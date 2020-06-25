"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: latin-1 -*-
from qgis.core import QgsPointXY
from qgis.gui import QgsMapToolEmitPoint, QgsMapTip
from qgis.PyQt.QtCore import Qt, QTimer
from qgis.PyQt.QtWidgets import QAction, QCheckBox, QComboBox, QCompleter, QGridLayout, QLabel, QLineEdit, QSizePolicy, QSpacerItem

from functools import partial

from lib import utils_giswater
from .api_parent import ApiParent
from ..map_tools.snapping_utils_v3 import SnappingConfigManager
from ..ui_manager import DimensioningUi


class ApiDimensioning(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class constructor """

        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir
        self.canvas = self.iface.mapCanvas()

        # Snapper
        self.snapper_manager = SnappingConfigManager(self.iface)
        self.snapper_manager.set_controller(self.controller)
        self.snapper = self.snapper_manager.get_snapper()


    def open_form(self, qgis_feature=None, layer=None, db_return=None, fid=None):

        self.dlg_dim = DimensioningUi()
        self.load_settings(self.dlg_dim)

        # Set signals
        actionSnapping = self.dlg_dim.findChild(QAction, "actionSnapping")
        actionSnapping.triggered.connect(partial(self.snapping, actionSnapping))
        self.set_icon(actionSnapping, "103")

        actionOrientation = self.dlg_dim.findChild(QAction, "actionOrientation")
        actionOrientation.triggered.connect(partial(self.orientation, actionOrientation))
        self.set_icon(actionOrientation, "133")

        # Set layers dimensions, node and connec
        self.layer_dimensions = self.controller.get_layer_by_tablename("v_edit_dimensions")
        self.layer_node = self.controller.get_layer_by_tablename("v_edit_node")
        self.layer_connec = self.controller.get_layer_by_tablename("v_edit_connec")

        if qgis_feature is None:
            features = self.layer_dimensions.getFeatures()
            for feature in features:
                if feature['id'] == fid:
                     return feature
            qgis_feature = feature

        #qgis_feature = self.get_feature_by_id(self.layer_dimensions, fid, 'id')

        self.dlg_dim.btn_accept.clicked.connect(partial(self.save_dimensioning, qgis_feature, layer))
        self.dlg_dim.btn_cancel.clicked.connect(partial(self.cancel_dimensioning))
        self.dlg_dim.dlg_closed.connect(partial(self.cancel_dimensioning))
        self.dlg_dim.dlg_closed.connect(partial(self.save_settings, self.dlg_dim))

        self.create_map_tips()

        # when funcion is called from new feature
        if db_return is None:
            body = self.create_body()
            function_name = 'gw_fct_getdimensioning'
            json_result = self.controller.get_json(function_name, body, log_sql=True)
            if json_result is None:
                return False
            db_return = [json_result]

        # get id from db response
        self.fid = db_return[0]['body']['feature']['id']

        layout_list = []
        for field in db_return[0]['body']['data']['fields']:
            if 'hidden' in field and field['hidden']: continue

            label, widget = self.set_widgets(self.dlg_dim, db_return, field)

            if widget.objectName() == 'id':
                utils_giswater.setWidgetText(self.dlg_dim, widget, self.fid)
            layout = self.dlg_dim.findChild(QGridLayout, field['layoutname'])

            # profilactic issue to prevent missed layouts againts db response and form
            if layout is not None:

                # Take the QGridLayout with the intention of adding a QSpacerItem later
                if layout not in layout_list and layout.objectName() not in ('lyt_top_1', 'lyt_bot_1', 'lyt_bot_2'):
                    layout_list.append(layout)
                    # Add widgets into layout
                    layout.addWidget(label, 0, field['layoutorder'])
                    layout.addWidget(widget, 1, field['layoutorder'])

                # If field is on top or bottom layout the position is horitzontal no vertical
                if field['layoutname'] in ('lyt_top_1', 'lyt_bot_1', 'lyt_bot_2'):
                    layout.addWidget(label, 0, field['layoutorder'])
                    layout.addWidget(widget, 1, field['layoutorder'])
                else:
                    self.put_widgets(self.dlg_dim, field, label, widget)

        # Add a QSpacerItem into each QGridLayout of the list
        for layout in layout_list:
            vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
            layout.addItem(vertical_spacer1)

        title = f"DIMENSIONING - {self.fid}"
        self.open_dialog(self.dlg_dim, dlg_name='dimensioning', title=title)
        return False, False


    def cancel_dimensioning(self):

        self.iface.actionRollbackEdits().trigger()
        self.close_dialog(self.dlg_dim)


    def save_dimensioning(self, qgis_feature, layer):

        # Upsert feature into db
        layer.updateFeature(qgis_feature)
        layer.commitChanges()

        # Create body
        fields = ''
        list_widgets = self.dlg_dim.findChildren(QLineEdit)
        for widget in list_widgets:
            widget_name = widget.property('columnname')
            widget_value = utils_giswater.getWidgetText(self.dlg_dim, widget)
            if widget_value == 'null':
                continue
            fields += f'"{widget_name}":"{widget_value}", '

        list_widgets = self.dlg_dim.findChildren(QCheckBox)
        for widget in list_widgets:
            widget_name = widget.property('columnname')
            widget_value = f'"{utils_giswater.isChecked(self.dlg_dim, widget)}"'
            if widget_value == 'null':
                continue
            fields += f'"{widget_name}":{widget_value},'


        list_widgets = self.dlg_dim.findChildren(QComboBox)
        for widget in list_widgets:
            widget_name = widget.property('columnname')
            widget_value = f'"{utils_giswater.get_item_data(self.dlg_dim, widget)}"'
            if widget_value == 'null':
                continue
            fields += f'"{widget_name}":{widget_value},'

        # remove last character (,) from fields
        fields = fields[:-1]

        feature = '"tableName":"v_edit_dimensions", '
        feature += f'"id":"{self.fid}"'
        extras = f'"fields":{{{fields}}}'
        body = self.create_body(feature=feature, extras=extras)

        # Execute query
        sql = f"SELECT gw_fct_setdimensioning({body})::text"
        row = self.controller.get_row(sql, log_sql=True, commit=True)

        # Close dialog
        self.close_dialog(self.dlg_dim)


    def deactivate_signals(self, action):
        self.snapper_manager.remove_marker()
        try:
            self.canvas.xyCoordinates.disconnect()
        except TypeError:
            pass

        try:
            self.emit_point.canvasClicked.disconnect()
        except TypeError:
            pass

        if not action.isChecked():
            action.setChecked(False)
            return True

        return False


    def snapping(self, action):

        # Set active layer and set signals
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        if self.deactivate_signals(action): return

        self.snapper_manager.set_snapping_layers()
        self.snapper_manager.remove_marker()
        self.snapper_manager.store_snapping_options()
        self.snapper_manager.enable_snapping()
        self.snapper_manager.snap_to_node()
        self.snapper_manager.snap_to_connec_gully()
        self.snapper_manager.set_snapping_mode()

        self.dlg_dim.actionOrientation.setChecked(False)
        self.iface.setActiveLayer(self.layer_node)
        self.canvas.xyCoordinates.connect(self.mouse_move)
        self.emit_point.canvasClicked.connect(partial(self.click_button_snapping, action))


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


    def click_button_snapping(self, action, point, btn):

        if not self.layer_dimensions:
            return

        if btn == Qt.RightButton:
            if btn == Qt.RightButton:
                action.setChecked(False)
                self.deactivate_signals(action)
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
            fieldname = None
            self.project_type = self.controller.get_project_type()
            if self.project_type == 'ws':
                fieldname = "depth"
            elif self.project_type == 'ud' and feat_type == 'node':
                fieldname = "ymax"
            elif self.project_type == 'ud' and feat_type == 'connec':
                fieldname = "connec_depth"

            if fieldname is None:
                return

            depth = snapped_feat.attribute(fieldname)
            if depth:
                utils_giswater.setText(self.dlg_dim, "depth", depth)
            utils_giswater.setText(self.dlg_dim, "feature_id", element_id)
            utils_giswater.setText(self.dlg_dim, "feature_type", feat_type.upper())

            self.snapper_manager.recover_snapping_options()
            self.deactivate_signals(action)
            action.setChecked(False)

    def orientation(self, action):

        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        if self.deactivate_signals(action): return

        self.snapper_manager.set_snapping_layers()
        self.snapper_manager.remove_marker()
        self.snapper_manager.store_snapping_options()
        self.snapper_manager.enable_snapping()
        self.snapper_manager.snap_to_node()
        self.snapper_manager.snap_to_connec_gully()
        self.snapper_manager.set_snapping_mode()

        self.dlg_dim.actionSnapping.setChecked(False)
        self.emit_point.canvasClicked.connect(partial(self.click_button_orientation, action))


    def click_button_orientation(self, action, point, btn):

        if not self.layer_dimensions:
            return

        if btn == Qt.RightButton:
            action.setChecked(False)
            self.deactivate_signals(action)
            return

        self.x_symbol = self.dlg_dim.findChild(QLineEdit, "x_symbol")

        self.x_symbol.setText(str(int(point.x())))

        self.y_symbol = self.dlg_dim.findChild(QLineEdit, "y_symbol")
        self.y_symbol.setText(str(int(point.y())))

        self.snapper_manager.recover_snapping_options()
        self.deactivate_signals(action)
        action.setChecked(False)

    def create_map_tips(self):
        """ Create MapTips on the map """

        row = self.controller.get_config('qgis_dim_tooltip')
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


    def set_widgets(self, dialog, db_return, field):

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
        elif field['widgettype'] == 'combo':
            widget = self.add_combobox(field)
            widget = self.set_widget_size(widget, field)
        elif field['widgettype'] == 'check':
            widget = self.add_checkbox(field)
        elif field['widgettype'] == 'datetime':
            widget = self.add_calendar(dialog, field)
        elif field['widgettype'] == 'button':
            widget = self.add_button(dialog, field)
            widget = self.set_widget_size(widget, field)
        elif field['widgettype'] == 'hyperlink':
            widget = self.add_hyperlink(field)
            widget = self.set_widget_size(widget, field)
        elif field['widgettype'] == 'hspacer':
            widget = self.add_horizontal_spacer()
        elif field['widgettype'] == 'vspacer':
            widget = self.add_verical_spacer()
        elif field['widgettype'] == 'textarea':
            widget = self.add_textarea(field)
        elif field['widgettype'] in ('spinbox'):
            widget = self.add_spinbox(field)
        elif field['widgettype'] == 'tableview':
            widget = self.add_tableview(db_return, field)
            widget = self.set_headers(widget, field)
            widget = self.populate_table(widget, field)
            widget = self.set_columns_config(widget, field['widgetname'], sort_order=1, isQStandardItemModel=True)
            utils_giswater.set_qtv_config(widget)
        widget.setObjectName(widget.property('columnname'))

        return label, widget

