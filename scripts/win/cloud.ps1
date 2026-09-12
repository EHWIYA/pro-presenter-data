# Nextcloud 연결을 기다리고 미디어 양방향 동기화를 실행한다.
function Test-PermanentNextcloudError {
    param($Check)
    $message = [string]::Join("`n", @($Check.Output))
    return $message -match "401|403|Unauthorized|Forbidden"
}

function Wait-NextcloudReady {
    param([int]$MaxAttempts = 60, [int]$RetryDelaySeconds = 5)
    Write-Host "      [확인] Nextcloud 연결 준비 상태를 확인합니다." -ForegroundColor Cyan
    for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
        $check = Invoke-RcloneQuiet -Arguments @("lsd", "pp-media:")
        if ($check.ExitCode -eq 0) {
            Write-Host "      [준비 완료] Nextcloud에 연결되었습니다." -ForegroundColor Green
            return
        }
        if (Test-PermanentNextcloudError $check) {
            throw "Nextcloud 서버가 접근을 거부했습니다(401/403). 서버 프록시와 WebDAV 권한을 확인하세요."
        }
        if ($attempt -eq $MaxAttempts) {
            throw "Nextcloud 연결 준비 시간이 초과되었습니다."
        }
        Write-Host "      [대기] ${RetryDelaySeconds}초 후 재시도합니다. ($attempt/$MaxAttempts)" `
            -ForegroundColor Yellow
        Start-Sleep -Seconds $RetryDelaySeconds
    }
}

function Invoke-MediaSync {
    Invoke-Checked "Nextcloud 미디어 동기화" {
        Wait-NextcloudReady
        & (Join-Path $RepoRoot "scripts\sync.bat")
    }
}
