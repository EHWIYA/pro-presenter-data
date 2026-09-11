# protobuf varint 값을 안전하게 읽고 쓴다.
def encode_varint(number: int) -> bytes:
    output = bytearray()
    while True:
        byte = number & 0x7F
        number >>= 7
        output.append(byte | 0x80 if number else byte)
        if not number:
            return bytes(output)


def read_varint(buffer: bytes, index: int) -> tuple[int, int]:
    shift = 0
    number = 0
    while True:
        if index >= len(buffer):
            raise ValueError("truncated varint")
        byte = buffer[index]
        index += 1
        number |= (byte & 0x7F) << shift
        if not byte & 0x80:
            return number, index
        shift += 7
        if shift > 70:
            raise ValueError("varint too long")
