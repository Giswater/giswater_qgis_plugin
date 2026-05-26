"""End-to-end planner: real dbmodel manifests should produce a stable plan."""

from __future__ import annotations

import os

import pytest

from giswater_admin.engine.builder import BuildParams, SchemaBuilder
from giswater_admin.engine.manifest import load_manifest


class _FakeConn:
    def execute(self, sql, *, filepath=None): return True
    def last_error(self): return ""
    def commit(self): pass
    def rollback(self): pass
    def close(self): pass


def _manifest(manifests_path: str, kind: str):
    p = os.path.join(manifests_path, f"{kind}.yaml")
    if not os.path.isfile(p):
        pytest.skip(f"manifest not present yet: {p}")
    return load_manifest(p)


@pytest.mark.parametrize("kind,profile", [
    ("ws", "empty"),
    ("ws", "sample_full"),
    ("ud", "empty"),
    ("utils", "empty"),
    ("am", "empty"),
    ("cm", "empty"),
    ("audit", "structure"),
])
def test_plan_produces_positive_file_count(manifests_path, dbmodel_path, kind, profile):
    manifest = _manifest(manifests_path, kind)
    if profile not in manifest.profiles:
        pytest.skip(f"profile {profile} not declared for {kind}")
    params = BuildParams(
        schema_name=f"{kind}_demo",
        srid="25831",
        sql_root=dbmodel_path,
        plugin_version="4.9.0",
        profile=profile,
        ws_schema="ws_demo",
        ud_schema="ud_demo",
        parent_schema="ws_demo",
        parent_type="ws",
    )
    b = SchemaBuilder(_FakeConn(), manifest, params)
    plan = b.plan()
    total = sum(c for _, c in plan)
    # At minimum: every kind should resolve at least one phase with files.
    # (audit/structure should hit ~4 files; ws/empty hundreds; cm/empty dozens.)
    assert total > 0, f"plan for {kind}/{profile} was empty: {plan}"
