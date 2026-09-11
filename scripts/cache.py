# 문맥 정본 파일의 짧은 해시 캐시를 갱신한다.
import sys

sys.dont_write_bytecode = True

from core.context import HASHES, refresh


if __name__ == "__main__":
    refresh()
    print(HASHES.relative_to(HASHES.parents[2]))
