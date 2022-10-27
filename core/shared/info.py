"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: latin-1 -*-
import json
import os
import re
import urllib.parse as parse
import webbrowser
from functools import partial

from sip import isdeleted

from qgis.PyQt.QtCore import pyqtSignal, QDate, QObject, QRegExp, QStringListModel, Qt, QSettings
from qgis.PyQt.QtGui import QColor, QRegExpValidator, QStandardItem, QStandardItemModel
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QAction, QAbstractItemView, QCheckBox, QComboBox, QCompleter, QDoubleSpinBox, \
    QDateEdit, QGridLayout, QLabel, QLineEdit, QListWidget, QListWidgetItem, QPushButton, QSizePolicy, \
    QSpinBox, QSpacerItem, QTableView, QTabWidget, QWidget, QTextEdit, QRadioButton
from qgis.core import QgsApplication, QgsMapToPixel, QgsVectorLayer, QgsExpression, QgsFeatureRequest, QgsPointXY, QgsProject
from qgis.gui import QgsDateTimeEdit, QgsMapToolEmitPoint

from .catalog import GwCatalog
from .dimensioning import GwDimensioning
from .document import GwDocument
from .element import GwElement
from .visit_gallery import GwVisitGallery
from .visit import GwVisit
from ..threads.toggle_valve_state import GwToggleValveTask
from ..utils import tools_gw
from ..utils.snap_manager import GwSnapManager
from ..ui.ui_manager import GwInfoGenericUi, GwInfoFeatureUi, GwVisitEventFullUi, GwMainWindow, GwVisitDocumentUi, GwInfoCrossectUi, \
    GwInterpolate
from ... import global_vars
from ...lib import tools_qgis, tools_qt, tools_log, tools_db, tools_os
from ...lib.tools_qt import GwHyperLinkLineEdit

global is_inserting
is_inserting = False


class GwInfo(QObject):

    # :var signal_activate: emitted from def cancel_snapping_tool(self, dialog, action) in order to re-start CadInfo
    signal_activate = pyqtSignal()

    def __init__(self, tab_type):

        super().__init__()

        self.iface = global_vars.iface
        self.settings = global_vars.giswater_settings
        self.plugin_dir = global_vars.plugin_dir
        self.canvas = global_vars.canvas
        self.schema_name = global_vars.schema_name

        self.new_feature_id = None
        self.layer_new_feature = None
        self.tab_type = tab_type
        self.connected = False
        self.rubber_band = tools_gw.create_rubberband(self.canvas, 0)
        self.snapper_manager = GwSnapManager(self.iface)
        self.snapper_manager.set_snapping_layers()
        self.suppres_form = None
        self.prev_action = None
        self.previous_map_tool = None


    def get_info_from_coordinates(self, point, tab_type):
        return self.open_form(point=point, tab_type=tab_type)


    def get_info_from_id(self, table_name, feature_id, tab_type=None, is_add_schema=None):
        return self.open_form(table_name=table_name, feature_id=feature_id, tab_type=tab_type, is_add_schema=is_add_schema)


    def open_form(self, point=None, table_name=None, feature_id=None, feature_cat=None, new_feature_id=None,
                  layer_new_feature=None, tab_type=None, new_feature=None, is_docker=True, is_add_schema=False):
        """
        :param point: point where use clicked
        :param table_name: table where do sql query
        :param feature_id: id of feature to do info
        :return:
        """

        try:
            # Manage tab signal
            self.tab_element_loaded = False
            self.tab_relations_loaded = False
            self.tab_connections_loaded = False
            self.tab_hydrometer_loaded = False
            self.tab_hydrometer_val_loaded = False
            self.tab_visit_loaded = False
            self.tab_event_loaded = False
            self.tab_document_loaded = False
            self.tab_rpt_loaded = False
            self.tab_plan_loaded = False
            self.dlg_is_destroyed = False
            self.layer = None
            self.feature = None
            self.my_json = {}
            # Note about self.my_json: this variable is passed to tools_gw.get_values via connected signals.
            # If it's reassigned after connecting the signal, it will most likely get a new position in memory, but
            # the self.my_json variable passed to the signal will be pointing to the original self.my_json.
            # For example, if we do this:
            #     self.my_json = {'test1': 'test1'}
            #     widget.signal.connect(partial(tools_gw.get_values, self.my_json))
            #     self.my_json = {}
            #     widget.signal.trigger()
            # Now tools_gw.get_values() will read self.my_json as {'test1': 'test1'}
            # So to clear the dictionary do this:
            #     self.my_json.clear()
            self.tab_type = tab_type

            # Get project variables
            qgis_project_add_schema = global_vars.project_vars['add_schema']
            qgis_project_main_schema = global_vars.project_vars['main_schema']
            qgis_project_role = global_vars.project_vars['project_role']

            self.new_feature = new_feature

            # Check for query layer and/or bad layer
            if not tools_qgis.check_query_layer(self.iface.activeLayer()) or self.iface.activeLayer() is None or \
                    type(self.iface.activeLayer()) != QgsVectorLayer:
                active_layer = ""
            else:
                active_layer = tools_qgis.get_layer_source_table_name(self.iface.activeLayer())

            # Used by action_interpolate
            last_click = self.canvas.mouseLastXY()
            self.last_point = QgsMapToPixel.toMapCoordinates(
                self.canvas.getCoordinateTransform(), last_click.x(), last_click.y())

            extras = ""
            if tab_type == 'inp':
                extras = '"toolBar":"epa"'
            elif tab_type == 'data':
                extras = '"toolBar":"basic"'


            function_name = None
            body = None

            # Insert new feature
            if point and feature_cat:
                self.feature_cat = feature_cat
                self.new_feature_id = new_feature_id
                self.layer_new_feature = layer_new_feature
                self.iface.actionPan().trigger()
                feature = f'"tableName":"{feature_cat.child_layer.lower()}"'
                extras += f', "coordinates":{{{point}}}'
                body = tools_gw.create_body(feature=feature, extras=extras)
                function_name = 'gw_fct_getfeatureinsert'

            # Click over canvas
            elif point:
                visible_layer = tools_qgis.get_visible_layers(as_str_list=True)
                scale_zoom = self.iface.mapCanvas().scale()
                extras += f', "activeLayer":"{active_layer}"'
                extras += f', "visibleLayer":{visible_layer}'
                extras += f', "mainSchema":"{qgis_project_main_schema}"'
                extras += f', "addSchema":"{qgis_project_add_schema}"'
                extras += f', "projecRole":"{qgis_project_role}"'
                extras += f', "coordinates":{{"xcoord":{point.x()},"ycoord":{point.y()}, "zoomRatio":{scale_zoom}}}'
                body = tools_gw.create_body(extras=extras)
                function_name = 'gw_fct_getinfofromcoordinates'

            # Comes from QPushButtons node1 or node2 from custom form or RightButton
            elif feature_id:
                if is_add_schema:
                    add_schema = global_vars.project_vars['add_schema']
                    extras = f'"addSchema":"{add_schema}"'
                else:
                    extras = '"addSchema":""'
                feature = f'"tableName":"{table_name}", "id":"{feature_id}"'
                body = tools_gw.create_body(feature=feature, extras=extras)
                function_name = 'gw_fct_getinfofromid'

            if function_name is None:
                return False, None

            tools_qgis.set_cursor_wait()
            json_result = tools_gw.execute_procedure(function_name, body, rubber_band=self.rubber_band)
            tools_qgis.restore_cursor()

            if json_result in (None, False):
                return False, None

            # Manage status failed
            if json_result['status'] == 'Failed' or ('results' in json_result and json_result['results'] <= 0):
                level = 1
                if 'level' in json_result['message']:
                    level = int(json_result['message']['level'])
                msg = f"Execution of {function_name} failed."
                if 'text' in json_result['message']:
                    msg = json_result['message']['text']
                tools_qgis.show_message(msg, level)
                return False, None

            self.complet_result = json_result
            try:
                template = self.complet_result['body']['form']['template']
            except Exception as e:
                tools_log.log_info(str(e))
                return False, None

            if template == 'info_generic':
                result, dialog = self._open_generic_form(self.complet_result)
                # Fill self.my_json for new qgis_feature
                if feature_cat is not None:
                    self._manage_new_feature(self.complet_result, dialog)
                return result, dialog

            elif template == 'dimensioning':
                self.lyr_dim = tools_qgis.get_layer_by_tablename("v_edit_dimensions", show_warning_=True)
                if self.lyr_dim:
                    self.dimensioning = GwDimensioning()
                    feature_id = self.complet_result['body']['feature']['id']
                    result, dialog = self.dimensioning.open_dimensioning_form(None, self.lyr_dim, self.complet_result,
                        feature_id, self.rubber_band)
                    return result, dialog

            elif template == 'info_feature':
                sub_tag = None
                if feature_cat:
                    if feature_cat.feature_type.lower() == 'arc':
                        sub_tag = 'arc'
                    else:
                        sub_tag = 'node'
                feature_id = self.complet_result['body']['feature']['id']
                result, dialog = self._open_custom_form(feature_id, self.complet_result, tab_type, sub_tag, is_docker,
                    new_feature=new_feature)
                if feature_cat is not None:
                    self._manage_new_feature(self.complet_result, dialog)
                return result, dialog

            elif template == 'visit':
                visit_id = self.complet_result['body']['feature']['id']
                manage_visit = GwVisit()
                manage_visit.get_visit(visit_id=visit_id, tag='info')
                dlg_add_visit = manage_visit.get_visit_dialog()
                dlg_add_visit.rejected.connect(lambda: tools_gw.reset_rubberband(self.rubber_band))

            else:
                tools_log.log_warning(f"template not managed: {template}")
                return False, None
        except Exception as e:
            tools_qgis.show_warning("Exception in info", parameter=e)
            self._disconnect_signals()  # Disconnect signals
            tools_qgis.restore_cursor()  # Restore overridden cursor
            return False, None


    """ FUNCTIONS ASSOCIATED TO BUTTONS FROM POSTGRES"""


    def get_info_node(self, **kwargs):
        """ Function called in class tools_gw.add_button(...) -->
                widget.clicked.connect(partial(getattr(self, function_name), **kwargs)) """

        dialog = kwargs['dialog']
        widget = kwargs['widget']
        feature_id = tools_qt.get_text(dialog, widget)
        self.customForm = GwInfo(self.tab_type)
        complet_result, dialog = self.customForm.open_form(table_name='v_edit_node', feature_id=feature_id,
                                                           tab_type=self.tab_type, is_docker=False)
        if not complet_result:
            tools_log.log_info("FAIL open_node")
            return


    def add_feature(self, feature_cat, action=None):
        """ Button 01, 02: Add 'node' or 'arc' """

        global is_inserting
        if is_inserting:
            msg = "You cannot insert more than one feature at the same time, finish editing the previous feature"
            tools_qgis.show_message(msg)
            return

        self.prev_action = action
        keep_active = tools_gw.get_config_parser('user_edit_tricks', 'keep_maptool_active', "user", "init")
        keep_active = tools_os.set_boolean(keep_active, False)
        if not keep_active:
            self.prev_action = None
        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Set snapping to 'node', 'connec' and 'gully'
        self.snapper_manager.config_snap_to_arc()
        self.snapper_manager.config_snap_to_node()
        self.snapper_manager.config_snap_to_connec()
        self.snapper_manager.config_snap_to_gully()
        self.snapper_manager.set_snap_mode()
        tools_gw.connect_signal(self.iface.actionAddFeature().toggled, self._action_is_checked,
                                'info', 'add_feature_actionAddFeature_toggled_action_is_checked')

        self.feature_cat = feature_cat
        # self.info_layer must be global because apparently the disconnect signal is not disconnected correctly if
        # parameters are passed to it
        self.info_layer = tools_qgis.get_layer_by_tablename(feature_cat.parent_layer)
        if self.info_layer:
            # The user selects a feature (for example junction) to insert, but before clicking on the canvas he
            # realizes that he has made a mistake and selects another feature, without this two features would
            # be inserted. This disconnect signal avoids it
            tools_gw.disconnect_signal('info', 'add_feature_featureAdded_open_new_feature')

            self.suppres_form = QSettings().value("/Qgis/digitizing/disable_enter_attribute_values_dialog")
            QSettings().setValue("/Qgis/digitizing/disable_enter_attribute_values_dialog", True)
            config = self.info_layer.editFormConfig()
            self.conf_supp = config.suppress()
            config.setSuppress(0)
            self.info_layer.setEditFormConfig(config)
            self.iface.setActiveLayer(self.info_layer)
            self.info_layer.startEditing()
            self.iface.actionAddFeature().trigger()
            tools_gw.connect_signal(self.info_layer.featureAdded, self._open_new_feature,
                                    'info', 'add_feature_featureAdded_open_new_feature')
        else:
            message = "Layer not found"
            tools_qgis.show_warning(message, parameter=feature_cat.parent_layer)


    """ FUNCTIONS RELATED WITH TAB PLAN """


    def get_snapped_feature_id(self, dialog, action, layer_name, option, widget_name, child_type):
        """ Snap feature and set a value into dialog """

        layer = tools_qgis.get_layer_by_tablename(layer_name)
        if not layer:
            action.setChecked(False)
            return
        if widget_name is not None:
            widget = dialog.findChild(QWidget, widget_name)
            if widget is None:
                action.setChecked(False)
                return
        # Block the signals of de dialog so that the key ESC does not close it
        dialog.key_escape.disconnect()

        self.vertex_marker = self.snapper_manager.vertex_marker

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Disable snapping
        self.snapper_manager.set_snapping_status()

        # if we are doing info over connec or over node
        if option in ('arc', 'set_to_arc'):
            self.snapper_manager.config_snap_to_arc()
        elif option == 'node':
            self.snapper_manager.config_snap_to_node()
        # Set signals
        tools_gw.disconnect_signal('info_snapping', 'get_snapped_feature_id_xyCoordinates_mouse_moved')
        tools_gw.connect_signal(self.canvas.xyCoordinates, partial(self._mouse_moved, layer),
                                'info_snapping', 'get_snapped_feature_id_xyCoordinates_mouse_moved')

        tools_gw.disconnect_signal('info_snapping', 'get_snapped_feature_id_ep_canvasClicked_get_id')
        emit_point = QgsMapToolEmitPoint(self.canvas)
        self.previous_map_tool = global_vars.canvas.mapTool()
        self.canvas.setMapTool(emit_point)
        tools_gw.connect_signal(emit_point.canvasClicked, partial(self._get_id, dialog, action, option, emit_point, child_type),
                                'info_snapping', 'get_snapped_feature_id_ep_canvasClicked_get_id')


    # region private functions


    def _get_feature_insert(self, point, feature_cat, new_feature_id, layer_new_feature, tab_type, new_feature):
        return self.open_form(point=point, feature_cat=feature_cat, new_feature_id=new_feature_id,
                              layer_new_feature=layer_new_feature, tab_type=tab_type, new_feature=new_feature)


    def _manage_new_feature(self, complet_result, dialog):

        result = complet_result['body']['data']
        for field in result['fields']:
            if 'hidden' in field and field['hidden']:
                continue
            if 'layoutname' in field and field['layoutname'] == 'lyt_none':
                continue
            widget = dialog.findChild(QWidget, field['widgetname'])
            value = None
            if type(widget) in (QLineEdit, QPushButton, QSpinBox, QDoubleSpinBox):
                value = tools_qt.get_text(dialog, widget, return_string_null=False)
            elif type(widget) is QComboBox:
                value = tools_qt.get_combo_value(dialog, widget, 0)
            elif type(widget) is QCheckBox:
                value = tools_qt.is_checked(dialog, widget)
            elif type(widget) is QgsDateTimeEdit:
                value = tools_qt.get_calendar_date(dialog, widget)
            else:
                if widget is None:
                    msg = f"Widget {field['columnname']} is not configured or have a bad config"
                    tools_qgis.show_message(msg, dialog=dialog)
            if str(value) not in ('', None, -1, "None", "-1") and widget.property('columnname'):
                self.my_json[str(widget.property('columnname'))] = str(value)

        tools_log.log_info(str(self.my_json))


    def _open_generic_form(self, complet_result):

        tools_gw.draw_by_json(complet_result, self.rubber_band)
        self.hydro_info_dlg = GwInfoGenericUi()
        tools_gw.load_settings(self.hydro_info_dlg)
        self.hydro_info_dlg.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.hydro_info_dlg))
        self.hydro_info_dlg.rejected.connect(partial(tools_gw.close_dialog, self.hydro_info_dlg))
        result = tools_gw.build_dialog_info(self.hydro_info_dlg, complet_result, self.my_json)

        # Disable button accept for info on generic form
        self.hydro_info_dlg.btn_accept.setEnabled(False)

        self.hydro_info_dlg.rejected.connect(self.rubber_band.reset)
        tools_gw.open_dialog(self.hydro_info_dlg, dlg_name='info_generic')

        return result, self.hydro_info_dlg


    def _open_custom_form(self, feature_id, complet_result, tab_type=None, sub_tag=None, is_docker=True, new_feature=None):
        """
        Opens a custom form
            :param feature_id: the id of the node that will populate the form (Integer)
            :param complet_result: The JSON used to create/populate the form (JSON)
            :param tab_type:
            :param sub_tag:
            :param is_docker: Whether the form is docker or not (Boolean)
            :param new_feature: Whether the form will create a new feature or not (Boolean)
            :return: self.complt_result, self.dlg_cf
        """

        # Dialog
        self.dlg_cf = GwInfoFeatureUi(sub_tag)
        tools_gw.load_settings(self.dlg_cf)

        # Get widget controls
        self._get_widget_controls(new_feature)

        self._get_features(complet_result)
        if self.layer is None:
            tools_qgis.show_message(f"Layer not found: {self.table_parent}", 2)
            return False, self.dlg_cf

        # If in the get_json function we have received a rubberband, it is not necessary to redraw it.
        # But if it has not been received, it is drawn
        # Using variable exist_rb for check if alredy exist rubberband
        try:
            # noinspection PyUnusedLocal
            exist_rb = complet_result['body']['returnManager']['style']['ruberband']
        except KeyError:
            tools_gw.draw_by_json(complet_result, self.rubber_band)

        # Remove unused tabs
        tabs_to_show = []

        # Get field id name and feature id
        self.field_id = str(complet_result['body']['feature']['idName'])
        self.feature_id = complet_result['body']['feature']['id']

        # Get the start point and end point of the feature
        list_points = None
        if new_feature:
            list_points = tools_qgis.get_points_from_geometry(self.layer, new_feature)
        else:
            try:
                list_points = (f'"x1": {complet_result["body"]["feature"]["geometry"]["x"]}, '
                               f'"y1": {complet_result["body"]["feature"]["geometry"]["y"]}')
            except:
                pass

        if 'visibleTabs' in complet_result['body']['form']:
            for tab in complet_result['body']['form']['visibleTabs']:
                tabs_to_show.append(tab['tabName'])

        for x in range(self.tab_main.count() - 1, 0, -1):
            if self.tab_main.widget(x).objectName() not in tabs_to_show:
                tools_qt.remove_tab(self.tab_main, self.tab_main.widget(x).objectName())

        # Actions
        self._get_actions()

        if self.new_feature_id is not None:
            self._enable_action(self.dlg_cf, "actionZoom", False)
            self._enable_action(self.dlg_cf, "actionZoomOut", False)
            self._enable_action(self.dlg_cf, "actionCentered", False)
            self._enable_action(self.dlg_cf, "actionSetToArc", False)
        self._show_actions(self.dlg_cf, 'tab_data')

        try:
            is_enabled = complet_result['body']['feature']['permissions']['isEditable']
            self.action_edit.setEnabled(is_enabled)
        except Exception:
            pass

        # Add icons to actions & buttons
        self._manage_icons()

        result = self._get_feature_type(complet_result)
        # Build and populate all the widgets
        self._manage_dlg_widgets(complet_result, result, new_feature)
        if global_vars.project_type == 'ud':
            self._check_elev_y()

        # Connect actions' signals
        dlg_cf, fid = self._manage_actions_signals(complet_result, list_points, new_feature, tab_type, result)

        btn_cancel = self.dlg_cf.findChild(QPushButton, 'btn_cancel')
        btn_accept = self.dlg_cf.findChild(QPushButton, 'btn_accept')
        title = self._set_dlg_title(complet_result)

        # Connect dialog signals
        if global_vars.session_vars['dialog_docker'] and is_docker and global_vars.session_vars['info_docker']:
            # Delete last form from memory
            last_info = global_vars.session_vars['dialog_docker'].findChild(GwMainWindow, 'dlg_info_feature')
            if last_info:
                last_info.setParent(None)
                del last_info

            tools_gw.docker_dialog(dlg_cf)
            global_vars.session_vars['dialog_docker'].widget().dlg_closed.connect(self._manage_docker_close)
            global_vars.session_vars['dialog_docker'].setWindowTitle(title)
            btn_cancel.clicked.connect(self._manage_docker_close)

        else:
            dlg_cf.dlg_closed.connect(self._roll_back)
            dlg_cf.dlg_closed.connect(lambda: tools_gw.reset_rubberband(self.rubber_band))
            dlg_cf.dlg_closed.connect(self._remove_layer_selection)
            dlg_cf.dlg_closed.connect(partial(tools_gw.save_settings, dlg_cf))
            dlg_cf.dlg_closed.connect(self._reset_my_json)
            dlg_cf.dlg_closed.connect(self._manage_prev_action)
            dlg_cf.key_escape.connect(partial(tools_gw.close_dialog, dlg_cf))
            btn_cancel.clicked.connect(partial(self._manage_info_close, dlg_cf))
        btn_accept.clicked.connect(
            partial(self._accept_from_btn, dlg_cf, self.action_edit, new_feature, self.my_json, complet_result))
        dlg_cf.key_enter.connect(
            partial(self._accept_from_btn, dlg_cf, self.action_edit, new_feature, self.my_json, complet_result))

        # Open dialog
        tools_gw.open_dialog(self.dlg_cf, dlg_name='info_feature')
        self.dlg_cf.setWindowTitle(title)

        return self.complet_result, self.dlg_cf


    def _get_widget_controls(self, new_feature):
        """ Sets class variables for most widgets """

        self.tab_main = self.dlg_cf.findChild(QTabWidget, "tab_main")
        self.tab_main.currentChanged.connect(partial(self._tab_activation, self.dlg_cf, new_feature))
        self.tbl_element = self.dlg_cf.findChild(QTableView, "tbl_element")
        tools_qt.set_tableview_config(self.tbl_element)
        self.tbl_relations = self.dlg_cf.findChild(QTableView, "tbl_relations")
        tools_qt.set_tableview_config(self.tbl_relations)
        self.tbl_upstream = self.dlg_cf.findChild(QTableView, "tbl_upstream")
        tools_qt.set_tableview_config(self.tbl_upstream)
        self.tbl_downstream = self.dlg_cf.findChild(QTableView, "tbl_downstream")
        tools_qt.set_tableview_config(self.tbl_downstream)
        self.tbl_hydrometer = self.dlg_cf.findChild(QTableView, "tbl_hydrometer")
        tools_qt.set_tableview_config(self.tbl_hydrometer)
        self.tbl_hydrometer_value = self.dlg_cf.findChild(QTableView, "tbl_hydrometer_value")
        tools_qt.set_tableview_config(self.tbl_hydrometer_value, QAbstractItemView.SelectItems,
                                      QTableView.CurrentChanged)
        self.tbl_visit_cf = self.dlg_cf.findChild(QTableView, "tbl_visit_cf")
        self.tbl_event_cf = self.dlg_cf.findChild(QTableView, "tbl_event_cf")
        tools_qt.set_tableview_config(self.tbl_event_cf)
        self.tbl_document = self.dlg_cf.findChild(QTableView, "tbl_document")
        tools_qt.set_tableview_config(self.tbl_document)


    def _get_features(self, complet_result):

        # Get table name
        self.tablename = complet_result['body']['feature']['tableName']
        # Get feature type (Junction, manhole, valve, fountain...)
        self.feature_type = complet_result['body']['feature']['childType']
        # Get tableParent and select layer
        self.table_parent = str(complet_result['body']['feature']['tableParent'])
        schema_name = str(complet_result['body']['feature']['schemaName'])
        self.layer = tools_qgis.get_layer_by_tablename(self.table_parent, False, False, schema_name)


    def _get_actions(self):
        """ Sets class variables for actions """

        self.action_edit = self.dlg_cf.findChild(QAction, "actionEdit")
        self.action_copy_paste = self.dlg_cf.findChild(QAction, "actionCopyPaste")
        self.action_rotation = self.dlg_cf.findChild(QAction, "actionRotation")
        self.action_catalog = self.dlg_cf.findChild(QAction, "actionCatalog")
        self.action_workcat = self.dlg_cf.findChild(QAction, "actionWorkcat")
        self.action_mapzone = self.dlg_cf.findChild(QAction, "actionMapZone")
        self.action_set_to_arc = self.dlg_cf.findChild(QAction, "actionSetToArc")
        self.action_get_arc_id = self.dlg_cf.findChild(QAction, "actionGetArcId")
        self.action_get_parent_id = self.dlg_cf.findChild(QAction, "actionGetParentId")
        self.action_zoom_in = self.dlg_cf.findChild(QAction, "actionZoom")
        self.action_zoom_out = self.dlg_cf.findChild(QAction, "actionZoomOut")
        self.action_centered = self.dlg_cf.findChild(QAction, "actionCentered")
        self.action_link = self.dlg_cf.findChild(QAction, "actionLink")
        self.action_help = self.dlg_cf.findChild(QAction, "actionHelp")
        self.action_interpolate = self.dlg_cf.findChild(QAction, "actionInterpolate")
        # action_switch_arc_id = self.dlg_cf.findChild(QAction, "actionSwicthArcid")
        self.action_section = self.dlg_cf.findChild(QAction, "actionSection")


    def _manage_icons(self):
        """ Adds icons to actions and buttons """

        # Set actions icon
        tools_gw.add_icon(self.action_edit, "101")
        tools_gw.add_icon(self.action_copy_paste, "107b", "24x24")
        tools_gw.add_icon(self.action_rotation, "107c", "24x24")
        tools_gw.add_icon(self.action_catalog, "195")
        tools_gw.add_icon(self.action_workcat, "193")
        tools_gw.add_icon(self.action_mapzone, "213", sub_folder="24x24")
        tools_gw.add_icon(self.action_set_to_arc, "212", sub_folder="24x24")
        tools_gw.add_icon(self.action_get_arc_id, "209")
        tools_gw.add_icon(self.action_get_parent_id, "210")
        tools_gw.add_icon(self.action_zoom_in, "103")
        tools_gw.add_icon(self.action_zoom_out, "107")
        tools_gw.add_icon(self.action_centered, "104")
        tools_gw.add_icon(self.action_link, "173", sub_folder="24x24")
        tools_gw.add_icon(self.action_section, "207")
        tools_gw.add_icon(self.action_help, "73", sub_folder="24x24")
        tools_gw.add_icon(self.action_interpolate, "194")
        # Set buttons icon
        # tab elements
        tools_gw.add_icon(self.dlg_cf.btn_insert, "111b", "24x24")
        tools_gw.add_icon(self.dlg_cf.btn_delete, "112b", "24x24")
        tools_gw.add_icon(self.dlg_cf.btn_new_element, "131b", "24x24")
        tools_gw.add_icon(self.dlg_cf.btn_open_element, "134b", "24x24")
        # tab hydrometer
        tools_gw.add_icon(self.dlg_cf.btn_link, "70", "24x24")
        # tab visit
        tools_gw.add_icon(self.dlg_cf.btn_open_gallery_2, "136b", "24x24")
        tools_gw.add_icon(self.dlg_cf.btn_visit_intervals, "136c", "24x24")
        # tab event
        tools_gw.add_icon(self.dlg_cf.btn_open_visit, "65", "24x24")
        tools_gw.add_icon(self.dlg_cf.btn_new_visit, "64", "24x24")
        tools_gw.add_icon(self.dlg_cf.btn_open_gallery, "136b", "24x24")
        tools_gw.add_icon(self.dlg_cf.btn_open_visit_doc, "170b", "24x24")
        tools_gw.add_icon(self.dlg_cf.btn_open_visit_event, "134b", "24x24")
        # tab doc
        tools_gw.add_icon(self.dlg_cf.btn_doc_insert, "111b", "24x24")
        tools_gw.add_icon(self.dlg_cf.btn_doc_delete, "112b", "24x24")
        tools_gw.add_icon(self.dlg_cf.btn_doc_new, "131b", "24x24")
        tools_gw.add_icon(self.dlg_cf.btn_open_doc, "170b", "24x24")


    def _manage_dlg_widgets(self, complet_result, result, new_feature):
        """ Creates and populates all the widgets """

        layout_list = []
        for field in complet_result['body']['data']['fields']:
            if 'hidden' in field and field['hidden']:
                continue
            label, widget = self._set_widgets(self.dlg_cf, complet_result, field, new_feature)
            if widget is None:
                continue
            layout = self.dlg_cf.findChild(QGridLayout, field['layoutname'])
            if layout is not None:
                # Take the QGridLayout with the intention of adding a QSpacerItem later
                if layout not in layout_list and layout.objectName() not in ('lyt_top_1', 'lyt_bot_1', 'lyt_bot_2'):
                    layout_list.append(layout)
                if field['layoutorder'] is None:
                    message = "The field layoutorder is not configured for"
                    msg = f"formname:{self.tablename}, columnname:{field['columnname']}"
                    tools_qgis.show_message(message, 2, parameter=msg, dialog=self.dlg_cf)
                elif field['layoutname'] in ('lyt_top_1', 'lyt_bot_1', 'lyt_bot_2'):
                    layout.addWidget(label, 0, field['layoutorder'])
                    layout.addWidget(widget, 1, field['layoutorder'])
                else:
                    tools_gw.add_widget(self.dlg_cf, field, label, widget)
            elif field['layoutname'] != 'lyt_none':
                message = "The field layoutname is not configured for"
                msg = f"formname:{self.tablename}, columnname:{field['columnname']}"
                tools_qgis.show_message(message, 2, parameter=msg, dialog=self.dlg_cf)
        # Add a QSpacerItem into each QGridLayout of the list
        for layout in layout_list:
            vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
            layout.addItem(vertical_spacer1)
        # Manage combo parents and children:
        for field in result['fields']:
            if field['isparent']:
                if field['widgettype'] == 'combo':
                    widget = self.dlg_cf.findChild(QComboBox, field['widgetname'])
                    if widget is not None:
                        widget.currentIndexChanged.connect(partial(
                            self._get_combo_child, self.dlg_cf, widget, self.feature_type,
                            self.tablename, self.field_id))


    def _manage_actions_signals(self, complet_result, list_points, new_feature, tab_type, result):
        """ Connects signals to the actions """

        # Set variables
        id_name = complet_result['body']['feature']['idName']
        self.filter = str(id_name) + " = '" + str(self.feature_id) + "'"
        dlg_cf = self.dlg_cf
        layer = self.layer
        fid = self.feature_id
        can_edit = tools_os.set_boolean(tools_db.check_role_user('role_edit'))
        if layer:
            if layer.isEditable() and can_edit:
                tools_gw.enable_all(dlg_cf, complet_result['body']['data'])
            else:
                tools_gw.enable_widgets(dlg_cf, complet_result['body']['data'], False)
        # We assign the function to a global variable,
        # since as it receives parameters we will not be able to disconnect the signals
        self.fct_block_action_edit = lambda: self._block_action_edit(dlg_cf, self.action_edit, result, layer, fid,
                                                                     self.my_json, new_feature)
        self.fct_start_editing = lambda: self._start_editing(dlg_cf, self.action_edit, complet_result['body']['data'], layer)
        self.fct_stop_editing = lambda: self._stop_editing(dlg_cf, self.action_edit, layer, fid, self.my_json, new_feature)
        self._connect_signals()

        self._enable_actions(dlg_cf, layer.isEditable() and can_edit)

        self.action_edit.setChecked(layer.isEditable() and can_edit)
        child_type = complet_result['body']['feature']['childType']

        # Actions signals
        self.action_edit.triggered.connect(partial(self._manage_edition, dlg_cf, self.action_edit, fid, new_feature))
        self.action_catalog.triggered.connect(partial(self._open_catalog, tab_type, self.feature_type, child_type))
        self.action_workcat.triggered.connect(
            partial(self._get_catalog, 'new_workcat', self.tablename, child_type, self.feature_id, list_points,
                    id_name))
        self.action_mapzone.triggered.connect(
            partial(self._get_catalog, 'new_mapzone', self.tablename, child_type, self.feature_id, list_points,
                    id_name))
        self.action_set_to_arc.triggered.connect(
            partial(self.get_snapped_feature_id, dlg_cf, self.action_set_to_arc, 'v_edit_arc', 'set_to_arc', None,
                    child_type))
        self.action_get_arc_id.triggered.connect(
            partial(self.get_snapped_feature_id, dlg_cf, self.action_get_arc_id, 'v_edit_arc', 'arc', 'data_arc_id',
                    child_type))
        self.action_get_parent_id.triggered.connect(
            partial(self.get_snapped_feature_id, dlg_cf, self.action_get_parent_id, 'v_edit_node', 'node',
                    'data_parent_id', child_type))
        self.action_zoom_in.triggered.connect(partial(self._manage_action_zoom_in, self.canvas, self.layer))
        self.action_centered.triggered.connect(partial(self._manage_action_centered, self.canvas, self.layer))
        self.action_zoom_out.triggered.connect(partial(self._manage_action_zoom_out, self.canvas, self.layer))
        self.action_copy_paste.triggered.connect(
            partial(self._manage_action_copy_paste, self.dlg_cf, self.feature_type, tab_type))
        self.action_rotation.triggered.connect(partial(self._change_hemisphere, self.dlg_cf, self.action_rotation))
        self.action_link.triggered.connect(partial(self.action_open_link))
        self.action_section.triggered.connect(partial(self._open_section_form))
        self.action_help.triggered.connect(partial(self._open_help, self.feature_type))
        self.ep = QgsMapToolEmitPoint(self.canvas)
        self.previous_map_tool = global_vars.canvas.mapTool()
        self.action_interpolate.triggered.connect(partial(self._activate_snapping, complet_result, self.ep))

        # Disable action edit if user can't edit
        if not can_edit:
            self.action_edit.setChecked(False)
            self.action_edit.setEnabled(False)

        return dlg_cf, fid


    def action_open_link(self):
        """ Manage def open_file from action 'Open Link' """
        
        try:
            widget_list = self.dlg_cf.findChildren(tools_qt.GwHyperLinkLabel)
            for widget in widget_list:
                path = widget.text()
                status, message = tools_os.open_file(path)
                if status is False and message is not None:
                    tools_qgis.show_warning(message, parameter=path, dialog=self.dlg_cf)
        except Exception:
            pass


    def _get_feature_type(self, complet_result):
        """ Get feature type as feature_type (node, arc, connec, gully) """

        self.feature_type = str(complet_result['body']['feature']['featureType'])
        if str(self.feature_type) in ('', '[]'):
            if 'feature_cat' in globals():
                parent_layer = self.feature_cat.parent_layer
            else:
                parent_layer = str(complet_result['body']['feature']['tableParent'])
            sql = f"SELECT lower(feature_type) FROM cat_feature WHERE parent_layer = '{parent_layer}' LIMIT 1"
            result = tools_db.get_row(sql)
            if result:
                self.feature_type = result[0]
        result = complet_result['body']['data']
        return result


    def _set_dlg_title(self, complet_result):
        """ Sets the dialog title """

        # Set title
        title = f"{complet_result['body']['form']['headerText']}"

        try:
            # Set toolbox labels
            toolbox_cf = self.dlg_cf.findChild(QWidget, 'toolBox')
            toolbox_cf.setItemText(0, complet_result['body']['form']['tabDataLytNames']['index_0'])
            toolbox_cf.setItemText(1, complet_result['body']['form']['tabDataLytNames']['index_1'])
        except Exception:
            pass
        finally:
            return title


    def _open_help(self, feature_type):
        """ Open PDF file with selected @project_type and @feature_type """

        # Get locale of QGIS application
        locale = tools_qgis.get_locale()

        project_type = tools_gw.get_project_type()
        # Get PDF file
        pdf_folder = os.path.join(global_vars.plugin_dir, f'resources{os.sep}png')
        pdf_path = os.path.join(pdf_folder, f"{project_type}_{feature_type}_{locale}.png")

        # Open PDF if exists. If not open Spanish version
        if os.path.exists(pdf_path):
            os.system(pdf_path)
        else:
            locale = "es_ES"
            pdf_path = os.path.join(pdf_folder, f"{project_type}_{feature_type}_{locale}.png")
            if os.path.exists(pdf_path):
                os.system(pdf_path)
            else:
                message = "No help file found"
                tools_qgis.show_warning(message, parameter=pdf_path)


    def _block_action_edit(self, dialog, action_edit, result, layer, fid, my_json, new_feature):

        current_layer = self.iface.activeLayer()

        if self.new_feature_id is not None and current_layer == layer:
            self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').blockSignals(True)
            save = self._stop_editing(dialog, action_edit, layer, fid, my_json, new_feature)
            self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').blockSignals(False)
            if save and not self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').isChecked():
                self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').trigger()

        if self.connected is False:
            self._connect_signals()


    def _connect_signals(self):

        if not self.connected:
            tools_gw.connect_signal(self.layer.editingStarted, self.fct_start_editing,
                                    'info', 'connect_signals_layer_editingStarted_fct_start_editing')
            action_toggle_editing = self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing')
            if action_toggle_editing:
                tools_gw.connect_signal(action_toggle_editing.triggered, self.fct_block_action_edit,
                                        'info', 'connect_signals_action_toggle_editing_triggered_fct_block_action_edit')
            self.connected = True


    def _disconnect_signals(self):

        try:
            tools_gw.disconnect_signal('info', 'connect_signals_layer_editingStarted_fct_start_editing')
        except Exception:
            pass

        try:
            # This signal isn't connected atm, might need to change the name depending on where it's connected
            tools_gw.disconnect_signal('info', 'connect_signals_layer_editingStopped_fct_stop_editing')
        except Exception:
            pass

        try:
            tools_gw.disconnect_signal('info', 'connect_signals_action_toggle_editing_triggered_fct_block_action_edit')
        except Exception:
            pass

        try:
            tools_gw.disconnect_signal('info_snapping')
        except Exception:
            pass

        try:
            global_vars.canvas.setMapTool(self.previous_map_tool)
        except Exception:
            pass

        self.connected = False
        global is_inserting
        is_inserting = False


    def _activate_snapping(self, complet_result, ep, refresh_dialog=False):

        self.rb_interpolate = []
        self.interpolate_result = None
        self.last_rb = None
        tools_gw.reset_rubberband(self.rubber_band)

        if refresh_dialog is False:
            dlg_interpolate = GwInterpolate()
            tools_gw.load_settings(dlg_interpolate)
        else:
            dlg_interpolate = refresh_dialog
        
        self.ep = ep

        # Manage QRadioButton interpolate/extrapolate
        rb_name = tools_gw.get_config_parser("btn_info", "rb_action_interpolate", "user", "session")
        self.last_rb = rb_name
        rb_widget = dlg_interpolate.findChild(QRadioButton, rb_name)
        rb_widget.setChecked(True)

        self.msg_infolog = ('Interpolate tool.\n'
               'To modify columns (top_elev, ymax, elev among others) to be interpolated set variable '
               'edit_node_interpolate on table config_param_user')
        tools_qt.set_widget_text(dlg_interpolate, dlg_interpolate.txt_infolog, self.msg_infolog)

        self.msg_text = "Please, use the cursor to select two nodes to proceed with the interpolation\nNode1: \nNode2:"
        dlg_interpolate.lbl_text.setText(self.msg_text)

        if refresh_dialog is False:
            # Disable tab log
            tools_gw.disable_tab_log(dlg_interpolate)

            dlg_interpolate.btn_accept.clicked.connect(partial(self._chek_for_existing_values, dlg_interpolate))
            dlg_interpolate.btn_close.clicked.connect(partial(tools_gw.close_dialog, dlg_interpolate))
            dlg_interpolate.rejected.connect(partial(tools_gw.save_settings, dlg_interpolate))
            dlg_interpolate.rejected.connect(partial(self._manage_interpolate_rejected))
            dlg_interpolate.rb_interpolate.clicked.connect(partial(self._change_rb_type, dlg_interpolate, dlg_interpolate.rb_interpolate, complet_result, ep))
            dlg_interpolate.rb_extrapolate.clicked.connect(partial(self._change_rb_type, dlg_interpolate, dlg_interpolate.rb_extrapolate, complet_result, ep))

            tools_gw.open_dialog(dlg_interpolate, dlg_name='dialog_text')

        # Set circle vertex marker
        self.vertex_marker = self.snapper_manager.vertex_marker
        self.snapper_manager.set_vertex_marker(self.vertex_marker, icon_type=4)
        self.vertex_marker.show()

        global_vars.canvas.setMapTool(self.ep)
        # We redraw the selected feature because self.canvas.setMapTool(emit_point) erases it
        tools_gw.draw_by_json(complet_result, self.rubber_band, None, False)

        # Store user snapping configuration
        self.previous_snapping = self.snapper_manager.get_snapping_options()

        self.layer_node = tools_qgis.get_layer_by_tablename("v_edit_node")
        global_vars.iface.setActiveLayer(self.layer_node)

        self.node1 = None
        self.node2 = None

        tools_gw.connect_signal(global_vars.canvas.xyCoordinates, partial(self._mouse_move),
                                'info_snapping', 'activate_snapping_xyCoordinates_mouse_move')
        tools_gw.connect_signal(ep.canvasClicked, partial(self._snapping_node, dlg_interpolate),
                                'info_snapping', 'activate_snapping_ep_canvasClicked_snapping_node')

    def _manage_interpolate_rejected(self):

        tools_gw.disconnect_signal('info_snapping', 'activate_snapping_xyCoordinates_mouse_move')
        tools_gw.disconnect_signal('info_snapping', 'activate_snapping_ep_canvasClicked_snapping_node')
        self._remove_interpolate_rb()
        self.vertex_marker.hide()
        self.iface.actionPan().trigger()


    def _change_rb_type(self, dialog, widget, complet_result, ep):
        """ Function to manage radioButton interpolate/extrapolate"""

        if widget.objectName() != self.last_rb:
            self.last_rb = widget.objectName()
            tools_gw.set_config_parser("btn_info", "rb_action_interpolate", f"{widget.objectName()}")
            self._manage_interpolate_rejected()
            self._activate_snapping(complet_result, ep, refresh_dialog=dialog)


    def _snapping_node(self, dlg_interpolate, point, button):
        """ Get id of selected nodes (node1 and node2) """

        if button == 2:
            self._dlg_destroyed(self.layer)
            return

        # Get coordinates
        event_point = self.snapper_manager.get_event_point(point=point)
        if not event_point:
            return

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if result.isValid():
            layer = self.snapper_manager.get_snapped_layer(result)
            # Check feature
            if layer == self.layer_node:
                snapped_feat = self.snapper_manager.get_snapped_feature(result)
                element_id = snapped_feat.attribute('node_id')
                message = "Selected node"
                rb = tools_gw.create_rubberband(global_vars.canvas, 0)
                if self.node1 is None:
                    self.node1 = str(element_id)
                    tools_qgis.draw_point(QgsPointXY(result.point()), rb, color=QColor(0, 150, 55, 100), width=10)
                    self.rb_interpolate.append(rb)
                    dlg_interpolate.lbl_text.setText(f"Node1: {self.node1}\nNode2:")
                    tools_qgis.show_message(message, message_level=0, parameter=self.node1)
                elif self.node1 != str(element_id):
                    self.node2 = str(element_id)
                    tools_qgis.draw_point(QgsPointXY(result.point()), rb, color=QColor(0, 150, 55, 100), width=10)
                    self.rb_interpolate.append(rb)
                    dlg_interpolate.lbl_text.setText(f"Node1: {self.node1}\nNode2: {self.node2}")
                    tools_qgis.show_message(message, message_level=0, parameter=self.node2)

        if self.node1 and self.node2:

            # Get checkbox extrapolate value from dialog
            rb_extrapolate = dlg_interpolate.findChild(QRadioButton, 'rb_extrapolate')

            action_dict = {True: 'EXTRAPOLATE', False: 'INTERPOLATE'}

            tools_gw.disconnect_signal('info_snapping', 'activate_snapping_xyCoordinates_mouse_move')
            tools_gw.disconnect_signal('info_snapping', 'activate_snapping_ep_canvasClicked_snapping_node')

            global_vars.iface.setActiveLayer(self.layer)
            self.vertex_marker.hide()
            extras = f'"parameters":{{'
            extras += f'"action":"{action_dict[rb_extrapolate.isChecked()]}", '
            extras += f'"x":{self.last_point[0]}, '
            extras += f'"y":{self.last_point[1]}, '
            extras += f'"node1":"{self.node1}", '
            extras += f'"node2":"{self.node2}"}}'
            body = tools_gw.create_body(extras=extras)
            self.interpolate_result = tools_gw.execute_procedure('gw_fct_node_interpolate', body)
            if not self.interpolate_result or self.interpolate_result['status'] == 'Failed':
                return False
            tools_gw.fill_tab_log(dlg_interpolate, self.interpolate_result['body']['data'], close=False)

            self.iface.actionPan().trigger()


    def _chek_for_existing_values(self, dlg_interpolate):

        text = False
        for k, v in self.interpolate_result['body']['data']['fields'][0].items():
            widget = self.dlg_cf.findChild(QWidget, k)
            if widget and len(v) > 0:
                text = tools_qt.get_text(self.dlg_cf, widget, False, False)
                if text:
                    msg = "Do you want to overwrite custom values?"
                    answer = tools_qt.show_question(msg, "Overwrite values")
                    if answer:
                        self._set_values(dlg_interpolate)
                    break
        if not text:
            self._set_values(dlg_interpolate)


    def _set_values(self, dlg_interpolate):

        # Set values tu info form
        for k, v in self.interpolate_result['body']['data']['fields'][0].items():
            widget = self.dlg_cf.findChild(QWidget, k)
            if widget and len(v) > 0:
                widget.setStyleSheet(None)
                tools_qt.set_widget_text(self.dlg_cf, widget, f'{v}')
                widget.editingFinished.emit()
        tools_gw.close_dialog(dlg_interpolate)


    def _dlg_destroyed(self, layer=None, vertex=None):

        self.dlg_is_destroyed = True
        if layer is not None:
            global_vars.iface.setActiveLayer(layer)
        if vertex is not None:
            global_vars.iface.mapCanvas().scene().removeItem(vertex)
        else:
            if hasattr(self, 'vertex_marker'):
                if self.vertex_marker is not None:
                    global_vars.iface.mapCanvas().scene().removeItem(self.vertex_marker)
        try:
            global_vars.canvas.xyCoordinates.disconnect()
        except Exception:
            pass


    def _remove_interpolate_rb(self):

        # Remove the circumferences made by the interpolate
        for rb in self.rb_interpolate:
            global_vars.iface.mapCanvas().scene().removeItem(rb)


    def _mouse_move(self, point):

        # Get clicked point
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if result.isValid():
            layer = self.snapper_manager.get_snapped_layer(result)
            if layer == self.layer_node:
                self.snapper_manager.add_marker(result, self.vertex_marker)
        else:
            self.vertex_marker.hide()


    def _change_hemisphere(self, dialog, action):

        # Set map tool emit point and signals
        tools_gw.disconnect_signal('info_snapping', 'change_hemisphere_ep_canvasClicked_action_rotation_canvas_clicked')
        emit_point = QgsMapToolEmitPoint(global_vars.canvas)
        self.previous_map_tool = global_vars.canvas.mapTool()
        global_vars.canvas.setMapTool(emit_point)
        tools_gw.connect_signal(emit_point.canvasClicked, partial(self._action_rotation_canvas_clicked, dialog, action, emit_point),
                                'info_snapping', 'change_hemisphere_ep_canvasClicked_action_rotation_canvas_clicked')


    def _action_rotation_canvas_clicked(self, dialog, action, emit_point, point, btn):

        if btn == Qt.RightButton:
            global_vars.canvas.setMapTool(self.previous_map_tool)
            return

        existing_point_x = None
        existing_point_y = None
        viewname = tools_qgis.get_layer_source_table_name(self.layer)
        sql = (f"SELECT ST_X(the_geom), ST_Y(the_geom)"
               f" FROM {viewname}"
               f" WHERE node_id = '{self.feature_id}'")
        row = tools_db.get_row(sql)

        if row:
            existing_point_x = row[0]
            existing_point_y = row[1]

        if existing_point_x:
            sql = (f"UPDATE node"
                   f" SET hemisphere = (SELECT degrees(ST_Azimuth(ST_Point({existing_point_x}, {existing_point_y}), "
                   f" ST_Point({point.x()}, {point.y()}))))"
                   f" WHERE node_id = '{self.feature_id}'")
            status = tools_db.execute_sql(sql)
            if not status:
                global_vars.canvas.setMapTool(self.previous_map_tool)
                return

        sql = (f"SELECT rotation FROM node "
               f" WHERE node_id = '{self.feature_id}'")
        row = tools_db.get_row(sql)
        if row:
            tools_qt.set_widget_text(dialog, "data_rotation", str(row[0]))

        sql = (f"SELECT degrees(ST_Azimuth(ST_Point({existing_point_x}, {existing_point_y}),"
               f" ST_Point({point.x()}, {point.y()})))")
        row = tools_db.get_row(sql)
        if row:
            tools_qt.set_widget_text(dialog, "data_hemisphere", str(row[0]))
            message = "Hemisphere of the node has been updated. Value is"
            tools_qgis.show_info(message, parameter=str(row[0]))
            # Force a map refresh
            tools_qgis.force_refresh_map_canvas()

        # Disable Rotation
        action_widget = dialog.findChild(QAction, "actionRotation")
        if action_widget:
            action_widget.setChecked(False)
        tools_gw.disconnect_signal('info_snapping', 'change_hemisphere_ep_canvasClicked_action_rotation_canvas_clicked')


    def _manage_action_copy_paste(self, dialog, feature_type, tab_type=None):
        """ Copy some fields from snapped feature to current feature """

        # Set map tool emit point and signals
        tools_gw.disconnect_signal('info_snapping', 'manage_action_copy_paste_ep_canvasClicked')
        emit_point = QgsMapToolEmitPoint(global_vars.canvas)
        self.previous_map_tool = global_vars.canvas.mapTool()
        global_vars.canvas.setMapTool(emit_point)
        tools_gw.disconnect_signal('info_snapping', 'manage_action_copy_paste_xyCoordinates_mouse_move')
        tools_gw.connect_signal(global_vars.canvas.xyCoordinates, self._manage_action_copy_paste_mouse_move,
                                'info_snapping', 'manage_action_copy_paste_xyCoordinates_mouse_move')
        tools_gw.connect_signal(emit_point.canvasClicked, partial(self._manage_action_copy_paste_canvas_clicked, dialog, tab_type, emit_point),
                                'info_snapping', 'manage_action_copy_paste_ep_canvasClicked')

        self.feature_type = feature_type

        # Store user snapping configuration
        self.previous_snapping = self.snapper_manager.get_snapping_options()

        # Clear snapping
        self.snapper_manager.set_snapping_status()

        # Set snapping
        layer = global_vars.iface.activeLayer()
        self.snapper_manager.config_snap_to_layer(layer)

        # Set marker
        self.vertex_marker = self.snapper_manager.vertex_marker

        if feature_type == 'node':
            self.snapper_manager.set_vertex_marker(self.vertex_marker, icon_type=4)


    def _manage_action_copy_paste_mouse_move(self, point):
        """ Slot function when mouse is moved in the canvas.
            Add marker if any feature is snapped
        """

        # Hide marker and get coordinates
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if not result.isValid():
            return

        # Add marker to snapped feature
        self.snapper_manager.add_marker(result, self.vertex_marker)


    def _manage_action_copy_paste_canvas_clicked(self, dialog, tab_type, emit_point, point, btn):
        """ Slot function when canvas is clicked """

        if btn == Qt.RightButton:
            self._manage_disable_copy_paste(dialog, emit_point)
            return

        # Get clicked point
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if not result.isValid():
            self._manage_disable_copy_paste(dialog, emit_point)
            return

        layer = global_vars.iface.activeLayer()
        layername = layer.name()

        # Get the point. Leave selection
        snapped_feature = self.snapper_manager.get_snapped_feature(result, True)
        snapped_feature_attr = snapped_feature.attributes()

        aux = f'"{self.feature_type}_id" = '
        aux += f"'{self.feature_id}'"
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = "Expression Error"
            tools_qgis.show_warning(message, parameter=expr.parserErrorString())
            self._manage_disable_copy_paste(dialog, emit_point)
            return

        fields = layer.dataProvider().fields()
        layer.startEditing()
        it = layer.getFeatures(QgsFeatureRequest(expr))
        feature_list = [i for i in it]
        if not feature_list:
            self._manage_disable_copy_paste(dialog, emit_point)
            return

        # Select only first element of the feature list
        feature = feature_list[0]
        feature_id = feature.attribute(str(self.feature_type) + '_id')
        msg = (f"Selected snapped feature_id to copy values from: {snapped_feature_attr[0]}\n"
               f"Do you want to copy its values to the current node?\n\n")
        # Replace id because we don't have to copy it!
        snapped_feature_attr[0] = feature_id
        snapped_feature_attr_aux = []
        fields_aux = []

        # Iterate over all fields and copy only specific ones
        for i in range(0, len(fields)):
            if fields[i].name() == 'sector_id' or fields[i].name() == 'dma_id' or fields[i].name() == 'expl_id' \
                    or fields[i].name() == 'state' or fields[i].name() == 'state_type' \
                    or fields[i].name() == layername + '_workcat_id' or fields[i].name() == layername + '_builtdate' \
                    or fields[i].name() == 'verified' or fields[i].name() == str(self.feature_type) + 'cat_id':
                snapped_feature_attr_aux.append(snapped_feature_attr[i])
                fields_aux.append(fields[i].name())
            if global_vars.project_type == 'ud':
                if fields[i].name() == str(self.feature_type) + '_type':
                    snapped_feature_attr_aux.append(snapped_feature_attr[i])
                    fields_aux.append(fields[i].name())

        for i in range(0, len(fields_aux)):
            msg += f"{fields_aux[i]}: {snapped_feature_attr_aux[i]}\n"

        # Ask confirmation question showing fields that will be copied
        answer = tools_qt.show_question(msg, "Update records", None)
        if answer:
            for i in range(0, len(fields)):
                for x in range(0, len(fields_aux)):
                    if fields[i].name() == fields_aux[x]:
                        layer.changeAttributeValue(feature.id(), i, snapped_feature_attr_aux[x])

            layer.commitChanges()

            # dialog.refreshFeature()
            for i in range(0, len(fields_aux)):
                widget = dialog.findChild(QWidget, tab_type + "_" + fields_aux[i])
                if tools_qt.get_widget_type(dialog, widget) is QLineEdit:
                    tools_qt.set_widget_text(dialog, widget, str(snapped_feature_attr_aux[i]))
                elif tools_qt.get_widget_type(dialog, widget) is QComboBox:
                    tools_qt.set_combo_value(widget, str(snapped_feature_attr_aux[i]), 0)

        self._manage_disable_copy_paste(dialog, emit_point)


    def _manage_disable_copy_paste(self, dialog, emit_point):
        """ Disable actionCopyPaste and set action 'Identify' """

        action_widget = dialog.findChild(QAction, "actionCopyPaste")
        if action_widget:
            action_widget.setChecked(False)

        try:
            self.snapper_manager.restore_snap_options(self.previous_snapping)
            self.vertex_marker.hide()
            tools_gw.disconnect_signal('info_snapping', 'manage_action_copy_paste_xyCoordinates_mouse_move')
            tools_gw.disconnect_signal('info_snapping', 'manage_action_copy_paste_ep_canvasClicked')
        except Exception:
            pass


    def _manage_docker_close(self):

        self._roll_back()
        tools_gw.reset_rubberband(self.rubber_band)
        self._remove_layer_selection()
        global_vars.session_vars['dialog_docker'].widget().dlg_closed.disconnect()
        self._reset_my_json()
        tools_gw.close_docker()


    def _remove_layer_selection(self):

        try:
            self.layer.removeSelection()
        except RuntimeError:
            pass


    def _manage_info_close(self, dialog):

        self._roll_back()
        tools_gw.reset_rubberband(self.rubber_band)
        tools_gw.save_settings(dialog)
        tools_gw.close_dialog(dialog)


    def _get_feature(self, tab_type):
        """ Get current QgsFeature """

        expr_filter = f"{self.field_id} = '{self.feature_id}'"
        self.feature = self._get_feature_by_expr(self.layer, expr_filter)
        return self.feature


    def _get_feature_by_expr(self, layer, expr_filter):

        # Check filter and existence of fields
        expr = QgsExpression(expr_filter)
        if expr.hasParserError():
            message = f"{expr.parserErrorString()}: {expr_filter}"
            tools_qgis.show_warning(message)
            return

        it = layer.getFeatures(QgsFeatureRequest(expr))
        # Iterate over features
        for feature in it:
            return feature

        return False


    def _manage_action_zoom_in(self, canvas, layer):
        """ Zoom in """

        if not self.feature:
            self._get_feature(self.tab_type)
        layer.selectByIds([self.feature.id()])
        canvas.zoomToSelected(layer)
        canvas.zoomIn()


    def _manage_action_centered(self, canvas, layer):
        """ Center map to current feature """

        if not self.feature:
            self._get_feature(self.tab_type)
        layer.selectByIds([self.feature.id()])
        canvas.zoomToSelected(layer)


    def _manage_action_zoom_out(self, canvas, layer):
        """ Zoom out """

        if not self.feature:
            self._get_feature(self.tab_type)
        layer.selectByIds([self.feature.id()])
        canvas.zoomToSelected(layer)
        canvas.zoomOut()
        expr_filter = f"{self.field_id} = '{self.feature_id}'"
        self.feature = self._get_feature_by_expr(self.layer, expr_filter)
        return self.feature


    def _get_last_value(self):

        try:
            # Widgets in ('lyt_top_1', 'lyt_bot_1', 'lyt_bot_2')
            other_widgets = []
            for field in self.complet_result['body']['data']['fields']:
                if field['layoutname'] in ('lyt_top_1', 'lyt_bot_1', 'lyt_bot_2'):
                    widget = self.dlg_cf.findChild(QWidget, field['widgetname'])
                    if widget:
                        other_widgets.append(widget)
            # Widgets in tab_data
            widgets = self.dlg_cf.tab_data.findChildren(QWidget)
            widgets.extend(other_widgets)
            for widget in widgets:
                if widget.hasFocus():
                    value = tools_qt.get_text(self.dlg_cf, widget)
                    if str(value) not in ('', None, -1, "None") and widget.property('columnname'):
                        self.my_json[str(widget.property('columnname'))] = str(value)
                    widget.clearFocus()
        except RuntimeError:
            pass


    def _manage_edition(self, dialog, action_edit, fid, new_feature=None):

        # With the editing QAction we need to collect the last modified value (self.get_last_value()),
        # since the "editingFinished" signals of the widgets are not detected.
        # Therefore whenever the cursor enters a widget, it will ask if we want to save changes
        if not action_edit.isChecked():
            self._get_last_value()
            if str(self.my_json) == '{}':
                tools_qt.set_action_checked(action_edit, False)
                tools_gw.enable_widgets(dialog, self.complet_result['body']['data'], False)
                self._enable_actions(dialog, False)
                return
            save = self._ask_for_save(action_edit, fid)
            if save:
                self._manage_accept(dialog, action_edit, new_feature, self.my_json, False)
            elif self.new_feature_id is not None:
                if global_vars.session_vars['dialog_docker'] and global_vars.session_vars['info_docker']:
                    self._manage_docker_close()
                else:
                    tools_gw.close_dialog(dialog)
            self._reset_my_json()
        else:
            tools_qt.set_action_checked(action_edit, True)
            tools_gw.enable_all(dialog, self.complet_result['body']['data'])
            self._enable_actions(dialog, True)


    def _accept_from_btn(self, dialog, action_edit, new_feature, my_json, last_json):

        if not action_edit.isChecked():
            tools_gw.close_dialog(dialog)
            return

        self._manage_accept(dialog, action_edit, new_feature, my_json, True)
        self._reset_my_json()


    def _manage_accept(self, dialog, action_edit, new_feature, my_json, close_dlg):

        self._get_last_value()
        status = self._accept(dialog, self.complet_result, my_json, close_dlg=close_dlg, new_feature=new_feature)
        if status:  # Commit succesfull and dialog keep opened
            tools_qt.set_action_checked(action_edit, False)
            tools_gw.enable_widgets(dialog, self.complet_result['body']['data'], False)
            self._enable_actions(dialog, False)
        # Force layers to reindex in order to fix some snapping issues
        self.iface.mapCanvas().snappingUtils().clearAllLocators()
        tools_qgis.force_refresh_map_canvas()


    def _stop_editing(self, dialog, action_edit, layer, fid, my_json, new_feature=None):

        if my_json == '' or str(my_json) == '{}':
            QgsProject.instance().blockSignals(True)
            tools_qt.set_action_checked(action_edit, False)
            tools_gw.enable_widgets(dialog, self.complet_result['body']['data'], False)
            self._enable_actions(dialog, False)
            QgsProject.instance().blockSignals(False)
        else:
            save = self._ask_for_save(action_edit, fid)
            if save:
                self._reset_my_json()
                self._manage_accept(dialog, action_edit, new_feature, my_json, False)
            self._reset_my_json()

            return save


    def _start_editing(self, dialog, action_edit, result, layer):

        QgsProject.instance().blockSignals(True)
        self.iface.setActiveLayer(layer)
        tools_qt.set_action_checked(action_edit, True)
        tools_gw.enable_all(dialog, self.complet_result['body']['data'])
        self._enable_actions(dialog, True)
        layer.startEditing()
        QgsProject.instance().blockSignals(False)


    def _ask_for_save(self, action_edit, fid):

        msg = 'Are you sure to save this feature?'
        answer = tools_qt.show_question(msg, "Save feature", None, parameter=fid)
        if not answer:
            tools_qt.set_action_checked(action_edit, True)
            return False
        return True


    def _roll_back(self):
        """ Discard changes in current layer """

        self._disconnect_signals()
        try:
            self.iface.actionRollbackEdits().trigger()
        except TypeError:
            pass

        try:
            self.layer_new_feature.rollBack()
        except AttributeError:
            pass

        try:
            self.layer.rollBack()
        except AttributeError:
            pass
        except RuntimeError:
            pass


    def _set_widgets(self, dialog, complet_result, field, new_feature):
        """
        functions called in -> widget = getattr(self, f"_manage_{field['widgettype']}")(**kwargs)
            def _manage_text(self, **kwargs)
            def _manage_typeahead(self, **kwargs)
            def _manage_combo(self, **kwargs)
            def _manage_check(self, **kwargs)
            def _manage_datetime(self, **kwargs)
            def _manage_button(self, **kwargs)
            def _manage_hyperlink(self, **kwargs)
            def _manage_hspacer(self, **kwargs)
            def _manage_vspacer(self, **kwargs)
            def _manage_textarea(self, **kwargs)
            def _manage_spinbox(self, **kwargs)
            def _manage_doubleSpinbox(self, **kwargs)
            def _manage_tableView(self, **kwargs)
         """

        widget = None
        label = None
        if field['label']:
            label = QLabel()
            label.setObjectName('lbl_' + field['widgetname'])
            label.setText(field['label'].capitalize())
            if 'stylesheet' in field and field['stylesheet'] is not None and 'label' in field['stylesheet']:
                label = tools_gw.set_stylesheet(field, label)
            if 'tooltip' in field:
                label.setToolTip(field['tooltip'])
            else:
                label.setToolTip(field['label'].capitalize())

        if 'widgettype' in field and not field['widgettype']:
            message = "The field widgettype is not configured for"
            msg = f"formname:{self.tablename}, columnname:{field['columnname']}"
            tools_qgis.show_message(message, 2, parameter=msg, dialog=dialog)
            return label, widget

        try:
            kwargs = {"dialog": dialog, "complet_result": complet_result, "field": field, "new_feature": new_feature}
            widget = getattr(self, f"_manage_{field['widgettype']}")(**kwargs)
        except Exception as e:
            msg = (f"{type(e).__name__}: {e} WHERE columname='{field['columnname']}' "
                   f"AND widgetname='{field['widgetname']}' AND widgettype='{field['widgettype']}'")
            tools_qgis.show_message(msg, 2, dialog=dialog)
            return label, widget

        return label, widget


    def _manage_text(self, **kwargs):
        """ This function is called in def _set_widgets(self, dialog, complet_result, field, new_feature)
            widget = getattr(self, f"_manage_{field['widgettype']}")(**kwargs)
        """

        dialog = kwargs['dialog']
        field = kwargs['field']
        new_feature = kwargs['new_feature']

        widget = tools_gw.add_lineedit(field)
        widget = tools_gw.set_widget_size(widget, field)
        widget = self._set_min_max_values(widget, field)
        widget = self._set_reg_exp(widget, field)
        widget = self._set_auto_update_lineedit(field, dialog, widget, new_feature)
        widget = tools_gw.set_data_type(field, widget)
        widget = self._set_max_length(widget, field)

        return widget


    def _set_min_max_values(self, widget, field):
        """ Set max and min values allowed """

        if field['widgetcontrols'] and 'maxMinValues' in field['widgetcontrols']:
            if 'min' in field['widgetcontrols']['maxMinValues']:
                widget.setProperty('minValue', field['widgetcontrols']['maxMinValues']['min'])

        if field['widgetcontrols'] and 'maxMinValues' in field['widgetcontrols']:
            if 'max' in field['widgetcontrols']['maxMinValues']:
                widget.setProperty('maxValue', field['widgetcontrols']['maxMinValues']['max'])

        return widget


    def _set_max_length(self, widget, field):
        """ Set max and min values allowed """

        if field['widgetcontrols'] and 'maxLength' in field['widgetcontrols']:
            if field['widgetcontrols']['maxLength'] is not None:
                widget.setProperty('maxLength', field['widgetcontrols']['maxLength'])

        return widget


    def _set_reg_exp(self, widget, field):
        """ Set regular expression """

        if 'widgetcontrols' in field and field['widgetcontrols']:
            if field['widgetcontrols'] and 'regexpControl' in field['widgetcontrols']:
                if field['widgetcontrols']['regexpControl'] is not None:
                    reg_exp = QRegExp(str(field['widgetcontrols']['regexpControl']))
                    widget.setValidator(QRegExpValidator(reg_exp))

        return widget


    def _manage_typeahead(self, **kwargs):
        """ This function is called in def _set_widgets(self, dialog, complet_result, field, new_feature)
            widget = getattr(self, f"_manage_{field['widgettype']}")(**kwargs)
        """

        dialog = kwargs['dialog']
        field = kwargs['field']
        completer = QCompleter()
        widget = self._manage_text(**kwargs)
        widget = tools_gw.set_typeahead(field, dialog, widget, completer)
        return widget


    def _manage_combo(self, **kwargs):
        """ This function is called in def _set_widgets(self, dialog, complet_result, field, new_feature)
            widget = getattr(self, f"_manage_{field['widgettype']}")(**kwargs)
        """

        dialog = kwargs['dialog']
        field = kwargs['field']
        new_feature = kwargs['new_feature']
        widget = tools_gw.add_combo(field)
        widget = tools_gw.set_widget_size(widget, field)
        widget = self._set_auto_update_combobox(field, dialog, widget, new_feature)
        return widget


    def _manage_check(self, **kwargs):
        """ This function is called in def _set_widgets(self, dialog, complet_result, field, new_feature)
            widget = getattr(self, f"_manage_{field['widgettype']}")(**kwargs)
        """

        dialog = kwargs['dialog']
        field = kwargs['field']
        new_feature = kwargs['new_feature']
        widget = tools_gw.add_checkbox(field)
        widget.stateChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))
        widget = self._set_auto_update_checkbox(field, dialog, widget, new_feature)
        return widget


    def _manage_datetime(self, **kwargs):
        """ This function is called in def _set_widgets(self, dialog, complet_result, field, new_feature)
            widget = getattr(self, f"_manage_{field['widgettype']}")(**kwargs)
        """

        dialog = kwargs['dialog']
        field = kwargs['field']
        new_feature = kwargs['new_feature']
        widget = tools_gw.add_calendar(dialog, field)
        widget = self._set_auto_update_dateedit(field, dialog, widget, new_feature)
        return widget


    def _manage_button(self, **kwargs):
        """ This function is called in def _set_widgets(self, dialog, complet_result, field, new_feature)
            widget = getattr(self, f"_manage_{field['widgettype']}")(**kwargs)
        """

        dialog = kwargs['dialog']
        field = kwargs['field']
        # If button text is empty it's because node_1/2 is not present.
        # Then we create a QLineEdit to input a node to be connected.
        if not field.get('value'):
            widget = self._manage_text(**kwargs)
            widget.editingFinished.connect(partial(self._run_settopology, widget, **kwargs))
            return widget
        widget = tools_gw.add_button(dialog, field, module=self)
        widget = tools_gw.set_widget_size(widget, field)
        return widget


    def _manage_hyperlink(self, **kwargs):
        """ This function is called in def _set_widgets(self, dialog, complet_result, field, new_feature)
            widget = getattr(self, f"_manage_{field['widgettype']}")(**kwargs)
        """

        field = kwargs['field']
        dialog = kwargs['dialog']
        new_feature = kwargs['new_feature']
        widget = tools_gw.add_hyperlink(field)
        widget = tools_gw.set_widget_size(widget, field)
        if type(widget) == GwHyperLinkLineEdit:
            widget = self._set_auto_update_hyperlink(field, dialog, widget, new_feature)
        return widget


    def _manage_hspacer(self, **kwargs):
        """ This function is called in def _set_widgets(self, dialog, complet_result, field, new_feature)
            widget = getattr(self, f"_manage_{field['widgettype']}")(**kwargs)
        """

        widget = tools_qt.add_horizontal_spacer()
        return widget


    def _manage_vspacer(self, **kwargs):
        """ This function is called in def _set_widgets(self, dialog, complet_result, field, new_feature)
            widget = getattr(self, f"_manage_{field['widgettype']}")(**kwargs)
        """

        widget = tools_qt.add_verticalspacer()
        return widget


    def _manage_textarea(self, **kwargs):
        """ This function is called in def _set_widgets(self, dialog, complet_result, field, new_feature)
            widget = getattr(self, f"_manage_{field['widgettype']}")(**kwargs)
        """

        dialog = kwargs['dialog']
        field = kwargs['field']
        new_feature = kwargs['new_feature']
        widget = tools_gw.add_textarea(field)
        widget = self._set_auto_update_textarea(field, dialog, widget, new_feature)
        return widget


    def _manage_spinbox(self, **kwargs):
        """ This function is called in def _set_widgets(self, dialog, complet_result, field, new_feature)
            widget = getattr(self, f"_manage_{field['widgettype']}")(**kwargs)
        """

        dialog = kwargs['dialog']
        field = kwargs['field']
        new_feature = kwargs['new_feature']
        widget = tools_gw.add_spinbox(field)
        widget = self._set_auto_update_spinbox(field, dialog, widget, new_feature)
        return widget


    def _manage_doubleSpinbox(self, **kwargs):
        """ This function is called in def _set_widgets(self, dialog, complet_result, field, new_feature)
            widget = getattr(self, f"_manage_{field['widgettype']}")(**kwargs)
        """

        dialog = kwargs['dialog']
        field = kwargs['field']
        new_feature = kwargs['new_feature']
        widget = tools_gw.add_spinbox(field)
        widget = self._set_auto_update_spinbox(field, dialog, widget, new_feature)
        return widget


    def _manage_tableView(self, **kwargs):
        """ This function is called in def _set_widgets(self, dialog, complet_result, field, new_feature)
            widget = getattr(self, f"_manage_{field['widgettype']}")(**kwargs)
        """

        complet_result = kwargs['complet_result']
        field = kwargs['field']
        dialog = kwargs['dialog']
        widget = tools_gw.add_tableview(complet_result, field, self)
        widget = tools_gw.add_tableview_header(widget, field)
        widget = tools_gw.fill_tableview_rows(widget, field)
        widget = tools_gw.set_tablemodel_config(dialog, widget, field['widgetname'], sort_order=1, isQStandardItemModel=True)
        tools_qt.set_tableview_config(widget)
        return widget


    def _open_section_form(self):

        dlg_sections = GwInfoCrossectUi()
        tools_gw.load_settings(dlg_sections)

        # Set dialog not resizable
        dlg_sections.setFixedSize(dlg_sections.size())

        feature = '"id":"' + self.feature_id + '"'
        body = tools_gw.create_body(feature=feature)
        json_result = tools_gw.execute_procedure('gw_fct_getinfocrossection', body)
        if not json_result or json_result['status'] == 'Failed':
            return False

        # Set image
        img = json_result['body']['data']['shapepng']
        tools_qt.add_image(dlg_sections, 'lbl_section_image', f"{self.plugin_dir}{os.sep}resources{os.sep}png{os.sep}{img}")

        # Set values into QLineEdits
        for field in json_result['body']['data']['fields']:
            widget = dlg_sections.findChild(QLineEdit, field['columnname'])
            if widget:
                if 'value' in field:
                    tools_qt.set_widget_text(dlg_sections, widget, field['value'])

        dlg_sections.btn_close.clicked.connect(partial(tools_gw.close_dialog, dlg_sections))
        tools_gw.open_dialog(dlg_sections, dlg_name='info_crossect')


    def _accept(self, dialog, complet_result, _json, p_widget=None, clear_json=False, close_dlg=True, new_feature=None):
        """
        :param dialog:
        :param complet_result:
        :param _json:
        :param p_widget:
        :param clear_json:
        :param close_dlg:
        :return: (boolean)
        """

        QgsProject.instance().blockSignals(True)

        # Check if C++ object has been deleted
        if isdeleted(dialog):
            return False

        after_insert = False

        if _json == '' or str(_json) == '{}':
            if not close_dlg:
                return None
            if global_vars.session_vars['dialog_docker'] and dialog == global_vars.session_vars['dialog_docker'].widget():
                global_vars.session_vars['dialog_docker'].setMinimumWidth(dialog.width())
                tools_gw.close_docker()
                return None
            tools_gw.close_dialog(dialog)
            return None

        p_table_id = complet_result['body']['feature']['tableName']
        id_name = complet_result['body']['feature']['idName']
        newfeature_id = complet_result['body']['feature']['id']
        parent_fields = complet_result['body']['data']['parentFields']
        fields_reload = ""
        list_mandatory = []
        for field in complet_result['body']['data']['fields']:
            if field.get('hidden') in (True, 'True', 'true'):
                continue
            if p_widget and (field['widgetname'] == p_widget.objectName()):
                if field['widgetcontrols'] and 'autoupdateReloadFields' in field['widgetcontrols']:
                    fields_reload = field['widgetcontrols']['autoupdateReloadFields']

            if field['ismandatory']:
                widget_name = 'data_' + field['columnname']
                widget = dialog.findChild(QWidget, widget_name)
                widget.setStyleSheet(None)
                value = tools_qt.get_text(dialog, widget)
                if value in ('null', None, ''):
                    widget.setStyleSheet("border: 1px solid red")
                    list_mandatory.append(widget_name)

        if list_mandatory:
            msg = "Some mandatory values are missing. Please check the widgets marked in red."
            tools_qgis.show_warning(msg, dialog=dialog)
            tools_qt.set_action_checked("actionEdit", True, dialog)
            QgsProject.instance().blockSignals(False)
            return False

        if self._has_elev_and_y_json(_json):
            tools_qt.set_action_checked("actionEdit", True, dialog)
            QgsProject.instance().blockSignals(False)
            return False

        # If we create a new feature
        if self.new_feature_id is not None:
            new_feature.setAttribute(id_name, newfeature_id)
            after_insert = True
            for k, v in list(_json.items()):
                if k in parent_fields:
                    new_feature.setAttribute(k, v)
                    _json.pop(k, None)

            if not self.layer_new_feature.isEditable():
                self.layer_new_feature.startEditing()
            self.layer_new_feature.updateFeature(new_feature)

            status = self.layer_new_feature.commitChanges()
            if status is False:
                error = self.layer_new_feature.commitErrors()
                tools_log.log_warning(f"{error}")
                QgsProject.instance().blockSignals(False)
                return False

            self.new_feature_id = None
            self._enable_action(dialog, "actionZoom", True)
            self._enable_action(dialog, "actionZoomOut", True)
            self._enable_action(dialog, "actionCentered", True)
            self._enable_action(dialog, "actionSetToArc", True)
            global is_inserting
            is_inserting = False
            my_json = json.dumps(_json)
            if my_json == '' or str(my_json) == '{}':
                if close_dlg:
                    if global_vars.session_vars['dialog_docker'] and dialog == global_vars.session_vars['dialog_docker'].widget():
                        tools_gw.close_docker()
                        return True
                    tools_gw.close_dialog(dialog)
                return True

            if self.new_feature.attribute(id_name) is not None:
                feature = f'"id":"{self.new_feature.attribute(id_name)}", '
            else:
                feature = f'"id":"{self.feature_id}", '

        # If we make an info
        else:
            my_json = json.dumps(_json)
            feature = f'"id":"{self.feature_id}", '

        feature += f'"tableName":"{p_table_id}", '
        feature += f' "featureType":"{self.feature_type}" '
        extras = f'"fields":{my_json}, "reload":"{fields_reload}", "afterInsert":"{after_insert}"'
        body = tools_gw.create_body(feature=feature, extras=extras)

        # Get utils_graphanalytics_automatic_trigger param
        row = tools_gw.get_config_value("utils_graphanalytics_automatic_trigger", table='config_param_system')
        thread = row[0] if row else None
        if thread:
            thread = json.loads(thread)
            thread = tools_os.set_boolean(thread['status'], default=False)
            if 'closed' not in _json:
                thread = False

        json_result = tools_gw.execute_procedure('gw_fct_setfields', body, log_sql=True)
        if not json_result:
            QgsProject.instance().blockSignals(False)
            return False

        if clear_json:
            _json = {}

        self._reset_my_json()

        if "Accepted" in json_result['status']:
            msg_text = json_result['message']['text']
            if msg_text is None:
                msg_text = 'Feature upserted'
            msg_level = json_result['message']['level']
            if msg_level is None:
                msg_level = 1
            tools_qgis.show_message(msg_text, message_level=msg_level, dialog=dialog)
            self._reload_fields(dialog, json_result, p_widget)

            if thread:
                # If param is true show question and create thread
                msg = "You closed a valve, this will modify the current mapzones and it may take a little bit of time."
                if global_vars.user_level['level'] in ('1', '2'):
                    msg += " Would you like to continue?"
                    answer = tools_qt.show_question(msg)
                else:
                    tools_qgis.show_info(msg)
                    answer = True

                if answer:
                    params = {"body": body}
                    self.valve_thread = GwToggleValveTask("Update mapzones", params)
                    QgsApplication.taskManager().addTask(self.valve_thread)
                    QgsApplication.taskManager().triggerTask(self.valve_thread)
        elif "Failed" in json_result['status']:
            # If json_result['status'] is Failed message from database is showed user by get_json->manage_json_exception
            QgsProject.instance().blockSignals(False)
            return False

        # Force a map refresh
        tools_qgis.force_refresh_map_canvas()

        if close_dlg:
            if global_vars.session_vars['dialog_docker'] and dialog == global_vars.session_vars['dialog_docker'].widget():
                self._manage_docker_close()
            else:
                tools_gw.close_dialog(dialog)
            return None

        return True


    def _manage_prev_action(self):
        if self.prev_action:
            self.prev_action.action.trigger()


    def _enable_actions(self, dialog, enabled):
        """ Enable actions according if layer is editable or not """

        try:
            actions_list = dialog.findChildren(QAction)
            static_actions = ('actionEdit', 'actionCentered', 'actionZoomOut', 'actionZoom', 'actionLink', 'actionHelp',
                              'actionSection', 'actionSetToArc')

            for action in actions_list:
                if action.objectName() not in static_actions:
                    self._enable_action(dialog, action, enabled)

            # When we are inserting we want the activation of QAction to be governed by the database,
            # when we are editing, it will govern the editing state of the layer.
            global is_inserting
            if not is_inserting:
                return

            # Get index of selected tab
            index_tab = self.tab_main.currentIndex()
            tab_name = self.tab_main.widget(index_tab).objectName()

            for tab in self.complet_result['body']['form']['visibleTabs']:
                if tab['tabName'] == tab_name:
                    if tab['tabactions'] is not None:
                        for act in tab['tabactions']:
                            action = dialog.findChild(QAction, act['actionName'])
                            if action is not None and action.objectName() not in static_actions:
                                action.setEnabled(not act['disabled'])

        except RuntimeError:
            pass


    def _enable_action(self, dialog, action, enabled):

        if type(action) is str:
            action = dialog.findChild(QAction, action)
        if not action:
            return
        action.setEnabled(enabled)


    def _check_datatype_validator(self, dialog, widget, btn):
        """
        functions called in ->  getattr(tools_gw, f"check_{widget.property('datatype')}")(value, widget, btn)
            def check_integer(self, value, widget, btn_accept)
            def check_double(self, value, widget, btn_accept)
        """

        value = tools_qt.get_text(dialog, widget, return_string_null=False)
        try:
            getattr(self, f"_check_{widget.property('datatype')}")(value, widget, btn)
        except AttributeError:
            """ If the function called by getattr don't exist raise this exception """
            pass


    def _check_double(self, value, widget, btn_accept):
        """ Check if the value is double or not.
            This function is called in def check_datatype_validator(self, value, widget, btn)
            getattr(self, f"check_{widget.property('datatype')}")(value, widget, btn)
        """

        if value is None or bool(re.search("^\d*$", value)) or bool(re.search("^\d+\.\d+$", value)):
            widget.setStyleSheet(None)
            btn_accept.setEnabled(True)
        else:
            widget.setStyleSheet("border: 1px solid red")
            btn_accept.setEnabled(False)


    def _check_integer(self, value, widget, btn_accept):
        """ Check if the value is an integer or not.
            This function is called in def check_datatype_validator(self, value, widget, btn)
            getattr(self, f"check_{widget.property('datatype')}")(value, widget, btn)
        """

        if value is None or bool(re.search("^\d*$", value)):
            widget.setStyleSheet(None)
            btn_accept.setEnabled(True)
        else:
            widget.setStyleSheet("border: 1px solid red")
            btn_accept.setEnabled(False)


    def _check_min_max_value(self, dialog, widget, btn_accept):

        value = tools_qt.get_text(dialog, widget, return_string_null=False)
        try:
            if value and ((widget.property('minValue') and float(value) < float(widget.property('minValue')))
                    or (widget.property('maxValue') and float(value) > float(widget.property('maxValue')))):
                widget.setStyleSheet("border: 1px solid red")
                btn_accept.setEnabled(False)
            else:
                widget.setStyleSheet(None)
                btn_accept.setEnabled(True)
        except ValueError:
            widget.setStyleSheet("border: 1px solid red")
            btn_accept.setEnabled(False)


    def _check_tab_data(self, dialog):
        """ Check if current tab name is tab_data """

        tab_main = dialog.findChild(QTabWidget, "tab_main")
        if not tab_main:
            return
        index_tab = tab_main.currentIndex()
        tab_name = tab_main.widget(index_tab).objectName()
        if tab_name == 'tab_data':
            return True
        return False


    def _clean_my_json(self, widget):
        """ Delete keys if exist, when widget is autoupdate """

        try:
            self.my_json.pop(str(widget.property('columnname')), None)
        except KeyError:
            pass


    def _reset_my_json(self):
        """ Delete keys if exist, when widget is autoupdate """

        self.my_json.clear()


    def _set_auto_update_lineedit(self, field, dialog, widget, new_feature=None):

        if self._check_tab_data(dialog):
            # "and field['widgettype'] != 'typeahead'" It is necessary so that the textchanged signal of the typeahead
            # does not jump, making it lose focus, which will cause the accept function to jump sent invalid parameters
            if field['isautoupdate'] and self.new_feature_id is None and field['widgettype'] != 'typeahead':
                _json = {}
                widget.editingFinished.connect(partial(self._clean_my_json, widget))
                widget.editingFinished.connect(partial(tools_gw.get_values, dialog, widget, _json))
                widget.editingFinished.connect(
                    partial(self._accept, dialog, self.complet_result, _json, widget, True, False, new_feature=new_feature))
            else:
                widget.editingFinished.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))

            widget.textChanged.connect(partial(self._enabled_accept, dialog))
            widget.textChanged.connect(partial(self._check_datatype_validator, dialog, widget, dialog.btn_accept))
            widget.textChanged.connect(partial(self._check_min_max_value, dialog, widget, dialog.btn_accept))

        return widget


    def _set_auto_update_textarea(self, field, dialog, widget, new_feature):

        if self._check_tab_data(dialog):
            # "and field['widgettype'] != 'typeahead'" It is necessary so that the textchanged signal of the typeahead
            # does not jump, making it lose focus, which will cause the accept function to jump sent invalid parameters
            if field['isautoupdate'] and self.new_feature_id is None and field['widgettype'] != 'typeahead':
                _json = {}
                widget.textChanged.connect(partial(self._clean_my_json, widget))
                widget.textChanged.connect(partial(tools_gw.get_values, dialog, widget, _json))
                widget.textChanged.connect(
                    partial(self._accept, dialog, self.complet_result, _json, widget, True, False, new_feature))
            else:
                widget.textChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))

            widget.textChanged.connect(partial(self._enabled_accept, dialog))
            widget.textChanged.connect(partial(self._check_datatype_validator, dialog, widget, dialog.btn_accept))
            widget.textChanged.connect(partial(self._check_min_max_value, dialog, widget, dialog.btn_accept))

        return widget


    def _set_auto_update_hyperlink(self, field, dialog, widget, new_feature=None):

        if self._check_tab_data(dialog):
            widget.editingFinished.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))

        return widget


    def _reload_fields(self, dialog, result, p_widget):
        """
        :param dialog: QDialog where find and set widgets
        :param result: row with info (json)
        :param p_widget: Widget that has changed
        """

        if not p_widget:
            return

        # Restore QLineEdit stylesheet
        widget_list = dialog.tab_data.findChildren(QLineEdit)
        for widget in widget_list:
            is_readonly = widget.isReadOnly()
            if is_readonly:
                widget.setStyleSheet("QLineEdit {background: rgb(244, 244, 244); color: rgb(100, 100, 100)}")
            else:
                widget.setStyleSheet(None)

        # Restore QPushButton stylesheet
        widget_list = dialog.tab_data.findChildren(QPushButton)
        for widget in widget_list:
            widget.setStyleSheet(None)

        # Restore widget stylesheet
        for field in result['body']['data']['fields']:
            widget = dialog.findChild(QLineEdit, f'{field["widgetname"]}')
            if widget is None:
                widget = dialog.findChild(QPushButton, f'{field["widgetname"]}')
            if widget:
                cur_value = tools_qt.get_text(dialog, widget)
                value = field["value"]
                if str(cur_value) != str(value):
                    widget.setText(value)
                    if not isinstance(widget, QPushButton):
                        widget.setStyleSheet("border: 2px solid #3ED396")
                    if getattr(widget, 'isReadOnly', False):
                        widget.setStyleSheet("QLineEdit {background: rgb(244, 244, 244); color: rgb(100, 100, 100); "
                                             "border: 2px solid #3ED396}")

            elif "message" in field:
                level = field['message']['level'] if 'level' in field['message'] else 0
                tools_qgis.show_message(field['message']['text'], level)


    def _enabled_accept(self, dialog):
        dialog.btn_accept.setEnabled(True)


    def _set_auto_update_combobox(self, field, dialog, widget, new_feature):

        if self._check_tab_data(dialog):
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                widget.currentIndexChanged.connect(partial(self._clean_my_json, widget))
                widget.currentIndexChanged.connect(partial(tools_gw.get_values, dialog, widget, _json))
                widget.currentIndexChanged.connect(partial(
                    self._accept, dialog, self.complet_result, _json, None, True, False, new_feature))
            else:
                widget.currentIndexChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))

        return widget


    def _set_auto_update_dateedit(self, field, dialog, widget, new_feature):

        if self._check_tab_data(dialog):
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                widget.valueChanged.connect(partial(self._clean_my_json, widget))
                widget.valueChanged.connect(partial(tools_gw.get_values, dialog, widget, _json))
                widget.valueChanged.connect(partial(
                    self._accept, dialog, self.complet_result, _json, None, True, False, new_feature))
            else:
                widget.valueChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))

        return widget


    def _set_auto_update_spinbox(self, field, dialog, widget, new_feature):

        if self._check_tab_data(dialog):
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                widget.valueChanged.connect(partial(self._clean_my_json, widget))
                widget.valueChanged.connect(partial(tools_gw.get_values, dialog, widget, _json))
                widget.valueChanged.connect(partial(
                    self._accept, dialog, self.complet_result, _json, None, True, False, new_feature))
            else:
                widget.valueChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))

        return widget


    def _set_auto_update_checkbox(self, field, dialog, widget, new_feature):

        if self._check_tab_data(dialog):
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                widget.stateChanged.connect(partial(self._clean_my_json, widget))
                widget.stateChanged.connect(partial(tools_gw.get_values, dialog, widget, _json))
                widget.stateChanged.connect(partial(
                    self._accept, dialog, self.complet_result, _json, None, True, False, new_feature))
            else:
                widget.stateChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))
        return widget


    def _run_settopology(self, widget, **kwargs):
        """ Sets node_1/2 from lineedit & converts widget into button if function run successfully """

        dialog = kwargs['dialog']
        field = kwargs['field']
        complet_result = kwargs['complet_result']
        feature_id = complet_result['body']['feature']['id']
        text = tools_qt.get_text(dialog, widget, return_string_null=True)

        if text in (None, 'null'):
            return

        feature = f'"id": "{feature_id}"'
        extras = f'"fields":{{"{widget.property("columnname")}":"{text}"}}'
        body = tools_gw.create_body(feature=feature, extras=extras)
        json_response = tools_gw.execute_procedure('gw_fct_settopology', body)
        if json_response and json_response['status'] != "Failed":
            # Refresh canvas & send a message
            tools_qgis.refresh_map_canvas()
            tools_qgis.show_info("Node set correctly", dialog=dialog)

            # Delete lineedit
            widget.deleteLater()
            # Create button with field from kwargs and value from {text}
            kwargs['field']['value'] = f"{text}"
            new_widget = self._manage_button(**kwargs)
            if new_widget is None:
                return
            # Add button to layout
            layout = self.dlg_cf.findChild(QGridLayout, field['layoutname'])
            if layout is not None:
                layout.addWidget(new_widget, int(field['layoutorder']), 2)
            return
        tools_qgis.show_warning("Error setting node", dialog=dialog)


    def _open_catalog(self, tab_type, feature_type, child_type):

        self.catalog = GwCatalog()

        # Check feature_type
        if self.feature_type == 'connec':
            widget = f'{tab_type}_{self.feature_type}at_id'
        elif self.feature_type == 'gully':
            widget = f'{tab_type}_gratecat_id'
        else:
            widget = f'{tab_type}_{self.feature_type}cat_id'
        self.catalog.open_catalog(self.dlg_cf, widget, feature_type, child_type)


    def _show_actions(self, dialog, tab_name):
        """
        Hide all actions and show actions for the corresponding tab
            :param tab_name: corresponding tab
        """

        actions_list = dialog.findChildren(QAction)
        for action in actions_list:
            action.setVisible(False)

        if 'visibleTabs' not in self.complet_result['body']['form']:
            return

        for tab in self.complet_result['body']['form']['visibleTabs']:
            if tab['tabName'] == tab_name:
                if tab['tabactions'] is not None:
                    for act in tab['tabactions']:
                        action = dialog.findChild(QAction, act['actionName'])
                        if action is not None:
                            action.setToolTip(act['actionTooltip'])
                            action.setVisible(True)

        self._enable_actions(dialog, self.layer.isEditable())


    def _check_elev_y(self):
        """ Show a warning if feature has both y and elev values """

        do_check = tools_gw.get_config_value('edit_check_redundance_y_topelev_elev', table='config_param_system')
        if do_check is not None and not tools_os.set_boolean(do_check[0], False):
            return False

        msg = f"This {self.feature_type} has redundant data on "
        # ARC
        if self.feature_type == 'arc':
            msg = f"{msg} both (elev & y) values. Review it and use only one."
            fields1 = 'y1, custom_y1, elev1, custom_elev1'
            sql = f"SELECT {fields1} FROM v_edit_arc WHERE {self.field_id} = '{self.feature_id}'"
            row = tools_db.get_row(sql)
            if row:
                has_y = (row[0], row[1]) != (None, None)
                has_elev = (row[2], row[3]) != (None, None)
                if has_y and has_elev:
                    tools_qgis.show_warning(msg, dialog=self.dlg_cf)
                    return False

            fields2 = 'y2, custom_y2, elev2, custom_elev2'
            sql = f"SELECT {fields2} FROM v_edit_arc WHERE {self.field_id} = '{self.feature_id}'"
            row = tools_db.get_row(sql)
            if row:
                has_y = (row[0], row[1]) != (None, None)
                has_elev = (row[2], row[3]) != (None, None)
                if has_y and has_elev:
                    tools_qgis.show_warning(msg, dialog=self.dlg_cf)
                    return False
        # NODE
        elif self.feature_type == 'node':
            msg = f"{msg} all (elev & ymax & top_elev) values. Review it and use at most two."
            fields = 'ymax, custom_ymax, elev, custom_elev, top_elev, custom_top_elev'
            sql = f"SELECT {fields} FROM v_edit_node WHERE {self.field_id} = '{self.feature_id}'"
            row = tools_db.get_row(sql)
            if row:
                has_y = (row[0], row[1]) != (None, None)
                has_elev = (row[2], row[3]) != (None, None)
                has_top_elev = (row[4], row[5]) != (None, None)
                if False not in (has_y, has_elev, has_top_elev):
                    tools_qgis.show_warning(msg, dialog=self.dlg_cf)
                    return False
        return True


    def _has_elev_and_y_json(self, _json):
        """ :returns True if feature has both y and elev values. False otherwise  """

        do_check = tools_gw.get_config_value('edit_check_redundance_y_topelev_elev', table='config_param_system')
        if do_check is not None and not tools_os.set_boolean(do_check[0], False):
            return False

        keys_list = ("y1", "custom_y1", "elev1", "custom_elev1",
                     "y2", "custom_y2", "elev2", "custom_elev2",
                     "ymax", "custom_ymax", "elev", "custom_elev", "top_elev", "custom_top_elev")

        # Check that edited field is y or elev
        has_modified = any(k in _json for k in keys_list)
        if not has_modified:
            return False

        # Get edited fields
        modified = [k for k in _json if k in keys_list]

        if self.new_feature_id is not None:
            return self._has_elev_y_json(_json, modified)

        for k in modified:
            if _json.get(k) in (None, ''):
                continue
            if self.feature_type == 'arc':
                # If edited field is Y check if feature has ELEV field
                if 'y' in k:
                    has_elev = self._has_elev(arc_n=k[-1:])
                    if has_elev:
                        msg = f"This feature already has ELEV values! Review it and use only one"
                        tools_qgis.show_warning(msg, dialog=self.dlg_cf)
                    return has_elev
                # If edited field is ELEV check if feature has Y field
                if 'elev' in k:
                    has_y = self._has_y(arc_n=k[-1:])
                    if has_y:
                        msg = f"This feature already has Y values! Review it and use only one"
                        tools_qgis.show_warning(msg, dialog=self.dlg_cf)
                    return has_y
            elif self.feature_type == 'node':
                # If edited field is Y check if feature has ELEV & TOP_ELEV field
                if 'y' in k:
                    has_elev = self._has_elev()
                    has_top_elev = self._has_top_elev()
                    if has_elev and has_top_elev:
                        msg = f"This feature already has ELEV & TOP_ELEV values! Review it and use at most two"
                        tools_qgis.show_warning(msg, dialog=self.dlg_cf)
                    return has_elev and has_top_elev
                # If edited field is TOP_ELEV check if feature has Y & ELEV field
                if 'top_elev' in k:
                    has_y = self._has_y()
                    has_elev = self._has_elev()
                    if has_y and has_elev:
                        msg = f"This feature already has Y & ELEV values! Review it and use at most two"
                        tools_qgis.show_warning(msg, dialog=self.dlg_cf)
                    return has_y and has_elev
                # If edited field is ELEV check if feature has Y & TOP_ELEV field
                elif 'elev' in k:
                    has_y = self._has_y()
                    has_top_elev = self._has_top_elev()
                    if has_y and has_top_elev:
                        msg = f"This feature already has Y & TOP_ELEV values! Review it and use at most two"
                        tools_qgis.show_warning(msg, dialog=self.dlg_cf)
                    return has_y and has_top_elev

        return False


    def _has_elev_y_json(self, _json, modified):
        """If we're creating new feature, check which keys are in json"""

        if self.feature_type == 'node':
            msg = f"This node has redundant data on (top_elev, ymax & elev) values. Review it and use at most two."
            # y
            ymax = _json.get('ymax')
            custom_ymax = _json.get('custom_ymax')
            has_ymax = (ymax, custom_ymax) != (None, None)
            # elev
            elev = _json.get('elev')
            custom_elev = _json.get('custom_elev')
            has_elev = (elev, custom_elev) != (None, None)
            # top_elev
            top_elev = _json.get('top_elev')
            custom_top_elev = _json.get('custom_top_elev')
            has_top_elev = (top_elev, custom_top_elev) != (None, None)

            for k in modified:
                if _json.get(k) in (None, ''):
                    continue
                if 'ymax' in k:
                    if has_elev and has_top_elev:
                        tools_qgis.show_warning(msg, dialog=self.dlg_cf)
                        return True
                if 'top_elev' in k:
                    if has_elev and has_ymax:
                        tools_qgis.show_warning(msg, dialog=self.dlg_cf)
                        return True
                elif 'elev' in k:
                    if has_top_elev and has_ymax:
                        tools_qgis.show_warning(msg, dialog=self.dlg_cf)
                        return True

            return False

        elif self.feature_type == 'arc':
            msg = f"This arc has redundant data on both (elev & y) values. Review it and use only one."
            # y1
            y1 = _json.get('y1')
            custom_y1 = _json.get('custom_y1')
            has_y1 = (y1, custom_y1) != (None, None)
            # elev1
            elev1 = _json.get('elev1')
            custom_elev1 = _json.get('custom_elev1')
            has_elev1 = (elev1, custom_elev1) != (None, None)
            # y2
            y2 = _json.get('y2')
            custom_y2 = _json.get('custom_y2')
            has_y2 = (y2, custom_y2) != (None, None)
            # elev2
            elev2 = _json.get('elev2')
            custom_elev2 = _json.get('custom_elev2')
            has_elev2 = (elev2, custom_elev2) != (None, None)

            for k in modified:
                if _json.get(k) in (None, ''):
                    continue
                if 'y1' in k:
                    if has_elev1:
                        tools_qgis.show_warning(msg, dialog=self.dlg_cf)
                        return True
                if 'elev1' in k:
                    if has_y1:
                        tools_qgis.show_warning(msg, dialog=self.dlg_cf)
                        return True
                if 'y2' in k:
                    if has_elev2:
                        tools_qgis.show_warning(msg, dialog=self.dlg_cf)
                        return True
                if 'elev2' in k:
                    if has_y2:
                        tools_qgis.show_warning(msg, dialog=self.dlg_cf)
                        return True

            return False

        return False


    def _has_y(self, arc_n=1):
        """ :returns True if feature has y values. False otherwise """

        if self.feature_type == 'arc':
            if arc_n not in (1, 2):
                arc_n = 1
            fields = f'y{arc_n}, custom_y{arc_n}'
            sql = f"SELECT {fields} FROM v_edit_arc WHERE {self.field_id} = '{self.feature_id}'"
            row = tools_db.get_row(sql)
            if row:
                return (row[0], row[1]) != (None, None)

        elif self.feature_type == 'node':
            fields = 'ymax, custom_ymax'
            sql = f"SELECT {fields} FROM v_edit_node WHERE {self.field_id} = '{self.feature_id}'"
            row = tools_db.get_row(sql)
            if row:
                return (row[0], row[1]) != (None, None)

        return True


    def _has_elev(self, arc_n=1):
        """ :returns True if feature has elev values. False otherwise """

        if self.feature_type == 'arc':
            if arc_n not in (1, 2):
                arc_n = 1
            fields = f'elev{arc_n}, custom_elev{arc_n}'
            sql = f"SELECT {fields} FROM v_edit_arc WHERE {self.field_id} = '{self.feature_id}'"
            row = tools_db.get_row(sql)
            if row:
                return (row[0], row[1]) != (None, None)

        elif self.feature_type == 'node':
            fields = 'elev, custom_elev'
            sql = f"SELECT {fields} FROM v_edit_node WHERE {self.field_id} = '{self.feature_id}'"
            row = tools_db.get_row(sql)
            if row:
                return (row[0], row[1]) != (None, None)

        return True


    def _has_top_elev(self):
        """ :returns True if feature has top_elev values. False otherwise """

        if self.feature_type == 'node':
            fields = 'top_elev, custom_top_elev'
            sql = f"SELECT {fields} FROM v_edit_node WHERE {self.field_id} = '{self.feature_id}'"
            row = tools_db.get_row(sql)
            if row:
                return (row[0], row[1]) != (None, None)

        return True

    """ MANAGE TABS """

    def _tab_activation(self, dialog, new_feature):
        """ Call functions depend on tab selection """

        # Get index of selected tab
        index_tab = self.tab_main.currentIndex()
        tab_name = self.tab_main.widget(index_tab).objectName()
        self._show_actions(dialog, tab_name)

        # Tab 'Elements'
        if self.tab_main.widget(index_tab).objectName() == 'tab_elements' and not self.tab_element_loaded:
            self._fill_tab_element()
            self.tab_element_loaded = True
        # Tab 'Relations'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_relations' and not self.tab_relations_loaded:
            self._fill_tab_relations()
            self.tab_relations_loaded = True
        # Tab 'Connections'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_connections' and not self.tab_connections_loaded:
            self._fill_tab_connections()
            self.tab_connections_loaded = True
        # Tab 'Hydrometer'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_hydrometer' and not self.tab_hydrometer_loaded:
            self._fill_tab_hydrometer()
            self.tab_hydrometer_loaded = True
        # Tab 'Hydrometer values'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_hydrometer_val' and not self.tab_hydrometer_val_loaded:
            self._fill_tab_hydrometer_values()
            self.tab_hydrometer_val_loaded = True
        # Tab 'Visit'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_visit' and not self.tab_visit_loaded:
            self._fill_tab_visit(self.feature_type)
            self.tab_visit_loaded = True
        # Tab 'Event'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_event' and not self.tab_event_loaded:
            self._fill_tab_event(self.feature_type)
            self.tab_event_loaded = True
        # Tab 'Documents'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_documents' and not self.tab_document_loaded:
            self._fill_tab_document()
            self.tab_document_loaded = True
        elif self.tab_main.widget(index_tab).objectName() == 'tab_rpt' and not self.tab_rpt_loaded:
            self._fill_tab_rpt(self.complet_result, new_feature)
            self.tab_rpt_loaded = True
        # Tab 'Plan'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_plan' and not self.tab_plan_loaded:
            self._fill_tab_plan(self.complet_result)
            self.tab_plan_loaded = True


    def _fill_tab_element(self):
        """ Fill tab 'Element' """

        table_element = "v_ui_element_x_" + self.feature_type
        self._fill_tbl_element_man(self.dlg_cf, self.tbl_element, table_element, self.filter)
        tools_gw.set_tablemodel_config(self.dlg_cf, self.tbl_element, table_element)


    def _fill_tbl_element_man(self, dialog, widget, table_name, expr_filter):
        """ Fill the table control to show elements """

        if not self.feature:
            self._get_feature(self.tab_type)

        # Get widgets
        self.element_id = self.dlg_cf.findChild(QLineEdit, "element_id")
        btn_open_element = self.dlg_cf.findChild(QPushButton, "btn_open_element")
        btn_delete = self.dlg_cf.findChild(QPushButton, "btn_delete")
        btn_insert = self.dlg_cf.findChild(QPushButton, "btn_insert")
        btn_new_element = self.dlg_cf.findChild(QPushButton, "btn_new_element")

        # Set signals
        self.tbl_element.doubleClicked.connect(partial(self._open_selected_element, dialog, widget))
        btn_open_element.clicked.connect(partial(self._open_selected_element, dialog, widget))
        btn_delete.clicked.connect(partial(self._delete_records, widget, table_name))
        btn_insert.clicked.connect(partial(self._add_object, widget, "element", "v_ui_element"))
        btn_new_element.clicked.connect(partial(self._manage_element, dialog, feature=self.feature))

        # Set model of selected widget
        message = tools_qt.fill_table(widget, table_name, expr_filter)
        if message:
            tools_qgis.show_warning(message)

        # Adding auto-completion to a QLineEdit
        self.table_object = "element"
        tools_gw.set_completer_object(dialog, self.table_object)


    def _open_selected_element(self, dialog, widget):
        """ Open form of selected element of the @widget?? """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.dlg_cf)
            return

        element_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            element_id = widget.model().record(row).value("element_id")
            break

        # Open selected element
        self._manage_element(dialog, element_id)


    def _add_object(self, widget, table_object, view_object):
        """ Add object (doc or element) to selected feature """

        # Get values from dialog
        object_id = tools_qt.get_text(self.dlg_cf, table_object + "_id")
        if object_id == 'null':
            message = "You need to insert data"
            tools_qgis.show_warning(message, parameter=table_object + "_id", dialog=self.dlg_cf)
            return

        # Check if this object exists
        field_object_id = "id"
        sql = ("SELECT * FROM " + view_object + ""
               " WHERE " + field_object_id + " = '" + object_id + "'")
        row = tools_db.get_row(sql)
        if not row:
            tools_qgis.show_warning("Object id not found", parameter=object_id, dialog=self.dlg_cf)
            return

        # Check if this object is already associated to current feature
        field_object_id = table_object + "_id"
        tablename = table_object + "_x_" + self.feature_type
        sql = ("SELECT *"
               " FROM " + str(tablename) + ""
               " WHERE " + str(self.field_id) + " = '" + str(self.feature_id) + "'"
               " AND " + str(field_object_id) + " = '" + str(object_id) + "'")
        row = tools_db.get_row(sql, log_info=False)

        # If object already exist show warning message
        if row:
            message = "Object already associated with this feature"
            tools_qgis.show_warning(message, dialog=self.dlg_cf)

        # If object not exist perform an INSERT
        else:
            sql = ("INSERT INTO " + tablename + " "
                   "(" + str(field_object_id) + ", " + str(self.field_id) + ")"
                   " VALUES ('" + str(object_id) + "', '" + str(self.feature_id) + "');")
            tools_db.execute_sql(sql, log_sql=False)
            if widget.objectName() == 'tbl_document':
                date_to = self.dlg_cf.tab_main.findChild(QDateEdit, 'date_document_to')
                if date_to:
                    current_date = QDate.currentDate()
                    date_to.setDate(current_date)
            widget.model().select()


    def _delete_records(self, widget, table_name):
        """ Delete selected objects (elements or documents) of the @widget """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.dlg_cf)
            return

        inf_text = ""
        list_object_id = ""
        row_index = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            object_id = widget.model().record(row).value("doc_id")
            id_ = widget.model().record(row).value("id")
            if object_id is None:
                object_id = widget.model().record(row).value("element_id")
            inf_text += str(object_id) + ", "
            list_id += str(id_) + ", "
            list_object_id = list_object_id + str(object_id) + ", "
            row_index += str(row + 1) + ", "

        list_object_id = list_object_id[:-2]
        list_id = list_id[:-2]
        message = "Are you sure you want to delete these records?"
        answer = tools_qt.show_question(message, "Delete records", list_object_id)
        if answer:
            sql = f"DELETE FROM {table_name} WHERE id::integer IN ({list_id})"
            tools_db.execute_sql(sql, log_sql=False)
            widget.model().select()


    """ FUNCTIONS RELATED WITH TAB ELEMENT"""


    def _manage_element(self, dialog, element_id=None, feature=None):
        """ Execute action of button 33 """

        elem = GwElement()
        elem.get_element(False, feature, self.feature_type)
        elem.dlg_add_element.accepted.connect(partial(self._manage_element_new, dialog, elem))
        elem.dlg_add_element.rejected.connect(partial(self._manage_element_new, dialog, elem))

        # Set completer
        tools_gw.set_completer_object(dialog, self.table_object)

        if element_id:
            tools_qt.set_widget_text(elem.dlg_add_element, "element_id", element_id)

        # Open dialog
        tools_gw.open_dialog(elem.dlg_add_element)


    def _manage_element_new(self, dialog, elem):
        """ Get inserted element_id and add it to current feature """

        if elem.element_id is None:
            return

        tools_qt.set_widget_text(dialog, "element_id", elem.element_id)
        self._add_object(self.tbl_element, "element", "v_ui_element")
        self.tbl_element.model().select()


    """ FUNCTIONS RELATED WITH TAB RELATIONS"""

    def _fill_tab_relations(self):
        """ Fill tab 'Relations' """

        table_relations = f"v_ui_{self.feature_type}_x_relations"
        message = tools_qt.fill_table(self.tbl_relations, self.schema_name + "." + table_relations, self.filter)
        if message:
            tools_qgis.show_warning(message)
        tools_gw.set_tablemodel_config(self.dlg_cf, self.tbl_relations, table_relations)
        self.tbl_relations.selectionModel().selectionChanged.connect(partial(self._manage_tab_relations_highlight, self.tbl_relations))
        self.tbl_relations.doubleClicked.connect(partial(self._open_selected_feature, self.tbl_relations))


    def _manage_tab_relations_highlight(self, qtable, selected):

        # Get id of selected row
        index = selected.indexes()
        if not index:
            self.rubber_band.reset()
            return

        # Get tablename
        index = index[0]
        table_name = qtable.model().record(index.row()).value("sys_table_id")
        # Highlight feature
        tools_qgis.hilight_feature_by_id(qtable, table_name, f"{table_name.split('_')[-1]}_id", self.rubber_band, 5,
                                         index, table_field="feature_id")


    def _open_selected_feature(self, qtable):
        """ Open selected feature from @qtable """

        selected_list = qtable.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.dlg_cf)
            return

        row = selected_list[0].row()
        table_name = qtable.model().record(row).value("sys_table_id")
        feature_id = qtable.model().record(row).value("feature_id")
        info_feature = GwInfo(self.tab_type)
        complet_result, dialog = info_feature.open_form(table_name=table_name, feature_id=feature_id, tab_type=self.tab_type)
        if not complet_result:
            tools_log.log_info("FAIL open_up_down_stream")
            return

        margin = float(complet_result['body']['feature']['zoomCanvasMargin']['mts'])
        tools_gw.draw_by_json(complet_result, self.rubber_band, margin)


    """ FUNCTIONS RELATED WITH TAB CONNECTIONS """


    def _fill_tab_connections(self):
        """ Fill tab 'Connections' """

        filter_ = f"node_id='{self.feature_id}'"
        table_name = f"{self.schema_name}.v_ui_node_x_connection_upstream"
        message = tools_qt.fill_table(self.dlg_cf.tbl_upstream, table_name, filter_)
        if message:
            tools_qgis.show_warning(message)
        tools_gw.set_tablemodel_config(self.dlg_cf, self.dlg_cf.tbl_upstream, "v_ui_node_x_connection_upstream")

        table_name = f"{self.schema_name}.v_ui_node_x_connection_downstream"
        message = tools_qt.fill_table(self.dlg_cf.tbl_downstream, table_name, filter_)
        if message:
            tools_qgis.show_warning(message)
        tools_gw.set_tablemodel_config(self.dlg_cf, self.dlg_cf.tbl_downstream, "v_ui_node_x_connection_downstream")

        self.dlg_cf.tbl_upstream.doubleClicked.connect(partial(self._open_selected_feature, self.tbl_upstream))
        self.dlg_cf.tbl_downstream.doubleClicked.connect(partial(self._open_selected_feature, self.tbl_downstream))


    """ FUNCTIONS RELATED WITH TAB HYDROMETER"""


    def _fill_tab_hydrometer(self):
        """ Fill tab 'Hydrometer' """

        table_hydro = "v_ui_hydrometer"
        txt_hydrometer_id = self.dlg_cf.findChild(QLineEdit, "txt_hydrometer_id")
        self._fill_tbl_hydrometer(self.tbl_hydrometer, table_hydro)
        txt_hydrometer_id.textChanged.connect(partial(self._fill_tbl_hydrometer, self.tbl_hydrometer, table_hydro))
        self.tbl_hydrometer.doubleClicked.connect(partial(self._open_selected_hydro, self.tbl_hydrometer))
        self.dlg_cf.findChild(QPushButton, "btn_link").clicked.connect(self._check_url)


    def _open_selected_hydro(self, qtable=None):

        selected_list = qtable.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.dlg_cf)
            return

        index = selected_list[0]
        row = index.row()

        table_name = 'v_ui_hydrometer'
        column_index = tools_qt.get_col_index_by_col_name(qtable, 'hydrometer_id')
        feature_id = index.sibling(row, column_index).data()

        # return
        info_feature = GwInfo(self.tab_type)
        complet_result, dialog = info_feature.open_form(table_name=table_name, feature_id=feature_id, tab_type=self.tab_type)
        if not complet_result:
            tools_log.log_info("FAIL open_selected_hydro")
            return


    def _check_url(self):
        """ Check URL. Enable/Disable button that opens it """

        selected_list = self.tbl_hydrometer.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.dlg_cf)
            return

        row = selected_list[0].row()
        url = self.tbl_hydrometer.model().record(row).value("hydrometer_link")
        if url != '':
            status, message = tools_os.open_file(url)
            if status is False and message is not None:
                tools_qgis.show_warning(message, parameter=url, dialog=self.dlg_cf)


    def _fill_tbl_hydrometer(self, qtable, table_name):
        """ Fill the table control to show hydrometers """

        txt_hydrometer_id = self.dlg_cf.findChild(QLineEdit, "txt_hydrometer_id")
        filter = f"connec_id = '{self.feature_id}' "
        filter += f" AND hydrometer_customer_code ILIKE '%{txt_hydrometer_id.text()}%'"

        # Set model of selected widget
        message = tools_qt.fill_table(qtable, f"{self.schema_name}.{table_name}", filter)
        if message:
            tools_qgis.show_warning(message)
        tools_gw.set_tablemodel_config(self.dlg_cf, qtable, table_name)


    """ FUNCTIONS RELATED WITH TAB HYDROMETER VALUES"""


    def _fill_tab_hydrometer_values(self):

        table_hydro_value = "v_ui_hydroval_x_connec"

        # Populate combo filter hydrometer peridod
        sql = (f"SELECT DISTINCT(t1.code), t2.cat_period_id "
               f"FROM ext_cat_period AS t1 "
               f"JOIN (SELECT * FROM v_ui_hydroval_x_connec WHERE connec_id = '" + str(self.feature_id) + "' "
			   f") AS t2 on t1.id = t2.cat_period_id "
               f"ORDER BY t2.cat_period_id DESC")
        rows = tools_db.get_rows(sql)
        if not rows:
            return False
        tools_qt.fill_combo_values(self.dlg_cf.cmb_cat_period_id_filter, rows, add_empty=True, sort_combo=False)

        # Populate combo filter hydrometer peridod
        sql = ("SELECT hydrometer_id, hydrometer_customer_code "
               " FROM v_rtc_hydrometer "
               " WHERE connec_id = '" + str(self.feature_id) + "' "
               " ORDER BY hydrometer_customer_code")
        rows_list = []
        rows = tools_db.get_rows(sql)
        rows_list.append(['', ''])
        if rows:
            for row in rows:
                rows_list.append(row)
        tools_qt.fill_combo_values(self.dlg_cf.cmb_hyd_customer_code, rows_list, 1)

        self._fill_tbl_hydrometer_values(self.tbl_hydrometer_value, table_hydro_value)
        tools_gw.set_tablemodel_config(self.dlg_cf, self.tbl_hydrometer_value, table_hydro_value)

        self.dlg_cf.cmb_cat_period_id_filter.currentIndexChanged.connect(
            partial(self._fill_tbl_hydrometer_values, self.tbl_hydrometer_value, table_hydro_value))
        self.dlg_cf.cmb_hyd_customer_code.currentIndexChanged.connect(
            partial(self._fill_tbl_hydrometer_values, self.tbl_hydrometer_value, table_hydro_value))


    def _fill_tbl_hydrometer_values(self, qtable, table_name):
        """ Fill the table control to show hydrometers values """

        cat_period = tools_qt.get_combo_value(self.dlg_cf, self.dlg_cf.cmb_cat_period_id_filter, 1)
        customer_code = tools_qt.get_combo_value(self.dlg_cf, self.dlg_cf.cmb_hyd_customer_code)
        filter_ = f"connec_id::text = '{self.feature_id}' "
        if cat_period != '':
            filter_ += f" AND cat_period_id::text = '{cat_period}'"
        if customer_code != '':
            filter_ += f" AND hydrometer_id::text = '{customer_code}'"

        # Set model of selected widget
        edit_strategy = QSqlTableModel.OnFieldChange
        message = tools_qt.fill_table(qtable, f"{self.schema_name}.{table_name}", filter_, edit_strategy)
        if message:
            tools_qgis.show_warning(message)
        tools_gw.set_tablemodel_config(self.dlg_cf, self.tbl_hydrometer_value, table_name)


    """ FUNTIONS RELATED WITH TAB VISIT """

    def _fill_tab_visit(self, geom_type):
        """ Fill tab Visit """

        sql = f"SELECT id, ui_tablename FROM config_visit_class WHERE feature_type = upper('{geom_type}') AND ui_tablename IS NOT NULL"
        rows = tools_db.get_rows(sql)
        table_visit_node_dict = {}
        if not rows:
            return
        for row in rows:
            table_visit_node_dict[row[0]] = str(row[1])
        self._fill_tbl_visit(self.tbl_visit_cf, table_visit_node_dict, self.filter, geom_type)


    def _fill_tbl_visit(self, widget, table_name, filter_, geom_type):
        """ Fill the table control to show documents """

        # Get widgets
        tools_qt.set_tableview_config(widget)
        self.cmb_visit_class = self.dlg_cf.findChild(QComboBox, "cmb_visit_class")
        self.date_visit_to = self.dlg_cf.findChild(QDateEdit, "date_visit_to")
        self.date_visit_from = self.dlg_cf.findChild(QDateEdit, "date_visit_from")
        date = QDate.currentDate()
        self.date_visit_to.setDate(date)

        btn_open_gallery = self.dlg_cf.findChild(QPushButton, "btn_open_gallery_2")
        btn_open_gallery.setEnabled(False)

        btn_visit_intervals = self.dlg_cf.findChild(QPushButton, "btn_visit_intervals")
        btn_visit_intervals.setEnabled(False)

        feature_key = f"{geom_type}_id"
        feature_type = geom_type.upper()

        # Get selected dates
        date_from = self.date_visit_from.date().toString('yyyyMMdd 00:00:00')
        date_to = self.date_visit_to.date().toString('yyyyMMdd 23:59:59')
        if date_from > date_to:
            message = "Selected date interval is not valid"
            tools_qgis.show_warning(message, dialog=self.dlg_cf)
            return

        # Fill ComboBox cmb_visit_class
        sql = ("SELECT DISTINCT(class_id), config_visit_class.idval"
               " FROM v_ui_om_visit_x_" + feature_type.lower() + ""
               " JOIN config_visit_class ON config_visit_class.id = v_ui_om_visit_x_" + feature_type.lower() + ".class_id"
               " WHERE " + feature_key + " IS NOT NULL AND " + str(feature_key) + " = '" + str(self.feature_id) + "' AND ui_tablename IS NOT NULL")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.cmb_visit_class, rows, 1)

        # Set signals
        widget.clicked.connect(partial(self._tbl_visit_clicked, table_name))
        widget.doubleClicked.connect(partial(self._open_generic_visit, widget, table_name))
        if tools_qt.get_combo_value(self.dlg_cf, self.cmb_visit_class, 0) not in (None, ''):
            filter_ += " AND startdate >= '" + date_from + "' AND startdate <= '" + date_to + "'"
            self.cmb_visit_class.currentIndexChanged.connect(partial(self._set_filter_table_visit, widget, table_name,
            visit_class=True, column_filter=feature_key, value_filter=self.feature_id))

            self.date_visit_to.dateChanged.connect(partial(self._set_filter_table_visit, widget, table_name,
                visit_class=False, column_filter=feature_key, value_filter=self.feature_id))
            self.date_visit_from.dateChanged.connect(partial(self._set_filter_table_visit, widget, table_name,
                visit_class=False, column_filter=feature_key, value_filter=self.feature_id))

            btn_open_gallery.clicked.connect(partial(self._open_visit_files))

            btn_visit_intervals.clicked.connect(partial(self._open_visit_intervals))

            table_name = str(table_name[tools_qt.get_combo_value(self.dlg_cf, self.cmb_visit_class, 0)])

            # Set model of selected widgetf.dlg_cf, self.cmb_visit_class, 0)])
            tools_gw.set_config_parser('visit', 'om_visit_table_name', table_name, 'user', 'session')
            tools_qt.fill_table(widget, table_name, filter_)
            self._set_filter_dates('startdate', 'enddate', table_name, self.date_visit_from, self.date_visit_to,
                                   column_filter=feature_key, value_filter=self.feature_id, widget=widget)
        # Manage config_form_tableview
        tools_gw.set_tablemodel_config(self.dlg_cf, widget, table_name)


    def _open_generic_visit(self, widget, table_name):

        table_name = str(table_name[tools_qt.get_combo_value(self.dlg_cf, self.cmb_visit_class, 0)])

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.dlg_cf)
            return

        visit_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            visit_id = widget.model().record(row).value("visit_id")
            break

        sql = (f"SELECT gw_fct_getfeatureinfo('{table_name}', '{visit_id}', 3, 100, 'false', 'visit_id', 'integer', '')")
        row = tools_db.get_row(sql)
        _json = json.dumps(row[0])
        _json = f'{{"body":{{"data":{{"fields":{_json}}}}}}}'
        result_json = json.loads(_json)

        self.dlg_generic_visit = GwInfoGenericUi()
        tools_gw.load_settings(self.dlg_generic_visit)
        self.dlg_generic_visit.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_generic_visit))
        self.dlg_generic_visit.rejected.connect(partial(tools_gw.close_dialog, self.dlg_generic_visit))
        tools_gw.build_dialog_info(self.dlg_generic_visit, result_json)

        # Disable button accept for info on generic form
        self.dlg_generic_visit.btn_accept.setEnabled(False)

        self.dlg_generic_visit.rejected.connect(self.rubber_band.reset)
        tools_gw.open_dialog(self.dlg_generic_visit, dlg_name='info_generic')


    def _set_filter_table_visit(self, widget, table_name, visit_class=False, column_filter=None, value_filter=None):
        """ Get values selected by the user and sets a new filter for its table model """

        # Get selected dates
        date_from = self.date_visit_from.date().toString('yyyyMMdd 00:00:00')
        date_to = self.date_visit_to.date().toString('yyyyMMdd 23:59:59')
        if date_from > date_to:
            message = "Selected date interval is not valid"
            tools_qgis.show_warning(message, dialog=self.dlg_cf)
            return

        if type(table_name) is dict:
            table_name = str(table_name[tools_qt.get_combo_value(self.dlg_cf, self.cmb_visit_class, 0)])

        # Set model of selected widget
        if visit_class:
            tools_qt.fill_table(widget, table_name, self.filter)
            self._set_filter_dates('startdate', 'enddate', table_name, self.date_visit_from, self.date_visit_to,
                                   column_filter, value_filter)
            date_from = self.date_visit_from.date().toString('yyyyMMdd 00:00:00')
            date_to = self.date_visit_to.date().toString('yyyyMMdd 23:59:59')

            # Manage config_form_tableview
            if len(table_name.split(".")) > 1:
                tbl_name = table_name.split(".")[1]
            else:
                tbl_name = table_name
            tools_gw.set_tablemodel_config(self.dlg_cf, widget, tbl_name)

        # Set filter to model
        expr = self.field_id + " = '" + self.feature_id + "'"
        expr += " AND startdate >= '" + date_from + "' AND startdate <= '" + date_to + "'"

        # Get selected values in Comboboxes
        visit_class_value = tools_qt.get_combo_value(self.dlg_cf, self.cmb_visit_class, 0)
        if str(visit_class_value) != 'null':
            expr += " AND class_id::text = '" + str(visit_class_value) + "'"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()


    def _tbl_visit_clicked(self, table_name):

        # Enable/Disable buttons
        btn_open_gallery = self.dlg_cf.findChild(QPushButton, "btn_open_gallery_2")
        btn_open_visit_doc = self.dlg_cf.findChild(QPushButton, "btn_open_visit_doc")
        btn_visit_intervals = self.dlg_cf.findChild(QPushButton, "btn_visit_intervals")
        btn_visit_intervals.setEnabled(False)
        btn_open_gallery.setEnabled(False)
        btn_open_visit_doc.setEnabled(False)

        # Get selected row
        selected_list = self.tbl_visit_cf.selectionModel().selectedRows()
        selected_row = selected_list[0].row()
        self.visit_id = self.tbl_visit_cf.model().record(selected_row).value("visit_id")
        self.parameter_id = self.tbl_visit_cf.model().record(selected_row).value("parameter_id")

        # Visit intervals
        sql = f"SELECT value FROM config_param_system WHERE parameter = 'plugin_lotmanage'"
        plugin_lot = tools_db.get_row(sql)

        if plugin_lot:

            #Visit intervals
            sql = f"SELECT lot_id, unit_id FROM om_visit WHERE id = '{self.visit_id}' "
            row = tools_db.get_row(sql)

            if row:
                self.visit_lot_id = row[0]
                self.visit_unit_id = row[1]
                if self.visit_lot_id is not None and self.visit_unit_id is not None:
                    sql = f"SELECT * FROM om_unit_intervals WHERE unit_id = {self.visit_unit_id} and lot_id = {self.visit_lot_id}"
                    rows = tools_db.get_rows(sql)
                    if rows:
                            btn_visit_intervals.setEnabled(True)

            #gallery
            if type(table_name) is dict:
                table_name = str(table_name[tools_qt.get_combo_value(self.dlg_cf, self.cmb_visit_class, 0)])

            sql = (f"SELECT column_name FROM information_schema.columns "
                   f"WHERE table_name = '{table_name}' AND column_name='photo'")
            column_exist = tools_db.get_row(sql)

            if column_exist:
                sql = f"SELECT photo FROM {table_name} WHERE photo IS TRUE AND visit_id = '{self.visit_id}'"
                row = tools_db.get_row(sql)
            else:
                row = None

            if not row:
                return

            # If gallery 'True' or 'False'
            if str(row[0]) == 'True':
                btn_open_gallery.setEnabled(True)


    def _open_visit_files(self):

        sql = (f"SELECT value FROM om_visit_event_photo"
               f" WHERE visit_id = '{self.visit_id}'")
        rows = tools_db.get_rows(sql)
        for path in rows:
            # Open selected document
            status, message = tools_os.open_file(path[0])
            if status is False and message is not None:
                tools_qgis.show_warning(message, parameter=path[0], dialog=self.dlg_cf)


    def _open_visit_intervals(self):

        self.visit_intervals_qtable = QTableView()
        filter = f"unit_id = {self.visit_unit_id} and lot_id = {self.visit_lot_id}"
        tools_qt.fill_table(self.visit_intervals_qtable, 'v_ui_om_unit_intervals', filter)

        self.visit_intervals_qtable.window().setWindowFlags(Qt.WindowStaysOnTopHint)
        self.visit_intervals_qtable.window().setWindowTitle("Visit Intervals")
        self.visit_intervals_qtable.window().resize(600, 300)
        self.visit_intervals_qtable.window().setMinimumSize(500, 200)
        self.visit_intervals_qtable.horizontalHeader().setSectionResizeMode(1)
        self.visit_intervals_qtable.horizontalHeader().setMinimumSectionSize(100)
        self.visit_intervals_qtable.show()



    def _set_filter_dates(self, mindate, maxdate, table_name, widget_fromdate, widget_todate, column_filter=None,
                          value_filter=None, widget=None):

        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        sql = (f"SELECT MIN({mindate}), MAX({maxdate}) "
               f"FROM {table_name}")
        if column_filter is not None and value_filter is not None:
            sql += f" WHERE {column_filter} = '{value_filter}'"
        row = tools_db.get_row(sql)
        if row:
            widget_fromdate.blockSignals(True)
            widget_todate.blockSignals(True)
            if row[0]:
                widget_fromdate.setDate(row[0])
            else:
                current_date = QDate.currentDate()
                widget_fromdate.setDate(current_date)
            if row[1]:
                widget_todate.setDate(row[1])
            else:
                current_date = QDate.currentDate()
                widget_todate.setDate(current_date)

            widget_fromdate.blockSignals(False)
            widget_todate.blockSignals(False)
            if widget is not None:
                self._set_filter_table_visit(widget, table_name)


    """ FUNCTIONS RELATED WITH TAB EVENT"""


    def _fill_tab_event(self, feature_type):
        """ Fill tab 'O&M' (event) """

        table_event_geom = "v_ui_event_x_" + feature_type
        self._fill_tbl_event(self.tbl_event_cf, table_event_geom)
        self.tbl_event_cf.doubleClicked.connect(self._open_visit_event)
        tools_gw.set_tablemodel_config(self.dlg_cf, self.tbl_event_cf, table_event_geom)


    def _fill_tbl_event(self, widget, table_name):
        """ Fill the table control to show events """

        # Get widgets
        widget.setSelectionBehavior(QAbstractItemView.SelectRows)
        event_type = self.dlg_cf.findChild(QComboBox, "event_type")
        event_id = self.dlg_cf.findChild(QComboBox, "event_id")
        self.date_event_to = self.dlg_cf.findChild(QDateEdit, "date_event_to")
        self.date_event_from = self.dlg_cf.findChild(QDateEdit, "date_event_from")

        tools_gw.set_dates_from_to(self.date_event_from, self.date_event_to, table_name, 'visit_start', 'visit_end')

        btn_open_visit = self.dlg_cf.findChild(QPushButton, "btn_open_visit")
        btn_new_visit = self.dlg_cf.findChild(QPushButton, "btn_new_visit")
        btn_open_gallery = self.dlg_cf.findChild(QPushButton, "btn_open_gallery")
        btn_open_visit_doc = self.dlg_cf.findChild(QPushButton, "btn_open_visit_doc")
        btn_open_visit_event = self.dlg_cf.findChild(QPushButton, "btn_open_visit_event")

        btn_open_gallery.setEnabled(False)
        btn_open_visit_doc.setEnabled(False)
        btn_open_visit_event.setEnabled(False)

        # Set signals
        widget.clicked.connect(partial(self._tbl_event_clicked, table_name))
        event_type.currentIndexChanged.connect(partial(self._set_filter_table_event, widget))
        event_id.currentIndexChanged.connect(partial(self._set_filter_table_event2, widget))
        self.date_event_to.dateChanged.connect(partial(self._set_filter_table_event, widget))
        self.date_event_from.dateChanged.connect(partial(self._set_filter_table_event, widget))

        btn_open_visit.clicked.connect(self._open_visit)
        btn_new_visit.clicked.connect(self._new_visit)
        btn_open_gallery.clicked.connect(self._open_gallery)
        btn_open_visit_doc.clicked.connect(self._open_visit_doc)
        btn_open_visit_event.clicked.connect(self._open_visit_event)

        feature_type = {'arc_id': 'ARC', 'connec_id': 'CONNEC', 'gully_id': 'GULLY', 'node_id': 'NODE'}
        table_name_event_id = "config_visit_parameter"

        # Fill ComboBox event_id
        sql = (f"SELECT DISTINCT(id), id "
               f"FROM {table_name_event_id} "
               f"WHERE feature_type = '{feature_type[self.field_id]}' OR feature_type = 'ALL' "
               f"ORDER BY id;")
        rows = tools_db.get_rows(sql)
        if rows:
            rows.append(['', ''])
            tools_qt.fill_combo_values(self.dlg_cf.event_id, rows)
        # Fill ComboBox event_type
        sql = (f"SELECT DISTINCT(parameter_type), parameter_type "
               f"FROM {table_name_event_id} "
               f"WHERE feature_type = '{feature_type[self.field_id]}' OR feature_type = 'ALL' "
               f"ORDER BY parameter_type;")
        rows = tools_db.get_rows(sql)
        if rows:
            rows.append(['', ''])
            tools_qt.fill_combo_values(self.dlg_cf.event_type, rows)

        message = tools_qt.fill_table(widget, table_name)
        if message:
            tools_qgis.show_warning(message)
        self._set_filter_table_event(widget)


    def _open_visit_event(self):
        """ Open event of selected record of the table """

        # Open dialog event_standard
        self.dlg_event_full = GwVisitEventFullUi()
        tools_gw.load_settings(self.dlg_event_full)
        self.dlg_event_full.rejected.connect(partial(tools_gw.close_dialog, self.dlg_event_full))
        # Get all data for one visit
        sql = (f"SELECT * FROM om_visit_event"
               f" WHERE id = '{self.event_id}' AND visit_id = '{self.visit_id}';")
        row = tools_db.get_row(sql)
        if not row:
            return

        tools_qt.set_widget_text(self.dlg_event_full, self.dlg_event_full.id, row['id'])
        tools_qt.set_widget_text(self.dlg_event_full, self.dlg_event_full.event_code, row['event_code'])
        tools_qt.set_widget_text(self.dlg_event_full, self.dlg_event_full.visit_id, row['visit_id'])
        tools_qt.set_widget_text(self.dlg_event_full, self.dlg_event_full.position_id, row['position_id'])
        tools_qt.set_widget_text(self.dlg_event_full, self.dlg_event_full.position_value, row['position_value'])
        tools_qt.set_widget_text(self.dlg_event_full, self.dlg_event_full.parameter_id, row['parameter_id'])
        tools_qt.set_widget_text(self.dlg_event_full, self.dlg_event_full.value, row['value'])
        tools_qt.set_widget_text(self.dlg_event_full, self.dlg_event_full.value1, row['value1'])
        tools_qt.set_widget_text(self.dlg_event_full, self.dlg_event_full.value2, row['value2'])
        tools_qt.set_widget_text(self.dlg_event_full, self.dlg_event_full.geom1, row['geom1'])
        tools_qt.set_widget_text(self.dlg_event_full, self.dlg_event_full.geom2, row['geom2'])
        tools_qt.set_widget_text(self.dlg_event_full, self.dlg_event_full.geom3, row['geom3'])
        tools_qt.set_widget_text(self.dlg_event_full, self.dlg_event_full.xcoord, row['xcoord'])
        tools_qt.set_widget_text(self.dlg_event_full, self.dlg_event_full.ycoord, row['ycoord'])
        tools_qt.set_widget_text(self.dlg_event_full, self.dlg_event_full.compass, row['compass'])
        tools_qt.set_widget_text(self.dlg_event_full, self.dlg_event_full.tstamp, row['tstamp'])
        tools_qt.set_widget_text(self.dlg_event_full, self.dlg_event_full.text, row['text'])
        tools_qt.set_widget_text(self.dlg_event_full, self.dlg_event_full.index_val, row['index_val'])
        tools_qt.set_widget_text(self.dlg_event_full, self.dlg_event_full.is_last, row['is_last'])
        self._populate_tbl_docs_x_event()

        # Set all QLineEdit readOnly(True)

        widget_list = self.dlg_event_full.findChildren(QTextEdit)
        aux = self.dlg_event_full.findChildren(QLineEdit)
        for w in aux:
            widget_list.append(w)
        for widget in widget_list:
            widget.setReadOnly(True)
            widget.setStyleSheet("QWidget { background: rgb(242, 242, 242);"
                                 " color: rgb(100, 100, 100)}")
        self.dlg_event_full.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_event_full))
        self.dlg_event_full.tbl_docs_x_event.doubleClicked.connect(partial(self._open_file, self.dlg_event_full))
        tools_qt.set_tableview_config(self.dlg_event_full.tbl_docs_x_event)
        tools_gw.open_dialog(self.dlg_event_full, 'visit_event_full')


    def _populate_tbl_docs_x_event(self):

        # Create and set model
        model = QStandardItemModel()
        self.dlg_event_full.tbl_docs_x_event.setModel(model)
        self.dlg_event_full.tbl_docs_x_event.horizontalHeader().setStretchLastSection(True)
        self.dlg_event_full.tbl_docs_x_event.horizontalHeader().setSectionResizeMode(3)
        # Get columns name and set headers of model with that
        columns_name = tools_db.get_columns_list('om_visit_event_photo')
        headers = []
        for x in columns_name:
            headers.append(x[0])
        headers = ['value', 'filetype', 'fextension']
        model.setHorizontalHeaderLabels(headers)

        # Get values in order to populate model
        sql = (f"SELECT value, filetype, fextension FROM om_visit_event_photo "
               f"WHERE visit_id='{self.visit_id}' AND event_id='{self.event_id}'")
        rows = tools_db.get_rows(sql)
        if rows is None:
            return

        for row in rows:
            item = []
            for value in row:
                if value is not None:
                    if type(value) != str:
                        item.append(QStandardItem(str(value)))
                    else:
                        item.append(QStandardItem(value))
                else:
                    item.append(QStandardItem(None))
            if len(row) > 0:
                model.appendRow(item)


    def _open_file(self, dialog):

        # Get row index
        index = self.dlg_event_full.tbl_docs_x_event.selectionModel().selectedRows()[0]
        column_index = tools_qt.get_col_index_by_col_name(self.dlg_event_full.tbl_docs_x_event, 'value')
        path = index.sibling(index.row(), column_index).data()
        status, message = tools_os.open_file(path)
        if status is False and message is not None:
            tools_qgis.show_warning(message, parameter=path, dialog=dialog)


    def _tbl_event_clicked(self, table_name):

        # Enable/Disable buttons
        btn_open_gallery = self.dlg_cf.findChild(QPushButton, "btn_open_gallery")
        btn_open_visit_doc = self.dlg_cf.findChild(QPushButton, "btn_open_visit_doc")
        btn_open_visit_event = self.dlg_cf.findChild(QPushButton, "btn_open_visit_event")
        btn_open_gallery.setEnabled(False)
        btn_open_visit_doc.setEnabled(False)
        btn_open_visit_event.setEnabled(True)

        # Get selected row
        selected_list = self.tbl_event_cf.selectionModel().selectedRows()
        selected_row = selected_list[0].row()
        self.visit_id = self.tbl_event_cf.model().record(selected_row).value("visit_id")
        self.event_id = self.tbl_event_cf.model().record(selected_row).value("event_id")
        self.parameter_id = self.tbl_event_cf.model().record(selected_row).value("parameter_id")

        sql = (f"SELECT gallery, document FROM {table_name}"
               f" WHERE event_id = '{self.event_id}' AND visit_id = '{self.visit_id}'")
        row = tools_db.get_row(sql)
        if not row:
            return

        # If gallery 'True' or 'False'
        if str(row[0]) == 'True':
            btn_open_gallery.setEnabled(True)

        # If document 'True' or 'False'
        if str(row[1]) == 'True':
            btn_open_visit_doc.setEnabled(True)


    def _set_filter_table_event(self, widget):
        """ Get values selected by the user and sets a new filter for its table model """

        # Get selected dates
        visit_start = self.date_event_from.date()
        visit_end = self.date_event_to.date()
        date_from = visit_start.toString('yyyyMMdd 00:00:00')
        date_to = visit_end.toString('yyyyMMdd 23:59:59')
        if date_from > date_to:
            message = "Selected date interval is not valid"
            tools_qgis.show_warning(message, dialog=self.dlg_cf)
            return

        # Cascade filter
        table_name_event_id = "config_visit_parameter"
        event_type_value = tools_qt.get_combo_value(self.dlg_cf, self.dlg_cf.event_type, 0)

        feature_type = {'arc_id': 'ARC', 'connec_id': 'CONNEC', 'gully_id': 'GULLY', 'node_id': 'NODE'}
        # Fill ComboBox event_id
        sql = (f"SELECT DISTINCT(id), id FROM {table_name_event_id}"
               f" WHERE (feature_type = '{feature_type[self.field_id]}' OR feature_type = 'ALL')")
        if event_type_value != 'null':
            sql += f" AND parameter_type ILIKE '%{event_type_value}%'"
        sql += " ORDER BY id"
        rows = tools_db.get_rows(sql)
        if rows:
            rows.append(['', ''])
            tools_qt.fill_combo_values(self.dlg_cf.event_id, rows, 1)

        # End cascading filter
        # Get selected values in Comboboxes
        event_type_value = tools_qt.get_combo_value(self.dlg_cf, self.dlg_cf.event_type, 0)
        event_id = tools_qt.get_combo_value(self.dlg_cf, self.dlg_cf.event_id, 0)
        format_low = 'yyyy-MM-dd 00:00:00.000'
        format_high = 'yyyy-MM-dd 23:59:59.999'
        interval = f"'{visit_start.toString(format_low)}'::timestamp AND '{visit_end.toString(format_high)}'::timestamp"

        # Set filter to model
        expr = f"{self.field_id} = '{self.feature_id}'"
        # Set filter
        expr += f" AND visit_start BETWEEN {interval}"

        if event_type_value not in ('null', -1):
            expr += f" AND parameter_type ILIKE '%{event_type_value}%'"

        if event_id not in ('null', -1):
            expr += f" AND parameter_id ILIKE '%{event_id}%'"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()


    def _set_filter_table_event2(self, widget):
        """ Get values selected by the user and sets a new filter for its table model """

        # Get selected dates
        visit_start = self.date_event_from.date()
        visit_end = self.date_event_to.date()
        date_from = visit_start.toString('yyyyMMdd 00:00:00')
        date_to = visit_end.toString('yyyyMMdd 23:59:59')
        if date_from > date_to:
            message = "Selected date interval is not valid"
            tools_qgis.show_warning(message, dialog=self.dlg_cf)
            return

        format_low = 'yyyy-MM-dd 00:00:00.000'
        format_high = 'yyyy-MM-dd 23:59:59.999'
        interval = f"'{visit_start.toString(format_low)}'::timestamp AND '{visit_end.toString(format_high)}'::timestamp"

        # Set filter to model
        expr = f"{self.field_id} = '{self.feature_id}'"
        # Set filter
        expr += f" AND visit_start BETWEEN {interval}"

        # Get selected values in Comboboxes
        event_type_value = tools_qt.get_combo_value(self.dlg_cf, self.dlg_cf.event_type, 0)
        if event_type_value != 'null':
            expr += f" AND parameter_type ILIKE '%{event_type_value}%'"
        event_id = tools_qt.get_combo_value(self.dlg_cf, self.dlg_cf.event_id, 0)
        if event_id != 'null':
            expr += f" AND parameter_id ILIKE '%{event_id}%'"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()


    def _open_visit(self):
        """ Call button 65: om_visit_management """

        manage_visit = GwVisit()
        manage_visit.visit_added.connect(self._update_visit_table)
        manage_visit.manage_visits(self.feature_type, self.feature_id)


    def _update_visit_table(self):
        """ Convenience fuction set as slot to update table after a Visit GUI close. """
        table_name = "v_ui_event_x_" + self.feature_type
        tools_gw.set_dates_from_to(self.date_event_from, self.date_event_to, table_name, 'visit_start', 'visit_end')
        self.tbl_event_cf.model().select()


    def _new_visit(self):
        """ Call button 64: om_add_visit """

        # Get expl_id to save it on om_visit and show the geometry of visit
        expl_id = tools_qt.get_combo_value(self.dlg_cf, self.tab_type + '_expl_id', 0)
        if expl_id == -1:
            msg = "Widget expl_id not found"
            tools_qgis.show_warning(msg, dialog=self.dlg_cf)
            return

        manage_visit = GwVisit()
        manage_visit.visit_added.connect(self._update_visit_table)
        # TODO: the following query fix a (for me) misterious bug
        # the DB connection is not available during manage_visit.manage_visit first call
        # so the workaroud is to do a unuseful query to have the dao active
        sql = "SELECT id FROM om_visit LIMIT 1;"
        tools_db.get_rows(sql)
        manage_visit.get_visit(feature_type=self.feature_type, feature_id=self.feature_id, expl_id=expl_id,
                               is_new_from_cf=True)


    def _open_gallery(self):
        """ Open gallery of selected record of the table """

        # Open Gallery
        gal = GwVisitGallery()
        gal.manage_gallery()
        gal.fill_gallery(self.visit_id, self.event_id)


    def _open_visit_doc(self):
        """ Open document of selected record of the table """

        # Get all documents for one visit
        sql = (f"SELECT doc_id FROM doc_x_visit"
               f" WHERE visit_id = '{self.visit_id}'")
        rows = tools_db.get_rows(sql)
        if not rows:
            return

        num_doc = len(rows)
        if num_doc == 1:
            # If just one document is attached directly open

            # Get path of selected document
            sql = (f"SELECT path"
                   f" FROM v_ui_doc"
                   f" WHERE id = '{rows[0][0]}'")
            row = tools_db.get_row(sql)
            if not row:
                return

            path = str(row[0])

            # Parse a URL into components
            url = parse.urlsplit(path)

            # Open selected document
            # Check if path is URL
            if url.scheme == "http" or url.scheme == "https":
                webbrowser.open(path)
            else:

                if not os.path.exists(path):
                    message = "File not found"
                    tools_qgis.show_warning(message, parameter=path, dialog=self.dlg_cf)
                else:
                    status, message = tools_os.open_file(path)
                    if status is False and message is not None:
                        tools_qgis.show_warning(message, parameter=path, dialog=self.dlg_cf)

        else:
            # If more then one document is attached open dialog with list of documents
            self.dlg_load_doc = GwVisitDocumentUi()
            tools_gw.load_settings(self.dlg_load_doc)
            self.dlg_load_doc.rejected.connect(partial(tools_gw.close_dialog, self.dlg_load_doc))
            btn_open_doc = self.dlg_load_doc.findChild(QPushButton, "btn_open")
            btn_open_doc.clicked.connect(self._open_selected_doc)

            lbl_visit_id = self.dlg_load_doc.findChild(QLineEdit, "visit_id")
            lbl_visit_id.setText(str(self.visit_id))

            self.tbl_list_doc = self.dlg_load_doc.findChild(QListWidget, "tbl_list_doc")
            self.tbl_list_doc.itemDoubleClicked.connect(partial(self._open_selected_doc))
            for row in rows:
                item_doc = QListWidgetItem(str(row[0]))
                self.tbl_list_doc.addItem(item_doc)

            tools_gw.open_dialog(self.dlg_load_doc, dlg_name='visit_document')


    def _open_selected_doc(self):

        # Selected item from list
        if self.tbl_list_doc.currentItem() is None:
            msg = "No document selected."
            tools_qgis.show_message(msg, 1)
            return

        selected_document = self.tbl_list_doc.currentItem().text()

        # Get path of selected document
        sql = (f"SELECT path FROM v_ui_doc"
               f" WHERE id = '{selected_document}'")
        row = tools_db.get_row(sql)
        if not row:
            return

        path = str(row[0])

        # Parse a URL into components
        url = parse.urlsplit(path)

        # Open selected document
        # Check if path is URL
        if url.scheme == "http" or url.scheme == "https":
            webbrowser.open(path)
        else:
            if not os.path.exists(path):
                message = "File not found"
                tools_qgis.show_warning(message, parameter=path)
            else:
                status, message = tools_os.open_file(path)
                if status is False and message is not None:
                    tools_qgis.show_warning(message, parameter=path)


    """ FUNCTIONS RELATED WITH TAB DOC"""


    def _fill_tab_document(self):
        """ Fill tab 'Document' """

        table_document = "v_ui_doc_x_" + self.feature_type
        self._fill_tbl_document_man(self.dlg_cf, self.tbl_document, table_document, self.filter)
        tools_gw.set_tablemodel_config(self.dlg_cf, self.tbl_document, table_document)


    def _fill_tbl_document_man(self, dialog, widget, table_name, expr_filter):
        """ Fill the table control to show documents """

        if not self.feature:
            self._get_feature(self.tab_type)

        # Get widgets
        doc_type = self.dlg_cf.findChild(QComboBox, "doc_type")
        self.date_document_to = self.dlg_cf.findChild(QDateEdit, "date_document_to")
        self.date_document_from = self.dlg_cf.findChild(QDateEdit, "date_document_from")
        btn_open_doc = self.dlg_cf.findChild(QPushButton, "btn_open_doc")
        btn_doc_delete = self.dlg_cf.findChild(QPushButton, "btn_doc_delete")
        btn_doc_insert = self.dlg_cf.findChild(QPushButton, "btn_doc_insert")
        btn_doc_new = self.dlg_cf.findChild(QPushButton, "btn_doc_new")

        # Set max and min dates
        tools_gw.set_dates_from_to(self.date_document_from, self.date_document_to, table_name, 'date', 'date')

        # Set model of selected widget
        message = tools_qt.fill_table(widget, f"{self.schema_name}.{table_name}", expr_filter)
        if message:
            tools_qgis.show_warning(message, dialog=dialog)

        # Set signals
        doc_type.currentIndexChanged.connect(partial(self._set_filter_table_man, widget))
        self.date_document_to.dateChanged.connect(partial(self._set_filter_table_man, widget))
        self.date_document_from.dateChanged.connect(partial(self._set_filter_table_man, widget))
        self.tbl_document.doubleClicked.connect(partial(self._open_selected_document, widget))
        btn_open_doc.clicked.connect(partial(self._open_selected_document, widget))
        btn_doc_delete.clicked.connect(partial(self._delete_records, widget, table_name))
        btn_doc_insert.clicked.connect(partial(self._add_object, widget, "doc", "v_ui_doc"))
        btn_doc_new.clicked.connect(partial(self._manage_new_document, dialog, None, self.feature))

        # Fill ComboBox doc_type
        sql = "SELECT id, id FROM doc_type ORDER BY id"
        rows = tools_db.get_rows(sql)
        if rows:
            rows.append(['', ''])
        tools_qt.fill_combo_values(doc_type, rows)

        # Adding auto-completion to a QLineEdit
        self.table_object = "doc"
        tools_gw.set_completer_object(dialog, self.table_object)

        # Set filter expresion
        self._set_filter_table_man(widget)


    def _set_filter_table_man(self, widget):
        """ Get values selected by the user and sets a new filter for its table model """

        # Get selected dates
        date_from = self.date_document_from.date()
        date_to = self.date_document_to.date()
        if date_from > date_to:
            message = "Selected date interval is not valid"
            tools_qgis.show_warning(message, dialog=self.dlg_cf)
            return

        # Create interval dates
        format_low = 'yyyy-MM-dd 00:00:00.000'
        format_high = 'yyyy-MM-dd 23:59:59.999'
        interval = f"'{date_from.toString(format_low)}'::timestamp AND '{date_to.toString(format_high)}'::timestamp"

        # Set filter
        expr = f"{self.field_id} = '{self.feature_id}'"
        expr += f" AND(date BETWEEN {interval}) AND (date BETWEEN {interval})"

        # Get selected values in Comboboxes
        doc_type_value = tools_qt.get_combo_value(self.dlg_cf, self.dlg_cf.doc_type, 0)
        if doc_type_value != 'null' and doc_type_value is not None:
            expr += f" AND doc_type ILIKE '%{doc_type_value}%'"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()


    def _open_selected_document(self, widget):
        """ Open selected document of the @widget """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.dlg_cf)
            return
        elif len(selected_list) > 1:
            message = "Select just one document"
            tools_qgis.show_warning(message, dialog=self.dlg_cf)
            return

        # Get document path (can be relative or absolute)
        row = selected_list[0].row()
        path = widget.model().record(row).value("path")
        status, message = tools_os.open_file(path)
        if status is False and message is not None:
            tools_qgis.show_warning(message, parameter=path, dialog=self.dlg_cf)


    def _manage_new_document(self, dialog, doc_id=None, feature=None):
        """ Execute action of button 34 """

        doc = GwDocument()
        doc.get_document(feature=feature, feature_type=self.feature_type)
        doc.doc_added.connect(partial(self._manage_document_new, doc))

        # Set completer
        tools_gw.set_completer_object(dialog, self.table_object)
        if doc_id:
            tools_qt.set_widget_text(dialog, "doc_id", doc_id)

        # # Open dialog
        # doc.open_dialog(doc.dlg_add_doc)


    def _manage_document_new(self, doc):
        """ Get inserted doc_id and add it to current feature """

        if not doc.doc_id:
            return

        tools_qt.set_widget_text(self.dlg_cf, "doc_id", doc.doc_id)
        self._add_object(self.tbl_document, "doc", "v_ui_doc")


    """ FUNCTIONS RELATED WITH TAB RPT """


    def _fill_tab_rpt(self, complet_result, new_feature):

        complet_list, widget_list = self._init_tbl_rpt(complet_result, self.dlg_cf, new_feature)
        if complet_list is False:
            return False
        self._set_listeners(complet_result, self.dlg_cf, widget_list)
        return complet_list


    def _init_tbl_rpt(self, complet_result, dialog, new_feature):
        """ Put filter widgets into layout and set headers into QTableView """

        rpt_layout1 = dialog.findChild(QGridLayout, "rpt_layout1")
        self._reset_grid_layout(rpt_layout1)
        index_tab = self.tab_main.currentIndex()
        tab_name = self.tab_main.widget(index_tab).objectName()
        complet_list = self._get_list(complet_result, tab_name=tab_name)
        if complet_list is False:
            return False, False

        # Put widgets into layout
        widget_list = []
        for field in complet_list['body']['data']['fields']:
            if 'hidden' in field and field['hidden']:
                continue
            label, widget = self._set_widgets(dialog, complet_list, field, new_feature)
            if widget is not None:
                if (type(widget)) == QSpacerItem:
                    rpt_layout1.addItem(widget, 1, field['layoutorder'])
                elif (type(widget)) == QTableView:
                    lyt = self.dlg_cf.findChild(QGridLayout, "gridLayout_7")
                    lyt.addWidget(widget, 2, field['layoutorder'])
                    widget_list.append(widget)
                else:
                    widget.setMaximumWidth(150)
                    widget_list.append(widget)
                    if label:
                        rpt_layout1.addWidget(label, 0, field['layoutorder'])
                    rpt_layout1.addWidget(widget, 1, field['layoutorder'])

            # Find combo parents:
            for field_ in complet_list['body']['data']['fields'][0]:
                if 'isparent' in field_:
                    if field_['isparent']:
                        widget = dialog.findChild(QComboBox, field_['widgetname'])
                        widget.currentIndexChanged.connect(partial(self._get_combo_child, dialog, widget,
                                                           self.feature_type, self.tablename, self.field_id))

        return complet_list, widget_list


    def _reset_grid_layout(self, layout):
        """  Remove all widgets of layout """

        while layout.count() > 0:
            child = layout.takeAt(0).widget()
            if child:
                child.setParent(None)
                child.deleteLater()


    def _set_listeners(self, complet_result, dialog, widget_list):

        model = None
        for widget in widget_list:
            if type(widget) is QTableView:
                model = widget.model()
        for widget in widget_list:
            if type(widget) is QLineEdit:
                widget.editingFinished.connect(partial(self._filter_table, complet_result, model, dialog, widget_list))
            elif type(widget) is QComboBox:
                widget.currentIndexChanged.connect(partial(
                    self._filter_table, complet_result, model, dialog, widget_list))


    def _get_list(self, complet_result, form_name='', tab_name='', filter_fields=''):

        form = f'"formName":"{form_name}", "tabName":"{tab_name}"'
        id_name = complet_result['body']['feature']['idName']
        feature = f'"tableName":"{self.tablename}", "idName":"{id_name}", "id":"{self.feature_id}"'
        body = tools_gw.create_body(form, feature, filter_fields)
        json_result = tools_gw.execute_procedure('gw_fct_getlist', body)
        if json_result is None or json_result['status'] == 'Failed':
            return False
        complet_list = json_result
        if not complet_list:
            return False

        return complet_list


    def _filter_table(self, complet_result, standar_model, dialog, widget_list):

        filter_fields = self._get_filter_qtableview(standar_model, dialog, widget_list)
        index_tab = self.tab_main.currentIndex()
        tab_name = self.tab_main.widget(index_tab).objectName()
        complet_list = self._get_list(complet_result, tab_name=tab_name, filter_fields=filter_fields)
        if complet_list is False:
            return False

        for field in complet_list['body']['data']['fields']:
            if field['widgettype'] == "tableview":
                qtable = dialog.findChild(QTableView, field['widgetname'])
                if qtable:
                    tools_gw.add_tableview_header(qtable, field)
                    tools_gw.fill_tableview_rows(qtable, field)

        return complet_list


    def _get_filter_qtableview(self, standar_model, dialog, widget_list):

        standar_model.clear()
        filter_fields = ""
        for widget in widget_list:
            if type(widget) != QTableView:
                columnname = widget.property('columnname')
                text = tools_qt.get_text(dialog, widget)
                if text != "null":
                    filter_fields += f'"{columnname}":"{text}", '

        if filter_fields != "":
            filter_fields = filter_fields[:-2]

        return filter_fields


    def _gw_api_open_rpt_result(self, widget, complet_result):
        self._open_rpt_result(widget, complet_result)


    def _open_rpt_result(self, qtable, complet_list):
        """ Open form of selected element of the @widget?? """

        # Get selected rows
        selected_list = qtable.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.dlg_cf)
            return

        index = selected_list[0]
        row = index.row()
        table_name = complet_list['body']['feature']['tableName']
        column_index = tools_qt.get_col_index_by_col_name(qtable, 'sys_id')
        feature_id = index.sibling(row, column_index).data()

        # return
        info_feature = GwInfo(self.tab_type)
        complet_result, dialog = info_feature.open_form(table_name=table_name, feature_id=feature_id, tab_type=self.tab_type)
        if not complet_result:
            tools_log.log_info("FAIL open_rpt_result")
            return

        margin = float(complet_result['body']['feature']['zoomCanvasMargin']['mts'])
        tools_gw.draw_by_json(complet_result, self.rubber_band, margin)


    """ FUNCTIONS RELATED WITH TAB PLAN """


    def _fill_tab_plan(self, complet_result):

        plan_layout = self.dlg_cf.findChild(QGridLayout, 'plan_layout')

        if self.feature_type == 'arc' or self.feature_type == 'node':
            index_tab = self.tab_main.currentIndex()
            tab_name = self.tab_main.widget(index_tab).objectName()
            form = f'"tabName":"{tab_name}"'
            feature = f'"featureType":"{complet_result["body"]["feature"]["featureType"]}", '
            feature += f'"tableName":"{self.tablename}", '
            feature += f'"idName":"{self.field_id}", '
            feature += f'"id":"{self.feature_id}"'
            body = tools_gw.create_body(form, feature, filter_fields='')
            json_result = tools_gw.execute_procedure('gw_fct_getinfoplan', body)
            if not json_result or json_result['status'] == 'Failed':
                return False

            result = json_result['body']['data']
            if 'fields' not in result:
                tools_qgis.show_message("No listValues for: " + json_result['body']['data'], 2, dialog=self.dlg_cf)
            else:
                for field in json_result['body']['data']['fields']:
                    label = QLabel()
                    if field['widgettype'] == 'divider':
                        for x in range(0, 2):
                            line = tools_gw.add_frame(field, x)
                            plan_layout.addWidget(line, field['layoutorder'], x)
                    else:
                        label = QLabel()
                        label.setTextInteractionFlags(Qt.TextSelectableByMouse)
                        label.setObjectName('lbl_' + field['label'])
                        label.setText(field['label'].capitalize())
                        if 'tooltip' in field:
                            label.setToolTip(field['tooltip'])
                        else:
                            label.setToolTip(field['label'].capitalize())

                    if field['widgettype'] == 'label':
                        widget = self._add_label(field)
                        widget.setAlignment(Qt.AlignRight)
                        label.setWordWrap(True)
                        plan_layout.addWidget(label, field['layoutorder'], 0)
                        plan_layout.addWidget(widget, field['layoutorder'], 1)

                plan_vertical_spacer = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
                plan_layout.addItem(plan_vertical_spacer)


    def _add_label(self, field):
        """ Add widgets QLineEdit type """

        widget = QLabel()
        widget.setTextInteractionFlags(Qt.TextSelectableByMouse)
        widget.setObjectName(field['widgetname'])
        if 'columnname' in field:
            widget.setProperty('columnname', field['columnname'])
        if 'value' in field:
            widget.setText(field['value'])

        return widget


    def _get_catalog(self, form_name, table_name, feature_type, feature_id, list_points, id_name):

        form = f'"formName":"{form_name}", "tabName":"data", "editable":"TRUE"'
        feature = f'"tableName":"{table_name}", "featureId":"{feature_id}", "feature_type":"{feature_type}"'
        extras = f'"coordinates":{{{list_points}}}'
        body = tools_gw.create_body(form, feature, extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_getcatalog', body)
        if json_result is None:
            return

        dlg_generic = GwInfoGenericUi()
        tools_gw.load_settings(dlg_generic)

        # Set signals
        dlg_generic.btn_close.clicked.connect(partial(tools_gw.close_dialog, dlg_generic))
        dlg_generic.rejected.connect(partial(tools_gw.close_dialog, dlg_generic))
        dlg_generic.btn_accept.clicked.connect(partial(self._set_catalog, dlg_generic, form_name, table_name, feature_id, id_name))

        tools_gw.build_dialog_info(dlg_generic, json_result)

        # Open dialog
        dlg_generic.setWindowTitle(f"{(form_name.lower()).capitalize().replace('_', ' ')}")
        tools_gw.open_dialog(dlg_generic)


    def _set_catalog(self, dialog, form_name, table_name, feature_id, id_name):
        """ Insert table 'cat_work'. Add cat_work """

        # Manage mandatory fields
        missing_mandatory = False
        widgets = dialog.findChildren(QWidget)
        for widget in widgets:
            widget.setStyleSheet(None)
            # Check mandatory fields
            value = tools_qt.get_text(dialog, widget, False, False)
            if widget.property('ismandatory') and value in (None, ''):
                missing_mandatory = True
                tools_qt.set_stylesheet(widget, "border: 2px solid red")
        if missing_mandatory:
            message = "Mandatory field is missing. Please, set a value"
            tools_qgis.show_warning(message, dialog=dialog)
            return

        # Form handling so that the user cannot change values until the process is finished
        self.dlg_cf.setEnabled(False)
        # global_vars.notify.task_finished.connect(self._enable_buttons)

        # Get widgets values
        values = {}
        for widget in widgets:
            if widget.property('columnname') in (None, ''):
                continue
            values = tools_gw.get_values(dialog, widget, values, ignore_editability=True)
        fields = json.dumps(values)

        # Call gw_fct_setcatalog
        fields = f'"fields":{fields}'
        form = f'"formName":"{form_name}"'
        feature = f'"tableName":"{table_name}", "id":"{feature_id}", "idName":"{id_name}"'
        body = tools_gw.create_body(form, feature, extras=fields)
        result = tools_gw.execute_procedure('gw_fct_setcatalog', body, log_sql=True)
        if result['status'] != 'Accepted':
            return

        # Set new value to the corresponding widget
        for field in result['body']['data']['fields']:
            widget = self.dlg_cf.findChild(QWidget, field['widgetname'])
            if widget.property('typeahead'):
                tools_qt.set_completer_object(QCompleter(), QStringListModel(), widget, field['comboIds'])
                tools_qt.set_widget_text(self.dlg_cf, widget, field['selectedId'])
                self.my_json[str(widget.property('columnname'))] = field['selectedId']
            elif type(widget) == QComboBox:
                widget = tools_gw.fill_combo(widget, field)
                tools_qt.set_combo_value(widget, field['selectedId'], 0)
                widget.setProperty('selectedId', field['selectedId'])
                self.my_json[str(widget.property('columnname'))] = field['selectedId']

        self._enable_buttons()
        tools_gw.close_dialog(dialog)


    def _enable_buttons(self):
        self.dlg_cf.setEnabled(True)
        # global_vars.notify.task_finished.disconnect()


    def _mouse_moved(self, layer, point):
        """ Mouse motion detection """

        # Set active layer
        self.iface.setActiveLayer(layer)
        layer_name = tools_qgis.get_layer_source_table_name(layer)

        # Get clicked point
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if result.isValid():
            layer = self.snapper_manager.get_snapped_layer(result)
            # Check feature
            viewname = tools_qgis.get_layer_source_table_name(layer)
            if viewname == layer_name:
                self.snapper_manager.add_marker(result, self.vertex_marker)


    def _get_id(self, dialog, action, option, emit_point, child_type, point, event):
        """ Get selected attribute from snapped feature """

        # @options{'key':['att to get from snapped feature', 'widget name destination']}
        options = {'arc': ['arc_id', 'data_arc_id'], 'node': ['node_id', 'data_parent_id'],
                   'set_to_arc': ['arc_id', '_set_to_arc']}

        if event == Qt.RightButton:
            self._cancel_snapping_tool(dialog, action)
            return

        try:
            # Refresh all layers to avoid selecting old deleted features
            global_vars.canvas.refreshAllLayers()
            # Get coordinates
            event_point = self.snapper_manager.get_event_point(point=point)
            # Snapping
            result = self.snapper_manager.snap_to_current_layer(event_point)
            if not result.isValid():
                return
            # Get the point. Leave selection
            snapped_feat = self.snapper_manager.get_snapped_feature(result)
            feat_id = snapped_feat.attribute(f'{options[option][0]}')
            if option in ('arc', 'node'):
                widget = dialog.findChild(QWidget, f"{options[option][1]}")
                widget.setFocus()
                tools_qt.set_widget_text(dialog, widget, str(feat_id))
            elif option == 'set_to_arc':
                # functions called in -> getattr(self, options[option][0])(feat_id, child_type)
                #       def _set_to_arc(self, feat_id, child_type)
                getattr(self, options[option][1])(feat_id, child_type)
        except Exception as e:
            tools_qgis.show_warning(f"Exception in info (def _get_id)", parameter=e)
        finally:
            self.snapper_manager.recover_snapping_options()
            self._cancel_snapping_tool(dialog, action)


    def _set_to_arc(self, feat_id, child_type):
        """
        Function called in def _get_id(self, dialog, action, option, emit_point, child_type, point, event):
            getattr(self, options[option][1])(feat_id, child_type)

            :param feat_id: Id of the snapped feature
        """

        w_dma_id = self.dlg_cf.findChild(QWidget, 'data_dma_id')
        if isinstance(w_dma_id, QComboBox):
            dma_id = tools_qt.get_combo_value(self.dlg_cf, w_dma_id)
        else:
            dma_id = tools_qt.get_text(self.dlg_cf, w_dma_id)
        w_presszone_id = self.dlg_cf.findChild(QComboBox, 'data_presszone_id')
        presszone_id = tools_qt.get_combo_value(self.dlg_cf, w_presszone_id)
        w_sector_id = self.dlg_cf.findChild(QComboBox, 'data_sector_id')
        sector_id = tools_qt.get_combo_value(self.dlg_cf, w_sector_id)
        w_dqa_id = self.dlg_cf.findChild(QComboBox, 'data_dqa_id')
        dqa_id = tools_qt.get_combo_value(self.dlg_cf, w_dqa_id)
        if dqa_id == -1:
            dqa_id = "null"

        feature = f'"featureType":"{child_type}", "id":"{self.feature_id}"'
        extras = (f'"arcId":"{feat_id}", "dmaId":"{dma_id}", "presszoneId":"{presszone_id}", "sectorId":"{sector_id}", '
                  f'"dqaId":"{dqa_id}"')
        body = tools_gw.create_body(feature=feature, extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_settoarc', body)
        if json_result is None:
            return

        if 'status' in json_result and json_result['status'] == 'Accepted':
            if json_result['message']:
                level = 1
                if 'level' in json_result['message']:
                    level = int(json_result['message']['level'])
                tools_qgis.show_message(json_result['message']['text'], level)


    def _cancel_snapping_tool(self, dialog, action):

        tools_qgis.disconnect_snapping(False, None, self.vertex_marker)
        tools_gw.disconnect_signal('info_snapping')
        dialog.blockSignals(False)
        dialog.key_escape.connect(partial(tools_gw.close_dialog, dialog))
        action.setChecked(False)
        self.signal_activate.emit()


    """ FUNCTIONS ASSOCIATED TO BUTTONS FROM POSTGRES"""


    def _action_is_checked(self):
        """ Recover snapping options when action add feature is un-checked """

        if not self.iface.actionAddFeature().isChecked():
            self.snapper_manager.recover_snapping_options()
            tools_gw.disconnect_signal('info', 'add_feature_actionAddFeature_toggled_action_is_checked')


    def _open_new_feature(self, feature_id):
        """
        :param feature_id: Parameter sent by the featureAdded method itself
        :return:
        """

        self.snapper_manager.recover_snapping_options()
        self.info_layer.featureAdded.disconnect(self._open_new_feature)
        feature = tools_qt.get_feature_by_id(self.info_layer, feature_id)
        geom = feature.geometry()
        list_points = None
        if self.info_layer.geometryType() == 0:
            points = geom.asPoint()
            list_points = f'"x1":{points.x()}, "y1":{points.y()}'
        elif self.info_layer.geometryType() in (1, 2):
            points = geom.asPolyline()
            init_point = points[0]
            last_point = points[-1]
            list_points = f'"x1":{init_point.x()}, "y1":{init_point.y()}'
            list_points += f', "x2":{last_point.x()}, "y2":{last_point.y()}'
        else:
            tools_log.log_info("NO FEATURE TYPE DEFINED")

        tools_gw.init_docker()
        global is_inserting
        is_inserting = True

        self.info_feature = GwInfo('data')
        self.info_feature.prev_action = self.prev_action
        result, dialog = self.info_feature._get_feature_insert(point=list_points, feature_cat=self.feature_cat,
                                                               new_feature_id=feature_id, new_feature=feature,
                                                               layer_new_feature=self.info_layer, tab_type='data')

        # Restore user value (Settings/Options/Digitizing/Suppress attribute from pop-up after feature creation)
        QSettings().setValue("/Qgis/digitizing/disable_enter_attribute_values_dialog", self.suppres_form)
        config = self.info_layer.editFormConfig()
        config.setSuppress(self.conf_supp)
        self.info_layer.setEditFormConfig(config)
        if not result:
            self.info_layer.deleteFeature(feature.id())
            self.iface.actionRollbackEdits().trigger()
            is_inserting = False


    def _get_combo_child(self, dialog, widget, feature_type, tablename, field_id):
        """
        Find QComboBox child and populate it
            :param dialog: QDialog
            :param widget: QComboBox parent
            :param feature_type: PIPE, ARC, JUNCTION, VALVE...
            :param tablename: view of DB
            :param field_id: Field id of tablename
            :return: False if failed
        """

        combo_parent = widget.property('columnname')
        combo_id = tools_qt.get_combo_value(dialog, widget)

        feature = f'"featureType":"{feature_type}", '
        feature += f'"tableName":"{tablename}", '
        feature += f'"idName":"{field_id}"'
        extras = f'"comboParent":"{combo_parent}", "comboId":"{combo_id}"'
        body = tools_gw.create_body(feature=feature, extras=extras)
        result = tools_gw.execute_procedure('gw_fct_getchilds', body)
        if not result or result['status'] == 'Failed':
            return False

        for combo_child in result['body']['data']:
            if combo_child is not None:
                tools_gw.manage_combo_child(dialog, widget, combo_child)

    # endregion
