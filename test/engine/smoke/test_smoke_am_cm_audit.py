"""am, cm, audit smoke builds."""

from __future__ import annotations

import os

import pytest

from giswater_admin.engine import BuildParams, SchemaBuilder, drop_schema, load_manifest


REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
DBMODEL = os.path.join(REPO_ROOT, "dbmodel")


def test_am_empty(adapter, temp_schema_name):
    manifest = load_manifest(os.path.join(DBMODEL, "manifests", "am.yaml"))
    params = BuildParams(
        schema_name=temp_schema_name, srid="25831",
        plugin_version="4.9.0", profile="empty",
        sql_root=DBMODEL,
    )
    try:
        result = SchemaBuilder(adapter, manifest, params).run()
        assert result.ok, f"am build: {result.first_failure()}"
        adapter.commit()
    finally:
        drop_schema(adapter, temp_schema_name, cascade=True, commit=True)


def test_am_update_replays_no_legacy_patches(adapter, temp_schema_name):
    """
    Create am pretending to be at 4.0.0, then upgrade to 4.9.0. The
    legacy date-collapsed patch at updates/0/0/0/am/ MUST NOT be
    replayed (it was already applied at create time).
    """
    manifest = load_manifest(os.path.join(DBMODEL, "manifests", "am.yaml"))
    create_params = BuildParams(
        schema_name=temp_schema_name, srid="25831",
        plugin_version="4.0.0", profile="empty",
        sql_root=DBMODEL,
    )
    try:
        r1 = SchemaBuilder(adapter, manifest, create_params).run()
        assert r1.ok, f"am create-at-4.0.0: {r1.first_failure()}"
        adapter.commit()

        upgrade_params = BuildParams(
            schema_name=temp_schema_name, srid="0",
            plugin_version="4.9.0", project_version="4.0.0",
            run_mode="upgrade", profile="update",
            sql_root=DBMODEL,
        )
        r2 = SchemaBuilder(adapter, manifest, upgrade_params).run()
        assert r2.ok, f"am upgrade-to-4.9.0: {r2.first_failure()}"
        adapter.commit()

        # The legacy 0/0/0 bucket is <= project_version 4.0.0, so the
        # upgrade phase should pick up zero files (no semver patches
        # between 4.0.0 exclusive and 4.9.0 inclusive exist yet).
        load_updates = next(p for p in r2.phases if p.phase_id == "load_updates")
        assert len(load_updates.files) == 0, (
            "am upgrade should not replay legacy 0/0/0 patches: "
            f"executed {[f.path for f in load_updates.files]}"
        )
    finally:
        drop_schema(adapter, temp_schema_name, cascade=True, commit=True)


def test_audit_structure(adapter):
    manifest = load_manifest(os.path.join(DBMODEL, "manifests", "audit.yaml"))
    params = BuildParams(
        schema_name="audit", srid="25831",
        plugin_version="4.9.0", profile="structure",
        sql_root=DBMODEL,
    )
    try:
        # `audit` schema is fixed-name; drop any stale one first.
        drop_schema(adapter, "audit", cascade=True, commit=True)
        result = SchemaBuilder(adapter, manifest, params).run()
        assert result.ok, f"audit structure: {result.first_failure()}"
        adapter.commit()
    finally:
        drop_schema(adapter, "audit", cascade=True, commit=True)


@pytest.fixture()
def parent_ws(adapter, temp_schema_name):
    """ws parent for cm tests."""
    ws = f"{temp_schema_name}_ws"
    manifest = load_manifest(os.path.join(DBMODEL, "manifests", "ws.yaml"))
    params = BuildParams(
        schema_name=ws, srid="25831",
        plugin_version="4.9.0", profile="empty",
        sql_root=DBMODEL,
    )
    try:
        r = SchemaBuilder(adapter, manifest, params).run()
        assert r.ok, f"ws build: {r.first_failure()}"
        adapter.commit()
        yield ws
    finally:
        drop_schema(adapter, ws, cascade=True, commit=True)


def test_cm_empty_attaches_to_ws_parent(adapter, parent_ws):
    cm_schema = f"{parent_ws}_cm"
    manifest = load_manifest(os.path.join(DBMODEL, "manifests", "cm.yaml"))
    params = BuildParams(
        schema_name=cm_schema, srid="25831",
        plugin_version="4.9.0", profile="empty",
        parent_schema=parent_ws, parent_type="ws",
        sql_root=DBMODEL,
    )
    try:
        result = SchemaBuilder(adapter, manifest, params).run()
        assert result.ok, f"cm build: {result.first_failure()}"
        adapter.commit()
    finally:
        drop_schema(adapter, cm_schema, cascade=True, commit=True)


def test_cm_update_profile_runs_walk_and_locale(adapter, parent_ws):
    """cm update profile should walk schemas/cm/updates/<v>/ then load locale."""
    cm_schema = f"{parent_ws}_cm"
    manifest = load_manifest(os.path.join(DBMODEL, "manifests", "cm.yaml"))
    create_params = BuildParams(
        schema_name=cm_schema, srid="25831",
        plugin_version="4.9.0", profile="empty",
        parent_schema=parent_ws, parent_type="ws",
        sql_root=DBMODEL,
    )
    try:
        r1 = SchemaBuilder(adapter, manifest, create_params).run()
        assert r1.ok, f"cm create: {r1.first_failure()}"
        adapter.commit()

        upgrade_params = BuildParams(
            schema_name=cm_schema, srid="0",
            plugin_version="4.9.0", project_version="4.8.0",
            run_mode="upgrade", profile="update",
            parent_schema=parent_ws, parent_type="ws",
            sql_root=DBMODEL,
        )
        r2 = SchemaBuilder(adapter, manifest, upgrade_params).run()
        assert r2.ok, f"cm update: {r2.first_failure()}"
        adapter.commit()

        phase_ids = [p.phase_id for p in r2.phases]
        assert "load_updates" in phase_ids
        assert "load_locale" in phase_ids
    finally:
        drop_schema(adapter, cm_schema, cascade=True, commit=True)
