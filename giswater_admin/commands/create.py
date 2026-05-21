"""``create`` subcommand."""

from __future__ import annotations

import argparse
import os

from .. import conn as conn_mod
from ..engine import BuildParams, SchemaBuilder
from ..output import Out
from . import _helpers as h


def run(args: argparse.Namespace, out: Out) -> int:
    manifest = h.manifest_for(args, args.kind)
    if args.profile not in manifest.profiles:
        out.error(
            f"Unknown profile '{args.profile}' for kind '{args.kind}'. "
            f"Known: {sorted(manifest.profiles)}"
        )
        return 1

    if args.kind == "utils" and (not args.ws_schema or not args.ud_schema):
        out.error("kind=utils requires --ws-schema and --ud-schema.")
        return 1
    if args.kind == "cm" and not args.parent_schema:
        out.error("kind=cm requires --parent-schema.")
        return 1
    if args.kind == "am" and not args.parent_schema:
        out.error(
            "kind=am requires --parent-schema (ws network schema with ve_arc/ve_node)."
        )
        return 1

    target_repr = h.safe_target_repr(args)
    if target_repr:
        out.info(f"target: {target_repr}")
    out.info(f"manifest: {manifest.path}")
    out.info(f"profile: {args.profile}")

    am_target = args.am_target or ""
    if am_target:
        out.warn("--am-target is deprecated; AM now uses --plugin-version (semver).")

    parent_type = ""
    conn = None
    if h.needs_connection(args) and not args.check:
        conn = h.open_conn(args, out)

    # am / cm parent_type auto-detect
    if args.kind == "am":
        parent_type = (args.parent_type or "ws").lower()
        if conn is not None and not args.parent_type:
            detected = h.detect_project_type(conn, args.parent_schema)
            if detected:
                parent_type = detected
                out.info(f"parent_type auto-detected: {parent_type}")

    if args.kind == "cm":
        if args.parent_type:
            parent_type = args.parent_type.lower()
        elif conn is not None:
            parent_type = h.detect_project_type(conn, args.parent_schema)
            if parent_type:
                out.info(f"parent_type auto-detected: {parent_type}")
        if not parent_type:
            out.error(
                "kind=cm: could not detect parent_type. "
                "Pass --parent-type ws|ud or ensure parent has sys_version.project_type."
            )
            if conn is not None:
                conn.close()
            return 1
        if not h.cm_parent_supported(args.dbmodel_path, parent_type):
            out.error(
                f"kind=cm: parent_type='{parent_type}' is not supported in this dbmodel. "
                f"Missing 'schemas/cm/parent_schema/{parent_type}/ddl.sql'."
            )
            if conn is not None:
                conn.close()
            return 1

    # utils: lift main_project_version from ws parent when --main-version not provided.
    locale = args.locale
    srid = args.srid
    main_version = args.main_version or args.plugin_version
    if (
        args.kind == "utils"
        and conn is not None
        and not args.main_version
    ):
        ws_ver = h.detect_project_version(conn, args.ws_schema)
        if ws_ver:
            main_version = ws_ver
            out.info(f"main_project_version lifted from {args.ws_schema}: {ws_ver}")

    params = BuildParams(
        schema_name=args.schema,
        srid=str(srid),
        locale=locale,
        plugin_version=args.plugin_version,
        project_version="0.0.0",
        run_mode="new_project",
        profile=args.profile,
        db_user=args.db_user or _conn_user(args),
        sql_root=args.dbmodel_path,
        ws_schema=args.ws_schema or "",
        ud_schema=args.ud_schema or "",
        parent_schema=args.parent_schema or "",
        parent_type=parent_type,
        am_target=am_target,
        main_project_version=main_version,
    )

    if args.check:
        return _print_check(out, manifest, params, target_repr)

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

    return h.report_result(args, out, manifest, params, result)


def _print_check(out: Out, manifest, params: BuildParams, target_repr: str) -> int:
    """Plan-only output. Never opens a DB connection."""
    builder = SchemaBuilder(h.NoopConn(), manifest, params)
    plan = builder.plan()
    out.result(
        {
            "ok": True,
            "mode": "check",
            "kind": manifest.kind,
            "schema": params.schema_name,
            "profile": params.profile,
            "target": target_repr or None,
            "plan": [{"phase": p.id, "files": n} for p, n in plan],
            "total_files": sum(n for _, n in plan),
        }
    )
    return 0


def _conn_user(args: argparse.Namespace) -> str:
    try:
        info = conn_mod.resolve(args.conn, args.config)
    except RuntimeError:
        return "postgres"
    return info.user or "postgres"


def _auto_am_target(dbmodel_path: str) -> str:
    """Deprecated: am uses semver version_walk now; kept until --am-target is removed."""
    root = os.path.join(dbmodel_path, "am", "updates")
    if not os.path.isdir(root):
        return ""
    entries = sorted(
        e for e in os.listdir(root)
        if os.path.isdir(os.path.join(root, e)) and not e.startswith(".")
    )
    return entries[-1] if entries else ""
