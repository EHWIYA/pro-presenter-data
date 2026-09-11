# 로그인부터 송출까지의 흐름

## Windows

1. 로그인 뒤 GitHub와 Nextcloud 자동 동기화 완료 기다리기.
2. ProPresenter를 열고 `Documents/pro-presenter`의 자료 사용하기.
3. 슬라이드와 재생목록을 ProPresenter 화면에서 직접 편집하기.
4. ProPresenter 화면에서 예배 송출하기.
5. 작업 뒤 ProPresenter 완전 종료하기.
6. 종료 뒤 GitHub와 Nextcloud 자동 동기화 결과 확인하기.

GitHub에는 문서·재생목록·테마·글꼴 저장. Nextcloud에는
`Media/Assets`의 영상·음원·이미지 저장. `Configuration`은 PC별 보관.

## Mac

Git 경로 변환과 로그인 시 Nextcloud 동기화만 지원. 작업 전후 수동으로
Git 동기화하고 ProPresenter 종료 전에 Nextcloud 동기화 완료 확인하기.
