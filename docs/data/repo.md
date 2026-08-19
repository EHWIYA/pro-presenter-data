# pro-presenter-data (이 repo)

## 경로

| OS | Show Directory |
|----|----------------|
| Windows | `%USERPROFILE%\Documents\pro-presenter` |
| Mac | `~/Documents/pro-presenter` |

Git working copy = PP Show Directory. 경로 템플릿: [paths.standard.json](../../paths.standard.json)

**Mac iCloud (정책 A, 1회):** 시스템 설정 → Apple ID → iCloud → iCloud Drive → **「바탕화면 및 Documents 폴더」 OFF**. Git·`.pro` 잠금 충돌 방지.

### Mac 최초 clone

```bash
git clone https://github.com/EHWIYA/pro-presenter-data.git "$HOME/Documents/pro-presenter"
```

PP 설정 → Show Directory를 위 경로로 맞출 것.

## 폴더

```
Documents/pro-presenter/
  Libraries/        ← .pro (Git)
  Playlists/        ← 재생목록 (Git) — PP UI 표시 기준
  Presets/, Themes/ ← Git
  Fonts/            ← Git LFS (정본 글꼴 바이너리)
  Media/Assets/     ← Nextcloud (정본 미디어, Git 제외 — 아래 참고)
  Media/Downloads|Import|Imported|ProContent/ ← gitignore (PP 런타임)
  Configuration/    ← gitignore — PC별
```

**콘텐츠 모델:** PP UI = 재생목록 → `Libraries/…/*.pro` 참조.

**테마:** `Themes/` = PP UI 테마. 프로필·재생목록 매핑 → [../handoff/theme-profiles.md](../handoff/theme-profiles.md)

**PP 설정:** Library / Support Files / Media → Show Directory 하위. `%APPDATA%\LocalWorkspaces` 혼용 금지.

## Git

**포함:** `Libraries/`, `Playlists/`, `Presets/`, `Themes/`, `Fonts/` (Git LFS)  
**제외:** `Media/` 전체(런타임 + `Assets/` 모두 — 아래 Nextcloud 참고), `Configuration/`, `.env`

**글꼴:** PP는 OS 설치 글꼴만 참조. 바이너리 정본 = `Fonts/` + `manifest.json`. OS 설치 → [../handoff/fonts.md](../handoff/fonts.md).

**LFS:** `.gitattributes` — `Fonts/*.ttf` `Fonts/*.otf` 만. 각 PC에 [Git LFS](https://git-lfs.com/) 설치·`git lfs install` 1회.

- `origin` = `https://github.com/EHWIYA/pro-presenter-data`
- init·remote add **이미 완료** — 재실행 금지
- 작업 전 ProPresenter **완전 종료**

## 미디어 (Media/Assets) — Nextcloud

2026-08 기준 `Media/Assets/`(영상·음원·이미지)는 **Git에서 제외**하고 자체 NAS의 Nextcloud로 관리한다. GitHub 무료 Git LFS 한도(저장 1GB·대역폭 1GB/월)를 캠프 영상 등으로 초과해 `git pull`이 계속 막혔던 문제 때문.

GUI 클라이언트 대신 **rclone bisync**로 CLI 자동 동기화한다 (`scripts/nextcloud-sync.bat`/`.sh`).

| 시점 | 동작 |
|------|------|
| **신규 PC 1회** | rclone 설치 → `rclone config`로 원격 `pp-nextcloud` 등록 (WebDAV, 앱 비밀번호 사용) → Win: `powershell -File scripts/setup-nextcloud-sync-task.ps1` (로그온 시 1회 자동 실행 등록) · Mac: `cp scripts/kr.iwhya.pp.nextcloudsync.plist ~/Library/LaunchAgents/ && launchctl load ~/Library/LaunchAgents/kr.iwhya.pp.nextcloudsync.plist` |
| PC 켤 때 | `nextcloud-sync.bat`/`.sh`가 자동 1회 실행 → `Media/Assets` ↔ NAS `04_교회자료/PP_Media_Assets` 양방향 동기화 |
| 미디어 추가·수정 후 즉시 반영하고 싶을 때 | 수동으로 `scripts/nextcloud-sync.bat`(또는 `.sh`) 재실행 |
| 문제 확인 | 로그: `.nextcloud-sync/sync.log` (git 제외) |

- `Media/Assets/`는 `.gitignore` 대상 — git으로 커밋/푸시/풀 하지 않는다.
- `Libraries/*.pro`·`Playlists/*`는 지금처럼 그대로 git으로 관리 — 파일명(경로)이 두 시스템을 잇는 유일한 연결고리이므로 미디어 파일명을 git 커밋과 별개로 마음대로 바꾸지 않는다.
- 과거(2026-08 이전) 커밋에 남아있는 Git LFS 이력은 아직 정리 전 — 별도 작업으로 예정.

## 동기화

| 시점 | 동작 |
|------|------|
| **신규 PC 1회** | Win: `powershell -File scripts/setup-git-filters.ps1` · Mac: `./scripts/setup-git-filters.sh` |
| PP 시작 전 | `git pull --rebase` (PP 종료) — checkout은 portable 유지 · **Changes 없음** |
| PP 열기 직전 | `python3 scripts/pp_path_normalize.py smudge-files` (이 PC 절대경로) |
| 예배 후 | `git add` / `commit` / `push` → 경로 **자동** clean (Git=portable) |

```powershell
# Windows
cd "$env:USERPROFILE\Documents\pro-presenter"
# powershell -File scripts/setup-git-filters.ps1   # 신규만 1회
git pull --rebase
python scripts/pp_path_normalize.py smudge-files   # PP 열기 직전
git add Libraries/ Playlists/ Presets/ Themes/ Fonts/
git commit -m "..."
git push
```

```bash
# macOS
cd "$HOME/Documents/pro-presenter"
# chmod +x scripts/setup-git-filters.sh && ./scripts/setup-git-filters.sh   # 신규만 1회
git pull --rebase
python3 scripts/pp_path_normalize.py smudge-files   # PP 열기 직전
git add Libraries/ Playlists/ Presets/ Themes/ Fonts/
git commit -m "..."
git push
```

**충돌:** 수정 → `git add` → `git rebase --continue` (또는 `--abort`).

### 재생목록 경로 (Win · Mac)

| 위치 | Windows | macOS |
|------|---------|-------|
| **Git 객체 (공통)** | `%USERPROFILE%\Documents\pro-presenter\…` | 동일 (백슬래시 portable) |
| **working tree (PP용)** | `C:\Users\<계정>\Documents\pro-presenter\…` | `/Users/<계정>/Documents/pro-presenter/…` |

`Playlists/Library` · `Playlists/Media` · `Libraries/LibraryData`는 Git **pp-paths** clean filter(커밋 시) + **명시적** `smudge-files`(PP 직전)로 변환한다. checkout/pull의 smudge filter는 identity라 Discard해도 파일이 다시 안 바뀐다. 상대 경로 `Libraries/…`는 OS 공통(슬래시).

문자열만 바꾸면 protobuf 길이 필드가 깨져 재생목록이 사라짐 → 반드시 이 스크립트 사용.

**smudge-files / pull 전 ProPresenter 완전 종료.** PP가 켜진 채 `LibraryData`를 바꾸면 라이브러리 `.pro`가 대량 삭제될 수 있다.

**`.pro` RTF (Win · Mac):** Windows PP는 보통 `rtf0` + `\uXXXX` 유니코드, Mac PP는 `cocoartf` + `ansicpg949` 로 저장한다. Mac에서 다시 저장한 곡을 Windows에서 열면 한글이 비거나 깨질 수 있음 → 해당 곡은 Windows에서 한 번 열어 저장하거나, 직전 Windows 커밋 내용으로 되돌린다.

**경로 유니코드 (NFC):** Mac PP는 재생목록/`LibraryData` 경로를 NFD(자모 분해, `file:` URL percent-encoding 포함)로 넣는다. Windows 디스크·Git 트리는 NFC라 NFD 문자열은 파일을 못 찾는다 → `pp_path_normalize` smudge/clean이 **NFC로 정규화**한다.

**라이브러리 UI 중복:** macOS는 PP가 `~/Library/Application Support/.../UserWorkspaces/<show>/Libraries/LibraryData` 에 별도 인덱스를 둔다. 여기에 같은 `.pro`가 2번 등록되면 라이브러리/찬양 목록이 2배로 보인다. **PP 완전 종료 후** 정리.

## 곡 정본 (Libraries)

곡 슬라이드 실체는 `Libraries/{찬양|찬송가|성가곡}/<제목>.pro` 만 main에 둔다. (예배·말씀·교독문 등 비곡 콘텐츠는 별도 카테고리.)

| 규칙 | 내용 |
|------|------|
| 파일 stem | 곡 제목과 **완전 일치** |
| fixture 금지 | `성가테스트`, `테스트곡`, `빌드곡`, `주님의 마음` mock 등 — data repo에 commit 안 함 |
| 예배 후 | PP 편집 → commit/push → 다른 PC는 `git pull` |

**완료 기준:** main에 운영 곡만 존재 · push 후 `git rev-parse HEAD` revision 공유.

## 다른 현장 PC

동일 `.gitignore` → clone 후 setup **1회** → Show Directory를 OS별 경로로.

| OS | setup |
|----|-------|
| Windows | `powershell -File scripts/setup-git-filters.ps1` |
| macOS | `./scripts/setup-git-filters.sh` |

Win ↔ Mac 자산 내용은 동일. 절대 경로·구분자는 filter가 PC별로 맞춤. Mac는 iCloud「바탕화면 및 Documents」OFF (위 정책 A).
