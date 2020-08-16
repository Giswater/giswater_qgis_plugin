from ..parent_action import GwParentAction

from ...actions.utilities.toolbox import GwToolBox

class GwToolBoxButton(GwParentAction):
	def __init__(self, icon_path, text, toolbar, action_group):
		super().__init__(icon_path, text, toolbar, action_group)
		
		self.toolbox = GwToolBox()
	
	
	def clicked_event(self):
		self.toolbox.open_toolbox()