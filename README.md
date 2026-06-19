# pro-presenter-data

ProPresenter **Show Directory** = Git working copy (`EHWIYA/pro-presenter-data`).

## 경로 (모든 현장 PC)

| 항목 | 경로 |
|------|------|
| Show Directory | `%USERPROFILE%\Documents\pro-presenter` |
| PP 콘텐츠 | 재생목록 → `Libraries/*.pro` |

## Git 동기화 (agent repo 런처)

| 시점 | 담당 | 방법 |
|------|------|------|
| PP 시작 | `launch-worship.bat` | `git pull --rebase` (PP **전**) |
| 수동 | agent `sync-assets-repo.ps1` | PP 종료 후 |
| 예배 후 | **이 repo** | `git commit` / `push` |

## Git 추적 / 제외

## 동기화

```powershell
# ProPresenter 종료 후
git pull
# ... 작업 ...
git add Libraries/ Playlists/ Presets/ Themes/
git commit -m "..."
git push
```

Cursor 규칙: [`.cursor/rules/`](.cursor/rules/) · [AGENTS.md](AGENTS.md)
