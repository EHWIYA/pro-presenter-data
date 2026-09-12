# Windows 자동 동기화의 권한과 실패 격리 규칙을 검증한다.
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[2]


class SyncSafetyTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8-sig")

    def test_scheduled_tasks_run_without_elevation(self):
        tasks = self.read("scripts/win/tasks.ps1")
        setup = self.read("scripts/auto-setup.ps1")
        self.assertIn("-RunLevel Limited", tasks)
        self.assertNotIn("-RunLevel Highest", tasks)
        self.assertNotIn("-Verb RunAs", setup)

    def test_scheduled_actions_use_stable_entrypoints_and_finish(self):
        tasks = self.read("scripts/win/tasks.ps1")
        self.assertIn('scripts\\windows-auto-sync.ps1', tasks)
        self.assertIn('scripts\\windows-propresenter-watcher.vbs', tasks)
        self.assertNotIn("-WaitForKey", tasks)

    def test_task_repair_failure_does_not_block_sync(self):
        main = self.read("scripts/win/main.ps1")
        repair = main.index('Invoke-Checked "자동 동기화 작업 복구"')
        warning = main.index("Add-SyncWarning", repair)
        assets = main.index("Initialize-GitAssets", warning)
        self.assertLess(repair, warning)
        self.assertLess(warning, assets)

    def test_admin_repair_is_narrow_and_one_shot(self):
        repair = self.read("scripts/windows-repair.ps1")
        for phrase in ("Gaussian Mixture Model*1911", "DISM.exe", "sfc.exe", "pnputil.exe"):
            self.assertIn(phrase, repair)
        self.assertNotIn("Register-ScheduledTask", repair)

if __name__ == "__main__":
    unittest.main()
