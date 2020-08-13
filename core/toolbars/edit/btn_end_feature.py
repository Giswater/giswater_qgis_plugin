from ..parent_action import GwParentAction

from ...actions.epa.feature_end import GwFeatureEnd

class GwEndFeatureButton(GwParentAction):
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		super().__init__(icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir)
		
		self.feature_end = GwFeatureEnd(self.iface, self.settings, self.controller, self.plugin_dir)
	
	
	def clicked_event(self):
		self.feature_end.manage_workcat_end()