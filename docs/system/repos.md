# 레포별 상세

## 1. front-end

**미션:** PWA · pro-api만 · venue → build → slide_map → trigger

스택: React 19 · Vite 6 · TanStack Query 5 · CSS Modules · PWA  
배포: GHA → rsync → NAS `/home/iwh/pro-presenter/web/dist`

**금지:** 에이전트 :8787·PP :12135 직접 호출 · `verse/send` · `auto_trigger: true` 기본

---

## 2. back-end

**미션:** NAS BFF · 성경·곡 DB · venue 프록시 · .pro 생성 안 함

실행: Docker `:8003` · Postgres `:5434` · NAS 설정(`venues.json`, `.env`)은 레포 밖

**금지:** .pro 직접 생성 · PP REST 슬라이드 추가

---

## 3. agent

**미션:** Windows · Protobuf .pro N장 · PP trigger · NAS 미배포

경로: `C:\pro-presenter-agent` · HTTP `:8787` · API: `/build`, `/build-song`, `/trigger`

**금지:** NAS Docker화 · DB/곡 CRUD · LLM · PWA

→ 현장 설정·handoff: [../handoff/agent.md](../handoff/agent.md)

---

## 4. data (이 repo)

**미션:** Show Directory Git · Media·Configuration 제외

→ [../data/repo.md](../data/repo.md)
