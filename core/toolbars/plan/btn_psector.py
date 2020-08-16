from ..parent_action import GwParentAction

from ...actions.plan.psector import GwPsector

class GwPsectorButton(GwParentAction):
	
	def __init__(self, icon_path, text, toolbar, action_group):
		super().__init__(icon_path, text, toolbar, action_group)
		
		self.psector = GwPsector()
	
	
	def clicked_event(self):
		self.psector.new_psector()
		