"""SchemaBuilder role_system session handling."""

from __future__ import annotations

from pathlib import Path

from giswater_admin.engine.builder import BuildParams, SchemaBuilder
from giswater_admin.engine.manifest import Manifest, Phase, Profile, Step


class _SqlCaptureConn:
    def __init__(self) -> None:
        self.sql: list[str] = []

    def execute(self, sql: str, *, filepath: str | None = None) -> bool:
        self.sql.append(sql)
        return True

    def last_error(self) -> str:
        return ""

    def commit(self) -> None:
        pass

    def rollback(self) -> None:
        pass

    def close(self) -> None:
        pass


def _seed(root: Path) -> None:
    (root / "base").mkdir(parents=True)
    (root / "base" / "init.sql").write_text("-- init", encoding="utf-8")
    (root / "updates" / "4" / "15" / "0" / "ws").mkdir(parents=True)
    (root / "updates" / "4" / "15" / "0" / "ws" / "patch.sql").write_text(
        "-- update patch", encoding="utf-8"
    )
    (root / "sample").mkdir(parents=True)
    (root / "sample" / "data.sql").write_text("-- sample", encoding="utf-8")


def _manifest() -> Manifest:
    return Manifest(
        kind="ws",
        engine_version=1,
        substitutions={},
        phases=(
            Phase(id="load_base", type="sql_dir", steps=(Step(source="base"),)),
            Phase(
                id="updates",
                type="version_walk",
                root="updates",
                subdirs=("ws",),
                range={"mode": "{{ run_mode }}"},
            ),
            Phase(id="load_sample", type="sql_dir", steps=(Step(source="sample"),)),
            Phase(id="final_pass", type="sql_dir", steps=(Step(source="sample"),)),
        ),
        profiles={
            "sample_full": Profile(
                name="sample_full",
                phases=("load_base", "updates", "load_sample", "final_pass"),
            ),
        },
    )


def test_role_system_only_on_ddl_phases(tmp_path: Path):
    _seed(tmp_path)
    conn = _SqlCaptureConn()
    params = BuildParams(
        schema_name="ws_demo",
        sql_root=str(tmp_path),
        plugin_version="4.15.0",
        profile="sample_full",
    )
    result = SchemaBuilder(conn, _manifest(), params).run()
    assert result.ok

    joined = "\n".join(conn.sql)
    assert "EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'role_system')" in joined
    assert joined.count("SET ROLE role_system") == 1
    assert joined.count("RESET ROLE") == 1
    assert joined.index("SET ROLE role_system") < joined.index("-- init")
    assert joined.index("-- init") < joined.index("RESET ROLE")
    # updates/load_sample need superuser (DISABLE TRIGGER ALL in legacy patches)
    assert "-- update patch" in joined
    update_pos = joined.index("-- update patch")
    reset_pos = joined.index("RESET ROLE")
    assert update_pos > reset_pos
    assert "SET ROLE role_system" not in joined[update_pos:]
