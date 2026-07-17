"""Command requirements and runtime context for ``gw`` subcommands."""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from typing import Callable

from ..install.dbmodel_paths import resolve_dbmodel_path
from ..install.schema_version import resolve_schema_version


@dataclass(frozen=True)
class CommandSpec:
    handler: Callable[[argparse.Namespace, object], int]
    needs_dbmodel: bool = False
    needs_schema_version: bool = False


@dataclass(frozen=True)
class CommandContext:
    dbmodel_path: str | None = None
    schema_version: str | None = None


def prepare_context(args: argparse.Namespace) -> CommandContext:
    """Resolve dbmodel path and schema version according to command requirements."""
    spec = getattr(args, "_command_spec", None)
    needs_dbmodel = bool(spec and spec.needs_dbmodel)
    needs_schema_version = bool(spec and spec.needs_schema_version)

    dbmodel_path: str | None = None
    schema_version: str | None = None

    if needs_dbmodel:
        dbmodel_path = resolve_dbmodel_path(getattr(args, "dbmodel_path", None))

    if needs_schema_version and dbmodel_path is not None:
        explicit = (
            getattr(args, "plugin_version", None)
            or getattr(args, "version", None)
            or getattr(args, "to_version", None)
        )
        schema_version = resolve_schema_version(dbmodel_path, explicit)
        args.plugin_version = schema_version

    if needs_dbmodel and dbmodel_path is not None:
        args.dbmodel_path = dbmodel_path

    return CommandContext(
        dbmodel_path=dbmodel_path,
        schema_version=schema_version,
    )


def set_command_spec(
    parser: argparse.ArgumentParser,
    spec: CommandSpec,
) -> None:
    parser.set_defaults(
        func=spec.handler,
        _command_spec=spec,
        _needs_dbmodel=spec.needs_dbmodel,
        _needs_schema_version=spec.needs_schema_version,
    )
