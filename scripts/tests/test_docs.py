# 초보자용 문서 작성 규칙이 유지되는지 검증한다.
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[2]


class DocumentationRuleTests(unittest.TestCase):
    def test_beginner_language_rules_are_explicit(self):
        text = (ROOT / "docs/rules/docs.md").read_text(encoding="utf-8-sig")
        for phrase in ("비전공자", "명사형으로 끝내기", "행동은 `~하기`", "전문용어"):
            with self.subTest(phrase=phrase):
                self.assertIn(phrase, text)

    def test_retired_web_architecture_is_absent(self):
        files = [ROOT / "AGENTS.md", ROOT / "README.md"]
        files += list((ROOT / "docs").rglob("*.md"))
        files += [ROOT / "docs/ctx/topics.json", ROOT / "paths.standard.json"]
        retired = (
            "pro-app.iwhya.kr",
            "pro-api.iwhya.kr",
            "pro-presenter-front-end",
            "pro-presenter-back-end",
            "휴대폰 웹 화면",
            "PWA",
            "BFF",
        )
        text = "\n".join(path.read_text(encoding="utf-8-sig") for path in files)
        for phrase in retired:
            with self.subTest(phrase=phrase):
                self.assertNotIn(phrase, text)


if __name__ == "__main__":
    unittest.main()
