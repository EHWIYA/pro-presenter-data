# 반복 명령 캐시

```powershell
python scripts/ctx.py git
python scripts/check.py
python -m unittest discover -s scripts/tests -v
python scripts/pp_path_normalize.py status
powershell -File scripts/setup-git-filters.ps1
powershell -File scripts/setup-auto-sync-windows.ps1
```

Mac에서는 `python`을 `python3`, PowerShell setup을
`./scripts/setup-git-filters.sh`로 바꾼다.
