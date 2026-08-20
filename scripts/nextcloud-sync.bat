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

if %ERRORLEVEL% EQU 0 (
    echo done > "%MARKER%"
) else (
    echo [nextcloud-sync] rclone bisync failed, exit code %ERRORLEVEL% - see %LOG%
)

endlocal