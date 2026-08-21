@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "REMOTE_NAME=pp-media"
set "LOCAL_PATH=%USERPROFILE%\Documents\pro-presenter\Media\Assets"
set "STATE_DIR=%USERPROFILE%\Documents\pro-presenter\.nextcloud-sync"

set "MARKER=%STATE_DIR%\resync-done"
set "LOG=%STATE_DIR%\sync.log"

if not defined PP_SYNC_MAX_ATTEMPTS set "PP_SYNC_MAX_ATTEMPTS=12"
if not defined PP_SYNC_RETRY_DELAY set "PP_SYNC_RETRY_DELAY=20"

if not exist "%STATE_DIR%" mkdir "%STATE_DIR%"
if not exist "%LOCAL_PATH%" mkdir "%LOCAL_PATH%"

:sync_retry
set /a SYNC_ATTEMPT+=1
set "RESYNC_FLAG="
if not exist "%MARKER%" set "RESYNC_FLAG=--resync"

rclone bisync "%REMOTE_NAME%:" "%LOCAL_PATH%" %RESYNC_FLAG% --create-empty-src-dirs -v --log-file "%LOG%"
set "SYNC_EXIT=!ERRORLEVEL!"

if !SYNC_EXIT! EQU 0 (
    echo done > "%MARKER%"
    endlocal & exit /b 0
)

if exist "%MARKER%" del /q "%MARKER%"

if !SYNC_ATTEMPT! GEQ %PP_SYNC_MAX_ATTEMPTS% (
    echo [nextcloud-sync] rclone bisync failed after !SYNC_ATTEMPT! attempts, exit code !SYNC_EXIT! - see %LOG%
    endlocal & exit /b %SYNC_EXIT%
)

echo [nextcloud-sync] attempt !SYNC_ATTEMPT! failed, exit code !SYNC_EXIT!. Retrying in %PP_SYNC_RETRY_DELAY% seconds...
powershell.exe -NoProfile -Command "Start-Sleep -Seconds %PP_SYNC_RETRY_DELAY%"
goto sync_retry
