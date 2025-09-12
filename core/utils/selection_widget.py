"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
import os
from functools import partial
from typing import Any, Callable, Union  # Literal, Dict, Optional,

from qgis.PyQt.QtGui import QIcon, QStandardItem, QStandardItemModel
from qgis.core import QgsExpression
from qgis.PyQt.QtWidgets import QActionGroup, QAction, QToolButton, QMenu, QTabWidget, QDialog, QWidget, \
                    QHBoxLayout, QPushButton, QGridLayout
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtCore import QItemSelectionModel

from . import tools_gw
from ...libs import tools_qt, tools_qgis, lib_vars  # tools_db,
# from .select_manager import GwSelectManager, GwPolygonSelectManager, GwCircleSelectManager, GwFreehandSelectManager
from .selection_mode import GwSelectionMode
from ... import global_vars


class GwSelectionWidget(QWidget):
    """
    A widget that provides selection tools and functionality for GIS features.
    
    This widget creates a horizontal layout containing various selection-related buttons
    and handles different selection modes (rectangle, polygon, circle, freehand, point).
    It also manages highlighting of selected features on the map based on table selections.
    """

    def __init__(self, self_varibles: dict, general_variables: dict, menu_variables: dict = None,
                 highlight_variables: dict = None, expression_selection: dict = None, selection_on_top_variables: dict = None):
        """
        Initialize the selection widget.
        
        Args:
            parent: Parent widget
            menu_variables: Dict for menu button initialization
            highlight_variables: Dict for highlight features methods
        """
        super().__init__()

        self.selection_mode = self_varibles.get("selection_mode", GwSelectionMode.DEFAULT)
        self.method = self_varibles.get("method", "selected")
        self.number_rows = self_varibles.get("number_rows", 1)
        self.number_buttons = 0
        self.highlight_method_active = False

        # Create layout
        self.lyt_selection = QGridLayout(self)
        self.lyt_selection.setContentsMargins(0, 0, 0, 0)
        self.lyt_selection.setSpacing(2)

        # Create selection button
        if menu_variables:  
            self.init_selection_btn(**general_variables, **menu_variables)

        # Activate highlight features methods
        if highlight_variables:
            self.init_highlight_features_methods(**general_variables, **highlight_variables)

        # Invert selection
        if self_varibles.get("invert_selection", False):
            self.init_invert_selection(**general_variables)

        if expression_selection:
            self.init_expression_selection(**general_variables, **expression_selection)

        if self_varibles.get("zoom_to_selection", False):
            self.init_zoom_to_selection(**general_variables)

        if self_varibles.get("selection_on_top", False):
            # selection_on_top_variables can be None; ensure we pass a mapping
            extra_kwargs = selection_on_top_variables or {}
            self.init_selection_on_top(**general_variables, **extra_kwargs)
        
        if self.number_rows > 1 and self.number_buttons > 1:
            self.reorder_lyt_selection()

    # region utility functions

    def find_parent_tab(self, widget: QWidget):
        """
        Find the parent QTabWidget of a given widget.
        
        Args:
            widget: The widget to find the parent tab for
            
        Returns:
            The parent QTabWidget or None if not found
        """
        current = widget.parent()
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
        class_object.highlight_method_active = self.highlight_method_active
        class_object.highlight_features_method = self.highlight_features_method
        tools_gw.selection_init(class_object, dialog, table_object, self.selection_mode, tool_type)

    def init_selection_btn(self, class_object: Any, dialog: QDialog, table_object: str, used_tools: list[str],
                        callback: Union[Callable[[], bool], None] = None, callback_later: Callable = None):
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
            class_object.callback_later_selection = callback_later
            self.activate_selection_mode(class_object, dialog, table_object, tool_type)

        # Action group to keep exclusivity
        tools = {"rectangle": "137.png", "polygon": "180.svg", "freehand": "182.svg", "circle": "181.svg", "point": "179.png"}

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
        self.lyt_selection.addWidget(self.btn_snapping, 0, self.number_buttons)
        self.number_buttons += 1

    # endregion menu btn_snapping

    # region activate highlight methods

    def highlight_features_method(self, class_object: Any, dialog: QDialog, table_object: str):
        """
        Route to appropriate highlight method based on method string.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table name
        """
        if self.method == "all":
            self.highlight_features_in_table(class_object, dialog, table_object)
        elif self.method == "selected":
            self.highlight_features_selected_in_table(class_object, dialog, table_object)

    def highlight_in_tab_changed(self, class_object: Any, dialog: QDialog, table_object: str,
                                 parent_tab: QTabWidget):
        """
        Handle tab change events for highlighting features.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table name
            parent_tab: The parent tab widget
        """
        widget = parent_tab.widget(parent_tab.currentIndex())
        if widget.objectName() in ("tab_relations", "tab_features", "tab_rel", "RelationsTab"):
            self.highlight_features_method(class_object, dialog, table_object)
        else:
            tools_qgis.refresh_map_canvas()
            if self.method == "psector":
                tools_gw.reset_rubberband(class_object.rubber_band_op)
                tools_gw.reset_rubberband(class_object.rubber_band_line)
                tools_gw.reset_rubberband(class_object.rubber_band_rectangle)
                tools_gw.reset_rubberband(class_object.rubber_band_point)
            else:
                tools_gw.reset_rubberband(class_object.rubber_band)

    def highlight_in_table_changed(self, callback_values: Callable[[], tuple]):
        """
        Handle table change events for highlighting features.
        
        Args:
            callback_values: Callback function that returns (class_object, dialog, table_object)
        """
        class_object, dialog, table_object = callback_values()
        self.highlight_features_method(class_object, dialog, table_object)

    def init_highlight_features_methods(self, class_object: Any, dialog: QDialog, table_object: str,
                                            callback_values: Callable[[], tuple]):
        """
        Initialize highlight features methods with tab change event handlers.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table object name
            callback_values: Optional callback function
        """
        # Setup tab change event handlers
        widget_table, _ = self.get_expected_table(class_object, dialog, table_object)
        parent_tab_table = self.find_parent_tab(widget_table)
        parent_tab = self.find_parent_tab(parent_tab_table)

        if parent_tab_table:
            parent_tab_table.currentChanged.connect(partial(self.highlight_in_table_changed, callback_values))
        if parent_tab:
            parent_tab.currentChanged.connect(partial(self.highlight_in_tab_changed, class_object, dialog,
                                                      table_object, parent_tab))

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
        self.highlight_method_active = True
        tools_qgis.refresh_map_canvas()
        all_rubberbands = global_vars.active_rubberbands
        for rubberband in all_rubberbands:
            tools_gw.reset_rubberband(rubberband)

        # Get main variables
        widget_table, feature_type = self.get_expected_table(class_object, dialog, table_object)

        # Validate table and model
        data_model = widget_table.model()
        if not widget_table or not feature_type or not data_model:
            return

        # Validate selection model
        selection_model = widget_table.selectionModel()
        if not selection_model or selection_model.selectedRows() == 0:
            tools_gw.remove_selection(layers=class_object.rel_layers)
            return
        elif not connected_signal:
            selection_model.selectionChanged.connect(partial(self.highlight_features_selected_in_table,
                                                   class_object, dialog, table_object, True))

        # Get feature IDs from table
        id_column_name = f"{feature_type}_id"
        id_column_index = tools_qt.get_col_index_by_col_name(widget_table, id_column_name)
        if id_column_index == -1:
            return

        ids_to_select = []
        for row in selection_model.selectedRows():
            id_value = data_model.data(data_model.index(row.row(), id_column_index))
            ids_to_select.append(id_value)

        if not ids_to_select:
            tools_gw.remove_selection(layers=class_object.rel_layers)
            return

        # Select features on map
        expr_filter = QgsExpression(f"{id_column_name} IN ({','.join(f'{i}' for i in ids_to_select)})")
        tools_qgis.select_features_by_ids(feature_type, expr_filter, class_object.rel_layers)

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
        tools_gw.add_icon(btn_invert, "183")
        btn_invert.setToolTip("Invert the current selection in the table")
        btn_invert.clicked.connect(partial(self.invert_table_selection, class_object, dialog, table_object))
        self.lyt_selection.addWidget(btn_invert, 0, self.number_buttons)
        self.number_buttons += 1

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

        data_model = widget_table.model()
        selection_model = widget_table.selectionModel()

        if not selection_model or not data_model:
            return

        # Get all row indices
        all_rows = set(range(data_model.rowCount()))
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
            index = data_model.index(row, 0)
            selection_model.select(index, selection_model.Select | selection_model.Rows)

    # endregion invert selection

    # region expression selection

    def init_expression_selection(self, class_object: Any, dialog: QDialog, table_object: str,
                                   callback: Union[Callable[[], bool], None] = None, callback_later: Callable = None):
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
        self.lyt_selection.addWidget(self.btn_expression, 0, self.number_buttons)
        self.number_buttons += 1

    def expression_selection(self, class_object: Any, dialog: QDialog, table_object: str,
                             callback: Union[Callable[[], bool], None] = None, callback_later: Callable = None):
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
        self.lyt_selection.addWidget(btn_zoom_to_selection, 0, self.number_buttons)
        self.number_buttons += 1

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
        tools_gw.zoom_to_feature_by_id(f"ve_{feature_type}", id_col_name, feature_ids)

    # endregion zoom to selection

    # region selection on top

    def init_selection_on_top(self, class_object: Any, dialog: QDialog, table_object: str, callback_later: Callable = None):
        """
        Initialize selection on top functionality.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table name
        """
        # Create button
        self.btn_selection_on_top = QPushButton(self)  # Store as instance variable
        tools_gw.add_icon(self.btn_selection_on_top, "175")
        self.btn_selection_on_top.setToolTip("Show selection on top")
        self.btn_selection_on_top.setCheckable(True)
        self.lyt_selection.addWidget(self.btn_selection_on_top, 0, self.number_buttons)
        self.number_buttons += 1

        # Store original model and button state
        widget_table, _ = self.get_expected_table(class_object, dialog, table_object)
        if widget_table and widget_table.model():
            widget_table.setProperty('original_model', widget_table.model())
            widget_table.setProperty('selection_on_top', False)

        # Connect signals
        self.btn_selection_on_top.clicked.connect(partial(self.toggle_selection_on_top, class_object, dialog, table_object, callback_later))

    def toggle_selection_on_top(self, class_object: Any, dialog: QDialog, table_object: str, callback_later: Callable = None):
        """
        Toggle between showing selection on top or restoring original order
        """
        widget_table, _ = self.get_expected_table(class_object, dialog, table_object)
        if not widget_table or not widget_table.model() or not widget_table.selectionModel():
            return

        checked = widget_table.property('selection_on_top')
        selected_ids = self.get_selected_ids(widget_table)

        if not checked or widget_table.property('previous_selected_ids') != selected_ids:
            # Store current model if not already stored
            if not widget_table.property('original_model'):
                widget_table.setProperty('original_model', widget_table.model())
            if widget_table.selectionModel():
                widget_table.setProperty('previous_selected_ids', selected_ids)
            self.show_selection_on_top(widget_table)
            widget_table.setProperty('selection_on_top', True)
            self.btn_selection_on_top.setChecked(True)  # Update button state
        else:
            # Get the current and original models
            current_model = widget_table.model()
            original_model = widget_table.property('original_model')
            if original_model and current_model:
                # Get the feature type and find ID column
                _, feature_type = self.get_expected_table(class_object, dialog, table_object)
                if not feature_type:
                    return

                # Create a mapping of IDs to their current data
                current_data = {}
                id_column_name = f"{feature_type}_id"
                id_col = tools_qt.get_col_index_by_col_name(widget_table, id_column_name)
                if id_col == -1:
                    return

                for row in range(current_model.rowCount()):
                    row_id = str(current_model.data(current_model.index(row, id_col)))
                    row_data = {}
                    for col in range(current_model.columnCount()):
                        source_index = current_model.index(row, col)
                        item = QStandardItem()
                        row_data[col] = self.copy_item_data(current_model, source_index, item)
                    current_data[row_id] = row_data

                # Update original model with current data
                for row in range(original_model.rowCount()):
                    row_id = str(original_model.data(original_model.index(row, id_col)))
                    if row_id in current_data:
                        for col in range(original_model.columnCount()):
                            target_index = original_model.index(row, col)
                            current_item = current_data[row_id][col]
                            # Copy all roles from current item to original model
                            for role in range(Qt.UserRole + 100):  # Copy all possible roles
                                data = current_item.data(role)
                                if data is not None:
                                    original_model.setData(target_index, data, role)

                # Restore model with updated data
                widget_table.setModel(original_model)
                # Restore selection
                self.restore_selection(widget_table, selected_ids)
                widget_table.setProperty('selection_on_top', False)
                self.btn_selection_on_top.setChecked(False)  # Update button state

        if callback_later:
            callback_later()

    def get_selected_ids(self, widget_table):
        """Get IDs of selected rows"""
        model = widget_table.model()
        selection_model = widget_table.selectionModel()
        selected_ids = []

        if selection_model and selection_model.hasSelection():
            for index in selection_model.selectedRows():
                selected_ids.append(str(model.data(model.index(index.row(), 0))))
        return selected_ids

    def restore_selection(self, widget_table, selected_ids):
        """Restore selection based on IDs"""
        model = widget_table.model()
        selection_model = widget_table.selectionModel()

        if not model or not selection_model:
            return

        for row in range(model.rowCount()):
            row_id = str(model.data(model.index(row, 0)))
            if row_id in selected_ids:
                index = model.index(row, 0)
                selection_model.select(index, QItemSelectionModel.Select | QItemSelectionModel.Rows)

    def show_selection_on_top(self, widget_table):
        """
        Moves the selected rows in a QTableView to the top while preserving all data roles and delegates
        """
        if not widget_table or not widget_table.model() or not widget_table.selectionModel():
            return

        model = widget_table.model()
        selection_model = widget_table.selectionModel()
        if not selection_model or not selection_model.hasSelection():
            return

        # Remember selected IDs
        selected_ids = self.get_selected_ids(widget_table)

        # Create a new model
        temp_model = QStandardItemModel()
        temp_model.setHorizontalHeaderLabels([model.headerData(i, Qt.Horizontal) for i in range(model.columnCount())])

        # Copy all item delegates from the original model
        for col in range(model.columnCount()):
            delegate = widget_table.itemDelegateForColumn(col)
            if delegate:
                widget_table.setItemDelegateForColumn(col, None)  # Remove from old model
                temp_model.setItemDelegateForColumn(col, delegate)  # Set on new model

        # First add selected rows
        selected_rows = sorted([index.row() for index in selection_model.selectedRows()])
        for row in selected_rows:
            row_data = []
            for col in range(model.columnCount()):
                source_index = model.index(row, col)
                item = QStandardItem()
                target_item = self.copy_item_data(model, source_index, item)
                row_data.append(target_item)
            temp_model.appendRow(row_data)

        # Then add non-selected rows
        for row in range(model.rowCount()):
            if row not in selected_rows:
                row_data = []
                for col in range(model.columnCount()):
                    source_index = model.index(row, col)
                    item = QStandardItem()
                    target_item = self.copy_item_data(model, source_index, item)
                    row_data.append(target_item)
                temp_model.appendRow(row_data)

        # Set the new model
        widget_table.setModel(temp_model)

        # Restore selection
        self.restore_selection(widget_table, selected_ids)

    def copy_item_data(self, model, source_index, target_item):
            # List of common Qt roles to preserve
            roles = [
                Qt.DisplayRole, Qt.EditRole, Qt.DecorationRole, Qt.ToolTipRole,
                Qt.StatusTipRole, Qt.WhatsThisRole, Qt.FontRole, Qt.TextAlignmentRole,
                Qt.BackgroundRole, Qt.ForegroundRole, Qt.CheckStateRole, Qt.InitialSortOrderRole,
                Qt.UserRole
            ]

            # Copy data for all roles
            for role in roles:
                data = model.data(source_index, role)
                if data is not None:
                    target_item.setData(data, role)

            # Copy any custom user roles (above Qt.UserRole)
            for role in range(Qt.UserRole + 1, Qt.UserRole + 100):
                data = model.data(source_index, role)
                if data is not None:
                    target_item.setData(data, role)

            return target_item

    # endregion selection on top

    # region reorder layout

    def reorder_lyt_selection(self) -> None:
        """
        Reorder the layout of the selection widget into a proper grid layout.
        
        Transforms the current horizontal layout into a grid layout with the specified
        number of rows, distributing widgets evenly across columns.
        """            
        # Collect all widgets from the current layout
        self.widgets = []
        while self.lyt_selection.count():
            item = self.lyt_selection.takeAt(0)
            widget = item.widget()
            if widget:
                widget.setParent(None)
                self.widgets.append(widget)

        # Early return if no widgets to reorder
        if not self.widgets:
            return

        # Calculate columns per row (ceiling division to ensure all widgets fit)
        total_widgets = len(self.widgets)
        cols_per_row = (total_widgets + self.number_rows - 1) // self.number_rows

        # Reinsert widgets in grid order
        for i, widget in enumerate(self.widgets):
            row = i // cols_per_row
            col = i % cols_per_row
            self.lyt_selection.addWidget(widget, row, col)

    # endregion reorder layout

