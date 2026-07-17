"""``version`` subcommand."""

from __future__ import annotations

import argparse

from ..install.dbmodel_paths import resolve_dbmodel_path
from ..install.schema_version import active_dbmodel_info
from ..output import Out


def run(args: argparse.Namespace, out: Out) -> int:
    dbmodel_path: str | None = None
    try:
        dbmodel_path = resolve_dbmodel_path(getattr(args, "dbmodel_path", None))
    except RuntimeError:
        pass

    info = active_dbmodel_info(
        dbmodel_path,
        explicit=getattr(args, "dbmodel_path", None),
    )
    payload = {"ok": True, **info}
    if args.json:
        out.result(payload)
        return 0

    out.info(f"cli {info['cli_version']}")
    if dbmodel_path:
        out.info(f"dbmodel-path: {dbmodel_path}")
        out.info(f"source: {info['source']}")
        if info.get("dbmodel_version"):
            out.info(f"dbmodel-version: {info['dbmodel_version']}")
        else:
            out.info("dbmodel-version: unknown (pass --plugin-version on create/update)")
    else:
        out.info("dbmodel: not configured")
    return 0
