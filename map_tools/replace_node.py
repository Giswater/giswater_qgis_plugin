"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from qgis.core import QgsPoint, QgsFeatureRequest, QgsExpression
from qgis.gui import QgsVertexMarker
from PyQt4.QtCore import QPoint, Qt
from PyQt4.QtGui import QColor
from PyQt4.Qt import QDate
from datetime import datetime
import utils_giswater
from map_tools.parent import ParentMapTool


from ..ui.node_replace import Node_replace             # @UnresolvedImport



# def formOpen(dialog, layer, feature):
#     ''' Function called when a feature is identified in the map '''
#
#     global feature_dialog
#     utils_giswater.setDialog(dialog)
#     # Create class to manage Feature Form interaction
#     feature_dialog = ManNodeDialog(dialog, layer, feature)
#     init_config()
#
#
# def init_config():
#     # Manage 'node_type'
#     node_type = utils_giswater.getWidgetText("node_type")
#     utils_giswater.setSelectedItem("node_type", node_type)
#
#     # Manage 'nodecat_id'
#     nodecat_id = utils_giswater.getWidgetText("nodecat_id")
#     utils_giswater.setSelectedItem("nodecat_id", nodecat_id)

class ReplaceNodeMapTool(ParentMapTool):
    ''' Button 44: User select one node. Execute SQL function: 'gw_fct_node_replace' '''

    def __init__(self, iface, settings, action, index_action):
        ''' Class constructor '''

        # Call ParentMapTool constructor
        super(ReplaceNodeMapTool, self).__init__(iface, settings, action, index_action)

        # Vertex marker
        self.vertex_marker = QgsVertexMarker(self.canvas)
        self.vertex_marker.setColor(QColor(255, 25, 25))
        self.vertex_marker.setIconSize(12)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CIRCLE)  # or ICON_CROSS, ICON_X
        self.vertex_marker.setPenWidth(5)

    def init_replace_node_form(self):
        # Create the dialog and signals
        dlg_nodereplace = Node_replace()
        utils_giswater.setDialog(dlg_nodereplace)

        dlg_nodereplace.btn_accept.pressed.connect(dlg_nodereplace.close)
        dlg_nodereplace.btn_cancel.pressed.connect(dlg_nodereplace.close)
        # self.load_settings(self.dlg)
        sql = 'SELECT value FROM ' + self.schema_name + '.config_param_user'
        sql += ' WHERE "cur_user" = current_user AND parameter = ' + "'workcat_vdefault'"
        row = self.controller.get_row(sql)
        dlg_nodereplace.workcat_id_end.setText(row[0])
        self.workcat_id_end_aux = row[0]
        sql = 'SELECT value FROM ' + self.schema_name + '.config_param_user'
        sql += ' WHERE "cur_user" = current_user AND parameter = ' + "'enddate_vdefault'"
        row = self.controller.get_row(sql)
        if row is not None:
            self.enddate_aux = datetime.strptime(row[0], '%Y-%m-%d').date()
        else:
            self.enddate_aux = QDate.currentDate().date()
        dlg_nodereplace.enddate.setDate(self.enddate_aux)

        dlg_nodereplace.exec_()

    ''' QgsMapTools inherited event functions '''

    def canvasMoveEvent(self, event):
        
        # Hide highlight
        self.vertex_marker.hide()

        # Get the click
        x = event.pos().x()
        y = event.pos().y()

        # Plugin reloader bug, MapTool should be deactivated
        try:
            eventPoint = QPoint(x, y)
        except(TypeError, KeyError):
            self.iface.actionPan().trigger()
            return

        # Snapping
        (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable

        # That's the snapped point
        if result:
            # Check for nodes
            for snap_point in result:
                exist = self.snapper_manager.check_node_group(snap_point.layer)
                if exist:
                    # Get the point and add marker
                    point = QgsPoint(result[0].snappedVertex)
                    self.vertex_marker.setCenter(point)
                    self.vertex_marker.show()
                    break


    def canvasReleaseEvent(self, event):

        # With left click the digitizing is finished
        if event.button() == Qt.LeftButton:

            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            event_point = QPoint(x, y)
            snapped_feat = None

            # Snapping
            (retval, result) = self.snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

            # That's the snapped point
            if result <> []:

                # Check Arc or Node
                for snap_point in result:

                    exist = self.snapper_manager.check_node_group(snap_point.layer)
                    # if snap_point.layer.name() == self.layer_node.name():
                    if exist:
                        # Get the point
                        point = QgsPoint(result[0].snappedVertex)  # @UnusedVariable
                        snapped_feat = next(result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))
                        result[0].layer.select([result[0].snappedAtGeometry])
                        break

            if snapped_feat is not None:

                # Get selected features and layer type: 'node'
                feature = snapped_feat
                node_id = feature.attribute('node_id')
                layer = result[0].layer.name()
                view_name = "v_edit_man_"+layer.lower()

                # Ask question before executing
                message = "Are you sure you want to replace selected node with a new one?"
                answer = self.controller.ask_question(message, "Replace node")
                if answer:
                    # Execute SQL function and show result to the user
                    function_name = "gw_fct_node_replace"
                    sql = "SELECT " + self.schema_name + "." + function_name + "('" + str(node_id) + "','"+self.workcat_id_end_aux+"','"+str(self.enddate_aux)+"');"
                    #TODO que pasa si self.controller.get_row(sql) no devuelve nada?

                    new_node_id = self.controller.get_row(sql)
                    status=self.controller.execute_sql(sql)
                    self.controller.log_info("1111: "+str(new_node_id))
                    #self.dao.commit()
                    self.controller.log_info(str("2222"))
                    self.controller.log_info("test 1: "+ str(new_node_id))
                    if status:
                        message = "Node replaced successfully"
                        self.controller.show_info(message)
    
                    # Refresh map canvas
                    self.iface.mapCanvas().refreshAllLayers()
                    for layer_refresh in self.iface.mapCanvas().layers():
                        layer_refresh.triggerRepaint()
                    self.test(new_node_id)


    def test(self, new_node_id):
        # get pointer of node by ID
        aux = "node_id = "
        aux += "'" + str(new_node_id[0]) + "'"  #SI PONESMO AQUI UN ID EXISTENTE ABRE EL FORM DE DICHO ID
        self.controller.log_info(str(aux))
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = "Expression Error: " + str(expr.parserErrorString())
            self.controller.log_info(str(message))
            self.controller.show_warning(message)
            return

        # List of nodes from node_type_cat_type - nodes which we are using
        self.controller.log_info(str("2"))
        # Get a featureIterator from this expression:
        it = self.canvas.currentLayer().getFeatures(QgsFeatureRequest(expr))
        self.controller.log_info(str("3"))
        self.controller.log_info(str(it))
        id_list = [i for i in it]
        self.controller.log_info(str(id_list))
        if id_list != []:
            self.controller.log_info("open")
            self.iface.openFeatureForm(self.canvas.currentLayer(), id_list[0])


    def activate(self):

        # Check button
        self.action().setChecked(True)

        self.init_replace_node_form()

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Clear snapping
        self.snapper_manager.clear_snapping()

        # Set snapping to node
        self.snapper_manager.snap_to_node()

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Select the node inside a pipe by clicking on it and it will be replaced"
            self.controller.show_info(message)

        # Control current layer (due to QGIS bug in snapping system)
        if self.canvas.currentLayer() == None:
            self.iface.setActiveLayer(self.layer_node_man[0])


    def deactivate(self):
          
        # Call parent method     
        ParentMapTool.deactivate(self)
    
