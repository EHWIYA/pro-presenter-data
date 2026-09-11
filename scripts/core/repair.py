# 과거 잘못 치환된 portable 경로를 parse 가능한 경우에만 복구한다.
from .config import LEGACY_USER_PREFIX
from .parse import parse_fields


def parses(data: bytes) -> bool:
    try:
        parse_fields(data, 0, len(data))
        return True
    except Exception:
        return False


def broken_portable(data: bytes) -> bytes:
    token = b"%USERPROFILE%"
    if token not in data or parses(data):
        return data
    legacy = LEGACY_USER_PREFIX.encode("utf-8")
    if len(legacy) <= len(token):
        return data
    expanded = data.replace(token, legacy)
    return expanded if parses(expanded) else data
