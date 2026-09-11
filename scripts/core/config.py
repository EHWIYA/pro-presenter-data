# 경로 변환 대상과 운영체제별 루트 설정을 제공한다.
import pathlib
import sys

TARGETS = ("Playlists/Library", "Playlists/Media", "Libraries/LibraryData")
PORTABLE_ROOT = "%USERPROFILE%\\Documents\\pro-presenter"
PORTABLE_ROOT_POSIX = "%USERPROFILE%/Documents/pro-presenter"
HOME_PORTABLE = "$HOME/Documents/pro-presenter"
HOME_PORTABLE_WIN = "$HOME\\Documents\\pro-presenter"
LEGACY_USER_PREFIX = "C:\\Users\\봉담중앙 방송실"
SHOW_MARKER = "Documents\\pro-presenter"
FILE_QUOTE_SAFE = " .-_()[]$@&,+=#"


def is_windows() -> bool:
    return sys.platform == "win32"


def runtime_root() -> str:
    path = pathlib.Path.home() / "Documents" / "pro-presenter"
    return str(path) if is_windows() else path.as_posix()


def repo_root() -> pathlib.Path:
    return pathlib.Path(__file__).resolve().parents[2]
