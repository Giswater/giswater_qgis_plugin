"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsPointXY, QgsVectorLayer
from qgis.PyQt.QtCore import QStringListModel
from ..map_tools.snapping_utils_v3 import SnappingConfigManager

from qgis.core import QgsExpression, QgsFeatureRequest, QgsExpressionContextUtils, QgsRectangle, QgsGeometry, QgsProject
from qgis.gui import QgsVertexMarker, QgsMapToolEmitPoint, QgsRubberBand, QgsDateTimeEdit
from qgis.PyQt.QtCore import Qt, QSettings, QTimer, QDate, QRegExp
from qgis.PyQt.QtGui import QColor, QIntValidator, QDoubleValidator, QRegExpValidator, QStandardItemModel, QStandardItem
from qgis.PyQt.QtWidgets import QLineEdit, QSizePolicy, QWidget, QComboBox, QGridLayout, QSpacerItem, QLabel, QCheckBox
from qgis.PyQt.QtWidgets import QCompleter, QToolButton, QFrame, QSpinBox, QDoubleSpinBox, QDateEdit, QGroupBox, QAction
from qgis.PyQt.QtWidgets import QTableView, QTabWidget, QPushButton, QTextEdit, QFileDialog
from qgis.PyQt.QtSql import QSqlTableModel

import os
import re
import subprocess
import sys
import webbrowser
from functools import partial

from .. import utils_giswater
from .parent import ParentAction
from .HyperLinkLabel import HyperLinkLabel

from ..ui_manager import BasicInfoUi


class ApiParent(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):

        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.dlg_is_destroyed = None
        self.tabs_removed = 0
        self.tab_type = None
        self.list_update = []
        self.temp_layers_added = []


    def get_visible_layers(self, as_list=False):
        """ Return string as {...} or [...] with name of table in DB of all visible layer in TOC """
        
        visible_layer = '{'
        if as_list is True:
            visible_layer = '['
        layers = self.controller.get_layers()
        for layer in layers:
            if self.controller.is_layer_visible(layer):
                table_name = self.controller.get_layer_source_table_name(layer)
                table = layer.dataProvider().dataSourceUri()
                # TODO:: Find differences between PostgreSQL and query layers, and replace this if condition.
                if 'SELECT row_number() over ()' in str(table) or 'srid' not in str(table):
                    continue

                visible_layer += f'"{table_name}", '
        visible_layer = visible_layer[:-2]

        if as_list is True:
            visible_layer += ']'
        else:
            visible_layer += '}'
        return visible_layer


    def get_editable_layers(self):
        """ Return string as {...}  with name of table in DB of all editable layer in TOC """
        
        editable_layer = '{'
        layers = self.controller.get_layers()
        for layer in layers:
            if not layer.isReadOnly():
                table_name = self.controller.get_layer_source_table_name(layer)
                editable_layer += f'"{table_name}", '
        editable_layer = editable_layer[:-2] + "}"
        return editable_layer


    def set_completer_object_api(self, completer, model, widget, list_items, max_visible=10):
        """ Set autocomplete of widget @table_object + "_id"
            getting id's from selected @table_object.
            WARNING: Each QLineEdit needs their own QCompleter and their own QStringListModel!!!
        """

        # Set completer and model: add autocomplete in the widget
        completer.setCaseSensitivity(Qt.CaseInsensitive)
        completer.setMaxVisibleItems(max_visible)
        widget.setCompleter(completer)
        completer.setCompletionMode(1)
        model.setStringList(list_items)
        completer.setModel(model)


    def set_completer_object(self, dialog, table_object):
        """ Set autocomplete of widget @table_object + "_id"
            getting id's from selected @table_object
        """

        widget = utils_giswater.getWidget(dialog, table_object + "_id")
        if not widget:
            return

        # Set SQL
        field_object_id = "id"
        if table_object == "element":
            field_object_id = table_object + "_id"
        sql = (f"SELECT DISTINCT({field_object_id})"
               f" FROM {table_object}")

        rows = self.controller.get_rows(sql, log_sql=True)
        if rows is None:
            return

        for i in range(0, len(rows)):
            aux = rows[i]
            rows[i] = str(aux[0])

        # Set completer and model: add autocomplete in the widget
        self.completer = QCompleter()
        self.completer.setCaseSensitivity(Qt.CaseInsensitive)
        widget.setCompleter(self.completer)
        model = QStringListModel()
        model.setStringList(rows)
        self.completer.setModel(model)


    def close_dialog(self, dlg=None):
        """ Close dialog """

        try:
            self.save_settings(dlg)
            dlg.close()
        except Exception as e:
            pass

            
    def check_expression(self, expr_filter, log_info=False):
        """ Check if expression filter @expr is valid """

        if log_info:
            self.controller.log_info(expr_filter)
        expr = QgsExpression(expr_filter)
        if expr.hasParserError():
            message = "Expression Error"
            self.controller.log_warning(message, parameter=expr_filter)
            return False, expr

        return True, expr


    def select_features_by_expr(self, layer, expr):
        """ Select features of @layer applying @expr """

        if expr is None:
            layer.removeSelection()
        else:
            it = layer.getFeatures(QgsFeatureRequest(expr))
            # Build a list of feature id's from the previous result and select them
            id_list = [i.id() for i in it]
            if len(id_list) > 0:
                layer.selectByIds(id_list)
            else:
                layer.removeSelection()


    def get_feature_by_id(self, layer, id, field_id):

        features = layer.getFeatures()
        for feature in features:
            if feature[field_id] == id:
                return feature

        return False


    def get_feature_by_expr(self, layer, expr_filter):

        # Check filter and existence of fields
        expr = QgsExpression(expr_filter)
        if expr.hasParserError():
            message = f"{expr.parserErrorString()}: {expr_filter}"
            self.controller.show_warning(message)
            return

        it = layer.getFeatures(QgsFeatureRequest(expr))
        # Iterate over features
        for feature in it:
            return feature

        return False


    def check_actions(self, action, enabled):

        action.setChecked(enabled)


    def api_action_help(self, geom_type):
        """ Open PDF file with selected @wsoftware and @geom_type """

        # Get locale of QGIS application
        locale = QSettings().value('locale/userLocale').lower()
        if locale == 'es_es':
            locale = 'es'
        elif locale == 'es_ca':
            locale = 'ca'
        elif locale == 'en_us':
            locale = 'en'
        wsoftware = self.controller.get_project_type()
        # Get PDF file
        pdf_folder = os.path.join(self.plugin_dir, 'png')
        pdf_path = os.path.join(pdf_folder, f"{wsoftware}_{geom_type}_{locale}.pdf")

        # Open PDF if exists. If not open Spanish version
        if os.path.exists(pdf_path):
            os.system(pdf_path)
        else:
            locale = "es"
            pdf_path = os.path.join(pdf_folder, f"{wsoftware}_{geom_type}_{locale}.pdf")
            if os.path.exists(pdf_path):
                os.system(pdf_path)
            else:
                message = "File not found"
                self.controller.show_warning(message, parameter=pdf_path)


    def action_rotation(self, dialog):

        # Set map tool emit point and signals
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.previous_map_tool = self.canvas.mapTool()
        self.canvas.setMapTool(self.emit_point)
        self.emit_point.canvasClicked.connect(partial(self.action_rotation_canvas_clicked, dialog))


    def action_rotation_canvas_clicked(self, dialog, point, btn):

        if btn == Qt.RightButton:
            self.canvas.setMapTool(self.previous_map_tool)
            return

        viewname = self.controller.get_layer_source_table_name(self.layer)
        sql = (f"SELECT ST_X(the_geom), ST_Y(the_geom)"
               f" FROM {viewname}"
               f" WHERE node_id = '{self.feature_id}'")
        row = self.controller.get_row(sql)
        if row:
            existing_point_x = row[0]
            existing_point_y = row[1]

        sql = (f"UPDATE node"
               f" SET hemisphere = (SELECT degrees(ST_Azimuth(ST_Point({existing_point_x}, {existing_point_y}), "
               f" ST_Point({point.x()}, {point.y()}))))"
               f" WHERE node_id = '{self.feature_id}'")
        status = self.controller.execute_sql(sql)
        if not status:
            self.canvas.setMapTool(self.previous_map_tool)
            return

        sql = (f"SELECT rotation FROM node "
               f" WHERE node_id='{self.feature_id}'")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(dialog, "rotation", str(row[0]))

        sql = (f"SELECT degrees(ST_Azimuth(ST_Point({existing_point_x}, {existing_point_y}),"
               f" ST_Point({point.x()}, {point.y()})))")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(dialog, "hemisphere", str(row[0]))
            message = "Hemisphere of the node has been updated. Value is"
            self.controller.show_info(message, parameter=str(row[0]))
        self.api_disable_rotation(dialog)


    def api_disable_rotation(self, dialog):
        """ Disable actionRotation and set action 'Identify' """

        action_widget = dialog.findChild(QAction, "actionRotation")
        if action_widget:
            action_widget.setChecked(False)
        try:
            self.emit_point.canvasClicked.disconnect()
            self.canvas.setMapTool(self.previous_map_tool)
        except Exception as e:
            self.controller.log_info(type(e).__name__)


    def api_action_copy_paste(self, dialog, geom_type, tab_type=None):
        """ Copy some fields from snapped feature to current feature """

        # Set map tool emit point and signals
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.canvas.xyCoordinates.connect(self.api_action_copy_paste_mouse_move)
        self.emit_point.canvasClicked.connect(partial(self.api_action_copy_paste_canvas_clicked, dialog, tab_type))
        self.geom_type = geom_type

        # Store user snapping configuration
        self.snapper_manager = SnappingConfigManager(self.iface)
        if self.snapper_manager.controller is None:
            self.snapper_manager.set_controller(self.controller)
        self.snapper_manager.store_snapping_options()
        self.snapper = self.snapper_manager.get_snapper()

        # Clear snapping
        self.snapper_manager.enable_snapping()

        # Set snapping
        layer = self.iface.activeLayer()
        self.snapper_manager.snap_to_layer(layer)

        # Set marker
        color = QColor(255, 100, 255)
        self.vertex_marker = QgsVertexMarker(self.canvas)
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
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if not self.snapper_manager.result_is_valid():
            return

        # Add marker to snapped feature
        self.snapper_manager.add_marker(result, self.vertex_marker)


    def api_action_copy_paste_canvas_clicked(self, dialog, tab_type, point, btn):
        """ Slot function when canvas is clicked """

        if btn == Qt.RightButton:
            self.api_disable_copy_paste(dialog)
            return

        # Get clicked point
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if not self.snapper_manager.result_is_valid():
            self.api_disable_copy_paste(dialog)
            return

        layer = self.iface.activeLayer()
        layername = layer.name()
        is_valid = False

        # Get the point. Leave selection
        snapped_feature = self.snapper_manager.get_snapped_feature(result, True)
        snapped_feature_attr = snapped_feature.attributes()
        is_valid = True

        # TODO: Remove this?
        if not is_valid:
            message = "Any of the snapped features belong to selected layer"
            self.controller.show_info(message, parameter=layername, duration=10)
            self.api_disable_copy_paste(dialog)
            return

        aux = f'"{self.geom_type}_id" = '
        aux += f"'{self.feature_id}'"
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = "Expression Error"
            self.controller.show_warning(message, parameter=expr.parserErrorString())
            self.api_disable_copy_paste(dialog)
            return

        fields = layer.dataProvider().fields()
        layer.startEditing()
        it = layer.getFeatures(QgsFeatureRequest(expr))
        feature_list = [i for i in it]
        if not feature_list:
            self.api_disable_copy_paste(dialog)
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
            if self.project_type == 'ud':
                if fields[i].name() == str(self.geom_type) + '_type':
                    snapped_feature_attr_aux.append(snapped_feature_attr[i])
                    fields_aux.append(fields[i].name())

        for i in range(0, len(fields_aux)):
            msg += f"{fields_aux[i]}: {snapped_feature_attr_aux[i]}\n"

        # Ask confirmation question showing fields that will be copied
        answer = self.controller.ask_question(msg, "Update records", None)
        if answer:
            for i in range(0, len(fields)):
                for x in range(0, len(fields_aux)):
                    if fields[i].name() == fields_aux[x]:
                        layer.changeAttributeValue(feature.id(), i, snapped_feature_attr_aux[x])

            layer.commitChanges()

            # dialog.refreshFeature()
            for i in range(0, len(fields_aux)):
                widget = dialog.findChild(QWidget, tab_type + "_" + fields_aux[i])
                if utils_giswater.getWidgetType(dialog, widget) is QLineEdit:
                    utils_giswater.setWidgetText(dialog, widget, str(snapped_feature_attr_aux[i]))
                elif utils_giswater.getWidgetType(dialog, widget) is QComboBox:
                    utils_giswater.set_combo_itemData(widget, str(snapped_feature_attr_aux[i]), 0)

        self.api_disable_copy_paste(dialog)

        
    def api_disable_copy_paste(self, dialog):
        """ Disable actionCopyPaste and set action 'Identify' """

        action_widget = dialog.findChild(QAction, "actionCopyPaste")
        if action_widget:
            action_widget.setChecked(False)

        try:
            self.snapper_manager.recover_snapping_options()
            self.vertex_marker.hide()
            self.canvas.xyCoordinates.disconnect()
            self.emit_point.canvasClicked.disconnect()
        except:
            pass

            
    def set_table_columns(self, dialog, widget, table_name, schema_name=None):
        """ Configuration of tables. Set visibility and width of columns """

        widget = utils_giswater.getWidget(dialog, widget)
        if not widget:
            return

        if schema_name is not None:
            self.schema_name = schema_name
            self.controller.set_search_path(self.schema_name)

        # Set width and alias of visible columns
        columns_to_delete = []
        sql = (f"SELECT column_index, width, alias, status"
               f" FROM config_client_forms"
               f" WHERE table_id = '{table_name}'"
               f" ORDER BY column_index")
        rows = self.controller.get_rows(sql, log_info=False)
        if not rows:
            return

        for row in rows:
            if not row['status']:
                columns_to_delete.append(row['column_index'] - 1)
            else:
                width = row['width']
                if width is None:
                    width = 100
                widget.setColumnWidth(row['column_index'] - 1, width)
                widget.model().setHeaderData(row['column_index'] - 1, Qt.Horizontal, row['alias'])

        # Set order
        # widget.model().setSort(0, Qt.AscendingOrder)
        widget.model().select()

        # Delete columns
        for column in columns_to_delete:
            widget.hideColumn(column)


    def set_table_columns_for_query(self, dialog, widget, table_name):
    
        widget = utils_giswater.getWidget(dialog, widget)
        if not widget:
            return

        # Set width and alias of visible columns
        columns_to_show = ""
        sql = (f"SELECT column_index, width, column_id, alias, status"
               f" FROM config_client_forms"
               f" WHERE table_id = '{table_name}'"
               f" ORDER BY column_index")
        rows = self.controller.get_rows(sql, log_sql=False)
        if not rows:
            return
        for row in rows:
            if row['status']:
                if row['column_id'] is not None:
                    columns_to_show += str(row['column_id'])
                    if row['alias'] is not None:
                        columns_to_show += " AS " + str(row['alias'])
                    columns_to_show += ", "
                    width = row['width']
                    if width is None:
                        width = 100
                    widget.setColumnWidth(row['column_index'] - 1, width)

        if len(columns_to_show) > 1:
            columns_to_show = columns_to_show[:-2]
        else:
            columns_to_show = "*"
        return columns_to_show


    def set_widget_size(self, widget, field):

        if 'widgetdim' in field:
            if field['widgetdim']:
                widget.setMaximumWidth(field['widgetdim'])
                widget.setMinimumWidth(field['widgetdim'])

        return widget


    def add_button(self, dialog, field):

        widget = QPushButton()
        widget.setObjectName(field['widgetname'])
        if 'column_id' in field:
            widget.setProperty('column_id', field['column_id'])
        if 'value' in field:
            widget.setText(field['value'])
        widget.resize(widget.sizeHint().width(), widget.sizeHint().height())
        function_name = 'no_function_associated'
        real_name = widget.objectName()[5:len(widget.objectName())]
        if 'widgetfunction' in field:
            if field['widgetfunction'] is not None:
                function_name = field['widgetfunction']
                exist = self.controller.check_python_function(self, function_name)
                if not exist:
                    msg = f"widget {real_name} have associated function {function_name}, but {function_name} not exist"
                    self.controller.show_message(msg, 2)
                    return widget
            else:
                message = "Parameter button_function is null for button"
                self.controller.show_message(message, 2, parameter=widget.objectName())
        # Call def gw_api_open_node(self, dialog, widget) of the class ApiCf
        # or def no_function_associated(self, widget=None, message_level=1)
        """
            functions called in -> partial(getattr(self, function_name), **kwargs)
                def no_function_associated(self, **kwargs)
                def gw_api_open_node(self, **kwargs) of the class ApiCf
                def gw_function_dxf(self, **kwargs):
        """
        kwargs = {'dialog': dialog, 'widget': widget, 'message_level':1, 'function_name':function_name}
        widget.clicked.connect(partial(getattr(self, function_name), **kwargs))
        return widget


    def add_textarea(self, field):
        """ Add widgets QTextEdit type """
        widget = QTextEdit()
        widget.setObjectName(field['widgetname'])
        if 'column_id' in field:
            widget.setProperty('column_id', field['column_id'])
        if 'value' in field:
            widget.setText(field['value'])
        if 'iseditable' in field:
            widget.setReadOnly(not field['iseditable'])
            if not field['iseditable']:
                widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242);"
                                     " color: rgb(100, 100, 100)}")
        return widget


    def add_lineedit(self, field):
        """ Add widgets QLineEdit type """
        
        widget = QLineEdit()
        widget.setObjectName(field['widgetname'])
        if 'column_id' in field:
            widget.setProperty('column_id', field['column_id'])
        if 'value' in field:
            widget.setText(field['value'])
        if 'iseditable' in field:
            widget.setReadOnly(not field['iseditable'])
            if not field['iseditable']:
                widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242); color: rgb(100, 100, 100)}")
        return widget


    def set_data_type(self, field, widget):
        widget.setProperty('datatype', field['datatype'])
        return widget


    def manage_lineedit(self, field, dialog, widget, completer):
        if field['widgettype'] == 'typeahead':
            if 'queryText' not in field or 'queryTextFilter' not in field:
                return widget
            model = QStringListModel()
            widget.textChanged.connect(partial(self.populate_lineedit, completer, model, field, dialog, widget))

        return widget


    def populate_lineedit(self, completer, model, field, dialog, widget):
        """ Set autocomplete of widget @table_object + "_id"
            getting id's from selected @table_object.
            WARNING: Each QLineEdit needs their own QCompleter and their own QStringListModel!!!
        """

        if not widget:
            return
        parent_id = ""
        if 'parentId' in field:
            parent_id = field["parentId"]

        extras = f'"queryText":"{field["queryText"]}"'
        extras += f', "queryTextFilter":"{field["queryTextFilter"]}"'
        extras += f', "parentId":"{parent_id}"'
        extras += f', "parentValue":"{utils_giswater.getWidgetText(dialog, "data_" + str(field["parentId"]))}"'
        extras += f', "textToSearch":"{utils_giswater.getWidgetText(dialog, widget)}"'
        body = self.create_body(extras=extras)
        complet_list = self.controller.get_json('gw_api_gettypeahead', body)
        if not complet_list: return False

        list_items = []
        for field in complet_list['body']['data']:
            list_items.append(field['idval'])
        self.set_completer_object_api(completer, model, widget, list_items)


    def add_tableview(self, complet_result, field):
        """ Add widgets QTableView type """

        widget = QTableView()
        widget.setObjectName(field['widgetname'])
        if 'column_id' in field:
            widget.setProperty('column_id', field['column_id'])
        function_name = 'no_function_asociated'
        real_name = widget.objectName()[5:len(widget.objectName())]
        if 'widgetfunction' in field:
            if field['widgetfunction'] is not None:
                function_name = field['widgetfunction']
                exist = self.controller.check_python_function(self, function_name)
                if not exist:
                    msg = f"widget {real_name} have associated function {function_name}, but {function_name} not exist"
                    self.controller.show_message(msg, 2)
                    return widget
        # Call def gw_api_open_rpt_result(self, widget, complet_result) of class ApiCf
        widget.doubleClicked.connect(partial(getattr(self, function_name), widget, complet_result))

        return widget


    def no_function_associated(self, **kwargs):

        widget = kwargs['widget']
        message_level = kwargs['message_level']
        message = f"No function associated to"
        self.controller.show_message(message, message_level, parameter=f"{type(widget)} {widget.objectName()}")


    def set_headers(self, widget, field):

        standar_model = widget.model()
        if standar_model is None:
            standar_model = QStandardItemModel()
        # Related by Qtable
        widget.setModel(standar_model)
        widget.horizontalHeader().setStretchLastSection(True)

        # # Get headers
        headers = []
        for x in field['value'][0]:
            headers.append(x)
        # Set headers
        standar_model.setHorizontalHeaderLabels(headers)

        return widget


    def populate_table(self, widget, field):

        standar_model = widget.model()
        for item in field['value']:
            row = []
            for value in item.values():
                row.append(QStandardItem(str(value)))
            if len(row) > 0:
                standar_model.appendRow(row)

        return widget


    def set_columns_config(self, widget, table_name, sort_order=0, isQStandardItemModel=False):
        """ Configuration of tables. Set visibility and width of columns """

        # Set width and alias of visible columns
        columns_to_delete = []
        sql = (f"SELECT column_index, width, alias, status"
               f" FROM config_client_forms"
               f" WHERE table_id = '{table_name}'"
               f" ORDER BY column_index")
        rows = self.controller.get_rows(sql, log_info=False)
        if not rows:
            return widget

        for row in rows:
            if not row['status']:
                columns_to_delete.append(row['column_index'] - 1)
            else:
                width = row['width']
                if width is None:
                    width = 100
                widget.setColumnWidth(row['column_index'] - 1, width)
                if row['alias'] is not None:
                    widget.model().setHeaderData(row['column_index'] - 1, Qt.Horizontal, row['alias'])

        # Set order
        if isQStandardItemModel:
            widget.model().sort(sort_order, Qt.AscendingOrder)
        else:
            widget.model().setSort(sort_order, Qt.AscendingOrder)
            widget.model().select()
        # Delete columns
        for column in columns_to_delete:
            widget.hideColumn(column)

        return widget


    def add_checkbox(self, field):

        widget = QCheckBox()
        widget.setObjectName(field['widgetname'])
        widget.setProperty('column_id', field['column_id'])
        if 'value' in field:
            if field['value'] in ("t", "true", True):
                widget.setChecked(True)
        if 'iseditable' in field:
            widget.setEnabled(field['iseditable'])
        return widget


    def add_combobox(self, field):
    
        widget = QComboBox()
        widget.setObjectName(field['widgetname'])
        if 'column_id' in field:
            widget.setProperty('column_id', field['column_id'])
        widget = self.populate_combo(widget, field)
        if 'selectedId' in field:
            utils_giswater.set_combo_itemData(widget, field['selectedId'], 0)
        return widget


    def fill_child(self, dialog, widget, feature_type, tablename, field_id):
        """ Find QComboBox child and populate it
        :param dialog: QDialog
        :param widget: QComboBox parent
        :param feature_type: PIPE, ARC, JUNCTION, VALVE...
        :param tablename: view of DB
        :param field_id: Field id of tablename
        """

        combo_parent = widget.property('column_id')
        combo_id = utils_giswater.get_item_data(dialog, widget)

        feature = f'"featureType":"{feature_type}", '
        feature += f'"tableName":"{tablename}", '
        feature += f'"idName":"{field_id}"'
        extras = f'"comboParent":"{combo_parent}", "comboId":"{combo_id}"'
        body = self.create_body(feature=feature, extras=extras)
        result = self.controller.get_json('gw_api_getchilds', body)
        if not result: return False

        for combo_child in result['body']['data']:
            if combo_child is not None:
                self.manage_child(dialog, widget, combo_child)


    def manage_child(self, dialog, combo_parent, combo_child):
        child = dialog.findChild(QComboBox, str(combo_child['widgetname']))
        if child:
            child.setEnabled(True)

            self.populate_child(dialog, combo_child)
            if 'widgetcontrols' not in combo_child or not combo_child['widgetcontrols'] or \
                    'enableWhenParent' not in combo_child['widgetcontrols']:
                return
            #
            if (str(utils_giswater.get_item_data(dialog, combo_parent, 0)) in str(combo_child['widgetcontrols']['enableWhenParent'])) \
                    and (utils_giswater.get_item_data(dialog, combo_parent, 0) not in (None, '')):
                # The keepDisbled property is used to keep the edition enabled or disabled,
                # when we activate the layer and call the "enable_all" function
                child.setProperty('keepDisbled', False)
                child.setEnabled(True)
            else:
                child.setProperty('keepDisbled', True)
                child.setEnabled(False)


    def populate_child(self, dialog, combo_child):

        child = dialog.findChild(QComboBox, str(combo_child['widgetname']))
        if child:
            self.populate_combo(child, combo_child)

        
    def populate_combo(self, widget, field):
        # Generate list of items to add into combo

        widget.blockSignals(True)
        widget.clear()
        widget.blockSignals(False)
        combolist = []
        if 'comboIds' in field:
            if 'isNullValue' in field and field['isNullValue']:
                combolist.append(['',''])
            for i in range(0, len(field['comboIds'])):
                elem = [field['comboIds'][i], field['comboNames'][i]]
                combolist.append(elem)

        # Populate combo
        for record in combolist:
            widget.addItem(record[1], record)

        return widget


    def add_frame(self, field, x=None):
    
        widget = QFrame()
        widget.setObjectName(f"{field['widgetname']}_{x}")
        if 'column_id' in field:
            widget.setProperty('column_id', field['column_id'])
        widget.setFrameShape(QFrame.HLine)
        widget.setFrameShadow(QFrame.Sunken)

        return widget


    def add_label(self, field):
        """ Add widgets QLineEdit type """
        
        widget = QLabel()
        widget.setTextInteractionFlags(Qt.TextSelectableByMouse)
        widget.setObjectName(field['widgetname'])
        if 'column_id' in field:
            widget.setProperty('column_id', field['column_id'])
        if 'value' in field:
            widget.setText(field['value'])

        return widget


    def set_calendar_empty(self, widget):
        """ Set calendar empty when click inner button of QgsDateTimeEdit because aesthetically it looks better"""
        widget.setEmpty()

        
    def add_hyperlink(self, dialog, field):
    
        widget = HyperLinkLabel()
        widget.setObjectName(field['widgetname'])
        if 'column_id' in field:
            widget.setProperty('column_id', field['column_id'])
        if 'value' in field:
            widget.setText(field['value'])
        widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
        widget.resize(widget.sizeHint().width(), widget.sizeHint().height())
        func_name = 'no_function_associated'
        real_name = widget.objectName()[5:len(widget.objectName())]
        if 'widgetfunction' in field:
            if field['widgetfunction'] is not None:
                func_name = field['widgetfunction']
                exist = self.controller.check_python_function(self, func_name)
                if not exist:
                    msg = f"widget {real_name} have associated function {func_name}, but {func_name} not exist"
                    self.controller.show_message(msg, 2)
                    return widget
            else:
                message = "Parameter widgetfunction is null for widget"
                self.controller.show_message(message, 2, parameter=real_name)
        else:
            message = "Parameter not found"
            self.controller.show_message(message, 2, parameter='widgetfunction')
        # Call def gw_api_open_url(self, widget) or def no_function_associated(self, widget=None, message_level=1)
        widget.clicked.connect(partial(getattr(self, func_name), widget))
        return widget

        
    def add_horizontal_spacer(self):
        widget = QSpacerItem(10, 10, QSizePolicy.Expanding, QSizePolicy.Minimum)
        return widget

        
    def add_verical_spacer(self):
        widget = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        return widget


    def add_spinbox(self, field):

        widget = None
        if 'value' in field:
            if field['widgettype'] == 'spinbox':
                widget = QSpinBox()
            if field['widgettype'] == 'doubleSpinbox':
                widget = QDoubleSpinBox()
        widget.setObjectName(field['widgetname'])
        if 'column_id' in field:
            widget.setProperty('column_id', field['column_id'])
        if 'value' in field:
            if field['widgettype'] == 'spinbox' and field['value'] != "":
                widget.setValue(int(field['value']))
            elif field['widgettype'] == 'doubleSpinbox' and field['value'] != "":
                widget.setValue(float(field['value']))
        if 'iseditable' in field:
            widget.setReadOnly(not field['iseditable'])
            if not field['iseditable']:
                widget.setStyleSheet("QDoubleSpinBox { background: rgb(0, 250, 0);"
                                     " color: rgb(100, 100, 100)}")
        return widget


    def draw(self, complet_result, zoom=True, reset_rb=True):

        if complet_result[0]['body']['feature']['geometry'] is None:
            return
        if complet_result[0]['body']['feature']['geometry']['st_astext'] is None:
            return
        list_coord = re.search('\((.*)\)', str(complet_result[0]['body']['feature']['geometry']['st_astext']))
        max_x, max_y, min_x, min_y = self.get_max_rectangle_from_coords(list_coord)

        if reset_rb: self.resetRubberbands()
        if str(max_x) == str(min_x) and str(max_y) == str(min_y):
            point = QgsPointXY(float(max_x), float(max_y))
            self.draw_point(point)
        else:
            points = self.get_points(list_coord)
            self.draw_polyline(points)
        if zoom:
            margin = float(complet_result[0]['body']['feature']['zoomCanvasMargin']['mts'])
            self.zoom_to_rectangle(max_x, max_y, min_x, min_y, margin)

            
    def draw_point(self, point, color=QColor(255, 0, 0, 100), width=3, duration_time=None, is_new=False):
        """
        :param duration_time: integer milliseconds ex: 3000 for 3 seconds
        """

        if self.rubber_point is None:
            self.init_rubber()

        if is_new:
            rb = QgsRubberBand(self.canvas, 0)
        else:
            rb = self.rubber_point

        rb.setColor(color)
        rb.setWidth(width)
        rb.addPoint(point)

        # wait to simulate a flashing effect
        if duration_time is not None:
            QTimer.singleShot(duration_time, self.resetRubberbands)
        return rb


    def draw_polygon(self, points, border=QColor(255, 0, 0, 100), width=3, duration_time=None, fill_color=None):
        """ Draw 'polygon' over canvas following list of points
        :param duration_time: integer milliseconds ex: 3000 for 3 seconds
        """

        if self.rubber_polygon is None:
            self.init_rubber()

        rb = self.rubber_polygon
        polygon = QgsGeometry.fromPolygonXY([points])
        rb.setToGeometry(polygon, None)
        rb.setColor(border)
        if fill_color:
            rb.setFillColor(fill_color)
        rb.setWidth(width)
        rb.show()

        # wait to simulate a flashing effect
        if duration_time is not None:
            QTimer.singleShot(duration_time, self.resetRubberbands)

        return rb

           
    def fill_table(self, widget, table_name, filter_=None):
        """ Set a model with selected filter.
        Attach that model to selected table """

        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.setSort(0, 0)
        if filter_:
            model.setFilter(filter_)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

        # Attach model to table view
        widget.setModel(model)

        
    def populate_basic_info(self, dialog, result, field_id):

        fields = result[0]['body']['data']
        if 'fields' not in fields:
            return
        grid_layout = dialog.findChild(QGridLayout, 'gridLayout')

        for x, field in enumerate(fields["fields"]):

            label = QLabel()
            label.setObjectName('lbl_' + field['label'])
            label.setText(field['label'].capitalize())

            if 'tooltip' in field:
                label.setToolTip(field['tooltip'])
            else:
                label.setToolTip(field['label'].capitalize())

            if field['widgettype'] in ('text', 'textline') or field['widgettype'] == 'typeahead':
                completer = QCompleter()
                widget = self.add_lineedit(field)
                widget = self.set_widget_size(widget, field)
                widget = self.set_data_type(field, widget)
                if field['widgettype'] == 'typeahead':
                    widget = self.manage_lineedit(field, dialog, widget, completer)
                if widget.property('column_id') == field_id:
                    self.feature_id = widget.text()
            elif field['widgettype'] == 'datepickertime':
                widget = self.add_calendar(dialog, field)
                widget = self.set_auto_update_dateedit(field, dialog, widget)
            elif field['widgettype'] == 'hyperlink':
                widget = self.add_hyperlink(dialog, field)
            elif field['widgettype'] == 'textarea':
                widget = self.add_textarea(field)
            elif field['widgettype'] in ('combo', 'combobox'):
                widget = QComboBox()
                self.populate_combo(widget, field)
                widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
            elif field['widgettype'] in ('check','checkbox'):
                widget = self.add_checkbox(field)
                widget.stateChanged.connect(partial(self.get_values, dialog, widget, self.my_json))
            elif field['widgettype'] == 'button':
                widget = self.add_button(dialog, field)

            grid_layout.addWidget(label,x, 0)
            grid_layout.addWidget(widget, x, 1)

        verticalSpacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        grid_layout.addItem(verticalSpacer1)
        
        return result


    def clear_gridlayout(self, layout):
        """  Remove all widgets of layout """
        
        while layout.count() > 0:
            child = layout.takeAt(0).widget()
            if child:
                child.setParent(None)
                child.deleteLater()
                

    def add_calendar(self, dialog, field):
    
        widget = QgsDateTimeEdit()
        widget.setObjectName(field['widgetname'])
        if 'column_id' in field:
            widget.setProperty('column_id', field['column_id'])
        widget.setAllowNull(True)
        widget.setCalendarPopup(True)
        widget.setDisplayFormat('dd/MM/yyyy')
        if 'value' in field and field['value'] not in ('', None, 'null'):
            date = QDate.fromString(field['value'].replace('/', '-'), 'yyyy-MM-dd')
            utils_giswater.setCalendarDate(dialog, widget, date)
        else:
            widget.clear()
        btn_calendar = widget.findChild(QToolButton)

        if field['isautoupdate']:
            _json = {}
            btn_calendar.clicked.connect(partial(self.get_values, dialog, widget, _json))
            btn_calendar.clicked.connect(partial(self.accept, dialog, self.complet_result[0], self.feature_id, _json, True, False))
        else:
            btn_calendar.clicked.connect(partial(self.get_values, dialog, widget, self.my_json))
        btn_calendar.clicked.connect(partial(self.set_calendar_empty, widget))

        return widget


    def manage_close_interpolate(self):

        self.save_settings(self.dlg_binfo)
        self.remove_interpolate_rb()


    def activate_snapping(self, complet_result, ep):

        self.rb_interpolate = []
        self.interpolate_result = None
        self.resetRubberbands()
        self.dlg_binfo = BasicInfoUi()
        self.load_settings(self.dlg_binfo)

        utils_giswater.setWidgetText(self.dlg_binfo, self.dlg_binfo.txt_infolog, 'Interpolate tool')
        self.dlg_binfo.lbl_title.setText("Please, use the cursor to select two nodes to proceed with the "
                                         "interpolation\nNode1: \nNode2:")

        self.dlg_binfo.btn_accept.clicked.connect(partial(self.chek_for_existing_values))
        self.dlg_binfo.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_binfo))
        self.dlg_binfo.rejected.connect(partial(self.save_settings, self.dlg_binfo))
        self.dlg_binfo.rejected.connect(partial(self.remove_interpolate_rb))

        self.open_dialog(self.dlg_binfo)

        # Set circle vertex marker
        color = QColor(255, 100, 255)
        self.vertex_marker = QgsVertexMarker(self.canvas)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CIRCLE)
        self.vertex_marker.setColor(color)
        self.vertex_marker.setIconSize(15)
        self.vertex_marker.setPenWidth(3)

        self.node1 = None
        self.node2 = None

        self.canvas.setMapTool(ep)
        # We redraw the selected feature because self.canvas.setMapTool(emit_point) erases it
        self.draw(complet_result, False, False)

        # Store user snapping configuration
        self.snapper_manager = SnappingConfigManager(self.iface)
        if self.snapper_manager.controller is None:
            self.snapper_manager.set_controller(self.controller)
        self.snapper_manager.store_snapping_options()
        self.snapper = self.snapper_manager.get_snapper()

        self.layer_node = self.controller.get_layer_by_tablename("v_edit_node")
        self.iface.setActiveLayer(self.layer_node)

        self.canvas.xyCoordinates.connect(partial(self.mouse_move))
        ep.canvasClicked.connect(partial(self.snapping_node, ep))


    def dlg_destroyed(self, layer=None, vertex=None):

        self.dlg_is_destroyed = True
        if layer is not None:
            self.iface.setActiveLayer(layer)
        else:
            if self.layer is not None:
                self.iface.setActiveLayer(self.layer)
        if vertex is not None:
            self.iface.mapCanvas().scene().removeItem(vertex)
        else:
            if hasattr(self, 'vertex_marker'):
                if self.vertex_marker is not None:
                    self.iface.mapCanvas().scene().removeItem(self.vertex_marker)
        try:
            self.canvas.xyCoordinates.disconnect()
        except:
            pass


    def snapping_node(self, ep, point, button):
        """ Get id of selected nodes (node1 and node2) """

        if button == 2:
            self.dlg_destroyed()
            return

        # Get coordinates
        event_point = self.snapper_manager.get_event_point(point=point)
        if not event_point: return
        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if self.snapper_manager.result_is_valid():
            layer = self.snapper_manager.get_snapped_layer(result)
            # Check feature
            if layer == self.layer_node:
                snapped_feat = self.snapper_manager.get_snapped_feature(result)
                element_id = snapped_feat.attribute('node_id')
                message = "Selected node"
                if self.node1 is None:
                    self.node1 = str(element_id)                    
                    rb = self.draw_point(QgsPointXY(result.point()),color=QColor(0, 150, 55, 100), width=10, is_new=True)
                    self.rb_interpolate.append(rb)
                    self.dlg_binfo.lbl_title.setText(f"Node1: {self.node1}\nNode2:")
                    self.controller.show_message(message, message_level=0, parameter=self.node1)
                elif self.node1 != str(element_id):
                    self.node2 = str(element_id)
                    rb = self.draw_point(QgsPointXY(result.point()),color=QColor(0, 150, 55, 100), width=10, is_new=True)
                    self.rb_interpolate.append(rb)
                    self.dlg_binfo.lbl_title.setText(f"Node1: {self.node1}\nNode2: {self.node2}")
                    self.controller.show_message(message, message_level=0, parameter=self.node2)

        if self.node1 and self.node2:
            self.canvas.xyCoordinates.disconnect()
            ep.canvasClicked.disconnect()

            self.iface.setActiveLayer(self.layer)
            self.iface.mapCanvas().scene().removeItem(self.vertex_marker)
            extras = f'"parameters":{{'
            extras += f'"x":{self.last_point[0]}, '
            extras += f'"y":{self.last_point[1]}, '
            extras += f'"node1":"{self.node1}", '
            extras += f'"node2":"{self.node2}"}}'
            body = self.create_body(extras=extras)
            self.interpolate_result = self.controller.get_json('gw_fct_node_interpolate', body, log_sql=True)
            self.add_layer.populate_info_text(self.dlg_binfo, self.interpolate_result['body']['data'])


    def chek_for_existing_values(self):

        text = False
        for k, v in self.interpolate_result['body']['data']['fields'][0].items():
            widget = self.dlg_cf.findChild(QWidget, k)
            if widget:
                text = utils_giswater.getWidgetText(self.dlg_cf, widget, False, False)
                if text:
                    msg = "Do you want to overwrite custom values?"
                    answer = self.controller.ask_question(msg, "Overwrite values")
                    if answer:
                        self.set_values()
                    break
        if not text:
            self.set_values()


    def set_values(self):

        # Set values tu info form
        for k, v in self.interpolate_result['body']['data']['fields'][0].items():
            widget = self.dlg_cf.findChild(QWidget, k)
            if widget:
                widget.setStyleSheet(None)
                utils_giswater.setWidgetText(self.dlg_cf, widget, f'{v}')
                widget.editingFinished.emit()
        self.close_dialog(self.dlg_binfo)


    def remove_interpolate_rb(self):

        # Remove the circumferences made by the interpolate
        for rb in self.rb_interpolate:
            self.iface.mapCanvas().scene().removeItem(rb)


    def mouse_move(self, point):

        # Get clicked point
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if self.snapper_manager.result_is_valid():
            layer = self.snapper_manager.get_snapped_layer(result)
            if layer == self.layer_node:
                self.snapper_manager.add_marker(result, self.vertex_marker)
        else:
            self.vertex_marker.hide()


    def construct_form_param_user(self, dialog, row, pos, _json):

        field_id = ''
        if 'fields' in row[pos]:
            field_id = 'fields'
        elif 'return_type' in row[pos]:
            if row[pos]['return_type'] not in ('', None):
                field_id = 'return_type'

        if field_id == '':
            return

        for field in row[pos][field_id]:
            if field['label']:
                lbl = QLabel()
                lbl.setObjectName('lbl' + field['widgetname'])
                lbl.setText(field['label'])
                lbl.setMinimumSize(160, 0)
                lbl.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Preferred)
                if 'tooltip' in field:
                    lbl.setToolTip(field['tooltip'])

                if field['widgettype'] == 'text' or field['widgettype'] == 'linetext':
                    widget = QLineEdit()
                    if 'isMandatory' in field:
                        widget.setProperty('is_mandatory', field['isMandatory'])
                    else:
                        widget.setProperty('is_mandatory', True)
                    widget.setText(field['value'])
                    if 'widgetcontrols' in field and field['widgetcontrols']:
                        if 'regexpControl' in field['widgetcontrols']:
                            if field['widgetcontrols']['regexpControl'] is not None:
                                reg_exp = QRegExp(str(field['widgetcontrols']['regexpControl']))
                                #widget.setValidator(QRegExpValidator(reg_exp))
                    widget.editingFinished.connect(partial(self.get_values_changed_param_user, dialog, None, widget, field, _json))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'combo':
                    widget = self.add_combobox(field)
                    widget.currentIndexChanged.connect(partial(self.get_values_changed_param_user, dialog, None, widget, field, _json))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'check':
                    widget = QCheckBox()
                    if field['value'] is not None and field['value'].lower() == "true":
                        widget.setChecked(True)
                    else:
                        widget.setChecked(False)
                    widget.stateChanged.connect(partial(self.get_values_changed_param_user, dialog, None, widget, field, _json))
                    widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
                elif field['widgettype'] == 'datepickertime':
                    widget = QgsDateTimeEdit()
                    widget.setAllowNull(True)
                    widget.setCalendarPopup(True)
                    widget.setDisplayFormat('yyyy/MM/dd')
                    date = QDate.currentDate()
                    if 'value' in field and field['value'] not in ('', None, 'null'):
                        date = QDate.fromString(field['value'].replace('/', '-'), 'yyyy-MM-dd')
                    widget.setDate(date)
                    widget.dateChanged.connect(partial(self.get_values_changed_param_user, dialog, None, widget, field, _json))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'spinbox':
                    widget = QDoubleSpinBox()
                    if 'value' in field and field['value'] not in(None, ""):
                        value = float(str(field['value']))
                        widget.setValue(value)
                    widget.valueChanged.connect(partial(self.get_values_changed_param_user, dialog, None, widget, field, _json))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'button':
                    widget = self.add_button(dialog, field)
                    widget = self.set_widget_size(widget, field)

                # Set editable/readonly
                if type(widget) in (QLineEdit, QDoubleSpinBox):
                    if 'iseditable' in field:
                        if str(field['iseditable']) == "False":
                            widget.setReadOnly(True)
                            widget.setStyleSheet("QWidget {background: rgb(242, 242, 242);color: rgb(100, 100, 100)}")
                    if type(widget) == QLineEdit:
                        if 'placeholder' in field:
                            widget.setPlaceholderText(field['placeholder'])
                elif type(widget) in (QComboBox, QCheckBox):
                    if 'iseditable' in field:
                        if str(field['iseditable']) == "False":
                            widget.setEnabled(False)
                widget.setObjectName(field['widgetname'])

                self.put_widgets(dialog, field, lbl, widget)


    def put_widgets(self, dialog, field,  lbl, widget):
        """ Insert widget into layout """

        layout = dialog.findChild(QGridLayout, field['layoutname'])
        if layout is None:
            return
        layout.addWidget(lbl, int(field['layout_order']), 0)
        layout.addWidget(widget, int(field['layout_order']), 2)
        layout.setColumnStretch(2, 1)


    def get_values_changed_param_user(self, dialog, chk, widget, field, list, value=None):

        elem = {}
        if type(widget) is QLineEdit:
            value = utils_giswater.getWidgetText(dialog, widget, return_string_null=False)
        elif type(widget) is QComboBox:
            value = utils_giswater.get_item_data(dialog, widget, 0)
        elif type(widget) is QCheckBox:
            value = utils_giswater.isChecked(dialog, widget)
        elif type(widget) is QDateEdit:
            value = utils_giswater.getCalendarDate(dialog, widget)
        # if chk is None:
        #     elem[widget.objectName()] = value
        elem['widget'] = str(widget.objectName())
        elem['value'] = value
        if chk is not None:
            if chk.isChecked():
                # elem['widget'] = str(widget.objectName())
                elem['chk'] = str(chk.objectName())
                elem['isChecked'] = str(utils_giswater.isChecked(dialog, chk))
                # elem['value'] = value

        if 'sys_role_id' in field:
            elem['sys_role_id'] = str(field['sys_role_id'])
        list.append(elem)
        self.controller.log_info(str(list))


    def get_values_checked_param_user(self, dialog, chk, widget, field, _json, value=None):

        elem = {}
        elem['widget'] = str(widget.objectName())
        elem['chk'] = str(chk.objectName())

        if type(widget) is QLineEdit:
            value = utils_giswater.getWidgetText(dialog, widget, return_string_null=False)
        elif type(widget) is QComboBox:
            value = utils_giswater.get_item_data(dialog, widget, 0)
        elif type(widget) is QCheckBox:
            value = utils_giswater.isChecked(dialog, chk)
        elif type(widget) is QDateEdit:
            value = utils_giswater.getCalendarDate(dialog, widget)
        elem['widget'] = str(widget.objectName())
        elem['chk'] = str(chk.objectName())
        elem['isChecked'] = str(utils_giswater.isChecked(dialog, chk))
        elem['value'] = value
        if 'sys_role_id' in field:
            elem['sys_role_id'] = str(field['sys_role_id'])
        else:
            elem['sys_role_id'] = 'role_admin'

        self.list_update.append(elem)


    def set_widgets_into_composer(self, dialog, field):

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
            widget = self.add_lineedit(field)
            widget = self.set_widget_size(widget, field)
            widget = self.set_data_type(field, widget)
            widget.editingFinished.connect(partial(self.get_values, dialog, widget, self.my_json))
            widget.returnPressed.connect(partial(self.get_values, dialog, widget, self.my_json))
        elif field['widgettype'] == 'combo':
            widget = self.add_combobox(field)
            widget = self.set_widget_size(widget, field)
            widget.currentIndexChanged.connect(partial(self.get_values, dialog, widget, self.my_json))
            if 'widgetfunction' in field:
                if field['widgetfunction'] is not None:
                    function_name = field['widgetfunction']
                    # Call def gw_api_setprint(self, dialog, my_json): of the class ApiManageComposer
                    widget.currentIndexChanged.connect(partial(getattr(self, function_name), dialog, self.my_json))

        return label, widget


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
        # Only get values if layer is editable or if layer not exist(need for ApiManageComposer)
        if not hasattr(self, 'layer') or self.layer.isEditable():
            # If widget.isEditable(False) return None, here control it.
            if str(value) == '' or value is None:
                _json[str(widget.property('column_id'))] = None
            else:
                _json[str(widget.property('column_id'))] = str(value)


    def set_function_associated(self, dialog, widget, field):

        function_name = 'no_function_associated'
        if 'widgetfunction' in field:
            if field['widgetfunction'] is not None:
                function_name = field['widgetfunction']
                exist = self.controller.check_python_function(self, function_name)
                if not exist:
                    return widget
        else:
            message = "Parameter not found"
            self.controller.show_message(message, 2, parameter='button_function')

        if type(widget) == QLineEdit:
            # Call def gw_api_setprint(self, dialog, my_json): of the class ApiManageComposer
            widget.editingFinished.connect(partial(getattr(self, function_name), dialog, self.my_json))
            widget.returnPressed.connect(partial(getattr(self, function_name), dialog, self.my_json))

        return widget


    def draw_rectangle(self, result):
        """ Draw lines based on geometry """

        if result['geometry'] is None:
            return

        list_coord = re.search('\((.*)\)', str(result['geometry']['st_astext']))
        points = self.get_points(list_coord)
        self.draw_polyline(points)


    def set_setStyleSheet(self, field, widget, wtype='label'):

        if field['stylesheet'] is not None:
            if wtype in field['stylesheet']:
                widget.setStyleSheet("QWidget{" + field['stylesheet'][wtype] + "}")
        return widget


    """ FUNCTIONS ASSOCIATED TO BUTTONS FROM POSTGRES"""

    # def no_function_asociated(self, widget=None, message_level=1):
    #     self.controller.show_message(str("no_function_asociated for button: ") + str(widget.objectName()), message_level)


    def action_open_url(self, dialog, result):

        widget = None
        function_name = 'no_function_associated'
        for field in result['fields']:
            if field['linkedaction'] == 'action_link':
                function_name = field['widgetfunction']
                widget = dialog.findChild(HyperLinkLabel, field['widgetname'])
                break

        if widget:
            # Call def  def gw_api_open_url(self, widget)
            getattr(self, function_name)(widget)


    def gw_api_open_url(self, widget):

        path = widget.text()
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


    def gw_function_dxf(self, **kwargs):
        """ Function called in def add_button(self, dialog, field): -->
                widget.clicked.connect(partial(getattr(self, function_name), dialog, widget)) """

        path, filter_ = self.open_file_path(filter_ = "DXF Files (*.dxf)")
        if not path: return

        dialog = kwargs['dialog']
        widget = kwargs['widget']
        function_name = kwargs['function_name']
        complet_result = self.manage_dxf(dialog, path, False, True)
        gruop_name = os.path.splitext(os.path.basename(path))[0]
        self.add_layer.zoom_to_group(gruop_name)
        for layer in complet_result['temp_layers_added']:
            self.temp_layers_added.append(layer)
        if complet_result is not False:
            widget.setText(complet_result['path'])
        if complet_result['result']:
            data = complet_result['result']['body']['data']
            result =  self.add_layer.add_temp_layer(dialog, data, function_name, True, False, 1, True)
            for layer in result['temp_layers_added']:
                self.temp_layers_added.append(layer)
        dialog.btn_run.setEnabled(True)
        dialog.btn_cancel.setEnabled(True)


    def manage_dxf(self, dialog, dxf_path, export_to_db=False, toc=False, del_old_layers=True):
        """ Select a dxf file and add layers into toc
        :param dxf_path: path of dxf file
        :param export_to_db: Export layers to database
        :param toc: insert layers into TOC
        :param del_old_layers: look for a layer with the same name as the one to be inserted and delete it
        :return:
        """
        srid = self.controller.plugin_settings_value('srid')
        # Block the signals so that the window does not appear asking for crs / srid and / or alert message
        self.iface.mainWindow().blockSignals(True)
        dialog.txt_infolog.clear()

        sql = "DELETE FROM temp_table WHERE fprocesscat_id=106;\n"
        self.controller.execute_sql(sql)
        temp_layers_added = []
        for type_ in ['LineString', 'Point', 'Polygon']:
            sql = ""
            # Get file name without extension
            dxf_output_filename = os.path.splitext(os.path.basename(dxf_path))[0]
            # Create layer
            dxf_layer = QgsVectorLayer(f"{dxf_path}|layername=entities|geometrytype={type_}", f"{dxf_output_filename}_{type_}", 'ogr')

            # Set crs to layer
            crs = dxf_layer.crs()
            crs.createFromId(srid)
            dxf_layer.setCrs(crs)

            if not dxf_layer.hasFeatures():
                continue

            # Get the name of the columns
            field_names = [field.name() for field in dxf_layer.fields()]

            geom_types = {0:'geom_point', 1:'geom_line', 2:'geom_polygon'}
            for count, feature in enumerate(dxf_layer.getFeatures()):
                geom_type = feature.geometry().type()
                sql += (f"INSERT INTO temp_table (fprocesscat_id, text_column, {geom_types[int(geom_type)]})"
                        f" VALUES (106, '{{")
                for att in field_names:
                    if feature[att] in (None, 'NULL', ''):
                        sql += f'"{att}":null , '
                    else:
                        sql += f'"{att}":"{feature[att]}" , '
                geometry = self.add_layer.manage_geometry(feature.geometry())
                sql = sql[:-2] + f"}}', (SELECT ST_GeomFromText('{geometry}', {srid})));\n"
                if count != 0 and count % 500 == 0:
                    status = self.controller.execute_sql(sql)
                    if not status:
                        return False
                    sql = ""
            if sql != "":
                status = self.controller.execute_sql(sql)
                if not status:
                    return False

            if export_to_db:
                self.add_layer.export_layer_to_db(dxf_layer, crs)

            if del_old_layers:
                self.add_layer.delete_layer_from_toc(dxf_layer.name())

            if toc:
                if dxf_layer.isValid():
                    self.add_layer.from_dxf_to_toc(dxf_layer, dxf_output_filename)
                    temp_layers_added.append(dxf_layer)
        # Unlock signals
        self.iface.mainWindow().blockSignals(False)

        extras = "  "
        for widget in dialog.grb_parameters.findChildren(QWidget):
            widget_name = widget.property('column_id')
            value = utils_giswater.getWidgetText(dialog, widget, add_quote=False)
            extras += f'"{widget_name}":"{value}", '
        extras = extras[:-2]
        body = self.create_body(extras)
        result = self.controller.get_json('gw_fct_check_importdxf', None, log_sql=True)
        if not result: return False

        return {"path": dxf_path, "result":result, "temp_layers_added":temp_layers_added}


    def get_selector(self, dialog, selector_type):
        """ Ask to DB for selectors and make dialog
        :param dialog: Is a standard dialog, from file api_selectors.ui, where put widgets
        :param selector_type: list of selectors to ask DB ['exploitation', 'state', ...]
        """

        main_tab = dialog.findChild(QTabWidget, 'main_tab')
        extras = f'"selector_type":{selector_type}'
        body = self.create_body(extras=extras)
        complet_result = self.controller.get_json('gw_api_getselectors', body, log_sql=True)
        if not complet_result: return False

        for form_tab in complet_result['body']['form']['formTabs']:
            # Create one tab for each form_tab and add to QTabWidget
            tab_widget = QWidget(main_tab)
            tab_widget.setObjectName(form_tab['tabName'])
            main_tab.addTab(tab_widget, form_tab['tabLabel'])

            # Create a new QGridLayout and put it into tab
            gridlayout = QGridLayout()
            gridlayout.setObjectName("grl_" + form_tab['tabName'])
            tab_widget.setLayout(gridlayout)

            for order, field in enumerate(form_tab['fields']):
                label = QLabel()
                label.setObjectName('lbl_' + field['label'])
                label.setText(field['label'])
                widget = self.add_checkbox(field)
                widget.setProperty('selector_type', form_tab['selectorType'])
                widget.stateChanged.connect(partial(self.set_selector, widget, form_tab['tableName'], field['column_id'], form_tab['selectorType']))
                widget.setLayoutDirection(Qt.RightToLeft)
                field['layoutname'] = gridlayout.objectName()
                field['layout_order'] = order
                self.put_widgets(dialog, field, label, widget)
            vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
            gridlayout.addItem(vertical_spacer1)


    def set_selector(self, widget, table_name, column_name, selector_type, state):
        """ Send values to DB
        :param widget: QCheckBox that has changed status
        :param table_name: name of the table that we have to update
        :param column_name: name of the column that we have to update
        :param state: sent by widget when stateChange
        """

        extras = f'"selector_type":"{widget.property("selector_type")}", '
        extras += f'"tableName":"{table_name}", '
        extras += f'"column_id":"{column_name}", '
        extras += f'"result_name":"{widget.objectName()}", '
        extras += f'"result_value":"{widget.isChecked()}"'
        body = self.create_body(extras=extras)
        complet_result = self.controller.get_json('gw_api_setselectors', body, log_sql=True)
        if not complet_result: return False
        if selector_type in complet_result['body']['data']['indexingLayers']:
            for layer_name in complet_result['body']['data']['indexingLayers'][selector_type]:
                self.controller.indexing_spatial_layer(layer_name)
