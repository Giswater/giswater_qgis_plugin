"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QCompleter, QStringListModel, QColor
from qgis.core import QgsFeatureRequest
from qgis.gui import QgsMapToolEmitPoint, QgsMapCanvasSnapper, QgsVertexMarker

import os
import sys
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)

import utils_giswater
from snapping import Snapping                           # @UnresolvedImport
from parent import ParentAction


class ParentManage(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):  
        """ Class to keep common functions of classes 
            'EditDocument', 'EditElement' and 'EditVisit' of toolbar 'edit' 
        """

        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
                  
        # Vertex marker
        self.snapper = QgsMapCanvasSnapper(self.iface.mapCanvas())
        self.vertex_marker = QgsVertexMarker(self.iface.mapCanvas())
        self.vertex_marker.setColor(QColor(255, 0, 255))
        self.vertex_marker.setIconSize(11)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)
        self.vertex_marker.setPenWidth(3)
         
        # Get table or view names from config file                 
        self.get_tables_from_config()
                  
        self.x = ""
        self.y = ""
        self.canvas = self.iface.mapCanvas()
     
     
    def reset_lists(self):
        """ Reset list of selected records """
        
        self.ids = []
        self.list_ids = {}
        self.list_ids['arc'] = []
        self.list_ids['node'] = []
        self.list_ids['connec'] = [] 
        
        
    def reset_model(self, table_object, geom_type):
        """ Reset model of the widget """ 

        table_relation = table_object + "_x_" + geom_type
        widget_name = "tbl_" + table_relation          
        widget = utils_giswater.getWidget(widget_name)
        if widget:              
            widget.setModel(None)                                 
                    
            
    def remove_selection(self):
        """ Remove all previous selections """
                  
        for layer in self.group_pointers_arc:
            layer.removeSelection()
        for layer in self.group_pointers_node:
            layer.removeSelection()
        for layer in self.group_pointers_connec:
            layer.removeSelection()
            
        layer = self.controller.get_layer_by_tablename("v_edit_arc")
        if layer:
            layer.removeSelection()
        layer = self.controller.get_layer_by_tablename("v_edit_node")
        if layer:
            layer.removeSelection()
        layer = self.controller.get_layer_by_tablename("v_edit_connec")
        if layer:
            layer.removeSelection()
            
        self.canvas.refresh()
        
                                     
    def get_tables_from_config(self):
        """ Get table or view names from config file """
        
        self.table_arc = self.settings.value('db/table_arc', 'v_edit_arc')
        self.table_node = self.settings.value('db/table_node', 'v_edit_node')
        self.table_connec = self.settings.value('db/table_connec', 'v_edit_connec')
        self.table_gully = self.settings.value('db/table_gully', 'v_edit_gully')

        self.table_man_arc = self.settings.value('db/table_man_arc', 'v_edit_man_arc')
        self.table_man_node = self.settings.value('db/table_man_node', 'v_edit_man_node')
        self.table_man_connec = self.settings.value('db/table_man_connec', 'v_edit_man_connec')
        self.table_man_gully = self.settings.value('db/table_man_gully', 'v_edit_man_gully')

        self.table_version = self.settings.value('db/table_version', 'version')

        # Tables connec_group
        self.table_wjoin = self.settings.value('db/table_wjoin', 'v_edit_man_wjoin')
        self.table_tap = self.settings.value('db/table_tap', 'v_edit_man_tap')
        self.table_greentap = self.settings.value('db/table_greentap', 'v_edit_man_greentap')
        self.table_fountain = self.settings.value('db/table_fountain', 'v_edit_man_fountain')

        # Tables node_group
        self.table_tank = self.settings.value('db/table_tank', 'v_edit_man_tank')
        self.table_pump = self.settings.value('db/table_pump', 'v_edit_man_pump')
        self.table_source = self.settings.value('db/table_source', 'v_edit_man_source')
        self.table_meter = self.settings.value('db/table_meter', 'v_edit_man_meter')
        self.table_junction = self.settings.value('db/table_junction', 'v_edit_man_junction')
        self.table_waterwell = self.settings.value('db/table_waterwell', 'v_edit_man_waterwell')
        self.table_reduction = self.settings.value('db/table_reduction', 'v_edit_man_reduction')
        self.table_hydrant = self.settings.value('db/table_hydrant', 'v_edit_man_hydrant')
        self.table_valve = self.settings.value('db/table_valve', 'v_edit_man_valve')
        self.table_manhole = self.settings.value('db/table_manhole', 'v_edit_man_manhole')

        # Tables arc_group
        self.table_varc = self.settings.value('db/table_varc', 'v_edit_man_varc')
        self.table_siphon = self.settings.value('db/table_siphon', 'v_edit_man_siphon')
        self.table_conduit = self.settings.value('db/table_conduit', 'v_edit_man_conduit')
        self.table_waccel = self.settings.value('db/table_waccel', 'v_edit_man_waccel')

        self.table_chamber = self.settings.value('db/table_chamber', 'v_edit_man_chamber')
        self.table_chamber_pol = self.settings.value('db/table_chamber', 'v_edit_man_chamber_pol')
        self.table_netgully = self.settings.value('db/table_netgully', 'v_edit_man_netgully')
        self.table_netgully_pol = self.settings.value('db/table_netgully_pol', 'v_edit_man_netgully_pol')
        self.table_netinit = self.settings.value('db/table_netinit', 'v_edit_man_netinit')
        self.table_wjump = self.settings.value('db/table_wjump', 'v_edit_man_wjump')
        self.table_wwtp = self.settings.value('db/table_wwtp', 'v_edit_man_wwtp')
        self.table_wwtp_pol = self.settings.value('db/table_wwtp_pol', 'v_edit_man_wwtp_pol')
        self.table_storage = self.settings.value('db/table_storage', 'v_edit_man_storage')
        self.table_storage_pol = self.settings.value('db/table_storage_pol', 'v_edit_man_storage_pol')
        self.table_outfall = self.settings.value('db/table_outfall', 'v_edit_man_outfall')
        
                          
    def set_layers_by_geom(self):
        """ Set one group of layers for every geom_type """
           
        # TODO: parametrize list of layers
        self.group_layers_arc = ["Pipe", "Varc"]
        self.group_pointers_arc = []
        for layername in self.group_layers_arc:
            layer = self.controller.get_layer_by_layername(layername)
            if layer:
                self.group_pointers_arc.append(layer)

        self.group_layers_node = ["Junction", "Valve", "Manhole", "Tank", "Source", "Pump", 
                                  "Hydrant", "Waterwell", "Meter", "Reduction", "Filter"]
        self.group_pointers_node = []
        for layername in self.group_layers_node:
            layer = self.controller.get_layer_by_layername(layername)
            if layer:
                self.group_pointers_node.append(layer)            
        
        self.group_layers_connec = ["Wjoin", "Greentap", "Fountain", "Tap"]
        self.group_pointers_connec = []
        for layername in self.group_layers_connec:
            layer = self.controller.get_layer_by_layername(layername)
            if layer:
                self.group_pointers_connec.append(layer)            
             
             
    def populate_combo(self, widget, table_name, field_name="id"):
        """ Executes query and fill combo box """

        sql = ("SELECT " + field_name + ""
               " FROM " + self.schema_name + "." + table_name + ""
               " ORDER BY " + field_name)
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(widget, rows)
        if rows:
            utils_giswater.setCurrentIndex(widget, 0)           
        
        
    def add_point(self):
        """ Create the appropriate map tool and connect to the corresponding signal """
        
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.emit_point.canvasClicked.connect(partial(self.get_xy))


    def get_xy(self, point):
        
        # TODO: 
        self.x = point.x()
        self.y = point.y()
        message = "Geometry has been added!"
        self.controller.show_info(message)
        self.emit_point.canvasClicked.disconnect()
        
        
    def tab_feature_changed(self, table_object):
        """ Set signals and group layers depending selected tab
            @table_object = ['doc' | 'element' ] 
        """
                        
        tab_position = self.dlg.tab_feature.currentIndex()
        if tab_position == 0:
            self.geom_type = "arc"
            self.group_pointers = self.group_pointers_arc
            self.group_layers = self.group_layers_arc
            
        elif tab_position == 1:
            self.geom_type = "node"
            self.group_pointers = self.group_pointers_node
            self.group_layers = self.group_layers_node
            
        elif tab_position == 2:
            self.geom_type = "connec"
            self.group_pointers = self.group_pointers_connec
            self.group_layers = self.group_layers_connec

        elif tab_position == 3:
            # TODO: check project if WS-delete gully tab if UD-set parameters
            self.geom_type = "gully"

        widget_name = "tbl_" + table_object + "_x_" + str(self.geom_type)
        viewname = "v_edit_" + str(self.geom_type)
        layer = self.controller.get_layer_by_tablename(viewname) 
        self.layer = layer
        self.iface.setActiveLayer(layer)
        self.widget = utils_giswater.getWidget(widget_name)
            
        # Adding auto-completion to a QLineEdit
        self.set_completer_feature_id(self.geom_type, viewname)
        

    def set_completer_object(self, table_object):
        """ Set autocomplete of widget @table_object + "_id" 
            getting id's from selected @table_object 
        """
             
        # Adding auto-completion to a QLineEdit
        self.completer = QCompleter()
        widget = utils_giswater.getWidget(table_object + "_id")
        widget.setCompleter(self.completer)
        
        model = QStringListModel()
        sql = ("SELECT DISTINCT(id)"
               " FROM " + self.schema_name + "." + table_object)
        row = self.controller.get_rows(sql)
        for i in range(0, len(row)):
            aux = row[i]
            row[i] = str(aux[0])

        model.setStringList(row)
        self.completer.setModel(model)
        

    def set_completer_feature_id(self, geom_type, viewname):
        """ Set autocomplete of widget 'feature_id' 
            getting id's from selected @viewname 
        """
             
        # Adding auto-completion to a QLineEdit
        self.completer = QCompleter()
        self.dlg.feature_id.setCompleter(self.completer)
        model = QStringListModel()

        sql = ("SELECT " + geom_type + "_id"
               " FROM " + self.schema_name + "." + viewname)
        row = self.controller.get_rows(sql)
        for i in range(0, len(row)):
            aux = row[i]
            row[i] = str(aux[0])

        model.setStringList(row)
        self.completer.setModel(model)


    def get_expr_filter(self, geom_type):
        """ Set an expression filter with the contents of the list.
            Set a model with selected filter. Attach that model to selected table 
        """
        
        list_ids = self.list_ids[geom_type]
        field_id = geom_type + "_id"
        if len(list_ids) == 0:
            return None
        
        expr_filter = field_id + " IN ("
        for i in range(len(list_ids)):
            expr_filter += "'" + str(list_ids[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"
            
        # Check expression
        (is_valid, expr) = self.check_expression(expr_filter)
        if not is_valid:
            return None

        # Select features of layers applying @expr
        self.select_features_by_ids(geom_type, expr)
        
        return expr_filter

    
    def select_features_by_ids(self, geom_type, expr):
        """ Select features of layers in @layer_list applying @expr """
        
        viewname = "v_edit_" + str(geom_type)
        layer = self.controller.get_layer_by_tablename(viewname) 
        # Build a list of feature id's and select them
        it = layer.getFeatures(QgsFeatureRequest(expr))
        id_list = [i.id() for i in it]
        layer.selectByIds(id_list)
                    

    def snapping_init(self, table_object):
       
        self.tool = Snapping(self.iface, self.controller, self.layer)
        self.canvas.setMapTool(self.tool)
        self.canvas.selectionChanged.connect(partial(self.snapping_selection, table_object, self.geom_type))
        
        
        # Create the appropriate map tool and connect the gotPoint() signal.
#         self.emit_point = QgsMapToolEmitPoint(self.canvas)
#         self.canvas.setMapTool(self.emit_point)
#         self.snapper = QgsMapCanvasSnapper(self.canvas)        

        # Disconnect previous
        #self.canvas.disconnect(self.canvas, SIGNAL("xyCoordinates(const QgsPoint&)"), self.mouse_move)
        #self.iface.mapCanvas().selectionChanged.disconnect(self.snapping_selection)
        
        
    def snapping_selection(self, table_object, geom_type):

        self.controller.log_info("snapping_selection")
        
        field_id = geom_type + "_id"
        self.ids = []
        layer = self.controller.get_layer_by_tablename("v_edit_" + geom_type)
        if not layer:
            self.controller.log_info("Layer not found")
            return
        
        if layer.selectedFeatureCount() > 0:
            # Get all selected features of the layer
            features = layer.selectedFeatures()
            # Get id from all selected features
            for feature in features:
                element_id = feature.attribute(field_id)
                if element_id in self.ids:
                    message = "Feature id already in the list!"
                    self.controller.show_info_box(message, parameter=element_id)
                else:
                    self.ids.append(element_id)
        
        if geom_type == 'arc':
            self.list_ids['arc'] = self.ids
        elif geom_type == 'node':
            self.list_ids['node'] = self.ids
        elif geom_type == 'connec':
            self.list_ids['connec'] = self.ids
   
        # Set 'expr_filter' with features that are in the list
        expr_filter = "\"" + field_id + "\" IN ("
        for i in range(len(self.ids)):
            expr_filter += "'" + str(self.ids[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"

        # Check expression
        (is_valid, expr) = self.check_expression(expr_filter, True)   #@UnusedVariable
        if not is_valid:
            return                           
        
        # Reload contents of table 'tbl_doc_x_@geom_type'
        self.reload_table(table_object, geom_type, expr_filter)                
        
    
    def disconnect_snapping(self):
        """ Select 'Pan' as current map tool and disconnect snapping """
        
        try:
            self.tool = None
            self.iface.actionPan().trigger()     
            self.canvas.xyCoordinates.disconnect()             
            self.emit_point.canvasClicked.disconnect()
        except Exception as e:   
            self.controller.log_info("Disconnect " + str(e))       
            pass
            
    
    def ed_add_to_feature(self, table_name, value_id):
        """ Add document or element to selected features """

        # Get schema and table name of selected layer
        layer_source = self.controller.get_layer_source(self.layer)
        uri_table = layer_source['table']
        if uri_table is None:
            msg = "Error getting table name from selected layer"
            self.controller.show_warning(msg)
            return

        elem_type = None
        field_id = None

        if self.table_arc in uri_table:
            elem_type = "arc"
            field_id = "arc_id"
        if self.table_node in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_connec in uri_table:
            elem_type = "connec"
            field_id = "connec_id"
        if self.table_gully in uri_table:
            elem_type = "gully"
            field_id = "gully_id"

        if self.table_man_arc in uri_table:
            elem_type = "arc"
            field_id = "arc_id"
        if self.table_man_node in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_man_connec in uri_table:
            elem_type = "connec"
            field_id = "connec_id"
        if self.table_man_gully in uri_table:
            elem_type = "gully"
            field_id = "gully_id"

        if self.table_wjoin in uri_table:
            elem_type = "connec"
            field_id = "connec_id"
        if self.table_tap in uri_table:
            elem_type = "connec"
            field_id = "connec_id"
        if self.table_greentap in uri_table:
            elem_type = "connec"
            field_id = "connec_id"
        if self.table_fountain in uri_table:
            elem_type = "connec"
            field_id = "connec_id"

        if self.table_tank in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_pump in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_source in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_meter in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_junction in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_waterwell in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_reduction in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_hydrant in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_valve in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_manhole in uri_table:
            elem_type = "node"
            field_id = "node_id"

        if self.table_chamber in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_chamber_pol in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_netgully in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_netgully_pol in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_netinit in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_wjump in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_wwtp in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_wwtp_pol in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_storage in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_storage_pol in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_outfall in uri_table:
            elem_type = "node"
            field_id = "node_id"

        if self.table_varc in uri_table:
            elem_type = "arc"
            field_id = "arc_id"
        if self.table_siphon in uri_table:
            elem_type = "arc"
            field_id = "arc_id"
        if self.table_conduit in uri_table:
            elem_type = "arc"
            field_id = "arc_id"
        if self.table_waccel in uri_table:
            elem_type = "arc"
            field_id = "arc_id"
        if 'v_edit_man_pipe' in uri_table:
            elem_type = "arc"
            field_id = "arc_id"

        if field_id is None:
            message = "Current active layer is different than selected features"
            self.controller.show_info(message)
            return

        # Get selected features
        features = self.layer.selectedFeatures()
        for feature in features:
            elem_id = feature.attribute(field_id)
            sql = "SELECT * FROM " + self.schema_name + "." + table_name + "_x_" + elem_type
            sql += " WHERE " + field_id + " = '" + elem_id + "' AND " + value_id + " = " + table_name + "_id"
            row = self.controller.get_row(sql)
            if row is None:
                sql = "INSERT INTO " + self.schema_name + "." + table_name + "_x_" + elem_type + " (" + field_id + ", " + table_name + "_id) "
                sql += " VALUES ('" + elem_id + "', '" + value_id + "')"
                self.controller.execute_sql(sql)
         
                