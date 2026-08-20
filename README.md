# pro-presenter-data

ProPresenter **Show Directory** Git 정본.

| 항목 | 값 |
|------|-----|
| GitHub | [EHWIYA/pro-presenter-data](https://github.com/EHWIYA/pro-presenter-data) |
| 로컬 | `%USERPROFILE%\Documents\pro-presenter` |

## 새 Windows PC에서 처음 한 번만 설정

설정을 마치면 다음 작업이 자동으로 실행됩니다.

- PC 로그인 시 GitHub 최신 자료와 Nextcloud 미디어를 받습니다.
- 작업 결과가 PowerShell에 표시되고 Enter를 눌러야 창이 닫힙니다.
- ProPresenter를 종료하면 변경 자료를 자동 커밋·push합니다.
- 자동 커밋 메시지는 `예배 세션 자동 동기화 2026-08-20 14:30` 형식입니다.
- 마지막으로 Nextcloud 미디어를 동기화하고 Enter 입력을 기다립니다.

설정과 동기화 중에는 ProPresenter를 완전히 종료하세요.

### 1단계. Git과 rclone 설치

PowerShell에서 다음 명령을 각각 실행합니다.

```powershell
winget install Git.Git
winget install GitHub.GitLFS
winget install rclone.rclone
```

### 2단계. 저장소 준비

처음 설치하는 PC라면 다음 위치에 저장소를 받습니다. 이미 폴더가 있다면 clone하지 않습니다.

```powershell
git clone https://github.com/EHWIYA/pro-presenter-data.git "$env:USERPROFILE\Documents\pro-presenter"
cd "$env:USERPROFILE\Documents\pro-presenter"
git lfs install
powershell -ExecutionPolicy Bypass -File scripts/setup-git-filters.ps1
```

### 3단계. Nextcloud 연결

`Media\Assets`의 영상·사진·음악은 Git이 아니라 교회 Nextcloud와 동기화됩니다.

아래 명령어들은 **뜻을 몰라도 됩니다.** 그대로 복사해서 붙여넣기만 하면 됩니다.

1. 브라우저에서 https://next-cloud.iwhya.kr/settings/user/security 에 로그인합니다.
2. `새 앱 비밀번호 생성`에 `pro-presenter-sync`를 입력하고 생성합니다.
3. 생성된 앱 비밀번호를 복사합니다.
4. PowerShell에서 `rclone config`를 실행하고 아래 값을 사용합니다.

```text
n
name> pp-media
Storage> webdav
url> https://next-cloud.iwhya.kr/remote.php/dav/files/LEEHWI/04_%EA%B5%90%ED%9A%8C%EC%9E%90%EB%A3%8C/PP_Media_Assets
vendor> nextcloud
user> dlgnl117@gmail.com
   (bearer_token 물어보면 그냥 Enter)
y
password> (2단계에서 복사한 비밀번호 붙여넣기)
   (advanced config? 물어보면) n
y
q
```

다음 명령에서 파일 개수와 용량이 나오면 성공입니다.

```powershell
rclone size pp-media:
```

### 4단계. 자동화 등록

```powershell
cd "$env:USERPROFILE\Documents\pro-presenter"
powershell -ExecutionPolicy Bypass -File scripts/setup-auto-sync-windows.ps1
```

`설정 완료`가 나오면 끝입니다. 다음 로그인부터 자동으로 동작합니다.

## 평소 사용법

1. 로그인 동기화 창에서 `모든 동기화가 완료되었습니다`를 확인합니다.
2. Enter를 눌러 창을 닫고 ProPresenter를 사용합니다.
3. 작업이 끝나면 ProPresenter를 완전히 종료합니다.
4. 자동으로 열린 동기화 창에서 완료를 확인합니다.
5. Enter를 누른 뒤 PC를 종료합니다.

동기화 창에 빨간 오류가 나오면 창을 닫지 말고 담당자에게 화면을 전달하세요. 변경이 없으면 자동 커밋은 생성되지 않습니다. 정전과 강제 종료는 보호할 수 없습니다.

Mac은 현재 Nextcloud 동기화만 지원하며 전체 자동화는 Windows 안정화 후 적용합니다. 상세 설계는 [자동 세션 동기화 문서](docs/handoff/auto-session-sync.md)를 참고하세요.

---

## Git (요약)

포함: `Libraries/` `Playlists/` `Presets/` `Themes/` `Fonts/` (LFS) · 제외: `Media/` 전체(런타임 + `Assets/`, Nextcloud 관리), `Configuration/`

```powershell
cd "$env:USERPROFILE\Documents\pro-presenter"
# 신규 PC 1회: powershell -File scripts/setup-git-filters.ps1
# macOS:       ./scripts/setup-git-filters.sh
git pull --rebase
```

`Media/Assets/`(영상·음원·이미지)는 git이 아닌 Nextcloud로 동기화한다. 상세: [docs/data/repo.md](docs/data/repo.md)

재생목록 경로는 pull/commit 시 **자동** 변환 (Win·Mac, setup 1회). 상세: [docs/data/repo.md](docs/data/repo.md) · 에이전트 안내: [AGENTS.md](AGENTS.md) · 목차: [docs/index.md](docs/index.md)
