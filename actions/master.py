"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtCore import QTime, Qt, QPoint
from PyQt4.QtGui import QComboBox, QCheckBox, QDateEdit, QSpinBox, QTimeEdit, QLineEdit
from PyQt4.QtGui import QDoubleValidator, QTabWidget, QTableView, QAbstractItemView
from PyQt4.QtSql import QSqlTableModel
from qgis.gui import QgsMapCanvasSnapper, QgsMapToolEmitPoint
from qgis.core import QgsFeatureRequest

import os
import sys
import operator
from datetime import datetime
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ui.config_master import ConfigMaster                     
from ui.psector_management import Psector_management           
from ui.plan_estimate_result_new import EstimateResultNew
from ui.plan_estimate_result_selector import EstimateResultSelector
from ui.plan_estimate_result_manager import EstimateResultManager   
from ui.multirow_selector import Multirow_selector                    
from models.config_param_system import ConfigParamSystem              
from parent import ParentAction
from actions.manage_new_psector import ManageNewPsector

class Master(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'master' """
        self.minor_version = "3.0"
        self.config_dict = {}
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.manage_new_psector = ManageNewPsector(iface, settings, controller, plugin_dir)

    def set_project_type(self, project_type):
        self.project_type = project_type


    def master_new_psector(self, psector_id=None):
        """ Button 45: New psector """
        self.manage_new_psector.master_new_psector(psector_id, 'plan')


    def master_psector_mangement(self):
        """ Button 46: Psector management """

        # Create the dialog and signals
        self.dlg = Psector_management()
        utils_giswater.setDialog(self.dlg)
        table_name = "plan_psector"
        column_id = "psector_id"

        # Tables
        qtbl_psm = self.dlg.findChild(QTableView, "tbl_psm")
        qtbl_psm.setSelectionBehavior(QAbstractItemView.SelectRows)  # Select by rows instead of individual cells

        # Set signals
        self.dlg.btn_accept.pressed.connect(partial(self.charge_psector, qtbl_psm))
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)
        self.dlg.btn_save.pressed.connect(partial(self.save_table, qtbl_psm, "plan_psector", column_id))
        self.dlg.btn_delete.clicked.connect(partial(self.multi_rows_delete, qtbl_psm, table_name, column_id))
        self.dlg.btn_current_psector.clicked.connect(partial(self.update_current_psector, qtbl_psm))
        self.dlg.txt_name.textChanged.connect(partial(self.filter_by_text, qtbl_psm, self.dlg.txt_name, "plan_psector"))

        self.fill_table_psector(qtbl_psm, "plan_psector", column_id)
        self.dlg.exec_()


    def update_current_psector(self, qtbl_psm):
      
        selected_list = qtbl_psm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        row = selected_list[0].row()
        psector_id = qtbl_psm.model().record(row).value("psector_id")
        sql = "SELECT * FROM " + self.schema_name + ".selector_psector WHERE cur_user = current_user"
        rows = self.controller.get_rows(sql)
        if rows:
            sql = "UPDATE " + self.schema_name + ".selector_psector SET psector_id="
            sql += "'" + str(psector_id) + "' WHERE cur_user = current_user"
        else:
            sql = 'INSERT INTO ' + self.schema_name + '.selector_psector (psector_id, cur_user)'
            sql += " VALUES ('" + str(psector_id) + "', current_user)"

        aux_widget = QLineEdit()
        aux_widget.setText(str(psector_id))
        self.insert_or_update_config_param_curuser(aux_widget, "psector_vdefault", "config_param_user")
        self.controller.execute_sql(sql)
        message = "Values has been updated"
        self.controller.show_info(message)

        self.fill_table(qtbl_psm, self.schema_name + ".plan_psector")

        self.dlg.exec_()


    def master_config_master(self):
        """ Button 99: Open a dialog showing data from table 'config_param_system' """

        # Create the dialog and signals
        self.dlg = ConfigMaster()
        utils_giswater.setDialog(self.dlg)
        self.load_settings(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.master_config_master_accept)
        self.dlg.btn_cancel.pressed.connect(partial(self.close_dialog, self.dlg))
        self.dlg.rejected.connect(partial(self.save_settings, self.dlg))
        # Get records from tables 'config' and 'config_param_system' and fill corresponding widgets
        self.select_config("config")
        self.select_config_param_system("config_param_system") 

        self.dlg.om_path_url.clicked.connect(partial(self.open_web_browser, "om_visit_absolute_path"))
        self.dlg.om_path_doc.clicked.connect(partial(self.get_folder_dialog, "om_visit_absolute_path"))
        self.dlg.doc_path_url.clicked.connect(partial(self.open_web_browser, "doc_absolute_path"))
        self.dlg.doc_path_doc.clicked.connect(partial(self.get_folder_dialog, "doc_absolute_path"))

        if self.project_type == 'ws':
            self.dlg.tab_topology.removeTab(1)

        sql = "SELECT name FROM" + self.schema_name + ".plan_psector ORDER BY name"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("psector_vdefault", rows)

        sql = ("SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'psector_vdefault'")
        row = self.dao.get_row(sql)
        if row:
            utils_giswater.setChecked("chk_psector_enabled", True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
            
        self.dlg.exec_()


    def select_config_param_system(self, tablename): 
        """ Get data from table 'config_param_system' and fill widgets according to the name of the field 'parameter' """
        
        self.config_dict = {}
        sql = ("SELECT parameter, value, context"
               " FROM " + self.schema_name + "." + tablename + " ORDER BY parameter")    
        rows = self.controller.get_rows(sql)
        for row in rows:
            config = ConfigParamSystem(row['parameter'], row['value'], row['context'])
            self.config_dict[row['parameter']] = config
        utils_giswater.fillWidgets(rows)       
        

    def select_config(self, tablename):
        """ Get data from table 'config' and fill widgets according to the name of the columns """

        sql = "SELECT * FROM " + self.schema_name + "." + tablename
        row = self.dao.get_row(sql)
        if not row:
            self.controller.show_warning("Any data found in table " + tablename)
            return None
        
        # Iterate over all columns and populate its corresponding widget
        columns = []
        for i in range(0, len(row)):

            column_name = self.dao.get_column_name(i)
            widget_type = utils_giswater.getWidgetType(column_name)
            if widget_type is QCheckBox:
                utils_giswater.setChecked(column_name, row[column_name])
            elif widget_type is QDateEdit:
                utils_giswater.setCalendarDate(column_name, datetime.strptime(row[column_name], '%Y-%m-%d'))
            elif widget_type is QTimeEdit:
                timeparts = str(row[column_name]).split(':')
                if len(timeparts) < 3:
                    timeparts.append("0")
                days = int(timeparts[0]) / 24
                hours = int(timeparts[0]) % 24
                minuts = int(timeparts[1])
                seconds = int(timeparts[2])
                time = QTime(hours, minuts, seconds)
                utils_giswater.setTimeEdit(column_name, time)
                utils_giswater.setText(column_name + "_day", days)
            else:
                utils_giswater.setWidgetText(column_name, row[column_name])
            columns.append(column_name)

        return columns


    def master_config_master_accept(self):
        """ Button 99: Slot for 'btn_accept' """
        
        if utils_giswater.isChecked("chk_psector_enabled"):
            self.insert_or_update_config_param_curuser(self.dlg.psector_vdefault, "psector_vdefault", "config_param_user")
        else:
            self.delete_row("psector_vdefault", "config_param_user")
            
        # Update tables 'confog' and 'config_param_system'            
        self.update_config("config", self.dlg)
        self.update_config_param_system("config_param_system")
        
        message = "Values has been updated"
        self.controller.show_info(message)

        self.close_dialog(self.dlg)


    def update_config_param_system(self, tablename):
        """ Update table @tablename """
        
        # Get all parameters from dictionary object
        for config in self.config_dict.itervalues():
            value = utils_giswater.getWidgetText(str(config.parameter))      
            if value is not None:           
                value = value.replace('null', '')
                sql = "UPDATE " + self.schema_name + "." + tablename
                sql += " SET value = '" + str(value) + "'"
                sql += " WHERE parameter = '" + str(config.parameter) + "';"            
                self.controller.execute_sql(sql)      
                
                
    def update_config(self, tablename, dialog):
        """ Update table @tablename from values get from @dialog """

        sql = "SELECT * FROM " + self.schema_name + "." + tablename
        row = self.dao.get_row(sql)
        columns = []
        for i in range(0, len(row)):
            column_name = self.dao.get_column_name(i)
            if column_name != 'id': 
                columns.append(column_name)

        if columns is None:
            return
        
        sql = "UPDATE " + self.schema_name + "." + tablename + " SET "
        for column_name in columns:         
            widget_type = utils_giswater.getWidgetType(column_name)
            if widget_type is QCheckBox:
                value = utils_giswater.isChecked(column_name)
            elif widget_type is QDateEdit:
                date = dialog.findChild(QDateEdit, str(column_name))
                value = date.dateTime().toString('yyyy-MM-dd')
            elif widget_type is QTimeEdit:
                aux = 0
                widget_day = str(column_name) + "_day"
                day = utils_giswater.getText(widget_day)
                if day != "null":
                    aux = int(day) * 24
                time = dialog.findChild(QTimeEdit, str(column_name))
                timeparts = time.dateTime().toString('HH:mm:ss').split(':')
                h = int(timeparts[0]) + int(aux)
                aux = str(h) + ":" + str(timeparts[1]) + ":00"
                value = aux
            elif widget_type is QSpinBox:
                x = dialog.findChild(QSpinBox, str(column_name))
                value = x.value()
            else:
                value = utils_giswater.getWidgetText(column_name)
              
            if value is not None:  
                if value == 'null':
                    sql += column_name + " = null, "
                else:
                    if type(value) is not bool and widget_type is not QSpinBox:
                        value = value.replace(",", ".")
                    sql += column_name + " = '" + str(value) + "', "

        sql = sql[:- 2]          
        self.controller.execute_sql(sql)
                        

    def insert_or_update_config_param_curuser(self, widget, parameter, tablename):
        """ Insert or update values in tables with current_user control """

        sql = 'SELECT * FROM ' + self.schema_name + '.' + tablename 
        sql += ' WHERE "cur_user" = current_user'
        rows = self.controller.get_rows(sql)
        exist_param = False
        if type(widget) != QDateEdit:
            if utils_giswater.getWidgetText(widget) != "":
                for row in rows:
                    if row[1] == parameter:
                        exist_param = True
                if exist_param:
                    sql = "UPDATE " + self.schema_name + "." + tablename + " SET value="
                    if widget.objectName() != 'state_vdefault':
                        sql += "'" + utils_giswater.getWidgetText(widget) + "' WHERE parameter='" + parameter + "'"
                    else:
                        sql += "(SELECT id FROM " + self.schema_name + ".value_state WHERE name ='" + utils_giswater.getWidgetText(widget) + "')"
                        sql += " WHERE parameter = 'state_vdefault' "
                else:
                    sql = 'INSERT INTO ' + self.schema_name + '.' + tablename + '(parameter, value, cur_user)'
                    if widget.objectName() != 'state_vdefault':
                        sql += " VALUES ('" + parameter + "', '" + utils_giswater.getWidgetText(widget) + "', current_user)"
                    else:
                        sql += " VALUES ('" + parameter + "', (SELECT id FROM " + self.schema_name + ".value_state WHERE name ='" + utils_giswater.getWidgetText(widget) + "'), current_user)"
        else:
            for row in rows:
                if row[1] == parameter:
                    exist_param = True
            if exist_param:
                sql = "UPDATE " + self.schema_name + "." + tablename + " SET value="
                _date = widget.dateTime().toString('yyyy-MM-dd')
                sql += "'" + str(_date) + "' WHERE parameter='" + parameter + "'"
            else:
                sql = 'INSERT INTO ' + self.schema_name + '.' + tablename + '(parameter, value, cur_user)'
                _date = widget.dateTime().toString('yyyy-MM-dd')
                sql += " VALUES ('" + parameter + "', '" + _date + "', current_user)"
        self.controller.execute_sql(sql)


    def delete_row(self,  parameter, tablename):
        sql = 'DELETE FROM ' + self.schema_name + '.' + tablename
        sql += ' WHERE "cur_user" = current_user and parameter = ' + "'" + parameter + "'"
        self.controller.execute_sql(sql)


    def filter_by_text(self, table, widget_txt, tablename):

        result_select = utils_giswater.getWidgetText(widget_txt)
        if result_select != 'null':
            expr = " name ILIKE '%" + result_select + "%'"
            # Refresh model with selected filter
            table.model().setFilter(expr)
            table.model().select()
        else:
            self.fill_table(table, self.schema_name + "." + tablename)


    def charge_psector(self, qtbl_psm):

        selected_list = qtbl_psm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        row = selected_list[0].row()
        psector_id = qtbl_psm.model().record(row).value("psector_id")
        self.close_dialog()
        self.master_new_psector(psector_id)


    def snapping(self, layername, tablename, table_view, elem_type):
        # Create the appropriate map tool and connect the gotPoint() signal
        map_canvas = self.iface.mapCanvas()
        self.emit_point = QgsMapToolEmitPoint(map_canvas)
        map_canvas.setMapTool(self.emit_point)
        utils_giswater.setWidgetText("btn_add_arc_plan", "Editing")
        utils_giswater.setWidgetText("btn_add_node_plan", "Editing")
        self.emit_point.canvasClicked.connect(partial(self.click_button_add, layername, tablename, table_view, elem_type))


    def click_button_add(self, layername, tablename, table_view, elem_type, point, button):
        """
        :param layer_view: it is the view we are using
        :param tablename:  Is the name of the table that we will use to make the SELECT and INSERT
        :param table_view: it's QTableView we are using, need ir for upgrade his own view
        :param elem_type: Used to buy the object that we "click" with the type of object we want to add or delete
        :param point: param inherited from signal canvasClicked
        :param button: param inherited from signal canvasClicked
        """

        if button == Qt.LeftButton:

            layernames_node = ["v_edit_node"]
            layernames_arc = ["v_edit_arc"]
            canvas = self.iface.mapCanvas()
            snapper = QgsMapCanvasSnapper(canvas)
            map_point = canvas.getCoordinateTransform().transform(point)
            x = map_point.x()
            y = map_point.y()
            event_point = QPoint(x, y)

            # Snapping
            (retval, result) = snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

            # That's the snapped point
            if result:
                # Check feature
                for snapped_feat in result:
                    element_type = snapped_feat.layer.name()
                    feat_type = None
                    if element_type in layernames_node:
                        feat_type = 'node'
                    elif element_type in layernames_arc:
                        feat_type = 'arc'

                    if feat_type:
                        # Get the point. Leave selection
                        feature = next(snapped_feat.layer.getFeatures(QgsFeatureRequest().setFilterFid(snapped_feat.snappedAtGeometry)))
                        element_id = feature.attribute(feat_type + '_id')
                        snapped_feat.layer.select([snapped_feat.snappedAtGeometry])
                        # Get depth of feature
                        if feat_type == elem_type:
                            sql = ("SELECT * FROM " + self.schema_name + "." + tablename + ""
                                   " WHERE " + feat_type+"_id = '" + element_id+"' AND psector_id = '" + self.psector_id.text() + "'")
                            row = self.controller.get_row(sql)
                            if not row:
                                self.list_elemets[element_id] = feat_type
                            else:
                                message = "This id already exists"
                                self.controller.show_info(message)
                        else:
                            message = self.tr("You are trying to introduce")+" "+feat_type+" "+self.tr("in a")+" "+elem_type
                            self.controller.show_info(message)

        elif button == Qt.RightButton:
            for element_id, feat_type in self.list_elemets.items():
                sql = ("INSERT INTO " + self.schema_name + "." + tablename + "(" + feat_type + "_id, psector_id)"
                       " VALUES (" + element_id + ", " + self.psector_id.text() + ")")
                self.controller.execute_sql(sql)
            table_view.model().select()
            self.emit_point.canvasClicked.disconnect()
            self.list_elemets.clear()
            self.dlg.btn_add_arc_plan.setText('Add')
            self.dlg.btn_add_node_plan.setText('Add')


    def insert_or_update_new_psector(self, update, tablename):

        sql = "SELECT * FROM " + self.schema_name + "." + tablename
        row = self.controller.get_row(sql)
        columns = []
        for i in range(0, len(row)):
            column_name = self.dao.get_column_name(i)
            columns.append(column_name)

        if update:
            if columns is not None:
                sql = "UPDATE " + self.schema_name + "." + tablename + " SET "
                for column_name in columns:
                    if column_name != 'psector_id':
                        widget_type = utils_giswater.getWidgetType(column_name)
                        if widget_type is QCheckBox:
                            value = utils_giswater.isChecked(column_name)
                        elif widget_type is QDateEdit:
                            date = self.dlg.findChild(QDateEdit, str(column_name))
                            value = date.dateTime().toString('yyyy-MM-dd HH:mm:ss')
                        else:
                            value = utils_giswater.getWidgetText(column_name)
                        if value is None or value == 'null':
                            sql += column_name + " = null, "
                        else:
                            if type(value) is not bool:
                                value = value.replace(",", ".")
                            sql += column_name + " = '" + str(value) + "', "

                sql = sql[:len(sql) - 2]
                sql += " WHERE psector_id = '" + self.psector_id.text() + "'"

        else:
            values = "VALUES("
            if columns is not None:
                sql = "INSERT INTO " + self.schema_name + "." + tablename+" ("
                for column_name in columns:
                    if column_name != 'psector_id':
                        widget_type = utils_giswater.getWidgetType(column_name)
                        if widget_type is not None:
                            if widget_type is QCheckBox:
                                values += utils_giswater.isChecked(column_name)+", "
                            elif widget_type is QDateEdit:
                                date = self.dlg.findChild(QDateEdit, str(column_name))
                                values += date.dateTime().toString('yyyy-MM-dd HH:mm:ss')+", "
                            else:
                                value = utils_giswater.getWidgetText(column_name)
                            if value is None or value == 'null':
                                sql += column_name + ", "
                                values += "null, "
                            else:
                                values += "'" + value + "',"
                                sql += column_name + ", "
                sql = sql[:len(sql) - 2]+") "
                values = values[:len(values)-2] + ")"
                sql += values
                
        self.controller.execute_sql(sql)
        
        self.close_dialog()


    def multi_rows_delete(self, widget, table_name, column_id):
        """ Delete selected elements of the table
        :param QTableView widget: origin
        :param table_name: table origin
        :param column_id: Refers to the id of the source table
        """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = widget.model().record(row).value(str(column_id))
            inf_text += str(id_)+", "
            list_id = list_id+"'"+str(id_)+"', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        answer = self.controller.ask_question("Are you sure you want to delete these records?", "Delete records", inf_text)

        if answer:
            sql = "DELETE FROM "+self.schema_name+"."+table_name
            sql += " WHERE "+column_id+" IN ("+list_id+")"
            self.controller.execute_sql(sql)
            widget.model().select()


    def cal_percent(self, widged_total, widged_percent, widget_result):
        text = str((float(widged_total.text()) * float(widged_percent.text())/100))
        widget_result.setText(text)


    def sum_total(self, widget_total, widged_percent, widget_result):
        text = str((float(widget_total.text()) + float(widged_percent.text())))
        widget_result.setText(text)


    def master_psector_selector(self):
        """ Button 47: Psector selector """

        # Create the dialog and signals
        self.dlg = Multirow_selector()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_ok.pressed.connect(self.close_dialog)
        self.dlg.setWindowTitle("Psector")
        tableleft = "plan_psector"
        tableright = "selector_psector"
        field_id_left = "psector_id"
        field_id_right = "psector_id"
        self.multi_row_selector(self.dlg, tableleft, tableright, field_id_left, field_id_right)
        self.dlg.exec_()
        
        
    def master_estimate_result_new(self, tablename=None, result_id=None, index=0):
        """ Button 38: New estimate result """

        # Create dialog 
        self.dlg = EstimateResultNew()
        utils_giswater.setDialog(self.dlg)
        
        # Set signals
        self.dlg.btn_calculate.clicked.connect(self.master_estimate_result_new_calculate)
        self.dlg.btn_close.clicked.connect(self.close_dialog)
        self.dlg.prices_coefficient.setValidator(QDoubleValidator())
        self.populate_cmb_result_type(self.dlg.cmb_result_type, 'name', 'id', 'plan_value_result_type', False)

        if result_id != 0 and result_id is not None:
            sql = ("SELECT * FROM " + self.schema_name + "." + tablename + " "
                   " WHERE result_id='"+str(result_id)+"' AND current_user = cur_user")
            row = self.controller.get_row(sql)

            if row is None:
                return

            self.controller.log_info(str(row))
            utils_giswater.setWidgetText(self.dlg.result_name, row['result_id'])
            self.dlg.cmb_result_type.setCurrentIndex(index)
            utils_giswater.setWidgetText(self.dlg.prices_coefficient, row['network_price_coeff'])

            self.dlg.result_name.setEnabled(False)
            self.dlg.cmb_result_type.setEnabled(False)
            self.dlg.prices_coefficient.setEnabled(False)

        # # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'estimate_result_new')
        self.dlg.exec_()

    def populate_cmb_result_type(self, combo, field_name, field_id, table_name, allow_nulls=True):

        sql = ("SELECT DISTINCT(" + field_id + "), " + field_name + ""
                " FROM " + self.schema_name + "." + table_name + ""
                " ORDER BY " + field_name + "")
        rows = self.controller.get_rows(sql)
        combo.blockSignals(True)
        combo.clear()
        if allow_nulls:
            combo.addItem("", "")
        records_sorted = sorted(rows, key=operator.itemgetter(1))
        for record in records_sorted:
            combo.addItem(str(record[1]), record)
        combo.blockSignals(False)

    def master_estimate_result_new_calculate(self):
        """ Execute function 'gw_fct_plan_estimate_result' """

        # Get values from form
        result_name = utils_giswater.getWidgetText("result_name")
        combo = utils_giswater.getWidget("cmb_result_type")
        elem = combo.itemData(combo.currentIndex())
        result_type = str(elem[0])
        coefficient = utils_giswater.getWidgetText("prices_coefficient")
        observ = utils_giswater.getWidgetText("observ")

        if result_name == 'null':
            message = "Please, introduce a result name"
            self.controller.show_warning(message)  
            return          
        if coefficient == 'null':
            message = "Please, introduce a coefficient value"
            self.controller.show_warning(message)  
            return          
        
        # Execute function 'gw_fct_plan_result'
        sql = ("SELECT " + self.schema_name + ".gw_fct_plan_result('"
               + result_name + "', " + result_type + ", '" + coefficient + "', '" + observ + "');")
        status = self.controller.execute_sql(sql)
        if status:
            message = "Values has been updated"
            self.controller.show_info(message)
        
        # Refresh canvas and close dialog
        self.iface.mapCanvas().refreshAllLayers()
        self.close_dialog()      


    def master_estimate_result_selector(self):
        """ Button 49: Estimate result selector """

        # Create dialog 
        self.dlg = EstimateResultSelector()
        utils_giswater.setDialog(self.dlg)
        selected_tab = 0


        sql = ("SELECT value FROM "+ self.schema_name + ".config_param_system"
               " WHERE parameter='module_om_rehabit'")
        row = self.controller.get_row(sql)
        if row[0] == 'TRUE':
            selected_tab = 1
            self.dlg.tabWidget.removeTab(0)
            self.populate_combos(self.dlg.rpt_selector_rep_result_id, 'plan_result_cat', 'plan_selector_result')
            self.populate_combos(self.dlg.rpt_selector_result_reh_id, 'plan_result_reh_cat', 'plan_selector_result_reh')
        else:
            selected_tab = 0
            self.dlg.tabWidget.removeTab(1)
            self.populate_combos(self.dlg.rpt_selector_result_id, 'plan_result_cat', 'plan_selector_result')
        # Set signals
        self.dlg.btn_accept.clicked.connect(partial(self.master_estimate_result_selector_accept, selected_tab))
        self.dlg.btn_cancel.clicked.connect(self.close_dialog)
        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'estimate_result_selector')
        self.dlg.exec_()


    def populate_combos(self, combo, table_name, table_result):

        sql = ("SELECT result_id FROM " + self.schema_name + "."+table_name + " "
               " WHERE cur_user = current_user ORDER BY result_id")
        rows = self.controller.get_rows(sql)
        if not rows:
            return
        utils_giswater.fillComboBox(combo, rows, False)
        sql = ("SELECT result_id FROM " +self.schema_name + "." + table_result + " "
               " WHERE cur_user = current_user")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setSelectedItem(combo, str(row[0]))
        elif row is None and self.controller.last_error:
            self.controller.log_info(sql)
            return


    def upsert(self, combo, tablename):
        result_id = utils_giswater.getWidgetText(combo)
        fields = ['result_id']
        values = [result_id]
        self.controller.log_info(str(result_id))
        self.controller.log_info(str(fields))
        self.controller.log_info(str(values))
        sql = ("DELETE FROM " + self.schema_name + "." + tablename + " WHERE current_user = cur_user;"
               "\nINSERT INTO " + self.schema_name + "." + tablename + "  (result_id, cur_user)"
               " VALUES(" + result_id + ", current_user);")
        status = self.controller.execute_sql(sql)
        #status = self.controller.execute_upsert(tablename, 'cur_user', 'current_user', fields, values)

        if status:
            message = "Values has been updated"
            self.controller.show_info(message)

            # Refresh canvas
        self.iface.mapCanvas().refreshAllLayers()

    def master_estimate_result_selector_accept(self, selected_tab):
        """ Update value of table 'plan_selector_result' """
        self.controller.log_info(str(selected_tab))
        if selected_tab == 0:
            self.upsert('rpt_selector_result_id', 'plan_selector_result')
        else:
            self.upsert('rpt_selector_rep_result_id', 'plan_selector_result')
            self.upsert('rpt_selector_result_reh_id', 'plan_selector_result_reh')


    def master_estimate_result_manager(self):
        """ Button 50: Plan estimate result manager """

        # Create the dialog and signals
        self.dlg_merm = EstimateResultManager()
        utils_giswater.setDialog(self.dlg_merm)
        #TODO activar este boton cuando sea necesario
        self.dlg_merm.btn_delete.setVisible(False)
        # Tables
        self.tbl_reconstru = self.dlg_merm.findChild(QTableView, "tbl_reconstru")
        self.tbl_reconstru.setSelectionBehavior(QAbstractItemView.SelectRows)  # Select by rows instead of individual cells
        self.tbl_rehabit = self.dlg_merm.findChild(QTableView, "tbl_rehabit")
        self.tbl_rehabit.setSelectionBehavior(QAbstractItemView.SelectRows)  # Select by rows instead of individual cells
        # Set signals
        self.dlg_merm.btn_accept.pressed.connect(partial(self.charge_plan_estimate_result, self.dlg_merm))
        self.dlg_merm.btn_cancel.pressed.connect(partial(self.close_dialog, self.dlg_merm))
        self.dlg_merm.btn_delete.clicked.connect(partial(self.delete_merm, self.dlg_merm))
        self.dlg_merm.txt_name.textChanged.connect(partial(self.filter_merm, self.dlg_merm))

        set_edit_strategy = QSqlTableModel.OnManualSubmit
        self.fill_table(self.tbl_reconstru, self.schema_name+"."+"plan_result_cat", set_edit_strategy)
        self.fill_table(self.tbl_rehabit, self.schema_name + "." + "plan_result_reh_cat", set_edit_strategy)
        self.dlg_merm.exec_()


    def charge_plan_estimate_result(self, dialog):
        """ Send selected plan to 'plan_estimate_result_new.ui' """
        if dialog.tabWidget.currentIndex() == 0:
            selected_list = dialog.tbl_reconstru.selectionModel().selectedRows()

            if len(selected_list) == 0:
                message = "Any record selected"
                self.controller.show_warning(message)
                return
            row = selected_list[0].row()
            result_id = dialog.tbl_reconstru.model().record(row).value("result_id")
            self.close_dialog(dialog)
            self.master_estimate_result_new('plan_result_cat', result_id, 0)

        if dialog.tabWidget.currentIndex() == 1:
            selected_list = dialog.tbl_rehabit.selectionModel().selectedRows()
            if len(selected_list) == 0:
                message = "Any record selected"
                self.controller.show_warning(message)
                return
            row = selected_list[0].row()
            result_id = dialog.tbl_rehabit.model().record(row).value("result_id")
            self.close_dialog(dialog)
            self.master_estimate_result_new('plan_result_reh_cat', result_id, 1)


    def delete_merm(self, dialog):
        """ Delete selected row from 'master_estimate_result_manager' dialog from selected tab"""
        if dialog.tabWidget.currentIndex() == 0:
            self.multi_rows_delete(dialog.tbl_reconstru, 'plan_result_cat', 'result_id')
        if dialog.tabWidget.currentIndex() == 1:
            self.multi_rows_delete(dialog.tbl_rehabit, 'plan_result_reh_cat', 'result_id')


    def filter_merm(self, dialog):
        """ Filter rows from 'master_estimate_result_manager' dialog from selected tab"""
        if dialog.tabWidget.currentIndex() == 0:
            self.filter_by_text(dialog.tbl_reconstru, dialog.txt_name, 'plan_result_cat')
        if dialog.tabWidget.currentIndex() == 1:
            self.filter_by_text(dialog.tbl_rehabit, dialog.txt_name, 'plan_result_reh_cat')