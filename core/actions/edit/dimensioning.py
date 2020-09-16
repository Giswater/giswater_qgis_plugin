"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: latin-1 -*-
from qgis.core import QgsPointXY
from qgis.gui import QgsMapToolEmitPoint, QgsMapTip, QgsVertexMarker
from qgis.PyQt.QtCore import Qt, QTimer
from qgis.PyQt.QtWidgets import QAction, QCheckBox, QComboBox, QCompleter, QGridLayout, QLabel, QLineEdit, \
    QSizePolicy, QSpacerItem

from functools import partial

from lib import qt_tools
from ...utils.giswater_tools import load_settings, open_dialog, save_settings

from ....ui_manager import DimensioningUi
from .... import global_vars

from ....actions.parent_functs import set_icon
from ....actions.api_parent_functs import create_body, put_widgets,  \
    close_dialog, set_setStyleSheet, add_lineedit, set_widget_size, set_data_type, manage_lineedit, add_combobox, \
    add_checkbox, add_calendar, add_button, add_hyperlink, add_horizontal_spacer, add_vertical_spacer, add_textarea, \
    add_spinbox, add_tableview, set_headers, populate_table, set_columns_config
from ....lib.qgis_tools import set_snapping_mode, remove_marker, get_snapping_options, enable_snapping, snap_to_node, \
    snap_to_connec_gully, get_event_point, snap_to_background_layers, get_snapped_layer, add_marker, \
    get_snapped_feature, get_snapped_feature_id, apply_snapping_options


class GwDimensioning:

    def __init__(self):
        """ Class constructor """

        self.iface = global_vars.iface
        self.settings = global_vars.settings
        self.controller = global_vars.controller
        self.plugin_dir = global_vars.plugin_dir
        self.canvas = global_vars.canvas

        self.vertex_marker = QgsVertexMarker(self.canvas)


    def open_dimensioning_form(self, qgis_feature=None, layer=None, db_return=None, fid=None):

        self.dlg_dim = DimensioningUi()
        load_settings(self.dlg_dim)

        # Set signals
        actionSnapping = self.dlg_dim.findChild(QAction, "actionSnapping")
        actionSnapping.triggered.connect(partial(self.snapping, actionSnapping))
        set_icon(actionSnapping, "103")

        actionOrientation = self.dlg_dim.findChild(QAction, "actionOrientation")
        actionOrientation.triggered.connect(partial(self.orientation, actionOrientation))
        set_icon(actionOrientation, "133")

        # Set layers dimensions, node and connec
        self.layer_dimensions = self.controller.get_layer_by_tablename("v_edit_dimensions")
        self.layer_node = self.controller.get_layer_by_tablename("v_edit_node")
        self.layer_connec = self.controller.get_layer_by_tablename("v_edit_connec")

        feature = None
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
        self.dlg_dim.dlg_closed.connect(partial(save_settings, self.dlg_dim))

        self.create_map_tips()

        # when funcion is called from new feature
        if db_return is None:
            body = create_body()
            function_name = 'gw_fct_getdimensioning'
            json_result = self.controller.get_json(function_name, body)
            if json_result is None:
                return False
            db_return = [json_result]

        # get id from db response
        self.fid = db_return[0]['body']['feature']['id']

        layout_list = []
        for field in db_return[0]['body']['data']['fields']:
            if 'hidden' in field and field['hidden']:
                continue

            label, widget = self.set_widgets(self.dlg_dim, db_return, field)

            if widget.objectName() == 'id':
                qt_tools.setWidgetText(self.dlg_dim, widget, self.fid)
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
                    put_widgets(self.dlg_dim, field, label, widget)

        # Add a QSpacerItem into each QGridLayout of the list
        for layout in layout_list:
            vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
            layout.addItem(vertical_spacer1)

        title = f"DIMENSIONING - {self.fid}"
        open_dialog(self.dlg_dim, dlg_name='dimensioning', title=title)
        return False, False


    def cancel_dimensioning(self):

        self.iface.actionRollbackEdits().trigger()
        close_dialog(self.dlg_dim)


    def save_dimensioning(self, qgis_feature, layer):

        # Upsert feature into db
        layer.updateFeature(qgis_feature)
        layer.commitChanges()

        # Create body
        fields = ''
        list_widgets = self.dlg_dim.findChildren(QLineEdit)
        for widget in list_widgets:
            widget_name = widget.property('columnname')
            widget_value = qt_tools.getWidgetText(self.dlg_dim, widget)
            if widget_value == 'null':
                continue
            fields += f'"{widget_name}":"{widget_value}", '

        list_widgets = self.dlg_dim.findChildren(QCheckBox)
        for widget in list_widgets:
            widget_name = widget.property('columnname')
            widget_value = f'"{qt_tools.isChecked(self.dlg_dim, widget)}"'
            if widget_value == 'null':
                continue
            fields += f'"{widget_name}":{widget_value},'


        list_widgets = self.dlg_dim.findChildren(QComboBox)
        for widget in list_widgets:
            widget_name = widget.property('columnname')
            widget_value = f'"{qt_tools.get_item_data(self.dlg_dim, widget)}"'
            if widget_value == 'null':
                continue
            fields += f'"{widget_name}":{widget_value},'

        # remove last character (,) from fields
        fields = fields[:-1]

        feature = '"tableName":"v_edit_dimensions", '
        feature += f'"id":"{self.fid}"'
        extras = f'"fields":{{{fields}}}'
        body = create_body(feature=feature, extras=extras)
        result = self.controller.get_json('gw_fct_setdimensioning', body)

        # Close dialog
        close_dialog(self.dlg_dim)


    def deactivate_signals(self, action, emit_point=None):
        self.vertex_marker.hide()
        try:
            self.canvas.xyCoordinates.disconnect()
        except TypeError:
            pass
        
        try:
            emit_point.canvasClicked.disconnect()
        except TypeError:
            pass

        if not action.isChecked():
            action.setChecked(False)
            return True

        return False


    def snapping(self, action):

        # Set active layer and set signals
        emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(emit_point)
        if self.deactivate_signals(action, emit_point):
            return

        remove_marker(self.vertex_marker)
        self.previous_snapping = get_snapping_options()
        enable_snapping()
        snap_to_node()
        snap_to_connec_gully()
        set_snapping_mode()

        self.dlg_dim.actionOrientation.setChecked(False)
        self.iface.setActiveLayer(self.layer_node)
        self.canvas.xyCoordinates.connect(self.mouse_move)
        emit_point.canvasClicked.connect(partial(self.click_button_snapping, action, emit_point))


    def mouse_move(self, point):

        # Hide marker and get coordinates
        self.vertex_marker.hide()
        event_point = get_event_point(point=point)

        # Snapping
        result = snap_to_background_layers(event_point)
        if result.isValid():
            layer = get_snapped_layer(result)
            # Check feature
            if layer == self.layer_node or layer == self.layer_connec:
                add_marker(result, self.vertex_marker)


    def click_button_snapping(self, action, emit_point, point, btn):

        if not self.layer_dimensions:
            return

        if btn == Qt.RightButton:
            if btn == Qt.RightButton:
                action.setChecked(False)
                self.deactivate_signals(action, emit_point)
                return

        layer = self.layer_dimensions
        self.iface.setActiveLayer(layer)
        layer.startEditing()

        # Get coordinates
        event_point = get_event_point(point=point)

        # Snapping
        result = snap_to_background_layers(event_point)
        if result.isValid():

            layer = get_snapped_layer(result)
            # Check feature
            if layer == self.layer_node:
                feat_type = 'node'
            elif layer == self.layer_connec:
                feat_type = 'connec'
            else:
                return

            # Get the point
            snapped_feat = get_snapped_feature(result)
            feature_id = get_snapped_feature_id(result)
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
                qt_tools.setText(self.dlg_dim, "depth", depth)
            qt_tools.setText(self.dlg_dim, "feature_id", element_id)
            qt_tools.setText(self.dlg_dim, "feature_type", feat_type.upper())

            apply_snapping_options(self.previous_snapping)
            self.deactivate_signals(action, emit_point)
            action.setChecked(False)

    def orientation(self, action):

        emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(emit_point)
        if self.deactivate_signals(action, emit_point):
            return

        remove_marker(self.vertex_marker)
        self.previous_snapping = get_snapping_options()
        enable_snapping()
        snap_to_node()
        snap_to_connec_gully()
        set_snapping_mode()

        self.dlg_dim.actionSnapping.setChecked(False)
        emit_point.canvasClicked.connect(partial(self.click_button_orientation, action, emit_point))


    def click_button_orientation(self, action, emit_point, point, btn):

        if not self.layer_dimensions:
            return

        if btn == Qt.RightButton:
            action.setChecked(False)
            self.deactivate_signals(action, emit_point)
            return

        self.x_symbol = self.dlg_dim.findChild(QLineEdit, "x_symbol")

        self.x_symbol.setText(str(int(point.x())))

        self.y_symbol = self.dlg_dim.findChild(QLineEdit, "y_symbol")
        self.y_symbol.setText(str(int(point.y())))

        apply_snapping_options(self.previous_snapping)
        self.deactivate_signals(action, emit_point)
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
                label = set_setStyleSheet(field, label)
            if 'tooltip' in field:
                label.setToolTip(field['tooltip'])
            else:
                label.setToolTip(field['label'].capitalize())
        if field['widgettype'] == 'text' or field['widgettype'] == 'typeahead':
            completer = QCompleter()
            widget = add_lineedit(field)
            widget = set_widget_size(widget, field)
            widget = set_data_type(field, widget)
            if field['widgettype'] == 'typeahead':
                widget = manage_lineedit(field, dialog, widget, completer)
        elif field['widgettype'] == 'combo':
            widget = add_combobox(field)
            widget = set_widget_size(widget, field)
        elif field['widgettype'] == 'check':
            widget = add_checkbox(field)
        elif field['widgettype'] == 'datetime':
            widget = add_calendar(dialog, field)
        elif field['widgettype'] == 'button':
            widget = add_button(dialog, field)
            widget = set_widget_size(widget, field)
        elif field['widgettype'] == 'hyperlink':
            widget = add_hyperlink(field)
            widget = set_widget_size(widget, field)
        elif field['widgettype'] == 'hspacer':
            widget = add_horizontal_spacer()
        elif field['widgettype'] == 'vspacer':
            widget = add_vertical_spacer()
        elif field['widgettype'] == 'textarea':
            widget = add_textarea(field)
        elif field['widgettype'] in 'spinbox':
            widget = add_spinbox(field)
        elif field['widgettype'] == 'tableview':
            widget = add_tableview(db_return, field)
            widget = set_headers(widget, field)
            widget = populate_table(widget, field)
            widget = set_columns_config(widget, field['widgetname'], sort_order=1, isQStandardItemModel=True)
            qt_tools.set_qtv_config(widget)
        widget.setObjectName(widget.property('columnname'))

        return label, widget

