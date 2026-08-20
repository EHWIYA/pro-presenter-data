# Media/Assets → Nextcloud 이관 (2026-08-20 세션 기록)

다음 대화에서 이어갈 수 있도록 이번 작업 세션 내용을 정리한 문서.

## 문제였던 것

- `git pull`/`push`가 반복적으로 꼬임 → 원인은 **GitHub Git LFS 무료 대역폭(1GB/월) 초과**. `Media/Assets`(캠프 영상 등)가 LFS로 관리되며 계속 쌓여 한도를 넘김.
- 여러 PC(이 PC, `HWIYA-DESK`, Mac `이휘` 계정, GitHub 웹 `EHWIYA`)가 "작업 전 pull" 없이 각자 push해서 커밋이 자주 갈라짐.
- `.cursor/`가 남아있었음 — Cursor 더 이상 안 씀, Claude Code/Codex가 읽도록 정리 필요했음.

## 완료한 것

1. **`.cursor` → `AGENTS.md`/`CLAUDE.md` 통합** — `.cursor/rules/*.mdc` 내용을 `AGENTS.md`에 병합, `.cursor` 삭제, `CLAUDE.md` 신규(그냥 AGENTS.md 참조).
2. **`Media/Assets`를 Git/LFS에서 완전히 제외** — `.gitattributes`(Fonts만 LFS 유지)·`.gitignore` 수정, 기존 추적 파일 159개 `git rm --cached`.
3. **부수적으로 발견한 진짜 버그 수정**: `Playlists/Library`/`Media`에 다른 PC(`봉담중앙 방송실` 계정)의 하드코딩 절대경로가 clean 필터 없이 커밋되어 있던 것 발견 → portable(`%USERPROFILE%`)로 재정정 커밋.
4. **NAS에 이미 설치돼 있던 Nextcloud 발견·활용** — 새로 설치한 게 아니라 기존 인스턴스(`https://next-cloud.iwhya.kr`, 계정 `LEEHWI`)를 그대로 씀. `04_교회자료/PP_Media_Assets` 폴더 신규 생성, 로컬 미디어 6.8GB(159개 파일) 업로드 완료 (바이트 단위까지 대조 검증함).
5. **rclone bisync 기반 CLI 자동 동기화 구축** (GUI 클라이언트 대신):
   - `scripts/nextcloud-sync.bat`(Win) / `.sh`(Mac) — 실제 동기화 실행
   - `scripts/setup-nextcloud-sync-task.ps1` — Windows 작업 스케줄러 등록(로그온 시 1회)
   - `scripts/kr.iwhya.pp.nextcloudsync.plist` — Mac launchd 등록용
   - **이 PC(Windows)에서 전 과정 실제 실행·검증 완료** — 로컬↔NAS 양방향 테스트 파일로 업/다운로드·삭제 반영까지 확인함.
6. **비전공자용 설정 가이드를 `README.md` 최상단에 추가** — 다른 PC(HWIYA-DESK, Mac)에서 그대로 따라 하면 됨.

## 다음 대화에서 할 일 (아직 안 한 것)

- [ ] **다른 PC(`HWIYA-DESK`, Mac)에 Nextcloud 동기화 설정** — `README.md`의 "📹 영상·사진·음악 자동 동기화 설정하기" 섹션 그대로 따라가면 됨. 이 PC에서 실증된 절차라 안심 가능.
- [ ] **과거 Git LFS 이력(약 7.7GB) 정리 여부/시기 결정** — 지금은 미룬 상태. 하게 되면 history rewrite(force-push) 필요 → 다른 PC들은 그때 `git fetch && git reset --hard origin/main`으로 맞춰야 함(병합 시도 금지, `Playlists/Library`류 깨질 위험 있었음).
- [ ] 남은 git stash 2개(`sync-fix-backup`, `라이브러리 재구축 전 백업`) — 내용 diff 대조로 origin/main과 완전 중복임을 확인했음, 안전하게 지워도 됨(아직 안 지움, 만약을 위해 보존 중).

## 재사용할 핵심 정보

| 항목 | 값 |
|---|---|
| NAS SSH | `ssh my-nas` (이 PC `~/.ssh/config`에 이미 등록, Tailscale IP `100.88.40.125`, user `iwh`, docker 그룹 권한 있음·sudo는 비밀번호 필요해서 못 씀) |
| Nextcloud URL | https://next-cloud.iwhya.kr (계정 `LEEHWI`) |
| **로그인 시 주의** | 반드시 이메일 `dlgnl117@gmail.com`로 로그인해야 함. `LEEHWI`로 로그인하면 앱 비밀번호 토큰의 로그인 이름과 안 맞아 rclone 401 남 (`App token login name does not match` — 이번에 겪은 실제 버그) |
| PP 미디어 폴더 | Nextcloud `04_교회자료/PP_Media_Assets` |
| rclone remote 이름 | `pp-media` (url에 폴더 경로까지 통째로 넣어둠 — 아래 주의사항 참고) |
| Windows 작업 스케줄러 | `PP-NextcloudSync` (이 PC에 등록 완료, 로그온 트리거) |

**주의(교훈)**: Windows `.bat` 파일 안에 한글을 직접 쓰면 `chcp 65001`을 앞에 둬도 cmd.exe가 파싱 도중 깨지는 경우가 있었음(실제 발생·재현함). 그래서 `.bat`/`.sh`는 순수 ASCII만 쓰고, 한글이 들어가는 NAS 폴더 경로는 rclone remote 설정(`rclone.conf`의 `pp-media` url, `%EA%B5%90%ED%9A%8C...` 식 percent-encoding)에 미리 박아뒀음. 새 원격 만들 때도 이 방식 유지할 것.

## 참고 문서

- [../data/repo.md](../data/repo.md) — 이 repo의 Git/Nextcloud 동기화 정본 설명
- [../../README.md](../../README.md) — 비전공자용 설정 가이드
- [../../AGENTS.md](../../AGENTS.md) — 에이전트용 규칙 요약
