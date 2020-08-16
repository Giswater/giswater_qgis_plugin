from ..parent_action import GwParentAction

from ...actions.om.visit_manager import GwVisitManager

class GwAddVisitButton(GwParentAction):
	
	def __init__(self, icon_path, text, toolbar, action_group):
		super().__init__(icon_path, text, toolbar, action_group)
		
		self.visit_manager = GwVisitManager()
	
	
	def clicked_event(self):
		self.visit_manager.manage_visit(tag='add')
		