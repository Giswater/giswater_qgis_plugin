from ..parent_action import GwParentAction

from ...actions.plan.plan_func import GwPlan

class GwPsectorManagerButton(GwParentAction):
	
	def __init__(self, icon_path, text, toolbar, action_group):
		super().__init__(icon_path, text, toolbar, action_group)
		
		self.plan = GwPlan()
	
	
	def clicked_event(self):
		self.plan.master_psector_mangement()
		