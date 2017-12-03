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
        """ Set geom_type and layer depending selected tab
            @table_object = ['doc' | 'element' ] 
        """
                        
        tab_position = self.dlg.tab_feature.currentIndex()
        if tab_position == 0:
            self.geom_type = "arc"
            
        elif tab_position == 1:
            self.geom_type = "node"
            
        elif tab_position == 2:
            self.geom_type = "connec"

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
        (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
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
            
                