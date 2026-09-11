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


if __name__ == "__main__":
    unittest.main()
