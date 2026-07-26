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
  Media/Assets/     ← Git LFS (정본 미디어)
  Media/Downloads|Import|Imported|ProContent/ ← gitignore (PP 런타임)
  Configuration/    ← gitignore — PC별
```

**콘텐츠 모델:** PP UI = 재생목록 → `Libraries/…/*.pro` 참조.

**테마:** `Themes/` = PP UI 테마. 프로필·재생목록 매핑 → [../handoff/theme-profiles.md](../handoff/theme-profiles.md)

**PP 설정:** Library / Support Files / Media → Show Directory 하위. `%APPDATA%\LocalWorkspaces` 혼용 금지.

## Git

**포함:** `Libraries/`, `Playlists/`, `Presets/`, `Themes/`, `Fonts/`, `Media/Assets/` (Git LFS)  
**제외:** `Media/` 런타임 하위, `Configuration/`, `.env`

**글꼴:** PP는 OS 설치 글꼴만 참조. 바이너리 정본 = `Fonts/` + `manifest.json`. OS 설치 → [../handoff/fonts.md](../handoff/fonts.md).

**LFS:** `.gitattributes` — `*.png` `*.jpg` `*.mp4` `*.ttf` `*.otf` 등. 각 PC에 [Git LFS](https://git-lfs.com/) 설치·`git lfs install` 1회.

- `origin` = `https://github.com/EHWIYA/pro-presenter-data`
- init·remote add **이미 완료** — 재실행 금지
- 작업 전 ProPresenter **완전 종료**

## 동기화

| 시점 | 동작 |
|------|------|
| **신규 PC 1회** | Win: `powershell -File scripts/setup-git-filters.ps1` · Mac: `./scripts/setup-git-filters.sh` |
| PP 시작 전 | `git pull --rebase` (PP 종료) → 경로 **자동** smudge |
| 예배 후 | `git add` / `commit` / `push` → 경로 **자동** clean (Git=portable) |

```powershell
# Windows
cd "$env:USERPROFILE\Documents\pro-presenter"
# powershell -File scripts/setup-git-filters.ps1   # 신규만 1회
git pull --rebase
git add Libraries/ Playlists/ Presets/ Themes/ Fonts/ Media/Assets/
git commit -m "..."
git push
```

```bash
# macOS
cd "$HOME/Documents/pro-presenter"
# chmod +x scripts/setup-git-filters.sh && ./scripts/setup-git-filters.sh   # 신규만 1회
git pull --rebase
git add Libraries/ Playlists/ Presets/ Themes/ Fonts/ Media/Assets/
git commit -m "..."
git push
```

**충돌:** 수정 → `git add` → `git rebase --continue` (또는 `--abort`).

### 재생목록 경로 (Win · Mac)

| 위치 | Windows | macOS |
|------|---------|-------|
| **Git 객체 (공통)** | `%USERPROFILE%\Documents\pro-presenter\…` | 동일 (백슬래시 portable) |
| **working tree (PP용)** | `C:\Users\<계정>\Documents\pro-presenter\…` | `/Users/<계정>/Documents/pro-presenter/…` |

`Playlists/Library` · `Playlists/Media` · `Libraries/LibraryData`는 Git **pp-paths** clean/smudge filter + `scripts/githooks`가 변환한다. Mac에서는 portable→POSIX 경로로 바꿀 때 **구분자(`/`)까지** 맞춘다. 상대 경로 `Libraries/…`는 OS 공통(슬래시).

문자열만 바꾸면 protobuf 길이 필드가 깨져 재생목록이 사라짐 → 반드시 이 스크립트 사용.

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
