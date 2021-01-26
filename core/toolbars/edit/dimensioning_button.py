"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import QSettings, Qt

from ..maptool_button import GwMaptoolButton
from ...shared.dimensioning import GwDimensioning
from ....lib import tools_qt, tools_log, tools_qgis


class GwDimensioningButton(GwMaptoolButton):
    """ Button 39: Dimensioning """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.suppres_form = None


    def open_new_dimensioning(self, feature_id):

        self.layer.featureAdded.disconnect(self.open_new_dimensioning)
        feature = tools_qt.get_feature_by_id(self.layer, feature_id)
        list_points = tools_qgis.get_points_from_geometry(self.layer, feature)

        # Restore user value (Settings/Options/Digitizing/Suppress attribute from pop-up after feature creation)
        QSettings().setValue("/Qgis/digitizing/disable_enter_attribute_values_dialog", self.suppres_form)
        config = self.layer.editFormConfig()
        config.setSuppress(self.conf_supp)
        self.layer.setEditFormConfig(config)

        self.recover_previus_maptool()

        self.dimensioning = GwDimensioning()
        self.dimensioning.points = list_points
        self.dimensioning.open_dimensioning_form(qgis_feature=feature, layer=self.layer)
        super().deactivate()


    # region QgsMapTools inherited
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

        self.layer = tools_qgis.get_layer_by_tablename("v_edit_dimensions", show_warning_=True)
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
            tools_qgis.set_layer_visible(self.layer)
            self.layer.startEditing()

            # Implement the Add Feature button
            self.iface.actionAddFeature().trigger()

            self.snapper_manager.config_snap_to_arc()
            self.snapper_manager.config_snap_to_connec()
            self.snapper_manager.config_snap_to_gully()
            self.snapper_manager.config_snap_to_node()
            self.snapper_manager.set_snap_mode()

            # Manage new tool
            self.layer.featureAdded.connect(self.open_new_dimensioning)


    def deactivate(self):

        # Call parent method
        super().deactivate()

    # endregion
