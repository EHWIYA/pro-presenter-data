# 저장소별 역할

## 휴대폰 웹 화면

사용자는 이 화면에서 성경 구절과 찬양을 입력한다. 이 화면은 NAS 서버에만
연결하며 ProPresenter에는 직접 연결하지 않는다.

개발에는 React 19, Vite 6, TanStack Query 5, CSS Modules를 사용한다.
GitHub 자동 배포가 NAS의 `/home/iwh/pro-presenter/web/dist`로 파일을 보낸다.

ProPresenter의 `:12135` 주소를 직접 사용하거나 자동 송출을 기본으로 켜지 않는다.

---

## NAS 서버

이 서버는 성경과 곡 데이터베이스를 관리한다. `.pro` 파일은 만들지 않는다.

Docker의 `:8003`에서 실행하며 데이터베이스는 Postgres `:5434`를 사용한다.
NAS 설정 파일인 `venues.json`과 `.env`는 GitHub에 저장하지 않는다.

ProPresenter에 직접 슬라이드를 추가하지 않는다.

---

## ProPresenter 자료 저장소

이 저장소가 현재 폴더다. ProPresenter 문서와 테마는 GitHub에 저장한다.
`Media/Assets/`는 Nextcloud에 저장하고 `Configuration`은 각 PC에만 둔다.

→ [../repo/layout.md](../repo/layout.md)

---

## 제거됨

| 저장소 | 상태 |
|------|------|
| EHWIYA/pro-presenter-agent | 제거했다. Windows에서 `.pro` 파일을 만들거나 ProPresenter를 자동 실행하지 않는다. |
