# 글꼴 설치

글꼴 정본은 `Fonts/`와 `Fonts/manifest.json`이다. ProPresenter는 Show
Directory의 파일을 직접 읽지 않으므로 각 OS에 설치해야 한다.

| OS | 설치 위치 |
|---|---|
| Windows | `%WINDIR%\Fonts` 또는 사용자 글꼴 폴더 |
| Mac | `~/Library/Fonts/` 또는 Font Book |

manifest의 `pp_face_names` 중 하나라도 OS에서 확인되면 설치 성공이다.
`used_in`이 비어 있지 않은 항목은 필수 글꼴로 취급한다.

| 파일 | PP 참조명 | 사용처 |
|---|---|---|
| `NanumGothic-Bold.ttf` | `NanumGothicBold` | `Themes/말씀` |
| `NanumGothic-ExtraBold.ttf` | `NanumGothicExtraBold` | 찬양·성가 |

`NanumGothic-Regular.ttf`는 추가 테마용 예비 글꼴이다. 설치 후 말씀과
찬양 테마 미리보기를 확인한다.
