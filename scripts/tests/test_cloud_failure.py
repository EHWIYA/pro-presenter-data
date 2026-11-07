# 실제 스크립트를 가짜 rclone으로 실행해 실패 종료와 안전한 재시도를 검증한다.
import os
import pathlib
import shutil
import subprocess
import tempfile
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[2]


class CloudFailureTests(unittest.TestCase):
    def test_windows_retry_never_enables_resync(self):
        if os.name != "nt":
            self.skipTest("Windows batch required")
        with tempfile.TemporaryDirectory() as temporary:
            folder = pathlib.Path(temporary)
            target = folder / "Documents/pro-presenter/.nextcloud-sync"
            target.mkdir(parents=True)
            (target / "resync-done").write_text("done")
            source = (ROOT / "scripts/win/sync.bat").read_text()
            source = source.replace("rclone bisync", 'call "%FAKE_RCLONE%" bisync')
            (folder / "sync.bat").write_text(source)
            fake = folder / "rclone.bat"
            fake.write_text('@echo off\necho %*>>"%USERPROFILE%\\calls.txt"\nexit /b 7\n')
            env = dict(os.environ, USERPROFILE=temporary, FAKE_RCLONE=str(fake),
                       PP_SYNC_MAX_ATTEMPTS="2", PP_SYNC_RETRY_DELAY="0")
            result = subprocess.run(["cmd", "/c", str(folder / "sync.bat")],
                                    env=env, capture_output=True)
            self.assertEqual(result.returncode, 7, result.stdout)
            calls = (folder / "calls.txt").read_text(errors="replace").splitlines()
            self.assertEqual(len(calls), 2)
            self.assertTrue(all("--resync" not in call for call in calls))
            self.assertTrue(all("--resilient --recover" in call for call in calls))
            self.assertTrue((target / "resync-done").exists())

    def test_mac_preserves_failure_exit_code(self):
        bash = shutil.which("bash")
        candidate = pathlib.Path("C:/Program Files/Git/bin/bash.exe")
        bash = str(candidate) if candidate.exists() else bash
        if not bash:
            self.skipTest("bash required")
        script = (ROOT / "scripts/mac/sync.sh").read_text(encoding="utf-8")
        prefix = 'mkdir() { :; }; rclone() { return 7; };\n'
        result = subprocess.run([bash, "-c", prefix + script], capture_output=True)
        self.assertEqual(result.returncode, 7, result.stderr)


if __name__ == "__main__":
    unittest.main()
