"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.gui import QgsMapCanvas, QgsVertexMarker
from qgis.core import QgsFeatureRequest, QgsPointLocator, QgsPointXY, QgsProject, QgsSnappingConfig, QgsSnappingUtils, \
    QgsTolerance, QgsVectorLayer
from qgis.PyQt.QtCore import QPoint
from qgis.PyQt.QtGui import QColor


class SnappingConfigManager(object):

    def __init__(self, iface):
        """ Class constructor """

        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.previous_snapping = None
        self.controller = None
        self.is_valid = False

        # Snapper
        self.snapping_config = self.get_snapping_options()
        self.snapping_config.setEnabled(True)
        self.snapper = self.get_snapper()
        proj = QgsProject.instance()
        proj.writeEntry('Digitizing', 'SnappingMode', 'advanced')

        # Set default vertex marker
        color = QColor(255, 100, 255)
        self.vertex_marker = QgsVertexMarker(self.canvas)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)
        self.vertex_marker.setColor(color)
        self.vertex_marker.setIconSize(15)
        self.vertex_marker.setPenWidth(3)


    def init_snapping_config(self):
        pass


    def set_controller(self, controller):
        self.controller = controller


    def set_snapping_layers(self):
        """ Set main snapping layers """

        self.layer_arc = self.controller.get_layer_by_tablename('v_edit_arc')
        self.layer_connec = self.controller.get_layer_by_tablename('v_edit_connec')
        self.layer_gully = self.controller.get_layer_by_tablename('v_edit_gully')
        self.layer_node = self.controller.get_layer_by_tablename('v_edit_node')


    def get_snapping_options(self):
        """ Function that collects all the snapping options """

        global_snapping_config = QgsProject.instance().snappingConfig()
        return global_snapping_config


    def store_snapping_options(self):
        """ Store the project user snapping configuration """

        # Get an array containing the snapping options for all the layers
        self.previous_snapping = self.get_snapping_options()


    def enable_snapping(self, enable=False):
        """ Enable/Disable snapping of all layers """

        QgsProject.instance().blockSignals(True)

        layers = self.controller.get_layers()
        # Loop through all the layers in the project
        for layer in layers:
            if type(layer) != QgsVectorLayer:
                continue
            layer_settings = self.snapping_config.individualLayerSettings(layer)
            layer_settings.setEnabled(enable)
            self.snapping_config.setIndividualLayerSettings(layer, layer_settings)

        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snappingConfigChanged.emit(self.snapping_config)


    def set_snapping_mode(self, mode=3):
        """ Defines on which layer the snapping is performed
        :param mode: 1 = ActiveLayer, 2=AllLayers, 3=AdvancedConfiguration (int or SnappingMode)
        """

        snapping_options = self.get_snapping_options()
        if snapping_options:
            QgsProject.instance().blockSignals(True)
            snapping_options.setMode(mode)
            QgsProject.instance().setSnappingConfig(snapping_options)
            QgsProject.instance().blockSignals(False)
            QgsProject.instance().snappingConfigChanged.emit(snapping_options)


    def snap_to_arc(self):
        """ Set snapping to 'arc' """

        QgsProject.instance().blockSignals(True)
        layer_settings = self.snap_to_layer(self.layer_arc, QgsPointLocator.All, True)
        if layer_settings:
            layer_settings.setType(2)
            layer_settings.setTolerance(15)
            layer_settings.setEnabled(True)
        else:
            layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, 2, 15, 1)
        self.snapping_config.setIndividualLayerSettings(self.layer_arc, layer_settings)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snappingConfigChanged.emit(self.snapping_config)


    def snap_to_node(self):
        """ Set snapping to 'node' """

        QgsProject.instance().blockSignals(True)
        layer_settings = self.snap_to_layer(self.layer_node, QgsPointLocator.Vertex, True)
        if layer_settings:
            layer_settings.setType(1)
            layer_settings.setTolerance(15)
            layer_settings.setEnabled(True)
        else:
            layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, 1, 15, 1)
        self.snapping_config.setIndividualLayerSettings(self.layer_node, layer_settings)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snappingConfigChanged.emit(self.snapping_config)


    def snap_to_connec_gully(self):
        """ Set snapping to 'connec' and 'gully' """

        QgsProject.instance().blockSignals(True)
        layer_settings = self.snap_to_layer(self.layer_connec, QgsPointLocator.Vertex, True)
        if layer_settings:
            layer_settings.setType(1)
            layer_settings.setTolerance(15)
            layer_settings.setEnabled(True)
        else:
            layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, 1, 15, 1)
        self.snapping_config.setIndividualLayerSettings(self.layer_connec, layer_settings)

        layer_settings = self.snap_to_layer(self.layer_gully, QgsPointLocator.Vertex, True)
        if layer_settings:
            layer_settings.setType(1)
            layer_settings.setTolerance(15)
            layer_settings.setEnabled(True)
        else:
            layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, 1, 15, 1)

        self.snapping_config.setIndividualLayerSettings(self.layer_gully, layer_settings)

        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snappingConfigChanged.emit(self.snapping_config)


    def snap_to_layer(self, layer, point_locator=QgsPointLocator.All, set_settings=False):
        """ Set snapping to @layer """

        if layer is None:
            return

        QgsSnappingUtils.LayerConfig(layer, point_locator, 15, QgsTolerance.Pixels)
        if set_settings:
            layer_settings = self.snapping_config.individualLayerSettings(layer)
            layer_settings.setEnabled(True)
            self.snapping_config.setIndividualLayerSettings(layer, layer_settings)
            return layer_settings


    def apply_snapping_options(self, snappings_options):
        """ Function that applies selected snapping configuration """

        QgsProject.instance().blockSignals(True)
        if snappings_options:
            QgsProject.instance().setSnappingConfig(snappings_options)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snappingConfigChanged.emit(self.snapping_config)


    def recover_snapping_options(self):
        """ Function to restore the previous snapping configuration """

        self.apply_snapping_options(self.previous_snapping)


    def get_snapper(self):
        """ Return snapper """

        snapper = QgsMapCanvas.snappingUtils(self.canvas)
        return snapper


    def snap_to_current_layer(self, event_point, vertex_marker=None):

        self.is_valid = False
        if event_point is None:
            return None, None

        result = self.snapper.snapToCurrentLayer(event_point, QgsPointLocator.All)
        if vertex_marker:
            if result.isValid():
                # Get the point and add marker on it
                point = QgsPointXY(result.point())
                vertex_marker.setCenter(point)
                vertex_marker.show()

        self.is_valid = result.isValid()
        return result


    def snap_to_background_layers(self, event_point, vertex_marker=None):

        self.is_valid = False
        if event_point is None:
            return None, None

        result = self.snapper.snapToMap(event_point)
        if vertex_marker:
            if result.isValid():
                # Get the point and add marker on it
                point = QgsPointXY(result.point())
                vertex_marker.setCenter(point)
                vertex_marker.show()

        self.is_valid = result.isValid()
        return result


    def add_marker(self, result, vertex_marker=None, icon_type=None):

        if not result.isValid():
            return None

        if vertex_marker is None:
            vertex_marker = self.vertex_marker

        point = result.point()
        if icon_type:
            vertex_marker.setIconType(icon_type)
        vertex_marker.setCenter(point)
        vertex_marker.show()

        return point


    def remove_marker(self, vertex_marker=None):

        if vertex_marker is None:
            vertex_marker = self.vertex_marker

        vertex_marker.hide()


    def get_event_point(self, event=None, point=None):
        """ Get point """

        event_point = None
        x = None
        y = None
        try:
            if event:
                x = event.pos().x()
                y = event.pos().y()
            if point:
                map_point = self.canvas.getCoordinateTransform().transform(point)
                x = map_point.x()
                y = map_point.y()
            event_point = QPoint(x, y)
        except:
            pass
        finally:
            return event_point


    def get_snapped_layer(self, result):

        layer = None
        if result.isValid():
            layer = result.layer()

        return layer


    def get_snapped_point(self, result):

        point = None
        if result.isValid():
            point = QgsPointXY(result.point())

        return point


    def get_snapped_feature_id(self, result):

        feature_id = None
        if result.isValid():
            feature_id = result.featureId()

        return feature_id


    def get_snapped_feature(self, result, select_feature=False):

        if not result.isValid():
            return None

        snapped_feat = None
        try:
            layer = result.layer()
            feature_id = result.featureId()
            feature_request = QgsFeatureRequest().setFilterFid(feature_id)
            snapped_feat = next(layer.getFeatures(feature_request))
            if select_feature and snapped_feat:
                self.select_snapped_feature(result, feature_id)
        except:
            pass
        finally:
            return snapped_feat


    def select_snapped_feature(self, result, feature_id):

        if not result.isValid():
            return

        layer = result.layer()
        layer.select([feature_id])


    def result_is_valid(self):

        return self.is_valid

