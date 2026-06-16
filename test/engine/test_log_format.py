"""Tests for schema-build log formatting helpers."""

from __future__ import annotations

from giswater_admin.log_format import format_sql_error, sql_line_at_offset


def test_sql_line_at_offset_multiline():
    sql = "SET search_path = x;\n\nSELECT 1;\nSELECT bad();"
    pos = sql.index("SELECT bad")
    assert sql_line_at_offset(sql, pos) == 4
    assert sql_line_at_offset(sql, 0) == 0
    assert sql_line_at_offset("", 10) == 0


def test_format_sql_error_includes_detail_and_line():
    sql = "\n".join(
        [
            "SET search_path = SCHEMA_NAME;",
            "",
            "SELECT gw_fct_admin_role_permissions();",
            'SELECT gw_fct_setowner($${"data":{"owner":"role_system"}}$$);',
        ]
    )
    pos = sql.index("gw_fct_setowner")
    error = (
        'cannot change owner of sequence "archived_rpt_arc_id_seq"\n'
        'DETAIL: Sequence "archived_rpt_arc_id_seq" is linked to table "archived_rpt_arc"'
    )
    msg = format_sql_error(
        error,
        filepath="/dbmodel/schemas/main/common/updates/4/15/0/patch.sql",
        sql_root="/dbmodel",
        sql=sql,
        statement_position=pos,
    )
    assert "common/updates/4/15/0/patch.sql  (line ~4)" in msg
    assert "DETAIL: Sequence" in msg
    assert "linked to table" in msg
    assert "..." not in msg


def test_format_sql_error_no_truncation():
    detail = "DETAIL: " + ("x" * 200)
    msg = format_sql_error(detail, filepath="patch.sql")
    assert detail in msg
    assert len(msg) > 120
