# 재생목록 경로

| 위치 | 경로 형식 |
|---|---|
| Git 정본 | `%USERPROFILE%\Documents\pro-presenter\…` |
| Windows 작업 트리 | `C:\Users\<계정>\Documents\pro-presenter\…` |
| Mac 작업 트리 | `/Users/<계정>/Documents/pro-presenter/…` |

`Playlists/Library`, `Playlists/Media`, `Libraries/LibraryData`는
`pp-paths` clean filter와 명시적 `smudge-files`로 변환한다.

- checkout과 pull의 smudge filter는 identity다.
- 상대 `Libraries/…` 경로는 OS 공통 슬래시를 사용한다.
- 한글 경로는 NFC로 정규화한다.
- `file:` URL과 protobuf 길이 필드를 함께 갱신한다.
- 문자열 치환은 길이 필드를 깨뜨리므로 금지한다.
- 변환 또는 pull 전에 ProPresenter를 완전히 종료한다.

Mac에서 다시 저장한 `.pro`의 RTF 인코딩이 Windows와 다를 수 있다.
Windows에서 한글이 깨지면 해당 PC에서 열어 다시 저장하고 검증한다.
