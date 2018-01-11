"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.Qt import QDate
from PyQt4.QtGui import QCompleter, QStringListModel, QAbstractItemView, QTableView
from PyQt4.QtSql import QSqlTableModel
from qgis.core import QgsFeatureRequest
from qgis.gui import QgsMapToolEmitPoint

import os
import sys
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)

import utils_giswater
from parent import ParentAction
from actions.multiple_selection import MultipleSelection  


class ParentManage(ParentAction, MultipleSelection):

    def __init__(self, iface, settings, controller, plugin_dir):  
        """ Class to keep common functions of classes 
            'ManageDocument', 'ManageElement' and 'ManageVisit' of toolbar 'edit' 
        """
        # need to explicitly call base class constructor to avoid
        # that super would resolve __init__ as hinerited class for second
        # base class. See:
        # https://stackoverflow.com/questions/9575409/calling-parent-class-init-with-multiple-inheritance-whats-the-right-way
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        MultipleSelection.__init__(self, iface, controller, {})
                  
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
        self.list_ids['gully'] = []
        self.list_ids['element'] = []


    def reset_layers(self):
        """ Reset list of layers """
        
        self.layers = {}
        self.layers['arc'] = []
        self.layers['node'] = []
        self.layers['connec'] = []
        self.layers['gully'] = []
        self.layers['element'] = []


    def reset_model(self, table_object, geom_type):
        """ Reset model of the widget """ 

        table_relation = table_object + "_x_" + geom_type
        widget_name = "tbl_" + table_relation          
        widget = utils_giswater.getWidget(widget_name)
        if widget:              
            widget.setModel(None)                                 
                    
            
    def remove_selection(self, remove_groups=True):
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
        layer = self.controller.get_layer_by_tablename("v_edit_element")
        if layer:
            layer.removeSelection()
            
        if self.project_type == 'ud':
            layer = self.controller.get_layer_by_tablename("v_edit_gully")
            if layer:
                layer.removeSelection()            

        if remove_groups:
            for layer in self.layers['arc']:
                layer.removeSelection()
            for layer in self.layers['node']:
                layer.removeSelection()
            for layer in self.layers['connec']:
                layer.removeSelection()
            for layer in self.layers['gully']:
                layer.removeSelection()
            for layer in self.layers['element']:
                layer.removeSelection()

        self.canvas.refresh()
    
    
    def reset_widgets(self, table_object):    
        """ Clear contents of input widgets """
        
        if table_object == "doc":
            utils_giswater.setWidgetText("doc_type", "")
            utils_giswater.setWidgetText("observ", "")
            utils_giswater.setWidgetText("path", "")   
        elif table_object == "element":
            utils_giswater.setWidgetText("elementcat_id", "")
            utils_giswater.setWidgetText("state", "")
            utils_giswater.setWidgetText("expl_id","")
            utils_giswater.setWidgetText("ownercat_id", "")
            utils_giswater.setWidgetText("location_type", "")
            utils_giswater.setWidgetText("buildercat_id", "")
            utils_giswater.setWidgetText("workcat_id", "")
            utils_giswater.setWidgetText("workcat_id_end", "")
            utils_giswater.setWidgetText("comment", "")
            utils_giswater.setWidgetText("observ", "")
            utils_giswater.setWidgetText("path", "")
            utils_giswater.setWidgetText("rotation", "")                                    
            utils_giswater.setWidgetText("verified", "")
                    
    
    def fill_widgets(self, table_object, row):    
        """ Fill input widgets with data int he @row """
        
        if table_object == "doc":
            
            utils_giswater.setWidgetText("doc_type", row["doc_type"])
            utils_giswater.setWidgetText("observ",  row["observ"])
            utils_giswater.setWidgetText("path",  row["path"])  
             
        elif table_object == "element":
                    
            state = ""  
            if row['state']:          
                sql = ("SELECT name FROM " + self.schema_name + ".value_state"
                       " WHERE id = '" + str(row['state']) + "'")
                row_aux = self.controller.get_row(sql)
                if row_aux:
                    state = row_aux[0]
    
            expl_id = ""
            if row['expl_id']:
                sql = ("SELECT name FROM " + self.schema_name + ".exploitation"
                       " WHERE expl_id = '" + str(row['expl_id']) + "'")
                row_aux = self.controller.get_row(sql)
                if row_aux:
                    expl_id = row_aux[0]                

            utils_giswater.setWidgetText("state", state)
            utils_giswater.setWidgetText("expl_id", expl_id)
            utils_giswater.setWidgetText("elementcat_id", row['elementcat_id'])
            utils_giswater.setWidgetText("ownercat_id", row['ownercat_id'])
            utils_giswater.setWidgetText("location_type", row['location_type'])
            utils_giswater.setWidgetText("buildercat_id", row['buildercat_id'])
            utils_giswater.setWidgetText("workcat_id", row['workcat_id'])
            utils_giswater.setWidgetText("workcat_id_end", row['workcat_id_end'])
            utils_giswater.setWidgetText("comment", row['comment'])
            utils_giswater.setWidgetText("observ", row['observ'])
            utils_giswater.setWidgetText("link", row['link'])
            utils_giswater.setWidgetText("verified", row['verified'])
            utils_giswater.setWidgetText("rotation", row['rotation'])
            if str(row['undelete'])== 'True':
                self.dlg.undelete.setChecked(True)
            builtdate = QDate.fromString(str(row['builtdate']), 'yyyy-MM-dd')
            enddate = QDate.fromString(str(row['enddate']), 'yyyy-MM-dd')

            self.dlg.builtdate.setDate(builtdate)
            self.dlg.enddate.setDate(enddate)
            
              
    def get_records_geom_type(self, table_object, geom_type):
        """ Get records of @geom_type associated to selected @table_object """
        
        object_id = utils_giswater.getWidgetText(table_object + "_id")        
        table_relation = table_object + "_x_" + geom_type
        widget_name = "tbl_" + table_relation           
        
        exists = self.controller.check_table(table_relation)
        if not exists:
            self.controller.log_info("Not found: " + str(table_relation))
            return
              
        sql = ("SELECT " + geom_type + "_id"
               " FROM " + self.schema_name + "." + table_relation + ""
               " WHERE " + table_object + "_id = '" + str(object_id) + "'")
        rows = self.controller.get_rows(sql, log_info=False)
        if rows:
            for row in rows:
                self.list_ids[geom_type].append(str(row[0]))
                self.ids.append(str(row[0]))

            expr_filter = self.get_expr_filter(geom_type)
            self.set_table_model(widget_name, geom_type, expr_filter)   
            
                                
    def exist_object(self, table_object):
        """ Check if selected object (document or element) already exists """
        
        # Reset list of selected records
        self.reset_lists()
        
        field_object_id = "id"
        if table_object == "element":
            field_object_id = table_object + "_id"           
        object_id = utils_giswater.getWidgetText(table_object + "_id")

        # Check if we already have data with selected object_id
        sql = ("SELECT * " 
            " FROM " + self.schema_name + "." + str(table_object) + ""
            " WHERE " + str(field_object_id) + " = '" + str(object_id) + "'")
        row = self.controller.get_row(sql, log_info=False)

        # If object_id not found: Clear data
        if not row:    
            self.reset_widgets(table_object)            
            self.remove_selection(True)        
            self.reset_model(table_object, "arc")      
            self.reset_model(table_object, "node")      
            self.reset_model(table_object, "connec")
            self.reset_model(table_object, "element")
            if self.project_type == 'ud':
                self.reset_model(table_object, "gully")
            return            

        # Fill input widgets with data of the @row
        self.fill_widgets(table_object, row)

        # Check related 'arcs'
        self.get_records_geom_type(table_object, "arc")
        
        # Check related 'nodes'
        self.get_records_geom_type(table_object, "node")
        
        # Check related 'connecs'
        self.get_records_geom_type(table_object, "connec")

        # Check related 'elements'
        self.get_records_geom_type(table_object, "element")

        # Check related 'gullys'
        if self.project_type == 'ud':        
            self.get_records_geom_type(table_object, "gully")


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
        """ Get coordinates of selected point """
        
        self.x = point.x()
        self.y = point.y()
        message = "Geometry has been added!"
        self.controller.show_info(message)
        self.emit_point.canvasClicked.disconnect()
        
        
    def tab_feature_changed(self, table_object):
        """ Set geom_type and layer depending selected tab
            @table_object = ['doc' | 'element' | 'cat_work']
        """
                        
        tab_position = self.dlg.tab_feature.currentIndex()
        if tab_position == 0:
            self.geom_type = "arc"   
        elif tab_position == 1:
            self.geom_type = "node"
        elif tab_position == 2:
            self.geom_type = "connec"
        elif tab_position == 3:
            self.geom_type = "element"
        elif tab_position == 4:
            self.geom_type = "gully"

        self.hide_generic_layers()                  
        widget_name = "tbl_" + table_object + "_x_" + str(self.geom_type)
        viewname = "v_edit_" + str(self.geom_type)
        self.widget = utils_giswater.getWidget(widget_name)
            
        # Adding auto-completion to a QLineEdit
        self.set_completer_feature_id(self.geom_type, viewname)
        
        self.iface.actionPan().trigger()    
        

    def set_completer_object(self, table_object):
        """ Set autocomplete of widget @table_object + "_id" 
            getting id's from selected @table_object 
        """
                     
        widget = utils_giswater.getWidget(table_object + "_id")
        if not widget:
            return
        
        # Set SQL
        field_object_id = "id"
        if table_object == "element":
            field_object_id = table_object + "_id"
        sql = ("SELECT DISTINCT(" + field_object_id + ")"
               " FROM " + self.schema_name + "." + table_object)
        row = self.controller.get_rows(sql)
        for i in range(0, len(row)):
            aux = row[i]
            row[i] = str(aux[0])

        # Set completer and model: add autocomplete in the widget
        self.completer = QCompleter()
        widget.setCompleter(self.completer)
        model = QStringListModel()
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
        
        # Set expression filter with features in the list        
        expr_filter = field_id + " IN ("
        for i in range(len(list_ids)):
            expr_filter += "'" + str(list_ids[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"
            
        # Check expression
        (is_valid, expr) = self.check_expression(expr_filter)
        if not is_valid:
            return None

        # Select features of layers applying @expr
        self.select_features_by_ids(geom_type, expr, has_group=True)
        
        return expr_filter


    def reload_table(self, table_object, geom_type, expr_filter):
        """ Reload @widget with contents of @tablename applying selected @expr_filter """
                         
        widget_name = "tbl_" + table_object + "_x_" + geom_type
        widget = utils_giswater.getWidget(widget_name) 
        if not widget:
            self.controller.log_info("Widget not found", parameter=widget_name)
            return None
        
        expr = self.set_table_model(widget, geom_type, expr_filter)
        return expr
    
    
    def set_table_model(self, widget_name, geom_type, expr_filter):
        """ Sets a TableModel to @widget_name attached to 
            @table_name and filter @expr_filter 
        """
        
        expr = None
        if expr_filter:
            # Check expression          
            (is_valid, expr) = self.check_expression(expr_filter)    #@UnusedVariable
            if not is_valid:
                return expr              

        # Set a model with selected filter expression
        table_name = "v_edit_" + geom_type        
        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name  
        
        # Set the model
        model = QSqlTableModel();
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.select()
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())
            return expr
        
        # Attach model to selected widget
        widget = utils_giswater.getWidget(widget_name) 
        if not widget:
            self.controller.log_info("Widget not found", parameter=widget_name)
            return expr
        
        if expr_filter:
            widget.setModel(model)
            widget.model().setFilter(expr_filter)
            widget.model().select()        
        else:
            widget.setModel(None)
        
        return expr      
        
    
    def select_features_by_ids(self, geom_type, expr, has_group=False):
        """ Select features of layers of group @geom_type applying @expr """

        # Build a list of feature id's and select them
        if not has_group:
            viewname = "v_edit_" + str(geom_type)
            layer = self.controller.get_layer_by_tablename(viewname)
            it = layer.getFeatures(QgsFeatureRequest(expr))
            id_list = [i.id() for i in it]
            layer.selectByIds(id_list)
        else:
            for layer in self.layers[geom_type]:
                it = layer.getFeatures(QgsFeatureRequest(expr))
                id_list = [i.id() for i in it]
                layer.selectByIds(id_list)

        
    def insert_feature(self, table_object):
        """ Select feature with entered id. Set a model with selected filter.
            Attach that model to selected table
        """
        
        self.disconnect_signal_selection_changed()            
                    
        # Clear list of ids
        self.ids = []
        field_id = self.geom_type + "_id"

        feature_id = utils_giswater.getWidgetText("feature_id")
        if feature_id == 'null':
            message = "You need to enter a feature id"
            self.controller.show_info_box(message)
            return

        # Iterate over all layers of the group
        for layer in self.layers[self.geom_type]:
            if layer.selectedFeatureCount() > 0:
                # Get selected features of the layer
                features = layer.selectedFeatures()
                for feature in features:
                    # Append 'feature_id' into the list
                    selected_id = feature.attribute(field_id)
                    self.ids.append(selected_id)
            if feature_id not in self.ids:
                # If feature id doesn't exist in list -> add
                self.ids.append(str(feature_id))

        # Set expression filter with features in the list
        expr_filter = "\"" + field_id + "\" IN ("
        for i in range(len(self.ids)):
            expr_filter += "'" + str(self.ids[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"

        # Check expression
        (is_valid, expr) = self.check_expression(expr_filter)
        if not is_valid:
            return

        # Select features with previous filter
        # Build a list of feature id's and select them
        for layer in self.layers[self.geom_type]:
            it = layer.getFeatures(QgsFeatureRequest(expr))
            id_list = [i.id() for i in it]
            if len(id_list) > 0:
                layer.selectByIds(id_list)

        # Reload contents of table 'tbl_???_x_@geom_type'
        self.reload_table(table_object, self.geom_type, expr_filter)

        # Update list
        self.list_ids[self.geom_type] = self.ids
        
        self.connect_signal_selection_changed(table_object)           
        
             
    def delete_records(self, table_object):
        """ Delete selected elements of the table """          
                    
        self.disconnect_signal_selection_changed()
                            
        widget_name = "tbl_" + table_object + "_x_" + self.geom_type
        widget = utils_giswater.getWidget(widget_name)
        if not widget:
            self.controller.show_warning("Widget not found", parameter=widget_name)
            return
        
        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_info_box(message)
            return

        self.ids = self.list_ids[self.geom_type]
        field_id = self.geom_type + "_id"
        
        del_id = []
        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_feature = widget.model().record(row).value(field_id)
            inf_text += str(id_feature) + ", "
            list_id = list_id + "'" + str(id_feature) + "', "
            del_id.append(id_feature)
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        message = "Are you sure you want to delete these records?"
        answer = self.controller.ask_question(message, "Delete records", inf_text)
        if answer:
            for el in del_id:
                self.ids.remove(el)
             
        expr_filter = None
        expr = None
        if len(self.ids) > 0:                    
                
            # Set expression filter with features in the list
            expr_filter = "\"" + field_id + "\" IN ("
            for i in range(len(self.ids)):
                expr_filter += "'" + str(self.ids[i]) + "', "
            expr_filter = expr_filter[:-2] + ")"
            
            # Check expression
            (is_valid, expr) = self.check_expression(expr_filter) #@UnusedVariable
            if not is_valid:
                return           

        # Update model of the widget with selected expr_filter   
        self.reload_table(table_object, self.geom_type, expr_filter)                 

        # Select features with previous filter
        # Build a list of feature id's and select them
        for layer in self.layers[self.geom_type]:
            it = layer.getFeatures(QgsFeatureRequest(expr))
            id_list = [i.id() for i in it]
            if len(id_list) > 0:
                layer.selectByIds(id_list)
        
        # Update list
        self.list_ids[self.geom_type] = self.ids                        
        
        self.connect_signal_selection_changed(table_object)                              
                
                                
    def manage_close(self, table_object, cur_active_layer=None):
        """ Close dialog and disconnect snapping """
        
        if cur_active_layer:
            self.iface.setActiveLayer(cur_active_layer)
        self.remove_selection(True)       
        self.reset_model(table_object, "arc")      
        self.reset_model(table_object, "node")      
        self.reset_model(table_object, "connec")   
        self.reset_model(table_object, "element")
        if self.project_type == 'ud':        
            self.reset_model(table_object, "gully")      
        self.close_dialog()   
        self.hide_generic_layers()
        self.disconnect_snapping()   
        self.disconnect_signal_selection_changed()         
                    

    def selection_init(self, table_object):
        """ Set canvas map tool to an instance of class 'MultipleSelection' """
        
        multiple_selection = MultipleSelection(self.iface, self.controller, self.layers[self.geom_type], 
                                             parent_manage=self, table_object=table_object)       
        self.canvas.setMapTool(multiple_selection)              
        self.disconnect_signal_selection_changed()        
        self.connect_signal_selection_changed(table_object)
        cursor = self.get_cursor_multiple_selection()
        self.canvas.setCursor(cursor) 


    def selection_changed(self, table_object, geom_type):
        """ Slot function for signal 'canvas.selectionChanged' """
        
        self.disconnect_signal_selection_changed()
                    
        field_id = geom_type + "_id"
        self.ids = []
        
        # Iterate over all layers of the group
        for layer in self.layers[self.geom_type]:
            if layer.selectedFeatureCount() > 0:
                # Get selected features of the layer
                features = layer.selectedFeatures()
                for feature in features:
                    # Append 'feature_id' into the list
                    selected_id = feature.attribute(field_id)
                    if selected_id not in self.ids:                    
                        self.ids.append(selected_id)
        
        if geom_type == 'arc':
            self.list_ids['arc'] = self.ids
        elif geom_type == 'node':
            self.list_ids['node'] = self.ids
        elif geom_type == 'connec':
            self.list_ids['connec'] = self.ids
        elif geom_type == 'gully':
            self.list_ids['gully'] = self.ids
        elif geom_type == 'element':
            self.list_ids['element'] = self.ids

        expr_filter = None
        if len(self.ids) > 0:
            # Set 'expr_filter' with features that are in the list
            expr_filter = "\"" + field_id + "\" IN ("
            for i in range(len(self.ids)):
                expr_filter += "'" + str(self.ids[i]) + "', "
            expr_filter = expr_filter[:-2] + ")"
    
            # Check expression
            (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
            if not is_valid:
                return                                           
                          
            self.select_features_by_ids(geom_type, expr, True)
                        
        # Reload contents of table 'tbl_@table_object_x_@geom_type'
        self.reload_table(table_object, geom_type, expr_filter)                    
                
        # Remove selection in generic 'v_edit' layers
        self.remove_selection(False)
                    
        self.connect_signal_selection_changed(table_object)           
                        
                        
    def disconnect_snapping(self):
        """ Select 'Pan' as current map tool and disconnect snapping """
        
        try:
            self.iface.actionPan().trigger()     
            self.canvas.xyCoordinates.disconnect()      
            if self.emit_point:       
                self.emit_point.canvasClicked.disconnect()
        except:     
            pass
            
            
    def fill_table_object(self, widget, table_name):
        """ Set a model with selected filter. Attach that model to selected table """

        # Set model
        model = QSqlTableModel();
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.sort(0, 1)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

        # Attach model to table view
        widget.setModel(model)
                     

    def filter_by_id(self, widget_table, widget_txt, table_object):

        field_object_id = "id"
        if table_object == "element":
            field_object_id = table_object + "_id"        
        object_id = utils_giswater.getWidgetText(widget_txt)
        if object_id != 'null':
            expr = field_object_id + " = '" + str(object_id) + "'"
            # Refresh model with selected filter
            widget_table.model().setFilter(expr)
            widget_table.model().select()
        else:
            self.fill_table_object(widget_table, self.schema_name + "." + table_object)
            
            
    def delete_selected_object(self, widget, table_object):
        """ Delete selected objects of the table (by object_id) """
        
        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        inf_text = ""
        list_id = ""
        field_object_id = "id"
        if table_object == "element":
            field_object_id = table_object + "_id"     
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = widget.model().record(row).value(str(field_object_id))
            inf_text+= str(id_) + ", "
            list_id = list_id + "'" + str(id_) + "', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        message = "Are you sure you want to delete these records?"
        answer = self.controller.ask_question(message, "Delete records", inf_text)
        if answer:
            sql = ("DELETE FROM " + self.schema_name + "." + table_object + ""
                   " WHERE " + field_object_id + " IN (" + list_id + ")")
            self.controller.execute_sql(sql, log_sql=True)
            widget.model().select()     
            
            
    def open_selected_object(self, widget, table_object):
        """ Open object form with selected record of the table """

        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        
        row = selected_list[0].row()

        # Get object_id from selected row
        field_object_id = "id"
        widget_id = table_object + "_id"
        if table_object == "element":
            field_object_id = table_object + "_id"      
        if table_object == "om_visit":
            widget_id = "visit_id"      
        selected_object_id = widget.model().record(row).value(field_object_id)

        # Close this dialog and open selected object
        self.dlg_man.close()
        
        if table_object == "doc":
            self.manage_document()
        elif table_object == "element":
            self.manage_element()
        elif table_object == "om_visit":
            self.manage_visit()
            
        utils_giswater.setWidgetText(widget_id, selected_object_id)
             
                                    
    def set_selectionbehavior(self, dialog):
        
        # Get objects of type: QTableView
        widget_list = dialog.findChildren(QTableView)
        for widget in widget_list:
            widget.setSelectionBehavior(QAbstractItemView.SelectRows) 
        
                       
    def set_layer_active_visible(self, layer, visible=True):    
        """ Set layer active and visible """
           
        self.iface.setActiveLayer(layer)                      
        self.iface.legendInterface().setLayerVisible(layer, visible)          
        
    
    def hide_generic_layers(self, visible=False):       
        """ Hide generic layers """
        
        layer = self.controller.get_layer_by_tablename("v_edit_arc")
        if layer:
            self.iface.legendInterface().setLayerVisible(layer, visible)
        layer = self.controller.get_layer_by_tablename("v_edit_node")
        if layer:
            self.iface.legendInterface().setLayerVisible(layer, visible)
        layer = self.controller.get_layer_by_tablename("v_edit_connec")
        if layer:
            self.iface.legendInterface().setLayerVisible(layer, visible)
        layer = self.controller.get_layer_by_tablename("v_edit_element")
        if layer:
            self.iface.legendInterface().setLayerVisible(layer, visible)
            
        if self.project_type == 'ud':
            layer = self.controller.get_layer_by_tablename("v_edit_gully")
            if layer:
                self.iface.legendInterface().setLayerVisible(layer, visible)            
        
    
    def connect_signal_selection_changed(self, table_object):
        """ Connect signal selectionChanged """
        
        try:
            self.canvas.selectionChanged.connect(partial(self.selection_changed, table_object, self.geom_type))  
        except Exception:    
            pass
    
    
    def disconnect_signal_selection_changed(self):
        """ Disconnect signal selectionChanged """
        
        try:
            self.canvas.selectionChanged.disconnect()  
        except Exception:   
            pass
        
