# Git 제외 자산과 문맥 캐시의 저장소 정책을 검사한다.
import subprocess

from .context import stale
from .policy import ROOT


def repo_errors() -> list[str]:
    result = subprocess.run(
        ["git", "ls-files", "Media/Assets", "Configuration"],
        cwd=ROOT, text=True, capture_output=True, check=False,
    )
    errors = [f"tracked-exclusion: {path}" for path in result.stdout.splitlines()]
    errors += [f"stale-cache: {path}" for path in stale()]
    return errors
