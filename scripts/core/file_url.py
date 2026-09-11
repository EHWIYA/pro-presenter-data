# file URL의 Show Directory 루트를 clean 또는 smudge 형식으로 바꾼다.
from urllib.parse import quote

from .config import FILE_QUOTE_SAFE, PORTABLE_ROOT, SHOW_MARKER, is_windows, runtime_root
from .text import decode_url_body, encode_segments, nfc


def _split(value: str) -> tuple[str, str] | None:
    for prefix, length in (("file:\\\\", 7), ("file://", 7), ("file:", 5)):
        if value.startswith(prefix):
            return prefix, value[length:]
    return None


def _map(path: str, root: str) -> str | None:
    index = path.find(SHOW_MARKER)
    if index == -1:
        return None
    rest = path[index + len(SHOW_MARKER):]
    return root.replace("/", "\\") + rest


def rewrite(value: bytes, mode: str) -> bytes:
    try:
        split = _split(value.decode("utf-8"))
    except UnicodeDecodeError:
        return value
    if split is None:
        return value
    mapped = _map(decode_url_body(split[1]), PORTABLE_ROOT if mode == "clean" else runtime_root())
    if mapped is None:
        return value
    if mode == "clean" or is_windows():
        output = "file:\\\\" + encode_segments(mapped)
    else:
        output = "file://" + quote(nfc(mapped.replace("\\", "/")), safe=FILE_QUOTE_SAFE)
    return output.encode("utf-8")
