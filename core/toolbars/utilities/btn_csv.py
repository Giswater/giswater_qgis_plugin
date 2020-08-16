from ..parent_action import GwParentAction

from ...actions.utilities.utilities_func import GwUtilities

class GwCSVButton(GwParentAction):
	def __init__(self, icon_path, text, toolbar, action_group):
		super().__init__(icon_path, text, toolbar, action_group)
		
		self.utils = GwUtilities()
	
	
	def clicked_event(self):
		self.utils.utils_import_csv()
