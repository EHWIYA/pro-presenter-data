# pro-presenter-data

ProPresenter **Show Directory** Git 정본.

| 항목 | 값 |
|------|-----|
| GitHub | [EHWIYA/pro-presenter-data](https://github.com/EHWIYA/pro-presenter-data) |
| 로컬 | `%USERPROFILE%\Documents\pro-presenter` |

## 📹 영상·사진·음악 자동 동기화 설정하기 (새 컴퓨터에서 딱 1번만)

이 폴더 안 `Media\Assets` 에 넣는 영상·사진·음악 파일들은, 아래 설정을 한 번만 해두면 **컴퓨터를 켤 때마다 자동으로** 우리 교회 NAS(Nextcloud)와 서로 최신 상태로 맞춰집니다. 한 컴퓨터에서 파일을 추가하면 다른 컴퓨터에도 자동으로 나타나요. 이후로는 신경 쓸 필요 없이 그냥 컴퓨터를 켜두기만 하면 됩니다.

아래 명령어들은 **뜻을 몰라도 됩니다.** 그대로 복사해서 붙여넣기만 하면 됩니다.

### 1단계. 동기화 프로그램(rclone) 설치

**Windows** — PowerShell을 열고:
```powershell
winget install rclone.rclone
```
> 만약 오류가 나면: https://rclone.org/downloads/ 에서 Windows용을 받아 압축을 풀고, 그 안의 `rclone.exe`를 아무 폴더(예: `C:\Users\내이름\bin`)에 넣은 뒤, 그 폴더를 [환경 변수 PATH에 추가](https://www.google.com/search?q=windows+환경변수+path+추가하는+법)해주세요.

**Mac** — 터미널(Terminal)을 열고:
```bash
brew install rclone
```
> Homebrew가 없다면 먼저 https://brew.sh 안내대로 설치해주세요.

### 2단계. Nextcloud 앱 비밀번호 발급받기

1. 브라우저에서 https://next-cloud.iwhya.kr/settings/user/security 접속 → 로그인
2. 페이지 위쪽 "새 앱 비밀번호 생성" 칸에 아무 이름(예: `pro-presenter-sync`)을 입력하고 생성 버튼 클릭
3. 화면에 나오는 비밀번호를 복사해두세요 (이 화면을 벗어나면 다시 안 보이니, 아직 창을 닫지 마세요)

### 3단계. 위 프로그램에 계정 등록하기

터미널(Windows는 PowerShell, Mac은 터미널)에 `rclone config`라고 입력하고 Enter, 그 다음 아래 순서대로 입력해주세요. (`password>`에서는 2단계에서 복사한 비밀번호를 붙여넣으세요.)

```
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

제대로 됐는지 확인: `rclone size pp-media:` 입력했을 때 파일 개수·용량이 나오면 성공입니다.

### 4단계. 컴퓨터 켤 때 자동 실행되도록 등록

**Windows** — PowerShell에서:
```powershell
powershell -File "%USERPROFILE%\Documents\pro-presenter\scripts\setup-nextcloud-sync-task.ps1"
```
> "액세스가 거부되었습니다" 오류가 나면, 아래 명령어로 대신 등록해주세요.
> ```powershell
> schtasks /create /tn "PP-NextcloudSync" /tr "\"%USERPROFILE%\Documents\pro-presenter\scripts\nextcloud-sync.bat\"" /sc onlogon /rl limited /f
> ```

**Mac** — 터미널에서:
```bash
cp scripts/kr.iwhya.pp.nextcloudsync.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/kr.iwhya.pp.nextcloudsync.plist
```

여기까지 하면 끝입니다. 다음에 컴퓨터를 켤 때부터 자동으로 동기화됩니다. 지금 바로 한번 실행해보고 싶다면 `scripts\nextcloud-sync.bat`(Mac은 `scripts/nextcloud-sync.sh`)를 더블클릭하거나 실행하면 됩니다.

---

## Git (요약)

포함: `Libraries/` `Playlists/` `Presets/` `Themes/` `Fonts/` (LFS) · 제외: `Media/` 전체(런타임 + `Assets/`, Nextcloud 관리), `Configuration/`

```powershell
cd "$env:USERPROFILE\Documents\pro-presenter"
# 신규 PC 1회: powershell -File scripts/setup-git-filters.ps1
# macOS:       ./scripts/setup-git-filters.sh
git pull
# PP 종료 후
git add Libraries/ Playlists/ Presets/ Themes/
git commit -m "..." ; git push
```

`Media/Assets/`(영상·음원·이미지)는 git이 아닌 Nextcloud로 동기화한다. 상세: [docs/data/repo.md](docs/data/repo.md)

재생목록 경로는 pull/commit 시 **자동** 변환 (Win·Mac, setup 1회). 상세: [docs/data/repo.md](docs/data/repo.md) · 에이전트 안내: [AGENTS.md](AGENTS.md) · 목차: [docs/index.md](docs/index.md)
