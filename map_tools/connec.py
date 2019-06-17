"""
/***************************************************************************
        begin                : 2016-01-05
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
try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

from qgis.core import QgsPoint, QgsVectorLayer, QgsRectangle
from qgis.PyQt.QtCore import QPoint, QRect, Qt
from qgis.PyQt.QtWidgets import QApplication

from map_tools.parent import ParentMapTool


class ConnecMapTool(ParentMapTool):
    """ Button 20: User select connections from layer 'connec'
    Execute SQL function: 'gw_fct_connect_to_network' """    

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        # Call ParentMapTool constructor
        super(ConnecMapTool, self).__init__(iface, settings, action, index_action)

        self.dragging = False

        # Select rectangle
        self.select_rect = QRect()



    """ QgsMapTools inherited event functions """

    def canvasMoveEvent(self, event):
        """ With left click the digitizing is finished """

        if event.buttons() == Qt.LeftButton:

            if not self.dragging:
                self.dragging = True
                self.select_rect.setTopLeft(event.pos())

            self.select_rect.setBottomRight(event.pos())
            self.set_rubber_band()

        else:

            # Hide marker
            self.vertex_marker.hide()

            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            event_point = QPoint(x, y)

            # Snapping
            (retval, result) = self.snapper_manager.snap_to_background_layers(event_point)
            if result:
                for snapped_feat in result:
                    # Check if it belongs to 'connec' or 'gully' group
                    exist_connec = self.snapper_manager.check_connec_group(snapped_feat.layer)                     
                    exist_gully = self.snapper_manager.check_gully_group(snapped_feat.layer)                                      
                    if exist_connec or exist_gully: 
                        self.snapper_manager.add_marker(snapped_feat, self.vertex_marker)
                        break


    def canvasPressEvent(self, event):   #@UnusedVariable

        self.select_rect.setRect(0, 0, 0, 0)
        self.rubber_band.reset(Qgis.Polygon)


    def canvasReleaseEvent(self, event):
        """ With left click the digitizing is finished """
        
        if event.button() == Qt.LeftButton:

            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            event_point = QPoint(x, y)

            # Simple selection
            if not self.dragging:

                # Snap to connec or gully
                (retval, result) = self.snapper_manager.snap_to_background_layers(event_point)
                if result:
                    # Check if it belongs to 'connec' or 'gully' group                  
                    exist_connec = self.snapper_manager.check_connec_group(result[0].layer)
                    exist_gully = self.snapper_manager.check_gully_group(result[0].layer)                    
                    if exist_connec or exist_gully:                       
                        key = QApplication.keyboardModifiers()   
                        # If Ctrl+Shift is clicked: deselect snapped feature               
                        if key == (Qt.ControlModifier | Qt.ShiftModifier):                   
                            result[0].layer.deselect([result[0].snappedAtGeometry])                                                       
                        else:
                            # If Ctrl is not clicked: remove previous selection                            
                            if key != Qt.ControlModifier:  
                                result[0].layer.removeSelection()                                          
                            result[0].layer.select([result[0].snappedAtGeometry])
                            
                        # Hide marker
                        self.vertex_marker.hide()

            # Multiple selection
            else:

                # Set valid values for rectangle's width and height
                if self.select_rect.width() == 1:
                    self.select_rect.setLeft(self.select_rect.left() + 1)

                if self.select_rect.height() == 1:
                    self.select_rect.setBottom(self.select_rect.bottom() + 1)

                self.set_rubber_band()
                selected_geom = self.rubber_band.asGeometry()   #@UnusedVariable
                self.select_multiple_features(self.selected_rectangle)
                self.dragging = False

                # Refresh map canvas
                self.rubber_band.reset()                

        elif event.button() == Qt.RightButton:

            # Check selected records
            number_features = 0
            for layer in self.layer_connec_man:
                number_features += layer.selectedFeatureCount()

            if number_features > 0:
                message = ("Number of features selected in the 'connec' group")
                title = "Interpolate value - Do you want to update values"
                answer = self.controller.ask_question(message, title, parameter=str(number_features))
                if answer:
                    # Create link
                    self.link_selected_features('connec', self.layer_connec_man)
                    
            if self.layer_gully_man:            
                # Check selected records
                number_features = 0
                for layer in self.layer_gully_man:
                    number_features += layer.selectedFeatureCount()
    
                if number_features > 0:
                    message = ("Number of features selected in the 'gully' group")
                    title = "Interpolate value - Do you want to update values"
                    answer = self.controller.ask_question(message, title, parameter=str(number_features))
                    if answer:
                        # Create link
                        self.link_selected_features('gully', self.layer_gully_man)                    


    def activate(self):

        # Check button
        self.action().setChecked(True)

        # Rubber band
        self.rubber_band.reset()

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Clear snapping
        self.snapper_manager.clear_snapping()    

        # Set snapping to 'connec' and 'gully'
        self.snapper_manager.snap_to_connec_gully()

        # Change cursor
        cursor = self.get_cursor_multiple_selection()
        self.canvas.setCursor(cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Right click to use current selection, select connec points by clicking or dragging (selection box)"
            self.controller.show_info(message)  


    def deactivate(self):

        # Call parent method     
        ParentMapTool.deactivate(self)


    def link_selected_features(self, geom_type, layers):
        """ Link selected @geom_type to the pipe """

        # Check features selected
        number_features = 0
        for layer in layers:
            number_features += layer.selectedFeatureCount()
            
        if number_features == 0:
            message = "You have to select at least one feature!"
            self.controller.show_warning(message)
            return

        # Get selected features from layers of selected @geom_type
        aux = "{"
        field_id = geom_type + "_id"
        
        # Iterate over all layers
        for layer in layers:
            if layer.selectedFeatureCount() > 0:
                # Get selected features of the layer
                features = layer.selectedFeatures()
                for feature in features:
                    feature_id = feature.attribute(field_id)
                    aux += str(feature_id) + ", "
                list_feature_id = aux[:-2] + "}"
        
                # Execute function
                function_name = "gw_fct_connect_to_network"
                sql = ("SELECT " + self.schema_name + "." + function_name + ""
                       "('" + list_feature_id + "', '" + geom_type.upper() + "');")            
                self.controller.execute_sql(sql, log_sql=True)
                layer.removeSelection()

        # Refresh map canvas
        self.rubber_band.reset()
        self.refresh_map_canvas()
        self.iface.actionPan().trigger()


    def set_rubber_band(self):

        # Coordinates transform
        transform = self.canvas.getCoordinateTransform()

        # Coordinates
        ll = transform.toMapCoordinates(self.select_rect.left(), self.select_rect.bottom())
        lr = transform.toMapCoordinates(self.select_rect.right(), self.select_rect.bottom())
        ul = transform.toMapCoordinates(self.select_rect.left(), self.select_rect.top())
        ur = transform.toMapCoordinates(self.select_rect.right(), self.select_rect.top())

        # Rubber band
        self.rubber_band.reset(Qgis.Polygon)
        self.rubber_band.addPoint(ll, False)
        self.rubber_band.addPoint(lr, False)
        self.rubber_band.addPoint(ur, False)
        self.rubber_band.addPoint(ul, False)
        self.rubber_band.addPoint(ll, True)

        self.selected_rectangle = QgsRectangle(ll, ur)


    def select_multiple_features(self, selectGeometry):

        if self.layer_connec_man is None and self.layer_gully_man is None:
            return

        key = QApplication.keyboardModifiers() 
        
        # If Ctrl+Shift clicked: remove features from selection
        if key == (Qt.ControlModifier | Qt.ShiftModifier):                
            behaviour = QgsVectorLayer.RemoveFromSelection
        # If Ctrl clicked: add features to selection
        elif key == Qt.ControlModifier:
            behaviour = QgsVectorLayer.AddToSelection
        # If Ctrl not clicked: add features to selection
        else:
            behaviour = QgsVectorLayer.AddToSelection

        # Selection for all connec and gully layers
        for layer in self.layer_connec_man:
            layer.selectByRect(selectGeometry, behaviour)
            
        if self.layer_gully_man:                
            for layer in self.layer_gully_man:
                layer.selectByRect(selectGeometry, behaviour)
        
