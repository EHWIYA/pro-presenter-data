# Handoff → 글꼴 OS 설치 (에이전트·런처)

**자산 정본:** `Fonts/` · `Fonts/manifest.json` (data repo, Git LFS).  
**이 문서 독자:** `C:\pro-presenter-agent` — `launch-worship`·`sync-assets`·`collect-info` 구현.

## 배경

- PP는 Show Directory 안의 글꼴 파일을 읽지 **않음**. OS에 설치된 패밀리명만 사용.
- 슬라이드·테마의 글꼴 **선택**은 이미 `Themes/`·`Libraries/*.pro`에 베이크됨 (자산).
- `git pull`만으로는 글꼴이 깨질 수 있음 → pull **이후** manifest 기준 OS 설치 필요.

## 정본 경로

```
%USERPROFILE%\Documents\pro-presenter\Fonts\
  manifest.json
  NanumGothic-Bold.ttf
  NanumGothic-ExtraBold.ttf
  NanumGothic-Regular.ttf
  OFL.txt
```

## 요청 작업 (에이전트팀)

| # | 작업 | 비고 |
|---|------|------|
| 1 | `install-fonts.ps1` / `install-fonts.sh` | `manifest.json` 순회 → OS 글꼴 디렉터리에 설치 (이미 동일 버전이면 skip) |
| 2 | `launch-worship`·`sync-assets` | 자산 `git pull` **직후**, PP 시작 **전**에 (1) 실행 |
| 3 | `collect-info` (선택) | manifest `pp_face_names` 설치 여부 반환 |
| 4 | 실패 정책 (선택) | 필수 글꼴 미설치 시 launch 경고 또는 중단 |

### OS 경로 (참고)

| OS | 설치 대상 |
|----|-----------|
| Windows | `%WINDIR%\Fonts` (관리자 권한 없이 per-user 설치 API 가능 시 우선 검토) |
| macOS | `~/Library/Fonts/` 또는 `Font Book` CLI |

### manifest 스키마

```json
{
  "fonts": [
    {
      "file": "NanumGothic-ExtraBold.ttf",
      "pp_face_names": ["NanumGothicExtraBold", "NanumGothicExtraBoldR"],
      "used_in": ["Themes/찬양+성가", "..."]
    }
  ]
}
```

- 검증: `pp_face_names` 중 하나라도 OS에서 resolve 되면 OK (PP 내부 RTF 접미사 `R` 대응).
- `used_in`이 비어 있지 않은 항목 = **필수** 글꼴로 간주 가능.

## 현재 필수 글꼴 (2026-07-03 실측)

| 파일 | PP 참조명 | 자산 사용처 |
|------|-----------|-------------|
| `NanumGothic-Bold.ttf` | `NanumGothicBold` | `Themes/말씀` |
| `NanumGothic-ExtraBold.ttf` | `NanumGothicExtraBold` | `Themes/찬양+성가`, `Libraries/찬양/*.pro` |

`NanumGothic-Regular.ttf` — manifest에만 포함, Themes 미사용 (추가 테마용 예비).

## 자산팀 완료 항목

- [x] `Fonts/` 정본 + OFL
- [x] `manifest.json`
- [x] Git LFS (`.ttf`/`.otf`)
- [x] `docs/data/repo.md`·`paths.standard.json` 갱신

## 검증 (에이전트 구현 후)

1. 글꼴 미설치 PC에서 `launch-worship` → pull 후 자동 설치.
2. PP에서 `Themes/찬양+성가`·`Themes/말씀` 미리보기 글꼴 정상.
3. `/build-song` 신규 곡 슬라이드 글꼴 = ExtraBold.

관련: [agent.md](agent.md) · [theme-profiles.md](theme-profiles.md)
