# E2E 흐름

> `pro-presenter-agent` 제거 후: PWA↔BFF 흐름은 유지하되, 현장 `.pro` 빌드·PP trigger 자동화가 없음. 슬라이드·송출은 ProPresenter UI에서 수동.

## 1 — 성경 구절

```
[PWA] venue 선택 → 구절 입력 (예: 마 3:1-10)
  → POST /api/v1/venues/{id}/build  { reference, auto_trigger: false }
  → [BFF] 성경 JSON 파싱·2줄 분할
  → (레거시) 에이전트 /build · slide_map — 제거됨
  → PP에서 해당 Libraries/*.pro 편집·송출 (수동)
```

## 2 — 찬양 악보

```
[PWA] 악보 이미지 업로드
  → POST /api/v1/song/analyze → [BFF] → cursor-llm-gateway
  → parsed.sections (verse/chorus, 2줄)
  → [PWA] 검수·편집 → (선택) PUT /api/v1/songs/{id}/sections
  → (레거시) build-song → 에이전트 — 제거됨
  → PP Libraries/<카테고리>/<제목>.pro 수동 반영 후 송출
```
