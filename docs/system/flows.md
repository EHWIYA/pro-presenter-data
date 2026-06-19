# E2E 흐름

## 1 — 성경 구절 (MVP)

```
[PWA] venue 선택 → 구절 입력 (예: 마 3:1-10)
  → POST /api/v1/venues/{id}/build  { reference, auto_trigger: false }
  → [BFF] 성경 JSON 파싱·2줄 분할 → Tailscale → 에이전트 POST /build
  → [에이전트] worship-2.pro에 슬라이드 N장 → slide_map 반환
  → [PWA] slide_map 버튼 그리드
  → 사용자 탭 → POST /api/v1/venues/{id}/trigger?index=N
  → [BFF] → 에이전트 POST /trigger → PP 송출
```

**핵심:** `slide_map[].index` ↔ `trigger?index=` 동일 값.

## 2 — 찬양 악보 (Phase 2)

```
[PWA] 악보 이미지 업로드
  → POST /api/v1/song/analyze → [BFF] → cursor-llm-gateway
  → parsed.sections (verse/chorus, 2줄)
  → [PWA] 검수·편집 → (선택) PUT /api/v1/songs/{id}/sections
  → POST /api/v1/worship/build-song { venueId, songId 또는 sections }
  → [BFF] → 에이전트 POST /build-song
  → slide_map → trigger (구절과 동일)
```
