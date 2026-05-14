"""Shared helpers used by multiple subcommands."""

from __future__ import annotations

import argparse
import os
from typing import Any

from .. import conn as conn_mod
from ..engine import BuildParams, Manifest, SchemaBuilder, load_manifest
from ..engine.sql_runner import ConnectionLike
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


def open_conn(args: argparse.Namespace) -> ConnectionLike:
    info = conn_mod.resolve(args.conn, args.config)
    return conn_mod.open_connection(info, autocommit=False)


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


def report_result(
    args: argparse.Namespace,
    out: Out,
    manifest: Manifest,
    params: BuildParams,
    result: Any,
) -> int:
    """Render a build result. Returns process exit code."""
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


def build_progress_cb(out: Out):
    """Phase milestones on ``info:``; each SQL file on ``exec:`` when verbose."""
    state = {"last_label": ""}

    def progress(seen: int, total: int, label: str) -> None:
        if label.startswith("phase:") or label == "done":
            if label != state["last_label"]:
                out.info(f"[{seen}/{total}] {label}")
                state["last_label"] = label
        else:
            out.exec_file(seen, total, label)

    return progress
