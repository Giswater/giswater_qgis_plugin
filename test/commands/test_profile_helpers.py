"""Tests for lastprocess profile step helpers."""

from __future__ import annotations

from types import SimpleNamespace

from giswater_admin.commands import _helpers as h


def _result_with_steps(steps):
    fx = SimpleNamespace(profile_steps=steps)
    phase = SimpleNamespace(phase_id="lastprocess", files=[fx])
    return SimpleNamespace(phases=[phase])


def test_profile_step_aggregate_key_child_config():
    key = h._profile_step_aggregate_key("ve_node_pump:cff_introspect", "child_config_timing")
    assert key == "cff_introspect"


def test_profile_step_aggregate_key_child_views():
    key = h._profile_step_aggregate_key(
        "view:ve_node_pump:child_config", "child_views_timing"
    )
    assert key == "view:*:child_config"


def test_include_in_profile_summary_skips_rollups():
    assert h._include_in_profile_summary("total") is False
    assert h._include_in_profile_summary("ve_node_pump:total") is False
    assert h._include_in_profile_summary("ve_node_pump:cff_introspect") is True


def test_emit_profile_step_summary_groups_child_config(capsys):
    from giswater_admin.output import Out

    result = _result_with_steps(
        [
            {"step": "ve_node_pump:cff_introspect", "ms": 11},
            {"step": "ve_node_tank:cff_introspect", "ms": 9},
            {"step": "after_manage_child_views", "ms": 9000},
        ]
    )
    out = Out(json_mode=False, quiet=False, verbose=False, debug=False, timing=False)
    h.emit_profile_step_summary(result, out)
    text = capsys.readouterr().err
    assert "── Profile: child config ──" in text
    assert "cff_introspect" in text
    assert "n=2" in text
    assert "total=20ms" in text
    assert "── Profile: lastprocess ──" in text
    assert "after_manage_child_views" in text
