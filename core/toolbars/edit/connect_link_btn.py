"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from enum import Enum

from qgis.PyQt.QtCore import QRect, Qt
from qgis.PyQt.QtWidgets import QApplication, QActionGroup, QWidget, QAction, QMenu
from qgis.core import QgsVectorLayer, QgsRectangle, QgsApplication, QgsFeatureRequest

from ..maptool import GwMaptool
from ...utils import tools_gw
from ....libs import tools_qgis, tools_qt, tools_db
from ...threads.connect_link import GwConnectLink
from ...ui.ui_manager import GwConnectLinkUi


class SelectAction(Enum):
    CONNEC_LINK = tools_qt.tr('Connec to network')
    GULLY_LINK = tools_qt.tr('Gully to network')


class GwConnectLinkButton(GwMaptool):
    """ Button 27: Connect Link
    User select connections from layer 'connec'
    Execute SQL function: 'gw_fct_setlinktonetwork ' """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.dragging = False
        self.select_rect = QRect()
        self.project_type = tools_gw.get_project_type()

        # Check project type
        if self.project_type != 'ws':
            # Create a dropdown menu
            self.menu = QMenu()

            # Fill the menu
            self._fill_action_menu()

            # Add menu to toolbar
            if toolbar is not None and self.action is not None:
                self.action.setMenu(self.menu)
                toolbar.addAction(self.action)

    def clicked_event(self):
        """ Event when button is clicked """

        if self.project_type == 'ws':
            self.feature_type = 'connec'
            self.open_dlg()

    def open_dlg(self):
        """ Open connect link dialog """

        # Create form and body
        form = {"formName": "generic", "formType": f"link_to_{self.feature_type}"}
        body = {"client": {"cur_user": tools_db.current_user}, "form": form}

        # Execute procedure
        json_result = tools_gw.execute_procedure('gw_fct_get_dialog', body)

        # Create dialog
        self.dlg_connect_link = GwConnectLinkUi(self)
        tools_gw.load_settings(self.dlg_connect_link)
        tools_gw.manage_dlg_widgets(self, self.dlg_connect_link, json_result)

        # Get dynamic widgets
        self.txt_id = self.dlg_connect_link.findChild(QWidget, "tab_none_id")
        self.pipe_diameter = self.dlg_connect_link.findChild(QWidget, "tab_none_pipe_diameter")
        self.max_distance = self.dlg_connect_link.findChild(QWidget, "tab_none_max_distance")
        self.tbl_ids = self.dlg_connect_link.findChild(QWidget, "tab_none_tbl_ids")

        # Set combo ids editable
        self.txt_id.setEditable(True)

        # Add headers to table
        tools_gw.add_tableview_header(self.tbl_ids, json_headers=[{'header': f'{self.feature_type}_id'}])

        # Connect signal when dialog is rejected
        self.dlg_connect_link.rejected.connect(lambda: close(**{'class': self, 'dialog': self.dlg_connect_link}))

        # Set window title from dialog depending of the current feature
        self.dlg_connect_link.setWindowTitle(tools_qt.tr(f"{self.feature_type.capitalize()} to link"))

        # Open dialog
        tools_gw.open_dialog(self.dlg_connect_link, 'connect_link')


    def fill_tbl_ids(self, layer):
        """ Fill table with selected features """

        # Initialize field variable
        field = {"value": []}

        # Loop througth canvas selected features
        for connec_feature in layer.selectedFeatures():

            # Build object with feature selected
            selected_feature = {f"{self.feature_type}_id": connec_feature.attribute(f"{self.feature_type}_id")}

            # Add built object to the list
            field["value"].append(selected_feature)

        # Clear previous table rows
        self.tbl_ids.model().removeRows(0, self.tbl_ids.model().rowCount())

        # Fill table with selected features
        tools_gw.fill_tableview_rows(self.tbl_ids, field)

    def _fill_action_menu(self):
        """Fill the dropdown menu with actions."""

        # Disconnect and remove previous signals and actions
        for action in self.menu.actions():
            action.disconnect()  # Disconnect signals
            self.menu.removeAction(action)  # Remove from menu

        # Create actions for the menu
        ag = QActionGroup(self.iface.mainWindow())
        for action in SelectAction:
            # Use `action.value` for user-friendly labels
            obj_action = QAction(action.value, ag)
            self.menu.addAction(obj_action)
            # connect signal
            obj_action.triggered.connect(self._action_triggered)

    def _action_triggered(self):
        """ Action triggered event """

        # Get the action that was triggered
        action = self.sender()

        # Check if the action is valid
        if action is None:
            return

        # Get the selected action from the menu
        selected_action = SelectAction(action.text())

        # Open dialog based on selected action
        self.feature_type = 'connec' if selected_action == SelectAction.CONNEC_LINK else 'gully'
        self.open_dlg()

    """ QgsMapTools inherited event functions """

    def activate(self):
        """ Activate map tool """

        # Rubber band
        tools_gw.reset_rubberband(self.rubber_band)

        # Store user snapping configuration
        self.previous_snapping = self.snapper_manager.get_snapping_options()

        # Change cursor
        cursor = tools_gw.get_cursor_multiple_selection()
        self.canvas.setCursor(cursor)

        # Show help message when action is activated
        if self.show_help:
            msg = ("Select connecs or gullies with qgis tool and use right click to connect them with network. "
                      "CTRL + SHIFT over selection to remove it")
            tools_qgis.show_info(msg, duration=9)

    def canvasMoveEvent(self, event):
        """ With left click the digitizing is finished """

        if event.buttons() == Qt.LeftButton:

            if not self.dragging:
                self.dragging = True
                self.select_rect.setTopLeft(event.pos())

            self.select_rect.setBottomRight(event.pos())
            self._set_rubber_band()

    def canvasPressEvent(self, event):

        self.select_rect.setRect(0, 0, 0, 0)
        tools_gw.reset_rubberband(self.rubber_band, "polygon")

    def canvasReleaseEvent(self, event):
        """ With left click the digitizing is finished """

        # Manage if task is already running
        if hasattr(self, 'connect_link_task') and self.connect_link_task is not None:
            try:
                if self.connect_link_task.isActive():
                    msg = "Connect link task is already active!"
                    tools_qgis.show_warning(msg)
                    return
            except RuntimeError:
                pass

        if event.button() == Qt.LeftButton:

            # Set valid values for rectangle's width and height
            if self.select_rect.width() == 1:
                self.select_rect.setLeft(self.select_rect.left() + 1)

            if self.select_rect.height() == 1:
                self.select_rect.setBottom(self.select_rect.bottom() + 1)

            self._set_rubber_band()
            self._select_multiple_features(self.selected_rectangle)
            self.dragging = False

            # Refresh map canvas
            tools_gw.reset_rubberband(self.rubber_band)

            # Force reload dataProvider of layer
            tools_qgis.set_layer_index('ve_link')
            tools_qgis.set_layer_index('ve_vnode')

    def manage_result(self, result):

        if result and result['status'] != 'Failed':
            tools_gw.fill_tab_log(self.dlg_connect_link, result['body']['data'])
        else:
            msg = "gw_fct_setlinktonetwork (Check log messages)"
            tools_qgis.show_warning(msg, title='Function error')

        # Remove selection from layers
        tools_gw.remove_selection()
        
        # Refresh map canvas
        tools_gw.reset_rubberband(self.rubber_band)
        self.refresh_map_canvas()
        self.iface.actionPan().trigger()

        # Force reload dataProvider of layer
        tools_qgis.set_layer_index('ve_link')
        tools_qgis.set_layer_index('ve_vnode')

    # endregion

    # region private functions

    def _set_rubber_band(self):

        # Coordinates transform
        transform = self.canvas.getCoordinateTransform()

        # Coordinates
        ll = transform.toMapCoordinates(self.select_rect.left(), self.select_rect.bottom())
        lr = transform.toMapCoordinates(self.select_rect.right(), self.select_rect.bottom())
        ul = transform.toMapCoordinates(self.select_rect.left(), self.select_rect.top())
        ur = transform.toMapCoordinates(self.select_rect.right(), self.select_rect.top())

        # Rubber band
        tools_gw.reset_rubberband(self.rubber_band, "polygon")
        self.rubber_band.addPoint(ll, False)
        self.rubber_band.addPoint(lr, False)
        self.rubber_band.addPoint(ur, False)
        self.rubber_band.addPoint(ul, False)
        self.rubber_band.addPoint(ll, True)

        self.selected_rectangle = QgsRectangle(ll, ur)

    def _select_multiple_features(self, select_geometry):
        """ Select multiple features on canvas """

        #TODO: Create button add_forced_arcs and manage selection with arcs

        # Get pressed keys on keyboard
        key = QApplication.keyboardModifiers()

        # Set behaviour depending of the pressed keys on keyboard
        behaviour = QgsVectorLayer.RemoveFromSelection if key == (Qt.ControlModifier | Qt.ShiftModifier) else QgsVectorLayer.AddToSelection

        # Get current feature layer (connec/gully)
        layer = tools_qgis.get_layer_by_tablename(f've_{self.feature_type}')

        # Check if layer exists
        if layer:

            # Select/Unselect features of the selected geometry
            layer.selectByRect(select_geometry, behaviour)

            # Refresh table
            self.fill_tbl_ids(layer)

    def _selection_init(self):
        """ Initialize selection mode """

        self.iface.actionSelect().trigger()

    def _selection_end(self):
        """ Process selected features """

        # Get current feature layer (connec/gully)
        layer = tools_qgis.get_layer_by_tablename(f've_{self.feature_type}')

        # Refresh table
        self.fill_tbl_ids(layer)
        self.iface.actionPan().trigger()

    # endregion


def add(**kwargs):
    """ Add button clicked event """

    # Get class
    this = kwargs['class']

    # Get selected id
    selected_id = tools_qt.get_combo_value(this.dlg_connect_link, "tab_none_id")

    # Check if selected id is not empty
    if selected_id is None or selected_id == '':
        message = "Please select a feature to add"
        tools_qgis.show_warning(message, title='Connect to network')
        return

    # Create expression filter
    expr_filter = f"{this.feature_type}_id = '{selected_id}'"
    is_valid, expr = tools_qt.check_expression_filter(expr_filter)

    # Get layer from feature
    layer = tools_qgis.get_layer_by_tablename(f've_{this.feature_type}')

    # Check if layer exists and expression is valid
    if layer and is_valid:

        # Get all selected features in canvas + the new current selected feature
        features = layer.selectedFeatures() + list(layer.getFeatures(QgsFeatureRequest(expr)))
        id_list = [feature.id() for feature in features]

        # Show selected ids in canvas
        layer.selectByIds(id_list)

    # Refresh table
    this.fill_tbl_ids(layer)


def remove(**kwargs):
    """ Remove button clicked event - Remove selected rows from table """

    # Get class
    this = kwargs['class']

    try:
        # Get the table model and selection model
        model = this.tbl_ids.model()
        selection_model = this.tbl_ids.selectionModel()
        
        if not model or not selection_model:
            return
            
        # Get selected rows
        selected_rows = selection_model.selectedRows()
        
        if not selected_rows:
            message = "Please select rows to remove from the table"
            tools_qgis.show_warning(message, title='Connect to network')
            return
        
        # Get IDs from selected rows
        selected_ids = []
        for index in selected_rows:
            item = model.item(index.row(), 0)  # Get the first column
            if item and item.text():
                selected_ids.append(item.text())
        
        if not selected_ids:
            return
            
        # Remove selected rows from the model
        # We need to remove rows in reverse order to avoid index issues
        rows_to_remove = sorted([index.row() for index in selected_rows], reverse=True)
        for row in rows_to_remove:
            model.removeRow(row)
        
        # Clear any selection in the combo box
        tools_qt.set_widget_text(this.dlg_connect_link, "tab_none_id", "")
        
        # Update canvas selection to show only remaining items in the table
        layer = tools_qgis.get_layer_by_tablename(f've_{this.feature_type}')
        if layer:
            # Get remaining IDs from the table
            remaining_ids = []
            for row in range(model.rowCount()):
                item = model.item(row, 0)
                if item and item.text():
                    remaining_ids.append(int(item.text()))
            
            # Clear current selection and select only remaining features
            layer.removeSelection()
            if remaining_ids:
                # Create expression to select remaining features
                expr_filter = f"{this.feature_type}_id IN ({','.join(map(str, remaining_ids))})"
                is_valid, expr = tools_qt.check_expression_filter(expr_filter)
                if is_valid:
                    layer.selectByExpression(expr_filter)  # Use expr_filter (string) instead of expr (QgsExpression)
            
            # Refresh the layer to show updated selection
            layer.triggerRepaint()
        
        # Show success message
        removed_count = len(selected_ids)
        tools_qgis.show_info(f"{removed_count} item(s) removed from the list: {', '.join(selected_ids)}")
            
    except Exception as e:
        tools_qgis.show_warning(f"Error removing items: {str(e)}")
        tools_gw.log_info(f"Error in remove function: {str(e)}")


def accept(**kwargs):
    """ Accept button clicked event """

    # Get class
    this = kwargs['class']

    # Get selected linkcat
    this.linkcat = tools_qt.get_combo_value(this.dlg_connect_link, "tab_none_linkcat")

    # Check input values
    if this.pipe_diameter.text() == '' or this.max_distance.text() == '' or this.linkcat == '':
        message = "Please fill all fields in the dialog"
        tools_qgis.show_warning(message, title='Connect to network', dialog=this.dlg_connect_link)
        return

    # Get arc layer
    layer_arc = tools_qgis.get_layer_by_tablename('ve_arc')
    selected_arc = None

    # Check if the layer is valid and has selected arc
    if layer_arc and layer_arc.selectedFeatureCount() > 0:
        selected_arc_feature = layer_arc.selectedFeatures()[0]  # Use the first selected arc
        selected_arc = selected_arc_feature.attribute("arc_id")

    # Initialize an empty list
    this.ids = []
    model = this.tbl_ids.model()

    # Check if table is empty
    if model.rowCount() == 0:
        message = "Please select a feature to add"
        tools_qgis.show_warning(message, title='Connect to network', dialog=this.dlg_connect_link)
        return

    # Loop throught table rows
    for row in range(model.rowCount()):
        item = model.item(row, 0)  # Get the row and the first column (0)
        if item is not None:
            this.ids.append(int(item.text()))

    # Create connect link task
    this.connect_link_task = GwConnectLink("Connect link", this, this.feature_type, selected_arc=selected_arc)

    # Add and trigger the task
    QgsApplication.taskManager().addTask(this.connect_link_task)
    QgsApplication.taskManager().triggerTask(this.connect_link_task)

    # Remove selection from layers before canceling map tool
    tools_gw.remove_selection()
    
    # Cancel map tool if no features are selected or the layer is not visible
    this.cancel_map_tool()


def snapping(**kwargs):
    """ Accept button clicked event """

    GwMaptool.clicked_event(kwargs['class'])


def close(**kwargs):
    """ Close button clicked event """

    # Get class
    this = kwargs['class']
    
    # Remove selection from layers before canceling map tool
    tools_gw.remove_selection()
    
    # Cancel map tool
    this.cancel_map_tool()
    
    # Close dialog
    tools_gw.close_dialog(kwargs['dialog'])


def filter_expression(**kwargs):
    """Select features by expression for mapzone config"""

    # Get class
    this = kwargs['class']

    # Get current layer and feature type
    layer_name = f've_{this.feature_type}'

    layer = tools_qgis.get_layer_by_tablename(layer_name)
    if not layer:
        return

    # Set active layer
    this.iface.setActiveLayer(layer)
    tools_qgis.set_layer_visible(layer)

    # Show expression dialog
    tools_gw.select_with_expression_dialog_custom(
        this,
        this.dlg_connect_link,
        None,  # No table object needed for expression selection
        layer_name,
        this._selection_init,
        this._selection_end
    )
