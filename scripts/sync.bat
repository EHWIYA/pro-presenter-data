@echo off
rem Run the Windows Nextcloud sync implementation.
call "%~dp0win\sync.bat" %*
exit /b %ERRORLEVEL%
