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
from qgis.gui import QgsMapCanvasSnapper, QgsVertexMarker
from qgis.core import QgsProject, QgsPoint
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

        snapping_layers_options = []
        layers = self.controller.get_layers()
        for layer in layers:
            options = QgsProject.instance().snapSettingsForLayer(layer.id())
            snapping_layers_options.append(
                {'layerid': layer.id(), 'enabled': options[1], 'snapType': options[2], 'unitType': options[3],
                 'tolerance': options[4], 'avoidInt': options[5]})

        return snapping_layers_options


    def store_snapping_options(self):
        """ Store the project user snapping configuration """

        # Get an array containing the snapping options for all the layers
        self.previous_snapping = self.get_snapping_options()


    def clear_snapping(self, snapping_mode=0):
        """ Removing snap """

        QgsProject.instance().blockSignals(True)
        layers = self.controller.get_layers()
        # Loop through all the layers in the project
        for layer in layers:
            QgsProject.instance().setSnapSettingsForLayer(layer.id(), False, snapping_mode, 0, 1, False)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snapSettingsChanged.emit()


    def snap_to_node(self):
        """ Set snapping to 'node' """

        QgsProject.instance().blockSignals(True)
        for layer in self.layer_node_man:
            QgsProject.instance().setSnapSettingsForLayer(layer.id(), True, 0, 2, 1.0, False)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snapSettingsChanged.emit()


    def snap_to_connec_gully(self):
        """ Set snapping to 'connec' and 'gully' """

        QgsProject.instance().blockSignals(True)
        for layer in self.layer_connec_man:
            QgsProject.instance().setSnapSettingsForLayer(layer.id(), True, 2, 2, 1.0, False)
        if self.layer_gully_man:
            for layer in self.layer_gully_man:
                QgsProject.instance().setSnapSettingsForLayer(layer.id(), True, 2, 2, 1.0, False)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snapSettingsChanged.emit()


    def snap_to_layer(self, layer):
        """ Set snapping to @layer """

        if layer is None:
            return

        QgsProject.instance().setSnapSettingsForLayer(layer.id(), True, 2, 2, 1.0, False)


    def apply_snapping_options(self, snappings_options):
        """ Function that restores the previous snapping """

        QgsProject.instance().blockSignals(True)

        if snappings_options:
            for snp_opt in snappings_options:
                QgsProject.instance().setSnapSettingsForLayer(snp_opt['layerid'], int(snp_opt['enabled']),
                                                              int(snp_opt['snapType']), int(snp_opt['unitType']),
                                                              float(snp_opt['tolerance']), int(snp_opt['avoidInt']))

        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snapSettingsChanged.emit()


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

        snapper = QgsMapCanvasSnapper(self.canvas)
        return snapper


    def snap_to_current_layer(self, event_point, vertex_marker=None):

        if event_point is None:
            return None, None

        (retval, result) = self.snapper.snapToCurrentLayer(event_point, 2)
        if vertex_marker:
            if result:
                # Get the point and add marker on it
                point = QgsPoint(result[0].snappedVertex)
                vertex_marker.setCenter(point)
                vertex_marker.show()

        return result


    def snap_to_background_layers(self, event_point, vertex_marker=None):

        if event_point is None:
            return None, None

        (retval, result) = self.snapper.snapToBackgroundLayers(event_point)
        if vertex_marker:
            if result:
                # Get the point and add marker on it
                point = QgsPoint(result.point())
                vertex_marker.setCenter(point)
                vertex_marker.show()

        return retval, result


    def add_marker(self, result, vertex_marker=None, icon_type=None):

        if result is None:
            return None

        if vertex_marker is None:
            vertex_marker = self.vertex_marker

        point = QgsPoint(result.snappedVertex)
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
        if result:
            snapped_point = result[0]
            layer = snapped_point.layer

        return layer


    def get_snapped_point(self, result):

        point = None
        if result:
            point = QgsPoint(result[0].snappedVertex)

        return point


    def get_snapped_feature_id(self, result):

        feature_id = None
        if result:
            feature_id = result[0].snappedAtGeometry

        return feature_id


    def get_snapped_feature(self, result, select_feature=False):

        if not result:
            return None

        snapped_feat = None
        try:
            snapped_point = result[0]
            layer = snapped_point.layer
            feature_id = snapped_point.snappedAtGeometry
            feature_request = QgsFeatureRequest().setFilterFid(feature_id)
