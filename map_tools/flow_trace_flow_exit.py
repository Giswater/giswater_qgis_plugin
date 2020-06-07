"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsExpression, QgsFeatureRequest, QgsProject
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QColor

from .parent import ParentMapTool
from ..actions.add_layer import AddLayer


class FlowTraceFlowExitMapTool(ParentMapTool):
    """ Button 56: Flow trace
        Button 57: Flow exit
    """    

    def __init__(self, iface, settings, action, index_action):  
        """ Class constructor """
        
        # Call ParentMapTool constructor     
        super(FlowTraceFlowExitMapTool, self).__init__(iface, settings, action, index_action)

        self.layers_added = []
        
    def check_for_layers(self):
        self.needed_layers = {"v_anl_flow_node":{"field_cat":"context", "field_id":"id", "size":2, "color_values":{'Flow exit': QColor(235, 74, 117), 'Flow trace': QColor(235, 167, 48)}},
                              "v_anl_flow_gully":{"field_cat":"context", "field_id":"gully_id", "size":2, "color_values":{'Flow exit': QColor(235, 74, 117), 'Flow trace': QColor(235, 167, 48)}},
                              "v_anl_flow_connec":{"field_cat":"context", "field_id":"connec_id", "size":2,"color_values":{'Flow exit': QColor(235, 74, 117), 'Flow trace': QColor(235, 167, 48)}},
                              "v_anl_flow_arc":{"field_cat":"context", "field_id":"id", "size":0.86, "color_values":{'Flow exit': QColor(235, 74, 117), 'Flow trace': QColor(235, 167, 48)}}}

        self.add_layer = AddLayer(self.iface, self.settings, self.controller, self.plugin_dir)
        for layer_name, values in self.needed_layers.items():
            layer = self.controller.get_layer_by_tablename(layer_name)
            if not layer:
                self.add_layer.from_postgres_to_toc(layer_name, field_id=values['field_id'])
                layer = self.controller.get_layer_by_tablename(layer_name)
                self.layers_added.append(layer)
                self.add_layer.categoryze_layer(layer, values['field_cat'], values['size'], values['color_values'], ['Flow exit', 'Flow trace'])
                self.controller.set_layer_visible(layer, False)



    """ QgsMapTools inherited event functions """

    def canvasMoveEvent(self, event):

        # Hide marker and get coordinates
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(event)

        # Snapping
        self.current_layer = None
        result = self.snapper_manager.snap_to_background_layers(event_point)
        if self.snapper_manager.result_is_valid():
            layer = self.snapper_manager.get_snapped_layer(result)
            # Check if feature belongs to 'node' group
            exist = self.snapper_manager.check_node_group(layer)

            if exist:
                self.snapper_manager.add_marker(result, self.vertex_marker)
                # Data for function
                self.current_layer = layer
                self.snapped_feat = self.snapper_manager.get_snapped_feature(result)


    def canvasReleaseEvent(self, event):
        """ With left click the digitizing is finished """
        
        if event.button() == Qt.LeftButton and self.current_layer:

            # Execute SQL function
            if self.index_action == '56':
                function_name = "gw_fct_flow_trace"
            else:
                function_name = "gw_fct_flow_exit"
                
            elem_id = self.snapped_feat.attribute('node_id')
            feature_id = f'"id":["{elem_id}"]'
            body = self.create_body(feature=feature_id)
            result = self.controller.get_json(function_name, body, log_sql=True)
            if not result: return

            for layer_name in result['body']['data']['setVisibleLayers']:
                layer = self.controller.get_layer_by_tablename(layer_name)
                if layer:
                    self.controller.set_layer_visible(layer)
                    if layer in self.layers_added:
                        values = self.needed_layers[layer.name()]
                        self.add_layer.categoryze_layer(layer, values['field_cat'], values['size'], values['color_values'])

            self.layers_added = []

            # Refresh map canvas
            self.refresh_map_canvas()

            # Set action pan   
            self.set_action_pan()


    def select_features(self, elem_type):
 
        if self.index_action == '56':
            tablename = f"anl_flow_{elem_type}"
            where = " WHERE context = 'Flow trace'"
        else:
            tablename = f"anl_flow_{elem_type}"
            where = " WHERE context = 'Flow exit'"
            
        sql = f"SELECT * FROM {tablename}"
        sql = sql + where
        sql += f" ORDER BY {elem_type}_id"
        rows = self.controller.get_rows(sql)
        if not rows:
            return
            
        # Build an expression to select them
        aux = f'"{elem_type}_id" IN ('
        for row in rows:
            aux += f"'{row[1]}', "
        aux = aux[:-2] + ")"

        # Get a featureIterator from this expression
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = "Expression Error"
            self.controller.show_warning(message, parameter=expr.parserErrorString())
            return

        # Select features with these id's
        tablename = f'v_edit_{elem_type}'
        layer = self.controller.get_layer_by_tablename(tablename)
        if layer:
            it = layer.getFeatures(QgsFeatureRequest(expr))
            # Build a list of feature id's from the previous result
            id_list = [i.id() for i in it]
            # Select features with these id's
            layer.selectByIds(id_list)


    def activate(self):

        # Check button
        self.action().setChecked(True)

        # Set main snapping layers
        self.snapper_manager.set_snapping_layers()

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Clear snapping
        self.snapper_manager.enable_snapping()

        # Set snapping to node
        self.snapper_manager.snap_to_node()

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            if self.index_action == '56':
                message = "Select a node and click on it, the upstream nodes are computed"
            else:
                message = "Select a node and click on it, the downstream nodes are computed"
            self.controller.show_info(message)
        self.check_for_layers()
        # Control current layer (due to QGIS bug in snapping system)
        if self.canvas.currentLayer() is None:
            layer = self.controller.get_layer_by_tablename('v_edit_node')
            if layer:
                self.iface.setActiveLayer(layer)


    def deactivate(self):

        # Call parent method     
        ParentMapTool.deactivate(self)

