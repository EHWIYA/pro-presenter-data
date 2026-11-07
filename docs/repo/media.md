# Nextcloud 미디어

`Media/Assets`는 Git 대신 NAS Nextcloud의 `PP_Media_Assets`와 양방향 동기화.
사용 명령은 `rclone bisync`, Nextcloud 연결 이름은 `pp-media`.

## 처음 설정

1. rclone 설치하기.
2. Nextcloud 앱 비밀번호 만들기.
3. `rclone config`에서 Nextcloud용 WebDAV 연결 `pp-media` 등록하기.
4. 아래 초기 동기화 절차로 양쪽 파일과 변경 방향을 확인하기.
5. Windows에서는 `scripts/auto-setup.ps1`, Mac에서는 launchd plist 등록하기.

## 초기 동기화와 장애 복구

자동 스크립트는 `--resync`를 사용하지 않음. 연결 실패는 기존 상태를 유지하고
재시도하며, rclone이 재초기화를 요구하면 담당자가 로그를 확인하고 복구.
`--resilient --recover`로 검증된 이전 목록에서 복구를 시도하며,
자료 버전을 자동 선택하는 `--resync`로 전환하지 않음.
`.nextcloud-sync/resync-done`은 최근 성공 표시일 뿐, 재초기화 조건이 아님.

먼저 양쪽 자료를 별도 백업하고 같은 이름의 수정본을 비교해 보존할 버전 결정.
기본 `--resync`는 원격을 우선하므로 로컬 수정본이 덮어써질 수 있음.
Windows에서 원격 우선 복구가 맞는 경우에만 다음 미리보기 실행.

```powershell
rclone bisync pp-media: "$env:USERPROFILE\Documents\pro-presenter\Media\Assets" --resync --dry-run -v
```

변경 방향이 맞을 때 같은 명령에서 `--dry-run`을 빼고 한 번 실행.
Mac의 로컬 경로는 `$HOME/Documents/pro-presenter/Media/Assets` 사용.
다음부터는 `scripts/sync.bat` 또는 `scripts/sync.sh`로 일반 동기화.
Mac 스크립트도 실패 종료 코드를 반환하므로 실행 결과와 로그를 함께 확인.

## 운영 규칙

- `Media/Assets`의 `git add` 또는 커밋 금지.
- 미디어 파일 이름 변경 시 `.pro` 파일 안의 연결도 함께 변경.
- 실패 기록은 `.nextcloud-sync`에서 확인.
- `401`·`403`은 NAS의 Nextcloud 프록시와 WebDAV 권한 확인.
- `.bat`와 `.sh`에는 영문, 숫자, 기본 기호만 사용.
- 한글 NAS 경로는 rclone 연결 주소에 URL 인코딩 형식으로 저장.

GitHub의 대용량 파일 전송 한도를 넘어서 2026-08-20에 과거 미디어 파일을
Git 기록에서 제거. 글꼴 파일인 `.ttf`와 `.otf`만 Git LFS에 저장.
