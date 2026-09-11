# 테마와 콘텐츠

PP 테마는 `Themes/<이름>/Theme`의 레이아웃 템플릿이다. 적용 결과는
`Libraries/*.pro` 슬라이드에 베이크되며 UUID로 연결되지 않는다.

```text
Playlists/Library → Libraries/<분류>/<이름>.pro
Themes/<그룹>/Theme → Libraries에 적용된 레이아웃
Media/Assets/* → .pro의 미디어 경로
```

| Libraries 폴더 | 기본 프로필 |
|---|---|
| `찬양/`, `찬송가/` | `song_lyric` |
| `성가곡/` | `mixed` |
| `말씀/` | `sermon` |
| `예배/` | 예배용 프로필 |
| `교독문/` | `bg_image` |

새 패턴은 PP에서 제작하고 테마, `.pro`, 미디어 참조를 함께 검증한다.
미디어 자체는 Nextcloud로 동기화하며 Git에 추가하지 않는다.

세부 판별 기준은 [profiles.md](profiles.md), 현재 예배 예시는
[session.md](session.md)에 기록한다.
