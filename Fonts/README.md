# ProPresenter 글꼴

ProPresenter 문서는 글꼴 파일을 직접 담지 않고 PC에 설치된 글꼴 이름만
기억한다. 모든 현장 PC는 이 폴더의 같은 글꼴 파일을 설치해야 한다.
설치 방법은 [글꼴 설치 안내](../docs/ops/fonts.md)에 있다.

## 포함 글꼴

| 파일 | PP 참조명 | 용도 |
|------|-----------|------|
| `NanumGothic-Regular.ttf` | `NanumGothic`, `NanumGothicR` | 예비 글꼴이며 현재 테마에서는 사용하지 않는다. |
| `NanumGothic-Bold.ttf` | `NanumGothicBold`, `NanumGothicBoldR` | 말씀 테마 |
| `NanumGothic-ExtraBold.ttf` | `NanumGothicExtraBold`, `NanumGothicExtraBoldR` | 찬양·성가 테마 |

`manifest.json`에는 프로그램이 읽는 글꼴 정보가 있다. 사용 조건은
`OFL.txt`의 SIL Open Font License 1.1을 따른다.

## 글꼴 추가·변경

1. `.ttf` 또는 `.otf` 파일을 `Fonts/`에 추가한다.
2. `manifest.json`의 `pp_face_names`와 `used_in`을 수정한다.
3. ProPresenter의 `Themes/`에서 새 글꼴로 디자인하고 Git에 저장한다.
4. 별도 자동화 저장소에서 `export_theme_snapshot.py`를 실행해
   `template/themes/`를 다시 맞춘다.

ProPresenter에 보이는 이름과 PC에 설치된 글꼴 이름이 같아야 한다.
변경 후에는 `manifest.json`을 기준으로 설치 결과를 확인한다.
