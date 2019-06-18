# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    from qgis.core import QgsPoint
else:
    from qgis.core import QgsPointXY

from qgis.core import QgsMapToPixel
from qgis.gui import QgsVertexMarker
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QDoubleValidator

from functools import partial

import utils_giswater
from map_tools.parent import ParentMapTool
from ui_manager import Cad_add_point


class CadAddPoint(ParentMapTool):
    """ Button 72: Add point """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

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

        # Hide highlight and get coordinates
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(event)

        # Snapping
        if self.snap_to_selected_layer:
            result = self.snapper_manager.snap_to_current_layer(event_point)
        else:
            result = self.snapper_manager.snap_to_background_layers(event_point)

        if self.snapper_manager.result_is_valid():
            # Get the point and add marker on it
            self.snapper_manager.add_marker(result, self.vertex_marker)


    def canvasReleaseEvent(self, event):

        if event.button() == Qt.LeftButton:

            # Get coordinates
            x = event.pos().x()
            y = event.pos().y()
            event_point = self.snapper_manager.get_event_point(event)

            # TODO: Test it!
            point = None
            (retval, result) = self.snapper_manager.snap_to_background_layers(event_point)
            # Create point with snap reference
            if result:
                if Qgis.QGIS_VERSION_INT < 29900:
                    point = QgsPoint(result[0].snappedVertex)
                else:
                    point = QgsPointXY(result.point())

            # Create point with mouse cursor reference
            if point is None:
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
               " WHERE cur_user = current_user AND parameter = 'cad_tools_base_layer_vdefault'")
        row = self.controller.get_row(sql)
        if row:
            self.snap_to_selected_layer = True
            self.vdefault_layer = self.controller.get_layer_by_layername(row[0])
            self.iface.setActiveLayer(self.vdefault_layer)
        else:
            # Get current layer
            self.vdefault_layer = self.iface.activeLayer()

        # Set snapping
        #self.snapper_manager.snap_to_layer(self.vdefault_layer)


    def deactivate(self):
        
        self.point_1 = None
        self.point_2 = None
        
        # Call parent method
        ParentMapTool.deactivate(self)
        self.iface.setActiveLayer(self.current_layer)
        
