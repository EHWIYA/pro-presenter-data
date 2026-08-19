@echo off
rem Media/Assets <-> Nextcloud(04_교회자료/PP_Media_Assets) 양방향 동기화 (Windows)
chcp 65001 >nul
setlocal

rem ── 설정값 (필요하면 여기만 수정) ──────────────────────────
set "REMOTE_NAME=pp-nextcloud"
set "REMOTE_PATH=04_교회자료/PP_Media_Assets"
set "LOCAL_PATH=%USERPROFILE%\Documents\pro-presenter\Media\Assets"
set "STATE_DIR=%USERPROFILE%\Documents\pro-presenter\.nextcloud-sync"
rem ──────────────────────────────────────────────────────────

set "MARKER=%STATE_DIR%\resync-done"
set "LOG=%STATE_DIR%\sync.log"

if not exist "%STATE_DIR%" mkdir "%STATE_DIR%"
if not exist "%LOCAL_PATH%" mkdir "%LOCAL_PATH%"

set "RESYNC_FLAG="
if not exist "%MARKER%" set "RESYNC_FLAG=--resync"

rclone bisync "%REMOTE_NAME%:%REMOTE_PATH%" "%LOCAL_PATH%" %RESYNC_FLAG% --create-empty-src-dirs -v --log-file "%LOG%"

if %ERRORLEVEL% EQU 0 (
    echo done > "%MARKER%"
) else (
    echo [nextcloud-sync] rclone bisync 실패, exit code %ERRORLEVEL% — 로그: %LOG%
)

endlocal
