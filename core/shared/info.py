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

from qgis.PyQt.QtCore import pyqtSignal, QDate, QObject, QRegExp, QStringListModel, Qt, QSettings, QRegularExpression
from qgis.PyQt.QtGui import QColor, QRegExpValidator, QStandardItem, QStandardItemModel
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QAction, QAbstractItemView, QCheckBox, QComboBox, QCompleter, QDoubleSpinBox, \
    QDateEdit, QGridLayout, QLabel, QLineEdit, QListWidget, QListWidgetItem, QPushButton, QSizePolicy, \
    QSpinBox, QSpacerItem, QTableView, QTabWidget, QWidget, QTextEdit, QRadioButton, QToolBox
from qgis.core import QgsApplication, QgsMapToPixel, QgsVectorLayer, QgsExpression, QgsFeatureRequest, QgsPointXY, QgsProject
from qgis.gui import QgsDateTimeEdit, QgsMapToolEmitPoint

from .catalog import GwCatalog
from .dimensioning import GwDimensioning
from .document import GwDocument
from .element import GwElement
from .visit_gallery import GwVisitGallery
from .visit import GwVisit

from ..utils import tools_gw, tools_backend_calls
from ..threads.toggle_valve_state import GwToggleValveTask

from ..utils.snap_manager import GwSnapManager
from ..ui.ui_manager import GwInfoGenericUi, GwInfoFeatureUi, GwVisitEventFullUi, GwMainWindow, GwVisitDocumentUi, \
    GwInfoCrossectUi, GwInterpolate, GwInfoEpaDemandUi, GwInfoEpaOrificeUi, GwInfoEpaOutletUi, GwInfoEpaPumpUi, \
    GwInfoEpaWeirUi, GwInfoEpaDwfUi
from ... import global_vars
from ...libs import lib_vars, tools_qgis, tools_qt, tools_log, tools_db, tools_os
from ...libs.tools_qt import GwHyperLinkLineEdit

global is_inserting
is_inserting = False


class GwInfo(QObject):

    # :var signal_activate: emitted from def cancel_snapping_tool(self, dialog, action) in order to re-start CadInfo
    signal_activate = pyqtSignal()

    def __init__(self, tab_type):

        super().__init__()

        self.iface = global_vars.iface
        self.settings = global_vars.giswater_settings
        self.plugin_dir = lib_vars.plugin_dir
        self.canvas = global_vars.canvas
        self.schema_name = lib_vars.schema_name

        self.new_feature_id = None
        self.layer_new_feature = None
        self.tab_type = tab_type
        self.connected = False
        self.rubber_band = tools_gw.create_rubberband(self.canvas, 0)
        self.snapper_manager = GwSnapManager(self.iface)
        self.snapper_manager.set_snapping_layers()
        self.suppres_form = None
        self.prev_action = None


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
            self.tab_epa_loaded = False
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
            self.my_json_epa = {}
            self.tab_type = tab_type
            self.visible_tabs = []
            self.epa_complet_result = None
            self.inserted_feature = False

            # Get project variables
            qgis_project_add_schema = lib_vars.project_vars['add_schema']
            qgis_project_main_schema = lib_vars.project_vars['main_schema']
            qgis_project_role = lib_vars.project_vars['project_role']

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
                extras += f', "visibleLayers":{visible_layer}'
                extras += f', "mainSchema":"{qgis_project_main_schema}"'
                extras += f', "addSchema":"{qgis_project_add_schema}"'
                extras += f', "projecRole":"{qgis_project_role}"'
                extras += f', "coordinates":{{"xcoord":{point.x()},"ycoord":{point.y()}, "zoomRatio":{scale_zoom}}}'
                body = tools_gw.create_body(extras=extras)
                function_name = 'gw_fct_getinfofromcoordinates'

            # Comes from QPushButtons node1 or node2 from custom form or RightButton
            elif feature_id:
                if is_add_schema:
                    add_schema = lib_vars.project_vars['add_schema']
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
                return self.complet_result, dlg_add_visit

            elif template == 'element':
                element_id = self.complet_result['body']['feature']['id']
                manage_element = GwElement()
                manage_element.get_element(new_element_id=False, selected_object_id=element_id)
                dlg_add_element = manage_element.get_element_dialog()
                dlg_add_element.rejected.connect(lambda: tools_gw.reset_rubberband(self.rubber_band))
                return self.complet_result, dlg_add_element

            else:
                tools_log.log_warning(f"template not managed: {template}")
                return False, None
        except Exception as e:
            tools_qgis.show_warning("Exception in info", parameter=e)
            self._disconnect_signals()  # Disconnect signals
            tools_qgis.restore_cursor()  # Restore overridden cursor
            return False, None


    """ FUNCTIONS ASSOCIATED TO BUTTONS FROM POSTGRES"""


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
        dialog.blockSignals(True)

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
            if field.get('tabname') != 'tab_data':
                continue
            if 'spacer' in field['widgettype']:
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
        # Dialog
        self.dlg_generic = GwInfoGenericUi()
        tools_gw.load_settings(self.dlg_generic)
        result = tools_gw.build_dialog_info(self.dlg_generic, complet_result, self.my_json)

        # Set variables
        self._get_features(complet_result)
        layer = self.layer
        fid = self.feature_id = complet_result['body']['feature']['id']
        new_feature = False
        can_edit = tools_os.set_boolean(tools_db.check_role_user('role_edit'))
        if layer:
            if layer.isEditable() and can_edit:
                tools_gw.enable_all(self.dlg_generic, complet_result['body']['data'])
            else:
                tools_gw.enable_widgets(self.dlg_generic, complet_result['body']['data'], False)

        # Manage actions
        action_edit = self.dlg_generic.findChild(QAction, "actionEdit")
        tools_gw.add_icon(action_edit, "101")
        is_enabled = False
        try:
            is_enabled = complet_result['body']['feature']['permissions']['isEditable']
        except (KeyError, TypeError):
            try:
                is_enabled = complet_result['body']['data']['editable']
            except (KeyError, TypeError):
                pass
        finally:
            action_edit.setEnabled(is_enabled)

        action_edit.triggered.connect(partial(self._manage_edition, self.dlg_generic, action_edit, fid, new_feature, True))
        action_edit.setChecked(layer.isEditable() and can_edit)

        # Signals
        self.dlg_generic.btn_accept.clicked.connect(partial(
            self._accept_from_btn, self.dlg_generic, action_edit, new_feature, self.my_json, complet_result, True
        ))
        self.dlg_generic.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_generic))
        self.dlg_generic.key_escape.connect(partial(tools_gw.close_dialog, self.dlg_generic))
        self.dlg_generic.dlg_closed.connect(partial(tools_gw.close_dialog, self.dlg_generic))

        # Disable button accept for info on generic form
        self.dlg_generic.btn_accept.setEnabled(can_edit)

        self.dlg_generic.dlg_closed.connect(self.rubber_band.reset)
        tools_gw.open_dialog(self.dlg_generic, dlg_name='info_generic')

        return result, self.dlg_generic


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

        self.visible_tabs = complet_result['body']['form'].get('visibleTabs', [])
        for tab in self.visible_tabs:
            tabs_to_show.append(tab['tabName'])

        for x in range(self.tab_main.count() - 1, 0, -1):
            if self.tab_main.widget(x).objectName() not in tabs_to_show:
                tools_qt.remove_tab(self.tab_main, self.tab_main.widget(x).objectName())

        # Actions
        self._get_actions()

        if self.new_feature_id is not None:
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
        # Disable tab EPA if epa_type is undefined
        if tools_qt.get_text(self.dlg_cf, 'tab_data_epa_type').lower() == 'undefined':
            tools_qt.enable_tab_by_tab_name(self.tab_main, 'tab_epa', False)
        # Check elev data consistency
        if global_vars.project_type == 'ud':
            self._check_elev_y()

        # Connect actions' signals
        dlg_cf, fid = self._manage_actions_signals(complet_result, list_points, new_feature, tab_type, result)

        btn_cancel = self.dlg_cf.findChild(QPushButton, 'btn_cancel')
        btn_accept = self.dlg_cf.findChild(QPushButton, 'btn_accept')
        title = self._set_dlg_title(complet_result)

        # Connect dialog signals
        if lib_vars.session_vars['dialog_docker'] and is_docker and lib_vars.session_vars['info_docker']:
            # Delete last form from memory
            last_info = lib_vars.session_vars['dialog_docker'].findChild(GwMainWindow, 'dlg_info_feature')
            if last_info:
                last_info.setParent(None)
                del last_info

            tools_gw.docker_dialog(dlg_cf)
            lib_vars.session_vars['dialog_docker'].widget().dlg_closed.connect(self._manage_docker_close)
            lib_vars.session_vars['dialog_docker'].setWindowTitle(title)
            btn_cancel.clicked.connect(self._manage_docker_close)

        else:
            dlg_cf.dlg_closed.connect(self._roll_back)
            dlg_cf.dlg_closed.connect(lambda: tools_gw.reset_rubberband(self.rubber_band))
            dlg_cf.dlg_closed.connect(self._remove_layer_selection)
            dlg_cf.dlg_closed.connect(partial(tools_gw.save_settings, dlg_cf))
            dlg_cf.dlg_closed.connect(self._reset_my_json, True)
            dlg_cf.dlg_closed.connect(self._manage_prev_action)
            dlg_cf.key_escape.connect(partial(tools_gw.close_dialog, dlg_cf))
            btn_cancel.clicked.connect(partial(self._manage_info_close, dlg_cf))
        btn_accept.clicked.connect(
            partial(self._accept_from_btn, dlg_cf, self.action_edit, new_feature, self.my_json, complet_result, False))
        dlg_cf.key_enter.connect(
            partial(self._accept_from_btn, dlg_cf, self.action_edit, new_feature, self.my_json, complet_result, False))

        # Open dialog
        tools_gw.open_dialog(self.dlg_cf, dlg_name='info_feature')
        self.dlg_cf.setWindowTitle(title)

        return self.complet_result, self.dlg_cf


    def _get_widget_controls(self, new_feature):
        """ Sets class variables for most widgets """

        self.tab_main = self.dlg_cf.findChild(QTabWidget, "tab_main")
        self.tab_main.currentChanged.connect(partial(self._tab_activation, self.dlg_cf))
        # self.tbl_element = self.dlg_cf.findChild(QTableView, "tbl_element")
        # tools_qt.set_tableview_config(self.tbl_element)
        # self.tbl_relations = self.dlg_cf.findChild(QTableView, "tbl_relations")
        # tools_qt.set_tableview_config(self.tbl_relations)
        # self.tbl_upstream = self.dlg_cf.findChild(QTableView, "tbl_upstream")
        # tools_qt.set_tableview_config(self.tbl_upstream)
        # self.tbl_downstream = self.dlg_cf.findChild(QTableView, "tbl_downstream")
        # tools_qt.set_tableview_config(self.tbl_downstream)
        # self.tbl_hydrometer = self.dlg_cf.findChild(QTableView, "tbl_hydrometer")
        # tools_qt.set_tableview_config(self.tbl_hydrometer)
        # self.tbl_hydrometer_value = self.dlg_cf.findChild(QTableView, "tbl_hydrometer_value")
        # tools_qt.set_tableview_config(self.tbl_hydrometer_value, QAbstractItemView.SelectItems,
        #                               QTableView.CurrentChanged)
        # self.tbl_visit_cf = self.dlg_cf.findChild(QTableView, "tbl_visit_cf")
        # self.tbl_event_cf = self.dlg_cf.findChild(QTableView, "tbl_event_cf")
        # tools_qt.set_tableview_config(self.tbl_event_cf)
        # self.tbl_document = self.dlg_cf.findChild(QTableView, "tbl_document")
        # tools_qt.set_tableview_config(self.tbl_document)


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
        self.action_centered = self.dlg_cf.findChild(QAction, "actionCentered")
        self.action_link = self.dlg_cf.findChild(QAction, "actionLink")
        self.action_help = self.dlg_cf.findChild(QAction, "actionHelp")
        self.action_interpolate = self.dlg_cf.findChild(QAction, "actionInterpolate")
        # action_switch_arc_id = self.dlg_cf.findChild(QAction, "actionSwicthArcid")
        self.action_section = self.dlg_cf.findChild(QAction, "actionSection")
        self.action_orifice = self.dlg_cf.findChild(QAction, "actionOrifice")
        self.action_outlet = self.dlg_cf.findChild(QAction, "actionOutlet")
        self.action_pump = self.dlg_cf.findChild(QAction, "actionPump")
        self.action_weir = self.dlg_cf.findChild(QAction, "actionWeir")
        self.action_demand = self.dlg_cf.findChild(QAction, "actionDemand")


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
        tools_gw.add_icon(self.action_centered, "104")
        tools_gw.add_icon(self.action_link, "173", sub_folder="24x24")
        tools_gw.add_icon(self.action_section, "207")
        tools_gw.add_icon(self.action_help, "73", sub_folder="24x24")
        tools_gw.add_icon(self.action_interpolate, "194")
        tools_gw.add_icon(self.action_orifice, "250", sub_folder="24x24")
        tools_gw.add_icon(self.action_outlet, "251", sub_folder="24x24")
        tools_gw.add_icon(self.action_pump, "252", sub_folder="24x24")
        tools_gw.add_icon(self.action_weir, "253", sub_folder="24x24")
        tools_gw.add_icon(self.action_demand, "254", sub_folder="24x24")


    def _manage_dlg_widgets(self, complet_result, result, new_feature, reload_epa=False, tab='tab_data'):
        """ Creates and populates all the widgets """

        layout_list = []
        widget_offset = 0
        prev_layout = ""
        widget_dict = {'text': 'lineedit', 'typeahead': 'lineedit', 'textarea': 'textarea', 'combo': 'combobox',
                       'check': 'checkbox', 'datetime': 'dateedit', 'hyperlink': 'hyperlink', 'spinbox': 'spinbox',
                       'doublespinbox': 'spinbox'}
        for field in complet_result['body']['data']['fields']:
            if field.get('hidden'):
                continue
            if tab != field['tabname']:
                continue
            if field.get('widgetcontrols') and field['widgetcontrols'].get('hiddenWhenNull') \
                    and field.get('value') in (None, ''):
                continue
            label, widget = tools_gw.set_widgets(self.dlg_cf, complet_result, field, self.tablename, self)
            if widget is None:
                continue

            # Create connections
            if field['widgettype'] not in ('tableview', 'vspacer', 'list', 'hspacer', 'button'):
                if field['widgettype'] == 'hyperlink':
                    if type(widget) == GwHyperLinkLineEdit:
                        widget = getattr(self, f"_set_auto_update_{widget_dict[field['widgettype']]}")(field, self.dlg_cf, widget, new_feature)
                else:
                    widget = getattr(self, f"_set_auto_update_{widget_dict[field['widgettype']]}")(field, self.dlg_cf, widget, new_feature)

            layout = self.dlg_cf.findChild(QGridLayout, field['layoutname'])
            if layout is not None:
                if layout.objectName() != prev_layout:
                    widget_offset = 0
                    prev_layout = layout.objectName()
                # Take the QGridLayout with the intention of adding a QSpacerItem later
                if layout not in layout_list and layout.objectName() in ('lyt_data_1', 'lyt_data_2',
                                                                         'lyt_epa_data_1', 'lyt_epa_data_2'):
                    layout_list.append(layout)

                if field['layoutorder'] is None:
                    message = "The field layoutorder is not configured for"
                    msg = f"formname:{self.tablename}, columnname:{field['columnname']}"
                    tools_qgis.show_message(message, 2, parameter=msg, dialog=self.dlg_cf)
                    continue

                # Manage widget and label positions
                label_pos = field['widgetcontrols']['labelPosition'] if (
                            'widgetcontrols' in field and field['widgetcontrols'] and 'labelPosition' in field[
                             'widgetcontrols']) else None
                widget_pos = field['layoutorder'] + widget_offset

                # The data tab is somewhat special (it has 2 columns)
                if 'lyt_data' in layout.objectName() or 'lyt_epa_data' in layout.objectName():
                    tools_gw.add_widget(self.dlg_cf, field, label, widget)
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

            elif field['layoutname'] != 'lyt_none':
                message = "The field layoutname is not configured for"
                msg = f"formname:{self.tablename}, columnname:{field['columnname']}"
                tools_qgis.show_message(message, 2, parameter=msg, dialog=self.dlg_cf)
        # Add a QSpacerItem into each QGridLayout of the list
        for layout in layout_list:
            vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
            layout.addItem(vertical_spacer1)

        # Manage dscenario sub-tab from epa tab
        try:
            lyt_dscenario = self.dlg_cf.findChild(QGridLayout, "lyt_epa_dsc_3")
            epa_toolbox = self.dlg_cf.findChild(QToolBox, "epa_toolbox")
            if lyt_dscenario.count() == 0:
                epa_toolbox.setItemEnabled(1, False)
            else:
                epa_toolbox.setItemEnabled(1, True)
        except Exception:
            pass

        if reload_epa:
            return
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
        self.action_edit.triggered.connect(partial(self._manage_edition, dlg_cf, self.action_edit, fid, new_feature, False))
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
            partial(self.get_snapped_feature_id, dlg_cf, self.action_get_arc_id, 'v_edit_arc', 'arc', 'tab_data_arc_id',
                    child_type))
        self.action_get_parent_id.triggered.connect(
            partial(self.get_snapped_feature_id, dlg_cf, self.action_get_parent_id, 'v_edit_node', 'node',
                    'tab_data_parent_id', child_type))
        self.action_centered.triggered.connect(partial(self._manage_action_centered, self.canvas, self.layer))
        self.action_copy_paste.triggered.connect(
            partial(self._manage_action_copy_paste, self.dlg_cf, self.feature_type, tab_type))
        self.action_rotation.triggered.connect(partial(self._change_hemisphere, self.dlg_cf, self.action_rotation))
        self.action_link.triggered.connect(partial(self.action_open_link))
        self.action_section.triggered.connect(partial(self._open_section_form))
        self.action_help.triggered.connect(partial(self._open_help, self.feature_type))
        self.ep = QgsMapToolEmitPoint(self.canvas)
        self.action_interpolate.triggered.connect(partial(self._activate_snapping, complet_result, self.ep))

        # EPA Actions
        self.action_orifice.triggered.connect(partial(self._open_orifice_dlg))
        self.action_outlet.triggered.connect(partial(self._open_outlet_dlg))
        self.action_weir.triggered.connect(partial(self._open_weir_dlg))
        if global_vars.project_type == 'ws':
            self.action_pump.triggered.connect(partial(self._open_pump_additional_dlg))
            self.action_demand.triggered.connect(partial(self._open_demand_dlg))
        elif global_vars.project_type == 'ud':
            self.action_pump.triggered.connect(partial(self._open_pump_dlg))
            self.action_demand.triggered.connect(partial(self._open_dwf_dlg))

        # Disable action edit if user can't edit
        if not can_edit:
            self.action_edit.setChecked(False)
            self.action_edit.setEnabled(False)

        return dlg_cf, fid

    def _open_orifice_dlg(self):
        # kwargs
        func_params = {"ui": "GwInfoEpaOrificeUi", "uiName": "info_epa_orifice",
                       "tableviews": [
                        {"tbl": "tbl_orifice", "view": "inp_flwreg_orifice", "add_view": "v_edit_inp_flwreg_orifice", "pk": "nodarc_id", "add_dlg_title": "Orifice - Base"},
                        {"tbl": "tbl_dscenario_orifice", "view": "inp_dscenario_flwreg_orifice", "add_view": "v_edit_inp_dscenario_flwreg_orifice", "pk": ["dscenario_id", "nodarc_id"], "add_dlg_title": "Orifice - Dscenario"}
                       ]}
        kwargs = {"complet_result": self.complet_result, "class": self, "func_params": func_params}
        open_epa_dlg(**kwargs)


    def _open_outlet_dlg(self):
        # kwargs
        func_params = {"ui": "GwInfoEpaOutletUi", "uiName": "info_epa_outlet",
                       "tableviews": [
                        {"tbl": "tbl_outlet", "view": "inp_flwreg_outlet", "add_view": "v_edit_inp_flwreg_outlet", "pk": "nodarc_id", "add_dlg_title": "Outlet - Base"},
                        {"tbl": "tbl_dscenario_outlet", "view": "inp_dscenario_flwreg_outlet", "add_view": "v_edit_inp_dscenario_flwreg_outlet", "pk": ["dscenario_id", "nodarc_id"], "add_dlg_title": "Outlet - Dscenario"}
                       ]}
        kwargs = {"complet_result": self.complet_result, "class": self, "func_params": func_params}
        open_epa_dlg(**kwargs)


    def _open_pump_dlg(self):
        # kwargs
        func_params = {"ui": "GwInfoEpaPumpUi", "uiName": "info_epa_pump",
                       "tableviews": [
                        {"tbl": "tbl_pump", "view": "inp_flwreg_pump", "add_view": "v_edit_inp_flwreg_pump", "pk": "nodarc_id", "add_dlg_title": "Pump - Base"},
                        {"tbl": "tbl_dscenario_pump", "view": "inp_dscenario_flwreg_pump", "add_view": "v_edit_inp_dscenario_flwreg_pump", "pk": ["dscenario_id", "nodarc_id"], "add_dlg_title": "Pump - Dscenario"}
                       ]}
        kwargs = {"complet_result": self.complet_result, "class": self, "func_params": func_params}
        open_epa_dlg(**kwargs)


    def _open_pump_additional_dlg(self):
        # kwargs
        func_params = {"ui": "GwInfoEpaPumpUi", "uiName": "info_epa_pump",
                       "tableviews": [
                        {"tbl": "tbl_pump", "view": "inp_pump_additional", "add_view": "v_edit_inp_pump_additional", "pk": "id", "add_dlg_title": "Pump Additional - Base"},
                        {"tbl": "tbl_dscenario_pump", "view": "inp_dscenario_pump_additional", "add_view": "v_edit_inp_dscenario_pump_additional", "pk": "id", "add_dlg_title": "Pump Additional - Dscenario"}
                       ]}
        kwargs = {"complet_result": self.complet_result, "class": self, "func_params": func_params}
        open_epa_dlg(**kwargs)


    def _open_weir_dlg(self):
        # kwargs
        func_params = {"ui": "GwInfoEpaWeirUi", "uiName": "info_epa_weir",
                       "tableviews": [
                        {"tbl": "tbl_weir", "view": "inp_flwreg_weir", "add_view": "v_edit_inp_flwreg_weir", "pk": "nodarc_id", "add_dlg_title": "Weir - Base"},
                        {"tbl": "tbl_dscenario_weir", "view": "inp_dscenario_flwreg_weir", "add_view": "v_edit_inp_dscenario_flwreg_weir", "pk": ["dscenario_id", "nodarc_id"], "add_dlg_title": "Weir - Dscenario"}
                       ]}
        kwargs = {"complet_result": self.complet_result, "class": self, "func_params": func_params}
        open_epa_dlg(**kwargs)


    def _open_demand_dlg(self):
        # kwargs
        func_params = {"ui": "GwInfoEpaDemandUi", "uiName": "info_epa_demand",
                       "tableviews": [
                        {"tbl": "tbl_dscenario_demand", "view": "inp_dscenario_demand", "add_view": "v_edit_inp_dscenario_demand", "id_name": "feature_id", "pk": "id", "add_dlg_title": "Demand - Dscenario"}
                       ]}
        kwargs = {"complet_result": self.complet_result, "class": self, "func_params": func_params}
        open_epa_dlg(**kwargs)


    def _open_dwf_dlg(self):
        # kwargs
        func_params = {"ui": "GwInfoEpaDwfUi", "uiName": "info_epa_dwf",
                       "tableviews": [
                        {"tbl": "tbl_dwf", "view": "inp_dwf", "pk": ["node_id", "dwfscenario_id"], "add_view": "v_edit_inp_dwf", "add_dlg_title": "DWF"},
                        {"tbl": "tbl_dscenario_inflows", "view": "inp_dscenario_inflows", "pk": ["dscenario_id", "node_id", "order_id"], "add_view": "v_edit_inp_dscenario_inflows", "add_dlg_title": "INFLOWS - Dscenario"}
                       ]}
        kwargs = {"complet_result": self.complet_result, "class": self, "func_params": func_params}
        open_epa_dlg(**kwargs)


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
        pdf_folder = os.path.join(lib_vars.plugin_dir, f'resources{os.sep}png')
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
            tools_gw.disconnect_signal('info', 'add_feature_featureAdded_open_new_feature')
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

        try:
            self.rubber_band.reset()
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
            dlg_interpolate.btn_accept.setEnabled(False)

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
                    dlg_interpolate.btn_accept.setEnabled(False)
                elif self.node1 != str(element_id):
                    self.node2 = str(element_id)
                    tools_qgis.draw_point(QgsPointXY(result.point()), rb, color=QColor(0, 150, 55, 100), width=10)
                    self.rb_interpolate.append(rb)
                    dlg_interpolate.lbl_text.setText(f"Node1: {self.node1}\nNode2: {self.node2}")
                    tools_qgis.show_message(message, message_level=0, parameter=self.node2)
                    dlg_interpolate.btn_accept.setEnabled(True)

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
            tools_qt.set_widget_text(dialog, "tab_data_rotation", str(row[0]))

        sql = (f"SELECT degrees(ST_Azimuth(ST_Point({existing_point_x}, {existing_point_y}),"
               f" ST_Point({point.x()}, {point.y()})))")
        row = tools_db.get_row(sql)
        if row:
            tools_qt.set_widget_text(dialog, "tab_data_hemisphere", str(row[0]))
            message = "Hemisphere of the node has been updated. Value is"
            tools_qgis.show_info(message, parameter=str(row[0]))

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
        lib_vars.session_vars['dialog_docker'].widget().dlg_closed.disconnect()
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
        self.feature = tools_qgis.get_feature_by_expr(self.layer, expr_filter)
        return self.feature


    def _manage_action_centered(self, canvas, layer):
        """ Center map to current feature """

        if not self.feature:
            self._get_feature(self.tab_type)
        layer.selectByIds([self.feature.id()])
        canvas.zoomToSelected(layer)


    def _get_last_value(self, dialog, generic=False):

        if generic:
            widgets = dialog.findChildren(QWidget)
            for widget in widgets:
                if widget.hasFocus():
                    value = tools_qt.get_text(dialog, widget)
                    if str(value) not in ('', None, -1, "None") and widget.property('columnname'):
                        self.my_json[str(widget.property('columnname'))] = str(value)
                    widget.clearFocus()
        else:
            try:
                # Widgets in ('lyt_top_1', 'lyt_bot_1', 'lyt_bot_2')
                other_widgets = []
                for field in self.complet_result['body']['data']['fields']:
                    if field['layoutname'] in ('lyt_top_1', 'lyt_bot_1', 'lyt_bot_2'):
                        widget = dialog.findChild(QWidget, field['widgetname'])
                        if widget:
                            other_widgets.append(widget)
                # Widgets in tab_data
                widgets = dialog.tab_data.findChildren(QWidget)
                widgets.extend(other_widgets)
                for widget in widgets:
                    if widget.hasFocus():
                        value = tools_qt.get_text(dialog, widget)
                        if str(value) not in ('', None, -1, "None") and widget.property('columnname'):
                            self.my_json[str(widget.property('columnname'))] = str(value)
                        widget.clearFocus()
                # Widgets in tab_epa
                widgets = dialog.tab_epa.findChildren(QWidget)
                widgets.extend(other_widgets)
                for widget in widgets:
                    if widget.hasFocus():
                        value = tools_qt.get_text(dialog, widget)
                        if str(value) not in ('', None, -1, "None") and widget.property('columnname'):
                            self.my_json_epa[str(widget.property('columnname'))] = str(value)
                        widget.clearFocus()
            except RuntimeError:
                pass


    def _manage_edition(self, dialog, action_edit, fid, new_feature=None, generic=False):

        # With the editing QAction we need to collect the last modified value (self.get_last_value()),
        # since the "editingFinished" signals of the widgets are not detected.
        # Therefore whenever the cursor enters a widget, it will ask if we want to save changes

        if not action_edit.isChecked():
            self._get_last_value(dialog, generic)
            if str(self.my_json) == '{}' and str(self.my_json_epa) == '{}':
                tools_qt.set_action_checked(action_edit, False)
                tools_gw.enable_widgets(dialog, self.complet_result['body']['data'], False)
                if self.epa_complet_result:
                    tools_gw.enable_widgets(dialog, self.epa_complet_result['body']['data'], False)
                self._enable_actions(dialog, False)
                return
            save = self._ask_for_save(action_edit, fid)
            if save:
                self._manage_accept(dialog, action_edit, new_feature, self.my_json, False, generic)
            elif self.new_feature_id is not None:
                if lib_vars.session_vars['dialog_docker'] and lib_vars.session_vars['info_docker']:
                    self._manage_docker_close()
                else:
                    tools_gw.close_dialog(dialog)
            self._reset_my_json()
        else:
            tools_qt.set_action_checked(action_edit, True)
            tools_gw.enable_all(dialog, self.complet_result['body']['data'])
            if self.epa_complet_result:
                tools_gw.enable_all(dialog, self.epa_complet_result['body']['data'])
            self._enable_actions(dialog, True)


    def _accept_from_btn(self, dialog, action_edit, new_feature, my_json, last_json, generic=False):

        if not action_edit.isChecked():
            tools_gw.close_dialog(dialog)
            return

        self._manage_accept(dialog, action_edit, new_feature, my_json, True, generic)
        self._reset_my_json()


    def _manage_accept(self, dialog, action_edit, new_feature, my_json, close_dlg, generic=False):

        self._get_last_value(dialog, generic)
        status = self._accept(dialog, self.complet_result, my_json, close_dlg=close_dlg, new_feature=new_feature, generic=generic)
        if status:  # Commit succesfull and dialog keep opened
            tools_qt.set_action_checked(action_edit, False)
            tools_gw.enable_widgets(dialog, self.complet_result['body']['data'], False)
            if self.epa_complet_result:
                tools_gw.enable_widgets(dialog, self.epa_complet_result['body']['data'], False)
            self._enable_actions(dialog, False)


    def _stop_editing(self, dialog, action_edit, layer, fid, my_json, new_feature=None):

        if (my_json == '' or str(my_json) == '{}') and (self.my_json_epa == '' or str(self.my_json_epa) == '{}'):
            QgsProject.instance().blockSignals(True)
            tools_qt.set_action_checked(action_edit, False)
            tools_gw.enable_widgets(dialog, self.complet_result['body']['data'], False)
            if self.epa_complet_result:
                tools_gw.enable_widgets(dialog, self.epa_complet_result['body']['data'], False)
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
        if self.epa_complet_result:
            tools_gw.enable_all(dialog, self.epa_complet_result['body']['data'])
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


    def _accept(self, dialog, complet_result, _json, p_widget=None, clear_json=False, close_dlg=True, new_feature=None, generic=False):
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

        # Tab data
        p_table_id = complet_result['body']['feature']['tableName']
        id_name = complet_result['body']['feature']['idName']
        newfeature_id = complet_result['body']['feature']['id']
        parent_fields = complet_result['body']['data']['parentFields']
        fields_reload = ""
        list_mandatory = []
        for field in complet_result['body']['data']['fields']:
            if field.get('hidden', False):
                continue

            if p_widget and (field['widgetname'] == p_widget.objectName()):
                if field['widgetcontrols'] and 'autoupdateReloadFields' in field['widgetcontrols']:
                    fields_reload = field['widgetcontrols']['autoupdateReloadFields']

            if field['ismandatory']:
                widget = dialog.findChild(QWidget, field['widgetname'])
                widget.setStyleSheet(None)
                value = tools_qt.get_text(dialog, widget)
                if value in ('null', None, ''):
                    widget.setStyleSheet("border: 1px solid red")
                    list_mandatory.append(field['widgetname'])

        if list_mandatory:
            msg = "Some mandatory values are missing. Please check the widgets marked in red."
            tools_qgis.show_warning(msg, dialog=dialog)
            tools_qt.set_action_checked("actionEdit", True, dialog)
            QgsProject.instance().blockSignals(False)
            return False

        if _json != '' and str(_json) != '{}':
            if not generic and self._has_elev_and_y_json(_json):
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
                self._enable_action(dialog, "actionCentered", True)
                self._enable_action(dialog, "actionSetToArc", True)
                global is_inserting
                is_inserting = False
                my_json = json.dumps(_json)
                if my_json == '' or str(my_json) == '{}':
                    if close_dlg:
                        if lib_vars.session_vars['dialog_docker'] and dialog == lib_vars.session_vars['dialog_docker'].widget():
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

            # Get utils_grafanalytics_automatic_trigger param
            row = tools_gw.get_config_value("utils_grafanalytics_automatic_trigger", table='config_param_system')
            thread = row[0] if row else None
            if thread:
                thread = json.loads(thread)
                thread = tools_os.set_boolean(thread['status'], default=False)
                if 'closed' not in _json:
                    thread = False
            epa_type_changed = False
            if 'epa_type' in _json:
                epa_type_changed = True

            json_result = tools_gw.execute_procedure('gw_fct_setfields', body)
            if not json_result:
                QgsProject.instance().blockSignals(False)
                return False

            if clear_json:
                _json = {}

            self._reset_my_json(False)

            if "Accepted" in json_result['status']:
                msg_text = json_result['message']['text']
                if msg_text is None:
                    msg_text = 'Feature upserted'
                msg_level = json_result['message']['level']
                if msg_level is None:
                    msg_level = 1
                tools_qgis.show_message(msg_text, message_level=msg_level, dialog=dialog)
                self._reload_fields(dialog, json_result, p_widget)
                if epa_type_changed:
                    self._reload_epa_tab(dialog)

                if thread:
                    # If param is true show question and create thread
                    msg = "You closed a valve, this will modify the current mapzones and it may take a little bit of time."
                    if lib_vars.user_level['level'] in ('1', '2'):
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

        # Tab EPA
        if not generic and self.my_json_epa != '' and str(self.my_json_epa) != '{}':
            feature = f'"id":"{self.feature_id}", '
            epa_type = tools_qt.get_text(dialog, 'tab_data_epa_type').lower()
            epa_table_id = 've_epa_' + epa_type
            if global_vars.project_type == 'ws' and self.feature_type == 'connec' and epa_type == 'junction':
                epa_table_id = 've_epa_connec'
            my_json = json.dumps(self.my_json_epa)
            feature += f'"tableName":"{epa_table_id}", '
            feature += f' "featureType":"{self.feature_type}" '
            extras = f'"fields":{my_json}, "afterInsert":"{after_insert}"'
            body = tools_gw.create_body(feature=feature, extras=extras)
            json_result = tools_gw.execute_procedure('gw_fct_setfields', body)
            self._reset_my_json_epa()
            if not json_result or "Failed" in json_result['status']:
                QgsProject.instance().blockSignals(False)
                return False

        # Force a map refresh
        tools_qgis.refresh_map_canvas()  # First refresh all the layers
        global_vars.iface.mapCanvas().refresh()  # Then refresh the map view itself

        if close_dlg:
            if lib_vars.session_vars['dialog_docker'] and dialog == lib_vars.session_vars['dialog_docker'].widget():
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
            static_actions = ('actionEdit', 'actionCentered', 'actionLink', 'actionHelp',
                              'actionSection', 'actionSetToArc',
                              'actionOrifice', 'actionOutlet', 'actionPump', 'actionWeir', 'actionDemand')

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

            if 'visibleTabs' not in self.complet_result['body']['form']:
                return
            for tab in self.visible_tabs:
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


    def _check_tab_data(self, field):
        """ Check if current tab name is tab_data """

        if field.get('tabname') != 'tab_data':
            return False
        return True


    def _clean_my_json(self, widget):
        """ Delete keys if exist, when widget is autoupdate """

        try:
            self.my_json.pop(str(widget.property('columnname')), None)
        except KeyError:
            pass


    def _reset_my_json(self, reset_epa=True):
        """ Clear the my_json dictionary """

        self.my_json.clear()
        if reset_epa:
            self._reset_my_json_epa()


    def _reset_my_json_epa(self):
        """ Clear the my_json_epa dictionary """
        self.my_json_epa.clear()


    def _set_auto_update_lineedit(self, field, dialog, widget, new_feature=None):

        if widget.property('isfilter'):
            return widget
        if widget.property('widgetcontrols') is not None and 'saveValue' in widget.property('widgetcontrols'):
            if widget.property('widgetcontrols')['saveValue'] is False:
                return widget

        if self._check_tab_data(field):  # Tab data
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
        else:  # Other tabs
            widget.editingFinished.connect(partial(tools_gw.get_values, dialog, widget, self.my_json_epa))
            # TODO: Make autoupdate widgets work
        widget.textChanged.connect(partial(self._enabled_accept, dialog))
        widget.textChanged.connect(partial(self._check_datatype_validator, dialog, widget, dialog.btn_accept))
        widget.textChanged.connect(partial(self._check_min_max_value, dialog, widget, dialog.btn_accept))

        return widget


    def _set_auto_update_textarea(self, field, dialog, widget, new_feature):

        if widget.property('isfilter'): return widget
        if widget.property('widgetcontrols') is not None and 'saveValue' in widget.property('widgetcontrols'):
            if widget.property('widgetcontrols')['saveValue'] is False: return widget

        if self._check_tab_data(field):  # Tab data
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
        else:  # Other tabs
            widget.textChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json_epa))
            # TODO: Make autoupdate widgets work
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

        changed_color = "#3ED396"
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
                cur_value = tools_qt.get_text(dialog, widget, return_string_null=False)
                value = field["value"]
                if str(cur_value) != str(value):
                    widget.setText(value)
                    if not isinstance(widget, QPushButton):
                        widget.setStyleSheet(f"border: 2px solid {changed_color}")
                    else:
                        changed_color = "#EB9438"
                    if getattr(widget, 'isReadOnly', False):
                        widget.setStyleSheet(f"QLineEdit {{background: rgb(244, 244, 244); color: rgb(100, 100, 100); "
                                             f"border: 2px solid {changed_color}}}")

            elif "message" in field:
                level = field['message']['level'] if 'level' in field['message'] else 0
                tools_qgis.show_message(field['message']['text'], level)


    def _enabled_accept(self, dialog):
        dialog.btn_accept.setEnabled(True)


    def _reload_epa_tab(self, dialog):
        epa_type = tools_qt.get_text(dialog, 'tab_data_epa_type')
        # call getinfofromid
        if epa_type.lower() == 'undefined':
            tools_qt.enable_tab_by_tab_name(self.tab_main, 'tab_epa', False)
            return

        tablename = 've_epa_' + epa_type.lower()
        if global_vars.project_type == 'ws' and self.feature_type == 'connec' and epa_type.lower() == 'junction':
            tablename = 've_epa_connec'
        feature = f'"tableName":"{tablename}", "id":"{self.feature_id}", "epaType": "{epa_type}"'
        body = tools_gw.create_body(feature=feature)
        function_name = 'gw_fct_getinfofromid'
        complet_result = tools_gw.execute_procedure(function_name, body)
        self.epa_complet_result = complet_result
        if complet_result:
            if complet_result['body']['form'].get('visibleTabs'):
                self.visible_tabs = complet_result['body']['form']['visibleTabs']
                self._show_actions(self.dlg_cf, self.tab_main.currentWidget().objectName())
            for lyt in dialog.findChildren(QGridLayout, QRegularExpression('lyt_epa')):
                i = 0
                while i < lyt.count():
                    item = lyt.itemAt(i)
                    widget = item.widget()
                    if widget:
                        widget.deleteLater()
                    else:  # for QSpacerItems
                        lyt.removeItem(item)
                    i += 1
            self._manage_dlg_widgets(complet_result, {}, False, reload_epa=True, tab='tab_epa')
            tools_qt.enable_tab_by_tab_name(self.tab_main, 'tab_epa', True)
            if self.action_edit.isChecked():
                tools_gw.enable_all(dialog, complet_result['body']['data'])
            else:
                tools_gw.enable_widgets(dialog, complet_result['body']['data'], False)
            self._reset_my_json_epa()
            dialog.show()


    def _set_auto_update_combobox(self, field, dialog, widget, new_feature):

        if widget.property('isfilter'): return widget
        if widget.property('widgetcontrols') is not None and 'saveValue' in widget.property('widgetcontrols'):
            if widget.property('widgetcontrols')['saveValue'] is False: return widget

        if self._check_tab_data(field):  # Tab data
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                widget.currentIndexChanged.connect(partial(self._clean_my_json, widget))
                widget.currentIndexChanged.connect(partial(tools_gw.get_values, dialog, widget, _json))
                widget.currentIndexChanged.connect(partial(
                    self._accept, dialog, self.complet_result, _json, None, True, False, new_feature))
            else:
                widget.currentIndexChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))
        else:  # Other tabs
            widget.currentIndexChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json_epa))
            # TODO: Make autoupdate widgets work

        return widget


    def _set_auto_update_dateedit(self, field, dialog, widget, new_feature):

        if widget.property('isfilter'): return widget
        if widget.property('widgetcontrols') is not None and 'saveValue' in widget.property('widgetcontrols'):
            if widget.property('widgetcontrols')['saveValue'] is False: return widget

        if self._check_tab_data(field):  # Tab data
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                widget.valueChanged.connect(partial(self._clean_my_json, widget))
                widget.valueChanged.connect(partial(tools_gw.get_values, dialog, widget, _json))
                widget.valueChanged.connect(partial(
                    self._accept, dialog, self.complet_result, _json, None, True, False, new_feature))
            else:
                widget.valueChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))
        else:  # Other tabs
            widget.valueChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json_epa))
            # TODO: Make autoupdate widgets work

        return widget


    def _set_auto_update_spinbox(self, field, dialog, widget, new_feature):

        if widget.property('isfilter'): return widget
        if widget.property('isfilter'): return widget
        if widget.property('widgetcontrols') is not None and 'saveValue' in widget.property('widgetcontrols'):
            if widget.property('widgetcontrols')['saveValue'] is False: return widget

        if self._check_tab_data(field):  # Tab data
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                widget.valueChanged.connect(partial(self._clean_my_json, widget))
                widget.valueChanged.connect(partial(tools_gw.get_values, dialog, widget, _json))
                widget.valueChanged.connect(partial(
                    self._accept, dialog, self.complet_result, _json, None, True, False, new_feature))
            else:
                widget.valueChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))
        else:  # Other tabs
            widget.valueChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json_epa))
            # TODO: Make autoupdate widgets work

        return widget


    def _set_auto_update_checkbox(self, field, dialog, widget, new_feature):

        if widget.property('isfilter'): return widget
        if widget.property('widgetcontrols') is not None and 'saveValue' in widget.property('widgetcontrols'):
            if widget.property('widgetcontrols')['saveValue'] is False: return widget

        if self._check_tab_data(field):  # Tab data
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                widget.stateChanged.connect(partial(self._clean_my_json, widget))
                widget.stateChanged.connect(partial(tools_gw.get_values, dialog, widget, _json))
                widget.stateChanged.connect(partial(
                    self._accept, dialog, self.complet_result, _json, None, True, False, new_feature))
            else:
                widget.stateChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))
        else:  # Other tabs
            widget.stateChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json_epa))
            # TODO: Make autoupdate widgets work
        return widget


    def run_settopology(self, widget, **kwargs):
        """ Sets node_1/2 from lineedit & converts widget into button if function run successfully """

        dialog = kwargs['dialog']
        field = kwargs['field']
        complet_result = kwargs['complet_result']
        feature_id = complet_result['body']['feature']['id']
        text = tools_qt.get_text(dialog, widget, return_string_null=True)

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
            new_widget = tools_gw._manage_button(**kwargs)
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
            if not action.objectName():
                continue
            action.setVisible(False)

        if not self.visible_tabs:
            return

        for tab in self.visible_tabs:
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

    def _tab_activation(self, dialog):
        """ Call functions depend on tab selection """

        # Get index of selected tab
        index_tab = self.tab_main.currentIndex()
        tab_name = self.tab_main.widget(index_tab).objectName()
        self._show_actions(dialog, tab_name)

        # Tab 'Elements'
        if self.tab_main.widget(index_tab).objectName() == 'tab_elements' and not self.tab_element_loaded:
            self._manage_dlg_widgets(self.complet_result, self.complet_result['body']['data'], False, tab='tab_elements')
            filter_fields = f'"{self.field_id}":{{"value":"{self.feature_id}","filterSign":"="}}'
            self._init_tab(self.complet_result, filter_fields)
            self.tab_element_loaded = True
        # Tab 'EPA'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_epa' and not self.tab_epa_loaded:
            self._reload_epa_tab(dialog)
            filter_fields = f'"{self.field_id}":{{"value":"{self.feature_id}","filterSign":"="}}'
            self._init_tab(self.complet_result, filter_fields)
            self.tab_epa_loaded = True
        # Tab 'Relations'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_relations' and not self.tab_relations_loaded:
            self._manage_dlg_widgets(self.complet_result, self.complet_result['body']['data'], False, tab='tab_relations')
            filter_fields = f'"{self.field_id}":{{"value":"{self.feature_id}","filterSign":"="}}'
            self._init_tab(self.complet_result, filter_fields)
            self.tab_relations_loaded = True
        # Tab 'Connections'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_connections' and not self.tab_connections_loaded:
            self._manage_dlg_widgets(self.complet_result, self.complet_result['body']['data'], False, tab='tab_connections')
            filter_fields = f'"{self.field_id}":{{"value":"{self.feature_id}","filterSign":"="}}'
            self._init_tab(self.complet_result, filter_fields)
            self.tab_connections_loaded = True
        # Tab 'Hydrometer'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_hydrometer' and not self.tab_hydrometer_loaded:
            self._manage_dlg_widgets(self.complet_result, self.complet_result['body']['data'], False, tab='tab_hydrometer')
            filter_fields = f'"feature_id":{{"value":"{self.feature_id}","filterSign":"="}}'
            self._init_tab(self.complet_result, filter_fields, id_name="feature_id")
            self.tab_hydrometer_loaded = True
        # Tab 'Hydrometer values'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_hydrometer_val' and not self.tab_hydrometer_val_loaded:
            self._manage_dlg_widgets(self.complet_result, self.complet_result['body']['data'], False, tab='tab_hydrometer_val')
            filter_fields = f'"feature_id":{{"value":"{self.feature_id}","filterSign":"="}}'
            self._init_tab(self.complet_result, filter_fields, id_name="feature_id")
            self.tab_hydrometer_val_loaded = True
        # Tab 'Visit'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_visit' and not self.tab_visit_loaded:
            self._manage_dlg_widgets(self.complet_result, self.complet_result['body']['data'], False, tab='tab_visit')
            filter_fields = f'"{self.field_id}":{{"value":"{self.feature_id}","filterSign":"="}}'
            self._init_tab(self.complet_result, filter_fields)
            self.tab_visit_loaded = True
        # Tab 'Event'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_event' and not self.tab_event_loaded:
            self._manage_dlg_widgets(self.complet_result, self.complet_result['body']['data'], False, tab='tab_event')
            filter_fields = f'"{self.field_id}":{{"value":"{self.feature_id}","filterSign":"="}}'
            self._init_tab(self.complet_result, filter_fields)
            self.tab_event_loaded = True
        # Tab 'Documents'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_documents' and not self.tab_document_loaded:
            self._manage_dlg_widgets(self.complet_result, self.complet_result['body']['data'], False, tab='tab_documents')
            filter_fields = f'"{self.field_id}":{{"value":"{self.feature_id}","filterSign":"="}}'
            self._init_tab(self.complet_result, filter_fields)
            self.tab_document_loaded = True
        # Tab 'Plan'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_plan' and not self.tab_plan_loaded:
            self._fill_tab_plan(self.complet_result)
            self.tab_plan_loaded = True


    def _init_tab(self, complet_result, filter_fields='', id_name=None):

        index_tab = self.tab_main.currentIndex()
        list_tables = self.tab_main.widget(index_tab).findChildren(QTableView)
        complet_list = []
        for table in list_tables:
            widgetname = table.objectName()
            columnname = table.property('columnname')
            if columnname is None:
                msg = f"widget {widgetname} in tab {self.tab_main.widget(index_tab).objectName()} has not columnname and cant be configured"
                tools_qgis.show_info(msg, 3)
                continue
            linkedobject = table.property('linkedobject')
            complet_list, widget_list = self._fill_tbl(complet_result, self.dlg_cf, widgetname, linkedobject, filter_fields, id_name)
            if complet_list is False:
                return False
            tools_gw.set_filter_listeners(complet_result, self.dlg_cf, widget_list, columnname, widgetname, self.feature_id)
        return complet_list


    def _fill_tbl(self, complet_result, dialog, widgetname, linkedobject, filter_fields, id_name=None):
        """ Put filter widgets into layout and set headers into QTableView """

        index_tab = self.tab_main.currentIndex()
        tab_name = self.tab_main.widget(index_tab).objectName().replace('tab_', "")
        complet_list = self._get_list(complet_result, '', tab_name, filter_fields, widgetname, 'form_feature', linkedobject, id_name)

        if complet_list is False:
            return False, False
        for field in complet_list['body']['data']['fields']:
            if 'hidden' in field and field['hidden']: continue

            widget = self.dlg_cf.findChild(QTableView, field['widgetname'])
            if widget is None: continue
            short_name = field['widgetname'].replace(f"tab_{tab_name}_", "", 1)
            widget = tools_gw.add_tableview_header(widget, field)
            widget = tools_gw.fill_tableview_rows(widget, field)
            widget = tools_gw.set_tablemodel_config(dialog, widget, short_name, 1, True)
            tools_qt.set_tableview_config(widget, edit_triggers=QTableView.DoubleClicked)
            if 'tab_epa' in widgetname:
                model = widget.model()
                tbl_upsert = widget.property('widgetcontrols').get('tableUpsert')
                setattr(self, f"my_json_{tbl_upsert}", {})

                # get view addparam
                addparam = None
                sql = f"SELECT addparam FROM sys_table WHERE id = '{tbl_upsert}'"
                row = tools_db.get_row(sql)
                if row:
                    addparam = row[0]
                    if addparam:
                        addparam = addparam.get('pkey')
                model.dataChanged.connect(partial(tbl_data_changed, self, tbl_upsert, widget, model, addparam))
                dialog.btn_accept.clicked.connect(partial(save_tbl_changes, tbl_upsert, self, dialog, addparam))

        widget_list = []
        widget_list.extend(self.tab_main.widget(index_tab).findChildren(QComboBox, QRegularExpression(f"{tab_name}_")))
        widget_list.extend(self.tab_main.widget(index_tab).findChildren(QTableView, QRegularExpression(f"{tab_name}_")))
        widget_list.extend(self.tab_main.widget(index_tab).findChildren(QLineEdit, QRegularExpression(f"{tab_name}_")))
        widget_list.extend(self.tab_main.widget(index_tab).findChildren(QgsDateTimeEdit, QRegularExpression(f"{tab_name}_")))
        return complet_list, widget_list


    def _set_filter_listeners(self, complet_result, dialog, widget_list, columnname, widgetname):
        """
        functions called in -> widget.textChanged.connect(partial(getattr(tools_backend_calls, widgetfunction), **kwargs))
                            -> widget.currentIndexChanged.connect(partial(getattr(tools_backend_calls, widgetfunction), **kwargs))
           module = tools_backend_calls -> def open_rpt_result(**kwargs)
                                        -> def filter_table(self, **kwargs)
         """

        model = None
        for widget in widget_list:
            if type(widget) is QTableView:
                model = widget.model()

        # Emitting the text changed signal of a widget slows down the process, so instead of emitting a signal for each
        # widget, we will emit only the one of the last widget. This is enough for the correct filtering of the
        # QTableView and we gain in performance
        last_widget = None
        for widget in widget_list:
            if widget.property('isfilter') is not True: continue
            widgetfunction = False
            func_params = None
            if widget.property('widgetfunction') is not None and 'functionName' in widget.property('widgetfunction'):
                widgetfunction = widget.property('widgetfunction')['functionName']
                func_params = widget.property('widgetfunction').get('parameters')
            if widgetfunction is False: continue

            field_id = None
            if func_params is not None:
                field_id = func_params.get('field_id')

            linkedobject = ""
            if widget.property('linkedobject') is not None:
                linkedobject = widget.property('linkedobject')

            kwargs = {"complet_result": complet_result, "model": model, "dialog": dialog, "linkedobject": linkedobject,
                      "columnname": columnname, "widget": widget, "widgetname": widgetname, "widget_list": widget_list,
                      "feature_id": self.feature_id, "func_params": func_params, "field_id": field_id}
            if type(widget) is QLineEdit:
                widget.textChanged.connect(partial(getattr(tools_backend_calls, widgetfunction), **kwargs))
            elif type(widget) is QComboBox:
                widget.currentIndexChanged.connect(partial(getattr(tools_backend_calls, widgetfunction), **kwargs))
            elif type(widget) is QgsDateTimeEdit:
                widget.setDate(QDate.currentDate())
                widget.dateChanged.connect(partial(getattr(tools_backend_calls, widgetfunction), **kwargs))

            else:
                continue
            last_widget = widget

        # Emit signal changed
        if last_widget is not None:
            if type(last_widget) is QLineEdit:
                text = tools_qt.get_text(dialog, last_widget, False, False)
                last_widget.textChanged.emit(text)
            elif type(last_widget) is QComboBox:
                last_widget.currentIndexChanged.emit(last_widget.currentIndex())


    def _get_list(self, complet_result, form_name='', tab_name='', filter_fields='', widgetname='', formtype='', linkedobject='', id_name=None):

        form = f'"formName":"{form_name}", "tabName":"{tab_name}", "widgetname":"{widgetname}", "formtype":"{formtype}"'
        id_name = complet_result['body']['feature']['idName'] if id_name is None else id_name
        feature = f'"tableName":"{linkedobject}", "idName":"{id_name}", "id":"{self.feature_id}"'
        body = tools_gw.create_body(form, feature, filter_fields)
        json_result = tools_gw.execute_procedure('gw_fct_getlist', body)
        if json_result is None or json_result['status'] == 'Failed':
            return False
        complet_list = json_result
        if not complet_list:
            return False

        return complet_list


    """ FUNCTIONS RELATED WITH TAB PLAN """


    def _fill_tab_plan(self, complet_result):

        plan_layout = self.dlg_cf.findChild(QGridLayout, 'lyt_plan_1')

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
                tools_qgis.show_message("No listValues for: " + json_result['body']['data'], 2)
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
        dlg_generic.dlg_closed.connect(partial(tools_gw.close_dialog, dlg_generic))
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
            tools_qgis.show_warning(message)
            return

        # Form handling so that the user cannot change values until the process is finished
        self.dlg_cf.setEnabled(False)

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
        result = tools_gw.execute_procedure('gw_fct_setcatalog', body)
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
        options = {'arc': ['arc_id', 'tab_data_arc_id'], 'node': ['node_id', 'tab_data_parent_id'],
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
        Function called in def get_id(self, dialog, action, option, point, event):
            getattr(self, options[option][1])(feat_id, child_type)

            :param feat_id: Id of the snapped feature
        """

        w_dma_id = self.dlg_cf.findChild(QWidget, 'tab_data_dma_id')
        if isinstance(w_dma_id, QComboBox):
            dma_id = tools_qt.get_combo_value(self.dlg_cf, w_dma_id)
        else:
            dma_id = tools_qt.get_text(self.dlg_cf, w_dma_id)
        w_presszone_id = self.dlg_cf.findChild(QComboBox, 'tab_data_presszone_id')
        presszone_id = tools_qt.get_combo_value(self.dlg_cf, w_presszone_id)
        w_sector_id = self.dlg_cf.findChild(QComboBox, 'tab_data_sector_id')
        sector_id = tools_qt.get_combo_value(self.dlg_cf, w_sector_id)
        w_dqa_id = self.dlg_cf.findChild(QComboBox, 'tab_data_dqa_id')
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
# region Static functions used by the widgets in the custom form


def get_list(table_name, id_name=None, filter=None):
    """ Mount and execute the query for gw_fct_getlist """

    feature = f'"tableName":"{table_name}"'
    filter_fields = f'"limit": -1'
    if id_name and filter:
        filter_fields += f', "{id_name}": {{"filterSign":"=", "value":"{filter}"}}'
    body = tools_gw.create_body(feature=feature, filter_fields=filter_fields)
    json_result = tools_gw.execute_procedure('gw_fct_getlist', body)
    if json_result is None or json_result['status'] == 'Failed':
        return False
    complet_list = json_result
    if not complet_list:
        return False

    return complet_list


def fill_tbl(complet_list, tbl, info, view):
    if complet_list is False:
        return False, False

    # get view addparam
    addparam = None
    sql = f"SELECT addparam FROM sys_table WHERE id = '{view}'"
    row = tools_db.get_row(sql)
    if row:
        addparam = row[0]
        if addparam:
            addparam = addparam.get('pkey')

    setattr(info, f"my_json_{view}", {})
    # headers
    headers = complet_list['body']['form'].get('headers')
    non_editable_columns = []
    if headers:
        model = tbl.model()
        if model is None:
            model = QStandardItemModel()

        # Related by Qtable
        model.clear()
        tbl.setModel(model)
        tbl.horizontalHeader().setStretchLastSection(True)
        # Non-editable columns
        non_editable_columns = [item['header'] for item in headers if item.get('editable') is False]

    # values
    for field in complet_list['body']['data']['fields']:
        if 'hidden' in field and field['hidden']: continue
        model = tbl.model()
        if model is None:
            model = QStandardItemModel()
            tbl.setModel(model)
        model.removeRows(0, model.rowCount())

        if field['value']:
            tbl = tools_gw.add_tableview_header(tbl, field)
            tbl = tools_gw.fill_tableview_rows(tbl, field)
        tools_qt.set_tableview_config(tbl, edit_triggers=QTableView.DoubleClicked)
        model.dataChanged.connect(partial(tbl_data_changed, info, view, tbl, model, addparam))
    # editability
    tbl.model().flags = lambda index: epa_tbl_flags(index, model, non_editable_columns)


def epa_tbl_flags(index, model, non_editable_columns=None):

    column_name = model.headerData(index.column(), Qt.Horizontal, Qt.DisplayRole)
    if non_editable_columns and column_name in non_editable_columns:
        flags = Qt.ItemIsSelectable | Qt.ItemIsEnabled
        return flags

    return QStandardItemModel.flags(model, index)

# region Tab epa


def open_epa_dlg(**kwargs):
    # Get variables
    complet_result = kwargs['complet_result']
    info = kwargs['class']
    func_params = kwargs['func_params']
    ui = func_params['ui']
    ui_name = func_params['uiName']
    tableviews = func_params['tableviews']
    widgets = func_params.get('widgets')
    widgets_tablename = func_params.get('widgetsTablename')
    widgets_table_pk = func_params.get('widgetsTablePk')

    feature_id = complet_result['body']['feature']['id']
    id_name = complet_result['body']['feature']['idName']

    # Build dlg
    info.dlg = globals()[ui]()
    tools_gw.load_settings(info.dlg)

    # Fill widgets
    if widgets and widgets_tablename:
        fields = str(widgets).replace('[', '').replace(']', '').replace('\'', '')
        sql = f"SELECT {fields} FROM {widgets_tablename} WHERE {id_name} = '{feature_id}'"
        row = tools_db.get_row(sql)
        if row:
            setattr(info, f"my_json_{widgets_tablename}", {})
            dwfscenario_sql = f"SELECT id, idval FROM cat_dwf_scenario WHERE id IS NOT NULL"
            dwfscenario_rows = tools_db.get_rows(dwfscenario_sql)
            pattern_sql = f"SELECT pattern_id as id, pattern_id as idval FROM inp_pattern WHERE pattern_id IS NOT NULL"
            pattern_rows = tools_db.get_rows(pattern_sql)
            for i, widget in enumerate(widgets):
                # dwfscenario_id
                if widget == 'dwfscenario_id':
                    w = info.dlg.findChild(QComboBox, widget)
                    if w is None:
                        continue
                    if dwfscenario_rows:
                        tools_qt.fill_combo_values(w, dwfscenario_rows, 1, add_empty=True)
                        tools_qt.set_combo_value(w, str(row[i]), 0)
                        w.currentIndexChanged.connect(partial(tools_gw.get_values, info.dlg, w, getattr(info, f"my_json_{widgets_tablename}")))
                        w.currentIndexChanged.connect(partial(_manage_accept_btn, info, widgets_tablename))
                    continue

                # patX
                if 'pat' in widget:
                    w = info.dlg.findChild(QComboBox, widget)
                    if w is None:
                        continue
                    if pattern_rows:
                        tools_qt.fill_combo_values(w, pattern_rows, add_empty=True)
                        tools_qt.set_combo_value(w, row[i], 0)
                        w.currentIndexChanged.connect(partial(tools_gw.get_values, info.dlg, w, getattr(info, f"my_json_{widgets_tablename}")))
                        w.currentIndexChanged.connect(partial(_manage_accept_btn, info, widgets_tablename))
                    continue

                # lineedits
                w = info.dlg.findChild(QLineEdit, widget)
                if w is None:
                    continue
                tools_qt.set_widget_text(info.dlg, w, row[i])
                w.editingFinished.connect(partial(tools_gw.get_values, info.dlg, w, getattr(info, f"my_json_{widgets_tablename}")))
                w.editingFinished.connect(partial(_manage_accept_btn, info, widgets_tablename))
        info.dlg.btn_accept.clicked.connect(partial(save_widgets_changes, widgets_tablename, info, info.dlg, widgets_table_pk))
    # Fill tableviews
    for tableview in tableviews:
        tbl = tableview['tbl']
        tbl = info.dlg.findChild(QTableView, tbl)
        if not tbl:
            continue
        view = tableview['view']
        add_view = tableview.get('add_view', view)
        add_dlg_title = tableview.get('add_dlg_title', f"{add_view} - Base")
        pk = tableview.get('pk')
        if not pk:
            pk = id_name
        id_name = tableview.get('id_name', id_name)

        complet_list = get_list(view, id_name, feature_id)
        fill_tbl(complet_list, tbl, info, view)
        tools_gw.set_tablemodel_config(info.dlg, tbl, view, schema_name=info.schema_name, isQStandardItemModel=True)
        info.dlg.btn_accept.clicked.connect(partial(save_tbl_changes, view, info, info.dlg, pk))

        # Add & Delete buttons
        if 'dscenario' not in view:
            btn_add_base = info.dlg.findChild(QPushButton, 'btn_add_base')
            if btn_add_base:
                tools_gw.add_icon(btn_add_base, '111b', "24x24")
                btn_add_base.clicked.connect(partial(add_row_epa, tbl, view, add_view, pk, info.dlg, add_dlg_title, **kwargs))
            btn_delete_base = info.dlg.findChild(QPushButton, 'btn_delete_base')
            if btn_delete_base:
                tools_gw.add_icon(btn_delete_base, '112b', "24x24")
                btn_delete_base.clicked.connect(partial(delete_tbl_row, tbl, view, pk, info.dlg, tablename=tableview['tbl'], tableview=tableview['view'], id_name=id_name, feature_id=feature_id, **kwargs))
        else:
            btn_add_dscenario = info.dlg.findChild(QPushButton, 'btn_add_dscenario')
            if btn_add_dscenario:
                tools_gw.add_icon(btn_add_dscenario, '111b', "24x24")
                btn_add_dscenario.clicked.connect(partial(add_row_epa, tbl, view, add_view, pk, info.dlg, add_dlg_title, **kwargs))
            btn_delete_dscenario = info.dlg.findChild(QPushButton, 'btn_delete_dscenario')
            if btn_delete_dscenario:
                tools_gw.add_icon(btn_delete_dscenario, '112b', "24x24")
                btn_delete_dscenario.clicked.connect(partial(delete_tbl_row, tbl, view, pk, info.dlg, **kwargs))

    info.dlg.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, info.dlg, True))
    info.dlg.finished.connect(partial(tools_gw.save_settings, info.dlg))
    # Open dlg
    tools_gw.open_dialog(info.dlg, dlg_name=ui_name)


def add_row_epa(tbl, view, tablename, pkey, dlg, dlg_title, **kwargs):

    # Get variables
    complet_result = kwargs['complet_result']
    info = kwargs['class']
    my_json = getattr(info, f"my_json_{view}")
    if my_json:
        message = "You are trying to add/remove a record from the table, with changes to the current records. If you continue, the changes will be discarded without saving. Do you want to continue?"
        answer = tools_qt.show_question(message, "Info Message", force_action=True)
        if not answer:
            return
    feature_id = complet_result['body']['feature']['id']
    id_name = complet_result['body']['feature']['idName']

    feature = f'"tableName":"{tablename}", "isEpa": true'
    body = tools_gw.create_body(feature=feature)
    json_result = tools_gw.execute_procedure('gw_fct_getinfofromid', body)
    if json_result is None or json_result['status'] == 'Failed':
        return
    result = json_result

    # Build dlg
    info.add_dlg = GwInfoGenericUi()
    tools_gw.load_settings(info.add_dlg)
    info.my_json_add = {}
    tools_gw.build_dialog_info(info.add_dlg, result, my_json=info.my_json_add)

    # Populate node_id/feature_id
    tools_qt.set_widget_text(info.add_dlg, f'tab_none_{info.feature_type}_id', feature_id)
    tools_qt.set_widget_text(info.add_dlg, 'tab_none_feature_id', feature_id)
    layout = info.add_dlg.findChild(QGridLayout, 'lyt_main_1')
    tools_qt.set_selected_item(info.add_dlg, 'tab_none_feature_type', f"{info.feature_type.upper()}")
    tools_qt.set_widget_enabled(info.add_dlg, 'tab_none_feature_type', False)

    cmb_nodarc_id = info.add_dlg.findChild(QComboBox, 'tab_none_nodarc_id')
    aux_view = view.replace("dscenario_", "")
    if cmb_nodarc_id:
        sql = (f"SELECT nodarc_id as id, nodarc_id as idval FROM {aux_view}"
               f" WHERE {info.feature_type}_id = '{feature_id}'")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(cmb_nodarc_id, rows)

    # Get every widget in the layout
    widgets = []
    for row in range(layout.rowCount()):
        for column in range(layout.columnCount()):
            item = layout.itemAtPosition(row, column)
            if item is not None:
                widget = item.widget()
                if widget is not None and type(widget) != QLabel:
                    widgets.append(widget)
    # Get all widget's values
    for widget in widgets:
        tools_gw.get_values(info.add_dlg, widget, info.my_json_add, ignore_editability=True)
    # Remove Nones from info.my_json_add
    keys_to_remove = []
    for key, value in info.my_json_add.items():
        if value is None:
            keys_to_remove.append(key)
    for key in keys_to_remove:
        del info.my_json_add[key]

    # Signals
    info.add_dlg.btn_close.clicked.connect(partial(tools_gw.close_dialog, info.add_dlg))
    info.add_dlg.dlg_closed.connect(partial(tools_gw.close_dialog, info.add_dlg))
    info.add_dlg.dlg_closed.connect(partial(refresh_epa_tbl, tbl, dlg, **kwargs))
    info.add_dlg.btn_accept.clicked.connect(partial(accept_add_dlg, info.add_dlg, tablename, pkey, feature_id, info.my_json_add, result, info))

    # Open dlg
    tools_gw.open_dialog(info.add_dlg, dlg_name='info_generic', title=dlg_title)


def refresh_epa_tbl(tblview, dlg, **kwargs):
    # Get variables
    complet_result = kwargs['complet_result']
    info = kwargs['class']
    func_params = kwargs['func_params']
    tableviews = func_params['tableviews']

    feature_id = complet_result['body']['feature']['id']
    id_name = complet_result['body']['feature']['idName']

    # Fill tableviews
    for tableview in tableviews:
        tbl = tableview['tbl']
        tbl = dlg.findChild(QTableView, tbl)
        if not tbl:
            continue    
        if tbl != tblview:
            continue
        id_name = tableview.get('id_name', id_name)
        if dlg == info.dlg_cf:
            view = tableview['tbl'].replace("tab_epa_", "")
        else:
            view = tableview['view']
        complet_list = get_list(view, id_name, feature_id)
        fill_tbl(complet_list, tbl, info, view)
        tools_gw.set_tablemodel_config(dlg, tbl, view, schema_name=info.schema_name, isQStandardItemModel=True)

def reload_tbl_dscenario (info, tablename, tableview, id_name, feature_id):

    tbl_name = tablename.replace ("tbl", "tbl_dscenario")
    view = tableview.replace("inp", "inp_dscenario")
    tbl = info.dlg.findChild(QTableView, tbl_name)

    if tbl is not None:
        complet_list = get_list(view, id_name, feature_id)
        fill_tbl(complet_list, tbl, info, view)


def delete_tbl_row(tbl, view, pkey, dlg, tablename=None, tableview=None, id_name=None, feature_id=None, **kwargs):
    # Get variables
    info = kwargs['class']

    my_json = getattr(info, f"my_json_{view}")
    if my_json:
        message = "You are trying to add/remove a record from the table, with changes to the current records. If you continue, the changes will be discarded without saving. Do you want to continue?"
        answer = tools_qt.show_question(message, "Info Message", force_action=True)
        if not answer:
            return

    # Get selected row
    selected_list = tbl.selectionModel().selectedRows()
    if len(selected_list) == 0:
        message = "Any record selected"
        tools_qgis.show_warning(message, dialog=dlg)
        return

    values = []
    if pkey:
        if not isinstance(pkey, list):
            pkey = [pkey]
        values = []
        for index in selected_list:
            value = {}
            for pk in pkey:
                col_idx = tools_qt.get_col_index_by_col_name(tbl, pk)
                if col_idx is None:
                    col_idx = 0
                value[pk] = index.sibling(index.row(), col_idx).data()
            if value:
                values.append(value)

    message = "Are you sure you want to delete these records?"
    answer = tools_qt.show_question(message, "Delete records", values, force_action=True)
    if answer:
        for value in values:
            conditions = []
            for key, val in value.items():
                condition = f"{key} = '{val}'"
                conditions.append(condition)
            condition_str = " AND ".join(conditions)
            sql = f"DELETE FROM {view} WHERE {condition_str}"
            tools_db.execute_sql(sql)
            try:
                info.dlg.btn_accept.setEnabled(True)
                info.inserted_feature = True
            except (AttributeError, RuntimeError):
                pass
        # Refresh tableview
        refresh_epa_tbl(tbl, dlg, **kwargs)
        if 'dscenario' not in view:
            reload_tbl_dscenario(info, tablename, tableview, id_name, feature_id)


def accept_add_dlg(dialog, tablename, pkey, feature_id, my_json, complet_result, info):

    if not my_json:
        return

    list_mandatory = []
    list_filter = []

    for field in complet_result['body']['data']['fields']:
        if field['ismandatory']:
            widget = dialog.findChild(QWidget, field['widgetname'])
            if not widget:
                continue
            widget.setStyleSheet(None)
            value = tools_qt.get_text(dialog, widget)
            if value in ('null', None, ''):
                widget.setStyleSheet("border: 1px solid red")
                list_mandatory.append(field['widgetname'])
            else:
                elem = [field['columnname'], value]
                list_filter.append(elem)

    if list_mandatory:
        msg = "Some mandatory values are missing. Please check the widgets marked in red."
        tools_qgis.show_warning(msg, dialog=dialog)
        tools_qt.set_action_checked("actionEdit", True, dialog)
        QgsProject.instance().blockSignals(False)
        return False

    fields = json.dumps(my_json)
    id_val = ""
    if pkey:
        if not isinstance(pkey, list):
            pkey = [pkey]
        for pk in pkey:
            widget_name = f"tab_none_{pk}"
            value = tools_qt.get_widget_value(dialog, widget_name)
            id_val += f"{value}, "
        id_val = id_val[:-2]
    if id_val in (None, '', 'None'):
        id_val = feature_id

    feature = f'"id":"{id_val}", '
    feature += f'"tableName":"{tablename}"'
    extras = f'"fields":{fields}, "force_action":"INSERT"'
    body = tools_gw.create_body(feature=feature, extras=extras)
    json_result = tools_gw.execute_procedure('gw_fct_upsertfields', body)
    if json_result and json_result.get('status') == 'Accepted':
        tools_gw.close_dialog(dialog)
        try:
            info.dlg.btn_accept.setEnabled(True)
            info.inserted_feature = True
        except (AttributeError, RuntimeError):
            pass
        return

    tools_qgis.show_warning('Error', parameter=json_result, dialog=dialog)


def widget_data_changed(info, view, tbl, model, addparam, value):

    # Get view pk
    ids = f''
    if addparam:
        for pk in addparam.split(','):
            col = tools_qt.get_col_index_by_col_name(tbl, pk.strip())
            if col is not False:
                ids += f"{model.index(index.row(), col).data()}, "
        ids = ids.strip(', ')
    else:
        ids = f"{model.index(index.row(), 0).data()}"

    if ids not in getattr(info, f"my_json_{view}"):
        getattr(info, f"my_json_{view}")[ids] = {}

    # Get edited cell
    fieldname = model.headerData(index.column(), Qt.Horizontal)
    field = index.data()

    # Fill my_json
    if str(field) == '' or field is None:
        getattr(info, f"my_json_{view}")[ids][fieldname] = None
    else:
        getattr(info, f"my_json_{view}")[ids][fieldname] = str(field)

    # Enable btn_accept
    try:
        info.dlg.btn_accept.setEnabled(True)
    except (AttributeError, RuntimeError):
        pass


def tbl_data_changed(info, view, tbl, model, addparam, index):

    # Get view pk
    ids = f''
    if addparam:
        for pk in addparam.split(','):
            col = tools_qt.get_col_index_by_col_name(tbl, pk.strip())
            if col is not False:
                ids += f"{model.index(index.row(), col).data()}, "
        ids = ids.strip(', ')
    else:
        ids = f"{model.index(index.row(), 0).data()}"

    if ids not in getattr(info, f"my_json_{view}"):
        getattr(info, f"my_json_{view}")[ids] = {}

    # Get edited cell
    fieldname = model.headerData(index.column(), Qt.Horizontal)
    field = index.data()

    # Fill my_json
    if str(field) == '' or field is None:
        getattr(info, f"my_json_{view}")[ids][fieldname] = None
    else:
        getattr(info, f"my_json_{view}")[ids][fieldname] = str(field)

    # Enable btn_accept
    try:
        info.dlg.btn_accept.setEnabled(True)
    except (AttributeError, RuntimeError):
        pass


def save_tbl_changes(table_name, info, dialog, pk):

    my_json = getattr(info, f"my_json_{table_name}")
    list_rows = []
    status = True
    if info.inserted_feature and not my_json:
        info.inserted_feature = False
        tools_gw.close_dialog(dialog)
        return
    elif not my_json:
        return

    # For each edited row
    for k, v in my_json.items():

        fields = json.dumps(v)
        if not fields:
            continue
        feature = f'"id":"{k}"'
        if pk and type(pk) != list and ',' not in pk:
            feature += f', "idName":"{pk}"'
        feature += f', "tableName":"{table_name}"'
        extras = f'"fields":{fields}, "force_action":"UPDATE"'
        body = tools_gw.create_body(feature=feature, extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_upsertfields', body)
        if json_result and json_result.get('status') != 'Accepted':
            status = False
            list_rows.append(k)
    if status:
        tools_gw.close_dialog(dialog)
    else:
        tools_qgis.show_warning('There are some error in the records with id: ', parameter=list_rows, dialog=dialog)


def save_widgets_changes(table_name, info, dialog, pk):
    my_json = getattr(info, f"my_json_{table_name}")
    status = True
    if info.inserted_feature and not my_json:
        info.inserted_feature = False
        tools_gw.close_dialog(dialog)
        return
    elif not my_json:
        return

    fields = json.dumps(my_json)
    if not fields:
        return
    id_ = tools_qt.get_text(dialog, pk)
    feature = f'"id":"{id_}"'
    if pk and type(pk) != list:
        feature += f', "idName":"{pk}"'
    feature += f', "tableName":"{table_name}"'
    extras = f'"fields":{fields}, "force_action":"UPDATE"'
    body = tools_gw.create_body(feature=feature, extras=extras)
    json_result = tools_gw.execute_procedure('gw_fct_upsertfields', body)
    if json_result and json_result.get('status') != 'Accepted':
        status = False

    if status:
        tools_gw.close_dialog(dialog)
    else:
        tools_qgis.show_warning('There are some error in the records with id: ', parameter=id_, dialog=dialog)


def _manage_accept_btn(info, tablename):
    my_json = getattr(info, f"my_json_{tablename}")
    if not my_json:
        return
    try:
        info.dlg.btn_accept.setEnabled(True)
    except (AttributeError, RuntimeError):
        pass


def add_to_dscenario(**kwargs):

    func_params = kwargs['func_params']
    dialog = kwargs['dialog']
    info = kwargs['class']
    tbl = tools_qt.get_widget(dialog, func_params.get('targetwidget'))
    tablename = func_params.get('tablename')
    dlg_title = func_params.get('add_dlg_title')
    pkey = func_params.get('pkey')
    if dlg_title:
        dlg_title = f"{dlg_title} - Dscenario"
    else:
        dlg_title = f"{tablename} - Dscenario"

    my_json = getattr(info, f"my_json_{tablename}")
    if my_json:
        message = "You are trying to add/remove a record from the table, with changes to the current records. If you continue, the changes will be discarded without saving. Do you want to continue?"
        answer = tools_qt.show_question(message, "Info Message", force_action=True)
        if not answer:
            return

    setattr(info, f"my_json_{tablename}", {})

    add_row_epa(tbl, tablename, tablename, pkey, dialog, dlg_title, **kwargs)


def remove_from_dscenario(**kwargs):
    func_params = kwargs['func_params']
    dialog = kwargs['dialog']
    info = kwargs['class']
    tbl = tools_qt.get_widget(dialog, func_params.get('targetwidget'))
    tablename = func_params.get('tablename')
    pkey = func_params.get('pkey')

    my_json = getattr(info, f"my_json_{tablename}")
    if my_json:
        message = "You are trying to add/remove a record from the table, with changes to the current records. If you continue, the changes will be discarded without saving. Do you want to continue?"
        answer = tools_qt.show_question(message, "Info Message", force_action=True)
        if not answer:
            return

    setattr(info, f"my_json_{tablename}", {})

    delete_tbl_row(tbl, tablename, pkey, dialog, **kwargs)

# endregion

# region Tab element


def open_selected_element(**kwargs):
    """
    Open form of selected element of the @qtable??
        function called in module tools_gw: def add_tableview(complet_result, field, module=sys.modules[__name__])
        at lines:   widget.doubleClicked.connect(partial(getattr(module, function_name), **kwargs))
    """
    func_params = kwargs['func_params']
    qtable = kwargs['qtable'] if 'qtable' in kwargs else tools_qt.get_widget(kwargs['dialog'], f"{func_params['targetwidget']}")
    # Get selected rows
    selected_list = qtable.selectionModel().selectedRows()
    if len(selected_list) == 0:
        message = "Any record selected"
        tools_qgis.show_warning(message)
        return

    index = selected_list[0]
    row = index.row()
    column_index = tools_qt.get_col_index_by_col_name(qtable, func_params['columnfind'])
    element_id = index.sibling(row, column_index).data()

    # Open selected element
    manage_element(element_id,  **kwargs)


def manage_element(element_id, **kwargs):

    """ Function called in class tools_gw.add_button(...) -->
            widget.clicked.connect(partial(getattr(self, function_name), **kwargs)) """

    feature = None
    complet_result = kwargs['complet_result']
    feature_type = complet_result['body']['feature']['featureType']
    feature_id = complet_result['body']['feature']['id']
    field_id = str(complet_result['body']['feature']['idName'])
    table_parent = str(complet_result['body']['feature']['tableParent'])
    schema_name = str(complet_result['body']['feature']['schemaName'])

    # When click button 'new_element' element id is the signal emited by the button
    if element_id is False:
        layer = tools_qgis.get_layer_by_tablename(table_parent, False, False, schema_name)
        if layer:
            expr_filter = f"{field_id} = '{feature_id}'"
            feature = tools_qgis.get_feature_by_expr(layer, expr_filter)

    elem = GwElement()
    elem.get_element(True, feature, feature_type)

    # If element exist
    if element_id:
        tools_qt.set_widget_text(elem.dlg_add_element, "element_id", element_id)
        elem.dlg_add_element.btn_accept.clicked.connect(partial(_reload_table, **kwargs))
    # If we are creating a new element
    else:
        elem.dlg_add_element.btn_accept.clicked.connect(partial(_manage_element_new, elem, **kwargs))


def _manage_element_new(elem, **kwargs):
    """ Get inserted element_id and add it to current feature """
    if elem.element_id is None:
        return

    dialog = kwargs['dialog']
    func_params = kwargs['func_params']
    tools_qt.set_widget_text(dialog, f"{func_params['sourcewidget']}", elem.element_id)
    tools_backend_calls.add_object(**kwargs)


def _reload_table(**kwargs):
    """ Get inserted element_id and add it to current feature """
    dialog = kwargs['dialog']
    index_tab = dialog.tab_main.currentIndex()
    tab_name = dialog.tab_main.widget(index_tab).objectName()

    list_tables = dialog.tab_main.widget(index_tab).findChildren(QTableView)
    complet_result = kwargs['complet_result']
    feature_id = complet_result['body']['feature']['id']
    field_id = str(complet_result['body']['feature']['idName'])
    widget_list = []
    widget_list.extend(dialog.tab_main.widget(index_tab).findChildren(QComboBox, QRegExp(f"{tab_name}_")))
    widget_list.extend(dialog.tab_main.widget(index_tab).findChildren(QTableView, QRegExp(f"{tab_name}_")))
    widget_list.extend(dialog.tab_main.widget(index_tab).findChildren(QLineEdit, QRegExp(f"{tab_name}_")))

    for table in list_tables:
        widgetname = table.objectName()
        columnname = table.property('columnname')
        if columnname is None:
            msg = f"widget {widgetname} in tab {dialog.tab_main.widget(index_tab).objectName()} has not columnname and can't be configured"
            tools_qgis.show_info(msg, 1)
            continue

        # Get value from filter widgets
        filter_fields = tools_backend_calls.get_filter_qtableview(dialog, widget_list, kwargs['complet_result'])

        # if tab dont have any filter widget
        if filter_fields in ('', None):
            filter_fields = f'"{field_id}":{{"value":"{feature_id}","filterSign":"="}}'

        linkedobject = table.property('linkedobject')
        complet_list, widget_list = tools_backend_calls.fill_tbl(complet_result, dialog, widgetname, linkedobject, filter_fields)
        if complet_list is False:
            return False

# endregion

# region Tab relation


def open_selected_feature(**kwargs):
    """
    Open selected feature from @qtable
        function called in -> def add_tableview(complet_result, field, dialog, module=sys.modules[__name__])
        at line: widget.doubleClicked.connect(partial(getattr(module, function_name), **kwargs))
    """
    qtable = kwargs['qtable']
    complet_list = kwargs['complet_result']
    func_params = kwargs['func_params']

    # Get selected rows
    selected_list = qtable.selectionModel().selectedRows()
    if len(selected_list) == 0:
        message = "Any record selected"
        tools_qgis.show_warning(message)
        return

    index = selected_list[0]
    row = index.row()
    column_index = tools_qt.get_col_index_by_col_name(qtable, func_params['columnfind'])
    feature_id = index.sibling(row, column_index).data()
    table_name = complet_list['body']['feature']['tableName']
    if 'tablefind' in func_params:
        column_index = tools_qt.get_col_index_by_col_name(qtable, func_params['tablefind'])
        table_name = index.sibling(row, column_index).data()
    info_feature = GwInfo('tab_data')
    complet_result, dialog = info_feature.open_form(table_name=table_name, feature_id=feature_id, tab_type='tab_data')
    if not complet_result:
        tools_log.log_info("FAIL open_selected_feature")
        return

# endregion

# region Tab hydrometer


def open_selected_hydro(**kwargs):
    qtable = kwargs['qtable']

    selected_list = qtable.selectionModel().selectedRows()
    if len(selected_list) == 0:
        message = "Any record selected"
        tools_qgis.show_warning(message)
        return

    index = selected_list[0]
    row = index.row()

    table_name = 'v_ui_hydrometer'
    column_index = tools_qt.get_col_index_by_col_name(qtable, 'hydrometer_id')
    feature_id = index.sibling(row, column_index).data()

    # return
    info_feature = GwInfo('tab_data')
    complet_result, dialog = info_feature.open_form(table_name=table_name, feature_id=feature_id,
                                                    tab_type='tab_data')
    if not complet_result:
        tools_log.log_info("FAIL open_selected_hydro")
        return


def open_hydro_url(**kwargs):
    func_params = kwargs['func_params']
    targetwidget = func_params['targetwidget']
    tbl_hydrometer = tools_qt.get_widget(kwargs['dialog'], f"{targetwidget}")

    selected_list = tbl_hydrometer.selectionModel().selectedRows()
    if len(selected_list) == 0:
        message = "Any record selected"
        tools_qgis.show_warning(message)
        return

    row = selected_list[0].row()
    url = tbl_hydrometer.model().record(row).value("hydrometer_link")
    if url != '':
        status, message = tools_os.open_file(url)
        if status is False and message is not None:
            tools_qgis.show_warning(message, parameter=url)

# endregion

# region Tab visit


def open_visit_files(**kwargs):
    func_params = kwargs['func_params']
    qtable = tools_qt.get_widget(kwargs['dialog'], f"{func_params.get('targetwidget')}")

    # Get selected row
    selected_list = qtable.selectionModel().selectedRows()
    message = "Any record selected"
    if not selected_list:
        tools_qgis.show_warning(message)
        return
    selected_row = selected_list[0].row()
    if not selected_row:
        tools_qgis.show_warning(message)
        return
    visit_id = qtable.model().record(selected_row).value("visit_id")

    sql = (f"SELECT value FROM om_visit_event_photo"
           f" WHERE visit_id = '{visit_id}'")
    rows = tools_db.get_rows(sql)
    for path in rows:
        # Open selected document
        status, message = tools_os.open_file(path[0])
        if status is False and message is not None:
            tools_qgis.show_warning(message, parameter=path[0])

# endregion

# region Tab event


def new_visit(**kwargs):
    """ Call button 64: om_add_visit """

    dlg_cf = kwargs['dialog']
    feature_type = kwargs['complet_result']['body']['feature']['childType']
    feature_id = kwargs['complet_result']['body']['feature']['id']
    # Get expl_id to save it on om_visit and show the geometry of visit
    expl_id = tools_qt.get_combo_value(dlg_cf, 'tab_data_expl_id', 0)
    if expl_id == -1:
        msg = "Widget expl_id not found"
        tools_qgis.show_warning(msg)
        return

    date_event_from = dlg_cf.findChild(QDateEdit, "date_event_from")
    date_event_to = dlg_cf.findChild(QDateEdit, "date_event_to")
    tbl_event_cf = dlg_cf.findChild(QTableView, "tbl_event_cf")
    manage_visit = GwVisit()
    manage_visit.visit_added.connect(partial(_update_visit_table, feature_type, date_event_from, date_event_to, tbl_event_cf))
    # TODO: the following query fix a (for me) misterious bug
    # the DB connection is not available during manage_visit.manage_visit first call
    # so the workaroud is to do a unuseful query to have the dao active
    sql = "SELECT id FROM om_visit LIMIT 1;"
    tools_db.get_rows(sql)
    manage_visit.get_visit(feature_type=feature_type, feature_id=feature_id, expl_id=expl_id,
                           is_new_from_cf=True)


def _update_visit_table(feature_type, date_event_from, date_event_to, tbl_event_cf):
    """ Convenience fuction set as slot to update table after a Visit GUI close. """
    table_name = "v_ui_event_x_" + feature_type
    tools_gw.set_dates_from_to(date_event_from, date_event_to, table_name, 'visit_start', 'visit_end')
    tbl_event_cf.model().select()


def open_visit_document(**kwargs):
    """ Open document of selected record of the table """

    # search visit_id in table (targetwidget, columnfind)
    func_params = kwargs['func_params']
    qtable = kwargs['qtable'] if 'qtable' in kwargs else tools_qt.get_widget(kwargs['dialog'], f"{func_params.get('targetwidget')}")
    # Get selected rows
    selected_list = qtable.selectionModel().selectedRows()
    if len(selected_list) == 0:
        message = "Any record selected"
        tools_qgis.show_warning(message)
        return

    index = selected_list[0]
    row = index.row()
    column_index = tools_qt.get_col_index_by_col_name(qtable, func_params['columnfind'])
    visit_id = index.sibling(row, column_index).data()

    # Get all documents for one visit
    sql = (f"SELECT doc_id FROM doc_x_visit"
           f" WHERE visit_id = '{visit_id}'")
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
                tools_qgis.show_warning(message, parameter=path)
            else:
                status, message = tools_os.open_file(path)
                if status is False and message is not None:
                    tools_qgis.show_warning(message, parameter=path)

    else:
        # If more then one document is attached open dialog with list of documents
        dlg_load_doc = GwVisitDocumentUi()
        tools_gw.load_settings(dlg_load_doc)
        dlg_load_doc.rejected.connect(partial(tools_gw.close_dialog, dlg_load_doc))

        btn_open_doc = dlg_load_doc.findChild(QPushButton, "btn_open")
        tbl_list_doc = dlg_load_doc.findChild(QListWidget, "tbl_list_doc")
        lbl_visit_id = dlg_load_doc.findChild(QLineEdit, "visit_id")

        lbl_visit_id.setText(str(visit_id))
        btn_open_doc.clicked.connect(partial(open_selected_doc, tbl_list_doc))
        tbl_list_doc.itemDoubleClicked.connect(partial(open_selected_doc, tbl_list_doc))
        for row in rows:
            item_doc = QListWidgetItem(str(row[0]))
            tbl_list_doc.addItem(item_doc)

        tools_gw.open_dialog(dlg_load_doc, dlg_name='visit_document')


def open_selected_doc(tbl_list_doc):

    # Selected item from list
    if tbl_list_doc.currentItem() is None:
        msg = "No document selected."
        tools_qgis.show_message(msg, 1)
        return

    selected_document = tbl_list_doc.currentItem().text()

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


def open_gallery(**kwargs):
    """ Open gallery of selected record of the table """

    dialog = kwargs['dialog']
    func_params = kwargs['func_params']
    qtable = kwargs['qtable'] if 'qtable' in kwargs else tools_qt.get_widget(dialog, f"{func_params.get('targetwidget')}")

    # Get selected rows
    selected_list = qtable.selectionModel().selectedRows()
    if len(selected_list) == 0:
        message = "Any record selected"
        tools_qgis.show_warning(message)
        return

    index = selected_list[0]
    row = index.row()
    ids = {}
    i = 0
    for col in func_params['columnfind']:
        column_index = tools_qt.get_col_index_by_col_name(qtable, func_params['columnfind'][i])
        ids[col] = index.sibling(row, column_index).data()
        i += 1
    visit_id = ids['visit_id']
    event_id = ids['event_id']

    # Open Gallery
    gal = GwVisitGallery()
    gal.manage_gallery()
    gal.fill_gallery(visit_id, event_id)


def open_visit_event(**kwargs):
    """
    Open event of selected record of the table
        Function called in:
            def add_button(**kwargs) -> widget.clicked.connect(partial(getattr(module, function_name), **kwargs))
            def add_tableview(complet_result, field, dialog, module=sys.modules[__name__]) ->
                                        widget.doubleClicked.connect(partial(getattr(module, function_name), **kwargs))
    """

    dialog = kwargs['dialog']
    func_params = kwargs['func_params']
    qtable = kwargs['qtable'] if 'qtable' in kwargs else tools_qt.get_widget(dialog, f"{func_params.get('targetwidget')}")
    complet_result = kwargs['complet_result']

    # Get selected rows
    selected_list = qtable.selectionModel().selectedRows()
    if len(selected_list) == 0:
        message = "Any record selected"
        tools_qgis.show_warning(message)
        return

    index = selected_list[0]
    row = index.row()
    ids = {}
    i = 0
    for col in func_params['columnfind']:
        column_index = tools_qt.get_col_index_by_col_name(qtable, func_params['columnfind'][i])
        ids[col] = index.sibling(row, column_index).data()
        i += 1
    visit_id = ids['visit_id']
    event_id = ids['event_id']

    # Open dialog event_standard
    dlg_event_full = GwVisitEventFullUi()
    tools_gw.load_settings(dlg_event_full)
    dlg_event_full.rejected.connect(partial(tools_gw.close_dialog, dlg_event_full))
    # Get all data for one visit
    sql = (f"SELECT * FROM om_visit_event"
           f" WHERE id = '{event_id}' AND visit_id = '{visit_id}';")
    row = tools_db.get_row(sql)
    if not row:
        return

    tools_qt.set_widget_text(dlg_event_full, dlg_event_full.id, row['id'])
    tools_qt.set_widget_text(dlg_event_full, dlg_event_full.event_code, row['event_code'])
    tools_qt.set_widget_text(dlg_event_full, dlg_event_full.visit_id, row['visit_id'])
    tools_qt.set_widget_text(dlg_event_full, dlg_event_full.position_id, row['position_id'])
    tools_qt.set_widget_text(dlg_event_full, dlg_event_full.position_value, row['position_value'])
    tools_qt.set_widget_text(dlg_event_full, dlg_event_full.parameter_id, row['parameter_id'])
    tools_qt.set_widget_text(dlg_event_full, dlg_event_full.value, row['value'])
    tools_qt.set_widget_text(dlg_event_full, dlg_event_full.value1, row['value1'])
    tools_qt.set_widget_text(dlg_event_full, dlg_event_full.value2, row['value2'])
    tools_qt.set_widget_text(dlg_event_full, dlg_event_full.geom1, row['geom1'])
    tools_qt.set_widget_text(dlg_event_full, dlg_event_full.geom2, row['geom2'])
    tools_qt.set_widget_text(dlg_event_full, dlg_event_full.geom3, row['geom3'])
    tools_qt.set_widget_text(dlg_event_full, dlg_event_full.xcoord, row['xcoord'])
    tools_qt.set_widget_text(dlg_event_full, dlg_event_full.ycoord, row['ycoord'])
    tools_qt.set_widget_text(dlg_event_full, dlg_event_full.compass, row['compass'])
    tools_qt.set_widget_text(dlg_event_full, dlg_event_full.tstamp, row['tstamp'])
    tools_qt.set_widget_text(dlg_event_full, dlg_event_full.text, row['text'])
    tools_qt.set_widget_text(dlg_event_full, dlg_event_full.index_val, row['index_val'])
    tools_qt.set_widget_text(dlg_event_full, dlg_event_full.is_last, row['is_last'])
    _populate_tbl_docs_x_event(dlg_event_full, visit_id, event_id)

    # Set all QLineEdit readOnly(True)

    widget_list = dlg_event_full.findChildren(QTextEdit)
    aux = dlg_event_full.findChildren(QLineEdit)
    for w in aux:
        widget_list.append(w)
    for widget in widget_list:
        widget.setReadOnly(True)
        widget.setStyleSheet("QWidget { background: rgb(242, 242, 242);"
                             " color: rgb(100, 100, 100)}")
    dlg_event_full.btn_close.clicked.connect(partial(tools_gw.close_dialog, dlg_event_full))
    dlg_event_full.tbl_docs_x_event.doubleClicked.connect(partial(_open_file, dlg_event_full))
    tools_qt.set_tableview_config(dlg_event_full.tbl_docs_x_event)
    tools_gw.open_dialog(dlg_event_full, 'visit_event_full')


def _populate_tbl_docs_x_event(dlg_event_full, visit_id, event_id):

    # Create and set model
    model = QStandardItemModel()
    dlg_event_full.tbl_docs_x_event.setModel(model)
    dlg_event_full.tbl_docs_x_event.horizontalHeader().setStretchLastSection(True)
    dlg_event_full.tbl_docs_x_event.horizontalHeader().setSectionResizeMode(3)
    # Get columns name and set headers of model with that
    columns_name = tools_db.get_columns_list('om_visit_event_photo')
    headers = []
    for x in columns_name:
        headers.append(x[0])
    headers = ['value', 'filetype', 'fextension']
    model.setHorizontalHeaderLabels(headers)

    # Get values in order to populate model
    sql = (f"SELECT value, filetype, fextension FROM om_visit_event_photo "
           f"WHERE visit_id='{visit_id}' AND event_id='{event_id}'")
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


def _open_file(dlg_event_full):

    # Get row index
    index = dlg_event_full.tbl_docs_x_event.selectionModel().selectedRows()[0]
    column_index = tools_qt.get_col_index_by_col_name(dlg_event_full.tbl_docs_x_event, 'value')
    path = index.sibling(index.row(), column_index).data()
    status, message = tools_os.open_file(path)
    if status is False and message is not None:
        tools_qgis.show_warning(message, parameter=path)

# endregion

# endregion
