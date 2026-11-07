#!/bin/sh
# Media/Assets <-> Nextcloud(04_교회자료/PP_Media_Assets) 양방향 동기화 (Mac)

# ── 설정값 (필요하면 여기만 수정) ──────────────────────────
REMOTE_NAME="pp-media"
LOCAL_PATH="$HOME/Documents/pro-presenter/Media/Assets"
STATE_DIR="$HOME/Documents/pro-presenter/.nextcloud-sync"
# ──────────────────────────────────────────────────────────

MARKER="$STATE_DIR/resync-done"
LOG="$STATE_DIR/sync.log"

mkdir -p "$STATE_DIR" "$LOCAL_PATH"

rclone bisync "$REMOTE_NAME:" "$LOCAL_PATH" --create-empty-src-dirs -v --log-file "$LOG"
SYNC_EXIT=$?

if [ "$SYNC_EXIT" -eq 0 ]; then
    echo done > "$MARKER"
else
    echo "[nextcloud-sync] rclone bisync 실패 — 로그: $LOG" >&2
fi
exit "$SYNC_EXIT"
