#!/bin/sh
# Media/Assets <-> Nextcloud(04_교회자료/PP_Media_Assets) 양방향 동기화 (Mac)

# ── 설정값 (필요하면 여기만 수정) ──────────────────────────
REMOTE_NAME="pp-nextcloud"
REMOTE_PATH="04_교회자료/PP_Media_Assets"
LOCAL_PATH="$HOME/Documents/pro-presenter/Media/Assets"
STATE_DIR="$HOME/Documents/pro-presenter/.nextcloud-sync"
# ──────────────────────────────────────────────────────────

MARKER="$STATE_DIR/resync-done"
LOG="$STATE_DIR/sync.log"

mkdir -p "$STATE_DIR" "$LOCAL_PATH"

RESYNC_FLAG=""
[ -f "$MARKER" ] || RESYNC_FLAG="--resync"

rclone bisync "$REMOTE_NAME:$REMOTE_PATH" "$LOCAL_PATH" $RESYNC_FLAG --create-empty-src-dirs -v --log-file "$LOG"

if [ $? -eq 0 ]; then
    echo done > "$MARKER"
else
    echo "[nextcloud-sync] rclone bisync 실패 — 로그: $LOG" >&2
fi
