# Windows 로그인 및 ProPresenter 종료 자동 동기화 작업을 등록한다.
$ErrorActionPreference = "Stop"

$CurrentIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$IsAdministrator = ([System.Security.Principal.WindowsPrincipal]::new($CurrentIdentity)).IsInRole(
    [System.Security.Principal.WindowsBuiltInRole]::Administrator
)

if (-not $IsAdministrator) {
    $Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Start-Process -FilePath "powershell.exe" -Verb RunAs -ArgumentList $Arguments
    Write-Host "Windows 권한 확인 창에서 '예'를 누르세요."
    exit 0
}

$RepoRoot = Split-Path -Parent $PSScriptRoot
$SyncScript = Join-Path $PSScriptRoot "windows-auto-sync.ps1"
$WatcherScript = Join-Path $PSScriptRoot "windows-propresenter-watcher.vbs"
$UserId = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$Principal = New-ScheduledTaskPrincipal -UserId $UserId -LogonType Interactive -RunLevel Limited
$Trigger = New-ScheduledTaskTrigger -AtLogOn -User $UserId
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

foreach ($Path in @($SyncScript, $WatcherScript)) {
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "필요한 스크립트를 찾을 수 없습니다. $Path"
    }
}

$StartupArgs = "-NoProfile -ExecutionPolicy Bypass -File `"$SyncScript`" -Mode Startup -WaitForKey"
$WatcherArgs = "`"$WatcherScript`""

Register-ScheduledTask -TaskName "PP-StartupSync" `
    -Action (New-ScheduledTaskAction -Execute "powershell.exe" -Argument $StartupArgs -WorkingDirectory $RepoRoot) `
    -Trigger $Trigger -Principal $Principal -Settings $Settings `
    -Description "로그인 시 Git과 Nextcloud를 동기화하고 결과 창을 유지" -Force | Out-Null

# 종료 감시기와 동기화 창을 서로 다른 예약 작업으로 실행한다. 동기화 결과
# 창을 닫아도 watcher가 콘솔 종료 신호를 받지 않아 다음 종료를 계속 감시한다.
Register-ScheduledTask -TaskName "PP-SessionSync" `
    -Action (New-ScheduledTaskAction -Execute "powershell.exe" -Argument $StartupArgs.Replace("-Mode Startup", "-Mode Session") -WorkingDirectory $RepoRoot) `
    -Principal $Principal -Settings $Settings `
    -Description "ProPresenter 종료 후 Git과 Nextcloud 동기화를 별도 창에서 실행" -Force | Out-Null

Register-ScheduledTask -TaskName "PP-SessionWatcher" `
    -Action (New-ScheduledTaskAction -Execute "wscript.exe" -Argument $WatcherArgs -WorkingDirectory $RepoRoot) `
    -Trigger $Trigger -Principal $Principal -Settings $Settings `
    -Description "ProPresenter 종료 시 자동 커밋, push, Nextcloud 동기화 실행" -Force | Out-Null

if (Get-ScheduledTask -TaskName "PP-NextcloudSync" -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName "PP-NextcloudSync" -Confirm:$false
}

Start-ScheduledTask -TaskName "PP-SessionWatcher"

Write-Host "설정 완료"
Write-Host "- PP-StartupSync      로그인 시 보이는 동기화 창"
Write-Host "- PP-SessionWatcher   ProPresenter 종료 감시"
Write-Host "- PP-SessionSync      종료 후 별도 동기화 창"
