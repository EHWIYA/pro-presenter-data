# ProPresenter 자산 저장소 작업 안내

이 저장소는 ProPresenter가 예배 자료를 읽고 저장하는 기본 폴더다.
GitHub에 저장된 내용이 기준이다.

## 시작 순서

1. ProPresenter가 완전히 종료됐는지 확인한다.
2. [기본 규칙](docs/rules/base.md)을 읽는다.
3. [작업별 문서 안내](docs/ctx/map.md)에서 필요한 문서만 읽는다.
4. 변경 전 테스트를 만들고 완료 전 전체 검사를 실행한다.

## 절대 금지

- `Media/Assets/`와 `Configuration/` 폴더를 Git에 추가하지 않는다.
- `git init`, `remote add`, 재생목록의 경로를 직접 바꾸지 않는다.
- 사용자마다 달라지는 홈 폴더는 직접 입력하지 않고 `%USERPROFILE%`을 사용한다.
- 이 저장소에서 웹 앱(PWA)이나 서버(BFF) 코드를 수정하지 않는다.
- 관련 없는 변경과 사용자의 기존 작업을 되돌리지 않는다.

## 빠른 명령

- 필요한 문서 조회는 `python scripts/ctx.py <topic>`을 사용한다.
- 전체 검사는 `python scripts/check.py`를 사용한다.
- 경로 변환은 `python scripts/path.py`만 사용한다.

문서 목차는 [docs/index.md](docs/index.md), 저장소 운영은
[docs/repo/git.md](docs/repo/git.md)를 참고한다.
