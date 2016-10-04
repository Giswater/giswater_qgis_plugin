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
from qgis.core import QgsPoint, QgsMapLayer, QgsVectorLayer, QgsRectangle, QgsRaster, QgsFeature, QgsFeatureRequest
from qgis.gui import QgsRubberBand, QgsVertexMarker
from PyQt4.QtCore import QPoint, QRect, Qt, QCoreApplication
from PyQt4.QtGui import QApplication, QColor, QAction

from map_tools.parent import ParentMapTool


class ExtractRasterValue(ParentMapTool):
    ''' Button 18. User select nodes and assign raster elevation or value '''

    def __init__(self, iface, settings, action, index_action):
        ''' Class constructor '''

        # Call ParentMapTool constructor
        super(ExtractRasterValue, self).__init__(iface, settings, action, index_action)

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

        # Init
        self.vectorLayer = None
        self.rasterLayer = None


    def reset(self):
        ''' Clear selected features '''
        
        layer = self.vectorLayer
        if layer is not None:
            layer.removeSelection()

        # Graphic elements
        self.rubberBand.reset()


    def set_config_action(self, action_99):
        ''' Set the config form action '''
        self.configAction = action_99


    ''' QgsMapTools inherited event functions '''

    def canvasMoveEvent(self, event):
        ''' With left click the digitizing is finished '''

        if self.vectorLayer is None:
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

                    if snapPoint.layer == self.vectorLayer:

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

            # Node layer
            layer = self.vectorLayer

            # Not dragging, just simple selection
            if not self.dragging:

                # Snap to node
                (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable

                # That's the snapped point
                if result <> [] and (result[0].layer.name() == self.vectorLayer.name()):
                    
                    point = QgsPoint(result[0].snappedVertex)   #@UnusedVariable
                    layer.removeSelection()
                    layer.select([result[0].snappedAtGeometry])

                    # Interpolate values
                    self.raster_interpolate()

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

                # Interpolate values
                self.raster_interpolate()

        elif event.button() == Qt.RightButton:

            # Interpolate values
            self.raster_interpolate()


    def activate(self):

        # Check button
        self.action().setChecked(True)

        # Rubber band
        self.rubberBand.reset()

        # Store user snapping configuration
        self.snapperManager.storeSnappingOptions()

        # Clear snapping
        self.snapperManager.clearSnapping()

        # Get layers
        res = self.find_raster_layers()
#        if res == 0:
#            self.controller.show_warning("Raster configuration tool not properly configured.")
#            return

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Right click to use current selection, select connec points by clicking or dragging (selection box)"
            self.controller.show_info(message, context_name='ui_message' )  

        # Control current layer (due to QGIS bug in snapping system)
        try:
            if self.canvas.currentLayer().type() == QgsMapLayer.VectorLayer:
                self.canvas.setCurrentLayer(self.layer_arc)
        except:
            self.canvas.setCurrentLayer(self.layer_arc)


    def deactivate(self):

        # Check button
        self.action().setChecked(False)

        # Rubber band
        self.rubberBand.reset()

        # Restore previous snapping
        self.snapperManager.recoverSnappingOptions()

        # Recover cursor
        self.canvas.setCursor(self.stdCursor)


    def nearestNeighbor(self, thePoint):

        ident = self.dataProv.identify(thePoint, QgsRaster.IdentifyFormatValue)
        value = None
        if ident is not None:  # and ident.has_key(choosenBand+1):
            try:
                value = float(ident.results()[int(self.band)])
            except TypeError:
                value = None
        if value == self.noDataValue:
            return None
        return value


    def writeInterpolation(self, f, fieldIdx):

        thePoint = f.geometry().asPoint()
        value = self.nearestNeighbor(thePoint)
        self.vectorLayer.changeAttributeValue(f.id(), fieldIdx, value)


    def raster_interpolate(self):
        ''' Interpolate features value from raster '''

        # Interpolate values
        if self.vectorLayer is None and self.rasterLayer is None:
            return

        # Get data provider
        layer = self.vectorLayer
        self.dataProv = self.rasterLayer.dataProvider()
        if self.dataProv.srcNoDataValue(int(self.band)):
            self.noDataValue = self.dataProv.srcNoDataValue(int(self.band))
        else:
            self.noDataValue = None

        self.continueProcess = True
        self.fieldIdx = ""
        self.fieldIdx = layer.fieldNameIndex(self.fieldName)

        if self.band == 0:
            self.controller.show_warning("You must choose a band for the raster layer.")
            return
        if self.fieldName == "":
            self.controller.show_warning("You must choose a field to write values.")
            return
        if self.fieldIdx < 0:
            self.controller.show_warning("Selected field does not exist in feature layer.")
            return

        k = 0
        c = 0
        f = QgsFeature()

        # Check features selected
        if layer.selectedFeatureCount() == 0:
            message = "You have to select at least one feature!"
            self.controller.show_warning(message, context_name='ui_message')
            return

        # Check editable
        if not layer.isEditable():
            layer.startEditing()

        # Get selected id's
        ids = self.vectorLayer.selectedFeaturesIds()
        for fid in ids:
            k += 1
            layer.getFeatures(QgsFeatureRequest(fid)).nextFeature(f)
            c += 1
            self.writeInterpolation(f, self.fieldIdx)
            QCoreApplication.processEvents()

        self.controller.show_info(
            "%u values have been updated in layer %s.%s over %u points using %s raster" % (
            c, self.vectorLayer.name(), self.fieldName, k, self.table_raster))

        # Check editable
        if layer.isEditable():
            layer.commitChanges()

        # Refresh map canvas
        self.rubberBand.reset()
        self.iface.mapCanvas().refresh()


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

        self.selectRectMapCoord = QgsRectangle(ll, ur)


    def select_multiple_features(self, selectGeometry):

        # Default choice
        behaviour = QgsVectorLayer.SetSelection

        # Modifiers
        modifiers = QApplication.keyboardModifiers()

        if modifiers == Qt.ControlModifier:
            behaviour = QgsVectorLayer.AddToSelection
        elif modifiers == Qt.ShiftModifier:
            behaviour = QgsVectorLayer.RemoveFromSelection

        if self.vectorLayer is None:
            return

        # Change cursor
        QApplication.setOverrideCursor(Qt.WaitCursor)

        # Selection
        self.vectorLayer.selectByRect(selectGeometry, behaviour)

        # Old cursor
        QApplication.restoreOverrideCursor()


    def find_raster_layers(self):

        # Query database (form data)
        sql = "SELECT *"
        sql+= " FROM " + self.schema_name + ".config_extract_raster_value"
        rows = self.controller.get_rows(sql)

        if not rows:
            self.controller.show_warning("Any data found in table config_extract_raster_value")
            self.configAction.activate(QAction.Trigger)
            return 0

        # Layers
        row = rows[0]
        self.table_raster = row[1]
        self.band = row[2]
        self.table_vector = row[3]
        self.fieldName = row[4]

        # Check if we have any layer loaded
        layers = self.iface.legendInterface().layers()
        if len(layers) == 0:
            return

        # Init layers
        self.rasterLayer = None
        self.vectorLayer = None

        # Iterate over all layers to get the ones specified in 'db' config section
        for cur_layer in layers:

            if cur_layer.name() == self.table_raster:
                self.rasterLayer = cur_layer

            layer_source = self.controller.get_layer_source(cur_layer)
            uri_table = layer_source['table']
            if uri_table is not None:
                if self.table_vector in uri_table:
                    self.vectorLayer = cur_layer

        # Check config
        if self.vectorLayer is None or self.rasterLayer is None:
            self.configAction.activate(QAction.Trigger)

        # Set snapping
        if self.vectorLayer <> None:
            self.snapperManager.snapToLayer(self.vectorLayer)
        else:
            self.controller.show_warning("Check vector_layer in config form, layer does not exist or is not defined.")
            return 0

        if self.rasterLayer == None:
            self.controller.show_warning("Check raster_layer in config form, layer does not exist or is not defined.")
            return 0

        return 1

