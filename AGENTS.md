# ProPresenter 자산 저장소 작업 안내

이 저장소는 ProPresenter Show Directory 정본이다.

## 시작 순서

1. ProPresenter가 완전히 종료됐는지 확인한다.
2. [기본 규칙](docs/rules/base.md)을 읽는다.
3. [문맥 지도](docs/ctx/map.md)에서 작업별 문서만 읽는다.
4. 변경 전 테스트를 만들고 완료 전 전체 검사를 실행한다.

## 절대 금지

- `Media/Assets/`와 `Configuration/`을 Git에 넣지 않는다.
- `git init`, `remote add`, 재생목록 문자열 수동 치환을 하지 않는다.
- 사용자 경로를 하드코딩하지 않고 `%USERPROFILE%`을 사용한다.
- 이 저장소에서 PWA나 BFF 코드를 수정하지 않는다.
- 관련 없는 변경과 사용자의 기존 작업을 되돌리지 않는다.

## 빠른 명령

- 문맥 조회는 `python scripts/ctx.py <topic>`을 사용한다.
- 전체 검사는 `python scripts/check.py`를 사용한다.
- 경로 변환은 `python scripts/pp_path_normalize.py`만 사용한다.

문서 목차는 [docs/index.md](docs/index.md), 저장소 운영은
[docs/repo/git.md](docs/repo/git.md)를 참고한다.
