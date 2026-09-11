# ProPresenter 예배 자료

ProPresenter 예배 자료 중 문서와 테마는 GitHub, 영상·음원·이미지는 Nextcloud에 저장.

## 한눈에 보는 흐름

```text
[담당자] ── 편집·송출 ──▶ [ProPresenter]
                              │
                              ▼
              [Documents/pro-presenter]
                  ├─ 문서·테마·글꼴 ↔ GitHub
                  ├─ 영상·음원·이미지 ↔ Nextcloud
                  └─ PC 설정은 이 PC에만 보관
```

Windows 로그인과 ProPresenter 종료 뒤 자동 동기화. ProPresenter에서 직접 편집하고 송출하는 구조.

## 처음 설정

ProPresenter 종료 후 필요한 도구 설치.

```powershell
winget install Git.Git
winget install GitHub.GitLFS
winget install rclone.rclone
git clone https://github.com/EHWIYA/pro-presenter-data.git "$env:USERPROFILE\Documents\pro-presenter"
cd "$env:USERPROFILE\Documents\pro-presenter"
git lfs install
powershell -ExecutionPolicy Bypass -File scripts/git-setup.ps1
powershell -ExecutionPolicy Bypass -File scripts/auto-setup.ps1
```

Nextcloud 연결은 `pp-media`, 인증은 앱 비밀번호로 설정. `PP_Media_Assets`와 `Media/Assets` 연결.

## 평소 사용

1. 로그인 동기화가 끝난 뒤 ProPresenter 열기.
2. 작업 후 ProPresenter 완전 종료.
3. 자동 동기화 결과에서 GitHub와 Nextcloud의 성공 여부 확인.

실패 기록은 `.nextcloud-sync/auto-sync-logs`에 저장.

## 자세한 문서

[문서 목차](docs/index.md) · [저장소 구조](docs/repo/layout.md) ·
[Git과 경로](docs/repo/git.md) · [미디어 동기화](docs/repo/media.md) ·
[자동 세션 동기화](docs/ops/sync.md)

Mac은 Git 경로 변환과 Nextcloud 동기화만 지원. 전체 작업 자동화는 Windows에서만 사용.
