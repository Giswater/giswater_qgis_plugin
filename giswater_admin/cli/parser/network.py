"""Register ``gw network`` subcommands."""

from __future__ import annotations

import argparse

from ...commands import network as cmd_network
from ...commands import update_network as cmd_update_network
from ..context import CommandSpec, set_command_spec
from .global_ import add_conn_args, add_version_arg, global_parent


def register(sub: argparse._SubParsersAction, parent: argparse.ArgumentParser) -> None:  # noqa: SLF001
    sp = sub.add_parser("network", help="Inspect and upgrade the linked Giswater network.")
    nsub = sp.add_subparsers(dest="network_command", required=True)

    sp_show = nsub.add_parser("show", help="Show network topology and versions.", parents=[parent])
    sp_show.add_argument(
        "--schema",
        default=None,
        help="Limit discovery to the cluster containing this schema.",
    )
    sp_show.add_argument("--flat", action="store_true", help="Flat inventory table (epsg, lang).")
    add_conn_args(sp_show)
    set_command_spec(sp_show, CommandSpec(cmd_network.run_show, needs_dbmodel=False))

    sp_up = nsub.add_parser("update", help="Lockstep upgrade of the discovered network.", parents=[parent])
    sp_up.add_argument(
        "--schema",
        default=None,
        help="Limit discovery to the cluster containing this schema.",
    )
    add_version_arg(sp_up)
    sp_up.add_argument("--locale", default="en_US")
    sp_up.add_argument("--check", action="store_true")
    add_conn_args(sp_up)
    set_command_spec(
        sp_up,
        CommandSpec(cmd_update_network.run, needs_dbmodel=True, needs_schema_version=True),
    )
