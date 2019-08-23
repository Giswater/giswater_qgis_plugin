"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: latin-1 -*-
try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    from qgis.core import QgsPoint as QgsPointXY
    from qgis.PyQt.QtGui import QStringListModel
    import urlparse as parse
else:
    from qgis.core import QgsPointXY
    from qgis.PyQt.QtCore import QStringListModel
    import urllib.parse as parse

from qgis.PyQt.QtCore import QDate, QPoint, Qt
from qgis.PyQt.QtGui import QColor, QCursor, QIcon, QStandardItem, QStandardItemModel
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QAction, QAbstractItemView, QCheckBox, QComboBox, QCompleter, QDoubleSpinBox, \
    QDateEdit,QGridLayout, QLabel, QLineEdit, QListWidget, QListWidgetItem, QMenu, QPushButton, QSizePolicy, \
    QSpinBox, QSpacerItem, QTableView, QTabWidget, QWidget, QTextEdit
from qgis.core import QgsMapToPixel, QgsGeometry
from qgis.gui import QgsDateTimeEdit, QgsMapToolEmitPoint, QgsRubberBand

import json
import os
import re
import subprocess
import sys
import webbrowser
from collections import OrderedDict
from functools import partial

from .. import utils_giswater
from .api_parent import ApiParent
from .manage_document import ManageDocument
from .manage_element import ManageElement
from .manage_visit import ManageVisit
from .manage_gallery import ManageGallery
from .api_catalog import ApiCatalog
from ..ui_manager import ApiCfUi, NewWorkcat, EventFull, LoadDocuments, Sections, ApiBasicInfo


class ApiCF(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir, tab_type):
        """ Class constructor """

        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir
        self.new_feature_id = None
        self.layer_new_feature = None
        self.tab_type = tab_type


    def hilight_feature(self, point, rb_list, tab_type=None):

        cursor = QCursor()
        x = cursor.pos().x()
        y = cursor.pos().y()
        click_point = QPoint(x + 5, y + 5)

        visible_layers = self.get_visible_layers(as_list=True)
        scale_zoom = self.iface.mapCanvas().scale()
        srid = self.controller.plugin_settings_value('srid')

        extras = '"pointClickCoords":{"xcoord":' + str(point.x()) + ', "ycoord":' + str(point.y()) + '}, '
        extras += '"visibleLayers":' + str(visible_layers) + ', '
        extras += '"zoomScale":' + str(scale_zoom) + ', '
        extras += '"srid":' + str(srid)
        body = self.create_body(extras=extras)
        # Get layers under mouse clicked
        sql = ("SELECT gw_api_getlayersfromcoordinates($${" + body + "}$$)::text")
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if not row:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return False
        complet_list = [json.loads(row[0], object_pairs_hook=OrderedDict)]

        # hide QMenu identify if no feature under mouse
        len_layers = len(complet_list[0]['body']['data']['layersNames'])
        if len_layers == 0:
            return False
        self.icon_folder = self.plugin_dir + '/icons/'

        # Right click main QMenu
        main_menu = QMenu()

        # Create one menu for each layer
        for layer in complet_list[0]['body']['data']['layersNames']:
            layer_name = self.controller.get_layer_by_tablename(layer['layerName'])
            icon = None
            icon_path = self.icon_folder + layer['icon'] + '.svg'
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
        for layer in complet_list[0]['body']['data']['layersNames']:
            cont += len(layer['ids'])
        action = QAction('Identify all (' + str(cont) + ')', None)
        action.hovered.connect(partial(self.identify_all, complet_list, rb_list))
        main_menu.addAction(action)
        main_menu.addSeparator()

        main_menu.exec_(click_point)


    def identify_all(self, complet_list, rb_list):

        self.resetRubberbands()
        for rb in rb_list:
            rb.reset()
        for layer in complet_list[0]['body']['data']['layersNames']:
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
                if Qgis.QGIS_VERSION_INT < 29900:
                    polyline = QgsGeometry.fromPolyline(points)
                else:
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
            table_name = self.controller.get_layer_source(layer)
            self.iface.setActiveLayer(layer)
            complet_result, dialog = self.open_form(
                table_name=table_name['table'], feature_id=action.text(), tab_type=tab_type)
            self.draw(complet_result)


    def open_form(self, point=None, table_name=None, feature_id=None, feature_cat=None, new_feature_id=None,
                  layer_new_feature=None, tab_type=None, new_feature=None):
        """
        :param point: point where use clicked
        :param table_name: table where do sql query
        :param feature_type: (arc, node, connec...)
        :param feature_id: id of feature to do info
        :return:
        """

        # Manage tab signal
        self.tab_element_loaded = False
        self.tab_relations_loaded = False
        self.tab_connections_loaded = False
        self.tab_conections_loaded = False
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

        # Get srid
        self.srid = self.controller.plugin_settings_value('srid')
        self.new_feature = new_feature
        if self.iface.activeLayer() is None:
            active_layer = ""
        else:
            active_layer = self.controller.get_layer_source_table_name(self.iface.activeLayer())

        if active_layer is None:
            active_layer = ""

        # Used by action_interpolate
        last_click = self.canvas.mouseLastXY()
        self.last_point = QgsMapToPixel.toMapCoordinates(
            self.canvas.getCoordinateTransform(), last_click.x(), last_click.y())

        visible_layers = self.get_visible_layers()
        scale_zoom = self.iface.mapCanvas().scale()
        is_project_editable = self.get_editable_project()

        if tab_type == 'inp':
            extras = '"toolBar":"epa"'
        elif tab_type == 'data':
            extras = '"toolBar":"basic"'
        role = self.controller.get_restriction()
        extras += ', "rolePermissions":"' + role + '"'

        # IF insert new feature
        if point and feature_cat:
            self.feature_cat = feature_cat
            self.new_feature_id = new_feature_id
            self.layer_new_feature = layer_new_feature
            self.iface.actionPan().trigger()
            feature = '"tableName":"' + str(feature_cat.child_layer.lower()) + '"'
            extras += ', "coordinates":{'+str(point) + '}'
            body = self.create_body(feature=feature, extras=extras)
            sql = ("SELECT gw_api_getfeatureinsert($${" + body + "}$$)")
        # IF click over canvas
        elif point:
            visible_layer = self.get_visible_layers(as_list=True)
            extras += ', "activeLayer":"'+active_layer+'"'
            extras += ', "visibleLayer":'+visible_layer+''
            extras += ', "coordinates":{"epsg":'+str(self.srid)+', "xcoord":' + str(point.x()) + ',"ycoord":' + str(point.y()) + ', "zoomRatio":1000}'
            body = self.create_body(extras=extras)
            sql = ("SELECT gw_api_getinfofromcoordinates($${" + body + "}$$)")
        # IF come from QPushButtons node1 or node2 from custom form or RightButton
        elif feature_id:
            feature = '"tableName":"' + str(table_name) + '", "id":"' + str(feature_id) + '"'
            body = self.create_body(feature=feature, extras=extras)
            sql = ("SELECT gw_api_getinfofromid($${" + body + "}$$)")

        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if not row:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return False, None

        # When info is nothing
        if 'results' in row[0]:
            if row[0]['results'] == 0:
                self.controller.show_message(row[0]['message']['text'], 1)
                return False, None

        # When insert feature failed
        if row[0]['status'] == "Failed":
            self.controller.show_message(row[0]['message']['text'], 2)
            return False, None

        # Control fail when insert new feature
        if 'status' in row[0]['body']['data']['fields']:
            if row[0]['body']['data']['fields']['status'].lower() == 'failed':
                msg = row[0]['body']['data']['fields']['message']['text']
                priority = int(row[0]['body']['data']['fields']['message']['priority'])
                self.controller.show_message(msg, message_level=priority)
                return False, None

        self.complet_result = row

        result = row[0]['body']['data']
        if 'fields' not in result:
            self.controller.show_message("NOT fileds in result FOR: " + sql, 2)
            return False, None

        if self.complet_result[0]['body']['form']['template'] == 'GENERIC':
            result, dialog = self.open_generic_form(self.complet_result)
            # Fill self.my_json for new feature
            if feature_cat is not None:
                self.manage_new_feature(self.complet_result, dialog)
            return result, dialog

        elif self.complet_result[0]['body']['form']['template'] == 'custom feature':
            result, dialog = self.open_custom_form(feature_id, self.complet_result, tab_type)
            if feature_cat is not None:
                self.manage_new_feature(self.complet_result, dialog)

            return result, dialog


    def manage_new_feature(self, complet_result, dialog):

        result = complet_result[0]['body']['data']
        for field in result['fields']:
            widget = dialog.findChild(QWidget, field['widgetname'])
            value = None
            if type(widget) in(QLineEdit, QPushButton):
                value = utils_giswater.getWidgetText(dialog, widget, return_string_null=False)
            elif type(widget) is QComboBox:
                value = utils_giswater.get_item_data(dialog, widget, 0)
            elif type(widget) is QCheckBox:
                value = utils_giswater.isChecked(dialog, widget)
            elif type(widget) is QgsDateTimeEdit:
                value = utils_giswater.getCalendarDate(dialog, widget)
            else:
                if widget is None:
                    msg = "Widget {} is not configured or have a bad config".format(field['widgetname'])
                    self.controller.show_message(msg)

            if str(value) != '' and value is not None and value is not -1:
                self.my_json[str(widget.property('column_id'))] = str(value)

        self.controller.log_info(str(self.my_json))


    def open_generic_form(self, complet_result):

        self.hydro_info_dlg = ApiBasicInfo()
        self.load_settings(self.hydro_info_dlg)
        self.hydro_info_dlg.btn_close.clicked.connect(partial(self.close_dialog, self.hydro_info_dlg))
        self.hydro_info_dlg.rejected.connect(partial(self.close_dialog, self.hydro_info_dlg))
        field_id = str(self.complet_result[0]['body']['feature']['idName'])
        result = self.populate_basic_info(self.hydro_info_dlg, complet_result, field_id)

        # Disable button accept for info on generic form
        self.hydro_info_dlg.btn_accept.setEnabled(False)

        # Open dialog
        self.open_dialog(self.hydro_info_dlg)
        
        return result, self.hydro_info_dlg


    def open_custom_form(self, feature_id, complet_result, tab_type=None):

        # Dialog
        self.dlg_cf = ApiCfUi()
        self.load_settings(self.dlg_cf)
        self.draw(complet_result, zoom=False)

        if feature_id:
            self.dlg_cf.setGeometry(self.dlg_cf.pos().x() + 25, self.dlg_cf.pos().y() + 25, self.dlg_cf.width(),
                                    self.dlg_cf.height())

        # Get widget controls
        self.tab_main = self.dlg_cf.findChild(QTabWidget, "tab_main")
        self.tab_main.currentChanged.connect(self.tab_activation)
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
        utils_giswater.set_qtv_config(self.tbl_hydrometer_value, QAbstractItemView.SelectItems, QTableView.CurrentChanged)
        self.tbl_event_cf = self.dlg_cf.findChild(QTableView, "tbl_event_cf")
        utils_giswater.set_qtv_config(self.tbl_event_cf)
        self.tbl_document = self.dlg_cf.findChild(QTableView, "tbl_document")
        utils_giswater.set_qtv_config(self.tbl_document)

        # Get table name for use as title
        self.tablename = complet_result[0]['body']['feature']['tableName']
        pos_ini = complet_result[0]['body']['feature']['tableName'].rfind("_")
        pos_fi = len(str(complet_result[0]['body']['feature']['tableName']))
        # Get feature type (Junction, manhole, valve, fountain...)
        self.feature_type = complet_result[0]['body']['feature']['tableName'][pos_ini + 1:pos_fi]
        self.dlg_cf.setWindowTitle(self.feature_type.capitalize())

        # Get tableParent and select layer
        self.table_parent = str(complet_result[0]['body']['feature']['tableParent'])
        self.layer = self.controller.get_layer_by_tablename(self.table_parent)
        if self.layer:
            self.iface.setActiveLayer(self.layer)
        else:
            self.controller.show_message("Layer not found: " + self.table_parent, 2)
            return False, self.dlg_cf

        # Remove unused tabs
        tabs_to_show = []
        # tabs_to_show = [tab['tabname'] for tab in complet_result[0]['form']['visibleTabs']]
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
        action_zoom_in = self.dlg_cf.findChild(QAction, "actionZoom")
        action_zoom_out = self.dlg_cf.findChild(QAction, "actionZoomOut")
        action_centered = self.dlg_cf.findChild(QAction, "actionCentered")
        action_link = self.dlg_cf.findChild(QAction, "actionLink")
        action_help = self.dlg_cf.findChild(QAction, "actionHelp")
        action_interpolate = self.dlg_cf.findChild(QAction, "actionInterpolate")
        # action_switch_arc_id = self.dlg_cf.findChild(QAction, "actionSwicthArcid")
        action_section = self.dlg_cf.findChild(QAction, "actionSection")

        self.show_actions('tab_data')

        # TODO action_edit.setEnabled(lo que venga del json segun permisos)
        # action_edit.setVisible(True)
        # action_edit.setEnabled(True)

        # Set actions icon
        self.set_icon(action_edit, "101")
        self.set_icon(action_copy_paste, "107b")
        self.set_icon(action_rotation, "107c")
        self.set_icon(action_catalog, "195")
        self.set_icon(action_workcat, "193")
        self.set_icon(action_zoom_in, "103")
        self.set_icon(action_zoom_out, "107")
        self.set_icon(action_centered, "104")
        self.set_icon(action_link, "173")
        self.set_icon(action_section, "207")
        self.set_icon(action_help, "73")
        self.set_icon(action_interpolate, "194")
        # self.set_icon(action_switch_arc_id, "141")

        # Set buttons icon
        # tab elements
        self.set_icon(self.dlg_cf.btn_insert, "111b")
        self.set_icon(self.dlg_cf.btn_delete, "112b")
        self.set_icon(self.dlg_cf.btn_new_element, "131b")
        self.set_icon(self.dlg_cf.btn_open_element, "134b")
        # tab hydrometer
        self.set_icon(self.dlg_cf.btn_link, "70b")
        # tab om
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

        # Get feature type as geom_type (node, arc, connec)
        self.geom_type = str(complet_result[0]['body']['feature']['featureType'])

        if self.geom_type == '[]':
            if 'feature_cat' in globals():
                parent_layer = self.feature_cat.parent_layer
            else:
                parent_layer = str(complet_result[0]['body']['feature']['tableParent'])
            sql = "SELECT type FROM cat_feature WHERE  parent_layer = '" + str(parent_layer) + "' LIMIT 1"
            result = self.controller.get_row(sql, log_sql=True, commit=True)
            self.geom_type = result[0]

        # Get field id name
        self.field_id = str(complet_result[0]['body']['feature']['idName'])

        # Get feature_type
        sql = ("SELECT system_id "
               "FROM " + self.schema_name + ".cat_feature "
               "WHERE child_layer = '" + self.tablename + "'")
        feature_type = self.controller.get_row(sql, log_sql=True, commit=True)

        self.feature_id = None
        result = complet_result[0]['body']['data']
        layout_list = []

        for field in complet_result[0]['body']['data']['fields']:
            label, widget = self.set_widgets(self.dlg_cf, complet_result, field)
            layout = self.dlg_cf.findChild(QGridLayout, field['layoutname'])

            # Take the QGridLayout with the intention of adding a QSpacerItem later
            if layout not in layout_list and layout.objectName() not in ('top_layout', 'bot_layout_1', 'bot_layout_2'):
                layout_list.append(layout)

            # Add widgets into layout
            if field['layoutname'] in ('top_layout', 'bot_layout_1', 'bot_layout_2'):
                layout.addWidget(label, 0, field['layout_order'])
                layout.addWidget(widget, 1, field['layout_order'])
            else:
                self.put_widgets(self.dlg_cf, field, label, widget)

        # Add a QSpacerItem into each QGridLayout of the list
        for layout in layout_list:
            vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
            layout.addItem(vertical_spacer1)

        # Find combo parents:
        for field in result['fields']:
            if field['isparent']:
                if field['widgettype'] == 'combo':
                    widget = self.dlg_cf.findChild(QComboBox, field['widgetname'])
                    if widget is not None:
                        widget.currentIndexChanged.connect(partial(self.fill_child, self.dlg_cf, widget))

        # Set variables
        self.filter = str(complet_result[0]['body']['feature']['idName']) + " = '" + str(self.feature_id) + "'"

        if self.layer:
            if self.layer.isEditable():
                self.enable_all(self.dlg_cf, result)
            else:
                self.disable_all(self.dlg_cf, result, False)

        if action_edit.isVisible():
            # SIGNALS
            self.layer.editingStarted.connect(partial(self.check_actions, action_edit, True))
            self.layer.editingStopped.connect(partial(self.check_actions, action_edit, False))
            self.layer.editingStarted.connect(partial(self.enable_all, self.dlg_cf, result))
            self.layer.editingStopped.connect(partial(self.disable_all, self.dlg_cf, result, False))
            # Actions
            self.enable_actions(self.layer.isEditable())
            self.layer.editingStarted.connect(partial(self.enable_actions, True))
            self.layer.editingStopped.connect(partial(self.enable_actions, False))

        action_edit.setChecked(self.layer.isEditable())
        action_edit.triggered.connect(partial(self.start_editing, self.layer))
        action_catalog.triggered.connect(partial(self.open_catalog, tab_type, feature_type))
        action_workcat.triggered.connect(partial(self.cf_new_workcat, tab_type))
        action_zoom_in.triggered.connect(partial(self.api_action_zoom_in, self.feature, self.canvas, self.layer))
        action_centered.triggered.connect(partial(self.api_action_centered, self.feature, self.canvas, self.layer))
        action_zoom_out.triggered.connect(partial(self.api_action_zoom_out, self.feature, self.canvas, self.layer))
        action_copy_paste.triggered.connect(partial(self.api_action_copy_paste, self.dlg_cf, self.geom_type, tab_type))
        action_rotation.triggered.connect(partial(self.action_rotation, self.dlg_cf))
        action_link.triggered.connect(partial(self.action_open_url, self.dlg_cf, result))
        action_section.triggered.connect(partial(self.open_section_form))
        action_help.triggered.connect(partial(self.api_action_help, self.geom_type))
        ep = QgsMapToolEmitPoint(self.canvas)
        action_interpolate.triggered.connect(partial(self.activate_snapping, ep))

        # Buttons
        btn_cancel = self.dlg_cf.findChild(QPushButton, 'btn_cancel')
        btn_accept = self.dlg_cf.findChild(QPushButton, 'btn_accept')
        btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_cf))
        btn_accept.clicked.connect(partial(self.accept, self.dlg_cf, self.complet_result[0], self.feature_id, self.my_json))
        self.dlg_cf.dlg_closed.connect(partial(self.resetRubberbands))
        self.dlg_cf.dlg_closed.connect(partial(self.save_settings, self.dlg_cf))
        self.dlg_cf.key_pressed.connect(partial(self.close_dialog, self.dlg_cf))

        # Open dialog
        self.open_dialog(self.dlg_cf)
        return self.complet_result, self.dlg_cf


    def start_editing(self, layer):
        """ start or stop the edition based on your current status """

        self.iface.setActiveLayer(layer)
        self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').trigger()
        action_is_checked = not self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').isChecked()
        # If the json is empty, we simply activate/deactivate the editing
        # else if editing is active, deactivate edition and save changes
        if self.my_json == '' or str(self.my_json) == '{}':
            return
        elif action_is_checked:
            self.accept(self.dlg_cf, self.complet_result[0], self.feature_id, self.my_json, close_dialog=False)


    def roll_back(self):
        """ discard changes in current layer """

        self.iface.actionRollbackEdits().trigger()


    def set_setStyleSheet(self, field, widget, wtype='label'):

        if field['stylesheet'] is not None:
            if wtype in field['stylesheet']:
                widget.setStyleSheet("QWidget{" + field['stylesheet'][wtype] + "}")
        return widget


    def set_widgets(self, dialog, complet_result, field):

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
        if field['widgettype'] == 'text' or field['widgettype'] == 'typeahead':
            completer = QCompleter()
            widget = self.add_lineedit(field)
            widget = self.set_widget_size(widget, field)
            widget = self.set_auto_update_lineedit(field, dialog, widget)
            widget = self.set_data_type(field, widget)
            if field['widgettype'] == 'typeahead':
                widget = self.manage_lineedit(field, dialog, widget, completer)
            if widget.property('column_id') == self.field_id:
                self.feature_id = widget.text()
                # Get selected feature
                self.feature = self.get_feature_by_id(self.layer, self.feature_id, self.field_id)
        elif field['widgettype'] == 'combo':
            widget = self.add_combobox(field)
            widget = self.set_widget_size(widget, field)
            widget = self.set_auto_update_combobox(field, dialog, widget)
        elif field['widgettype'] == 'check':
            widget = self.add_checkbox(dialog, field)
            widget = self.set_auto_update_checkbox(field, dialog, widget)
        elif field['widgettype'] == 'datepickertime':
            widget = self.add_calendar(dialog, field)
            widget = self.set_auto_update_dateedit(field, dialog, widget)
        elif field['widgettype'] == 'button':
            widget = self.add_button(dialog, field)
            widget = self.set_widget_size(widget, field)
        elif field['widgettype'] == 'hyperlink':
            widget = self.add_hyperlink(dialog, field)
            widget = self.set_widget_size(widget, field)
        elif field['widgettype'] == 'hspacer':
            widget = self.add_horizontal_spacer()
        elif field['widgettype'] == 'vspacer':
            widget = self.add_verical_spacer()
        elif field['widgettype'] == 'textarea':
            widget = self.add_textarea(field)
        elif field['widgettype'] in ('spinbox', 'doubleSpinbox'):
            widget = self.add_spinbox(field)
            widget = self.set_auto_update_spinbox(field, dialog, widget)
        elif field['widgettype'] == 'tableView':
            widget = self.add_tableview(complet_result, field)
            widget = self.set_headers(widget, field)
            widget = self.populate_table(widget, field)
            widget = self.set_columns_config(widget, field['widgetname'], sort_order=1, isQStandardItemModel=True)
            utils_giswater.set_qtv_config(widget)

        return label, widget


    def open_section_form(self):

        dlg_sections = Sections()
        self.load_settings(dlg_sections)
        feature = '"id":"'+self.feature_id+'"'
        body = self.create_body(feature=feature)
        sql = ("SELECT gw_api_getinfocrossection($${" + body + "}$$)")
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if not row:
            return False

        section_result = row

        # Set image
        img = section_result[0]['body']['data']['shapepng']
        utils_giswater.setImage(dlg_sections, 'lbl_section_image', img)

        # Set values into QLineEdits
        for field in section_result[0]['body']['data']['fields']:
            widget = dlg_sections.findChild(QLineEdit, field['column_id'])
            if widget:
                if 'value' in field:
                    utils_giswater.setWidgetText(dlg_sections, widget, field['value'])

        dlg_sections.btn_close.clicked.connect(partial(self.close_dialog, dlg_sections))
        self.open_dialog(dlg_sections, maximize_button=False)


    def accept(self, dialog, complet_result, feature_id, _json, clear_json=False, close_dialog=True):

        if _json == '' or str(_json) == '{}':
            self.close_dialog(dialog)
            return

        p_table_id = complet_result['body']['feature']['tableName']
        id_name = complet_result['body']['feature']['idName']
        parent_fields = complet_result['body']['data']['parentFields']

        if self.new_feature_id is not None:
            for k, v in list(_json.items()):
                if k in parent_fields:
                    self.new_feature.setAttribute(k, v)
                    _json.pop(k, None)
            self.layer_new_feature.updateFeature(self.new_feature)
            self.layer_new_feature.commitChanges()

            my_json = json.dumps(_json)

            if my_json == '' or str(my_json) == '{}':
                self.close_dialog(dialog)
                return

            feature = '"featureType":"'+str(self.feature_type)+'", '
            feature += '"tableName":"' + p_table_id + '", '
            feature += '"id":"' + self.new_feature.attribute(id_name) + '"'
            extras = '"fields":' + my_json + ''
            body = self.create_body(feature=feature, extras=extras)
            sql = ("SELECT gw_api_setfields($${" + body + "}$$)")

        else:
            my_json = json.dumps(_json)
            feature = '"featureType":"'+self.feature_type+'", '
            feature += '"tableName":"' + p_table_id + '", '
            feature += '"id":"' + feature_id + '"'
            extras = '"fields":' + my_json + ''
            body = self.create_body(feature=feature, extras=extras)
            sql = ("SELECT gw_api_setfields($${" + body + "}$$)")

        row = self.controller.execute_returning(sql, log_sql=True, commit=True)

        if not row:
            msg = "Fail in: {0}".format(sql)
            self.controller.show_message(msg, message_level=2)
            self.controller.log_info(str("FAIL IN: ")+str(sql))
            return

        if clear_json:
            _json = {}

        if "Accepted" in str(row[0]['status']):
            msg = "OK"
            self.controller.show_message(msg, message_level=3)
        elif "Failed" in str(row[0]['status']):
            msg = "FAIL"
            self.controller.show_message(msg, message_level=2)
        if close_dialog:
            self.close_dialog(dialog)


    def get_scale_zoom(self):

        scale_zoom = self.iface.mapCanvas().scale()
        return scale_zoom


    def disable_all(self, dialog, result, enable):

        widget_list = dialog.findChildren(QWidget)
        for widget in widget_list:
            for field in result['fields']:
                if widget.objectName() == field['widgetname']:
                    if type(widget) in (QSpinBox, QDoubleSpinBox, QLineEdit):
                        widget.setReadOnly(not enable)
                        widget.setStyleSheet("QWidget { background: rgb(242, 242, 242); color: rgb(0, 0, 0)}")
                    elif type(widget) in (QComboBox, QCheckBox, QgsDateTimeEdit):
                        widget.setEnabled(enable)
                    elif type(widget) is QPushButton:
                        # Manage the clickability of the buttons according to the configuration
                        # in the table config_api_form_fields simultaneously with the edition,
                        # but giving preference to the configuration when iseditable is True
                        if not field['iseditable']:
                            widget.setEnabled(field['iseditable'])

        self.new_feature_id = None


    def enable_all(self, dialog, result):

        widget_list = dialog.findChildren(QWidget)
        for widget in widget_list:
            for field in result['fields']:
                if widget.objectName() == field['widgetname']:
                    if type(widget) in (QSpinBox, QDoubleSpinBox, QLineEdit):
                        widget.setReadOnly(not field['iseditable'])
                        if not field['iseditable']:
                            widget.setFocusPolicy(Qt.NoFocus)
                            widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242); color: rgb(0, 0, 0)}")
                        else:
                            widget.setFocusPolicy(Qt.StrongFocus)
                            widget.setStyleSheet("QLineEdit { background: rgb(255, 255, 255); color: rgb(0, 0, 0)}")
                    elif type(widget) in(QComboBox, QCheckBox, QPushButton, QgsDateTimeEdit):
                        widget.setEnabled(field['iseditable'])
                        widget.focusPolicy(Qt.StrongFocus) if widget.setEnabled(
                            field['iseditable']) else widget.setFocusPolicy(Qt.NoFocus)


    def enable_actions(self, enabled):
        """ Enable actions according if layer is editable or not """

        actions_list = self.dlg_cf.findChildren(QAction)
        static_actions = ('actionEdit', 'actionCentered', 'actionZoomOut', 'actionZoom', 'actionLink', 'actionHelp',
                          'actionSection')
        for action in actions_list:
            if action.objectName() not in static_actions:
                action.setEnabled(enabled)


    def get_values(self, dialog, widget, _json=None):

        value = None
        if type(widget) in(QLineEdit, QSpinBox, QDoubleSpinBox) and widget.isReadOnly() is False:
            value = utils_giswater.getWidgetText(dialog, widget, return_string_null=False)
        elif type(widget) is QComboBox and widget.isEnabled():
            value = utils_giswater.get_item_data(dialog, widget, 0)
        elif type(widget) is QCheckBox and widget.isEnabled():
            value = utils_giswater.isChecked(dialog, widget)
        elif type(widget) is QgsDateTimeEdit and widget.isEnabled():
            value = utils_giswater.getCalendarDate(dialog, widget)

        # Only get values if layer is editable
        if self.layer.isEditable():
            # If widget.isEditable(False) return None, here control it.
            if str(value) == '' or value is None:
                _json[str(widget.property('column_id'))] = None
            else:
                _json[str(widget.property('column_id'))] = str(value)
        self.controller.log_info(str(_json))


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
            self.my_json.pop(str(widget.property('column_id')), None)
        except KeyError:
            pass


    def set_auto_update_lineedit(self, field, dialog, widget):

        if self.check_tab_data(dialog):
            if field['isautoupdate'] and self.new_feature_id is None:
                _json = {}
                if Qgis.QGIS_VERSION_INT < 29900:
                    widget.lostFocus.connect(partial(self.clean_my_json, widget))
                    widget.lostFocus.connect(partial(self.get_values, dialog, widget, _json))
                    widget.lostFocus.connect(partial(
                        self.accept, dialog, self.complet_result[0], self.feature_id, _json, True, False))
                else:
                    widget.editingFinished.connect(partial(self.clean_my_json, widget))
                    widget.editingFinished.connect(partial(self.get_values, dialog, widget, _json))
                    widget.editingFinished.connect(partial(
                        self.accept, dialog, self.complet_result[0], self.feature_id, _json, True, False))
            else:
                if Qgis.QGIS_VERSION_INT < 29900:
                    widget.lostFocus.connect(partial(self.get_values, dialog, widget, self.my_json))
                else:
                    widget.editingFinished.connect(partial(self.get_values, dialog, widget, self.my_json))

        return widget


    def set_auto_update_combobox(self, field, dialog, widget):

        if self.check_tab_data(dialog):
            if field['isautoupdate']:
                _json = {}
                widget.currentIndexChanged.connect(partial(self.clean_my_json, widget))
                widget.currentIndexChanged.connect(partial(self.get_values, dialog, widget, _json))
                widget.currentIndexChanged.connect(partial(
                    self.accept, dialog, self.complet_result[0], self.feature_id, _json, True, False))
            else:
                widget.currentIndexChanged.connect(partial(self.get_values, dialog, widget, self.my_json))

        return widget


    def set_auto_update_dateedit(self, field, dialog, widget):

        if self.check_tab_data(dialog):
            if field['isautoupdate']:
                _json = {}
                widget.dateChanged.connect(partial(self.clean_my_json, widget))
                widget.dateChanged.connect(partial(self.get_values, dialog, widget, _json))
                widget.dateChanged.connect(partial(
                    self.accept, dialog, self.complet_result[0], self.feature_id, _json, True, False))
            else:
                widget.dateChanged.connect(partial(self.get_values, dialog, widget, self.my_json))

        return widget


    def set_auto_update_spinbox(self, field, dialog, widget):

        if self.check_tab_data(dialog):
            if field['isautoupdate']:
                _json = {}
                widget.valueChanged.connect(partial(self.clean_my_json, widget))
                widget.valueChanged.connect(partial(self.get_values, dialog, widget, _json))
                widget.valueChanged.connect(partial(
                    self.accept, dialog, self.complet_result[0], self.feature_id, _json, True, False))
            else:
                widget.valueChanged.connect(partial(self.get_values, dialog, widget, self.my_json))

        return widget


    def set_auto_update_checkbox(self, field, dialog, widget):

        if self.check_tab_data(dialog):
            if field['isautoupdate']:
                _json = {}
                widget.stateChanged.connect(partial(self.clean_my_json, widget))
                widget.stateChanged.connect(partial(self.get_values, dialog, widget, _json))
                widget.stateChanged.connect(partial(
                    self.accept, dialog, self.complet_result[0], self.feature_id, _json, True, False))
            else:
                widget.stateChanged.connect(partial(self.get_values, dialog, widget, self.my_json))
        return widget


    def fill_child(self, dialog, widget):
        """ Find QComboBox child and populate it
        :param widget: QComboBox parent
        """

        combo_parent = widget.property('column_id')
        combo_id = utils_giswater.get_item_data(dialog, widget)

        feature = '"featureType":"' + self.feature_type + '", '
        feature += '"tableName":"' + self.tablename + '", '
        feature += '"idName":"' + self.field_id + '"'
        extras = '"comboParent":"'+combo_parent+'", "comboId":"'+combo_id+'"'
        body = self.create_body(feature=feature, extras=extras)
        sql = ("SELECT gw_api_getchilds($${" + body + "}$$)")
        row = self.controller.get_row(sql, log_sql=False, commit=True)
        for combo_child in row[0]['body']['data']:
            if combo_child is not None:
                self.populate_child(combo_child)


    def populate_child(self, combo_child):

        child = self.dlg_cf.findChild(QComboBox, str(combo_child['widgetname']))
        if child:
            self.populate_combo(child, combo_child)


    def open_catalog(self, tab_type, feature_type):

        self.catalog = ApiCatalog(self.iface, self.settings, self.controller, self.plugin_dir)

        # Check geom_type
        if self.geom_type == 'connec':
            widget = tab_type+"_"+self.geom_type+'at_id'
        else:
            widget = tab_type+"_"+self.geom_type+'cat_id'

        self.catalog.api_catalog(self.dlg_cf, widget, self.geom_type, feature_type[0])


    def show_actions(self, tab_name):
        """ Hide all actions and show actions for the corresponding tab
        :param tab_name: corresponding tab
        """

        actions_list = self.dlg_cf.findChildren(QAction)
        for action in actions_list:
            action.setVisible(False)
        for tab in self.complet_result[0]['body']['form']['visibleTabs']:
            if tab['tabName'] == tab_name:
                if tab['tabactions'] is not None:
                    for act in tab['tabactions']:
                        action = self.dlg_cf.findChild(QAction, act['actionName'])
                        if action is not None:
                            action.setToolTip(act['actionTooltip'])
                            action.setVisible(True)

        self.enable_actions(self.layer.isEditable())


    """ MANAGE TABS """
    def tab_activation(self):
        """ Call functions depend on tab selection """

        # Get index of selected tab
        index_tab = self.tab_main.currentIndex()
        tab_name = self.tab_main.widget(index_tab).objectName()
        self.show_actions(tab_name)
        # Tab 'Elements'
        if self.tab_main.widget(index_tab).objectName() == 'tab_elements' and not self.tab_element_loaded:
            self.fill_tab_element()
            self.tab_element_loaded = True
        # Tab 'Relations'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_relations' and not self.tab_relations_loaded:
            # if self.geom_type in ('arc', 'node'):
            #     self.manage_tab_relations("v_ui_" + str(self.geom_type) + "_x_relations", str(self.field_id))
            self.fill_tab_relations()
            self.tab_relations_loaded = True
        # Tab 'Conections'
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
            result = self.fill_tab_rpt(self.complet_result)
            self.tab_rpt_loaded = True
        # Tab 'Plan'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_plan' and not self.tab_plan_loaded:
            self.fill_tab_plan(self.complet_result)
            self.tab_plan_loaded = True


    """ FUNCTIONS RELATED TAB ELEMENT"""
    def fill_tab_element(self):
        """ Fill tab 'Element' """

        table_element = "v_ui_element_x_" + self.geom_type
        self.fill_tbl_element_man(self.dlg_cf, self.tbl_element, table_element, self.filter)
        self.set_columns_config(self.tbl_element, table_element)


    def fill_tbl_element_man(self, dialog, widget, table_name, expr_filter):
        """ Fill the table control to show elements """

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
        table_name = self.schema_name + "." + table_name
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
        row = self.controller.get_row(sql, commit=True)
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
        row = self.controller.get_row(sql, log_info=False, log_sql=False, commit=True)

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

        row_index = row_index[:-2]
        inf_text = inf_text[:-2]
        list_object_id = list_object_id[:-2]
        list_id = list_id[:-2]

        message = "Are you sure you want to delete these records?"
        answer = self.controller.ask_question(message, "Delete records", list_object_id)
        if answer:
            sql = ("DELETE FROM " + table_name + ""
                   " WHERE id::integer IN (" + list_id + ")")
            self.controller.execute_sql(sql, log_sql=False)
            widget.model().select()


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
        sql = ("SELECT * FROM " + viewname + ""
               " WHERE " + str(field_id) + " = '" + str(self.feature_id) + "';")
        row = self.controller.get_row(sql, log_info=True, log_sql=False, commit=True)

        if not row:
            # Hide tab 'relations'
            utils_giswater.remove_tab_by_tabName(self.tab_main, "relations")

        else:
            # Manage signal 'doubleClicked'
            self.tbl_relations.doubleClicked.connect(partial(self.open_relation, field_id))


    def fill_tab_relations(self):
        """ Fill tab 'Relations' """

        table_relations = "v_ui_"+self.geom_type+"_x_relations"
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
        sql = ("SELECT feature_type FROM cat_feature "
               "WHERE id = '"+str(sys_type)+"'")
        sys_type = self.controller.get_row(sql, commit=True)
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
            print("FAIL open_relation")
            return
        self.draw(complet_result)


    """ FUNCTIONS RELATED WITH TAB CONECTIONS """
    def fill_tab_connections(self):
        """ Fill tab 'Connections' """

        self.fill_table(self.dlg_cf.tbl_upstream, self.schema_name + ".v_ui_node_x_connection_upstream")
        self.set_columns_config(self.dlg_cf.tbl_upstream, "v_ui_node_x_connection_upstream")

        self.fill_table(self.dlg_cf.tbl_downstream, self.schema_name + ".v_ui_node_x_connection_downstream")
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
        feature_id = qtable.model().record(row).value("sys_id")
        api_cf = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir, self.tab_type)
        complet_result, dialog = api_cf.open_form(table_name=table_name, feature_id=feature_id, tab_type=self.tab_type)
        if not complet_result:
            print("FAIL open_up_down_stream")
            return
        self.draw(complet_result)


    """ FUNCTIONS RELATED WITH TAB HYDROMETER"""
    def fill_tab_hydrometer(self):
        """ Fill tab 'Hydrometer' """

        table_hydro = "v_rtc_hydrometer"
        txt_hydrometer_id = self.dlg_cf.findChild(QLineEdit, "txt_hydrometer_id")
        self.fill_tbl_hydrometer(self.tbl_hydrometer,  table_hydro)
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
        column_index = 0
        column_index = utils_giswater.get_col_index_by_col_name(qtable, 'hydrometer_id')
        feature_id = index.sibling(row, column_index).data()

        # return
        api_cf = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir, self.tab_type)
        complet_result, dialog = api_cf.open_form(table_name=table_name, feature_id=feature_id, tab_type=self.tab_type)
        if not complet_result:
            print("FAIL open_selected_hydro")
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
        filter = "connec_id ILIKE '%" + self.feature_id + "%' "
        filter += " AND hydrometer_customer_code ILIKE '%" + txt_hydrometer_id.text() + "%'"

        # Set model of selected widget
        self.set_model_to_table(qtable, self.schema_name + "." + table_name, filter)


    """ FUNCTIONS RELATED WITH TAB HYDROMETER VALUES"""
    def fill_tab_hydrometer_values(self):

        table_hydro_value = "v_ui_hydroval_x_connec"
        cmb_cat_period_id_filter = self.dlg_cf.findChild(QComboBox, "cmb_cat_period_id_filter")

        # Populate combo filter hydrometer value
        sql = ("SELECT DISTINCT cat_period_id, cat_period_id "
               "FROM " + str(table_hydro_value) + " "
               "ORDER BY cat_period_id")
        rows = self.controller.get_rows(sql, commit=True)
        if not rows:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return False

        rows.append(['', ''])
        utils_giswater.set_item_data(cmb_cat_period_id_filter, rows)
        self.fill_tbl_hydrometer_values(self.tbl_hydrometer_value, table_hydro_value)
        self.set_columns_config(self.tbl_hydrometer_value, table_hydro_value)

        cmb_cat_period_id_filter = self.dlg_cf.findChild(QComboBox, "cmb_cat_period_id_filter")
        cmb_cat_period_id_filter.currentIndexChanged.connect(
            partial(self.fill_tbl_hydrometer_values, self.tbl_hydrometer_value, table_hydro_value))


    def fill_tbl_hydrometer_values(self, qtable, table_name):
        """ Fill the table control to show hydrometers values """

        cmb_cat_period_id_filter = self.dlg_cf.findChild(QComboBox, "cmb_cat_period_id_filter")
        cat_period = utils_giswater.get_item_data(self.dlg_cf, cmb_cat_period_id_filter)
        filter_ = "connec_id ILIKE '%" + self.feature_id + "%' "
        filter_ += " AND cat_period_id ILIKE '%" + cat_period + "%'"

        # Set model of selected widget
        self.set_model_to_table(qtable, self.schema_name + "." + table_name, filter_, QSqlTableModel.OnFieldChange)


    def set_filter_hydrometer_values(self, widget):
        """ Get Filter for table hydrometer value with combo value"""

        # Get combo value
        cat_period_id_filter = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.cmb_cat_period_id_filter, 0)

        # Set filter
        expr = self.field_id + " = '" + self.feature_id + "'"
        expr += " AND cat_period_id ILIKE '%" + cat_period_id_filter + "%'"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()


    """ FUNCTIONS RELATED WITH TAB OM"""
    def fill_tab_om(self, geom_type):
        """ Fill tab 'O&M' (event) """

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
        btn_new_visit.clicked.connect(self.new_visit)
        btn_open_gallery.clicked.connect(self.open_gallery)
        btn_open_visit_doc.clicked.connect(self.open_visit_doc)
        btn_open_visit_event.clicked.connect(self.open_visit_event)

        feature_key = self.controller.get_layer_primary_key()
        if feature_key == 'node_id':
            feature_type = 'NODE'
        if feature_key == 'connec_id':
            feature_type = 'CONNEC'
        if feature_key == 'arc_id':
            feature_type = 'ARC'
        if feature_key == 'gully_id':
            feature_type = 'GULLY'

        table_name_event_id = "om_visit_parameter"

        # Fill ComboBox event_id
        sql = ("SELECT DISTINCT(id), id "
               "FROM " + table_name_event_id + " "
               "WHERE feature_type = '" + feature_type + "' OR feature_type = 'ALL' "
               "ORDER BY id")
        rows = self.controller.get_rows(sql, commit=True)
        if rows:
            rows.append(['', ''])
            utils_giswater.set_item_data(self.dlg_cf.event_id, rows)
        # Fill ComboBox event_type
        sql = ("SELECT DISTINCT(parameter_type), parameter_type "
               "FROM " + table_name_event_id + " "
               "WHERE feature_type = '" + feature_type + "' OR feature_type = 'ALL' "
               "ORDER BY parameter_type")
        rows = self.controller.get_rows(sql, commit=True)
        if rows:
            rows.append(['', ''])
            utils_giswater.set_item_data(self.dlg_cf.event_type, rows)

        # Get selected dates
        date_from = self.date_event_from.date()
        date_to = self.date_event_to.date()
        if date_from > date_to:
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return

        format_low = 'yyyy-MM-dd 00:00:00.000'
        format_high = 'yyyy-MM-dd 23:59:59.999'
        interval = "'{}'::timestamp AND '{}'::timestamp".format(
            date_from.toString(format_low), date_to.toString(format_high))

        # Set filter
        filter_ += " AND(tstamp BETWEEN {0}) AND (tstamp BETWEEN {0})".format(interval)

        # Set model of selected widget
        self.set_model_to_table(widget, table_name, filter_)


    def open_visit_event(self):
        """ Open event of selected record of the table """

        # Open dialog event_standard
        self.dlg_event_full = EventFull()
        self.load_settings(self.dlg_event_full)
        self.dlg_event_full.rejected.connect(partial(self.close_dialog, self.dlg_event_full))
        # Get all data for one visit
        sql = ("SELECT * FROM om_visit_event"
               " WHERE id = '" + str(self.event_id) + "' AND visit_id = '" + str(self.visit_id) + "'")
        row = self.controller.get_row(sql, commit=True)
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
        
        self.open_dialog(self.dlg_event_full)


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

        sql = ("SELECT value, filetype, fextension FROM " + self.schema_name + ".om_visit_event_photo "
               "WHERE visit_id='" + str(self.visit_id) + "' AND event_id='" + str(self.event_id) + "'")
        rows = self.controller.get_rows(sql, commit=True)
        if rows is None:
            return

        for row in rows:
            item = []
            for value in row:
                if value is not None:
                    if type(value) != unicode:
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

        sql = ("SELECT gallery, document FROM " + table_name + ""
               " WHERE event_id = '" + str(self.event_id) + "' AND visit_id = '" + str(self.visit_id) + "'")
        row = self.controller.get_row(sql, log_sql=False, commit=True)
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
        table_name_event_id = "om_visit_parameter"
        event_type_value = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.event_type, 0)

        # Get type of feature
        feature_key = self.controller.get_layer_primary_key()
        if feature_key == 'node_id':
            feature_type = 'NODE'
        if feature_key == 'connec_id':
            feature_type = 'CONNEC'
        if feature_key == 'arc_id':
            feature_type = 'ARC'
        if feature_key == 'gully_id':
            feature_type = 'GULLY'

        # Fill ComboBox event_id
        sql = ("SELECT DISTINCT(id), id FROM " + table_name_event_id + ""
               " WHERE (feature_type = '" + feature_type + "' OR feature_type = 'ALL')")
        if event_type_value != 'null':
            sql += " AND parameter_type ILIKE '%" + event_type_value + "%'"
        sql += " ORDER BY id"
        rows = self.controller.get_rows(sql, log_sql=False, commit=True)
        rows.append(['', ''])
        utils_giswater.set_item_data(self.dlg_cf.event_id, rows, 1)

        # End cascading filter
        # Get selected values in Comboboxes
        event_type_value = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.event_type, 0)
        event_id = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.event_id, 0)
        format_low = 'yyyy-MM-dd 00:00:00.000'
        format_high = 'yyyy-MM-dd 23:59:59.999'
        interval = "'{}'::timestamp AND '{}'::timestamp".format(
            visit_start.toString(format_low), visit_end.toString(format_high))
        # Set filter to model
        expr = self.field_id + " = '" + self.feature_id + "'"
        # Set filter
        expr += " AND visit_start BETWEEN {0}".format(interval)

        if event_type_value != 'null':
            expr += " AND parameter_type ILIKE '%" + event_type_value + "%'"

        if event_id != 'null':
            expr += " AND parameter_id ILIKE '%" + event_id + "%'"

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
        interval = "'{}'::timestamp AND '{}'::timestamp".format(
            visit_start.toString(format_low), visit_end.toString(format_high))
        # Set filter to model
        expr = self.field_id + " = '" + self.feature_id + "'"
        # Set filter
        expr += " AND visit_start BETWEEN {0}".format(interval)

        # Get selected values in Comboboxes
        event_type_value = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.event_type, 0)
        if event_type_value != 'null':
            expr += " AND parameter_type ILIKE '%" + event_type_value + "%'"
        event_id = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.event_id, 0)
        if event_id != 'null':
            expr += " AND parameter_id ILIKE '%" + event_id + "%'"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()


    def open_visit(self):
        """ Call button 65: om_visit_management """

        manage_visit = ManageVisit(self.iface, self.settings, self.controller, self.plugin_dir)
        manage_visit.visit_added.connect(self.update_visit_table)
        manage_visit.edit_visit(self.geom_type, self.feature_id)


    # creat the new visit GUI
    def update_visit_table(self):
        """ Convenience fuction set as slot to update table after a Visit GUI close. """
        self.tbl_event_cf.model().select()


    def new_visit(self):
        """ Call button 64: om_add_visit """

        # Get expl_id to save it on om_visit and show the geometry of visit
        expl_id = utils_giswater.get_item_data(self.dlg_cf, self.tab_type+'_expl_id', 0)
        if expl_id == -1:
            msg = "Widget expl_id not found"
            self.controller.show_warning(msg)
            return

        manage_visit = ManageVisit(self.iface, self.settings, self.controller, self.plugin_dir)
        manage_visit.visit_added.connect(self.update_visit_table)
        # TODO: the following query fix a (for me) misterious bug
        # the DB connection is not available during manage_visit.manage_visit first call
        # so the workaroud is to do a unuseful query to have the dao controller active
        sql = ("SELECT id FROM om_visit LIMIT 1")
        self.controller.get_rows(sql, commit=True)
        manage_visit.manage_visit(geom_type=self.geom_type, feature_id=self.feature_id, expl_id=expl_id)


    def open_gallery(self):
        """ Open gallery of selected record of the table """

        # Open Gallery
        gal = ManageGallery(self.iface, self.settings, self.controller, self.plugin_dir)
        gal.manage_gallery()
        gal.fill_gallery(self.visit_id, self.event_id)


    def open_visit_doc(self):
        """ Open document of selected record of the table """

        # Get all documents for one visit
        sql = ("SELECT doc_id FROM doc_x_visit"
               " WHERE visit_id = '" + str(self.visit_id) + "'")
        rows = self.controller.get_rows(sql, commit=True)
        if not rows:
            return

        num_doc = len(rows)
        if num_doc == 1:
            # If just one document is attached directly open

            # Get path of selected document
            sql = ("SELECT path"
                   " FROM v_ui_doc"
                   " WHERE id = '" + str(rows[0][0]) + "'")
            row = self.controller.get_row(sql, commit=True)
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
            self.dlg_load_doc = LoadDocuments()
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

            self.open_dialog(self.dlg_load_doc)


    def open_selected_doc(self):

        # Selected item from list
        selected_document = self.tbl_list_doc.currentItem().text()

        # Get path of selected document
        sql = ("SELECT path FROM v_ui_doc"
               " WHERE id = '" + str(selected_document) + "'")
        row = self.controller.get_row(sql, commit=True)
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
        table_document = "v_ui_doc_x_"+self.geom_type
        self.fill_tbl_document_man(self.dlg_cf, self.tbl_document, table_document, self.filter)
        self.set_columns_config(self.tbl_document, table_document)


    def fill_tbl_document_man(self, dialog, widget, table_name, expr_filter):
        """ Fill the table control to show documents """

        # Get widgets
        txt_doc_id = self.dlg_cf.findChild(QLineEdit, "txt_doc_id")
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
        sql = ("SELECT id, id FROM doc_type ORDER BY id")
        rows = self.controller.get_rows(sql, commit=True)
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
        interval = "'{}'::timestamp AND '{}'::timestamp".format(
            date_from.toString(format_low), date_to.toString(format_high))

        # Set filter
        expr = self.field_id + " = '" + self.feature_id + "'"
        expr += " AND(date BETWEEN {0}) AND (date BETWEEN {0})".format(interval)

        # Get selected values in Comboboxes
        doc_type_value = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.doc_type, 0)
        if doc_type_value != 'null' and doc_type_value is not None:
            expr += " AND doc_type ILIKE '%" + str(doc_type_value) + "%'"
        print(str(expr))
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
        doc.manage_document(feature=feature)
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
    def fill_tab_rpt(self, complet_result):

        complet_list, widget_list = self.init_tbl_rpt(complet_result, self.dlg_cf)
        if complet_list is False:
            return False
        self.set_listeners(complet_result, self.dlg_cf, widget_list)
        #self.dlg_cf.tbl_rpt.doubleClicked.connect(partial(self.open_rpt_result, self.dlg_cf.tbl_rpt,  complet_list))
        return complet_list


    def init_tbl_rpt(self, complet_result, dialog):
        """ Put filter widgets into layout and set headers into QTableView """

        rpt_layout1 = dialog.findChild(QGridLayout, "rpt_layout1")
        # qtable = dialog.findChild(QTableView, qtv_name)
        self.clear_gridlayout(rpt_layout1)
        index_tab = self.tab_main.currentIndex()
        tab_name = self.tab_main.widget(index_tab).objectName()
        complet_list = self.get_list(complet_result, tab_name=tab_name)
        if complet_list is False:
            return False, False

        # Put widgets into layout
        widget_list = []
        for field in complet_list[0]['body']['data']['fields']:
            label, widget = self.set_widgets(dialog, complet_list, field)
            if widget is not None:
                if (type(widget)) == QSpacerItem:
                    rpt_layout1.addItem(widget, 1, field['layout_order'])
                elif (type(widget)) == QTableView:
                    gridLayout_7 = self.dlg_cf.findChild(QGridLayout, "gridLayout_7")
                    gridLayout_7.addWidget(widget, 2, field['layout_order'])
                    widget_list.append(widget)
                else:
                    widget.setMaximumWidth(150)
                    widget_list.append(widget)
                    if label:
                        rpt_layout1.addWidget(label, 0, field['layout_order'])
                    rpt_layout1.addWidget(widget, 1, field['layout_order'])

            # Find combo parents:
            for field in complet_list[0]['body']['data']['fields'][0]:
                if 'isparent' in field:
                    if field['isparent']:
                        widget = dialog.findChild(QComboBox, field['widgetname'])
                        widget.currentIndexChanged.connect(partial(self.fill_child, dialog, widget))

        return complet_list, widget_list


    def set_listeners(self, complet_result, dialog, widget_list):

        for widget in widget_list:
            if type(widget) is QTableView:
                standar_model = widget.model()
        for widget in widget_list:
            if type(widget) is QLineEdit:
                if Qgis.QGIS_VERSION_INT < 29900:
                    widget.textChanged.connect(partial(
                        self.filter_table, complet_result, standar_model, dialog, widget_list))
                else:
                    widget.editingFinished.connect(partial(
                        self.filter_table, complet_result, standar_model, dialog, widget_list))
            elif type(widget) is QComboBox:
                widget.currentIndexChanged.connect(partial(
                    self.filter_table, complet_result, standar_model, dialog, widget_list))


    def get_list(self, complet_result, form_name='', tab_name='', filter_fields=''):

        form = '"formName":"' + form_name + '", "tabName":"' + tab_name + '"'
        id_name = complet_result[0]['body']['feature']['idName']
        feature = '"tableName":"' + self.tablename + '", "idName":"'+id_name+'", "id":"'+self.feature_id+'"'
        body = self.create_body(form, feature,  filter_fields)
        sql = ("SELECT gw_api_getlist($${" + body + "}$$)::text")
        row = self.controller.get_row(sql, log_sql=True, commit=True)

        if row is None or row[0] is None:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return False
        # Parse string to order dict into List
        complet_list = [json.loads(row[0],  object_pairs_hook=OrderedDict)]

        return complet_list


    def filter_table(self, complet_result,  standar_model,  dialog, widget_list):

        filter_fields = self.get_filter_qtableview(standar_model, dialog, widget_list)
        index_tab = self.tab_main.currentIndex()
        tab_name = self.tab_main.widget(index_tab).objectName()
        complet_list = self.get_list(complet_result, tab_name=tab_name, filter_fields=filter_fields)
        if complet_list is False:
            return False
        # for item in complet_list[0]['body']['data']['listValues'][0]:
        #     row = [QStandardItem(str(value)) for value in item.values() if filter in str(item['event_id'])]
        #     if len(row) > 0:
        #         standar_model.appendRow(row)
        for field in complet_list[0]['body']['data']['fields']:
            if field['widgettype'] == "tableView":
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
                column_id = widget.property('column_id')
                text = utils_giswater.getWidgetText(dialog, widget)
                if text != "null":
                    filter_fields += '"' + column_id + '":"'+text+'", '

        if filter_fields != "":
            filter_fields = filter_fields[:-2]

        return filter_fields


    def gw_api_open_rpt_result(self, widget, complet_result):
        self.open_rpt_result(widget, complet_result)


    def open_rpt_result(self, qtable,  complet_list):
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
            print("FAIL open_rpt_result")
            return

        self.draw(complet_result)


    """ FUNCTIONS RELATED WITH TAB PLAN """
    def fill_tab_plan(self, complet_result):

        plan_layout = self.dlg_cf.findChild(QGridLayout, 'plan_layout')

        if self.geom_type == 'arc' or self.geom_type == 'node':
            index_tab = self.tab_main.currentIndex()
            tab_name = self.tab_main.widget(index_tab).objectName()
            form = '"tabName":"'+tab_name+'"'
            feature = '"featureType":"'+complet_result[0]['body']['feature']['featureType']+'", '
            feature += '"tableName":"' + self.tablename + '", '
            feature += '"idName":"' + self.field_id + '", '
            feature += '"id":"' + self.feature_id + '"'
            body = self.create_body(form, feature, filter_fields='')
            sql = ("SELECT gw_api_getinfoplan($${" + body + "}$$)::text")
            row = self.controller.get_row(sql, log_sql=False, commit=True)
            if not row:
                self.controller.show_message("NOT ROW FOR: " + sql, 2)
                return False

            complet_list = [json.loads(row[0], object_pairs_hook=OrderedDict)]
            result = complet_list[0]['body']['data']
            if 'fields' not in result:
                self.controller.show_message("No listValues for: " + row[0]['body']['data'], 2)
            else:
                for field in complet_list[0]['body']['data']['fields']:
                    if field['widgettype'] == 'formDivider':
                        for x in range(0, 2):
                            line = self.add_frame(field, x)
                            plan_layout.addWidget(line, field['layout_order'], x)
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
                        plan_layout.addWidget(label, field['layout_order'], 0)
                        plan_layout.addWidget(widget, field['layout_order'], 1)

                plan_vertical_spacer = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
                plan_layout.addItem(plan_vertical_spacer)


    """ NEW WORKCAT"""
    def cf_new_workcat(self, tab_type):

        body = '"client":{"device":3, "infoType":100, "lang":"ES"}, '
        body += '"form":{"formName":"new_workcat", "tabName":"data", "editable":"TRUE"}, '
        body += '"feature":{}, '
        body += '"data":{}'
        sql = ("SELECT gw_api_getcatalog($${" + body + "}$$)::text")
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if not row:
            return

        complet_list = [json.loads(row[0], object_pairs_hook=OrderedDict)]

        self.dlg_new_workcat = ApiBasicInfo()
        self.load_settings(self.dlg_new_workcat)

        # Set signals
        self.dlg_new_workcat.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_new_workcat))
        self.dlg_new_workcat.rejected.connect(partial(self.close_dialog, self.dlg_new_workcat))
        self.dlg_new_workcat.btn_accept.clicked.connect(partial(self.cf_manage_new_workcat_accept, 'cat_work', tab_type))

        self.populate_basic_info(self.dlg_new_workcat, complet_list, self.field_id)

        # Open dialog
        self.dlg_new_workcat.setWindowTitle("Create workcat")
        self.open_dialog(self.dlg_new_workcat)


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
        cat_work_id = utils_giswater.getWidgetText(self.dlg_new_workcat, cat_work_id)
        if cat_work_id != "null":
            fields += 'id, '
            values += ("'" + str(cat_work_id) + "', ")
        descript = utils_giswater.getWidgetText(self.dlg_new_workcat, descript)
        if descript != "null":
            fields += 'descript, '
            values += ("'" + str(descript) + "', ")
        link = utils_giswater.getWidgetText(self.dlg_new_workcat, link)
        if link != "null":
            fields += 'link, '
            values += ("'" + str(link) + "', ")
        workid_key_1 = utils_giswater.getWidgetText(self.dlg_new_workcat, workid_key_1)
        if workid_key_1 != "null":
            fields += 'workid_key1, '
            values += ("'" + str(workid_key_1) + "', ")
        workid_key_2 = utils_giswater.getWidgetText(self.dlg_new_workcat, workid_key_2)
        if workid_key_2 != "null":
            fields += 'workid_key2, '
            values += ("'" + str(workid_key_2) + "', ")
        builtdate = builtdate.dateTime().toString('yyyy-MM-dd')
        if builtdate != "null":
            fields += 'builtdate, '
            values += ("'" + str(builtdate) + "', ")

        if values != "":
            fields = fields[:-2]
            values = values[:-2]
            if cat_work_id == 'null':
                msg = "El campo Work id esta vacio"
                self.controller.show_info_box(msg, "Warning")
            else:
                # Check if this element already exists
                sql = ("SELECT DISTINCT(id)"
                       "FROM " + str(table_object) + " "
                       "WHERE id = '" + str(cat_work_id) + "' ")
                row = self.controller.get_row(sql, log_info=False, commit=True)
                if row is None:
                    sql = ("INSERT INTO cat_work (" + fields + ") VALUES (" + values + ")")
                    self.controller.execute_sql(sql)
                    sql = "SELECT id, id FROM cat_work ORDER BY id"
                    rows = self.controller.get_rows(sql, commit=True)
                    if rows:
                        cmb_workcat_id = self.dlg_cf.findChild(QWidget, tab_type + "_workcat_id")
                        model = QStringListModel()
                        completer = QCompleter()
                        self.set_completer_object_api(completer, model, cmb_workcat_id, rows[0])
                        utils_giswater.setWidgetText(self.dlg_cf, cmb_workcat_id, cat_work_id)
                    self.close_dialog(self.dlg_new_workcat)
                else:
                    msg = "This workcat already exists"
                    self.controller.show_info_box(msg, "Warning")


    def cf_open_dialog(self, dlg=None, dlg_name=None, maximize_button=True, stay_on_top=True):
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


    """ OTHER FUNCTIONS """
    def set_image(self, dialog, widget):
        utils_giswater.setImage(dialog, widget, "ws_shape.png")


    def check_column_exist(self, table_name, column_name):

        sql = ("SELECT DISTINCT column_name FROM information_schema.columns"
               " WHERE table_name = '" + table_name + "' AND column_name = '" + column_name + "'")
        row = self.controller.get_row(sql, log_sql=False, commit=True)
        return row


    """ FUNCTIONS ASSOCIATED TO BUTTONS FROM POSTGRES"""

    def gw_api_open_node(self, dialog, widget=None):

        feature_id = utils_giswater.getWidgetText(dialog, widget)
        self.ApiCF = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir, self.tab_type)
        complet_result, dialog = self.ApiCF.open_form(table_name='v_edit_node', feature_id=feature_id, tab_type=self.tab_type)
        if not complet_result:
            print("FAIL open_node")
            return

        self.draw(complet_result)

