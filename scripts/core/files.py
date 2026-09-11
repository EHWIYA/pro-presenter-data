# 저장소 경로 대상 파일의 일괄 변환과 상태 출력을 처리한다.
import sys

from .config import PORTABLE_ROOT, TARGETS, is_windows, repo_root, runtime_root
from .detect import posix_roots, win_roots
from .transform import transform


def transform_files(mode: str) -> None:
    root = repo_root()
    for relative in TARGETS:
        path = root / relative
        if not path.is_file():
            continue
        source = path.read_bytes()
        output = transform(source, mode)
        if output != source:
            path.write_bytes(output)
            print(f"{mode}: {relative} ({len(source)} → {len(output)})", file=sys.stderr)
        else:
            print(f"{mode}: {relative} (unchanged)", file=sys.stderr)


def status() -> None:
    root = repo_root()
    portable, runtime = PORTABLE_ROOT.encode(), runtime_root().encode()
    for relative in TARGETS:
        path = root / relative
        if not path.is_file():
            print(f"{relative}: missing")
            continue
        data = path.read_bytes()
        other_win = win_roots(data) - {runtime, portable}
        other_mac = posix_roots(data) - {runtime}
        platform = "win" if is_windows() else "posix"
        print(f"{relative}: size={len(data)} portable={data.count(portable)} "
              f"runtime={data.count(runtime)} other_win={len(other_win)} "
              f"other_mac={len(other_mac)} platform={platform}")
