# ProPresenter 경로 정규화의 짧은 명령행 진입점을 제공한다.
import sys

sys.dont_write_bytecode = True

from core.cli import main


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
