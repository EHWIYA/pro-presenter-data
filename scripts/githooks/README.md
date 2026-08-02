# githooks (core.hooksPath)

`scripts/setup-git-filters.ps1` (Win) 또는 `scripts/setup-git-filters.sh` (Mac)이 `core.hooksPath`를 여기로 지정한다.

| hook | 역할 |
|------|------|
| `post-merge` / `post-checkout` / `post-rewrite` | **no-op** — checkout/pull이 working tree 경로를 바꾸지 않음 |
| `pre-commit` | `filter.pp-paths` 설정 여부 확인 · staged 인덱스 clean |

경로 변환:

| 시점 | 동작 |
|------|------|
| `git add` / commit | **clean** filter → Git portable |
| PP 열기 직전 | `python3 scripts/pp_path_normalize.py smudge-files` (명시) |
| checkout/pull | smudge filter = identity (파일 그대로) |

Mac는 executable bit 필요 → setup.sh가 `chmod +x` 한다.
