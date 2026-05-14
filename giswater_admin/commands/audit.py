"""
``audit`` sub-subcommands: ``audit structure``, ``audit activate``,
``audit drop``.

``structure`` is a once-per-database operation; ``activate`` runs per
target ws/ud schema. ``drop`` is a convenience wrapper around the audit
schema (which has no sys_version, so plain ``drop`` works too).
"""

from __future__ import annotations

import argparse

from ..engine import BuildParams, SchemaBuilder, drop_schema
from ..output import Out
from . import _helpers as h


def run_structure(args: argparse.Namespace, out: Out) -> int:
    """Load audit/structure (and optionally audit_checkproject)."""
    manifest = h.manifest_for(args, "audit")
    profile = "full" if args.with_checkproject else "structure"
    params = BuildParams(
        schema_name="audit",
        srid="25831",
        locale=args.locale,
        plugin_version=args.plugin_version,
        run_mode="new_project",
        profile=profile,
        sql_root=args.dbmodel_path,
    )
    return _execute(args, out, manifest, params)


def run_activate(args: argparse.Namespace, out: Out) -> int:
    """Wire audit triggers into the target ws/ud schema."""
    manifest = h.manifest_for(args, "audit")
    params = BuildParams(
        schema_name=args.schema,  # target ws/ud schema
        srid="25831",
        locale=args.locale,
        plugin_version=args.plugin_version,
        run_mode="new_project",
        profile="activate",
        sql_root=args.dbmodel_path,
    )
    return _execute(args, out, manifest, params)


def run_drop(args: argparse.Namespace, out: Out) -> int:
    if not args.yes:
        out.error("audit drop is destructive; pass --yes.")
        return 1
    if args.check:
        out.result({"ok": True, "mode": "check", "sql": "DROP SCHEMA IF EXISTS audit CASCADE;"})
        return 0
    conn = h.open_conn(args)
    try:
        fx = drop_schema(conn, "audit", cascade=True, commit=True)
        if not fx.ok:
            conn.rollback()
    finally:
        conn.close()
    out.result({"ok": fx.ok, "schema": "audit", "error": fx.error or None})
    return 0 if fx.ok else 1


def _execute(args: argparse.Namespace, out: Out, manifest, params: BuildParams) -> int:
    if args.check:
        builder = SchemaBuilder(h.NoopConn(), manifest, params)
        plan = builder.plan()
        out.result(
            {
                "ok": True,
                "mode": "check",
                "kind": "audit",
                "schema": params.schema_name,
                "profile": params.profile,
                "plan": [{"phase": p.id, "files": n} for p, n in plan],
                "total_files": sum(n for _, n in plan),
            }
        )
        return 0

    conn = h.open_conn(args)
    try:
        builder = SchemaBuilder(conn, manifest, params, progress_cb=h.build_progress_cb(out))
        result = builder.run()
        if result.ok:
            conn.commit()
        else:
            conn.rollback()
    finally:
        conn.close()
    return h.report_result(args, out, manifest, params, result)
