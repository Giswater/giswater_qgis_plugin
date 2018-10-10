"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
import os
import re
from functools import partial

from PyQt4.QtCore import Qt, QSettings, QPoint, QTimer
from PyQt4.QtGui import QAction, QLineEdit, QSizePolicy, QColor, QWidget, QComboBox

from qgis.core import QgsMapLayerRegistry, QgsExpression,QgsFeatureRequest, QgsExpressionContextUtils, QGis
from qgis.core import QgsRectangle, QgsPoint, QgsGeometry
from qgis.gui import QgsMapCanvasSnapper, QgsVertexMarker, QgsMapToolEmitPoint, QgsRubberBand

import utils_giswater
from map_tools.snapping_utils import SnappingConfigManager
from giswater.actions.parent import ParentAction
from giswater.actions.HyperLinkLabel import HyperLinkLabel


class ApiParent(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.dlg_is_destroyed = None

        if QGis.QGIS_VERSION_INT >= 10900:
            self.rubber_point = QgsRubberBand(self.canvas, QGis.Point)
            self.rubber_point.setColor(Qt.yellow)
            # self.rubberBand.setIcon(QgsRubberBand.IconType.ICON_CIRCLE)
            self.rubber_point.setIconSize(10)
            self.rubber_polygon = QgsRubberBand(self.canvas)
            self.rubber_polygon.setColor(Qt.darkRed)
            self.rubber_polygon.setIconSize(20)
        else:
            self.vMarker = QgsVertexMarker(self.canvas)
            self.vMarker.setIconSize(10)


    def get_editable_project(self):
        """ Get variable 'editable_project' from qgis project variables"""
        editable_project = QgsExpressionContextUtils.projectScope().variable('editable_project')
        if editable_project is None:
            return False
        return editable_project

    def get_visible_layers(self):
            """ Return string as {...} with name of table in DB of all visible layer in TOC """
            visible_layer = '{'
            for layer in QgsMapLayerRegistry.instance().mapLayers().values():
                if self.iface.legendInterface().isLayerVisible(layer):
                    table_name = self.controller.get_layer_source_table_name(layer)
                    visible_layer += '"' + str(table_name) + '", '
            visible_layer = visible_layer[:-2] + "}"
            return visible_layer


    def get_editable_layers(self):
        """ Return string as {...}  with name of table in DB of all editable layer in TOC """
        editable_layer = '{'
        for layer in QgsMapLayerRegistry.instance().mapLayers().values():
            if not layer.isReadOnly():
                table_name = self.controller.get_layer_source_table_name(layer)
                editable_layer += '"' + str(table_name) + '", '
        editable_layer = editable_layer[:-2] + "}"
        return editable_layer


    def set_completer_object(self, completer, model, widget, list_items):
        """ Set autocomplete of widget @table_object + "_id"
            getting id's from selected @table_object.
            WARNING: Each QlineEdit needs their own QCompleter and their own QStringListModel!!!
        """

        # Set completer and model: add autocomplete in the widget
        completer.setCaseSensitivity(Qt.CaseInsensitive)
        completer.setMaxVisibleItems(10)
        widget.setCompleter(completer)
        completer.setCompletionMode(1)
        model.setStringList(list_items)
        completer.setModel(model)

    def close_dialog(self, dlg=None):
        """ Close dialog """
        try:
            self.save_settings(dlg)
            dlg.close()

        except AttributeError:
            pass

    def check_expression(self, expr_filter, log_info=False):
        """ Check if expression filter @expr is valid """

        if log_info:
            self.controller.log_info(expr_filter)
        expr = QgsExpression(expr_filter)
        if expr.hasParserError():
            message = "Expression Error"
            self.controller.log_warning(message, parameter=expr_filter)
            return (False, expr)
        return (True, expr)



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


    def start_editing(self):
        """ start or stop the edition based on your current status"""
        self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').trigger()


    def get_feature_by_id(self, layer):
        feature = None
        selected_features = layer.selectedFeatures()
        for f in selected_features:
            feature = f
            return feature


    def check_actions(self, action, enabled):
        if not self.dlg_is_destroyed:
            action.setChecked(enabled)


    def api_action_centered(self, feature, canvas, layer):
        """ Center map to current feature """
        layer.selectByIds([feature.id()])
        canvas.zoomToSelected(layer)


    def api_action_zoom_in(self, feature, canvas, layer):
        """ Zoom in """
        layer.selectByIds([feature.id()])
        canvas.zoomToSelected(layer)
        canvas.zoomIn()


    def api_action_zoom_out(self, feature, canvas, layer):
        """ Zoom out """
        self.controller.log_info(str(feature))
        layer.selectByIds([feature.id()])
        canvas.zoomToSelected(layer)
        canvas.zoomOut()


    def api_action_help(self, wsoftware, geom_type):
        """ Open PDF file with selected @wsoftware and @geom_type """
        # Get locale of QGIS application
        locale = QSettings().value('locale/userLocale').lower()
        if locale == 'es_es':
            locale = 'es'
        elif locale == 'es_ca':
            locale = 'ca'
        elif locale == 'en_us':
            locale = 'en'

        # Get PDF file
        pdf_folder = os.path.join(self.plugin_dir, 'png')
        pdf_path = os.path.join(pdf_folder, wsoftware + "_" + geom_type + "_" + locale + ".pdf")

        # Open PDF if exists. If not open Spanish version
        if os.path.exists(pdf_path):
            os.system(pdf_path)
        else:
            locale = "es"
            pdf_path = os.path.join(pdf_folder, wsoftware + "_" + geom_type + "_" + locale + ".pdf")
            if os.path.exists(pdf_path):
                os.system(pdf_path)
            else:
                message = "File not found"
                self.controller.show_warning(message, parameter=pdf_path)

    def api_action_copy_paste(self, dialog, geom_type):
        """ Copy some fields from snapped feature to current feature """

        # Set map tool emit point and signals
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.snapper = QgsMapCanvasSnapper(self.canvas)
        self.canvas.xyCoordinates.connect(self.api_action_copy_paste_mouse_move)
        self.emit_point.canvasClicked.connect(partial(self.api_action_copy_paste_canvas_clicked, dialog))
        self.geom_type = geom_type

        # Store user snapping configuration
        self.snapper_manager = SnappingConfigManager(self.iface)
        self.snapper_manager.store_snapping_options()

        # Clear snapping
        self.snapper_manager.clear_snapping()

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
        map_point = self.canvas.getCoordinateTransform().transform(point)
        x = map_point.x()
        y = map_point.y()
        event_point = QPoint(x, y)

        # Snapping
        (retval, result) = self.snapper.snapToCurrentLayer(event_point, 2)  # @UnusedVariable

        if not result:
            return

        # Check snapped features
        for snapped_point in result:
            point = QgsPoint(snapped_point.snappedVertex)
            self.vertex_marker.setCenter(point)
            self.vertex_marker.show()
            break

    def api_action_copy_paste_canvas_clicked(self, dialog, point, btn):
        """ Slot function when canvas is clicked """

        if btn == Qt.RightButton:
            self.api_disable_copy_paste(dialog)
            return

            # Get clicked point
        map_point = self.canvas.getCoordinateTransform().transform(point)
        x = map_point.x()
        y = map_point.y()
        event_point = QPoint(x, y)

        # Snapping
        (retval, result) = self.snapper.snapToCurrentLayer(event_point, 2)  # @UnusedVariable

        # That's the snapped point
        if not result:
            self.api_disable_copy_paste(dialog)
            return

        layer = self.iface.activeLayer()
        layername = layer.name()
        is_valid = False
        for snapped_point in result:
            # Get only one feature
            point = QgsPoint(snapped_point.snappedVertex)  # @UnusedVariable
            snapped_feature = next(
                snapped_point.layer.getFeatures(QgsFeatureRequest().setFilterFid(snapped_point.snappedAtGeometry)))
            snapped_feature_attr = snapped_feature.attributes()
            # Leave selection
            snapped_point.layer.select([snapped_point.snappedAtGeometry])
            is_valid = True
            break

        if not is_valid:
            message = "Any of the snapped features belong to selected layer"
            self.controller.show_info(message, parameter=self.iface.activeLayer().name(), duration=10)
            self.api_disable_copy_paste(dialog)
            return

        aux = "\"" + str(self.geom_type) + "_id\" = "
        aux += "'" + str(self.feature_id) + "'"
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
        message = ("Selected snapped feature_id to copy values from: " + str(snapped_feature_attr[0]) + "\n"
                   "Do you want to copy its values to the current node?\n\n")
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
            message += str(fields_aux[i]) + ": " + str(snapped_feature_attr_aux[i]) + "\n"

        # Ask confirmation question showing fields that will be copied
        answer = self.controller.ask_question(message, "Update records", None)
        if answer:
            for i in range(0, len(fields)):
                for x in range(0, len(fields_aux)):
                    if fields[i].name() == fields_aux[x]:
                        layer.changeAttributeValue(feature.id(), i, snapped_feature_attr_aux[x])

            layer.commitChanges()
            #TODO: REVISAR
            # dialog.refreshFeature()
            for i in range(0, len(fields_aux)):
                widget = dialog.findChild(QWidget, fields_aux[i])
                if utils_giswater.getWidgetType(dialog, widget) is QLineEdit:
                    utils_giswater.setWidgetText(dialog, widget, str(snapped_feature_attr_aux[i]))
                elif utils_giswater.getWidgetType(dialog, widget) is QComboBox:
                    utils_giswater.set_combo_itemData(widget, snapped_feature_attr_aux[i], 1)


        self.api_disable_copy_paste(dialog)

    def api_disable_copy_paste(self, dialog):
        """ Disable actionCopyPaste and set action 'Identify' """

        action_widget = dialog.findChild(QAction, "actionCopyPaste")
        if action_widget:
            action_widget.setChecked(False)

        try:
            self.snapper_manager.recover_snapping_options()
            self.vertex_marker.hide()
            self.set_action_identify()
            self.canvas.xyCoordinates.disconnect()
            self.emit_point.canvasClicked.disconnect()
        except:
            pass

    def set_table_columns(self, dialog, widget, table_name):
        """ Configuration of tables. Set visibility and width of columns """

        widget = utils_giswater.getWidget(dialog, widget)
        if not widget:
            return

        # Set width and alias of visible columns
        columns_to_delete = []
        sql = ("SELECT column_index, width, alias, status"
               " FROM " + self.schema_name + ".config_client_forms"
               " WHERE table_id = '" + table_name + "'"
               " ORDER BY column_index")
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
        sql = ("SELECT column_index, width, column_id, alias, status"
               " FROM " + self.schema_name + ".config_client_forms"
               " WHERE table_id = '" + table_name + "'"
               " ORDER BY column_index")
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


    def add_lineedit(self, field):
        """ Add widgets QLineEdit type """
        widget = QLineEdit()
        widget.setObjectName(field['column_id'])
        if 'value' in field:
            widget.setText(field['value'])
        if 'iseditable' in field:
            widget.setReadOnly(not field['iseditable'])
            if not field['iseditable']:
                widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242);"
                                     " color: rgb(100, 100, 100)}")
        return widget

    def set_calendar_empty(self, widget):
        """ Set calendar empty when click inner button of QgsDateTimeEdit because aesthetically it looks better"""
        widget.setEmpty()

    def add_hyperlink(self, dialog, field):
        widget = HyperLinkLabel()
        widget.setObjectName(field['column_id'])
        widget.setText(field['value'])
        widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
        widget.resize(widget.sizeHint().width(), widget.sizeHint().height())
        function_name = 'no_function_asociated'

        if 'button_function' in field:
            if field['button_function'] is not None:
                function_name = field['button_function']
            else:
                msg = ("parameter button_function is null for button " + widget.objectName())
                self.controller.show_message(msg, 2)
        else:
            msg = "parameter button_function not found"
            self.controller.show_message(msg, 2)

        widget.clicked.connect(partial(getattr(self, function_name), dialog, widget, 2))
        return widget


    def get_points(self, list_coord=None):
        """ Return list of QgsPoints taken from geometry
        :type list_coord: list of coors in format ['x1 y1', 'x2 y2',....,'x99 y99']
        """

        coords = list_coord.group(1)
        polygon = coords.split(',')
        points = []

        for i in range(0, len(polygon)):
            x, y = polygon[i].split(' ')
            point = QgsPoint(float(x), float(y))
            points.append(point)
            print(i, x, y)
        return points


    def get_max_rectangle_from_coords(self, list_coord):
        """ Returns the minimum rectangle(x1, y1, x2, y2) of a series of coordinates
        :type list_coord: list of coors in format ['x1 y1', 'x2 y2',....,'x99 y99']
        """
        coords = list_coord.group(1)
        polygon = coords.split(',')

        x, y = polygon[0].split(' ')
        min_x = x  # start with something much higher than expected min
        min_y = y
        max_x = x  # start with something much lower than expected max
        max_y = y
        for i in range(0, len(polygon)):
            x, y = polygon[i].split(' ')
            if x < min_x:
                min_x = x
            if x > max_x:
                max_x = x
            if y < min_y:
                min_y = y
            if y > max_y:
                max_y = y

        return max_x, max_y, min_x, min_y


    def zoom_to_rectangle(self, x1, y1, x2, y2):
        rect = QgsRectangle(float(x1), float(y1), float(x2), float(y2))
        self.canvas.setExtent(rect)
        self.canvas.refresh()


    def draw(self, complet_result):
        list_coord = re.search('\((.*)\)', str(complet_result[0]['geometry']['st_astext']))
        max_x, max_y, min_x, min_y = self.get_max_rectangle_from_coords(list_coord)

        self.resetRubberbands()
        if str(max_x) == str(min_x) and str(max_y) == str(min_y):
            point = QgsPoint(float(max_x), float(max_y))
            self.draw_point(point)
        else:
            points = self.get_points(list_coord)
            self.draw_polygon(points)
        self.zoom_to_rectangle(max_x, max_y, min_x, min_y)

    def draw_point(self, point, color=QColor(255, 0, 0, 100), width=3, duration_time=None):

        if QGis.QGIS_VERSION_INT >= 10900:
            rb = self.rubber_point
            rb.setColor(color)
            rb.setWidth(width)
            rb.addPoint(point)
        else:
            self.vMarker = QgsVertexMarker(self.canvas)
            self.vMarker.setIconSize(10)
            self.vMarker.setCenter(point)
            self.vMarker.show()

        # wait to simulate a flashing effect
        if duration_time is not None:
            QTimer.singleShot(duration_time, self.resetRubberbands)


    def draw_polygon(self, points, color=QColor(255, 0, 0, 100), width=5, duration_time=None):
        """ Draw 'line' over canvas following list of points """

        if QGis.QGIS_VERSION_INT >= 10900:
            rb = self.rubber_polygon
            rb.setToGeometry(QgsGeometry.fromPolyline(points), None)
            rb.setColor(color)
            rb.setWidth(width)
            rb.show()
        else:
            self.vMarker = QgsVertexMarker(self.canvas)
            self.vMarker.setIconSize(width)
            self.vMarker.setCenter(points)
            self.vMarker.show()

        # wait to simulate a flashing effect
        if duration_time is not None:
            QTimer.singleShot(duration_time, self.resetRubberbands)


    def resetRubberbands(self):
        canvas = self.canvas
        if QGis.QGIS_VERSION_INT >= 10900:
            self.rubber_point.reset(QGis.Point)
            self.rubber_polygon.reset()
        else:
            self.vMarker.hide()
            canvas.scene().removeItem(self.vMarker)


    def test(self, widget=None):
        # if event.key() == Qt.Key_Escape:
        #     self.controller.log_info(str("IT WORK S"))
        self.controller.log_info(str("---------------IT WORK S----------------"))
        return 0
        #self.controller.log_info(str(widget.objectName()))


