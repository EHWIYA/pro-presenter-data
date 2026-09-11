# 경로 교체, protobuf 분석, 길이 재구성을 하나의 변환으로 조합한다.
import sys

from .config import is_windows
from .parse import parse_fields
from .rebuild import rebuild
from .repair import broken_portable
from .replace import in_tree
from .roots import for_clean, for_smudge


def transform(data: bytes, mode: str) -> bytes:
    data = broken_portable(data)
    if mode == "clean":
        replacements, style = for_clean(data), "windows"
    elif mode == "smudge":
        replacements = for_smudge(data)
        style = "windows" if is_windows() else "posix"
    else:
        raise ValueError(mode)
    needs_root = replacements and any(old in data for old, _ in replacements)
    if not needs_root and b"file:" not in data:
        replacements = []
    try:
        fields = parse_fields(data, 0, len(data))
    except Exception as error:
        if needs_root or b"file:" in data:
            print(f"pp_path_normalize: parse failed ({error}); leaving bytes unchanged",
                  file=sys.stderr)
        return data
    changes = in_tree(data, fields, replacements, style, mode)
    return rebuild(data, fields) if changes else data
