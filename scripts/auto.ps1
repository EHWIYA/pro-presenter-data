# Windows 세션 자동 동기화의 짧은 진입점을 제공한다.
param([ValidateSet("Startup", "Session")][string]$Mode = "Session", [switch]$WaitForKey)
& (Join-Path $PSScriptRoot "win\main.ps1") -Mode $Mode -WaitForKey:$WaitForKey
exit $LASTEXITCODE
