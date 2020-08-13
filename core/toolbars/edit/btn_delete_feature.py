from ..parent_action import GwParentAction

from ...actions.edit.feature_delete import GwFeatureDelete

class GwDeleteFeatureButton(GwParentAction):
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		super().__init__(icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir)
		
		self.delete_feature = GwFeatureDelete(self.iface, self.settings, self.controller, self.plugin_dir)
	
	
	def clicked_event(self):
		self.delete_feature.manage_delete_feature()