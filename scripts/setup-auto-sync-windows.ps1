# 기존 Windows 자동화 설정 명령을 새 진입점으로 연결한다.
& (Join-Path $PSScriptRoot "auto-setup.ps1")
exit $LASTEXITCODE
