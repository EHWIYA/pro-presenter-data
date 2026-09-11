# 자동 세션 동기화

Windows는 로그인과 ProPresenter 종료 시 Git과 Nextcloud를 동기화한다.

## 순서

1. 예약 작업 정의를 복구한다.
2. ProPresenter 종료와 Git 필터를 확인한다.
3. Git 자산만 stage하고 변경이 있을 때만 자동 커밋한다.
4. pull 후 이 PC용 경로를 적용하고 push한다.
5. Nextcloud 연결을 기다린 뒤 미디어를 bisync한다.
6. 결과와 로그 경로를 표시한다.

자동 커밋은 `예배 세션 자동 동기화 YYYY-MM-DD HH:mm` 형식이다.
Git이 실패해도 Nextcloud는 별도로 시도한다. 네트워크는 5초 간격으로
최대 60회 확인하며 실패 창만 사용자가 닫을 때까지 유지한다.

| 예약 작업 | 역할 |
|---|---|
| `PP-StartupSync` | 로그인 동기화와 작업 복구 |
| `PP-SessionWatcher` | ProPresenter 본체 종료 감시 |
| `PP-SessionSync` | 종료 후 별도 동기화 실행 |

Mac은 로그인 Nextcloud 동기화만 지원한다. 정상 종료 전 동기화 완료를
확인하며 정전과 강제 종료는 다음 로그인 동기화에서 복구한다.
