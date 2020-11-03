"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import QSettings, Qt

from ...shared.dimensioning import GwDimensioning
from ..parent_maptool import GwParentMapTool
from ....lib import tools_qt

class GwDimensioningButton(GwParentMapTool):
    """ Button 39: Dimensioning """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        """ Class constructor """

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.suppres_form = None


    def open_new_dimensioning(self, feature_id):

        self.layer.featureAdded.disconnect(self.open_new_dimensioning)
        feature = tools_qt.get_feature_by_id(self.layer, feature_id)
        geom = feature.geometry()
        list_points = None
        if self.layer.geometryType() == 0:
            points = geom.asPoint()
            list_points = f'"x1":{points.x()}, "y1":{points.y()}'
        elif self.layer.geometryType() in (1, 2):
            points = geom.asPolyline()
            init_point = points[0]
            last_point = points[-1]
            list_points = f'"x1":{init_point.x()}, "y1":{init_point.y()}'
            list_points += f', "x2":{last_point.x()}, "y2":{last_point.y()}'
        else:
            self.controller.log_info(str(type("NO FEATURE TYPE DEFINED")))
        # Restore user value (Settings/Options/Digitizing/Suppress attribute from pop-up after feature creation)
        QSettings().setValue("/Qgis/digitizing/disable_enter_attribute_values_dialog", self.suppres_form)
        config = self.layer.editFormConfig()
        config.setSuppress(self.conf_supp)
        self.layer.setEditFormConfig(config)

        self.recover_previus_maptool()

        self.api_dim = GwDimensioning()
        self.api_dim.points = list_points
        self.api_dim.open_dimensioning_form(qgis_feature=feature, layer=self.layer)
        super().deactivate()

    """ QgsMapTools inherited event functions """

    def canvasMoveEvent(self, event):
        pass


    def canvasReleaseEvent(self, event):
        pass


    def keyPressEvent(self, event):

        if event.key() == Qt.Key_Escape:
            self.action.trigger()
            return


    def activate(self):
        # Check button
        self.action.setChecked(True)

        self.layer = self.controller.get_layer_by_tablename("v_edit_dimensions", show_warning=True)
        if self.layer:
            # Get user values (Settings/Options/Digitizing/Suppress attribute from pop-up after feature creation)
            # and set True
            self.suppres_form = QSettings().value("/Qgis/digitizing/disable_enter_attribute_values_dialog")
            QSettings().setValue("/Qgis/digitizing/disable_enter_attribute_values_dialog", True)
            config = self.layer.editFormConfig()
            self.conf_supp = config.suppress()
            config.setSuppress(0)
            self.layer.setEditFormConfig(config)
            
            self.iface.setActiveLayer(self.layer)
            self.controller.set_layer_visible(self.layer)
            self.layer.startEditing()

            # Implement the Add Feature button
            self.iface.actionAddFeature().trigger()

            self.snapper_manager.snap_to_arc()
            self.snapper_manager.snap_to_connec()
            self.snapper_manager.snap_to_gully()
            self.snapper_manager.snap_to_node()
            self.snapper_manager.set_snapping_mode()

            # Manage new api tool
            self.layer.featureAdded.connect(self.open_new_dimensioning)


    def deactivate(self):

        # Call parent method
        super().deactivate()
