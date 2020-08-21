"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from ..parent_action import GwParentAction

from ...actions.toc.manage_layers import GwManageLayers

class GwAddChildLayerButton(GwParentAction):
	
	def __init__(self, icon_path, text, toolbar, action_group):
		super().__init__(icon_path, text, toolbar, action_group)
		
		self.manage_layers = GwManageLayers()
		self.manage_layers.config_layers()
	
	
	def clicked_event(self):
		self.manage_layers.create_add_layer_menu()
		