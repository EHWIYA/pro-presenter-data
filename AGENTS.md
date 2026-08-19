# AGENTS — pro-presenter-data

자산 Git repo. ProPresenter Show Directory 정본. (Cursor 사용 종료 — Claude Code·Codex 기준)

## 먼저 읽기

| 필요 시 | 문서 |
|---------|------|
| 시스템 개요 | [docs/system/overview.md](docs/system/overview.md) |
| 이 repo | [docs/data/repo.md](docs/data/repo.md) |
| 테마·재생목록 | [docs/handoff/theme-profiles.md](docs/handoff/theme-profiles.md) |
| 목차 | [docs/index.md](docs/index.md) |

맥락 질문 시 문서 먼저 — 없는 내용만 탐색·수정. 문서 내용을 채팅에 장문으로 재작성하지 말 것 — 링크·한두 줄 요약.

## 빠른 참조

| 항목 | 값 |
|------|-----|
| 원격 | `github.com/EHWIYA/pro-presenter-data` |
| 경로 | `%USERPROFILE%\Documents\pro-presenter` |
| PP UI | 재생목록 → `Libraries/*.pro` |
| 신규 PC | Win: `scripts/setup-git-filters.ps1` · Mac: `scripts/setup-git-filters.sh` |
| 미디어(Media/Assets) | Git 아님 — Nextcloud (신규 PC 1회: 클라이언트 설치 + 폴더 지정) |

## 워크스페이스 경계

| 작업 | 위치 |
|------|------|
| PP 자산 Git | **여기** |
| PWA·BFF | 각각 별 repo — **여기서 수정 안 함** |

## 하지 말 것

- `Media/Assets/` git commit 금지 (Nextcloud 관리 — Git LFS 대역폭 한도 초과로 이관됨)
- `Configuration/` `.env` commit 금지
- `git init` / `remote add` 재실행 금지 — 이미 완료
- 재생목록 경로 수동 문자열 치환 금지 — protobuf 길이 필드 깨져 재생목록 소실 위험, 반드시 `scripts/pp_path_normalize.py` 사용
- 작업 전 ProPresenter **완전 종료**
- `C:\Users\사용자명\...` 하드코딩 금지 — `%USERPROFILE%` 사용

## 완료됨 — 재실행 금지

Git init·origin·첫 push · `docs/` 정본화
