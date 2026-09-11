# ProPresenter 글꼴

ProPresenter 문서는 글꼴 파일 대신 PC에 설치된 글꼴 이름만 기억.
모든 현장 PC에 이 폴더의 같은 글꼴 파일 설치 필요.
설치 방법은 [글꼴 설치 안내](../docs/ops/fonts.md) 참고.

## 포함 글꼴

| 파일 | PP 참조명 | 용도 |
|------|-----------|------|
| `NanumGothic-Regular.ttf` | `NanumGothic`, `NanumGothicR` | 현재 테마에서 사용하지 않는 예비 글꼴 |
| `NanumGothic-Bold.ttf` | `NanumGothicBold`, `NanumGothicBoldR` | 말씀 테마 |
| `NanumGothic-ExtraBold.ttf` | `NanumGothicExtraBold`, `NanumGothicExtraBoldR` | 찬양·성가 테마 |

프로그램이 읽는 글꼴 정보는 `manifest.json`에 저장.
사용 조건은 `OFL.txt`의 SIL Open Font License 1.1 적용.

## 글꼴 추가·변경

1. `.ttf` 또는 `.otf` 파일을 `Fonts/`에 추가하기.
2. `manifest.json`의 `pp_face_names`와 `used_in` 수정하기.
3. ProPresenter의 `Themes/`에서 새 글꼴로 디자인하고 Git에 저장하기.
4. 별도 자동화 저장소에서 `export_theme_snapshot.py`를 실행해
   `template/themes/` 다시 맞추기.

ProPresenter에 보이는 이름과 PC에 설치된 글꼴 이름의 일치 필수.
변경 후 `manifest.json`을 기준으로 설치 결과 확인.
