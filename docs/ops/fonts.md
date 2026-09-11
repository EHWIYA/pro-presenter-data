# 글꼴 설치

사용할 글꼴 파일은 `Fonts/`, 글꼴 목록은 `Fonts/manifest.json`에 저장.
ProPresenter가 폴더의 글꼴을 직접 읽지 않으므로 각 PC에 설치 필요.

| 운영체제 | 설치 위치 |
|---|---|
| Windows | `%WINDIR%\Fonts` 또는 사용자 글꼴 폴더 |
| Mac | `~/Library/Fonts/` 또는 Font Book |

`manifest.json`의 `pp_face_names` 중 하나라도 PC에서 보이면 설치 성공.
`used_in`에 사용처가 적힌 글꼴은 설치 필수.

| 파일 | PP 참조명 | 사용처 |
|---|---|---|
| `NanumGothic-Bold.ttf` | `NanumGothicBold` | `Themes/말씀` |
| `NanumGothic-ExtraBold.ttf` | `NanumGothicExtraBold` | 찬양·성가 |

`NanumGothic-Regular.ttf`는 추가 테마용 예비 글꼴.
설치 후 말씀과 찬양 테마 미리보기 확인.
