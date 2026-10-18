# pull 충돌 시 원인과 파일을 알리고 후속 전송을 중단하는지 검증한다.
import pathlib
import shutil
import subprocess
import tempfile
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[2]


@unittest.skipUnless(shutil.which("powershell"), "Windows PowerShell required")
class GitPullFailureTests(unittest.TestCase):
    def test_pull_conflict_reports_files_and_preserves_rebase(self):
        with tempfile.TemporaryDirectory() as tmp:
            repo = pathlib.Path(tmp) / "repo"
            subprocess.run(["git", "clone", "--shared", "--no-checkout",
                            str(ROOT), str(repo)], check=True, capture_output=True)
            marker = repo / ".git/rebase-merge"
            marker.mkdir()
            runner = str(ROOT / "scripts/win/run.ps1").replace("'", "''")
            script = str(ROOT / "scripts/win/git.ps1").replace("'", "''")
            code = (
                "$ErrorActionPreference='Stop'; "
                f". '{runner}'; . '{script}'; "
                "function git { "
                "if ($args[0] -eq 'pull') { $global:LASTEXITCODE=1; return }; "
                "if ($args -contains 'diff') { 'Libraries/conflict.pro'; return }; "
                "if ($args[0] -eq 'push') { throw 'UNEXPECTED_PUSH' }; "
                "& git.exe @args }; "
                "function python { throw 'UNEXPECTED_PATH_CHANGE' }; "
                "try { Invoke-GitRemote; exit 0 } "
                "catch { [Console]::WriteLine($_.Exception.Message); exit 1 }")
            result = subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy",
                                     "Bypass", "-Command", code],
                                    cwd=repo, capture_output=True)
            self.assertEqual(1, result.returncode)
            self.assertIn(b"GIT_SYNC_BLOCKED", result.stdout)
            self.assertIn(b"Libraries/conflict.pro", result.stdout)
            self.assertNotIn(b"UNEXPECTED_", result.stdout)
            self.assertTrue(marker.is_dir())


if __name__ == "__main__":
    unittest.main()
