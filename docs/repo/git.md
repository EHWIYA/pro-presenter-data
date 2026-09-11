# Git 운영

포함 대상은 `Libraries`, `Playlists`, `Presets`, `Themes`, `Fonts`다.
`Media`, `Configuration`, `.env`는 포함하지 않는다.

## 새 PC

| OS | 한 번 실행할 명령 |
|---|---|
| Windows | `powershell -File scripts/setup-git-filters.ps1` |
| Mac | `./scripts/setup-git-filters.sh` |

## 운영 순서

1. ProPresenter를 종료하고 `git pull --rebase`를 실행한다.
2. 열기 직전에 `python scripts/pp_path_normalize.py smudge-files`를 실행한다.
3. 편집 후 Git 자산만 stage, commit, push한다.
4. clean filter가 경로를 portable 형식으로 저장한다.

충돌은 수정 후 `git add`와 `git rebase --continue`로 해결하거나
`git rebase --abort`로 취소한다. 저장소 초기화와 원격 추가는 완료됐으므로
반복하지 않는다.

곡 파일은 `Libraries/{찬양|찬송가|성가곡}/<제목>.pro` 형식을 사용하고
파일 이름을 실제 제목과 일치시킨다. 테스트 곡은 운영 자산에 넣지 않는다.
