# pro-presenter-data (이 repo)

## 경로

| OS | Show Directory |
|----|----------------|
| Windows | `%USERPROFILE%\Documents\pro-presenter` |
| Mac | `~/Documents/pro-presenter` |

Git working copy = PP Show Directory. 경로 템플릿: [paths.standard.json](../../paths.standard.json)

## 폴더

```
Documents/pro-presenter/
  Libraries/        ← .pro (Git) — 에이전트 build
  Playlists/        ← 재생목록 (Git) — PP UI 표시 기준
  Presets/, Themes/ ← Git
  Media/            ← gitignore — NAS rsync
  Configuration/    ← gitignore — PC별
```

**콘텐츠 모델:** PP UI = 재생목록 → `Libraries/…/*.pro` 참조. worship-2 단일 정본 개념 없음.

**테마:** agent `template/themes/` = 빌드용 복제 · `Themes/` = PP UI 테마 (별개).

**PP 설정:** Library / Support Files / Media → Show Directory 하위. `%APPDATA%\LocalWorkspaces` 혼용 금지.

## Git

**포함:** `Libraries/`, `Playlists/`, `Presets/`, `Themes/`  
**제외:** `Media/`, `Configuration/`, `.env`

- `origin` = `https://github.com/EHWIYA/pro-presenter-data`
- init·remote add **이미 완료** — 재실행 금지
- 작업 전 ProPresenter **완전 종료**

## 동기화

| 시점 | 담당 | 동작 |
|------|------|------|
| PP 시작 | `launch-worship.bat` | PP **전** `git pull --rebase` |
| 수동 pull | `sync-assets-repo.ps1` | PP 종료 후 |
| 예배 후 | **이 repo** | commit / push |

**launch 순서:** 에이전트 → git pull → PP 시작 → (종료 시) 에이전트 종료.

pull skip: PP 이미 실행 중 · `-SkipAssetsSync` · rebase 충돌 시 launch 중단.

```powershell
cd "$env:USERPROFILE\Documents\pro-presenter"
git add Libraries/ Playlists/ Presets/ Themes/
git commit -m "..."
git push
```

**빌드 후:** `.pro` 갱신 → PP 종료 → commit/push → 다른 PC는 launch 또는 sync로 pull.

**충돌:** 수정 → `git add` → `git rebase --continue` (또는 `--abort`).

## agent config (이 repo 아님)

`C:\pro-presenter-agent\config.json` — `pp_show_directory`, `pp_library_dir`, `sync_assets_on_launch`

## 다른 현장 PC

동일 `.gitignore` → clone 또는 remote add → `paths.standard.json`·agent config만 현장 맞게 조정.
