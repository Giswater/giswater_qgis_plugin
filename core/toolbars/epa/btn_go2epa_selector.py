from ..parent_action import GwParentAction

from ...actions.epa.go2epa import GwGo2Epa

class GwGo2EpaSelectorButton(GwParentAction):
	
	def __init__(self, icon_path, text, toolbar, action_group):
		super().__init__(icon_path, text, toolbar, action_group)
		
		self.go2epa = GwGo2Epa()
	
	
	def clicked_event(self):
		self.go2epa.go2epa_result_selector()
		