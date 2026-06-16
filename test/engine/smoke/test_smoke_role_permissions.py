"""Smoke checks for role_system ownership and restrictive table grants."""

from __future__ import annotations

import os

import pytest

from giswater_admin.engine import BuildParams, SchemaBuilder, drop_schema, load_manifest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
DBMODEL = os.path.join(REPO_ROOT, "dbmodel")


@pytest.fixture()
def built_empty_schema(adapter, temp_schema_name):
    manifest = load_manifest(os.path.join(DBMODEL, "manifests", "ws.yaml"))
    params = BuildParams(
        schema_name=temp_schema_name,
        srid="25831",
        plugin_version="4.15.0",
        profile="empty",
        sql_root=DBMODEL,
    )
    try:
        result = SchemaBuilder(adapter, manifest, params).run()
        assert result.ok, f"build failed: {result.first_failure()}"
        adapter.commit()
        yield temp_schema_name
    finally:
        drop_schema(adapter, temp_schema_name, cascade=True, commit=True)


def test_tables_owned_by_role_system(adapter, built_empty_schema):
    schema = built_empty_schema
    with adapter.raw.cursor() as cur:
        cur.execute(
            """
            SELECT tableowner
            FROM pg_tables
            WHERE schemaname = %s AND tablename IN ('node', 'sys_table')
            ORDER BY tablename
            """,
            (schema,),
        )
        owners = {row[0] for row in cur.fetchall()}
    assert owners == {"role_system"}


def test_role_edit_cannot_truncate_or_disable_triggers(psycopg2_conn, built_empty_schema):
    schema = built_empty_schema
    with psycopg2_conn.cursor() as cur:
        cur.execute("SET ROLE role_edit")
        with pytest.raises(Exception):
            cur.execute(f'TRUNCATE TABLE "{schema}".node')
        psycopg2_conn.rollback()

        cur.execute("SET ROLE role_edit")
        with pytest.raises(Exception):
            cur.execute(f'ALTER TABLE "{schema}".node DISABLE TRIGGER ALL')
        psycopg2_conn.rollback()

        cur.execute("RESET ROLE")


def test_role_edit_can_select_node(psycopg2_conn, built_empty_schema):
    schema = built_empty_schema
    with psycopg2_conn.cursor() as cur:
        cur.execute("SET ROLE role_edit")
        cur.execute(f'SELECT count(*) FROM "{schema}".node')
        cur.fetchone()
        cur.execute("RESET ROLE")
