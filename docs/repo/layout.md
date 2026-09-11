# 폴더 구조

| 운영체제 | ProPresenter 기본 폴더 |
|---|---|
| Windows | `%USERPROFILE%\Documents\pro-presenter` |
| Mac | `~/Documents/pro-presenter` |

Git으로 관리하는 폴더와 ProPresenter가 사용하는 기본 폴더는 같다.

| 경로 | 저장 위치 | 역할 |
|---|---|---|
| `Libraries/` | GitHub | `.pro` 슬라이드 파일 |
| `Playlists/` | GitHub | ProPresenter 화면의 재생목록 |
| `Presets/`, `Themes/` | Git | 디자인 설정 |
| `Fonts/` | GitHub 대용량 파일 저장소 | 설치용 글꼴 |
| `Media/Assets/` | Nextcloud | 영상·음원·이미지 |
| `Configuration/` | 각 PC | 해당 PC에서만 쓰는 설정 |

ProPresenter의 Library, Support Files, Media 위치는 모두 이 기본 폴더
아래로 맞춘다. `%APPDATA%\LocalWorkspaces`와 함께 사용하지 않는다.

Mac에서는 iCloud의 바탕화면 및 Documents 폴더 동기화를 꺼서 Git과
ProPresenter 잠금 충돌을 막는다. 경로 템플릿은
[paths.standard.json](../../paths.standard.json)에 있다.
