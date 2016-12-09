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
        QgsProject.instance().setSnapSettingsForLayer(self.layer_connec.node_id(), True, 2, 2, 1.0, False)


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


    def set_layer(self):
        
        self.layer = self.iface.activeLayer()
        
        if self.layer == table_arc:  
            self.layer_value = layer_arc
        if self.layer == table_node : 
            self.layer_value = layer_node
        if self.layer == table_connec : 
            self.layer_value = layer_connec
        if self.layer == table_gully :  
            self.layer_value = layer_gully
            
        if self.layer == table_man_arc :  
            self.layer_value = layer_man_arc
        if self.layer == table_man_node : 
            self.layer_value = layer_man_node
        if self.layer == table_man_connec : 
            self.layer_value = layer_man_connec
        if self.layer == table_man_gully :  
            self.layer_value = layer_gully
                 
        if self.layer == table_wjoin :  
            self.layer_value = layer_connec
        if self.layer == table_tap :  
            self.layer_value = layer_connec
        if self.layer == table_greentap:  
            self.layer_value = layer_connec
        if self.layer == table_fountain :  
            self.layer_value = layer_connec
             
        if self.layer == table_tank :  
            self.layer_value = layer_node
        if self.layer == table_pump :  
            self.layer_value = layer_node  
        if self.layer == table_source :  
            self.layer_value = layer_node   
        if self.layer == table_meter :  
            self.layer_value = layer_node
        if self.layer == table_junction :  
            self.layer_value = layer_node
        if self.layer == table_waterwell :  
            self.layer_value = layer_node
        if self.layer == table_reduction:  
            self.layer_value = layer_node
        if self.layer == table_hydrant :  
            self.layer_value = layer_node
        if self.layer == table_valve :  
            self.layer_value = layer_node
        if self.layer == table_manhole :  
            self.layer_value = layer_node
            
        if self.layer == table_chamber:  
            self.layer_value = layer_node
        if self.layer == table_chamber_pol :  
            self.layer_value = layer_node
        if self.layer == table_netgully :  
            self.layer_value = layer_node
        if self.layer == table_netgully_pol :  
            self.layer_value = layer_node
        if self.layer == table_netinit :  
            self.layer_value = layer_node
        if self.layer == table_wjump :  
            self.layer_value = layer_node
        if self.layer == table_wwtp :  
            self.layer_value = layer_node
        if self.layer == table_wwtp_pol :  
            self.layer_value = layer_node
        if self.layer == table_storage :  
            self.layer_value = layer_node
        if self.layer == table_storage_pol :  
            self.layer_value = layer_node
        if self.layer == table_outfall :  
            self.layer_value = layer_node
            
            
        if self.layer == table_varc :  
            self.layer_value = layer_arc
        if self.layer == table_siphon :  
            self.layer_value = layer_arc
        if self.layer == table_conduit :  
            self.layer_value = layer_arc
        if self.layer == table_waccel:  
            self.layer_value = layer_arc
        
        
        
        