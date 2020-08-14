from ..parent_action import GwParentAction

from ...actions.plan.plan_func import GwPlan

class GwPriceManagerButton(GwParentAction):
	
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		super().__init__(icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir)
		
		self.plan = GwPlan()
	
	
	def clicked_event(self):
		self.plan.master_estimate_result_manager()
		