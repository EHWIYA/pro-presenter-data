# Markdown 상대 링크가 실제 저장소 파일을 가리키는지 검사한다.
import re

from .policy import ROOT

LINK = re.compile(r"\[[^]]+\]\(([^)]+)\)")


def link_errors() -> list[str]:
    errors = []
    files = [ROOT / "AGENTS.md", ROOT / "README.md", *(ROOT / "docs").rglob("*.md")]
    for document in files:
        text = document.read_text(encoding="utf-8-sig")
        for target in LINK.findall(text):
            if target.startswith(("http://", "https://", "#")):
                continue
            clean = target.split("#", 1)[0].strip("<>")
            if clean and not (document.parent / clean).resolve().exists():
                relative = document.relative_to(ROOT)
                errors.append(f"link: {relative} -> {target}")
    return errors
