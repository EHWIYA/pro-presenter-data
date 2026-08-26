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

& (Join-Path $PSScriptRoot "repair-auto-sync-tasks.ps1") -StartWatcher

if (Get-ScheduledTask -TaskName "PP-NextcloudSync" -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName "PP-NextcloudSync" -Confirm:$false
}

Write-Host "설정 완료"
Write-Host "- PP-StartupSync      로그인 시 보이는 동기화 창"
Write-Host "- PP-SessionWatcher   ProPresenter 종료 감시"
Write-Host "- PP-SessionSync      종료 후 별도 동기화 창"
