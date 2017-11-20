'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from qgis.core import QGis, QgsPoint, QgsMapToPixel, QgsFeatureRequest
from PyQt4.QtCore import QPoint, Qt

import os
import sys
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ..ui.change_node_type import ChangeNodeType    # @UnresolvedImport  
from ..ui.ud_catalog import UDcatalog               # @UnresolvedImport
from ..ui.ws_catalog import WScatalog               # @UnresolvedImport
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
        
                
    def catalog(self, wsoftware, geom_type, node_type=None):
        """ Set dialog depending water software """

        node_type = utils_giswater.getWidgetText("node_node_type_new")
        if wsoftware == 'ws':
            self.dlg_cat = WScatalog()
            self.field2 = 'pnom'
            self.field3 = 'dnom'
        elif wsoftware == 'ud':
            self.dlg_cat = UDcatalog()
            self.field2 = 'shape'
            self.field3 = 'geom1'
        utils_giswater.setDialog(self.dlg_cat)
        self.dlg_cat.open()      

        # Set signals
        self.dlg_cat.btn_ok.pressed.connect(partial(self.fill_geomcat_id, geom_type))
        self.dlg_cat.btn_cancel.pressed.connect(partial(self.close_dialog, self.dlg_cat))
        self.dlg_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))
        self.dlg_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_filter2, wsoftware, geom_type))
        self.dlg_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_filter3, wsoftware, geom_type))
        self.dlg_cat.filter2.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))
        self.dlg_cat.filter2.currentIndexChanged.connect(partial(self.fill_filter3, wsoftware, geom_type))
        self.dlg_cat.filter3.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))

        self.node_type_text = None
        if wsoftware == 'ws' and geom_type == 'node':
            self.node_type_text = node_type

        sql = "SELECT DISTINCT(matcat_id) as matcat_id "
        sql += " FROM " + self.schema_name + ".cat_" + geom_type
        if wsoftware == 'ws' and geom_type == 'node':
            sql += " WHERE " + geom_type + "type_id = '" + self.node_type_text + "'"
        sql += " ORDER BY matcat_id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.matcat_id, rows)

        sql = "SELECT DISTINCT(" + self.field2 + ")"
        sql += " FROM " + self.schema_name + ".cat_" + geom_type
        if wsoftware == 'ws' and geom_type == 'node':
            sql += " WHERE " + geom_type + "type_id = '" + self.node_type_text + "'"
        sql += " ORDER BY " + self.field2
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.filter2, rows)            

        if wsoftware == 'ws':
            if geom_type == 'node':
                sql = "SELECT " + self.field3
                sql += " FROM (SELECT DISTINCT(regexp_replace(trim(' nm' FROM " + self.field3 + "), '-', '', 'g')::int) as x, " + self.field3
                sql += " FROM " + self.schema_name + ".cat_" + geom_type + " ORDER BY x) AS " + self.field3
            elif geom_type == 'arc':
                sql = "SELECT DISTINCT(" + self.field3 + "), (trim('mm' from " + self.field3 + ")::int) AS x, " + self.field3
                sql += " FROM " + self.schema_name + ".cat_" + geom_type + " ORDER BY x"
            elif geom_type == 'connec':
                sql = "SELECT DISTINCT(TRIM(TRAILING ' ' from " + self.field3 + ")) AS " + self.field3
                sql += " FROM " + self.schema_name + ".cat_" + geom_type + " ORDER BY " + self.field3
        else:
            if geom_type == 'node':
                sql = "SELECT DISTINCT(" + self.field3 + ") AS " + self.field3
                sql += " FROM " + self.schema_name + ".cat_" + geom_type
                sql += " ORDER BY " + self.field3
            elif geom_type == 'arc':
                sql = "SELECT DISTINCT(" + self.field3 + "), (trim('mm' from " + self.field3 + ")::int) AS x, " + self.field3
                sql += " FROM " + self.schema_name + ".cat_" + geom_type + " ORDER BY x"

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.filter3, rows)             


    def fill_filter2(self, wsoftware, geom_type):

        # Get values from filters
        mats = utils_giswater.getWidgetText(self.dlg_cat.matcat_id)

        # Set SQL query
        sql_where = None
        sql = "SELECT DISTINCT(" + self.field2 + ")"
        sql += " FROM " + self.schema_name + ".cat_" + geom_type

        # Build SQL filter
        if mats != "null":
            if sql_where is None:
                sql_where = " WHERE"
            sql_where += " matcat_id = '" + mats + "'"
        if wsoftware == 'ws' and self.node_type_text is not None:
            if sql_where is None:
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " " + geom_type + "type_id = '" + self.node_type_text + "'"
        sql += sql_where + " ORDER BY " + self.field2

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.filter2, rows)
        self.fill_filter3(wsoftware, geom_type)


    def fill_filter3(self, wsoftware, geom_type):

        # Get values from filters
        mats = utils_giswater.getWidgetText(self.dlg_cat.matcat_id)
        filter2 = utils_giswater.getWidgetText(self.dlg_cat.filter2)

        # Set SQL query
        sql_where = None
        if wsoftware == 'ws' and geom_type != 'connec':
            sql = "SELECT " + self.field3
            sql += " FROM (SELECT DISTINCT(regexp_replace(trim(' nm'from " + self.field3 + "),'-','', 'g')::int) as x, " + self.field3
        elif wsoftware == 'ws' and geom_type == 'connec':
            sql = "SELECT DISTINCT(TRIM(TRAILING ' ' from " + self.field3 + ")) as " + self.field3
        else:
            sql = "SELECT DISTINCT(" + self.field3 + ")"
        sql += " FROM " + self.schema_name + ".cat_" + geom_type

        # Build SQL filter
        if wsoftware == 'ws' and self.node_type_text is not None:
            sql_where = " WHERE " + geom_type + "type_id = '" + self.node_type_text + "'"
        if mats != "null":
            if sql_where is None:
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " matcat_id = '" + mats + "'"
        if filter2 != "null":
            if sql_where is None:
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " " + self.field2 + " = '" + filter2 + "'"
        if wsoftware == 'ws' and geom_type != 'connec':
            sql += sql_where + " ORDER BY x) AS " + self.field3
        else:
            sql += sql_where + " ORDER BY " + self.field3

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.filter3, rows)


    def fill_catalog_id(self, wsoftware, geom_type):

        # Get values from filters
        mats = utils_giswater.getWidgetText(self.dlg_cat.matcat_id)
        filter2 = utils_giswater.getWidgetText(self.dlg_cat.filter2)
        filter3 = utils_giswater.getWidgetText(self.dlg_cat.filter3)

        # Set SQL query
        sql_where = None
        sql = "SELECT DISTINCT(id) as id"
        sql += " FROM " + self.schema_name + ".cat_" + geom_type

        if wsoftware == 'ws' and self.node_type_text is not None:
            sql_where = " WHERE " + geom_type + "type_id = '" + self.node_type_text + "'"
        if mats != "null":
            if sql_where is None:
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " matcat_id = '" + mats + "'"
        if filter2 != "null":
            if sql_where is None:
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " " + self.field2 + " = '" + filter2 + "'"
        if filter3 != "null":
            if sql_where is None:
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " " + self.field3 + " = '" + filter3 + "'"
        sql += sql_where + " ORDER BY id"

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.id, rows)


    def fill_geomcat_id(self, geom_type):
        catalog_id = utils_giswater.getWidgetText(self.dlg_cat.id)
        self.close_dialog(self.dlg_cat)
        utils_giswater.setWidgetEnabled("node_nodecat_id", True)
        utils_giswater.setWidgetText("node_nodecat_id", catalog_id)        
          
     
    def edit_change_elem_type_get_value(self, index):
        """ Just select item to 'real' combo 'nodecat_id' (that is hidden) """
        
        if index == -1:
            return
        
        # Get selected value from 2nd combobox
        node_node_type_new = utils_giswater.getWidgetText("node_node_type_new")
        
        # When value is selected, enabled 3rd combo box
        if node_node_type_new != 'null':
            # Fill 3rd combo_box-catalog_id
            utils_giswater.setWidgetEnabled("node_nodecat_id", True)
            sql = ("SELECT DISTINCT(id)"
                   " FROM " + self.schema_name + ".cat_node"
                   " WHERE nodetype_id = '" + str(node_node_type_new) + "'")
            rows = self.controller.get_rows(sql, log_sql=True)
            utils_giswater.fillComboBox("node_nodecat_id", rows)


    def edit_change_elem_type_accept(self):
        """ Update current type of node and save changes in database """

        self.controller.log_info("edit_change_elem_type_accept")
        
        old_node_type = utils_giswater.getWidgetText(self.dlg.node_node_type)
        node_node_type_new = utils_giswater.getWidgetText(self.dlg.node_node_type_new)
        node_nodecat_id = utils_giswater.getWidgetText(self.dlg.node_nodecat_id)

        if node_node_type_new != "null":
            if (node_nodecat_id != "null" and self.project_type == 'ws') or (self.project_type == 'ud'):
                sql = "SELECT man_table FROM  " + self.schema_name + ".node_type WHERE id = '" + old_node_type + "'"
                row = self.controller.get_row(sql)
                if not row:
                    return

                # Delete from current table
                sql = "DELETE FROM "+self.schema_name + "." + row[0] + " WHERE node_id ='" + self.node_id + "'"
                self.controller.execute_sql(sql)

                sql = "SELECT man_table FROM "+self.schema_name + ".node_type WHERE id ='" + node_node_type_new + "'"
                row = self.controller.get_row(sql)
                if not row:
                    return

                # Insert into new table
                sql = "INSERT INTO " + self.schema_name + "." + row[0] + "(node_id)"
                sql += " VALUES (" + self.node_id + ")"
                self.controller.execute_sql(sql)

                # Update field 'nodecat_id'
                if self.project_type == 'ws':
                    sql = "UPDATE " + self.schema_name + ".node SET nodecat_id = '" + node_nodecat_id + "'"
                    sql += " WHERE node_id = '" + self.node_id + "'"
                    self.controller.execute_sql(sql)
                # TODO  mirar si el  ""and node_nodecat_id != ''"" hace falta, ya que ahora el combobox no tendra registro vacio
                if self.project_type == 'ud':
                    sql = "UPDATE " + self.schema_name + ".node SET nodecat_id = '" + node_nodecat_id + "'"
                    sql += " WHERE node_id = '" + self.node_id + "'"
                    self.controller.execute_sql(sql)
                    sql = "UPDATE " + self.schema_name + ".node SET node_type = '" + node_node_type_new + "'"
                    sql += " WHERE node_id = '" + self.node_id + "'"
                    self.controller.execute_sql(sql)
            else:
                message = "Field catalog_id required!"
                self.controller.show_warning(message)
        else:
            message = "The node has not been updated because no catalog has been selected!"
            self.controller.show_warning(message)

        # Close form
        self.close_dialog(self.dlg)
        
             
    def change_elem_type(self, feature):
                        
        # Create the dialog, fill node_type and define its signals
        self.dlg = ChangeNodeType()      
        utils_giswater.setDialog(self.dlg)
        self.load_settings(self.dlg)        

        # Get nodetype_id from current node         
        project_type = self.controller.get_project_type()         
        if project_type == 'ws':
            node_type = feature.attribute('nodetype_id')
        if project_type == 'ud':
            node_type = feature.attribute('node_type')
            sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".cat_node ORDER BY id"
            rows = self.controller.get_rows(sql)
            utils_giswater.fillComboBox("node_nodecat_id", rows, allow_nulls=False)
 
        self.dlg.node_node_type.setText(node_type)
        self.dlg.node_node_type_new.currentIndexChanged.connect(self.edit_change_elem_type_get_value)        
        self.dlg.btn_catalog.pressed.connect(partial(self.catalog, project_type, 'node'))
        self.dlg.btn_accept.pressed.connect(self.edit_change_elem_type_accept)         
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)
        
        # Fill 1st combo boxes-new system node type
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".node_type ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("node_node_type_new", rows)

        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'change_node_type')

        self.dlg.exec_()
                
               
            
    """ QgsMapTools inherited event functions """

    def canvasMoveEvent(self, event):

        # Hide highlight
        self.vertex_marker.hide()

        # Get the click
        x = event.pos().x()
        y = event.pos().y()

        #Plugin reloader bug, MapTool should be deactivated
        try:
            event_point = QPoint(x, y)
        except(TypeError, KeyError):
            self.iface.actionPan().trigger()
            return

        # Snapping
        (retval, result) = self.snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

        # That's the snapped features
        if result:
            for snapped_feat in result:
                # Check if point belongs to 'node' group
                exist = self.snapper_manager.check_node_group(snapped_feat.layer)
                if exist:
                    # Get the point and add marker on it
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
                
            # That's the snapped features
            if result:
                for snapped_feat in result:
                    # Check if feature belongs to 'node' group
                    exist = self.snapper_manager.check_node_group(snapped_feat.layer)
                    if exist:
                        # Get the point
                        point = QgsPoint(result[0].snappedVertex)   #@UnusedVariable
                        snapped_feat = next(result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))
                        break

            if snapped_feat is not None:            
                      
                # Change node type
                self.change_elem_type(snapped_feat)

                # Refresh map canvas
                self.refresh_map_canvas()


    def activate(self):
        
        # Check button
        self.action().setChecked(True)

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
            message = "Select the node inside a pipe by clicking on it and it will be changed"
            self.controller.show_info(message)
               
        # Control current layer (due to QGIS bug in snapping system)
        if self.canvas.currentLayer() is None:
            self.iface.setActiveLayer(self.layer_node_man[0])


    def deactivate(self):

        # Call parent method     
        ParentMapTool.deactivate(self)

