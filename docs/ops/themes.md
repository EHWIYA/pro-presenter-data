# 테마와 콘텐츠

ProPresenter 테마는 `Themes/<이름>/Theme`에 저장된 디자인 틀이다.
테마를 적용하면 디자인이 `Libraries/*.pro` 슬라이드에 복사된다. 그 뒤에는
원본 테마와 자동으로 연결되지 않는다.

```text
Playlists/Library → 재생목록이 Libraries/<분류>/<이름>.pro를 사용한다.
Themes/<그룹>/Theme → 디자인이 Libraries의 슬라이드에 복사된다.
Media/Assets/* → .pro 파일이 영상·음원·이미지 경로를 기억한다.
```

| Libraries 폴더 | 기본 프로필 |
|---|---|
| `찬양/`, `찬송가/` | `song_lyric` |
| `성가곡/` | `mixed` |
| `말씀/` | `sermon` |
| `예배/` | 예배용 프로필 |
| `교독문/` | `bg_image` |

새 디자인은 ProPresenter에서 만든다. 테마, `.pro` 파일, 미디어 연결이 모두
정상인지 함께 확인한다.
미디어 자체는 Nextcloud로 동기화하며 Git에 추가하지 않는다.

세부 판별 기준은 [profiles.md](profiles.md), 현재 예배 예시는
[session.md](session.md)에 기록한다.
