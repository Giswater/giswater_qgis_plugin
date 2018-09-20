"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4.QtCore import Qt
    from PyQt4.QtGui import QAction
else:
    from qgis.PyQt.QtCore import Qt
    from qgis.PyQt.QtWidgets import QAction
    
from qgis.core import QgsMapLayerRegistry

import os

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


    def start_editing(self):
        """ start or stop the edition based on your current status"""
        self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').trigger()


    def check_actions(self, action, enabled):
        if not self.dlg_is_destroyed:
            action.setChecked(enabled)


    def test(self, widget=None):
        # if event.key() == Qt.Key_Escape:
        #     self.controller.log_info(str("IT WORK S"))
        self.controller.log_info(str("IT WORK S"))
        return 0
        #self.controller.log_info(str(widget.objectName()))

