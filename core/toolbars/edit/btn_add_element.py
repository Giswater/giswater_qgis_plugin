from ..parent_action import GwParentAction

from ...actions.epa.element import GwElement

class GwAddElementButton(GwParentAction):
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		super().__init__(icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir)
		
		self.element = GwElement()
	
	
	def clicked_event(self):
		self.element.manage_element()