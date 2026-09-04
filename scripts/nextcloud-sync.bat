@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "REMOTE_NAME=pp-media"
set "LOCAL_PATH=%USERPROFILE%\Documents\pro-presenter\Media\Assets"
set "STATE_DIR=%USERPROFILE%\Documents\pro-presenter\.nextcloud-sync"

set "MARKER=%STATE_DIR%\resync-done"
set "LOG=%STATE_DIR%\sync.log"

if not defined PP_SYNC_MAX_ATTEMPTS set "PP_SYNC_MAX_ATTEMPTS=60"
if not defined PP_SYNC_RETRY_DELAY set "PP_SYNC_RETRY_DELAY=5"

if not exist "%STATE_DIR%" mkdir "%STATE_DIR%"
if not exist "%LOCAL_PATH%" mkdir "%LOCAL_PATH%"

:sync_retry
set /a SYNC_ATTEMPT+=1
set "RESYNC_FLAG="
if not exist "%MARKER%" set "RESYNC_FLAG=--resync"

echo.
echo [Nextcloud] Sync attempt !SYNC_ATTEMPT! of %PP_SYNC_MAX_ATTEMPTS%
echo [Nextcloud] The progress below shows transferred size, speed, ETA, and file count.
echo [Nextcloud] Local : Media\Assets
echo [Nextcloud] Remote: %REMOTE_NAME%:
echo.

rclone bisync "%REMOTE_NAME%:" "%LOCAL_PATH%" %RESYNC_FLAG% --create-empty-src-dirs -v --log-file "%LOG%" --progress --stats 1s
set "SYNC_EXIT=!ERRORLEVEL!"

if !SYNC_EXIT! EQU 0 (
    echo done > "%MARKER%"
    echo.
    echo [Nextcloud] Sync completed successfully.
    endlocal & exit /b 0
)

if exist "%MARKER%" del /q "%MARKER%"

if !SYNC_ATTEMPT! GEQ %PP_SYNC_MAX_ATTEMPTS% (
    echo.
    echo [Nextcloud] Sync failed after !SYNC_ATTEMPT! attempts. Exit code: !SYNC_EXIT!
    echo [Nextcloud] Details: %LOG%
    endlocal & exit /b %SYNC_EXIT%
)

echo.
echo [Nextcloud] Attempt !SYNC_ATTEMPT! failed with exit code !SYNC_EXIT!.
echo [Nextcloud] Retrying in %PP_SYNC_RETRY_DELAY% seconds. You may leave this window open.
powershell.exe -NoProfile -Command "Start-Sleep -Seconds %PP_SYNC_RETRY_DELAY%"
goto sync_retry
