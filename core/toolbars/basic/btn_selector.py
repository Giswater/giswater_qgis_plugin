from ..parent_action import GwParentAction

from ...actions.basic.basic_func import GwBasic

class GwSelectorButton(GwParentAction):
	
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		super().__init__(icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir)
		
		self.basic = GwBasic()
	
	
	def clicked_event(self):
		self.basic.basic_filter_selectors()
		