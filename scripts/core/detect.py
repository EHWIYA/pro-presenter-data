# ProPresenter 경로 종류와 포함된 사용자 루트를 판별한다.
import re


def is_relative(value: bytes) -> bool:
    return value.startswith((b"Libraries/", b"Libraries\\"))


def is_absolute(value: bytes) -> bool:
    if is_relative(value):
        return False
    prefixes = (b"%USERPROFILE%", b"$HOME", b"C:\\Users\\", b"C:/Users/")
    if value.startswith(prefixes):
        return True
    if value.startswith(b"/Users/") and b"pro-presenter" in value:
        return True
    if b"%2FUsers%2F" in value and b"pro-presenter" in value:
        return True
    return b"Documents\\pro-presenter" in value or b"Documents/pro-presenter" in value


def is_path(value: bytes) -> bool:
    return is_relative(value) or is_absolute(value) or value.startswith(b"file:")


def fix_separators(value: bytes, style: str) -> bytes:
    if is_relative(value):
        return value.replace(b"\\", b"/")
    if not is_absolute(value):
        return value
    return value.replace(b"\\", b"/") if style == "posix" else value.replace(b"/", b"\\")


def win_roots(data: bytes) -> set[bytes]:
    backslash = re.findall(rb"C:\\Users\\[^\\]+\\Documents\\pro-presenter", data)
    slash = re.findall(rb"C:/Users/[^/]+/Documents/pro-presenter", data)
    return set(backslash + slash)


def posix_roots(data: bytes) -> set[bytes]:
    return set(re.findall(rb"/Users/[^/]+/Documents/pro-presenter", data))
