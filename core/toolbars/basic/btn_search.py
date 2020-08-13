from ..parent_action import GwParentAction
from ...actions.basic.search import GwSearch

class GwSearchButton(GwParentAction):
	
	def __init__(self, icon_path, text, toolbar, action_group):
		super().__init__(icon_path, text, toolbar, action_group)
		
		self.api_search = GwSearch()
	
	
	def clicked_event(self):
		self.api_search.api_search()