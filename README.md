# pro-presenter-data

ProPresenter **Show Directory** = Git working copy (`EHWIYA/pro-presenter-data`).

## 경로 (모든 현장 PC)

| 항목 | 경로 |
|------|------|
| Show Directory | `%USERPROFILE%\Documents\pro-presenter` |
| PP 콘텐츠 | 재생목록 → `Libraries/*.pro` |

## Git

- **포함:** Libraries, Playlists, Presets, Themes
- **제외:** Media/, Configuration/
- **시작 시 pull:** `launch-worship.bat` (PP 실행 전 `git pull --rebase`)
- **수동 pull:** `C:\pro-presenter-agent\scripts\sync-assets-repo.ps1`

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
