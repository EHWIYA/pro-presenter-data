# 기존 Windows Git 설정 명령을 새 진입점으로 연결한다.
& (Join-Path $PSScriptRoot "git-setup.ps1")
exit $LASTEXITCODE
