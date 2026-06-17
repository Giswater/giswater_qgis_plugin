"""Tests for dbmodel path resolution."""

from __future__ import annotations

import os
from pathlib import Path

import pytest

from giswater_admin.install import config
from giswater_admin.install import dbmodel_paths


@pytest.fixture
def repo_dbmodel() -> str:
    root = dbmodel_paths.REPO_ROOT / "dbmodel"
    if not (root / "manifests" / "ws.yaml").is_file():
        pytest.skip("repo dbmodel not present")
    return str(root)


def test_resolve_explicit_path(repo_dbmodel: str) -> None:
    assert dbmodel_paths.resolve_dbmodel_path(repo_dbmodel) == os.path.abspath(repo_dbmodel)


def test_resolve_env_path(repo_dbmodel: str, monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setenv(dbmodel_paths.ENV_DBMODEL, repo_dbmodel)
    assert dbmodel_paths.resolve_dbmodel_path(None) == os.path.abspath(repo_dbmodel)


def test_resolve_repo_sibling_without_config(repo_dbmodel: str, monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.delenv(dbmodel_paths.ENV_DBMODEL, raising=False)
    cfg_path = config.config_file()
    if cfg_path.is_file():
        cfg_path.unlink()
    resolved = dbmodel_paths.resolve_dbmodel_path(None)
    assert resolved == os.path.abspath(repo_dbmodel)


def test_resolve_missing_bootstrap(monkeypatch: pytest.MonkeyPatch, tmp_path: Path) -> None:
    monkeypatch.delenv(dbmodel_paths.ENV_DBMODEL, raising=False)
    cfg_path = config.config_file()
    if cfg_path.is_file():
        cfg_path.unlink()
    monkeypatch.setattr(dbmodel_paths, "DEV_DBMODEL", tmp_path / "missing")
    with pytest.raises(RuntimeError, match="No dbmodel found"):
        dbmodel_paths.resolve_dbmodel_path(None)
