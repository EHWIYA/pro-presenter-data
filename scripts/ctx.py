# 주제별 핵심 문맥과 현재 Git 상태를 짧게 출력한다.
import argparse
import subprocess

from core.context import ROOT, load_topics


def git(*arguments: str) -> str:
    result = subprocess.run(["git", *arguments], cwd=ROOT, text=True,
                            capture_output=True, check=False)
    return result.stdout.strip()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("topic", nargs="?", default="system")
    parser.add_argument("--full", action="store_true")
    args = parser.parse_args()
    topics = load_topics()
    if args.topic not in topics:
        print("topics=" + ",".join(sorted(topics)))
        return 2
    entry = topics[args.topic]
    print(f"topic={args.topic}")
    print(f"summary={entry['summary']}")
    print("docs=" + ",".join(entry["files"]))
    print("branch=" + git("branch", "--show-current"))
    changes = git("status", "--short").splitlines()
    print(f"changes={len(changes)}")
    if args.full:
        for relative in entry["files"]:
            print(f"\n# {relative}\n")
            print((ROOT / relative).read_text(encoding="utf-8").rstrip())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
