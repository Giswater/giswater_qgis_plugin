"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
import os
from functools import partial
from typing import Any, Callable  # Literal, Dict, Optional,

from qgis.PyQt.QtGui import QIcon, QStandardItem
from qgis.core import QgsExpression
from qgis.PyQt.QtWidgets import QActionGroup, QAction, QToolButton, QMenu, QTabWidget, QDialog, QWidget, QHBoxLayout, QPushButton
from qgis.PyQt.QtCore import Qt

from . import tools_gw
from ...libs import tools_qt, tools_qgis, lib_vars  # tools_db,
# from .select_manager import GwSelectManager, GwPolygonSelectManager, GwCircleSelectManager, GwFreehandSelectManager
from .selection_mode import GwSelectionMode


class GwSelectionWidget(QWidget):
    """
    A widget that provides selection tools and functionality for GIS features.
    
    This widget creates a horizontal layout containing various selection-related buttons
    and handles different selection modes (rectangle, polygon, circle, freehand, point).
    It also manages highlighting of selected features on the map based on table selections.
    """

    def __init__(self, selection_mode: GwSelectionMode, general_variables: dict, menu_variables: dict = None,
                 highlight_variables: dict = None, invert_selection: bool = False, expression_selection: dict = None,
                 zoom_to_selection: bool = False, selection_on_top: bool = False):
        """
        Initialize the selection widget.
        
        Args:
            parent: Parent widget
            menu_variables: Dict for menu button initialization
            highlight_variables: Dict for highlight features methods
            invert_selection: Dict for invert selection functionality
        """
        super().__init__()

        self.selection_mode = selection_mode

        # Create layout
        self.lyt_selection = QHBoxLayout(self)
        self.lyt_selection.setContentsMargins(0, 0, 0, 0)
        self.lyt_selection.setSpacing(2)

        # Create selection button
        if menu_variables:
            self.init_selection_btn(**general_variables, **menu_variables)

        # Activate highlight features methods
        if highlight_variables:
            self.init_highlight_features_methods(**general_variables, **highlight_variables)

        # Invert selection
        if invert_selection:
            self.init_invert_selection(**general_variables)

        if expression_selection:
            self.init_expression_selection(**general_variables, **expression_selection)

        if zoom_to_selection:
            self.init_zoom_to_selection(**general_variables)

        if selection_on_top:
            self.init_selection_on_top(**general_variables)

    # region utility functions

    def find_parent_tab(self, widget: QWidget):
        """
        Find the parent QTabWidget of a given widget.
        
        Args:
            widget: The widget to find the parent tab for
            
        Returns:
            The parent QTabWidget or None if not found
        """
        current = widget
        while current is not None:
            if isinstance(current, QTabWidget):
                return current
            current = current.parent()
        return None

    def get_expected_table(self, class_object: Any, dialog: QDialog, table_object: str):
        """
        Get the expected table name based on selection mode.
        
        Args:
            class_object: The class object
            table_object: The table object name
            
        Returns:
            The expected QTableView
            The feature type
        """
        if self.selection_mode in (GwSelectionMode.LOT, GwSelectionMode.EXPRESSION_LOT):
            expected_table_name = f"tbl_campaign_{table_object}_x_{class_object.rel_feature_type}"
        elif self.selection_mode == GwSelectionMode.MINCUT_CONNEC:
            expected_table_name = f"tbl_{table_object}_{class_object.rel_feature_type}"
        else:
            expected_table_name = f"tbl_{table_object}_x_{class_object.rel_feature_type}"

        widget_table = tools_qt.get_widget(dialog, expected_table_name)

        return widget_table, class_object.rel_feature_type

    # endregion utility functions

    # region menu btn_snapping

    def update_default_action(self, action: QAction):
        """
        Update the default action for the snapping button.
        
        Args:
            action: The action to set as default
        """
        self.btn_snapping.setDefaultAction(action)

    def activate_selection_mode(self, class_object: Any, dialog: QDialog, table_object: str, tool_type: str):
        """
        Activate selection snapping mode.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table object name
            tool_type: The type of selection tool
        """
        # Disconnect any existing connections to avoid duplicates
        try:
            self.btn_snapping.clicked.disconnect()
        except Exception:
            pass
        tools_gw.selection_init(class_object, dialog, table_object, self.selection_mode, tool_type)

    def init_selection_btn(self, class_object: Any, dialog: QDialog, table_object: str, used_tools: list[str],
                        callback: Callable[[], bool] | None = None, callback_later: Callable = None):
        """
        Create snapping button with menu (split button behavior).
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table object name
            used_tools: List of tools to include
            callback: Optional callback function
            callback_later: Optional callback to execute after selection
        """
        def handle_action(tool_type):
            if callback and callback() is False:
                return
            # Directly call selection_init instead of activate_selection_mode to avoid double activation
            self.activate_selection_mode(class_object, dialog, table_object, tool_type)
            if callback_later:
                callback_later()

        # Action group to keep exclusivity
        tools = {"rectangle": "137.png", "polygon": "180.svg", "freehand": "182.svg", "circle": "181.svg", "point": "181.svg"}

        # Create btn_snapping as menu or button widget
        if used_tools and len(used_tools) > 1:
            self.btn_snapping = QToolButton(self)
            ag = QActionGroup(dialog)

            # Create actions for each tool type
            for tool_type in used_tools:
                icon_path = os.path.join(lib_vars.plugin_dir, "icons", "dialogs", tools[tool_type])
                action = QAction(QIcon(icon_path), tool_type, dialog)
                action.setProperty('has_icon', True)
                action.triggered.connect(partial(handle_action, tool_type))
                ag.addAction(action)

            menu = QMenu(dialog)
            menu.addActions(ag.actions())

            # Configure QToolButton as split button
            self.btn_snapping.setPopupMode(QToolButton.MenuButtonPopup)  # left = default, arrow = menu
            self.btn_snapping.setMenu(menu)

            # Set initial default action
            self.btn_snapping.setDefaultAction(ag.actions()[0])

            # Connect menu triggered signal
            menu.triggered.connect(partial(self.update_default_action))
        else:
            tool_type = used_tools[0]
            self.btn_snapping = QPushButton(self)
            tools_gw.add_icon(self.btn_snapping, tools[tool_type].split(".")[0])
            self.btn_snapping.setToolTip(tool_type)
            self.btn_snapping.clicked.connect(partial(tools_gw.selection_init, class_object, dialog, table_object,
                                                      self.selection_mode, tool_type))

        # Add btn_snapping to layout and create actions
        self.lyt_selection.addWidget(self.btn_snapping)

    # endregion menu btn_snapping

    # region activate highlight methods

    def highlight_features_method(self, class_object: Any, dialog: QDialog, table_object: str, method: str):
        """
        Route to appropriate highlight method based on method string.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table name
            method: The method to use ("all", "selected", "psector")
        """
        if method == "all":
            self.highlight_features_in_table(class_object, dialog, table_object)
        elif method == "selected":
            self.highlight_features_selected_in_table(class_object, dialog, table_object)
        elif method == "psector":
            self.highlight_features_psector_in_table(class_object, dialog, table_object)

    def highlight_in_tab_changed(self, class_object: Any, dialog: QDialog, table_object: str,
                                 parent_tab: QTabWidget, method: str):
        """
        Handle tab change events for highlighting features.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table name
            parent_tab: The parent tab widget
            method: The highlight method to use
        """
        widget = parent_tab.widget(parent_tab.currentIndex())
        if widget.objectName() in ("tab_relations", "tab_features"):
            self.highlight_features_method(class_object, dialog, table_object, method)
        else:
            tools_qgis.refresh_map_canvas()
            tools_gw.reset_rubberband(class_object.rubber_band)

    def highlight_in_table_changed(self, method: str, callback_values: Callable[[], tuple]):
        """
        Handle table change events for highlighting features.
        
        Args:
            method: The highlight method to use
            callback_values: Callback function that returns (class_object, dialog, table_object)
        """
        class_object, dialog, table_object = callback_values()
        self.highlight_features_method(class_object, dialog, table_object, method)

    def init_highlight_features_methods(self, class_object: Any, dialog: QDialog, table_object: str,
                                            callback_values: Callable[[], tuple],
                                            method: str = "selected"):
        """
        Initialize highlight features methods with tab change event handlers.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table object name
            method: The highlight method
            callback_values: Optional callback function
        """
        # Setup tab change event handlers
        widget_table, _ = self.get_expected_table(class_object, dialog, table_object)
        parent_tab_table = self.find_parent_tab(widget_table)
        parent_tab = self.find_parent_tab(parent_tab_table)

        if parent_tab_table:
            parent_tab_table.currentChanged.connect(partial(self.highlight_in_table_changed, method, callback_values))
        if parent_tab:
            parent_tab.currentChanged.connect(partial(self.highlight_in_tab_changed, class_object, dialog,
                                                      table_object, parent_tab, method))

    # endregion activate highlight methods

    # region highlight features in table

    def highlight_features_selected_in_table(self, class_object: Any, dialog: QDialog, table_object: str,
                                             connected_signal: bool = False):
        """
        Highlight features selected in table.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table name
            connected_signal: Whether this is called from a connected signal
        """
        # Refresh map canvas and reset rubberband
        tools_qgis.refresh_map_canvas()
        tools_gw.reset_rubberband(class_object.rubber_band)

        # Get main variables
        widget_table, feature_type = self.get_expected_table(class_object, dialog, table_object)

        # Validate table and model
        if not widget_table or not widget_table.selectionModel() or not feature_type:
            return

        model = widget_table.selectionModel()
        if not model or model.selectedRows() == 0:
            tools_gw.remove_selection(layers=class_object.rel_layers)
            return

        # Get feature IDs from table
        id_column_name = f"{feature_type}_id"
        id_column_index = tools_qt.get_col_index_by_col_name(widget_table, id_column_name)
        if id_column_index == -1:
            return

        ids_to_select = [str(model.index(row.row(), id_column_index).data()) for row in model.selectedRows()]

        if not ids_to_select:
            tools_gw.remove_selection(layers=class_object.rel_layers)
            return

        # Select features on map
        expr_filter = QgsExpression(f"{id_column_name} IN ({','.join(f'{i}' for i in ids_to_select)})")
        tools_qgis.select_features_by_ids(feature_type, expr_filter, class_object.rel_layers)

        if not connected_signal:
            model.selectionChanged.connect(partial(tools_qgis.highlight_features_selected_in_table,
                                                   class_object, dialog, table_object, connected_signal=True))

    def highlight_features_psector_in_table(self, class_object: Any, dialog: QDialog, table_object: str):
        """
        Highlight features psector in table.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table name
        """
        # Refresh map canvas and reset rubberband
        tools_qgis.refresh_map_canvas()
        tools_gw.reset_rubberband(class_object.rubber_band)

        widget_table, feature_type = self.get_expected_table(class_object, dialog, table_object)

    def highlight_features_in_table(self, class_object: Any, dialog: QDialog, table_object: str):
        """
        Selects all features on the map that are currently listed in the given table widget.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table name
        """
        # Get main variables
        widget_table, feature_type = self.get_expected_table(class_object, dialog, table_object)

        # Validate table and model
        if not widget_table or not widget_table.model() or not feature_type:
            return

        model = widget_table.model()
        if not model or model.rowCount() == 0:
            tools_gw.remove_selection(layers=class_object.rel_layers)
            return

        # Get feature IDs from table
        id_column_name = f"{feature_type}_id"
        id_column_index = tools_qt.get_col_index_by_col_name(widget_table, id_column_name)
        if id_column_index == -1:
            return

        ids_to_select = [str(model.index(row, id_column_index).data()) for row in range(model.rowCount())]

        if not ids_to_select:
            tools_gw.remove_selection(layers=class_object.rel_layers)
            return

        # Select features on map
        expr_filter = QgsExpression(f"{id_column_name} IN ({','.join(f'{i}' for i in ids_to_select)})")
        tools_qgis.select_features_by_ids(feature_type, expr_filter, class_object.rel_layers)

        # Activate rubberband highlighting
        tools_qgis.highlight_features_selected_in_table(class_object, dialog, table_object, feature_type)

    # endregion highlight features in table

    # region invert selection

    def init_invert_selection(self, class_object: Any, dialog: QDialog, table_object: str):
        """
        Initialize invert selection functionality.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table name
        """
        # Create invert selection button
        btn_invert = QPushButton(self)
        tools_gw.add_icon(btn_invert, "137")
        btn_invert.setToolTip("Invert the current selection in the table")
        btn_invert.clicked.connect(partial(self.invert_table_selection, class_object, dialog, table_object))
        self.lyt_selection.addWidget(btn_invert)

    def invert_table_selection(self, class_object: Any, dialog: QDialog, table_object: str):
        """
        Invert the current selection in the table.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table name
        """
        widget_table, _ = self.get_expected_table(class_object, dialog, table_object)
        if not widget_table or not widget_table.model():
            return

        model = widget_table.model()
        selection_model = widget_table.selectionModel()

        if not selection_model:
            return

        # Get all row indices
        all_rows = set(range(model.rowCount()))
        selected_rows = set()

        # Get currently selected rows
        for index in selection_model.selectedRows():
            selected_rows.add(index.row())

        # Calculate rows to select (invert selection)
        rows_to_select = all_rows - selected_rows

        # Clear current selection
        selection_model.clearSelection()

        # Select the inverted rows
        for row in rows_to_select:
            index = model.index(row, 0)
            selection_model.select(index, selection_model.Select | selection_model.Rows)

        # Highlight the newly selected features
        self.highlight_features_selected_in_table(class_object, dialog, table_object)

    # endregion invert selection

    # region expression selection

    def init_expression_selection(self, class_object: Any, dialog: QDialog, table_object: str,
                                   callback: Callable[[], bool] | None = None, callback_later: Callable = None):
        """
        Initialize expression selection functionality.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table name
            callback: Optional callback function
            callback_later: Optional callback to execute after selection
        """
        # Create expression button
        self.btn_expression = QToolButton(self)
        tools_gw.add_icon(self.btn_expression, "178")
        self.btn_expression.setToolTip("Select features by expression")
        # Connect button click
        self.btn_expression.clicked.connect(partial(self.expression_selection, class_object, dialog, table_object,
                                                  callback, callback_later))
        self.lyt_selection.addWidget(self.btn_expression)

    def expression_selection(self, class_object: Any, dialog: QDialog, table_object: str,
                             callback: Callable[[], bool] | None = None, callback_later: Callable = None):
        """
        Select features by expression.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table name
            callback: Optional callback function
            callback_later: Optional callback to execute after selection
        """
        if callback and callback() is False:
            return
        tools_gw.select_with_expression_dialog(class_object, dialog, table_object, self.selection_mode)
        if callback_later:
            callback_later()

    # endregion expression selection

    # region zoom to selection

    def init_zoom_to_selection(self, class_object: Any, dialog: QDialog, table_object: str):
        """
        Initialize zoom to selection functionality.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table name
        """
        btn_zoom_to_selection = QPushButton(self)
        tools_gw.add_icon(btn_zoom_to_selection, "176")
        btn_zoom_to_selection.setToolTip("Zoom to selection")
        btn_zoom_to_selection.clicked.connect(partial(self.zoom_to_selection, class_object, dialog, table_object))
        self.lyt_selection.addWidget(btn_zoom_to_selection, 0)

    def zoom_to_selection(self, class_object: Any, dialog: QDialog, table_object: str):
        """
        Zoom to selection.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table name
        """
        widget_table, feature_type = self.get_expected_table(class_object, dialog, table_object)
        if not widget_table or not feature_type:
            return

        selection_model = widget_table.selectionModel()
        if not selection_model or not selection_model.hasSelection():
            tools_qgis.show_warning("Please select an element to zoom to.", dialog=dialog)
            return

        model = widget_table.model()
        id_column_index = -1
        id_col_name = f'{feature_type}_id'

        for i in range(model.columnCount()):
            if model.headerData(i, Qt.Horizontal) == id_col_name:
                id_column_index = i
                break

        if id_column_index == -1:
            tools_qgis.show_warning(f"Could not find ID column '{id_col_name}'.", dialog=dialog)
            return

        selected_rows = selection_model.selectedRows()
        feature_ids = [model.data(model.index(row.row(), id_column_index)) for row in selected_rows]

        if not feature_ids:
            return

        # Use the generic zoom function to match psector's behavior
        tools_gw.zoom_to_feature_by_id(f"ve_{feature_type}", id_col_name, feature_ids, dialog=dialog)

    # endregion zoom to selection

    # region selection on top

    def init_selection_on_top(self, class_object: Any, dialog: QDialog, table_object: str):
        """
        Initialize selection on top functionality.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table name
        """
        btn_selection_on_top = QPushButton(self)
        tools_gw.add_icon(btn_selection_on_top, "175")
        btn_selection_on_top.setToolTip("Show selection on top")
        self.lyt_selection.addWidget(btn_selection_on_top, 0)
        btn_selection_on_top.clicked.connect(partial(self.show_selection_on_top, class_object, dialog, table_object))

    def show_selection_on_top(self, class_object: Any, dialog: QDialog, table_object: str):
        """
        Moves the selected rows in a QTableView to the top
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table name
        """
        widget_table, _ = self.get_expected_table(class_object, dialog, table_object)
        if not widget_table or not widget_table.model() or not widget_table.selectionModel():
            return

        model = widget_table.model()
        selection_model = widget_table.selectionModel()
        if not selection_model or not selection_model.hasSelection():
            return

        selected_rows = [index.row() for index in selection_model.selectedRows()]
        selected_rows.sort()

        # Extract items from selected rows
        rows_data = []
        for row in selected_rows:
            row_items = [model.item(row, col) for col in range(model.columnCount())]
            rows_data.append([QStandardItem(item.text()) if item else QStandardItem() for item in row_items])

        # Remove selected rows from the bottom up to avoid index shifting issues
        for row in reversed(selected_rows):
            model.removeRow(row)

        # Insert rows at the top
        for i, row_data in enumerate(rows_data):
            model.insertRow(i, row_data)

        # Restore selection on the moved rows
        for i in range(len(rows_data)):
            widget_table.selectRow(i)

    # endregion selection on top