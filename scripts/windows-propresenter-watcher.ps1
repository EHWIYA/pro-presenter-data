# Windows에서 ProPresenter 본체 종료를 감지해 자동 동기화 창을 연다.
$ErrorActionPreference = "Stop"
$SyncScript = Join-Path $PSScriptRoot "windows-auto-sync.ps1"
$SyncTaskName = "PP-SessionSync"
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
            # 동기화 창을 watcher의 자식 프로세스로 열면, 사용자가 그 창을 닫을 때
            # 콘솔 종료 신호(0xC000013A)가 watcher에도 전달될 수 있다. 별도 예약
            # 작업으로 실행해 watcher 수명과 결과 창 수명을 완전히 분리한다.
            if (Get-ScheduledTask -TaskName $SyncTaskName -ErrorAction SilentlyContinue) {
                Start-ScheduledTask -TaskName $SyncTaskName
            } else {
                $Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$SyncScript`" -Mode Session -WaitForKey"
                Start-Process -FilePath "powershell.exe" -ArgumentList $Arguments
            }
        }

        $WasRunning = $IsRunning
    }
} finally {
    $Mutex.ReleaseMutex()
    $Mutex.Dispose()
}
