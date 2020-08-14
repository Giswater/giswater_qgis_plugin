from ..parent_action import GwParentAction

from ...actions.om.visit_manager import GwVisitManager


class GwManageVisitButton(GwParentAction):
	
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		super().__init__(icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir)
		
		self.visit_manager = GwVisitManager()
	
	def clicked_event(self):
		self.visit_manager.edit_visit()
