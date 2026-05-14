"""Templating + file-content substitution unit tests."""

from __future__ import annotations

from giswater_admin.engine.templating import apply_subs, render


def test_render_str_replaces_known_tokens():
    assert render("{{ name }}-{{ env }}", {"name": "ws", "env": "ci"}) == "ws-ci"


def test_render_keeps_unknown_tokens_verbatim():
    assert render("{{ missing }}-x", {}) == "{{ missing }}-x"


def test_render_recurses_into_dict_list_tuple():
    ctx = {"a": "1", "b": "2"}
    out = render({"k": "{{ a }}", "lst": ["{{ a }}", "{{ b }}"], "tup": ("{{ a }}",)}, ctx)
    assert out == {"k": "1", "lst": ["1", "2"], "tup": ("1",)}


def test_apply_subs_literal_replace():
    sql = "CREATE TABLE SCHEMA_NAME.foo (id int);"
    assert apply_subs(sql, {"SCHEMA_NAME": "ws_demo"}) == "CREATE TABLE ws_demo.foo (id int);"


def test_apply_subs_skips_none_values():
    sql = "SCHEMA_NAME AUX_SCHEMA_NAME"
    out = apply_subs(sql, {"SCHEMA_NAME": "x", "AUX_SCHEMA_NAME": None})
    assert out == "x AUX_SCHEMA_NAME"


def test_apply_subs_bd_name_is_case_insensitive():
    sql = "use BD_NAME and bd_name and Bd_Name"
    assert apply_subs(sql, {"BD_NAME": "mydb"}) == "use mydb and mydb and mydb"


def test_apply_subs_srid_value():
    sql = "ST_SetSRID(geom, SRID_VALUE)"
    assert apply_subs(sql, {"SRID_VALUE": "25831"}) == "ST_SetSRID(geom, 25831)"
