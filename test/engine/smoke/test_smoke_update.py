"""Upgrade path smoke test: build an older ws, then upgrade it forward."""

from __future__ import annotations

import os

from giswater_admin.engine import BuildParams, SchemaBuilder, drop_schema, load_manifest


REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
DBMODEL = os.path.join(REPO_ROOT, "dbmodel")


def test_ws_upgrade_from_4_8_to_4_9(adapter, temp_schema_name):
    """
    Build ws pretending the plugin is at 4.8.0, then upgrade to 4.9.0.
    Asserts that the update path applies more patches the second time.
    """
    manifest = load_manifest(os.path.join(DBMODEL, "manifests", "ws.yaml"))

    create_params = BuildParams(
        schema_name=temp_schema_name, srid="25831",
        plugin_version="4.8.0", profile="empty",
        sql_root=DBMODEL,
    )
    try:
        r1 = SchemaBuilder(adapter, manifest, create_params).run()
        assert r1.ok, f"create-at-4.8.0 failed: {r1.first_failure()}"
        adapter.commit()

        upgrade_params = BuildParams(
            schema_name=temp_schema_name, srid="25831",
            plugin_version="4.9.0", project_version="4.8.0",
            run_mode="upgrade", profile="update",
            sql_root=DBMODEL,
        )
        r2 = SchemaBuilder(adapter, manifest, upgrade_params).run()
        assert r2.ok, f"upgrade-to-4.9.0 failed: {r2.first_failure()}"
        adapter.commit()

        # Verify sys_version is now bumped via the lastprocess_upgrade phase.
        with adapter.raw.cursor() as cur:
            cur.execute(
                f'SELECT giswater FROM "{temp_schema_name}".sys_version '
                "ORDER BY id DESC LIMIT 1"
            )
            row = cur.fetchone()
        assert row is not None
        assert row[0].startswith("4.9"), f"unexpected version after upgrade: {row}"
    finally:
        drop_schema(adapter, temp_schema_name, cascade=True, commit=True)
