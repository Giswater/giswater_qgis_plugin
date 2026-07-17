"""Shared argument normalization for version flags."""

from __future__ import annotations


def normalize_version_args(args) -> None:
    """Map ``--version`` to plugin/to-version fields used by command handlers."""
    version = getattr(args, "version", None)
    if not version:
        return
    if not getattr(args, "plugin_version", None):
        args.plugin_version = version
    if not getattr(args, "to_version", None):
        args.to_version = version
