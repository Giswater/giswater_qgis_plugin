"""Deprecated shim — use :mod:`giswater_admin.install.config`."""

from __future__ import annotations

from .install.config import (
    DEFAULT_BASE_URL,
    DEFAULT_MAJOR,
    cache_dir,
    config_dir,
    config_file,
    download_settings,
    get_config_value,
    list_cached_versions,
    load_config,
    read_metadata_version,
    release_dbmodel_dir,
    save_config,
    set_config_value,
)

__all__ = [
    "DEFAULT_BASE_URL",
    "DEFAULT_MAJOR",
    "cache_dir",
    "config_dir",
    "config_file",
    "download_settings",
    "get_config_value",
    "list_cached_versions",
    "load_config",
    "read_metadata_version",
    "release_dbmodel_dir",
    "save_config",
    "set_config_value",
]
