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
import subprocess
import sys
import urllib.parse as parse
import webbrowser
from collections import OrderedDict
from functools import partial
from sip import isdeleted

from qgis.PyQt.QtCore import pyqtSignal, QDate, QObject, QRegExp, QStringListModel, Qt, QSettings
from qgis.PyQt.QtGui import QColor, QRegExpValidator, QStandardItem, QStandardItemModel
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QAction, QAbstractItemView, QCheckBox, QComboBox, QCompleter, QDoubleSpinBox, \
    QDateEdit, QGridLayout, QLabel, QLineEdit, QListWidget, QListWidgetItem, QPushButton, QSizePolicy, \
    QSpinBox, QSpacerItem, QTableView, QTabWidget, QWidget, QTextEdit
from qgis.core import QgsMapToPixel, QgsVectorLayer, QgsExpression, QgsFeatureRequest, QgsPointXY
from qgis.gui import QgsDateTimeEdit, QgsVertexMarker, QgsMapToolEmitPoint, QgsRubberBand

from .catalog import GwCatalog
from .dimensioning import GwDimensioning
from .document import GwDocument
from .element import GwElement
from .visit_gallery import GwVisitGallery
from .visit_manager import GwVisitManager
from ..utils import tools_gw
from ..utils.snap_manager import GwSnapManager
from ..ui.ui_manager import GwInfoGenericUi, GwInfoFeatureUi, GwVisitEventFullUi, GwMainWindowDialog, GwVisitDocumentUi, GwInfoCrossectUi, \
    GwDialogTextUi
from ... import global_vars
from ...lib import tools_qgis, tools_qt, tools_log, tools_db

global is_inserting
is_inserting = False


class GwInfo(QObject):

    # :var signal_activate: emitted from def cancel_snapping_tool(self, dialog, action) in order to re-start CadInfo
    signal_activate = pyqtSignal()

    def __init__(self, tab_type):
        """ Class constructor """

        super().__init__()

        self.iface = global_vars.iface
        self.settings = global_vars.settings
        self.plugin_dir = global_vars.plugin_dir
        self.canvas = global_vars.canvas
        self.schema_name = global_vars.schema_name

        self.new_feature_id = None
        self.layer_new_feature = None
        self.tab_type = tab_type
        self.connected = False
        self.rubber_band = QgsRubberBand(self.canvas, 0)
        self.snapper_manager = GwSnapManager(self.iface)
        self.snapper_manager.set_snapping_layers()
        self.suppres_form = None


    def get_info_from_coordinates(self, point, tab_type):
        return self.open_form(point=point, tab_type=tab_type)


    def get_info_from_id(self, table_name, feature_id, tab_type=None, is_add_schema=None):
        return self.open_form(table_name=table_name, feature_id=feature_id, tab_type=tab_type, is_add_schema=is_add_schema)


    def get_feature_insert(self, point, feature_cat, new_feature_id, layer_new_feature, tab_type, new_feature):
        return self.open_form(point=point, feature_cat=feature_cat, new_feature_id=new_feature_id,
                              layer_new_feature=layer_new_feature, tab_type=tab_type, new_feature=new_feature)


    def open_form(self, point=None, table_name=None, feature_id=None, feature_cat=None, new_feature_id=None,
                  layer_new_feature=None, tab_type=None, new_feature=None, is_docker=True, is_add_schema=False):
        """
        :param point: point where use clicked
        :param table_name: table where do sql query
        :param feature_id: id of feature to do info
        :return:
        """

        # Manage tab signal
        self.tab_element_loaded = False
        self.tab_relations_loaded = False
        self.tab_connections_loaded = False
        self.tab_hydrometer_loaded = False
        self.tab_hydrometer_val_loaded = False
        self.tab_om_loaded = False
        self.tab_document_loaded = False
        self.tab_rpt_loaded = False
        self.tab_plan_loaded = False
        self.dlg_is_destroyed = False
        self.layer = None
        self.feature = None
        self.my_json = {}
        self.tab_type = tab_type

        # Get project variables
        project_vars = global_vars.project_vars
        qgis_project_add_schema = project_vars['add_schema']
        qgis_project_main_schema = project_vars['main_schema']
        qgis_project_infotype = project_vars['infotype']
        qgis_project_role = project_vars['role']

        self.new_feature = new_feature

        if self.iface.activeLayer() is None or type(self.iface.activeLayer()) != QgsVectorLayer:
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

        extras += f', "rolePermissions":"{qgis_project_infotype}"'

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
            visible_layer = tools_qgis.get_visible_layers(as_list=True)
            scale_zoom = self.iface.mapCanvas().scale()
            extras += f', "activeLayer":"{active_layer}"'
            extras += f', "visibleLayer":{visible_layer}'
            extras += f', "mainSchema":"{qgis_project_main_schema}"'
            extras += f', "addSchema":"{qgis_project_add_schema}"'
            extras += f', "infoType":"{qgis_project_infotype}"'
            extras += f', "projecRole":"{qgis_project_role}"'
            extras += f', "coordinates":{{"xcoord":{point.x()},"ycoord":{point.y()}, "zoomRatio":{scale_zoom}}}'
            body = tools_gw.create_body(extras=extras)
            function_name = 'gw_fct_getinfofromcoordinates'

        # Comes from QPushButtons node1 or node2 from custom form or RightButton
        elif feature_id:
            if is_add_schema is True:
                project_vars = global_vars.project_vars
                add_schema = project_vars['add_schema']
                extras = f'"addSchema":"{add_schema}"'
            else:
                extras = '"addSchema":""'
            feature = f'"tableName":"{table_name}", "id":"{feature_id}"'
            body = tools_gw.create_body(feature=feature, extras=extras)
            function_name = 'gw_fct_getinfofromid'

        if function_name is None:
            return False, None

        json_result = tools_gw.get_json(function_name, body, rubber_band=self.rubber_band, log_sql=False)
        if json_result is None:
            return False, None

        if json_result in (None, False):
            return False, None

        # When insert feature failed
        if 'status' in json_result and json_result['status'] == 'Failed':
            return False, None

        # When something is wrong
        if 'message' in json_result and json_result['message']:
            level = 1
            if 'level' in json_result['message']:
                level = int(json_result['message']['level'])
            tools_qgis.show_message(json_result['message']['text'], level)
            return False, None

        # Control fail when insert new feature
        if 'status' in json_result['body']['data']['fields']:
            if json_result['body']['data']['fields']['status'].lower() == 'failed':
                msg = json_result['body']['data']['fields']['message']['text']
                level = 1
                if 'level' in json_result['body']['data']['fields']['message']:
                    level = int(json_result['body']['data']['fields']['message']['level'])
                tools_qgis.show_message(msg, message_level=level)
                return False, None

        self.complet_result = json_result
        try:
            template = self.complet_result['body']['form']['template']
        except Exception as e:
            tools_log.log_info(str(e))
            return False, None

        if template == 'info_generic':
            result, dialog = self.open_generic_form(self.complet_result)
            # Fill self.my_json for new qgis_feature
            if feature_cat is not None:
                self.manage_new_feature(self.complet_result, dialog)
            return result, dialog

        elif template == 'dimensioning':
            self.lyr_dim = tools_qgis.get_layer_by_tablename("v_edit_dimensions", show_warning_=True)
            if self.lyr_dim:
                self.dimensioning = GwDimensioning()
                feature_id = self.complet_result['body']['feature']['id']
                result, dialog = self.dimensioning.open_dimensioning_form(None, self.lyr_dim, self.complet_result, feature_id, self.rubber_band)
                return result, dialog

        elif template == 'info_feature':
            sub_tag = None
            if feature_cat:
                if feature_cat.feature_type.lower() == 'arc':
                    sub_tag = 'arc'
                else:
                    sub_tag = 'node'
            feature_id = self.complet_result['body']['feature']['id']
            result, dialog = self.open_custom_form(feature_id, self.complet_result, tab_type, sub_tag, is_docker, new_feature=new_feature)
            if feature_cat is not None:
                self.manage_new_feature(self.complet_result, dialog)
            return result, dialog

        elif template == 'visit':
            visit_id = self.complet_result['body']['feature']['id']
            manage_visit = GwVisitManager()
            manage_visit.get_visit(visit_id=visit_id, tag='info')

        else:
            tools_log.log_warning(f"template not managed: {template}")
            return False, None


    def get_layers_visibility(self):

        layers = tools_qgis.get_project_layers()
        layers_visibility = {}
        for layer in layers:

            layers_visibility[layer] = tools_qgis.is_layer_visible(layer)
        return layers_visibility


    def manage_new_feature(self, complet_result, dialog):

        result = complet_result['body']['data']
        for field in result['fields']:
            if 'hidden' in field and field['hidden']: continue
            if 'layoutname' in field and field['layoutname'] == 'lyt_none': continue
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
                    tools_qgis.show_message(msg)

            if str(value) not in ('', None, -1, "None") and widget.property('columnname'):
                self.my_json[str(widget.property('columnname'))] = str(value)

        tools_log.log_info(str(self.my_json))


    def open_generic_form(self, complet_result):

        tools_gw.draw_by_json(complet_result, self.rubber_band, zoom=False)
        self.hydro_info_dlg = GwInfoGenericUi()
        tools_gw.load_settings(self.hydro_info_dlg)
        self.hydro_info_dlg.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.hydro_info_dlg))
        self.hydro_info_dlg.rejected.connect(partial(tools_gw.close_dialog, self.hydro_info_dlg))
        field_id = str(self.complet_result['body']['feature']['idName'])
        result = tools_gw.build_dialog_info(self.hydro_info_dlg, complet_result, self.my_json)

        # Disable button accept for info on generic form
        self.hydro_info_dlg.btn_accept.setEnabled(False)
        self.hydro_info_dlg.rejected.connect(self.rubber_band.reset)
        # Open dialog
        tools_gw.open_dialog(self.hydro_info_dlg, dlg_name='info_generic')

        return result, self.hydro_info_dlg


    def open_custom_form(self, feature_id, complet_result, tab_type=None, sub_tag=None, is_docker=True, new_feature=None):

        # Dialog
        self.dlg_cf = GwInfoFeatureUi(sub_tag)
        tools_gw.load_settings(self.dlg_cf)

        # If in the get_json function we have received a rubberband, it is not necessary to redraw it.
        # But if it has not been received, it is drawn
        # Using variable exist_rb for check if alredy exist rubberband
        try:
            exist_rb = complet_result['body']['returnManager']['style']['ruberband']
        except KeyError:
            tools_gw.draw_by_json(complet_result, self.rubber_band)

        if feature_id:
            self.dlg_cf.setGeometry(self.dlg_cf.pos().x() + 25, self.dlg_cf.pos().y() + 25, self.dlg_cf.width(),
                                    self.dlg_cf.height())

        # Get widget controls
        self.tab_main = self.dlg_cf.findChild(QTabWidget, "tab_main")
        self.tab_main.currentChanged.connect(partial(self.tab_activation, self.dlg_cf, new_feature))
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
        tools_qt.set_tableview_config(self.tbl_hydrometer_value, QAbstractItemView.SelectItems, QTableView.CurrentChanged)
        self.tbl_event_cf = self.dlg_cf.findChild(QTableView, "tbl_event_cf")
        tools_qt.set_tableview_config(self.tbl_event_cf)
        self.tbl_document = self.dlg_cf.findChild(QTableView, "tbl_document")
        tools_qt.set_tableview_config(self.tbl_document)

        # Get table name
        self.tablename = complet_result['body']['feature']['tableName']

        # Get feature type (Junction, manhole, valve, fountain...)
        self.feature_type = complet_result['body']['feature']['childType']

        # Get tableParent and select layer
        self.table_parent = str(complet_result['body']['feature']['tableParent'])
        schema_name = str(complet_result['body']['feature']['schemaName'])
        self.layer = tools_qgis.get_layer_by_tablename(self.table_parent, False, False, schema_name)
        if self.layer is None:
            tools_qgis.show_message("Layer not found: " + self.table_parent, 2)
            return False, self.dlg_cf

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
            feature = tools_qt.get_feature_by_id(self.layer, self.feature_id, self.field_id)
            list_points = tools_qgis.get_points_from_geometry(self.layer, feature)

        if 'visibleTabs' in complet_result['body']['form']:
            for tab in complet_result['body']['form']['visibleTabs']:
                tabs_to_show.append(tab['tabName'])

        for x in range(self.tab_main.count() - 1, 0, -1):
            if self.tab_main.widget(x).objectName() not in tabs_to_show:
                tools_qt.remove_tab(self.tab_main, self.tab_main.widget(x).objectName())

        # Actions
        action_edit = self.dlg_cf.findChild(QAction, "actionEdit")
        action_copy_paste = self.dlg_cf.findChild(QAction, "actionCopyPaste")
        action_rotation = self.dlg_cf.findChild(QAction, "actionRotation")
        action_catalog = self.dlg_cf.findChild(QAction, "actionCatalog")
        action_workcat = self.dlg_cf.findChild(QAction, "actionWorkcat")
        action_mapzone = self.dlg_cf.findChild(QAction, "actionMapZone")
        action_set_to_arc = self.dlg_cf.findChild(QAction, "actionSetToArc")
        action_get_arc_id = self.dlg_cf.findChild(QAction, "actionGetArcId")
        action_get_parent_id = self.dlg_cf.findChild(QAction, "actionGetParentId")
        action_zoom_in = self.dlg_cf.findChild(QAction, "actionZoom")
        action_zoom_out = self.dlg_cf.findChild(QAction, "actionZoomOut")
        action_centered = self.dlg_cf.findChild(QAction, "actionCentered")
        action_link = self.dlg_cf.findChild(QAction, "actionLink")
        action_help = self.dlg_cf.findChild(QAction, "actionHelp")
        action_interpolate = self.dlg_cf.findChild(QAction, "actionInterpolate")
        # action_switch_arc_id = self.dlg_cf.findChild(QAction, "actionSwicthArcid")
        action_section = self.dlg_cf.findChild(QAction, "actionSection")

        if self.new_feature_id is not None:
            self.enable_action(self.dlg_cf, "actionZoom", False)
            self.enable_action(self.dlg_cf, "actionZoomOut", False)
            self.enable_action(self.dlg_cf, "actionCentered", False)
        self.show_actions(self.dlg_cf, 'tab_data')

        try:
            action_edit.setEnabled(self.complet_result['body']['feature']['permissions']['isEditable'])
        except KeyError:
            pass

        # Set actions icon
        tools_gw.add_icon(action_edit, "101")
        tools_gw.add_icon(action_copy_paste, "107b", "24x24")
        tools_gw.add_icon(action_rotation, "107c", "24x24")
        tools_gw.add_icon(action_catalog, "195")
        tools_gw.add_icon(action_workcat, "193")
        tools_gw.add_icon(action_mapzone, "213")
        tools_gw.add_icon(action_set_to_arc, "212")
        tools_gw.add_icon(action_get_arc_id, "209")
        tools_gw.add_icon(action_get_parent_id, "210")
        tools_gw.add_icon(action_zoom_in, "103")
        tools_gw.add_icon(action_zoom_out, "107")
        tools_gw.add_icon(action_centered, "104")
        tools_gw.add_icon(action_link, "173")
        tools_gw.add_icon(action_section, "207")
        tools_gw.add_icon(action_help, "73")
        tools_gw.add_icon(action_interpolate, "194")

        # Set buttons icon
        # tab elements
        tools_gw.add_icon(self.dlg_cf.btn_insert, "111b", "24x24")
        tools_gw.add_icon(self.dlg_cf.btn_delete, "112b", "24x24")
        tools_gw.add_icon(self.dlg_cf.btn_new_element, "131b", "24x24")
        tools_gw.add_icon(self.dlg_cf.btn_open_element, "134b", "24x24")
        # tab hydrometer
        tools_gw.add_icon(self.dlg_cf.btn_link, "70", "24x24")
        # tab om
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

        # Get feature type as geom_type (node, arc, connec, gully)
        self.geom_type = str(complet_result['body']['feature']['featureType'])
        if str(self.geom_type) in ('', '[]'):
            if 'feature_cat' in globals():
                parent_layer = self.feature_cat.parent_layer
            else:
                parent_layer = str(complet_result['body']['feature']['tableParent'])
            sql = f"SELECT lower(feature_type) FROM cat_feature WHERE parent_layer = '{parent_layer}' LIMIT 1"
            result = tools_db.get_row(sql)
            if result:
                self.geom_type = result[0]

        result = complet_result['body']['data']
        layout_list = []
        for field in complet_result['body']['data']['fields']:
            if 'hidden' in field and field['hidden']:
                continue
            label, widget = self.set_widgets(self.dlg_cf, complet_result, field, new_feature)
            if widget is None:
                continue
            layout = self.dlg_cf.findChild(QGridLayout, field['layoutname'])
            if layout is not None:
                # Take the QGridLayout with the intention of adding a QSpacerItem later
                if layout not in layout_list and layout.objectName() not in ('lyt_top_1', 'lyt_bot_1', 'lyt_bot_2'):
                    layout_list.append(layout)
                    # Add widgets into layout
                    layout.addWidget(label, 0, field['layoutorder'])
                    layout.addWidget(widget, 1, field['layoutorder'])
                if field['layoutname'] in ('lyt_top_1', 'lyt_bot_1', 'lyt_bot_2'):
                    layout.addWidget(label, 0, field['layoutorder'])
                    layout.addWidget(widget, 1, field['layoutorder'])
                else:
                    tools_gw.add_widget(self.dlg_cf, field, label, widget)

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
                            self.get_combo_child, self.dlg_cf, widget, self.feature_type, self.tablename, self.field_id))

        # Set variables
        self.filter = str(complet_result['body']['feature']['idName']) + " = '" + str(self.feature_id) + "'"
        dlg_cf = self.dlg_cf
        layer = self.layer
        fid = self.feature_id
        my_json = self.my_json
        if layer:
            if layer.isEditable():
                tools_gw.enable_all(dlg_cf, self.complet_result['body']['data'])
            else:
                tools_gw.disable_widgets(dlg_cf, self.complet_result['body']['data'], False)


        # We assign the function to a global variable,
        # since as it receives parameters we will not be able to disconnect the signals
        self.fct_block_action_edit = lambda: self.block_action_edit(dlg_cf, action_edit, result, layer, fid, my_json, new_feature)
        self.fct_start_editing = lambda: self.start_editing(dlg_cf, action_edit, complet_result['body']['data'], layer)
        self.fct_stop_editing = lambda: self.stop_editing(dlg_cf, action_edit, layer, fid, self.my_json, new_feature)
        self.connect_signals()

        self.enable_actions(dlg_cf, layer.isEditable())

        action_edit.setChecked(layer.isEditable())
        # Actions signals
        action_edit.triggered.connect(partial(self.manage_edition, dlg_cf, action_edit, fid, new_feature))
        action_catalog.triggered.connect(partial(self.open_catalog, tab_type, self.feature_type))
        action_workcat.triggered.connect(partial(self.get_catalog, 'new_workcat', self.tablename, self.feature_type, self.feature_id, self.field_id, list_points))
        action_mapzone.triggered.connect(partial(self.get_catalog, 'new_mapzone', self.tablename, self.feature_type, self.feature_id, self.field_id, list_points))
        action_set_to_arc.triggered.connect(partial(self.get_snapped_feature_id, dlg_cf, action_set_to_arc, 'v_edit_arc', 'set_to_arc', None))
        action_get_arc_id.triggered.connect(partial(self.get_snapped_feature_id, dlg_cf, action_get_arc_id,  'v_edit_arc', 'arc', 'data_arc_id'))
        action_get_parent_id.triggered.connect(partial(self.get_snapped_feature_id, dlg_cf, action_get_parent_id, 'v_edit_node', 'node', 'data_parent_id'))
        action_zoom_in.triggered.connect(partial(self.manage_action_zoom_in, self.canvas, self.layer))
        action_centered.triggered.connect(partial(self.manage_action_centered, self.canvas, self.layer))
        action_zoom_out.triggered.connect(partial(self.manage_action_zoom_out, self.canvas, self.layer))
        action_copy_paste.triggered.connect(partial(self.manage_action_copy_paste, self.dlg_cf, self.geom_type, tab_type))
        action_rotation.triggered.connect(partial(self.change_hemisphere, self.dlg_cf, action_rotation))
        action_link.triggered.connect(lambda: webbrowser.open('http://www.giswater.org'))
        action_section.triggered.connect(partial(self.open_section_form))
        action_help.triggered.connect(partial(self.open_help, self.geom_type))
        self.ep = QgsMapToolEmitPoint(self.canvas)
        action_interpolate.triggered.connect(partial(self.activate_snapping, complet_result, self.ep))

        btn_cancel = self.dlg_cf.findChild(QPushButton, 'btn_cancel')
        btn_accept = self.dlg_cf.findChild(QPushButton, 'btn_accept')
        title = f"{complet_result['body']['feature']['childType']} - {self.feature_id}"

        if global_vars.session_vars['dlg_docker'] and is_docker and global_vars.session_vars['show_docker']:
            # Delete last form from memory
            last_info = global_vars.session_vars['dlg_docker'].findChild(GwMainWindowDialog, 'dlg_info_feature')
            if last_info:
                last_info.setParent(None)
                del last_info

            tools_gw.docker_dialog(dlg_cf)
            global_vars.session_vars['dlg_docker'].dlg_closed.connect(self.manage_docker_close)
            global_vars.session_vars['dlg_docker'].setWindowTitle(title)
            btn_cancel.clicked.connect(self.manage_docker_close)

        else:
            dlg_cf.dlg_closed.connect(self.roll_back)
            dlg_cf.dlg_closed.connect(lambda: self.rubber_band.reset())
            dlg_cf.dlg_closed.connect(partial(tools_gw.save_settings, dlg_cf))
            dlg_cf.key_escape.connect(partial(tools_gw.close_dialog, dlg_cf))
            btn_cancel.clicked.connect(partial(self.manage_info_close, dlg_cf))
        btn_accept.clicked.connect(partial(self.accept_from_btn, dlg_cf, action_edit, new_feature, self.my_json))
        dlg_cf.key_enter.connect(partial(self.accept_from_btn, dlg_cf, action_edit, new_feature, self.my_json))

        # Set title
        toolbox_cf = self.dlg_cf.findChild(QWidget, 'toolBox')
        row = tools_gw.get_config_value('admin_customform_param', 'value', 'config_param_system')
        if row:
            results = json.loads(row[0], object_pairs_hook=OrderedDict)
            for result in results['custom_form_tab_labels']:
                toolbox_cf.setItemText(int(result['index']), result['text'])

        # Open dialog
        tools_gw.open_dialog(self.dlg_cf, dlg_name='info_feature')
        self.dlg_cf.setWindowTitle(title)

        return self.complet_result, self.dlg_cf


    def open_help(self, geom_type):
        """ Open PDF file with selected @project_type and @geom_type """

        # Get locale of QGIS application
        locale = QSettings().value('locale/userLocale').lower()
        if locale == 'es_es':
            locale = 'es'
        elif locale == 'es_ca':
            locale = 'ca'
        elif locale == 'en_us':
            locale = 'en'
        project_type = tools_gw.get_project_type()
        # Get PDF file
        pdf_folder = os.path.join(global_vars.plugin_dir, f'resources{os.sep}png')
        pdf_path = os.path.join(pdf_folder, f"{project_type}_{geom_type}_{locale}.png")

        # Open PDF if exists. If not open Spanish version
        if os.path.exists(pdf_path):
            os.system(pdf_path)
        else:
            locale = "es"
            pdf_path = os.path.join(pdf_folder, f"{project_type}_{geom_type}_{locale}.png")
            if os.path.exists(pdf_path):
                os.system(pdf_path)
            else:
                message = "File not found"
                tools_qgis.show_warning(message, parameter=pdf_path)


    def block_action_edit(self, dialog, action_edit, result, layer, fid, my_json, new_feature):

        if self.new_feature_id is not None:
            self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').blockSignals(True)
            save = self.stop_editing(dialog, action_edit, result, fid, my_json, new_feature)
            self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').blockSignals(False)
            if save and not self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').isChecked():
                self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').trigger()

        if self.connected is False:
            self.connect_signals()


    def connect_signals(self):
        if not self.connected:
            self.layer.editingStarted.connect(self.fct_start_editing)
            self.layer.editingStopped.connect(self.fct_stop_editing)
            self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').toggled.connect(self.fct_block_action_edit)
            self.connected = True


    def disconnect_signals(self):

        try:
            self.layer.editingStarted.disconnect(self.fct_start_editing)
        except Exception:
            pass

        try:
            self.layer.editingStopped.disconnect(self.fct_stop_editing)
        except Exception:
            pass

        try:
            self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').toggled.disconnect(self.fct_block_action_edit)
        except Exception:
            pass

        self.connected = False
        global is_inserting
        is_inserting = False


    def activate_snapping(self, complet_result, ep):

        rb_interpolate = []
        self.interpolate_result = None
        self.rubber_band.reset()
        dlg_dtext = GwDialogTextUi()
        tools_gw.load_settings(dlg_dtext)

        tools_qt.set_widget_text(dlg_dtext, dlg_dtext.txt_infolog, 'Interpolate tool')
        dlg_dtext.lbl_text.setText("Please, use the cursor to select two nodes to proceed with the "
                                   "interpolation\nNode1: \nNode2:")

        dlg_dtext.btn_accept.clicked.connect(partial(self.chek_for_existing_values, dlg_dtext))
        dlg_dtext.btn_close.clicked.connect(partial(tools_gw.close_dialog, dlg_dtext))
        dlg_dtext.rejected.connect(partial(tools_gw.save_settings, dlg_dtext))
        dlg_dtext.rejected.connect(partial(self.remove_interpolate_rb, rb_interpolate))

        tools_gw.open_dialog(dlg_dtext, dlg_name='dialog_text')

        # Set circle vertex marker
        color = QColor(255, 100, 255)
        self.vertex_marker = QgsVertexMarker(global_vars.canvas)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CIRCLE)
        self.vertex_marker.setColor(color)
        self.vertex_marker.setIconSize(15)
        self.vertex_marker.setPenWidth(3)

        self.node1 = None
        self.node2 = None

        global_vars.canvas.setMapTool(ep)
        # We redraw the selected feature because self.canvas.setMapTool(emit_point) erases it
        tools_gw.draw_by_json(complet_result, self.rubber_band, None, False)

        # Store user snapping configuration
        self.previous_snapping = self.snapper_manager.get_snapping_options

        self.layer_node = tools_qgis.get_layer_by_tablename("v_edit_node")
        global_vars.iface.setActiveLayer(self.layer_node)

        global_vars.canvas.xyCoordinates.connect(partial(self.mouse_move))
        ep.canvasClicked.connect(partial(self.snapping_node, ep, dlg_dtext, rb_interpolate))


    def snapping_node(self, ep, dlg_dtext, rb_interpolate, point, button):
        """ Get id of selected nodes (node1 and node2) """

        if button == 2:
            self.dlg_destroyed(self.layer)
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
                rb = QgsRubberBand(global_vars.canvas, 0)
                if self.node1 is None:
                    self.node1 = str(element_id)
                    tools_qgis.draw_point(QgsPointXY(result.point()), rb, color=QColor(0, 150, 55, 100), width=10)
                    rb_interpolate.append(rb)
                    dlg_dtext.lbl_text.setText(f"Node1: {self.node1}\nNode2:")
                    tools_qgis.show_message(message, message_level=0, parameter=self.node1)
                elif self.node1 != str(element_id):
                    self.node2 = str(element_id)
                    tools_qgis.draw_point(QgsPointXY(result.point()), rb, color=QColor(0, 150, 55, 100), width=10)
                    rb_interpolate.append(rb)
                    dlg_dtext.lbl_text.setText(f"Node1: {self.node1}\nNode2: {self.node2}")
                    tools_qgis.show_message(message, message_level=0, parameter=self.node2)

        if self.node1 and self.node2:
            global_vars.canvas.xyCoordinates.disconnect()
            ep.canvasClicked.disconnect()

            global_vars.iface.setActiveLayer(self.layer)
            global_vars.iface.mapCanvas().scene().removeItem(self.vertex_marker)
            extras = f'"parameters":{{'
            extras += f'"x":{self.last_point[0]}, '
            extras += f'"y":{self.last_point[1]}, '
            extras += f'"node1":"{self.node1}", '
            extras += f'"node2":"{self.node2}"}}'
            body = tools_gw.create_body(extras=extras)
            self.interpolate_result = tools_gw.get_json('gw_fct_node_interpolate', body)
            tools_gw.fill_tab_log(dlg_dtext, self.interpolate_result['body']['data'])


    def chek_for_existing_values(self, dlg_dtext):

        text = False
        for k, v in self.interpolate_result['body']['data']['fields'][0].items():
            widget = self.dlg_cf.findChild(QWidget, k)
            if widget:
                text = tools_qt.get_text(self.dlg_cf, widget, False, False)
                if text:
                    msg = "Do you want to overwrite custom values?"
                    answer = tools_qt.ask_question(msg, "Overwrite values")
                    if answer:
                        self.set_values(dlg_dtext)
                    break
        if not text:
            self.set_values(dlg_dtext)


    def set_values(self, dlg_dtext):

        # Set values tu info form
        for k, v in self.interpolate_result['body']['data']['fields'][0].items():
            widget = self.dlg_cf.findChild(QWidget, k)
            if widget:
                widget.setStyleSheet(None)
                tools_qt.set_widget_text(self.dlg_cf, widget, f'{v}')
                widget.editingFinished.emit()
        tools_gw.close_dialog(dlg_dtext)


    def dlg_destroyed(self, layer=None, vertex=None):

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
        except:
            pass


    def remove_interpolate_rb(self, rb_interpolate):

        # Remove the circumferences made by the interpolate
        for rb in rb_interpolate:
            global_vars.iface.mapCanvas().scene().removeItem(rb)


    def mouse_move(self, point):

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


    def change_hemisphere(self, dialog, action):

        # Set map tool emit point and signals
        emit_point = QgsMapToolEmitPoint(global_vars.canvas)
        self.previous_map_tool = global_vars.canvas.mapTool()
        global_vars.canvas.setMapTool(emit_point)
        emit_point.canvasClicked.connect(partial(self.action_rotation_canvas_clicked, dialog, action, emit_point))


    def action_rotation_canvas_clicked(self, dialog, action, emit_point, point, btn):

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

        # Disable Rotation
        action_widget = dialog.findChild(QAction, "actionRotation")
        if action_widget:
            action_widget.setChecked(False)
        try:
            emit_point.canvasClicked.disconnect()
        except Exception as e:
            tools_log.log_info(f"{type(e).__name__} --> {e}")
        self.cancel_snapping_tool(dialog, action)

    def manage_action_copy_paste(self, dialog, geom_type, tab_type=None):
        """ Copy some fields from snapped feature to current feature """

        # Set map tool emit point and signals
        emit_point = QgsMapToolEmitPoint(global_vars.canvas)
        global_vars.canvas.setMapTool(emit_point)
        global_vars.canvas.xyCoordinates.connect(self.manage_action_copy_paste_mouse_move)
        emit_point.canvasClicked.connect(partial(self.manage_action_copy_paste_canvas_clicked, dialog, tab_type, emit_point))
        self.geom_type = geom_type

        # Store user snapping configuration
        self.previous_snapping = self.snapper_manager.get_snapping_options

        # Clear snapping
        self.snapper_manager.set_snapping_status()

        # Set snapping
        layer = global_vars.iface.activeLayer()
        self.snapper_manager.config_snap_to_layer(layer)

        # Set marker
        color = QColor(255, 100, 255)
        self.vertex_marker = QgsVertexMarker(global_vars.canvas)
        if geom_type == 'node':
            self.vertex_marker.setIconType(QgsVertexMarker.ICON_CIRCLE)
        elif geom_type == 'arc':
            self.vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)
        self.vertex_marker.setColor(color)
        self.vertex_marker.setIconSize(15)
        self.vertex_marker.setPenWidth(3)


    def manage_action_copy_paste_mouse_move(self, point):
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


    def manage_action_copy_paste_canvas_clicked(self, dialog, tab_type, emit_point, point, btn):
        """ Slot function when canvas is clicked """

        if btn == Qt.RightButton:
            self.manage_disable_copy_paste(dialog, emit_point)
            return

        # Get clicked point
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if not result.isValid():
            self.manage_disable_copy_paste(dialog, emit_point)
            return

        layer = global_vars.iface.activeLayer()
        layername = layer.name()

        # Get the point. Leave selection
        snapped_feature = self.snapper_manager.get_snapped_feature(result, True)
        snapped_feature_attr = snapped_feature.attributes()

        aux = f'"{self.geom_type}_id" = '
        aux += f"'{self.feature_id}'"
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = "Expression Error"
            tools_qgis.show_warning(message, parameter=expr.parserErrorString())
            self.manage_disable_copy_paste(dialog, emit_point)
            return

        fields = layer.dataProvider().fields()
        layer.startEditing()
        it = layer.getFeatures(QgsFeatureRequest(expr))
        feature_list = [i for i in it]
        if not feature_list:
            self.manage_disable_copy_paste(dialog, emit_point)
            return

        # Select only first element of the feature list
        feature = feature_list[0]
        feature_id = feature.attribute(str(self.geom_type) + '_id')
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
                    or fields[i].name() == 'verified' or fields[i].name() == str(self.geom_type) + 'cat_id':
                snapped_feature_attr_aux.append(snapped_feature_attr[i])
                fields_aux.append(fields[i].name())
            if global_vars.project_type == 'ud':
                if fields[i].name() == str(self.geom_type) + '_type':
                    snapped_feature_attr_aux.append(snapped_feature_attr[i])
                    fields_aux.append(fields[i].name())

        for i in range(0, len(fields_aux)):
            msg += f"{fields_aux[i]}: {snapped_feature_attr_aux[i]}\n"

        # Ask confirmation question showing fields that will be copied
        answer = tools_qt.ask_question(msg, "Update records", None)
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

        self.manage_disable_copy_paste(dialog, emit_point)


    def manage_disable_copy_paste(self, dialog, emit_point):
        """ Disable actionCopyPaste and set action 'Identify' """

        action_widget = dialog.findChild(QAction, "actionCopyPaste")
        if action_widget:
            action_widget.setChecked(False)

        try:
            self.snapper_manager.restore_snap_options(self.previous_snapping)
            self.vertex_marker.hide()
            global_vars.canvas.xyCoordinates.disconnect()
            emit_point.canvasClicked.disconnect()
        except:
            pass


    def manage_docker_close(self):

        self.roll_back()
        self.rubber_band.reset()
        tools_gw.close_docker()


    def manage_info_close(self, dialog):

        self.roll_back()
        self.rubber_band.reset()
        tools_gw.save_settings(dialog)
        tools_gw.close_dialog(dialog)


    def get_feature(self, tab_type):
        """ Get current QgsFeature """

        expr_filter = f"{self.field_id} = '{self.feature_id}'"
        self.feature = self.get_feature_by_expr(self.layer, expr_filter)
        return self.feature


    def get_feature_by_expr(self, layer, expr_filter):

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


    def manage_action_zoom_in(self, canvas, layer):
        """ Zoom in """

        if not self.feature:
            self.get_feature(self.tab_type)
        layer.selectByIds([self.feature.id()])
        canvas.zoomToSelected(layer)
        canvas.zoomIn()


    def manage_action_centered(self, canvas, layer):
        """ Center map to current feature """

        if not self.feature:
            self.get_feature(self.tab_type)
        layer.selectByIds([self.feature.id()])
        canvas.zoomToSelected(layer)


    def manage_action_zoom_out(self, canvas, layer):
        """ Zoom out """

        if not self.feature:
            self.get_feature(self.tab_type)
        layer.selectByIds([self.feature.id()])
        canvas.zoomToSelected(layer)
        canvas.zoomOut()
        expr_filter = f"{self.field_id} = '{self.feature_id}'"
        self.feature = self.get_feature_by_expr(self.layer, expr_filter)
        return self.feature


    def get_last_value(self):

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


    def manage_edition(self, dialog, action_edit, fid, new_feature=None):
        # With the editing QAction we need to collect the last modified value (self.get_last_value()),
        # since the "editingFinished" signals of the widgets are not detected.
        # Therefore whenever the cursor enters a widget, it will ask if we want to save changes
        if not action_edit.isChecked():
            self.get_last_value()
            if str(self.my_json) == '{}':
                tools_qt.set_action_checked(action_edit, False)
                tools_gw.disable_widgets(dialog, self.complet_result['body']['data'], False)
                self.enable_actions(dialog, False)
                return
            save = self.ask_for_save(action_edit, fid)
            if save:
                self.manage_accept(dialog, action_edit, new_feature, self.my_json, False)
                self.my_json = {}
            elif self.new_feature_id is not None:
                if global_vars.session_vars['dlg_docker'] and global_vars.session_vars['show_docker']:
                    self.manage_docker_close()
                else:
                    tools_gw.close_dialog(dialog)
        else:
            tools_qt.set_action_checked(action_edit, True)
            tools_gw.enable_all(dialog, self.complet_result['body']['data'])
            self.enable_actions(dialog, True)


    def accept_from_btn(self, dialog, action_edit, new_feature, my_json):

        if not action_edit.isChecked():
            tools_gw.close_dialog(dialog)
            return

        self.manage_accept(dialog, action_edit, new_feature, my_json, True)


    def manage_accept(self, dialog, action_edit, new_feature, my_json, close_dlg):
        self.get_last_value()
        status = self.accept(dialog, self.complet_result, my_json, close_dlg=close_dlg, new_feature=new_feature)
        if status is True:  # Commit succesfull and dialog keep opened
            tools_qt.set_action_checked(action_edit, False)
            tools_gw.disable_widgets(dialog, self.complet_result['body']['data'], False)
            self.enable_actions(dialog, False)


    def stop_editing(self, dialog, action_edit, layer, fid, my_json, new_feature=None):
        if my_json == '' or str(my_json) == '{}':
            self.disconnect_signals()
            # Use commitChanges just for closse edition
            layer.commitChanges()
            self.connect_signals()
            tools_qt.set_action_checked(action_edit, False)
            tools_gw.disable_widgets(dialog, self.complet_result['body']['data'], False)
            self.enable_actions(dialog, False)
            self.connect_signals()
        else:
            save = self.ask_for_save(action_edit, fid)
            if save:
                self.manage_accept(dialog, action_edit, new_feature, my_json, False)

            return save


    def start_editing(self, dialog, action_edit, result, layer):
        self.disconnect_signals()
        self.iface.setActiveLayer(layer)
        tools_qt.set_action_checked(action_edit, True)
        tools_gw.enable_all(dialog, self.complet_result['body']['data'])
        self.enable_actions(dialog, True)
        layer.startEditing()
        self.connect_signals()


    def ask_for_save(self, action_edit, fid):

        msg = 'Are you sure to save this feature?'
        answer = tools_qt.ask_question(msg, "Save feature", None, parameter=fid)
        if not answer:
            tools_qt.set_action_checked(action_edit, True)
            return False
        return True


    def roll_back(self):
        """ Discard changes in current layer """

        self.disconnect_signals()
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


    def set_widgets(self, dialog, complet_result, field, new_feature):
        """
        functions called in -> widget = getattr(self, f"manage_{field['widgettype']}")(**kwargs)
            def manage_text(self, **kwargs)
            def manage_typeahead(self, **kwargs)
            def manage_combo(self, **kwargs)
            def manage_check(self, **kwargs)
            def manage_datetime(self, **kwargs)
            def manage_button(self, **kwargs)
            def manage_hyperlink(self, **kwargs)
            def manage_hspacer(self, **kwargs)
            def manage_vspacer(self, **kwargs)
            def manage_textarea(self, **kwargs)
            def manage_spinbox(self, **kwargs)
            def manage_doubleSpinbox(self, **kwargs)
            def manage_tableView(self, **kwargs)
         """

        widget = None
        label = None
        if field['label']:
            label = QLabel()
            label.setObjectName('lbl_' + field['widgetname'])
            label.setText(field['label'].capitalize())
            if field['stylesheet'] is not None and 'label' in field['stylesheet']:
                label = tools_gw.set_stylesheet(field, label)
            if 'tooltip' in field:
                label.setToolTip(field['tooltip'])
            else:
                label.setToolTip(field['label'].capitalize())

        if 'widgettype' in field and not field['widgettype']:
            message = "The field widgettype is not configured for"
            msg = f"formname:{self.tablename}, columnname:{field['columnname']}"
            tools_qgis.show_message(message, 2, parameter=msg)
            return label, widget

        try:
            kwargs = {"dialog": dialog, "complet_result": complet_result, "field": field, "new_feature": new_feature}
            widget = getattr(self, f"manage_{field['widgettype']}")(**kwargs)
        except Exception as e:
            msg = f"{type(e).__name__}: {e}"
            tools_qgis.show_message(msg, 2)
            return label, widget

        return label, widget


    def manage_text(self, **kwargs):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(**kwargs)
        """
        dialog = kwargs['dialog']
        field = kwargs['field']
        new_feature = kwargs['new_feature']

        widget = tools_gw.add_lineedit(field)
        widget = tools_gw.set_widget_size(widget, field)
        widget = self.set_min_max_values(widget, field)
        widget = self.set_reg_exp(widget, field)
        widget = self.set_auto_update_lineedit(field, dialog, widget, new_feature)
        widget = tools_gw.set_data_type(field, widget)
        widget = self.set_max_length(widget, field)

        return widget


    def set_min_max_values(self, widget, field):
        """ Set max and min values allowed """

        if field['widgetcontrols'] and 'maxMinValues' in field['widgetcontrols']:
            if 'min' in field['widgetcontrols']['maxMinValues']:
                widget.setProperty('minValue', field['widgetcontrols']['maxMinValues']['min'])

        if field['widgetcontrols'] and 'maxMinValues' in field['widgetcontrols']:
            if 'max' in field['widgetcontrols']['maxMinValues']:
                widget.setProperty('maxValue', field['widgetcontrols']['maxMinValues']['max'])

        return widget


    def set_max_length(self, widget, field):
        """ Set max and min values allowed """

        if field['widgetcontrols'] and 'maxLength' in field['widgetcontrols']:
            if field['widgetcontrols']['maxLength'] is not None:
                widget.setProperty('maxLength', field['widgetcontrols']['maxLength'])

        return widget


    def set_reg_exp(self, widget, field):
        """ Set regular expression """

        if 'widgetcontrols' in field and field['widgetcontrols']:
            if field['widgetcontrols'] and 'regexpControl' in field['widgetcontrols']:
                if field['widgetcontrols']['regexpControl'] is not None:
                    reg_exp = QRegExp(str(field['widgetcontrols']['regexpControl']))
                    widget.setValidator(QRegExpValidator(reg_exp))

        return widget


    def manage_typeahead(self, **kwargs):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(**kwargs)
        """
        dialog = kwargs['dialog']
        field = kwargs['field']

        completer = QCompleter()
        widget = self.manage_text(**kwargs)
        widget = tools_gw.set_typeahead(field, dialog, widget, completer)
        return widget


    def manage_combo(self, **kwargs):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(**kwargs)
        """
        dialog = kwargs['dialog']
        field = kwargs['field']
        new_feature = kwargs['new_feature']

        widget = tools_gw.add_combo(field)
        widget = tools_gw.set_widget_size(widget, field)
        widget = self.set_auto_update_combobox(field, dialog, widget, new_feature)
        return widget


    def manage_check(self, **kwargs):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(**kwargs)
        """
        dialog = kwargs['dialog']
        field = kwargs['field']
        new_feature = kwargs['new_feature']

        widget = tools_gw.add_checkbox(field)
        widget.stateChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))
        widget = self.set_auto_update_checkbox(field, dialog, widget, new_feature)
        return widget


    def manage_datetime(self, **kwargs):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(**kwargs)
        """
        dialog = kwargs['dialog']
        field = kwargs['field']
        new_feature = kwargs['new_feature']

        widget = tools_gw.add_calendar(dialog, field)
        widget = self.set_auto_update_dateedit(field, dialog, widget, new_feature)
        return widget


    def manage_button(self, **kwargs):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(**kwargs)
        """
        dialog = kwargs['dialog']
        field = kwargs['field']

        widget = tools_gw.add_button(dialog, field, module=self)
        widget = tools_gw.set_widget_size(widget, field)
        return widget


    def manage_hyperlink(self, **kwargs):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(**kwargs)
        """
        field = kwargs['field']

        widget = tools_gw.add_hyperlink(field)
        widget = tools_gw.set_widget_size(widget, field)
        return widget


    def manage_hspacer(self, **kwargs):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(**kwargs)
        """

        widget = tools_qt.add_horizontal_spacer()
        return widget


    def manage_vspacer(self, **kwargs):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(**kwargs)
        """
        widget = tools_qt.add_verticalspacer()
        return widget


    def manage_textarea(self, **kwargs):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(**kwargs)
        """
        dialog = kwargs['dialog']
        field = kwargs['field']
        new_feature = kwargs['new_feature']

        widget = tools_gw.add_textarea(field)
        widget = self.set_auto_update_textarea(field, dialog, widget, new_feature)
        return widget


    def manage_spinbox(self, **kwargs):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(**kwargs)
        """
        dialog = kwargs['dialog']
        field = kwargs['field']
        new_feature = kwargs['new_feature']

        widget = tools_gw.add_spinbox(field)
        widget = self.set_auto_update_spinbox(field, dialog, widget, new_feature)
        return widget


    def manage_doubleSpinbox(self, **kwargs):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(**kwargs)
        """
        dialog = kwargs['dialog']
        field = kwargs['field']
        new_feature = kwargs['new_feature']

        widget = tools_gw.add_spinbox(field)

        widget = self.set_auto_update_spinbox(field, dialog, widget, new_feature)
        return widget


    def manage_tableView(self, **kwargs):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(**kwargs)
        """
        complet_result = kwargs['complet_result']
        field = kwargs['field']
        dialog = kwargs['dialog']
        widget = tools_gw.add_tableview(complet_result, field)
        widget = tools_gw.add_tableview_header(widget, field)
        widget = tools_gw.fill_tableview_rows(widget, field)
        widget = tools_gw.set_tablemodel_config(dialog, widget, field['widgetname'], sort_order=1, isQStandardItemModel=True)
        tools_qt.set_tableview_config(widget)
        return widget


    def open_section_form(self):

        dlg_sections = GwInfoCrossectUi()
        tools_gw.load_settings(dlg_sections)

        # Set dialog not resizable
        dlg_sections.setFixedSize(dlg_sections.size())

        feature = '"id":"' + self.feature_id + '"'
        body = tools_gw.create_body(feature=feature)
        json_result = tools_gw.get_json('gw_fct_getinfocrossection', body)
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
        tools_gw.open_dialog(dlg_sections, dlg_name='info_crossect', maximize_button=False)


    def accept(self, dialog, complet_result, _json, p_widget=None, clear_json=False, close_dlg=True, new_feature=None):
        """
        :param dialog:
        :param complet_result:
        :param _json:
        :param p_widget:
        :param clear_json:
        :param close_dlg:
        :return:
        """
        self.disconnect_signals()

        # Check if C++ object has been deleted
        if isdeleted(dialog):
            return False

        after_insert = False

        if _json == '' or str(_json) == '{}':
            if global_vars.session_vars['dlg_docker']:
                global_vars.session_vars['dlg_docker'].setMinimumWidth(dialog.width())
                tools_gw.close_docker()
            tools_gw.close_dialog(dialog)
            return None

        p_table_id = complet_result['body']['feature']['tableName']
        id_name = complet_result['body']['feature']['idName']
        parent_fields = complet_result['body']['data']['parentFields']
        fields_reload = ""
        list_mandatory = []
        for field in complet_result['body']['data']['fields']:
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
            tools_qgis.show_warning(msg)
            tools_qt.set_action_checked("actionEdit", True, dialog)
            self.connect_signals()
            return False

        # If we create a new feature
        if self.new_feature_id is not None:
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
                self.connect_signals()
                return False
            
            self.new_feature_id = None
            self.enable_action(dialog, "actionZoom", True)
            self.enable_action(dialog, "actionZoomOut", True)
            self.enable_action(dialog, "actionCentered", True)
            global is_inserting
            is_inserting = False
            my_json = json.dumps(_json)
            if my_json == '' or str(my_json) == '{}':
                if close_dlg:
                    if global_vars.session_vars['dlg_docker']:
                        tools_gw.close_docker()
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
        json_result = tools_gw.get_json('gw_fct_setfields', body, log_sql=True)
        if not json_result:
            self.connect_signals()
            return False

        if clear_json:
            _json = {}

        if "Accepted" in json_result['status']:
            msg = "OK"
            tools_qgis.show_message(msg, message_level=3)
            self.reload_fields(dialog, json_result, p_widget)
        elif "Failed" in json_result['status']:
            # If json_result['status'] is Failed message from database is showed user by get_json->manage_json_exception
            self.connect_signals()
            return False

        if close_dlg:
            if global_vars.session_vars['dlg_docker']:
                self.manage_docker_close()
            tools_gw.close_dialog(dialog)
            return None

        return True


    def get_scale_zoom(self):

        scale_zoom = self.iface.mapCanvas().scale()
        return scale_zoom


    def enable_actions(self, dialog, enabled):
        """ Enable actions according if layer is editable or not """

        try:
            actions_list = dialog.findChildren(QAction)
            static_actions = ('actionEdit', 'actionCentered', 'actionZoomOut', 'actionZoom', 'actionLink', 'actionHelp',
                              'actionSection')
            for action in actions_list:
                if action.objectName() not in static_actions:
                    self.enable_action(dialog, action, enabled)
        except RuntimeError:
            pass


    def enable_action(self, dialog, action, enabled):
        if type(action) is str:
            action = dialog.findChild(QAction, action)
        if not action:
            return
        action.setEnabled(enabled)


    def check_datatype_validator(self, dialog, widget, btn):
        """
        functions called in ->  getattr(tools_gw, f"check_{widget.property('datatype')}")(value, widget, btn)
            def check_integer(self, value, widget, btn_accept)
            def check_double(self, value, widget, btn_accept)
        """
        value = tools_qt.get_text(dialog, widget, return_string_null=False)
        try:
            getattr(self, f"check_{widget.property('datatype')}")(value, widget, btn)
        except AttributeError as e:
            """ If the function called by getattr don't exist raise this exception """
            pass


    def check_double(self, value, widget, btn_accept):
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


    def check_integer(self, value, widget, btn_accept):
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


    def check_min_max_value(self, dialog, widget, btn_accept):

        value = tools_qt.get_text(dialog, widget, return_string_null=False)
        try:
            if value and ((widget.property('minValue') and float(value) < float(widget.property('minValue'))) or
                          (widget.property('maxValue') and float(value) > float(widget.property('maxValue')))):
                widget.setStyleSheet("border: 1px solid red")
                btn_accept.setEnabled(False)
            else:
                widget.setStyleSheet(None)
                btn_accept.setEnabled(True)
        except ValueError:
            widget.setStyleSheet("border: 1px solid red")
            btn_accept.setEnabled(False)


    def check_tab_data(self, dialog):
        """ Check if current tab name is tab_data """

        tab_main = dialog.findChild(QTabWidget, "tab_main")
        if not tab_main:
            return
        index_tab = tab_main.currentIndex()
        tab_name = tab_main.widget(index_tab).objectName()
        if tab_name == 'tab_data':
            return True
        return False


    def clean_my_json(self, widget):
        """ Delete keys if exist, when widget is autoupdate """

        try:
            self.my_json.pop(str(widget.property('columnname')), None)
        except KeyError:
            pass


    def set_auto_update_lineedit(self, field, dialog, widget, new_feature=None):
        if self.check_tab_data(dialog):
            # "and field['widgettype'] != 'typeahead'" It is necessary so that the textchanged signal of the typeahead
            # does not jump, making it lose focus, which will cause the accept function to jump sent invalid parameters
            if field['isautoupdate'] and self.new_feature_id is None and field['widgettype'] != 'typeahead':
                _json = {}
                widget.editingFinished.connect(partial(self.clean_my_json, widget))
                widget.editingFinished.connect(partial(tools_gw.get_values, dialog, widget, _json))
                widget.editingFinished.connect(
                    partial(self.accept, dialog, self.complet_result, _json, widget, True, False, new_feature=new_feature))
            else:
                widget.editingFinished.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))

            widget.textChanged.connect(partial(self.enabled_accept, dialog))
            widget.textChanged.connect(partial(self.check_datatype_validator, dialog, widget, dialog.btn_accept))
            widget.textChanged.connect(partial(self.check_min_max_value, dialog, widget, dialog.btn_accept))

        return widget


    def set_auto_update_textarea(self, field, dialog, widget, new_feature):

        if self.check_tab_data(dialog):
            # "and field['widgettype'] != 'typeahead'" It is necessary so that the textchanged signal of the typeahead
            # does not jump, making it lose focus, which will cause the accept function to jump sent invalid parameters
            if field['isautoupdate'] and self.new_feature_id is None and field['widgettype'] != 'typeahead':
                _json = {}
                widget.textChanged.connect(partial(self.clean_my_json, widget))
                widget.textChanged.connect(partial(tools_gw.get_values, dialog, widget, _json))
                widget.textChanged.connect(
                    partial(self.accept, dialog, self.complet_result, _json, widget, True, False, new_feature))
            else:
                widget.textChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))

            widget.textChanged.connect(partial(self.enabled_accept, dialog))
            widget.textChanged.connect(partial(self.check_datatype_validator, dialog, widget, dialog.btn_accept))
            widget.textChanged.connect(partial(self.check_min_max_value, dialog, widget, dialog.btn_accept))

        return widget


    def reload_fields(self, dialog, result, p_widget):
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
                if str(cur_value) != str(value) and str(value) != '':
                    widget.setText(value)
                    widget.setStyleSheet("border: 2px solid #3ED396")
            elif "message" in field:
                level = field['message']['level'] if 'level' in field['message'] else 0
                tools_qgis.show_message(field['message']['text'], level)


    def enabled_accept(self, dialog):
        dialog.btn_accept.setEnabled(True)


    def set_auto_update_combobox(self, field, dialog, widget, new_feature):

        if self.check_tab_data(dialog):
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                widget.currentIndexChanged.connect(partial(self.clean_my_json, widget))
                widget.currentIndexChanged.connect(partial(tools_gw.get_values, dialog, widget, _json))
                widget.currentIndexChanged.connect(partial(
                    self.accept, dialog, self.complet_result, _json, None, True, False, new_feature))
            else:
                widget.currentIndexChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))

        return widget


    def set_auto_update_dateedit(self, field, dialog, widget, new_feature):

        if self.check_tab_data(dialog):
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                widget.dateChanged.connect(partial(self.clean_my_json, widget))
                widget.dateChanged.connect(partial(tools_gw.get_values, dialog, widget, _json))
                widget.dateChanged.connect(partial(
                    self.accept, dialog, self.complet_result, _json, None, True, False, new_feature))
            else:
                widget.dateChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))

        return widget


    def set_auto_update_spinbox(self, field, dialog, widget, new_feature):

        if self.check_tab_data(dialog):
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                widget.valueChanged.connect(partial(self.clean_my_json, widget))
                widget.valueChanged.connect(partial(tools_gw.get_values, dialog, widget, _json))
                widget.valueChanged.connect(partial(
                    self.accept, dialog, self.complet_result, _json, None, True, False, new_feature))
            else:
                widget.valueChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))

        return widget


    def set_auto_update_checkbox(self, field, dialog, widget, new_feature):

        if self.check_tab_data(dialog):
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                widget.stateChanged.connect(partial(self.clean_my_json, widget))
                widget.stateChanged.connect(partial(tools_gw.get_values, dialog, widget, _json))
                widget.stateChanged.connect(partial(
                    self.accept, dialog, self.complet_result, _json, None, True, False, new_feature))
            else:
                widget.stateChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))
        return widget


    def open_catalog(self, tab_type, feature_type):

        self.catalog = GwCatalog()

        # Check geom_type
        if self.geom_type == 'connec':
            widget = f'{tab_type}_{self.geom_type}at_id'
        else:
            widget = f'{tab_type}_{self.geom_type}cat_id'
        self.catalog.open_catalog(self.dlg_cf, widget, self.geom_type, feature_type)


    def show_actions(self, dialog, tab_name):
        """ Hide all actions and show actions for the corresponding tab
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

        self.enable_actions(dialog, self.layer.isEditable())


    """ MANAGE TABS """

    def tab_activation(self, dialog, new_feature):
        """ Call functions depend on tab selection """

        # Get index of selected tab
        index_tab = self.tab_main.currentIndex()
        tab_name = self.tab_main.widget(index_tab).objectName()
        self.show_actions(dialog, tab_name)

        # Tab 'Elements'
        if self.tab_main.widget(index_tab).objectName() == 'tab_elements' and not self.tab_element_loaded:
            self.fill_tab_element()
            self.tab_element_loaded = True
        # Tab 'Relations'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_relations' and not self.tab_relations_loaded:
            self.fill_tab_relations()
            self.tab_relations_loaded = True
        # Tab 'Connections'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_connections' and not self.tab_connections_loaded:
            self.fill_tab_connections()
            self.tab_connections_loaded = True
        # Tab 'Hydrometer'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_hydrometer' and not self.tab_hydrometer_loaded:
            self.fill_tab_hydrometer()
            self.tab_hydrometer_loaded = True
        # Tab 'Hydrometer values'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_hydrometer_val' and not self.tab_hydrometer_val_loaded:
            self.fill_tab_hydrometer_values()
            self.tab_hydrometer_val_loaded = True
        # Tab 'O&M'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_om' and not self.tab_om_loaded:
            self.fill_tab_om(self.geom_type)
            self.tab_om_loaded = True
        # Tab 'Documents'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_documents' and not self.tab_document_loaded:
            self.fill_tab_document()
            self.tab_document_loaded = True
        elif self.tab_main.widget(index_tab).objectName() == 'tab_rpt' and not self.tab_rpt_loaded:
            self.fill_tab_rpt(self.complet_result, new_feature)
            self.tab_rpt_loaded = True
        # Tab 'Plan'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_plan' and not self.tab_plan_loaded:
            self.fill_tab_plan(self.complet_result)
            self.tab_plan_loaded = True


    def fill_tab_element(self):
        """ Fill tab 'Element' """

        table_element = "v_ui_element_x_" + self.geom_type
        self.fill_tbl_element_man(self.dlg_cf, self.tbl_element, table_element, self.filter)
        tools_gw.set_tablemodel_config(self.dlg_cf, self.tbl_element, table_element)


    def fill_tbl_element_man(self, dialog, widget, table_name, expr_filter):
        """ Fill the table control to show elements """

        if not self.feature:
            self.get_feature(self.tab_type)

        # Get widgets
        self.element_id = self.dlg_cf.findChild(QLineEdit, "element_id")
        btn_open_element = self.dlg_cf.findChild(QPushButton, "btn_open_element")
        btn_delete = self.dlg_cf.findChild(QPushButton, "btn_delete")
        btn_insert = self.dlg_cf.findChild(QPushButton, "btn_insert")
        btn_new_element = self.dlg_cf.findChild(QPushButton, "btn_new_element")

        # Set signals
        self.tbl_element.doubleClicked.connect(partial(self.open_selected_element, dialog, widget))
        btn_open_element.clicked.connect(partial(self.open_selected_element, dialog, widget))
        btn_delete.clicked.connect(partial(self.delete_records, widget, table_name))
        btn_insert.clicked.connect(partial(self.add_object, widget, "element", "v_ui_element"))
        btn_new_element.clicked.connect(partial(self.manage_element, dialog, feature=self.feature))

        # Set model of selected widget
        message = tools_qt.fill_table(widget, table_name, expr_filter)
        if message:
            tools_qgis.show_warning(message)

        # Adding auto-completion to a QLineEdit
        self.table_object = "element"
        tools_gw.set_completer_object(dialog, self.table_object)


    def open_selected_element(self, dialog, widget):
        """ Open form of selected element of the @widget?? """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        element_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            element_id = widget.model().record(row).value("element_id")
            break

        # Open selected element
        self.manage_element(dialog, element_id)


    def add_object(self, widget, table_object, view_object):
        """ Add object (doc or element) to selected feature """

        # Get values from dialog
        object_id = tools_qt.get_text(self.dlg_cf, table_object + "_id")
        if object_id == 'null':
            message = "You need to insert data"
            tools_qgis.show_warning(message, parameter=table_object + "_id")
            return

        # Check if this object exists
        field_object_id = "id"
        sql = ("SELECT * FROM " + view_object + ""
               " WHERE " + field_object_id + " = '" + object_id + "'")
        row = tools_db.get_row(sql)
        if not row:
            tools_qgis.show_warning("Object id not found", parameter=object_id)
            return

        # Check if this object is already associated to current feature
        field_object_id = table_object + "_id"
        tablename = table_object + "_x_" + self.geom_type
        sql = ("SELECT *"
               " FROM " + str(tablename) + ""
               " WHERE " + str(self.field_id) + " = '" + str(self.feature_id) + "'"
               " AND " + str(field_object_id) + " = '" + str(object_id) + "'")
        row = tools_db.get_row(sql, log_info=False, log_sql=False)

        # If object already exist show warning message
        if row:
            message = "Object already associated with this feature"
            tools_qgis.show_warning(message)

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


    def delete_records(self, widget, table_name):
        """ Delete selected objects (elements or documents) of the @widget """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
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
        answer = tools_qt.ask_question(message, "Delete records", list_object_id)
        if answer:
            sql = ("DELETE FROM " + table_name + ""
                   " WHERE id::integer IN (" + list_id + ")")
            tools_db.execute_sql(sql, log_sql=False)
            widget.model().select()

    """ FUNCTIONS RELATED WITH TAB ELEMENT"""

    def manage_element(self, dialog, element_id=None, feature=None):
        """ Execute action of button 33 """

        elem = GwElement()
        elem.get_element(True, feature, self.geom_type)
        elem.dlg_add_element.accepted.connect(partial(self.manage_element_new, dialog, elem))
        elem.dlg_add_element.rejected.connect(partial(self.manage_element_new, dialog, elem))

        # Set completer
        tools_gw.set_completer_object(dialog, self.table_object)

        if element_id:
            tools_qt.set_widget_text(elem.dlg_add_element, "element_id", element_id)

        # Open dialog
        tools_gw.open_dialog(elem.dlg_add_element)


    def manage_element_new(self, dialog, elem):
        """ Get inserted element_id and add it to current feature """

        if elem.element_id is None:
            return

        tools_qt.set_widget_text(dialog, "element_id", elem.element_id)
        self.add_object(self.tbl_element, "element", "v_ui_element")
        self.tbl_element.model().select()


    """ FUNCTIONS RELATED WITH TAB RELATIONS"""

    def manage_tab_relations(self, viewname, field_id):
        """ Hide tab 'relations' if no data in the view """

        # Check if data in the view
        sql = (f"SELECT * FROM {viewname}"
               f" WHERE {field_id} = '{self.feature_id}';")
        row = tools_db.get_row(sql, log_info=True, log_sql=False)

        if not row:
            # Hide tab 'relations'
            tools_qt.remove_tab(self.tab_main, "relations")

        else:
            # Manage signal 'doubleClicked'
            self.tbl_relations.doubleClicked.connect(partial(self.open_relation, field_id))


    def fill_tab_relations(self):
        """ Fill tab 'Relations' """

        table_relations = f"v_ui_{self.geom_type}_x_relations"
        message = tools_qt.fill_table(self.tbl_relations, self.schema_name + "." + table_relations, self.filter)
        if message:
            tools_qgis.show_warning(message)
        tools_gw.set_tablemodel_config(self.dlg_cf, self.tbl_relations, table_relations)
        self.tbl_relations.doubleClicked.connect(partial(self.open_relation, str(self.field_id)))


    def open_relation(self, field_id):
        """ Open feature form of selected element """

        selected_list = self.tbl_relations.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        row = selected_list[0].row()

        # Get object_id from selected row
        field_object_id = "parent_id"
        if field_id == "arc_id":
            field_object_id = "feature_id"
        selected_object_id = self.tbl_relations.model().record(row).value(field_object_id)
        sys_type = self.tbl_relations.model().record(row).value("sys_type")
        sql = (f"SELECT feature_type FROM cat_feature "
               f"WHERE system_id = '{sys_type}'")
        sys_type = tools_db.get_row(sql)
        table_name = self.tbl_relations.model().record(row).value("sys_table_id")
        feature_id = self.tbl_relations.model().record(row).value("sys_id")

        if table_name is None:
            table_name = 'v_edit_' + sys_type[0].lower()

        if feature_id is None:
            feature_id = selected_object_id

        layer = tools_qgis.get_layer_by_tablename(table_name, log_info=True)

        if not layer:
            message = "Layer not found"
            tools_qgis.show_message(message, parameter=table_name)
            return

        info_feature = GwInfo(self.tab_type)
        complet_result, dialog = info_feature.open_form(table_name=table_name, feature_id=feature_id, tab_type=self.tab_type)
        if not complet_result:
            tools_log.log_info("FAIL open_relation")
            return

        margin = float(complet_result['body']['feature']['zoomCanvasMargin']['mts'])
        tools_gw.draw_by_json(complet_result, self.rubber_band, margin)


    """ FUNCTIONS RELATED WITH TAB CONNECTIONS """

    def fill_tab_connections(self):
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

        self.dlg_cf.tbl_upstream.doubleClicked.connect(partial(self.open_up_down_stream, self.tbl_upstream))
        self.dlg_cf.tbl_downstream.doubleClicked.connect(partial(self.open_up_down_stream, self.tbl_downstream))


    def open_up_down_stream(self, qtable):
        """ Open selected node from @qtable """

        selected_list = qtable.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
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


    """ FUNCTIONS RELATED WITH TAB HYDROMETER"""

    def fill_tab_hydrometer(self):
        """ Fill tab 'Hydrometer' """

        table_hydro = "v_ui_hydrometer"
        txt_hydrometer_id = self.dlg_cf.findChild(QLineEdit, "txt_hydrometer_id")
        self.fill_tbl_hydrometer(self.tbl_hydrometer, table_hydro)
        tools_gw.set_tablemodel_config(self.dlg_cf, self.tbl_hydrometer, table_hydro)
        txt_hydrometer_id.textChanged.connect(partial(self.fill_tbl_hydrometer, self.tbl_hydrometer, table_hydro))
        self.tbl_hydrometer.doubleClicked.connect(partial(self.open_selected_hydro, self.tbl_hydrometer))
        self.dlg_cf.findChild(QPushButton, "btn_link").clicked.connect(self.check_url)


    def open_selected_hydro(self, qtable=None):

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
        info_feature = GwInfo(self.tab_type)
        complet_result, dialog = info_feature.open_form(table_name=table_name, feature_id=feature_id, tab_type=self.tab_type)
        if not complet_result:
            tools_log.log_info("FAIL open_selected_hydro")
            return


    def check_url(self):
        """ Check URL. Enable/Disable button that opens it """

        selected_list = self.tbl_hydrometer.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        row = selected_list[0].row()
        url = self.tbl_hydrometer.model().record(row).value("hydrometer_link")
        if url != '':
            if os.path.exists(url):
                # Open the document
                if sys.platform == "win32":
                    os.startfile(url)
                else:
                    opener = "open" if sys.platform == "darwin" else "xdg-open"
                    subprocess.call([opener, url])
            else:
                webbrowser.open(url)


    def fill_tbl_hydrometer(self, qtable, table_name):
        """ Fill the table control to show hydrometers """

        txt_hydrometer_id = self.dlg_cf.findChild(QLineEdit, "txt_hydrometer_id")
        filter = f"connec_id = '{self.feature_id}' "
        filter += f" AND hydrometer_customer_code ILIKE '%{txt_hydrometer_id.text()}%'"

        # Set model of selected widget
        message = tools_qt.fill_table(qtable, f"{self.schema_name}.{table_name}", filter)
        if message:
            tools_qgis.show_warning(message)


    """ FUNCTIONS RELATED WITH TAB HYDROMETER VALUES"""

    def fill_tab_hydrometer_values(self):

        table_hydro_value = "v_ui_hydroval_x_connec"

        # Populate combo filter hydrometer value
        sql = (f"SELECT DISTINCT(t1.code), t2.cat_period_id "
               f"FROM ext_cat_period as t1 "
               f"join v_ui_hydroval_x_connec as t2 on t1.id = t2.cat_period_id "
               f"ORDER BY t2.cat_period_id DESC")
        rows = tools_db.get_rows(sql)
        if not rows:
            return False
        tools_qt.fill_combo_values(self.dlg_cf.cmb_cat_period_id_filter, rows, add_empty=True, sort_combo=False)

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

        self.fill_tbl_hydrometer_values(self.tbl_hydrometer_value, table_hydro_value)
        tools_gw.set_tablemodel_config(self.dlg_cf, self.tbl_hydrometer_value, table_hydro_value)

        self.dlg_cf.cmb_cat_period_id_filter.currentIndexChanged.connect(
            partial(self.fill_tbl_hydrometer_values, self.tbl_hydrometer_value, table_hydro_value))
        self.dlg_cf.cmb_hyd_customer_code.currentIndexChanged.connect(
            partial(self.fill_tbl_hydrometer_values, self.tbl_hydrometer_value, table_hydro_value))


    def fill_tbl_hydrometer_values(self, qtable, table_name):
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


    def set_filter_hydrometer_values(self, widget):
        """ Get Filter for table hydrometer value with combo value"""

        # Get combo value
        cat_period_id_filter = tools_qt.get_combo_value(self.dlg_cf, self.dlg_cf.cmb_cat_period_id_filter, 0)

        # Set filter
        expr = f"{self.field_id} = '{self.feature_id}'"
        expr += f" AND cat_period_id ILIKE '%{cat_period_id_filter}%'"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()


    """ FUNCTIONS RELATED WITH TAB OM"""

    def fill_tab_om(self, geom_type):
        """ Fill tab 'O&M' (event) """

        table_event_geom = "v_ui_event_x_" + geom_type
        self.fill_tbl_event(self.tbl_event_cf, table_event_geom, self.filter)
        self.tbl_event_cf.doubleClicked.connect(self.open_visit_event)
        tools_gw.set_tablemodel_config(self.dlg_cf, self.tbl_event_cf, table_event_geom)


    def fill_tbl_event(self, widget, table_name, filter_):
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
        widget.clicked.connect(partial(self.tbl_event_clicked, table_name))
        event_type.currentIndexChanged.connect(partial(self.set_filter_table_event, widget))
        event_id.currentIndexChanged.connect(partial(self.set_filter_table_event2, widget))
        self.date_event_to.dateChanged.connect(partial(self.set_filter_table_event, widget))
        self.date_event_from.dateChanged.connect(partial(self.set_filter_table_event, widget))

        btn_open_visit.clicked.connect(self.open_visit)
        btn_new_visit.clicked.connect(self.new_visit)
        btn_open_gallery.clicked.connect(self.open_gallery)
        btn_open_visit_doc.clicked.connect(self.open_visit_doc)
        btn_open_visit_event.clicked.connect(self.open_visit_event)

        feature_type = {'arc_id': 'ARC', 'connec_id': 'CONNEC', 'gully_id': 'GULLY', 'node_id': 'NODE'}
        table_name_event_id = "config_visit_parameter"

        # Fill ComboBox event_id
        sql = (f"SELECT DISTINCT(id), id "
               f"FROM {table_name_event_id} "
               f"WHERE feature_type = '{feature_type[self.field_id]}' OR feature_type = 'ALL' "
               f"ORDER BY id")
        rows = tools_db.get_rows(sql)
        if rows:
            rows.append(['', ''])
            tools_qt.fill_combo_values(self.dlg_cf.event_id, rows)
        # Fill ComboBox event_type
        sql = (f"SELECT DISTINCT(parameter_type), parameter_type "
               f"FROM {table_name_event_id} "
               f"WHERE feature_type = '{feature_type[self.field_id]}' OR feature_type = 'ALL' "
               f"ORDER BY parameter_type")
        rows = tools_db.get_rows(sql)
        if rows:
            rows.append(['', ''])
            tools_qt.fill_combo_values(self.dlg_cf.event_type, rows)

        message = tools_qt.fill_table(widget, table_name)
        if message:
            tools_qgis.show_warning(message)
        self.set_filter_table_event(widget)


    def open_visit_event(self):
        """ Open event of selected record of the table """

        # Open dialog event_standard
        self.dlg_event_full = GwVisitEventFullUi()
        tools_gw.load_settings(self.dlg_event_full)
        self.dlg_event_full.rejected.connect(partial(tools_gw.close_dialog, self.dlg_event_full))
        # Get all data for one visit
        sql = (f"SELECT * FROM om_visit_event"
               f" WHERE id = '{self.event_id}' AND visit_id = '{self.visit_id}'")
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
        self.populate_tbl_docs_x_event()

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
        self.dlg_event_full.tbl_docs_x_event.doubleClicked.connect(self.open_file)
        tools_qt.set_tableview_config(self.dlg_event_full.tbl_docs_x_event)
        tools_gw.open_dialog(self.dlg_event_full, 'visit_event_full')


    def populate_tbl_docs_x_event(self):

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


    def open_file(self):

        # Get row index
        index = self.dlg_event_full.tbl_docs_x_event.selectionModel().selectedRows()[0]
        column_index = tools_qt.get_col_index_by_col_name(self.dlg_event_full.tbl_docs_x_event, 'value')

        path = index.sibling(index.row(), column_index).data()
        # Check if file exist
        if os.path.exists(path):
            # Open the document
            if sys.platform == "win32":
                os.startfile(path)
            else:
                opener = "open" if sys.platform == "darwin" else "xdg-open"
                subprocess.call([opener, path])
        else:
            webbrowser.open(path)


    def tbl_event_clicked(self, table_name):

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
        row = tools_db.get_row(sql, log_sql=False)
        if not row:
            return

        # If gallery 'True' or 'False'
        if str(row[0]) == 'True':
            btn_open_gallery.setEnabled(True)

        # If document 'True' or 'False'
        if str(row[1]) == 'True':
            btn_open_visit_doc.setEnabled(True)


    def set_filter_table_event(self, widget):
        """ Get values selected by the user and sets a new filter for its table model """

        # Get selected dates
        visit_start = self.date_event_from.date()
        visit_end = self.date_event_to.date()
        date_from = visit_start.toString('yyyyMMdd 00:00:00')
        date_to = visit_end.toString('yyyyMMdd 23:59:59')
        if date_from > date_to:
            message = "Selected date interval is not valid"
            tools_qgis.show_warning(message)
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


    def set_filter_table_event2(self, widget):
        """ Get values selected by the user and sets a new filter for its table model """

        # Get selected dates
        visit_start = self.date_event_from.date()
        visit_end = self.date_event_to.date()
        date_from = visit_start.toString('yyyyMMdd 00:00:00')
        date_to = visit_end.toString('yyyyMMdd 23:59:59')
        if date_from > date_to:
            message = "Selected date interval is not valid"
            tools_qgis.show_warning(message)
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


    def open_visit(self):
        """ Call button 65: om_visit_management """

        manage_visit = GwVisitManager()
        manage_visit.visit_added.connect(self.update_visit_table)
        manage_visit.manage_visits(self.geom_type, self.feature_id)


    # creat the new visit GUI


    def update_visit_table(self):
        """ Convenience fuction set as slot to update table after a Visit GUI close. """
        table_name = "v_ui_event_x_" + self.geom_type
        tools_gw.set_dates_from_to(self.date_event_from, self.date_event_to, table_name, 'visit_start', 'visit_end')
        self.tbl_event_cf.model().select()


    def new_visit(self):
        """ Call button 64: om_add_visit """

        # Get expl_id to save it on om_visit and show the geometry of visit
        expl_id = tools_qt.get_combo_value(self.dlg_cf, self.tab_type + '_expl_id', 0)
        if expl_id == -1:
            msg = "Widget expl_id not found"
            tools_qgis.show_warning(msg)
            return

        manage_visit = GwVisitManager()
        manage_visit.visit_added.connect(self.update_visit_table)
        # TODO: the following query fix a (for me) misterious bug
        # the DB connection is not available during manage_visit.manage_visit first call
        # so the workaroud is to do a unuseful query to have the dao active
        sql = "SELECT id FROM om_visit LIMIT 1"
        tools_db.get_rows(sql)
        manage_visit.get_visit(geom_type=self.geom_type, feature_id=self.feature_id, expl_id=expl_id, is_new_from_cf=True)


    def open_gallery(self):
        """ Open gallery of selected record of the table """

        # Open Gallery
        gal = GwVisitGallery()
        gal.manage_gallery()
        gal.fill_gallery(self.visit_id, self.event_id)


    def open_visit_doc(self):
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
                # If path is URL open URL in browser
                webbrowser.open(path)
            else:
                # If its not URL ,check if file exist
                if not os.path.exists(path):
                    message = "File not found"
                    tools_qgis.show_warning(message, parameter=path)
                else:
                    # Open the document
                    os.startfile(path)

        else:
            # If more then one document is attached open dialog with list of documents
            self.dlg_load_doc = GwVisitDocumentUi()
            tools_gw.load_settings(self.dlg_load_doc)
            self.dlg_load_doc.rejected.connect(partial(tools_gw.close_dialog, self.dlg_load_doc))
            btn_open_doc = self.dlg_load_doc.findChild(QPushButton, "btn_open")
            btn_open_doc.clicked.connect(self.open_selected_doc)

            lbl_visit_id = self.dlg_load_doc.findChild(QLineEdit, "visit_id")
            lbl_visit_id.setText(str(self.visit_id))

            self.tbl_list_doc = self.dlg_load_doc.findChild(QListWidget, "tbl_list_doc")
            self.tbl_list_doc.itemDoubleClicked.connect(partial(self.open_selected_doc))
            for row in rows:
                item_doc = QListWidgetItem(str(row[0]))
                self.tbl_list_doc.addItem(item_doc)

            tools_gw.open_dialog(self.dlg_load_doc, dlg_name='visit_document')


    def open_selected_doc(self):

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
            # If path is URL open URL in browser
            webbrowser.open(path)
        else:
            # If its not URL ,check if file exist
            if not os.path.exists(path):
                message = "File not found"
                tools_qgis.show_warning(message, parameter=path)
            else:
                # Open the document
                os.startfile(path)


    """ FUNCTIONS RELATED WITH TAB DOC"""

    def fill_tab_document(self):
        """ Fill tab 'Document' """

        table_document = "v_ui_doc_x_" + self.geom_type
        self.fill_tbl_document_man(self.dlg_cf, self.tbl_document, table_document, self.filter)
        tools_gw.set_tablemodel_config(self.dlg_cf, self.tbl_document, table_document)


    def fill_tbl_document_man(self, dialog, widget, table_name, expr_filter):
        """ Fill the table control to show documents """

        if not self.feature:
            self.get_feature(self.tab_type)

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
            tools_qgis.show_warning(message)

        # Set signals
        doc_type.currentIndexChanged.connect(partial(self.set_filter_table_man, widget))
        self.date_document_to.dateChanged.connect(partial(self.set_filter_table_man, widget))
        self.date_document_from.dateChanged.connect(partial(self.set_filter_table_man, widget))
        self.tbl_document.doubleClicked.connect(partial(self.open_selected_document, widget))
        btn_open_doc.clicked.connect(partial(self.open_selected_document, widget))
        btn_doc_delete.clicked.connect(partial(self.delete_records, widget, table_name))
        btn_doc_insert.clicked.connect(partial(self.add_object, widget, "doc", "v_ui_doc"))
        btn_doc_new.clicked.connect(partial(self.manage_new_document, dialog, None, self.feature))

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
        self.set_filter_table_man(widget)


    def set_filter_table_man(self, widget):
        """ Get values selected by the user and sets a new filter for its table model """

        # Get selected dates
        date_from = self.date_document_from.date()
        date_to = self.date_document_to.date()
        if date_from > date_to:
            message = "Selected date interval is not valid"
            tools_qgis.show_warning(message)
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


    def open_selected_document(self, widget):
        """ Open selected document of the @widget """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return
        elif len(selected_list) > 1:
            message = "Select just one document"
            tools_qgis.show_warning(message)
            return

        # Get document path (can be relative or absolute)
        row = selected_list[0].row()
        path = widget.model().record(row).value("path")

        # Check if file exist
        if os.path.exists(path):
            # Open the document
            if sys.platform == "win32":
                os.startfile(path)
            else:
                opener = "open" if sys.platform == "darwin" else "xdg-open"
                subprocess.call([opener, path])
        else:
            webbrowser.open(path)


    def manage_new_document(self, dialog, doc_id=None, feature=None):
        """ Execute action of button 34 """

        doc = GwDocument()
        doc.get_document(feature=feature, geom_type=self.geom_type)
        doc.dlg_add_doc.accepted.connect(partial(self.manage_document_new, dialog, doc))
        doc.dlg_add_doc.rejected.connect(partial(self.manage_document_new, dialog, doc))

        # Set completer
        tools_gw.set_completer_object(dialog, self.table_object)
        if doc_id:
            tools_qt.set_widget_text(dialog, "doc_id", doc_id)

        # # Open dialog
        # doc.open_dialog(doc.dlg_add_doc)


    def manage_document_new(self, dialog, doc):
        """ Get inserted doc_id and add it to current feature """

        if doc.doc_id is None:
            return

        tools_qt.set_widget_text(dialog, "doc_id", doc.doc_id)
        self.add_object(self.tbl_document, "doc", "v_ui_doc")


    """ FUNCTIONS RELATED WITH TAB RPT """

    def fill_tab_rpt(self, complet_result, new_feature):

        complet_list, widget_list = self.init_tbl_rpt(complet_result, self.dlg_cf, new_feature)
        if complet_list is False:
            return False
        self.set_listeners(complet_result, self.dlg_cf, widget_list)
        return complet_list


    def init_tbl_rpt(self, complet_result, dialog, new_feature):
        """ Put filter widgets into layout and set headers into QTableView """

        rpt_layout1 = dialog.findChild(QGridLayout, "rpt_layout1")
        self.reset_grid_layout(rpt_layout1)
        index_tab = self.tab_main.currentIndex()
        tab_name = self.tab_main.widget(index_tab).objectName()
        complet_list = self.get_list(complet_result, tab_name=tab_name)
        if complet_list is False:
            return False, False

        # Put widgets into layout
        widget_list = []
        for field in complet_list['body']['data']['fields']:
            if 'hidden' in field and field['hidden']:
                continue
            label, widget = self.set_widgets(dialog, complet_list, field, new_feature)
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
                        widget.currentIndexChanged.connect(partial(self.get_combo_child, dialog, widget,
                                                           self.feature_type, self.tablename, self.field_id))

        return complet_list, widget_list


    def reset_grid_layout(self, layout):
        """  Remove all widgets of layout """

        while layout.count() > 0:
            child = layout.takeAt(0).widget()
            if child:
                child.setParent(None)
                child.deleteLater()


    def set_listeners(self, complet_result, dialog, widget_list):

        model = None
        for widget in widget_list:
            if type(widget) is QTableView:
                model = widget.model()
        for widget in widget_list:
            if type(widget) is QLineEdit:
                widget.editingFinished.connect(partial(self.filter_table, complet_result, model, dialog, widget_list))
            elif type(widget) is QComboBox:
                widget.currentIndexChanged.connect(partial(
                    self.filter_table, complet_result, model, dialog, widget_list))


    def get_list(self, complet_result, form_name='', tab_name='', filter_fields=''):

        form = f'"formName":"{form_name}", "tabName":"{tab_name}"'
        id_name = complet_result['body']['feature']['idName']
        feature = f'"tableName":"{self.tablename}", "idName":"{id_name}", "id":"{self.feature_id}"'
        body = tools_gw.create_body(form, feature, filter_fields)
        function_name = 'gw_fct_getlist'
        json_result = tools_gw.get_json(function_name, body)
        if json_result is None or json_result['status'] == 'Failed':
            return False
        complet_list = json_result
        if not complet_list:
            return False

        return complet_list


    def filter_table(self, complet_result, standar_model, dialog, widget_list):

        filter_fields = self.get_filter_qtableview(standar_model, dialog, widget_list)
        index_tab = self.tab_main.currentIndex()
        tab_name = self.tab_main.widget(index_tab).objectName()
        complet_list = self.get_list(complet_result, tab_name=tab_name, filter_fields=filter_fields)
        if complet_list is False:
            return False

        for field in complet_list['body']['data']['fields']:
            if field['widgettype'] == "tableview":
                qtable = dialog.findChild(QTableView, field['widgetname'])
                if qtable:
                    tools_gw.add_tableview_header(qtable, field)
                    tools_gw.fill_tableview_rows(qtable, field)

        return complet_list


    def get_filter_qtableview(self, standar_model, dialog, widget_list):

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


    def gw_api_open_rpt_result(self, widget, complet_result):
        self.open_rpt_result(widget, complet_result)


    def open_rpt_result(self, qtable, complet_list):
        """ Open form of selected element of the @widget?? """

        # Get selected rows
        selected_list = qtable.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
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

    def fill_tab_plan(self, complet_result):

        plan_layout = self.dlg_cf.findChild(QGridLayout, 'plan_layout')

        if self.geom_type == 'arc' or self.geom_type == 'node':
            index_tab = self.tab_main.currentIndex()
            tab_name = self.tab_main.widget(index_tab).objectName()
            form = f'"tabName":"{tab_name}"'
            feature = f'"featureType":"{complet_result["body"]["feature"]["featureType"]}", '
            feature += f'"tableName":"{self.tablename}", '
            feature += f'"idName":"{self.field_id}", '
            feature += f'"id":"{self.feature_id}"'
            body = tools_gw.create_body(form, feature, filter_fields='')
            json_result = tools_gw.get_json('gw_fct_getinfoplan', body)
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
                        widget = self.add_label(field)
                        widget.setAlignment(Qt.AlignRight)
                        label.setWordWrap(True)
                        plan_layout.addWidget(label, field['layoutorder'], 0)
                        plan_layout.addWidget(widget, field['layoutorder'], 1)

                plan_vertical_spacer = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
                plan_layout.addItem(plan_vertical_spacer)


    def add_label(self, field):
        """ Add widgets QLineEdit type """

        widget = QLabel()
        widget.setTextInteractionFlags(Qt.TextSelectableByMouse)
        widget.setObjectName(field['widgetname'])
        if 'columnname' in field:
            widget.setProperty('columnname', field['columnname'])
        if 'value' in field:
            widget.setText(field['value'])

        return widget


    def get_catalog(self, form_name, table_name, feature_type, feature_id, field_id, list_points):
        form = f'"formName":"{form_name}", "tabName":"data", "editable":"TRUE"'
        feature = f'"tableName":"{table_name}", "featureId":"{feature_id}", "feature_type":"{feature_type}"'
        extras = f'"coordinates":{{{list_points}}}'
        body = tools_gw.create_body(form, feature, extras=extras)
        json_result = tools_gw.get_json('gw_fct_getcatalog', body, log_sql=True)
        if json_result is None:
            return

        dlg_generic = GwInfoGenericUi()
        tools_gw.load_settings(dlg_generic)

        # Set signals
        dlg_generic.btn_close.clicked.connect(partial(tools_gw.close_dialog, dlg_generic))
        dlg_generic.rejected.connect(partial(tools_gw.close_dialog, dlg_generic))
        dlg_generic.btn_accept.clicked.connect(partial(self.set_catalog, dlg_generic, form_name, table_name))

        tools_gw.build_dialog_info(dlg_generic, json_result)

        # Open dialog
        dlg_generic.setWindowTitle(f"{(form_name.lower()).capitalize().replace('_', ' ')}")
        tools_gw.open_dialog(dlg_generic)


    def set_catalog(self, dialog, form_name, table_name):
        """ Insert table 'cat_work'. Add cat_work """

        # Manage mandatory fields
        missing_mandatory = False
        widgets = dialog.findChildren(QWidget)
        for widget in widgets:
            widget.setStyleSheet(None)
            # Check mandatory fields
            if widget.property('ismandatory') and tools_qt.get_text(dialog, widget, False, False) in (None, ''):
                missing_mandatory = True
                tools_qt.set_stylesheet(widget, "border: 2px solid red")
        if missing_mandatory:
            message = "Mandatory field is missing. Please, set a value"
            tools_qgis.show_warning(message)
            return

        # Get widgets values
        values = {}
        for widget in widgets:
            if widget.property('columnname') in (None, ''): continue
            values = tools_gw.get_values(dialog, widget, values)
        fields = json.dumps(values)

        # Call gw_fct_setcatalog
        fields = f'"fields":{fields}'
        form = f'"formName":"{form_name}"'
        feature = f'"tableName":"{table_name}"'
        body = tools_gw.create_body(form, feature, extras=fields)
        result = tools_gw.get_json('gw_fct_setcatalog', body, log_sql=True)
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

        tools_gw.close_dialog(dialog)


    def get_snapped_feature_id(self, dialog, action, layer_name, option, widget_name):
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

        self.vertex_marker = QgsVertexMarker(self.canvas)
        self.vertex_marker.setColor(QColor(255, 100, 255))
        self.vertex_marker.setIconSize(15)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)
        self.vertex_marker.setPenWidth(3)

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
        self.canvas.xyCoordinates.connect(partial(self.mouse_moved, layer))
        emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(emit_point)
        emit_point.canvasClicked.connect(partial(self.get_id, dialog, action, option, emit_point))


    def mouse_moved(self, layer, point):
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


    def get_id(self, dialog, action, option, emit_point, point, event):

        """ Get selected attribute from snapped feature """
        # @options{'key':['att to get from snapped feature', 'widget name destination']}
        options = {'arc': ['arc_id', 'data_arc_id'], 'node': ['node_id', 'data_parent_id'],
                   'set_to_arc': ['arc_id', 'set_to_arc']}

        if event == Qt.RightButton:
            tools_qgis.disconnect_snapping(False, None, self.vertex_marker)
            self.cancel_snapping_tool(dialog, action)
            return

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
            # functions called in -> getattr(self, options[option][0])(feat_id) --> def set_to_arc(self, feat_id)
            getattr(self, options[option][1])(feat_id)
        self.snapper_manager.recover_snapping_options()
        self.cancel_snapping_tool(dialog, action)


    def set_to_arc(self, feat_id):
        """  Function called in def get_id(self, dialog, action, option, point, event):
                getattr(self, options[option][1])(feat_id)
        :param feat_id: Id of the snapped feature
        :return:
        """
        w_dma_id = self.dlg_cf.findChild(QComboBox, 'data_dma_id')
        dma_id = tools_qt.get_combo_value(self.dlg_cf, w_dma_id)
        w_presszone_id = self.dlg_cf.findChild(QComboBox, 'data_presszone_id')
        presszone_id = tools_qt.get_combo_value(self.dlg_cf, w_presszone_id)
        w_sector_id = self.dlg_cf.findChild(QComboBox, 'data_sector_id')
        sector_id = tools_qt.get_combo_value(self.dlg_cf, w_sector_id)
        w_dqa_id = self.dlg_cf.findChild(QComboBox, 'data_dqa_id')
        dqa_id = tools_qt.get_combo_value(self.dlg_cf, w_dqa_id)

        feature = f'"featureType":"{self.feature_type}", "id":"{self.feature_id}"'
        extras = (f'"arcId":"{feat_id}", "dmaId":"{dma_id}", "presszoneId":"{presszone_id}", "sectorId":"{sector_id}", '
                  f'"dqaId":"{dqa_id}"')
        body = tools_gw.create_body(feature=feature, extras=extras)
        json_result = tools_gw.get_json('gw_fct_settoarc', body, log_sql=True)
        if 'status' in json_result and json_result['status'] == 'Accepted':
            if json_result['message']:
                level = 1
                if 'level' in json_result['message']:
                    level = int(json_result['message']['level'])
                tools_qgis.show_message(json_result['message']['text'], level)


    def cancel_snapping_tool(self, dialog, action):

        tools_qgis.disconnect_snapping(False, None, self.vertex_marker)
        dialog.blockSignals(False)
        action.setChecked(False)
        self.signal_activate.emit()


    """ OTHER FUNCTIONS """

    def set_image(self, dialog, widget):
        tools_qt.add_image(dialog, widget, "ws_shape.png")



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


    def add_feature(self, feature_cat):
        """ Button 01, 02: Add 'node' or 'arc' """
        global is_inserting
        if is_inserting:
            msg = "You cannot insert more than one feature at the same time, finish editing the previous feature"
            tools_qgis.show_message(msg)
            return

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Set snapping to 'node', 'connec' and 'gully'
        self.snapper_manager.config_snap_to_arc()
        self.snapper_manager.config_snap_to_node()
        self.snapper_manager.config_snap_to_connec()
        self.snapper_manager.config_snap_to_gully()
        self.snapper_manager.set_snap_mode()
        self.iface.actionAddFeature().toggled.connect(self.action_is_checked)

        self.feature_cat = feature_cat
        # self.info_layer must be global because apparently the disconnect signal is not disconnected correctly if
        # parameters are passed to it
        self.info_layer = tools_qgis.get_layer_by_tablename(feature_cat.parent_layer)
        if self.info_layer:
            self.suppres_form = QSettings().value("/Qgis/digitizing/disable_enter_attribute_values_dialog")
            QSettings().setValue("/Qgis/digitizing/disable_enter_attribute_values_dialog", True)
            config = self.info_layer.editFormConfig()
            self.conf_supp = config.suppress()
            config.setSuppress(0)
            self.info_layer.setEditFormConfig(config)
            self.iface.setActiveLayer(self.info_layer)
            self.info_layer.startEditing()
            self.iface.actionAddFeature().trigger()
            self.info_layer.featureAdded.connect(self.open_new_feature)
        else:
            message = "Layer not found"
            tools_qgis.show_warning(message, parameter=feature_cat.parent_layer)


    def action_is_checked(self):
        """ Recover snapping options when action add feature is un-checked """
        if not self.iface.actionAddFeature().isChecked():
            self.snapper_manager.recover_snapping_options()
            self.iface.actionAddFeature().toggled.disconnect(self.action_is_checked)


    def open_new_feature(self, feature_id):
        """
        :param feature_id: Parameter sent by the featureAdded method itself
        :return:
        """

        self.snapper_manager.recover_snapping_options()
        self.info_layer.featureAdded.disconnect(self.open_new_feature)
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
            tools_log.log_info(str(type("NO FEATURE TYPE DEFINED")))

        tools_gw.init_docker()
        global is_inserting
        is_inserting = True

        self.info_feature = GwInfo('data')
        result, dialog = self.info_feature.get_feature_insert(point=list_points, feature_cat=self.feature_cat,
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


    def get_combo_child(self, dialog, widget, feature_type, tablename, field_id):
        """ Find QComboBox child and populate it
        :param dialog: QDialog
        :param widget: QComboBox parent
        :param feature_type: PIPE, ARC, JUNCTION, VALVE...
        :param tablename: view of DB
        :param field_id: Field id of tablename
        """

        combo_parent = widget.property('columnname')
        combo_id = tools_qt.get_combo_value(dialog, widget)

        feature = f'"featureType":"{feature_type}", '
        feature += f'"tableName":"{tablename}", '
        feature += f'"idName":"{field_id}"'
        extras = f'"comboParent":"{combo_parent}", "comboId":"{combo_id}"'
        body = tools_gw.create_body(feature=feature, extras=extras)
        result = tools_gw.get_json('gw_fct_getchilds', body)
        if not result or result['status'] == 'Failed':
            return False

        for combo_child in result['body']['data']:
            if combo_child is not None:
                tools_gw.manage_combo_child(dialog, widget, combo_child)
