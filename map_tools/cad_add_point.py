# -*- coding: utf-8 -*-
from qgis.core import QgsMapLayerRegistry, QgsFeatureRequest, QgsVectorLayer, QgsFeature, QgsGeometry, QgsPoint
from qgis.core import QgsProject, QgsSingleSymbolRendererV2, QgsMarkerSymbolV2, QgsMapToPixel
from qgis.gui import QgsVertexMarker
from PyQt4.QtCore import QPoint, Qt
from PyQt4.QtGui import QDoubleValidator

import utils_giswater
from map_tools.parent import ParentMapTool
from ui_manager import Cad_add_point
from functools import partial


class CadAddPoint(ParentMapTool):
    """ Button 72: Add point """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        # Call ParentMapTool constructor
        super(CadAddPoint, self).__init__(iface, settings, action, index_action)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)
        self.cancel_point = False
        self.layer_points = None
        self.point_1 = None
        self.point_2 = None
        self.snap_to_selected_layer = False


    def init_create_point_form(self, point_1=None, point_2=None):

        # Create the dialog and signals
        self.dlg_create_point = Cad_add_point()
        self.load_settings(self.dlg_create_point)

        validator = QDoubleValidator(-99999.99, 99999.999, 3)
        validator.setNotation(QDoubleValidator().StandardNotation)
        self.dlg_create_point.dist_x.setValidator(validator)
        validator = QDoubleValidator(-99999.99, 99999.999, 3)
        validator.setNotation(QDoubleValidator().StandardNotation)
        self.dlg_create_point.dist_y.setValidator(validator)
        self.dlg_create_point.dist_x.setFocus()
        self.dlg_create_point.btn_accept.clicked.connect(partial(self.get_values, point_1, point_2))
        self.dlg_create_point.btn_cancel.clicked.connect(self.cancel)
        rb_left = self.controller.plugin_settings_value(self.dlg_create_point.rb_left.objectName())
        if rb_left == 'true':
            self.dlg_create_point.rb_left.setChecked(True)
        else:
            self.dlg_create_point.rb_right.setChecked(True)

        self.open_dialog(self.dlg_create_point, maximize_button=False)


    def get_values(self, point_1, point_2):
        self.controller.plugin_settings_set_value(self.dlg_create_point.rb_left.objectName(),
                                                  self.dlg_create_point.rb_left.isChecked())
        self.dist_x = self.dlg_create_point.dist_x.text()
        if not self.dist_x:
            self.dist_x = 0
        self.dist_y = self.dlg_create_point.dist_y.text()
        if not self.dist_y:
            self.dist_y = 0
        self.delete_prev = utils_giswater.isChecked(self.dlg_create_point, self.dlg_create_point.chk_delete_prev)
        
        if self.layer_points:
            self.layer_points.startEditing()
            self.close_dialog(self.dlg_create_point)
            if self.dlg_create_point.rb_left.isChecked():
                self.direction = 1
            else:
                self.direction = 2

            sql = ("SELECT ST_GeomFromText('POINT("+str(point_1[0])+" "+ str(point_1[1])+")', "+str(self.srid)+")")
            row = self.controller.get_row(sql)
            point_1 = row[0]
            sql = ("SELECT ST_GeomFromText('POINT("+str(point_2[0])+" "+ str(point_2[1])+")', "+str(self.srid)+")")
            row = self.controller.get_row(sql)
            point_2 = row[0]

            sql = ("SELECT " + self.controller.schema_name + ".gw_fct_cad_add_relative_point"
                   "('" + str(point_1) + "', '" + str(point_2) + "', " + str(self.dist_x) + ", "
                   + str(self.dist_y) + ", "+str(self.direction)+", "+str(self.delete_prev)+" )")
            self.controller.execute_sql(sql)
            self.layer_points.commitChanges()
            self.layer_points.dataProvider().forceReload()
            self.layer_points.triggerRepaint()
            
        else:
            self.iface.actionPan().trigger()
            self.cancel_point = False
            return


    def cancel(self):
        self.controller.plugin_settings_set_value(self.dlg_create_point.rb_left.objectName(),
                                                  self.dlg_create_point.rb_left.isChecked())

        self.close_dialog(self.dlg_create_point)
        self.iface.setActiveLayer(self.current_layer)
        if self.layer_points:
            if self.layer_points.isEditable():
                self.layer_points.commitChanges()
        self.cancel_point = True
        self.cancel_map_tool()


    """ QgsMapTools inherited event functions """
    
    def keyPressEvent(self, event):

        if event.key() == Qt.Key_Escape:
            self.cancel_map_tool()
            self.iface.setActiveLayer(self.current_layer)
            return


    def canvasMoveEvent(self, event):

        # Hide highlight
        self.vertex_marker.hide()

        # Get the click
        x = event.pos().x()
        y = event.pos().y()
        try:
            event_point = QPoint(x, y)
        except(TypeError, KeyError):
            self.iface.actionPan().trigger()
            return

        # Snapping
        if self.snap_to_selected_layer:
            (retval, result) = self.snapper.snapToCurrentLayer(event_point, 2)
        else:
            (retval, result) = self.snapper.snapToBackgroundLayers(event_point)

        # That's the snapped features
        if result:
            # Get the point and add marker on it
            point = QgsPoint(result[0].snappedVertex)
            self.vertex_marker.setCenter(point)
            self.vertex_marker.show()


    def canvasReleaseEvent(self, event):

        if event.button() == Qt.LeftButton:

            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            try:
                event_point = QPoint(x, y)
            except(TypeError, KeyError):
                self.iface.actionPan().trigger()
                return

            (retval, result) = self.snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable
            # Create point with snap reference
            if result:
                point = QgsPoint(result[0].snappedVertex)
            # Create point with mouse cursor reference
            else:
                point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)
            if self.point_1 is None:
                self.point_1 = point
            else:
                self.point_2 = point

            if self.point_1 is not None and self.point_2 is not None:
                self.init_create_point_form(self.point_1, self.point_2)

        elif event.button() == Qt.RightButton:
            self.cancel_map_tool()
            self.iface.setActiveLayer(self.current_layer)

        if self.layer_points:
            self.layer_points.commitChanges()


    def activate(self):
        
        # Get SRID
        self.srid = self.controller.plugin_settings_value('srid')
        
        # Check button
        self.action().setChecked(True)

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Select an element and click it to set radius"
            self.controller.show_info(message)

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Get current layer
        self.current_layer = self.iface.activeLayer()

        self.layer_points = self.controller.get_layer_by_tablename('v_edit_cad_auxpoint', True)
        if self.layer_points is None:
            self.show_warning("Layer not found", parameter=self.layer_points)
            return
        self.iface.setActiveLayer(self.layer_points)

        # Check for default base layer
        sql = ("SELECT value FROM " + self.controller.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'cad_tools_base_layer_vdefault_1'")
        row = self.controller.get_row(sql)
        if row:
            self.snap_to_selected_layer = True
            self.vdefault_layer = self.controller.get_layer_by_layername(row[0])
            self.iface.setActiveLayer(self.vdefault_layer)
        else:
            # Get current layer
            self.vdefault_layer = self.iface.activeLayer()
        self.controller.log_info(str(self.vdefault_layer.name()))
        # Set snapping
        self.snapper_manager.snap_to_layer(self.vdefault_layer)


    def deactivate(self):
        
        self.point_1 = None
        self.point_2 = None
        
        # Call parent method
        ParentMapTool.deactivate(self)
        self.iface.setActiveLayer(self.current_layer)
        
        
