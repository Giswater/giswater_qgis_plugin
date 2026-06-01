"""Alphabetical dir-walk filtering for am-style date folders."""

from __future__ import annotations

from pathlib import Path

from giswater_admin.engine.builder import BuildParams, SchemaBuilder
from giswater_admin.engine.manifest import Manifest, Phase, Profile


def _make_tree(root: Path, names: list[str]) -> None:
    for n in names:
        d = root / "am" / "updates" / n
        d.mkdir(parents=True, exist_ok=True)
        (d / "ddl.sql").write_text("-- noop", encoding="utf-8")


def _manifest(range_: dict) -> Manifest:
    return Manifest(
        kind="am",
        engine_version=1,
        substitutions={},
        phases=(
            Phase(
                id="walk",
                type="dir_walk",
                root="am/updates",
                range=range_,
            ),
        ),
        profiles={"u": Profile(name="u", phases=("walk",))},
    )


class _FakeConn:
    def execute(self, sql, *, filepath=None): return True
    def last_error(self): return ""
    def commit(self): pass
    def rollback(self): pass
    def close(self): pass


def test_new_project_walks_all_when_no_to_inclusive(tmp_path: Path):
    _make_tree(tmp_path, ["2023-05", "2024-01", "2025-11", "2026-04"])
    params = BuildParams(
        schema_name="am", sql_root=str(tmp_path),
        run_mode="new_project", profile="u",
    )
    b = SchemaBuilder(_FakeConn(), _manifest({"mode": "{{ run_mode }}"}), params)
    [(_, count)] = b.plan()
    assert count == 4


def test_new_project_respects_to_inclusive(tmp_path: Path):
    _make_tree(tmp_path, ["2023-05", "2024-01", "2025-11", "2026-04"])
    params = BuildParams(
        schema_name="am", sql_root=str(tmp_path),
        run_mode="new_project", profile="u", am_target="2024-01",
    )
    b = SchemaBuilder(
        _FakeConn(),
        _manifest({"mode": "{{ run_mode }}", "to_inclusive": "{{ am_target }}"}),
        params,
    )
    [(_, count)] = b.plan()
    assert count == 2  # 2023-05 + 2024-01


def test_upgrade_uses_from_exclusive(tmp_path: Path):
    _make_tree(tmp_path, ["2023-05", "2024-01", "2025-11", "2026-04"])
    params = BuildParams(
        schema_name="am", sql_root=str(tmp_path),
        run_mode="upgrade", profile="u", am_target="2026-04",
    )
    b = SchemaBuilder(
        _FakeConn(),
        _manifest(
            {
                "mode": "{{ run_mode }}",
                "from_exclusive": "2024-01",
                "to_inclusive": "{{ am_target }}",
            }
        ),
        params,
    )
    [(_, count)] = b.plan()
    assert count == 2  # 2025-11 + 2026-04


def test_dir_walk_ignores_hidden_dirs(tmp_path: Path):
    _make_tree(tmp_path, ["2025-11"])
    (tmp_path / "am" / "updates" / ".cache").mkdir()
    (tmp_path / "am" / "updates" / "ignored.txt").write_text("nope", encoding="utf-8")
    params = BuildParams(
        schema_name="am", sql_root=str(tmp_path),
        run_mode="new_project", profile="u",
    )
    b = SchemaBuilder(_FakeConn(), _manifest({"mode": "{{ run_mode }}"}), params)
    [(_, count)] = b.plan()
    assert count == 1
