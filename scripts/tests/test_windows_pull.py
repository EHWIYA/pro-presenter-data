# 다른 Windows PC의 경로가 적용된 복제본에서 Git pull을 검증한다.
import pathlib
import shutil
import subprocess
import tempfile
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[2]


@unittest.skipUnless(shutil.which("powershell"), "Windows PowerShell required")
class WindowsPullTests(unittest.TestCase):
    def test_pull_from_previous_pc_commit_after_smudge(self):
        with tempfile.TemporaryDirectory() as tmp:
            repo = pathlib.Path(tmp) / "other-pc"
            subprocess.run(["git", "clone", "--shared", str(ROOT), str(repo)],
                           check=True, capture_output=True)
            merge = subprocess.check_output(
                ["git", "rev-list", "--merges", "-n1", "HEAD"], cwd=ROOT,
                text=True).strip()
            previous = subprocess.check_output(
                ["git", "rev-parse", f"{merge}^2"], cwd=ROOT,
                text=True).strip()
            subprocess.run(["git", "checkout", "-b", "other-pc", previous],
                           cwd=repo, check=True, capture_output=True)
            subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy",
                            "Bypass", "-File", "scripts/git-setup.ps1"],
                           cwd=repo, check=True, capture_output=True)
            subprocess.run(["python", "scripts/path.py", "smudge-files"],
                           cwd=repo, check=True, capture_output=True)
            targets = ("Playlists/Library", "Playlists/Media", "Libraries/LibraryData")
            for target in targets:
                staged = subprocess.check_output(["git", "rev-parse", f":{target}"], cwd=repo)
                current = subprocess.check_output(
                    ["git", "hash-object", f"--path={target}", target], cwd=repo)
                self.assertEqual(staged, current)
            subprocess.run(["git", "add", "--", *targets], cwd=repo,
                           check=True, capture_output=True)
            subprocess.run(["git", "diff", "--cached", "--quiet"], cwd=repo, check=True)
            result = subprocess.run(["git", "pull", "--no-rebase", "origin", "main"],
                                    cwd=repo, capture_output=True)
            self.assertEqual(0, result.returncode,
                             (result.stdout + result.stderr).decode(errors="replace"))
            self.assertEqual(subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT),
                             subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=repo))


if __name__ == "__main__":
    unittest.main()
