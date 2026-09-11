#!/bin/sh
# Run the macOS Nextcloud sync implementation.
exec "$(dirname "$0")/mac/sync.sh" "$@"
