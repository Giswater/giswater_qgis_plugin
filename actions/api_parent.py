"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
import os

from PyQt4.QtCore import Qt, QSettings
from PyQt4.QtGui import QAction

from qgis.core import QgsMapLayerRegistry, QgsExpression,QgsFeatureRequest
import utils_giswater

from giswater.actions.parent import ParentAction

class ApiParent(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.dlg_is_destroyed = None

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

    def test(self, widget=None):
        # if event.key() == Qt.Key_Escape:
        #     self.controller.log_info(str("IT WORK S"))
        self.controller.log_info(str("---------------IT WORK S----------------"))
        return 0
        #self.controller.log_info(str(widget.objectName()))


