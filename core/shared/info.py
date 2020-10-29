"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: latin-1 -*-
from qgis.core import QgsMapToPixel, QgsVectorLayer, QgsExpression, QgsFeatureRequest, QgsPointXY
from qgis.gui import QgsDateTimeEdit, QgsVertexMarker, QgsMapToolEmitPoint, QgsRubberBand
from qgis.PyQt.QtCore import pyqtSignal, QDate, QObject, QRegExp, QStringListModel, Qt
from qgis.PyQt.QtGui import QColor, QRegExpValidator, QStandardItem, QStandardItemModel
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QAction, QAbstractItemView, QCheckBox, QComboBox, QCompleter, QDoubleSpinBox, \
    QDateEdit, QGridLayout, QLabel, QLineEdit, QListWidget, QListWidgetItem, QPushButton, QSizePolicy, \
    QSpinBox, QSpacerItem, QTableView, QTabWidget, QWidget, QTextEdit

import json
import os
import subprocess
import urllib.parse as parse
import sys
import webbrowser
from collections import OrderedDict
from functools import partial
from sip import isdeleted

from ... import global_vars
from .catalog import GwCatalog
from .dimensioning import GwDimensioning
from .document import GwDocument
from .element import GwElement
from .visit_gallery import GwVisitGallery
from .visit_manager import GwVisitManager
from ..utils.tools_giswater import load_settings, open_dialog, save_settings, close_dialog, create_body, draw, \
    draw_point, populate_info_text_ as populate_info_text, snap_to_layer, snap_to_arc, snap_to_node
from ..ui.ui_manager import InfoGenericUi, InfoFeatureUi, VisitEventFull, GwMainWindow, VisitDocument, InfoCrossectUi, \
    DialogTextUi
from ...lib.tools_qgis import get_snapping_options, get_event_point, snap_to_current_layer, get_snapped_layer, \
    get_snapped_feature, add_marker, enable_snapping, apply_snapping_options, get_feature_by_expr, get_visible_layers
from ...lib.tools_qt import set_completer_object_api, set_completer_object, check_actions, api_action_help, \
    set_widget_size, add_button, add_textarea, add_lineedit, set_data_type, manage_lineedit, add_tableview, \
    set_headers, populate_table, set_columns_config, add_checkbox, add_combobox, fill_child, add_frame, add_label, \
    add_hyperlink, add_horizontal_spacer, add_vertical_spacer, add_spinbox, fill_table, populate_basic_info, \
    add_calendar, put_widgets, get_values, set_setStyleSheet, disable_all, enable_all, clear_gridlayout, set_icon, \
    set_dates_from_to, getWidgetText, get_item_data, isChecked, getCalendarDate, set_qtv_config, remove_tab_by_tabName,\
    setWidgetText, getWidgetType, set_combo_itemData, setImage, get_col_index_by_col_name, set_item_data, \
    GwHyperLinkLabel


class GwInfo(QObject):

    # :var signal_activate: emitted from def cancel_snapping_tool(self, dialog, action) in order to re-start CadApiInfo
    signal_activate = pyqtSignal()

    def __init__(self, tab_type):
        """ Class constructor """

        super().__init__()

        self.iface = global_vars.iface
        self.settings = global_vars.settings
        self.controller = global_vars.controller
        self.plugin_dir = global_vars.plugin_dir
        self.canvas = global_vars.canvas
        self.schema_name = global_vars.schema_name

        self.new_feature_id = None
        self.layer_new_feature = None
        self.tab_type = tab_type
        self.connected = False
        self.rubber_band = QgsRubberBand(self.canvas, 0)


    def get_info_from_coordinates(self, point, tab_type):
        return self.open_form(point=point, tab_type=tab_type)


    def get_info_from_id(self, table_name, feature_id, tab_type=None, is_add_schema=None):
        return self.open_form(table_name=table_name, feature_id=feature_id, tab_type=tab_type, is_add_schema=is_add_schema)


    def get_feature_insert(self, point, feature_cat, new_feature_id, layer_new_feature, tab_type, new_feature):
        return self.open_form(point=point, feature_cat=feature_cat, new_feature_id=new_feature_id, layer_new_feature=layer_new_feature, tab_type=tab_type, new_feature=new_feature)


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
            active_layer = self.controller.get_layer_source_table_name(self.iface.activeLayer())

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
            body = create_body(feature=feature, extras=extras)
            function_name = 'gw_fct_getfeatureinsert'

        # Click over canvas
        elif point:
            visible_layer = get_visible_layers(as_list=True)
            scale_zoom = self.iface.mapCanvas().scale()
            extras += f', "activeLayer":"{active_layer}"'
            extras += f', "visibleLayer":{visible_layer}'
            extras += f', "mainSchema":"{qgis_project_main_schema}"'
            extras += f', "addSchema":"{qgis_project_add_schema}"'
            extras += f', "infoType":"{qgis_project_infotype}"'
            extras += f', "projecRole":"{qgis_project_role}"'
            extras += f', "coordinates":{{"xcoord":{point.x()},"ycoord":{point.y()}, "zoomRatio":{scale_zoom}}}'
            body = create_body(extras=extras)
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
            body = create_body(feature=feature, extras=extras)
            function_name = 'gw_fct_getinfofromid'

        if function_name is None:
            return False, None

        json_result = self.controller.get_json(function_name, body, rubber_band=self.rubber_band, log_sql=True)
        if json_result is None:
            return False, None

        row = [json_result]
        if not row or row[0] is False:
            return False, None

        # When insert feature failed
        if 'status' in row[0] and row[0]['status'] == 'Failed':
            return False, None

        # When something is wrong
        if 'message' in row[0] and row[0]['message']:
            level = 1
            if 'level' in row[0]['message']:
                level = int(row[0]['message']['level'])
            self.controller.show_message(row[0]['message']['text'], level)
            return False, None

        # Control fail when insert new feature
        if 'status' in row[0]['body']['data']['fields']:
            if row[0]['body']['data']['fields']['status'].lower() == 'failed':
                msg = row[0]['body']['data']['fields']['message']['text']
                level = 1
                if 'level' in row[0]['body']['data']['fields']['message']:
                    level = int(row[0]['body']['data']['fields']['message']['level'])
                self.controller.show_message(msg, message_level=level)
                return False, None

        self.complet_result = row
        try:
            template = self.complet_result[0]['body']['form']['template']
        except Exception as e:
            self.controller.log_info(str(e))
            return False, None

        if template == 'info_generic':
            result, dialog = self.open_generic_form(self.complet_result)
            # Fill self.my_json for new qgis_feature
            if feature_cat is not None:
                self.manage_new_feature(self.complet_result, dialog)
            return result, dialog

        elif template == 'dimensioning':
            self.lyr_dim = self.controller.get_layer_by_tablename("v_edit_dimensions", show_warning=True)
            if self.lyr_dim:
                self.api_dim = GwDimensioning()
                feature_id = self.complet_result[0]['body']['feature']['id']
                result, dialog = self.api_dim.open_dimensioning_form(None, self.lyr_dim, self.complet_result, feature_id, self.rubber_band)
                return result, dialog

        elif template == 'info_feature':
            sub_tag = None
            if feature_cat:
                if feature_cat.feature_type.lower() == 'arc':
                    sub_tag = 'arc'
                else:
                    sub_tag = 'node'
            feature_id = self.complet_result[0]['body']['feature']['id']
            result, dialog = self.open_custom_form(feature_id, self.complet_result, tab_type, sub_tag, is_docker, new_feature=new_feature)
            if feature_cat is not None:
                self.manage_new_feature(self.complet_result, dialog)
            return result, dialog

        elif template == 'visit':
            visit_id = self.complet_result[0]['body']['feature']['id']
            layers_visibility = self.get_layers_visibility()
            manage_visit = GwVisitManager()
            manage_visit.manage_visit(visit_id=visit_id, tag='info')
            manage_visit.dlg_add_visit.rejected.connect(partial(self.restore_layers_visibility, layers_visibility))

        else:
            self.controller.log_warning(f"template not managed: {template}")
            return False, None


    def get_layers_visibility(self):

        layers = self.controller.get_layers()
        layers_visibility = {}
        for layer in layers:

            layers_visibility[layer] = self.controller.is_layer_visible(layer)
        return layers_visibility


    def restore_layers_visibility(self, layers):

        for layer, visibility in layers.items():
            self.controller.set_layer_visible(layer, visibility)


    def manage_new_feature(self, complet_result, dialog):

        result = complet_result[0]['body']['data']
        for field in result['fields']:
            if 'hidden' in field and field['hidden']: continue
            if 'layoutname' in field and field['layoutname'] == 'lyt_none': continue
            widget = dialog.findChild(QWidget, field['widgetname'])
            value = None
            if type(widget) in(QLineEdit, QPushButton, QSpinBox, QDoubleSpinBox):
                value = getWidgetText(dialog, widget, return_string_null=False)
            elif type(widget) is QComboBox:
                value = get_item_data(dialog, widget, 0)
            elif type(widget) is QCheckBox:
                value = isChecked(dialog, widget)
            elif type(widget) is QgsDateTimeEdit:
                value = getCalendarDate(dialog, widget)
            else:
                if widget is None:
                    msg = f"Widget {field['columnname']} is not configured or have a bad config"
                    self.controller.show_message(msg)

            if str(value) not in ('', None, -1, "None") and widget.property('columnname'):
                self.my_json[str(widget.property('columnname'))] = str(value)

        self.controller.log_info(str(self.my_json))


    def open_generic_form(self, complet_result):

        draw(complet_result, self.rubber_band, zoom=False)
        self.hydro_info_dlg = InfoGenericUi()
        load_settings(self.hydro_info_dlg)
        self.hydro_info_dlg.btn_close.clicked.connect(partial(close_dialog, self.hydro_info_dlg))
        self.hydro_info_dlg.rejected.connect(partial(close_dialog, self.hydro_info_dlg))
        field_id = str(self.complet_result[0]['body']['feature']['idName'])
        result = populate_basic_info(self.hydro_info_dlg, complet_result, field_id, self.my_json,
                 new_feature_id=self.new_feature_id, new_feature=self.new_feature, layer_new_feature=self.layer_new_feature,
                 feature_id=self.feature_id, feature_type=self.feature_type, layer=self.layer)

        # Disable button accept for info on generic form
        self.hydro_info_dlg.btn_accept.setEnabled(False)
        self.hydro_info_dlg.rejected.connect(self.rubber_band.reset)
        # Open dialog
        open_dialog(self.hydro_info_dlg, dlg_name='info_generic')

        return result, self.hydro_info_dlg


    def open_custom_form(self, feature_id, complet_result, tab_type=None, sub_tag=None, is_docker=True, new_feature=None):

        # Dialog
        self.dlg_cf = InfoFeatureUi(sub_tag)
        load_settings(self.dlg_cf)

        # If in the get_json function we have received a rubberband, it is not necessary to redraw it.
        # But if it has not been received, it is drawn
        try:
            exist_rb = complet_result[0]['body']['returnManager']['style']['ruberband']
        except KeyError:
            draw(complet_result[0], self.rubber_band)

        if feature_id:
            self.dlg_cf.setGeometry(self.dlg_cf.pos().x() + 25, self.dlg_cf.pos().y() + 25, self.dlg_cf.width(),
                                    self.dlg_cf.height())

        # Get widget controls
        self.tab_main = self.dlg_cf.findChild(QTabWidget, "tab_main")
        self.tab_main.currentChanged.connect(partial(self.tab_activation, self.dlg_cf, new_feature))
        self.tbl_element = self.dlg_cf.findChild(QTableView, "tbl_element")
        set_qtv_config(self.tbl_element)
        self.tbl_relations = self.dlg_cf.findChild(QTableView, "tbl_relations")
        set_qtv_config(self.tbl_relations)
        self.tbl_upstream = self.dlg_cf.findChild(QTableView, "tbl_upstream")
        set_qtv_config(self.tbl_upstream)
        self.tbl_downstream = self.dlg_cf.findChild(QTableView, "tbl_downstream")
        set_qtv_config(self.tbl_downstream)
        self.tbl_hydrometer = self.dlg_cf.findChild(QTableView, "tbl_hydrometer")
        set_qtv_config(self.tbl_hydrometer)
        self.tbl_hydrometer_value = self.dlg_cf.findChild(QTableView, "tbl_hydrometer_value")
        set_qtv_config(self.tbl_hydrometer_value, QAbstractItemView.SelectItems, QTableView.CurrentChanged)
        self.tbl_event_cf = self.dlg_cf.findChild(QTableView, "tbl_event_cf")
        set_qtv_config(self.tbl_event_cf)
        self.tbl_document = self.dlg_cf.findChild(QTableView, "tbl_document")
        set_qtv_config(self.tbl_document)

        # Get table name
        self.tablename = complet_result[0]['body']['feature']['tableName']

        # Get feature type (Junction, manhole, valve, fountain...)
        self.feature_type = complet_result[0]['body']['feature']['childType']

        # Get tableParent and select layer
        self.table_parent = str(complet_result[0]['body']['feature']['tableParent'])
        schema_name = str(complet_result[0]['body']['feature']['schemaName'])
        self.layer = self.controller.get_layer_by_tablename(self.table_parent, False, False, schema_name)
        if self.layer is None:
            self.controller.show_message("Layer not found: " + self.table_parent, 2)
            return False, self.dlg_cf

        # Remove unused tabs
        tabs_to_show = []

        # Get field id name and feature id
        self.field_id = str(complet_result[0]['body']['feature']['idName'])
        self.feature_id = complet_result[0]['body']['feature']['id']

        if 'visibleTabs' in complet_result[0]['body']['form']:
            for tab in complet_result[0]['body']['form']['visibleTabs']:
                tabs_to_show.append(tab['tabName'])

        for x in range(self.tab_main.count() - 1, 0, -1):
            if self.tab_main.widget(x).objectName() not in tabs_to_show:
                remove_tab_by_tabName(self.tab_main, self.tab_main.widget(x).objectName())

        # Actions
        action_edit = self.dlg_cf.findChild(QAction, "actionEdit")
        action_copy_paste = self.dlg_cf.findChild(QAction, "actionCopyPaste")
        action_rotation = self.dlg_cf.findChild(QAction, "actionRotation")
        action_catalog = self.dlg_cf.findChild(QAction, "actionCatalog")
        action_workcat = self.dlg_cf.findChild(QAction, "actionWorkcat")
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
            action_edit.setEnabled(self.complet_result[0]['body']['feature']['permissions']['isEditable'])
        except KeyError:
            pass

        # Set actions icon
        set_icon(action_edit, "101")
        set_icon(action_copy_paste, "107b")
        set_icon(action_rotation, "107c")
        set_icon(action_catalog, "195")
        set_icon(action_workcat, "193")
        set_icon(action_get_arc_id, "209")
        set_icon(action_get_parent_id, "210")
        set_icon(action_zoom_in, "103")
        set_icon(action_zoom_out, "107")
        set_icon(action_centered, "104")
        set_icon(action_link, "173")
        set_icon(action_section, "207")
        set_icon(action_help, "73")
        set_icon(action_interpolate, "194")
        # self.set_icon(action_switch_arc_id, "141")

        # Set buttons icon
        # tab elements
        set_icon(self.dlg_cf.btn_insert, "111b")
        set_icon(self.dlg_cf.btn_delete, "112b")
        set_icon(self.dlg_cf.btn_new_element, "131b")
        set_icon(self.dlg_cf.btn_open_element, "134b")
        # tab hydrometer
        set_icon(self.dlg_cf.btn_link, "70b")
        # tab om
        set_icon(self.dlg_cf.btn_open_visit, "65b")
        set_icon(self.dlg_cf.btn_new_visit, "64b")
        set_icon(self.dlg_cf.btn_open_gallery, "136b")
        set_icon(self.dlg_cf.btn_open_visit_doc, "170b")
        set_icon(self.dlg_cf.btn_open_visit_event, "134b")
        # tab doc
        set_icon(self.dlg_cf.btn_doc_insert, "111b")
        set_icon(self.dlg_cf.btn_doc_delete, "112b")
        set_icon(self.dlg_cf.btn_doc_new, "131b")
        set_icon(self.dlg_cf.btn_open_doc, "170b")

        # Get feature type as geom_type (node, arc, connec, gully)
        self.geom_type = str(complet_result[0]['body']['feature']['featureType'])
        if str(self.geom_type) in ('', '[]'):
            if 'feature_cat' in globals():
                parent_layer = self.feature_cat.parent_layer
            else:
                parent_layer = str(complet_result[0]['body']['feature']['tableParent'])
            sql = f"SELECT lower(feature_type) FROM cat_feature WHERE parent_layer = '{parent_layer}' LIMIT 1"
            result = self.controller.get_row(sql)
            if result:
                self.geom_type = result[0]

        result = complet_result[0]['body']['data']
        layout_list = []
        for field in complet_result[0]['body']['data']['fields']:
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
                    put_widgets(self.dlg_cf, field, label, widget)

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
                        widget.currentIndexChanged.connect(partial(fill_child, self.dlg_cf, widget,
                            self.feature_type, self.tablename, self.field_id))

        # Set variables
        self.filter = str(complet_result[0]['body']['feature']['idName']) + " = '" + str(self.feature_id) + "'"
        dlg_cf = self.dlg_cf
        layer = self.layer
        fid = self.feature_id
        my_json = self.my_json
        if layer:
            if layer.isEditable():
                enable_all(dlg_cf, self.complet_result[0]['body']['data'])
            else:
                disable_all(dlg_cf, self.complet_result[0]['body']['data'], False)


        # We assign the function to a global variable,
        # since as it receives parameters we will not be able to disconnect the signals
        self.fct_block_action_edit = lambda: self.block_action_edit(dlg_cf, action_edit, result, layer, fid, my_json, new_feature)
        self.fct_start_editing = lambda: self.start_editing(dlg_cf, action_edit, complet_result[0]['body']['data'], layer)
        self.fct_stop_editing = lambda: self.stop_editing(dlg_cf, action_edit, layer, fid, self.my_json, new_feature)
        self.connect_signals()

        self.enable_actions(dlg_cf, layer.isEditable())

        action_edit.setChecked(layer.isEditable())
        # Actions signals
        action_edit.triggered.connect(partial(self.manage_edition, dlg_cf, action_edit, fid, new_feature))
        action_catalog.triggered.connect(partial(self.open_catalog, tab_type, self.feature_type))
        action_workcat.triggered.connect(partial(self.cf_new_workcat, tab_type))
        action_get_arc_id.triggered.connect(partial(self.get_snapped_feature_id, self.dlg_cf, action_get_arc_id, 'arc', 'data_arc_id'))
        action_get_parent_id.triggered.connect(partial(self.get_snapped_feature_id, self.dlg_cf, action_get_parent_id, 'node', 'data_parent_id'))
        action_zoom_in.triggered.connect(partial(self.api_action_zoom_in, self.canvas, self.layer))
        action_centered.triggered.connect(partial(self.api_action_centered, self.canvas, self.layer))
        action_zoom_out.triggered.connect(partial(self.api_action_zoom_out, self.canvas, self.layer))
        action_copy_paste.triggered.connect(partial(self.api_action_copy_paste, self.dlg_cf, self.geom_type, tab_type))
        action_rotation.triggered.connect(partial(self.change_hemisphere, self.dlg_cf))
        action_link.triggered.connect(partial(self.action_open_url, self.dlg_cf, result))
        action_section.triggered.connect(partial(self.open_section_form))
        action_help.triggered.connect(partial(api_action_help, self.geom_type))
        self.ep = QgsMapToolEmitPoint(self.canvas)
        action_interpolate.triggered.connect(partial(self.activate_snapping, complet_result, self.ep))

        btn_cancel = self.dlg_cf.findChild(QPushButton, 'btn_cancel')
        btn_accept = self.dlg_cf.findChild(QPushButton, 'btn_accept')
        title = f"{complet_result[0]['body']['feature']['childType']} - {self.feature_id}"

        if self.controller.dlg_docker and is_docker and self.controller.show_docker:
            # Delete last form from memory
            last_info = self.controller.dlg_docker.findChild(GwMainWindow, 'api_cf')
            if last_info:
                last_info.setParent(None)
                del last_info

            self.controller.dock_dialog(dlg_cf)
            self.controller.dlg_docker.dlg_closed.connect(self.manage_docker_close)
            self.controller.dlg_docker.setWindowTitle(title)
            btn_cancel.clicked.connect(self.manage_docker_close)

        else:
            dlg_cf.dlg_closed.connect(self.roll_back)
            dlg_cf.dlg_closed.connect(lambda: self.rubber_band.reset())
            dlg_cf.dlg_closed.connect(partial(save_settings, dlg_cf))
            dlg_cf.key_pressed.connect(partial(close_dialog, dlg_cf))
            btn_cancel.clicked.connect(partial(self.manage_info_close, dlg_cf))
        btn_accept.clicked.connect(partial(self.accept_from_btn, dlg_cf, action_edit, new_feature, self.my_json))

        # Set title
        toolbox_cf = self.dlg_cf.findChild(QWidget, 'toolBox')
        row = self.controller.get_config('admin_customform_param', 'value', 'config_param_system')
        if row:
            results = json.loads(row[0], object_pairs_hook=OrderedDict)
            for result in results['custom_form_tab_labels']:
                toolbox_cf.setItemText(int(result['index']), result['text'])

        # Open dialog
        open_dialog(self.dlg_cf, dlg_name='info_feature')
        self.dlg_cf.setWindowTitle(title)

        return self.complet_result, self.dlg_cf


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
        except Exception as e:
            pass

        try:
            self.layer.editingStopped.disconnect(self.fct_stop_editing)
        except Exception as e:
            pass

        try:
            self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').toggled.disconnect(self.fct_block_action_edit)
        except Exception as e:
            pass
        self.connected = False
        self.controller.is_inserting = False


    def activate_snapping(self, complet_result, ep):

        rb_interpolate = []
        self.interpolate_result = None
        self.rubber_band.reset()
        dlg_dtext = DialogTextUi()
        load_settings(dlg_dtext)

        setWidgetText(dlg_dtext, dlg_dtext.txt_infolog, 'Interpolate tool')
        dlg_dtext.lbl_text.setText("Please, use the cursor to select two nodes to proceed with the "
                                   "interpolation\nNode1: \nNode2:")

        dlg_dtext.btn_accept.clicked.connect(partial(self.chek_for_existing_values, dlg_dtext))
        dlg_dtext.btn_close.clicked.connect(partial(close_dialog, dlg_dtext))
        dlg_dtext.rejected.connect(partial(save_settings, dlg_dtext))
        dlg_dtext.rejected.connect(partial(self.remove_interpolate_rb, rb_interpolate))

        open_dialog(dlg_dtext, dlg_name='dialog_text')

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
        draw(complet_result[0], self.rubber_band, None, False)

        # Store user snapping configuration
        self.previous_snapping = get_snapping_options

        self.layer_node = global_vars.controller.get_layer_by_tablename("v_edit_node")
        global_vars.iface.setActiveLayer(self.layer_node)

        global_vars.canvas.xyCoordinates.connect(partial(self.mouse_move))
        ep.canvasClicked.connect(partial(self.snapping_node, ep, dlg_dtext, rb_interpolate))


    def snapping_node(self, ep, dlg_dtext, rb_interpolate, point, button):
        """ Get id of selected nodes (node1 and node2) """

        if button == 2:
            self.dlg_destroyed(self.layer)
            return

        # Get coordinates
        event_point = get_event_point(point=point)
        if not event_point:
            return
        # Snapping
        result = snap_to_current_layer(event_point)
        if result.isValid():
            layer = get_snapped_layer(result)
            # Check feature
            if layer == self.layer_node:
                snapped_feat = get_snapped_feature(result)
                element_id = snapped_feat.attribute('node_id')
                message = "Selected node"
                rb = QgsRubberBand(global_vars.canvas, 0)
                if self.node1 is None:
                    self.node1 = str(element_id)
                    draw_point(QgsPointXY(result.point()), rb, color=QColor(0, 150, 55, 100), width=10, is_new=True)
                    rb_interpolate.append(rb)
                    dlg_dtext.lbl_text.setText(f"Node1: {self.node1}\nNode2:")
                    global_vars.controller.show_message(message, message_level=0, parameter=self.node1)
                elif self.node1 != str(element_id):
                    self.node2 = str(element_id)
                    draw_point(QgsPointXY(result.point()), rb, color=QColor(
                        0, 150, 55, 100), width=10, is_new=True)
                    rb_interpolate.append(rb)
                    dlg_dtext.lbl_text.setText(f"Node1: {self.node1}\nNode2: {self.node2}")
                    global_vars.controller.show_message(message, message_level=0, parameter=self.node2)

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
            body = create_body(extras=extras)
            self.interpolate_result = global_vars.controller.get_json('gw_fct_node_interpolate', body)
            populate_info_text(dlg_dtext, self.interpolate_result['body']['data'])


    def chek_for_existing_values(self, dlg_dtext):

        text = False
        for k, v in self.interpolate_result['body']['data']['fields'][0].items():
            widget = self.dlg_cf.findChild(QWidget, k)
            if widget:
                text = getWidgetText(self.dlg_cf, widget, False, False)
                if text:
                    msg = "Do you want to overwrite custom values?"
                    answer = global_vars.controller.ask_question(msg, "Overwrite values")
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
                setWidgetText(self.dlg_cf, widget, f'{v}')
                widget.editingFinished.emit()
        close_dialog(dlg_dtext)


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
        event_point = get_event_point(point=point)

        # Snapping
        result = snap_to_current_layer(event_point)
        if result.isValid():
            layer = get_snapped_layer(result)
            if layer == self.layer_node:
                add_marker(result, self.vertex_marker)
        else:
            self.vertex_marker.hide()


    def change_hemisphere(self, dialog):

        # Set map tool emit point and signals
        emit_point = QgsMapToolEmitPoint(global_vars.canvas)
        self.previous_map_tool = global_vars.canvas.mapTool()
        global_vars.canvas.setMapTool(emit_point)
        emit_point.canvasClicked.connect(partial(self.action_rotation_canvas_clicked, dialog, emit_point))


    def action_rotation_canvas_clicked(self, dialog, emit_point, point, btn):

        if btn == Qt.RightButton:
            global_vars.canvas.setMapTool(self.previous_map_tool)
            return

        existing_point_x = None
        existing_point_y = None
        viewname = global_vars.controller.get_layer_source_table_name(self.layer)
        sql = (f"SELECT ST_X(the_geom), ST_Y(the_geom)"
               f" FROM {viewname}"
               f" WHERE node_id = '{self.feature_id}'")
        row = global_vars.controller.get_row(sql)

        if row:
            existing_point_x = row[0]
            existing_point_y = row[1]

        if existing_point_x:
            sql = (f"UPDATE node"
                   f" SET hemisphere = (SELECT degrees(ST_Azimuth(ST_Point({existing_point_x}, {existing_point_y}), "
                   f" ST_Point({point.x()}, {point.y()}))))"
                   f" WHERE node_id = '{self.feature_id}'")
            status = global_vars.controller.execute_sql(sql)
            if not status:
                global_vars.canvas.setMapTool(self.previous_map_tool)
                return

        sql = (f"SELECT rotation FROM node "
               f" WHERE node_id = '{self.feature_id}'")
        row = global_vars.controller.get_row(sql)
        if row:
            setWidgetText(dialog, "rotation", str(row[0]))

        sql = (f"SELECT degrees(ST_Azimuth(ST_Point({existing_point_x}, {existing_point_y}),"
               f" ST_Point({point.x()}, {point.y()})))")
        row = global_vars.controller.get_row(sql)
        if row:
            setWidgetText(dialog, "hemisphere", str(row[0]))
            message = "Hemisphere of the node has been updated. Value is"
            global_vars.controller.show_info(message, parameter=str(row[0]))

        # Disable Rotation
        action_widget = dialog.findChild(QAction, "actionRotation")
        if action_widget:
            action_widget.setChecked(False)
        try:
            emit_point.canvasClicked.disconnect()
            global_vars.canvas.setMapTool(self.previous_map_tool)
        except Exception as e:
            global_vars.controller.log_info(type(e).__name__)


    def api_action_copy_paste(self, dialog, geom_type, tab_type=None):
        """ Copy some fields from snapped feature to current feature """

        # Set map tool emit point and signals
        emit_point = QgsMapToolEmitPoint(global_vars.canvas)
        global_vars.canvas.setMapTool(emit_point)
        global_vars.canvas.xyCoordinates.connect(self.api_action_copy_paste_mouse_move)
        emit_point.canvasClicked.connect(partial(self.api_action_copy_paste_canvas_clicked, dialog, tab_type, emit_point))
        self.geom_type = geom_type

        # Store user snapping configuration
        self.previous_snapping = get_snapping_options

        # Clear snapping
        enable_snapping()

        # Set snapping
        layer = global_vars.iface.activeLayer()
        snap_to_layer(layer)

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


    def api_action_copy_paste_mouse_move(self, point):
        """ Slot function when mouse is moved in the canvas.
            Add marker if any feature is snapped
        """

        # Hide marker and get coordinates
        self.vertex_marker.hide()
        event_point = get_event_point(point=point)

        # Snapping
        result = snap_to_current_layer(event_point)
        if not result.isValid():
            return

        # Add marker to snapped feature
        add_marker(result, self.vertex_marker)


    def api_action_copy_paste_canvas_clicked(self, dialog, tab_type, emit_point, point, btn):
        """ Slot function when canvas is clicked """

        if btn == Qt.RightButton:
            self.api_disable_copy_paste(dialog, emit_point)
            return

        # Get clicked point
        event_point = get_event_point(point=point)

        # Snapping
        result = snap_to_current_layer(event_point)
        if not result.isValid():
            self.api_disable_copy_paste(dialog, emit_point)
            return

        layer = global_vars.iface.activeLayer()
        layername = layer.name()

        # Get the point. Leave selection
        snapped_feature = get_snapped_feature(result, True)
        snapped_feature_attr = snapped_feature.attributes()

        aux = f'"{self.geom_type}_id" = '
        aux += f"'{self.feature_id}'"
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = "Expression Error"
            global_vars.controller.show_warning(message, parameter=expr.parserErrorString())
            self.api_disable_copy_paste(dialog, emit_point)
            return

        fields = layer.dataProvider().fields()
        layer.startEditing()
        it = layer.getFeatures(QgsFeatureRequest(expr))
        feature_list = [i for i in it]
        if not feature_list:
            self.api_disable_copy_paste(dialog, emit_point)
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
        answer = global_vars.controller.ask_question(msg, "Update records", None)
        if answer:
            for i in range(0, len(fields)):
                for x in range(0, len(fields_aux)):
                    if fields[i].name() == fields_aux[x]:
                        layer.changeAttributeValue(feature.id(), i, snapped_feature_attr_aux[x])

            layer.commitChanges()

            # dialog.refreshFeature()
            for i in range(0, len(fields_aux)):
                widget = dialog.findChild(QWidget, tab_type + "_" + fields_aux[i])
                if getWidgetType(dialog, widget) is QLineEdit:
                    setWidgetText(dialog, widget, str(snapped_feature_attr_aux[i]))
                elif getWidgetType(dialog, widget) is QComboBox:
                    set_combo_itemData(widget, str(snapped_feature_attr_aux[i]), 0)

        self.api_disable_copy_paste(dialog, emit_point)


    def api_disable_copy_paste(self, dialog, emit_point):
        """ Disable actionCopyPaste and set action 'Identify' """

        action_widget = dialog.findChild(QAction, "actionCopyPaste")
        if action_widget:
            action_widget.setChecked(False)

        try:
            apply_snapping_options(self.previous_snapping)
            self.vertex_marker.hide()
            global_vars.canvas.xyCoordinates.disconnect()
            emit_point.canvasClicked.disconnect()
        except:
            pass


    def manage_docker_close(self):

        self.roll_back()
        self.rubber_band.reset()
        self.controller.close_docker()


    def manage_info_close(self, dialog):

        self.roll_back()
        self.rubber_band.reset()
        save_settings(dialog)
        close_dialog(dialog)


    def get_feature(self, tab_type):
        """ Get current QgsFeature """

        expr_filter = f"{self.field_id} = '{self.feature_id}'"
        self.feature = get_feature_by_expr(self.layer, expr_filter)
        return self.feature


    def api_action_zoom_in(self, canvas, layer):
        """ Zoom in """

        if not self.feature:
            self.get_feature(self.tab_type)
        layer.selectByIds([self.feature.id()])
        canvas.zoomToSelected(layer)
        canvas.zoomIn()


    def api_action_centered(self, canvas, layer):
        """ Center map to current feature """

        if not self.feature:
            self.get_feature(self.tab_type)
        layer.selectByIds([self.feature.id()])
        canvas.zoomToSelected(layer)


    def api_action_zoom_out(self, canvas, layer):
        """ Zoom out """

        if not self.feature:
            self.get_feature(self.tab_type)
        layer.selectByIds([self.feature.id()])
        canvas.zoomToSelected(layer)
        canvas.zoomOut()
        expr_filter = f"{self.field_id} = '{self.feature_id}'"
        self.feature = get_feature_by_expr(self.layer, expr_filter)
        return self.feature


    def get_last_value(self):

        try:
            # Widgets in ('lyt_top_1', 'lyt_bot_1', 'lyt_bot_2')
            other_widgets = []
            for field in self.complet_result[0]['body']['data']['fields']:
                if field['layoutname'] in ('lyt_top_1', 'lyt_bot_1', 'lyt_bot_2'):
                    widget = self.dlg_cf.findChild(QWidget, field['widgetname'])
                    if widget:
                        other_widgets.append(widget)
            # Widgets in tab_data
            widgets = self.dlg_cf.tab_data.findChildren(QWidget)
            widgets.extend(other_widgets)
            for widget in widgets:
                if widget.hasFocus():
                    value = getWidgetText(self.dlg_cf, widget)
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
                check_actions(action_edit, False)
                disable_all(dialog, self.complet_result[0]['body']['data'], False)
                self.enable_actions(dialog, False)
                return
            save = self.ask_for_save(action_edit, fid)
            if save:
                self.manage_accept(dialog, action_edit, new_feature, self.my_json, False)
                self.my_json = {}
            elif self.new_feature_id is not None:
                if self.controller.dlg_docker and self.controller.show_docker:
                    self.manage_docker_close()
                else:
                    close_dialog(dialog)
        else:
            check_actions(action_edit, True)
            enable_all(dialog, self.complet_result[0]['body']['data'])
            self.enable_actions(dialog, True)


    def accept_from_btn(self, dialog, action_edit, new_feature, my_json):

        if not action_edit.isChecked():
            close_dialog(dialog)
            return

        self.manage_accept(dialog, action_edit, new_feature, my_json, True)


    def manage_accept(self, dialog, action_edit, new_feature, my_json, close_dlg):
        self.get_last_value()
        status = self.accept(dialog, self.complet_result[0], my_json, close_dlg=close_dlg, new_feature=new_feature)
        if status is True:  # Commit succesfull and dialog keep opened
            check_actions(action_edit, False)
            disable_all(dialog, self.complet_result[0]['body']['data'], False)
            self.enable_actions(dialog, False)


    def stop_editing(self, dialog, action_edit, layer, fid, my_json, new_feature=None):
        if my_json == '' or str(my_json) == '{}':
            self.disconnect_signals()
            # Use commitChanges just for closse edition
            layer.commitChanges()
            self.connect_signals()
            check_actions(action_edit, False)
            disable_all(dialog, self.complet_result[0]['body']['data'], False)
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
        check_actions(action_edit, True)
        enable_all(dialog, self.complet_result[0]['body']['data'])
        self.enable_actions(dialog, True)
        layer.startEditing()
        self.connect_signals()


    def ask_for_save(self, action_edit, fid):

        msg = 'Are you sure to save this feature?'
        answer = self.controller.ask_question(msg, "Save feature", None, parameter=fid)
        if not answer:
            check_actions(action_edit, True)
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
        functions called in -> widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field):
            def manage_text(self, dialog, complet_result, field)
            def manage_typeahead(self, dialog, complet_result, field)
            def manage_combo(self, dialog, complet_result, field)
            def manage_check(self, dialog, complet_result, field)
            def manage_datetime(self, dialog, complet_result, field)
            def manage_button(self, dialog, complet_result, field)
            def manage_hyperlink(self, dialog, complet_result, field)
            def manage_hspacer(self, dialog, complet_result, field)
            def manage_vspacer(self, dialog, complet_result, field)
            def manage_textarea(self, dialog, complet_result, field)
            def manage_spinbox(self, dialog, complet_result, field)
            def manage_doubleSpinbox(self, dialog, complet_result, field)
            def manage_tableView(self, dialog, complet_result, field)
         """

        widget = None
        label = None
        if field['label']:
            label = QLabel()
            label.setObjectName('lbl_' + field['widgetname'])
            label.setText(field['label'].capitalize())
            if field['stylesheet'] is not None and 'label' in field['stylesheet']:
                label = set_setStyleSheet(field, label)
            if 'tooltip' in field:
                label.setToolTip(field['tooltip'])
            else:
                label.setToolTip(field['label'].capitalize())

        if 'widgettype' in field and not field['widgettype']:
            message = "The field widgettype is not configured for"
            msg = f"formname:{self.tablename}, columnname:{field['columnname']}"
            self.controller.show_message(message, 2, parameter=msg)
            return label, widget

        try:
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field, new_feature)
        except Exception as e:
            msg = f"{type(e).__name__}: {e}"
            self.controller.show_message(msg, 2)
            return label, widget

        return label, widget


    def manage_text(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """

        widget = add_lineedit(field)
        widget = set_widget_size(widget, field)
        widget = self.set_min_max_values(widget, field)
        widget = self.set_reg_exp(widget, field)
        widget = self.set_auto_update_lineedit(field, dialog, widget, new_feature)
        widget = set_data_type(field, widget)
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


    def manage_typeahead(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        completer = QCompleter()
        widget = self.manage_text(dialog, complet_result, field, new_feature)
        widget = manage_lineedit(field, dialog, widget, completer)
        return widget


    def manage_combo(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = add_combobox(field)
        widget = set_widget_size(widget, field)
        widget = self.set_auto_update_combobox(field, dialog, widget, new_feature)
        return widget


    def manage_check(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = add_checkbox(field)
        widget.stateChanged.connect(partial(get_values, dialog, widget, self.my_json))
        widget = self.set_auto_update_checkbox(field, dialog, widget, new_feature)
        return widget


    def manage_datetime(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = add_calendar(dialog, field, my_json=self.my_json, complet_result=self.complet_result,
                              new_feature_id=self.new_feature_id, new_feature=self.new_feature,
                              layer_new_feature=self.layer_new_feature,
                              feature_id=self.feature_id, feature_type=self.feature_type, layer=self.layer)
        widget = self.set_auto_update_dateedit(field, dialog, widget, new_feature)
        return widget


    def manage_button(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = add_button(dialog, field, module=self)
        widget = set_widget_size(widget, field)
        return widget


    def manage_hyperlink(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = add_hyperlink(field)
        widget = set_widget_size(widget, field)
        return widget


    def manage_hspacer(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = add_horizontal_spacer()
        return widget


    def manage_vspacer(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = add_vertical_spacer()
        return widget


    def manage_textarea(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """

        widget = add_textarea(field)
        widget = self.set_auto_update_textarea(field, dialog, widget, new_feature)
        return widget


    def manage_spinbox(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = add_spinbox(field)
        widget = self.set_auto_update_spinbox(field, dialog, widget, new_feature)
        return widget


    def manage_doubleSpinbox(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = add_spinbox(field)
        if 'widgetcontrols' in field and field['widgetcontrols'] and 'spinboxDecimals' in field['widgetcontrols']:
            widget.setDecimals(field['widgetcontrols']['spinboxDecimals'])
        widget = self.set_auto_update_spinbox(field, dialog, widget, new_feature)
        return widget


    def manage_tableView(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = add_tableview(complet_result, field)
        widget = set_headers(widget, field)
        widget = populate_table(widget, field)
        widget = set_columns_config(widget, field['widgetname'], sort_order=1, isQStandardItemModel=True)
        set_qtv_config(widget)
        return widget


    def open_section_form(self):

        dlg_sections = InfoCrossectUi()
        load_settings(dlg_sections)

        # Set dialog not resizable
        dlg_sections.setFixedSize(dlg_sections.size())

        feature = '"id":"' + self.feature_id + '"'
        body = create_body(feature=feature)
        json_result = self.controller.get_json('gw_fct_getinfocrossection', body)
        if not json_result or json_result['status'] == 'Failed':
            return False

        # Set image
        img = json_result['body']['data']['shapepng']
        setImage(dlg_sections, 'lbl_section_image', img)

        # Set values into QLineEdits
        for field in json_result['body']['data']['fields']:
            widget = dlg_sections.findChild(QLineEdit, field['columnname'])
            if widget:
                if 'value' in field:
                    setWidgetText(dlg_sections, widget, field['value'])

        dlg_sections.btn_close.clicked.connect(partial(close_dialog, dlg_sections))
        open_dialog(dlg_sections, dlg_name='info_crossect', maximize_button=False)


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
            if self.controller.dlg_docker:
                self.controller.dlg_docker.setMinimumWidth(dialog.width())
                self.controller.close_docker()
            close_dialog(dialog)
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
                value = getWidgetText(dialog, widget)
                if value in ('null', None, ''):
                    widget.setStyleSheet("border: 1px solid red")
                    list_mandatory.append(widget_name)

        if list_mandatory:
            msg = "Some mandatory values are missing. Please check the widgets marked in red."
            self.controller.show_warning(msg)
            check_actions("actionEdit", True, dialog)
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
                self.controller.log_warning(f"{error}")
                self.connect_signals()
                return False
            
            self.new_feature_id = None
            self.enable_action(dialog, "actionZoom", True)
            self.enable_action(dialog, "actionZoomOut", True)
            self.enable_action(dialog, "actionCentered", True)
            self.controller.is_inserting = False
            my_json = json.dumps(_json)
            if my_json == '' or str(my_json) == '{}':
                if close_dlg:
                    if self.controller.dlg_docker:
                        self.controller.close_docker()
                    close_dialog(dialog)
                return True

            if self.new_feature.attribute(id_name) is not None:
                feature = f'"id":"{self.new_feature.attribute(id_name)}", '
            else:
                feature = f'"id":"{self.feature_id}", '

        # If we make an info
        else:
            my_json = json.dumps(_json)
            feature = f'"id":"{self.feature_id}", '
            feature += f'"tableName":"{p_table_id}"'

        feature += f', "featureType":"{self.feature_type}" '
        extras = f'"fields":{my_json}, "reload":"{fields_reload}", "afterInsert":"{after_insert}"'
        body = create_body(feature=feature, extras=extras)
        json_result = self.controller.get_json('gw_fct_setfields', body)
        if not json_result:
            self.connect_signals()
            return False

        if clear_json:
            _json = {}

        if "Accepted" in json_result['status']:
            msg = "OK"
            self.controller.show_message(msg, message_level=3)
            self.reload_fields(dialog, json_result, p_widget)
        elif "Failed" in json_result['status']:
            # If json_result['status'] is Failed message from database is showed user by get_json-->manage_exception_api
            self.connect_signals()
            return False

        if close_dlg:
            if self.controller.dlg_docker:
                self.manage_docker_close()
            close_dialog(dialog)
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
        functions called in ->  widget = getattr(self, f"{widget.property('datatype')}_validator")( value, widget, btn):
            def integer_validator(self, value, widget, btn_accept)
            def double_validator(self, value, widget, btn_accept)
        """

        value = getWidgetText(dialog, widget, return_string_null=False)
        try:
            getattr(self, f"{widget.property('datatype')}_validator")(value, widget, btn)
        except AttributeError:
            """ If the function called by getattr don't exist raise this exception """


    def check_min_max_value(self, dialog, widget, btn_accept):

        value = getWidgetText(dialog, widget, return_string_null=False)
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
                widget.editingFinished.connect(partial(get_values, dialog, widget, _json))
                widget.editingFinished.connect(
                    partial(self.accept, dialog, self.complet_result[0], _json, widget, True, False, new_feature=new_feature))
            else:
                widget.editingFinished.connect(partial(get_values, dialog, widget, self.my_json))

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
                widget.textChanged.connect(partial(get_values, dialog, widget, _json))
                widget.textChanged.connect(
                    partial(self.accept, dialog, self.complet_result[0], _json, widget, True, False, new_feature))
            else:
                widget.textChanged.connect(partial(get_values, dialog, widget, self.my_json))

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

        for field in result['body']['data']['fields']:
            widget = dialog.findChild(QLineEdit, f'{field["widgetname"]}')
            if widget:
                value = field["value"]
                setWidgetText(dialog, widget, value)
                if not field['iseditable']:
                    widget.setStyleSheet("QLineEdit { background: rgb(0, 255, 0); color: rgb(0, 0, 0)}")
                else:
                    widget.setStyleSheet(None)
            elif "message" in field:
                level = field['message']['level'] if 'level' in field['message'] else 0
                self.controller.show_message(field['message']['text'], level)


    def enabled_accept(self, dialog):
        dialog.btn_accept.setEnabled(True)


    def set_auto_update_combobox(self, field, dialog, widget, new_feature):

        if self.check_tab_data(dialog):
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                widget.currentIndexChanged.connect(partial(self.clean_my_json, widget))
                widget.currentIndexChanged.connect(partial(get_values, dialog, widget, _json))
                widget.currentIndexChanged.connect(partial(
                    self.accept, dialog, self.complet_result[0], _json, None, True, False, new_feature))
            else:
                widget.currentIndexChanged.connect(partial(get_values, dialog, widget, self.my_json))

        return widget


    def set_auto_update_dateedit(self, field, dialog, widget, new_feature):

        if self.check_tab_data(dialog):
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                widget.dateChanged.connect(partial(self.clean_my_json, widget))
                widget.dateChanged.connect(partial(get_values, dialog, widget, _json))
                widget.dateChanged.connect(partial(
                    self.accept, dialog, self.complet_result[0], _json, None, True, False, new_feature))
            else:
                widget.dateChanged.connect(partial(get_values, dialog, widget, self.my_json))

        return widget


    def set_auto_update_spinbox(self, field, dialog, widget, new_feature):

        if self.check_tab_data(dialog):
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                widget.valueChanged.connect(partial(self.clean_my_json, widget))
                widget.valueChanged.connect(partial(get_values, dialog, widget, _json))
                widget.valueChanged.connect(partial(
                    self.accept, dialog, self.complet_result[0], _json, None, True, False, new_feature))
            else:
                widget.valueChanged.connect(partial(get_values, dialog, widget, self.my_json))

        return widget


    def set_auto_update_checkbox(self, field, dialog, widget, new_feature):

        if self.check_tab_data(dialog):
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                widget.stateChanged.connect(partial(self.clean_my_json, widget))
                widget.stateChanged.connect(partial(get_values, dialog, widget, _json))
                widget.stateChanged.connect(partial(
                    self.accept, dialog, self.complet_result[0], _json, None, True, False, new_feature))
            else:
                widget.stateChanged.connect(partial(get_values, dialog, widget, self.my_json))
        return widget


    def open_catalog(self, tab_type, feature_type):

        self.catalog = GwCatalog()

        # Check geom_type
        if self.geom_type == 'connec':
            widget = f'{tab_type}_{self.geom_type}at_id'
        else:
            widget = f'{tab_type}_{self.geom_type}cat_id'
        self.catalog.api_catalog(self.dlg_cf, widget, self.geom_type, feature_type)


    def show_actions(self, dialog, tab_name):
        """ Hide all actions and show actions for the corresponding tab
        :param tab_name: corresponding tab
        """

        actions_list = dialog.findChildren(QAction)
        for action in actions_list:
            action.setVisible(False)

        if not 'visibleTabs' in self.complet_result[0]['body']['form']:
            return

        for tab in self.complet_result[0]['body']['form']['visibleTabs']:
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
        set_columns_config(self.tbl_element, table_element)


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
        self.set_model_to_table(widget, table_name, expr_filter)

        # Adding auto-completion to a QLineEdit
        self.table_object = "element"
        set_completer_object(dialog, self.table_object)


    def open_selected_element(self, dialog, widget):
        """ Open form of selected element of the @widget?? """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
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
        object_id = getWidgetText(self.dlg_cf, table_object + "_id")
        if object_id == 'null':
            message = "You need to insert data"
            self.controller.show_warning(message, parameter=table_object + "_id")
            return

        # Check if this object exists
        field_object_id = "id"
        sql = ("SELECT * FROM " + view_object + ""
               " WHERE " + field_object_id + " = '" + object_id + "'")
        row = self.controller.get_row(sql)
        if not row:
            self.controller.show_warning("Object id not found", parameter=object_id)
            return

        # Check if this object is already associated to current feature
        field_object_id = table_object + "_id"
        tablename = table_object + "_x_" + self.geom_type
        sql = ("SELECT *"
               " FROM " + str(tablename) + ""
               " WHERE " + str(self.field_id) + " = '" + str(self.feature_id) + "'"
               " AND " + str(field_object_id) + " = '" + str(object_id) + "'")
        row = self.controller.get_row(sql, log_info=False, log_sql=False)

        # If object already exist show warning message
        if row:
            message = "Object already associated with this feature"
            self.controller.show_warning(message)

        # If object not exist perform an INSERT
        else:
            sql = ("INSERT INTO " + tablename + " "
                   "(" + str(field_object_id) + ", " + str(self.field_id) + ")"
                   " VALUES ('" + str(object_id) + "', '" + str(self.feature_id) + "');")
            self.controller.execute_sql(sql, log_sql=False)
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
            self.controller.show_warning(message)
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
        answer = self.controller.ask_question(message, "Delete records", list_object_id)
        if answer:
            sql = ("DELETE FROM " + table_name + ""
                   " WHERE id::integer IN (" + list_id + ")")
            self.controller.execute_sql(sql, log_sql=False)
            widget.model().select()

    """ FUNCTIONS RELATED WITH TAB ELEMENT"""

    def manage_element(self, dialog, element_id=None, feature=None):
        """ Execute action of button 33 """

        elem = GwElement()
        elem.manage_element(True, feature, self.geom_type)
        elem.dlg_add_element.accepted.connect(partial(self.manage_element_new, dialog, elem))
        elem.dlg_add_element.rejected.connect(partial(self.manage_element_new, dialog, elem))

        # Set completer
        set_completer_object(dialog, self.table_object)

        if element_id:
            setWidgetText(elem.dlg_add_element, "element_id", element_id)

        # Open dialog
        open_dialog(elem.dlg_add_element)


    def manage_element_new(self, dialog, elem):
        """ Get inserted element_id and add it to current feature """

        if elem.element_id is None:
            return

        setWidgetText(dialog, "element_id", elem.element_id)
        self.add_object(self.tbl_element, "element", "v_ui_element")
        self.tbl_element.model().select()


    def set_model_to_table(self, widget, table_name, expr_filter=None, edit_strategy=QSqlTableModel.OnManualSubmit):
        """ Set a model with selected filter.
        Attach that model to selected table """

        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(edit_strategy)
        if expr_filter:
            model.setFilter(expr_filter)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

        # Attach model to table view
        if widget:
            widget.setModel(model)
        else:
            self.controller.log_info("set_model_to_table: widget not found")


    """ FUNCTIONS RELATED WITH TAB RELATIONS"""

    def manage_tab_relations(self, viewname, field_id):
        """ Hide tab 'relations' if no data in the view """

        # Check if data in the view
        sql = (f"SELECT * FROM {viewname}"
               f" WHERE {field_id} = '{self.feature_id}';")
        row = self.controller.get_row(sql, log_info=True, log_sql=False)

        if not row:
            # Hide tab 'relations'
            remove_tab_by_tabName(self.tab_main, "relations")

        else:
            # Manage signal 'doubleClicked'
            self.tbl_relations.doubleClicked.connect(partial(self.open_relation, field_id))


    def fill_tab_relations(self):
        """ Fill tab 'Relations' """

        table_relations = f"v_ui_{self.geom_type}_x_relations"
        fill_table(self.tbl_relations, self.schema_name + "." + table_relations, self.filter)
        set_columns_config(self.tbl_relations, table_relations)
        self.tbl_relations.doubleClicked.connect(partial(self.open_relation, str(self.field_id)))


    def open_relation(self, field_id):
        """ Open feature form of selected element """

        selected_list = self.tbl_relations.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
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
        sys_type = self.controller.get_row(sql)
        table_name = self.tbl_relations.model().record(row).value("sys_table_id")
        feature_id = self.tbl_relations.model().record(row).value("sys_id")

        if table_name is None:
            table_name = 'v_edit_' + sys_type[0].lower()

        if feature_id is None:
            feature_id = selected_object_id

        layer = self.controller.get_layer_by_tablename(table_name, log_info=True)

        if not layer:
            message = "Layer not found"
            self.controller.show_message(message, parameter=table_name)
            return

        api_cf = GwInfo(self.tab_type)
        complet_result, dialog = api_cf.open_form(table_name=table_name, feature_id=feature_id, tab_type=self.tab_type)
        if not complet_result:
            self.controller.log_info("FAIL open_relation")
            return

        margin = float(complet_result['body']['feature']['zoomCanvasMargin']['mts'])
        draw(complet_result[0], self.rubber_band, margin)


    """ FUNCTIONS RELATED WITH TAB CONNECTIONS """

    def fill_tab_connections(self):
        """ Fill tab 'Connections' """

        filter_ = f"node_id='{self.feature_id}'"
        fill_table(self.dlg_cf.tbl_upstream, self.schema_name + ".v_ui_node_x_connection_upstream", filter_)
        set_columns_config(self.dlg_cf.tbl_upstream, "v_ui_node_x_connection_upstream")

        fill_table(self.dlg_cf.tbl_downstream, self.schema_name + ".v_ui_node_x_connection_downstream", filter_)
        set_columns_config(self.dlg_cf.tbl_downstream, "v_ui_node_x_connection_downstream")

        self.dlg_cf.tbl_upstream.doubleClicked.connect(partial(self.open_up_down_stream, self.tbl_upstream))
        self.dlg_cf.tbl_downstream.doubleClicked.connect(partial(self.open_up_down_stream, self.tbl_downstream))


    def open_up_down_stream(self, qtable):
        """ Open selected node from @qtable """

        selected_list = qtable.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        row = selected_list[0].row()
        table_name = qtable.model().record(row).value("sys_table_id")
        feature_id = qtable.model().record(row).value("feature_id")
        api_cf = GwInfo(self.tab_type)
        complet_result, dialog = api_cf.open_form(table_name=table_name, feature_id=feature_id, tab_type=self.tab_type)
        if not complet_result:
            self.controller.log_info("FAIL open_up_down_stream")
            return

        margin = float(complet_result['body']['feature']['zoomCanvasMargin']['mts'])
        draw(complet_result[0], self.rubber_band, margin)


    """ FUNCTIONS RELATED WITH TAB HYDROMETER"""

    def fill_tab_hydrometer(self):
        """ Fill tab 'Hydrometer' """

        table_hydro = "v_ui_hydrometer"
        txt_hydrometer_id = self.dlg_cf.findChild(QLineEdit, "txt_hydrometer_id")
        self.fill_tbl_hydrometer(self.tbl_hydrometer, table_hydro)
        set_columns_config(self.tbl_hydrometer, table_hydro)
        txt_hydrometer_id.textChanged.connect(partial(self.fill_tbl_hydrometer, self.tbl_hydrometer, table_hydro))
        self.tbl_hydrometer.doubleClicked.connect(partial(self.open_selected_hydro, self.tbl_hydrometer))
        self.dlg_cf.findChild(QPushButton, "btn_link").clicked.connect(self.check_url)


    def open_selected_hydro(self, qtable=None):

        selected_list = qtable.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        index = selected_list[0]
        row = index.row()

        table_name = 'v_ui_hydrometer'
        column_index = get_col_index_by_col_name(qtable, 'hydrometer_id')
        feature_id = index.sibling(row, column_index).data()

        # return
        api_cf = GwInfo(self.tab_type)
        complet_result, dialog = api_cf.open_form(table_name=table_name, feature_id=feature_id, tab_type=self.tab_type)
        if not complet_result:
            self.controller.log_info("FAIL open_selected_hydro")
            return


    def check_url(self):
        """ Check URL. Enable/Disable button that opens it """

        selected_list = self.tbl_hydrometer.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
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
        self.set_model_to_table(qtable, self.schema_name + "." + table_name, filter)


    """ FUNCTIONS RELATED WITH TAB HYDROMETER VALUES"""

    def fill_tab_hydrometer_values(self):

        table_hydro_value = "v_ui_hydroval_x_connec"

        # Populate combo filter hydrometer value
        sql = (f"SELECT DISTINCT(t1.code), t2.cat_period_id "
               f"FROM ext_cat_period as t1 "
               f"join v_ui_hydroval_x_connec as t2 on t1.id = t2.cat_period_id "
               f"ORDER BY t2.cat_period_id DESC")
        rows = self.controller.get_rows(sql)
        if not rows:
            return False
        set_item_data(self.dlg_cf.cmb_cat_period_id_filter, rows, add_empty=True, sort_combo=False)

        sql = ("SELECT hydrometer_id, hydrometer_customer_code "
               " FROM v_rtc_hydrometer "
               " WHERE connec_id = '" + str(self.feature_id) + "' "
               " ORDER BY hydrometer_customer_code")
        rows_list = []
        rows = self.controller.get_rows(sql)
        rows_list.append(['', ''])
        if rows:
            for row in rows:
                rows_list.append(row)
        set_item_data(self.dlg_cf.cmb_hyd_customer_code, rows_list, 1)

        self.fill_tbl_hydrometer_values(self.tbl_hydrometer_value, table_hydro_value)
        set_columns_config(self.tbl_hydrometer_value, table_hydro_value)

        self.dlg_cf.cmb_cat_period_id_filter.currentIndexChanged.connect(
            partial(self.fill_tbl_hydrometer_values, self.tbl_hydrometer_value, table_hydro_value))
        self.dlg_cf.cmb_hyd_customer_code.currentIndexChanged.connect(
            partial(self.fill_tbl_hydrometer_values, self.tbl_hydrometer_value, table_hydro_value))


    def fill_tbl_hydrometer_values(self, qtable, table_name):
        """ Fill the table control to show hydrometers values """

        cat_period = get_item_data(self.dlg_cf, self.dlg_cf.cmb_cat_period_id_filter, 1)
        customer_code = get_item_data(self.dlg_cf, self.dlg_cf.cmb_hyd_customer_code)
        filter_ = f"connec_id::text = '{self.feature_id}' "
        if cat_period != '':
            filter_ += f" AND cat_period_id::text = '{cat_period}'"
        if customer_code != '':
            filter_ += f" AND hydrometer_id::text = '{customer_code}'"

        # Set model of selected widget
        self.set_model_to_table(qtable, self.schema_name + "." + table_name, filter_, QSqlTableModel.OnFieldChange)
        set_columns_config(self.tbl_hydrometer_value, table_name)


    def set_filter_hydrometer_values(self, widget):
        """ Get Filter for table hydrometer value with combo value"""

        # Get combo value
        cat_period_id_filter = get_item_data(self.dlg_cf, self.dlg_cf.cmb_cat_period_id_filter, 0)

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
        set_columns_config(self.tbl_event_cf, table_event_geom)


    def fill_tbl_event(self, widget, table_name, filter_):
        """ Fill the table control to show events """

        # Get widgets
        widget.setSelectionBehavior(QAbstractItemView.SelectRows)
        event_type = self.dlg_cf.findChild(QComboBox, "event_type")
        event_id = self.dlg_cf.findChild(QComboBox, "event_id")
        self.date_event_to = self.dlg_cf.findChild(QDateEdit, "date_event_to")
        self.date_event_from = self.dlg_cf.findChild(QDateEdit, "date_event_from")

        set_dates_from_to(self.date_event_from, self.date_event_to, table_name, 'visit_start', 'visit_end')

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
        rows = self.controller.get_rows(sql)
        if rows:
            rows.append(['', ''])
            set_item_data(self.dlg_cf.event_id, rows)
        # Fill ComboBox event_type
        sql = (f"SELECT DISTINCT(parameter_type), parameter_type "
               f"FROM {table_name_event_id} "
               f"WHERE feature_type = '{feature_type[self.field_id]}' OR feature_type = 'ALL' "
               f"ORDER BY parameter_type")
        rows = self.controller.get_rows(sql)
        if rows:
            rows.append(['', ''])
            set_item_data(self.dlg_cf.event_type, rows)

        self.set_model_to_table(widget, table_name)
        self.set_filter_table_event(widget)


    def open_visit_event(self):
        """ Open event of selected record of the table """

        # Open dialog event_standard
        self.dlg_event_full = VisitEventFull()
        load_settings(self.dlg_event_full)
        self.dlg_event_full.rejected.connect(partial(close_dialog, self.dlg_event_full))
        # Get all data for one visit
        sql = (f"SELECT * FROM om_visit_event"
               f" WHERE id = '{self.event_id}' AND visit_id = '{self.visit_id}'")
        row = self.controller.get_row(sql)
        if not row:
            return

        setWidgetText(self.dlg_event_full, self.dlg_event_full.id, row['id'])
        setWidgetText(self.dlg_event_full, self.dlg_event_full.event_code, row['event_code'])
        setWidgetText(self.dlg_event_full, self.dlg_event_full.visit_id, row['visit_id'])
        setWidgetText(self.dlg_event_full, self.dlg_event_full.position_id, row['position_id'])
        setWidgetText(self.dlg_event_full, self.dlg_event_full.position_value, row['position_value'])
        setWidgetText(self.dlg_event_full, self.dlg_event_full.parameter_id, row['parameter_id'])
        setWidgetText(self.dlg_event_full, self.dlg_event_full.value, row['value'])
        setWidgetText(self.dlg_event_full, self.dlg_event_full.value1, row['value1'])
        setWidgetText(self.dlg_event_full, self.dlg_event_full.value2, row['value2'])
        setWidgetText(self.dlg_event_full, self.dlg_event_full.geom1, row['geom1'])
        setWidgetText(self.dlg_event_full, self.dlg_event_full.geom2, row['geom2'])
        setWidgetText(self.dlg_event_full, self.dlg_event_full.geom3, row['geom3'])
        setWidgetText(self.dlg_event_full, self.dlg_event_full.xcoord, row['xcoord'])
        setWidgetText(self.dlg_event_full, self.dlg_event_full.ycoord, row['ycoord'])
        setWidgetText(self.dlg_event_full, self.dlg_event_full.compass, row['compass'])
        setWidgetText(self.dlg_event_full, self.dlg_event_full.tstamp, row['tstamp'])
        setWidgetText(self.dlg_event_full, self.dlg_event_full.text, row['text'])
        setWidgetText(self.dlg_event_full, self.dlg_event_full.index_val, row['index_val'])
        setWidgetText(self.dlg_event_full, self.dlg_event_full.is_last, row['is_last'])
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
        self.dlg_event_full.btn_close.clicked.connect(partial(close_dialog, self.dlg_event_full))
        self.dlg_event_full.tbl_docs_x_event.doubleClicked.connect(self.open_file)
        set_qtv_config(self.dlg_event_full.tbl_docs_x_event)
        open_dialog(self.dlg_event_full, 'visit_event_full')


    def populate_tbl_docs_x_event(self):

        # Create and set model
        model = QStandardItemModel()
        self.dlg_event_full.tbl_docs_x_event.setModel(model)
        self.dlg_event_full.tbl_docs_x_event.horizontalHeader().setStretchLastSection(True)
        self.dlg_event_full.tbl_docs_x_event.horizontalHeader().setSectionResizeMode(3)
        # Get columns name and set headers of model with that
        columns_name = self.controller.get_columns_list('om_visit_event_photo')
        headers = []
        for x in columns_name:
            headers.append(x[0])
        headers = ['value', 'filetype', 'fextension']
        model.setHorizontalHeaderLabels(headers)

        # Get values in order to populate model
        sql = (f"SELECT value, filetype, fextension FROM om_visit_event_photo "
               f"WHERE visit_id='{self.visit_id}' AND event_id='{self.event_id}'")
        rows = self.controller.get_rows(sql)
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
        column_index = get_col_index_by_col_name(self.dlg_event_full.tbl_docs_x_event, 'value')

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
        row = self.controller.get_row(sql, log_sql=False)
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
            self.controller.show_warning(message)
            return

        # Cascade filter
        table_name_event_id = "config_visit_parameter"
        event_type_value = get_item_data(self.dlg_cf, self.dlg_cf.event_type, 0)

        feature_type = {'arc_id': 'ARC', 'connec_id': 'CONNEC', 'gully_id': 'GULLY', 'node_id': 'NODE'}
        # Fill ComboBox event_id
        sql = (f"SELECT DISTINCT(id), id FROM {table_name_event_id}"
               f" WHERE (feature_type = '{feature_type[self.field_id]}' OR feature_type = 'ALL')")
        if event_type_value != 'null':
            sql += f" AND parameter_type ILIKE '%{event_type_value}%'"
        sql += " ORDER BY id"
        rows = self.controller.get_rows(sql)
        if rows:
            rows.append(['', ''])
            set_item_data(self.dlg_cf.event_id, rows, 1)

        # End cascading filter
        # Get selected values in Comboboxes
        event_type_value = get_item_data(self.dlg_cf, self.dlg_cf.event_type, 0)
        event_id = get_item_data(self.dlg_cf, self.dlg_cf.event_id, 0)
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
            self.controller.show_warning(message)
            return

        format_low = 'yyyy-MM-dd 00:00:00.000'
        format_high = 'yyyy-MM-dd 23:59:59.999'
        interval = f"'{visit_start.toString(format_low)}'::timestamp AND '{visit_end.toString(format_high)}'::timestamp"

        # Set filter to model
        expr = f"{self.field_id} = '{self.feature_id}'"
        # Set filter
        expr += f" AND visit_start BETWEEN {interval}"

        # Get selected values in Comboboxes
        event_type_value = get_item_data(self.dlg_cf, self.dlg_cf.event_type, 0)
        if event_type_value != 'null':
            expr += f" AND parameter_type ILIKE '%{event_type_value}%'"
        event_id = get_item_data(self.dlg_cf, self.dlg_cf.event_id, 0)
        if event_id != 'null':
            expr += f" AND parameter_id ILIKE '%{event_id}%'"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()


    def open_visit(self):
        """ Call button 65: om_visit_management """

        manage_visit = GwVisitManager()
        manage_visit.visit_added.connect(self.update_visit_table)
        manage_visit.edit_visit(self.geom_type, self.feature_id)


    # creat the new visit GUI


    def update_visit_table(self):
        """ Convenience fuction set as slot to update table after a Visit GUI close. """
        table_name = "v_ui_event_x_" + self.geom_type
        set_dates_from_to(self.date_event_from, self.date_event_to, table_name, 'visit_start', 'visit_end')
        self.tbl_event_cf.model().select()


    def new_visit(self):
        """ Call button 64: om_add_visit """

        # Get expl_id to save it on om_visit and show the geometry of visit
        expl_id = get_item_data(self.dlg_cf, self.tab_type + '_expl_id', 0)
        if expl_id == -1:
            msg = "Widget expl_id not found"
            self.controller.show_warning(msg)
            return

        manage_visit = GwVisitManager()
        manage_visit.visit_added.connect(self.update_visit_table)
        # TODO: the following query fix a (for me) misterious bug
        # the DB connection is not available during manage_visit.manage_visit first call
        # so the workaroud is to do a unuseful query to have the dao controller active
        sql = "SELECT id FROM om_visit LIMIT 1"
        self.controller.get_rows(sql)
        manage_visit.manage_visit(geom_type=self.geom_type, feature_id=self.feature_id, expl_id=expl_id, is_new_from_cf=True)


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
        rows = self.controller.get_rows(sql)
        if not rows:
            return

        num_doc = len(rows)
        if num_doc == 1:
            # If just one document is attached directly open

            # Get path of selected document
            sql = (f"SELECT path"
                   f" FROM v_ui_doc"
                   f" WHERE id = '{rows[0][0]}'")
            row = self.controller.get_row(sql)
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
                    self.controller.show_warning(message, parameter=path)
                else:
                    # Open the document
                    os.startfile(path)

        else:
            # If more then one document is attached open dialog with list of documents
            self.dlg_load_doc = VisitDocument()
            load_settings(self.dlg_load_doc)
            self.dlg_load_doc.rejected.connect(partial(close_dialog, self.dlg_load_doc))
            btn_open_doc = self.dlg_load_doc.findChild(QPushButton, "btn_open")
            btn_open_doc.clicked.connect(self.open_selected_doc)

            lbl_visit_id = self.dlg_load_doc.findChild(QLineEdit, "visit_id")
            lbl_visit_id.setText(str(self.visit_id))

            self.tbl_list_doc = self.dlg_load_doc.findChild(QListWidget, "tbl_list_doc")
            self.tbl_list_doc.itemDoubleClicked.connect(partial(self.open_selected_doc))
            for row in rows:
                item_doc = QListWidgetItem(str(row[0]))
                self.tbl_list_doc.addItem(item_doc)

            open_dialog(self.dlg_load_doc, dlg_name='visit_document')


    def open_selected_doc(self):

        # Selected item from list
        if self.tbl_list_doc.currentItem() is None:
            msg = "No document selected."
            self.controller.show_message(msg, 1)
            return

        selected_document = self.tbl_list_doc.currentItem().text()

        # Get path of selected document
        sql = (f"SELECT path FROM v_ui_doc"
               f" WHERE id = '{selected_document}'")
        row = self.controller.get_row(sql)
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
                self.controller.show_warning(message, parameter=path)
            else:
                # Open the document
                os.startfile(path)


    """ FUNCTIONS RELATED WITH TAB DOC"""

    def fill_tab_document(self):
        """ Fill tab 'Document' """

        table_document = "v_ui_doc_x_" + self.geom_type
        self.fill_tbl_document_man(self.dlg_cf, self.tbl_document, table_document, self.filter)
        set_columns_config(self.tbl_document, table_document)


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
        set_dates_from_to(self.date_document_from, self.date_document_to, table_name, 'date', 'date')

        # Set model of selected widget
        self.set_model_to_table(widget, self.schema_name + "." + table_name, expr_filter)

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
        rows = self.controller.get_rows(sql)
        if rows:
            rows.append(['', ''])
        set_item_data(doc_type, rows)

        # Adding auto-completion to a QLineEdit
        self.table_object = "doc"
        set_completer_object(dialog, self.table_object)

        # Set filter expresion
        self.set_filter_table_man(widget)


    def set_filter_table_man(self, widget):
        """ Get values selected by the user and sets a new filter for its table model """

        # Get selected dates
        date_from = self.date_document_from.date()
        date_to = self.date_document_to.date()
        if date_from > date_to:
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return

        # Create interval dates
        format_low = 'yyyy-MM-dd 00:00:00.000'
        format_high = 'yyyy-MM-dd 23:59:59.999'
        interval = f"'{date_from.toString(format_low)}'::timestamp AND '{date_to.toString(format_high)}'::timestamp"

        # Set filter
        expr = f"{self.field_id} = '{self.feature_id}'"
        expr += f" AND(date BETWEEN {interval}) AND (date BETWEEN {interval})"

        # Get selected values in Comboboxes
        doc_type_value = get_item_data(self.dlg_cf, self.dlg_cf.doc_type, 0)
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
            self.controller.show_warning(message)
            return
        elif len(selected_list) > 1:
            message = "Select just one document"
            self.controller.show_warning(message)
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
        doc.manage_document(feature=feature, geom_type=self.geom_type)
        doc.dlg_add_doc.accepted.connect(partial(self.manage_document_new, dialog, doc))
        doc.dlg_add_doc.rejected.connect(partial(self.manage_document_new, dialog, doc))

        # Set completer
        set_completer_object(dialog, self.table_object)
        if doc_id:
            setWidgetText(dialog, "doc_id", doc_id)

        # # Open dialog
        # doc.open_dialog(doc.dlg_add_doc)


    def manage_document_new(self, dialog, doc):
        """ Get inserted doc_id and add it to current feature """

        if doc.doc_id is None:
            return

        setWidgetText(dialog, "doc_id", doc.doc_id)
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
        clear_gridlayout(rpt_layout1)
        index_tab = self.tab_main.currentIndex()
        tab_name = self.tab_main.widget(index_tab).objectName()
        complet_list = self.get_list(complet_result, tab_name=tab_name)
        if complet_list is False:
            return False, False

        # Put widgets into layout
        widget_list = []
        for field in complet_list[0]['body']['data']['fields']:
            if 'hidden' in field and field['hidden']:
                continue
            label, widget = self.set_widgets(dialog, complet_list, field, new_feature)
            if widget is not None:
                if (type(widget)) == QSpacerItem:
                    rpt_layout1.addItem(widget, 1, field['layoutorder'])
                elif (type(widget)) == QTableView:
                    gridLayout_7 = self.dlg_cf.findChild(QGridLayout, "gridLayout_7")
                    gridLayout_7.addWidget(widget, 2, field['layoutorder'])
                    widget_list.append(widget)
                else:
                    widget.setMaximumWidth(150)
                    widget_list.append(widget)
                    if label:
                        rpt_layout1.addWidget(label, 0, field['layoutorder'])
                    rpt_layout1.addWidget(widget, 1, field['layoutorder'])

            # Find combo parents:
            for field in complet_list[0]['body']['data']['fields'][0]:
                if 'isparent' in field:
                    if field['isparent']:
                        widget = dialog.findChild(QComboBox, field['widgetname'])
                        widget.currentIndexChanged.connect(partial(fill_child, dialog, widget, self.feature_type,
                            self.tablename, self.field_id))

        return complet_list, widget_list


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
        id_name = complet_result[0]['body']['feature']['idName']
        feature = f'"tableName":"{self.tablename}", "idName":"{id_name}", "id":"{self.feature_id}"'
        body = create_body(form, feature, filter_fields)
        function_name = 'gw_fct_getlist'
        json_result = self.controller.get_json(function_name, body)
        if json_result is None or json_result['status'] == 'Failed':
            return False
        complet_list = [json_result]
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

        for field in complet_list[0]['body']['data']['fields']:
            if field['widgettype'] == "tableview":
                qtable = dialog.findChild(QTableView, field['widgetname'])
                if qtable:
                    set_headers(qtable, field)
                    populate_table(qtable, field)

        return complet_list


    def get_filter_qtableview(self, standar_model, dialog, widget_list):

        standar_model.clear()
        filter_fields = ""
        for widget in widget_list:
            if type(widget) != QTableView:
                columnname = widget.property('columnname')
                text = getWidgetText(dialog, widget)
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
            self.controller.show_warning(message)
            return

        index = selected_list[0]
        row = index.row()
        table_name = complet_list[0]['body']['feature']['tableName']
        column_index = get_col_index_by_col_name(qtable, 'sys_id')
        feature_id = index.sibling(row, column_index).data()

        # return
        api_cf = GwInfo(self.tab_type)
        complet_result, dialog = api_cf.open_form(table_name=table_name, feature_id=feature_id, tab_type=self.tab_type)
        if not complet_result:
            self.controller.log_info("FAIL open_rpt_result")
            return

        margin = float(complet_result['body']['feature']['zoomCanvasMargin']['mts'])
        draw(complet_result[0], self.rubber_band, margin)


    """ FUNCTIONS RELATED WITH TAB PLAN """

    def fill_tab_plan(self, complet_result):

        plan_layout = self.dlg_cf.findChild(QGridLayout, 'plan_layout')

        if self.geom_type == 'arc' or self.geom_type == 'node':
            index_tab = self.tab_main.currentIndex()
            tab_name = self.tab_main.widget(index_tab).objectName()
            form = f'"tabName":"{tab_name}"'
            feature = f'"featureType":"{complet_result[0]["body"]["feature"]["featureType"]}", '
            feature += f'"tableName":"{self.tablename}", '
            feature += f'"idName":"{self.field_id}", '
            feature += f'"id":"{self.feature_id}"'
            body = create_body(form, feature, filter_fields='')
            json_result = self.controller.get_json('gw_fct_getinfoplan', body)
            if not json_result or json_result['status'] == 'Failed':
                return False

            result = json_result['body']['data']
            if 'fields' not in result:
                self.controller.show_message("No listValues for: " + json_result['body']['data'], 2)
            else:
                for field in json_result['body']['data']['fields']:
                    label = QLabel()
                    if field['widgettype'] == 'divider':
                        for x in range(0, 2):
                            line = add_frame(field, x)
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
                        widget = add_label(field)
                        widget.setAlignment(Qt.AlignRight)
                        label.setWordWrap(True)
                        plan_layout.addWidget(label, field['layoutorder'], 0)
                        plan_layout.addWidget(widget, field['layoutorder'], 1)

                plan_vertical_spacer = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
                plan_layout.addItem(plan_vertical_spacer)


    """ NEW WORKCAT"""

    def cf_new_workcat(self, tab_type):

        body = '$${"client":{"device":4, "infoType":1, "lang":"ES"}, '
        body += '"form":{"formName":"new_workcat", "tabName":"data", "editable":"TRUE"}, '
        body += '"feature":{}, '
        body += '"data":{}}$$'
        function_name = 'gw_fct_getcatalog'
        json_result = self.controller.get_json(function_name, body)
        if json_result is None or json_result['status'] == 'Failed':
            return
        complet_list = [json_result]
        if not complet_list:
            return

        self.dlg_new_workcat = InfoGenericUi()
        load_settings(self.dlg_new_workcat)

        # Set signals
        self.dlg_new_workcat.btn_close.clicked.connect(partial(close_dialog, self.dlg_new_workcat))
        self.dlg_new_workcat.rejected.connect(partial(close_dialog, self.dlg_new_workcat))
        self.dlg_new_workcat.btn_accept.clicked.connect(
            partial(self.cf_manage_new_workcat_accept, 'cat_work', tab_type))

        populate_basic_info(self.dlg_new_workcat, complet_list, self.field_id, self.my_json,
                 new_feature_id=self.new_feature_id, new_feature=self.new_feature, layer_new_feature=self.layer_new_feature,
                 feature_id=self.feature_id, feature_type=self.feature_type, layer=self.layer)

        # Open dialog
        self.dlg_new_workcat.setWindowTitle("Create workcat")
        open_dialog(self.dlg_new_workcat, dlg_name='info_generic')


    def cf_manage_new_workcat_accept(self, table_object, tab_type):
        """ Insert table 'cat_work'. Add cat_work """

        # Take widgets
        cat_work_id = self.dlg_new_workcat.findChild(QLineEdit, "data_cat_work_id")
        descript = self.dlg_new_workcat.findChild(QLineEdit, "data_descript")
        link = self.dlg_new_workcat.findChild(QLineEdit, "data_link")
        workid_key_1 = self.dlg_new_workcat.findChild(QLineEdit, "data_workid_key_1")
        workid_key_2 = self.dlg_new_workcat.findChild(QLineEdit, "data_workid_key_2")
        builtdate = self.dlg_new_workcat.findChild(QgsDateTimeEdit, "data_builtdate")

        # Get values from dialog
        values = ""
        fields = ""
        cat_work_id = getWidgetText(self.dlg_new_workcat, cat_work_id)
        if cat_work_id != "null":
            fields += 'id, '
            values += f"'{cat_work_id}', "
        descript = getWidgetText(self.dlg_new_workcat, descript)
        if descript != "null":
            fields += 'descript, '
            values += f"'{descript}', "
        link = getWidgetText(self.dlg_new_workcat, link)
        if link != "null":
            fields += 'link, '
            values += f"'{link}', "
        workid_key_1 = getWidgetText(self.dlg_new_workcat, workid_key_1)
        if workid_key_1 != "null":
            fields += 'workid_key1, '
            values += f"'{workid_key_1}', "
        workid_key_2 = getWidgetText(self.dlg_new_workcat, workid_key_2)
        if workid_key_2 != "null":
            fields += 'workid_key2, '
            values += f"'{workid_key_2}', "
        builtdate = builtdate.dateTime().toString('yyyy-MM-dd')
        if builtdate != "null" and builtdate != '':
            fields += 'builtdate, '
            values += f"'{builtdate}', "

        if values != "":
            fields = fields[:-2]
            values = values[:-2]
            if cat_work_id == 'null':
                msg = "El campo Work id esta vacio"
                self.controller.show_info_box(msg, "Warning")
            else:
                # Check if this element already exists
                sql = (f"SELECT DISTINCT(id)"
                       f"FROM {table_object} "
                       f"WHERE id = '{cat_work_id}' ")
                row = self.controller.get_row(sql, log_info=False)
                if row is None:
                    sql = f"INSERT INTO cat_work ({fields}) VALUES ({values})"
                    self.controller.execute_sql(sql)
                    sql = "SELECT id, id FROM cat_work ORDER BY id"
                    rows = self.controller.get_rows(sql)
                    if rows:
                        cmb_workcat_id = self.dlg_cf.findChild(QWidget, tab_type + "_workcat_id")
                        model = QStringListModel()
                        completer = QCompleter()
                        set_completer_object_api(completer, model, cmb_workcat_id, rows[0])
                        setWidgetText(self.dlg_cf, cmb_workcat_id, cat_work_id)
                        self.my_json[str(cmb_workcat_id.property('columnname'))] = str(cat_work_id)
                    close_dialog(self.dlg_new_workcat)
                else:
                    msg = "This workcat already exists"
                    self.controller.show_info_box(msg, "Warning")


    def cf_open_dialog(self, dlg=None, dlg_name='giswater', maximize_button=True, stay_on_top=True):
        """ Open dialog """

        if dlg is None or type(dlg) is bool:
            dlg = self.dlg

        # Manage i18n of the dialog
        if dlg_name:
            self.controller.manage_translation(dlg_name, dlg)

        # Manage stay on top and maximize button
        if maximize_button and stay_on_top:
            dlg.setWindowFlags(Qt.WindowMinimizeButtonHint | Qt.WindowMaximizeButtonHint | Qt.WindowStaysOnTopHint)
        elif not maximize_button and stay_on_top:
            dlg.setWindowFlags(Qt.WindowMinimizeButtonHint | Qt.WindowStaysOnTopHint)
        elif maximize_button and not stay_on_top:
            dlg.setWindowFlags(Qt.WindowMaximizeButtonHint)

        # Open dialog
        dlg.open()


    def get_snapped_feature_id(self, dialog, action, option, widget_name):
        """ Snap feature and set a value into dialog """

        layer_name = 'v_edit_' + option
        layer = self.controller.get_layer_by_tablename(layer_name)
        widget = dialog.findChild(QWidget, widget_name)
        if not layer or not widget:
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
        self.previous_snapping = get_snapping_options

        # Disable snapping
        enable_snapping()

        # if we are doing info over connec or over node
        if option == 'arc':
            snap_to_arc()
        elif option == 'node':
            snap_to_node()

        # Set signals
        self.canvas.xyCoordinates.connect(partial(self.mouse_moved, layer))
        emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(emit_point)
        emit_point.canvasClicked.connect(partial(self.get_id, dialog, action, option))


    def mouse_moved(self, layer, point):
        """ Mouse motion detection """

        # Set active layer
        self.iface.setActiveLayer(layer)
        layer_name = self.controller.get_layer_source_table_name(layer)

        # Get clicked point
        self.vertex_marker.hide()
        event_point = get_event_point(point=point)

        # Snapping
        result = snap_to_current_layer(event_point)
        if result.isValid():
            layer = get_snapped_layer(result)
            # Check feature
            viewname = self.controller.get_layer_source_table_name(layer)
            if viewname == layer_name:
                add_marker(result, self.vertex_marker)


    def get_id(self, dialog, action, option, point, event):
        """ Get selected attribute from snapped feature """

        # @options{'key':['att to get from snapped feature', 'widget name destination']}
        options = {'arc': ['arc_id', 'data_arc_id'], 'node': ['node_id', 'data_parent_id']}

        if event == Qt.RightButton:
            self.disconnect_snapping(False)
            self.cancel_snapping_tool(dialog, action)
            return

        # Get coordinates
        event_point = get_event_point(point=point)

        # Snapping
        result = snap_to_current_layer(event_point)
        if not result.isValid():
            return
        # Get the point. Leave selection
        snapped_feat = get_snapped_feature(result)
        feat_id = snapped_feat.attribute(f'{options[option][0]}')
        widget = dialog.findChild(QWidget, f"{options[option][1]}")
        widget.setFocus()
        setWidgetText(dialog, widget, str(feat_id))
        apply_snapping_options(self.previous_snapping)
        self.cancel_snapping_tool(dialog, action)


    def cancel_snapping_tool(self, dialog, action):

        self.disconnect_snapping(False)
        dialog.blockSignals(False)
        action.setChecked(False)
        self.signal_activate.emit()


    def disconnect_snapping(self, action_pan=True, emit_point=None):
        """ Select 'Pan' as current map tool and disconnect snapping """

        emit_point.canvasClicked.disconnect()
        try:
            self.canvas.xyCoordinates.disconnect()
            if action_pan:
                self.iface.actionPan().trigger()
            self.vertex_marker.hide()
        except Exception as e:
            self.controller.log_info(f"{type(e).__name__} --> {e}")


    """ OTHER FUNCTIONS """

    def set_image(self, dialog, widget):
        setImage(dialog, widget, "ws_shape.png")



    """ FUNCTIONS ASSOCIATED TO BUTTONS FROM POSTGRES"""

    def get_info_node(self, **kwargs):
        """ Function called in class ApiParent.add_button(...) -->
                widget.clicked.connect(partial(getattr(self, function_name), **kwargs)) """

        dialog = kwargs['dialog']
        widget = kwargs['widget']

        feature_id = getWidgetText(dialog, widget)
        self.ApiCF = GwInfo(self.tab_type)
        complet_result, dialog = self.ApiCF.open_form(table_name='v_edit_node', feature_id=feature_id,
            tab_type=self.tab_type, is_docker=False)
        if not complet_result:
            self.controller.log_info("FAIL open_node")
            return


    def action_open_url(self, dialog, result):

        widget = None
        function_name = 'no_function_associated'
        for field in result['fields']:
            if field['linkedaction'] == 'action_link':
                function_name = field['widgetfunction']
                widget = dialog.findChild(GwHyperLinkLabel, field['widgetname'])
                break

        if widget:
            # Call def  function (self, widget)
            getattr(sys.modules[__name__], function_name)(widget)