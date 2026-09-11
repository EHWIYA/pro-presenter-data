# 기존 예약 작업 복구 명령을 새 구현으로 연결한다.
param([switch]$StartWatcher)
& (Join-Path $PSScriptRoot "win\tasks.ps1") -StartWatcher:$StartWatcher
exit $LASTEXITCODE
