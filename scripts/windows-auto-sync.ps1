# Windows에서 ProPresenter 자산과 Nextcloud 미디어를 안전하게 자동 동기화한다.
param(
    [ValidateSet("Startup", "Session")]
    [string]$Mode = "Session",
    [switch]$WaitForKey
)

$ErrorActionPreference = "Stop"
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

New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
Start-Transcript -Path (Join-Path $LogDir "$LogStamp-$($Mode.ToLower()).log") | Out-Null

function Invoke-Checked {
    param([string]$Name, [scriptblock]$Command)

    Write-Host ""
    Write-Host "[$Name]" -ForegroundColor Cyan
    & $Command
    if ($LASTEXITCODE -ne 0) {
        throw "$Name failed with exit code $LASTEXITCODE"
    }
}

try {
    Write-Host "ProPresenter 자동 동기화 - $ModeLabel" -ForegroundColor Green
    Write-Host "시작 시각 $Timestamp"

    $HasMutex = $Mutex.WaitOne([TimeSpan]::FromMinutes(30))
    if (-not $HasMutex) {
        throw "다른 동기화 작업이 30분 넘게 진행 중입니다."
    }

    if (Get-Process -Name "ProPresenter" -ErrorAction SilentlyContinue) {
        throw "ProPresenter가 실행 중입니다. 완전히 종료한 뒤 다시 실행하세요."
    }

    Set-Location $RepoRoot

    Invoke-Checked "경로 필터 확인" {
        git config --get filter.pp-paths.clean | Out-Null
    }

    Invoke-Checked "변경 자산 준비" {
        git add -- Libraries Playlists Presets Themes Fonts
    }

    git diff --cached --quiet
    if ($LASTEXITCODE -eq 1) {
        $CommitMessage = "예배 세션 자동 동기화 $Timestamp"
        Invoke-Checked "자동 커밋" {
            git commit -m $CommitMessage
        }
    } elseif ($LASTEXITCODE -eq 0) {
        Write-Host "커밋할 ProPresenter 변경 사항이 없습니다."
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
    } catch {
        $Success = $false
        $Errors.Add($_.Exception.Message)
        Write-Host $_.Exception.Message -ForegroundColor Red
    }

    try {
        Invoke-Checked "Nextcloud 미디어 동기화" {
            & (Join-Path $PSScriptRoot "nextcloud-sync.bat")
        }
    } catch {
        $Success = $false
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
    if ($Success) {
        Write-Host "모든 동기화가 완료되었습니다." -ForegroundColor Green
    } else {
        Write-Host "일부 작업이 실패했습니다. 이 창의 내용을 확인하세요." -ForegroundColor Red
        $Errors | ForEach-Object { Write-Host "- $_" -ForegroundColor Red }
    }

    Stop-Transcript | Out-Null
    if ($WaitForKey) {
        Read-Host "Enter를 누르면 창이 닫힙니다"
    }
}

if (-not $Success) {
    exit 1
}
