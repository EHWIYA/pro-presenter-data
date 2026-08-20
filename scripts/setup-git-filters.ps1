# One-time per PC (clone 후).
# Registers Git clean filter + identity smudge + hooks.
# Working tree stays portable until you run smudge-files before opening PP.
#
#   powershell -File scripts/setup-git-filters.ps1

$ErrorActionPreference = "Stop"
$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::new()
$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $Root

$PyExe = $null
$PythonCandidates = @()

foreach ($Name in @("python", "python3")) {
    $Command = Get-Command $Name -ErrorAction SilentlyContinue
    if ($Command -and $Command.Source -notmatch "\\WindowsApps\\") {
        $PythonCandidates += $Command.Source
    }
}

foreach ($Base in @(
    (Join-Path $env:LOCALAPPDATA "Programs\Python"),
    $env:ProgramFiles
)) {
    if (Test-Path -LiteralPath $Base) {
        $PythonCandidates += Get-ChildItem -LiteralPath $Base -Filter python.exe `
            -Recurse -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -notmatch "\\WindowsApps\\" } |
            Select-Object -ExpandProperty FullName
    }
}

$PythonCandidates = $PythonCandidates | Sort-Object -Unique -Descending

foreach ($Candidate in $PythonCandidates) {
    try {
        & $Candidate -c "import sys; raise SystemExit(sys.version_info < (3, 8))"
        if ($LASTEXITCODE -eq 0) {
            $PyExe = $Candidate
            break
        }
    } catch {
        continue
    }
}

if (-not $PyExe) {
    throw "Python not found. Install Python 3 and re-run."
}

$Fso = New-Object -ComObject Scripting.FileSystemObject
$FilterPython = $Fso.GetFile($PyExe).ShortPath.Replace("\", "/")
$FilterCmd = "$FilterPython scripts/pp_path_normalize.py"

Write-Host "Python: $PyExe"
Write-Host "Repo:   $Root"

git config --replace-all filter.pp-paths.clean "$FilterCmd clean"
# Identity smudge: checkout/pull must not rewrite paths.
git config --replace-all filter.pp-paths.smudge "$FilterCmd smudge"
git config filter.pp-paths.required true
git config core.hooksPath scripts/githooks
git config core.quotepath false
git config i18n.commitEncoding utf-8
git config i18n.logOutputEncoding utf-8

Write-Host "Configured:"
git config --get filter.pp-paths.clean
git config --get filter.pp-paths.smudge
git config --get core.hooksPath

& $PyExe scripts/pp_path_normalize.py status

Write-Host ""
Write-Host "OK - checkout/pull leave portable paths (no Changes until PP)."
Write-Host "  add/commit         -> clean (Git portable)"
Write-Host "  before opening PP  -> $PyExe scripts/pp_path_normalize.py smudge-files"
