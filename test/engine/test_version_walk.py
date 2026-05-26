"""Version-walk filtering across new_project / upgrade modes."""

from __future__ import annotations

import os
from pathlib import Path

from giswater_admin.engine.builder import BuildParams, SchemaBuilder
from giswater_admin.engine.manifest import Manifest, Phase, Profile


def _make_tree(root: Path, versions: list[tuple[int, int, int]]) -> None:
    """Create updates/M/m/p/ws/ddl.sql for each version triple."""
    for ma, mi, pa in versions:
        d = root / "updates" / str(ma) / str(mi) / str(pa) / "ws"
        d.mkdir(parents=True, exist_ok=True)
        (d / "ddl.sql").write_text("SELECT 1;", encoding="utf-8")


def _make_manifest() -> Manifest:
    return Manifest(
        kind="ws",
        engine_version=1,
        substitutions={},
        phases=(
            Phase(
                id="updates",
                type="version_walk",
                root="updates",
                subdirs=("ws",),
                range={"mode": "{{ run_mode }}"},
            ),
        ),
        profiles={"u": Profile(name="u", phases=("updates",))},
    )


class _FakeConn:
    def execute(self, sql, *, filepath=None): return True
    def last_error(self): return ""
    def commit(self): pass
    def rollback(self): pass
    def close(self): pass


def test_new_project_empty_applies_all_versions_up_to_plugin(tmp_path: Path):
    _make_tree(tmp_path, [(3, 6, 1), (4, 2, 0), (4, 9, 0)])
    manifest = Manifest(
        kind="ws",
        engine_version=1,
        substitutions={},
        phases=(
            Phase(
                id="updates",
                type="version_walk",
                root="updates",
                subdirs=("ws",),
                range={"mode": "{{ run_mode }}"},
            ),
        ),
        profiles={"empty": Profile(name="empty", phases=("updates",))},
    )
    params = BuildParams(
        schema_name="ws_demo",
        sql_root=str(tmp_path),
        plugin_version="4.9.0",
        project_version="0.0.0",
        run_mode="new_project",
        profile="empty",
    )
    b = SchemaBuilder(_FakeConn(), manifest, params)
    [(_phase, count)] = b.plan()
    assert count == 3  # 3.6.1, 4.2.0, 4.9.0


def test_new_project_includes_all_le_plugin(tmp_path: Path):
    _make_tree(tmp_path, [(3, 6, 1), (4, 0, 0), (4, 9, 0), (5, 0, 0)])
    params = BuildParams(
        schema_name="ws_demo", sql_root=str(tmp_path),
        plugin_version="4.9.0", project_version="0.0.0",
        run_mode="new_project", profile="u",
    )
    b = SchemaBuilder(_FakeConn(), _make_manifest(), params)
    plan = b.plan()
    [(_phase, count)] = plan
    assert count == 3  # 3.6.1, 4.0.0, 4.9.0 (not 5.0.0)


def test_upgrade_only_strictly_between_project_and_plugin(tmp_path: Path):
    _make_tree(tmp_path, [(3, 6, 1), (4, 0, 0), (4, 8, 0), (4, 9, 0), (5, 0, 0)])
    params = BuildParams(
        schema_name="ws_demo", sql_root=str(tmp_path),
        plugin_version="4.9.0", project_version="4.0.0",
        run_mode="upgrade", profile="u",
    )
    b = SchemaBuilder(_FakeConn(), _make_manifest(), params)
    [(_phase, count)] = b.plan()
    assert count == 2  # 4.8.0 and 4.9.0


def test_version_walk_ignores_non_numeric_dirs(tmp_path: Path):
    _make_tree(tmp_path, [(4, 9, 0)])
    # noise
    (tmp_path / "updates" / "README.md").write_text("ignore me", encoding="utf-8")
    (tmp_path / "updates" / "foo").mkdir()
    params = BuildParams(
        schema_name="ws_demo", sql_root=str(tmp_path),
        plugin_version="4.9.0", profile="u",
    )
    b = SchemaBuilder(_FakeConn(), _make_manifest(), params)
    [(_phase, count)] = b.plan()
    assert count == 1


def test_version_walk_empty_root_returns_zero(tmp_path: Path):
    params = BuildParams(
        schema_name="ws_demo", sql_root=str(tmp_path),
        plugin_version="4.9.0", profile="u",
    )
    b = SchemaBuilder(_FakeConn(), _make_manifest(), params)
    [(_phase, count)] = b.plan()
    assert count == 0
