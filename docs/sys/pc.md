# Windows 운영 PC

2026-11-07 KST 점검 기준. 계정명, 네트워크 주소, 제품 키,
일련번호와 인증 정보는 기록하지 않음. 용량과 실행 상태는 점검 당시 값.

## 하드웨어와 Windows

| 항목 | 확인값 |
|---|---|
| 메인보드 | ASRock B660M Pro RS |
| 운영체제 | Windows 11 Pro 25H2, 빌드 26200.9711, 64비트 |
| CPU | Intel Core i7-12700F, 12코어 20스레드 |
| 메모리 | Samsung DDR4 16GB 2개, 3200MHz |
| 그래픽 | NVIDIA GeForce RTX 3060 Ti, 드라이버 32.0.16.1088 |
| 네트워크 | Intel I219-V 유선 연결, 협상 속도 1Gbps |
| 장치 오류 | 현재 연결된 장치에서 비정상 상태 감지 없음 |

## 저장장치

| 항목 | 확인값 |
|---|---|
| 물리 디스크 | Samsung SSD 870 EVO 1TB, SHGP31-2000GM 2TB |
| 디스크 상태 | 두 디스크 모두 Healthy / OK |
| C 드라이브 | 전체 376.0GiB, 여유 약 109GiB |

## 운영 소프트웨어

- ProPresenter 21.4.2, OBS Studio 31.1.2.
- Git 2.54.0, Git LFS 3.7.1, Python 기본 3.12.10, rclone 1.75.0.

## 저장소와 자동 동기화

- 점검 시작 시 `main`과 GitHub `main` 일치, 현재 충돌 없음.
- hook 경로는 `scripts/hooks`, `pp-paths` 필터 설정 확인.
- 경로 대상 3개 파일에서 다른 Windows·Mac 사용자 경로 없음.
- 오늘 12:50 로그인 동기화에서 GitHub·Nextcloud 모두 성공.
- Nextcloud 파일 경로·크기 비교: 양쪽 322개, 차이 0개.
- 로컬 미디어 12,116,639,417바이트. 내용 해시 전수 검사는 미실시.
- Windows 자동 재초기화 제거, Mac 실패 종료 코드 전달 테스트 추가.

## 점검 범위

실제 송출 장비와 NAS 내부 디스크·백업·휴지통·버전 복구 상태는 미점검.
기존 PC의 공간 부족·Bluetooth 오류 기록은 현재 PC의 상태로 적용하지 않음.
감시기 재시작 후 복구 명령을 반복해도 실제 감시기 1개와 Running 상태 유지.
이전 `0x800710E0` 대신 실행 중 상태 `0x00041301` 확인.
실제 ProPresenter 정상 종료 후 13:08 세션 동기화 자동 실행 확인.
Nextcloud의 일시적 nginx 403이 재현되어 이전 목록 복구 옵션을 추가함.
13:10:07 기존 목록 복구로 GitHub·Nextcloud 모두 성공, 세션 작업 결과 0.
재초기화 없이 미디어 전송·삭제 0건. Mac 실패 처리는 Git Bash에서 검증.
