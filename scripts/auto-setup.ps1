# Windows 자동 동기화 예약 작업을 관리자 권한으로 등록한다.
$ErrorActionPreference = "Stop"
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$admin = ([Security.Principal.WindowsPrincipal]::new($identity)).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)
if (-not $admin) {
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Start-Process powershell.exe -Verb RunAs -ArgumentList $arguments
    Write-Host "Windows 권한 확인 창에서 '예'를 누르세요."
    exit 0
}
& (Join-Path $PSScriptRoot "win\tasks.ps1") -StartWatcher
if (Get-ScheduledTask -TaskName "PP-NextcloudSync" -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName "PP-NextcloudSync" -Confirm:$false
}
Write-Host "설정 완료"
Write-Host "- PP-StartupSync"
Write-Host "- PP-SessionWatcher"
Write-Host "- PP-SessionSync"
