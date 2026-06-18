#!/usr/bin/env python3
"""
Bump the giswater-cli package version (independent of the QGIS plugin release).

Usage:
  python3 scripts/bump_cli_version.py 0.1.0
"""

from __future__ import annotations

import sys
from pathlib import Path

from release_lib import ReleaseError, bump_cli_version_text, parse_cli_version, read_text, repo_root


def bump(repo_root_path: Path, version_text: str) -> None:
    version = parse_cli_version(version_text)
    for rel in ("pyproject.toml", "giswater_admin/__version__.py"):
        path = repo_root_path / rel
        text = read_text(path)
        updated = bump_cli_version_text(path, text, version)
        path.write_text(updated, encoding="utf-8")


def main(argv: list[str] | None = None) -> int:
    args = argv if argv is not None else sys.argv[1:]
    if len(args) != 1:
        print("Usage: bump_cli_version.py X.Y.Z", file=sys.stderr)
        return 1
    try:
        bump(repo_root(), args[0])
    except ReleaseError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1
    print(args[0])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
