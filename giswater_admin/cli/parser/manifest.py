"""Register manifest subcommands."""

from __future__ import annotations

import argparse

from ...commands import manifest as cmd_manifest
from ..context import CommandSpec, set_command_spec


def register(sub: argparse._SubParsersAction, parent: argparse.ArgumentParser) -> None:  # noqa: SLF001
    sp = sub.add_parser("manifest", help="Manifest utilities.", parents=[parent])
    msub = sp.add_subparsers(dest="manifest_cmd", required=True)

    spv = msub.add_parser("validate", help="Validate a manifest YAML.",
                          parents=[parent])
    spv.add_argument("path", help="Path to <kind>.yaml.")
    set_command_spec(spv, CommandSpec(cmd_manifest.validate, needs_dbmodel=True))

    spl = msub.add_parser("list", help="List manifests under --dbmodel-path/manifests.",
                          parents=[parent])
    set_command_spec(spl, CommandSpec(cmd_manifest.list_kinds, needs_dbmodel=True))
