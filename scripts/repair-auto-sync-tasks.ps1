# ProPresenter 자동 동기화 예약 작업을 최신 정의로 복구한다.
param(
    [switch]$StartWatcher
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$SyncScript = Join-Path $PSScriptRoot "windows-auto-sync.ps1"
$WatcherScript = Join-Path $PSScriptRoot "windows-propresenter-watcher.vbs"
$UserId = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
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

$StartupArgs = "-NoProfile -ExecutionPolicy Bypass -File `"$SyncScript`" -Mode Startup -WaitForKey"
$SessionArgs = "-NoProfile -ExecutionPolicy Bypass -File `"$SyncScript`" -Mode Session -WaitForKey"

Register-ScheduledTask -TaskName "PP-StartupSync" `
    -Action (New-ScheduledTaskAction -Execute "powershell.exe" -Argument $StartupArgs -WorkingDirectory $RepoRoot) `
    -Trigger $Trigger -Principal $Principal -Settings $DefaultSettings `
    -Description "로그인 시 Git과 Nextcloud를 동기화하고 예약 작업을 복구" -Force | Out-Null

Register-ScheduledTask -TaskName "PP-SessionSync" `
    -Action (New-ScheduledTaskAction -Execute "powershell.exe" -Argument $SessionArgs -WorkingDirectory $RepoRoot) `
    -Principal $Principal -Settings $DefaultSettings `
    -Description "ProPresenter 종료 후 Git과 Nextcloud 동기화를 별도 창에서 실행" -Force | Out-Null

Register-ScheduledTask -TaskName "PP-SessionWatcher" `
    -Action (New-ScheduledTaskAction -Execute "wscript.exe" -Argument "`"$WatcherScript`"" -WorkingDirectory $RepoRoot) `
    -Trigger $Trigger -Principal $Principal -Settings $WatcherSettings `
    -Description "ProPresenter 종료 시 자동 커밋, push, Nextcloud 동기화 실행" -Force | Out-Null

if ($StartWatcher) {
    Start-ScheduledTask -TaskName "PP-SessionWatcher"
}
