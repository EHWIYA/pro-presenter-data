# Handoff → pro-presenter-agent (에이전트 repo Cursor용)

**이 문서를 `C:\pro-presenter-agent` 워크스페이스 Cursor 대화에 붙여넣으세요.**  
자산 repo(`Documents\pro-presenter`) 쪽에서 작성·유지합니다. **코드 변경은 에이전트 repo에서만** 진행.

---

## 1. 프로젝트 한 줄 요약

교회 현장 PC에서 **ProPresenter 7** 예배를 **NAS·모바일**과 연동.  
**코드(에이전트)** 와 **PP 파일(Git 자산)** 은 repo·폴더가 **완전히 분리**되어 있다.

---

## 2. Repo · 폴더 (절대 혼동 금지)

| | GitHub | 로컬 | Git에 올리는 것 |
|--|--------|------|----------------|
| **에이전트 (너의 워크스페이스)** | EHWIYA/pro-presenter-agent | `C:\pro-presenter-agent` | Python, config.json, template/, scripts/ |
| **PP 자산 (다른 repo)** | EHWIYA/pro-presenter-data | `%USERPROFILE%\Documents\pro-presenter` | Libraries/, Playlists/, Presets/, Themes/ |

- 에이전트를 `Documents\pro-presenter` **안에 넣지 않음**
- Git remote·commit은 **repo마다 따로**

---

## 3. PP 콘텐츠 모델 (2026~, 중요)

### worship-2 단일 정본 → **종료**

과거: `presentations/worship-2.pro`(agent repo) ↔ PP 라이브러리 복사, `repo-pull`/`repo-push`

**현재:**

```
Documents\pro-presenter\
  Playlists/     ← PP UI에 보이는 재생목록 (Git)
  Libraries/     ← .pro 실체 — 재생목록이 여기 파일 참조 (Git)
  Themes/        ← PP UI 테마 (Git)
  Media/         ← Git 제외
  Configuration/ ← Git 제외 (PC별)
```

- PP 화면 = **재생목록** 기준
- `Playlists/Library` 등이 `Libraries/예배/시작 전.pro` 형태로 참조
- 에이전트 **빌드**는 config의 `pp_library_dir` 아래 `.pro`에 기록
- **빌드 템플릿** = agent repo `template/` (PP `Themes/`와 **별개**)

### 테마 두 종류

| 위치 | 역할 | repo |
|------|------|------|
| `C:\pro-presenter-agent\template\themes\*.pro` | 슬라이드 1장 복제 후 본문 채움 | agent |
| `Documents\pro-presenter\Themes\` | PP UI 테마 | data |

---

## 4. launch-worship.bat — 예배 시작 (이미 구현됨, 문서화 필요)

**표준 진입점:** `launch-worship.bat` → `scripts/launch-worship.ps1`

### 실행 순서

1. **에이전트 시작** (`Start-VenueAgent` → `:8787`)
2. **자산 Git sync** — ProPresenter **실행 전**
3. **ProPresenter 시작**
4. PP 종료 → **에이전트 종료**

### Git sync (런처 업무 — Python 아님)

- 파일: `scripts/lib/assets-git-sync.ps1`, `scripts/sync-assets-repo.ps1`
- `launch-worship.ps1`에서 PP 시작 **직전** 호출
- 동작: `git fetch` → (dirty면 stash) → **`git pull --rebase origin main`**
- 대상: `config.json` → `pp_show_directory` (기본 `%USERPROFILE%\Documents\pro-presenter`)

| 조건 | 동작 |
|------|------|
| `sync_assets_on_launch: true` | pull 시도 |
| PP **이미 실행 중** | pull **skip** (`.pro` 잠금) |
| `-SkipAssetsSync` / `-AgentOnly` | pull skip |
| rebase 충돌 | launch 중단, 수동 `git rebase --continue` |

**PP.exe 직접 실행** → pull 없음. **`launch-worship.bat` 권장.**

### 에이전트 vs 런cher

| 담당 | 업무 |
|------|------|
| **에이전트 (Python)** | NAS, `/build`, `/trigger`, `.pro` 생성·배포 |
| **런처 (PowerShell)** | PP↔에이전트 생명주기, **자산 repo git pull** |

---

## 5. config.json (현장 PC — 이미 로컬 반영됨, agent repo에 commit 필요할 수 있음)

경로는 **`%USERPROFILE%`만** PC마다 다름. 사용자명 하드코딩 금지.

```json
{
  "pp_show_directory": "%USERPROFILE%\\Documents\\pro-presenter",
  "pp_library_dir": "%USERPROFILE%\\Documents\\pro-presenter\\Libraries\\예배",
  "sync_assets_on_launch": true,
  "sync_assets_stash_dirty": true,
  "presentation_filename": "worship-2.pro",
  "presentation_repo_path": "%USERPROFILE%\\Documents\\pro-presenter\\Libraries\\예배\\worship-2.pro",
  "template_pro": "template/worship-template.pro",
  "themes_repo_dir": "template/themes",
  "copy_to_library": true,
  "sync_built_to_repo": true,
  "nas_api": "http://100.88.40.125:8003",
  "agent_port": 8787,
  "pp_api": "http://127.0.0.1:12135"
}
```

- `pp_library_subdir`(예: `예배`)는 현장마다 다를 수 있음
- 자산 repo `paths.standard.json`과 정합 유지
- `patch-config.ps1` / `collect-venue-info.ps1` 실행 시 경로 **덮어쓰기 주의**

---

## 6. 이미 agent repo 로컬에 들어간 코드 (commit/push 검토)

자산 repo Cursor가 이전에 **로컬만** 수정했을 수 있음. agent repo에서 `git status` 확인:

| 파일 | 내용 |
|------|------|
| `scripts/lib/assets-git-sync.ps1` | **신규** — git pull --rebase |
| `scripts/sync-assets-repo.ps1` | **신규** — 수동 sync |
| `scripts/launch-worship.ps1` | PP 전 `Sync-AssetsRepository` 호출 |
| `scripts/patch-config.ps1` | `Documents\pro-presenter` 탐색, `%USERPROFILE%` portable |
| `pro_presenter_agent/domain/config.py` | `pp_show_directory`, sync 플래그, 경로 확장 |
| `pro_presenter_agent/infrastructure/venue_discovery.py` | pro-presenter 우선 탐색 |
| `config.json` / `config.example.json` | 신규 경로 키 |

**에이전트 repo Cursor 할 일:** 위 변경 검토 → commit/push → README/AGENTS.md/.cursor 반영 (아래 §8)

---

## 7. 워크플로

| 작업 | 어디서 |
|------|--------|
| 예배 시작 (pull+agent+PP) | `launch-worship.bat` |
| 수동 pull | `scripts\sync-assets-repo.ps1` (PP 종료 후) |
| 예배 후 자산 공유 | `Documents\pro-presenter` → git commit/push |
| 성경 빌드 | `python -m pro_presenter_agent build` → `Libraries\…\*.pro` |
| 점검 | `GET http://127.0.0.1:8787/collect-info` |

### 레거시 (사용 줄임)

- `presentations/worship-2.pro` — agent repo 옛 정본
- `repo-pull` / `repo-push` — library path = repo path면 불필요
- README의 worship-2 중심 설명 — **재생목록 모델로 갱신 필요**

---

## 8. 에이전트 repo Cursor에게 요청할 작업

1. **§6 로컬 변경** git status → commit/push
2. **`AGENTS.md`** 생성 — Cursor 진입 (자산 repo `docs/HANDOFF-TO-AGENT-REPO.md` 요약 + agent 관점)
3. **`docs/PROJECT-CONTEXT.md`** — 전체 맥락 정본
4. **`.cursor/rules/`** — repo 분리, launch+git sync, 경로 규칙
5. **README.md** — worship-2 중심 문구 → 재생목록·launch pull 반영
6. (선택) `collect-venue-info.ps1`이 `%APPDATA%`로 config 덮어쓰지 않게 pro-presenter 우선

---

## 9. ProPresenter Settings (GUI, 현장 PC 수동)

- Library / Support Files / Media → `Documents\pro-presenter` 하위
- `%APPDATA%\LocalWorkspaces` 혼용 금지

---

## 10. NAS (참고, agent 쪽 변경 보통 불필요)

- `venues.json`: `pp_library_name`, `pp_library_id` — REST UUID fallback
- `.pro` 경로와 무관

---

## 11. 하지 말 것

- `Documents\pro-presenter`에 agent `.venv` / config 넣기
- Media/, Configuration/ 을 data repo에 commit
- `C:\Users\사용자명\...` 경로 하드코딩
- 두 repo git remote 혼동

---

## 12. 자산 repo 참고 파일 (GitHub)

- `paths.standard.json` — 경로 템플릿
- `AGENTS.md` — data repo Cursor 규칙
- `.cursor/rules/` — repo 분리·sync·효율

원격: https://github.com/EHWIYA/pro-presenter-data
