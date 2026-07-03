# pro-presenter-data (이 repo)

## 경로

| OS | Show Directory | 에이전트 (별도 Git, 자산 repo 밖) |
|----|----------------|----------------------------------|
| Windows | `%USERPROFILE%\Documents\pro-presenter` | `C:\pro-presenter-agent` |
| Mac | `~/Documents/pro-presenter` | `~/Documents/pro-presenter-agent` |

Git working copy = PP Show Directory. 경로 템플릿: [paths.standard.json](../../paths.standard.json)

**Mac iCloud (정책 A, 1회):** 시스템 설정 → Apple ID → iCloud → iCloud Drive → **「바탕화면 및 Documents 폴더」 OFF**. Git·`.pro` 잠금 충돌 방지. 상세: agent repo `docs/agent/macos-paths.md`.

### Mac 최초 clone (자산만)

```bash
git clone https://github.com/EHWIYA/pro-presenter-data.git "$HOME/Documents/pro-presenter"
```

PP 설정 → Show Directory를 위 경로로 맞출 것. 에이전트는 형제 폴더 `~/Documents/pro-presenter-agent`에 별도 clone (agent repo 담당).

## 폴더

```
Documents/pro-presenter/
  Libraries/        ← .pro (Git) — 에이전트 build
  Playlists/        ← 재생목록 (Git) — PP UI 표시 기준
  Presets/, Themes/ ← Git
  Media/Assets/     ← Git LFS (정본 미디어)
  Media/Downloads|Import|Imported|ProContent/ ← gitignore (PP 런타임)
  Configuration/    ← gitignore — PC별
```

**콘텐츠 모델:** PP UI = 재생목록 → `Libraries/…/*.pro` 참조. worship-2 단일 정본 개념 없음.

**테마:** agent `template/themes/` = 빌드용 복제 · `Themes/` = PP UI 테마 (별개). 프로필·재생목록 매핑 → [../handoff/theme-profiles.md](../handoff/theme-profiles.md)

**PP 설정:** Library / Support Files / Media → Show Directory 하위. `%APPDATA%\LocalWorkspaces` 혼용 금지.

## Git

**포함:** `Libraries/`, `Playlists/`, `Presets/`, `Themes/`, `Media/Assets/` (Git LFS)  
**제외:** `Media/` 런타임 하위, `Configuration/`, `.env`

**LFS:** `.gitattributes` — `*.png` `*.jpg` `*.mp4` 등. 각 PC에 [Git LFS](https://git-lfs.com/) 설치·`git lfs install` 1회. `launch-worship` pull 시 LFS 객체 함께 내려받음.

- `origin` = `https://github.com/EHWIYA/pro-presenter-data`
- init·remote add **이미 완료** — 재실행 금지
- 작업 전 ProPresenter **완전 종료**

## 동기화

| 시점 | 담당 | 동작 |
|------|------|------|
| PP 시작 | `launch-worship.bat` (Win) · `launch-worship.sh` (Mac) | PP **전** `git pull --rebase` |
| 수동 pull | `sync-assets-repo.ps1` (Win) | PP 종료 후 |
| 예배 후 | **이 repo** | commit / push |

**launch 순서:** 에이전트 → git pull → PP 시작 → (종료 시) 에이전트 종료.

pull skip: PP 이미 실행 중 · `-SkipAssetsSync` · rebase 충돌 시 launch 중단.

```powershell
cd "$env:USERPROFILE\Documents\pro-presenter"
git add Libraries/ Playlists/ Presets/ Themes/ Media/Assets/
git commit -m "..."
git push
```

**빌드 후:** `.pro` 갱신 → PP 종료 → commit/push → 다른 PC는 launch 또는 sync로 pull.

**충돌:** 수정 → `git add` → `git rebase --continue` (또는 `--abort`).

### 재생목록 (Win · Mac)

`Playlists/Library` 항목은 `local.path`(`ROOT_SHOW` + `Libraries/…`)가 **공통 정본**이다. Git에는 `absolute_string`을 `%USERPROFILE%\Documents\pro-presenter\…` portable 형태로 맞춘다 (에이전트 `normalize-playlists`, launch pull/push 시 자동). PP 종료 후 push 전에 **같은 곡이 재생목록에 두 번** 있으면 자동 제거된다.

**라이브러리 UI 중복:** macOS는 PP가 `~/Library/Application Support/.../UserWorkspaces/<show>/Libraries/LibraryData` 에 별도 인덱스를 둔다. 여기에 같은 `.pro`가 2번 등록되면 라이브러리/찬양 목록이 2배로 보인다. `normalize-playlists`가 Show Directory와 UserWorkspaces `LibraryData` 중복도 함께 제거한다. **PP 완전 종료 후** 실행·launch.

수동: `python -m pro_presenter_agent normalize-playlists --show-dir ~/Documents/pro-presenter --mode git`

## 곡 정본 (Libraries)

곡 슬라이드 실체는 `Libraries/{찬양|찬송가|성가곡}/<제목>.pro` 만 main에 둔다. (예배·말씀·교독문 등 비곡 콘텐츠는 별도 카테고리.)

| 규칙 | 내용 |
|------|------|
| 파일 stem | API `songId` 제목과 **완전 일치** (예: `413.내 평생에 가는 길` ≠ `413.내 평생`) |
| fixture 금지 | `성가테스트`, `테스트곡`, `빌드곡`, `주님의 마음` mock 등 — data repo에 commit 안 함 |
| 생성 경로 | agent `/build-song` → Show Directory `Libraries/` (BFF API로 곡 저장 ❌) |
| 예배 후 | PP 편집 → commit/push → revision을 서버·에이전트·현장 PC에 공유 → `launch-worship` 또는 `sync-assets-repo` pull |

**완료 기준:** main에 운영 곡만 존재 · push 후 `git rev-parse HEAD` revision 공유.

## agent config (이 repo 아님)

`config.json`은 Git에 없음. PC마다 portable 토큰만 다름 (`%USERPROFILE%` / `$HOME`).

| OS | 위치 |
|----|------|
| Windows | `C:\pro-presenter-agent\config.json` |
| Mac | `~/Documents/pro-presenter-agent/config.json` |

필드: `pp_show_directory`, `pp_library_dir`, `sync_assets_on_launch` — `paths.standard.json`·agent `paths.py`와 정합.

## 다른 현장 PC

동일 `.gitignore` → clone 또는 remote add → `paths.standard.json`·agent config만 현장 맞게 조정. Win ↔ Mac 자산 repo 내용은 동일; 절대 경로·런처 스크립트만 OS별.
