# Windows 자동 동기화의 전체 실행 순서만 조정한다.
param([ValidateSet("Startup", "Session")][string]$Mode = "Session", [switch]$WaitForKey)
$ErrorActionPreference = "Stop"
$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::new()
foreach ($part in @("state", "console", "ui", "run", "cloud", "git", "finish")) {
    . (Join-Path $PSScriptRoot "$part.ps1")
}
Initialize-SyncState -RunMode $Mode -PauseOnFinish:$WaitForKey
try {
    try { Disable-ConsoleQuickEdit } catch {}
    Write-SyncBanner
    $script:HasMutex = $Mutex.WaitOne([TimeSpan]::FromMinutes(30))
    if (-not $HasMutex) { throw "다른 동기화 작업이 30분 넘게 진행 중입니다." }
    if (Get-Process -Name "ProPresenter" -ErrorAction SilentlyContinue) {
        throw "ProPresenter가 실행 중입니다. 완전히 종료하세요."
    }
    Set-Location $RepoRoot
    if ($Mode -eq "Startup") {
        Invoke-Checked "자동 동기화 작업 복구" {
            & (Join-Path $RepoRoot "scripts\win\tasks.ps1") -StartWatcher
        }
    }
    Initialize-GitAssets
    try {
        Invoke-GitRemote
        $script:GitResult = "정상 완료"
    } catch { $script:GitResult = "실패"; Add-SyncError $_.Exception.Message }
    try {
        Invoke-MediaSync
        $script:NextcloudResult = "정상 완료"
    } catch { $script:NextcloudResult = "실패"; Add-SyncError $_.Exception.Message }
} catch {
    Add-SyncError $_.Exception.Message
} finally {
    Complete-Sync
}
if (-not $Success) { exit 1 }
