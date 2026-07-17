"""Deprecated shim — use :mod:`giswater_admin.install.releases`."""

from __future__ import annotations

from .install.releases import (
    download_bytes,
    extract_dbmodel_from_zip,
    fetch_latest_version,
    fetch_text,
    install_latest,
    install_release,
    parse_plugin_xml_download_url,
    parse_plugin_xml_version,
    parse_version,
    pointer_url,
    version_str,
    zip_url,
)

__all__ = [
    "download_bytes",
    "extract_dbmodel_from_zip",
    "fetch_latest_version",
    "fetch_text",
    "install_latest",
    "install_release",
    "parse_plugin_xml_download_url",
    "parse_plugin_xml_version",
    "parse_version",
    "pointer_url",
    "version_str",
    "zip_url",
]
