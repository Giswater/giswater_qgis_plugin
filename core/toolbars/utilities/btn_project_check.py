from ..parent_action import GwParentAction

from ...actions.utilities.utilities_func import GwUtilities

class GwProjectCheckButton(GwParentAction):
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		super().__init__(icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir)
		
		self.utils = GwUtilities()
	
	
	def clicked_event(self):
		self.utils.utils_show_check_project_result()
