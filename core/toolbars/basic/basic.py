from qgis.core import QgsMapToPixel
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtWidgets import QAction
from qgis.PyQt.QtGui import QCursor

from ..parent_action import GwParentAction
from ..parent_maptool import GwParentMapTool

from .search import GwSearch
from .info import GwInfo

class GwSearchButton(GwParentAction):
	
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		super().__init__(icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir)
		
	def clicked_event(self):
		api_search = GwSearch(self.iface, self.settings, self.controller, self.plugin_dir)
		api_search.api_search()
		

class GwInfoButton(GwParentMapTool):
	
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		super().__init__(icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir)
		
		self.tab_type = None
		# Used when the signal 'signal_activate' is emitted from the info, do not open another form
		self.block_signal = False
	
	
	def create_point(self, event):
	
		x = event.pos().x()
		y = event.pos().y()
		try:
			point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)
		except(TypeError, KeyError):
			self.iface.actionPan().trigger()
			return False
		
		return point
	
	
	""" QgsMapTools inherited event functions """
	
	def keyPressEvent(self, event):
		
		if event.key() == Qt.Key_Escape:
			for rb in self.rubberband_list:
				rb.reset()
			self.api_cf.resetRubberbands()
			self.action.trigger()
			return
	
	
	def canvasMoveEvent(self, event):
		pass
	
	
	def canvasReleaseEvent(self, event):
		
		for rb in self.rubberband_list:
			rb.reset()
		
		if self.block_signal:
			self.block_signal = False
			return
		
		self.controller.init_docker()
		
		if event.button() == Qt.LeftButton:
			point = self.create_point(event)
			if point is False:
				return
			self.api_cf.open_form(point, tab_type=self.tab_type)
		
		elif event.button() == Qt.RightButton:
			point = self.create_point(event)
			if point is False:
				return
			self.api_cf.hilight_feature(point, self.rubberband_list, self.tab_type)
	
	
	def reactivate_map_tool(self):
		""" Reactivate tool """
		
		self.block_signal = True
		info_action = self.iface.mainWindow().findChild(QAction, 'map_tool_api_info_data')
		info_action.trigger()
	
	
	def activate(self):
		
		# Check button
		self.action.setChecked(True)
		# Change map tool cursor
		self.cursor = QCursor()
		self.cursor.setShape(Qt.WhatsThisCursor)
		self.canvas.setCursor(self.cursor)
		self.rubberband_list = []
		# if self.index_action == '37':
		self.tab_type = 'data'
		# elif self.index_action == '199':
		# 	self.tab_type = 'inp'
		
		self.api_cf = GwInfo(self.iface, self.settings, self.controller, self.controller.plugin_dir, self.tab_type)
		
		self.api_cf.signal_activate.connect(self.reactivate_map_tool)
	
	
	def deactivate(self):
		
		for rb in self.rubberband_list:
			rb.reset()
		if hasattr(self, 'api_cf'):
			self.api_cf.resetRubberbands()
		super().deactivate()
		
	