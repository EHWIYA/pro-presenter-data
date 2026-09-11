# 경로 문자열의 한글과 URL 인코딩을 NFC로 정규화한다.
import unicodedata
from urllib.parse import quote, unquote

from .config import FILE_QUOTE_SAFE
from .detect import is_path


def nfc(value: str) -> str:
    return unicodedata.normalize("NFC", value)


def encode_segments(path: str) -> str:
    parts = [part if part.isascii() else quote(nfc(part), safe=FILE_QUOTE_SAFE)
             for part in path.split("\\")]
    return "\\".join(parts)


def decode_url_body(body: str) -> str:
    return nfc(unquote(body, encoding="utf-8")).replace("/", "\\")


def normalize_plain(value: bytes) -> bytes:
    if not is_path(value) or value.startswith(b"file:"):
        return value
    try:
        text = value.decode("utf-8")
    except UnicodeDecodeError:
        return value
    normalized = nfc(text)
    return value if normalized == text else normalized.encode("utf-8")
