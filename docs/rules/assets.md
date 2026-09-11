# 자산 안전 규칙

- 자료 또는 경로 작업 전에 ProPresenter 완전 종료.
- `Libraries`, `Playlists`, `Presets`, `Themes`, `Fonts`만 Git에 저장.
- `Media/Assets`는 Nextcloud에만 저장하고 Git 추가 금지.
- PC별 정보인 `Configuration`과 `.env` 커밋 금지.
- 재생목록과 `LibraryData`의 경로를 단순 문자열로 변경 금지.
- 경로 변경에는 파일 안의 경로 길이도 함께 바꾸는 `scripts/path.py` 사용.
- 운영 `Libraries`에 테스트용 곡이나 가짜 자료 생성 금지.
- 사용자 홈 경로는 `%USERPROFILE%` 또는 `$HOME`으로 표기.
