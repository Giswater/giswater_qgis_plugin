from ..parent_action import GwParentAction

from ...actions.epa.element import GwElement

class GwEditElementButton(GwParentAction):
	def __init__(self, icon_path, text, toolbar, action_group):
		super().__init__(icon_path, text, toolbar, action_group)
		
		self.element = GwElement()
	
	
	def clicked_event(self):
		self.element.edit_element()