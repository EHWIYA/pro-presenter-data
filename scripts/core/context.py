# 주제별 문맥 캐시를 읽고 정본 문서의 해시를 관리한다.
import hashlib
import json
import pathlib

ROOT = pathlib.Path(__file__).resolve().parents[2]
TOPICS = ROOT / "docs" / "ctx" / "topics.json"
HASHES = ROOT / "docs" / "ctx" / "hashes.json"


def load_topics() -> dict:
    return json.loads(TOPICS.read_text(encoding="utf-8"))


def topic_files() -> list[str]:
    files = {"docs/ctx/topics.json"}
    for entry in load_topics().values():
        files.update(entry["files"])
    return sorted(files)


def digest(relative: str) -> str:
    content = (ROOT / relative).read_bytes().replace(b"\r\n", b"\n")
    return hashlib.sha256(content).hexdigest()[:12]


def current_hashes() -> dict[str, str]:
    return {relative: digest(relative) for relative in topic_files()}


def refresh() -> None:
    text = json.dumps(current_hashes(), ensure_ascii=False, indent=2) + "\n"
    HASHES.write_text(text, encoding="utf-8")


def stale() -> list[str]:
    if not HASHES.exists():
        return ["docs/ctx/hashes.json is missing"]
    saved = json.loads(HASHES.read_text(encoding="utf-8"))
    current = current_hashes()
    return [path for path in sorted(set(saved) | set(current))
            if saved.get(path) != current.get(path)]
