"""
Connection resolution. Three layered sources, evaluated in order:

  1. ``--conn 'postgres://user:pass@host:port/dbname'``
  2. ``--config /path/to/yaml`` with host/port/user/password/dbname
  3. Environment: PGHOST, PGPORT, PGUSER, PGPASSWORD, PGDATABASE,
     PGSERVICE (psycopg2 will read PGSERVICE for free when nothing else
     is set)

The returned :class:`ConnInfo` is intentionally a plain dataclass — the
psycopg2 adapter consumes its fields directly. We never carry passwords
through ``safe_repr()``.
"""

from __future__ import annotations

import os
from dataclasses import dataclass
from urllib.parse import unquote, urlparse


@dataclass
class ConnInfo:
    host: str = ""
    port: str = ""
    user: str = ""
    password: str = ""
    dbname: str = ""
    service: str = ""

    def safe_repr(self) -> str:
        if self.service:
            return f"service={self.service}"
        host = self.host or "localhost"
        port = self.port or "5432"
        user = self.user or "?"
        db = self.dbname or "?"
        return f"{user}@{host}:{port}/{db}"


def resolve(conn_url: str | None, config_path: str | None) -> ConnInfo:
    """Pick the highest-priority source that yields enough info."""
    if conn_url:
        return _from_url(conn_url)
    if config_path:
        return _from_config(config_path)
    info = _from_env()
    if not info.dbname and not info.service:
        raise RuntimeError(
            "No connection info. Pass --conn, --config, set PGDATABASE/PGSERVICE."
        )
    return info


def _from_url(url: str) -> ConnInfo:
    if "://" not in url:
        raise RuntimeError(f"--conn must be a URL (got: {url!r})")
    p = urlparse(url)
    if p.scheme not in ("postgres", "postgresql"):
        raise RuntimeError(f"--conn scheme must be postgres[ql] (got: {p.scheme!r})")
    return ConnInfo(
        host=p.hostname or "",
        port=str(p.port) if p.port else "",
        user=unquote(p.username) if p.username else "",
        password=unquote(p.password) if p.password else "",
        dbname=(p.path or "").lstrip("/"),
    )


def _from_config(path: str) -> ConnInfo:
    try:
        import yaml  # type: ignore[import-untyped]
    except ImportError as e:  # pragma: no cover
        raise RuntimeError("PyYAML required for --config") from e
    if not os.path.isfile(path):
        raise RuntimeError(f"--config file not found: {path}")
    with open(path, "r", encoding="utf-8") as f:
        body = yaml.safe_load(f) or {}
    if not isinstance(body, dict):
        raise RuntimeError(f"--config root must be a mapping: {path}")
    return ConnInfo(
        host=str(body.get("host", "")),
        port=str(body.get("port", "")),
        user=str(body.get("user", "")),
        password=str(body.get("password", "")),
        dbname=str(body.get("dbname", "")),
        service=str(body.get("service", "")),
    )


def _from_env() -> ConnInfo:
    return ConnInfo(
        host=os.environ.get("PGHOST", ""),
        port=os.environ.get("PGPORT", ""),
        user=os.environ.get("PGUSER", ""),
        password=os.environ.get("PGPASSWORD", ""),
        dbname=os.environ.get("PGDATABASE", ""),
        service=os.environ.get("PGSERVICE", ""),
    )


def has_pg_env() -> bool:
    return bool(
        os.environ.get("PGUSER")
        or os.environ.get("PGDATABASE")
        or os.environ.get("PGSERVICE")
    )


def open_connection(info: ConnInfo, *, autocommit: bool = False):
    """Open a psycopg2 connection through the adapter."""
    from .adapters.psycopg2_adapter import Psycopg2Adapter
    return Psycopg2Adapter.open(info, autocommit=autocommit)
