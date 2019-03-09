"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
from builtins import next
from builtins import str

# -*- coding: utf-8 -*-
from qgis.core import QgsPoint, QgsFeatureRequest
from qgis.PyQt.QtCore import QPoint, Qt

from functools import partial

import utils_giswater
from ui_manager import ChangeNodeType
from ui_manager import UDcatalog
from ui_manager import WScatalog
from map_tools.parent import ParentMapTool


class ChangeElemType(ParentMapTool):
    """ Button 28: User select one node. A form is opened showing current node_type.type
        Combo to select new node_type.type
        Combo to select new node_type.id
        Combo to select new cat_node.id
    """    

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """        
        
        # Call ParentMapTool constructor     
        super(ChangeElemType, self).__init__(iface, settings, action, index_action)       
        
                
    def open_catalog_form(self, wsoftware, geom_type):
        """ Set dialog depending water software """

        node_type = utils_giswater.getWidgetText(self.dlg_chg_node_type, "node_node_type_new")
        if node_type == 'null':
            message = "Select a Custom node Type"
            self.controller.show_warning(message)
            return

        if wsoftware == 'ws':
            self.dlg_cat = WScatalog()
            self.field2 = 'pnom'
            self.field3 = 'dnom'
        elif wsoftware == 'ud':
            self.dlg_cat = UDcatalog()
            self.field2 = 'shape'
            self.field3 = 'geom1'
        self.load_settings(self.dlg_cat)

        self.node_type_text = None
        if wsoftware == 'ws' and geom_type == 'node':
            self.node_type_text = node_type

        sql = ("SELECT DISTINCT(matcat_id) as matcat_id "
               " FROM " + self.schema_name + ".cat_" + geom_type)
        if wsoftware == 'ws' and geom_type == 'node':
            sql += " WHERE " + geom_type + "type_id = '" + self.node_type_text + "'"
        sql += " ORDER BY matcat_id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat, self.dlg_cat.matcat_id, rows)

        sql = ("SELECT DISTINCT(" + self.field2 + ")"
               " FROM " + self.schema_name + ".cat_" + geom_type)
        if wsoftware == 'ws' and geom_type == 'node':
            sql += " WHERE " + geom_type + "type_id = '" + self.node_type_text + "'"
        sql += " ORDER BY " + self.field2
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat, self.dlg_cat.filter2, rows)

        self.fill_filter3(wsoftware, geom_type)

        # Set signals and open dialog
        self.dlg_cat.btn_ok.clicked.connect(self.fill_geomcat_id)
        self.dlg_cat.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_cat))
        self.dlg_cat.rejected.connect(partial(self.close_dialog, self.dlg_cat))
        self.dlg_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))
        self.dlg_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_filter2, wsoftware, geom_type))
        self.dlg_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_filter3, wsoftware, geom_type))
        self.dlg_cat.filter2.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))
        self.dlg_cat.filter2.currentIndexChanged.connect(partial(self.fill_filter3, wsoftware, geom_type))
        self.dlg_cat.filter3.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))
        self.open_dialog(self.dlg_cat)
           

    def fill_filter2(self, wsoftware, geom_type):

        # Get values from filters
        mats = utils_giswater.getWidgetText(self.dlg_cat, self.dlg_cat.matcat_id)

        # Set SQL query
        sql_where = ""
        sql = ("SELECT DISTINCT(" + self.field2 + ")"
               " FROM " + self.schema_name + ".cat_" + geom_type)

        # Build SQL filter
        if mats != "null":
            if sql_where == "":
                sql_where = " WHERE"
            sql_where += " matcat_id = '" + mats + "'"
        if wsoftware == 'ws' and self.node_type_text is not None:
            if sql_where == "":
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " " + geom_type + "type_id = '" + self.node_type_text + "'"
        sql += sql_where + " ORDER BY " + self.field2

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat, self.dlg_cat.filter2, rows)
        self.fill_filter3(wsoftware, geom_type)


    def fill_filter3(self, wsoftware, geom_type):

        # Get values from filters
        mats = utils_giswater.getWidgetText(self.dlg_cat, self.dlg_cat.matcat_id)
        filter2 = utils_giswater.getWidgetText(self.dlg_cat, self.dlg_cat.filter2)

        # Set SQL query
        sql_where = ""
        if wsoftware == 'ws' and geom_type != 'connec':
            sql = "SELECT " + self.field3
            sql += " FROM (SELECT DISTINCT(regexp_replace(trim(' nm' FROM " + self.field3 + "),'-','', 'g')) as x, " + self.field3
        elif wsoftware == 'ws' and geom_type == 'connec':
            sql = "SELECT DISTINCT(TRIM(TRAILING ' ' from " + self.field3 + ")) as " + self.field3
        else:
            sql = "SELECT DISTINCT(" + self.field3 + ")"
        sql += " FROM " + self.schema_name + ".cat_" + geom_type

        # Build SQL filter
        if wsoftware == 'ws' and self.node_type_text is not None:
            sql_where = " WHERE " + geom_type + "type_id = '" + self.node_type_text + "'"
            
        if mats != "null":
            if sql_where == "":
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " matcat_id = '" + mats + "'"
            
        if filter2 != "null":
            if sql_where == "":
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " " + self.field2 + " = '" + filter2 + "'"
        if wsoftware == 'ws' and geom_type != 'connec':
            sql += sql_where + " ORDER BY x) AS " + self.field3
        else:
            sql += sql_where + " ORDER BY " + self.field3

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat, self.dlg_cat.filter3, rows)
        
        self.fill_catalog_id(wsoftware, geom_type)        


    def fill_catalog_id(self, wsoftware, geom_type):

        # Get values from filters
        mats = utils_giswater.getWidgetText(self.dlg_cat, self.dlg_cat.matcat_id)
        filter2 = utils_giswater.getWidgetText(self.dlg_cat, self.dlg_cat.filter2)
        filter3 = utils_giswater.getWidgetText(self.dlg_cat, self.dlg_cat.filter3)

        # Set SQL query
        sql_where = ""
        sql = ("SELECT DISTINCT(id) as id"
               " FROM " + self.schema_name + ".cat_" + geom_type)

        if wsoftware == 'ws' and self.node_type_text is not None:
            sql_where = " WHERE " + geom_type + "type_id = '" + self.node_type_text + "'"
        if mats != "null":
            if sql_where == "":
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " matcat_id = '" + mats + "'"
        if filter2 != "null":
            if sql_where == "":
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " " + self.field2 + " = '" + filter2 + "'"
        if filter3 != "null":
            if sql_where == "":
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " " + self.field3 + " = '" + filter3 + "'"
        sql += sql_where + " ORDER BY id"

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat, self.dlg_cat.id, rows)


    def fill_geomcat_id(self):
        
        catalog_id = utils_giswater.getWidgetText(self.dlg_cat, self.dlg_cat.id)
        self.close_dialog(self.dlg_cat)
        utils_giswater.setWidgetEnabled(self.dlg_chg_node_type, self.dlg_chg_node_type.node_nodecat_id, True)
        utils_giswater.setWidgetText(self.dlg_chg_node_type, self.dlg_chg_node_type.node_nodecat_id, catalog_id)
          
     
    def edit_change_elem_type_get_value(self, index):
        """ Just select item to 'real' combo 'nodecat_id' (that is hidden) """
        
        if index == -1:
            return
        
        # Get selected value from 2nd combobox
        node_node_type_new = utils_giswater.getWidgetText(self.dlg_chg_node_type, "node_node_type_new")
        
        # When value is selected, enabled 3rd combo box
        if node_node_type_new != 'null':
            project_type = self.controller.get_project_type()             
            if project_type == 'ws':
                # Fill 3rd combo_box-catalog_id
                utils_giswater.setWidgetEnabled(self.dlg_chg_node_type, self.dlg_chg_node_type.node_nodecat_id, True)
                sql = ("SELECT DISTINCT(id)"
                       " FROM " + self.schema_name + ".cat_node"
                       " WHERE nodetype_id = '" + str(node_node_type_new) + "'")
                rows = self.controller.get_rows(sql)
                utils_giswater.fillComboBox(self.dlg_chg_node_type, self.dlg_chg_node_type.node_nodecat_id, rows)


    def edit_change_elem_type_accept(self):
        """ Update current type of node and save changes in database """
        
        project_type = self.controller.get_project_type() 
        old_node_type = utils_giswater.getWidgetText(self.dlg_chg_node_type, self.dlg_chg_node_type.node_node_type)
        node_node_type_new = utils_giswater.getWidgetText(self.dlg_chg_node_type, self.dlg_chg_node_type.node_node_type_new)
        node_nodecat_id = utils_giswater.getWidgetText(self.dlg_chg_node_type, self.dlg_chg_node_type.node_nodecat_id)

        if node_node_type_new != "null":
                    
            if (node_nodecat_id != "null" and project_type == 'ws') or (project_type == 'ud'):
                sql = ("SELECT man_table FROM " + self.schema_name + ".node_type"
                       " WHERE id = '" + old_node_type + "'")
                row = self.controller.get_row(sql)
                if not row:
                    return

                # Delete from current table 
                sql = ("DELETE FROM " + self.schema_name + "." + row[0] + ""
                       " WHERE node_id = '" + str(self.node_id) + "'")
                self.controller.execute_sql(sql)

                sql = ("SELECT man_table FROM " + self.schema_name + ".node_type"
                       " WHERE id = '" + node_node_type_new + "'")
                row = self.controller.get_row(sql)
                if not row:
                    return

                # Insert into new table
                sql = ("INSERT INTO " + self.schema_name + "." + row[0] + "(node_id)"
                       " VALUES ('" + str(self.node_id) + "')")
                self.controller.execute_sql(sql)

                # Update field 'nodecat_id'
                sql = ("UPDATE " + self.schema_name + ".node SET nodecat_id = '" + node_nodecat_id + "'"
                       " WHERE node_id = '" + str(self.node_id) + "'")
                self.controller.execute_sql(sql)

                if project_type == 'ud':
                    sql = ("UPDATE " + self.schema_name + ".node SET node_type = '" + node_node_type_new + "'"
                        " WHERE node_id = '" + str(self.node_id) + "'")
                    self.controller.execute_sql(sql)
                    
                # Set active layer
                viewname = "v_edit_" + str(row[0])
                layer = self.controller.get_layer_by_tablename(viewname)
                if layer:
                    self.iface.setActiveLayer(layer)
                message = "Values has been updated"
                self.controller.show_info(message)
                
            else:
                message = "Field catalog_id required!"
                self.controller.show_warning(message)
                
        else:
            message = "The node has not been updated because no catalog has been selected!"
            self.controller.show_warning(message)


        # Close form
        self.close_dialog(self.dlg_chg_node_type)

        # Refresh map canvas
        self.refresh_map_canvas()

        # Check if the expression is valid
        expr_filter = "node_id = '" + str(self.node_id) + "'"
        (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
        if not is_valid:
            return
        if layer:
            self.open_custom_form(layer, expr)

    def open_custom_form(self, layer, expr):
        """ Open custom from selected layer """

        it = layer.getFeatures(QgsFeatureRequest(expr))
        features = [i for i in it]
        if features:
            self.iface.openFeatureForm(layer, features[0])
             
    def change_elem_type(self, feature):
                        
        # Create the dialog, fill node_type and define its signals
        self.dlg_chg_node_type = ChangeNodeType()
        self.load_settings(self.dlg_chg_node_type)

        # Get nodetype_id from current node         
        project_type = self.controller.get_project_type()         
        if project_type == 'ws':
            node_type = feature.attribute('nodetype_id')
        if project_type == 'ud':
            node_type = feature.attribute('node_type')
            sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".cat_node ORDER BY id"
            rows = self.controller.get_rows(sql)
            utils_giswater.fillComboBox(self.dlg_chg_node_type, "node_nodecat_id", rows, allow_nulls=False)
 
        self.dlg_chg_node_type.node_node_type.setText(node_type)
        self.dlg_chg_node_type.node_node_type_new.currentIndexChanged.connect(self.edit_change_elem_type_get_value)
        self.dlg_chg_node_type.btn_catalog.clicked.connect(partial(self.open_catalog_form, project_type, 'node'))
        self.dlg_chg_node_type.btn_accept.clicked.connect(self.edit_change_elem_type_accept)
        self.dlg_chg_node_type.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_chg_node_type))
        
        # Fill 1st combo boxes-new system node type
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".node_type ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_chg_node_type, "node_node_type_new", rows)

        # Open dialog
        self.open_dialog(self.dlg_chg_node_type, dlg_name='change_node_type', maximize_button=False)


    def close_dialog(self, dlg=None):
        """ Close dialog """

        if dlg is None or type(dlg) is bool:
            dlg = self.dlg
        try:
            self.save_settings(dlg)
            dlg.close()
            map_tool = self.canvas.mapTool()
            # If selected map tool is from the plugin, set 'Pan' as current one
            if map_tool.toolName() == '':
                self.set_action_pan()
        except AttributeError:
            pass
               
            
    """ QgsMapTools inherited event functions """
                
    def keyPressEvent(self, event):
        if event.key() == Qt.Key_Escape:
            self.cancel_map_tool()
            return


    def canvasReleaseEvent(self, event):

        self.node_id = None

        # With left click the digitizing is finished
        if event.button() == Qt.RightButton:
            self.cancel_map_tool()
            return

        # Get the click
        x = event.pos().x()
        y = event.pos().y()
        event_point = QPoint(x, y)
        snapped_feat = None

        # Snapping
        (retval, result) = self.snapper.snapToCurrentLayer(event_point, 2)  #@UnusedVariable
            
        if result:
            # Get the point
            point = QgsPoint(result[0].snappedVertex)   #@UnusedVariable
            snapped_feat = next(result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))
            self.node_id = snapped_feat.attribute('node_id')           
                  
            # Change node type
            self.change_elem_type(snapped_feat)




    def activate(self):
        
        # Check button
        self.action().setChecked(True)     

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Clear snapping
        self.snapper_manager.clear_snapping()

        # Set active layer to 'v_edit_node'
        self.layer_node = self.controller.get_layer_by_tablename("v_edit_node")
        self.iface.setActiveLayer(self.layer_node)  

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Select the node inside a pipe by clicking on it and it will be changed"
            self.controller.show_info(message)


    def deactivate(self):

        # Call parent method     
        ParentMapTool.deactivate(self)

