# 테마 프로필

대표 슬라이드의 `base_slide.elements[].element`로 판별한다.

| 키 | 요소와 용도 |
|---|---|
| `song_lyric` | `content_text`, 찬양·찬송가 |
| `sermon` | 제목·본문 box와 text, 말씀 |
| `worship_text` | 본문 box와 text, 기도 |
| `worship_titled` | 제목과 본문, 축도 |
| `bg_image` | 이름 없는 media element |
| `image_sequence` | 슬라이드마다 이미지 한 장 |
| `mixed` | 서로 다른 레이아웃 혼합 |
| `empty` | 연결되지 않은 빈 슬라이드 |

`song_lyric`은 `Themes/찬양+성가`, `sermon`은 `Themes/말씀`을 사용한다.
혼합 또는 빈 콘텐츠는 자동 변환하지 않고 수동 유지한다.

공통 배경은 `Media/Assets/bg_worship_2.png`, 사도신경은
`apostles_creed_01.png`부터 `03.png`까지 사용한다.
