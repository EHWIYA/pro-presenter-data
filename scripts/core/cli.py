# 경로 변환기의 명령행 계약과 Git 표준 입출력을 처리한다.
import sys

from .files import status, transform_files
from .transform import transform

HELP = "clean | smudge | clean-files | smudge-files | status"


def filter_stdio(mode: str) -> None:
    data = sys.stdin.buffer.read()
    sys.stdout.buffer.write(data if mode == "smudge" else transform(data, mode))


def main(arguments: list[str]) -> int:
    if len(arguments) < 2:
        print(HELP, file=sys.stderr)
        return 2
    command = arguments[1]
    if command in ("clean", "smudge"):
        filter_stdio(command)
    elif command in ("clean-files", "smudge-files"):
        transform_files(command.removesuffix("-files"))
    elif command == "status":
        status()
    else:
        print(f"unknown command: {command}", file=sys.stderr)
        return 2
    return 0
