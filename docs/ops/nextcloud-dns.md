# Nextcloud DNS 경로 복구

2026-11-08 KST, NAS의 dnsmasq에서 원인 재현과 수정 후 검증.
IPv4(A) 질의는 Tailscale 주소였지만 IPv6(AAAA) 질의가 외부로 전달되어
공인 주소의 별칭(CNAME)이 반환됨. Windows가 이 주소를 사용하면 nginx가 403으로 거부.
Windows의 DNS 서버 지정만으로는 해결되지 않았음.

## 적용한 수정

NAS의 `/home/iwh/scripts/network/dns/iwhya-tailscale.conf` 정본과
`/etc/dnsmasq.d/iwhya-tailscale.conf`에 아래 두 설정 유지.
`address`는 기존 설정이며, `local`을 추가해 다른 종류의 질의도 외부로 보내지 않음.

```ini
address=/next-cloud.iwhya.kr/100.88.40.125
local=/next-cloud.iwhya.kr/
```

정본과 운영 설정 백업 후 `dnsmasq --test` 통과, dnsmasq 서비스만 재시작.
nginx 접근 제한과 TLS 검증 유지. 다른 서비스의 DNS 규칙은 변경하지 않음.
서버 백업: `/home/iwh/backup/snapshots/nextcloud-dns-20261107T152341`.

Windows에는 `ProPresenter Nextcloud Tailscale DNS` 규칙도 적용됨.
`next-cloud.iwhya.kr` 하나의 질의만 `100.88.40.125`로 전달.
최초 규칙 백업은 `.nextcloud-sync/dns-rules-before.xml`.
자동 승인 검토가 제거 명령을 차단하여 이 규칙은 유지함.
Tailscale의 Windows hosts 교체 오류 자체를 해결한 것은 아님.

## 확인과 복구

- `scripts/nas-check-nextcloud-dns.sh`를 NAS에서 실행.
- A는 `100.88.40.125`, AAAA·HTTPS는 공인 별칭 없는 빈 응답이어야 함.
- Windows DNS 캐시를 비우고 실제 접속 IP와 HTTP 응답을 반복 확인.
- `rclone check`와 일반 미디어 동기화의 성공 여부 확인.
- 재로그인 직후 동작은 다음 실제 로그인에서 자동 동기화 로그로 확인.
- NAS 복구는 위 백업의 `canonical.conf`와 `live.conf`를 각각 원래 경로에 복원.
- `dnsmasq --test` 통과 후 dnsmasq만 재시작. Windows DNS 캐시도 비우기.
- Windows 규칙 제거가 필요하면 관리자가 위 DisplayName의 규칙만 선별 제거.

## 이번 검증 결과

- 수정 전 AAAA에서 공인 별칭 재현, 수정 후 A·AAAA·HTTPS 검사 통과.
- 실제 HTTPS 접속은 수정 전 20회 모두 403, 수정 후 20회 모두 Tailscale IP와 200.
- 일반 bisync가 첫 시도에 성공. 변경·전송·삭제 없음.
- 323개 중 235개는 서버 해시 비교, 해시 없는 88개는 양쪽 SHA-256 직접 비교 통과.
- 원본 검증 기록은 PC의 `.nextcloud-sync/sha256-check.json`과 동기화 로그.

참고: [dnsmasq 공식 설명](https://lists.thekelleys.org.uk/pipermail/dnsmasq-discuss/2022q3/016501.html).
