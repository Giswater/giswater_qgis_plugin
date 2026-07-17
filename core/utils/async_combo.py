"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import sys
from functools import partial
from typing import List, Optional, Sequence, Tuple

from qgis.PyQt.QtCore import QAbstractListModel, QEvent, QModelIndex, Qt, QTimer
from qgis.PyQt.QtGui import QKeyEvent
from qgis.PyQt.QtWidgets import (
    QApplication,
    QComboBox,
    QFrame,
    QLineEdit,
    QListView,
    QProxyStyle,
    QStyle,
    QStyleFactory,
)
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


# Hard cap on how many rows are made visible in the popup at any one time.
# Even with the custom list model and uniform item sizes, painting and scroll
# math get noticeably slower past a few thousand rows; the user is expected
# to narrow with the search box past this point. The model itself still
# stores the full set so filtering uses every row.
MAX_POPUP_VISIBLE_ROWS = 200

# Cap on how many items the popup shows on screen at once (height limit).
# The popup scrolls past this; anything within the visible-rows cap can still
# be reached by scrolling, anything past it by typing in the search box.
MAX_POPUP_VISIBLE_HEIGHT_ITEMS = 15

# Popup layout: Qt may not have painted rows on the first pass.
_POPUP_LAYOUT_RETRY_MS = 10
_POPUP_LAYOUT_MAX_ATTEMPTS = 3
_POPUP_FRAME_PAD = 2
_QWIDGETSIZE_MAX = 16777215


class _NonNativeComboPopupStyle(QProxyStyle):
    """Style proxy that forces a non-native combo popup.

    Some styles (GTK+, macOS, sometimes Breeze) return `true` for
    `SH_ComboBox_Popup`, which makes Qt show a native popup that ignores
    `setMaxVisibleItems` on non-editable combos. By proxying the platform
    style and overriding only that hint we keep every other style detail
    (paint, metrics, sub-controls) untouched.

    Important: the base style passed to `QProxyStyle` is **reparented** by
    the proxy (Qt takes ownership). Never pass `QApplication.style()`
    directly — that steals the app's style and causes a crash later when
    the proxy (and with it, the app style) is destroyed. Always feed a
    fresh `QStyleFactory.create(...)` instance (or `None` to let Qt build
    its default).
    """

    def styleHint(self, hint, option=None, widget=None, returnData=None):  # noqa: N802 - Qt API
        if hint == QStyle.StyleHint.SH_ComboBox_Popup:
            return 0
        return super().styleHint(hint, option, widget, returnData)


def _build_non_native_combo_style() -> Optional[QProxyStyle]:
    """Build a `_NonNativeComboPopupStyle` over a fresh copy of the current
    application style. Returns `None` if no suitable style key is found
    (caller should then skip applying the proxy).
    """
    app_style = QApplication.style()
    if app_style is None:
        return None
    # Try the QObject name first. QStyleFactory sets it to the key it was
    # created with (e.g. "Fusion"); native platform styles often have it
    # too (e.g. "Breeze" on KDE).
    style_key = app_style.objectName()
    if not style_key:
        # Fall back: derive from class name (QFusionStyle -> Fusion).
        cls_name = type(app_style).__name__
        if cls_name.startswith("Q") and cls_name.endswith("Style"):
            style_key = cls_name[1:-len("Style")]
    base = None
    if style_key:
        base = QStyleFactory.create(style_key)
    if base is None:
        # Anything is fine here — only used to delegate non-overridden
        # hints. Fusion is available on every Qt build.
        base = QStyleFactory.create("Fusion")
    if base is None:
        return None
    return _NonNativeComboPopupStyle(base)


class _ComboPopupView(QListView):
    """`QListView` subclass that reserves a top viewport margin so a search
    `QLineEdit` can sit above the items without overlapping them.

    `setViewportMargins` is `protected` in `QAbstractScrollArea`, so we expose
    a public method here. Setting the margin reserves space inside the view's
    frame: the viewport (where items render) is shifted down by `margin`, but
    the view itself keeps the same outer geometry.
    """

    def __init__(self, parent=None):
        super().__init__(parent)
        # Drop the default frame; the QComboBox popup container already draws
        # its own frame around us.
        self.setFrameShape(QFrame.Shape.NoFrame)
        try:
            self.setUniformItemSizes(True)
        except AttributeError:
            pass
        self._top_margin = 0
        self._top_widget: Optional[QLineEdit] = None

    def set_top_margin(self, margin: int) -> None:
        self._top_margin = max(0, int(margin))
        self.setViewportMargins(0, self._top_margin, 0, 0)

    def set_top_widget(self, widget: Optional[QLineEdit]) -> None:
        self._top_widget = widget

    def top_margin(self) -> int:
        return self._top_margin

    def resizeEvent(self, event):  # noqa: N802 - Qt API
        super().resizeEvent(event)
        # Keep the registered search overlay anchored at the top, full-width.
        if self._top_margin <= 0 or self._top_widget is None:
            return
        try:
            self._top_widget.setGeometry(0, 0, self.width(), self._top_margin)
        except RuntimeError:
            self._top_widget = None


class GwAsyncComboBox(QComboBox):
    """Non-editable combobox that loads its items asynchronously and lets the
    user type-to-filter inside the popup.

    UX
        - The widget is **not editable**: clicking on it just opens the popup,
          the user can never type into the combo's display itself.
        - When the popup opens, a small `QLineEdit` is overlaid at the top of
          the popup container. It receives focus immediately so the user can
          start typing right away to narrow the visible items.
        - Up/Down/PageUp/PageDown navigate the visible (non-hidden) rows in
          the popup view. Enter activates the highlighted row. Escape closes
          the popup without changing the selection.
        - Filtering is done by hiding rows in the popup view (`setRowHidden`)
          so the underlying model is never modified — every other API
          (`combo.count()`, `combo.itemData(i)`,
          `tools_qt.get_combo_value`/`set_combo_value`) keeps seeing the full
          list, regardless of the filter.
        - After open/filter, the popup is resized to the painted row span
          (not Qt's default `maxVisibleItems` height). Set
          ``popup_opens_upward = True`` on status-bar combos that open above
          the widget.

    Lifecycle
        1. Widget is constructed and immediately shows a single placeholder
           row so `tools_qt.get_combo_value(...)` returns `''` while loading.
        2. `start_loading(query)` schedules a `GwComboLoaderTask`. The widget
           bumps an internal *token* so older tasks are ignored if multiple
           loads are queued (e.g. parent combo changed).
        3. When the task finishes, `_on_rows_loaded` swaps the model contents
           in O(1) and re-applies any pending selection.

    Markers
        - ``_gw_is_async_combo``: True; used by external helpers to detect
          an async combo without importing this module.
        - ``rows_loaded`` Qt property: False while loading, True afterwards.
    """

    popup_opens_upward = False

    def __init__(self, parent=None):
        super().__init__(parent)
        self._gw_is_async_combo = True
        self._token = 0
        self._task: Optional[GwComboLoaderTask] = None
        self._pending_selected_id: Optional[str] = None
        self._pending_select_index: int = 0
        self._is_null_value: bool = False
        self._loading: bool = False

        # Popup search state.
        self._search_edit: Optional[QLineEdit] = None
        self._search_active: bool = False
        # Set of row indices currently hidden in the popup view. Tracking it
        # ourselves lets us only call setRowHidden on rows whose state has
        # actually changed (huge win when typing/backspacing on 15k+ items).
        self._hidden_rows: set = set()

        self.setProperty('rows_loaded', False)
        self.setFocusPolicy(Qt.FocusPolicy.StrongFocus)
        self.setEditable(False)
        self.setInsertPolicy(QComboBox.InsertPolicy.NoInsert)
        # On GTK+ / macOS / KDE Breeze, `SH_ComboBox_Popup` is true by
        # default which makes Qt show a native popup that ignores
        # `maxVisibleItems`. The proxy style flips that single hint so the
        # cap is honored everywhere.
        #
        # Skip on Windows: the Windows/Vista style already returns false
        # for `SH_ComboBox_Popup`, so the proxy is unnecessary there — and
        # avoiding it dodges any QStyle ownership / lifetime weirdness on
        # platforms where it isn't needed in the first place.
        #
        # We also must hand `QProxyStyle` a fresh `QStyleFactory.create(...)`
        # instance — passing `self.style()` would let the proxy reparent
        # (and later free) the application style, which crashes any
        # subsequent `style()` lookup (e.g. `QMenuPrivate::init`).
        if not sys.platform.startswith("win"):
            try:
                proxy = _build_non_native_combo_style()
                if proxy is not None:
                    self.setStyle(proxy)
            except Exception:
                pass
        self.setMaxVisibleItems(MAX_POPUP_VISIBLE_HEIGHT_ITEMS)

        # Use a custom QAbstractListModel; this is the whole point of the
        # widget — populating 15k+ rows must be a constant-cost operation.
        self._list_model = _ComboListModel(self)
        self.setModel(self._list_model)

        # Custom view with a configurable top margin so the search edit gets
        # its own reserved space at the top of the popup.
        self._popup_view = _ComboPopupView(self)
        self.setView(self._popup_view)

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

        # New row set invalidates any hidden-rows bookkeeping from a
        # previous model state.
        self._hidden_rows = set()

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

    # region Popup with type-to-filter
    def showPopup(self):  # noqa: N802 - Qt API
        super().showPopup()
        if self._list_model.rowCount() <= 1:
            return
        self._install_search_overlay()

    def hidePopup(self):  # noqa: N802 - Qt API
        self._teardown_search_overlay()
        super().hidePopup()

    def _popup_container(self):
        view = self.view()
        return view.parentWidget() if view is not None else None

    def _popup_widgets(self):
        """Return popup widgets whose height we manage (container, view, window)."""
        view = self.view()
        if view is None:
            return []
        seen = set()
        widgets = []
        for widget in (self._popup_container(), view, view.window()):
            if widget is not None and id(widget) not in seen:
                seen.add(id(widget))
                widgets.append(widget)
        return widgets

    def _set_popup_height(self, width: int, height: int) -> None:
        """Pin popup height on every layer Qt uses for the combo list."""
        for widget in self._popup_widgets():
            if not widget.isVisible():
                continue
            widget.setMaximumHeight(_QWIDGETSIZE_MAX)
            widget.setMinimumHeight(0)
            widget.resize(width, height)
            widget.setMinimumHeight(height)
            widget.setMaximumHeight(height)

    def _clear_popup_height(self) -> None:
        for widget in self._popup_widgets():
            widget.setMinimumHeight(0)
            widget.setMaximumHeight(_QWIDGETSIZE_MAX)

    def _install_search_overlay(self):
        view = self.view()
        container = self._popup_container()
        if view is None or container is None:
            return

        if self._search_edit is None:
            edit = QLineEdit(view)
            edit.setObjectName(f"{self.objectName() or 'gw_async_combo'}_search")
            edit.setPlaceholderText(self.tr("Type to filter..."))
            edit.setClearButtonEnabled(True)
            edit.textChanged.connect(self._apply_search_filter)
            edit.installEventFilter(self)
            self._search_edit = edit
        else:
            self._search_edit.setParent(view)

        if isinstance(view, _ComboPopupView):
            view.set_top_widget(self._search_edit)

        edit = self._search_edit
        edit_h = edit.sizeHint().height()
        edit.blockSignals(True)
        edit.clear()
        edit.blockSignals(False)

        if isinstance(view, _ComboPopupView):
            view.set_top_margin(edit_h)

        edit.setGeometry(0, 0, view.width(), edit_h)
        edit.show()
        edit.raise_()
        edit.setFocus(Qt.FocusReason.PopupFocusReason)

        self._search_active = True
        self._apply_search_filter("")

    def _teardown_search_overlay(self):
        self._search_active = False
        self._clear_popup_height()
        view = self.view()
        if isinstance(view, _ComboPopupView):
            view.set_top_margin(0)
            view.set_top_widget(None)
        if self._search_edit is None:
            return
        try:
            self._search_edit.blockSignals(True)
            self._search_edit.clear()
            self._search_edit.blockSignals(False)
            self._search_edit.hide()
        except RuntimeError:
            # View may already be gone.
            self._search_edit = None

    def _apply_search_filter(self, text: str) -> None:
        if not self._search_active:
            return
        view = self.view()
        if view is None:
            return
        needle = (text or '').strip().lower()
        rows = self._list_model.get_rows()
        total = len(rows)

        # Walk the rows once: collect non-matches into the hidden set, and
        # cap the number of *matches* we actually expose to the view. Excess
        # matches go into the hidden set too — the user can narrow further.
        new_hidden: set = set()
        first_visible = -1
        visible_count = 0
        match_count = 0
        for i in range(total):
            if needle and needle not in rows[i][1].lower():
                new_hidden.add(i)
                continue
            match_count += 1
            if visible_count >= MAX_POPUP_VISIBLE_ROWS:
                new_hidden.add(i)
                continue
            if first_visible < 0:
                first_visible = i
            visible_count += 1

        # Diff against the previous hidden set to only call setRowHidden on
        # rows whose visibility actually changed.
        view.setUpdatesEnabled(False)
        try:
            for i in self._hidden_rows - new_hidden:
                view.setRowHidden(i, False)
            for i in new_hidden - self._hidden_rows:
                view.setRowHidden(i, True)
        finally:
            view.setUpdatesEnabled(True)
        self._hidden_rows = new_hidden

        if first_visible >= 0:
            new_idx = self._list_model.index(first_visible, 0)
            view.setCurrentIndex(new_idx)
            view.scrollTo(new_idx)

        self._update_search_status(match_count, visible_count, needle, total)
        display_rows = 0 if match_count <= 0 else min(match_count, self.maxVisibleItems())
        self._schedule_layout_popup(display_rows)

    def _schedule_layout_popup(self, display_rows: int) -> None:
        """Layout after Qt paints rows so visualRect measurements are reliable."""
        QTimer.singleShot(0, partial(self._layout_popup, display_rows, 0))

    def _visible_row_span(self, display_rows: int):
        """Return `(first_row, last_row)` indices for popup height, up to `display_rows`."""
        first = last = None
        shown = 0
        for i in range(self._list_model.rowCount()):
            if i in self._hidden_rows:
                continue
            if first is None:
                first = i
            last = i
            shown += 1
            if shown >= display_rows:
                break
        return first, last

    def _popup_list_height(self, view, display_rows: int) -> int:
        """Measure the painted list height from first to last visible row."""
        if display_rows <= 0:
            return max(12, view.fontMetrics().height() // 2)

        first, last = self._visible_row_span(display_rows)
        if first is not None and last is not None:
            top = view.visualRect(self._list_model.index(first, 0)).top()
            bottom = view.visualRect(self._list_model.index(last, 0)).bottom()
            if bottom > top:
                return bottom - top + 1

        # Fallback before rows are painted: sum size hints without padding floors.
        total = 0
        shown = 0
        for i in range(self._list_model.rowCount()):
            if i in self._hidden_rows:
                continue
            total += view.sizeHintForRow(i) or (view.fontMetrics().height() + 4)
            shown += 1
            if shown >= display_rows:
                return total
        return 0

    def _layout_popup(self, display_rows: int, attempt: int = 0) -> None:
        """Resize the popup to fit the search box plus visible rows.

        Qt opens the list at ``maxVisibleItems`` height. We remeasure the
        painted row span after the popup is shown and pin the same height on
        the container, view and top-level popup window so no empty area remains.
        """
        if not self._search_active:
            return
        view = self.view()
        if view is None:
            return

        list_h = self._popup_list_height(view, display_rows)
        if list_h <= 0 and attempt < _POPUP_LAYOUT_MAX_ATTEMPTS:
            QTimer.singleShot(
                _POPUP_LAYOUT_RETRY_MS,
                partial(self._layout_popup, display_rows, attempt + 1),
            )
            return

        edit_h = self._search_edit.sizeHint().height() if self._search_edit else 0
        container = self._popup_container()
        width = self.width() or (container.width() if container is not None else 0)
        height = edit_h + list_h + _POPUP_FRAME_PAD

        self._set_popup_height(width, height)

        if self.popup_opens_upward:
            popup = view.window()
            if popup is not None and popup.isVisible():
                pos = self.mapToGlobal(self.rect().topLeft())
                popup.move(pos.x(), pos.y() - height)

    def _update_search_status(
        self, match_count: int, visible_count: int, needle: str, total: int
    ) -> None:
        if self._search_edit is None:
            return
        if needle:
            if match_count == 0:
                tip = self.tr("No matches")
            elif match_count > visible_count:
                tip = self.tr("Showing {0} of {1} matches - keep typing...").format(
                    visible_count, match_count
                )
            else:
                tip = self.tr("{0} matches").format(match_count)
        elif total > MAX_POPUP_VISIBLE_ROWS:
            tip = self.tr("Type to filter ({0} of {1} shown)").format(
                MAX_POPUP_VISIBLE_ROWS, total
            )
        else:
            tip = self.tr("Type to filter...")
        self._search_edit.setToolTip(tip)
        # Placeholder is only visible while the line edit is empty, but
        # showing the truncation hint there is exactly when it's most useful.
        self._search_edit.setPlaceholderText(tip)

    def _forward_navigation(self, event: QKeyEvent) -> None:
        # QAbstractItemView.moveCursor already skips hidden rows during
        # arrow / page navigation, so we just deliver the key event to the
        # popup view as if it were focused.
        view = self.view()
        if view is None:
            return
        QApplication.sendEvent(view, event)

    def _activate_highlighted(self) -> None:
        view = self.view()
        if view is None:
            self.hidePopup()
            return
        idx = view.currentIndex()
        if idx.isValid() and not view.isRowHidden(idx.row()):
            self.setCurrentIndex(idx.row())
        self.hidePopup()

    def eventFilter(self, obj, event):  # noqa: N802 - Qt API
        if obj is self._search_edit and event.type() == QEvent.Type.KeyPress:
            assert isinstance(event, QKeyEvent)
            key = event.key()
            if key in (
                Qt.Key.Key_Down,
                Qt.Key.Key_Up,
                Qt.Key.Key_PageDown,
                Qt.Key.Key_PageUp,
                Qt.Key.Key_Home,
                Qt.Key.Key_End,
            ):
                self._forward_navigation(event)
                return True
            if key in (Qt.Key.Key_Return, Qt.Key.Key_Enter):
                self._activate_highlighted()
                return True
            if key == Qt.Key.Key_Escape:
                self.hidePopup()
                return True
            if key == Qt.Key.Key_Tab:
                # Close popup and let focus go to the next widget.
                self.hidePopup()
                QApplication.sendEvent(self, event)
                return True
        return super().eventFilter(obj, event)
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
