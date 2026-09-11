# 테마 프로필

자동 검사 도구는 대표 슬라이드의 `base_slide.elements[].element` 값을 보고
아래 유형을 구분한다.

| 키 | 요소와 용도 |
|---|---|
| `song_lyric` | `content_text`, 찬양·찬송가 |
| `sermon` | 제목과 본문 글상자가 있는 말씀 슬라이드 |
| `worship_text` | 본문 글상자가 있는 기도 슬라이드 |
| `worship_titled` | 제목과 본문, 축도 |
| `bg_image` | 이름 없는 배경 이미지 요소 |
| `image_sequence` | 슬라이드마다 이미지 한 장 |
| `mixed` | 서로 다른 레이아웃 혼합 |
| `empty` | 연결되지 않은 빈 슬라이드 |

`song_lyric`은 `Themes/찬양+성가`, `sermon`은 `Themes/말씀`을 사용한다.
여러 디자인이 섞였거나 빈 슬라이드는 자동으로 바꾸지 않고 사람이 관리한다.

공통 배경은 `Media/Assets/bg_worship_2.png`, 사도신경은
`apostles_creed_01.png`부터 `03.png`까지 사용한다.
