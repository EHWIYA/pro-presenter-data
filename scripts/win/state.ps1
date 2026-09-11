# Windows 자동 동기화 실행 상태와 로그를 초기화한다.
function Initialize-SyncState {
    param([string]$RunMode, [switch]$PauseOnFinish)
    $script:RepoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    $script:StateDir = Join-Path $RepoRoot ".nextcloud-sync"
    $script:LogDir = Join-Path $StateDir "auto-sync-logs"
    $script:Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
    $script:Mode = $RunMode
    $script:WaitForKey = $PauseOnFinish
    $script:ModeLabel = if ($Mode -eq "Startup") { "PC 로그인" } else { "ProPresenter 종료" }
    $script:Success = $true
    $script:Errors = [Collections.Generic.List[string]]::new()
    $script:Warnings = [Collections.Generic.List[string]]::new()
    $script:Mutex = [Threading.Mutex]::new($false, "Local\ProPresenterAutoSync")
    $script:HasMutex = $false
    $script:StepNumber = 0
    $script:StepTotal = if ($Mode -eq "Startup") { 7 } else { 6 }
    $script:GitResult = "확인 전"
    $script:NextcloudResult = "확인 전"
    New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $script:LogPath = Join-Path $LogDir "$stamp-$($Mode.ToLower()).log"
    Start-Transcript -Path $LogPath | Out-Null
}

function Add-SyncError {
    param([string]$Message)
    $script:Success = $false
    $script:Errors.Add($Message)
    Write-Host $Message -ForegroundColor Red
}

function Add-SyncWarning {
    param([string]$Message)
    $script:Warnings.Add($Message)
    Write-Warning $Message
}
