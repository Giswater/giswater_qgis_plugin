# -*- coding: utf-8 -*-
from qgis.gui import *       # @UnusedWildImport
from PyQt4.QtCore import *   # @UnusedWildImport
from PyQt4.QtGui import *    # @UnusedWildImport
from qgis.core import (QGis, QgsPoint, QgsMapToPixel, QgsMapLayerRegistry, QgsProject)


class MoveNode(QgsMapTool):

    def __init__(self, iface, settings, action, index_action, controller):
        ''' Class constructor '''        
        
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.settings = settings        
        self.index_action = index_action
        self.srid = self.settings.value('status/srid')        
        self.elem_type = self.settings.value('actions/'+str(index_action)+'_elem_type')
        self.show_help = bool(int(self.settings.value('status/show_help', 1)))  
        self.controller = controller
        self.dao = controller.getDao()   
        self.schema_name = self.dao.get_schema_name()   
        
        # Vertex marker
        self.vertexMarker = QgsVertexMarker(self.canvas)
        self.vertexMarker.setColor(QColor(0, 255, 0))
        self.vertexMarker.setIconSize(9)
        self.vertexMarker.setIconType(QgsVertexMarker.ICON_BOX) # or ICON_CROSS, ICON_X
        self.vertexMarker.setPenWidth(5)

        # Snapper
        self.snapper = QgsMapCanvasSnapper(self.canvas)

        # Call superclass constructor and set current action                
        QgsMapTool.__init__(self, self.canvas)
        self.setAction(action) 
   
        # Rubber band
        self.rubberBand = QgsRubberBand(self.canvas, QGis.Line)
        mFillColor = QColor(255, 0, 0);
        self.rubberBand.setColor(mFillColor)
        self.rubberBand.setWidth(3)           
        self.reset()        
        

    def reset(self):
                
        # Selection
        layer = self.canvas.currentLayer()

        if layer is not None:
            layer.setSelectedFeatures([])
            #self.vertexMarker.

        # Graphic elements
        self.rubberBand.reset()
          
            
    def move_node(self, node_id, point):
        ''' Move selected node to the current point '''     
        
        # Update node geometry
        the_geom = "ST_GeomFromText('POINT("+str(point.x())+" "+str(point.y())+")', "+self.srid+")";
        sql = "UPDATE "+self.schema_name+".node SET the_geom = "+the_geom
        sql+= " WHERE node_id = '"+node_id+"'"
        status = self.dao.execute_sql(sql) 
        
        if status:
            
            # Execute function
            sql = "SELECT "+self.schema_name+".gw_fct_node2arc('"+node_id+"')"
            result = self.dao.get_row(sql) 
            self.dao.commit()
            if result is None:
                self.showWarning(self.controller.tr("Uncatched error. Open PotgreSQL log file to get more details"))   
            elif result[0] == 0:
                self.showInfo(self.controller.tr("Node moved successfully"))                
            elif result[0] == 1:
                print self.controller.tr("Node already related with 2 arcs")
        
        else:
            self.showWarning(self.controller.tr("Move node: Error updating geometry")) 
            
        # Refresh map canvas
        self.canvas.currentLayer().triggerRepaint()  


    def showInfo(self, text, duration = 3):
        self.iface.messageBar().pushMessage("", text, QgsMessageBar.INFO, duration)    
    

    def showWarning(self, text, duration = 3):
        self.iface.messageBar().pushMessage("", text, QgsMessageBar.WARNING, duration)    
                
                
    
    ''' QgsMapTool inherited event functions '''    
       
    def activate(self):
        
        # Change pointer
        cursor = QCursor()
        cursor.setShape(Qt.CrossCursor)

        # Get default cursor        
        self.stdCursor = self.parent().cursor()   
 
        # And finally we set the mapTool's parent cursor
        self.parent().setCursor(cursor)

        # Clear selection
        #iface.mapCanvas().setSelectionColor( QColor("red") )
#        layer = self.canvas.currentLayer()
#        layer.select([])

        # Reset
        self.reset()
        
        layerArc = QgsMapLayerRegistry.instance().mapLayersByName( "Arc" )[0]

        if layerArc is not None:

            # it defines the snapping options layerArc : the id of your layer, True : to enable the layer snapping, 2 : options (0: on vertex, 1 on segment, 2: vertex+segment), 1: pixel (0: type of unit on map), 1000 : tolerance, true : avoidIntersection)
            QgsProject.instance().setSnapSettingsForLayer(layerArc.id(), True, 2, 0, 2, True)
        
        # Show help message when action is activated
        if self.show_help:
            self.showInfo(self.controller.tr("Click a point on the map to move selected node"))
            
            
    def deactivate(self):
        try:
            self.rubberBand.reset(QGis.Line)
        except AttributeError:
            pass


    def canvasMoveEvent(self, event):
        ''' Mouse movement event '''      
                        
        # Hide highlight
        self.vertexMarker.hide()
            
        # Get the click
        x = event.pos().x()
        y = event.pos().y()
        eventPoint = QPoint(x,y)

        # Node layer
        layer = self.canvas.currentLayer()

        # Select node or arc
        if layer.selectedFeatureCount() == 0:

            # Snap to node
            (retval,result) = self.snapper.snapToCurrentLayer(eventPoint, 0)
            
            # That's the snapped point
            if result <> []:
                point = QgsPoint(result[0].snappedVertex)

                # Add marker    
                self.vertexMarker.setColor(QColor(0, 255, 0))
                self.vertexMarker.setCenter(point)
                self.vertexMarker.show()
                
                # Set a new point to go on with
                #self.appendPoint(point)
                self.rubberBand.movePoint(point)

            else:
                point =  QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(),  x, y)
                self.rubberBand.movePoint(point)

        else:
                
            # Snap to arc
            result = []
            (retval,result) = self.snapper.snapToBackgroundLayers(eventPoint)
            
            # That's the snapped point
            if (result <> []) and (result[0].layer.name() == "Arc") and (result[0].snappedVertexNr == -1):
            
                point = QgsPoint(result[0].snappedVertex)

                # Add marker
                self.vertexMarker.setColor(QColor(255, 0, 0))
                self.vertexMarker.setCenter(point)
                self.vertexMarker.show()
                
                # Select the arc
                layerArc = QgsMapLayerRegistry.instance().mapLayersByName( "Arc" )[0]
                layerArc.setSelectedFeatures([])
                layerArc.select([result[0].snappedAtGeometry])

                # Bring the rubberband to the cursor i.e. the clicked point
                self.rubberBand.movePoint(point)
        
            else:
                
                # Bring the rubberband to the cursor i.e. the clicked point
                point =  QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(),  x, y)
                self.rubberBand.movePoint(point)


    def canvasReleaseEvent(self, event):
        
        # On left click, take action
        if event.button()  ==  1:
            
            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            eventPoint = QPoint(x,y)

            # Node layer
            layer = self.canvas.currentLayer()

            # Select node or arc
            if layer.selectedFeatureCount() == 0:

                # Snap to node
                (retval,result) = self.snapper.snapToCurrentLayer(eventPoint, 0)
            
                # That's the snapped point
                if result <> []:
            
                    point = QgsPoint(result[0].snappedVertex)

                    layer.select([result[0].snappedAtGeometry])
        
                    # Hide highlight
                    self.vertexMarker.hide()
                    
                    # Set a new point to go on with
                    self.rubberBand.addPoint(point)

            else:
                
                # Snap to arc
                (retval,result) = self.snapper.snapToBackgroundLayers(eventPoint)
            
                # That's the snapped point
                if (result <> []) and (result[0].layer.name() == "Arc"):
            
                    point = QgsPoint(result[0].snappedVertex)

                    # Get clicked point, current layer and number of selected features             
                    count = layer.selectedFeatureCount()     
                    if count > 1:  
                        self.showInfo(self.controller.tr("More than one feature selected. Only the first one will be processed!"))   
                    
                    # Get selected features (nodes)           
                    features = layer.selectedFeatures()
                    feature = features[0]
                    node_id = feature.attribute('node_id') 
        
                    # Move selected node to the current point
                    status = self.move_node(node_id, point)       
            
                    # Rubberband reset
                    self.reset()                    
            
                    # Refresh map canvas
                    self.iface.mapCanvas().refresh()               
        
        # On left click, take action
        if event.button()  ==  2:
            
            # Node layer
            self.reset()
        
        
    def canvasPressEvent(self, event):
        pass    
            
        