# 한 번의 관리자 승인으로 Windows 드라이버와 시스템 무결성을 복구한다.
$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$StateDir = Join-Path $RepoRoot ".nextcloud-sync"
$ResultPath = Join-Path $StateDir "windows-repair-result.txt"
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$admin = ([Security.Principal.WindowsPrincipal]::new($identity)).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)
if (-not $admin) {
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Start-Process powershell.exe -Verb RunAs -WindowStyle Hidden -ArgumentList $arguments
    Write-Host "Windows 권한 확인 창에서 '예'를 누르세요."
    exit 0
}
New-Item -ItemType Directory -Force -Path $StateDir | Out-Null
Start-Transcript -Path (Join-Path $StateDir "windows-repair.log") -Append | Out-Null
try {
    $session = New-Object -ComObject Microsoft.Update.Session
    $found = $session.CreateUpdateSearcher().Search("IsInstalled=0 and IsHidden=0")
    $selected = New-Object -ComObject Microsoft.Update.UpdateColl
    for ($i = 0; $i -lt $found.Updates.Count; $i++) {
        $update = $found.Updates.Item($i)
        if ($update.Title -like "*Gaussian Mixture Model*1911*") {
            if (-not $update.EulaAccepted) { $update.AcceptEula() }
            [void]$selected.Add($update)
        }
    }
    if ($selected.Count -gt 1) { throw "예상보다 많은 Intel 1911 드라이버를 찾았습니다." }
    if ($selected.Count -eq 1) {
        $downloader = $session.CreateUpdateDownloader(); $downloader.Updates = $selected
        if ($downloader.Download().ResultCode -notin 2, 3) { throw "드라이버 다운로드 실패" }
        $installer = $session.CreateUpdateInstaller(); $installer.Updates = $selected
        if ($installer.Install().ResultCode -notin 2, 3) { throw "드라이버 설치 실패" }
    }
    & DISM.exe /Online /Cleanup-Image /RestoreHealth
    if ($LASTEXITCODE -ne 0) { throw "DISM 실패 $LASTEXITCODE" }
    & sfc.exe /scannow
    if ($LASTEXITCODE -ne 0) { throw "SFC 실패 $LASTEXITCODE" }
    & pnputil.exe /scan-devices
    if ($LASTEXITCODE -ne 0) { throw "장치 검색 실패 $LASTEXITCODE" }
    "SUCCESS $(Get-Date -Format s)" | Set-Content -LiteralPath $ResultPath -Encoding UTF8
} catch {
    "FAILED $(Get-Date -Format s) $($_.Exception.Message)" | Set-Content -LiteralPath $ResultPath -Encoding UTF8
    throw
} finally {
    Stop-Transcript | Out-Null
}
