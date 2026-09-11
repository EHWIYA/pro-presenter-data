# 변경된 protobuf 길이 필드를 반영해 바이트열을 다시 만든다.
from .varint import encode_varint


def rebuild(buffer: bytes, fields: list[dict]) -> bytes:
    return _emit(buffer, fields, 0, len(buffer))


def _emit(buffer: bytes, nodes: list[dict], start: int, end: int) -> bytes:
    output = bytearray()
    position = start
    for node in nodes:
        if node["tag_start"] > position:
            output.extend(buffer[position:node["tag_start"]])
        if node["kind"] != "ld":
            output.extend(buffer[node["tag_start"]:node["end"]])
            position = node["end"]
            continue
        output.extend(buffer[node["tag_start"]:node["len_start"]])
        if node.get("children"):
            value = _emit(buffer, node["children"], node["val_start"], node["end"])
        elif "_new_val" in node:
            value = node["_new_val"]
        else:
            value = buffer[node["val_start"]:node["end"]]
        output.extend(encode_varint(len(value)))
        output.extend(value)
        position = node["end"]
    output.extend(buffer[position:end])
    return bytes(output)
