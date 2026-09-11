# Python, PowerShell, shell과 Git의 정적 검증 명령을 실행한다.
import pathlib
import shutil
import subprocess
import sys

from .policy import ROOT


def _run(command: list[str]) -> list[str]:
    result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True, check=False)
    if result.returncode == 0:
        return []
    detail = (result.stderr or result.stdout).strip().splitlines()
    return [f"command: {' '.join(command)}", *(detail[-3:] if detail else [])]


def _powershell() -> list[str]:
    powershell = shutil.which("powershell")
    if not powershell:
        return []
    code = (
        "$e=@(); Get-ChildItem scripts -Recurse -Filter *.ps1|%{"
        "$t=$null;$x=$null;[Management.Automation.Language.Parser]::ParseFile("
        "$_.FullName,[ref]$t,[ref]$x)|Out-Null;if($x){$e+=$x}};if($e){$e;exit 1}"
    )
    return _run([powershell, "-NoProfile", "-Command", code])


def _bash() -> list[str]:
    candidate = pathlib.Path("C:/Program Files/Git/bin/bash.exe")
    bash = str(candidate) if candidate.exists() else shutil.which("bash")
    if not bash:
        return []
    scripts = [str(path.relative_to(ROOT)) for path in (ROOT / "scripts").rglob("*.sh")]
    return _run([bash, "-n", *scripts])


def command_errors() -> list[str]:
    errors = _run([sys.executable, "-m", "unittest", "discover", "-s", "scripts/tests"])
    errors += _powershell()
    errors += _bash()
    errors += _run(["git", "diff", "--check"])
    errors += _run(["git", "diff", "--cached", "--check"])
    return errors
