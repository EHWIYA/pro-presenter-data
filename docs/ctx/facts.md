# 고정 사실 캐시

- 저장소는 `%USERPROFILE%\Documents\pro-presenter`에 둔다.
- Git 원격은 `github.com/EHWIYA/pro-presenter-data`다.
- ProPresenter UI는 재생목록에서 `Libraries/*.pro`를 참조한다.
- Git 자산은 `Libraries`, `Playlists`, `Presets`, `Themes`, `Fonts`다.
- `Media/Assets`는 `pp-media` Nextcloud 원격과 bisync한다.
- 경로 정본은 `%USERPROFILE%\Documents\pro-presenter` 형식이다.
- 경로 변환 전 ProPresenter를 완전히 종료한다.
- PWA와 BFF는 별도 저장소이며 여기서 수정하지 않는다.

변경 가능한 상태는 이 파일에 저장하지 않고 실행 시 조회한다.
