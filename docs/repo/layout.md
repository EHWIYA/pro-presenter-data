# 저장소 구조

| OS | Show Directory |
|---|---|
| Windows | `%USERPROFILE%\Documents\pro-presenter` |
| Mac | `~/Documents/pro-presenter` |

Git working copy와 ProPresenter Show Directory는 같은 폴더다.

| 경로 | 정본 | 역할 |
|---|---|---|
| `Libraries/` | Git | `.pro` 슬라이드 |
| `Playlists/` | Git | PP UI 재생목록 |
| `Presets/`, `Themes/` | Git | 디자인 설정 |
| `Fonts/` | Git LFS | 설치용 글꼴 |
| `Media/Assets/` | Nextcloud | 영상·음원·이미지 |
| `Configuration/` | PC | 로컬 설정 |

PP의 Library, Support Files, Media 위치는 모두 Show Directory 하위로
맞춘다. `%APPDATA%\LocalWorkspaces`와 혼용하지 않는다.

Mac에서는 iCloud의 바탕화면 및 Documents 폴더 동기화를 꺼서 Git과
ProPresenter 잠금 충돌을 막는다. 경로 템플릿은
[paths.standard.json](../../paths.standard.json)에 있다.
