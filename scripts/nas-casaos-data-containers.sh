#!/bin/sh
# CasaOS 저장소 재시작 전후에 /DATA 사용 컨테이너만 안전하게 멈추고 다시 연다.
set -eu

STATE=/run/casaos-data-containers

stop_containers() {
    [ -s "$STATE" ] && return
    if ! docker info >/dev/null 2>&1; then
        rm -f "$STATE"
        return
    fi
    : > "$STATE"
    docker ps -q | while read -r id; do
        sources=$(docker inspect -f '{{range .Mounts}}{{println .Source}}{{end}}' "$id")
        if printf '%s\n' "$sources" | grep -q '^/DATA\(/\|$\)'; then
            docker inspect -f '{{.Name}}' "$id" | sed 's|^/||' >> "$STATE"
        fi
    done
    [ ! -s "$STATE" ] || xargs -r -n1 -P0 docker stop -t 10 < "$STATE"
}

start_containers() {
    mountpoint -q /DATA || {
        echo "/DATA mergerfs가 연결되지 않아 컨테이너 시작을 중단합니다." >&2
        exit 1
    }
    [ ! -s "$STATE" ] || xargs docker start < "$STATE"
    rm -f "$STATE"
}

case "${1:-}" in
    stop) stop_containers ;;
    start) start_containers ;;
    *) echo "사용법: $0 stop|start" >&2; exit 2 ;;
esac
