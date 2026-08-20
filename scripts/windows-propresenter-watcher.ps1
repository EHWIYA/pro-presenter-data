# Windows에서 ProPresenter 본체 종료를 감지해 자동 동기화 창을 연다.
$ErrorActionPreference = "Stop"
$SyncScript = Join-Path $PSScriptRoot "windows-auto-sync.ps1"
$CreatedNew = $false
$Mutex = [System.Threading.Mutex]::new($true, "Local\ProPresenterWatcher", [ref]$CreatedNew)

if (-not $CreatedNew) {
    $Mutex.Dispose()
    exit 0
}

try {
    $WasRunning = $null -ne (Get-Process -Name "ProPresenter" -ErrorAction SilentlyContinue)

    while ($true) {
        Start-Sleep -Seconds 2
        $IsRunning = $null -ne (Get-Process -Name "ProPresenter" -ErrorAction SilentlyContinue)

        if ($WasRunning -and -not $IsRunning) {
            Start-Sleep -Seconds 5
            $Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$SyncScript`" -Mode Session -WaitForKey"
            Start-Process -FilePath "powershell.exe" -ArgumentList $Arguments
        }

        $WasRunning = $IsRunning
    }
} finally {
    $Mutex.ReleaseMutex()
    $Mutex.Dispose()
}
