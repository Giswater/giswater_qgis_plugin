"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from typing import List, Optional, Sequence, Tuple

from qgis.PyQt.QtCore import QAbstractListModel, QModelIndex, Qt
from qgis.PyQt.QtWidgets import QComboBox, QCompleter
from qgis.core import QgsApplication

from ..threads.combo_loader import GwComboLoaderTask


# Pair of (id, idval) strings stored per row. Tuples are cheap and immutable.
_ComboRow = Tuple[str, str]


class _ComboListModel(QAbstractListModel):
    """Lightweight list model backed by a Python list of `(id, idval)` tuples.

    Built specifically to avoid the per-item cost of `QStandardItem` when a
    combo has many rows: replacing 15k items via `QComboBox.addItem` takes
    several seconds because each call constructs a `QStandardItem`, allocates
    indices and emits dataChanged/rowsInserted. With this model, refreshing
    the contents is a `beginResetModel`/`endResetModel` pair plus a Python
    list assignment — typically a few milliseconds even for 100k rows.
    """

    def __init__(self, parent=None):
        super().__init__(parent)
        self._rows: List[_ComboRow] = []

    # region Model API used internally
    def set_rows(self, rows: Sequence[_ComboRow]) -> None:
        self.beginResetModel()
        self._rows = list(rows)
        self.endResetModel()

    def get_rows(self) -> List[_ComboRow]:
        return self._rows
    # endregion

    # region QAbstractListModel
    def rowCount(self, parent: QModelIndex = QModelIndex()) -> int:  # noqa: N802 - Qt API
        if parent.isValid():
            return 0
        return len(self._rows)

    def data(self, index: QModelIndex, role: int = Qt.ItemDataRole.DisplayRole):
        if not index.isValid():
            return None
        row = index.row()
        if row < 0 or row >= len(self._rows):
            return None
        item = self._rows[row]
        if role in (
            Qt.ItemDataRole.DisplayRole,
            Qt.ItemDataRole.EditRole,
            Qt.ItemDataRole.ToolTipRole,
        ):
            return item[1]
        if role == Qt.ItemDataRole.UserRole:
            # Keep `[id, idval]` as a list so existing code that does
            # `combo.itemData(i)[0]` (tools_qt.get_combo_value) keeps working.
            return [item[0], item[1]]
        return None

    def flags(self, index: QModelIndex):
        if not index.isValid():
            return Qt.ItemFlag.NoItemFlags
        return Qt.ItemFlag.ItemIsEnabled | Qt.ItemFlag.ItemIsSelectable

    def removeRows(self, row: int, count: int, parent: QModelIndex = QModelIndex()) -> bool:  # noqa: N802 - Qt API
        if parent.isValid() or row < 0 or count <= 0:
            return False
        if row + count > len(self._rows):
            return False
        self.beginRemoveRows(parent, row, row + count - 1)
        del self._rows[row:row + count]
        self.endRemoveRows()
        return True

    def append_row(self, row: _ComboRow) -> None:
        position = len(self._rows)
        self.beginInsertRows(QModelIndex(), position, position)
        self._rows.append(row)
        self.endInsertRows()
    # endregion


class GwAsyncComboBox(QComboBox):
    """Editable combobox that loads its items asynchronously.

    Lifecycle
        1. Widget is constructed and immediately shows a single placeholder row
           so `tools_qt.get_combo_value(...)` returns `''` while loading.
        2. `start_loading(query)` schedules a `GwComboLoaderTask`. The widget
           bumps an internal *token* so older tasks are ignored if multiple
           loads are queued (e.g. parent combo changed).
        3. When the task finishes, `_on_rows_loaded` swaps the model contents
           in O(1) (single Python list assignment + `endResetModel`) and
           re-applies any pending selection.

    Compatibility
        - Items are exposed through a custom `QAbstractListModel`. Keeping
          `[id, idval]` under `Qt.UserRole` preserves the public API:
          `combo.itemData(i)[0]`, `tools_qt.get_combo_value(...)` and
          `tools_qt.set_combo_value(...)` all keep working.
        - The widget is editable with a *contains* completer so users can type
          any substring to narrow the popup. Clicking the arrow shows the full
          list (no implicit filter on the model itself).
        - The wheel-focus behavior matches `CustomQComboBox`.

    Markers
        - ``_gw_is_async_combo``: True; used by external helpers to detect
          an async combo without importing this module.
        - ``rows_loaded`` Qt property: False while loading, True afterwards.
    """

    def __init__(self, parent=None):
        super().__init__(parent)
        self._gw_is_async_combo = True
        self._token = 0
        self._task: Optional[GwComboLoaderTask] = None
        self._pending_selected_id: Optional[str] = None
        self._pending_select_index: int = 0
        self._is_null_value: bool = False
        self._loading: bool = False

        self.setProperty('rows_loaded', False)
        self.setFocusPolicy(Qt.FocusPolicy.StrongFocus)
        self.setEditable(True)
        self.setInsertPolicy(QComboBox.InsertPolicy.NoInsert)
        self.setMaxVisibleItems(20)

        # Use a custom QAbstractListModel; this is the whole point of the
        # widget — populating 15k+ rows must be a constant-cost operation.
        self._list_model = _ComboListModel(self)
        self.setModel(self._list_model)

        # Replace the default prefix completer with a contains-matching one
        # that uses the same model. Contains matching scans the full model on
        # every keystroke, but Qt does the iteration in C++ on our list-backed
        # model, so 100k rows is still well under one frame.
        completer = QCompleter(self._list_model, self)
        completer.setCompletionMode(QCompleter.CompletionMode.PopupCompletion)
        completer.setCaseSensitivity(Qt.CaseSensitivity.CaseInsensitive)
        try:
            completer.setFilterMode(Qt.MatchFlag.MatchContains)
        except (TypeError, AttributeError):
            # Older PyQt: fall back to the default prefix matching.
            pass
        self.setCompleter(completer)

        self._show_placeholder('')

    # region Wheel event (match CustomQComboBox)
    def wheelEvent(self, event):  # noqa: N802 - Qt API
        if self.hasFocus():
            return QComboBox.wheelEvent(self, event)
        return None
    # endregion

    # region Write API overrides
    # Our custom QAbstractListModel is read-only by design (faster bulk
    # population). Forward the few mutating QComboBox calls callers might use
    # to the underlying list so things like `tools_qt.set_combo_value`'s
    # fall-back `addItem(...)` keep working on async combos.
    def addItem(self, *args, **kwargs):  # noqa: N802 - Qt API
        text, user_data = self._extract_text_and_data(args, kwargs)
        row_id, row_idval = self._row_from_user_data(text, user_data)
        self._list_model.append_row((row_id, row_idval))

    def insertItem(self, *_args, **_kwargs):  # noqa: N802 - Qt API
        # Treat as append; we don't support arbitrary insertion points.
        text, user_data = self._extract_text_and_data(_args[1:], _kwargs)
        row_id, row_idval = self._row_from_user_data(text, user_data)
        self._list_model.append_row((row_id, row_idval))

    def clear(self):
        self._list_model.set_rows([])

    @staticmethod
    def _extract_text_and_data(args, kwargs):
        text = ''
        user_data = None
        if args:
            text = args[0]
            if len(args) > 1:
                user_data = args[1]
        if 'text' in kwargs:
            text = kwargs['text']
        if 'userData' in kwargs:
            user_data = kwargs['userData']
        return text, user_data

    @staticmethod
    def _row_from_user_data(text, user_data) -> _ComboRow:
        if isinstance(user_data, (list, tuple)) and len(user_data) >= 2:
            return ('' if user_data[0] is None else str(user_data[0]),
                    '' if user_data[1] is None else str(user_data[1]))
        # Fall back to using `text` as the visible label only.
        return ('' if user_data is None else str(user_data), '' if text is None else str(text))
    # endregion

    # region Public API used by tools_gw / tools_qt
    def set_null_value_enabled(self, is_null: bool) -> None:
        """Toggle whether an empty placeholder row is prepended to the data."""
        self._is_null_value = bool(is_null)

    def set_pending_selection(self, value, index: int = 0) -> None:
        """Defer selection until the items finish loading.

        Called by `tools_qt.set_combo_value` (via duck typing) when the combo
        hasn't been populated yet. The value is reapplied in `apply_rows`.
        """
        self._pending_selected_id = None if value in (None, '') else str(value)
        self._pending_select_index = int(index) if index is not None else 0
        if self.property('rows_loaded'):
            # If rows are already there, apply immediately.
            self._apply_pending_selection()

    def has_loaded_rows(self) -> bool:
        return bool(self.property('rows_loaded'))

    def start_loading(self, query: str) -> None:
        """Begin (or restart) loading the combo's items in the background."""
        if not query:
            # No query → empty list, just clear the placeholder so the combo
            # is ready (and signal that loading is "done").
            self._show_placeholder('')
            self.apply_rows([])
            return

        # Bump token: older tasks finishing later will be ignored.
        self._token += 1
        self._loading = True
        self.setProperty('rows_loaded', False)
        self._show_placeholder(self.tr('Loading...'))

        # Try to cancel the previous task if it is still running.
        if self._task is not None:
            try:
                self._task.cancel()
            except Exception:
                pass
            self._task = None

        description = f"GwAsyncComboBox load {self.objectName() or '(no name)'}"
        task = GwComboLoaderTask(description, query, self._token)
        task.rows_loaded.connect(self._on_rows_loaded)
        self._task = task
        QgsApplication.taskManager().addTask(task)

    def apply_rows(self, rows: Sequence) -> None:
        """Replace the combo contents with `rows` and restore selection.

        Implementation note: we never iterate `addItem` for thousands of rows.
        We build a Python list of tuples (cheap, ~1ms per 10k rows) and hand
        it to the custom model in a single `set_rows` call. The model emits
        a single `modelReset`, so the QComboBox refreshes once.
        """

        items: List[_ComboRow] = []
        if self._is_null_value:
            items.append(('', ''))
        for row in rows or []:
            row_id = '' if row[0] is None else str(row[0])
            idval = row[1] if len(row) > 1 and row[1] is not None else row_id
            items.append((row_id, str(idval)))

        # Block signals across the model swap + selection so external
        # handlers don't fire intermediate `currentIndexChanged` events
        # while the combo is rebuilding.
        self.blockSignals(True)
        try:
            self._list_model.set_rows(items)
            self._apply_pending_selection()
        finally:
            self.blockSignals(False)

        self.setProperty('rows_loaded', True)
        self._loading = False

        # Single coalesced signal so child combo loaders / `get_values` /
        # widgetfunctions can react to the final state.
        try:
            self.currentIndexChanged.emit(self.currentIndex())
        except Exception:
            pass
    # endregion

    # region Internals
    def _show_placeholder(self, text: str) -> None:
        # Single placeholder row with empty `id` so get_combo_value() returns
        # '' while the combo is loading. The displayed `idval` carries the
        # placeholder text (e.g. `Loading...`).
        self._list_model.set_rows([('', text)])

    def _on_rows_loaded(self, token: int, rows: list, error: str) -> None:
        if token != self._token:
            # Stale task result - ignore.
            return
        self._task = None
        if error:
            # Show a single, clearly disabled-looking row. We don't disable
            # the widget so the user can still type/retry via parent combo.
            self._list_model.set_rows([('', self.tr('Error loading values'))])
            self.setProperty('rows_loaded', True)
            self._loading = False
            return
        self.apply_rows(rows)

    def _apply_pending_selection(self) -> None:
        if self._pending_selected_id is None:
            return
        target = str(self._pending_selected_id)
        idx = self._pending_select_index or 0
        # Iterate the Python list directly — much cheaper than calling
        # itemData(i) once per row through Qt for 10k+ entries.
        rows = self._list_model.get_rows()
        for i, item in enumerate(rows):
            try:
                value = item[idx]
            except (IndexError, KeyError, TypeError):
                continue
            if str(value) == target:
                self.setCurrentIndex(i)
                self._pending_selected_id = None
                return
        # Value not found in the loaded rows: leave selection unchanged.
        # We keep _pending_selected_id so a later reload (e.g. parent combo
        # changed) can pick it up.
    # endregion
