"""
giswater_admin
==============

Headless engine + CLI for the Giswater dbmodel schema lifecycle.

The package is Qt- and QGIS-free by construction. It is imported by:

- the standalone CLI entrypoint (``python -m giswater_admin``)
- the QGIS plugin's Admin dialogs through a thin Qt adapter
- pytest suites that hit a real PostgreSQL instance through psycopg2

Public surface lives in :mod:`giswater_admin.engine` and the CLI commands
under :mod:`giswater_admin.commands`.
"""

from __future__ import annotations

from .engine import (
    BuildParams,
    BuildResult,
    CancelToken,
    ConnectionLike,
    Manifest,
    PhaseResult,
    SchemaBuilder,
    drop_schema,
    load_manifest,
)
from .output import Out, configure_stderr_logging

__all__ = [
    "BuildParams",
    "BuildResult",
    "CancelToken",
    "ConnectionLike",
    "Manifest",
    "Out",
    "PhaseResult",
    "SchemaBuilder",
    "configure_stderr_logging",
    "drop_schema",
    "load_manifest",
]

__version__ = "0.1.0"
