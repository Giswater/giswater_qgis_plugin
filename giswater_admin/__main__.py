"""Allow ``python3 -m giswater_admin`` invocation."""

from __future__ import annotations

import sys

from .cli import main


if __name__ == "__main__":
    sys.exit(main())
