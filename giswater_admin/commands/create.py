"""``create`` subcommand."""

from __future__ import annotations

import argparse
import os

from .. import conn as conn_mod
from ..engine import BuildParams, SchemaBuilder
from ..output import Out
from . import _helpers as h


def run(args: argparse.Namespace, out: Out) -> int:  # noqa: C901
    manifest = h.manifest_for(args, args.kind)
    if args.profile not in manifest.profiles:
        out.error(
            f"Unknown profile '{args.profile}' for kind '{args.kind}'. "
            f"Known: {sorted(manifest.profiles)}"
        )
        return 1

    if args.kind == "utils":
        if args.profile == "integrate_ws" and not args.ws_schema:
            out.error("kind=utils profile=integrate_ws requires --ws-schema.")
            return 1
        if args.profile == "integrate_ud" and not args.ud_schema:
            out.error("kind=utils profile=integrate_ud requires --ud-schema.")
            return 1
    if args.kind == "cm" and args.profile not in ("update", "empty", "bootstrap") and not args.parent_schema:
        out.error("kind=cm requires --parent-schema (except profile=empty|update).")
        return 1
    if args.kind == "cibs" and args.profile == "integrate" and not args.parent_schema:
        out.error("kind=cibs profile=integrate requires --parent-schema.")
        return 1
    if args.kind == "audit":
        if args.profile == "integrate":
            args.profile = "activate"
        if args.profile in ("activate",) and not args.parent_schema:
            out.error("kind=audit profile=integrate requires --parent-schema.")
            return 1
        if args.schema != "audit":
            out.warn("kind=audit usually uses schema name 'audit'.")

    if args.kind == "cibs" and args.schema != "cibs":
        out.warn("kind=cibs usually uses schema name 'cibs' (singleton satellite).")

    _AM_CREATE_PROFILES = frozenset({"empty", "sample"})
    _AM_INTEGRATE_PROFILES = frozenset({"integrate", "integrate_sample"})

    if args.kind == "am":
        if args.profile in _AM_INTEGRATE_PROFILES and not args.parent_schema:
            out.error(
                "kind=am profile=integrate|integrate_sample requires --parent-schema."
            )
            return 1
        if args.profile not in _AM_CREATE_PROFILES | _AM_INTEGRATE_PROFILES | {"update"}:
            out.error(
                f"Unknown profile '{args.profile}' for kind=am. "
                f"Known: {sorted(_AM_CREATE_PROFILES | _AM_INTEGRATE_PROFILES | {'update'})}"
            )
            return 1

    target_repr = h.safe_target_repr(args)
    if target_repr:
        out.info(f"target: {target_repr}")
    out.info(f"manifest: {manifest.path}")
    out.info(f"profile: {args.profile}")

    am_target = getattr(args, "am_target", None) or ""

    parent_type = ""
    conn = None
    needs_detect_in_check = args.check and h.needs_connection(args) and (
        (
            args.kind in ("cm", "cibs")
            and args.parent_schema
            and not args.parent_type
        )
        or (
            args.kind == "am"
            and args.profile in _AM_INTEGRATE_PROFILES
            and args.parent_schema
            and not args.parent_type
        )
        or (args.kind == "utils" and not args.main_version and (args.ws_schema or args.ud_schema))
    )
    if (h.needs_connection(args) and not args.check) or needs_detect_in_check:
        conn = h.open_conn(args, out)

    # am parent_type: only required for integrate profiles (from sys_version).
    if args.kind == "am" and args.profile in _AM_INTEGRATE_PROFILES:
        if args.parent_type:
            parent_type = args.parent_type.lower()
        elif conn is not None and args.parent_schema:
            parent_type = h.detect_project_type(conn, args.parent_schema)
            if parent_type:
                out.info(f"parent_type auto-detected: {parent_type}")
        if not parent_type:
            out.error(
                "kind=am: could not detect parent_type. "
                "Pass --parent-type ws or ensure parent has sys_version.project_type."
            )
            if conn is not None:
                conn.close()
            return 1
        if parent_type == "ud":
            out.error(
                "kind=am: parent project is UD. AM only integrates with WS parent schemas."
            )
            if conn is not None:
                conn.close()
            return 1
        if not h.am_parent_supported(args.dbmodel_path, parent_type):
            out.error(
                f"kind=am: parent_type='{parent_type}' is not supported in this dbmodel. "
                f"Missing 'schemas/addon/am/integration/{parent_type}/integration.sql'."
            )
            if conn is not None:
                conn.close()
            return 1
        if conn is not None and not args.check:
            linked = h.detect_am_linked_parent(conn, args.schema or "am")
            if linked:
                out.error(
                    f"kind=am: already integrated with parent '{linked}'. "
                    "AM is a singleton satellite (one parent per database)."
                )
                conn.close()
                return 1

    if args.kind == "cm":
        if args.parent_type:
            parent_type = args.parent_type.lower()
        elif conn is not None and args.parent_schema:
            parent_type = h.detect_project_type(conn, args.parent_schema)
            if parent_type:
                out.info(f"parent_type auto-detected: {parent_type}")
        if args.profile != "update" and not parent_type:
            out.error(
                "kind=cm: could not detect parent_type. "
                "Pass --parent-type ws|ud or ensure parent has sys_version.project_type."
            )
            if conn is not None:
                conn.close()
            return 1
        if parent_type and not h.cm_parent_supported(args.dbmodel_path, parent_type):
            out.error(
                f"kind=cm: parent_type='{parent_type}' is not supported in this dbmodel. "
                f"Missing 'schemas/addon/cm/integration/{parent_type}/integration.sql'."
            )
            if conn is not None:
                conn.close()
            return 1

    if args.kind == "cibs" and args.profile == "integrate":
        if args.parent_type:
            parent_type = args.parent_type.lower()
        elif conn is not None:
            parent_type = h.detect_project_type(conn, args.parent_schema)
            if parent_type:
                out.info(f"parent_type auto-detected: {parent_type}")
        if not parent_type:
            out.error(
                "kind=cibs profile=integrate: could not detect parent_type. "
                "Pass --parent-type ws|ud."
            )
            if conn is not None:
                conn.close()
            return 1
        if not h.cibs_parent_supported(args.dbmodel_path, parent_type):
            out.error(
                f"kind=cibs: parent_type='{parent_type}' is not supported. "
                f"Missing schemas/addon/cibs/integration/{parent_type}/integration.sql."
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

    creation_profile = ""
    if args.kind in ("ws", "ud"):
        _profile_map = {
            "empty": "empty",
            "sample_inv": "inventory",
            "sample_full": "sample",
        }
        creation_profile = _profile_map.get(args.profile, "")

    register_is_new = "false"
    infer_parents = "false"
    register_parent = ""
    if args.kind == "utils":
        if args.profile == "empty":
            register_is_new = "true"
        elif args.profile == "update":
            infer_parents = "true"
        if args.profile == "integrate_ws":
            register_parent = args.ws_schema or ""
            parent_type = "ws"
        elif args.profile == "integrate_ud":
            register_parent = args.ud_schema or ""
            parent_type = "ud"
    elif args.kind == "cibs":
        if args.profile == "empty":
            register_is_new = "true"
        elif args.profile in ("integrate", "update"):
            infer_parents = "true"
        if args.profile == "integrate":
            register_parent = args.parent_schema or ""
    elif args.kind == "audit":
        if args.profile in ("empty", "structure", "full", "bootstrap"):
            register_is_new = "true"
        elif args.profile in ("activate", "integrate", "update"):
            infer_parents = "true"
        if args.profile in ("activate", "integrate"):
            register_parent = args.parent_schema or ""
    elif args.kind == "am":
        if args.profile in ("empty", "sample"):
            register_is_new = "true"
        elif args.profile in ("integrate", "integrate_sample", "update"):
            infer_parents = "true"
        if args.profile in ("integrate", "integrate_sample"):
            register_parent = args.parent_schema or ""
    elif args.kind == "cm":
        if args.profile in ("bootstrap", "empty"):
            register_is_new = "true"
        elif args.profile in ("integrate", "update"):
            infer_parents = "true"

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
        parent_schema=args.parent_schema or register_parent or args.ws_schema or args.ud_schema or "",
        parent_type=parent_type,
        am_target=am_target,
        main_project_version=main_version,
        creation_profile=creation_profile,
        register_is_new=register_is_new,
        infer_parents_from_config=infer_parents,
        register_parent_schema=register_parent,
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
        return ""
    return info.user or ""


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
