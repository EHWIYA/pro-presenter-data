# Fonts (정본)

ProPresenter는 글꼴 파일을 쇼 문서에 넣지 않고 **OS에 설치된 글꼴 이름**만 참조합니다.  
여기는 현장 PC가 동일하게 맞출 **글꼴 바이너리 정본**입니다. OS 설치 자동화는 에이전트 런처 → [docs/handoff/fonts.md](../docs/handoff/fonts.md).

## 포함 글꼴

| 파일 | PP 참조명 | 용도 |
|------|-----------|------|
| `NanumGothic-Regular.ttf` | `NanumGothic`, `NanumGothicR` | 예비 (현재 Themes 미사용) |
| `NanumGothic-Bold.ttf` | `NanumGothicBold`, `NanumGothicBoldR` | 말씀 테마 |
| `NanumGothic-ExtraBold.ttf` | `NanumGothicExtraBold`, `NanumGothicExtraBoldR` | 찬양·성가 테마 |

기계 판독: `manifest.json` · 라이선스: `OFL.txt` (SIL Open Font License 1.1).

## 글꼴 추가·변경

1. `Fonts/`에 `.ttf`/`.otf` 추가 (Git LFS).
2. `manifest.json`에 `pp_face_names`·`used_in` 갱신.
3. PP `Themes/`에서 해당 글꼴로 디자인 후 commit.
4. 에이전트 `export_theme_snapshot.py`로 `template/themes/` 재동기화 (에이전트 repo).

**주의:** PP에 보이는 글꼴 이름과 OS 설치 후 패밀리명이 일치해야 합니다. 변경 시 에이전트팀에 `manifest.json` 기준 설치 검증 요청.
