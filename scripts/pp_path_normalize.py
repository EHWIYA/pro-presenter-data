# ProPresenter 경로 정규화의 호환 명령행 진입점을 제공한다.
import sys

sys.dont_write_bytecode = True

from core.cli import main
from core.config import PORTABLE_ROOT, runtime_root
from core.transform import transform
from core.varint import encode_varint, read_varint

__all__ = [
    "PORTABLE_ROOT",
    "encode_varint",
    "read_varint",
    "runtime_root",
    "transform",
]


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
