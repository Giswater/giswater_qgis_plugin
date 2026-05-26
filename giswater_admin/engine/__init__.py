"""
Engine public API. Importing this module must NOT pull in qgis/Qt.
"""

from __future__ import annotations

from .builder import BuildParams, BuildResult, PhaseResult, SchemaBuilder, drop_schema
from .cancel import CancelToken
from .changelog import (
    VersionChangelog,
    changelog_versions_as_dicts,
    collect_pending_versions,
    collect_upgrade_changelogs,
    format_upgrade_changelog,
    network_update_roots,
    parse_changelog_file,
    read_version_sections,
)
from .manifest import Manifest, Phase, Step, load_manifest
from .sql_runner import ConnectionLike, FileExec

__all__ = [
    "BuildParams",
    "BuildResult",
    "CancelToken",
    "ConnectionLike",
    "FileExec",
    "Manifest",
    "Phase",
    "PhaseResult",
    "SchemaBuilder",
    "Step",
    "VersionChangelog",
    "changelog_versions_as_dicts",
    "collect_pending_versions",
    "collect_upgrade_changelogs",
    "drop_schema",
    "format_upgrade_changelog",
    "load_manifest",
    "network_update_roots",
    "parse_changelog_file",
    "read_version_sections",
]
