"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.Qt import QDate
from PyQt4.QtCore import Qt
from PyQt4.QtGui import QCompleter, QLineEdit, QTabWidget, QTableView, QStringListModel
from PyQt4.QtSql import QSqlTableModel
from qgis.core import QgsFeatureRequest, QgsExpression           
from qgis.gui import QgsMapToolEmitPoint

import os
import sys
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ui.add_element import AddElement                 
from actions.parent_manage import ParentManage


class ManageElement(ParentManage):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'Add element' of toolbar 'edit' """
        ParentManage.__init__(self, iface, settings, controller, plugin_dir)
        
         
    def manage_element(self):
        """ Button 33: Add element """
        
        self.controller.log_info("manage_element")  
        
        # Create the dialog and signals
        self.dlg = AddElement()
        utils_giswater.setDialog(self.dlg)
        self.set_icon(self.dlg.add_geom, "133")
        self.set_icon(self.dlg.btn_insert, "111")
        self.set_icon(self.dlg.btn_delete, "112")
        self.set_icon(self.dlg.btn_snapping, "137")
        self.dlg.btn_accept.pressed.connect(self.ed_add_element_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)

        # Manage i18n of the form
        #self.controller.translate_form(self.dlg, 'element')     
        
        # Adding auto-completion to a QLineEdit - element_id
        self.completer = QCompleter()
        self.dlg.element_id.setCompleter(self.completer)
        model = QStringListModel()
        
        sql = "SELECT DISTINCT(element_id) FROM " + self.schema_name + ".element"
        rows = self.controller.get_rows(sql)
        values = []
        for row in rows:
            values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)
                
        # Fill combo boxes
        self.populate_combo("elementcat_id", "cat_element")
        self.populate_combo("state", "value_state", "name")
        self.populate_combo("expl_id", "exploitation", "name")
        self.populate_combo("location_type", "man_type_location")
        self.populate_combo("workcat_id", "cat_work")
        self.populate_combo("buildercat_id", "cat_builder")
        self.populate_combo("ownercat_id", "cat_owner")
        self.populate_combo("verified", "value_verified")
        self.populate_combo("workcat_id_end", "cat_work")
        
        # Set default tab 0
        self.tab_feature = self.dlg.findChild(QTabWidget, "tab_feature")
        if self.project_type == 'ws':
            self.tab_feature.removeTab(3)

        self.tab_feature.setCurrentIndex(0)
        
        # Set default values
        feature = "arc"
        view = "v_edit_arc"

        # Check which tab is selected
        table = "element"
        self.tab_feature.currentChanged.connect(partial(self.tab_feature_changed, table))
        self.dlg.element_id.textChanged.connect(partial(self.check_element, "element_id", table))

        # Adding auto-completion to a QLineEdit for default feature
        self.set_completer_feature_id(feature, table, view)
        # Set signal to reach selected value from QCompleter
        # self.completer.activated.connect(self.ed_add_el_autocomplete)
        self.dlg.add_geom.pressed.connect(self.add_point)

        self.widget = self.dlg.findChild(QTableView, "tbl_doc_x_arc")

        #self.dlg.btn_insert.pressed.connect(partial(self.get_expr_filter, self.ids_arc, "arc_id", self.group_pointers_arc))
        self.dlg.btn_insert.pressed.connect(partial(self.manual_init, self.widget, view, feature + "_id", self.dlg, self.group_pointers_arc))
        self.dlg.btn_delete.pressed.connect(partial(self.delete_records, self.widget, view, feature + "_id", self.group_pointers_arc))
        self.dlg.btn_snapping.pressed.connect(partial(self.snapping_init, self.group_pointers_arc, self.group_layers_arc, feature + "_id", view))

        # Open the dialog
        self.dlg.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg.open()


    def check_element(self,attribute,table):

        id_ = self.dlg.element_id.text()

        # Check if we already have data with selected element_id
        sql = ("SELECT DISTINCT(" + str(attribute) + ") FROM " + self.schema_name + "." + str(table) + ""
               " WHERE " + str(attribute) + " = '" + str(id_) + "'")
        row = self.controller.get_row(sql)

        if row:
            # If element exist : load data ELEMENT
            sql = "SELECT * FROM " + self.schema_name + "."+ table+" WHERE " + attribute + " = '" + str(id_) + "'"
            row = self.controller.get_row(sql)
            # Set data
            utils_giswater.setWidgetText("elementcat_id", row['elementcat_id'])

            # TODO: make join
            if str(row['state']) == '0':
                state = "OBSOLETE"
            if str(row['state']) == '1':
                state = "ON SERVICE"
            if str(row['state']) == '2':
                state = "PLANIFIED"

            if str(row['expl_id']) == '1':
                expl_id = "expl_01"
            if str(row['expl_id']) == '2':
                expl_id = "expl_02"
            if str(row['expl_id']) == '3':
                expl_id = "expl_03"
            if str(row['expl_id']) == '4':
                expl_id = "expl_03"

            utils_giswater.setWidgetText("state", str(state))
            utils_giswater.setWidgetText("expl_id", str(expl_id))
            utils_giswater.setWidgetText("ownercat_id", row['ownercat_id'])
            utils_giswater.setWidgetText("location_type", row['location_type'])
            utils_giswater.setWidgetText("buildercat_id", row['buildercat_id'])
            utils_giswater.setWidgetText("workcat_id", row['workcat_id'])
            utils_giswater.setWidgetText("workcat_id_end", row['workcat_id_end'])
            self.dlg.comment.setText(str(row['comment']))
            self.dlg.observ.setText(str(row['observ']))
            self.dlg.path.setText(str(row['link']))
            utils_giswater.setWidgetText("verified", row['verified'])
            self.dlg.rotation.setText(str(row['rotation']))
            if str(row['undelete'])== 'True':
                self.dlg.undelete.setChecked(True)
            builtdate = QDate.fromString(str(row['builtdate']), 'yyyy-MM-dd')
            enddate = QDate.fromString(str(row['enddate']), 'yyyy-MM-dd')

            self.dlg.builtdate.setDate(builtdate)
            self.dlg.enddate.setDate(enddate)

            self.ids_node = []
            self.ids_arc = []
            self.ids_connec = []
            self.ids = []
            # If element exist : load data RELATIONS

            sql = "SELECT arc_id FROM " + self.schema_name + ".element_x_arc WHERE element_id = '" + str(id_) + "'"
            rows = self.controller.get_rows(sql)
            if rows:
                for row in rows:
                    self.ids_arc.append(str(row[0]))
                    self.ids.append(str(row[0]))

                self.get_expr_filter(self.ids_arc, "arc_id", self.group_pointers_arc)
                self.reload_table_update("v_edit_arc", "arc_id", self.ids_arc, self.dlg.tbl_doc_x_arc)

            sql = "SELECT node_id FROM " + self.schema_name + ".element_x_node WHERE element_id = '" + str(id_) + "'"
            rows = self.controller.get_rows(sql)
            if rows:
                for row in rows:
                    self.ids_node.append(str(row[0]))
                    self.ids.append(str(row[0]))

                self.get_expr_filter(self.ids_node, "node_id", self.group_pointers_node)
                self.reload_table_update("v_edit_node", "node_id", self.ids_node, self.dlg.tbl_doc_x_node)

            sql = "SELECT connec_id FROM " + self.schema_name + ".element_x_connec WHERE element_id = '" + str(id_) + "'"
            rows = self.controller.get_rows(sql)
            if rows:
                for row in rows:
                    self.ids_connec.append(str(row[0]))
                    self.ids.append(str(row[0]))

                self.reload_table_update("v_edit_connec", "connec_id", self.ids_connec, self.dlg.tbl_doc_x_connec)
                self.get_expr_filter(self.ids_connec, "connec_id", self.group_pointers_connec)

        # If element_id not exiast: Clear data
        else:
            utils_giswater.setWidgetText("elementcat_id", str(""))
            utils_giswater.setWidgetText("state", str(""))
            utils_giswater.setWidgetText("expl_id",str(""))
            utils_giswater.setWidgetText("ownercat_id", str(""))
            utils_giswater.setWidgetText("location_type", str(""))
            utils_giswater.setWidgetText("buildercat_id", str(""))
            utils_giswater.setWidgetText("workcat_id", str(""))
            utils_giswater.setWidgetText("workcat_id_end", str(""))
            self.dlg.comment.setText(str(""))
            self.dlg.observ.setText(str(""))
            self.dlg.path.setText(str(""))
            utils_giswater.setWidgetText("verified", str(""))
            self.dlg.rotation.setText(str(""))
            return


    def tab_feature_changed(self, table):

        self.dlg.btn_insert.pressed.disconnect()
        self.dlg.btn_delete.pressed.disconnect()
        self.dlg.btn_snapping.pressed.disconnect()

        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)

        tab_position = self.tab_feature.currentIndex()

        if tab_position == 0:
            feature = "arc"
            group_pointers = self.group_pointers_arc
            group_layers = self.group_layers_arc
            
        elif tab_position == 1:
            feature = "node"
            group_pointers = self.group_pointers_node
            group_layers = self.group_layers_node
            
        elif tab_position == 2:
            feature = "connec"
            group_pointers = self.group_pointers_connec
            group_layers = self.group_layers_connec

        elif tab_position == 3:
            # TODO: check project if WS-delete gully tab if UD-set parameters
            feature = "gully"

        table = table + "_x_" + str(feature)
        view = "v_edit_" + str(feature)
        layer = self.controller.get_layer_by_tablename(view) 
        if layer:           
            self.iface.setActiveLayer(layer)
        self.widget = self.dlg.findChild(QTableView, "tbl_doc_x_" + str(feature))
            
        # Adding auto-completion to a QLineEdit
        self.set_completer_feature_id(feature, table, view)

        self.dlg.btn_insert.pressed.connect(partial(self.manual_init, self.widget, view, feature + "_id", self.dlg, group_pointers))
        self.dlg.btn_delete.pressed.connect(partial(self.delete_records, self.widget, view, feature + "_id",  group_pointers))
        self.dlg.btn_snapping.pressed.connect(partial(self.snapping_init, group_pointers, group_layers, feature + "_id",view))


    def manual_init(self, widget, table, attribute, dialog, group_pointers) :
        """  Select feature with entered id
        Set a model with selected filter.
        Attach that model to selected table """
        
        widget_feature_id = self.dlg.findChild(QLineEdit, "feature_id")
        element_id = widget_feature_id.text()
        # Clear list of ids
        self.ids = []
        for layer in group_pointers:
            if layer.selectedFeatureCount() > 0:
                # Get all selected features at layer
                features = layer.selectedFeatures()
                # Get id from all selected features
                for feature in features:
                    feature_id = feature.attribute(attribute)
                    # List of all selected features
                    self.ids.append(str(feature_id))

        # Check if user entered hydrometer_id
        if element_id == "":
            message = "You need to enter id"
            self.controller.show_info_box(message)
            return
        if element_id in self.ids:
            message = str(attribute)+ ":"+element_id+" id already in the list!"
            return
        else:
            # If feature id doesn't exist in list -> add
            self.ids.append(element_id)
            # SELECT features which are in the list
        aux = attribute + " IN ("
        for i in range(len(self.ids)):
            aux += "'" + str(self.ids[i]) + "', "
        aux = aux[:-2] + ")"
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = "Expression Error: " + str(expr.parserErrorString())
            self.controller.show_warning(message)
            return

        for layer in group_pointers:

            it = layer.getFeatures(QgsFeatureRequest(expr))
            # Build a list of feature id's from the previous result
            id_list = [i.id() for i in it]
            # Select features with these id's
            layer.setSelectedFeatures(id_list)

        # Reload table
        self.reload_table(table, attribute)


    def get_expr_filter(self, ids, attribute, group_pointers) :
        """ Select feature with entered id
            Set a model with selected filter. Attach that model to selected table 
        """

        if len(ids) > 0 :
            aux = attribute + " IN ("
            for i in range(len(ids)):
                aux += "'" + str(ids[i]) + "', "
            aux = aux[:-2] + ")"
            expr = QgsExpression(aux)
            if expr.hasParserError():
                message = "Expression Error: " + str(expr.parserErrorString())
                self.controller.show_warning(message)
                return

        for layer in group_pointers:
            # SELECT features which are in the list
            it = layer.getFeatures(QgsFeatureRequest(expr))
            # Build a list of feature id's from the previous result
            id_list = [i.id() for i in it]
            # Select features with these id's
            layer.setSelectedFeatures(id_list)


    def reload_table_update(self, table, attribute, ids, widget):

        # Reload table
        table_name = self.schema_name + "." + table
        
        expr = attribute + " = '" + str(ids[0]) + "'"
        if len(ids) > 1:
            for el in range(1, len(ids)):
                expr += " OR " + str(attribute) + " = '" + str(ids[el]) + "'"

        # Set model
        model = QSqlTableModel();
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

        # Attach model to table view
        widget.setModel(model)
        widget.model().setFilter(expr)


    def delete_records(self, widget, tablename, feature_id, group_pointers):
        """ Delete selected elements of the table """          
                    
        tab_position = self.tab_feature.currentIndex()
        if tab_position == 0:
            self.ids = self.ids_arc
        elif tab_position == 1:
            self.ids = self.ids_node
        elif tab_position == 2:
            self.ids = self.ids_connec

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_info_box(message)
            return

        del_id = []
        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_feature = widget.model().record(row).value(feature_id)
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
                if tab_position == 0:
                    sql = "DELETE FROM " + self.schema_name + ".element_x_arc WHERE arc_id = '" + str(el) + "'"
                    ids = self.ids_arc
                    #self.ids_arc.remove(str(el))
                elif tab_position == 1:
                    sql = "DELETE FROM " + self.schema_name + ".element_x_node WHERE node_id = '" + str(el) + "'"
                    ids = self.ids_node
                    #self.ids_node.remove(str(el))
                elif tab_position == 2:
                    sql = "DELETE FROM " + self.schema_name + ".element_x_connec WHERE connec_id = '" + str(el) + "'"
                    ids = self.ids_connec


        ids = self.ids


       
        # Select features which are in the list
        expr_filter = "\"" + str(feature_id) + "\" IN ("
        for i in range(len(ids)):
            expr_filter += "'" + str(ids[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"

        expr = QgsExpression(expr_filter)
        if expr.hasParserError():
            message = "Expression Error: " + str(expr.parserErrorString())
            self.controller.show_warning(message)
            return
        
        # Update model of the widget with selected expr_filter
        #self.connec_expr_filter = expr_filter     
        expr = self.reload_table(widget, tablename, expr_filter)               

        # Reload selection
        for layer in group_pointers:
            # Build a list of feature id's and select them
            it = layer.getFeatures(QgsFeatureRequest(expr))
            id_list = [i.id() for i in it]
            layer.selectByIds(id_list)


    def reload_table(self, widget, tablename, expr_filter=None):
        """ Reload @widget with contents of @tablename applying selected @expr_filter """
                         
        #table_name = self.schema_name + "." + table_name
#         if expr_filter is None:
#             expr_filter = self.connec_expr_filter        
        expr = self.set_table_model(widget, table_name, expr_filter)
        return expr
                        
                
    def ed_add_el_autocomplete(self):
        """ Once we select 'element_id' using autocomplete, 
            fill widgets with current values 
        """

        self.dlg.element_id.setCompleter(self.completer)
        element_id = utils_giswater.getWidgetText("element_id")

        # Get values from database
        sql = ("SELECT elementcat_id, location_type, ownercat_id, state, workcat_id,"
               " buildercat_id, annotation, observ, comment, link, verified, rotation"
               " FROM " + self.schema_name + ".element"
               " WHERE element_id = '" + element_id + "'")
        row = self.controller.get_row(sql)
        if row:
            # Fill widgets
            columns_length = self.dao.get_columns_length()
            for i in range(0, columns_length):
                column_name = self.dao.get_column_name(i)
                utils_giswater.setWidgetText(column_name, row[column_name])


    def ed_add_element_accept(self):
        """ Insert or update table 'element'. Add element to selected features """

        # Get values from dialog
        element_id = utils_giswater.getWidgetText("element_id")
        elementcat_id = utils_giswater.getWidgetText("elementcat_id")
        state = utils_giswater.getWidgetText("state")
        expl_id = utils_giswater.getWidgetText("expl_id")
        ownercat_id = utils_giswater.getWidgetText("ownercat_id")
        location_type = utils_giswater.getWidgetText("location_type")
        buildercat_id = utils_giswater.getWidgetText("buildercat_id")

        workcat_id = utils_giswater.getWidgetText("workcat_id")
        workcat_id_end = utils_giswater.getWidgetText("workcat_id_end")
        #annotation = utils_giswater.getWidgetText("annotation")
        comment = utils_giswater.getWidgetText("comment")
        observ = utils_giswater.getWidgetText("observ")
        link = utils_giswater.getWidgetText("path")
        verified = utils_giswater.getWidgetText("verified")
        rotation = utils_giswater.getWidgetText("rotation")

        builtdate = self.dlg.builtdate.dateTime().toString('yyyy-MM-dd')
        enddate = self.dlg.enddate.dateTime().toString('yyyy-MM-dd')
        undelete = self.dlg.undelete.isChecked()

        # TODO make join
        if state == 'OBSOLETE':
            state = '0'
        if state == 'ON SERVICE':
            state = '1'
        if state == 'PLANIFIED':
            state = '2'

        # TODO:
        if expl_id == 'expl_01':
            expl_id = '1'
        if expl_id == 'expl_02':
            expl_id = '2'
        if expl_id == 'expl_03':
            expl_id = '3'
        if expl_id == 'expl_04':
            expl_id = '4'

        if element_id == 'null':
            message = "You need to insert element_id"
            self.controller.show_warning(message)
            return

        # Get SRID
        srid = self.controller.plugin_settings_value('srid')   

        # Check if we already have data with selected element_id
        sql = ("SELECT DISTINCT(element_id) FROM " + self.schema_name + ".element"
               " WHERE element_id = '" + str(element_id) + "'")
        row = self.controller.get_row(sql)
        
        # If element already exist perform an UPDATE
        if row:
            answer = self.controller.ask_question("Are you sure you want change the data?")
            if answer:
                sql = "UPDATE " + self.schema_name + ".element"
                sql += " SET elementcat_id = '" + str(elementcat_id) + "', state = '" + str(state) + "', location_type = '" + str(location_type) + "'"
                sql += ", workcat_id_end = '" + str(workcat_id_end) + "', workcat_id = '" + str(workcat_id) + "', buildercat_id = '" + str(buildercat_id) + "', ownercat_id = '" + str(ownercat_id) + "'"
                sql += ", rotation = '" + str(rotation) + "', comment = '" + str(comment) + "', expl_id = '" + str(expl_id) + "', observ = '" + str(observ) + "', link = '" + str(link) + "', verified = '" + str(verified) + "'"
                sql += ", undelete = '" + str(undelete) + "', enddate = '" + str(enddate) + "', builtdate = '" + str(builtdate) + "'"
                if str(self.x) != "":
                    sql += ", the_geom = ST_SetSRID(ST_MakePoint(" + str(self.x) + "," + str(self.y) + "), " + str(srid) + ")"
                else:
                    sql += ""
                sql += " WHERE element_id = '" + str(element_id) + "'"
                status = self.controller.execute_sql(sql)
                if status:
                    message = "Values has been updated into table element"
                    self.controller.show_info(message)

                    sql = "DELETE FROM " + self.schema_name + ".element_x_node WHERE element_id = '" + str(element_id) + "'"
                    self.controller.execute_sql(sql)
                    sql = "DELETE FROM " + self.schema_name + ".element_x_arc WHERE element_id = '" + str(element_id) + "'"
                    self.controller.execute_sql(sql)
                    sql = "DELETE FROM " + self.schema_name + ".element_x_connec WHERE element_id = '" + str(element_id) + "'"
                    self.controller.execute_sql(sql)

                    if self.ids_arc != []:
                        for arc_id in self.ids_arc:
                            sql = "INSERT INTO " + self.schema_name + ".element_x_arc (element_id, arc_id)"
                            sql += " VALUES ('" + str(element_id) + "', '" + str(arc_id) + "')"
                            status = self.controller.execute_sql(sql)
                            if status:
                                message = "Values has been updated into table element_x_arc"
                                self.controller.show_info(message)
                            if not status:
                                message = "Error inserting element in table, you need to review data"
                                self.controller.show_warning(message)
                                return
                            
                    if self.ids_node != []:
                        for node_id in self.ids_node:
                            sql = "INSERT INTO " + self.schema_name + ".element_x_node (element_id, node_id )"
                            sql += " VALUES ('" + str(element_id) + "', '" + str(node_id) + "')"
                            status = self.controller.execute_sql(sql)
                            if status:
                                message = "Values has been updated into table element_x_node"
                                self.controller.show_info(message)
                            if not status:
                                message = "Error inserting element in table, you need to review data"
                                self.controller.show_warning(message)
                                return
                            
                    if self.ids_connec != []:
                        for connec_id in self.ids_connec:
                            sql = "INSERT INTO " + self.schema_name + ".element_x_connec (element_id, connec_id )"
                            sql += " VALUES ('" + str(element_id) + "', '" + str(connec_id) + "')"
                            status = self.controller.execute_sql(sql)
                            if status:
                                message = "Values has been updated into table element_x_connec"
                                self.controller.show_info(message)
                            if not status:
                                message = "Error inserting element in table, you need to review data"
                                self.controller.show_warning(message)
                                return

        # If element doesn't exist perform an INSERT
        else:
            sql = "INSERT INTO " + self.schema_name + ".element (element_id, elementcat_id, state, location_type"
            sql += ", workcat_id, buildercat_id, ownercat_id, rotation, comment, expl_id, observ, link, verified, workcat_id_end, enddate, builtdate, undelete"
            if str(self.x) != "":
                sql +=" , the_geom) "
            else:
                sql += ")"
            sql += " VALUES ('" + str(element_id) + "', '" + str(elementcat_id) + "', '" + str(state) + "', '" + str(location_type) + "', '"
            sql += str(workcat_id) + "', '" + str(buildercat_id) + "', '" + str(ownercat_id) + "', '" + str(rotation) + "', '" + str(comment) + "', '"
            sql += str(expl_id) + "','" + str(observ) + "','" + str(link) + "','" + str(verified) + "','" + str(workcat_id_end) + "','" + str(enddate) + "','" + str(builtdate) + "','" + str(undelete) + "'"
            if str(self.x) != "" :
                sql += ", ST_SetSRID(ST_MakePoint(" + str(self.x) + "," + str(self.y) + "), " + str(srid) +"))"
            else:
                sql += ")"
            status = self.controller.execute_sql(sql)
            if status:
                message = "Values has been updated into table element"
                self.controller.show_info(message)

                if self.ids_arc != []:
                    for arc_id in self.ids_arc:
                        sql = "INSERT INTO " + self.schema_name + ".element_x_arc (element_id, arc_id)"
                        sql += " VALUES ('" + str(element_id) + "', '" + str(arc_id) + "')"
                        status = self.controller.execute_sql(sql)
                        if status:
                            message = "Values has been updated into table"
                            self.controller.show_info(message, parameter='element_x_arc')
                        else:
                            message = "Error inserting element in table, you need to review data"
                            self.controller.show_warning(message, parameter='element_x_arc')
                            return
                        
                if self.ids_node != []:
                    for node_id in self.ids_node:
                        sql = ("INSERT INTO " + self.schema_name + ".element_x_node (element_id, node_id)"
                               " VALUES ('" + str(element_id) + "', '" + str(node_id) + "')")
                        status = self.controller.execute_sql(sql)
                        if status:
                            message = "Values has been updated into table"
                            self.controller.show_info(message, parameter='element_x_node')
                        else:
                            message = "Error inserting element in table, you need to review data"
                            self.controller.show_warning(message, parameter='element_x_node')
                            return
                        
                if self.ids_connec != []:
                    for connec_id in self.ids_connec:
                        sql = "INSERT INTO " + self.schema_name + ".element_x_connec (element_id, connec_id)"
                        sql += " VALUES ('" + str(element_id) + "', '" + str(connec_id) + "')"
                        status = self.controller.execute_sql(sql)
                        if status:
                            message = "Values has been updated into table"
                            self.controller.show_info(message, parameter='element_x_connec')
                        else:
                            message = "Error inserting element in table, you need to review data"
                            self.controller.show_warning(message, parameter='element_x_connec')
                            return
            
            else:
                message = "Error inserting element in table, you need to review data"
                self.controller.show_warning(message)
                return

        self.close_dialog(self.dlg)
        self.iface.mapCanvas().refreshAllLayers()

