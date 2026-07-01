# 테마 프로필 · 재생목록 · 미디어 (data repo 정본)

> 2026-07-01 갱신. PP Show Directory `Libraries/`·`Playlists/`·`Themes/` 실측.
> 에이전트 연동: [agent.md](agent.md) · 스냅샷 export는 agent `scripts/dev/export_theme_snapshot.py`.

## PP 테마 vs 프로필 vs agent

PP **테마** = `Themes/<이름>/Theme` 안에 **테마 슬라이드(레이아웃 템플릿) N장**. Libraries 슬라이드 수와 무관.

| 프로필 (정본 키) | PP Theme | 대표 테마 슬라이드 | agent `theme_templates` | agent 스냅샷 |
|------------------|----------|-------------------|-------------------------|--------------|
| `song_lyric` | `Themes/찬양+성가` | 가운데 `content_text` (2장 중 기본) | `lyric` | `template/themes/lyric.pro` |
| `sermon` | `Themes/말씀` | 4장 중 제목+본문 4 element (기본) | `sermon`, `reader-context`(별칭) | `template/themes/sermon.pro` |
| `worship_text` | — | — | 미등록 | 수동 |
| `worship_titled` | — | — | 미등록 | 수동 |
| `bg_image` | — | — | 미등록 | 수동 |
| `image_sequence` | — | — | 미등록 | 수동 |
| `mixed` / `empty` | — | — | 미등록 | 수동 |

- **디자인 정본:** PP `Themes/` → Libraries에 적용(베이크) → 필요 시 Libraries 대표 `.pro` 첫 슬라이드를 agent에 **re-export**.
- **자동 빌드:** agent는 `template/themes/*.pro`만 사용 (PP `Themes/` 파일 형식과 다름).

### 스냅샷 재동기화 (PP Themes 수정 후)

```powershell
cd C:\pro-presenter-agent
.\.venv\Scripts\python.exe scripts\dev\export_theme_snapshot.py `
  --src "$env:USERPROFILE\Documents\pro-presenter\Libraries\찬양\먼저 그 나라와 의를 구하라.pro" `
  --dest template/themes/lyric.pro --name lyric-template
.\.venv\Scripts\python.exe scripts\dev\export_theme_snapshot.py `
  --src "$env:USERPROFILE\Documents\pro-presenter\Libraries\말씀\260621-말씀.pro" `
  --dest template/themes/sermon.pro --name sermon-template
Copy-Item template\themes\sermon.pro template\worship-template.pro -Force
```

검증: agent repo에서 `python -m pro_presenter_agent.cli.main inspect-template` · `unittest tests.test_theme_templates`.

## 콘텐츠 모델

```
Playlists/Library          ← PP UI 재생목록 (바이너리 protobuf, Git)
  └── 2026 / 06 / 260621_worship_2
        └── 항목 → Libraries/<카테고리>/<이름>.pro

Libraries/*.pro            ← 슬라이드 실체 (Git)
Themes/<그룹>/Theme        ← PP UI 테마 정의 (Git)
Media/Assets/*             ← 미디어 (Git LFS)
```

- 재생목록 항목은 **절대경로 + 상대경로** `Libraries/…/*.pro` 둘 다 저장.
- `.pro` 안 미디어는 `url.local.path` = `Media/Assets/…` (Show Directory 기준).
- PP 테마는 `.pro`에 **UUID 참조가 아니라 슬라이드 레이아웃으로 베이크**됨.
- agent `template/themes/*.pro` = 빌드용 복제 원본 (**PP `Themes/`와 별개**).

## 현재 재생목록 `260621_worship_2` (15항목)

| # | 표시명 | Libraries 경로 | 슬라이드 | 테마 프로필 |
|---|--------|----------------|----------|-------------|
| 1 | 시작 전 | `예배/시작 전.pro` | 2 | `bg_image` |
| 2 | 먼저 그 나라와 의를 구하라 | `찬양/먼저 그 나라와 의를 구하라.pro` | 9 | `song_lyric` |
| 3 | 413.내 평생에 가는 길 | `찬송가/413.내 평생에 가는 길.pro` | 14 | `song_lyric` |
| 4 | 주님 말씀하시면 | `찬양/주님 말씀하시면.pro` | 9 | `song_lyric` |
| 5 | 성령이 오셨네 | `찬양/성령이 오셨네.pro` | 8 | `song_lyric` |
| 6 | 때가 차매 | `찬양/때가 차매.pro` | 4 | `song_lyric` (+ 마지막 `bg_image`) |
| 7 | 사도신경 | `예배/사도신경.pro` | 3 | `image_sequence` |
| 8 | 교독문-000 | `교독문/교독문-000.pro` | 2 | `bg_image` (2번째 슬라이드) |
| 9 | HCC뉴스 | `예배/HCC뉴스.pro` | 1 | `empty` (미연결) |
| 10 | 기도 | `예배/기도.pro` | 2 | `bg_image` + `worship_text` |
| 11 | 주의 축복 내려주소서 | `성가곡/주의 축복 내려주소서.pro` | 21 | `mixed` (아래 참고) |
| 12 | 260621-말씀 | `말씀/260621-말씀.pro` | 31 | `sermon` |
| 13 | 모든 상황 속에서 | `찬양/모든 상황 속에서.pro` | 7 | `song_lyric` |
| 14 | 새가족 | `예배/새가족.pro` | 4 | `mixed` (전용) |
| 15 | 봉헌 기도 및 축도 | `예배/봉헌 기도 및 축도.pro` | 2 | `worship_titled` |

`Libraries/예배/worship-2.pro` — 레거시, **이 재생목록에 없음**.

## 테마 프로필 정의

판별 기준: 첫 슬라이드(또는 대표 슬라이드) `base_slide.elements[].element` 패턴.

### `song_lyric` — 찬양+성가 (가장 빈번, 7곡)

| 항목 | 값 |
|------|-----|
| PP Themes | `Themes/찬양+성가/Theme` |
| elements | `content_text` 1개 |
| 폰트 | `NanumGothicExtraBold` |
| 배경 | 녹색 틴트 (`background_color.green ≈ 0.502`) |
| Libraries | `찬양/`, `찬송가/` |
| agent | `lyric` → `template/themes/lyric.pro` · `/build-song` 기본 키 |

### `sermon` — 말씀

| 항목 | 값 |
|------|-----|
| PP Themes | `Themes/말씀/Theme` |
| elements | `title_box`, `title_text`, `content_box`, `content_text` |
| 폰트 | `NanumGothicBold`, `NanumGothicExtraBold`, `ArialMT` |
| Libraries | `말씀/` |
| agent | `sermon` / `reader-context` → `template/themes/sermon.pro` · `/build` |

### `worship_text` — 예배 간이 텍스트

| elements | `content_box`, `content_text` |
| Libraries | `예배/기도.pro` 등 |
| agent | 미등록 |

### `worship_titled` — 예배 타이틀+본문

| elements | `title_box`, `title_text`, `content_box`, `content_text` |
| 폰트 | `ArialMT`, `NanumGothicExtraBold` (Bold 없음 — `sermon`과 구분) |
| Libraries | `예배/봉헌 기도 및 축도.pro` |
| agent | 미등록 |

### `bg_image` — 전면 배경 이미지

| elements | 이름 없는 1 element, `fill.media` |
| 공통 미디어 | `Media/Assets/bg_worship_2.png` |
| 사용 | 시작 전, 교독문-000(2번째), 때가 차매(마지막), 기도(1번째) |
| agent | 미등록 |

### `image_sequence` — 슬라이드당 이미지 1장

| 미디어 | `apostles_creed_01.png`, `_02`, `_03` |
| Libraries | `예배/사도신경.pro` |
| agent | 미등록 |

### `mixed` / `empty` — 수동 유지 권장

| 파일 | 내용 |
|------|------|
| `성가곡/주의 축복 내려주소서` | 1장 빈 슬라이드 → `worship_titled` 타이틀 → 이후 `song_lyric` |
| `예배/새가족` | `content_text`×2, `content_box` 혼합 |
| `예배/HCC뉴스` | 빈 슬라이드 1장. `Media/Assets/hcc_news(26.05.31).mp4` 존재하나 `.pro` 미연결 |

## 공통 미디어 자산

| 상대 경로 | 용도 | 참조 .pro |
|-----------|------|-----------|
| `Media/Assets/bg_worship_2.png` | 예배 공통 배경 | 시작 전, 때가 차매, 교독문-000, 기도 |
| `Media/Assets/apostles_creed_01~03.png` | 사도신경 | 사도신경 |
| `Media/Assets/hcc_news(26.05.31).mp4` | HCC 뉴스 | Media만 (`.pro` 미연결) |

미디어는 `Media/Assets/`에 두고 Git LFS로 commit. 경로는 항상 `ROOT_SHOW` + `Media/Assets/…` 형태로 기록.

## 새 패턴 발생 시 (data repo 절차)

1. **PP에서 제작** — `Themes/` 저장, `Libraries/`에 `.pro`, 필요 시 `Media/Assets/` 추가.
2. **이 문서 갱신** — 프로필 키·elements·미디어·재생목록 매핑 한 줄 추가.
3. **자동화 필요 여부 판단**
   - 연 1~2회·수동 편집 → data만, agent 작업 없음.
   - 주간 반복·`/build`·`/build-song` 대상 → [agent.md](agent.md) § 에이전트 TODO에 항목 추가 후 agent repo 작업.
4. **검증** — PP 종료 → (agent 빌드 시) `.pro` 확인 → 재생목록 반영.
5. **commit** — `Libraries/` `Playlists/` `Themes/` `Media/Assets/` (+ agent 쪽 template·config).

## Libraries 폴더 ↔ 용도

| 폴더 | 용도 | 기본 테마 프로필 |
|------|------|------------------|
| `예배/` | 예배 순서·기도·축도 등 | `bg_image`, `worship_text`, `worship_titled`, `image_sequence` |
| `찬양/` | CCM·찬양 | `song_lyric` |
| `찬송가/` | 찬송가 | `song_lyric` |
| `성가곡/` | 성가곡 | `mixed` |
| `말씀/` | 설교 | `sermon` |
| `교독문/` | 교독 | `bg_image` |
