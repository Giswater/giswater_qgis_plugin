"""Create an empty schema from scratch and print lastprocess/child-view timings."""

from __future__ import annotations

import argparse

from ..engine import drop_schema
from ..output import Out
from . import _helpers as h
from . import create as cmd_create


def run(args: argparse.Namespace, out: Out) -> int:
    """``profile-create``: always a fresh ``create --profile empty`` with profiling."""
    if not args.schema:
        args.schema = h.make_profile_schema_name(args.kind)
        out.info(f"schema (auto): {args.schema}")

    args.profile_lastprocess = True
    args.profile_summary = True

    if args.drop_if_exists and not args.check:
        target = h.safe_target_repr(args)
        if target:
            out.info(f"target: {target}")
        out.info(f"drop-if-exists: {args.schema}")
        conn = h.open_conn(args, out)
        try:
            safe = args.schema.replace('"', "").replace(";", "")
            fx = drop_schema(conn, safe, cascade=True, commit=True)
            if not fx.ok:
                conn.rollback()
                out.error(fx.error or "drop failed")
                return 1
            conn.commit()
        finally:
            conn.close()

    out.info(
        "profile-create: fresh schema + lastprocess profiling "
        "(use this instead of profile-child-views on existing schemas)"
    )
    return cmd_create.run(args, out)
