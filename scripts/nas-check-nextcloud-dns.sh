#!/bin/sh
# Nextcloud DNS가 A 이외 질의에서도 공인 경로를 반환하지 않는지 검사한다.
set -eu
host=next-cloud.iwhya.kr
server=100.88.40.125
a=$(dig @"$server" "$host" A +short +time=3 +tries=1)
[ "$a" = "$server" ] || { echo "FAIL A: $a"; exit 1; }
for kind in AAAA HTTPS; do
    answer=$(dig @"$server" "$host" "$kind" +short +time=3 +tries=1)
    [ -z "$answer" ] || { echo "FAIL $kind: $answer"; exit 1; }
done
echo 'PASS A=Tailscale; AAAA/HTTPS=no public alias'
