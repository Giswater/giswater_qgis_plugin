"""Tests for giswater_admin.log_format."""

from __future__ import annotations

from giswater_admin.log_format import (
    LogStyle,
    format_build_header,
    format_file,
    format_phase,
    format_progress_status,
    format_timing_summary,
    shorten_path,
)


def test_shorten_path_strips_sql_root():
    root = "/proj/dbmodel"
    path = "/proj/dbmodel/schemas/network/ws/updates/4/2/0/dml.sql"
    assert shorten_path(path, root) == "ws/updates/4/2/0/dml.sql"


def test_shorten_path_strips_dbmodel_prefix():
    path = "dbmodel/schemas/network/ws/ddl.sql"
    assert shorten_path(path) == "ws/ddl.sql"


def test_format_phase_counter_padding():
    line = format_phase(12, 723, "updates")
    assert line.startswith("[ 12/723]")
    assert "phase  updates" in line


def test_format_file_with_timing():
    style = LogStyle(sql_root="/db", show_timing_ms=True)
    path = "/db/ws/updates/4/2/0/dml.sql"
    line = format_file(5, 100, path, ms=3241, style=style)
    assert "3.2s" in line
    assert "updates/4/2/0/dml.sql" in line


def test_format_timing_summary_includes_done_header():
    summary = {
        "total_ms": 10400,
        "file_count": 723,
        "by_phase": [{"phase_id": "updates", "ms": 7100, "count": 612, "pct": 68.0}],
        "slowest": [
            {
                "path": "dbmodel/schemas/network/ws/updates/4/2/0/dml.sql",
                "duration_ms": 3241,
                "phase_id": "updates",
            }
        ],
        "updates_by_version": [],
        "slowest_by_phase": {},
    }
    lines = format_timing_summary(summary, style=LogStyle())
    assert any("Done" in ln for ln in lines)
    assert any("updates" in ln for ln in lines)
    assert any("Slowest:" in ln for ln in lines)


def test_format_progress_status_file():
    hint = format_progress_status(
        145,
        723,
        "dbmodel/schemas/network/ws/updates/4/2/0/dml.sql",
        sql_root="dbmodel",
    )
    assert "145/723" in hint
    assert "4/2/0/dml.sql" in hint or "updates" in hint


def test_format_build_header():
    line = format_build_header("ws", "gw_test", "empty", "4.9.0")
    assert "ws" in line
    assert "gw_test" in line
    assert "4.9.0" in line
