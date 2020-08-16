from ..parent_action import GwParentAction

from ...actions.utilities.config import GwConfig

class GwConfigButton(GwParentAction):
	def __init__(self, icon_path, text, toolbar, action_group):
		super().__init__(icon_path, text, toolbar, action_group)
		
		self.config = GwConfig()
	
	
	def clicked_event(self):
		self.config.api_config()
