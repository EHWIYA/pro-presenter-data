# Nextcloud 이관 기록

2026-08-20에 `Media/Assets`를 Git LFS에서 Nextcloud로 이전.

- GitHub의 대용량 파일 전송 한도 초과 원인 제거.
- 원격의 모든 브랜치에서 과거 미디어 기록 정리.
- 파일 159개, 약 6.8GB를 NAS와 대조해 검증.
- Windows에서 업로드, 다운로드, 삭제 반영 확인.
- Git 기록에서 분리된 대용량 파일 삭제를 GitHub 지원팀에 티켓
  `#4682683`으로 요청.
- `HWIYA-DESK`와 Mac의 Nextcloud 설정은 아직 필요.

현재 사용법은 [미디어 운영](../repo/media.md)과
[자동 동기화](sync.md)를 기준으로 사용.
