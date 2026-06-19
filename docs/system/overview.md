# 시스템 개요

## 한 줄 요약

모바일 PWA에서 성경 구절·찬양을 입력하면, NAS BFF가 파싱·곡 DB·현장 라우팅을 맡고, Windows 에이전트가 ProPresenter `.pro`에 슬라이드를 생성한 뒤, 사용자가 버튼을 눌러 송출합니다. PP 자산은 별도 Git repo로 관리합니다.

## 아키텍처

```
[PWA]  pro-app.iwhya.kr
  │  HTTPS + X-API-Key
  ▼
[NAS BFF]  pro-api.iwhya.kr → :8003
  │  성경 JSON · verse/parse · Postgres 곡 DB · venue 프록시
  ├─ Tailscale ──▶ [Venue Agent] Windows :8787 → PP :12135
  └─ 127.0.0.1:18080 ──▶ cursor-llm-gateway (악보 분석)
                              │
                              ▼
                    [PP 자산] Documents/pro-presenter (Git)
```

## 운영 URL

| 서비스 | URL |
|--------|-----|
| PWA | https://pro-app.iwhya.kr |
| API | https://pro-api.iwhya.kr |
| NAS Tailscale | `100.88.40.125` (GHA·SSH) |

## 4레포

| # | GitHub | 역할 | 실행 | 배포 |
|---|--------|------|------|------|
| 1 | EHWIYA/pro-presenter-front-end | 모바일 PWA | NAS nginx | GHA → rsync |
| 2 | EHWIYA/pro-presenter-back-end | NAS API (BFF) | NAS Docker :8003 | GHA → GHCR |
| 3 | EHWIYA/pro-presenter-agent | .pro 빌드·PP 트리거 | Windows :8787 | 수동 설치 |
| 4 | EHWIYA/pro-presenter-data | PP Show Directory | Documents/pro-presenter | git pull/push |

## 의존 관계

```
front-end  ──▶  back-end (OpenAPI·DTO)
back-end   ──▶  agent (:8787 via Tailscale)
back-end   ──▶  cursor-llm-gateway
agent      ──▶  pro-presenter-data (.pro 읽기/쓰기)
data       ◀──  agent + ProPresenter 앱
```

## 왜 에이전트가 필요한가

ProPresenter 7 REST API는 슬라이드 생성·본문 수정 불가, 트리거만 가능. `.pro` Protobuf 조립은 Windows 에이전트 필수.

→ [principles.md](principles.md) · [flows.md](flows.md) · [repos.md](repos.md)
