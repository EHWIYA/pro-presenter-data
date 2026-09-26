# Windows 운영 PC

2026-09-26 21:00 KST 점검 기준. 계정명, 네트워크 주소, 제품 키,
일련번호와 인증 정보는 기록하지 않음.

## 하드웨어와 Windows

| 항목 | 확인값 |
|---|---|
| 본체 | 제조사 정보 없음, ASRock X300M-STX, UEFI BIOS P1.70 |
| 운영체제 | Windows 11 Home 25H2, 빌드 26200.9445, 64비트 |
| CPU | AMD Ryzen 5 5600G, 6코어 12스레드 |
| 메모리 | Samsung DDR4 16GB 1개, 3200MHz |
| 그래픽 | AMD Radeon Graphics, 드라이버 31.0.21925.1001 |
| 화면 | 1920×1080 기본 화면 1대 감지 |
| 네트워크 | Realtek PCIe GbE 유선 연결, 협상 속도 100Mbps |
| 입력 장치 | Camo 카메라, High Definition Audio 장치 |

## 저장장치

| 드라이브 | 장치 | 전체·여유 공간 | 상태 |
|---|---|---|---|
| C | Samsung MZVL2256HCHQ 256GB NVMe SSD | 237.4·24.3GB | 정상, 여유 공간 부족 |
| G | Google Drive 가상 드라이브 | 15.0·4.0GB | 정상 |

## 운영 소프트웨어

- ProPresenter 21.4.2, OBS Studio 32.1.2.
- Git 2.53.0, Git LFS 3.7.1, Python 기본 3.13.12, rclone 1.75.0.
- 필수 나눔고딕 Regular·Bold·ExtraBold는 사용자 글꼴로 설치됨.

## 저장소와 자동 동기화

- `main`과 `origin/main` 일치, hook 경로는 `scripts/hooks`로 설정됨.
- `pp-paths` 필터가 설정됐고 다른 PC의 절대경로 없음.
- `PP-StartupSync`와 `PP-SessionSync` 최근 결과 정상.
- `PP-SessionWatcher` 실행 중이며 실제 감시기 1개만 유지됨.
- Nextcloud 양방향 동기화 성공, 로컬·원격 각 193개와 차이 0개.

## 확인 필요

- 구성 요소 교체와 파일 이름 변경 작업의 재부팅 대기가 남아 있음.
- C 드라이브 여유 공간이 24.3GB, 10% 수준이라 정리 필요.
- Intel Wireless Bluetooth 장치가 오류 코드 31로 감지됨.
- Secure Boot는 일반 사용자 권한으로 확인하지 못했고 TPM 값도 확인되지 않음.
