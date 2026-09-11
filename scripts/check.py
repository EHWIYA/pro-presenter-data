# 저장소 구조, 문서, 캐시와 자동화 구문을 한 번에 검증한다.
import os
import sys

os.environ["PYTHONDONTWRITEBYTECODE"] = "1"
sys.dont_write_bytecode = True

from core.commands import command_errors
from core.links import link_errors
from core.policy import folder_errors, header_errors, line_errors
from core.repo_check import repo_errors


def main() -> int:
    errors = line_errors() + folder_errors() + header_errors()
    errors += link_errors() + repo_errors() + command_errors()
    if errors:
        print("CHECK FAILED")
        print("\n".join(f"- {error}" for error in errors))
        return 1
    print("CHECK OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
