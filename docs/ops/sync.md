# 자동 세션 동기화

Windows는 로그인과 ProPresenter 종료 시 Git과 Nextcloud를 동기화한다.

## 순서

1. Windows의 예약 작업 설정이 없으면 다시 만든다.
2. ProPresenter 종료와 Git 필터를 확인한다.
3. Git으로 관리하는 파일만 `git add`하고 변경이 있을 때만 자동 커밋한다.
4. `git pull`로 원격 변경을 받은 뒤 이 PC의 경로를 적용하고 `git push`한다.
5. Nextcloud가 연결되면 미디어를 양방향으로 동기화한다.
6. 결과와 로그 경로를 표시한다.

자동 커밋은 `예배 세션 자동 동기화 YYYY-MM-DD HH:mm` 형식이다.
Git이 실패해도 Nextcloud는 별도로 시도한다. 네트워크는 5초 간격으로
최대 60회 확인하며 실패 창만 사용자가 닫을 때까지 유지한다.

| 예약 작업 | 역할 |
|---|---|
| `PP-StartupSync` | 로그인할 때 동기화하고 빠진 예약 작업을 다시 만든다. |
| `PP-SessionWatcher` | ProPresenter가 종료됐는지 확인한다. |
| `PP-SessionSync` | ProPresenter 종료 후 동기화를 실행한다. |

Mac은 로그인 Nextcloud 동기화만 지원한다. 정상 종료 전 동기화 완료를
확인하며 정전과 강제 종료는 다음 로그인 동기화에서 복구한다.
