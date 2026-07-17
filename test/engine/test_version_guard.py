"""Tests for version downgrade guards."""

from __future__ import annotations

from giswater_admin.engine.schema_catalog import NetworkGraph, NetworkNode
from giswater_admin.engine.version_guard import (
    assert_network_no_downgrade,
    assert_no_downgrade,
)


def test_assert_no_downgrade_blocks():
    assert assert_no_downgrade("4.16.0", "4.15.0", label="schema 'ws'") is not None
    assert assert_no_downgrade("4.16.0", "4.16.0", label="x") is None
    assert assert_no_downgrade("4.16.0", "4.17.0", label="x") is None


def test_assert_network_no_downgrade_blocks():
    graph = NetworkGraph(
        anchor="",
        nodes=[
            NetworkNode(schema="ws", kind="ws", version="4.16.0"),
            NetworkNode(schema="utils", kind="utils", version="4.16.0"),
        ],
        edges=[],
    )
    assert assert_network_no_downgrade(graph, "4.15.0") is not None
    assert assert_network_no_downgrade(graph, "4.17.0") is None
