"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import QSettings

from .api_cf import ApiCF
from .manage_element import ManageElement
from .manage_document import ManageDocument
from .manage_workcat_end import ManageWorkcatEnd
from .delete_feature import DeleteFeature
from .parent import ParentAction
from ..map_tools.snapping_utils_v3 import SnappingConfigManager

class Edit(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'edit' """

        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.manage_document = ManageDocument(iface, settings, controller, plugin_dir)
        self.manage_element = ManageElement(iface, settings, controller, plugin_dir)
        self.manage_workcat_end = ManageWorkcatEnd(iface, settings, controller, plugin_dir)
        self.delete_feature = DeleteFeature(iface, settings, controller, plugin_dir)
        self.suppres_form = None

        # Snapper
        self.snapper_manager = SnappingConfigManager(self.iface)
        self.snapper_manager.set_controller(self.controller)
        self.snapper = self.snapper_manager.get_snapper()
        self.snapper_manager.set_snapping_layers()


    def set_project_type(self, project_type):
        self.project_type = project_type


    def edit_add_feature(self, feature_cat):
        """ Button 01, 02: Add 'node' or 'arc' """

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Set snapping to 'node', 'connec' and 'gully'
        self.snapper_manager.snap_to_arc()
        self.snapper_manager.snap_to_node()
        self.snapper_manager.snap_to_connec_gully()
        self.snapper_manager.set_snapping_mode()
        self.iface.actionAddFeature().toggled.connect(self.action_is_checked)

        self.feature_cat = feature_cat
        self.layer = self.controller.get_layer_by_tablename(feature_cat.parent_layer)
        if self.layer:
            self.suppres_form = QSettings().value("/Qgis/digitizing/disable_enter_attribute_values_dialog")
            QSettings().setValue("/Qgis/digitizing/disable_enter_attribute_values_dialog", True)
            config = self.layer.editFormConfig()
            self.conf_supp = config.suppress()
            config.setSuppress(0)
            self.layer.setEditFormConfig(config)
            self.iface.setActiveLayer(self.layer)
            self.layer.startEditing()
            self.iface.actionAddFeature().trigger()
            self.layer.featureAdded.connect(self.open_new_feature)

        else:
            message = "Layer not found"
            self.controller.show_warning(message, parameter=feature_cat.parent_layer)

    def action_is_checked(self):
        """ Recover snapping options when action add feature is un-checked """
        if not self.iface.actionAddFeature().isChecked():
            self.snapper_manager.recover_snapping_options()


    def open_new_feature(self, feature_id):
        self.layer.featureAdded.disconnect(self.open_new_feature)
        feature = self.get_feature_by_id(self.layer, feature_id)

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

        self.controller.init_docker()

        self.api_cf = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir, 'data')
        result, dialog = self.api_cf.open_form(point=list_points, feature_cat=self.feature_cat,
                                               new_feature_id=feature_id, layer_new_feature=self.layer,
                                               tab_type='data', new_feature=feature)

        # Restore user value (Settings/Options/Digitizing/Suppress attribute from pop-up after feature creation)
        QSettings().setValue("/Qgis/digitizing/disable_enter_attribute_values_dialog", self.suppres_form)
        config = self.layer.editFormConfig()
        config.setSuppress(self.conf_supp)
        self.layer.setEditFormConfig(config)
        if not result:
            self.layer.deleteFeature(feature.id())
            self.iface.actionRollbackEdits().trigger()


    def get_feature_by_id(self, layer, id_):

        features = layer.getFeatures()
        for feature in features:
            if feature.id() == id_:
                return feature
        return False


    def edit_add_element(self):
        """ Button 33: Add element """
        self.manage_element.manage_element()


    def edit_add_file(self):
        """ Button 34: Add document """
        self.manage_document.manage_document()


    def edit_document(self):
        """ Button 66: Edit document """
        self.manage_document.edit_document()


    def edit_element(self):
        """ Button 67: Edit element """
        self.manage_element.edit_element()


    def edit_end_feature(self):
        """ Button 68: Edit end feature """
        self.manage_workcat_end.manage_workcat_end()


    def del_feature(self):
        """" Button 69: Delete Feature """
        self.delete_feature.manage_delete_feature()

