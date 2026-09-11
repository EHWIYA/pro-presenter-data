# Git 경로 필터에 사용할 Python 3 실행 파일을 찾는다.
function Find-Python {
    $candidates = @()
    foreach ($name in @("python", "python3")) {
        $command = Get-Command $name -ErrorAction SilentlyContinue
        if ($command -and $command.Source -notmatch '\\WindowsApps\\') {
            $candidates += $command.Source
        }
    }
    foreach ($base in @((Join-Path $env:LOCALAPPDATA "Programs\Python"), $env:ProgramFiles)) {
        if (Test-Path -LiteralPath $base) {
            $candidates += Get-ChildItem -LiteralPath $base -Filter python.exe `
                -Recurse -ErrorAction SilentlyContinue |
                Where-Object { $_.FullName -notmatch '\\WindowsApps\\' } |
                Select-Object -ExpandProperty FullName
        }
    }
    foreach ($candidate in ($candidates | Sort-Object -Unique -Descending)) {
        try {
            & $candidate -c "import sys; raise SystemExit(sys.version_info < (3, 10))"
            if ($LASTEXITCODE -eq 0) { return $candidate }
        } catch { continue }
    }
    throw "Python 3.10 or newer was not found."
}
