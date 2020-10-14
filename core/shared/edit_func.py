"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import QSettings

from .info import GwInfo
from .element import GwElement
from .document import GwDocument
from ... import global_vars
from ...map_tools.snapping_utils_v3 import SnappingConfigManager


class GwEdit:

    def __init__(self):
        """ Class to control toolbar 'edit' """

        self.controller = global_vars.controller
        self.iface = global_vars.iface
        self.plugin_dir = global_vars.plugin_dir
        self.settings = global_vars.settings

        self.manage_document = GwDocument()
        self.manage_element = GwElement()
        self.suppres_form = None

        # Snapper
        self.snapper_manager = SnappingConfigManager(self.iface)
        self.snapper_manager.set_controller(self.controller)
        self.snapper = self.snapper_manager.get_snapper()
        self.snapper_manager.set_snapping_layers()


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
        # self.info_layer must be global because apparently the disconnect signal is not disconnected correctly if
        # parameters are passed to it
        self.info_layer = self.controller.get_layer_by_tablename(feature_cat.parent_layer)
        if self.info_layer:
            self.suppres_form = QSettings().value("/Qgis/digitizing/disable_enter_attribute_values_dialog")
            QSettings().setValue("/Qgis/digitizing/disable_enter_attribute_values_dialog", True)
            config = self.info_layer.editFormConfig()
            self.conf_supp = config.suppress()
            config.setSuppress(0)
            self.info_layer.setEditFormConfig(config)
            self.iface.setActiveLayer(self.info_layer)
            self.info_layer.startEditing()
            self.iface.actionAddFeature().trigger()
            self.info_layer.featureAdded.connect(self.open_new_feature)
        else:
            message = "Layer not found"
            self.controller.show_warning(message, parameter=feature_cat.parent_layer)


    def action_is_checked(self):
        """ Recover snapping options when action add feature is un-checked """
        if not self.iface.actionAddFeature().isChecked():
            self.snapper_manager.recover_snapping_options()


    def open_new_feature(self, feature_id):
        """
        :param feature_id: Parameter sent by the featureAdded method itself
        :return:
        """
        self.info_layer.featureAdded.disconnect(self.open_new_feature)
        feature = self.get_feature_by_id(self.info_layer, feature_id)
        geom = feature.geometry()
        list_points = None
        if self.info_layer.geometryType() == 0:
            points = geom.asPoint()
            list_points = f'"x1":{points.x()}, "y1":{points.y()}'
        elif self.info_layer.geometryType() in (1, 2):
            points = geom.asPolyline()
            init_point = points[0]
            last_point = points[-1]
            list_points = f'"x1":{init_point.x()}, "y1":{init_point.y()}'
            list_points += f', "x2":{last_point.x()}, "y2":{last_point.y()}'
        else:
            self.controller.log_info(str(type("NO FEATURE TYPE DEFINED")))

        self.controller.init_docker()

        self.api_cf = GwInfo('data')
        result, dialog = self.api_cf.get_feature_insert(point=list_points, feature_cat=self.feature_cat,
                                                        new_feature_id=feature_id, layer_new_feature=self.info_layer,
                                                        tab_type='data', new_feature=feature)

        # Restore user value (Settings/Options/Digitizing/Suppress attribute from pop-up after feature creation)
        QSettings().setValue("/Qgis/digitizing/disable_enter_attribute_values_dialog", self.suppres_form)
        config = self.info_layer.editFormConfig()
        config.setSuppress(self.conf_supp)
        self.info_layer.setEditFormConfig(config)
        if not result:
            self.info_layer.deleteFeature(feature.id())
            self.iface.actionRollbackEdits().trigger()


    def get_feature_by_id(self, layer, id_):

        features = layer.getFeatures()
        for feature in features:
            if feature.id() == id_:
                return feature
        return False

