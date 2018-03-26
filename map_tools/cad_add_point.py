# -*- coding: utf-8 -*-
from PyQt4.QtCore import QPoint, Qt
from PyQt4.QtGui import QDoubleValidator
from qgis.core import QgsMapLayerRegistry, QgsFeatureRequest, QgsVectorLayer, QgsFeature, QgsGeometry, QgsPoint
from qgis.core import QgsProject, QgsSingleSymbolRendererV2, QgsMarkerSymbolV2, QgsMapToPixel

from qgis.gui import QgsVertexMarker
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
        self.virtual_layer_point = None
        self.point_1 = None
        self.point_2 = None
        self.snap_to_selected_layer = False

    def init_create_point_form(self, point_1=None, point_2=None):

        # Create the dialog and signals
        self.dlg_create_point = Cad_add_point()
        utils_giswater.setDialog(self.dlg_create_point)
        self.load_settings(self.dlg_create_point)
        virtual_layer_name = "point"
        sql = ("SELECT value FROM " + self.controller.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'virtual_layer_point'")
        row = self.controller.get_row(sql)
        if row:
            virtual_layer_name = row[0]
        if self.exist_virtual_layer(virtual_layer_name):
            self.get_coords(virtual_layer_name, point_1, point_2)
        else:
            self.create_virtual_layer(virtual_layer_name)
            message = "Virtual layer not found. It's gonna be created"
            self.controller.show_info(message)
            self.iface.setActiveLayer(self.vdefault_layer)
            self.get_coords(virtual_layer_name, point_1, point_2)


    def exist_virtual_layer(self, virtual_layer_name):
        layers = self.iface.mapCanvas().layers()
        for layer in layers:
            if layer.name() == virtual_layer_name:
                return True
        return False


    def get_coords(self, virtual_layer_name,  point_1, point_2):
        validator = QDoubleValidator(-99999.99, 99999.999, 3)
        validator.setNotation(QDoubleValidator().StandardNotation)
        self.dlg_create_point.dist_x.setValidator(validator)
        validator = QDoubleValidator(-99999.99, 99999.999, 3)
        validator.setNotation(QDoubleValidator().StandardNotation)
        self.dlg_create_point.dist_y.setValidator(validator)
        #self.dlg_create_point.rb_left.setChecked(True)
        self.dlg_create_point.btn_accept.pressed.connect(partial(self.get_values, point_1, point_2))
        self.dlg_create_point.btn_cancel.pressed.connect(self.cancel)
        self.dlg_create_point.dist_x.setFocus()

        self.active_layer = self.iface.mapCanvas().currentLayer()
        self.virtual_layer_point = self.controller.get_layer_by_layername(virtual_layer_name, True)

        # Open dialog
        self.open_dialog(self.dlg_create_point, maximize_button=False)


    def get_values(self, point_1, point_2):
        self.dist_x = self.dlg_create_point.dist_x.text()
        self.dist_y = self.dlg_create_point.dist_y.text()

        if self.virtual_layer_point:
            self.virtual_layer_point.startEditing()
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
                   "('" + str(point_1) + "', '" + str(point_2) + "', " + utils_giswater.getWidgetText(self.dlg_create_point.dist_x) + ", "
                   + str(utils_giswater.getWidgetText(self.dlg_create_point.dist_y)) + ", "+str(self.direction)+" )")
            row = self.controller.get_row(sql)
            if not row:
                return
            point = row[0]
            feature = QgsFeature()
            feature.setGeometry(QgsGeometry.fromPoint(QgsPoint(float(point[0]), float(point[1]))))
            provider = self.virtual_layer_point.dataProvider()
            self.virtual_layer_point.startEditing()
            provider.addFeatures([feature])
            self.virtual_layer_point.commitChanges()
        else:
            self.iface.actionPan().trigger()
            self.cancel_point = False
            return

    def create_virtual_layer(self, virtual_layer_name):

        sql = ("SELECT value FROM " + self.controller.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'virtual_layer_point'")
        row = self.controller.get_row(sql)
        if not row:
            sql = ("INSERT INTO " + self.schema_name + ".config_param_user (parameter, value, cur_user) "
                   " VALUES ('virtual_layer_point', '" + virtual_layer_name + "', current_user)")
            self.controller.execute_sql(sql)
        uri = "Point?crs=epsg:" + str(self.srid)
        virtual_layer = QgsVectorLayer(uri, virtual_layer_name, "memory")
        props = {'color': 'red', 'color_border': 'red', 'size': '1.5'}
        s = QgsMarkerSymbolV2.createSimple(props)
        virtual_layer.setRendererV2(QgsSingleSymbolRendererV2(s))
        virtual_layer.updateExtents()
        QgsProject.instance().setSnapSettingsForLayer(virtual_layer.id(), True, 0, 1, 15, False)
        QgsMapLayerRegistry.instance().addMapLayer(virtual_layer)
        self.iface.mapCanvas().refresh()

    def cancel(self):

        self.close_dialog(self.dlg_create_point)
        self.iface.setActiveLayer(self.current_layer)
        if self.virtual_layer_point:
            if self.virtual_layer_point.isEditable():
                self.virtual_layer_point.commitChanges()
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
            (retval, result) = self.snapper.snapToCurrentLayer(event_point, 2)  # @UnusedVariable
        else:
            (retval, result) = self.snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

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

        if self.virtual_layer_point:
            self.virtual_layer_point.commitChanges()


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


        # Set snapping
        self.snapper_manager.snap_to_layer(self.vdefault_layer)


    def deactivate(self):
        self.point_1 = None
        self.point_2 = None
        # Call parent method
        ParentMapTool.deactivate(self)
        self.iface.setActiveLayer(self.current_layer)
