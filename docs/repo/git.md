# Git 운영

GitHub에는 `Libraries`, `Playlists`, `Presets`, `Themes`, `Fonts` 저장.
`Media`, `Configuration`, `.env`는 각 PC나 Nextcloud에서 관리하므로 제외.

## 새 PC

| OS | 한 번 실행할 명령 |
|---|---|
| Windows | `powershell -File scripts/git-setup.ps1` |
| Mac | `./scripts/git-setup.sh` |

## 운영 순서

1. ProPresenter 종료 후 `git pull --no-rebase` 실행하기.
2. 열기 직전에 `python scripts/path.py smudge-files` 실행하기.
3. 편집 후 Git으로 관리하는 파일만 `git add`, `git commit`, `git push`하기.
4. Git의 경로 변환 기능으로 사용자 경로를 `%USERPROFILE%` 형식으로 저장하기.

기존 Windows PC에서 이 변경을 처음 받을 때, `smudge-files`로 적용한 PC별
경로를 Git이 수정으로 표시하면 아래 명령으로 내용이 같은 파일의 인덱스만
갱신한 뒤 받기. 실제 편집 내용이 있으면 중단하므로 먼저 해당 작업 해결하기.

```powershell
$targets = @('Playlists/Library', 'Playlists/Media', 'Libraries/LibraryData')
foreach ($file in $targets) {
    if ((git rev-parse ":$file") -ne (git hash-object "--path=$file" $file)) {
        throw "로컬 편집 확인 필요. $file"
    }
}
git add -- $targets
git diff --cached --quiet -- $targets
if ($LASTEXITCODE -ne 0) { throw '스테이징된 재생목록 변경 확인 필요.' }
git pull --no-rebase
powershell -ExecutionPolicy Bypass -File scripts/git-setup.ps1
python scripts/path.py smudge-files
```

같은 부분을 서로 다르게 수정해 충돌하면 파일을 고친 뒤 `git add`와
`git merge --continue` 실행. 작업을 취소하려면 `git merge --abort` 사용.
저장소 초기화와 원격 추가는 이미 완료됐으므로 반복 금지.

곡 파일은 `Libraries/{찬양|찬송가|성가곡}/<제목>.pro` 형식 사용.
파일 이름은 실제 제목과 일치 필수. 운영 자료에 테스트 곡 추가 금지.
