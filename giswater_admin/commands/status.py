"""``status`` subcommand."""

from __future__ import annotations

import argparse

from ..output import Out
from . import _helpers as h


def run(args: argparse.Namespace, out: Out) -> int:
    conn = h.open_conn(args)
    try:
        with conn.raw.cursor() as cur:  # type: ignore[attr-defined]
            if args.schema:
                cur.execute(
                    """
                    SELECT table_schema FROM information_schema.tables
                    WHERE table_schema = %s AND table_name = 'sys_version'
                    """,
                    (args.schema,),
                )
                if not cur.fetchone():
                    out.error(f"schema '{args.schema}' has no sys_version table.")
                    return 1
                schemas = [args.schema]
            else:
                cur.execute(
                    """
                    SELECT table_schema FROM information_schema.tables
                    WHERE table_name = 'sys_version'
                    ORDER BY table_schema
                    """
                )
                schemas = [row[0] for row in cur.fetchall()]

            rows = []
            for schema in schemas:
                try:
                    cur.execute(
                        f'SELECT giswater, project_type, epsg, language '
                        f'FROM "{schema}".sys_version ORDER BY id DESC LIMIT 1'
                    )
                    row = cur.fetchone()
                    if row:
                        rows.append(
                            {
                                "schema": schema,
                                "project_version": row[0],
                                "project_type": row[1],
                                "epsg": row[2],
                                "language": row[3],
                            }
                        )
                except Exception as e:  # noqa: BLE001
                    rows.append({"schema": schema, "error": str(e).strip()})
                    conn.rollback()
    finally:
        conn.close()

    out.result({"ok": True, "schemas": rows})
    return 0
