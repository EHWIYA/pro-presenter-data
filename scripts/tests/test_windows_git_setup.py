# Windows Git 경로 필터가 8.3 짧은 파일명 없이 설정되는지 검증한다.
import pathlib
import shutil
import subprocess
import sys
import tempfile
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[2]


@unittest.skipUnless(shutil.which("powershell"), "Windows PowerShell required")
class WindowsGitSetupTests(unittest.TestCase):
    def test_filter_setup_does_not_require_short_paths(self):
        with tempfile.TemporaryDirectory() as tmp:
            repo = pathlib.Path(tmp) / "other pc"
            subprocess.run(["git", "clone", "--shared", str(ROOT), str(repo)],
                           check=True, capture_output=True)
            helper = str(ROOT / "scripts/win/git-config.ps1").replace("'", "''")
            python = r"C:\Program Files\Python\python.exe"
            code = (f". '{helper}'; function New-Object {{ throw '8.3 unavailable' }}; "
                    f"Set-PathGitConfig -Python '{python}'")
            result = subprocess.run(["powershell", "-NoProfile", "-Command", code],
                                    cwd=repo, capture_output=True)
            self.assertEqual(0, result.returncode,
                             (result.stdout + result.stderr).decode(errors="replace"))
            configured = subprocess.check_output(
                ["git", "config", "--get", "filter.pp-paths.clean"],
                cwd=repo, text=True).strip()
            self.assertEqual('"C:/Program Files/Python/python.exe" scripts/path.py clean',
                             configured)
            actual = code.replace(python, sys.executable.replace("'", "''"))
            subprocess.run(["powershell", "-NoProfile", "-Command", actual],
                           cwd=repo, check=True, capture_output=True)
            filtered = subprocess.check_output(
                ["git", "hash-object", "--path=Playlists/Library", "Playlists/Library"], cwd=repo)
            stored = subprocess.check_output(
                ["git", "rev-parse", "HEAD:Playlists/Library"], cwd=repo)
            self.assertEqual(stored, filtered)


if __name__ == "__main__":
    unittest.main()
