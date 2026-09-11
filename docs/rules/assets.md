# 자산 안전 규칙

- 자산 또는 경로 작업 전에 ProPresenter를 완전히 종료한다.
- `Libraries`, `Playlists`, `Presets`, `Themes`, `Fonts`만 Git 자산이다.
- `Media/Assets`는 Nextcloud 정본이며 Git에 추가하지 않는다.
- `Configuration`과 `.env`는 PC별 정보이므로 커밋하지 않는다.
- 재생목록과 `LibraryData`의 경로를 문자열 치환하지 않는다.
- 경로 변경은 `scripts/path.py`를 통해 길이 필드까지 갱신한다.
- 테스트용 곡이나 mock 자산을 운영 `Libraries`에 만들지 않는다.
- 사용자 홈 경로는 `%USERPROFILE%` 또는 `$HOME`으로 표현한다.
