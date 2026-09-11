# Git 운영

GitHub에는 `Libraries`, `Playlists`, `Presets`, `Themes`, `Fonts` 저장.
`Media`, `Configuration`, `.env`는 각 PC나 Nextcloud에서 관리하므로 제외.

## 새 PC

| OS | 한 번 실행할 명령 |
|---|---|
| Windows | `powershell -File scripts/git-setup.ps1` |
| Mac | `./scripts/git-setup.sh` |

## 운영 순서

1. ProPresenter 종료 후 `git pull --rebase` 실행하기.
2. 열기 직전에 `python scripts/path.py smudge-files` 실행하기.
3. 편집 후 Git으로 관리하는 파일만 `git add`, `git commit`, `git push`하기.
4. Git의 경로 변환 기능으로 사용자 경로를 `%USERPROFILE%` 형식으로 저장하기.

같은 부분을 서로 다르게 수정해 충돌하면 파일을 고친 뒤 `git add`와
`git rebase --continue` 실행. 작업을 취소하려면 `git rebase --abort` 사용.
저장소 초기화와 원격 추가는 이미 완료됐으므로 반복 금지.

곡 파일은 `Libraries/{찬양|찬송가|성가곡}/<제목>.pro` 형식 사용.
파일 이름은 실제 제목과 일치 필수. 운영 자료에 테스트 곡 추가 금지.
