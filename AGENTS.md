# Cursor Agent — pro-presenter-data

ProPresenter **자산 Git repo** (`Documents\pro-presenter`).  
**에이전트 코드는 이 워크스페이스에서 작업하지 않음** → `C:\pro-presenter-agent` (별 Cursor).

> **에이전트 repo Cursor에게 넘길 handoff:** [docs/HANDOFF-TO-AGENT-REPO.md](docs/HANDOFF-TO-AGENT-REPO.md) ← **복붙용**

## 빠른 참조

| 항목 | 값 |
|------|-----|
| 원격 | `https://github.com/EHWIYA/pro-presenter-data` |
| Show Directory | `%USERPROFILE%\Documents\pro-presenter` |
| PP 표시 | **재생목록** (`Playlists/`) → `Libraries/*.pro` 참조 |
| 시작 시 sync | **`launch-worship.bat`** (agent repo) → PP 실행 **전** `git pull --rebase` |
| 수동 pull | `C:\pro-presenter-agent\scripts\sync-assets-repo.ps1` |
| 경로 템플릿 | [`paths.standard.json`](paths.standard.json) |
| 에이전트 config | `C:\pro-presenter-agent\config.json` |

## 역할 분담

| 담당 | 업무 |
|------|------|
| **이 repo (data)** | Libraries, Playlists, Themes Git · 예배 후 commit/push |
| **agent repo** | Python API, 빌드, `launch-worship.bat`, 시작 시 pull |
| **PP** | 재생목록 UI, 송출 |

## 규칙 (`.cursor/rules/`)

- 두 repo 분리, Git 포함/제외, `%USERPROFILE%` 경로, 중복 작업 방지

## 일반 작업

```powershell
# 예배 시작 (pull 포함) — agent repo
C:\pro-presenter-agent\launch-worship.bat

# 예배 후 공유 (PP 종료 후, 여기서)
cd "$env:USERPROFILE\Documents\pro-presenter"
git add Libraries/ Playlists/ Presets/ Themes/
git commit -m "..."
git push

# 에이전트 점검
Invoke-RestMethod http://127.0.0.1:8787/collect-info
```

## 하지 말 것

- `Media/`, `Configuration/` commit
- 에이전트 `.venv` / `config.json`을 이 폴더에 두기
- Windows 사용자명 하드코딩
