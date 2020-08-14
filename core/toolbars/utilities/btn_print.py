from ..parent_action import GwParentAction

from ...actions.om.composer_tools import GwComposerTools

class GwPrintButton(GwParentAction):
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		super().__init__(icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir)
		
		self.composer = GwComposerTools()
	
	
	def clicked_event(self):
		self.composer.composer()
