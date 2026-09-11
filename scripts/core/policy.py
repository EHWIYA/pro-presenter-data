# 문서와 소스의 줄 수, 폴더 수, 헤더 규칙을 검사한다.
import pathlib

ROOT = pathlib.Path(__file__).resolve().parents[2]
SOURCE = {".py", ".ps1", ".sh", ".bat", ".vbs"}


def managed_files() -> list[pathlib.Path]:
    fixed = [ROOT / "AGENTS.md", ROOT / "README.md"]
    docs = list((ROOT / "docs").rglob("*.md")) + list((ROOT / "docs").rglob("*.json"))
    scripts = [path for path in (ROOT / "scripts").rglob("*")
               if path.is_file() and path.suffix.lower() in SOURCE | {".md", ".plist"}]
    return fixed + docs + scripts


def line_errors() -> list[str]:
    errors = []
    for path in managed_files():
        count = len(path.read_text(encoding="utf-8-sig", errors="replace").splitlines())
        if count > 50:
            errors.append(f"line-limit: {path.relative_to(ROOT)} has {count}")
    return errors


def folder_errors() -> list[str]:
    errors = []
    for name in ("docs", "scripts"):
        folders = [path for path in (ROOT / name).iterdir()
                   if path.is_dir() and path.name != "__pycache__"]
        if len(folders) > 5:
            errors.append(f"folder-limit: {name} has {len(folders)}")
    return errors


def header_errors() -> list[str]:
    errors = []
    for path in managed_files():
        if path.suffix.lower() not in SOURCE:
            continue
        lines = path.read_text(encoding="utf-8-sig", errors="replace").splitlines()[:3]
        comments = ("#", "rem ", "'", "//")
        if not any(line.lower().startswith(comments) for line in lines):
            errors.append(f"header: {path.relative_to(ROOT)}")
    return errors
