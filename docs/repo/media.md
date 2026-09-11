# Nextcloud 미디어

`Media/Assets`는 Git이 아니라 NAS Nextcloud의 `PP_Media_Assets`와
`rclone bisync` 명령으로 양쪽의 변경을 서로 동기화한다. rclone에 등록할
Nextcloud 연결 이름은 `pp-media`다.

## 처음 설정

1. rclone을 설치한다.
2. Nextcloud 앱 비밀번호를 만든다.
3. `rclone config`에서 Nextcloud용 WebDAV 연결 `pp-media`를 등록한다.
4. Windows는 `scripts/auto-setup.ps1`을 실행한다.
5. Mac은 자동 실행 설정 파일인 launchd plist를 등록한다.

## 운영 규칙

- `Media/Assets`를 `git add`하거나 커밋하지 않는다.
- 미디어 파일 이름을 바꿀 때는 `.pro` 파일 안의 연결도 함께 바꾼다.
- 실패 로그는 `.nextcloud-sync`에서 확인한다.
- `.bat`와 `.sh`에는 ASCII만 사용한다.
- NAS 경로에 한글이 있으면 rclone 연결 주소에 URL 인코딩 형식으로 저장한다.

GitHub의 대용량 파일 전송 한도를 넘어서 2026-08-20에 과거 미디어 파일을
Git 기록에서 제거했다. 글꼴 파일인 `.ttf`와 `.otf`만 Git LFS에 저장한다.
