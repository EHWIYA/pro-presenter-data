# 경로 점검이 현재 사용자의 URL 인코딩 경로를 다른 PC로 오인하지 않는지 검증한다.
import contextlib
import io
import pathlib
import tempfile
import unittest
from unittest.mock import patch
from urllib.parse import quote

from scripts.core.files import status


class PathStatusTests(unittest.TestCase):
    def check_status(self, value, expected, expected_mac=0):
        runtime = "C:\\Users\\테스트\\Documents\\pro-presenter"
        with tempfile.TemporaryDirectory() as directory:
            root = pathlib.Path(directory)
            (root / "data").write_bytes(value.encode())
            output = io.StringIO()
            with patch("scripts.core.files.repo_root", return_value=root), \
                 patch("scripts.core.files.runtime_root", return_value=runtime), \
                 patch("scripts.core.files.TARGETS", ("data",)), \
                 contextlib.redirect_stdout(output):
                status()
            self.assertIn(f"other_win={expected}", output.getvalue())
            self.assertIn(f"other_mac={expected_mac}", output.getvalue())

    def test_encoded_current_user_is_not_foreign(self):
        user = quote("테스트")
        self.check_status(f"C:\\Users\\{user}\\Documents\\pro-presenter", 0)

    def test_slash_current_user_is_not_foreign(self):
        self.check_status("C:/Users/테스트/Documents/pro-presenter", 0)

    def test_encoded_foreign_user_is_still_foreign(self):
        user = quote("다른사용자")
        self.check_status(f"C:\\Users\\{user}\\Documents\\pro-presenter", 1)

    def test_foreign_mac_user_is_still_detected(self):
        self.check_status("/Users/다른사용자/Documents/pro-presenter", 0, 1)


if __name__ == "__main__":
    unittest.main()
