"""
Argument parsing + dispatch.

Subcommands live under :mod:`giswater_admin.commands`. Each handler
returns an int exit code:

    0  success
    1  error (parse / IO / DB / SQL failure)
"""

from __future__ import annotations

import argparse
import os
import sys

from .commands import audit as cmd_audit
from .commands import create as cmd_create
from .commands import drop as cmd_drop
from .commands import init_db as cmd_init_db
from .commands import manifest as cmd_manifest
from .commands import status as cmd_status
from .commands import update as cmd_update
from .output import Out, configure_stderr_logging


REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
DEFAULT_DBMODEL = os.path.join(REPO_ROOT, "dbmodel")


def _global_parent() -> argparse.ArgumentParser:
    parent = argparse.ArgumentParser(add_help=False)
    parent.add_argument("--json", action="store_true",
                        help="Machine-readable output on stdout.")
    parent.add_argument("--quiet", action="store_true",
                        help="Suppress info-level progress on stderr.")
    parent.add_argument("-v", "--verbose", action="store_true",
                        help="Log each executed SQL path on stderr (exec: lines).")
    parent.add_argument("-d", "--debug", action="store_true",
                        help="Like -v plus DEBUG logs with SQL previews (giswater_admin loggers).")
    parent.add_argument("--timing", action="store_true",
                        help="Print timing summary on stderr; with -v, include ms per file.")
    parent.add_argument("--timing-threshold-ms", type=int, default=0, metavar="N",
                        help="With -v --timing, only log files taking at least N ms.")
    parent.add_argument("--timing-top", type=int, default=20, metavar="K",
                        help="Number of slowest files in timing summary (default: 20).")
    parent.add_argument("--timing-detail", action="store_true",
                        help="With --json --timing, include per-file timings in output.")
    parent.add_argument("--dbmodel-path", default=DEFAULT_DBMODEL,
                        help=f"dbmodel root (default: {DEFAULT_DBMODEL}).")
    return parent


def _add_conn_args(sp: argparse.ArgumentParser) -> None:
    g = sp.add_argument_group("connection")
    g.add_argument("--conn", default=None,
                   help="postgres://user:pass@host:port/dbname")
    g.add_argument("--config", default=None,
                   help="YAML with host/port/user/password/dbname/service.")


def build_parser() -> argparse.ArgumentParser:
    parent = _global_parent()
    p = argparse.ArgumentParser(
        prog="giswater-admin",
        description=(
            "Headless dbmodel schema lifecycle CLI. "
            "Global options (--json, --quiet, --dbmodel-path) go AFTER the subcommand."
        ),
    )
    sub = p.add_subparsers(dest="command", required=True)

    # create -----------------------------------------------------------------
    sp = sub.add_parser("create", help="Create a schema from a manifest.",
                        parents=[parent])
    sp.add_argument("--kind", required=True,
                    choices=["ws", "ud", "utils", "am", "cm"])
    sp.add_argument("--schema", required=True, help="Target schema name.")
    sp.add_argument("--srid", default="25831", help="EPSG code (default 25831).")
    sp.add_argument("--profile", default="empty",
                    help="Manifest profile (empty / sample_full / sample_inv / dev / ci / with_example).")
    sp.add_argument("--locale", default="en_US")
    sp.add_argument("--plugin-version", default="4.9.0",
                    help="Max version applied from updates/ (default 4.9.0).")
    sp.add_argument("--db-user", default=None,
                    help="Author recorded in lastprocess (default: connection user).")
    sp.add_argument("--ws-schema", default=None,
                    help="Linked ws schema (required for kind=utils).")
    sp.add_argument("--ud-schema", default=None,
                    help="Linked ud schema (utils integrate_ud / optional context).")
    sp.add_argument("--parent-schema", default=None,
                    help="Parent ws/ud schema (required for kind=cm).")
    sp.add_argument("--parent-type", default=None, choices=["ws", "ud"],
                    help="Override kind=cm parent_type (default: auto-detect).")
    sp.add_argument("--main-version", default=None,
                    help="Main project version for satellite context. Defaults to --plugin-version.")
    sp.add_argument("--am-target", default=None,
                    help=argparse.SUPPRESS)  # deprecated: AM now uses --plugin-version (semver).
    sp.add_argument("--check", action="store_true",
                    help="Plan only, do not execute SQL.")
    _add_conn_args(sp)
    sp.set_defaults(func=cmd_create.run)

    # update -----------------------------------------------------------------
    sp = sub.add_parser("update", help="Upgrade an existing schema in place.",
                        parents=[parent])
    sp.add_argument("--schema", required=True)
    sp.add_argument("--kind", choices=["ws", "ud", "utils", "am", "cm"], default=None,
                    help="Override; otherwise inferred from sys_version.project_type.")
    sp.add_argument("--to-version", default=None,
                    help="Target version (defaults to --plugin-version).")
    sp.add_argument("--plugin-version", default="4.9.0")
    sp.add_argument("--locale", default="en_US")
    sp.add_argument("--check", action="store_true")
    _add_conn_args(sp)
    sp.set_defaults(func=cmd_update.run)

    # status -----------------------------------------------------------------
    sp = sub.add_parser("status",
                        help="Inspect schemas via sys_version. Omit --schema to list all.",
                        parents=[parent])
    sp.add_argument("--schema", default=None)
    _add_conn_args(sp)
    sp.set_defaults(func=cmd_status.run)

    # drop -------------------------------------------------------------------
    sp = sub.add_parser("drop", help="Drop a schema. Irreversible.",
                        parents=[parent])
    sp.add_argument("--schema", required=True)
    sp.add_argument("--yes", action="store_true",
                    help="Required; confirms the destructive action.")
    sp.add_argument("--cascade", action="store_true",
                    help="DROP SCHEMA ... CASCADE (default RESTRICT).")
    sp.add_argument("--check", action="store_true",
                    help="Print the SQL that would run; do not execute.")
    _add_conn_args(sp)
    sp.set_defaults(func=cmd_drop.run)

    # init-db ----------------------------------------------------------------
    sp = sub.add_parser(
        "init-db",
        help=(
            "CREATE EXTENSION IF NOT EXISTS for PostGIS, tablefunc, pgRouting, unaccent "
            "(same order as dbmodel needs; run once per database)."
        ),
        parents=[parent],
    )
    sp.add_argument(
        "--with-fdw",
        action="store_true",
        help="Also install postgres_fdw (used in some corporate SQL).",
    )
    sp.add_argument(
        "--continue-on-error",
        action="store_true",
        help="Try every extension even if one fails (default: stop on first error).",
    )
    sp.add_argument("--check", action="store_true",
                    help="Print SQL only; do not connect.")
    _add_conn_args(sp)
    sp.set_defaults(func=cmd_init_db.run)

    # audit ------------------------------------------------------------------
    sp = sub.add_parser("audit", help="Audit lifecycle.", parents=[parent])
    asub = sp.add_subparsers(dest="audit_cmd", required=True)

    sps = asub.add_parser("structure", help="Build the audit schema.", parents=[parent])
    sps.add_argument("--with-checkproject", action="store_true",
                     help="Also load audit_checkproject helpers.")
    sps.add_argument("--locale", default="en_US")
    sps.add_argument("--plugin-version", default="4.9.0")
    sps.add_argument("--check", action="store_true")
    _add_conn_args(sps)
    sps.set_defaults(func=cmd_audit.run_structure)

    spa = asub.add_parser("activate", help="Attach audit triggers to a ws/ud schema.",
                          parents=[parent])
    spa.add_argument("--schema", required=True,
                     help="Target ws/ud schema to wire audit triggers into.")
    spa.add_argument("--locale", default="en_US")
    spa.add_argument("--plugin-version", default="4.9.0")
    spa.add_argument("--check", action="store_true")
    _add_conn_args(spa)
    spa.set_defaults(func=cmd_audit.run_activate)

    spd = asub.add_parser("drop", help="Drop the audit schema.", parents=[parent])
    spd.add_argument("--yes", action="store_true")
    spd.add_argument("--check", action="store_true")
    _add_conn_args(spd)
    spd.set_defaults(func=cmd_audit.run_drop)

    # manifest ---------------------------------------------------------------
    sp = sub.add_parser("manifest", help="Manifest utilities.", parents=[parent])
    msub = sp.add_subparsers(dest="manifest_cmd", required=True)

    spv = msub.add_parser("validate", help="Validate a manifest YAML.",
                          parents=[parent])
    spv.add_argument("path", help="Path to <kind>.yaml.")
    spv.set_defaults(func=cmd_manifest.validate)

    spl = msub.add_parser("list", help="List manifests under --dbmodel-path/manifests.",
                          parents=[parent])
    spl.set_defaults(func=cmd_manifest.list_kinds)

    return p


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    configure_stderr_logging(debug=getattr(args, "debug", False))
    out = Out(
        json_mode=getattr(args, "json", False),
        quiet=getattr(args, "quiet", False),
        verbose=getattr(args, "verbose", False),
        debug=getattr(args, "debug", False),
        timing=getattr(args, "timing", False),
        sql_root=getattr(args, "dbmodel_path", "") or "",
    )
    try:
        return args.func(args, out)
    except Exception as e:  # noqa: BLE001 - CLI boundary
        out.error(str(e))
        if getattr(args, "json", False):
            out.result({"ok": False, "error": str(e)})
        return 1


if __name__ == "__main__":
    sys.exit(main())
