# 자동 동기화가 기존 병합 이력을 다시 리베이스하지 않는지 검증한다.
import pathlib
import shutil
import subprocess
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[2]


@unittest.skipUnless(shutil.which("powershell"), "Windows PowerShell required")
class GitPullMergeTests(unittest.TestCase):
    def test_pull_keeps_existing_merge_history(self):
        runner = str(ROOT / "scripts/win/run.ps1").replace("'", "''")
        script = str(ROOT / "scripts/win/git.ps1").replace("'", "''")
        code = (
            "$ErrorActionPreference='Stop'; $script:StepNumber=0; $script:StepTotal=3; "
            f". '{runner}'; . '{script}'; "
            "function git { "
            "if ($args[0] -eq 'pull') { "
            "if ($args -contains '--no-rebase') { $global:LASTEXITCODE=0; return }; "
            "throw 'UNSAFE_REBASE' }; "
            "if ($args[0] -eq 'push') { $global:LASTEXITCODE=0; return }; "
            "& git.exe @args }; "
            "function python { $global:LASTEXITCODE=0 }; "
            "try { Invoke-GitRemote; exit 0 } "
            "catch { [Console]::WriteLine($_.Exception.Message); exit 1 }")
        result = subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy",
                                 "Bypass", "-Command", code], cwd=ROOT,
                                capture_output=True)
        self.assertEqual(0, result.returncode, result.stdout.decode(errors="replace"))


if __name__ == "__main__":
    unittest.main()
