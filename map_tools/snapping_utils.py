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


# -*- coding: utf-8 -*-
from qgis.core import (QgsProject, QgsMapLayerRegistry)
from qgis.gui import (QgsMapCanvasSnapper)


class SnappingConfigManager():

    def __init__(self, iface):
        ''' Class constructor '''

        self.iface = iface
        self.canvas = self.iface.mapCanvas()

        # Snapper
        self.snapper = QgsMapCanvasSnapper(self.canvas)


    # Function that collects all the snapping options and put it in an array
    def getSnappingOptions(self):

        snappingLayersOptions = []

        layers = self.iface.legendInterface().layers()

        for layer in layers:
            options = QgsProject.instance().snapSettingsForLayer(layer.id())

            snappingLayersOptions.append(
                {'layerid': layer.id(), 'enabled': options[1], 'snapType': options[2], 'unitType': options[3],
                 'tolerance': options[4], 'avoidInt': options[5]})

        return snappingLayersOptions


    # Store the project user snapping configuration
    def storeSnappingOptions(self):

        #Get an array containing the snapping options for all the layers
        self.previousSnapping = self.getSnappingOptions()


    # Function that collects all the snapping options and put it in an array
    def clearSnapping(self):

        # We loop through all the layers in the project
        QgsProject.instance().blockSignals(True)  # we don't want to refresh the snapping UI

        layers = self.iface.legendInterface().layers()

        for layer in layers:
            QgsProject.instance().setSnapSettingsForLayer(layer.id(), False, 0, 0, 1, False)

        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snapSettingsChanged.emit()  # update the gui


    # Set snapping to Arc
    def snapToArc(self):
        QgsProject.instance().setSnapSettingsForLayer((QgsMapLayerRegistry.instance().mapLayersByName("Arc")[0]).id(), True, 2, 2, 1.0, False)


    # Set snapping to Node
    def snapToNode(self):
        QgsProject.instance().setSnapSettingsForLayer((QgsMapLayerRegistry.instance().mapLayersByName("Node")[0]).id(), True, 0, 2, 1.0, False)


    # Set snapping to Connec
    def snapToConnec(self):

        QgsProject.instance().setSnapSettingsForLayer((QgsMapLayerRegistry.instance().mapLayersByName("Connec")[0]).id(), True, 2, 2, 1.0, False)


    # Function that restores the previous snapping
    def applySnappingOptions(self, snappingsOptions):

        # We loop through all the layers in the project
        QgsProject.instance().blockSignals(True)  # we don't want to refresh the snapping UI

        layers = self.iface.legendInterface().layers()

        for snpOpts in snappingsOptions:
            QgsProject.instance().setSnapSettingsForLayer(snpOpts['layerid'], int(snpOpts['enabled']),
                                                          int(snpOpts['snapType']), int(snpOpts['unitType']),
                                                          float(snpOpts['tolerance']), int(snpOpts['avoidInt']))

        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snapSettingsChanged.emit()  # update the gui


    # Function to restore user configuration
    def recoverSnappingOptions(self):

        self.applySnappingOptions(self.previousSnapping)

