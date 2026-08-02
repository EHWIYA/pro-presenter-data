#!/usr/bin/env bash
# One-time per Mac (clone 후).
# Registers Git clean filter + identity smudge + hooks.
# Working tree stays portable until you run smudge-files before opening PP.
#
#   chmod +x scripts/setup-git-filters.sh
#   ./scripts/setup-git-filters.sh

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if command -v python3 >/dev/null 2>&1; then
  PY=python3
elif command -v python >/dev/null 2>&1; then
  PY=python
else
  echo "Python 3 not found. Install Python and re-run." >&2
  exit 1
fi

FILTER_CMD="$PY scripts/pp_path_normalize.py"

echo "Python: $PY"
echo "Repo:   $ROOT"

git config filter.pp-paths.clean "$FILTER_CMD clean"
# Identity smudge: checkout/pull must not rewrite paths.
git config filter.pp-paths.smudge "$FILTER_CMD smudge"
git config filter.pp-paths.required true
git config core.hooksPath scripts/githooks

chmod +x scripts/githooks/post-merge \
         scripts/githooks/post-checkout \
         scripts/githooks/post-rewrite \
         scripts/githooks/pre-commit \
         scripts/setup-git-filters.sh \
         scripts/pp_path_normalize.py 2>/dev/null || true

echo "Configured:"
git config --get filter.pp-paths.clean
git config --get filter.pp-paths.smudge
git config --get core.hooksPath

$PY scripts/pp_path_normalize.py status

echo ""
echo "OK — checkout/pull leave portable paths (no Changes until PP)."
echo "  add/commit         → clean (Git portable)"
echo "  before opening PP  → $PY scripts/pp_path_normalize.py smudge-files"
echo ""
echo "Reminder: iCloud Desktop&Documents OFF (docs/data/repo.md)."
