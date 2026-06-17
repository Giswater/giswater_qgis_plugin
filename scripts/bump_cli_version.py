#!/usr/bin/env python3
"""
Bump the giswater-cli package version (independent of the QGIS plugin release).

Usage:
  python3 scripts/bump_cli_version.py 0.2.0
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

_VERSION_RE = re.compile(r"^\d+\.\d+\.\d+$")


def bump(repo_root: Path, version: str) -> None:
    if not _VERSION_RE.match(version):
        raise RuntimeError(f"Invalid CLI version {version!r}; expected X.Y.Z")

    for rel, pattern, replacement in (
        (
            "pyproject.toml",
            r'(?m)^version = "[^"]+"',
            f'version = "{version}"',
        ),
        (
            "giswater_admin/__version__.py",
            r'(?m)^__version__ = "[^"]+"',
            f'__version__ = "{version}"',
        ),
    ):
        path = repo_root / rel
        text = path.read_text(encoding="utf-8")
        updated, count = re.subn(pattern, replacement, text, count=1)
        if count != 1:
            raise RuntimeError(f"Could not update version in {path}")
        path.write_text(updated, encoding="utf-8")


def main(argv: list[str] | None = None) -> int:
    args = argv if argv is not None else sys.argv[1:]
    if len(args) != 1:
        print("Usage: bump_cli_version.py X.Y.Z", file=sys.stderr)
        return 1
    repo_root = Path(__file__).resolve().parents[1]
    bump(repo_root, args[0])
    print(args[0])
    return 0


if __name__ == "__main__":
    sys.exit(main())
