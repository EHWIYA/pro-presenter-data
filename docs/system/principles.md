# 제품 원칙 (변경 금지)

| 원칙 | 내용 |
|------|------|
| 1회만 사람 | PP 템플릿·테마 디자인 (reader + reader-context) |
| 송출 | ProPresenter UI에서 수동 송출 |
| 다교회 | NAS 1대 + 교회 PC마다 PP Show Directory(data) |
| BFF 경계 | PWA는 pro-api만 호출. PP :12135 직접 호출 금지 |
| 자산 정본 | `pro-presenter-data` Git — `Libraries/` `Playlists/` `Themes/` `Media/Assets/` |
