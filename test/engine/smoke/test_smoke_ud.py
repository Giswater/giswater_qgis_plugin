"""ud schema smoke build."""

from __future__ import annotations

import os

from giswater_admin.engine import BuildParams, SchemaBuilder, drop_schema, load_manifest


REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
DBMODEL = os.path.join(REPO_ROOT, "dbmodel")


def test_ud_sample_full_round_trip(adapter, temp_schema_name):
    manifest = load_manifest(os.path.join(DBMODEL, "manifests", "ud.yaml"))
    params = BuildParams(
        schema_name=temp_schema_name,
        srid="25831",
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
                f'SELECT project_type FROM "{temp_schema_name}".sys_version '
                "ORDER BY id DESC LIMIT 1"
            )
            row = cur.fetchone()
        assert row is not None and row[0] == "UD"
    finally:
        drop_schema(adapter, temp_schema_name, cascade=True, commit=True)
