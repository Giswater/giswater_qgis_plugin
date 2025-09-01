"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
import os
from functools import partial
from typing import Any, Callable  # Literal, Dict, Optional,

from qgis.PyQt.QtGui import QIcon
from qgis.core import QgsExpression
from qgis.PyQt.QtWidgets import QActionGroup, QAction, QToolButton, QMenu, QTabWidget, QDialog, QWidget, QHBoxLayout, QPushButton

import tools_gw
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

    def __init__(self, parent: QWidget):
        """
        Initialize the selection widget.
        
        Args:
            parent: Parent widget
            menu_variables: Tuple containing (class_object, dialog, table_object, used_tools, selection_mode, callback, callback_later)
            highlight_variables: Tuple containing (class_object, dialog, table_object, selection_mode, method, callback_values)
        """
        super().__init__(parent)

        # Create layout
        self.layout = QHBoxLayout(self)
        self.layout.setContentsMargins(0, 0, 0, 0)
        self.layout.setSpacing(2)

    def general_init(self, menu_variables: tuple = None, highlight_variables: tuple = None, invert_selection: tuple = None):
        """
        General initialization for selection widget.
        
        Args:
            menu_variables: Tuple for menu button initialization
            highlight_variables: Tuple for highlight features methods
            invert_selection: Tuple for invert selection functionality
        """
        if menu_variables:
            if menu_variables[3] and len(menu_variables[3]) > 1:
                # Create QPushButton for multiple tools
                self.btn_snapping = QPushButton(self)
                self.layout.addWidget(self.btn_snapping)
            else:
                # Create QToolButton for single tool
                self.btn_snapping = QToolButton(self)
                self.layout.addWidget(self.btn_snapping)

            # Create actions for btn_snapping
            self.init_selection_btn(*menu_variables)

        # Activate highlight features methods
        if highlight_variables:
            self.init_highlight_features_methods(*highlight_variables)

        # Invert selection
        if invert_selection:
            self.init_invert_selection(*invert_selection)

    def add_selection_button(self, button: QWidget, tooltip: str = None):
        """
        Add a custom selection-related button to the layout.
        
        Args:
            button: The button widget to add
            tooltip: Optional tooltip text
            
        Returns:
            The added button
        """
        if tooltip:
            button.setToolTip(tooltip)
        self.layout.addWidget(button)
        return button

    def add_separator(self):
        """Add a visual separator to the layout."""
        separator = QWidget()
        separator.setFixedWidth(1)
        separator.setStyleSheet("background-color: #cccccc;")
        self.layout.addWidget(separator)

    def create_selection_toolbar(self, class_object: Any, dialog: QDialog, expected_table_name: str):
        """
        Create a complete selection toolbar with common operations.
        
        Args:
            class_object: The class object containing feature information
            dialog: The dialog containing the table
            expected_table_name: The name of the table widget
            
        Returns:
            Tuple of (select_all_button, clear_button)
        """
        # Select All button
        btn_select_all = QPushButton("Select All", self)
        btn_select_all.setToolTip("Select all features in the table")
        btn_select_all.clicked.connect(partial(self.select_all_features, class_object, dialog, expected_table_name))
        self.layout.addWidget(btn_select_all)

        # Clear Selection button
        btn_clear = QPushButton("Clear", self)
        btn_clear.setToolTip("Clear current selection")
        btn_clear.clicked.connect(partial(self.clear_selection, class_object, dialog, expected_table_name))
        self.layout.addWidget(btn_clear)

        # Add separator
        self.add_separator()

        return btn_select_all, btn_clear

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

    def get_expected_table_name(self, class_object: Any, table_object: str, selection_mode: GwSelectionMode):
        """
        Get the expected table name based on selection mode.
        
        Args:
            class_object: The class object
            table_object: The table object name
            selection_mode: The selection mode
            
        Returns:
            The expected table name
        """
        if selection_mode in (GwSelectionMode.LOT, GwSelectionMode.EXPRESSION_LOT):
            expected_table_name = f"tbl_campaign_{table_object}_x_{class_object.rel_feature_type}"
        elif selection_mode == GwSelectionMode.MINCUT_CONNEC:
            expected_table_name = f"tbl_{table_object}_{class_object.rel_feature_type}"
        else:
            expected_table_name = f"tbl_{table_object}_x_{class_object.rel_feature_type}"

        return expected_table_name

    # endregion utility functions

    # region menu btn_snapping

    def update_default_action(self, dialog: QDialog, action: QAction):
        """
        Update the default action for the snapping button.
        
        Args:
            dialog: The dialog containing the button
            action: The action to set as default
        """
        dialog.btn_snapping.setDefaultAction(action)

    def activate_selection_mode(self, class_object: Any, dialog: QDialog, table_object: str, selection_mode: GwSelectionMode, tool_type: str):
        """
        Activate selection snapping mode.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table object name
            selection_mode: The selection mode
            tool_type: The type of selection tool
        """
        tools_gw.add_icon(dialog.btn_snapping, "137")
        dialog.btn_snapping.clicked.connect(
            partial(tools_gw.selection_init, class_object, dialog, table_object, selection_mode, tool_type))
        tools_gw.selection_init(class_object, dialog, table_object, selection_mode, tool_type)

    def init_selection_btn(self, class_object: Any, dialog: QDialog, table_object: str, used_tools: list[str], selection_mode=GwSelectionMode.DEFAULT,
                        callback: Callable[[], bool] | None = None, callback_later: Callable = None):
        """
        Create snapping button with menu (split button behavior).
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table object name
            used_tools: List of tools to include
            selection_mode: The selection mode
            callback: Optional callback function
            callback_later: Optional callback to execute after selection
        """
        def handle_action(tool_type):
            if callback and callback() is False:
                return
            self.activate_selection_mode(class_object, dialog, table_object, selection_mode, tool_type)
            if callback_later:
                callback_later()

        # Action group to keep exclusivity
        tools = [("rectangle", "137.png"), ("polygon", "180.svg"), ("freehand", "182.svg"), ("circle", "181.svg"), ("point", "181.svg")]
        ag = QActionGroup(dialog)

        # Create actions for each tool type
        for tool_type, icon_path in tools:
            if tool_type in used_tools:
                icon_path = os.path.join(lib_vars.plugin_dir, "icons", "dialogs", icon_path)
                action = QAction(QIcon(icon_path), tool_type, dialog)
                action.setProperty('has_icon', True)
                action.triggered.connect(partial(handle_action, tool_type))
                ag.addAction(action)

        # Create menu with actions
        if len(used_tools) > 1:
            menu = QMenu(dialog)
            menu.addActions(ag.actions())

            # Configure QToolButton as split button
            dialog.btn_snapping.setPopupMode(QToolButton.MenuButtonPopup)  # left = default, arrow = menu
            dialog.btn_snapping.setMenu(menu)

            # Set initial default action
            dialog.btn_snapping.setDefaultAction(ag.actions()[0])

            # Connect menu triggered signal
            menu.triggered.connect(partial(self.update_default_action, dialog))

    # endregion menu btn_snapping

    # region activate highlight methods

    def highlight_features_method(self, class_object: Any, dialog: QDialog, expected_table_name: str, method: str):
        """
        Route to appropriate highlight method based on method string.
        
        Args:
            class_object: The class object
            dialog: The dialog
            expected_table_name: The table name
            method: The method to use ("all", "selected", "psector")
        """
        if method == "all":
            self.highlight_features_in_table(class_object, dialog, expected_table_name)
        elif method == "selected":
            self.highlight_features_selected_in_table(class_object, dialog, expected_table_name)
        elif method == "psector":
            self.highlight_features_psector_in_table(class_object, dialog, expected_table_name)

    def highlight_in_tab_changed(self, class_object: Any, dialog: QDialog, expected_table_name: str,
                                 parent_tab: QTabWidget, method: str):
        """
        Handle tab change events for highlighting features.
        
        Args:
            class_object: The class object
            dialog: The dialog
            expected_table_name: The table name
            parent_tab: The parent tab widget
            method: The highlight method to use
        """
        widget = parent_tab.widget(parent_tab.currentIndex())
        if widget.objectName() in ("tab_relations", "tab_features"):
            self.highlight_features_method(class_object, dialog, expected_table_name, method)
        else:
            tools_qgis.refresh_map_canvas()
            tools_gw.reset_rubberband(class_object.rubber_band)

    def highlight_in_table_changed(self, method: str, callback_values: Callable[[], tuple[Any, Any, Any]] | None = None):
        """
        Handle table change events for highlighting features.
        
        Args:
            method: The highlight method to use
            callback_values: Callback function that returns (class_object, dialog, expected_table_name)
        """
        class_object, dialog, expected_table_name = callback_values()
        self.highlight_features_method(class_object, dialog, expected_table_name, method)

    def init_highlight_features_methods(self, class_object: Any, dialog: QDialog, table_object: str,
                                            selection_mode: GwSelectionMode, method: str = "selected",
                                            callback_values: Callable[[], tuple[Any, Any, Any]] | None = None):
        """
        Initialize highlight features methods with tab change event handlers.
        
        Args:
            class_object: The class object
            dialog: The dialog
            table_object: The table object name
            selection_mode: The selection mode
            method: The highlight method
            callback_values: Optional callback function
        """
        # Setup tab change event handlers
        parent_tab = self.find_parent_tab(dialog.btn_snapping)
        expected_table_name = self.get_expected_table_name(class_object, table_object, selection_mode)
        widget_table = tools_qt.get_widget(dialog, expected_table_name)
        parent_tab_table = self.find_parent_tab(widget_table)

        if parent_tab_table:
            parent_tab_table.currentChanged.connect(partial(self.highlight_in_table_changed, method, callback_values))
        if parent_tab:
            parent_tab.currentChanged.connect(partial(self.highlight_in_tab_changed, class_object, dialog,
                                                      expected_table_name, parent_tab, method))

    # endregion activate highlight methods

    # region highlight features in table

    def highlight_features_selected_in_table(self, class_object: Any, dialog: QDialog, expected_table_name: str,
                                             connected_signal: bool = False):
        """
        Highlight features selected in table.
        
        Args:
            class_object: The class object
            dialog: The dialog
            expected_table_name: The table name
            connected_signal: Whether this is called from a connected signal
        """
        # Refresh map canvas and reset rubberband
        tools_qgis.refresh_map_canvas()
        tools_gw.reset_rubberband(class_object.rubber_band)

        # Get main variables
        widget_table = tools_qt.get_widget(dialog, expected_table_name)
        feature_type = class_object.rel_feature_type or expected_table_name.split('_')[-1]

        # Validate table and model
        if not widget_table or not widget_table.model().selectionModel() or not feature_type:
            return

        model = widget_table.model().selectionModel()
        if not model or model.selectedRows() == 0:
            tools_gw.remove_selection(layers=class_object.rel_layers)
            return

        # Get feature IDs from table
        id_column_name = f"{feature_type}_id"
        id_column_index = tools_qt.get_col_index_by_col_name(widget_table, id_column_name)
        if id_column_index == -1:
            return

        ids_to_select = [str(model.index(row, id_column_index).data()) for row in range(model.selectedRows())]

        if not ids_to_select:
            tools_gw.remove_selection(layers=class_object.rel_layers)
            return

        # Select features on map
        expr_filter = QgsExpression(f"{id_column_name} IN ({','.join(f'{i}' for i in ids_to_select)})")
        tools_qgis.select_features_by_ids(feature_type, expr_filter, class_object.rel_layers)

        if not connected_signal:
            model.selectionChanged.connect(partial(tools_qgis.highlight_features_selected_in_table,
                                                   class_object, dialog, expected_table_name, connected_signal=True))

    def highlight_features_psector_in_table(self, class_object: Any, dialog: QDialog, expected_table_name: str):
        """
        Highlight features psector in table.
        
        Args:
            class_object: The class object
            dialog: The dialog
            expected_table_name: The table name
        """
        # Refresh map canvas and reset rubberband
        tools_qgis.refresh_map_canvas()
        tools_gw.reset_rubberband(class_object.rubber_band)

    def highlight_features_in_table(self, class_object: Any, dialog: QDialog, expected_table_name: str):
        """
        Selects all features on the map that are currently listed in the given table widget.
        
        Args:
            class_object: The class object
            dialog: The dialog
            expected_table_name: The table name
        """
        # Get main variables
        widget_table = tools_qt.get_widget(dialog, expected_table_name)
        feature_type = class_object.rel_feature_type or expected_table_name.split('_')[-1]

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
        tools_qgis.highlight_features_selected_in_table(class_object, dialog, expected_table_name, feature_type)

    # endregion highlight features in table

    # region selection operations

    def select_all_features(self, class_object: Any, dialog: QDialog, expected_table_name: str):
        """
        Select all features in the table.
        
        Args:
            class_object: The class object
            dialog: The dialog
            expected_table_name: The table name
        """
        widget_table = tools_qt.get_widget(dialog, expected_table_name)
        if not widget_table or not widget_table.model():
            return

        selection_model = widget_table.selectionModel()
        if not selection_model:
            return

        # Select all rows
        for row in range(widget_table.model().rowCount()):
            index = widget_table.model().index(row, 0)
            selection_model.select(index, selection_model.Select | selection_model.Rows)

        # Highlight the selected features
        self.highlight_features_in_table(class_object, dialog, expected_table_name)

    def clear_selection(self, class_object: Any, dialog: QDialog, expected_table_name: str):
        """
        Clear current selection in the table.
        
        Args:
            class_object: The class object
            dialog: The dialog
            expected_table_name: The table name
        """
        widget_table = tools_qt.get_widget(dialog, expected_table_name)
        if not widget_table or not widget_table.selectionModel():
            return

        # Clear selection
        widget_table.selectionModel().clearSelection()

        # Remove selection from map
        tools_gw.remove_selection(layers=class_object.rel_layers)
        tools_qgis.refresh_map_canvas()
        tools_gw.reset_rubberband(class_object.rubber_band)

    # endregion selection operations

    # region invert selection

    def init_invert_selection(self, class_object: Any, dialog: QDialog, expected_table_name: str):
        """
        Initialize invert selection functionality.
        
        Args:
            class_object: The class object
            dialog: The dialog
            expected_table_name: The table name
        """
        # Create invert selection button
        btn_invert = QPushButton("Invert Selection", self)
        btn_invert.setToolTip("Invert the current selection in the table")
        self.layout.addWidget(btn_invert)

        # Connect button click to invert selection logic
        btn_invert.clicked.connect(partial(self.invert_table_selection, class_object, dialog, expected_table_name))

    def invert_table_selection(self, class_object: Any, dialog: QDialog, expected_table_name: str):
        """
        Invert the current selection in the table.
        
        Args:
            class_object: The class object
            dialog: The dialog
            expected_table_name: The table name
        """
        widget_table = tools_qt.get_widget(dialog, expected_table_name)
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
        self.highlight_features_selected_in_table(class_object, dialog, expected_table_name)

    # endregion invert selection
