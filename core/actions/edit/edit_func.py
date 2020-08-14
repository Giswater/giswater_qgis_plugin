"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import QSettings

from ..basic.info import GwInfo
from ..epa.element import GwElement
from ..edit.document import GwDocument
from ..epa.feature_end import GwFeatureEnd
from ..edit.feature_delete import GwFeatureDelete

from .... import global_vars
from ....actions import parent_vars

class GwEdit:
	
	def __init__(self):
		""" Class to control toolbar 'edit' """
		
		self.controller = global_vars.controller
		self.iface = global_vars.iface
		self.plugin_dir = global_vars.plugin_dir
		self.settings = global_vars.settings
		
		self.manage_document = GwDocument()
		self.manage_element = GwElement()
		self.manage_workcat_end = GwFeatureEnd()
		self.delete_feature = GwFeatureDelete()
		self.suppres_form = None
	
	
	def edit_add_feature(self, feature_cat):
		""" Button 01, 02: Add 'node' or 'arc' """
		
		self.feature_cat = feature_cat
		parent_vars.layer = self.controller.get_layer_by_tablename(feature_cat.parent_layer)
		if parent_vars.layer:
			self.suppres_form = QSettings().value("/Qgis/digitizing/disable_enter_attribute_values_dialog")
			QSettings().setValue("/Qgis/digitizing/disable_enter_attribute_values_dialog", True)
			config = parent_vars.layer.editFormConfig()
			self.conf_supp = config.suppress()
			config.setSuppress(0)
			parent_vars.layer.setEditFormConfig(config)
			self.iface.setActiveLayer(parent_vars.layer)
			parent_vars.layer.startEditing()
			self.iface.actionAddFeature().trigger()
			parent_vars.layer.featureAdded.connect(self.open_new_feature)
		else:
			message = "Layer not found"
			self.controller.show_warning(message, parameter=feature_cat.parent_layer)
	
	
	def open_new_feature(self, feature_id):
		
		parent_vars.layer.featureAdded.disconnect(self.open_new_feature)
		feature = self.get_feature_by_id(parent_vars.layer, feature_id)
		
		geom = feature.geometry()
		list_points = None
		if parent_vars.layer.geometryType() == 0:
			points = geom.asPoint()
			list_points = f'"x1":{points.x()}, "y1":{points.y()}'
		elif parent_vars.layer.geometryType() in (1, 2):
			points = geom.asPolyline()
			init_point = points[0]
			last_point = points[-1]
			list_points = f'"x1":{init_point.x()}, "y1":{init_point.y()}'
			list_points += f', "x2":{last_point.x()}, "y2":{last_point.y()}'
		else:
			self.controller.log_info(str(type("NO FEATURE TYPE DEFINED")))
		
		self.controller.init_docker()
		
		self.api_cf = GwInfo('data')
		result, dialog = self.api_cf.open_form(point=list_points, feature_cat=self.feature_cat,
											   new_feature_id=feature_id, layer_new_feature=parent_vars.layer,
											   tab_type='data', new_feature=feature)
		
		# Restore user value (Settings/Options/Digitizing/Suppress attribute from pop-up after feature creation)
		QSettings().setValue("/Qgis/digitizing/disable_enter_attribute_values_dialog", self.suppres_form)
		config = parent_vars.layer.editFormConfig()
		config.setSuppress(self.conf_supp)
		parent_vars.layer.setEditFormConfig(config)
		if not result:
			parent_vars.layer.deleteFeature(feature.id())
			self.iface.actionRollbackEdits().trigger()
	
	
	def get_feature_by_id(self, layer, id_):
		
		features = layer.getFeatures()
		for feature in features:
			if feature.id() == id_:
				return feature
		return False
	