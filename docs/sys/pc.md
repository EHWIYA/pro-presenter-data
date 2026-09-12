# Windows 운영 PC

2026-09-12 22:56 KST 점검 기준. 계정명, 네트워크 주소, 제품 키,
일련번호와 인증 정보는 기록하지 않는다.

## 하드웨어와 Windows

| 항목 | 확인값 |
|---|---|
| 본체 | MSI MS-7C67, MAG B365M MORTAR, UEFI BIOS 1.10 |
| 운영체제 | Windows 11 Home 25H2, 빌드 26200.9445, 64비트 |
| CPU | Intel Core i5-9400F, 6코어 6스레드 |
| 메모리 | Samsung DDR4 16GB 2개, 총 32GB, 2667MHz |
| 그래픽 | NVIDIA GeForce GTX 1660 SUPER, 드라이버 591.86 |
| 화면 | 점검 시 1920×1080 기본 화면 1대 감지 |
| 네트워크 | Intel I219-V 유선 연결, 협상 속도 100Mbps |
| 입력 장치 | DICOTA D31841 카메라·마이크, MATA STUDIO C10 오디오 |

## 저장장치

| 드라이브 | 장치 | 전체·여유 공간 | 상태 |
|---|---|---|---|
| C | Samsung 970 EVO Plus 500GB NVMe SSD | 464.7·116.4GB | 정상 |
| D | Seagate ST2000DM008 2TB SATA HDD | 1863.0·1635.1GB | 정상 |
| I | Toshiba 4TB USB 외장 디스크 `DataHub` | 3725.9·2581.6GB | 정상 |

## 운영 소프트웨어

- ProPresenter 21.4.2, OBS Studio 32.0.4.
- Git 2.50.1, Git LFS 3.7.0, Python 기본 3.14.0, rclone 1.75.0.
- Python 3.13.14도 설치되어 있고 Git 경로 필터는 이 버전을 사용한다.
- 필수 나눔고딕 Regular·Bold·ExtraBold는 사용자 글꼴로 설치됨.

## 저장소와 자동 동기화

- `main`과 `origin/main`이 일치하고 hooks 경로와 `pp-paths` 필터가 설정됨.
- `PP-StartupSync` 최근 결과는 성공, `PP-SessionWatcher`는 실행 중.
- `PP-SessionSync` 최근 결과 `0xC000013A`는 다음 정상 종료 뒤 재확인 필요.
- 최근 rclone 양방향 동기화 성공은 2026-09-11 18:33.
- 원격 186개와 로컬 185개가 일치하지 않으며 원격의
  `HCC_뉴스/26.09.13(HCC).mp4`가 아직 로컬에 없음.

## 확인 필요

- 2026-09-10 부팅 뒤 파일 교체 재부팅 대기가 남아 있어 재부팅 필요.
- USB 설명자 요청 실패 장치 한 개가 오류 코드 43으로 계속 감지됨.
- Secure Boot 상태는 일반 사용자 권한으로 확인하지 못했고 TPM은 감지되지 않음.
- 9월 11일 DISM 복구 완료 뒤 SFC 무결성 위반 없음은 확인됨.
