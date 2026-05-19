"""Tests for timing_report helpers."""

from __future__ import annotations

from types import SimpleNamespace

from giswater_admin.engine import timing_report as tr


def _fx(path: str, ms: int, phase: str = "updates"):
    return SimpleNamespace(path=path, duration_ms=ms, ok=True)


def _phase(phase_id: str, files):
    return SimpleNamespace(phase_id=phase_id, skipped=False, files=files)


def test_version_key_from_path():
    p = "dbmodel/schemas/network/common/updates/4/2/0/dml.sql"
    assert tr.version_key_from_path(p) == "4.2.0"


def test_summarize_build_updates_by_version():
    files = [
        _fx("dbmodel/schemas/network/common/updates/4/1/0/dml.sql", 500),
        _fx("dbmodel/schemas/network/ws/updates/4/1/0/dml.sql", 300),
        _fx("dbmodel/schemas/network/common/updates/4/2/0/dml.sql", 100),
    ]
    result = SimpleNamespace(
        phases=[_phase("updates", files), _phase("load_base", [_fx("ddl.sql", 10, "load_base")])]
    )
    summary = tr.summarize_build(result, top=5)
    by_ver = summary["updates_by_version"]
    assert by_ver[0]["version"] == "4.1.0"
    assert by_ver[0]["ms"] == 800
    assert by_ver[0]["count"] == 2


def test_summarize_build_totals_and_slowest():
    files = [
        SimpleNamespace(path="a.sql", duration_ms=100, ok=True),
        SimpleNamespace(path="b.sql", duration_ms=50, ok=True),
    ]
    result = SimpleNamespace(
        phases=[SimpleNamespace(phase_id="load_base", skipped=False, files=files)]
    )
    summary = tr.summarize_build(result, top=2)
    assert summary["total_ms"] == 150
    assert summary["file_count"] == 2
    assert len(summary["slowest"]) == 2
    assert summary["slowest"][0]["path"] == "a.sql"
