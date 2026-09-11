# 자동 세션 동기화

Windows 로그인과 ProPresenter 종료 시 사용자 권한으로 Git과 Nextcloud 자동 동기화.

## 순서

1. Windows의 예약 작업을 현재 사용자 권한과 고정 진입점으로 복구하기.
2. ProPresenter 종료와 Git 필터 확인하기.
3. Git으로 관리하는 파일만 `git add`하고 변경이 있을 때만 자동 커밋하기.
4. `git pull`로 원격 변경을 받은 뒤 이 PC의 경로를 적용하고 `git push`하기.
5. Nextcloud가 연결되면 미디어를 양방향으로 동기화하기.
6. 결과와 기록 파일 경로 표시하기. 예약 작업 복구 실패는 경고로만 기록하기.

자동 커밋은 `예배 세션 자동 동기화 YYYY-MM-DD HH:mm` 형식.
Git이 실패해도 Nextcloud 동기화는 별도로 시도. 네트워크는 5초 간격으로
최대 60회 확인하며 예약 작업은 결과를 기록한 뒤 자동 종료.

| 예약 작업 | 역할 |
|---|---|
| `PP-StartupSync` | 로그인 동기화와 빠진 예약 작업 복구 |
| `PP-SessionWatcher` | ProPresenter 종료 확인 |
| `PP-SessionSync` | ProPresenter 종료 후 동기화 실행 |

Mac은 로그인 시 Nextcloud 동기화만 지원. 정상 종료 전 동기화 완료 확인.
정전과 강제 종료로 빠진 작업은 다음 로그인 동기화에서 복구.
