# 경로만 바뀐 파일의 Git 인덱스를 안전하게 갱신한다.
import subprocess

from .config import TARGETS, repo_root


def refresh_unchanged_targets() -> None:
    root = repo_root()
    for relative in TARGETS:
        if not (root / relative).is_file():
            continue
        current = subprocess.run(
            ["git", "hash-object", f"--path={relative}", relative],
            cwd=root, capture_output=True, check=False,
        )
        staged = subprocess.run(
            ["git", "rev-parse", f":{relative}"],
            cwd=root, capture_output=True, check=False,
        )
        if current.returncode == staged.returncode == 0 and current.stdout == staged.stdout:
            subprocess.run(["git", "add", "--", relative], cwd=root,
                           capture_output=True, check=True)
