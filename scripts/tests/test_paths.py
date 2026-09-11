# ProPresenter 경로 변환기의 핵심 동작을 합성 protobuf로 검증한다.
import importlib.util
import pathlib
import unicodedata
import unittest

SCRIPT = pathlib.Path(__file__).parents[1] / "pp_path_normalize.py"
SPEC = importlib.util.spec_from_file_location("pp_path_normalize", SCRIPT)
pp = importlib.util.module_from_spec(SPEC)
assert SPEC.loader
SPEC.loader.exec_module(pp)


def field(value: str) -> bytes:
    raw = value.encode("utf-8")
    return b"\x0a" + pp.encode_varint(len(raw)) + raw


class PathTests(unittest.TestCase):
    def test_clean_and_smudge_round_trip(self):
        source = pp.runtime_root() + r"\Libraries\찬양\곡.pro"
        clean = pp.transform(field(source), "clean")
        self.assertIn(pp.PORTABLE_ROOT.encode(), clean)
        self.assertEqual(pp.transform(clean, "smudge"), field(source))

    def test_relative_library_path_uses_slashes(self):
        source = field(r"Libraries\찬양\곡.pro")
        self.assertIn("Libraries/찬양/곡.pro".encode(), pp.transform(source, "clean"))

    def test_hangul_is_nfc(self):
        decomposed = unicodedata.normalize("NFD", "Libraries/찬양/곡.pro")
        out = pp.transform(field(decomposed), "clean")
        self.assertIn("Libraries/찬양/곡.pro".encode(), out)

    def test_malformed_input_is_unchanged(self):
        broken = b"\x0a\xff"
        self.assertEqual(pp.transform(broken, "clean"), broken)


if __name__ == "__main__":
    unittest.main()
