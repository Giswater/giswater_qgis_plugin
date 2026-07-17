"""Tests for giswater_admin.engine.changelog."""

from __future__ import annotations

from giswater_admin.engine.changelog import (
    collect_pending_versions,
    format_upgrade_changelog,
    network_update_roots,
)


def test_network_update_roots_use_main_layout():
    roots = network_update_roots("dbmodel", "ws")
    assert roots == [
        "dbmodel/schemas/main/common/updates",
        "dbmodel/schemas/main/ws/updates",
    ]


def test_collect_pending_versions_from_4_11_1_to_4_12_0():
    roots = network_update_roots("dbmodel", "ws")
    pending = collect_pending_versions(roots, "4.11.1", "4.12.0")
    assert pending == [(4, 11, 2), (4, 12, 0)]


def test_format_upgrade_changelog_includes_4_12_0():
    text = format_upgrade_changelog("dbmodel", "ws", "4.11.1", "4.12.0")
    assert "4.12.0" in text
