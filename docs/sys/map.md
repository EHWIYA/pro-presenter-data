# 시스템 개요

## 한 줄 요약

휴대폰 웹 화면(PWA)에서 성경 구절이나 찬양을 입력한다. NAS의 서버(BFF)는
내용을 읽고 곡 데이터베이스를 관리한다. ProPresenter 자료는 별도 GitHub
저장소인 `pro-presenter-data`에서 관리한다.

`pro-presenter-agent`는 제거했다. 슬라이드 제작과 송출은 Windows 자동화가
아니라 ProPresenter 화면에서 사람이 직접 진행한다.

## 아키텍처

```
[휴대폰 웹 화면]  pro-app.iwhya.kr
  │  암호화된 인터넷 연결
  ▼
[NAS 서버]  pro-api.iwhya.kr → :8003
  │  성경 데이터 · 곡 데이터베이스
  └─ 127.0.0.1:18080 ──▶ 인공지능 악보 분석

[ProPresenter 자료] Documents/pro-presenter (GitHub)
```

## 운영 URL

| 서비스 | URL |
|--------|-----|
| 휴대폰 웹 화면 | https://pro-app.iwhya.kr |
| NAS 서버 | https://pro-api.iwhya.kr |
| 관리자용 NAS 주소 | `100.88.40.125` |

## 저장소

| # | GitHub | 역할 | 실행 | 배포 |
|---|--------|------|------|------|
| 1 | EHWIYA/pro-presenter-front-end | 휴대폰 웹 화면 | NAS 웹 서버 | GitHub 자동 배포 |
| 2 | EHWIYA/pro-presenter-back-end | NAS 서버 | NAS Docker :8003 | GitHub 자동 배포 |
| 3 | EHWIYA/pro-presenter-data | ProPresenter 자료 | Documents/pro-presenter | Git으로 동기화 |

## 의존 관계

```
휴대폰 웹 화면  ──▶  NAS 서버
NAS 서버         ──▶  인공지능 악보 분석
ProPresenter 자료 ◀──  ProPresenter 앱에서 사람이 편집하고 송출한다.
```

→ [rules.md](rules.md) · [flow.md](flow.md) · [repos.md](repos.md)
