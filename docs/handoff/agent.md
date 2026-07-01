# Handoff → pro-presenter-agent

**`C:\pro-presenter-agent` Cursor 대화에 붙여넣기.** 코드 변경은 agent repo에서만.

테마·재생목록·미디어 정본: [theme-profiles.md](theme-profiles.md)

## Repo 분리

| | GitHub | 로컬 |
|--|--------|------|
| **에이전트 (작업 대상)** | EHWIYA/pro-presenter-agent | `C:\pro-presenter-agent` |
| **PP 자산** | EHWIYA/pro-presenter-data | `%USERPROFILE%\Documents\pro-presenter` |

## config.json (현장 PC)

`%USERPROFILE%`만 PC마다 다름. `theme_templates`·`template_pro`는 코드 기본값과 같으면 생략 가능.

```json
{
  "pp_show_directory": "%USERPROFILE%\\Documents\\pro-presenter",
  "sync_assets_on_launch": true,
  "template_pro": "template/themes/sermon.pro",
  "theme_templates": {
    "sermon": "template/themes/sermon.pro",
    "reader-context": "template/themes/sermon.pro",
    "lyric": "template/themes/lyric.pro"
  },
  "nas_api": "http://100.88.40.125:8003",
  "agent_port": 8787,
  "pp_api": "http://127.0.0.1:12135"
}
```

빌드 시 `library_category`·`presentation_filename`(또는 `song_title`)으로 `Libraries/<카테고리>/<이름>.pro` 지정. 레거시 `worship-2.pro` 단일 경로는 사용하지 않음.

`paths.standard.json`(data repo)과 정합 유지.

## 담당 분리

| 담당 | 업무 |
|------|------|
| **에이전트 (Python)** | `/build`, `/build-song`, `/trigger`, `.pro` 생성 |
| **런처 (PowerShell)** | PP↔에이전트 생명주기, 자산 repo `git pull` |
| **data repo** | `Libraries/` `Playlists/` `Themes/` `Media/Assets/` — PP UI 정본 |

## 워크플로

| 작업 | 어디서 |
|------|--------|
| 예배 시작 | `launch-worship.bat` |
| 수동 pull | `scripts\sync-assets-repo.ps1` |
| 예배 후 자산 공유 | data repo → commit/push (`Media/Assets/` 포함, LFS) |
| PP Themes 수정 후 agent 동기화 | `scripts/dev/export_theme_snapshot.py` ([theme-profiles.md](theme-profiles.md)) |
| 점검 | `GET http://127.0.0.1:8787/collect-info` |

## 테마 템플릿 (완료 · 2026-07-01)

| 항목 | 상태 |
|------|------|
| `template/themes/lyric.pro` | ✅ data `Libraries/찬양` 대표 슬라이드에서 export |
| `template/themes/sermon.pro` | ✅ data `Libraries/말씀` 대표 슬라이드에서 export |
| `template/worship-template.pro` | ✅ `sermon.pro`와 동일 (레거시 별칭) |
| `/build-song` + `lyric` | ✅ 기본 `group_theme_key` · `library_category` |
| `/build` + `sermon` / `reader-context` | ✅ |
| `Libraries/<카테고리>/<이름>.pro` 출력 | ✅ API `library_category`·`presentation_filename` |

### 미등록 (수동 유지)

`worship_text`, `worship_titled`, `bg_image`, `image_sequence`, `mixed`, `empty` — [theme-profiles.md](theme-profiles.md).

### 검증

```powershell
cd C:\pro-presenter-agent
.\.venv\Scripts\python.exe -m unittest tests.test_theme_templates tests.test_build_song_lyric_smoke -v
.\.venv\Scripts\python.exe -m pro_presenter_agent.cli.main inspect-template
```

1. `lyric` 빌드 첫 슬라이드 = `content_text` only.
2. `sermon` / `reader-context` = `title_*` + `content_*` 4 element.
3. PP 재생목록에 넣었을 때 슬라이드·미디어 정상 표시.

## 레거시 (사용 줄임)

- `presentation_filename` = `worship-2.pro` 고정 config
- agent `presentations/worship-2.pro` — data repo로 이전됨
- `Libraries/예배/worship-2.pro` — 재생목록 미사용
- `repo-pull` / `repo-push` — library path = repo path면 불필요

## 하지 말 것

- `Documents\pro-presenter`에 agent `.venv` / config 넣기
- NAS Docker화
- 두 repo git remote 혼동
- `Configuration/` 을 data repo에 commit
- `Media/` 런타임 폴더(Downloads·Import 등) commit

전체 맥락: [../system/overview.md](../system/overview.md) · data repo [../index.md](../index.md)
