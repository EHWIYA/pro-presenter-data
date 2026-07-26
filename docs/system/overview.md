# 시스템 개요

## 한 줄 요약

모바일 PWA에서 성경 구절·찬양을 입력하면 NAS BFF가 파싱·곡 DB·현장 라우팅을 맡고, ProPresenter 자산은 별도 Git repo(`pro-presenter-data`)로 관리합니다.

> **참고:** `pro-presenter-agent`(Windows `.pro` 빌드·PP 트리거)는 제거됨. 슬라이드 제작·송출은 PP UI·수동 워크플로로 유지.

## 아키텍처

```
[PWA]  pro-app.iwhya.kr
  │  HTTPS + X-API-Key
  ▼
[NAS BFF]  pro-api.iwhya.kr → :8003
  │  성경 JSON · verse/parse · Postgres 곡 DB
  └─ 127.0.0.1:18080 ──▶ cursor-llm-gateway (악보 분석)

[PP 자산] Documents/pro-presenter (Git)
```

## 운영 URL

| 서비스 | URL |
|--------|-----|
| PWA | https://pro-app.iwhya.kr |
| API | https://pro-api.iwhya.kr |
| NAS Tailscale | `100.88.40.125` (GHA·SSH) |

## 레포

| # | GitHub | 역할 | 실행 | 배포 |
|---|--------|------|------|------|
| 1 | EHWIYA/pro-presenter-front-end | 모바일 PWA | NAS nginx | GHA → rsync |
| 2 | EHWIYA/pro-presenter-back-end | NAS API (BFF) | NAS Docker :8003 | GHA → GHCR |
| 3 | EHWIYA/pro-presenter-data | PP Show Directory | Documents/pro-presenter | git pull/push |

## 의존 관계

```
front-end  ──▶  back-end (OpenAPI·DTO)
back-end   ──▶  cursor-llm-gateway
data       ◀──  ProPresenter 앱 (수동 편집·송출)
```

→ [principles.md](principles.md) · [flows.md](flows.md) · [repos.md](repos.md)
