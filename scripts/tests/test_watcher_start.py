# 예약 작업 복구가 실행 중인 감시기에 중복 시작 요청을 보내지 않는지 검증한다.
import pathlib
import shutil
import subprocess
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[2]


class WatcherStartTests(unittest.TestCase):
    def test_running_watcher_is_skipped_and_ready_watcher_starts(self):
        powershell = shutil.which("powershell")
        if not powershell:
            self.skipTest("PowerShell required")
        code = r'''
. ./scripts/win/task-definitions.ps1
$script:starts = 0
$script:state = 'Running'
function Get-ScheduledTask { [pscustomobject]@{State=$script:state} }
function Start-ScheduledTask { $script:starts++ }
Start-WatcherIfNeeded
if ($script:starts -ne 0) { throw 'duplicate watcher start' }
$script:state = 'Ready'
Start-WatcherIfNeeded
if ($script:starts -ne 1) { throw 'watcher not started' }
'''
        result = subprocess.run([powershell, "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command",
                                 "$ErrorActionPreference='Stop';" + code],
                                cwd=ROOT, capture_output=True)
        self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
