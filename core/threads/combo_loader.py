"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import QObject, pyqtSignal
from qgis.core import QgsTask

from ...libs import tools_db, tools_log


class GwComboLoaderTask(QgsTask, QObject):
    """Background task that loads dv_querytext rows for an async combo widget.

    Each `GwAsyncComboBox` owns a monotonically increasing token. When the user
    triggers a reload (e.g. parent combo changed), the widget bumps the token
    and starts a new task. The signal handler in the widget ignores results
    coming from older tokens so stale rows can never overwrite fresh data.

    The task does NOT subclass `GwTask` on purpose: combo loads are short and
    happen in bulk when a dialog opens, so we don't want to disable the
    iface "open project" actions or spam the log for every loader.
    """

    # token, rows (list of psycopg2 DictRow / tuples), error (str, '' on success)
    rows_loaded = pyqtSignal(int, list, str)

    def __init__(self, description: str, query: str, token: int):
        QObject.__init__(self)
        QgsTask.__init__(self, description, QgsTask.Flag.CanCancel)
        self._query = query
        self._token = token
        self._rows = []
        self._error = ''
        self._aux_conn = None

    @property
    def token(self) -> int:
        return self._token

    def run(self) -> bool:
        if self.isCanceled():
            return False

        try:
            aux_result = tools_db.dao.get_aux_conn()
        except Exception as exc:
            self._error = f"get_aux_conn failed: {exc}"
            return False

        # `dao.get_aux_conn` returns a psycopg2 connection on success or a
        # `{"status": False, "last_error": ...}` dict on failure.
        if aux_result is None or isinstance(aux_result, dict):
            err = ''
            if isinstance(aux_result, dict):
                err = str(aux_result.get('last_error') or '')
            self._error = err or 'Could not get auxiliary connection'
            return False

        self._aux_conn = aux_result

        if self.isCanceled():
            return False

        try:
            cursor = tools_db.dao.get_cursor(self._aux_conn)
            cursor.execute(self._query)
            rows = cursor.fetchall()
            cursor.close()
            self._aux_conn.commit()
            # Materialize as list of (id, idval) tuples so the result object is
            # safe to pass across threads and survives connection close.
            self._rows = [(_safe_get(r, 0), _safe_get(r, 1)) for r in rows or []]
        except Exception as exc:
            self._error = str(exc)
            try:
                self._aux_conn.rollback()
            except Exception:
                pass
            return False

        return True

    def finished(self, result: bool) -> None:
        if self._aux_conn is not None:
            try:
                tools_db.dao.delete_aux_con(self._aux_conn)
            except Exception:
                pass
            self._aux_conn = None

        if not result and not self._error:
            self._error = 'cancelled'

        if self._error:
            tools_log.log_warning(
                "GwComboLoaderTask failed: {0}", msg_params=(self._error,)
            )

        try:
            self.rows_loaded.emit(self._token, self._rows, self._error)
        except RuntimeError:
            # Receiver was destroyed (dialog closed before task finished).
            pass

    def cancel(self) -> None:
        # Best-effort: we don't try to cancel the running query through pid here
        # because combo loads are short. Just flip the cancel flag; finished()
        # will release the aux connection.
        super().cancel()


def _safe_get(row, idx):
    """Return row[idx] for tuples and DictRow alike, or None on missing index."""
    try:
        return row[idx]
    except (IndexError, KeyError, TypeError):
        return None
