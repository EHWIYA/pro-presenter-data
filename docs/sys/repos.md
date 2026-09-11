# 저장소별 역할

## 휴대폰 웹 화면

사용자가 성경 구절과 찬양을 입력하는 화면. NAS 서버에만 연결하며
ProPresenter에는 직접 연결 금지.

개발 도구는 React 19, Vite 6, TanStack Query 5, CSS Modules.
GitHub 자동 배포로 NAS의 `/home/iwh/pro-presenter/web/dist`에 파일 전송.

ProPresenter의 `:12135` 주소 직접 사용과 자동 송출 기본 설정 금지.

---

## NAS 서버

성경과 곡 데이터베이스를 관리하는 서버. `.pro` 파일 생성 금지.

Docker의 `:8003`에서 실행하며 데이터베이스는 Postgres `:5434` 사용.
NAS 설정 파일인 `venues.json`과 `.env`는 GitHub 저장 금지.

ProPresenter에 직접 슬라이드 추가 금지.

---

## ProPresenter 자료 저장소

현재 폴더에 해당하는 저장소. ProPresenter 문서와 테마는 GitHub에 저장.
`Media/Assets/`는 Nextcloud에 저장하고 `Configuration`은 각 PC에만 보관.

→ [../repo/layout.md](../repo/layout.md)

---

## 제거됨

| 저장소 | 상태 |
|------|------|
| EHWIYA/pro-presenter-agent | 제거됨. Windows의 `.pro` 파일 생성과 ProPresenter 자동 실행 없음. |
