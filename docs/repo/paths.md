# 재생목록 경로

| 사용하는 곳 | 경로 형식 |
|---|---|
| GitHub | `%USERPROFILE%\Documents\pro-presenter\…` |
| Windows PC | `C:\Users\<계정>\Documents\pro-presenter\…` |
| Mac | `/Users/<계정>/Documents/pro-presenter/…` |

`Playlists/Library`, `Playlists/Media`, `Libraries/LibraryData` 안의 경로는
Git에 저장할 때 `pp-paths` 기능으로 공통 형식으로 변환. ProPresenter를 열기
전에는 `smudge-files` 명령으로 현재 PC의 실제 경로 적용.

- `git checkout`과 `git pull`은 파일의 경로를 자동으로 바꾸지 않음.
- `Libraries/…`처럼 시작하는 경로는 Windows와 Mac에서 같은 `/` 사용.
- 한글 경로는 운영체제가 달라도 같은 글자로 인식되는 NFC 형식으로 통일.
- 경로 변경 시 `file:` 주소와 ProPresenter 내부의 경로 길이도 함께 변경.
- 파일 손상을 막기 위해 단순 문자열 바꾸기 금지.
- 경로 변경이나 `git pull` 실행 전에 ProPresenter 완전 종료.

Mac에서 다시 저장한 `.pro`의 글자 저장 형식이 Windows와 다를 수 있음.
Windows에서 한글이 깨지면 해당 PC에서 열어 다시 저장하고 확인.
