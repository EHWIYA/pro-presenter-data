# 재생목록 경로

| 사용하는 곳 | 경로 형식 |
|---|---|
| GitHub | `%USERPROFILE%\Documents\pro-presenter\…` |
| Windows PC | `C:\Users\<계정>\Documents\pro-presenter\…` |
| Mac | `/Users/<계정>/Documents/pro-presenter/…` |

`Playlists/Library`, `Playlists/Media`, `Libraries/LibraryData` 안의 경로는
Git에 저장할 때 `pp-paths` 필터로 공통 형식으로 바꾼다. ProPresenter를 열기
전에는 `smudge-files` 명령으로 현재 PC의 실제 경로를 적용한다.

- `git checkout`과 `git pull`은 파일의 경로를 자동으로 바꾸지 않는다.
- `Libraries/…`처럼 시작하는 경로는 Windows와 Mac에서 같은 `/`를 사용한다.
- 한글 경로는 운영체제가 달라도 같은 글자로 인식되도록 NFC 형식으로 맞춘다.
- 경로를 바꿀 때는 `file:` 주소와 ProPresenter 내부의 경로 길이도 함께 바꾼다.
- 단순 문자열 바꾸기는 파일을 손상할 수 있으므로 사용하지 않는다.
- 경로를 바꾸거나 `git pull`을 실행하기 전에 ProPresenter를 완전히 종료한다.

Mac에서 다시 저장한 `.pro`의 RTF 인코딩이 Windows와 다를 수 있다.
Windows에서 한글이 깨지면 해당 PC에서 열어 다시 저장하고 검증한다.
