# Windows 자동 동기화 자원을 해제하고 결과 창을 마무리한다.
function Complete-Sync {
    if ($HasMutex) {
        $Mutex.ReleaseMutex()
    }
    $Mutex.Dispose()
    Write-SyncResult
    Stop-Transcript | Out-Null
    if (-not $WaitForKey) {
        return
    }
    if ($Success) {
        Write-Host "성공한 창은 10초 후 자동으로 닫힙니다." -ForegroundColor DarkGray
        Start-Sleep -Seconds 10
    } else {
        Read-Host "오류를 확인했으면 Enter를 눌러 창을 닫으세요"
    }
}
