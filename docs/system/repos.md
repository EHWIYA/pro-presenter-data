# 레포별 상세

## 1. front-end

**미션:** PWA · pro-api만

스택: React 19 · Vite 6 · TanStack Query 5 · CSS Modules · PWA  
배포: GHA → rsync → NAS `/home/iwh/pro-presenter/web/dist`

**금지:** PP :12135 직접 호출 · `verse/send` · `auto_trigger: true` 기본

---

## 2. back-end

**미션:** NAS BFF · 성경·곡 DB · .pro 생성 안 함

실행: Docker `:8003` · Postgres `:5434` · NAS 설정(`venues.json`, `.env`)은 레포 밖

**금지:** .pro 직접 생성 · PP REST 슬라이드 추가

---

## 3. data (이 repo)

**미션:** Show Directory Git · `Media/Assets/` LFS · Configuration 제외

→ [../data/repo.md](../data/repo.md)

---

## 제거됨

| 레포 | 상태 |
|------|------|
| EHWIYA/pro-presenter-agent | 제거 — Windows `.pro` 빌드·PP 트리거 에이전트 더 이상 사용하지 않음 |
