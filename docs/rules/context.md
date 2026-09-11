# 문맥 절약 규칙

- 작업 시작 시 전체 저장소 대신 `docs/ctx/map.md`를 먼저 읽는다.
- `python scripts/ctx.py <topic>`으로 관련 경로와 핵심 사실만 조회한다.
- 긴 명령은 문서에 복사하지 않고 검증된 스크립트로 제공한다.
- 여러 문서에 같은 사실을 복제하지 않는다.
- 안정적인 사실만 캐시하고 branch와 dirty 상태는 실행 시 계산한다.
- 정본이 바뀌면 `python scripts/cache.py`로 해시를 갱신한다.
