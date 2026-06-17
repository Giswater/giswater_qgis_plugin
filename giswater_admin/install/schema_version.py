"""Resolve Giswater schema release versions from the active dbmodel."""

from __future__ import annotations

import os
from pathlib import Path

from ..__version__ import __version__ as cli_version
from . import releases
from .config import (
    cache_dir,
    list_cached_versions,
    load_config,
    read_metadata_version,
    release_dbmodel_dir,
)
from .dbmodel_paths import DEV_DBMODEL, ENV_DBMODEL


def _version_from_cache_path(dbmodel_path: str) -> str | None:
    path = Path(dbmodel_path).resolve()
    if path.name != "dbmodel":
        return None
    version_dir = path.parent
    root = cache_dir().resolve()
    try:
        version_dir.relative_to(root)
    except ValueError:
        return None
    version = version_dir.name
    if releases.parse_version(version):
        return version
    return None


def _plugin_root_for_dbmodel(dbmodel_path: str) -> Path | None:
    path = Path(dbmodel_path).resolve()
    if path.name == "dbmodel":
        return path.parent
    return None


def _dbmodel_matches_version(dbmodel_path: str, version: str) -> bool:
    try:
        return Path(dbmodel_path).resolve() == release_dbmodel_dir(version).resolve()
    except Exception:  # noqa: BLE001
        return False


def _is_valid_dbmodel(path: str | os.PathLike[str]) -> bool:
    return (Path(path) / "manifests" / "ws.yaml").is_file()


def resolve_schema_version(
    dbmodel_path: str,
    explicit: str | None,
) -> str:
    """
    Return the Giswater **schema release** version (``--plugin-version``).

    Independent of the CLI package version. Controls which ``dbmodel/updates/``
    patches are applied when creating or upgrading schemas.
    """
    if explicit:
        return explicit

    cfg = load_config()
    dbmodel = cfg.get("dbmodel") or {}
    source = dbmodel.get("source") or "release"

    if source == "dev":
        dev_root = dbmodel.get("dev_root")
        if dev_root:
            meta = read_metadata_version(dev_root)
            if meta:
                return meta

    version = dbmodel.get("version")
    if version:
        return str(version)

    cached_version = _version_from_cache_path(dbmodel_path)
    if cached_version:
        return cached_version

    cached = list_cached_versions()
    for candidate in reversed(cached):
        if _dbmodel_matches_version(dbmodel_path, candidate):
            return candidate

    plugin_root = _plugin_root_for_dbmodel(dbmodel_path)
    if plugin_root is not None:
        meta = read_metadata_version(plugin_root)
        if meta:
            return meta

    raise RuntimeError(_schema_version_message())


# Deprecated alias — engine and CLI flag still use ``plugin_version`` internally.
resolve_plugin_version = resolve_schema_version


def resolution_label(explicit: str | None, resolved_path: str) -> str:
    if explicit:
        return "flag"
    if os.environ.get(ENV_DBMODEL):
        return "env"
    cfg = load_config()
    dbmodel = cfg.get("dbmodel") or {}
    source = dbmodel.get("source") or "release"
    if source == "dev":
        dev_root = dbmodel.get("dev_root")
        if dev_root and _is_valid_dbmodel(Path(dev_root) / "dbmodel"):
            return "dev"
    version = dbmodel.get("version")
    if version and _dbmodel_matches_version(resolved_path, str(version)):
        return "release"
    if Path(resolved_path).resolve() == DEV_DBMODEL.resolve():
        return "repo"
    for candidate in list_cached_versions():
        if _dbmodel_matches_version(resolved_path, candidate):
            return "cache"
    if _version_from_cache_path(resolved_path):
        return "cache"
    return str(source)


def active_dbmodel_info(
    dbmodel_path: str | None = None,
    *,
    explicit: str | None = None,
) -> dict[str, str | None]:
    """Describe the active dbmodel source for ``gw version``."""
    cfg = load_config()
    dbmodel = cfg.get("dbmodel") or {}
    info: dict[str, str | None] = {
        "cli_version": cli_version,
        "source": None,
        "configured_version": dbmodel.get("version"),
        "dev_root": dbmodel.get("dev_root"),
        "path": dbmodel_path,
        "dbmodel_version": None,
    }
    if dbmodel_path:
        info["source"] = resolution_label(explicit, dbmodel_path)
        try:
            info["dbmodel_version"] = resolve_schema_version(dbmodel_path, None)
        except RuntimeError:
            pass
    return info


def _schema_version_message() -> str:
    return (
        "Could not determine Giswater schema version from the active dbmodel.\n"
        "Pass --plugin-version X.Y.Z (the Giswater release whose updates/ tree to apply),\n"
        "or use gw dbmodel use X.Y.Z / gw dbmodel use dev --root /path/to/plugin."
    )


__all__ = [
    "REPO_ROOT",
    "active_dbmodel_info",
    "resolve_plugin_version",
    "resolve_schema_version",
    "resolution_label",
]
