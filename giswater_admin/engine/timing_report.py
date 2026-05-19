"""Aggregate per-file execution timings from a :class:`BuildResult`."""

from __future__ import annotations

import re
from typing import TYPE_CHECKING, Any

if TYPE_CHECKING:
    from .builder import BuildResult

_UPDATE_VERSION_RE = re.compile(r"/updates/(\d+)/(\d+)/(\d+)/")


def version_key_from_path(path: str) -> str | None:
    """Extract ``M.m.p`` from an updates SQL path, if present."""
    match = _UPDATE_VERSION_RE.search(path.replace("\\", "/"))
    if not match:
        return None
    return ".".join(match.groups())


def summarize_build(result: BuildResult, *, top: int = 20) -> dict[str, Any]:
    """
    Build a timing summary from a finished :class:`BuildResult`.

    Returns ``total_ms``, ``file_count``, ``by_phase``, and ``slowest``
    (up to ``top`` entries, descending by ``duration_ms``).
    """
    by_phase: list[dict[str, Any]] = []
    all_files: list[dict[str, Any]] = []
    total_ms = 0

    for pr in result.phases:
        if pr.skipped:
            continue
        phase_ms = sum(fx.duration_ms for fx in pr.files)
        count = len(pr.files)
        total_ms += phase_ms
        by_phase.append(
            {
                "phase_id": pr.phase_id,
                "ms": phase_ms,
                "count": count,
            }
        )
        for fx in pr.files:
            all_files.append(
                {
                    "path": fx.path,
                    "duration_ms": fx.duration_ms,
                    "phase_id": pr.phase_id,
                    "ok": fx.ok,
                }
            )

    if total_ms > 0:
        for row in by_phase:
            row["pct"] = round(100.0 * row["ms"] / total_ms, 1)

    slowest = sorted(all_files, key=lambda r: r["duration_ms"], reverse=True)[:top]
    slowest_by_phase = _slowest_by_phase(all_files, top=top)
    updates_by_version = _rollup_updates_by_version(all_files)

    return {
        "total_ms": total_ms,
        "file_count": len(all_files),
        "by_phase": by_phase,
        "slowest": slowest,
        "slowest_by_phase": slowest_by_phase,
        "updates_by_version": updates_by_version,
    }


def _slowest_by_phase(
    all_files: list[dict[str, Any]], *, top: int
) -> dict[str, list[dict[str, Any]]]:
    by_phase: dict[str, list[dict[str, Any]]] = {}
    for row in all_files:
        by_phase.setdefault(str(row["phase_id"]), []).append(row)
    return {
        phase_id: sorted(rows, key=lambda r: r["duration_ms"], reverse=True)[:top]
        for phase_id, rows in by_phase.items()
    }


def _rollup_updates_by_version(all_files: list[dict[str, Any]]) -> list[dict[str, Any]]:
    buckets: dict[str, dict[str, Any]] = {}
    for row in all_files:
        if row.get("phase_id") != "updates":
            continue
        version = version_key_from_path(str(row.get("path", "")))
        if not version:
            continue
        bucket = buckets.setdefault(
            version,
            {"version": version, "ms": 0, "count": 0, "slowest_file": "", "slowest_ms": 0},
        )
        ms = int(row.get("duration_ms") or 0)
        bucket["ms"] += ms
        bucket["count"] += 1
        if ms >= bucket["slowest_ms"]:
            bucket["slowest_ms"] = ms
            bucket["slowest_file"] = str(row.get("path", ""))
    ranked = sorted(buckets.values(), key=lambda r: r["ms"], reverse=True)
    if ranked:
        total = sum(r["ms"] for r in ranked)
        for row in ranked:
            row["pct_of_updates"] = round(100.0 * row["ms"] / total, 1) if total else 0.0
    return ranked


def all_files(result: BuildResult) -> list[dict[str, Any]]:
    """Flat list of every executed file with phase and timing (for ``--timing-detail``)."""
    out: list[dict[str, Any]] = []
    for pr in result.phases:
        if pr.skipped:
            continue
        for fx in pr.files:
            out.append(
                {
                    "path": fx.path,
                    "duration_ms": fx.duration_ms,
                    "phase_id": pr.phase_id,
                    "ok": fx.ok,
                }
            )
    return out
