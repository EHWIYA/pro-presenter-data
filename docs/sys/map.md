# 시스템 개요

## 한 줄 요약

담당자가 ProPresenter에서 예배 자료를 직접 편집하고 송출하며, 같은 자료
폴더를 GitHub와 Nextcloud에 나누어 동기화하는 구조.

## 전체 구성

```text
[담당자] ── 편집·송출 ──▶ [ProPresenter]
                              │
                              ▼
              [Documents/pro-presenter]
                  ├─ 문서·테마·글꼴 ↔ GitHub
                  ├─ 영상·음원·이미지 ↔ Nextcloud
                  └─ Configuration은 PC별 보관
```

GitHub 저장소는 `EHWIYA/pro-presenter-data` 하나만 사용. ProPresenter가
읽는 기본 폴더와 Git 작업 폴더는 같은 위치.

Windows는 로그인과 ProPresenter 종료 뒤 자동 동기화. Mac은 Git 경로
변환과 로그인 시 Nextcloud 동기화만 지원.

→ [flow.md](flow.md) · [rules.md](rules.md) · [../repo/layout.md](../repo/layout.md)
