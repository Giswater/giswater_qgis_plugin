from qgis.PyQt.QtWidgets import QAction, QMenu
from qgis.PyQt.QtGui import QKeySequence

from functools import partial

from ..parent_action import GwParentAction
from ...actions.edit.edit_func import GwEdit
from ...utils.pg_man import PgMan
from .... import global_vars


class GwAddLineButton(GwParentAction):
	
	def __init__(self, icon_path, text, toolbar, action_group):
		super().__init__(icon_path, text, toolbar, action_group)
		
		# First add the menu before adding it to the toolbar
		toolbar.removeAction(self.action)
		
		pg_man = PgMan(global_vars.controller)
		self.feature_cat = pg_man.manage_feature_cat()
		
		self.edit = GwEdit()
		
		# Get list of different node and arc types
		menu = QMenu()
		# List of nodes from node_type_cat_type - nodes which we are using
		list_feature_cat = self.controller.get_values_from_dictionary(self.feature_cat)
		for feature_cat in list_feature_cat:
			if feature_cat.feature_type.upper() == 'ARC':
				obj_action = QAction(str(feature_cat.id), action_group)
				obj_action.setShortcut(QKeySequence(str(feature_cat.shortcut_key)))
				try:
					obj_action.setShortcutVisibleInContextMenu(True)
				except:
					pass
				menu.addAction(obj_action)
				obj_action.triggered.connect(partial(self.edit.edit_add_feature, feature_cat))
		
		self.action.setMenu(menu)
		toolbar.addAction(self.action)
	
	
	def clicked_event(self):
		pass
	