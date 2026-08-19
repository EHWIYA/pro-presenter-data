# pro-presenter-data

ProPresenter **Show Directory** Git 정본.

| 항목 | 값 |
|------|-----|
| GitHub | [EHWIYA/pro-presenter-data](https://github.com/EHWIYA/pro-presenter-data) |
| 로컬 | `%USERPROFILE%\Documents\pro-presenter` |

## Git (요약)

포함: `Libraries/` `Playlists/` `Presets/` `Themes/` `Fonts/` (LFS) · 제외: `Media/` 전체(런타임 + `Assets/`, Nextcloud 관리), `Configuration/`

```powershell
cd "$env:USERPROFILE\Documents\pro-presenter"
# 신규 PC 1회: powershell -File scripts/setup-git-filters.ps1
# macOS:       ./scripts/setup-git-filters.sh
git pull
# PP 종료 후
git add Libraries/ Playlists/ Presets/ Themes/
git commit -m "..." ; git push
```

`Media/Assets/`(영상·음원·이미지)는 git이 아닌 Nextcloud로 동기화한다. 상세: [docs/data/repo.md](docs/data/repo.md)

재생목록 경로는 pull/commit 시 **자동** 변환 (Win·Mac, setup 1회). 상세: [docs/data/repo.md](docs/data/repo.md) · 에이전트 안내: [AGENTS.md](AGENTS.md) · 목차: [docs/index.md](docs/index.md)
