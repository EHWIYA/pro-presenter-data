# githooks (core.hooksPath)

`scripts/setup-git-filters.ps1` (Win) 또는 `scripts/setup-git-filters.sh` (Mac)이 `core.hooksPath`를 여기로 지정한다.

| hook | 역할 |
|------|------|
| `post-merge` / `post-checkout` / `post-rewrite` | pull·checkout 후 경로 smudge (이 PC 절대경로) |
| `pre-commit` | `filter.pp-paths` 설정 여부 확인 |

정본 변환은 Git **clean/smudge filter** (`pp-paths`)가 담당한다. Mac는 executable bit 필요 → setup.sh가 `chmod +x` 한다.
