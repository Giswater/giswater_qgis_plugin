"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: latin-1 -*-
from qgis.core import QgsGeometry, QgsMapToPixel, QgsPointXY, QgsVectorLayer
from qgis.gui import QgsDateTimeEdit, QgsMapToolEmitPoint, QgsRubberBand, QgsVertexMarker
from qgis.PyQt.QtCore import pyqtSignal, QDate, QObject, QPoint, QStringListModel, Qt
from qgis.PyQt.QtGui import QColor, QCursor, QIcon, QStandardItem, QStandardItemModel
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QAction, QAbstractItemView, QCheckBox, QComboBox, QCompleter, QDoubleSpinBox, \
    QDateEdit, QGridLayout, QLabel, QLineEdit, QListWidget, QListWidgetItem, QMenu, QPushButton, QSizePolicy, \
    QSpinBox, QSpacerItem, QTableView, QTabWidget, QWidget, QTextEdit

import json
import os
import re
import subprocess
import urllib.parse as parse
import sys
import webbrowser
from collections import OrderedDict
from functools import partial
from sip import isdeleted

from .. import utils_giswater
from .api_catalog import ApiCatalog
from .api_parent import ApiParent
from .manage_document import ManageDocument
from .manage_element import ManageElement
from .manage_gallery import ManageGallery
from .manage_visit import ManageVisit
from ..map_tools.snapping_utils_v3 import SnappingConfigManager
from ..ui_manager import InfoGenericUi, InfoFeatureUi, VisitEventFull, GwMainWindow, VisitDocument, InfoCrossectUi
from ..actions.api_dimensioning import ApiDimensioning


class ApiCF(ApiParent, QObject):

    # :var signal_activate: emitted from def cancel_snapping_tool(self, dialog, action) in order to re-start CadApiInfo
    signal_activate = pyqtSignal()

    def __init__(self, iface, settings, controller, plugin_dir, tab_type):
        """ Class constructor """

        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        QObject.__init__(self)
        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir
        self.new_feature_id = None
        self.layer_new_feature = None
        self.tab_type = tab_type
        self.connected = False
        self.event_id = None
        self.visit_id = None


    def hilight_feature(self, point, rb_list, tab_type=None):

        cursor = QCursor()
        x = cursor.pos().x()
        y = cursor.pos().y()
        click_point = QPoint(x + 5, y + 5)

        visible_layers = self.get_visible_layers(as_list=True)
        scale_zoom = self.iface.mapCanvas().scale()

        # Get layers under mouse clicked
        extras = f'"pointClickCoords":{{"xcoord":{point.x()}, "ycoord":{point.y()}}}, '
        extras += f'"visibleLayers":{visible_layers}, '
        extras += f'"zoomScale":{scale_zoom} '
        body = self.create_body(extras=extras)
        json_result = self.controller.get_json('gw_fct_getlayersfromcoordinates', body)
        if not json_result:
            return False

        # hide QMenu identify if no feature under mouse
        len_layers = len(json_result['body']['data']['layersNames'])
        if len_layers == 0:
            return False

        self.icon_folder = self.plugin_dir + '/icons/'

        # Right click main QMenu
        main_menu = QMenu()

        # Create one menu for each layer
        for layer in json_result['body']['data']['layersNames']:
            layer_name = self.controller.get_layer_by_tablename(layer['layerName'])
            icon = None
            icon_path = self.icon_folder + layer['icon'] + '.png'
            if os.path.exists(str(icon_path)):
                icon = QIcon(icon_path)
                sub_menu = main_menu.addMenu(icon, layer_name.name())
            else:
                sub_menu = main_menu.addMenu(layer_name.name())
            # Create one QAction for each id
            for feature in layer['ids']:
                action = QAction(str(feature['id']), None)
                sub_menu.addAction(action)
                action.triggered.connect(partial(self.set_active_layer, action, tab_type))
                action.hovered.connect(partial(self.draw_by_action, feature, rb_list))

        main_menu.addSeparator()
        # Identify all
        cont = 0
        for layer in json_result['body']['data']['layersNames']:
            cont += len(layer['ids'])
        action = QAction(f'Identify all ({cont})', None)
        action.hovered.connect(partial(self.identify_all, json_result, rb_list))
        main_menu.addAction(action)
        main_menu.addSeparator()
        main_menu.exec_(click_point)


    def identify_all(self, complet_list, rb_list):

        self.resetRubberbands()
        for rb in rb_list:
            rb.reset()
        for layer in complet_list['body']['data']['layersNames']:
            for feature in layer['ids']:
                points = []
                list_coord = re.search('\((.*)\)', str(feature['geometry']))
                coords = list_coord.group(1)
                polygon = coords.split(',')
                for i in range(0, len(polygon)):
                    x, y = polygon[i].split(' ')
                    point = QgsPointXY(float(x), float(y))
                    points.append(point)
                rb = QgsRubberBand(self.canvas)
                polyline = QgsGeometry.fromPolylineXY(points)
                rb.setToGeometry(polyline, None)
                rb.setColor(QColor(255, 0, 0, 100))
                rb.setWidth(5)
                rb.show()
                rb_list.append(rb)


    def draw_by_action(self, feature, rb_list, reset_rb=True):
        """ Draw lines based on geometry """

        for rb in rb_list:
            rb.reset()
        if feature['geometry'] is None:
            return

        list_coord = re.search('\((.*)\)', str(feature['geometry']))
        max_x, max_y, min_x, min_y = self.get_max_rectangle_from_coords(list_coord)
        if reset_rb is True:
            self.resetRubberbands()
        if str(max_x) == str(min_x) and str(max_y) == str(min_y):
            point = QgsPointXY(float(max_x), float(max_y))
            self.draw_point(point)
        else:
            points = self.get_points(list_coord)
            self.draw_polyline(points)


    def set_active_layer(self, action, tab_type):
        """ Set active selected layer """

        parent_menu = action.associatedWidgets()[0]
        layer = self.controller.get_layer_by_layername(parent_menu.title())
        if layer:
            layer_source = self.controller.get_layer_source(layer)
            self.iface.setActiveLayer(layer)
            complet_result, dialog = self.open_form(
                table_name=layer_source['table'], feature_id=action.text(), tab_type=tab_type)
            self.draw(complet_result)



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
        self.tab_visit_loaded = False
        self.tab_event_loaded = False
        self.tab_document_loaded = False
        self.tab_rpt_loaded = False
        self.tab_plan_loaded = False
        self.dlg_is_destroyed = False
        self.layer = None
        self.feature = None
        self.my_json = {}
        self.tab_type = tab_type

        # Get values
        qgis_project_add_schema = self.controller.plugin_settings_value('gwAddSchema')
        qgis_project_main_schema = self.controller.plugin_settings_value('gwMainSchema')
        qgis_project_infotype = self.controller.plugin_settings_value('gwInfoType')
        qgis_project_role = self.controller.plugin_settings_value('gwProjectRole')

        # Check for query layer and/or bad layer
        table_uri = None
        if self.iface.activeLayer() is not None:
            table_uri = self.iface.activeLayer().dataProvider().dataSourceUri()

        if 'SELECT row_number() over ()' in str(table_uri) or 'srid' not in str(table_uri) or \
                self.iface.activeLayer() is None or type(self.iface.activeLayer()) != QgsVectorLayer:
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
            body = self.create_body(feature=feature, extras=extras)
            function_name = 'gw_fct_getfeatureinsert'

        # Click over canvas
        elif point:
            visible_layer = self.get_visible_layers(as_list=True)
            scale_zoom = self.iface.mapCanvas().scale()
            extras += f', "activeLayer":"{active_layer}"'
            extras += f', "visibleLayer":{visible_layer}'
            extras += f', "mainSchema":"{qgis_project_main_schema}"'
            extras += f', "addSchema":"{qgis_project_add_schema}"'
            extras += f', "infoType":"{qgis_project_infotype}"'
            extras += f', "projecRole":"{qgis_project_role}"'
            extras += f', "coordinates":{{"xcoord":{point.x()},"ycoord":{point.y()}, "zoomRatio":{scale_zoom}}}'
            body = self.create_body(extras=extras)
            function_name = 'gw_fct_getinfofromcoordinates'

        # Comes from QPushButtons node1 or node2 from custom form or RightButton
        elif feature_id:
            if is_add_schema is True:
                add_schema = self.controller.plugin_settings_value('gwAddSchema')
                extras = f'"addSchema":"{add_schema}"'
            else:
                extras = '"addSchema":""'
            feature = f'"tableName":"{table_name}", "id":"{feature_id}"'
            body = self.create_body(feature=feature, extras=extras)
            function_name = 'gw_fct_getinfofromid'

        if function_name is None:
            return False, None

        json_result = self.controller.get_json(function_name, body)
        if json_result is None:
            return False, None

        row = [json_result]
        if not row or row[0] is False:
            return False, None

        # When something is wrong
        if row[0]['message']:
            level = 1
            if 'level' in row[0]['message']:
                level = int(row[0]['message']['level'])
            self.controller.show_message(row[0]['message']['text'], level)
            return False, None

        # When insert feature failed
        if row[0]['status'] == "Failed":
            self.controller.show_message(row[0]['message']['text'], 2)
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
            if feature_cat:
                self.manage_new_feature(self.complet_result, dialog)
            return result, dialog

        elif template == 'dimensioning':
            self.lyr_dim = self.controller.get_layer_by_tablename("v_edit_dimensions", show_warning=True)
            if self.lyr_dim:
                self.api_dim = ApiDimensioning(self.iface, self.settings, self.controller, self.plugin_dir)
                feature_id = self.complet_result[0]['body']['feature']['id']
                result, dialog = self.api_dim.open_form(None, self.lyr_dim, self.complet_result, feature_id)
                return result, dialog

        elif template == 'info_feature':
            sub_tag = None
            if feature_cat:
                if feature_cat.feature_type.lower() == 'arc':
                    sub_tag = 'arc'
                else:
                    sub_tag = 'node'
            feature_id = self.complet_result[0]['body']['feature']['id']
            result, dialog = self.open_custom_form(feature_id, self.complet_result, tab_type, sub_tag, is_docker, 
                                                   new_feature=new_feature)
            if feature_cat:
                self.manage_new_feature(self.complet_result, dialog)
            return result, dialog

        elif template == 'visit':
            visit_id = self.complet_result[0]['body']['feature']['id']
            manage_visit = ManageVisit(self.iface, self.settings, self.controller, self.plugin_dir)
            manage_visit.manage_visit(visit_id=visit_id, tag='info')
        else:
            self.controller.log_warning(f"template not managed: {template}")
            return False, None


    def get_layers_visibility(self):

        layers = self.controller.get_layers()
        layers_visibility = {}
        for layer in layers:

            layers_visibility[layer] = self.controller.is_layer_visible(layer)
        return layers_visibility


    def manage_new_feature(self, complet_result, dialog):

        result = complet_result[0]['body']['data']
        for field in result['fields']:
            if 'hidden' in field and field['hidden']: continue
            if 'layoutname' in field and field['layoutname'] == 'lyt_none': continue
            widget = dialog.findChild(QWidget, field['widgetname'])
            value = None
            if type(widget) in (QLineEdit, QPushButton, QSpinBox, QDoubleSpinBox):
                value = utils_giswater.getWidgetText(dialog, widget, return_string_null=False)
            elif type(widget) is QComboBox:
                value = utils_giswater.get_item_data(dialog, widget, 0)
            elif type(widget) is QCheckBox:
                value = utils_giswater.isChecked(dialog, widget)
            elif type(widget) is QgsDateTimeEdit:
                value = utils_giswater.getCalendarDate(dialog, widget)
            else:
                if widget is None:
                    msg = f"Widget {field['columnname']} is not configured or have a bad config"
                    self.controller.show_message(msg)

            if str(value) not in ('', None, -1, "None") and widget.property('columnname'):
                self.my_json[str(widget.property('columnname'))] = str(value)


    def open_generic_form(self, complet_result):

        self.draw(complet_result, zoom=False)
        self.hydro_info_dlg = InfoGenericUi()
        self.load_settings(self.hydro_info_dlg)
        self.hydro_info_dlg.btn_close.clicked.connect(partial(self.close_dialog, self.hydro_info_dlg))
        self.hydro_info_dlg.rejected.connect(partial(self.close_dialog, self.hydro_info_dlg))
        field_id = str(self.complet_result[0]['body']['feature']['idName'])
        result = self.populate_basic_info(self.hydro_info_dlg, complet_result, field_id)

        # Disable button accept for info on generic form
        self.hydro_info_dlg.btn_accept.setEnabled(False)
        self.hydro_info_dlg.rejected.connect(partial(self.resetRubberbands))
        # Open dialog
        self.open_dialog(self.hydro_info_dlg, dlg_name='info_generic')

        return result, self.hydro_info_dlg


    def open_custom_form(self, feature_id, complet_result, tab_type=None, sub_tag=None, is_docker=True, new_feature=None):

        # Dialog
        self.dlg_cf = InfoFeatureUi(sub_tag)
        self.load_settings(self.dlg_cf)
        self.draw(complet_result, zoom=False)

        if feature_id:
            self.dlg_cf.setGeometry(self.dlg_cf.pos().x()+1, self.dlg_cf.pos().y()+7, self.dlg_cf.width(),
                                    self.dlg_cf.height())

        # Get widget controls
        self.tab_main = self.dlg_cf.findChild(QTabWidget, "tab_main")
        self.tab_main.currentChanged.connect(partial(self.tab_activation, self.dlg_cf, new_feature))
        self.tbl_element = self.dlg_cf.findChild(QTableView, "tbl_element")
        utils_giswater.set_qtv_config(self.tbl_element)
        self.tbl_relations = self.dlg_cf.findChild(QTableView, "tbl_relations")
        utils_giswater.set_qtv_config(self.tbl_relations)
        self.tbl_upstream = self.dlg_cf.findChild(QTableView, "tbl_upstream")
        utils_giswater.set_qtv_config(self.tbl_upstream)
        self.tbl_downstream = self.dlg_cf.findChild(QTableView, "tbl_downstream")
        utils_giswater.set_qtv_config(self.tbl_downstream)
        self.tbl_hydrometer = self.dlg_cf.findChild(QTableView, "tbl_hydrometer")
        utils_giswater.set_qtv_config(self.tbl_hydrometer)
        self.tbl_hydrometer_value = self.dlg_cf.findChild(QTableView, "tbl_hydrometer_value")
        utils_giswater.set_qtv_config(self.tbl_hydrometer_value,
                                      QAbstractItemView.SelectItems, QTableView.CurrentChanged)
        self.tbl_visit_cf = self.dlg_cf.findChild(QTableView, "tbl_visit_cf")
        self.tbl_event_cf = self.dlg_cf.findChild(QTableView, "tbl_event_cf")
        utils_giswater.set_qtv_config(self.tbl_event_cf)
        self.tbl_document = self.dlg_cf.findChild(QTableView, "tbl_document")
        utils_giswater.set_qtv_config(self.tbl_document)

        # Get table name
        self.tablename = complet_result[0]['body']['feature']['tableName']

        # Get feature type (Junction, manhole, valve, fountain...)
        self.feature_type = complet_result[0]['body']['feature']['childType']

        # Get tableParent and select layer
        self.table_parent = str(complet_result[0]['body']['feature']['tableParent'])
        schema_name = None
        if 'schemaName' in complet_result[0]['body']['feature']:
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

        # Get the start point and end point of the feature
        if new_feature:
            list_points = self.get_points_from_geometry(self.layer, new_feature)
        else:
            feature = self.get_feature_by_id(self.layer, self.feature_id, self.field_id)
            list_points = self.get_points_from_geometry(self.layer, feature)

        if 'visibleTabs' in complet_result[0]['body']['form']:
            for tab in complet_result[0]['body']['form']['visibleTabs']:
                tabs_to_show.append(tab['tabName'])

        for x in range(self.tab_main.count() - 1, 0, -1):
            if self.tab_main.widget(x).objectName() not in tabs_to_show:
                utils_giswater.remove_tab_by_tabName(self.tab_main, self.tab_main.widget(x).objectName())

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
        self.set_icon(action_edit, "101")
        self.set_icon(action_copy_paste, "107b")
        self.set_icon(action_rotation, "107c")
        self.set_icon(action_catalog, "195")
        self.set_icon(action_workcat, "193")
        self.set_icon(action_mapzone, "213")
        self.set_icon(action_set_to_arc, "212")
        self.set_icon(action_get_arc_id, "209")
        self.set_icon(action_get_parent_id, "210")
        self.set_icon(action_zoom_in, "103")
        self.set_icon(action_zoom_out, "107")
        self.set_icon(action_centered, "104")
        self.set_icon(action_link, "173")
        self.set_icon(action_section, "207")
        self.set_icon(action_help, "73")
        self.set_icon(action_interpolate, "194")

        # Set buttons icon
        # tab elements
        self.set_icon(self.dlg_cf.btn_insert, "111b")
        self.set_icon(self.dlg_cf.btn_delete, "112b")
        self.set_icon(self.dlg_cf.btn_new_element, "131b")
        self.set_icon(self.dlg_cf.btn_open_element, "134b")
        # tab hydrometer
        self.set_icon(self.dlg_cf.btn_link, "70b")
        # tab visit
        self.set_icon(self.dlg_cf.btn_open_visit_2, "65b")
        self.set_icon(self.dlg_cf.btn_new_visit_2, "64b")
        self.set_icon(self.dlg_cf.btn_open_gallery_2, "136b")
        # tab event
        self.set_icon(self.dlg_cf.btn_open_visit, "65b")
        self.set_icon(self.dlg_cf.btn_new_visit, "64b")
        self.set_icon(self.dlg_cf.btn_open_gallery, "136b")
        self.set_icon(self.dlg_cf.btn_open_visit_doc, "170b")
        self.set_icon(self.dlg_cf.btn_open_visit_event, "134b")
        # tab doc
        self.set_icon(self.dlg_cf.btn_doc_insert, "111b")
        self.set_icon(self.dlg_cf.btn_doc_delete, "112b")
        self.set_icon(self.dlg_cf.btn_doc_new, "131b")
        self.set_icon(self.dlg_cf.btn_open_doc, "170b")

        # Get feature type as geom_type (node, arc, connec, gully)
        self.geom_type = str(complet_result[0]['body']['feature']['featureType'])
        if str(self.geom_type) in ('', '[]'):
            if 'feature_cat' in globals():
                parent_layer = self.feature_cat.parent_layer
            else:
                parent_layer = str(complet_result[0]['body']['feature']['tableParent'])
            sql = f"SELECT lower(feature_type) FROM cat_feature WHERE parent_layer = '{parent_layer}' LIMIT 1"
            row = self.controller.get_row(sql)
            if row:
                self.geom_type = row[0]

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
                    self.put_widgets(self.dlg_cf, field, label, widget)

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
                        widget.currentIndexChanged.connect(partial(self.fill_child, self.dlg_cf, widget,
                            self.feature_type, self.tablename, self.field_id))

        # Set variables
        id_name = complet_result[0]['body']['feature']['idName']
        self.filter = str(id_name) + " = '" + str(self.feature_id) + "'"
        dlg_cf = self.dlg_cf
        layer = self.layer
        fid = self.feature_id
        my_json = self.my_json
        if layer:
            if layer.isEditable():
                self.enable_all(dlg_cf, self.complet_result[0]['body']['data'])
            else:
                self.disable_all(dlg_cf, self.complet_result[0]['body']['data'], False)

        # We assign the function to a global variable,
        # since as it receives parameters we will not be able to disconnect the signals
        self.fct_block_action_edit = lambda: self.block_action_edit(dlg_cf, action_edit, result, layer, fid, my_json, new_feature)
        self.fct_start_editing = lambda: self.start_editing(dlg_cf, action_edit, complet_result[0]['body']['data'], layer)
        self.fct_stop_editing = lambda: self.stop_editing(dlg_cf, action_edit, layer, fid, self.my_json, new_feature)
        self.connect_signals()

        self.enable_actions(dlg_cf, layer.isEditable())

        action_edit.setChecked(layer.isEditable())

        # Actions signals
        action_edit.triggered.connect(partial(self.manage_edition, dlg_cf, action_edit, complet_result[0]['body']['data'], fid, new_feature))
        action_catalog.triggered.connect(partial(self.open_catalog, tab_type, self.feature_type))
        action_workcat.triggered.connect(partial(self.get_catalog, 'new_workcat', self.tablename, self.feature_type, self.feature_id, self.field_id, list_points, id_name))
        action_mapzone.triggered.connect(partial(self.get_catalog, 'new_mapzone', self.tablename, self.feature_type, self.feature_id, self.field_id, list_points, id_name))
        action_set_to_arc.triggered.connect(partial(self.get_snapped_feature_id, dlg_cf, action_set_to_arc, 'v_edit_arc', 'set_to_arc', None))
        action_get_arc_id.triggered.connect(partial(self.get_snapped_feature_id, dlg_cf, action_get_arc_id,  'v_edit_arc', 'arc', 'data_arc_id'))
        action_get_parent_id.triggered.connect(partial(self.get_snapped_feature_id, dlg_cf, action_get_parent_id, 'v_edit_node', 'node', 'data_parent_id'))
        action_zoom_in.triggered.connect(partial(self.api_action_zoom_in, self.canvas, layer))
        action_centered.triggered.connect(partial(self.api_action_centered, self.canvas, layer))
        action_zoom_out.triggered.connect(partial(self.api_action_zoom_out, self.canvas, layer))
        action_copy_paste.triggered.connect(partial(self.api_action_copy_paste, dlg_cf, self.geom_type, tab_type))
        action_rotation.triggered.connect(partial(self.action_rotation, dlg_cf, action_rotation))
        action_link.triggered.connect(partial(self.action_open_url, dlg_cf, result))
        action_section.triggered.connect(partial(self.open_section_form))
        action_help.triggered.connect(partial(self.api_action_help, self.geom_type))
        self.ep = QgsMapToolEmitPoint(self.canvas)
        action_interpolate.triggered.connect(partial(self.activate_snapping, complet_result, self.ep))

        btn_cancel = dlg_cf.findChild(QPushButton, 'btn_cancel')
        btn_accept = dlg_cf.findChild(QPushButton, 'btn_accept')
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
            dlg_cf.dlg_closed.connect(partial(self.resetRubberbands))
            dlg_cf.dlg_closed.connect(partial(self.save_settings, dlg_cf))
            dlg_cf.key_escape.connect(partial(self.close_dialog, dlg_cf))
            btn_cancel.clicked.connect(partial(self.manage_info_close, dlg_cf))
        btn_accept.clicked.connect(partial(self.accept_from_btn, dlg_cf, action_edit, result, new_feature, self.my_json))
        dlg_cf.key_enter.connect(partial(self.accept_from_btn, dlg_cf, action_edit, result, new_feature, self.my_json))

        # Set title
        toolbox_cf = dlg_cf.findChild(QWidget, 'toolBox')
        row = self.controller.get_config('admin_customform_param', 'value', 'config_param_system')
        if row:
            results = json.loads(row[0], object_pairs_hook=OrderedDict)
            for result in results['custom_form_tab_labels']:
                toolbox_cf.setItemText(int(result['index']), result['text'])

        # Open dialog
        self.open_dialog(dlg_cf, dlg_name='info_feature')
        dlg_cf.setWindowTitle(title)

        return self.complet_result, dlg_cf


    def action_rotation(self, dialog, action):
        # Set map tool emit point and signals
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.previous_map_tool = self.canvas.mapTool()
        self.canvas.setMapTool(self.emit_point)
        self.emit_point.canvasClicked.connect(partial(self.action_rotation_canvas_clicked, dialog, action))


    def action_rotation_canvas_clicked(self, dialog, action, point, btn):

        if btn == Qt.RightButton:
            self.canvas.setMapTool(self.previous_map_tool)
            return

        existing_point_x = None
        existing_point_y = None
        viewname = self.controller.get_layer_source_table_name(self.layer)
        sql = (f"SELECT ST_X(the_geom), ST_Y(the_geom)"
               f" FROM {viewname}"
               f" WHERE node_id = '{self.feature_id}'")
        row = self.controller.get_row(sql)
        if row:
            existing_point_x = row[0]
            existing_point_y = row[1]

        if existing_point_x:
            sql = (f"UPDATE node"
                   f" SET hemisphere = (SELECT degrees(ST_Azimuth(ST_Point({existing_point_x}, {existing_point_y}), "
                   f" ST_Point({point.x()}, {point.y()}))))"
                   f" WHERE node_id = '{self.feature_id}'")
            status = self.controller.execute_sql(sql)
            if not status:
                self.canvas.setMapTool(self.previous_map_tool)
                return

        sql = (f"SELECT rotation FROM node "
               f" WHERE node_id = '{self.feature_id}'")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(dialog, "data_rotation", str(row[0]))

        sql = (f"SELECT degrees(ST_Azimuth(ST_Point({existing_point_x}, {existing_point_y}),"
               f" ST_Point({point.x()}, {point.y()})))")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(dialog, "data_hemisphere", str(row[0]))
            message = "Hemisphere of the node has been updated. Value is"
            self.controller.show_info(message, parameter=str(row[0]))
        self.api_disable_rotation(dialog)
        self.cancel_snapping_tool(dialog, action)


    def block_action_edit(self, dialog, action_edit, result, layer, fid, my_json, new_feature):

        if self.new_feature_id is not None:
            self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').blockSignals(True)
            save = self.stop_editing(dialog, action_edit, result, fid, my_json, new_feature)
            self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').blockSignals(False)
            if save and not self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').isChecked():
                self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').trigger()
                
        if self.connected is False:
            self.connect_signals()


    def close_dialog(self, dlg=None):
        """ Disconnect signals and call superclass to close dialog """

        super(ApiCF, self).close_dialog(dlg)


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


    def manage_docker_close(self):
        self.roll_back()
        self.resetRubberbands()
        self.controller.close_docker()


    def manage_info_close(self, dialog):

        self.roll_back()
        self.resetRubberbands()
        self.save_settings(dialog)
        self.close_dialog(dialog)


    def get_feature(self, tab_type):
        """ Get current QgsFeature """

        expr_filter = f"{self.field_id} = '{self.feature_id}'"
        self.feature = self.get_feature_by_expr(self.layer, expr_filter)
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
        self.feature = self.get_feature_by_expr(self.layer, expr_filter)
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
                    value = utils_giswater.getWidgetText(self.dlg_cf, widget)
                    if str(value) not in ('', None, -1, "None") and widget.property('columnname'):
                        self.my_json[str(widget.property('columnname'))] = str(value)
                    widget.clearFocus()
        except RuntimeError:
            pass


    def manage_edition(self, dialog, action_edit, result, fid, new_feature=None):
        # With the editing QAction we need to collect the last modified value (self.get_last_value()),
        # since the "editingFinished" signals of the widgets are not detected.
        # Therefore whenever the cursor enters a widget, it will ask if we want to save changes
        if not action_edit.isChecked():
            self.get_last_value()
            if str(self.my_json) == '{}':
                self.check_actions(action_edit, False)
                self.disable_all(dialog, self.complet_result[0]['body']['data'], False)
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
                    self.close_dialog(dialog)
        else:
            self.check_actions(action_edit, True)
            self.enable_all(dialog, self.complet_result[0]['body']['data'])
            self.enable_actions(dialog, True)


    def accept_from_btn(self, dialog, action_edit, result, new_feature, my_json):
        if not action_edit.isChecked():
            self.close_dialog(dialog)
            return

        self.manage_accept(dialog, action_edit, new_feature, my_json, True)


    def manage_accept(self, dialog, action_edit, new_feature, my_json, close_dlg):
        self.get_last_value()
        status = self.accept(dialog, self.complet_result[0], my_json, close_dialog=close_dlg, new_feature=new_feature)
        if status is True:  # Commit succesfull and dialog keep opened
            self.check_actions(action_edit, False)
            self.disable_all(dialog, self.complet_result[0]['body']['data'], False)
            self.enable_actions(dialog, False)


    def stop_editing(self, dialog, action_edit, layer, fid, my_json, new_feature=None):
        if my_json == '' or str(my_json) == '{}':
            self.disconnect_signals()
            # Use commitChanges just for closse edition
            layer.commitChanges()
            self.connect_signals()
            self.check_actions(action_edit, False)
            self.disable_all(dialog, self.complet_result[0]['body']['data'], False)
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
        self.check_actions(action_edit, True)
        self.enable_all(dialog, self.complet_result[0]['body']['data'])
        self.enable_actions(dialog, True)
        layer.startEditing()
        self.connect_signals()


    def ask_for_save(self, action_edit, fid):

        msg = 'Are you sure to save this feature?'
        answer = self.controller.ask_question(msg, "Save feature", None, parameter=fid)
        if not answer:
            self.check_actions(action_edit, True)
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
                label = self.set_setStyleSheet(field, label)
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

        widget = self.add_lineedit(field)
        widget = self.set_widget_size(widget, field)
        widget = self.set_min_max_values(widget, field)
        widget = self.set_reg_exp(widget, field)
        widget = self.set_auto_update_lineedit(field, dialog, widget, new_feature)
        widget = self.set_data_type(field, widget)
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


    def manage_typeahead(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        completer = QCompleter()
        widget = self.manage_text(dialog, complet_result, field, new_feature)
        widget = self.manage_lineedit(field, dialog, widget, completer)
        return widget


    def manage_combo(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = self.add_combobox(field)
        widget = self.set_widget_size(widget, field)
        widget = self.set_auto_update_combobox(field, dialog, widget, new_feature)
        return widget


    def manage_check(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = self.add_checkbox(field)
        widget.stateChanged.connect(partial(self.get_values, dialog, widget, self.my_json))
        widget = self.set_auto_update_checkbox(field, dialog, widget, new_feature)
        return widget


    def manage_datetime(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = self.add_calendar(dialog, field)
        widget = self.set_auto_update_dateedit(field, dialog, widget, new_feature)
        return widget


    def manage_button(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = self.add_button(dialog, field)
        widget = self.set_widget_size(widget, field)
        return widget


    def manage_hyperlink(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = self.add_hyperlink(field)
        widget = self.set_widget_size(widget, field)
        return widget


    def manage_hspacer(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = self.add_horizontal_spacer()
        return widget


    def manage_vspacer(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = self.add_verical_spacer()
        return widget


    def manage_textarea(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = self.add_textarea(field)
        widget = self.set_auto_update_textarea(field, dialog, widget)
        return widget


    def manage_spinbox(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = self.add_spinbox(field)
        widget = self.set_auto_update_spinbox(field, dialog, widget, new_feature)
        return widget


    def manage_doubleSpinbox(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = self.manage_spinbox(dialog, complet_result, field, new_feature)
        return widget


    def manage_tableView(self, dialog, complet_result, field, new_feature):
        """ This function is called in def set_widgets(self, dialog, complet_result, field)
            widget = getattr(self, f"manage_{field['widgettype']}")(dialog, complet_result, field)
        """
        widget = self.add_tableview(complet_result, field)
        widget = self.set_headers(widget, field)
        widget = self.populate_table(widget, field)
        widget = self.set_columns_config(widget, field['widgetname'], sort_order=1, isQStandardItemModel=True)
        utils_giswater.set_qtv_config(widget)
        return widget


    def open_section_form(self):

        dlg_sections = InfoCrossectUi()
        self.load_settings(dlg_sections)

        # Set dialog not resizable
        dlg_sections.setFixedSize(dlg_sections.size())

        feature = '"id":"' + self.feature_id + '"'
        body = self.create_body(feature=feature)
        json_result = self.controller.get_json('gw_fct_getinfocrossection', body)
        if not json_result:
            return False

        # Set image
        img = json_result['body']['data']['shapepng']
        utils_giswater.setImage(dlg_sections, 'lbl_section_image', img)

        # Set values into QLineEdits
        for field in json_result['body']['data']['fields']:
            widget = dlg_sections.findChild(QLineEdit, field['columnname'])
            if widget:
                if 'value' in field:
                    utils_giswater.setWidgetText(dlg_sections, widget, field['value'])

        dlg_sections.btn_close.clicked.connect(partial(self.close_dialog, dlg_sections))
        self.open_dialog(dlg_sections, dlg_name='info_crossect', maximize_button=False)


    def accept(self, dialog, complet_result, _json, p_widget=None, clear_json=False, close_dialog=True, new_feature=None):
        """
        :param dialog:
        :param complet_result:
        :param _json:
        :param p_widget:
        :param clear_json:
        :param close_dialog:
        :param new_feature:
        :return: True if all ok, False if sommething fail, None if close dialog
            (When it is true or false the signals are reconnected, if it is None, it is not necessary to reconnect them)
        """

        self.disconnect_signals()

        # Check if C++ object has been deleted
        if isdeleted(dialog):
            return False

        if _json == '' or str(_json) == '{}':
            if self.controller.dlg_docker:
                self.manage_docker_close()
            self.close_dialog(dialog)
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
                value = utils_giswater.getWidgetText(dialog, widget)
                if value in ('null', None, ''):
                    widget.setStyleSheet("border: 1px solid red")
                    list_mandatory.append(widget_name)

        if list_mandatory:
            msg = "Some mandatory values are missing. Please check the widgets marked in red."
            self.controller.show_warning(msg)
            self.check_actions("actionEdit", True, dialog)
            self.connect_signals()
            return False

        # If we create a new feature
        if self.new_feature_id is not None:
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
                if close_dialog:
                    if self.controller.dlg_docker:
                        self.manage_docker_close()
                    self.close_dialog(dialog)
                return True

            feature = f'"id":"{new_feature.attribute(id_name)}", '

        # If we make an info
        else:
            my_json = json.dumps(_json)
            feature = f'"id":"{self.feature_id}", '
        feature += f'"featureType":"{self.feature_type}", '
        feature += f'"tableName":"{p_table_id}"'
        extras = f'"fields":{my_json}, "reload":"{fields_reload}"'
        body = self.create_body(feature=feature, extras=extras)
        json_result = self.controller.get_json('gw_fct_setfields', body, log_sql=True)

        if not json_result:
            self.connect_signals()
            return False
        if clear_json:
            _json = {}

        if "Accepted" in json_result['status']:
            try:
                level = json_result['message']['level']
                msg = json_result['message']['text']
                self.controller.show_message(msg, message_level=level)
            except KeyError:
                pass
            finally:
                self.reload_fields(dialog, json_result, p_widget)
                self.connect_signals()
        elif "Failed" in json_result['status']:
            # If json_result['status'] is Failed message from database is showed user by get_json-->manage_exception_api
            self.connect_signals()
            return False

        if close_dialog:
            if self.controller.dlg_docker:
                self.manage_docker_close()
            self.close_dialog(dialog)
            return None

        return True


    def get_scale_zoom(self):

        scale_zoom = self.iface.mapCanvas().scale()
        return scale_zoom


    def disable_all(self, dialog, result, enable):

        try:
            widget_list = dialog.findChildren(QWidget)
            for widget in widget_list:
                for field in result['fields']:
                    if widget.objectName() == field['widgetname']:
                        if type(widget) in (QSpinBox, QDoubleSpinBox, QLineEdit, QTextEdit):
                            widget.setReadOnly(not enable)
                            widget.setStyleSheet("QWidget { background: rgb(242, 242, 242); color: rgb(0, 0, 0)}")
                        elif type(widget) in (QComboBox, QgsDateTimeEdit):
                            widget.setEnabled(enable)
                            widget.setStyleSheet("QWidget {color: rgb(0, 0, 0)}")
                        elif type(widget) is QCheckBox:
                            widget.setEnabled(enable)
                        elif type(widget) is QPushButton:
                            # Manage the clickability of the buttons according to the configuration
                            # in the table config_api_form_fields simultaneously with the edition,
                            # but giving preference to the configuration when iseditable is True
                            if not field['iseditable']:
                                widget.setEnabled(field['iseditable'])
        except RuntimeError:
            pass


    def enable_all(self, dialog, result):

        try:
            widget_list = dialog.findChildren(QWidget)
            for widget in widget_list:
                if widget.property('keepDisbled'):
                    continue
                for field in result['fields']:
                    if widget.objectName() == field['widgetname']:
                        if type(widget) in (QSpinBox, QDoubleSpinBox, QLineEdit, QTextEdit):
                            widget.setReadOnly(not field['iseditable'])
                            if not field['iseditable']:
                                widget.setFocusPolicy(Qt.NoFocus)
                                widget.setStyleSheet("QWidget { background: rgb(242, 242, 242); color: rgb(0, 0, 0)}")
                            else:
                                widget.setFocusPolicy(Qt.StrongFocus)
                                widget.setStyleSheet(None)
                        elif type(widget) in (QComboBox, QgsDateTimeEdit):
                            widget.setEnabled(field['iseditable'])
                            widget.setStyleSheet(None)
                            widget.focusPolicy(Qt.StrongFocus) if widget.setEnabled(
                                field['iseditable']) else widget.setFocusPolicy(Qt.NoFocus)
                        elif type(widget) in (QCheckBox, QPushButton):
                            widget.setEnabled(field['iseditable'])
                            widget.focusPolicy(Qt.StrongFocus) if widget.setEnabled(
                                field['iseditable']) else widget.setFocusPolicy(Qt.NoFocus)
        except RuntimeError:
            pass


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

        value = utils_giswater.getWidgetText(dialog, widget, return_string_null=False)
        try:
            getattr(self, f"{widget.property('datatype')}_validator")(value, widget, btn)
        except AttributeError:
            """If the function called by getattr don't exist raise this exception"""
            pass


    def check_min_max_value(self, dialog, widget, btn_accept):

        value = utils_giswater.getWidgetText(dialog, widget, return_string_null=False)
        try:
            if value and ((widget.property('minValue') and float(value) < float(widget.property('minValue'))) or
                    (widget.property('maxValue') and float(value) > float(widget.property('maxValue')))):
                widget.setStyleSheet("border: 1px solid red")
                btn_accept.setEnabled(False)
            else:
                widget.setStyleSheet(None)
                btn_accept.setEnabled(True)
        except ValueError as e:
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
                widget.editingFinished.connect(partial(self.get_values, dialog, widget, _json))
                widget.editingFinished.connect(
                    partial(self.accept, dialog, self.complet_result[0], _json, widget, True, False, new_feature=new_feature))
            else:
                widget.editingFinished.connect(partial(self.get_values, dialog, widget, self.my_json))

            widget.textChanged.connect(partial(self.enabled_accept, dialog))
            widget.textChanged.connect(partial(self.check_datatype_validator, dialog, widget, dialog.btn_accept))
            widget.textChanged.connect(partial(self.check_min_max_value, dialog, widget, dialog.btn_accept))

        return widget


    def set_auto_update_textarea(self, field, dialog, widget):

        if self.check_tab_data(dialog):
            # "and field['widgettype'] != 'typeahead'" It is necessary so that the textchanged signal of the typeahead
            # does not jump, making it lose focus, which will cause the accept function to jump sent invalid parameters
            if field['isautoupdate'] and self.new_feature_id is None and field['widgettype'] != 'typeahead':
                _json = {}
                widget.textChanged.connect(partial(self.clean_my_json, widget))
                widget.textChanged.connect(partial(self.get_values, dialog, widget, _json))
                widget.textChanged.connect(
                    partial(self.accept, dialog, self.complet_result[0], _json, widget, True, False))
            else:
                widget.textChanged.connect(partial(self.get_values, dialog, widget, self.my_json))

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

        # Restore QPushButton stylesheet
        for field in result['body']['data']['fields']:
            widget = dialog.findChild(QLineEdit, f'{field["widgetname"]}')
            if widget is None:
                widget = dialog.findChild(QPushButton, f'{field["widgetname"]}')
            if widget:
                cur_value = utils_giswater.getWidgetText(dialog, widget)
                value = field["value"]
                if str(cur_value) != str(value) and str(value) != '':
                    widget.setText(value)
                    widget.setStyleSheet("border: 2px solid #3ED396")

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
                widget.currentIndexChanged.connect(partial(self.get_values, dialog, widget, _json))
                widget.currentIndexChanged.connect(partial(
                    self.accept, dialog, self.complet_result[0], _json, None, True, False, new_feature=new_feature))
            else:
                widget.currentIndexChanged.connect(partial(self.get_values, dialog, widget, self.my_json))

        return widget


    def set_auto_update_dateedit(self, field, dialog, widget, new_feature):

        if self.check_tab_data(dialog):
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                widget.dateChanged.connect(partial(self.clean_my_json, widget))
                widget.dateChanged.connect(partial(self.get_values, dialog, widget, _json))
                widget.dateChanged.connect(partial(
                    self.accept, dialog, self.complet_result[0], _json, None, True, False, new_feature=new_feature))
            else:
                widget.dateChanged.connect(partial(self.get_values, dialog, widget, self.my_json))

        return widget


    def set_auto_update_spinbox(self, field, dialog, widget, new_feature):

        if self.check_tab_data(dialog):
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                widget.valueChanged.connect(partial(self.clean_my_json, widget))
                widget.valueChanged.connect(partial(self.get_values, dialog, widget, _json))
                widget.valueChanged.connect(partial(
                    self.accept, dialog, self.complet_result[0], _json, None, True, False, new_feature=new_feature))
            else:
                widget.valueChanged.connect(partial(self.get_values, dialog, widget, self.my_json))

        return widget


    def set_auto_update_checkbox(self, field, dialog, widget, new_feature):

        if self.check_tab_data(dialog):
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                widget.stateChanged.connect(partial(self.clean_my_json, widget))
                widget.stateChanged.connect(partial(self.get_values, dialog, widget, _json))
                widget.stateChanged.connect(partial(
                    self.accept, dialog, self.complet_result[0], _json, None, True, False, new_feature=new_feature))
            else:
                widget.stateChanged.connect(partial(self.get_values, dialog, widget, self.my_json))
        return widget


    def open_catalog(self, tab_type, feature_type):

        self.catalog = ApiCatalog(self.iface, self.settings, self.controller, self.plugin_dir)

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

        actions_list = self.dlg_cf.findChildren(QAction)
        for action in actions_list:
            action.setVisible(False)

        if not 'visibleTabs' in self.complet_result[0]['body']['form']:
            return

        for tab in self.complet_result[0]['body']['form']['visibleTabs']:
            if tab['tabName'] == tab_name:
                if tab['tabactions'] is not None:
                    for act in tab['tabactions']:
                        action = self.dlg_cf.findChild(QAction, act['actionName'])
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
        # Tab 'Event'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_visit' and not self.tab_visit_loaded:
            self.fill_tab_visit(self.geom_type)
            self.tab_visit_loaded = True
        elif self.tab_main.widget(index_tab).objectName() == 'tab_event' and not self.tab_event_loaded:
            self.fill_tab_event(self.geom_type)
            self.tab_event_loaded = True
        # Tab 'Documents'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_documents' and not self.tab_document_loaded:
            self.fill_tab_document()
            self.tab_document_loaded = True
        elif self.tab_main.widget(index_tab).objectName() == 'tab_rpt' and not self.tab_rpt_loaded:
            self.fill_tab_rpt(partial(self.complet_result, new_feature))
            self.tab_rpt_loaded = True
        # Tab 'Plan'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_plan' and not self.tab_plan_loaded:
            self.fill_tab_plan(self.complet_result)
            self.tab_plan_loaded = True


    def fill_tab_element(self):
        """ Fill tab 'Element' """

        table_element = "v_ui_element_x_" + self.geom_type
        self.fill_tbl_element_man(self.dlg_cf, self.tbl_element, table_element, self.filter)
        self.set_columns_config(self.tbl_element, table_element)


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
        self.set_completer_object(dialog, self.table_object)


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
        object_id = utils_giswater.getWidgetText(self.dlg_cf, table_object + "_id")
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

        elem = ManageElement(self.iface, self.settings, self.controller, self.plugin_dir)
        elem.manage_element(True, feature, self.geom_type)
        elem.dlg_add_element.accepted.connect(partial(self.manage_element_new, dialog, elem))
        elem.dlg_add_element.rejected.connect(partial(self.manage_element_new, dialog, elem))

        # Set completer
        self.set_completer_object(dialog, self.table_object)

        if element_id:
            utils_giswater.setWidgetText(elem.dlg_add_element, "element_id", element_id)

        # Open dialog
        elem.open_dialog(elem.dlg_add_element)


    def manage_element_new(self, dialog, elem):
        """ Get inserted element_id and add it to current feature """

        if elem.element_id is None:
            return

        utils_giswater.setWidgetText(dialog, "element_id", elem.element_id)
        self.add_object(self.tbl_element, "element", "v_ui_element")
        self.tbl_element.model().select()


    def set_model_to_table(self, widget, table_name, expr_filter=None, edit_strategy=QSqlTableModel.OnManualSubmit):
        """ Set a model with selected filter.
        Attach that model to selected table """

        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set model
        model = QSqlTableModel(db=self.controller.db)
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
            utils_giswater.remove_tab_by_tabName(self.tab_main, "relations")

        else:
            # Manage signal 'doubleClicked'
            self.tbl_relations.doubleClicked.connect(partial(self.open_relation, field_id))


    def fill_tab_relations(self):
        """ Fill tab 'Relations' """

        table_relations = f"v_ui_{self.geom_type}_x_relations"
        self.fill_table(self.tbl_relations, self.schema_name + "." + table_relations, self.filter)
        self.set_columns_config(self.tbl_relations, table_relations)
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

        api_cf = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir, self.tab_type)
        complet_result, dialog = api_cf.open_form(table_name=table_name, feature_id=feature_id, tab_type=self.tab_type)
        if not complet_result:
            self.controller.log_info("FAIL open_relation")
            return
        self.draw(complet_result)


    """ FUNCTIONS RELATED WITH TAB CONNECTIONS """

    def fill_tab_connections(self):
        """ Fill tab 'Connections' """

        filter_ = f"node_id='{self.feature_id}'"
        self.fill_table(self.dlg_cf.tbl_upstream, self.schema_name + ".v_ui_node_x_connection_upstream", filter_)
        self.set_columns_config(self.dlg_cf.tbl_upstream, "v_ui_node_x_connection_upstream")

        self.fill_table(self.dlg_cf.tbl_downstream, self.schema_name + ".v_ui_node_x_connection_downstream", filter_)
        self.set_columns_config(self.dlg_cf.tbl_downstream, "v_ui_node_x_connection_downstream")

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
        api_cf = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir, self.tab_type)
        complet_result, dialog = api_cf.open_form(table_name=table_name, feature_id=feature_id, tab_type=self.tab_type)
        if not complet_result:
            self.controller.log_info("FAIL open_up_down_stream")
            return
        self.draw(complet_result)


    """ FUNCTIONS RELATED WITH TAB HYDROMETER"""

    def fill_tab_hydrometer(self):
        """ Fill tab 'Hydrometer' """

        table_hydro = "v_rtc_hydrometer"
        txt_hydrometer_id = self.dlg_cf.findChild(QLineEdit, "txt_hydrometer_id")
        self.fill_tbl_hydrometer(self.tbl_hydrometer, table_hydro)
        self.set_columns_config(self.tbl_hydrometer, table_hydro)
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
        column_index = utils_giswater.get_col_index_by_col_name(qtable, 'hydrometer_id')
        feature_id = index.sibling(row, column_index).data()

        # return
        api_cf = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir, self.tab_type)
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
        utils_giswater.set_item_data(self.dlg_cf.cmb_cat_period_id_filter, rows, add_empty=True, sort_combo=False)

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
        utils_giswater.set_item_data(self.dlg_cf.cmb_hyd_customer_code, rows_list, 1)

        self.fill_tbl_hydrometer_values(self.tbl_hydrometer_value, table_hydro_value)
        self.set_columns_config(self.tbl_hydrometer_value, table_hydro_value)

        self.dlg_cf.cmb_cat_period_id_filter.currentIndexChanged.connect(
            partial(self.fill_tbl_hydrometer_values, self.tbl_hydrometer_value, table_hydro_value))
        self.dlg_cf.cmb_hyd_customer_code.currentIndexChanged.connect(
            partial(self.fill_tbl_hydrometer_values, self.tbl_hydrometer_value, table_hydro_value))


    def fill_tbl_hydrometer_values(self, qtable, table_name):
        """ Fill the table control to show hydrometers values """

        cat_period = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.cmb_cat_period_id_filter, 1)
        customer_code = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.cmb_hyd_customer_code)
        filter_ = f"connec_id::text = '{self.feature_id}' "
        if cat_period != '':
            filter_ += f" AND cat_period_id::text = '{cat_period}'"
        if customer_code != '':
            filter_ += f" AND hydrometer_id::text = '{customer_code}'"

        # Set model of selected widget
        self.set_model_to_table(qtable, self.schema_name + "." + table_name, filter_, QSqlTableModel.OnFieldChange)
        self.set_columns_config(self.tbl_hydrometer_value, table_name)


    def set_filter_hydrometer_values(self, widget):
        """ Get Filter for table hydrometer value with combo value"""

        # Get combo value
        cat_period_id_filter = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.cmb_cat_period_id_filter, 0)

        # Set filter
        expr = f"{self.field_id} = '{self.feature_id}'"
        expr += f" AND cat_period_id ILIKE '%{cat_period_id_filter}%'"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()


    """ FUNTIONS RELATED WITH TAB VISIT"""

    def fill_tab_visit(self, geom_type):
        """ Fill tab Visit """

        sql = f"SELECT id, ui_tablename FROM {self.schema_name}.config_visit_class WHERE feature_type = upper('{geom_type}')"
        rows = self.controller.get_rows(sql)
        table_visit_node_dict = {}
        for row in rows:
            table_visit_node_dict[row[0]] = str(row[1])
        self.fill_tbl_visit(self.tbl_visit_cf, table_visit_node_dict, self.filter, geom_type)
        # self.tbl_visit_cf.doubleClicked.connect(self.open_visit)


    def fill_tbl_visit(self, widget, table_name, filter_, geom_type):
        """ Fill the table control to show documents """

        # Get widgets
        widget.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.cmb_visit_class = self.dlg_cf.findChild(QComboBox, "cmb_visit_class")
        self.date_visit_to = self.dlg_cf.findChild(QDateEdit, "date_visit_to")
        self.date_visit_from = self.dlg_cf.findChild(QDateEdit, "date_visit_from")
        btn_new_visit = self.dlg_cf.findChild(QPushButton, "btn_new_visit_2")
        date = QDate.currentDate()
        self.date_visit_to.setDate(date)

        btn_open_gallery = self.dlg_cf.findChild(QPushButton, "btn_open_gallery_2")
        btn_open_visit = self.dlg_cf.findChild(QPushButton, "btn_open_visit_2")
        btn_open_gallery.setEnabled(False)

        feature_key = f"{geom_type}_id"
        feature_type = geom_type.upper()

        # Set signals
        widget.clicked.connect(partial(self.tbl_visit_clicked, table_name))
        self.cmb_visit_class.currentIndexChanged.connect(
            partial(self.set_filter_table_visit, widget, table_name, visitClass=True, column_filter=feature_key,
                    value_filter=self.feature_id))
        self.date_visit_to.dateChanged.connect(
            partial(self.set_filter_table_visit, widget, table_name, visitClass=False, column_filter=feature_key,
                    value_filter=self.feature_id))
        self.date_visit_from.dateChanged.connect(
            partial(self.set_filter_table_visit, widget, table_name, visitClass=False, column_filter=feature_key,
                    value_filter=self.feature_id))

        parameters = [widget, table_name, filter_, self.cmb_visit_class, self.feature_id]
        btn_new_visit.clicked.connect(partial(self.new_visit, table_name, refresh_table=parameters, tab='visit'))
        btn_open_gallery.clicked.connect(partial(self.open_visit_files))
        btn_open_visit.clicked.connect(partial(self.open_visit, refresh_table=parameters))

        # Fill ComboBox cmb_visit_class
        sql = ("SELECT DISTINCT(class_id), config_visit_class.idval"
               " FROM " + self.schema_name + ".v_ui_om_visit_x_" + feature_type.lower() + ""
               " JOIN " + self.schema_name + ".config_visit_class ON config_visit_class.id = v_ui_om_visit_x_" + feature_type.lower() + ".class_id"
               " WHERE " + feature_key + " IS NOT NULL AND " + str(feature_key) + " = '" + str(self.feature_id) + "'")
        rows = self.controller.get_rows(sql)
        utils_giswater.set_item_data(self.cmb_visit_class, rows, 1)

        # Get selected dates
        date_from = self.date_visit_from.date().toString('yyyyMMdd 00:00:00')
        date_to = self.date_visit_to.date().toString('yyyyMMdd 23:59:59')
        if date_from > date_to:
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return

        filter_ += " AND startdate >= '" + date_from + "' AND startdate <= '" + date_to + "' ORDER BY startdate desc"

        # Set model of selected widget
        if utils_giswater.get_item_data(self.dlg_cf, self.cmb_visit_class, 0) not in (None, ''):
            table_name = str(table_name[utils_giswater.get_item_data(self.dlg_cf, self.cmb_visit_class, 0)])
            self.controller.plugin_settings_set_value("om_visit_table_name", str(table_name))
            self.set_model_to_table(widget, table_name, filter_)
            self.set_filter_dates('startdate', 'enddate', table_name, self.date_visit_from, self.date_visit_to,
                                column_filter=feature_key, value_filter=self.feature_id, widget=widget)


    def set_filter_table_visit(self, widget, table_name, visitClass=False, column_filter=None, value_filter=None):
        """ Get values selected by the user and sets a new filter for its table model """
        # Get selected dates
        date_from = self.date_visit_from.date().toString('yyyyMMdd 00:00:00')
        date_to = self.date_visit_to.date().toString('yyyyMMdd 23:59:59')

        if date_from > date_to:
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return
        visit_class = utils_giswater.get_item_data(self.dlg_cf, self.cmb_visit_class, 0)

        if visit_class in (None, ''):
            return

        if type(table_name) is dict:
            table_name = str(table_name[visit_class])

        # Set model of selected widget
        if visitClass:
            self.set_model_to_table(widget, table_name, self.filter)
            self.set_filter_dates('startdate', 'enddate', table_name, self.date_visit_from, self.date_visit_to, column_filter, value_filter)

            date_from = self.date_visit_from.date().toString('yyyyMMdd 00:00:00')
            date_to = self.date_visit_to.date().toString('yyyyMMdd 23:59:59')

        # Set filter to model
        expr = self.field_id + " = '" + self.feature_id + "'"
        expr += " AND startdate >= '" + date_from + "' AND startdate <= '" + date_to + "'"

        # Get selected values in Comboboxes
        visit_class_value = utils_giswater.get_item_data(self.dlg_cf, self.cmb_visit_class, 0)
        if str(visit_class_value) != 'null':
            expr += " AND class_id::text = '" + str(visit_class_value) + "'"
        expr += " ORDER BY startdate desc"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()


    def tbl_visit_clicked(self, table_name):

        # Enable/Disable buttons
        btn_open_gallery = self.dlg_cf.findChild(QPushButton, "btn_open_gallery_2")
        btn_open_visit_doc = self.dlg_cf.findChild(QPushButton, "btn_open_visit_doc")
        btn_open_gallery.setEnabled(False)
        btn_open_visit_doc.setEnabled(False)

        # Get selected row
        selected_list = self.tbl_visit_cf.selectionModel().selectedRows()
        selected_row = selected_list[0].row()
        self.visit_id = self.tbl_visit_cf.model().record(selected_row).value("visit_id")
        self.parameter_id = self.tbl_visit_cf.model().record(selected_row).value("parameter_id")

        if type(table_name) is dict:
            table_name = str(table_name[utils_giswater.get_item_data(self.dlg_cf, self.cmb_visit_class, 0)])

        sql = f"SELECT photo FROM {table_name} WHERE photo IS TRUE AND visit_id = '{self.visit_id}'"
        row = self.controller.get_row(sql)

        if not row:
            return

        # If gallery 'True' or 'False'
        if str(row[0]) == 'True':
            btn_open_gallery.setEnabled(True)

    def open_visit_files(self):

        sql = (f"SELECT value FROM om_visit_event_photo"
               f" WHERE visit_id = '{self.visit_id}'")
        rows = self.controller.get_rows(sql, commit=True)
        for path in rows:
            # Parse a URL into components
            url = parse.urlsplit(path[0])

            # Open selected document
            # Check if path is URL
            if url.scheme == "http" or url.scheme == "https":
                # If path is URL open URL in browser
                webbrowser.open(path[0])


    def set_filter_dates(self, mindate, maxdate, table_name, widget_fromdate, widget_todate, column_filter=None, value_filter=None, widget=None):

        if table_name is None:
            return

        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        sql = ("SELECT MIN("+str(mindate)+"), MAX("+str(mindate)+")"
               " FROM {}".format(str(table_name)))
        if column_filter is not None and value_filter is not None:
            sql += " WHERE " + str(column_filter) + " = '" + str(value_filter) + "'"
        row = self.controller.get_row(sql)
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
                self.set_filter_table_visit(widget, table_name)



    """ FUNCTIONS RELATED WITH TAB EVENT"""

    def fill_tab_event(self, geom_type):
        """ Fill tab 'Event' """

        table_event_geom = "v_ui_event_x_" + geom_type
        self.fill_tbl_event(self.tbl_event_cf, table_event_geom, self.filter)
        self.tbl_event_cf.doubleClicked.connect(self.open_visit_event)
        self.set_columns_config(self.tbl_event_cf, table_event_geom)


    def fill_tbl_event(self, widget, table_name, filter_):
        """ Fill the table control to show events """

        # Get widgets
        widget.setSelectionBehavior(QAbstractItemView.SelectRows)
        event_type = self.dlg_cf.findChild(QComboBox, "event_type")
        event_id = self.dlg_cf.findChild(QComboBox, "event_id")
        self.date_event_to = self.dlg_cf.findChild(QDateEdit, "date_event_to")
        self.date_event_from = self.dlg_cf.findChild(QDateEdit, "date_event_from")

        self.set_dates_from_to(self.date_event_from, self.date_event_to, table_name, 'visit_start', 'visit_end')

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
        btn_new_visit.clicked.connect(partial(self.new_visit, table_name, None, tab='event'))
        btn_open_gallery.clicked.connect(partial(self.open_gallery))
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
            utils_giswater.set_item_data(self.dlg_cf.event_id, rows)
        # Fill ComboBox event_type
        sql = (f"SELECT DISTINCT(parameter_type), parameter_type "
               f"FROM {table_name_event_id} "
               f"WHERE feature_type = '{feature_type[self.field_id]}' OR feature_type = 'ALL' "
               f"ORDER BY parameter_type")
        rows = self.controller.get_rows(sql)
        if rows:
            rows.append(['', ''])
            utils_giswater.set_item_data(self.dlg_cf.event_type, rows)

        self.set_model_to_table(widget, table_name)
        self.set_filter_table_event(widget)


    def open_visit_event(self):
        """ Open event of selected record of the table """

        # Open dialog event_standard
        self.dlg_event_full = VisitEventFull()
        self.load_settings(self.dlg_event_full)
        self.dlg_event_full.rejected.connect(partial(self.close_dialog, self.dlg_event_full))
        # Get all data for one visit
        sql = (f"SELECT * FROM om_visit_event"
               f" WHERE id = '{self.event_id}' AND visit_id = '{self.visit_id}'")
        row = self.controller.get_row(sql)
        if not row:
            return

        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.id, row['id'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.event_code, row['event_code'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.visit_id, row['visit_id'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.position_id, row['position_id'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.position_value, row['position_value'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.parameter_id, row['parameter_id'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.value, row['value'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.value1, row['value1'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.value2, row['value2'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.geom1, row['geom1'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.geom2, row['geom2'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.geom3, row['geom3'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.xcoord, row['xcoord'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.ycoord, row['ycoord'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.compass, row['compass'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.tstamp, row['tstamp'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.text, row['text'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.index_val, row['index_val'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.is_last, row['is_last'])
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
        self.dlg_event_full.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_event_full))
        self.dlg_event_full.tbl_docs_x_event.doubleClicked.connect(self.open_file)
        utils_giswater.set_qtv_config(self.dlg_event_full.tbl_docs_x_event)

        self.open_dialog(self.dlg_event_full, 'visit_event_full')


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
        column_index = utils_giswater.get_col_index_by_col_name(self.dlg_event_full.tbl_docs_x_event, 'value')

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
        event_type_value = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.event_type, 0)

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
            utils_giswater.set_item_data(self.dlg_cf.event_id, rows, 1)

        # End cascading filter
        # Get selected values in Comboboxes
        event_type_value = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.event_type, 0)
        event_id = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.event_id, 0)
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
        event_type_value = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.event_type, 0)
        if event_type_value != 'null':
            expr += f" AND parameter_type ILIKE '%{event_type_value}%'"
        event_id = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.event_id, 0)
        if event_id != 'null':
            expr += f" AND parameter_id ILIKE '%{event_id}%'"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()


    def open_visit(self, refresh_table=None):
        """ Call button 65: om_visit_management """

        manage_visit = ManageVisit(self.iface, self.settings, self.controller, self.plugin_dir)
        manage_visit.visit_added.connect(self.update_visit_table)
        manage_visit.edit_visit(self.geom_type, self.feature_id, refresh_table)


    # creat the new visit GUI
    def update_visit_table(self):
        """ Convenience fuction set as slot to update table after a Visit GUI close. """
        table_name = "v_ui_event_x_" + self.geom_type
        self.set_dates_from_to(self.date_visit_from, self.date_visit_to, table_name, 'visit_start', 'visit_end')
        self.tbl_event_cf.model().select()


    def new_visit(self, table_name=None, refresh_table=None, tab=None):
        """ Call button 64: om_add_visit """

        # Get expl_id to save it on om_visit and show the geometry of visit
        expl_id = utils_giswater.get_item_data(self.dlg_cf, self.tab_type + '_expl_id', 0)
        if expl_id == -1:
            msg = "Widget expl_id not found"
            self.controller.show_warning(msg)
            return

        visit_class = utils_giswater.get_item_data(self.dlg_cf, self.cmb_visit_class, 0)
        if type(table_name) is dict and visit_class not in (None, ''):
            table_name = str(table_name[visit_class])
        else:
            table_name = None

        manage_visit = ManageVisit(self.iface, self.settings, self.controller, self.plugin_dir)
        # manage_visit.visit_added.connect(self.update_visit_table)
        # TODO: the following query fix a (for me) misterious bug
        # the DB connection is not available during manage_visit.manage_visit first call
        # so the workaroud is to do a unuseful query to have the dao controller active
        sql = "SELECT id FROM om_visit LIMIT 1"
        self.controller.get_rows(sql)
        manage_visit.manage_visit(geom_type=self.geom_type, feature_id=self.feature_id, expl_id=expl_id,
                                  refresh_table=refresh_table)
        if tab == 'event':
            self.set_filter_dates('visit_start', 'visit_end', table_name, self.date_event_from, self.date_event_to)
        elif tab == 'visit':
            self.set_filter_dates('startdate', 'enddate', table_name, self.date_visit_from, self.date_visit_to)


    def open_gallery(self):
        """ Open gallery of selected record of the table """
        # Open Gallery
        gal = ManageGallery(self.iface, self.settings, self.controller, self.plugin_dir)
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
            self.load_settings(self.dlg_load_doc)
            self.dlg_load_doc.rejected.connect(partial(self.close_dialog, self.dlg_load_doc))
            btn_open_doc = self.dlg_load_doc.findChild(QPushButton, "btn_open")
            btn_open_doc.clicked.connect(self.open_selected_doc)

            lbl_visit_id = self.dlg_load_doc.findChild(QLineEdit, "visit_id")
            lbl_visit_id.setText(str(self.visit_id))

            self.tbl_list_doc = self.dlg_load_doc.findChild(QListWidget, "tbl_list_doc")
            self.tbl_list_doc.itemDoubleClicked.connect(partial(self.open_selected_doc))
            for row in rows:
                item_doc = QListWidgetItem(str(row[0]))
                self.tbl_list_doc.addItem(item_doc)

            self.open_dialog(self.dlg_load_doc, dlg_name='visit_document')


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
        self.set_columns_config(self.tbl_document, table_document)


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
        self.set_dates_from_to(self.date_document_from, self.date_document_to, table_name, 'date', 'date')

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
        utils_giswater.set_item_data(doc_type, rows)

        # Adding auto-completion to a QLineEdit
        self.table_object = "doc"
        self.set_completer_object(dialog, self.table_object)

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
        doc_type_value = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.doc_type, 0)
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

        doc = ManageDocument(self.iface, self.settings, self.controller, self.plugin_dir)
        doc.manage_document(feature=feature, geom_type=self.geom_type)
        doc.dlg_add_doc.accepted.connect(partial(self.manage_document_new, dialog, doc))
        doc.dlg_add_doc.rejected.connect(partial(self.manage_document_new, dialog, doc))

        # Set completer
        self.set_completer_object(dialog, self.table_object)
        if doc_id:
            utils_giswater.setWidgetText(dialog, "doc_id", doc_id)

        # # Open dialog
        # doc.open_dialog(doc.dlg_add_doc)


    def manage_document_new(self, dialog, doc):
        """ Get inserted doc_id and add it to current feature """

        if doc.doc_id is None:
            return

        utils_giswater.setWidgetText(dialog, "doc_id", doc.doc_id)
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
        self.clear_gridlayout(rpt_layout1)
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
                        widget.currentIndexChanged.connect(partial(self.fill_child, dialog, widget, self.feature_type,
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
        body = self.create_body(form, feature, filter_fields)
        function_name = 'gw_fct_getlist'
        json_result = self.controller.get_json(function_name, body)
        if json_result is None:
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
                    self.set_headers(qtable, field)
                    self.populate_table(qtable, field)

        return complet_list


    def get_filter_qtableview(self, standar_model, dialog, widget_list):

        standar_model.clear()
        filter_fields = ""
        for widget in widget_list:
            if type(widget) != QTableView:
                columnname = widget.property('columnname')
                text = utils_giswater.getWidgetText(dialog, widget)
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
        column_index = utils_giswater.get_col_index_by_col_name(qtable, 'sys_id')
        feature_id = index.sibling(row, column_index).data()

        # return
        api_cf = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir, self.tab_type)
        complet_result, dialog = api_cf.open_form(table_name=table_name, feature_id=feature_id, tab_type=self.tab_type)
        if not complet_result:
            self.controller.log_info("FAIL open_rpt_result")
            return

        self.draw(complet_result)


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
            body = self.create_body(form, feature, filter_fields='')
            json_result = self.controller.get_json('gw_fct_getinfoplan', body)
            if not json_result:
                return False

            result = json_result['body']['data']
            if 'fields' not in result:
                self.controller.show_message("No listValues for: " + json_result['body']['data'], 2)
            else:
                for field in json_result['body']['data']['fields']:
                    label = QLabel()
                    if field['widgettype'] == 'divider':
                        for x in range(0, 2):
                            line = self.add_frame(field, x)
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


    def get_catalog(self, form_name, table_name, feature_type, feature_id, field_id, list_points, id_name):
        form = f'"formName":"{form_name}", "tabName":"data", "editable":"TRUE"'
        feature = f'"tableName":"{table_name}", "featureId":"{feature_id}", "feature_type":"{feature_type}"'
        extras = f'"coordinates":{{{list_points}}}'
        body = self.create_body(form, feature, extras=extras)
        json_result = self.controller.get_json('gw_fct_getcatalog', body, log_sql=True)
        if json_result is None:
            return

        dlg_generic = InfoGenericUi()
        self.load_settings(dlg_generic)

        # Set signals
        dlg_generic.btn_close.clicked.connect(partial(self.close_dialog, dlg_generic))
        dlg_generic.rejected.connect(partial(self.close_dialog, dlg_generic))
        dlg_generic.btn_accept.clicked.connect(
            partial(self.set_catalog, dlg_generic, form_name, table_name, feature_id, id_name))

        self.populate_basic_info(dlg_generic, [json_result], field_id)

        # Open dialog
        dlg_generic.setWindowTitle(f"{(form_name.lower()).capitalize().replace('_', ' ')}")
        self.open_dialog(dlg_generic)


    def set_catalog(self, dialog, form_name, table_name, feature_id, id_name):
        """ Insert table 'cat_work'. Add cat_work """

        # Form handling so that the user cannot change values until the process is finished
        self.dlg_cf.setEnabled(False)
        self.controller.notify.task_finished.connect(self._enable_dialog)

        # Manage mandatory fields
        missing_mandatory = False
        widgets = dialog.findChildren(QWidget)
        for widget in widgets:
            widget.setStyleSheet(None)
            # Check mandatory fields
            if widget.property('ismandatory') and utils_giswater.getWidgetText(dialog, widget, False, False) in (None, ''):
                missing_mandatory = True
                widget.setStyleSheet("border: 2px solid red")
        if missing_mandatory:
            message = "Mandatory field is missing. Please, set a value"
            self.controller.show_warning(message)
            self._enable_dialog()
            return


        # Get widgets values
        values = {}
        for widget in widgets:
            if widget.property('columnname') in (None, ''): continue
            values = self.get_values(dialog, widget, values)
        fields = json.dumps(values)

        # Call gw_fct_setcatalog
        fields = f'"fields":{fields}'
        form = f'"formName":"{form_name}"'
        feature = f'"tableName":"{table_name}", "id":"{feature_id}", "idName":"{id_name}"'
        body = self.create_body(form, feature, extras=fields)
        result = self.controller.get_json('gw_fct_setcatalog', body)
        if result['status'] != 'Accepted':
            return

        # Set new value to the corresponding widget
        for field in result['body']['data']['fields']:
            widget = self.dlg_cf.findChild(QWidget, field['widgetname'])
            if widget.property('typeahead'):
                self.set_completer_object_api(QCompleter(), QStringListModel(), widget, field['comboIds'])
                utils_giswater.setWidgetText(self.dlg_cf, widget, field['selectedId'])
                self.my_json[str(widget.property('columnname'))] = field['selectedId']
            elif type(widget) == QComboBox:
                widget = self.populate_combo(widget, field)
                utils_giswater.set_combo_itemData(widget, field['selectedId'], 0)
                widget.setProperty('selectedId', field['selectedId'])
                self.my_json[str(widget.property('columnname'))] = field['selectedId']

        self.close_dialog(dialog)


    def _enable_dialog(self):
        self.dlg_cf.setEnabled(True)
        self.controller.notify.task_finished.disconnect()


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


    def get_snapped_feature_id(self, dialog, action, layer_name, option, widget_name):
        """ Snap feature and set a value into dialog """

        layer = self.controller.get_layer_by_tablename(layer_name)
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

        # Snapper
        self.snapper_manager = SnappingConfigManager(self.iface)
        self.snapper_manager.set_controller(self.controller)
        self.snapper = self.snapper_manager.get_snapper()

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Disable snapping
        self.snapper_manager.enable_snapping()

        # Set snapping to 'arc' and 'node'
        self.snapper_manager.set_snapping_layers()

        # if we are doing info over connec or over node
        if option in ('arc', 'set_to_arc'):
            self.snapper_manager.snap_to_arc()
        elif option == 'node':
            self.snapper_manager.snap_to_node()

        # Set signals
        self.canvas.xyCoordinates.connect(partial(self.mouse_moved, layer))
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.emit_point.canvasClicked.connect(partial(self.get_id, dialog, action, option))


    def mouse_moved(self, layer, point):
        """ Mouse motion detection """

        # Set active layer
        self.disconnect_signals()
        self.iface.setActiveLayer(layer)
        self.connect_signals()
        layer_name = self.controller.get_layer_source_table_name(layer)

        # Get clicked point
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if self.snapper_manager.result_is_valid():
            layer = self.snapper_manager.get_snapped_layer(result)
            # Check feature
            viewname = self.controller.get_layer_source_table_name(layer)
            if viewname == layer_name:
                self.snapper_manager.add_marker(result, self.vertex_marker)


    def get_id(self, dialog, action, option, point, event):
        """ Get selected attribute from snapped feature """
        # @options{'key':['att to get from snapped feature', 'widget name destination or function_name to call']}
        options = {'arc': ['arc_id', 'data_arc_id'], 'node': ['node_id', 'data_parent_id'], 'set_to_arc': ['arc_id', 'set_to_arc']}

        if event == Qt.RightButton:
            self.disconnect_snapping(False)
            self.cancel_snapping_tool(dialog, action)
            return

        # Get coordinates
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)

        if not self.snapper_manager.result_is_valid():
            return
        # Get the point. Leave selection
        snapped_feat = self.snapper_manager.get_snapped_feature(result)
        feat_id = snapped_feat.attribute(f'{options[option][0]}')
        if option in ('arc', 'node'):
            widget = dialog.findChild(QWidget, f"{options[option][1]}")
            widget.setFocus()
            utils_giswater.setWidgetText(dialog, widget, str(feat_id))
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

        w_dma_id = self.dlg_cf.findChild(QWidget, 'data_dma_id')
        dma_id = utils_giswater.getWidgetText(self.dlg_cf, w_dma_id)
        w_presszone_id = self.dlg_cf.findChild(QComboBox, 'data_presszone_id')
        presszone_id = utils_giswater.get_item_data(self.dlg_cf, w_presszone_id)
        w_sector_id = self.dlg_cf.findChild(QComboBox, 'data_sector_id')
        sector_id = utils_giswater.get_item_data(self.dlg_cf, w_sector_id)
        w_dqa_id = self.dlg_cf.findChild(QComboBox, 'data_dqa_id')
        dqa_id = utils_giswater.get_item_data(self.dlg_cf, w_dqa_id)

        feature = f'"featureType":"{self.feature_type}", "id":"{self.feature_id}"'
        extras = (f'"arcId":"{feat_id}", "dmaId":"{dma_id}", "presszoneId":"{presszone_id}", "sectorId":"{sector_id}", '
                  f'"dqaId":"{dqa_id}"')
        body = self.create_body(feature=feature, extras=extras)
        json_result = self.controller.get_json('gw_fct_settoarc', body, log_sql=True)
        if 'status' in json_result and json_result['status'] == 'Accepted':
            if json_result['message']:
                level = 1
                if 'level' in json_result['message']:
                    level = int(json_result['message']['level'])
                self.controller.show_message(json_result['message']['text'], level)


    def cancel_snapping_tool(self, dialog, action):

        self.disconnect_snapping(False)
        dialog.blockSignals(False)
        action.setChecked(False)
        self.signal_activate.emit()


    def disconnect_snapping(self, action_pan=True):
        """ Select 'Pan' as current map tool and disconnect snapping """

        try:
            self.canvas.xyCoordinates.disconnect()
            self.emit_point.canvasClicked.disconnect()
            if action_pan:
                self.iface.actionPan().trigger()
            self.vertex_marker.hide()
        except Exception as e:
            self.controller.log_info(f"{type(e).__name__} --> {e}")


    """ OTHER FUNCTIONS """

    def set_image(self, dialog, widget):
        utils_giswater.setImage(dialog, widget, "ws_shape.png")



    """ FUNCTIONS ASSOCIATED TO BUTTONS FROM POSTGRES"""

    def get_info_node(self, **kwargs):
        """ Function called in class ApiParent.add_button(...) -->
                widget.clicked.connect(partial(getattr(self, function_name), **kwargs)) """

        dialog = kwargs['dialog']
        widget = kwargs['widget']

        feature_id = utils_giswater.getWidgetText(dialog, widget)
        self.ApiCF = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir, self.tab_type)
        complet_result, dialog = self.ApiCF.open_form(table_name='v_edit_node', feature_id=feature_id,
            tab_type=self.tab_type, is_docker=False)
        if not complet_result:
            self.controller.log_info("FAIL open_node")
            return

        self.draw(complet_result)

