# Windows에서 UTF-8 외부 명령 출력을 읽는 검증을 수행한다.
import pathlib
import subprocess
import sys
import unittest
from unittest.mock import patch

ROOT = pathlib.Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "scripts"))

from core.commands import _run
import ctx


class SubprocessEncodingTests(unittest.TestCase):
    def test_propresenter_indexes_are_binary_to_git(self):
        result = subprocess.run(
            ["git", "check-attr", "filter", "diff", "text", "--", "Playlists/Library",
             "Playlists/Media", "Libraries/LibraryData"],
            cwd=ROOT, text=True, encoding="utf-8", capture_output=True, check=True,
        )
        for path in ("Playlists/Library", "Playlists/Media", "Libraries/LibraryData"):
            self.assertIn(f"{path}: filter: pp-paths", result.stdout)
            self.assertIn(f"{path}: diff: unset", result.stdout)
            self.assertIn(f"{path}: text: unset", result.stdout)

    def test_failed_command_preserves_utf8_diagnostic(self):
        command = [sys.executable, "-c", "import sys; sys.stderr.buffer.write('한글 오류'.encode('utf-8')); sys.exit(1)"]
        self.assertIn("한글 오류", "\n".join(_run(command)))

    def test_context_git_preserves_utf8_output(self):
        real_run = subprocess.run

        def run_utf8(*args, **kwargs):
            return real_run(
                [sys.executable, "-c", "import sys; sys.stdout.buffer.write('한글 파일'.encode('utf-8'))"],
                **kwargs,
            )

        with patch.object(ctx.subprocess, "run", side_effect=run_utf8):
            self.assertEqual("한글 파일", ctx.git("status", "--short"))


if __name__ == "__main__":
    unittest.main()
