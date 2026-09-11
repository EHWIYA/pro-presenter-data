# 기존 Windows 자동 동기화 명령을 새 진입점으로 연결한다.
param([ValidateSet("Startup", "Session")][string]$Mode = "Session", [switch]$WaitForKey)
& (Join-Path $PSScriptRoot "auto.ps1") -Mode $Mode -WaitForKey:$WaitForKey
exit $LASTEXITCODE
