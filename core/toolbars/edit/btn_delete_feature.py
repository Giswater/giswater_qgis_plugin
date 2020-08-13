from ..parent_action import GwParentAction

from ...actions.edit.feature_delete import GwFeatureDelete

class GwDeleteFeatureButton(GwParentAction):
	def __init__(self, icon_path, text, toolbar, action_group):
		super().__init__(icon_path, text, toolbar, action_group)
		
		self.delete_feature = GwFeatureDelete()
	
	
	def clicked_event(self):
		self.delete_feature.manage_delete_feature()