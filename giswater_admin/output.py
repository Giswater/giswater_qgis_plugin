"""
CLI output helper.

Splits human-readable progress (stderr) from machine-readable results
(stdout). With ``--json`` only one JSON object is ever written to
stdout, which is what tools like ``jq``, Ansible's ``command``, and
GitHub Actions rely on.
"""

from __future__ import annotations

import json
import sys
from typing import Any


class Out:
    def __init__(
        self,
        json_mode: bool = False,
        quiet: bool = False,
        *,
        verbose: bool = False,
        debug: bool = False,
    ) -> None:
        self.json_mode = json_mode
        self.quiet = quiet
        # --debug implies per-file logging behaviour like verbose.
        self.verbose = bool(verbose or debug)
        self.debug = bool(debug)

    def info(self, msg: str) -> None:
        if self.quiet:
            return
        print(f"info: {msg}", file=sys.stderr)

    def warn(self, msg: str) -> None:
        print(f"warning: {msg}", file=sys.stderr)

    def error(self, msg: str) -> None:
        print(f"error: {msg}", file=sys.stderr)

    def progress(self, msg: str) -> None:
        if self.quiet:
            return
        print(msg, file=sys.stderr)

    def exec_file(self, seen: int, total: int, path: str) -> None:
        """Per-SQL file trace (QGIS-terminal parity). Respects ``quiet``."""
        if self.quiet or not self.verbose:
            return
        print(f"exec: [{seen}/{total}] {path}", file=sys.stderr, flush=True)

    def result(self, payload: Any) -> None:
        """Final machine-or-human payload. Writes ONCE to stdout."""
        if self.json_mode:
            json.dump(payload, sys.stdout, ensure_ascii=False, default=str)
            sys.stdout.write("\n")
        else:
            self._print_yaml(payload, indent=0)
        sys.stdout.flush()

    def _print_yaml(self, value: Any, indent: int) -> None:
        pad = "  " * indent
        if isinstance(value, dict):
            for k, v in value.items():
                if isinstance(v, (dict, list)):
                    print(f"{pad}{k}:")
                    self._print_yaml(v, indent + 1)
                else:
                    print(f"{pad}{k}: {v}")
        elif isinstance(value, list):
            for item in value:
                if isinstance(item, dict):
                    first = True
                    for k, v in item.items():
                        prefix = f"{pad}- " if first else f"{pad}  "
                        if isinstance(v, (dict, list)):
                            print(f"{prefix}{k}:")
                            self._print_yaml(v, indent + 2)
                        else:
                            print(f"{prefix}{k}: {v}")
                        first = False
                else:
                    print(f"{pad}- {item}")
        else:
            print(f"{pad}{value}")


def configure_stderr_logging(*, debug: bool = False) -> None:
    """
    Attach a stderr handler to the ``giswater_admin`` logger tree.

    Used when ``--debug`` is passed. Does not touch the root logger, so
    third-party noise stays out. Call from CLI ``main()`` or from Qt when
    you want SQL previews.
    """
    import logging

    pkg = logging.getLogger("giswater_admin")
    pkg.handlers.clear()
    pkg.setLevel(logging.DEBUG if debug else logging.WARNING)
    if not debug:
        return
    h = logging.StreamHandler(sys.stderr)
    h.setFormatter(logging.Formatter("%(levelname)s %(name)s: %(message)s"))
    pkg.addHandler(h)
    pkg.propagate = False
