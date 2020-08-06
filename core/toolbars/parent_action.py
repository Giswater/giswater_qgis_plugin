from qgis.PyQt.QtWidgets import QAction
from qgis.PyQt.QtGui import QIcon
import os

class GwParentAction:
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		
		self.iface = iface
		self.settings = settings
		self.controller = controller
		self.plugin_dir = plugin_dir
		
		icon = None
		if os.path.exists(icon_path):
			icon = QIcon(icon_path)
		
		self.action = None
		if icon is None:
			self.action = QAction(text, action_group)
		else:
			self.action = QAction(icon, text, action_group)
			
		self.action.setObjectName(text)
		self.action.setCheckable(False)
		self.action.triggered.connect(self.clicked_event)
		
		toolbar.addAction(self.action)
	
	
	def clicked_event(self):
		self.controller.show_message("Action has no function!!", "INFO")