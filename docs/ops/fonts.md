# 글꼴 설치

사용할 글꼴 파일은 `Fonts/`에 있고 글꼴 목록은 `Fonts/manifest.json`에 있다.
ProPresenter는 이 폴더의 글꼴을 직접 읽지 않으므로 각 PC에 설치해야 한다.

| 운영체제 | 설치 위치 |
|---|---|
| Windows | `%WINDIR%\Fonts` 또는 사용자 글꼴 폴더 |
| Mac | `~/Library/Fonts/` 또는 Font Book |

manifest의 `pp_face_names` 중 하나라도 OS에서 확인되면 설치 성공이다.
`used_in`에 사용처가 적혀 있는 글꼴은 반드시 설치한다.

| 파일 | PP 참조명 | 사용처 |
|---|---|---|
| `NanumGothic-Bold.ttf` | `NanumGothicBold` | `Themes/말씀` |
| `NanumGothic-ExtraBold.ttf` | `NanumGothicExtraBold` | 찬양·성가 |

`NanumGothic-Regular.ttf`는 추가 테마용 예비 글꼴이다. 설치 후 말씀과
찬양 테마 미리보기를 확인한다.
