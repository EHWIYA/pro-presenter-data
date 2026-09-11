# 기존 PowerShell 감시기 명령을 새 구현으로 연결한다.
& (Join-Path $PSScriptRoot "win\watch.ps1")
exit $LASTEXITCODE
