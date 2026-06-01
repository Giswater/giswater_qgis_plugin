"""
ConnectionLike adapter over ``tools_db`` for the QGIS plugin runtime.

Lets :class:`giswater_admin.engine.SchemaBuilder` execute against the
plugin's single ``QSqlDatabase`` session without dragging psycopg2 into
QGIS. Transactions stay where they always were (the engine never
commits; the plugin commits via ``tools_db.dao.commit()`` after the
task succeeds).
"""

from __future__ import annotations

from ...libs import lib_vars, tools_db


class QtDbAdapter:
    """Implements :class:`giswater_admin.engine.ConnectionLike`."""

    def __init__(self, *, dev_commit: bool = False) -> None:
        # When dev_commit is True the engine commits each file (legacy
        # `force_commit` mode used to survive a single failing file).
        self._dev_commit = bool(dev_commit)
        self._error = ""

    # --------------------------------------------------------- ConnectionLike

    def execute(self, sql: str, *, filepath: str | None = None) -> bool:
        ok = tools_db.execute_sql(
            sql,
            log_sql=False,
            log_error=False,
            commit=self._dev_commit,
            filepath=filepath,
            is_thread=True,
            show_exception=False,
        )
        if not ok:
            self._error = (
                lib_vars.session_vars.get("last_error") or "tools_db.execute_sql returned False"
            )
        else:
            self._error = ""
        return bool(ok)

    def last_error(self) -> str:
        return self._error

    def commit(self) -> None:
        tools_db.dao.commit()

    def rollback(self) -> None:
        tools_db.dao.rollback()

    def close(self) -> None:
        # Plugin owns the session; engine must not close it.
        return
