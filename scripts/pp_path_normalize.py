#!/usr/bin/env python3
"""ProPresenter playlist/index path normalize (protobuf length-safe).

Git filter:
  clean  — working tree absolute → Git portable (%USERPROFILE%\\Documents\\pro-presenter)
  smudge — Git portable (or other-PC absolute) → this PC absolute

CLI:
  clean | smudge          stdin → stdout (git filter)
  clean-files | smudge-files   rewrite on-disk targets in-place
  status                  print path-style counts for targets

Win · Mac:
  Git 정본은 Windows portable(백슬래시). Mac working tree는 /Users/… (슬래시).
  상대 경로 Libraries/… 는 항상 슬래시 유지.
"""
from __future__ import annotations

import pathlib
import re
import sys

TARGETS = (
    "Playlists/Library",
    "Playlists/Media",
    "Libraries/LibraryData",
)

# Single Git-canonical portable root (see docs/data/repo.md, paths.standard.json).
PORTABLE_ROOT = "%USERPROFILE%\\Documents\\pro-presenter"
PORTABLE_ROOT_POSIX = "%USERPROFILE%/Documents/pro-presenter"  # if ever written wrong
HOME_PORTABLE = "$HOME/Documents/pro-presenter"
HOME_PORTABLE_WIN = "$HOME\\Documents\\pro-presenter"

# Legacy account baked into length prefixes when paths were naively portableized.
_LEGACY_USER_PREFIX = "C:\\Users\\봉담중앙 방송실"


def is_windows() -> bool:
    return sys.platform == "win32"


def runtime_root() -> str:
    p = pathlib.Path.home() / "Documents" / "pro-presenter"
    if is_windows():
        return str(p)
    return p.as_posix()


def _path_end(data: bytes, start: int) -> int:
    """End index (exclusive) of a show-dir path starting at start."""
    for ext in (
        b".pro",
        b".PNG",
        b".png",
        b".JPG",
        b".jpg",
        b".mp4",
        b".MP4",
        b".mov",
    ):
        k = data.find(ext, start)
        if k != -1 and k - start < 400:
            return k + len(ext)
    i = start
    while i < len(data) and data[i] >= 0x20 and data[i] not in (0x22,):
        i += 1
        if i - start > 240:
            break
    return i


def portable_lengths_ok(data: bytes) -> bool:
    token = b"%USERPROFILE%\\Documents\\pro-presenter"
    j = data.find(token)
    if j < 1:
        # also accept posix-ish portable
        j = data.find(b"%USERPROFILE%/Documents/pro-presenter")
        if j < 1:
            return True
    end = _path_end(data, j)
    actual = end - j
    declared = data[j - 1]
    return declared == actual


def repair_broken_portable(data: bytes) -> bytes:
    """Expand %USERPROFILE% → legacy abs prefix so stale length prefixes match again."""
    if b"%USERPROFILE%" not in data:
        return data
    if portable_lengths_ok(data):
        return data
    legacy = _LEGACY_USER_PREFIX.encode("utf-8")
    token = b"%USERPROFILE%"
    if len(legacy) <= len(token):
        return data
    return data.replace(token, legacy)


def encode_varint(n: int) -> bytes:
    out = bytearray()
    while True:
        b = n & 0x7F
        n >>= 7
        out.append(b | 0x80 if n else b)
        if not n:
            return bytes(out)


def read_varint(buf: bytes, i: int) -> tuple[int, int]:
    shift = 0
    n = 0
    while True:
        if i >= len(buf):
            raise ValueError("truncated varint")
        b = buf[i]
        i += 1
        n |= (b & 0x7F) << shift
        if not (b & 0x80):
            return n, i
        shift += 7
        if shift > 70:
            raise ValueError("varint too long")


def parse_fields(buf: bytes, start: int, end: int) -> list[dict]:
    fields: list[dict] = []
    i = start
    while i < end:
        tag_start = i
        tag, i = read_varint(buf, i)
        field_no = tag >> 3
        wire = tag & 7
        if wire == 0:
            _, i = read_varint(buf, i)
            fields.append(
                {"kind": "varint", "tag_start": tag_start, "end": i, "field": field_no}
            )
        elif wire == 1:
            i += 8
            fields.append(
                {"kind": "fixed64", "tag_start": tag_start, "end": i, "field": field_no}
            )
        elif wire == 5:
            i += 4
            fields.append(
                {"kind": "fixed32", "tag_start": tag_start, "end": i, "field": field_no}
            )
        elif wire == 2:
            len_start = i
            length, val_start = read_varint(buf, i)
            val_end = val_start + length
            if val_end > end:
                raise ValueError(
                    f"length overflow field={field_no} len={length} at {len_start}"
                )
            children: list[dict] = []
            try:
                children = parse_fields(buf, val_start, val_end)
                if children and children[-1]["end"] != val_end:
                    children = []
            except Exception:
                children = []
            fields.append(
                {
                    "kind": "ld",
                    "tag_start": tag_start,
                    "len_start": len_start,
                    "val_start": val_start,
                    "end": val_end,
                    "length": length,
                    "field": field_no,
                    "children": children,
                }
            )
            i = val_end
        else:
            raise ValueError(f"unknown wire {wire} at {tag_start}")
    return fields


def is_relative_library_path(val: bytes) -> bool:
    return val.startswith(b"Libraries/") or val.startswith(b"Libraries\\")


def is_absolute_show_path(val: bytes) -> bool:
    if is_relative_library_path(val):
        return False
    if val.startswith(b"%USERPROFILE%") or val.startswith(b"$HOME"):
        return True
    if val.startswith(b"C:\\Users\\") or val.startswith(b"C:/Users/"):
        return True
    if val.startswith(b"/Users/") and b"pro-presenter" in val:
        return True
    return b"Documents\\pro-presenter" in val or b"Documents/pro-presenter" in val


def fix_abs_separators(val: bytes, style: str) -> bytes:
    """Normalize separators in absolute show-dir paths only. Relative Libraries/ → '/'."""
    if is_relative_library_path(val):
        return val.replace(b"\\", b"/")
    if not is_absolute_show_path(val):
        return val
    if style == "posix":
        return val.replace(b"\\", b"/")
    if style == "windows":
        return val.replace(b"/", b"\\")
    return val


def _apply_replacements(
    val: bytes, replacements: list[tuple[bytes, bytes]], sep_style: str | None
) -> bytes:
    out = val
    for old, new in replacements:
        if old and old in out:
            out = out.replace(old, new)
    if sep_style:
        out = fix_abs_separators(out, sep_style)
    return out


def replace_in_tree(
    buf: bytes,
    fields: list[dict],
    replacements: list[tuple[bytes, bytes]],
    sep_style: str | None,
) -> int:
    count = 0

    def walk(nodes: list[dict]) -> int:
        nonlocal count
        total = 0
        for node in nodes:
            if node["kind"] != "ld":
                continue
            if node["children"]:
                d = walk(node["children"])
                if d:
                    node["length"] += d
                    total += d
            else:
                val = buf[node["val_start"] : node["end"]]
                new_val = _apply_replacements(val, replacements, sep_style)
                if new_val != val:
                    for old, _new in replacements:
                        if old:
                            count += val.count(old)
                    if not any(old in val for old, _ in replacements) and new_val != val:
                        count += 1  # separator-only fix
                    node["_new_val"] = new_val
                    d = len(new_val) - len(val)
                    node["length"] = len(new_val)
                    total += d
        return total

    walk(fields)
    return count


def rebuild(buf: bytes, fields: list[dict]) -> bytes:
    def emit(nodes: list[dict], start: int, end: int) -> bytes:
        out = bytearray()
        pos = start
        for node in nodes:
            if node["tag_start"] > pos:
                out.extend(buf[pos : node["tag_start"]])
            if node["kind"] != "ld":
                out.extend(buf[node["tag_start"] : node["end"]])
                pos = node["end"]
                continue
            out.extend(buf[node["tag_start"] : node["len_start"]])
            if node.get("children"):
                inner = emit(node["children"], node["val_start"], node["end"])
                out.extend(encode_varint(len(inner)))
                out.extend(inner)
            elif "_new_val" in node:
                val = node["_new_val"]
                out.extend(encode_varint(len(val)))
                out.extend(val)
            else:
                val = buf[node["val_start"] : node["end"]]
                out.extend(encode_varint(len(val)))
                out.extend(val)
            pos = node["end"]
        if pos < end:
            out.extend(buf[pos:end])
        return bytes(out)

    return emit(fields, 0, len(buf))


def win_abs_roots_in(data: bytes) -> set[bytes]:
    found: set[bytes] = set()
    for m in re.finditer(rb"C:\\Users\\[^\\]+\\Documents\\pro-presenter", data):
        found.add(m.group())
    for m in re.finditer(rb"C:/Users/[^/]+/Documents/pro-presenter", data):
        found.add(m.group())
    return found


def posix_abs_roots_in(data: bytes) -> set[bytes]:
    found: set[bytes] = set()
    for m in re.finditer(rb"/Users/[^/]+/Documents/pro-presenter", data):
        found.add(m.group())
    return found


def replacements_for_clean(data: bytes) -> list[tuple[bytes, bytes]]:
    portable = PORTABLE_ROOT.encode("utf-8")
    reps: list[tuple[bytes, bytes]] = []
    for root in sorted(win_abs_roots_in(data), key=len, reverse=True):
        if root != portable:
            reps.append((root, portable))
    for root in sorted(posix_abs_roots_in(data), key=len, reverse=True):
        reps.append((root, portable))
    for token in (
        HOME_PORTABLE.encode(),
        HOME_PORTABLE_WIN.encode(),
        PORTABLE_ROOT_POSIX.encode(),
    ):
        if token in data and token != portable:
            reps.append((token, portable))
    rt = runtime_root()
    rt_b = rt.encode("utf-8")
    rt_alt = rt.replace("\\", "/").encode("utf-8")
    if rt_b != portable and rt_b in data:
        reps.append((rt_b, portable))
    if rt_alt != portable and rt_alt in data and rt_alt != rt_b:
        reps.append((rt_alt, portable))
    # de-dupe preserving order
    seen: set[bytes] = set()
    out: list[tuple[bytes, bytes]] = []
    for old, new in reps:
        if old in seen:
            continue
        seen.add(old)
        out.append((old, new))
    return out


def replacements_for_smudge(data: bytes) -> list[tuple[bytes, bytes]]:
    rt = runtime_root().encode("utf-8")
    portable = PORTABLE_ROOT.encode("utf-8")
    reps: list[tuple[bytes, bytes]] = []
    for token in (
        portable,
        PORTABLE_ROOT_POSIX.encode(),
        HOME_PORTABLE.encode(),
        HOME_PORTABLE_WIN.encode(),
    ):
        if token in data and token != rt:
            reps.append((token, rt))
    for root in sorted(win_abs_roots_in(data), key=len, reverse=True):
        if root != rt:
            reps.append((root, rt))
    for root in sorted(posix_abs_roots_in(data), key=len, reverse=True):
        if root != rt:
            reps.append((root, rt))
    seen: set[bytes] = set()
    out: list[tuple[bytes, bytes]] = []
    for old, new in reps:
        if old in seen:
            continue
        seen.add(old)
        out.append((old, new))
    return out


def transform(data: bytes, mode: str) -> bytes:
    data = repair_broken_portable(data)

    if mode == "clean":
        reps = replacements_for_clean(data)
        sep_style = "windows"  # Git portable uses backslash abs paths
    elif mode == "smudge":
        reps = replacements_for_smudge(data)
        sep_style = "windows" if is_windows() else "posix"
    else:
        raise ValueError(mode)

    # Separator fix may still be needed even if roots already match
    need = bool(reps and any(old in data for old, _ in reps))
    if not need:
        # Still normalize separators on abs paths for this platform/mode
        try:
            fields = parse_fields(data, 0, len(data))
        except Exception:
            return data
        n = replace_in_tree(data, fields, [], sep_style)
        if n == 0:
            return data
        return rebuild(data, fields)

    try:
        fields = parse_fields(data, 0, len(data))
    except Exception as e:
        print(
            f"pp_path_normalize: parse failed ({e}); leaving bytes unchanged",
            file=sys.stderr,
        )
        return data
    n = replace_in_tree(data, fields, reps, sep_style)
    if n == 0:
        return data
    return rebuild(data, fields)


def filter_stdio(mode: str) -> None:
    data = sys.stdin.buffer.read()
    sys.stdout.buffer.write(transform(data, mode))


def repo_root() -> pathlib.Path:
    return pathlib.Path(__file__).resolve().parent.parent


def transform_files(mode: str) -> None:
    root = repo_root()
    for rel in TARGETS:
        path = root / rel
        if not path.is_file():
            continue
        raw = path.read_bytes()
        out = transform(raw, mode)
        if out != raw:
            path.write_bytes(out)
            print(f"{mode}: {rel} ({len(raw)} → {len(out)})", file=sys.stderr)
        else:
            print(f"{mode}: {rel} (unchanged)", file=sys.stderr)


def status() -> None:
    root = repo_root()
    portable = PORTABLE_ROOT.encode()
    rt = runtime_root().encode()
    for rel in TARGETS:
        path = root / rel
        if not path.is_file():
            print(f"{rel}: missing")
            continue
        b = path.read_bytes()
        other_win = win_abs_roots_in(b) - {rt, portable}
        other_mac = posix_abs_roots_in(b) - {rt}
        print(
            f"{rel}: size={len(b)} portable={b.count(portable)} "
            f"runtime={b.count(rt)} other_win={len(other_win)} other_mac={len(other_mac)} "
            f"platform={'win' if is_windows() else 'posix'}"
        )


def main(argv: list[str]) -> int:
    if len(argv) < 2:
        print(__doc__, file=sys.stderr)
        return 2
    cmd = argv[1]
    if cmd in ("clean", "smudge"):
        filter_stdio(cmd)
        return 0
    if cmd == "clean-files":
        transform_files("clean")
        return 0
    if cmd == "smudge-files":
        transform_files("smudge")
        return 0
    if cmd == "status":
        status()
        return 0
    print(f"unknown command: {cmd}", file=sys.stderr)
    return 2


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
