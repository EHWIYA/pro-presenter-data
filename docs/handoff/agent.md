# Handoff → pro-presenter-agent

**`C:\pro-presenter-agent` Cursor 대화에 붙여넣기.** 코드 변경은 agent repo에서만.

## Repo 분리

| | GitHub | 로컬 |
|--|--------|------|
| **에이전트 (작업 대상)** | EHWIYA/pro-presenter-agent | `C:\pro-presenter-agent` |
| **PP 자산** | EHWIYA/pro-presenter-data | `%USERPROFILE%\Documents\pro-presenter` |

## config.json (현장 PC)

`%USERPROFILE%`만 PC마다 다름. 사용자명 하드코딩 금지.

```json
{
  "pp_show_directory": "%USERPROFILE%\\Documents\\pro-presenter",
  "pp_library_dir": "%USERPROFILE%\\Documents\\pro-presenter\\Libraries\\예배",
  "sync_assets_on_launch": true,
  "presentation_filename": "worship-2.pro",
  "presentation_repo_path": "%USERPROFILE%\\Documents\\pro-presenter\\Libraries\\예배\\worship-2.pro",
  "template_pro": "template/worship-template.pro",
  "nas_api": "http://100.88.40.125:8003",
  "agent_port": 8787,
  "pp_api": "http://127.0.0.1:12135"
}
```

`paths.standard.json`(data repo)과 정합 유지.

## 담당 분리

| 담당 | 업무 |
|------|------|
| **에이전트 (Python)** | `/build`, `/build-song`, `/trigger`, `.pro` 생성 |
| **런처 (PowerShell)** | PP↔에이전트 생명주기, 자산 repo `git pull` |

## 워크플로

| 작업 | 어디서 |
|------|--------|
| 예배 시작 | `launch-worship.bat` |
| 수동 pull | `scripts\sync-assets-repo.ps1` |
| 예배 후 자산 공유 | data repo → commit/push |
| 점검 | `GET http://127.0.0.1:8787/collect-info` |

## 레거시 (사용 줄임)

- agent `presentations/worship-2.pro` — data repo로 이전됨
- `repo-pull` / `repo-push` — library path = repo path면 불필요

## 하지 말 것

- `Documents\pro-presenter`에 agent `.venv` / config 넣기
- NAS Docker화
- 두 repo git remote 혼동

전체 맥락: [../system/overview.md](../system/overview.md) · data repo [../index.md](../index.md)
