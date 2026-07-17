"""Deprecated shim — use :mod:`giswater_admin.install.dbmodel_paths`."""

from __future__ import annotations

from .install.dbmodel_paths import (
    DEV_DBMODEL,
    ENV_DBMODEL,
    REPO_ROOT,
    resolve_dbmodel_path,
)
from .install.schema_version import (
    active_dbmodel_info,
    resolve_plugin_version,
    resolve_schema_version,
    resolution_label,
)

__all__ = [
    "DEV_DBMODEL",
    "ENV_DBMODEL",
    "REPO_ROOT",
    "active_dbmodel_info",
    "resolve_dbmodel_path",
    "resolve_plugin_version",
    "resolve_schema_version",
    "resolution_label",
]
