from ..parent_action import GwParentAction

from ...actions.om.mincut import GwMincut

class GwMincutManagerButton(GwParentAction):
	
	def __init__(self, icon_path, text, toolbar, action_group):
		super().__init__(icon_path, text, toolbar, action_group)
		
		self.mincut = GwMincut()
	
	
	def clicked_event(self):
		self.mincut.mg_mincut_management()