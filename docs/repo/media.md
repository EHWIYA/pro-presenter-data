# Nextcloud 미디어

`Media/Assets`는 Git이 아니라 NAS Nextcloud의 `PP_Media_Assets`와
`rclone bisync`로 양방향 동기화한다. 원격 이름은 `pp-media`다.

## 처음 설정

1. rclone을 설치한다.
2. Nextcloud 앱 비밀번호를 만든다.
3. `rclone config`에서 WebDAV 원격 `pp-media`를 등록한다.
4. Windows는 `scripts/setup-auto-sync-windows.ps1`을 실행한다.
5. Mac은 제공된 launchd plist를 등록한다.

## 운영 규칙

- `Media/Assets`를 Git stage 또는 commit하지 않는다.
- 미디어 파일명은 `.pro` 참조와 함께 관리한다.
- 실패 로그는 `.nextcloud-sync`에서 확인한다.
- `.bat`와 `.sh`에는 ASCII만 사용한다.
- 한글 NAS 경로는 rclone 원격 URL에 percent-encoding으로 저장한다.

Git LFS 대역폭 문제로 미디어 이력은 2026-08-20 제거됐다. 글꼴의
`.ttf`와 `.otf`만 Git LFS를 계속 사용한다.
