"""Adapters for ``gw schema main|addon`` subcommands."""

from __future__ import annotations

import argparse
import copy

from ..cli.version_args import normalize_version_args
from ..engine.schema_catalog import (
    discover_database_network,
    graph_has_linked_dependents,
    make_conn_fetcher,
)
from ..engine.version_guard import assert_no_downgrade
from ..output import Out
from . import create as cmd_create
from . import drop as cmd_drop
from . import update as cmd_update

_MAIN_TYPES = frozenset({"ws", "ud"})
_ADDON_TYPES = frozenset({"utils", "cibs", "cm", "am", "audit"})
_MAIN_PROFILE_MAP = {
    "empty": "empty",
    "sample": "sample_full",
    "inventory": "sample_inv",
}

# Fields that legacy ``create`` expects but new ``schema`` parsers omit.
_CREATE_LEGACY_DEFAULTS = {
    "srid": "25831",
    "locale": "en_US",
    "ws_schema": None,
    "ud_schema": None,
    "parent_schema": None,
    "parent_type": None,
    "am_target": None,
    "main_version": None,
    "db_user": None,
    "copy_source_schema": None,
    "with_checkproject": False,
}


def _legacy_args(args: argparse.Namespace, **overrides) -> argparse.Namespace:
    legacy = copy.copy(args)
    for key, default in _CREATE_LEGACY_DEFAULTS.items():
        if not hasattr(legacy, key):
            setattr(legacy, key, default)
    for key, value in overrides.items():
        setattr(legacy, key, value)
    normalize_version_args(legacy)
    return legacy


def _default_name(schema_type: str) -> str:
    return schema_type


def _resolve_name(args: argparse.Namespace, schema_type: str) -> str:
    return str(getattr(args, "name", None) or _default_name(schema_type))


def _resolve_target_version(args: argparse.Namespace) -> str | None:
    return (
        getattr(args, "version", None)
        or getattr(args, "to_version", None)
        or getattr(args, "plugin_version", None)
    )


def run_main_create(args: argparse.Namespace, out: Out) -> int:
    schema_type = args.type.lower()
    if schema_type not in _MAIN_TYPES:
        out.error(f"schema main create: --type must be ws|ud, got '{args.type}'.")
        return 1
    profile = _MAIN_PROFILE_MAP.get(args.profile, args.profile)
    name = _resolve_name(args, schema_type)
    legacy = _legacy_args(
        args,
        kind=schema_type,
        schema=name,
        profile=profile,
        locale=getattr(args, "lang", None) or getattr(args, "locale", "en_US"),
    )
    return cmd_create.run(legacy, out)


def run_addon_create(args: argparse.Namespace, out: Out) -> int:
    schema_type = args.type.lower()
    if schema_type not in _ADDON_TYPES:
        out.error(
            f"schema addon create: --type must be one of "
            f"{sorted(_ADDON_TYPES)}, got '{args.type}'."
        )
        return 1
    name = _resolve_name(args, schema_type)
    if schema_type == "audit":
        profile = "empty"
    elif schema_type in ("cm", "am"):
        profile = "bootstrap"
    else:
        profile = "empty"
    legacy = _legacy_args(args, kind=schema_type, schema=name, profile=profile)
    return cmd_create.run(legacy, out)


def run_addon_integrate(args: argparse.Namespace, out: Out) -> int:
    from . import _helpers as h  # noqa: WPS433

    schema_type = args.type.lower()
    if schema_type not in _ADDON_TYPES:
        out.error(f"schema addon integrate: invalid --type '{args.type}'.")
        return 1
    parent = args.parent
    name = _resolve_name(args, schema_type)
    profile = "integrate"
    parent_schema = parent
    ws_schema = None
    ud_schema = None
    parent_type = ""

    if schema_type == "utils":
        parent_schema = None
        if h.needs_connection(args) and not args.check:
            conn = h.open_conn(args, out)
            try:
                parent_type = h.detect_project_type(conn, parent) or ""
            finally:
                conn.close()
        if parent_type == "ud":
            profile = "integrate_ud"
            ud_schema = parent
        else:
            profile = "integrate_ws"
            ws_schema = parent
    elif schema_type == "audit":
        profile = "integrate"
    elif schema_type in ("cibs", "cm", "am"):
        profile = "integrate"

    legacy = _legacy_args(
        args,
        kind=schema_type,
        schema=name if schema_type != "utils" else "utils",
        profile=profile,
        parent_schema=parent_schema or parent,
        ws_schema=ws_schema,
        ud_schema=ud_schema,
    )
    return cmd_create.run(legacy, out)


def run_main_update(args: argparse.Namespace, out: Out) -> int:
    name = args.name
    target = _resolve_target_version(args)
    normalize_version_args(args)

    conn = None
    from . import _helpers as h  # noqa: WPS433

    if h.needs_connection(args) and not args.check:
        conn = h.open_conn(args, out)
        fetcher = make_conn_fetcher(conn)
        db = discover_database_network(fetcher, schema_filter=name)
        graph = db.cluster
        if graph_has_linked_dependents(graph, name):
            peers = sorted(n.schema for n in graph.nodes if n.schema != name)
            hint = graph.suggested_update_command(target or "")
            out.error(
                f"Schema '{name}' is part of an interconnected network "
                f"({', '.join(peers)}). Use {hint} instead."
            )
            conn.close()
            return 1
        current = h.detect_project_version(conn, name) or "0.0.0"
        err = assert_no_downgrade(current, target or "", label=f"schema '{name}'")
        if err:
            out.error(err)
            conn.close()
            return 1
        conn.close()

    legacy = _legacy_args(
        args,
        schema=name,
        kind=None,
        to_version=target,
        force=False,
    )
    return cmd_update.run(legacy, out)


def run_addon_update(args: argparse.Namespace, out: Out) -> int:
    schema_type = args.type.lower()
    name = _resolve_name(args, schema_type)
    target = _resolve_target_version(args)
    normalize_version_args(args)

    from . import _helpers as h  # noqa: WPS433

    if h.needs_connection(args) and not args.check:
        conn = h.open_conn(args, out)
        fetcher = make_conn_fetcher(conn)
        db = discover_database_network(fetcher, schema_filter=name)
        graph = db.cluster
        if graph_has_linked_dependents(graph, name):
            hint = graph.suggested_update_command(target or "")
            out.error(
                f"Addon '{name}' is integrated in a network. Use {hint} instead."
            )
            conn.close()
            return 1
        current = h.detect_project_version(conn, name) or "0.0.0"
        err = assert_no_downgrade(current, target or "", label=f"addon '{name}'")
        if err:
            out.error(err)
            conn.close()
            return 1
        conn.close()

    legacy = _legacy_args(
        args,
        schema=name,
        kind=schema_type,
        to_version=target,
        force=False,
    )
    return cmd_update.run(legacy, out)


def run_main_drop(args: argparse.Namespace, out: Out) -> int:
    legacy = _legacy_args(args, schema=args.name)
    return cmd_drop.run(legacy, out)


def run_addon_drop(args: argparse.Namespace, out: Out) -> int:
    name = _resolve_name(args, args.type.lower())
    legacy = _legacy_args(args, schema=name)
    return cmd_drop.run(legacy, out)


def run_schema_list(args: argparse.Namespace, out: Out) -> int:
    from . import network as cmd_network  # noqa: WPS433

    return cmd_network._run_schema_list(args, out)
