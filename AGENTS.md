# Cursor Agent — pro-presenter-data

ProPresenter **자산 Git repo** (`Documents\pro-presenter`). 에이전트 코드는 `C:\pro-presenter-agent` (별 repo).

## 빠른 참조

| 항목 | 값 |
|------|-----|
| 원격 | `https://github.com/EHWIYA/pro-presenter-data` |
| Show Directory | `%USERPROFILE%\Documents\pro-presenter` |
| PP 표시 | **재생목록** (`Playlists/`) → `Libraries/*.pro` 참조 |
| 시작 시 sync | `launch-worship.bat` → `git pull --rebase` |
| 에이전트 config | `C:\pro-presenter-agent\config.json` |

## 규칙 (.cursor/rules/)

- 두 repo 분리, Git 포함/제외, 경로 `%USERPROFILE%`, 중복 작업 방지

## 일반 작업

```powershell
# 자산 동기화 (PP 종료 후)
cd "$env:USERPROFILE\Documents\pro-presenter"
git pull
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
