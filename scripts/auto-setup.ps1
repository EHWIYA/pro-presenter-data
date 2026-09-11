# Windows 자동 동기화 예약 작업을 현재 사용자 권한으로 등록한다.
$ErrorActionPreference = "Stop"
& (Join-Path $PSScriptRoot "win\tasks.ps1") -StartWatcher
if (Get-ScheduledTask -TaskName "PP-NextcloudSync" -ErrorAction SilentlyContinue) {
    try { Unregister-ScheduledTask -TaskName "PP-NextcloudSync" -Confirm:$false }
    catch { Write-Warning "이전 예약 작업은 관리자 권한으로 삭제하세요." }
}
Write-Host "설정 완료"
Write-Host "- PP-StartupSync"
Write-Host "- PP-SessionWatcher"
Write-Host "- PP-SessionSync"
