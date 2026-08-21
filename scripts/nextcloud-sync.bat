@echo off
setlocal

set "REMOTE_NAME=pp-media"
set "LOCAL_PATH=%USERPROFILE%\Documents\pro-presenter\Media\Assets"
set "STATE_DIR=%USERPROFILE%\Documents\pro-presenter\.nextcloud-sync"

set "MARKER=%STATE_DIR%\resync-done"
set "LOG=%STATE_DIR%\sync.log"

if not exist "%STATE_DIR%" mkdir "%STATE_DIR%"
if not exist "%LOCAL_PATH%" mkdir "%LOCAL_PATH%"

set "RESYNC_FLAG="
if not exist "%MARKER%" set "RESYNC_FLAG=--resync"

rclone bisync "%REMOTE_NAME%:" "%LOCAL_PATH%" %RESYNC_FLAG% --create-empty-src-dirs -v --log-file "%LOG%"
set "SYNC_EXIT=%ERRORLEVEL%"

if %SYNC_EXIT% EQU 0 (
    echo done > "%MARKER%"
) else (
    if exist "%MARKER%" del /q "%MARKER%"
    echo [nextcloud-sync] rclone bisync failed, exit code %SYNC_EXIT% - see %LOG%
)

endlocal & exit /b %SYNC_EXIT%
