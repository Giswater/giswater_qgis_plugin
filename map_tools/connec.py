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
from qgis.core import QgsPoint, QgsVectorLayer, QgsRectangle, QGis
from qgis.gui import QgsRubberBand, QgsVertexMarker
from PyQt4.QtCore import QPoint, QRect, Qt
from PyQt4.QtGui import QApplication, QColor

from map_tools.parent import ParentMapTool


class ConnecMapTool(ParentMapTool):
    ''' Button 20: User select connections from layer 'connec'
    Execute SQL function: 'gw_fct_connect_to_network' '''    

    def __init__(self, iface, settings, action, index_action):
        ''' Class constructor '''

        # Call ParentMapTool constructor
        super(ConnecMapTool, self).__init__(iface, settings, action, index_action)

        self.dragging = False

        # Vertex marker
        self.vertex_marker = QgsVertexMarker(self.canvas)
        self.vertex_marker.setColor(QColor(255, 25, 25))
        self.vertex_marker.setIconSize(11)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_BOX)  # or ICON_CROSS, ICON_X
        self.vertex_marker.setPenWidth(5)

        # Rubber band
        self.rubber_band = QgsRubberBand(self.canvas, True)
        mFillColor = QColor(100, 0, 0);
        self.rubber_band.setColor(mFillColor)
        self.rubber_band.setWidth(3)
        mBorderColor = QColor(254, 58, 29)
        self.rubber_band.setBorderColor(mBorderColor)

        # Select rectangle
        self.select_rect = QRect()


    def reset(self):
        ''' Clear selected features '''
        
        layer = self.layer_connec
        if layer is not None:
            layer.removeSelection()

        # Graphic elements
        self.rubber_band.reset()



    ''' QgsMapTools inherited event functions '''

    def canvasMoveEvent(self, event):
        ''' With left click the digitizing is finished '''

        # Plugin reloader bug, MapTool should be deactivated
        if not hasattr(Qt, 'LeftButton'):
            self.iface.actionPan().trigger()
            return

        if event.buttons() == Qt.LeftButton:

            if not self.dragging:
                self.dragging = True
                self.select_rect.setTopLeft(event.pos())

            self.select_rect.setBottomRight(event.pos())
            self.set_rubber_band()

        else:

            # Hide highlight
            self.vertex_marker.hide()

            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            eventPoint = QPoint(x, y)

            # Snapping
            (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable

            # That's the snapped point
            if result:
                for snapped_feat in result:
                    # Check if it belongs to connec group
                    exist = self.snapper_manager.check_connec_group(snapped_feat.layer)
                    if exist: 
                        # Get the point and add marker
                        point = QgsPoint(result[0].snappedVertex)
                        self.vertex_marker.setCenter(point)
                        self.vertex_marker.show()
                        break


    def canvasPressEvent(self, event):   #@UnusedVariable

        self.select_rect.setRect(0, 0, 0, 0)
        self.rubber_band.reset()


    def canvasReleaseEvent(self, event):
        ''' With left click the digitizing is finished '''
        
        if event.button() == Qt.LeftButton:

            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            event_point = QPoint(x, y)

            # Not dragging, just simple selection
            if not self.dragging:

                # Snap to node
                (retval, result) = self.snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

                # That's the snapped point
                if result:
                    exist = self.snapper_manager.check_connec_group(result[0].layer)
                    if exist:
                        point = QgsPoint(result[0].snappedVertex)   #@UnusedVariable
                        result[0].layer.removeSelection()
                        result[0].layer.select([result[0].snappedAtGeometry])
                        # Hide highlight
                        self.vertex_marker.hide()

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
                message = "There are " + str(number_features) + " features selected in the connec group, do you want to update values on them?"
                answer = self.controller.ask_question(message, "Interpolate value")
                if answer:
                    # Create link
                    self.link_connec()


    def activate(self):

        # Check button
        self.action().setChecked(True)

        # Rubber band
        self.rubber_band.reset()

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Clear snapping
        self.snapper_manager.clear_snapping()

        # Set snapping to connec
        self.snapper_manager.snap_to_connec()

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Right click to use current selection, select connec points by clicking or dragging (selection box)"
            self.controller.show_info(message)  

        # Control current layer (due to QGIS bug in snapping system)
        if self.canvas.currentLayer() == None:
            self.iface.setActiveLayer(self.layer_node_man[0])


    def deactivate(self):

        # Call parent method     
        ParentMapTool.deactivate(self)


    def link_connec(self):
        ''' Link selected connec to the pipe '''

        # Check features selected
        number_features = 0
        for layer in self.layer_connec_man:
            number_features += layer.selectedFeatureCount()
            
        if number_features == 0:
            message = "You have to select at least one feature!"
            self.controller.show_warning(message)
            return

        # Get selected features from layers of geom_type 'connec'
        aux = "{"
        
        for layer in self.layer_connec_man:
            
            if layer.selectedFeatureCount() > 0:

                features = layer.selectedFeatures()
                for feature in features:
                    connec_id = feature.attribute('connec_id')
                    aux += str(connec_id) + ", "
                connec_array = aux[:-2] + "}"
        
                # Execute function
                function_name = "gw_fct_connect_to_network"
                sql = "SELECT "+self.schema_name+"."+function_name+"('"+connec_array+"', 'CONNEC');"
                self.controller.log_info(layer.name())                
                self.controller.log_info(sql)
                self.controller.execute_sql(sql)
        
                # Refresh map canvas
                self.rubber_band.reset()
                self.iface.mapCanvas().refreshAllLayers()

                for layer_refresh in self.iface.mapCanvas().layers():
                    layer_refresh.triggerRepaint()



    def set_rubber_band(self):

        # Coordinates transform
        transform = self.canvas.getCoordinateTransform()

        # Coordinates
        ll = transform.toMapCoordinates(self.select_rect.left(), self.select_rect.bottom())
        lr = transform.toMapCoordinates(self.select_rect.right(), self.select_rect.bottom())
        ul = transform.toMapCoordinates(self.select_rect.left(), self.select_rect.top())
        ur = transform.toMapCoordinates(self.select_rect.right(), self.select_rect.top())

        # Rubber band
        self.rubber_band.reset()
        self.rubber_band.addPoint(ll, False)
        self.rubber_band.addPoint(lr, False)
        self.rubber_band.addPoint(ur, False)
        self.rubber_band.addPoint(ul, False)
        self.rubber_band.addPoint(ll, True)

        self.selected_rectangle = QgsRectangle(ll, ur)


    def select_multiple_features(self, selectGeometry):

        if self.layer_connec_man is None:
            return

        # Change cursor
        QApplication.setOverrideCursor(Qt.WaitCursor)

        if QGis.QGIS_VERSION_INT >= 21600:

            # Default choice
            behaviour = QgsVectorLayer.SetSelection

            # Selection for all connec group layers
            for layer in self.layer_connec_man:
                layer.selectByRect(selectGeometry, behaviour)

        else:

            for layer in self.layer_connec_man:
                layer.removeSelection()
                layer.select(selectGeometry, True)

        # Old cursor
        QApplication.restoreOverrideCursor()
        
