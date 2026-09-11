#!/bin/sh
# Keep the previous macOS Git setup command compatible.
exec "$(dirname "$0")/git-setup.sh" "$@"
