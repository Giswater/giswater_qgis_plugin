"""
/***************************************************************************
        begin                : 2016-08-16
        copyright            : (C) 2016 by BGEO SL
        email                : vicente.medina@gits.ws
        git sha              : $Format:%H$
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
"""
from builtins import object

# -*- coding: utf-8 -*-
from qgis.gui import QgsMapCanvas, QgsVertexMarker
from qgis.core import QgsProject, QgsSnappingUtils, QgsPointLocator, QgsTolerance, QgsPointXY, QgsFeatureRequest
from qgis.PyQt.QtCore import QPoint
from qgis.PyQt.QtGui import QColor


class SnappingConfigManager(object):

    def __init__(self, iface):
        """ Class constructor """

        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.layer_arc = None
        self.layer_connec = None
        self.layer_node = None
        self.previous_snapping = None
        self.controller = None
        self.is_valid = False

        # Snapper
        try:
            self.snapper = self.get_snapper()
            proj = QgsProject.instance()
            proj.writeEntry('Digitizing', 'SnappingMode', 'advanced')
        except:
            pass
        finally:
            # Set default vertex marker
            color = QColor(255, 100, 255)
            self.vertex_marker = QgsVertexMarker(self.canvas)
            self.vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)
            self.vertex_marker.setColor(color)
            self.vertex_marker.setIconSize(15)
            self.vertex_marker.setPenWidth(3)


    def set_layers(self, layer_arc_man, layer_connec_man, layer_node_man, layer_gully_man=None):

        self.layer_arc_man = layer_arc_man
        self.layer_connec_man = layer_connec_man
        self.layer_node_man = layer_node_man
        self.layer_gully_man = layer_gully_man


    def get_snapping_options(self):
        """ Function that collects all the snapping options and put it in an array """

        global_snapping_config = QgsProject.instance().snappingConfig()
        return global_snapping_config


    def store_snapping_options(self):
        """ Store the project user snapping configuration """

        # Get an array containing the snapping options for all the layers
        self.previous_snapping = self.get_snapping_options()


    def clear_snapping(self):
        """ Removing snap """

        QgsProject.instance().blockSignals(True)
        layers = self.controller.get_layers()
        # Loop through all the layers in the project
        for layer in layers:
            QgsSnappingUtils.LayerConfig(layer, QgsPointLocator.All, 15, QgsTolerance.Pixels)

        QgsProject.instance().blockSignals(False)
        snapping_config = self.get_snapping_options()
        QgsProject.instance().snappingConfigChanged.emit(snapping_config)


    def snap_to_node(self):
        """ Set snapping to 'node' """

        QgsProject.instance().blockSignals(True)
        for layer in self.layer_node_man:
            QgsSnappingUtils.LayerConfig(layer, QgsPointLocator.Edge, 15, QgsTolerance.Pixels)

        QgsProject.instance().blockSignals(False)
        snapping_config = self.get_snapping_options()
        QgsProject.instance().snappingConfigChangedemit(snapping_config)


    def snap_to_connec_gully(self):
        """ Set snapping to 'connec' and 'gully' """

        QgsProject.instance().blockSignals(True)
        for layer in self.layer_connec_man:
            QgsSnappingUtils.LayerConfig(layer, QgsPointLocator.Edge, 15, QgsTolerance.Pixels)
        if self.layer_gully_man:
            for layer in self.layer_gully_man:
                QgsSnappingUtils.LayerConfig(layer, QgsPointLocator.Edge, 15, QgsTolerance.Pixels)

        QgsProject.instance().blockSignals(False)
        snapping_config = self.get_snapping_options()
        QgsProject.instance().snappingConfigChanged.emit(snapping_config)


    def snap_to_layer(self, layer):
        """ Set snapping to @layer """

        if layer is None:
            return
        QgsSnappingUtils.LayerConfig(layer, QgsPointLocator.All, 15, QgsTolerance.Pixels)


    def apply_snapping_options(self, snappings_options):
        """ Function that restores the previous snapping """

        QgsProject.instance().blockSignals(True)

        if snappings_options:
            QgsProject.instance().setSnappingConfig(snappings_options)

        QgsProject.instance().blockSignals(False)


    def recover_snapping_options(self):
        """ Function to restore user configuration """

        self.apply_snapping_options(self.previous_snapping)


    def check_node_group(self, snapped_layer):
        """ Check if snapped layer is in the node group """

        if snapped_layer in self.layer_node_man:
            return 1


    def check_connec_group(self, snapped_layer):
        """ Check if snapped layer is in the connec group """

        if snapped_layer in self.layer_connec_man:
            return 1


    def check_gully_group(self, snapped_layer):
        """ Check if snapped layer is in the gully group """

        if self.layer_gully_man:
            if snapped_layer in self.layer_gully_man:
                return 1


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


    def get_event_point(self, event=None, point=None):
        """ Get point """

        event_point = None
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


    def select_snapped_feature(self, result, feature_id=None):

        if not result.isValid():
            return

        layer = result.layer()
        if feature_id is None:
            feature_id = result.featureId()
        layer.select([feature_id])


    def result_is_valid(self):

        return self.is_valid

