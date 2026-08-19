# Windows: PC 로그온 시 nextcloud-sync.bat 1회 자동 실행되도록 작업 스케줄러에 등록 (최초 1회만 실행)
$ErrorActionPreference = "Stop"

$TaskName = "PP-NextcloudSync"
$BatPath = Join-Path $env:USERPROFILE "Documents\pro-presenter\scripts\nextcloud-sync.bat"

if (-not (Test-Path $BatPath)) {
    throw "nextcloud-sync.bat 을 찾을 수 없습니다: $BatPath"
}

$Action = New-ScheduledTaskAction -Execute $BatPath
$Trigger = New-ScheduledTaskTrigger -AtLogOn
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Settings $Settings `
    -Description "ProPresenter Media/Assets Nextcloud 동기화 (로그온 시 1회)" -Force

Write-Host "등록 완료: 작업 스케줄러 '$TaskName' (로그온 시 1회 실행)"
