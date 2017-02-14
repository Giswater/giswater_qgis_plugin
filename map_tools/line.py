"""
/***************************************************************************
        begin                : 2016-01-05
        copyright            : (C) 2016 by BGEO SL
        email                : derill@bgeo.es
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

Some code has been wrapped from:

# Vertex Trace Tool - A QGIS tool to get a geometry by moving the cursor over vertices. Draws rubberband.
#
# Copyright (C) 2010-2012 Cedric Mori

Under the terms of GNU GPL 2.
"""

# -*- coding: utf-8 -*-
from qgis.core import QgsFeatureRequest, QGis, QgsPoint, QgsMapToPixel, QgsGeometry, QgsFeature
from qgis.gui import QgsMapCanvasSnapper, QgsMapTool, QgsRubberBand, QgsVertexMarker
from PyQt4.QtCore import QPoint, Qt
from PyQt4.QtGui import QColor, QCursor, QMessageBox    


class LineMapTool(QgsMapTool):

    def __init__(self, iface, settings, action, index_action):  
        ''' Class constructor '''
        
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.settings = settings
        self.index_action = index_action
        self.elem_type_type = self.settings.value('insert_values/'+str(index_action)+'_elem_type_type')           
        QgsMapTool.__init__(self, self.canvas)
        self.setAction(action)

        # Set rubber band features
        self.rubberBand = QgsRubberBand(self.canvas, QGis.Line)
        mFillColor = QColor(255, 0, 0);
        self.rubberBand.setColor(mFillColor)
        self.rubberBand.setWidth(2)
        self.reset()        
        
        # Vertex marker
        self.vertexMarker = QgsVertexMarker(self.canvas)
        self.vertexMarker.setColor(QColor(0, 255, 0))
        self.vertexMarker.setIconSize(9)
        self.vertexMarker.setIconType(QgsVertexMarker.ICON_BOX) # or ICON_CROSS, ICON_X
        self.vertexMarker.setPenWidth(5)

        # Snapper
        self.snapper = QgsMapCanvasSnapper(self.canvas)

        # Control button state
        self.mCtrl = False
        self.started = False
        
        # Tracing options
        self.firstTimeOnSegment = True
        self.lastPointMustStay = False
        self.lastPoint = None
        
        # Change map tool cursor
        self.cursor = QCursor()
        self.cursor.setShape(Qt.CrossCursor)
        self.parent().setCursor(self.cursor)                                             
 
 
    def keyPressEvent(self,  event):
        ''' We need to know, if ctrl-key is pressed '''
        if event.key() == Qt.Key_Control:
            self.mCtrl = True


    def keyReleaseEvent(self,  event):
        ''' Ctrl-key is released '''
        if event.key() == Qt.Key_Control:
            self.mCtrl = False
        
        # Remove the last added point when the delete key is pressed
        if event.key() == Qt.Key_Backspace:
            self.rubberBand.removeLastPoint()
       

    def reset(self):
        self.start_point = self.end_point = None
        self.isEmittingPoint = False
        self.rubberBand.reset(QGis.Line)
                       
    
    
    ''' QgsMapTools inherited event functions '''
        
    def canvasPressEvent(self, event):
        ''' On left click, we add a point '''
        
        if event.button()  ==  1:
            # layer = self.canvas.currentLayer()
            layer = self.iface.activeLayer() 
    
            # Declare, that are we going to work
            self.started = True
            
            if layer <> None:
                x = event.pos().x()
                y = event.pos().y()
                selPoint = QPoint(x,y)
    
                # Check something snapped
                (retval,result) = self.snapper.snapToBackgroundLayers(selPoint) #@UnusedVariable
              
                # The point we want to have, is either from snapping result
                if result <> []:
                    point = result[0].snappedVertex
    
                    # If we snapped something, it's either a vertex
                    if result[0].snappedVertexNr <> -1:
                        self.firstTimeOnSegment = True
                
                    # Or a point on a segment, so we have to declare, that a point on segment is found
                    else:
                        self.firstTimeOnSegment = False
    
                # Or its some point from out in the wild
                else:
                    point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)
                    self.firstTimeOnSegment = True
    
                # Bring the rubberband to the cursor i.e. the clicked point
                self.rubberBand.movePoint(point)
    
                # Set a new point to go on with
                self.appendPoint(point)
              
                # Try to remember that this point was on purpose i.e. clicked by the user
                self.lastPointMustStay = True
                self.firstTimeOnSegment = True    
                       
    
    def canvasMoveEvent(self, event):
        
        # Hide highlight
        self.vertexMarker.hide()
            
        # Get the click
        x = event.pos().x()
        y = event.pos().y()
        eventPoint = QPoint(x,y)

        # Snapping        
        (retval,result) = self.snapper.snapToBackgroundLayers(eventPoint)   #@UnusedVariable

        # That's the snapped point
        if result <> []:
            point = QgsPoint(result[0].snappedVertex)

            # Add marker    
            self.vertexMarker.setCenter(point)
            self.vertexMarker.show()
            
        # Check tracing 
        if self.started:
                        
            # Only if the ctrl key is pressed
            if self.mCtrl == True:
                 
                # So if we have found a snapping
                if result <> []:

                    # If it is a vertex, not a point on a segment
                    if result[0].snappedVertexNr <> -1: 
                        self.rubberBand.movePoint(point) 
                        self.appendPoint(point)
                        self.lastPointMustStay = True
                    
                        # The next point found, may  be on a segment
                        self.firstTimeOnSegment = True
                                          
                    # We are on a segment
                    else:
                        self.rubberBand.movePoint(point)
                    
                        # If we are on a new segment, we add the point in any case
                        if self.firstTimeOnSegment:
                            self.appendPoint(point)
                            self.lastPointMustStay = True
                            self.firstTimeOnSegment = False
                    
                        # if we are not on a new segment, we have to test, if this point is really needed
                        else:
                            # but only if we have already enough points
                            if self.rubberBand.numberOfVertices() >=3:
                                num_vertexs = self.rubberBand.numberOfVertices()    
                                lastRbP = self.rubberBand.getPoint(0, num_vertexs-2)
                                nextToLastRbP = self.rubberBand.getPoint(0, num_vertexs-3)                          
                                if not self.pointOnLine(lastRbP, nextToLastRbP, QgsPoint(point)):
                                    self.appendPoint(point)
                                    self.lastPointMustStay = False
                                else:
                                    if not self.lastPointMustStay:
                                        self.rubberBand.removeLastPoint()
                                        self.rubberBand.movePoint(point)
                            else:
                                self.appendPoint(point)
                                self.lastPointMustStay = False
                                self.firstTimeOnSegment = False
          
                else:
                    #if nothing specials happens, just update the rubberband to the cursor position
                    point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform (), x, y)
                    self.rubberBand.movePoint(point)
          
            else:
                ''' In "not-tracing" state, just update the rubberband to the cursor position
                 but we have still to snap to act like the "normal" digitize tool '''
                if result <> []:
                    point = QgsPoint(result[0].snappedVertex)
                
                    # Add marker    
                    self.vertexMarker.setCenter(point)
                    self.vertexMarker.show()

                else:
                    point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(),  x, y)
                
                self.rubberBand.movePoint(point)            
        
        
    def canvasReleaseEvent(self, event):
        ''' With right click the digitizing is finished '''
        
        if event.button() == 2:
      
            # layer = self.canvas.currentLayer()
            layer = self.iface.activeLayer()
            
            x = event.pos().x()
            y = event.pos().y()
            
            if layer <> None and self.started == True: 
                selPoint = QPoint(x,y)
                (retval,result) = self.snapper.snapToBackgroundLayers(selPoint) #@UnusedVariable
        
            if result <> []:
                point = result[0].snappedVertex #@UnusedVariable
            else:
                point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)  #@UnusedVariable
        
            self.sendGeometry()
 
        
    def appendPoint(self, point):
        ''' Don't add the point if it is identical to the last point we added '''
        
        if not (self.lastPoint == point) :      
            self.rubberBand.addPoint(point)
            self.lastPoint = QgsPoint(point)
        else:
            pass
          
    
    def sendGeometry(self):
        
        #layer = self.canvas.currentLayer()
        layer = self.iface.activeLayer()        
        
        coords = []
        self.rubberBand.removeLastPoint()
        
        if QGis.QGIS_VERSION_INT >= 10700:
            [coords.append(self.rubberBand.getPoint(0, i)) for i in range(self.rubberBand.numberOfVertices())]
        else:
            [coords.append(self.rubberBand.getPoint(0,i)) for i in range(1,self.rubberBand.numberOfVertices())]
        
        # On the Fly reprojection, not necessary any more, mapToLayerCoordinates is clever enough on its own
        #layerEPSG = layer.srs().epsg()
        #projectEPSG = self.canvas.mapRenderer().destinationSrs().epsg()
        #if layerEPSG != projectEPSG:
        coords_tmp = coords[:]
        coords = []
        for point in coords_tmp:
            transformedPoint = self.canvas.mapRenderer().mapToLayerCoordinates( layer, point );
            coords.append(transformedPoint)

        # Filter duplicated points
        coords_tmp = coords[:]
        coords = []
        lastPt = None
        for pt in coords_tmp:
            if (lastPt <> pt) :
                coords.append(pt)
                lastPt = pt
                 
        # Add geometry to feature.
        g = QgsGeometry().fromPolyline(coords)

        self.rubberBand.reset(QGis.Line)
        self.started = False
        
        # Write the feature
        self.createFeature(g)
        
        
    def createFeature(self, geom):

        # layer = self.canvas.currentLayer()
        layer = self.iface.activeLayer()        
        provider = layer.dataProvider()
        f = QgsFeature()
        if (geom.isGeosValid()):
            f.setGeometry(geom)
        else:
            reply = QMessageBox.question(self.iface.mainWindow(), 'Feature not valid',
                "The geometry of the feature you just added isn't valid. Do you want to use it anyway?",
            QMessageBox.Yes, QMessageBox.No)
            if reply == QMessageBox.Yes:
                f.setGeometry(geom)
            else:
                return False
      
        # Add attribute fields to feature.
        fields = layer.pendingFields()
        
        try: #API-Break 1.8 vs. 2.0 handling
            attr = f.initAttributes(len(fields))    #@UnusedVariable
            for i in range(len(fields)):
                f.setAttribute(i, provider.defaultValue(i))
              
        except AttributeError: #<=1.8
            # Add attributefields to feature.
            for i in fields:
                f.addAttribute(i, provider.defaultValue(i))
        
        idx = layer.fieldNameIndex('epa_type')
        f[idx] = self.elem_type_type
        
        # Upload changes
        layer.startEditing()
        layer.addFeature(f)
        
        # Control PostgreSQL exceptions
        boolOk = layer.commitChanges()

        # Update canvas        
        self.iface.mapCanvas().refreshAllLayers()

        for layerRefresh in self.iface.mapCanvas().layers():
            layerRefresh.triggerRepaint()
 
        # Capture edit exception
        if boolOk:
                        
            # Spatial query to retrieve last added line, start searchingcandidates
            cands = layer.getFeatures(QgsFeatureRequest().setFilterRect(f.geometry().boundingBox()))

            # Iterate on candidates
            for line_feature in cands:
                if line_feature.geometry().equals(f.geometry()):

                    # Highlight
                    layer.setSelectedFeatures([line_feature.id()])

                    # Open form
                    self.iface.openFeatureForm(layer, line_feature)
                    break
        
        else:
            
            # Delete
            layer.rollBack()
            
            # User error
            msg = "Error adding PIPE: Typically this occurs if\n the first point is not located in a existing\n node or feature is out of the defined sectors."
            QMessageBox.information(None, "PostgreSQL error:", msg)

                
    def activate(self):
        self.canvas.setCursor(self.cursor)
  
  
    def deactivate(self):
        try:
            self.rubberBand.reset(QGis.Line)
        except AttributeError:
            pass
        
        