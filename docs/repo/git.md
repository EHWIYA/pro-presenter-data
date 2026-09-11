# Git 운영

GitHub에는 `Libraries`, `Playlists`, `Presets`, `Themes`, `Fonts`를 저장한다.
`Media`, `Configuration`, `.env`는 각 PC나 Nextcloud에서 관리하므로 제외한다.

## 새 PC

| OS | 한 번 실행할 명령 |
|---|---|
| Windows | `powershell -File scripts/git-setup.ps1` |
| Mac | `./scripts/git-setup.sh` |

## 운영 순서

1. ProPresenter를 종료하고 `git pull --rebase`를 실행한다.
2. 열기 직전에 `python scripts/path.py smudge-files`를 실행한다.
3. 편집 후 Git으로 관리하는 파일만 `git add`, `git commit`, `git push`한다.
4. Git의 clean 필터가 사용자마다 다른 경로를 `%USERPROFILE%` 형식으로 바꾼다.

같은 부분을 서로 다르게 수정해 충돌하면 파일을 고친 뒤 `git add`와
`git rebase --continue`를 실행한다. 작업을 취소하려면
`git rebase --abort`로 취소한다. 저장소 초기화와 원격 추가는 완료됐으므로
반복하지 않는다.

곡 파일은 `Libraries/{찬양|찬송가|성가곡}/<제목>.pro` 형식을 사용하고
파일 이름을 실제 제목과 일치시킨다. 테스트 곡은 운영 자산에 넣지 않는다.
