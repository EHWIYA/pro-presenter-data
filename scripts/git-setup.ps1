# Windows PC에 Git 경로 필터와 hook을 한 번 설정한다.
$ErrorActionPreference = "Stop"
$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::new()
$root = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $root
. (Join-Path $PSScriptRoot "win\python.ps1")
. (Join-Path $PSScriptRoot "win\git-config.ps1")
$python = Find-Python
Set-PathGitConfig -Python $python
& $python scripts/path.py status
Write-Host "OK - checkout은 portable, PP 실행 전에는 smudge-files를 사용합니다."
