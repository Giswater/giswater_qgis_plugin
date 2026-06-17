"""Register meta subcommands: version, config, dbmodel."""

from __future__ import annotations

import argparse

from ...commands import config as cmd_config
from ...commands import dbmodel as cmd_dbmodel
from ...commands import version as cmd_version
from ..context import CommandSpec, set_command_spec
from .global_ import global_parent


def register(sub: argparse._SubParsersAction) -> None:  # noqa: SLF001
    sp = sub.add_parser(
        "version",
        help="Show CLI and active dbmodel version.",
        parents=[global_parent(needs_dbmodel=False)],
    )
    sp.add_argument("--dbmodel-path", default=None, help=argparse.SUPPRESS)
    set_command_spec(sp, CommandSpec(cmd_version.run))

    sp = sub.add_parser("config", help="Read or write persistent CLI config.")
    cfg_sub = sp.add_subparsers(dest="config_cmd", required=True)

    spg = cfg_sub.add_parser("get", help="Show config value or full config.")
    spg.add_argument("key", nargs="?", default=None,
                     help="Dotted key (e.g. dbmodel.source). Omit for full config.")
    spg.add_argument("--json", action="store_true")
    set_command_spec(spg, CommandSpec(cmd_config.run_get))

    sps = cfg_sub.add_parser("set", help="Set a config value.")
    sps.add_argument("key", help="Dotted key (e.g. dbmodel.source).")
    sps.add_argument("value", help="Value (JSON literal, true/false, null, or string).")
    sps.add_argument("--json", action="store_true")
    set_command_spec(sps, CommandSpec(cmd_config.run_set))

    sp = sub.add_parser("dbmodel", help="Manage cached dbmodel releases.")
    dm_sub = sp.add_subparsers(dest="dbmodel_cmd", required=True)

    spi = dm_sub.add_parser("install", help="Download and cache a plugin release dbmodel.")
    spi.add_argument("version", nargs="?", default="latest",
                     help="Semantic version X.Y.Z or 'latest' (default).")
    spi.add_argument("--force", action="store_true",
                     help="Re-download even if already cached.")
    spi.add_argument("--set-active", action="store_true",
                     help="Activate this version after install.")
    spi.add_argument("--json", action="store_true")
    set_command_spec(spi, CommandSpec(cmd_dbmodel.run_install))

    spl = dm_sub.add_parser("list", help="List cached dbmodel versions.")
    spl.add_argument("--offline", action="store_true",
                     help="Do not query remote latest version.")
    spl.add_argument("--json", action="store_true")
    set_command_spec(spl, CommandSpec(cmd_dbmodel.run_list))

    spu = dm_sub.add_parser("use", help="Switch active dbmodel source.")
    spu.add_argument("mode", help="Release version X.Y.Z, 'latest', or 'dev'.")
    spu.add_argument("--root", default=None,
                     help="Plugin repo root (required when mode=dev).")
    spu.add_argument("--json", action="store_true")
    set_command_spec(spu, CommandSpec(cmd_dbmodel.run_use))

    sps = dm_sub.add_parser("status", help="Show dbmodel config.")
    sps.add_argument("--json", action="store_true")
    set_command_spec(sps, CommandSpec(cmd_dbmodel.run_status))
