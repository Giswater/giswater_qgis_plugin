"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtWidgets import QMenu, QAction, QActionGroup
from qgis.core import QgsFeatureRequest

from ..maptool import GwMaptool
from ...shared.catalog import GwCatalog
from ...shared.info import GwInfo
from ...ui.ui_manager import GwFeatureTypeChangeUi
from ...utils import tools_gw
from ....libs import tools_qgis, tools_qt, tools_db
from .... import global_vars
from qgis.PyQt.QtWidgets import QAction, QAbstractItemView, QCheckBox, QComboBox, QCompleter, QDoubleSpinBox, \
    QDateEdit, QGridLayout, QLabel, QLineEdit, QListWidget, QListWidgetItem, QPushButton, QSizePolicy, \
    QSpinBox, QSpacerItem, QTableView, QTabWidget, QWidget, QTextEdit, QRadioButton, QToolBox

class GwFeatureTypeChangeButton(GwMaptool):
    """ Button 28: Change feature type
    User select from drop-down button feature type: ARC, NODE, CONNEC.
    Snap to this feature type is activated.
    User selects a feature of that type from the map.
    A form is opened showing current feature_type.type and combos to replace it
    """

    def __init__(self, icon_path, action_name, text, toolbar, action_group, icon_type=1, actions=None, list_tables=None):

        super().__init__(icon_path, action_name, text, toolbar, action_group, icon_type)
        self.project_type = None
        self.feature_type = None
        self.tablename = None
        self.cat_table = None
        self.feature_edit_type = None
        self.feature_type_cat = None
        self.feature_id = None
        self.actions = actions
        if not self.actions:
            self.actions = ['ARC', 'NODE', 'CONNEC']
        self.list_tables = list_tables
        if not self.list_tables:
            self.list_tables = ['v_edit_arc', 'v_edit_node', 'v_edit_connec', 'v_edit_gully']

        # Create a menu and add all the actions
        if toolbar is not None:
            toolbar.removeAction(self.action)

        self.menu = QMenu()
        self.menu.setObjectName("GW_change_menu")
        self._fill_change_menu()

        if toolbar is not None:
            self.action.setMenu(self.menu)
            toolbar.addAction(self.action)


    # region QgsMapTools inherited
    """ QgsMapTools inherited event functions """

    def activate(self):

        self.project_type = tools_gw.get_project_type()

        # Check action. It works if is selected from toolbar. Not working if is selected from menu or shortcut keys
        if hasattr(self.action, "setChecked"):
            self.action.setChecked(True)

        # Store user snapping configuration
        self.previous_snapping = self.snapper_manager.get_snapping_options()

        # Set snapping to 'node', 'connec' and 'gully'
        self.snapper_manager.set_snapping_layers()

        # Manage last feature type selected
        last_feature_type = tools_gw.get_config_parser("btn_featuretype_change", "last_feature_type", "user", "session")
        if last_feature_type is None:
            last_feature_type = "NODE"

        # Manage active layer
        self._set_active_layer(last_feature_type)
        layer = self.iface.activeLayer()
        tablename = tools_qgis.get_layer_source_table_name(layer)
        if tablename not in self.list_tables:
            self._set_active_layer(last_feature_type)

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Click on feature to change its type"
            tools_qgis.show_info(message)


    def canvasMoveEvent(self, event):

        # Hide marker and get coordinates
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(event)

        # Snapping layers 'v_edit_'
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if result.isValid():
            layer = self.snapper_manager.get_snapped_layer(result)
            tablename = tools_qgis.get_layer_source_table_name(layer)
            if tablename and 'v_edit' in tablename:
                self.snapper_manager.add_marker(result, self.vertex_marker)


    def canvasReleaseEvent(self, event):

        self._featuretype_change(event)


    # endregion


    # region private functions

    def _fill_change_menu(self):
        """ Fill change feature type menu """

        # disconnect and remove previuos signals and actions
        actions = self.menu.actions()
        for action in actions:
            action.disconnect()
            self.menu.removeAction(action)
            del action
        ag = QActionGroup(self.iface.mainWindow())

        if global_vars.project_type.lower() == 'ud':
            self.actions.append('GULLY')

        for action in self.actions:
            obj_action = QAction(f"{action}", ag)
            self.menu.addAction(obj_action)
            obj_action.triggered.connect(partial(super().clicked_event))
            obj_action.triggered.connect(partial(self._set_active_layer, action))
            obj_action.triggered.connect(partial(tools_gw.set_config_parser, section="btn_featuretype_change",
                                                 parameter="last_feature_type", value=action, comment=None))


    def _set_active_layer(self, name):
        """ Sets the active layer according to the name parameter (ARC, NODE, CONNEC, GULLY) """

        layers = {"ARC": "v_edit_arc", "NODE": "v_edit_node",
                  "CONNEC": "v_edit_connec", "GULLY": "v_edit_gully"}
        tablename = layers.get(name.upper())
        self.current_layer = tools_qgis.get_layer_by_tablename(tablename)
        self.iface.setActiveLayer(self.current_layer)

    def _open_custom_form(self, layer, expr):
        """ Open custom from selected layer """

        it = layer.getFeatures(QgsFeatureRequest(expr))
        features = [i for i in it]
        if features[0]:
            self.customForm = GwInfo('data')
            self.customForm.user_current_layer = self.current_layer
            feature_id = features[0][f"{self.feature_type}_id"]
            complet_result, dialog = self.customForm.get_info_from_id(self.tablename, feature_id, 'data')
            if not complet_result:
                return

            dialog.dlg_closed.connect(partial(tools_qgis.restore_user_layer, self.tablename))


    def _open_dialog(self):
        """ Open Feature Change Dialog dynamic """

        feature = f'"tableName":"{self.tablename}", "id":"{self.feature_id}"'
        body = tools_gw.create_body(feature = feature)
        json_result = tools_gw.execute_procedure('gw_fct_getfeaturereplace', body)
        self.dlg_change = GwFeatureTypeChangeUi(self)
        tools_gw.load_settings(self.dlg_change)
        self._manage_dlg_widgets(self.dlg_change, json_result)
        tools_gw.open_dialog(self.dlg_change, 'featuretype_change')


    def _manage_dlg_widgets(self, dialog,complet_result):
        """ Creates and populates all the widgets """

        layout_list = []
        widget_offset = 0
        prev_layout = ""
        for field in complet_result['body']['data']['fields']:
            if field.get('hidden'):
                continue

            if field['widgettype'] is "button":
                continue

            if field.get('widgetcontrols') and field['widgetcontrols'].get('hiddenWhenNull') \
                    and field.get('value') in (None, ''):
                continue
            label, widget = tools_gw.set_widgets(dialog, complet_result, field, self.tablename, self)
            if widget is None:
                continue

            layout = dialog.findChild(QGridLayout, field['layoutname'])
            if layout is not None:
                if layout.objectName() != prev_layout:
                    widget_offset = 0
                    prev_layout = layout.objectName()
                # Take the QGridLayout with the intention of adding a QSpacerItem later
                if layout not in layout_list and layout.objectName() in ('lyt_main_1', 'lyt_main_2', 'lyt_main_3','lyt_buttons'):
                    layout_list.append(layout)

                if field['layoutorder'] is None:
                    message = "The field layoutorder is not configured for"
                    msg = f"formname:{self.tablename}, columnname:{field['columnname']}"
                    tools_qgis.show_message(message, 2, parameter=msg, dialog=dialog)
                    continue

                # Manage widget and label positions
                label_pos = field['widgetcontrols']['labelPosition'] if (
                            'widgetcontrols' in field and field['widgetcontrols'] and 'labelPosition' in field[
                             'widgetcontrols']) else None
                widget_pos = field['layoutorder'] + widget_offset

                # The data tab is somewhat special (it has 2 columns)
                if 'lyt_data' in layout.objectName() or 'lyt_epa_data' in layout.objectName():
                    tools_gw.add_widget(dialog, field, label, widget)
                # If the widget has a label
                elif label:
                    # If it has a labelPosition configured
                    if label_pos is not None:
                        if label_pos == 'top':
                            layout.addWidget(label, 0, widget_pos)
                            if type(widget) is QSpacerItem:
                                layout.addItem(widget, 1, widget_pos)
                            else:
                                layout.addWidget(widget, 1, widget_pos)
                        elif label_pos == 'left':
                            layout.addWidget(label, 0, widget_pos)
                            if type(widget) is QSpacerItem:
                                layout.addItem(widget, 0, widget_pos + 1)
                            else:
                                layout.addWidget(widget, 0, widget_pos + 1)
                            widget_offset += 1
                        else:
                            if type(widget) is QSpacerItem:
                                layout.addItem(widget, 0, widget_pos)
                            else:
                                layout.addWidget(widget, 0, widget_pos)
                    # If widget has label but labelPosition is not configured (put it on the left by default)
                    else:
                        layout.addWidget(label, 0, widget_pos)
                        if type(widget) is QSpacerItem:
                            layout.addItem(widget, 0, widget_pos + 1)
                        else:
                            layout.addWidget(widget, 0, widget_pos + 1)
                # If the widget has no label
                else:
                    if type(widget) is QSpacerItem:
                        layout.addItem(widget, 0, widget_pos)
                    else:
                        layout.addWidget(widget, 0, widget_pos)


    def _featuretype_change(self, event):

        if event.button() == Qt.RightButton:
            self.cancel_map_tool()
            return

        # Get snapped feature
        event_point = self.snapper_manager.get_event_point(event)
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if not result.isValid():
            return

        snapped_feat = self.snapper_manager.get_snapped_feature(result)
        if snapped_feat is None:
            return

        layer = self.snapper_manager.get_snapped_layer(result)
        tablename = tools_qgis.get_layer_source_table_name(layer)
        if tablename and 'v_edit' in tablename:
            if tablename == 'v_edit_node':
                self.feature_type = 'node'
            elif tablename == 'v_edit_connec':
                self.feature_type = 'connec'
            elif tablename == 'v_edit_gully':
                self.feature_type = 'gully'
            elif tablename == 'v_edit_arc':
                self.feature_type = 'arc'

        self.tablename = tablename
        self.cat_table = f'cat_{self.feature_type}'
        if self.feature_type == 'gully':
            self.cat_table = f'cat_grate'
        self.feature_edit_type = f'{self.feature_type}_type'
        self.feature_type_cat = f'{self.feature_type}type_id'
        self.feature_id = snapped_feat.attribute(f'{self.feature_type}_id')
        self._open_dialog()
    # endregion


def btn_cancel_featuretype_change(**kwargs):
    """ Close form """

    dialog = kwargs["dialog"]
    tools_gw.close_dialog(dialog)


def btn_accept_featuretype_change(**kwargs):
    """ Update current type of feature and save changes in database """

    this = kwargs["class"]
    dialog = kwargs["dialog"]

    project_type = tools_gw.get_project_type()
    feature_type_new = tools_qt.get_widget_value(dialog, "tab_none_feature_type_new")
    featurecat_id = tools_qt.get_widget_value(dialog, "tab_none_featurecat_id")

    if feature_type_new != "null":

        if (featurecat_id != "null" and featurecat_id is not None and project_type == 'ws') or (
                project_type == 'ud'):

            # Get function input parameters
            feature = f'"type":"{this.feature_type}"'
            extras = f'"feature_id":"{this.feature_id}"'
            extras += f', "feature_type_new":"{feature_type_new}"'
            extras += f', "featurecat_id":"{featurecat_id}"'
            body = tools_gw.create_body(feature=feature, extras=extras)

            # Execute SQL function and show result to the user
            complet_result = tools_gw.execute_procedure('gw_fct_setchangefeaturetype', body)
            if not complet_result:
                message = "Error replacing feature"
                tools_qgis.show_warning(message)
                # Check in init config file if user wants to keep map tool active or not
                this.manage_active_maptool()
                tools_gw.close_dialog(dialog)
                return

            tools_gw.set_config_parser("btn_featuretype_change", "feature_type_new", feature_type_new)
            tools_gw.set_config_parser("btn_featuretype_change", "featurecat_id", featurecat_id)
            message = "Values has been updated"
            tools_qgis.show_info(message)

        else:
            message = "Field catalog_id required!"
            tools_qgis.show_warning(message, dialog=dialog)
            return

    else:
        message = "Feature has not been updated because no catalog has been selected"
        tools_qgis.show_warning(message)

    # Close form
    tools_gw.close_dialog(dialog)

    # Refresh map canvas
    this.refresh_map_canvas()

    # Check if the expression is valid
    expr_filter = f"{this.feature_type}_id = '{this.feature_id}'"
    (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)  # @UnusedVariable
    if not is_valid:
        return

    # Check in init config file if user wants to keep map tool active or not
    this.manage_active_maptool()


def btn_catalog_featuretype_change(**kwargs):
    """ Open Catalog form """

    dialog = kwargs["dialog"]
    this = kwargs["class"]

    # Get feature_type
    child_type = tools_qt.get_text(dialog, "tab_none_feature_type_new")
    if child_type == 'null':
        msg = "New feature type is null. Please, select a valid value"
        tools_qt.show_info_box(msg, "Info")
        return

    this.catalog = GwCatalog()
    this.catalog.open_catalog(dialog, 'tab_none_featurecat_id', this.feature_type, child_type)


def cmb_new_featuretype_selection_changed(**kwargs):
    """ When new featuretype change, catalog_id changes as well """

    dialog = kwargs["dialog"]
    cmb_new_feature_type = kwargs["widget"]
    this = kwargs["class"]
    cmb_catalog_id = tools_qt.get_widget(dialog,"tab_none_featurecat_id")

    # Populate catalog_id
    feature_type_new = tools_qt.get_widget_value(dialog, cmb_new_feature_type)
    sql = (f"SELECT DISTINCT(id), id as idval "
            f"FROM {this.cat_table} "
            f"WHERE {this.feature_type}type_id = '{feature_type_new}' AND (active IS TRUE OR active IS NULL) "
            f"ORDER BY id")
    rows = tools_db.get_rows(sql)
    tools_qt.fill_combo_values(cmb_catalog_id, rows)