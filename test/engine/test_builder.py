"""End-to-end SchemaBuilder behaviour with a fake connection + tmp dbmodel."""

from __future__ import annotations

from pathlib import Path

from giswater_admin.engine.builder import BuildParams, SchemaBuilder, _inject_profile_timing
from giswater_admin.engine.sql_runner import _parse_profile_steps
from giswater_admin.engine.cancel import CancelToken
from giswater_admin.engine.manifest import Manifest, Phase, Profile, Step


class _RecConn:
    def __init__(self, fail_on: str = "") -> None:
        self.fail_on = fail_on
        self.executed: list[str] = []
        self.commits = 0
        self.rollbacks = 0
        self._err = ""

    def execute(self, sql: str, *, filepath: str | None = None) -> bool:
        if self.fail_on and self.fail_on in (filepath or sql):
            self._err = f"forced failure on {self.fail_on}"
            return False
        self.executed.append(filepath or sql[:40])
        return True

    def last_error(self) -> str:
        return self._err

    def commit(self) -> None:
        self.commits += 1

    def rollback(self) -> None:
        self.rollbacks += 1

    def close(self) -> None:
        pass


def _seed(root: Path) -> None:
    """Tiny synthetic dbmodel."""
    (root / "ws" / "fct").mkdir(parents=True)
    (root / "ws" / "fct" / "01.sql").write_text("-- one\nSELECT 'SCHEMA_NAME';", encoding="utf-8")
    (root / "ws" / "fct" / "02.sql").write_text("-- two", encoding="utf-8")
    (root / "updates" / "4" / "9" / "0" / "ws").mkdir(parents=True)
    (root / "updates" / "4" / "9" / "0" / "ws" / "ddl.sql").write_text("-- update", encoding="utf-8")
    (root / "final_pass" / "ws" / "i18n" / "en_US").mkdir(parents=True)
    (root / "final_pass" / "ws" / "i18n" / "en_US" / "en_US.sql").write_text("-- en", encoding="utf-8")


def _manifest() -> Manifest:
    return Manifest(
        kind="ws",
        engine_version=1,
        substitutions={},
        phases=(
            Phase(id="load_base", type="sql_dir",
                  steps=(Step(source="ws/fct"),)),
            Phase(id="updates", type="version_walk", root="updates",
                  subdirs=("ws",), range={"mode": "{{ run_mode }}"}),
            Phase(id="final_pass", type="sql_dir",
                  steps=(Step(
                      source="final_pass/ws/i18n/{{ locale }}",
                      fallback_source="final_pass/ws/i18n/en_US",
                  ),)),
        ),
        profiles={"empty": Profile(name="empty",
                                    phases=("load_base", "updates", "final_pass"))},
    )


def test_runs_all_phases_successfully(tmp_path: Path):
    _seed(tmp_path)
    conn = _RecConn()
    params = BuildParams(
        schema_name="ws_demo", srid="25831", sql_root=str(tmp_path),
        plugin_version="4.9.0", profile="empty",
    )
    result = SchemaBuilder(conn, _manifest(), params).run()
    assert result.ok
    assert [pr.phase_id for pr in result.phases] == ["load_base", "updates", "final_pass"]
    assert len(conn.executed) == 4  # 2 base + 1 update + 1 final_pass


def test_locale_fallback_used_when_locale_folder_missing(tmp_path: Path):
    _seed(tmp_path)
    conn = _RecConn()
    params = BuildParams(
        schema_name="ws_demo", sql_root=str(tmp_path),
        plugin_version="4.9.0", profile="empty",
        locale="zz_ZZ",  # nonexistent
    )
    result = SchemaBuilder(conn, _manifest(), params).run()
    assert result.ok
    fp = next(pr for pr in result.phases if pr.phase_id == "final_pass")
    assert any("en_US" in fx.path for fx in fp.files)


def test_stops_on_first_failure(tmp_path: Path):
    _seed(tmp_path)
    conn = _RecConn(fail_on="01.sql")
    params = BuildParams(
        schema_name="ws_demo", sql_root=str(tmp_path),
        plugin_version="4.9.0", profile="empty",
    )
    result = SchemaBuilder(conn, _manifest(), params).run()
    assert not result.ok
    assert len(result.phases) == 1  # bailed out before updates/final_pass
    fail = result.first_failure()
    assert fail is not None and "01.sql" in fail.path


def test_cancel_token_stops_engine(tmp_path: Path):
    _seed(tmp_path)
    conn = _RecConn()
    token = CancelToken()
    token.cancel()
    params = BuildParams(
        schema_name="ws_demo", sql_root=str(tmp_path),
        plugin_version="4.9.0", profile="empty",
        cancel_token=token,
    )
    result = SchemaBuilder(conn, _manifest(), params).run()
    assert result.cancelled
    assert not result.ok


def test_parse_profile_steps_root_profile_steps():
    raw = '{"profileSteps":[{"step":"ve_node_pump:copy_parent_cff","ms":120}]}'
    steps = _parse_profile_steps(raw)
    assert len(steps) == 1
    assert steps[0]["step"] == "ve_node_pump:copy_parent_cff"


def test_parse_profile_steps_from_function_json():
    raw = (
        '{"status":"Accepted","body":{"data":{"profileSteps":['
        '{"step":"after_reset_sequences","ms":4200},{"step":"total","ms":9500}'
        "]}}}"
    )
    steps = _parse_profile_steps(raw)
    assert len(steps) == 2
    assert steps[0]["step"] == "after_reset_sequences"
    assert steps[0]["ms"] == 4200


def test_inject_profile_timing():
    payload = {"client": {"lang": "en_US"}, "data": {"isNewProject": "TRUE"}}
    out = _inject_profile_timing(payload)
    assert out["data"]["profileTiming"] is True
    assert out["data"]["isNewProject"] == "TRUE"


def test_substitutions_applied_in_file_content(tmp_path: Path):
    _seed(tmp_path)
    conn = _RecConn()

    # Spy on what arrives at execute().
    sent_payloads: list[str] = []
    original = conn.execute
    def spy(sql, *, filepath=None):
        sent_payloads.append(sql)
        return original(sql, filepath=filepath)
    conn.execute = spy  # type: ignore[method-assign]

    params = BuildParams(
        schema_name="ws_real", srid="3857", sql_root=str(tmp_path),
        plugin_version="4.9.0", profile="empty",
    )
    SchemaBuilder(conn, _manifest(), params).run()
    assert any("ws_real" in p for p in sent_payloads)
