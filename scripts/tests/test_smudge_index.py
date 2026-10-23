# PC별 경로 적용 후 실제 편집 내용은 스테이징하지 않는지 검증한다.
import pathlib
import shutil
import subprocess
import tempfile
import unittest
from unittest.mock import patch

from scripts.core.files import transform_files

ROOT = pathlib.Path(__file__).resolve().parents[2]


@unittest.skipUnless(shutil.which("powershell"), "Windows PowerShell required")
class SmudgeIndexTests(unittest.TestCase):
    def test_smudge_refreshes_only_unchanged_git_content(self):
        with tempfile.TemporaryDirectory() as tmp:
            repo = pathlib.Path(tmp) / "other-pc"
            subprocess.run(["git", "clone", "--shared", str(ROOT), str(repo)],
                           check=True, capture_output=True)
            subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy",
                            "Bypass", "-File", "scripts/git-setup.ps1"],
                           cwd=repo, check=True, capture_output=True)
            with patch("scripts.core.files.repo_root", return_value=repo), \
                 patch("scripts.core.index.repo_root", return_value=repo):
                transform_files("smudge")
                status = subprocess.check_output(
                    ["git", "status", "--porcelain", "--", "Playlists/Library"], cwd=repo)
                self.assertEqual(b"", status)
                playlist = repo / "Playlists/Library"
                playlist.write_bytes(playlist.read_bytes() + b"\x00")
                before = subprocess.check_output(
                    ["git", "rev-parse", ":Playlists/Library"], cwd=repo)
                transform_files("smudge")
                after = subprocess.check_output(
                    ["git", "rev-parse", ":Playlists/Library"], cwd=repo)
                self.assertEqual(before, after)
                self.assertTrue(subprocess.check_output(
                    ["git", "status", "--porcelain", "--", "Playlists/Library"], cwd=repo))


if __name__ == "__main__":
    unittest.main()
