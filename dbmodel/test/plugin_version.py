#!/usr/bin/env python3
"""Print highest network update semver (M.m.p) under dbmodel/schemas/main/."""

from __future__ import annotations

import os
import sys


def _max_version(root: str) -> tuple[int, int, int] | None:
    best: tuple[int, int, int] | None = None
    if not os.path.isdir(root):
        return None
    for major_name in os.listdir(root):
        major_path = os.path.join(root, major_name)
        if not (major_name.isdigit() and os.path.isdir(major_path)):
            continue
        for minor_name in os.listdir(major_path):
            minor_path = os.path.join(major_path, minor_name)
            if not (minor_name.isdigit() and os.path.isdir(minor_path)):
                continue
            for patch_name in os.listdir(minor_path):
                patch_path = os.path.join(minor_path, patch_name)
                if not (patch_name.isdigit() and os.path.isdir(patch_path)):
                    continue
                key = (int(major_name), int(minor_name), int(patch_name))
                if best is None or key > best:
                    best = key
    return best


def main() -> int:
    base = os.path.join(
        os.path.dirname(__file__), "..", "schemas", "main"
    )
    base = os.path.abspath(base)
    candidates: list[tuple[int, int, int]] = []
    for sub in ("common/updates", "ws/updates", "ud/updates"):
        v = _max_version(os.path.join(base, sub))
        if v is not None:
            candidates.append(v)
    if not candidates:
        print("0.0.0", end="")
        return 1
    best = max(candidates)
    print(f"{best[0]}.{best[1]}.{best[2]}", end="")
    return 0


if __name__ == "__main__":
    sys.exit(main())
