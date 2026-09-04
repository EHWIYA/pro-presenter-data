# Windows에서 ProPresenter 자산과 Nextcloud 미디어를 안전하게 자동 동기화한다.
param(
    [ValidateSet("Startup", "Session")]
    [string]$Mode = "Session",
    [switch]$WaitForKey
)

$ErrorActionPreference = "Stop"
$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::new()
$RepoRoot = Split-Path -Parent $PSScriptRoot
$StateDir = Join-Path $RepoRoot ".nextcloud-sync"
$LogDir = Join-Path $StateDir "auto-sync-logs"
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
$LogStamp = Get-Date -Format "yyyyMMdd-HHmmss"
$ModeLabel = if ($Mode -eq "Startup") { "PC 로그인" } else { "ProPresenter 종료" }
$Success = $true
$Errors = New-Object System.Collections.Generic.List[string]
$Mutex = [System.Threading.Mutex]::new($false, "Local\ProPresenterAutoSync")
$HasMutex = $false
$StepNumber = 0
$StepTotal = if ($Mode -eq "Startup") { 7 } else { 6 }
$GitResult = "확인 전"
$NextcloudResult = "확인 전"
$LogPath = Join-Path $LogDir "$LogStamp-$($Mode.ToLower()).log"

New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
Start-Transcript -Path $LogPath | Out-Null

$Host.UI.RawUI.WindowTitle = "ProPresenter 자동 동기화 - $ModeLabel"

function Disable-ConsoleQuickEdit {
    # 콘솔에서 마우스로 글자를 선택해도 실행이 정지되지 않게 한다.
    if (-not ("ConsoleMode.NativeMethods" -as [type])) {
        Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
namespace ConsoleMode {
    public static class NativeMethods {
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern IntPtr GetStdHandle(int nStdHandle);
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool GetConsoleMode(IntPtr hConsoleHandle, out uint lpMode);
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool SetConsoleMode(IntPtr hConsoleHandle, uint dwMode);
    }
}
"@
    }

    $Handle = [ConsoleMode.NativeMethods]::GetStdHandle(-10)
    [uint32]$ConsoleMode = 0
    if ([ConsoleMode.NativeMethods]::GetConsoleMode($Handle, [ref]$ConsoleMode)) {
        $EnableExtendedFlags = [uint32]0x0080
        $EnableQuickEditMode = [uint32]0x0040
        $NewMode = ($ConsoleMode -bor $EnableExtendedFlags) -band (-bnot $EnableQuickEditMode)
        [ConsoleMode.NativeMethods]::SetConsoleMode($Handle, $NewMode) | Out-Null
    }
}

try {
    Disable-ConsoleQuickEdit
} catch {
    # 콘솔이 없는 수동 실행 환경에서도 동기화는 계속한다.
}

function Write-Banner {
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor DarkCyan
    Write-Host "              ProPresenter 자동 동기화" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor DarkCyan
    Write-Host "  실행 이유  $ModeLabel"
    Write-Host "  시작 시각  $Timestamp"
    Write-Host "  저장 위치  $RepoRoot"
    Write-Host "  진행 안내  GitHub 자산 확인 후 Nextcloud 미디어를 양방향 동기화합니다."
    Write-Host "             창을 닫거나 PC를 끄지 말고 완료 메시지를 확인하세요."
    Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray
}

function Invoke-Checked {
    param([string]$Name, [scriptblock]$Command)

    $script:StepNumber++
    Write-Host ""
    Write-Host "[$StepNumber/$StepTotal] $Name" -ForegroundColor Yellow
    $global:LASTEXITCODE = 0
    & $Command
    if ($LASTEXITCODE -ne 0) {
        throw "$Name failed with exit code $LASTEXITCODE"
    }
    Write-Host "      [완료] $Name" -ForegroundColor Green
}

function Invoke-RcloneQuiet {
    param([string[]]$Arguments)

    $PreviousErrorActionPreference = $ErrorActionPreference
    try {
        # Windows PowerShell 5 turns native stderr into a terminating error when
        # ErrorActionPreference is Stop. Capture it and judge only the exit code.
        $ErrorActionPreference = "Continue"
        $CommandOutput = & rclone @Arguments 2>$null
        $CommandExitCode = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $PreviousErrorActionPreference
    }

    [pscustomobject]@{
        ExitCode = $CommandExitCode
        Output = $CommandOutput
    }
}

function Wait-NextcloudReady {
    param(
        [int]$MaxAttempts = 60,
        [int]$RetryDelaySeconds = 5
    )

    Write-Host "      [확인] Nextcloud 연결 준비 상태를 확인합니다." -ForegroundColor Cyan
    Write-Host "      네트워크 준비가 늦으면 5초 간격으로 최대 60회(약 5분) 기다립니다." -ForegroundColor DarkGray

    for ($Attempt = 1; $Attempt -le $MaxAttempts; $Attempt++) {
        $ConnectionCheck = Invoke-RcloneQuiet -Arguments @("lsd", "pp-media:")
        if ($ConnectionCheck.ExitCode -eq 0) {
            Write-Host "      [준비 완료] Nextcloud에 연결되었습니다." -ForegroundColor Green
            Write-Host "      이어서 파일별 전송량·속도·남은 시간이 실시간으로 표시됩니다." -ForegroundColor DarkGray
            return
        }

        if ($Attempt -eq $MaxAttempts) {
            throw "Nextcloud 연결 준비 시간이 초과되었습니다. 네트워크 상태를 확인하세요."
        }

        Write-Host "      [대기] 네트워크를 준비 중입니다. 오류가 아닙니다. ${RetryDelaySeconds}초 후 다시 확인합니다. ($Attempt/$MaxAttempts)" -ForegroundColor Yellow
        Start-Sleep -Seconds $RetryDelaySeconds
    }
}

try {
    Write-Banner

    $HasMutex = $Mutex.WaitOne([TimeSpan]::FromMinutes(30))
    if (-not $HasMutex) {
        throw "다른 동기화 작업이 30분 넘게 진행 중입니다."
    }

    if (Get-Process -Name "ProPresenter" -ErrorAction SilentlyContinue) {
        throw "ProPresenter가 실행 중입니다. 완전히 종료한 뒤 다시 실행하세요."
    }

    Set-Location $RepoRoot

    if ($Mode -eq "Startup") {
        Invoke-Checked "자동 동기화 작업 복구" {
            & (Join-Path $PSScriptRoot "repair-auto-sync-tasks.ps1") -StartWatcher
        }
    }

    Invoke-Checked "경로 필터 확인" {
        git config --get filter.pp-paths.clean | Out-Null
    }

    Invoke-Checked "변경 자산 준비" {
        git add -- Libraries Playlists Presets Themes Fonts
    }

    git diff --cached --quiet
    if ($LASTEXITCODE -eq 1) {
        $StepTotal++
        $CommitMessage = "예배 세션 자동 동기화 $Timestamp"
        Invoke-Checked "자동 커밋" {
            git commit -m $CommitMessage
        }
    } elseif ($LASTEXITCODE -eq 0) {
        Write-Host "      [건너뜀] 커밋할 ProPresenter 변경 사항이 없습니다." -ForegroundColor DarkGray
    } else {
        throw "Git 변경 사항 확인에 실패했습니다."
    }

    try {
        Invoke-Checked "GitHub 최신 내용 받기" {
            git pull --rebase
        }
        Invoke-Checked "이 PC용 경로 적용" {
            python scripts/pp_path_normalize.py smudge-files
        }
        Invoke-Checked "GitHub에 올리기" {
            git push
        }
        $GitResult = "정상 완료"
    } catch {
        $Success = $false
        $GitResult = "실패"
        $Errors.Add($_.Exception.Message)
        Write-Host $_.Exception.Message -ForegroundColor Red
    }

    try {
        Invoke-Checked "Nextcloud 미디어 동기화" {
            Wait-NextcloudReady
            & (Join-Path $PSScriptRoot "nextcloud-sync.bat")
        }
        $NextcloudResult = "정상 완료"
    } catch {
        $Success = $false
        $NextcloudResult = "실패"
        $Errors.Add($_.Exception.Message)
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
} catch {
    $Success = $false
    $Errors.Add($_.Exception.Message)
    Write-Host $_.Exception.Message -ForegroundColor Red
} finally {
    if ($HasMutex) {
        $Mutex.ReleaseMutex()
    }
    $Mutex.Dispose()

    Write-Host ""
    Write-Host "============================================================" -ForegroundColor DarkCyan
    Write-Host "                      실행 결과" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor DarkCyan
    Write-Host "  GitHub       $GitResult" -ForegroundColor $(if ($GitResult -eq "실패") { "Red" } else { "Green" })
    Write-Host "  Nextcloud    $NextcloudResult" -ForegroundColor $(if ($NextcloudResult -eq "실패") { "Red" } else { "Green" })
    Write-Host "  완료 시각    $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Write-Host "  상세 로그    $LogPath"
    Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray
    if ($Success) {
        Write-Host "  모든 동기화가 안전하게 완료되었습니다." -ForegroundColor Green
        Write-Host "  이제 ProPresenter를 실행하거나 PC를 종료해도 됩니다." -ForegroundColor Green
    } else {
        Write-Host "  일부 작업이 실패했습니다. 이 창을 닫지 마세요." -ForegroundColor Red
        $Errors | ForEach-Object { Write-Host "- $_" -ForegroundColor Red }
    }
    Write-Host "============================================================" -ForegroundColor DarkCyan

    Stop-Transcript | Out-Null
    if ($WaitForKey) {
        Write-Host ""
        if ($Success) {
            Write-Host "성공한 창은 10초 후 자동으로 닫힙니다." -ForegroundColor DarkGray
            Start-Sleep -Seconds 10
        } else {
            Read-Host "오류를 확인했으면 Enter를 눌러 창을 닫으세요"
        }
    }
}

if (-not $Success) {
    exit 1
}
