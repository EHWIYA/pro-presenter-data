# ProPresenter 자산 저장소 작업 안내

ProPresenter가 예배 자료를 읽고 저장하는 기본 폴더.
GitHub에 저장된 내용을 기준으로 사용.

## 시작 순서

1. ProPresenter가 완전히 종료됐는지 확인하기.
2. [기본 규칙](docs/rules/base.md) 읽기.
3. [작업별 문서 안내](docs/ctx/map.md)에서 필요한 문서만 읽기.
4. 변경 전 테스트 작성 후 완료 전에 전체 검사 실행하기.

## 절대 금지

- `Media/Assets/`와 `Configuration/` 폴더의 Git 추가 금지.
- `git init`, `remote add`, 재생목록 경로의 직접 변경 금지.
- 사용자마다 달라지는 홈 폴더 대신 `%USERPROFILE%` 사용.
- 관련 없는 변경과 사용자의 기존 작업 되돌리기 금지.

## 빠른 명령

- 필요한 문서 조회에는 `python scripts/ctx.py <topic>` 사용.
- 전체 검사에는 `python scripts/check.py` 사용.
- 경로 변환에는 `python scripts/path.py`만 사용.

문서 목차는 [docs/index.md](docs/index.md), 저장소 운영은
[docs/repo/git.md](docs/repo/git.md) 참고.
