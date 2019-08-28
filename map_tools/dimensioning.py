"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-

from qgis.PyQt.QtCore import QSettings, Qt

from ..actions.api_dimensioning import ApiDimensioning
from .parent import ParentMapTool


class Dimensioning(ParentMapTool):
    """ Button 39: Dimensioning """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        # Call ParentMapTool constructor
        super(Dimensioning, self).__init__(iface, settings, action, index_action)
        self.suppres_form = None

    def open_new_dimensioning(self, feature_id):
        self.layer.featureAdded.disconnect(self.open_new_dimensioning)
        feature = self.get_feature_by_id(self.layer, feature_id)
        self.layer.updateFeature(feature)
        self.layer.commitChanges()



        self.api_dim = ApiDimensioning(self.iface, self.settings, self.controller, self.plugin_dir)
        result, dialog = self.api_dim.open_form(new_feature=feature)

        # Restore user value (Settings/Options/Digitizing/Suppress attribute from pop-up after feature creation)
        QSettings().setValue("/Qgis/digitizing/disable_enter_attribute_values_dialog", self.suppres_form)


    def get_feature_by_id(self, layer, id_):

        features = layer.getFeatures()
        for feature in features:
            if feature.id() == id_:
                return feature
        return False
    """ QgsMapTools inherited event functions """
          
          
    def canvasMoveEvent(self, event):
        pass
                    

    def canvasReleaseEvent(self, event):
        pass

    def keyPressEvent(self, event):
        print(f"{event.key()} PRESSED")
        if event.key() == Qt.Key_Escape:
            print(f"{event.key()} PRESSED")
            self.action().trigger()
            return

    def activate(self):

        # Check button
        self.action().setChecked(True)          

        self.layer = self.controller.get_layer_by_tablename("v_edit_dimensions", show_warning=True)
        if self.layer:
            # Get user values (Settings/Options/Digitizing/Suppress attribute from pop-up after feature creation)
            # and set True
            self.suppres_form = QSettings().value("/Qgis/digitizing/disable_enter_attribute_values_dialog")
            QSettings().setValue("/Qgis/digitizing/disable_enter_attribute_values_dialog", True)
            self.iface.setActiveLayer(self.layer)
            self.controller.set_layer_visible(self.layer)
            self.layer.startEditing()
            # Implement the Add Feature button
            self.iface.actionAddFeature().trigger()
            # TODO uncomment nex line to manage new api tool
            # self.layer.featureAdded.connect(self.open_new_dimensioning)

    def deactivate(self):

        # Call parent method     
        ParentMapTool.deactivate(self)
    
