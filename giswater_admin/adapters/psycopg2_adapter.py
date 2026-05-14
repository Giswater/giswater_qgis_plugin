"""
psycopg2-backed :class:`ConnectionLike` adapter.

The CLI and the engine pytest smoke suite both use this. The plugin
runtime uses a separate :class:`QtDbAdapter` so we never depend on
psycopg2 inside QGIS.
"""

from __future__ import annotations

from typing import Any

try:
    import psycopg2  # type: ignore[import-untyped]
except ImportError as e:  # pragma: no cover
    raise ImportError(
        "psycopg2 is required by giswater_admin's CLI/tests. "
        "Install with `python3 -m pip install psycopg2-binary`."
    ) from e

from ..conn import ConnInfo


class Psycopg2Adapter:
    """Thin wrapper exposing ``ConnectionLike`` over a psycopg2 connection."""

    def __init__(self, conn: Any) -> None:
        self._conn = conn
        self._error = ""

    # ---------------------------------------------------------- construction

    @classmethod
    def open(cls, info: ConnInfo, *, autocommit: bool = False) -> "Psycopg2Adapter":
        if info.service:
            conn = psycopg2.connect(service=info.service)
        else:
            kwargs = {
                k: v
                for k, v in {
                    "host": info.host,
                    "port": info.port or None,
                    "user": info.user or None,
                    "password": info.password or None,
                    "dbname": info.dbname or None,
                }.items()
                if v
            }
            conn = psycopg2.connect(**kwargs)
        conn.autocommit = autocommit
        return cls(conn)

    # --------------------------------------------------------- ConnectionLike

    def execute(self, sql: str, *, filepath: str | None = None) -> bool:
        try:
            with self._conn.cursor() as cur:
                cur.execute(sql)
            self._error = ""
            return True
        except psycopg2.Error as e:
            self._error = self._format_error(e, filepath)
            # psycopg2 puts the connection into an unusable state on
            # error inside a transaction; rolling back here keeps the
            # session alive for the engine's final commit/rollback.
            try:
                self._conn.rollback()
            except psycopg2.Error:
                pass
            return False

    def last_error(self) -> str:
        return self._error

    def commit(self) -> None:
        self._conn.commit()

    def rollback(self) -> None:
        self._conn.rollback()

    def close(self) -> None:
        try:
            self._conn.close()
        except psycopg2.Error:
            pass

    # ---------------------------------------------------------------- helpers

    @property
    def raw(self) -> Any:
        """Escape hatch for commands that need direct psycopg2 access (status, etc.)."""
        return self._conn

    @staticmethod
    def _format_error(err: psycopg2.Error, filepath: str | None) -> str:
        diag = getattr(err, "diag", None)
        msg = (diag.message_primary if diag else None) or str(err).strip()
        suffix = f" [{filepath}]" if filepath else ""
        return f"{msg}{suffix}"
