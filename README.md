# pro-presenter-data

ProPresenter Show Directory의 Git 정본이다. 미디어는 Nextcloud에서 관리한다.

## 처음 설정

ProPresenter를 종료하고 필요한 도구를 설치한다.

```powershell
winget install Git.Git
winget install GitHub.GitLFS
winget install rclone.rclone
git clone https://github.com/EHWIYA/pro-presenter-data.git "$env:USERPROFILE\Documents\pro-presenter"
cd "$env:USERPROFILE\Documents\pro-presenter"
git lfs install
powershell -ExecutionPolicy Bypass -File scripts/setup-git-filters.ps1
powershell -ExecutionPolicy Bypass -File scripts/setup-auto-sync-windows.ps1
```

Nextcloud 원격 이름은 `pp-media`로 설정한다. 앱 비밀번호를 사용하고,
원격의 `PP_Media_Assets` 폴더를 `Media/Assets`와 연결한다.

## 평소 사용

1. 로그인 동기화가 끝난 뒤 ProPresenter를 연다.
2. 작업 후 ProPresenter를 완전히 종료한다.
3. 자동 동기화 결과에서 GitHub와 Nextcloud 성공을 확인한다.

실패 로그는 `.nextcloud-sync/auto-sync-logs`에 남는다.

## 문서

- [문서 목차](docs/index.md)
- [저장소 구조](docs/repo/layout.md)
- [Git과 경로](docs/repo/git.md)
- [미디어 동기화](docs/repo/media.md)
- [자동 세션 동기화](docs/ops/sync.md)

Mac은 Git 경로 필터와 Nextcloud 동기화만 지원한다. 전체 세션 자동화는
Windows에서 운영한다.
