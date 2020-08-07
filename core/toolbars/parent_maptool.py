from qgis.PyQt.QtWidgets import QAction
from qgis.PyQt.QtGui import QCursor, QColor, QIcon, QPixmap
from qgis.gui import QgsMapTool, QgsVertexMarker, QgsRubberBand
from qgis.core import QgsWkbTypes
from qgis.PyQt.QtCore import Qt

import os

from ...map_tools.snapping_utils_v3 import SnappingConfigManager

class GwParentMapTool(QgsMapTool):
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		
		self.iface = iface
		self.settings = settings
		self.controller = controller
		self.plugin_dir = plugin_dir
		
		self.show_help = bool(int(self.settings.value('status/show_help', 1)))
		self.layer_arc = None
		self.layer_connec = None
		self.layer_gully = None
		self.layer_node = None
		self.snapper_manager = SnappingConfigManager(self.iface)
		self.snapper_manager.controller = controller
		
		self.canvas = iface.mapCanvas()
		super().__init__(self.canvas)
		
		
		icon = None
		if os.path.exists(icon_path):
			icon = QIcon(icon_path)
		
		self.action = None
		if icon is None:
			self.action = QAction(text, action_group)
		else:
			self.action = QAction(icon, text, action_group)
			
		self.action.setObjectName(text)
		self.action.setCheckable(True)
		self.action.triggered.connect(self.clicked_event)
		
		# Change map tool cursor
		self.cursor = QCursor()
		self.cursor.setShape(Qt.CrossCursor)
		
		# Get default cursor
		self.std_cursor = self.parent().cursor()
		
		# Set default vertex marker
		color = QColor(255, 100, 255)
		self.vertex_marker = QgsVertexMarker(self.canvas)
		self.vertex_marker.setIconType(QgsVertexMarker.ICON_CIRCLE)
		self.vertex_marker.setColor(color)
		self.vertex_marker.setIconSize(15)
		self.vertex_marker.setPenWidth(3)
		
		# Set default rubber band
		color_selection = QColor(254, 178, 76, 63)
		self.rubber_band = QgsRubberBand(self.canvas, 2)
		self.rubber_band.setColor(color)
		self.rubber_band.setFillColor(color_selection)
		self.rubber_band.setWidth(1)
		self.reset()
		
		self.force_active_layer = True
		
		toolbar.addAction(self.action)
		self.setAction(self.action)
	
	
	def clicked_event(self):
		self.controller.check_actions(False)
		self.controller.prev_maptool = self.iface.mapCanvas().mapTool()
		if not (self == self.iface.mapCanvas().mapTool()):
			self.iface.mapCanvas().setMapTool(self)
		else:
			self.iface.mapCanvas().unsetMapTool(self)
			
	
	def deactivate(self):
	
		# Uncheck button
		self.action.setChecked(False)
		
		# Restore previous snapping
		self.snapper_manager.recover_snapping_options()
		
		# Enable snapping
		self.snapper_manager.enable_snapping(True)
		
		# Recover cursor
		self.canvas.setCursor(self.std_cursor)
		
		# Remove highlight
		self.vertex_marker.hide()
	
	
	def canvasMoveEvent(self, event):
	
		# Make sure active layer is always 'v_edit_node'
		cur_layer = self.iface.activeLayer()
		if cur_layer != self.layer_node and self.force_active_layer:
			self.iface.setActiveLayer(self.layer_node)
		
		# Hide highlight and get coordinates
		self.vertex_marker.hide()
		event_point = self.snapper_manager.get_event_point(event)
		
		# Snapping
		result = self.snapper_manager.snap_to_current_layer(event_point)
		if self.snapper_manager.result_is_valid():
			self.snapper_manager.add_marker(result, self.vertex_marker)
	
	
	def recover_previus_maptool(self):
		if self.controller.prev_maptool:
			self.iface.mapCanvas().setMapTool(self.controller.prev_maptool)
			self.controller.prev_maptool = None
	
	
	def remove_vertex(self):
		""" Remove vertex_marker from canvas"""
		vertex_items = [i for i in self.iface.mapCanvas().scene().items() if issubclass(type(i), QgsVertexMarker)]
		
		for ver in vertex_items:
			if ver in self.iface.mapCanvas().scene().items():
				if self.vertex_marker == ver:
					self.iface.mapCanvas().scene().removeItem(ver)
	
	
	def set_action_pan(self):
		""" Set action 'Pan' """
		try:
			self.iface.actionPan().trigger()
		except Exception:
			pass
	
	
	def reset_rubber_band(self, geom_type="polygon"):
		
		try:
			if geom_type == "polygon":
				geom_type = QgsWkbTypes.PolygonGeometry
			elif geom_type == "line":
				geom_type = QgsWkbTypes.LineString
			self.rubber_band.reset(geom_type)
		except:
			pass
	
	
	def reset(self):
	
		self.reset_rubber_band()
		self.snapped_feat = None
	
	
	def cancel_map_tool(self):
		""" Executed if user press right button or escape key """
		
		# Reset rubber band
		self.reset()
		
		# Deactivate map tool
		self.deactivate()
		self.set_action_pan()
	
	
	def remove_markers(self):
		""" Remove previous markers """
		
		vertex_items = [i for i in list(self.canvas.scene().items()) if issubclass(type(i), QgsVertexMarker)]
		for ver in vertex_items:
			if ver in list(self.canvas.scene().items()):
				self.canvas.scene().removeItem(ver)
	
	
	def refresh_map_canvas(self):
		""" Refresh all layers present in map canvas """
		
		self.canvas.refreshAllLayers()
		for layer_refresh in self.canvas.layers():
			layer_refresh.triggerRepaint()
	
