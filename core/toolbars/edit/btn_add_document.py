from ..parent_action import GwParentAction

from ...actions.edit.document import GwDocument

class GwAddDocumentButton(GwParentAction):
	def __init__(self, icon_path, text, toolbar, action_group):
		super().__init__(icon_path, text, toolbar, action_group)
		
		self.document = GwDocument()
	
	
	def clicked_event(self):
		self.document.manage_document()