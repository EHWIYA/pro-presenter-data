# Git 자동 검사

Git hook은 특정 Git 명령 전후에 자동으로 실행되는 검사.
Windows는 `scripts/git-setup.ps1`, Mac은 `scripts/git-setup.sh`로 등록.

| 자동 검사 | 역할 |
|------|------|
| `post-merge` / `post-checkout` / `post-rewrite` | 파일 변경 없음 |
| `pre-commit` | 경로 설정 확인과 커밋할 경로의 공통 형식 변환 |

경로가 바뀌는 시점.

| 시점 | 동작 |
|------|------|
| `git add` 또는 커밋 | Git 필터가 경로를 `%USERPROFILE%` 형식으로 변환 |
| ProPresenter를 열기 직전 | `python3 scripts/path.py smudge-files`로 이 PC의 경로 적용 |
| `git checkout` 또는 `git pull` | 파일 변경 없음 |

Mac에서는 실행 권한 필요. `setup.sh`가 `chmod +x`를 자동 실행.
