from ..parent_action import GwParentAction

from ...actions.om.om_func import GwOm


class GwDateSelectorButton(GwParentAction):
	
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		super().__init__(icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir)
		
		self.om = GwOm()
	
	def clicked_event(self):
		self.om.selector_date()
