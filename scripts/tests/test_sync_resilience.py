# Windows 동기화 오류가 반복되지 않도록 복구 조건과 빠른 실패를 검증한다.
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[2]


class SyncResilienceTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8-sig")

    def test_current_tasks_are_not_registered_again(self):
        tasks = self.read("scripts/win/tasks.ps1")
        helpers = self.read("scripts/win/task-definitions.ps1")
        self.assertIn("Register-ScheduledTaskIfNeeded", tasks)
        self.assertIn("Test-ScheduledTaskDefinition", helpers)
        self.assertIn("Get-ScheduledTask", helpers)
        self.assertIn("WorkingDirectory", helpers)
        self.assertIn("Where-Object", helpers)

    def test_retired_venue_agent_task_is_removed(self):
        tasks = self.read("scripts/win/tasks.ps1")
        self.assertIn('"ProPresenter-VenueAgent-Watcher"', tasks)
        self.assertIn("Unregister-ScheduledTask", tasks)

    def test_permanent_nextcloud_errors_fail_fast(self):
        cloud = self.read("scripts/win/cloud.ps1")
        batch = self.read("scripts/win/sync.bat")
        self.assertIn("Test-PermanentNextcloudError", cloud)
        self.assertIn("401|403", cloud)
        self.assertIn("$Check.Output", cloud)
        self.assertIn("findstr", batch)
        self.assertIn('type nul > "%LOG%"', batch)
        for phrase in ("401", "403", "Unauthorized", "Forbidden"):
            self.assertIn(phrase, batch)


if __name__ == "__main__":
    unittest.main()
