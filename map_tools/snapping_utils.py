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
        proj = QgsProject.instance()
        proj.writeEntry('Digitizing', 'SnappingMode', 'advanced')


        
    def set_layers(self, layer_arc_man, layer_connec_man, layer_node_man):
        self.layer_arc_man = layer_arc_man
        self.layer_connec_man = layer_connec_man
        self.layer_node_man = layer_node_man      
 

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
        ''' Removing snap '''

        # We loop through all the layers in the project
        QgsProject.instance().blockSignals(True)  # we don't want to refresh the snapping UI

        layers = self.iface.legendInterface().layers()

        for layer in layers:
            QgsProject.instance().setSnapSettingsForLayer(layer.id(), False, 0, 0, 1, False)

        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snapSettingsChanged.emit()  # update the gui


    def snapToArc(self):
        ''' Set snapping to Arc '''
        QgsProject.instance().blockSignals(True)
        for layer in self.layer_arc_man:
            QgsProject.instance().setSnapSettingsForLayer(layer.id(), True, 2, 2, 1.0, False)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snapSettingsChanged.emit()  # update the gui


    def unsnapToArc(self):
        ''' Unset snapping to Arc '''
        #QgsProject.instance().blockSignals(True)
        for layer in self.layer_arc_man:
            QgsProject.instance().setSnapSettingsForLayer(layer.id(), False, 2, 2, 1.0, False)
        #QgsProject.instance().blockSignals(False)
        QgsProject.instance().snapSettingsChanged.emit()  # update the gui
        
        
    def snapToNode(self):
        ''' Set snapping to Node '''
        
        QgsProject.instance().blockSignals(True)
        for layer in self.layer_node_man:
            QgsProject.instance().setSnapSettingsForLayer(layer.id(), True, 0, 2, 1.0, False)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snapSettingsChanged.emit()  # update the gui
        
        
    def snapToConnec(self):
        ''' Set snapping to Connec '''
        QgsProject.instance().blockSignals(True)
        #QgsProject.instance().setSnapSettingsForLayer(self.layer_connec.id(), True, 2, 2, 1.0, False)

        for layer in self.layer_connec_man:
            QgsProject.instance().setSnapSettingsForLayer(layer.id(), True, 2, 2, 1.0, False)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snapSettingsChanged.emit()  # update the gui


    def snapToValve(self):
        ''' Set snapping to Connec '''
        QgsProject.instance().blockSignals(True)
        #QgsProject.instance().setSnapSettingsForLayer(self.layer_connec.id(), True, 2, 2, 1.0, False)
        
        for layer in self.layer_node_man:
            if layer.name() == 'Valve':
                QgsProject.instance().setSnapSettingsForLayer(layer.id(), True, 2, 2, 1.0, False)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snapSettingsChanged.emit()  # update the gui
        


    def snapToLayer(self, Layer):
        ''' Set snapping to Layer '''
        QgsProject.instance().setSnapSettingsForLayer(Layer.id(), True, 2, 2, 1.0, False)


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
        

    def check_node_group(self, snapped_layer):
        ''' Check if snapped layer is in the node group''' 
        if snapped_layer in self.layer_node_man:
            return 1


    def check_connec_group(self, snapped_layer):
        ''' Check if snapped layer is in the connec group''' 
        if snapped_layer in self.layer_connec_man:
            return 1
        
        
    def check_arc_group(self, snapped_layer):
        ''' Check if snapped layer is in the arc group''' 
        if snapped_layer in self.layer_arc_man:
            return 1
        
