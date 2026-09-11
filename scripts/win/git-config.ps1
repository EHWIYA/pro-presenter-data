# Windows Git 경로 필터와 hook 경로를 등록한다.
function Set-PathGitConfig {
    param([string]$Python)
    $fso = New-Object -ComObject Scripting.FileSystemObject
    $shortPython = $fso.GetFile($Python).ShortPath.Replace("\", "/")
    $filter = "$shortPython scripts/path.py"
    git config --replace-all filter.pp-paths.clean "$filter clean"
    git config --replace-all filter.pp-paths.smudge "$filter smudge"
    git config filter.pp-paths.required true
    git config core.hooksPath scripts/hooks
    git config core.quotepath false
    git config i18n.commitEncoding utf-8
    git config i18n.logOutputEncoding utf-8
    Write-Host "Python: $Python"
    git config --get filter.pp-paths.clean
    git config --get filter.pp-paths.smudge
    git config --get core.hooksPath
}
