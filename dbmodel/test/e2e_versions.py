#!/usr/bin/env python3
"""Resolve PLUGIN_VER (create) and TARGET_VER (upgrade) for E2E update tests."""

from __future__ import annotations

import os
import sys


def _collect_versions(root: str) -> list[tuple[int, int, int]]:
    found: list[tuple[int, int, int]] = []
    if not os.path.isdir(root):
        return found
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
                patch_sql = os.path.join(patch_path, "patch.sql")
                if os.path.isfile(patch_sql):
                    found.append((int(major_name), int(minor_name), int(patch_name)))
    return found


def _fmt(v: tuple[int, int, int]) -> str:
    return f"{v[0]}.{v[1]}.{v[2]}"


def main() -> int:
    test_dir = os.path.dirname(os.path.abspath(__file__))
    dbmodel = os.path.join(test_dir, "..")
    roots = [
        os.path.join(dbmodel, "schemas", "main", "common", "updates"),
        os.path.join(dbmodel, "schemas", "main", "ws", "updates"),
        os.path.join(dbmodel, "schemas", "main", "ud", "updates"),
    ]
    versions: set[tuple[int, int, int]] = set()
    for root in roots:
        for item in _collect_versions(root):
            versions.add(item)
    ordered = sorted(versions)
    if len(ordered) < 2:
        print(
            "error: need at least two semver patches under main/*/updates for E2E upgrades",
            file=sys.stderr,
        )
        return 1

    target = ordered[-1]
    source = ordered[-2]
    print(f"TARGET_VER={_fmt(target)}")
    print(f"PLUGIN_VER={_fmt(source)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
