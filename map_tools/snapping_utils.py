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
from qgis.core import QgsProject
from qgis.gui import QgsMapCanvasSnapper


class SnappingConfigManager():

    def __init__(self, iface):
        ''' Class constructor '''

        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.layer_arc = None        
        self.layer_connec = None        
        self.layer_node = None                

        # Snapper
        self.snapper = QgsMapCanvasSnapper(self.canvas)
        
        
    def set_layers(self, layer_arc, layer_connec, layer_node):
        self.layer_arc = layer_arc
        self.layer_connec = layer_connec
        self.layer_node = layer_node        


    def getSnappingOptions(self):
        ''' Function that collects all the snapping options and put it in an array '''

        snappingLayersOptions = []

        layers = self.iface.legendInterface().layers()

        for layer in layers:
            options = QgsProject.instance().snapSettingsForLayer(layer.id())

            snappingLayersOptions.append(
                {'layerid': layer.id(), 'enabled': options[1], 'snapType': options[2], 'unitType': options[3],
                 'tolerance': options[4], 'avoidInt': options[5]})

        return snappingLayersOptions


    def storeSnappingOptions(self):
        ''' Store the project user snapping configuration '''

        #Get an array containing the snapping options for all the layers
        self.previousSnapping = self.getSnappingOptions()


    def clearSnapping(self):
        ''' Function that collects all the snapping options and put it in an array '''

        # We loop through all the layers in the project
        QgsProject.instance().blockSignals(True)  # we don't want to refresh the snapping UI

        layers = self.iface.legendInterface().layers()

        for layer in layers:
            QgsProject.instance().setSnapSettingsForLayer(layer.id(), False, 0, 0, 1, False)

        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snapSettingsChanged.emit()  # update the gui


    def snapToArc(self):
        ''' Set snapping to Arc '''
        QgsProject.instance().setSnapSettingsForLayer(self.layer_arc.id(), True, 2, 2, 1.0, False)


    def snapToNode(self):
        ''' Set snapping to Node '''
        QgsProject.instance().setSnapSettingsForLayer(self.layer_node.id(), True, 0, 2, 1.0, False)


    def snapToConnec(self):
        ''' Set snapping to Connec '''
        QgsProject.instance().setSnapSettingsForLayer(self.layer_connec.id(), True, 2, 2, 1.0, False)


    def applySnappingOptions(self, snappingsOptions):
        ''' Function that restores the previous snapping '''

        # We loop through all the layers in the project
        # We don't want to refresh the snapping UI        
        QgsProject.instance().blockSignals(True)  

        for snpOpts in snappingsOptions:
            QgsProject.instance().setSnapSettingsForLayer(snpOpts['layerid'], int(snpOpts['enabled']),
                                                          int(snpOpts['snapType']), int(snpOpts['unitType']),
                                                          float(snpOpts['tolerance']), int(snpOpts['avoidInt']))

        QgsProject.instance().blockSignals(False)
        # Update the gui        
        QgsProject.instance().snapSettingsChanged.emit()  


    def recoverSnappingOptions(self):
        ''' Function to restore user configuration '''
        self.applySnappingOptions(self.previousSnapping)

