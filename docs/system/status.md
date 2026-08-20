# 현재 상태 (2026-08-20)

| 영역 | 상태 |
|------|------|
| PWA 호스팅 | ✅ pro-app.iwhya.kr |
| NAS API | ✅ GHCR :main, Postgres 곡 DB |
| pro-presenter-agent | ❌ 제거 |
| 자산 repo | ✅ pro-presenter-data (`Documents/pro-presenter`) |
| 재생목록 경로 | ✅ `pp-paths` filter · Win/Mac setup 스크립트 (PC당 1회) |
| 경로 smudge | ✅ checkout identity · PP 직전 `smudge-files` · Mac `file://%2F` clean (2026-08-02) |
| Git LFS 대역폭 초과 | ✅ 해결 — `Media/Assets` Git 추적 제외, NAS Nextcloud로 이관 (2026-08-20) |
| Media/Assets 동기화 | ✅ 이 PC(Win) rclone bisync 자동화 완료 · ⏳ `HWIYA-DESK`·Mac 미설정 — 상세: [../handoff/nextcloud-media-sync.md](../handoff/nextcloud-media-sync.md) |
| 예배 세션 자동 동기화 | ✅ 이 PC(Win) 로그인·ProPresenter 종료 자동화 적용 · ⏳ 다른 PC 미설정 — 상세: [../handoff/auto-session-sync.md](../handoff/auto-session-sync.md) |
| Cursor 사용 | ❌ 종료 — `.cursor` 제거, `AGENTS.md`/`CLAUDE.md`로 통합 (2026-08-20) |

갱신 시 이 파일만 수정. 스냅샷 날짜를 표제에 반영.
