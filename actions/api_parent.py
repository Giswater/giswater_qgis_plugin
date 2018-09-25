"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
import os
from PyQt4.QtCore import Qt
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

    def get_feature_by_id(self, layer):
        feature = None
        selected_features = layer.selectedFeatures()
        for f in selected_features:
            feature = f
            return feature

    def test(self, widget=None):
        # if event.key() == Qt.Key_Escape:
        #     self.controller.log_info(str("IT WORK S"))
        self.controller.log_info(str("---------------IT WORK S----------------"))
        return 0
        #self.controller.log_info(str(widget.objectName()))


