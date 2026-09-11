# protobuf leaf의 경로를 바꾸고 상위 길이 변화량을 계산한다.
from .detect import fix_separators
from .file_url import rewrite
from .text import normalize_plain


def _value(value: bytes, replacements: list[tuple[bytes, bytes]],
           style: str, mode: str) -> bytes:
    if value.startswith(b"file:"):
        return rewrite(value, mode)
    output = value
    for old, new in replacements:
        if old and old in output:
            output = output.replace(old, new)
    return normalize_plain(fix_separators(output, style))


def in_tree(buffer: bytes, fields: list[dict], replacements: list[tuple[bytes, bytes]],
            style: str, mode: str) -> int:
    count = 0

    def walk(nodes: list[dict]) -> int:
        nonlocal count
        delta = 0
        for node in nodes:
            if node["kind"] != "ld":
                continue
            if node["children"]:
                change = walk(node["children"])
                node["length"] += change
                delta += change
                continue
            value = buffer[node["val_start"]:node["end"]]
            new_value = _value(value, replacements, style, mode)
            if new_value == value:
                continue
            hits = sum(value.count(old) for old, _ in replacements if old)
            count += hits or 1
            node["_new_val"] = new_value
            node["length"] = len(new_value)
            delta += len(new_value) - len(value)
        return delta

    walk(fields)
    return count
