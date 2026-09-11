# Nextcloud 이관 기록

2026-08-20에 `Media/Assets`를 Git LFS에서 Nextcloud로 이전했다.

- GitHub의 대용량 파일 전송 한도를 넘기는 원인을 제거했다.
- 원격 전체 브랜치에서 과거 미디어 이력을 정리했다.
- 159개, 약 6.8GB를 NAS와 대조 검증했다.
- Windows에서 업로드, 다운로드, 삭제 반영을 실증했다.
- Git 기록에서 분리된 대용량 파일 삭제는 GitHub 지원팀에 티켓
  `#4682683`으로 요청했다.
- `HWIYA-DESK`와 Mac의 Nextcloud 설정은 아직 필요하다.

현재 사용법은 [미디어 운영](../repo/media.md)과
[자동 동기화](sync.md)를 기준으로 삼는다.
