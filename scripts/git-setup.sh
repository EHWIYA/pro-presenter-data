#!/usr/bin/env bash
# Configure the Git path filter and hooks once on macOS.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
PY="$(command -v python3 2>/dev/null || true)"
if [ -z "$PY" ] || ! "$PY" -c 'import sys; raise SystemExit(sys.version_info < (3, 10))'; then
  echo "Python 3.10 or newer is required." >&2
  exit 1
fi
printf -v FILTER_PY '%q' "$PY"
FILTER_CMD="$FILTER_PY scripts/path.py"
git config --replace-all filter.pp-paths.clean "$FILTER_CMD clean"
git config --replace-all filter.pp-paths.smudge "$FILTER_CMD smudge"
git config filter.pp-paths.required true
git config core.hooksPath scripts/hooks
git config core.quotepath false
git config i18n.commitEncoding utf-8
git config i18n.logOutputEncoding utf-8
chmod +x scripts/hooks/* scripts/*.sh scripts/path.py 2>/dev/null || true
git config --get filter.pp-paths.clean
git config --get filter.pp-paths.smudge
git config --get core.hooksPath
"$PY" scripts/path.py status
echo "OK - checkout is portable; run smudge-files before ProPresenter."
