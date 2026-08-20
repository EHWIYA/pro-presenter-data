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

if ! PY="$(command -v python3 2>/dev/null)" || [ -z "$PY" ]; then
  echo "Python 3 not found. Install Python and re-run." >&2
  exit 1
fi

if ! "$PY" -c 'import sys; raise SystemExit(sys.version_info < (3, 8))'; then
  echo "Python 3.8 or newer is required." >&2
  exit 1
fi

printf -v FILTER_PY '%q' "$PY"
FILTER_CMD="$FILTER_PY scripts/pp_path_normalize.py"

echo "Python: $PY"
echo "Repo:   $ROOT"

git config --replace-all filter.pp-paths.clean "$FILTER_CMD clean"
# Identity smudge: checkout/pull must not rewrite paths.
git config --replace-all filter.pp-paths.smudge "$FILTER_CMD smudge"
git config filter.pp-paths.required true
git config core.hooksPath scripts/githooks
git config core.quotepath false
git config i18n.commitEncoding utf-8
git config i18n.logOutputEncoding utf-8

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

"$PY" scripts/pp_path_normalize.py status

echo ""
echo "OK - checkout/pull leave portable paths (no Changes until PP)."
echo "  add/commit         -> clean (Git portable)"
echo "  before opening PP  -> $PY scripts/pp_path_normalize.py smudge-files"
echo ""
echo "Reminder: iCloud Desktop&Documents OFF (docs/data/repo.md)."
