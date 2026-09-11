# 테마와 콘텐츠

ProPresenter 테마는 `Themes/<이름>/Theme`에 저장된 디자인 틀.
테마 적용 시 디자인이 `Libraries/*.pro` 슬라이드에 복사되며,
그 뒤에는 원본 테마와 자동으로 연결되지 않음.

```text
Playlists/Library → 재생목록에서 Libraries/<분류>/<이름>.pro 사용
Themes/<그룹>/Theme → 디자인을 Libraries의 슬라이드에 복사
Media/Assets/* → .pro 파일에 영상·음원·이미지 경로 저장
```

| Libraries 폴더 | 기본 프로필 |
|---|---|
| `찬양/`, `찬송가/` | `song_lyric` |
| `성가곡/` | `mixed` |
| `말씀/` | `sermon` |
| `예배/` | 예배용 프로필 |
| `교독문/` | `bg_image` |

새 디자인은 ProPresenter에서 제작. 테마, `.pro` 파일, 미디어 연결이 모두
정상인지 함께 확인.
미디어 자체는 Nextcloud로 동기화하며 Git 추가 금지.

세부 판별 기준은 [profiles.md](profiles.md), 현재 예배 예시는
[session.md](session.md)에 기록.
