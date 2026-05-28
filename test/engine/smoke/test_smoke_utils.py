"""utils satellite schema smoke build.

Requires a ws + ud schema to exist in the DB. Builds throwaway ws_test /
ud_test, then a single utils, then tears all three down.
"""

from __future__ import annotations

import os

import pytest

from giswater_admin.engine import BuildParams, SchemaBuilder, drop_schema, load_manifest


REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
DBMODEL = os.path.join(REPO_ROOT, "dbmodel")


@pytest.fixture()
def parent_schemas(adapter, temp_schema_name):
    """Build a ws + ud pair so utils has something to link to."""
    ws = f"{temp_schema_name}_ws"
    ud = f"{temp_schema_name}_ud"
    manifests = {
        "ws": load_manifest(os.path.join(DBMODEL, "manifests", "ws.yaml")),
        "ud": load_manifest(os.path.join(DBMODEL, "manifests", "ud.yaml")),
    }
    try:
        for kind, schema in [("ws", ws), ("ud", ud)]:
            params = BuildParams(
                schema_name=schema, srid="25831",
                plugin_version="4.9.0", profile="empty",
                sql_root=DBMODEL,
            )
            r = SchemaBuilder(adapter, manifests[kind], params).run()
            assert r.ok, f"{kind} build: {r.first_failure()}"
            adapter.commit()
        yield ws, ud
    finally:
        for schema in (ws, ud):
            drop_schema(adapter, schema, cascade=True, commit=True)


def test_utils_empty(adapter):
    manifest = load_manifest(os.path.join(DBMODEL, "manifests", "utils.yaml"))
    params = BuildParams(
        schema_name="utils", srid="25831",
        plugin_version="4.9.0", main_project_version="4.9.0",
        profile="empty", register_is_new="true",
        sql_root=DBMODEL,
    )
    try:
        drop_schema(adapter, "utils", cascade=True, commit=True)
        result = SchemaBuilder(adapter, manifest, params).run()
        assert result.ok, f"utils build: {result.first_failure()}"
        adapter.commit()
        with adapter.raw.cursor() as cur:
            cur.execute(
                "SELECT giswater FROM utils.sys_version ORDER BY id DESC LIMIT 1"
            )
            row = cur.fetchone()
        assert row is not None and row[0] == "4.9.0"
    finally:
        drop_schema(adapter, "utils", cascade=True, commit=True)


def test_utils_update_in_place(adapter, parent_schemas):
    """Create utils at 4.8.0, then upgrade it to 4.9.0 via the update profile."""
    ws, ud = parent_schemas
    manifest = load_manifest(os.path.join(DBMODEL, "manifests", "utils.yaml"))
    create_params = BuildParams(
        schema_name="utils", srid="25831",
        plugin_version="4.8.0", main_project_version="4.8.0",
        profile="empty", register_is_new="true",
        sql_root=DBMODEL,
    )
    try:
        drop_schema(adapter, "utils", cascade=True, commit=True)
        r1 = SchemaBuilder(adapter, manifest, create_params).run()
        assert r1.ok, f"utils create-at-4.8.0: {r1.first_failure()}"
        adapter.commit()

        update_params = BuildParams(
            schema_name="utils", srid="0",
            plugin_version="4.9.0", project_version="4.8.0",
            main_project_version="4.9.0",
            run_mode="upgrade", profile="update",
            infer_parents_from_config="true",
            sql_root=DBMODEL,
        )
        r2 = SchemaBuilder(adapter, manifest, update_params).run()
        assert r2.ok, f"utils upgrade-to-4.9.0: {r2.first_failure()}"
        adapter.commit()

        with adapter.raw.cursor() as cur:
            cur.execute(
                "SELECT giswater FROM utils.sys_version ORDER BY id DESC LIMIT 1"
            )
            row = cur.fetchone()
        assert row is not None
        assert row[0] == "4.9.0", f"unexpected utils sys_version after upgrade: {row}"
    finally:
        drop_schema(adapter, "utils", cascade=True, commit=True)
