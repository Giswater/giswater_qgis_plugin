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
from qgis.core import QgsPoint, QgsMapLayer, QgsVectorLayer, QgsRectangle, QGis
from qgis.gui import QgsRubberBand, QgsVertexMarker
from PyQt4.QtCore import QPoint, QRect, Qt
from PyQt4.QtGui import QApplication, QColor

from map_tools.parent import ParentMapTool


class ConnecMapTool(ParentMapTool):
    ''' Button 20. User select connections from layer 'connec'
    Execute SQL function: 'gw_fct_connect_to_network' '''    

    def __init__(self, iface, settings, action, index_action):
        ''' Class constructor '''

        # Call ParentMapTool constructor
        super(ConnecMapTool, self).__init__(iface, settings, action, index_action)

        self.dragging = False

        # Vertex marker
        self.vertexMarker = QgsVertexMarker(self.canvas)
        self.vertexMarker.setColor(QColor(255, 25, 25))
        self.vertexMarker.setIconSize(11)
        self.vertexMarker.setIconType(QgsVertexMarker.ICON_BOX)  # or ICON_CROSS, ICON_X
        self.vertexMarker.setPenWidth(5)

        # Rubber band
        self.rubberBand = QgsRubberBand(self.canvas, True)
        mFillColor = QColor(100, 0, 0);
        self.rubberBand.setColor(mFillColor)
        self.rubberBand.setWidth(3)
        mBorderColor = QColor(254, 58, 29)
        self.rubberBand.setBorderColor(mBorderColor)

        # Select rectangle
        self.selectRect = QRect()


    def reset(self):
        ''' Clear selected features '''
        
        layer = self.layer_connec
        if layer is not None:
            layer.removeSelection()

        # Graphic elements
        self.rubberBand.reset()



    ''' QgsMapTools inherited event functions '''

    def canvasMoveEvent(self, event):
        ''' With left click the digitizing is finished '''


        #Plugin reloader bug, MapTool should be deactivated
        if not hasattr(Qt, 'LeftButton'):
            print "Plugin loader bug"
            self.iface.actionPan().trigger()
            return

        if event.buttons() == Qt.LeftButton:

            if not self.dragging:
                self.dragging = True
                self.selectRect.setTopLeft(event.pos())

            self.selectRect.setBottomRight(event.pos())
            self.set_rubber_band()

        else:

            # Hide highlight
            self.vertexMarker.hide()

            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            eventPoint = QPoint(x, y)

            # Snapping
            (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable

            # That's the snapped point
            if result <> []:

                # Check Arc or Node
                for snapPoint in result:
                    
                    exist=self.snapperManager.check_connec_group(snapPoint.layer)
                    if exist : 
                    #if snapPoint.layer == self.layer_connec:

                        # Get the point
                        point = QgsPoint(result[0].snappedVertex)

                        # Add marker
                        self.vertexMarker.setCenter(point)
                        self.vertexMarker.show()

                        break


    def canvasPressEvent(self, event):

        self.selectRect.setRect(0, 0, 0, 0)
        self.rubberBand.reset()


    def canvasReleaseEvent(self, event):
        ''' With left click the digitizing is finished '''
        
        if event.button() == Qt.LeftButton:

            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            eventPoint = QPoint(x, y)

            # Not dragging, just simple selection
            if not self.dragging:

                # Snap to node
                (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable

                # That's the snapped point
                if result <> [] :
                    exist=self.snapperManager.check_connec_group(result[0].layer)

                    if exist :
                        point = QgsPoint(result[0].snappedVertex)   #@UnusedVariable
                        #layer.removeSelection()
                        #layer.select([result[0].snappedAtGeometry])
                        result[0].layer.removeSelection()
                        result[0].layer.select([result[0].snappedAtGeometry])
    
                        # Create link
                        self.link_connec()
    
                        # Hide highlight
                        self.vertexMarker.hide()

            else:

                # Set valid values for rectangle's width and height
                if self.selectRect.width() == 1:
                    self.selectRect.setLeft( self.selectRect.left() + 1 )

                if self.selectRect.height() == 1:
                    self.selectRect.setBottom( self.selectRect.bottom() + 1 )

                self.set_rubber_band()
                selectGeom = self.rubberBand.asGeometry()   #@UnusedVariable
                self.select_multiple_features(self.selectRectMapCoord)
                self.dragging = False

                # Create link
                self.link_connec()

        elif event.button() == Qt.RightButton:

            # Check selected records
            numberFeatures = 0

            for layer in self.layer_connec_man:
                numberFeatures += layer.selectedFeatureCount()

            if numberFeatures > 0:
                answer = self.controller.ask_question("There are " + str(numberFeatures) + " features selected in the connec group, do you want to update values on them?", "Interpolate value")

                if answer:

                    # Create link
                    self.link_connec()


    def activate(self):

        # Check button
        self.action().setChecked(True)

        # Rubber band
        self.rubberBand.reset()

        # Store user snapping configuration
        self.snapperManager.storeSnappingOptions()

        # Clear snapping
        self.snapperManager.clearSnapping()

        # Set snapping to arc and node
        self.snapperManager.snapToConnec()


        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Right click to use current selection, select connec points by clicking or dragging (selection box)"
            self.controller.show_info(message, context_name='ui_message' )  

        # Control current layer (due to QGIS bug in snapping system)
        if self.canvas.currentLayer() == None:
            self.iface.setActiveLayer(self.layer_node_man[0])


    def deactivate(self):

        # Check button
        self.action().setChecked(False)

        # Rubber band
        self.rubberBand.reset()

        # Restore previous snapping
        self.snapperManager.recoverSnappingOptions()

        # Recover cursor
        self.canvas.setCursor(self.stdCursor)


    def link_connec(self):
        ''' Link selected connec to the pipe '''


        # Check features selected
        numberFeatures = 0

        for layer in self.layer_connec_man:
            numberFeatures += layer.selectedFeatureCount()
        if numberFeatures == 0:
            message = "You have to select at least one feature!"
            self.controller.show_warning(message, context_name='ui_message')
            return

        # Get selected features (from layer 'connec')
        aux = "{"
        
        for layer in self.layer_connec_man:
        #layer = self.layer_connec
            if layer.selectedFeatureCount() > 0:

                features = layer.selectedFeatures()
                for feature in features:
                    connec_id = feature.attribute('connec_id')
                    aux += str(connec_id) + ", "
                connec_array = aux[:-2] + "}"
        
                # Execute function
                function_name = "gw_fct_connect_to_network"

                sql = "SELECT "+self.schema_name+"."+function_name+"('"+connec_array+"');"
                self.controller.execute_sql(sql)
        
                # Refresh map canvas
                self.rubberBand.reset()
                self.iface.mapCanvas().refreshAllLayers()

                for layerRefresh in self.iface.mapCanvas().layers():
                    layerRefresh.triggerRepaint()


    def set_rubber_band(self):

        # Coordinates transform
        transform = self.canvas.getCoordinateTransform()

        # Coordinates
        ll = transform.toMapCoordinates(self.selectRect.left(), self.selectRect.bottom())
        lr = transform.toMapCoordinates(self.selectRect.right(), self.selectRect.bottom())
        ul = transform.toMapCoordinates(self.selectRect.left(), self.selectRect.top())
        ur = transform.toMapCoordinates(self.selectRect.right(), self.selectRect.top())

        # Rubber band
        self.rubberBand.reset()
        self.rubberBand.addPoint(ll, False)
        self.rubberBand.addPoint(lr, False)
        self.rubberBand.addPoint(ur, False)
        self.rubberBand.addPoint(ul, False)
        self.rubberBand.addPoint(ll, True)

        self.selectRectMapCoord = 	QgsRectangle(ll, ur)


    def select_multiple_features(self, selectGeometry):

        if self.layer_connec_man is None:
            return

        # Change cursor
        QApplication.setOverrideCursor(Qt.WaitCursor)

        if QGis.QGIS_VERSION_INT >= 21600:

            # Default choice
            behaviour = QgsVectorLayer.SetSelection

            # # Modifiers
            # modifiers = QApplication.keyboardModifiers()
            #
            # if modifiers == Qt.ControlModifier:
            #     behaviour = QgsVectorLayer.AddToSelection
            # elif modifiers == Qt.ShiftModifier:
            #     behaviour = QgsVectorLayer.RemoveFromSelection

            # Selection for all connec group layers
            for layer in self.layer_connec_man:
                layer.selectByRect(selectGeometry, behaviour)

        else:

            for layer in self.layer_connec_man:
                layer.removeSelection()
                layer.select(selectGeometry, True)

        # Old cursor
        QApplication.restoreOverrideCursor()
