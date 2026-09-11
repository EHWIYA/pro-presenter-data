@echo off
rem Keep the previous Windows sync command compatible.
call "%~dp0sync.bat" %*
exit /b %ERRORLEVEL%
