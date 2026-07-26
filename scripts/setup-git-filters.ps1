# One-time per PC (clone 또는 agent 제거 후).
# Registers Git clean/smudge filter + hooks so pull/push keep playlist paths valid.
#
#   powershell -File scripts/setup-git-filters.ps1

$ErrorActionPreference = "Stop"
$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $Root

$PyExe = $null
$PyPrefix = @()
if (Get-Command python -ErrorAction SilentlyContinue) {
    $PyExe = "python"
} elseif (Get-Command python3 -ErrorAction SilentlyContinue) {
    $PyExe = "python3"
} elseif (Get-Command py -ErrorAction SilentlyContinue) {
    $PyExe = "py"
    $PyPrefix = @("-3")
} else {
    throw "Python not found. Install Python 3 and re-run."
}

$FilterCmd = if ($PyPrefix.Count) {
    "py -3 scripts/pp_path_normalize.py"
} else {
    "$PyExe scripts/pp_path_normalize.py"
}

Write-Host "Python: $PyExe $($PyPrefix -join ' ')"
Write-Host "Repo:   $Root"

git config filter.pp-paths.clean "$FilterCmd clean"
git config filter.pp-paths.smudge "$FilterCmd smudge"
git config filter.pp-paths.required true
git config core.hooksPath scripts/githooks

Write-Host "Configured:"
git config --get filter.pp-paths.clean
git config --get filter.pp-paths.smudge
git config --get core.hooksPath

& $PyExe @PyPrefix scripts/pp_path_normalize.py smudge-files
& $PyExe @PyPrefix scripts/pp_path_normalize.py status

Write-Host ""
Write-Host "OK — pull/push only; path rewrite is automatic."
Write-Host "  pull/checkout → smudge (이 PC 경로)"
Write-Host "  add/commit    → clean (Git portable)"
