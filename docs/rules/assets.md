# 자산 안전 규칙

- 자산 또는 경로 작업 전에 ProPresenter를 완전히 종료한다.
- `Libraries`, `Playlists`, `Presets`, `Themes`, `Fonts`만 Git에 저장한다.
- `Media/Assets`는 Nextcloud에만 저장하며 Git에 추가하지 않는다.
- `Configuration`과 `.env`는 PC별 정보이므로 커밋하지 않는다.
- 재생목록과 `LibraryData`의 경로를 문자열 치환하지 않는다.
- 경로는 `scripts/path.py`로 바꾼다. 이 명령은 파일 안의 경로 길이도 함께 바꾼다.
- 테스트용 곡이나 가짜 자산을 운영 `Libraries`에 만들지 않는다.
- 사용자 홈 경로는 `%USERPROFILE%` 또는 `$HOME`으로 표현한다.
