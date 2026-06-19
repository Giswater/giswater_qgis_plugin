"""Register ``gw db`` subcommands."""

from __future__ import annotations

import argparse

from ...commands import init_db as cmd_init_db
from ..context import CommandSpec, set_command_spec
from .global_ import add_conn_args


def register(sub: argparse._SubParsersAction, parent: argparse.ArgumentParser) -> None:  # noqa: SLF001
    sp = sub.add_parser("db", help="PostgreSQL database preparation.")
    dsub = sp.add_subparsers(dest="db_command", required=True)

    sp_init = dsub.add_parser("init", help="Install PostGIS, pgRouting and required extensions.", parents=[parent])
    sp_init.add_argument("--with-fdw", action="store_true")
    sp_init.add_argument("--with-pgtap", action="store_true")
    sp_init.add_argument("--continue-on-error", action="store_true")
    sp_init.add_argument("--check", action="store_true")
    add_conn_args(sp_init)
    set_command_spec(sp_init, CommandSpec(cmd_init_db.run, needs_dbmodel=False))
