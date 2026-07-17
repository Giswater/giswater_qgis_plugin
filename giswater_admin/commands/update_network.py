"""``network update`` — lockstep upgrade of an interconnected schema cluster."""

from __future__ import annotations

import argparse

from ..cli.version_args import normalize_version_args
from ..engine.network_update import plan_lockstep, run_lockstep
from ..engine.schema_catalog import (
    discover_database_network,
    format_database_network,
    make_conn_fetcher,
)
from ..engine.version_guard import assert_network_no_downgrade
from ..output import Out
from . import _helpers as h
from .network import _database_name


def run(args: argparse.Namespace, out: Out) -> int:
    normalize_version_args(args)
    target_version = args.to_version or args.plugin_version or getattr(args, "version", None)
    conn = h.open_conn(args, out) if h.needs_connection(args) else None
    if conn is None:
        out.error("network update requires a connection.")
        return 1

    fetcher = make_conn_fetcher(conn)
    schema_filter = (
        getattr(args, "schema", None)
        or getattr(args, "anchor", None)
        or None
    )
    db = discover_database_network(fetcher, schema_filter=schema_filter)
    graph = db.cluster
    if not graph.nodes:
        out.error("No interconnected Giswater network discovered in this database.")
        conn.close()
        return 1

    if target_version:
        err = assert_network_no_downgrade(graph, target_version)
        if err:
            out.error(err)
            conn.close()
            return 1

    steps = plan_lockstep(graph, args.dbmodel_path, target_version)
    if not steps:
        payload = {
            "ok": True,
            "target_version": target_version,
            "message": "Network already at target version.",
            "steps": [],
        }
        if not getattr(args, "json", False):
            out.info(format_database_network(db, database=_database_name(args)))
            out.info(f"Network already at {target_version}.")
        out.result(payload)
        conn.close()
        return 0

    if args.check:
        payload = {
            "ok": True,
            "mode": "check",
            "target_version": target_version,
            "version_skew": graph.version_skew,
            "steps": [
                {
                    "target_version": step.target_version,
                    "kind": step.kind,
                    "schema": step.schema,
                    "action": step.action,
                    "from_version": step.from_version,
                }
                for step in steps
            ],
        }
        if not getattr(args, "json", False):
            out.info(format_database_network(db, database=_database_name(args)))
            out.info(f"Lockstep plan to {target_version} ({len(steps)} steps):")
            for step in steps:
                out.info(
                    f"  {step.target_version}  {step.kind:6}  {step.schema:12}  "
                    f"{step.action:7}  ({step.from_version})"
                )
        out.result(payload)
        conn.close()
        return 0

    assert conn is not None
    try:
        out.info(format_database_network(db, database=_database_name(args)))
        out.info(f"Running lockstep update to {target_version} ({len(steps)} steps)...")
        result = run_lockstep(
            conn,
            steps,
            args.dbmodel_path,
            locale=args.locale,
            db_user=_safe_user(args),
        )
        payload = {
            "ok": result.ok,
            "target_version": target_version,
            "steps": result.results,
            "error": result.error or None,
        }
        out.result(payload)
        return 0 if result.ok else 1
    finally:
        conn.close()


def _safe_user(args: argparse.Namespace) -> str:
    from .. import conn as conn_mod  # noqa: WPS433

    try:
        return conn_mod.resolve(args.conn, args.config).user or "postgres"
    except RuntimeError:
        return "postgres"
