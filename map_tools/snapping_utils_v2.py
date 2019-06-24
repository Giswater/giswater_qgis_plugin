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
from qgis.core import QgsProject, QgsPoint, QgsFeatureRequest
from qgis.PyQt.QtCore import QPoint
from qgis.PyQt.QtGui import QColor


class SnappingConfigManager(object):

    def __init__(self, iface):
        """ Class constructor """

        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.previous_snapping = None
        self.controller = None
        self.is_valid = None

        # Snapper
        self.snapping_config = self.get_snapping_options()
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


    def set_snapping_layers(self):
        """ Set main snapping layers """

        self.layer_arc = self.controller.get_layer_by_tablename('v_edit_arc')
        self.layer_connec = self.controller.get_layer_by_tablename('v_edit_connec')
        self.layer_gully = self.controller.get_layer_by_tablename('v_edit_gully')
        self.layer_node = self.controller.get_layer_by_tablename('v_edit_node')


    def get_snapping_options(self):
        """ Function that collects all the snapping options """

        if self.controller is None:
            return None

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


    def enable_snapping(self, enable=False, snapping_mode=0):
        """ Enable/Disable snapping of all layers """

        QgsProject.instance().blockSignals(True)

        layers = self.controller.get_layers()
        # Loop through all the layers in the project
        for layer in layers:
            QgsProject.instance().setSnapSettingsForLayer(layer.id(), enable, snapping_mode, 0, 1, False)

        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snapSettingsChanged.emit()


    def snap_to_arc(self):
        """ Set snapping to 'arc' """

        QgsProject.instance().blockSignals(True)
        self.snap_to_layer(self.layer_arc, snapping_type=2)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snapSettingsChanged.emit()


    def snap_to_node(self):
        """ Set snapping to 'node' """

        QgsProject.instance().blockSignals(True)
        self.snap_to_layer(self.layer_node)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snapSettingsChanged.emit()


    def snap_to_connec_gully(self):
        """ Set snapping to 'connec' and 'gully' """

        QgsProject.instance().blockSignals(True)
        self.snap_to_layer(self.layer_connec)
        self.snap_to_layer(self.layer_gully)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snapSettingsChanged.emit()


    def snap_to_layer(self, layer, enabled=True, snapping_type=0, unit_type=2, tolerance=1.0):
        """ Set snapping to @layer """

        if layer is None:
            return

        QgsProject.instance().setSnapSettingsForLayer(layer.id(), enabled, snapping_type, unit_type, tolerance, False)


    def apply_snapping_options(self, snappings_options):
        """ Function that applies selected snapping configuration """

        if snappings_options:
            return

        QgsProject.instance().blockSignals(True)

        for snp_opt in snappings_options:
            QgsProject.instance().setSnapSettingsForLayer(snp_opt['layerid'], int(snp_opt['enabled']),
                                                          int(snp_opt['snapType']), int(snp_opt['unitType']),
                                                          float(snp_opt['tolerance']), int(snp_opt['avoidInt']))

        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snapSettingsChanged.emit()


    def recover_snapping_options(self):
        """ Function to restore user configuration """

        self.apply_snapping_options(self.previous_snapping)


    def check_arc_group(self, snapped_layer):
        """ Check if snapped layer is in the arc group """

        return snapped_layer == self.layer_arc


    def check_node_group(self, snapped_layer):
        """ Check if snapped layer is in the node group """

        return snapped_layer == self.layer_node


    def check_connec_group(self, snapped_layer):
        """ Check if snapped layer is in the connec group """

        return snapped_layer == self.layer_connec


    def check_gully_group(self, snapped_layer):
        """ Check if snapped layer is in the gully group """

        return snapped_layer == self.layer_gully


    def get_snapper(self):
        """ Return snapper """

        snapper = QgsMapCanvasSnapper(self.canvas)
        return snapper


    def snap_to_current_layer(self, event_point, vertex_marker=None):

        self.is_valid = False
        if event_point is None:
            return None, None

        (retval, result) = self.snapper.snapToCurrentLayer(event_point, 2)
        if vertex_marker:
            if result:
                # Get the point and add marker on it
                point = QgsPoint(result[0].snappedVertex)
                vertex_marker.setCenter(point)
                vertex_marker.show()

        self.is_valid = result is not None
        return result


    def snap_to_background_layers(self, event_point, vertex_marker=None):

        self.is_valid = False
        if event_point is None:
            return None, None

        (retval, result) = self.snapper.snapToBackgroundLayers(event_point)
        if vertex_marker:
            if result:
                # Get the point and add marker on it
                point = QgsPoint(result.point())
                vertex_marker.setCenter(point)
                vertex_marker.show()

        self.is_valid = result is not None
        return result


    def add_marker(self, result, vertex_marker=None, icon_type=None):

        if result is None:
            return None

        if vertex_marker is None:
            vertex_marker = self.vertex_marker

        point = QgsPoint(result[0].snappedVertex)
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
            layer = result[0].layer

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
            layer = result[0].layer
            feature_id = result[0].snappedAtGeometry
            feature_request = QgsFeatureRequest().setFilterFid(feature_id)
            snapped_feat = next(layer.getFeatures(feature_request))
            if select_feature:
                self.select_snapped_feature(result, feature_id)
        except:
            pass
        finally:
            return snapped_feat


    def select_snapped_feature(self, result, feature_id):

        if not result:
            return

        layer = result[0].layer()
        layer.select([feature_id])


    def result_is_valid(self):

        return self.is_valid

