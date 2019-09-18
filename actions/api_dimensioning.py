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
    pass
else:
    from qgis.core import QgsPointXY
    from ..map_tools.snapping_utils_v3 import SnappingConfigManager

import json
from collections import OrderedDict
from functools import partial

from qgis.gui import QgsMapToolEmitPoint, QgsMapTip

from qgis.PyQt.QtCore import QTimer
from qgis.PyQt.QtWidgets import QAction, QCompleter, QGridLayout, QLabel, QLineEdit, QPushButton, QSizePolicy,\
    QSpacerItem, QWidget

from .api_parent import ApiParent
from ..ui_manager import ApiDimensioningUi

from .. import utils_giswater


class ApiDimensioning(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class constructor """

        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir

        self.canvas = self.iface.mapCanvas()
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)

        # Snapper
        self.snapper_manager = SnappingConfigManager(self.iface)
        self.snapper = self.snapper_manager.get_snapper()


    def open_form(self, new_feature=None, new_feature_id=None):
        self.dlg_dim = ApiDimensioningUi()
        self.load_settings(self.dlg_dim)

        # Set signals
        actionSnapping = self.dlg_dim.findChild(QAction, "actionSnapping")
        actionSnapping.triggered.connect(self.snapping)
        self.set_icon(actionSnapping, "103")

        actionOrientation = self.dlg_dim.findChild(QAction, "actionOrientation")
        actionOrientation.triggered.connect(self.orientation)
        self.set_icon(actionOrientation, "133")

        self.dlg_dim.btn_accept.clicked.connect(partial(self.save_dimensioning, new_feature))
        self.dlg_dim.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_dim))
        self.dlg_dim.dlg_closed.connect(partial(self.save_settings, self.dlg_dim))

        # Set layers dimensions, node and connec
        self.layer_dimensions = self.controller.get_layer_by_tablename("v_edit_dimensions")
        self.layer_node = self.controller.get_layer_by_tablename("v_edit_node")
        self.layer_connec = self.controller.get_layer_by_tablename("v_edit_connec")

        self.create_map_tips()
        body = self.create_body()
        # Get layers under mouse clicked
        sql = f"SELECT gw_api_getdimensioning($${{{body}}}$$)::text"
        row = self.controller.get_row(sql, log_sql=True, commit=True)

        if row is None or row[0] is None:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return False
        # Parse string to order dict into List
        complet_result = [json.loads(row[0],  object_pairs_hook=OrderedDict)]

        layout_list = []
        for field in complet_result[0]['body']['data']['fields']:
            label, widget = self.set_widgets(self.dlg_dim, complet_result, field)
            if widget.objectName() == 'id':
                utils_giswater.setWidgetText(self.dlg_dim, widget, new_feature.attribute('id'))
            layout = self.dlg_dim.findChild(QGridLayout, field['layoutname'])
           # Take the QGridLayout with the intention of adding a QSpacerItem later
            if layout not in layout_list and layout.objectName() not in ('top_layout', 'bot_layout_1', 'bot_layout_2'):
                layout_list.append(layout)

            # Add widgets into layout
            if field['layoutname'] in ('top_layout', 'bot_layout_1', 'bot_layout_2'):
                layout.addWidget(label, 0, field['layout_order'])
                layout.addWidget(widget, 1, field['layout_order'])
            else:
                self.put_widgets(self.dlg_dim, field, label, widget)

        # Add a QSpacerItem into each QGridLayout of the list
        for layout in layout_list:
            vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
            layout.addItem(vertical_spacer1)

        self.open_dialog(self.dlg_dim)
        return False, False


    def save_dimensioning(self, new_feature):
        # Create body
        fields = ''
        list_widgets = self.dlg_dim.findChildren(QLineEdit)
        for widget in list_widgets:
            widget_name = widget.objectName()
            widget_value = utils_giswater.getWidgetText(self.dlg_dim, widget)
            if widget_value == 'null':
                continue
            fields += f'"{widget_name}":"{widget_value}",'

        srid = self.controller.plugin_settings_value('srid')
        sql = f"SELECT ST_GeomFromText('{new_feature.geometry().asWkt()}', {srid})"
        the_geom = self.controller.get_row(sql, commit=True, log_sql=True)
        fields += f'"the_geom":"{the_geom[0]}"'

        feature = '"tableName":"v_edit_dimensions"'
        body = self.create_body(feature=feature, filter_fields=fields)

        # Execute query
        sql = f"SELECT gw_api_setdimensioning($${{{body}}}$$)::text"
        row = self.controller.get_row(sql, log_sql=True, commit=True)


    def snapping(self):
        # Set active layer and set signals
        self.iface.setActiveLayer(self.layer_node)
        self.canvas.xyCoordinates.connect(self.mouse_move)
        self.emit_point.canvasClicked.connect(self.click_button_snapping)

    def mouse_move(self, point):

        # Hide marker and get coordinates
        self.snapper_manager.remove_marker()
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_background_layers(event_point)
        if self.snapper_manager.result_is_valid():
            layer = self.snapper_manager.get_snapped_layer(result)
            # Check feature
            if layer == self.layer_node or layer == self.layer_connec:
                self.snapper_manager.add_marker(result)


    def click_button_snapping(self, point, btn):

        if not self.layer_dimensions:
            return

        layer = self.layer_dimensions
        self.iface.setActiveLayer(layer)
        layer.startEditing()

        # Get coordinates
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_background_layers(event_point)
        if self.snapper_manager.result_is_valid():

            layer = self.snapper_manager.get_snapped_layer(result)
            # Check feature
            if layer == self.layer_node:
                feat_type = 'node'
            elif layer == self.layer_connec:
                feat_type = 'connec'
            else:
                return

            # Get the point
            snapped_feat = self.snapper_manager.get_snapped_feature(result)
            feature_id = self.snapper_manager.get_snapped_feature_id(result)
            element_id = snapped_feat.attribute(feat_type + '_id')

            # Leave selection
            layer.select([feature_id])

            # Get depth of the feature
            self.project_type = self.controller.get_project_type()
            if self.project_type == 'ws':
                fieldname = "depth"
            elif self.project_type == 'ud' and feat_type == 'node':
                fieldname = "ymax"
            elif self.project_type == 'ud' and feat_type == 'connec':
                fieldname = "connec_depth"

            sql = (f"SELECT {fieldname} "
                   f"FROM {feat_type} "
                   f"WHERE {feat_type}_id = '{element_id}'")
            row = self.controller.get_row(sql)

            if not row:
                return

            utils_giswater.setText(self.dlg_dim, "depth", row[0])
            utils_giswater.setText(self.dlg_dim, "feature_id", element_id)
            utils_giswater.setText(self.dlg_dim, "feature_type", feat_type.upper())


    def orientation(self):

        self.emit_point.canvasClicked.connect(self.click_button_orientation)


    def click_button_orientation(self, point):

        if not self.layer_dimensions:
            return

        self.x_symbol = self.dlg_dim.findChild(QLineEdit, "x_symbol")

        self.x_symbol.setText(str(int(point.x())))

        self.y_symbol = self.dlg_dim.findChild(QLineEdit, "y_symbol")
        self.y_symbol.setText(str(int(point.y())))


    def create_map_tips(self):
        """ Create MapTips on the map """

        sql = ("SELECT value FROM config_param_user "
               "WHERE cur_user = current_user AND parameter = 'dim_tooltip'")
        row = self.controller.get_row(sql)
        if not row or row[0].lower() != 'true':
            return

        self.timer_map_tips = QTimer(self.canvas)
        self.map_tip_node = QgsMapTip()
        self.map_tip_connec = QgsMapTip()

        self.canvas.xyCoordinates.connect(self.map_tip_changed)
        self.timer_map_tips.timeout.connect(self.show_map_tip)
        self.timer_map_tips_clear = QTimer(self.canvas)
        self.timer_map_tips_clear.timeout.connect(self.clear_map_tip)


    def map_tip_changed(self, point):
        """ SLOT. Initialize the Timer to show MapTips on the map """

        if self.canvas.underMouse():
            self.last_map_position = QgsPointXY(point.x(), point.y())
            self.map_tip_node.clear(self.canvas)
            self.map_tip_connec.clear(self.canvas)
            self.timer_map_tips.start(100)

    def show_map_tip(self):
        """ Show MapTips on the map """

        self.timer_map_tips.stop()
        if self.canvas.underMouse():
            point_qgs = self.last_map_position
            point_qt = self.canvas.mouseLastXY()
            if self.layer_node:
                self.map_tip_node.showMapTip(self.layer_node, point_qgs, point_qt, self.canvas)
            if self.layer_connec:
                self.map_tip_connec.showMapTip(self.layer_connec, point_qgs, point_qt, self.canvas)
            self.timer_map_tips_clear.start(1000)

    def clear_map_tip(self):
        """ Clear MapTips """

        self.timer_map_tips_clear.stop()
        self.map_tip_node.clear(self.canvas)
        self.map_tip_connec.clear(self.canvas)


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
            widget = self.set_data_type(field, widget)
            if field['widgettype'] == 'typeahead':
                widget = self.manage_lineedit(field, dialog, widget, completer)
            # if widget.property('column_id') == self.field_id:
            #     self.feature_id = widget.text()
            #     # Get selected feature
            #     self.feature = self.get_feature_by_id(self.layer, self.feature_id, self.field_id)
        elif field['widgettype'] == 'combo':
            widget = self.add_combobox(field)
            widget = self.set_widget_size(widget, field)
        elif field['widgettype'] == 'check':
            widget = self.add_checkbox(dialog, field)
        elif field['widgettype'] == 'datepickertime':
            widget = self.add_calendar(dialog, field)
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
        elif field['widgettype'] == 'tableView':
            widget = self.add_tableview(complet_result, field)
            widget = self.set_headers(widget, field)
            widget = self.populate_table(widget, field)
            widget = self.set_columns_config(widget, field['widgetname'], sort_order=1, isQStandardItemModel=True)
            utils_giswater.set_qtv_config(widget)

        return label, widget