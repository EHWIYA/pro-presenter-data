# Handoff → pro-presenter-agent

**`C:\pro-presenter-agent` Cursor 대화에 붙여넣기.** 코드 변경은 agent repo에서만.

테마·재생목록·미디어 정본: [theme-profiles.md](theme-profiles.md)

## Repo 분리

| | GitHub | 로컬 |
|--|--------|------|
| **에이전트 (작업 대상)** | EHWIYA/pro-presenter-agent | `C:\pro-presenter-agent` |
| **PP 자산** | EHWIYA/pro-presenter-data | `%USERPROFILE%\Documents\pro-presenter` |

## config.json (현장 PC)

`%USERPROFILE%`만 PC마다 다름. 사용자명 하드코딩 금지.

```json
{
  "pp_show_directory": "%USERPROFILE%\\Documents\\pro-presenter",
  "pp_library_dir": "%USERPROFILE%\\Documents\\pro-presenter\\Libraries\\예배",
  "sync_assets_on_launch": true,
  "presentation_filename": "worship-2.pro",
  "presentation_repo_path": "%USERPROFILE%\\Documents\\pro-presenter\\Libraries\\예배\\worship-2.pro",
  "template_pro": "template/worship-template.pro",
  "nas_api": "http://100.88.40.125:8003",
  "agent_port": 8787,
  "pp_api": "http://127.0.0.1:12135"
}
```

`paths.standard.json`(data repo)과 정합 유지.

## 담당 분리

| 담당 | 업무 |
|------|------|
| **에이전트 (Python)** | `/build`, `/build-song`, `/trigger`, `.pro` 생성 |
| **런처 (PowerShell)** | PP↔에이전트 생명주기, 자산 repo `git pull` |
| **data repo** | `Libraries/` `Playlists/` `Themes/` `Media/` — PP UI 정본 |

## 워크플로

| 작업 | 어디서 |
|------|--------|
| 예배 시작 | `launch-worship.bat` |
| 수동 pull | `scripts\sync-assets-repo.ps1` |
| 예배 후 자산 공유 | data repo → commit/push |
| 점검 | `GET http://127.0.0.1:8787/collect-info` |

## 에이전트 TODO (data repo 분석 결과)

현재 재생목록 `260621_worship_2` = 15개 `Libraries/*.pro` 참조. 상세 매핑은 [theme-profiles.md](theme-profiles.md).

### 우선순위 1 — `song_lyric` (찬양+성가) 자동 빌드

- **현황:** `theme_templates`에 `reader-context`(말씀)만 있음. 찬양 6곡·찬송가 1곡은 `song_lyric` 프로필인데 agent 키 없음.
- **PP 원본:** `Themes/찬양+성가/Theme` — element `content_text`, 폰트 `NanumGothicExtraBold`.
- **요청:**
  1. PP에서 슬라이드 1장 export → `template/themes/lyric.pro` (또는 동등 이름).
  2. `config.json` → `theme_templates`에 `"lyric": "template/themes/lyric.pro"` 등록.
  3. `/build-song` 기본 `group_theme_key`를 `lyric`으로 (또는 요청별 지정).
  4. 출력 경로: `Libraries/찬양/<곡명>.pro` (재생목록은 data에서 수동·별도 자동화).

### 우선순위 2 — 빌드 출력 경로 모델 정합

- **현황:** config `pp_library_dir` = `Libraries/예배`, `presentation_filename` = `worship-2.pro` — **레거시 단일 파일 모델**.
- **실제:** 재생목록이 카테고리별 `.pro` 15개 참조. `worship-2.pro`는 재생목록에 없음.
- **요청:** `/build`·`/build-song`이 `Libraries/<카테고리>/<이름>.pro`에 쓰도록 API·config 확장 (카테고리·파일명 파라미터 또는 convention).

### 우선순위 3 — (선택) 추가 `theme_templates`

| 프로필 | elements | 빈도 | 권장 |
|--------|----------|------|------|
| `worship_text` | content_box + content_text | 낮음 | 필요 시 |
| `worship_titled` | title + content 4종 | 낮음 | 필요 시 |
| `bg_image` | fill.media + bg_worship_2.png | 중간 | 미디어 경로 파라미터화 검토 |
| `mixed` / `empty` | 새가족, 성가곡, HCC뉴스 | 일회성 | **자동화 보류** |

### 미디어 규칙 (빌드 시)

- Show Directory 상대경로: `Media/Assets/…`
- 공통 배경: `Media/Assets/bg_worship_2.png` (4개 .pro에서 사용)
- 절대경로 `C:\Users\…` 하드코딩 금지 — `ROOT_SHOW` + `local.path` 패턴 유지.

### 검증 체크리스트

1. `lyric` 키로 빌드한 `.pro` 첫 슬라이드 = `content_text` + `NanumGothicExtraBold`.
2. `reader-context` 빌드 = `title_*` + `content_*` 4 element (기존과 동일).
3. 빌드 결과를 PP 재생목록에 넣었을 때 슬라이드·미디어 정상 표시.

## 레거시 (사용 줄임)

- agent `presentations/worship-2.pro` — data repo로 이전됨
- `Libraries/예배/worship-2.pro` — 재생목록 미사용
- `repo-pull` / `repo-push` — library path = repo path면 불필요

## 하지 말 것

- `Documents\pro-presenter`에 agent `.venv` / config 넣기
- NAS Docker화
- 두 repo git remote 혼동
- `Media/` `Configuration/` 을 data repo에 commit

전체 맥락: [../system/overview.md](../system/overview.md) · data repo [../index.md](../index.md)
