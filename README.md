# ProPresenter 예배 자료

ProPresenter가 사용하는 예배 자료 폴더. 문서와 테마는 GitHub에 저장하고,
용량이 큰 영상·음원·이미지는 Nextcloud에 저장.

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

Nextcloud 연결 이름은 `pp-media`로 설정. 일반 로그인 비밀번호 대신
Nextcloud 앱 비밀번호 사용. 서버의 `PP_Media_Assets` 폴더와 이 PC의
`Media/Assets` 폴더 연결.

## 평소 사용

1. 로그인 동기화가 끝난 뒤 ProPresenter 열기.
2. 작업 후 ProPresenter 완전 종료.
3. 자동 동기화 결과에서 GitHub와 Nextcloud의 성공 여부 확인.

실패 기록은 `.nextcloud-sync/auto-sync-logs`에 저장.

## 문서

- [문서 목차](docs/index.md)
- [저장소 구조](docs/repo/layout.md)
- [Git과 경로](docs/repo/git.md)
- [미디어 동기화](docs/repo/media.md)
- [자동 세션 동기화](docs/ops/sync.md)

Mac은 Git 경로 변환과 Nextcloud 동기화만 지원. 전체 작업 자동화는
Windows에서만 사용.
