# Windows 자동 동기화의 시작 안내와 최종 결과를 표시한다.
function Write-SyncBanner {
    $Host.UI.RawUI.WindowTitle = "ProPresenter 자동 동기화 - $ModeLabel"
    Write-Host "`n============================================================" -ForegroundColor DarkCyan
    Write-Host "              ProPresenter 자동 동기화" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor DarkCyan
    Write-Host "  실행 이유  $ModeLabel"
    Write-Host "  시작 시각  $Timestamp"
    Write-Host "  저장 위치  $RepoRoot"
    Write-Host "  GitHub 확인 후 Nextcloud 미디어를 양방향 동기화합니다."
    Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray
}

function Write-SyncResult {
    Write-Host "`n============================================================" -ForegroundColor DarkCyan
    Write-Host "                      실행 결과" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor DarkCyan
    Write-Host "  GitHub       $GitResult"
    Write-Host "  Nextcloud    $NextcloudResult"
    Write-Host "  완료 시각    $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Write-Host "  상세 로그    $LogPath"
    if ($Success) {
        Write-Host "  모든 동기화가 안전하게 완료되었습니다." -ForegroundColor Green
    } else {
        Write-Host "  일부 작업이 실패했습니다." -ForegroundColor Red
        $Errors | ForEach-Object { Write-Host "- $_" -ForegroundColor Red }
    }
    Write-Host "============================================================" -ForegroundColor DarkCyan
}
