#!/bin/sh
# Keep the previous macOS sync command compatible.
exec "$(dirname "$0")/sync.sh" "$@"
