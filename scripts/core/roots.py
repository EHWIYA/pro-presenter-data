# 입력에 포함된 절대경로와 portable 루트의 교체 목록을 만든다.
from .config import HOME_PORTABLE, HOME_PORTABLE_WIN, PORTABLE_ROOT
from .config import PORTABLE_ROOT_POSIX, runtime_root
from .detect import posix_roots, win_roots


def _unique(items: list[tuple[bytes, bytes]]) -> list[tuple[bytes, bytes]]:
    output = []
    seen = set()
    for old, new in items:
        if old not in seen:
            output.append((old, new))
            seen.add(old)
    return output


def for_clean(data: bytes) -> list[tuple[bytes, bytes]]:
    portable = PORTABLE_ROOT.encode()
    items = [(root, portable) for root in sorted(win_roots(data), key=len, reverse=True)
             if root != portable]
    items += [(root, portable) for root in sorted(posix_roots(data), key=len, reverse=True)]
    tokens = (HOME_PORTABLE, HOME_PORTABLE_WIN, PORTABLE_ROOT_POSIX)
    items += [(token.encode(), portable) for token in tokens if token.encode() in data]
    runtime = runtime_root().encode()
    alternate = runtime_root().replace("\\", "/").encode()
    items += [(root, portable) for root in (runtime, alternate)
              if root != portable and root in data]
    return _unique(items)


def for_smudge(data: bytes) -> list[tuple[bytes, bytes]]:
    runtime = runtime_root().encode()
    tokens = (PORTABLE_ROOT, PORTABLE_ROOT_POSIX, HOME_PORTABLE, HOME_PORTABLE_WIN)
    items = [(token.encode(), runtime) for token in tokens
             if token.encode() in data and token.encode() != runtime]
    items += [(root, runtime) for root in sorted(win_roots(data), key=len, reverse=True)
              if root != runtime]
    items += [(root, runtime) for root in sorted(posix_roots(data), key=len, reverse=True)
              if root != runtime]
    return _unique(items)
