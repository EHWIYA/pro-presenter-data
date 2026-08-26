# ProPresenter 자동 세션 동기화

## 목표

- PC 로그인 시 Git pull과 Nextcloud 동기화를 실행하고 결과 창을 Enter 전까지 유지한다.
- ProPresenter 본체가 종료되면 자산을 자동 커밋·push하고 Nextcloud를 동기화한다.
- 자동 커밋 메시지는 `예배 세션 자동 동기화 YYYY-MM-DD HH:mm` 형식을 사용한다.
- `Media/Assets`는 Git에 넣지 않고 Nextcloud로만 동기화한다.

## Windows 구현

| 파일 | 역할 |
|---|---|
| `scripts/windows-auto-sync.ps1` | Git commit/pull/push, 경로 적용, Nextcloud 동기화 |
| `scripts/windows-propresenter-watcher.vbs` | 콘솔 종료 신호와 분리된 `ProPresenter.exe` 종료 감시 |
| `scripts/repair-auto-sync-tasks.ps1` | 로그인 시 예약 작업 누락·구버전 정의 자동 복구 |
| `scripts/setup-auto-sync-windows.ps1` | 작업 스케줄러 작업 3개 등록 |

작업 스케줄러의 `PP-StartupSync`는 로그인 시 보이는 PowerShell 창을 연다. `PP-SessionWatcher`는 숨김 상태로 본체 프로세스를 감시하고 종료 후 5초 뒤 별도 예약 작업 `PP-SessionSync`를 실행한다. 감시기와 동기화 창의 프로세스를 분리했으므로 결과 창을 닫아도 다음 종료 감시는 계속된다. 상시 실행되는 `ProPresenter Helper` 프로세스는 감시 대상이 아니다.

로그인 동기화는 세 예약 작업을 현재 저장소의 정의로 매번 다시 등록한다. 작업이 누락되거나 이전 스크립트를 가리켜도 로그인 시 복구되며, 감시기가 비정상 종료되면 작업 스케줄러가 1분 뒤 자동 재시작한다.

자동 커밋 대상은 `Libraries`, `Playlists`, `Presets`, `Themes`, `Fonts`로 제한한다. 변경이 없으면 빈 커밋을 만들지 않는다. Git 작업이 실패해도 Nextcloud 동기화는 별도로 시도하며 로그는 `.nextcloud-sync/auto-sync-logs`에 남긴다.

로그인 직후 Tailscale·네트워크가 아직 준비되지 않아 Nextcloud가 `403` 또는 DNS 오류를 반환할 수 있다. 자동 동기화는 가벼운 연결 확인을 먼저 수행하고, 준비 중에는 사용자에게 오류가 아니라는 대기 안내를 표시한다. 연결 확인과 `nextcloud-sync.bat`는 각각 20초 간격으로 최대 12회 재시도하며, 실패한 bisync의 완료 표식을 제거해 다음 시도에서 `--resync`로 자동 복구한다.

## Mac 적용 방향

Mac도 로그인 시 Terminal 실행과 ProPresenter 종료 감시를 `launchd`로 구성할 수 있다. Windows 자동화가 실제 운영에서 안정화된 뒤 동일 순서로 이식한다. 정상적인 macOS 종료를 확실히 지연하려면 셸 스크립트가 아닌 작은 메뉴 막대 앱이 필요하다.

## 시스템 종료와 정전

ProPresenter 종료 직후 동기화를 시작하므로 정상 종료를 누르기 전에 열린 동기화 창에서 완료를 확인하는 운영을 기본으로 한다. Windows와 macOS 모두 셸 스크립트만으로 시스템 종료를 무기한 차단할 수 없다. 정전이나 전원 버튼 강제 종료는 보호할 수 없으며, 다음 로그인 동기화가 미반영 작업을 다시 처리한다.

## 새 Windows PC 설정

ProPresenter를 완전히 종료한 뒤 저장소 루트에서 다음을 한 번 실행한다.

```powershell
powershell -ExecutionPolicy Bypass -File scripts/setup-git-filters.ps1
powershell -ExecutionPolicy Bypass -File scripts/setup-auto-sync-windows.ps1
```

설정 직후 테스트는 다음 명령으로 실행한다.

```powershell
powershell -ExecutionPolicy Bypass -File scripts/windows-auto-sync.ps1 -Mode Startup -WaitForKey
```
