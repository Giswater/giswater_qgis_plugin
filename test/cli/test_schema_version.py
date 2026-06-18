"""Tests for schema version detection."""

from __future__ import annotations

from pathlib import Path

import pytest

from giswater_admin import __version__ as cli_version
from giswater_admin.install import config
from giswater_admin.install import dbmodel_paths
from giswater_admin.install import schema_version


@pytest.fixture
def repo_dbmodel() -> str:
    root = dbmodel_paths.REPO_ROOT / "dbmodel"
    if not (root / "manifests" / "ws.yaml").is_file():
        pytest.skip("repo dbmodel not present")
    return str(root)


def test_resolve_schema_version_from_metadata(repo_dbmodel: str) -> None:
    version = schema_version.resolve_schema_version(repo_dbmodel, None)
    assert version == config.read_metadata_version(dbmodel_paths.REPO_ROOT)


def test_cli_version_independent_of_schema_version(repo_dbmodel: str) -> None:
    schema = schema_version.resolve_schema_version(repo_dbmodel, None)
    assert cli_version != schema
    assert cli_version.count(".") == 2


def test_resolve_schema_version_requires_explicit_for_unknown_tree(tmp_path: Path) -> None:
    dbmodel = tmp_path / "dbmodel"
    (dbmodel / "manifests").mkdir(parents=True)
    (dbmodel / "manifests" / "ws.yaml").write_text("kind: ws\n", encoding="utf-8")
    with pytest.raises(RuntimeError, match="Could not determine Giswater schema version"):
        schema_version.resolve_schema_version(str(dbmodel), None)


def test_resolve_schema_version_from_cache_path(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    monkeypatch.setattr(config, "cache_dir", lambda: tmp_path / "releases")
    cache_root = config.cache_dir()
    dbmodel = cache_root / "4.9.0" / "dbmodel"
    (dbmodel / "manifests").mkdir(parents=True)
    (dbmodel / "manifests" / "ws.yaml").write_text("kind: ws\n", encoding="utf-8")
    assert schema_version.resolve_schema_version(str(dbmodel), None) == "4.9.0"


def test_resolve_schema_version_explicit(repo_dbmodel: str) -> None:
    assert schema_version.resolve_schema_version(repo_dbmodel, "9.9.9") == "9.9.9"


def test_plugin_version_alias(repo_dbmodel: str) -> None:
    assert schema_version.resolve_plugin_version is schema_version.resolve_schema_version


def test_config_roundtrip(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setattr(config, "config_dir", lambda: tmp_path)
    monkeypatch.setattr(config, "config_file", lambda: tmp_path / "config.yaml")
    config.set_config_value("dbmodel.source", "dev")
    assert config.get_config_value("dbmodel.source") == "dev"


def test_read_metadata_version() -> None:
    version = config.read_metadata_version(dbmodel_paths.REPO_ROOT)
    assert version is not None
    assert version.count(".") == 2
