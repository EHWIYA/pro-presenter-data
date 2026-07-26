# pro-presenter-data

ProPresenter **Show Directory** Git 정본.

| 항목 | 값 |
|------|-----|
| GitHub | [EHWIYA/pro-presenter-data](https://github.com/EHWIYA/pro-presenter-data) |
| 로컬 | `%USERPROFILE%\Documents\pro-presenter` |

## Git (요약)

포함: `Libraries/` `Playlists/` `Presets/` `Themes/` `Media/Assets/` (LFS) · 제외: `Media/` 런타임, `Configuration/`

```powershell
cd "$env:USERPROFILE\Documents\pro-presenter"
git pull
# PP 종료 후
git add Libraries/ Playlists/ Presets/ Themes/ Media/Assets/
git commit -m "..." ; git push
```

상세: [docs/data/repo.md](docs/data/repo.md) · Cursor: [AGENTS.md](AGENTS.md) · 목차: [docs/index.md](docs/index.md)
