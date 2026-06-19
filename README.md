# pro-presenter-data

ProPresenter **Show Directory** = Git working copy (`EHWIYA/pro-presenter-data`).

## 경로 (모든 현장 PC)

| 항목 | 경로 |
|------|------|
| Show Directory | `%USERPROFILE%\Documents\pro-presenter` |
| worship-2.pro | `Libraries\{subfolder}\worship-2.pro` — [`paths.standard.json`](paths.standard.json) |
| 에이전트 | `C:\pro-presenter-agent` (별 repo) |

## Git

- **포함:** Libraries, Playlists, Presets, Themes
- **제외:** Media/, Configuration/ (NAS rsync 예정)

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
