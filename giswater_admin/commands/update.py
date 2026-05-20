"""``update`` subcommand: upgrade an existing schema in place."""

from __future__ import annotations

import argparse

from ..engine import BuildParams, SchemaBuilder
from ..output import Out
from . import _helpers as h


def run(args: argparse.Namespace, out: Out) -> int:
    conn = None
    if not args.check:
        conn = h.open_conn(args, out)

    # Infer kind + project_version from sys_version unless overridden.
    kind = args.kind
    project_version = "0.0.0"
    if conn is not None:
        if not kind:
            kind = h.detect_project_type(conn, args.schema)
            if not kind:
                out.error(
                    f"Could not detect project_type for schema '{args.schema}'. "
                    "Pass --kind."
                )
                conn.close()
                return 1
            out.info(f"kind auto-detected: {kind}")
        project_version = h.detect_project_version(conn, args.schema) or "0.0.0"
        out.info(f"current project_version: {project_version}")

    if not kind:
        out.error("kind is required when running with --check and no connection.")
        return 1

    manifest = h.manifest_for(args, kind)
    if "update" not in manifest.profiles:
        out.error(f"Manifest '{kind}' has no 'update' profile.")
        if conn is not None:
            conn.close()
        return 1

    target_version = args.to_version or args.plugin_version
    params = BuildParams(
        schema_name=args.schema,
        srid="0",  # irrelevant for upgrade phases (they don't touch SRID)
        locale=args.locale,
        plugin_version=target_version,
        project_version=project_version,
        run_mode="upgrade",
        profile="update",
        db_user=_safe_user(args),
        sql_root=args.dbmodel_path,
        profile_lastprocess=getattr(args, "profile_lastprocess", False),
    )

    if args.check:
        builder = SchemaBuilder(h.NoopConn(), manifest, params)
        plan = builder.plan()
        out.result(
            {
                "ok": True,
                "mode": "check",
                "kind": kind,
                "schema": args.schema,
                "from_version": project_version,
                "to_version": target_version,
                "plan": [{"phase": p.id, "files": n} for p, n in plan],
                "total_files": sum(n for _, n in plan),
            }
        )
        return 0

    assert conn is not None
    try:
        builder = SchemaBuilder(conn, manifest, params, progress_cb=h.progress_cb_for_args(out, args))
        result = builder.run()
        if result.ok:
            conn.commit()
        else:
            conn.rollback()
    finally:
        conn.close()

    code = h.report_result(args, out, manifest, params, result)
    # Inject extras into stdout when in JSON mode by re-using report_result is overkill;
    # surfacing the version pair via stderr is sufficient for the CLI contract.
    out.info(f"upgraded {args.schema}: {project_version} -> {target_version}: ok={result.ok}")
    return code


def _safe_user(args):
    from .. import conn as conn_mod  # noqa: WPS433 - local to avoid cycle
    try:
        return conn_mod.resolve(args.conn, args.config).user or "postgres"
    except RuntimeError:
        return "postgres"
