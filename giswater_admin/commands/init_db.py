"""``init-db`` — install PostgreSQL extensions expected by the dbmodel."""

from __future__ import annotations

import argparse

from ..output import Out
from . import _helpers as h

# Order matters: postgis_raster needs postgis; pgrouting needs PostGIS.
# `public.raster` comes from postgis_raster (PostGIS 3+ splits it from core postgis).
_DEFAULT_EXTENSIONS = (
    "postgis",
    "postgis_topology",
    "postgis_raster",
    "tablefunc",
    "pgrouting",
    "unaccent",
    "pgtap",
)


def run(args: argparse.Namespace, out: Out) -> int:
    exts = list(_DEFAULT_EXTENSIONS)
    if getattr(args, "with_fdw", False):
        exts.append("postgres_fdw")

    statements = [f"CREATE EXTENSION IF NOT EXISTS {ext};" for ext in exts]

    if args.check:
        out.result(
            {
                "ok": True,
                "mode": "check",
                "extensions": exts,
                "sql": statements,
            }
        )
        return 0

    conn = h.open_conn(args)
    ok = True
    last_err = ""
    executed: list[dict[str, str]] = []
    try:
        for ext, sql in zip(exts, statements):
            if conn.execute(sql):
                executed.append({"extension": ext, "ok": True})
            else:
                ok = False
                last_err = conn.last_error()
                executed.append({"extension": ext, "ok": False, "error": last_err})
                if not getattr(args, "continue_on_error", False):
                    break
        if ok:
            conn.commit()
        else:
            conn.rollback()
    finally:
        conn.close()

    out.result(
        {
            "ok": ok,
            "extensions": executed,
            "error": None if ok else last_err,
        }
    )
    return 0 if ok else 1
