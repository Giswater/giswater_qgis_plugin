"""ws schema smoke build + tear-down."""

from __future__ import annotations

import os

from giswater_admin.engine import BuildParams, SchemaBuilder, drop_schema, load_manifest


REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
DBMODEL = os.path.join(REPO_ROOT, "dbmodel")


def test_ws_sample_full_round_trip(adapter, temp_schema_name):
    """Build ws/sample_full, assert sys_version row, drop."""
    manifest = load_manifest(os.path.join(DBMODEL, "manifests", "ws.yaml"))
    params = BuildParams(
        schema_name=temp_schema_name,
        srid="25831",
        locale="en_US",
        plugin_version="4.9.0",
        profile="sample_full",
        sql_root=DBMODEL,
    )
    try:
        result = SchemaBuilder(adapter, manifest, params).run()
        assert result.ok, f"build failed: {result.first_failure()}"
        adapter.commit()

        with adapter.raw.cursor() as cur:
            cur.execute(
                f'SELECT giswater, project_type, epsg FROM "{temp_schema_name}".sys_version '
                "ORDER BY id DESC LIMIT 1"
            )
            row = cur.fetchone()
        assert row is not None
        assert row[1] == "WS"
        assert int(row[2]) == 25831
    finally:
        fx = drop_schema(adapter, temp_schema_name, cascade=True, commit=True)
        assert fx.ok, f"teardown failed: {fx.error}"


def test_ws_empty_minimal_build(adapter, temp_schema_name):
    manifest = load_manifest(os.path.join(DBMODEL, "manifests", "ws.yaml"))
    params = BuildParams(
        schema_name=temp_schema_name,
        srid="25831",
        plugin_version="4.9.0",
        profile="empty",
        sql_root=DBMODEL,
    )
    try:
        result = SchemaBuilder(adapter, manifest, params).run()
        assert result.ok, f"build failed: {result.first_failure()}"
        adapter.commit()
    finally:
        drop_schema(adapter, temp_schema_name, cascade=True, commit=True)
