# 실제 Git 저장소에서 중단된 작업과 분리된 HEAD의 자동 커밋 차단을 검증한다.
import pathlib
import shutil
import subprocess
import tempfile
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[2]


@unittest.skipUnless(shutil.which("powershell"), "Windows PowerShell required")
class GitSyncStateTests(unittest.TestCase):
    def test_unsafe_states_stop_before_staging(self):
        for state in ("rebase-merge", "rebase-apply", "MERGE_HEAD",
                      "CHERRY_PICK_HEAD", "REVERT_HEAD", "detached"):
            with self.subTest(state=state), tempfile.TemporaryDirectory() as tmp:
                repo = pathlib.Path(tmp) / "repo"
                subprocess.run(["git", "clone", "--shared", "--no-checkout",
                                str(ROOT), str(repo)], check=True, capture_output=True)
                if state == "detached":
                    head = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=repo)
                    subprocess.run(["git", "update-ref", "--no-deref", "HEAD",
                                    head.decode().strip()], cwd=repo, check=True)
                else:
                    marker = repo / ".git" / state
                    marker.mkdir() if state.startswith("rebase-") else marker.touch()
                script = str(ROOT / "scripts/win/git.ps1").replace("'", "''")
                runner = str(ROOT / "scripts/win/run.ps1").replace("'", "''")
                code = ("$ErrorActionPreference='Stop'; "
                        f". '{runner}'; . '{script}'; try {{ Initialize-GitAssets; exit 0 }} "
                        "catch { [Console]::WriteLine($_.Exception.Message); exit 1 }")
                result = subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy",
                                         "Bypass", "-Command", code],
                                        cwd=repo, capture_output=True)
                self.assertEqual(1, result.returncode)
                self.assertIn(b"GIT_SYNC_BLOCKED", result.stdout)
                self.assertFalse((repo / ".git/index").exists())

    def test_git_preparation_failure_still_allows_media_sync(self):
        main = (ROOT / "scripts/win/main.ps1").read_text(encoding="utf-8-sig")
        start = main.index("    try {\n        Initialize-GitAssets")
        failure = main.index('$script:GitResult = "실패"', start)
        self.assertGreater(main.index("Invoke-MediaSync"), failure)


if __name__ == "__main__":
    unittest.main()
