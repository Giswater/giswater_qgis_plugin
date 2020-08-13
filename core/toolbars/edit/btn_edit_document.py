from ..parent_action import GwParentAction

from ...actions.edit.document import GwDocument

class GwEditDocumentButton(GwParentAction):
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		super().__init__(icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir)
		
		self.document = GwDocument(self.iface, self.settings, self.controller, self.plugin_dir)
	
	
	def clicked_event(self):
		self.document.edit_document()