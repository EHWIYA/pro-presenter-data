# ProPresenter 자동 동기화 예약 작업을 최신 정의로 복구한다.
param(
    [switch]$StartWatcher
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
. (Join-Path $PSScriptRoot "task-definitions.ps1")
$SyncScript = Join-Path $RepoRoot "scripts\windows-auto-sync.ps1"
$WatcherScript = Join-Path $RepoRoot "scripts\windows-propresenter-watcher.vbs"
$UserId = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
# Git, rclone과 감시기는 관리자 권한이 필요 없으므로 사용자가 직접 복구한다.
$Principal = New-ScheduledTaskPrincipal -UserId $UserId -LogonType Interactive -RunLevel Limited
$Trigger = New-ScheduledTaskTrigger -AtLogOn -User $UserId
$DefaultSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
$WatcherSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
    -StartWhenAvailable -RestartCount 999 -RestartInterval (New-TimeSpan -Minutes 1) `
    -ExecutionTimeLimit ([TimeSpan]::Zero) -MultipleInstances IgnoreNew

foreach ($Path in @($SyncScript, $WatcherScript)) {
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "필요한 스크립트를 찾을 수 없습니다. $Path"
    }
}

$StartupArgs = "-NoProfile -ExecutionPolicy Bypass -File `"$SyncScript`" -Mode Startup"
$SessionArgs = "-NoProfile -ExecutionPolicy Bypass -File `"$SyncScript`" -Mode Session"

$StartupAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $StartupArgs -WorkingDirectory $RepoRoot
$SessionAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $SessionArgs -WorkingDirectory $RepoRoot
$WatcherAction = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "`"$WatcherScript`"" -WorkingDirectory $RepoRoot

Register-ScheduledTaskIfNeeded "PP-StartupSync" $StartupAction $Principal $DefaultSettings `
    "로그인 시 Git과 Nextcloud를 동기화하고 예약 작업을 복구" $Trigger
Register-ScheduledTaskIfNeeded "PP-SessionSync" $SessionAction $Principal $DefaultSettings `
    "ProPresenter 종료 후 Git과 Nextcloud 동기화를 별도 창에서 실행"
Register-ScheduledTaskIfNeeded "PP-SessionWatcher" $WatcherAction $Principal $WatcherSettings `
    "ProPresenter 종료 시 자동 커밋, push, Nextcloud 동기화 실행" $Trigger

$RetiredName = "ProPresenter-VenueAgent-Watcher"
if (Get-ScheduledTask -TaskName $RetiredName -ErrorAction SilentlyContinue) {
    try { Unregister-ScheduledTask -TaskName $RetiredName -Confirm:$false }
    catch { Write-Warning "폐기된 예약 작업을 삭제하지 못했습니다. $($_.Exception.Message)" }
}

if ($StartWatcher) {
    Start-ScheduledTask -TaskName "PP-SessionWatcher"
}
