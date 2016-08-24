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
from qgis.core import QgsPoint, QgsFeatureRequest, QgsExpression, QgsMapLayer, QgsMapLayerRegistry
from qgis.gui import QgsMapCanvasSnapper, QgsMapTool, QgsVertexMarker
from PyQt4.QtCore import Qt, QPoint   
from PyQt4.QtGui import QColor, QCursor   

from snapping_utils import SnappingConfigManager


class MincutMapTool(QgsMapTool):

    def __init__(self, iface, settings, action, index_action):  
        ''' Class constructor '''

        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.settings = settings
        self.index_action = index_action
        QgsMapTool.__init__(self, self.canvas)
        self.setAction(action)

        # Snapper
        self.snapperManager = SnappingConfigManager(self.iface)
        self.snapper = QgsMapCanvasSnapper(self.canvas)

        # Change map tool cursor
        self.cursor = QCursor()
        self.cursor.setShape(Qt.CrossCursor)

        # Get default cursor
        self.stdCursor = self.parent().cursor()

        # And finally we set the mapTool's parent cursor
        #self.parent().setCursor(self.cursor)

        # Vertex marker
        self.vertexMarker = QgsVertexMarker(self.canvas)
        self.vertexMarker.setColor(QColor(255, 25, 25))
        self.vertexMarker.setIconSize(11)
        self.vertexMarker.setIconType(QgsVertexMarker.ICON_BOX) # or ICON_CROSS, ICON_X
        self.vertexMarker.setPenWidth(5)



    ''' QgsMapTools inherited event functions '''

    def canvasMoveEvent(self, event):

        # Hide highlight
        self.vertexMarker.hide()

        # Get the click
        x = event.pos().x()
        y = event.pos().y()
        eventPoint = QPoint(x,y)

        # Snapping        
        (retval,result) = self.snapper.snapToBackgroundLayers(eventPoint)   #@UnusedVariable   
        self.current_layer = None

        # That's the snapped point
        if result <> []:

            # Check Arc or Node
            for snapPoint in result:

                if snapPoint.layer.name() == 'Node' or snapPoint.layer.name() == 'Arc':

                    # Get the point
                    point = QgsPoint(result[0].snappedVertex)

                    # Add marker
                    self.vertexMarker.setCenter(point)
                    self.vertexMarker.show()

                    # Data for function
                    self.current_layer = result[0].layer
                    self.snappFeat = next(
                        result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))

                    # Change symbol
                    if snapPoint.layer.name() == 'Node':
                        self.vertexMarker.setIconType(QgsVertexMarker.ICON_CIRCLE)
                    else:
                        self.vertexMarker.setIconType(QgsVertexMarker.ICON_BOX)

                    break


    def canvasReleaseEvent(self, event):
        
        # With right click the digitizing is finished
        if event.button() == 1 and self.current_layer is not None:

            ''' Button 26. User select one node or arc.
            SQL function fills 3 temporary tables with id's: node_id, arc_id and valve_id
            Returns and integer: error code
            Get these id's and select them in its corresponding layers '''

            # Get selected features and layer type: 'arc' or 'node'
            elem_type = self.current_layer.name().lower()

            feature = self.snappFeat
            elem_id = feature.attribute(elem_type + '_id')

            # Execute SQL function
            function_name = "gw_fct_mincut"
            sql = "SELECT " + self.schema_name + "." + function_name + "('" + str(
                elem_id) + "', '" + elem_type + "');"
            result = self.dao.get_row(sql)
            self.dao.commit()

            # Manage SQL execution result
            if result is None:
                self.showWarning(self.controller.tr("Uncatched error. Open PotgreSQL log file to get more details"))
                return
            elif result[0] == 0:
                # Get 'arc' and 'node' list and select them
                self.mg_flow_trace_select_features(self.layer_arc, 'arc')
                self.mg_flow_trace_select_features(self.layer_node, 'node')
            elif result[0] == 1:
                self.showWarning(self.controller.tr("Parametrize error type 1"))
                return
            else:
                self.showWarning(self.controller.tr("Undefined error"))
                return

                # Refresh map canvas
            self.iface.mapCanvas().refresh()


    def mg_flow_trace_select_features(self, layer, elem_type):

        sql = "SELECT * FROM " + self.schema_name + ".anl_mincut_" + elem_type + " ORDER BY " + elem_type + "_id"
        rows = self.dao.get_rows(sql)
        self.dao.commit()

        # Build an expression to select them
        aux = "\"" + elem_type + "_id\" IN ("
        for elem in rows:
            aux += elem[0] + ", "
        aux = aux[:-2] + ")"

        # Get a featureIterator from this expression:
        expr = QgsExpression(aux)
        if expr.hasParserError():
            self.showWarning("Expression Error: " + str(expr.parserErrorString()))
            return
        it = layer.getFeatures(QgsFeatureRequest(expr))

        # Build a list of feature id's from the previous result
        id_list = [i.id() for i in it]

        # Select features with these id's
        layer.setSelectedFeatures(id_list)


    def set_layer_arc(self, layer_arc):
        ''' Set layer 'Arc' '''
        self.layer_arc = layer_arc


    def set_layer_node(self, layer_node):
        ''' Set layer 'Node' '''
        self.layer_node = layer_node


    def set_schema_name(self, schema_name):
        self.schema_name = schema_name


    def set_dao(self, dao):
        self.dao = dao


    def activate(self):

        print('mincut_map_tool Activate')

        # Check button
        self.action().setChecked(True)

        # Store user snapping configuration
        self.snapperManager.storeSnappingOptions()

        # Clear snapping
        self.snapperManager.clearSnapping()

        # Set snapping to arc and node
        self.snapperManager.snapToArc()
        self.snapperManager.snapToNode()

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Control current layer (due to QGIS bug in snapping system)
        try:
            if self.canvas.currentLayer().type() == QgsMapLayer.VectorLayer:
                self.canvas.setCurrentLayer(QgsMapLayerRegistry.instance().mapLayersByName("Arc")[0])
        except:
            self.canvas.setCurrentLayer(QgsMapLayerRegistry.instance().mapLayersByName("Arc")[0])


    def deactivate(self):

        print('mincut_map_tool Deactivate')

        # Check button
        self.action().setChecked(False)

        # Restore previous snapping
        self.snapperManager.recoverSnappingOptions()

        # Recover cursor
        self.canvas.setCursor(self.stdCursor)

        # Removehighlight
        self.h = None