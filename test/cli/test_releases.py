"""Tests for release download helpers (offline)."""

from __future__ import annotations

import io
import zipfile

from giswater_admin.install import releases


def test_parse_version() -> None:
    assert releases.parse_version("4.9.0") == (4, 9, 0)
    assert releases.parse_version("bad") is None


def test_parse_plugin_xml_version() -> None:
    xml = """<?xml version="1.0"?>
    <plugins>
      <pyqgis_plugin name="giswater" version="4.9.0">
        <download_url>https://example.org/giswater.zip</download_url>
      </pyqgis_plugin>
    </plugins>"""
    assert releases.parse_plugin_xml_version(xml) == "4.9.0"
    assert releases.parse_plugin_xml_download_url(xml) == "https://example.org/giswater.zip"


def test_extract_dbmodel_from_zip(tmp_path) -> None:
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w") as zf:
        zf.writestr("giswater/dbmodel/manifests/ws.yaml", "kind: ws\n")
        zf.writestr("giswater/dbmodel/schemas/main/common/base/init.sql", "SELECT 1;\n")
    dest = tmp_path / "dbmodel"
    releases.extract_dbmodel_from_zip(buf.getvalue(), dest)
    assert (dest / "manifests" / "ws.yaml").is_file()
    assert (dest / "schemas" / "main" / "common" / "base" / "init.sql").is_file()


def test_zip_url() -> None:
    assert (
        releases.zip_url("https://download.giswater.org/plugin", (4, 8, 2))
        == "https://download.giswater.org/plugin/4/8/2/giswater.zip"
    )
