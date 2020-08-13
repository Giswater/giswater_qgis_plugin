from ..parent_action import GwParentAction
from ...actions.basic.search import GwSearch


class GwSearchButton(GwParentAction):
	
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		super().__init__(icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir)
		
		self.api_search = GwSearch(self.iface, self.settings, self.controller, self.plugin_dir)
	
	
	def clicked_event(self):
		self.api_search.api_search()