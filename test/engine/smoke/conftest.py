"""
Real-DB smoke fixtures. Skips the entire module when no PG connection
info is available.

Connection precedence (matches CLI):
  1. ``PGSERVICE`` (preferred — works with the legacy
     ``localhost_giswater`` service entry)
  2. ``PGDATABASE`` (+ optional PGHOST/PGPORT/PGUSER/PGPASSWORD)
"""

from __future__ import annotations

import os
import time
import uuid

import pytest


def _has_pg_env() -> bool:
    return bool(os.environ.get("PGSERVICE") or os.environ.get("PGDATABASE"))


@pytest.fixture(scope="session")
def psycopg2_conn():
    if not _has_pg_env():
        pytest.skip("Set PGSERVICE=localhost_giswater or PGDATABASE/... to enable smoke tests.")
    try:
        import psycopg2  # type: ignore[import-untyped]
    except ImportError:
        pytest.skip("psycopg2 not installed")
    service = os.environ.get("PGSERVICE")
    if service:
        conn = psycopg2.connect(service=service)
    else:
        conn = psycopg2.connect(
            host=os.environ.get("PGHOST"),
            port=os.environ.get("PGPORT"),
            user=os.environ.get("PGUSER"),
            password=os.environ.get("PGPASSWORD"),
            dbname=os.environ.get("PGDATABASE"),
        )
    yield conn
    conn.close()


@pytest.fixture()
def adapter(psycopg2_conn):
    from giswater_admin.adapters.psycopg2_adapter import Psycopg2Adapter
    a = Psycopg2Adapter(psycopg2_conn)
    yield a


@pytest.fixture()
def temp_schema_name() -> str:
    # Short uuid suffix so concurrent test runs never collide.
    return f"gwtest_{int(time.time())}_{uuid.uuid4().hex[:6]}"
