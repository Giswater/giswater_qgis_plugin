"""
Shared fixtures + path bootstrap for the engine test suite.

These tests must NOT import qgis/Qt. They depend only on the
``giswater_admin`` package, the standard library, and (for smoke tests
under :mod:`test.engine.smoke`) psycopg2 + a running PostgreSQL.
"""

from __future__ import annotations

import os
import sys

import pytest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
if REPO_ROOT not in sys.path:
    sys.path.insert(0, REPO_ROOT)


@pytest.fixture(scope="session")
def repo_root() -> str:
    return REPO_ROOT


@pytest.fixture(scope="session")
def dbmodel_path(repo_root: str) -> str:
    return os.path.join(repo_root, "dbmodel")


@pytest.fixture(scope="session")
def manifests_path(repo_root: str) -> str:
    return os.path.join(repo_root, "dbmodel", "manifests")
