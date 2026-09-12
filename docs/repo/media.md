# Nextcloud 미디어

`Media/Assets`는 Git 대신 NAS Nextcloud의 `PP_Media_Assets`와 양방향 동기화.
사용 명령은 `rclone bisync`, Nextcloud 연결 이름은 `pp-media`.

## 처음 설정

1. rclone 설치하기.
2. Nextcloud 앱 비밀번호 만들기.
3. `rclone config`에서 Nextcloud용 WebDAV 연결 `pp-media` 등록하기.
4. Windows에서는 `scripts/auto-setup.ps1` 실행하기.
5. Mac에서는 자동 실행 설정 파일인 launchd plist 등록하기.

## 운영 규칙

- `Media/Assets`의 `git add` 또는 커밋 금지.
- 미디어 파일 이름 변경 시 `.pro` 파일 안의 연결도 함께 변경.
- 실패 기록은 `.nextcloud-sync`에서 확인.
- `401`·`403`은 NAS의 Nextcloud 프록시와 WebDAV 권한 확인.
- `.bat`와 `.sh`에는 영문, 숫자, 기본 기호만 사용.
- 한글 NAS 경로는 rclone 연결 주소에 URL 인코딩 형식으로 저장.

GitHub의 대용량 파일 전송 한도를 넘어서 2026-08-20에 과거 미디어 파일을
Git 기록에서 제거. 글꼴 파일인 `.ttf`와 `.otf`만 Git LFS에 저장.
