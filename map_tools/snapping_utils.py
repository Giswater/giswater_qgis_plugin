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
        """ Class constructor """

        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.layer_arc = None        
        self.layer_connec = None        
        self.layer_node = None 
        self.previous_snapping = None
        self.controller = None
            
        # Snapper
        self.snapper = QgsMapCanvasSnapper(self.canvas)
        proj = QgsProject.instance()
        proj.writeEntry('Digitizing', 'SnappingMode', 'advanced')

        
    def set_layers(self, layer_arc_man, layer_connec_man, layer_node_man, layer_gully_man=None):
        self.layer_arc_man = layer_arc_man
        self.layer_connec_man = layer_connec_man
        self.layer_node_man = layer_node_man   
        self.layer_gully_man = layer_gully_man
 

    def get_snapping_options(self):
        """ Function that collects all the snapping options and put it in an array """

        snapping_layers_options = []
        layers = self.iface.legendInterface().layers()
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
        layers = self.iface.legendInterface().layers()
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
        
