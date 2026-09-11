# Git 자동 검사

Git hook은 특정 Git 명령 전후에 자동으로 실행되는 검사다.
Windows는 `scripts/git-setup.ps1`, Mac은 `scripts/git-setup.sh`가 등록한다.

| 자동 검사 | 역할 |
|------|------|
| `post-merge` / `post-checkout` / `post-rewrite` | 파일을 바꾸지 않는다. |
| `pre-commit` | 경로 필터 설정을 확인하고 커밋할 경로를 공통 형식으로 바꾼다. |

경로는 다음 시점에 바뀐다.

| 시점 | 동작 |
|------|------|
| `git add` 또는 커밋 | Git 필터가 경로를 `%USERPROFILE%` 형식으로 바꾼다. |
| ProPresenter를 열기 직전 | `python3 scripts/path.py smudge-files`로 이 PC의 경로를 적용한다. |
| `git checkout` 또는 `git pull` | 파일을 바꾸지 않는다. |

Mac에서는 실행 권한이 필요하다. `setup.sh`가 `chmod +x`를 자동으로 실행한다.
