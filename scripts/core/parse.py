# protobuf 필드를 길이 경계를 지키며 재귀적으로 분석한다.
from .varint import read_varint


def _fixed(kind: str, tag: int, end: int, field: int) -> dict:
    return {"kind": kind, "tag_start": tag, "end": end, "field": field}


def parse_fields(buffer: bytes, start: int, end: int) -> list[dict]:
    fields = []
    index = start
    while index < end:
        tag_start = index
        tag, index = read_varint(buffer, index)
        field, wire = tag >> 3, tag & 7
        if wire == 0:
            _, index = read_varint(buffer, index)
            fields.append(_fixed("varint", tag_start, index, field))
        elif wire in (1, 5):
            index += 8 if wire == 1 else 4
            fields.append(_fixed("fixed64" if wire == 1 else "fixed32", tag_start, index, field))
        elif wire == 2:
            len_start = index
            length, val_start = read_varint(buffer, index)
            val_end = val_start + length
            if val_end > end:
                raise ValueError(f"length overflow field={field} len={length} at {len_start}")
            children = _children(buffer, val_start, val_end)
            fields.append({"kind": "ld", "tag_start": tag_start, "len_start": len_start,
                           "val_start": val_start, "end": val_end, "length": length,
                           "field": field, "children": children})
            index = val_end
        else:
            raise ValueError(f"unknown wire {wire} at {tag_start}")
    return fields


def _children(buffer: bytes, start: int, end: int) -> list[dict]:
    try:
        children = parse_fields(buffer, start, end)
        return children if children and children[-1]["end"] == end else []
    except Exception:
        return []
