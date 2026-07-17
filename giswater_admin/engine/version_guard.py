"""Semver guards for schema and network updates."""

from __future__ import annotations

from .schema_catalog import NetworkGraph, _version_tuple


def version_compare(current: str, target: str) -> int:
    """Return -1 if target < current, 0 if equal, 1 if target > current."""
    cur = _version_tuple(current)
    tgt = _version_tuple(target)
    if tgt < cur:
        return -1
    if tgt > cur:
        return 1
    return 0


def assert_no_downgrade(current: str, target: str, *, label: str) -> str | None:
    """Return error message when *target* is below *current*, else None."""
    if not target or not current:
        return None
    if version_compare(current, target) < 0:
        return f"cannot downgrade {label} to {target} (current {current})"
    return None


def assert_network_no_downgrade(graph: NetworkGraph, target: str) -> str | None:
    """Return error when any cluster member would downgrade."""
    if not target:
        return None
    conflicts: list[str] = []
    for node in graph.nodes:
        if not node.version:
            continue
        if version_compare(node.version, target) < 0:
            conflicts.append(f"{node.schema}@{node.version}")
    if not conflicts:
        return None
    return (
        f"cannot downgrade network to {target} "
        f"(members: {', '.join(sorted(conflicts))})"
    )
