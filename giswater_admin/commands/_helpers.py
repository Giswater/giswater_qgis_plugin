"""Shared helpers used by multiple subcommands."""

from __future__ import annotations

import argparse
import os
import time
from collections import defaultdict
from typing import Any, Optional

from .. import conn as conn_mod
from ..engine import BuildParams, Manifest, SchemaBuilder, load_manifest
from ..engine.builder import ProgressCb
from ..engine.sql_runner import ConnectionLike, FileExec
from ..engine.timing_report import all_files, summarize_build
from ..log_format import (
    format_done,
    format_file,
    format_phase,
    format_profile_block,
    format_profile_step,
)
from ..output import Out


def manifest_for(args: argparse.Namespace, kind: str) -> Manifest:
    path = os.path.join(args.dbmodel_path, "manifests", f"{kind}.yaml")
    return load_manifest(path)


def needs_connection(args: argparse.Namespace) -> bool:
    """``--check`` runs offline; everything else needs a real connection."""
    if not getattr(args, "check", False):
        return True
    # Even in check mode, if user passed --conn/--config/PG*, honour it
    # so they get the safe_repr() in the output.
    return bool(args.conn or args.config or conn_mod.has_pg_env())


def open_conn(args: argparse.Namespace, out: Out | None = None) -> ConnectionLike:
    info = conn_mod.resolve(args.conn, args.config)
    conn = conn_mod.open_connection(info, autocommit=False)
    if getattr(args, "profile_lastprocess", False):
        try:
            conn.execute("SET client_min_messages TO NOTICE")
        except Exception:  # noqa: BLE001
            pass
    if getattr(args, "profile_lastprocess", False) and hasattr(conn, "set_notice_sink"):
        if out is not None:
            conn.set_notice_sink(out.info)
        else:
            import sys

            conn.set_notice_sink(
                lambda msg: print(f"notice: {msg}", file=sys.stderr, flush=True)
            )
    return conn


def safe_target_repr(args: argparse.Namespace) -> str:
    try:
        return conn_mod.resolve(args.conn, args.config).safe_repr()
    except RuntimeError:
        return ""


def detect_project_type(conn: Any, schema: str) -> str:
    """
    Return ``project_type`` (``ws``, ``ud``, ``cm``, ``am``, ``utils``)
    of ``schema`` based on its ``sys_version`` row, or empty if not
    detectable. ``conn`` is a Psycopg2Adapter (has ``.raw``).
    """
    sql = (
        "SELECT project_type FROM information_schema.tables "
        "WHERE table_schema = %s AND table_name = 'sys_version' LIMIT 1"
    )
    try:
        with conn.raw.cursor() as cur:  # type: ignore[attr-defined]
            cur.execute(
                f"SELECT project_type FROM \"{schema}\".sys_version "
                "ORDER BY id DESC LIMIT 1"
            )
            row = cur.fetchone()
            if row and row[0]:
                return str(row[0]).lower()
    except Exception:  # noqa: BLE001
        try:
            conn.rollback()
        except Exception:  # noqa: BLE001
            pass
    return ""


def detect_project_version(conn: Any, schema: str) -> str:
    try:
        with conn.raw.cursor() as cur:  # type: ignore[attr-defined]
            cur.execute(
                f"SELECT giswater FROM \"{schema}\".sys_version "
                "ORDER BY id DESC LIMIT 1"
            )
            row = cur.fetchone()
            if row and row[0]:
                return str(row[0])
    except Exception:  # noqa: BLE001
        try:
            conn.rollback()
        except Exception:  # noqa: BLE001
            pass
    return ""


def _profile_step_prefix(step_name: str) -> str:
    """Classify a profile step label for stderr (child_views vs child_config vs lastprocess)."""
    if step_name.startswith(
        ("multi_create", "view:", "role_permissions", "multi_create_loop")
    ):
        return "child_views_timing"
    if step_name.startswith(("ve_", "ve_element")) and ":" in step_name:
        return "child_config_timing"
    if step_name.startswith(
        ("start", "after_", "isnew_", "upgrade_", "total")
    ) and not step_name.startswith("ve_"):
        return "lastprocess_timing"
    if ":disable_cff_trigger" in step_name or ":copy_parent_cff" in step_name:
        return "child_config_timing"
    return "lastprocess_timing"


def make_profile_schema_name(kind: str) -> str:
    """Unique schema name for one-shot profiling creates."""
    return f"gw_{kind}_prof_{time.strftime('%Y%m%d%H%M%S')}"


def _profile_step_aggregate_key(step_name: str, prefix: str) -> str:
    """Normalize per-view step names for aggregated summaries."""
    if prefix == "child_config_timing" and ":" in step_name:
        return step_name.split(":", 1)[1]
    if prefix == "child_views_timing":
        if step_name.startswith("view:") and step_name.count(":") >= 2:
            return f"view:*:{step_name.rsplit(':', 1)[-1]}"
        if step_name.startswith("multi_create:"):
            return "multi_create:*"
    return step_name


def iter_lastprocess_profile_steps(result: Any):
    """Yield (step_name, ms) from lastprocess / lastprocess_upgrade phases."""
    for pr in result.phases:
        if pr.phase_id not in ("lastprocess", "lastprocess_upgrade"):
            continue
        for fx in pr.files:
            for step in fx.profile_steps:
                step_name = str(step.get("step", ""))
                try:
                    ms = int(step.get("ms") or 0)
                except (TypeError, ValueError):
                    ms = 0
                yield step_name, ms


def emit_lastprocess_profile_steps(result: Any, out: Out) -> None:
    """Print ``profileSteps`` collected from lastprocess (stderr)."""
    by_prefix: dict[str, list[tuple[str, int]]] = defaultdict(list)
    for step_name, ms in iter_lastprocess_profile_steps(result):
        prefix = _profile_step_prefix(step_name)
        by_prefix[prefix].append((step_name, ms))
    for prefix, steps in by_prefix.items():
        for step_name, ms in steps:
            out.info(format_profile_step(step_name, ms, style=out.style))
    return None


def _include_in_profile_summary(step_name: str) -> bool:
    """Skip per-view rollup lines that double-count wall-clock totals."""
    if step_name in ("total", "multi_create_loop_total"):
        return False
    if step_name.endswith(":total"):
        return False
    return True


def emit_profile_step_summary(result: Any, out: Out) -> None:
    """Print aggregated ms by step kind (stderr, ``profile_summary`` prefix)."""
    groups: dict[str, dict[str, list[int]]] = defaultdict(lambda: defaultdict(list))
    for step_name, ms in iter_lastprocess_profile_steps(result):
        if not _include_in_profile_summary(step_name):
            continue
        prefix = _profile_step_prefix(step_name)
        key = _profile_step_aggregate_key(step_name, prefix)
        groups[prefix][key].append(ms)

    for prefix in ("lastprocess_timing", "child_views_timing", "child_config_timing"):
        bucket = groups.get(prefix)
        if not bucket:
            continue
        ranked = sorted(bucket.items(), key=lambda item: -sum(item[1]))
        rows = []
        for key, ms_list in ranked:
            n = len(ms_list)
            total = sum(ms_list)
            avg = total // n if n else 0
            rows.append((key, n, total, avg))
        for line in format_profile_block(prefix, rows, style=out.style):
            out.info(line)
    return None


def report_result(
    args: argparse.Namespace,
    out: Out,
    manifest: Manifest,
    params: BuildParams,
    result: Any,
) -> int:
    """Render a build result. Returns process exit code."""
    if getattr(args, "profile_lastprocess", False):
        emit_lastprocess_profile_steps(result, out)
        if getattr(args, "profile_summary", False):
            emit_profile_step_summary(result, out)
        has_steps = any(iter_lastprocess_profile_steps(result))
        if not has_steps:
            out.warn(
                "no lastprocess_timing steps returned; redeploy "
                "gw_fct_admin_schema_lastprocess from dbmodel (load_base) or check --profile-lastprocess"
            )
    payload = {
        "ok": result.ok,
        "kind": manifest.kind,
        "schema": params.schema_name,
        "profile": params.profile,
        "cancelled": getattr(result, "cancelled", False),
        "phases": [
            {
                "phase": pr.phase_id,
                "ok": pr.ok,
                "skipped": pr.skipped,
                "files_executed": len(pr.files),
                "first_failure": next(
                    (
                        {"path": fx.path, "error": fx.error}
                        for fx in pr.files
                        if not fx.ok
                    ),
                    None,
                ),
            }
            for pr in result.phases
        ],
    }
    if getattr(args, "timing", False):
        top = int(getattr(args, "timing_top", 20))
        summary = summarize_build(result, top=top)
        out.timing_summary(summary)
        if getattr(args, "json", False):
            timing_payload: dict[str, Any] = dict(summary)
            if getattr(args, "timing_detail", False):
                timing_payload["files"] = all_files(result)
            payload["timing"] = timing_payload
    out.result(payload)
    return 0 if result.ok else 1


def cm_parent_supported(dbmodel_path: str, parent_type: str) -> bool:
    """
    Return ``True`` when `dbmodel/schemas/cm/parent_schema/<parent_type>/ddl.sql`
    exists. ``cm`` schema setup only ships content for `parent_type=ud`
    today; ws support requires populating the parallel tree first.
    """
    if not parent_type:
        return False
    ddl = os.path.join(dbmodel_path, "schemas", "cm", "parent_schema", parent_type, "ddl.sql")
    return os.path.isfile(ddl)


class NoopConn:
    """``ConnectionLike`` stub used in ``--check`` paths (no DB calls)."""

    def execute(self, sql, *, filepath=None):  # noqa: D401 - protocol shape
        return True

    def last_error(self) -> str:
        return ""

    def commit(self) -> None:
        pass

    def rollback(self) -> None:
        pass

    def close(self) -> None:
        pass


def build_progress_cb(
    out: Out,
    *,
    timing: bool = False,
    timing_threshold_ms: int = 0,
) -> ProgressCb:
    """Phase milestones and per-file lines (when ``out.verbose``)."""
    state = {"last_label": ""}
    out.style.show_timing_ms = bool(timing)

    def progress(
        seen: int,
        total: int,
        label: str,
        fx: Optional[FileExec] = None,
    ) -> None:
        if label.startswith("phase:"):
            if label != state["last_label"]:
                phase_id = label.split(":", 1)[1]
                out.info(format_phase(seen, total, phase_id, style=out.style))
                state["last_label"] = label
        elif label == "done":
            if label != state["last_label"]:
                out.info(format_done(seen, total, style=out.style))
                state["last_label"] = label
        elif out.verbose:
            ms = None
            if timing and fx is not None:
                if timing_threshold_ms and fx.duration_ms < timing_threshold_ms:
                    return
                ms = fx.duration_ms
            out.progress(
                format_file(seen, total, label, ms=ms, style=out.style)
            )

    return progress


def progress_cb_for_args(out: Out, args: argparse.Namespace) -> ProgressCb:
    """Build a progress callback wired to CLI timing flags."""
    out.style.sql_root = getattr(args, "dbmodel_path", "") or out.style.sql_root
    out.style.show_timing_ms = bool(getattr(args, "timing", False))
    return build_progress_cb(
        out,
        timing=getattr(args, "timing", False),
        timing_threshold_ms=int(getattr(args, "timing_threshold_ms", 0)),
    )
