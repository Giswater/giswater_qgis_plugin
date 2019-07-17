"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    from qgis.core import QgsComposition
    from qgis.PyQt.QtGui import QStringListModel
    from ..map_tools.snapping_utils_v2 import SnappingConfigManager
else:
    from qgis.PyQt.QtCore import QStringListModel
    from qgis.core import QgsLayout
    from ..map_tools.snapping_utils_v3 import SnappingConfigManager

from qgis.core import QgsFeatureRequest, QgsExpression, QgsExpressionContextUtils, QgsProject, QgsVectorLayer
from qgis.gui import QgsMapToolEmitPoint, QgsVertexMarker
from qgis.PyQt.QtCore import Qt, QDate, QTime
from qgis.PyQt.QtWidgets import QLineEdit, QTextEdit, QAction, QCompleter, QAbstractItemView
from qgis.PyQt.QtGui import QColor
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtXml import QDomDocument

import os
import operator
from functools import partial

from .. import utils_giswater
from .parent import ParentAction
from .mincut_config import MincutConfig
from .multiple_selection import MultipleSelection
from ..ui_manager import Mincut
from ..ui_manager import Mincut_fin
from ..ui_manager import Mincut_add_hydrometer
from ..ui_manager import Mincut_add_connec
from ..ui_manager import MincutComposer


class MincutParent(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class constructor """

        # Call ParentAction constructor
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.canvas = self.iface.mapCanvas()
        
        # Create separate class to manage 'actionConfig'
        self.mincut_config = MincutConfig(self)                

        # Get layers of node, arc, connec group
        self.node_group = []
        self.layers_connec = None
        self.arc_group = []
        self.hydro_list = []
        self.deleted_list = []
        self.connec_list = []

        # Serialize data of table 'anl_mincut_cat_state'
        self.set_states()
        self.current_state = None
        self.is_new = True


    def set_states(self):
        """ Serialize data of table 'anl_mincut_cat_state' """
        
        self.states = {}
        sql = ("SELECT id, name "
               "FROM " + self.schema_name + ".anl_mincut_cat_state "
               "ORDER BY id")
        rows = self.controller.get_rows(sql)
        if not rows:
            return
        
        for row in rows:
            self.states[row['id']] = row['name']
        
        
    def init_mincut_form(self):
        """ Custom form initial configuration """

        # Create the appropriate map tool and connect the gotPoint() signal.
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.connec_list = []
        self.hydro_list = []
        self.deleted_list = []

        # Snapper
        self.snapper_manager = SnappingConfigManager(self.iface)
        self.snapper = self.snapper_manager.get_snapper()

        # Refresh canvas, remove all old selections
        self.remove_selection()      

        self.dlg_mincut = Mincut()
        self.load_settings(self.dlg_mincut)
        self.dlg_mincut.setWindowFlags(Qt.WindowStaysOnTopHint)

        # Parametrize list of layers
        self.layers_connec = self.controller.get_group_layers('connec')                        
        self.layer_node = self.controller.get_layer_by_tablename("v_edit_node")
        self.layer_arc = self.controller.get_layer_by_tablename("v_edit_arc")                

        # Control current layer (due to QGIS bug in snapping system)
        if self.canvas.currentLayer() is None:
            self.iface.setActiveLayer(self.layer_node)

        self.result_mincut_id = self.dlg_mincut.findChild(QLineEdit, "result_mincut_id")
        self.customer_state = self.dlg_mincut.findChild(QLineEdit, "customer_state")
        self.work_order = self.dlg_mincut.findChild(QLineEdit, "work_order")
        self.pred_description = self.dlg_mincut.findChild(QTextEdit, "pred_description")
        self.real_description = self.dlg_mincut.findChild(QTextEdit, "real_description")
        self.distance = self.dlg_mincut.findChild(QLineEdit, "distance")
        self.depth = self.dlg_mincut.findChild(QLineEdit, "depth")
        
        utils_giswater.double_validator(self.distance, 0, 9999999, 3)
        utils_giswater.double_validator(self.depth, 0, 9999999, 3)

        # Manage address
        self.adress_init_config(self.dlg_mincut)

        # Set signals
        self.dlg_mincut.btn_accept.clicked.connect(self.accept_save_data)        
        self.dlg_mincut.btn_cancel.clicked.connect(self.mincut_close)
        self.dlg_mincut.dlg_rejected.connect(self.mincut_close)
        self.dlg_mincut.btn_start.clicked.connect(self.real_start)
        self.dlg_mincut.btn_end.clicked.connect(self.real_end)

        # Fill ComboBox type
        sql = ("SELECT id, descript "
               "FROM " + self.schema_name + ".anl_mincut_cat_type "
               "ORDER BY id")
        rows = self.controller.get_rows(sql)
        utils_giswater.set_item_data(self.dlg_mincut.type, rows, 1)

        # Fill ComboBox cause
        sql = ("SELECT id, descript "
               "FROM " + self.schema_name + ".anl_mincut_cat_cause "
               "ORDER BY id")
        rows = self.controller.get_rows(sql)
        utils_giswater.set_item_data(self.dlg_mincut.cause, rows, 1)

        # Fill ComboBox assigned_to and exec_user
        sql = ("SELECT id, name "
               "FROM " + self.schema_name + ".cat_users "
               "ORDER BY name")
        rows = self.controller.get_rows(sql)
        utils_giswater.set_item_data(self.dlg_mincut.assigned_to, rows, 1)
        utils_giswater.fillComboBox(self.dlg_mincut, "exec_user", rows, False)
        self.dlg_mincut.exec_user.setVisible(False)

        # Toolbar actions
        action = self.dlg_mincut.findChild(QAction, "actionConfig")
        action.triggered.connect(self.mincut_config.config)
        self.set_icon(action, "99")
        self.action_config = action

        action = self.dlg_mincut.findChild(QAction, "actionMincut")
        action.triggered.connect(self.auto_mincut)
        self.set_icon(action, "126")
        self.action_mincut = action

        action = self.dlg_mincut.findChild(QAction, "actionCustomMincut")
        action.triggered.connect(self.custom_mincut)
        self.set_icon(action, "123")
        self.action_custom_mincut = action

        action = self.dlg_mincut.findChild(QAction, "actionAddConnec")
        action.triggered.connect(self.add_connec)
        self.set_icon(action, "121")
        self.action_add_connec = action

        action = self.dlg_mincut.findChild(QAction, "actionAddHydrometer")
        action.triggered.connect(self.add_hydrometer)
        self.set_icon(action, "122")
        self.action_add_hydrometer = action

        action = self.dlg_mincut.findChild(QAction, "actionComposer")
        action.triggered.connect(self.mincut_composer)
        self.set_icon(action, "181")
        self.action_mincut_composer = action

        # Show future id of mincut
        self.set_id_val()

        # Set state name
        utils_giswater.setWidgetText(self.dlg_mincut, self.dlg_mincut.state, str(self.states[0]))
        self.current_state = 0        
        
        self.sql_connec = ""
        self.sql_hydro = ""
        
        self.dlg_mincut.show()


    def set_id_val(self):

        # Show future id of mincut
        result_mincut_id = 1
        sql = ("SELECT setval('" +self.schema_name+".anl_mincut_result_cat_seq', (SELECT max(id::integer) FROM " + self.schema_name + ".anl_mincut_result_cat), true)")
        row = self.controller.get_row(sql, log_sql=True)
        if row:
            if row[0]:
                if self.is_new:
                    result_mincut_id = str(int(row[0])+1)

        self.result_mincut_id.setText(str(result_mincut_id))


    def mg_mincut(self):
        """ Button 26: New Mincut """

        self.is_new = True
        self.init_mincut_form()
        self.action = "mg_mincut"

        # Get current date. Set all QDateEdit to current date
        date_start = QDate.currentDate()
        utils_giswater.setCalendarDate(self.dlg_mincut, "cbx_date_start", date_start)
        utils_giswater.setCalendarDate(self.dlg_mincut, "cbx_date_end", date_start)
        utils_giswater.setCalendarDate(self.dlg_mincut, "cbx_recieved_day", date_start)
        utils_giswater.setCalendarDate(self.dlg_mincut, "cbx_date_start_predict", date_start)
        utils_giswater.setCalendarDate(self.dlg_mincut, "cbx_date_end_predict", date_start)
        
        # Get current time
        current_time = QTime.currentTime()
        self.dlg_mincut.cbx_recieved_time.setTime(current_time)     

        # Enable/Disable widget depending state
        self.enable_widgets('0')

        self.dlg_mincut.show()


    def mincut_close(self):
        
        self.dlg_mincut.closeMainWin = True
        self.dlg_mincut.mincutCanceled = True

        # If id exists in data base on btn_cancel delete
        if self.action == "mg_mincut":
            result_mincut_id = self.dlg_mincut.result_mincut_id.text()
            sql = ("SELECT id FROM " + self.schema_name + ".anl_mincut_result_cat"
                   " WHERE id = " + str(result_mincut_id))
            row = self.controller.get_row(sql)
            if row:
                sql = ("DELETE FROM " + self.schema_name + ".anl_mincut_result_cat"
                       " WHERE id = " + str(result_mincut_id))
                self.controller.execute_sql(sql)
                self.controller.show_info("Mincut canceled!")                   
        
        # Rollback transaction
        else:
            self.controller.dao.rollback()
            
        # Close dialog, save dialog position, and disconnect snapping
        self.close_dialog(self.dlg_mincut)
        self.disconnect_snapping()
        self.refresh_map_canvas()
        
    
    def disconnect_snapping(self, action_pan=True):
        """ Select 'Pan' as current map tool and disconnect snapping """

        try:
            self.canvas.xyCoordinates.disconnect()             
            self.emit_point.canvasClicked.disconnect()
            if action_pan:
                self.iface.actionPan().trigger()     
            self.vertex_marker.hide()
        except Exception:          
            pass


    def real_start(self):

        date_start = QDate.currentDate()
        time_start = QTime.currentTime()
        self.dlg_mincut.cbx_date_start.setDate(date_start)
        self.dlg_mincut.cbx_hours_start.setTime(time_start)
        self.dlg_mincut.cbx_date_end.setDate(date_start)
        self.dlg_mincut.cbx_hours_end.setTime(time_start)
        self.dlg_mincut.btn_end.setEnabled(True)
        self.dlg_mincut.distance.setEnabled(True)
        self.dlg_mincut.depth.setEnabled(True)
        self.dlg_mincut.real_description.setEnabled(True)

        # Set state to 'In Progress'
        utils_giswater.setWidgetText(self.dlg_mincut, self.dlg_mincut.state, str(self.states[1]))
        self.current_state = 1

        # Enable/Disable widget depending state
        self.enable_widgets('1')


    def real_end(self):

        # Create the dialog and signals
        self.dlg_fin = Mincut_fin()
        self.load_settings(self.dlg_fin)

        mincut = utils_giswater.getWidgetText(self.dlg_mincut, self.dlg_mincut.result_mincut_id)
        utils_giswater.setWidgetText(self.dlg_fin, self.dlg_fin.mincut, mincut)
        work_order = utils_giswater.getWidgetText(self.dlg_mincut, self.dlg_mincut.work_order)
        if str(work_order) != 'null':
            utils_giswater.setWidgetText(self.dlg_fin, self.dlg_fin.work_order, work_order)

        # Manage address
        self.adress_init_config(self.dlg_fin)
        municipality_current = str(self.dlg_mincut.address_exploitation.currentText())
        utils_giswater.setWidgetText(self.dlg_fin, self.dlg_fin.address_exploitation, municipality_current)
        address_postal_code_current = str(self.dlg_mincut.address_postal_code.currentText())
        utils_giswater.setWidgetText(self.dlg_fin, self.dlg_fin.address_postal_code, address_postal_code_current)
        address_street_current = str(self.dlg_mincut.address_street.currentText())
        utils_giswater.setWidgetText(self.dlg_fin, self.dlg_fin.address_street, address_street_current)
        address_number_current = str(self.dlg_mincut.address_number.currentText())
        utils_giswater.setWidgetText(self.dlg_fin, self.dlg_fin.address_number, address_number_current)

        # Fill ComboBox exec_user
        sql = ("SELECT name "
               "FROM " + self.schema_name + ".cat_users "
               "ORDER BY name")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_fin, "exec_user", rows, False)
        assigned_to = utils_giswater.get_item_data(self.dlg_mincut, self.dlg_mincut.assigned_to, 1)
        utils_giswater.setWidgetText(self.dlg_fin, "exec_user", str(assigned_to))

        date_start = self.dlg_mincut.cbx_date_start.date()
        time_start = self.dlg_mincut.cbx_hours_start.time()
        self.dlg_fin.cbx_date_start_fin.setDate(date_start)
        self.dlg_fin.cbx_hours_start_fin.setTime(time_start)
        date_end = self.dlg_mincut.cbx_date_end.date()
        time_end = self.dlg_mincut.cbx_hours_end.time()
        self.dlg_fin.cbx_date_end_fin.setDate(date_end)
        self.dlg_fin.cbx_hours_end_fin.setTime(time_end) 

        # Set state to 'Finished'
        utils_giswater.setWidgetText(self.dlg_mincut, self.dlg_mincut.state, str(self.states[2]))
        self.current_state = 2                 

        # Enable/Disable widget depending state
        self.enable_widgets('2')
        
        # Set signals
        self.dlg_fin.btn_accept.clicked.connect(self.real_end_accept)
        self.dlg_fin.btn_cancel.clicked.connect(self.real_end_cancel)
        self.dlg_fin.btn_set_real_location.clicked.connect(self.set_real_location)        

        # Open the dialog
        self.dlg_fin.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_fin.show()


    def set_real_location(self):

        # Activate snapping of node and arcs
        self.canvas.xyCoordinates.connect(self.mouse_move_node_arc)        
        self.emit_point.canvasClicked.connect(self.snapping_node_arc_real_location)


    def accept_save_data(self):
        """ Slot function button 'Accept' """

        mincut_result_state = self.current_state

        # Manage 'address'
        address_exploitation_id = utils_giswater.get_item_data(self.dlg_mincut, self.dlg_mincut.address_exploitation)
        address_postal_code = utils_giswater.getWidgetText(self.dlg_mincut, self.dlg_mincut.address_postal_code, return_string_null=False)
        address_street = utils_giswater.get_item_data(self.dlg_mincut, self.dlg_mincut.address_street)
        address_number = utils_giswater.getWidgetText(self.dlg_mincut, self.dlg_mincut.address_number)

        mincut_result_type = utils_giswater.get_item_data(self.dlg_mincut, self.dlg_mincut.type, 0)
        anl_cause = utils_giswater.get_item_data(self.dlg_mincut, self.dlg_mincut.cause, 0)
        work_order = self.work_order.text()

        anl_descript = utils_giswater.getWidgetText(self.dlg_mincut, "pred_description", return_string_null=False)
        exec_from_plot = str(self.distance.text())
        exec_depth = str(self.depth.text())
        exec_descript = utils_giswater.getWidgetText(self.dlg_mincut, "real_description", return_string_null=False)
        exec_user = utils_giswater.getWidgetText(self.dlg_mincut, "exec_user", return_string_null=False)
        
        # Get prediction date - start
        date_start_predict = self.dlg_mincut.cbx_date_start_predict.date()
        time_start_predict = self.dlg_mincut.cbx_hours_start_predict.time()
        forecast_start_predict = date_start_predict.toString('yyyy-MM-dd') + " " + time_start_predict.toString('HH:mm:ss')

        # Get prediction date - end
        date_end_predict = self.dlg_mincut.cbx_date_end_predict.date()
        time_end_predict = self.dlg_mincut.cbx_hours_end_predict.time()
        forecast_end_predict = date_end_predict.toString('yyyy-MM-dd') + " " + time_end_predict.toString('HH:mm:ss')

        # Get real date - start
        date_start_real = self.dlg_mincut.cbx_date_start.date()
        time_start_real = self.dlg_mincut.cbx_hours_start.time()
        forecast_start_real = date_start_real.toString('yyyy-MM-dd') + " " + time_start_real.toString('HH:mm:ss')

        # Get real date - end
        date_end_real = self.dlg_mincut.cbx_date_end.date()
        time_end_real = self.dlg_mincut.cbx_hours_end.time()
        forecast_end_real = date_end_real.toString('yyyy-MM-dd') + " " + time_end_real.toString('HH:mm:ss')

        # Check data
        received_day = self.dlg_mincut.cbx_recieved_day.date()
        received_time = self.dlg_mincut.cbx_recieved_time.time()
        received_date = received_day.toString('yyyy-MM-dd') + " " + received_time.toString('HH:mm:ss')

        assigned_to = utils_giswater.get_item_data(self.dlg_mincut, self.dlg_mincut.assigned_to, 0)
        cur_user = self.controller.get_project_user()
        appropiate_status = utils_giswater.isChecked(self.dlg_mincut, "appropiate")

        check_data = [str(mincut_result_state), str(anl_cause), str(received_date), 
                      str(forecast_start_predict), str(forecast_end_predict)]
        for data in check_data:
            if data == '':
                message = "Some mandatory field is missing. Please, review your data"
                self.controller.show_warning(message)
                return

        if self.is_new:
            self.set_id_val()
            self.is_new = False

        # Check if id exist in table 'anl_mincut_result_cat'
        result_mincut_id = self.result_mincut_id.text()        
        sql = ("SELECT id FROM " + self.schema_name + ".anl_mincut_result_cat " 
               "WHERE id = '" + str(result_mincut_id) + "';")
        rows = self.controller.get_rows(sql)
        
        # If not found Insert just its 'id'
        sql = ""
        if not rows:
            sql = ("INSERT INTO " + self.schema_name + ".anl_mincut_result_cat (id) "
                   "VALUES ('" + str(result_mincut_id) + "');\n")

        # Update all the fields
        sql += ("UPDATE " + self.schema_name + ".anl_mincut_result_cat"
                " SET mincut_state = '" + str(mincut_result_state) + "',"
                " mincut_type = '" + str(mincut_result_type) + "', anl_cause = '" + str(anl_cause) + "',"
                " anl_tstamp = '" + str(received_date) + "', received_date = '" + str(received_date) + "',"
                " forecast_start = '" + str(forecast_start_predict) + "', forecast_end = '" + str(forecast_end_predict) + "',"
                " assigned_to = '" + str(assigned_to) + "', exec_appropiate = '" + str(appropiate_status) + "'")
        
        # Manage fields 'work_order' and 'anl_descript'
        if work_order != "":        
            sql += ", work_order = $$" + str(work_order) + "$$"
        if anl_descript != "":        
            sql += ", anl_descript = $$" + str(anl_descript) + "$$ "
        
        # Manage address
        if address_exploitation_id != -1:        
            sql += ", muni_id = '" + str(address_exploitation_id) + "'"
        if address_street != -1:
            sql += ", streetaxis_id = '" + str(address_street) + "'"
        if address_postal_code:
            sql += ", postcode = '" + str(address_postal_code) + "'"            
        if address_number:
            sql += ", postnumber = '" + str(address_number) + "'"

        # If state 'In Progress' or 'Finished'
        if mincut_result_state == 1 or mincut_result_state == 2:
            sql += ", exec_start = '" + str(forecast_start_real) + "', exec_end = '" + str(forecast_end_real) + "'"
            if exec_from_plot != '':
                sql += ", exec_from_plot = '" + str(exec_from_plot) + "'"
            if exec_depth != '':
                sql += ",  exec_depth = '" + str(exec_depth) + "'"
            if exec_descript != '':
                sql += ", exec_descript = $$" + str(exec_descript) + "$$"
            if exec_user != '':
                sql += ", exec_user = '" + str(exec_user) + "'"
            else:
                sql += ", exec_user = '" + str(cur_user) + "'"    
                
        sql += " WHERE id = '" + str(result_mincut_id) + "';\n"
        
        # Update table 'anl_mincut_result_selector'
        sql += ("DELETE FROM " + self.schema_name + ".anl_mincut_result_selector WHERE cur_user = current_user;\n"
                "INSERT INTO " + self.schema_name + ".anl_mincut_result_selector (cur_user, result_id) VALUES "
                "(current_user, " + str(result_mincut_id) + ");")
        
        # Check if any 'connec' or 'hydro' associated
        if self.sql_connec != "":
            sql += self.sql_connec
                
        if self.sql_hydro != "":
            sql += self.sql_hydro
                            
        status = self.controller.execute_sql(sql, log_error=True)
        if status:                                  
            message = "Values has been updated"
            self.controller.show_info(message)
            self.update_result_selector(result_mincut_id, commit=True)
        else:
            message = "Error updating element in table, you need to review data"
            self.controller.show_warning(message)           
        
        # Close dialog and disconnect snapping
        self.disconnect_snapping()

        sql = ("SELECT mincut_state, mincut_class FROM " + self.schema_name + ".anl_mincut_result_cat "
               " WHERE id = '" + str(result_mincut_id) + "'")
        row = self.controller.get_row(sql)
        if row:
            if str(row[0]) == '0' and str(row[1]) == '1':
                cur_user = self.controller.get_project_user()
                result_mincut_id_text = self.dlg_mincut.result_mincut_id.text()
                sql = ("SELECT " + self.schema_name + ".gw_fct_mincut_result_overlap('"+str(result_mincut_id_text) + "', '" + str(cur_user) + "');")
                row = self.controller.get_row(sql, commit=True)
                if row:
                    if row[0]:
                        message = "Mincut done, but has conflict and overlaps with "
                        answer = self.controller.ask_question(message, "Change dates", parameter=row[0])
                        if answer:
                            sql = ("SELECT * FROM " + self.schema_name + ".selector_audit"
                                   " WHERE fprocesscat_id='31' AND cur_user=current_user")
                            row = self.controller.get_row(sql, log_sql=False)
                            if not row:
                                sql = ("INSERT INTO " + self.schema_name + ".selector_audit(fprocesscat_id, cur_user) "
                                       " VALUES('31', current_user)")
                                self.controller.execute_sql(sql, log_sql=False)
                            views = 'v_anl_arc, v_anl_node, v_anl_connec'
                            message = "To see the conflicts load the views"
                            self.controller.show_info_box(message, "See layers", parameter=views)
                            self.dlg_mincut.close()
                    else:
                        self.dlg_mincut.closeMainWin = True
                        self.dlg_mincut.mincutCanceled = False
                        self.dlg_mincut.close()

            else:
                self.dlg_mincut.closeMainWin = True
                self.dlg_mincut.mincutCanceled = False
                self.dlg_mincut.close()
        else:
            self.dlg_mincut.closeMainWin = True
            self.dlg_mincut.mincutCanceled = False
            self.dlg_mincut.close()

        self.iface.actionPan().trigger()


    def update_result_selector(self, result_mincut_id, commit=True):    
        """ Update table 'anl_mincut_result_selector' """    
            
        sql = ("DELETE FROM " + self.schema_name + ".anl_mincut_result_selector WHERE cur_user = current_user;"    
               "\nINSERT INTO " + self.schema_name + ".anl_mincut_result_selector (cur_user, result_id) VALUES"    
               " (current_user, " + str(result_mincut_id) + ");")    
        status = self.controller.execute_sql(sql, commit)    
        if not status:    
            message = "Error updating table"    
            self.controller.show_warning(message, parameter='anl_mincut_result_selector')   
                

    def real_end_accept(self):

        # Get end_date and end_hour from mincut_fin dialog
        exec_start_day = self.dlg_fin.cbx_date_start_fin.date()
        exec_start_time = self.dlg_fin.cbx_hours_start_fin.time()
        exec_end_day = self.dlg_fin.cbx_date_end_fin.date()
        exec_end_time = self.dlg_fin.cbx_hours_end_fin.time()
 
        # Set new values in mincut dialog also
        self.dlg_mincut.cbx_date_start.setDate(exec_start_day)
        self.dlg_mincut.cbx_hours_start.setTime(exec_start_time)
        self.dlg_mincut.cbx_date_end.setDate(exec_end_day)
        self.dlg_mincut.cbx_hours_end.setTime(exec_end_time)
        utils_giswater.setWidgetText(self.dlg_mincut, self.dlg_mincut.work_order, str(self.dlg_fin.work_order.text()))
        municipality = self.dlg_fin.address_exploitation.currentText()
        utils_giswater.setWidgetText(self.dlg_mincut, self.dlg_mincut.address_exploitation, municipality)
        street = self.dlg_fin.address_street.currentText()
        utils_giswater.setWidgetText(self.dlg_mincut, self.dlg_mincut.address_street, street)
        number = self.dlg_fin.address_number.currentText()
        utils_giswater.setWidgetText(self.dlg_mincut, self.dlg_mincut.address_number, number)
        postal_code = self.dlg_fin.address_postal_code.currentText()
        utils_giswater.setWidgetText(self.dlg_mincut, self.dlg_mincut.address_postal_code, postal_code)
        exec_user = utils_giswater.getWidgetText(self.dlg_fin, self.dlg_fin.exec_user)
        utils_giswater.setWidgetText(self.dlg_mincut, self.dlg_mincut.exec_user, exec_user)

        self.dlg_fin.close()


    def real_end_cancel(self):

        # Return to state 'In Progress'
        utils_giswater.setWidgetText(self.dlg_mincut, self.dlg_mincut.state, str(self.states[1]))
        self.enable_widgets('1')
        
        self.dlg_fin.close()


    def add_connec(self):
        """ B3-121: Connec selector """

        result_mincut_id_text = self.dlg_mincut.result_mincut_id.text()

        # Check if id exist in anl_mincut_result_cat
        sql = ("SELECT id FROM " + self.schema_name + ".anl_mincut_result_cat"
               " WHERE id = '" + str(result_mincut_id_text) + "';")
        exist_id = self.controller.get_row(sql)
        if not exist_id:
            sql = ("INSERT INTO " + self.schema_name + ".anl_mincut_result_cat (id, mincut_class) "
                   " VALUES ('" + str(result_mincut_id_text) + "', 2);")
            self.controller.execute_sql(sql)

        # Disable Auto, Custom, Hydrometer
        self.action_mincut.setDisabled(True)
        self.action_custom_mincut.setDisabled(True)
        self.action_add_hydrometer.setDisabled(True)

        # Set dialog add_connec
        self.dlg_connec = Mincut_add_connec()
        self.dlg_connec.setWindowTitle("Connec management")
        self.load_settings(self.dlg_connec)
        self.dlg_connec.tbl_mincut_connec.setSelectionBehavior(QAbstractItemView.SelectRows)
        # Set icons
        self.set_icon(self.dlg_connec.btn_insert, "111")
        self.set_icon(self.dlg_connec.btn_delete, "112")
        self.set_icon(self.dlg_connec.btn_snapping, "129")

        # Set signals
        self.dlg_connec.btn_insert.clicked.connect(partial(self.insert_connec))
        self.dlg_connec.btn_delete.clicked.connect(partial(self.delete_records_connec))
        self.dlg_connec.btn_snapping.clicked.connect(self.snapping_init_connec)
        self.dlg_connec.btn_accept.clicked.connect(partial(self.accept_connec, self.dlg_connec, "connec"))
        self.dlg_connec.rejected.connect(partial(self.close_dialog, self.dlg_connec))
        # self.dlg_connec.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_connec))
        
        # Set autocompleter for 'customer_code'
        self.set_completer_customer_code(self.dlg_connec.connec_id)

        # On opening form check if result_id already exist in anl_mincut_result_connec
        # if exist show data in form / show selection!!!
        if exist_id:
            # Read selection and reload table
            self.select_features_connec()
        self.snapping_selection_connec()
        self.dlg_connec.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_connec.show()

        
    def set_completer_customer_code(self, widget, set_signal=False):
        """ Set autocompleter for 'customer_code' """
        
        # Get list of 'customer_code'
        sql = "SELECT DISTINCT(customer_code) FROM " + self.schema_name + ".v_edit_connec"
        rows = self.controller.get_rows(sql)
        values = []
        if rows:
            for row in rows:
                values.append(str(row[0]))

        # Adding auto-completion to a QLineEdit
        self.completer = QCompleter()
        widget.setCompleter(self.completer)
        model = QStringListModel()
        model.setStringList(values)
        self.completer.setModel(model)        
        
        if set_signal:
            self.completer.activated.connect(self.auto_fill_hydro_id)          
        

    def snapping_init_connec(self):
        """ Snap connec """

        multiple_snapping = MultipleSelection(self.iface, self.controller, self.layers_connec, self)       
        self.canvas.setMapTool(multiple_snapping)        
        self.canvas.selectionChanged.connect(partial(self.snapping_selection_connec))     
        cursor = self.get_cursor_multiple_selection()
        self.canvas.setCursor(cursor)


    def snapping_init_hydro(self):
        """ Snap also to connec (hydrometers has no geometry) """

        multiple_snapping = MultipleSelection(self.iface, self.controller, self.layers_connec, self)
        self.canvas.setMapTool(multiple_snapping)
        self.canvas.selectionChanged.connect(
            partial(self.snapping_selection_hydro, self.layers_connec, "rtc_hydrometer", "connec_id"))
        cursor = self.get_cursor_multiple_selection()
        self.canvas.setCursor(cursor)        


    def snapping_selection_hydro(self):
        """ Snap to connec layers to add its hydrometers """
        
        self.connec_list = []
        
        for layer in self.layers_connec:                      
            if layer.selectedFeatureCount() > 0:
                # Get selected features of the layer
                features = layer.selectedFeatures()
                # Get id from all selected features
                for feature in features:
                    connec_id = feature.attribute("connec_id")
                    # Add element
                    if connec_id in self.connec_list:
                        message = "Feature already in the list"
                        self.controller.show_info_box(message, parameter=connec_id)
                        return
                    else:
                        self.connec_list.append(connec_id)
        
        # Set 'expr_filter' with features that are in the list
        expr_filter = "\"connec_id\" IN ("
        for i in range(len(self.connec_list)):
            expr_filter += "'" + str(self.connec_list[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"
        if len(self.connec_list) == 0:
            expr_filter = "\"connec_id\" =''"
        # Check expression
        (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
        if not is_valid:
            return        

        self.reload_table_hydro(expr_filter)


    def snapping_selection_connec(self):
        """ Snap to connec layers """
        
        self.connec_list = []
        
        for layer in self.layers_connec:                      
            if layer.selectedFeatureCount() > 0:
                # Get selected features of the layer
                features = layer.selectedFeatures()
                # Get id from all selected features
                for feature in features:
                    connec_id = feature.attribute("connec_id")
                    # Add element
                    if connec_id not in self.connec_list:
                        self.connec_list.append(connec_id)
        
        expr_filter = None
        if len(self.connec_list) > 0:
            # Set 'expr_filter' with features that are in the list
            expr_filter = "\"connec_id\" IN ("
            for i in range(len(self.connec_list)):
                expr_filter += "'" + str(self.connec_list[i]) + "', "
            expr_filter = expr_filter[:-2] + ")"
            if len(self.connec_list) == 0:
                expr_filter = "\"connec_id\" =''"
            # Check expression
            (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
            if not is_valid:
                return                           
        
        self.reload_table_connec(expr_filter)


    def add_hydrometer(self):
        """ B4-122: Hydrometer selector """
        self.connec_list = []
        result_mincut_id_text = self.dlg_mincut.result_mincut_id.text()

        # Check if id exist in table 'anl_mincut_result_cat'
        sql = ("SELECT id FROM " + self.schema_name + ".anl_mincut_result_cat"
               " WHERE id = '" + str(result_mincut_id_text) + "';")
        exist_id = self.controller.get_row(sql)
        if not exist_id:
            sql = ("INSERT INTO " + self.schema_name + ".anl_mincut_result_cat (id, mincut_class)"
                   " VALUES ('" + str(result_mincut_id_text) + "', 3);")
            self.controller.execute_sql(sql)

        # On inserting work order
        self.action_mincut.setDisabled(True)
        self.action_custom_mincut.setDisabled(True)
        self.action_add_connec.setDisabled(True)

        # Set dialog Mincut_add_hydrometer
        self.dlg_hydro = Mincut_add_hydrometer()
        self.load_settings(self.dlg_hydro)
        self.dlg_hydro.setWindowTitle("Hydrometer management")
        self.dlg_hydro.tbl_hydro.setSelectionBehavior(QAbstractItemView.SelectRows)
        # self.dlg_hydro.btn_snapping.setEnabled(False)
        
        # Set icons
        self.set_icon(self.dlg_hydro.btn_insert, "111")
        self.set_icon(self.dlg_hydro.btn_delete, "112")
        #self.set_icon(self.dlg_hydro.btn_snapping, "129")

        # Set dignals
        self.dlg_hydro.btn_insert.clicked.connect(partial(self.insert_hydro))
        self.dlg_hydro.btn_delete.clicked.connect(partial(self.delete_records_hydro))
        # self.dlg_hydro.btn_snapping.clicked.connect(self.snapping_init_hydro)
        self.dlg_hydro.btn_accept.clicked.connect(partial(self.accept_hydro, self.dlg_hydro, "hydrometer"))

        # Set autocompleter for 'customer_code'
        self.set_completer_customer_code(self.dlg_hydro.customer_code_connec, True)

        # Set signal to reach selected value from QCompleter
        if exist_id:
            # Read selection and reload table
            self.select_features_hydro()

        self.dlg_hydro.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_hydro.show()


    def auto_fill_hydro_id(self):

        # Adding auto-completion to a QLineEdit - hydrometer_id
        self.completer_hydro = QCompleter()
        self.dlg_hydro.hydrometer_cc.setCompleter(self.completer_hydro)
        model = QStringListModel()

        # Get 'connec_id' from 'customer_code'
        customer_code = str(self.dlg_hydro.customer_code_connec.text())
        connec_id = self.get_connec_id_from_customer_code(customer_code)
        if connec_id is None:
            return        
        
        # Get 'hydrometers' related with this 'connec'
        sql = ("SELECT DISTINCT(hydrometer_customer_code)"
               " FROM " + self.schema_name + ".v_rtc_hydrometer"
               " WHERE connec_id = '" + str(connec_id) + "'")
        rows = self.controller.get_rows(sql)
        values = []
        for row in rows:
            values.append(str(row[0]))

        model.setStringList(values)
        self.completer_hydro.setModel(model)


    def insert_hydro(self):
        """ Select feature with entered id. Set a model with selected filter.
            Attach that model to selected table 
        """

        # Check if user entered hydrometer_id
        hydrometer_cc = utils_giswater.getWidgetText(self.dlg_hydro, self.dlg_hydro.hydrometer_cc)
        if hydrometer_cc == "null":
            message = "You need to enter hydrometer_id"
            self.controller.show_info_box(message)
            return
                        
        # Show message if element is already in the list
        if hydrometer_cc in self.hydro_list:
            message = "Selected element already in the list"
            self.controller.show_info_box(message, parameter=hydrometer_cc)
            return
        
        # Check if hydrometer_id belongs to any 'connec_id'
        sql = ("SELECT hydrometer_id FROM " + self.schema_name + ".v_rtc_hydrometer"
               " WHERE hydrometer_customer_code = '" + str(hydrometer_cc) + "'")
        row = self.controller.get_row(sql, log_sql=False)
        if not row:
            message = "Selected hydrometer_id not found"
            self.controller.show_info_box(message, parameter=hydrometer_cc)
            return

        if row[0] in self.hydro_list:
            message = "Selected element already in the list"
            self.controller.show_info_box(message, parameter=hydrometer_cc)
            return

        # Set expression filter with 'hydro_list'

        if row[0] in self.deleted_list:
            self.deleted_list.remove(row[0])
        self.hydro_list.append(row[0])
        expr_filter = "\"hydrometer_id\" IN ("
        for i in range(len(self.hydro_list)):
            expr_filter += "'" + str(self.hydro_list[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"
        
        # Reload table
        self.reload_table_hydro(expr_filter)


    def select_features_group_layers(self, expr):
        """ Select features of the layers filtering by @expr """
        
        # Iterate over all layers of type 'connec'
        # Select features and them to 'connec_list'
        for layer in self.layers_connec:
            it = layer.getFeatures(QgsFeatureRequest(expr))
            # Build a list of feature id's from the previous result
            id_list = [i.id() for i in it]
            # Select features with these id's
            layer.selectByIds(id_list)
            if layer.selectedFeatureCount() > 0:
                # Get selected features of the layer
                features = layer.selectedFeatures()
                for feature in features:
                    connec_id = feature.attribute("connec_id")
                    # Check if 'connec_id' is already in 'connec_list'
                    if connec_id not in self.connec_list:
                        self.connec_list.append(connec_id)              
        

    def select_features_connec(self):
        """ Select features of 'connec' of selected mincut """
                    
        # Set 'expr_filter' of connecs related with current mincut
        result_mincut_id = utils_giswater.getWidgetText(self.dlg_connec, self.result_mincut_id)
        sql = ("SELECT connec_id FROM " + self.schema_name + ".anl_mincut_result_connec"
               " WHERE result_id = " + str(result_mincut_id))
        rows = self.controller.get_rows(sql)
        if rows:
            expr_filter = "\"connec_id\" IN ("
            for row in rows:
                if row[0] not in self.connec_list and row[0] not in self.deleted_list:
                    self.connec_list.append(row[0])
            for connec_id in self.connec_list:
                expr_filter += "'" + str(connec_id) + "', "
            expr_filter = expr_filter[:-2] + ")"
            if len(self.connec_list) == 0:
                expr_filter = "\"connec_id\" =''"
            # Check expression
            (is_valid, expr) = self.check_expression(expr_filter)
            if not is_valid:
                return     
    
            # Select features of the layers filtering by @expr
            self.select_features_group_layers(expr)         
                                                        
            # Reload table
            self.reload_table_connec(expr_filter)


    def select_features_hydro(self):
        
        self.connec_list = []

        # Set 'expr_filter' of connecs related with current mincut
        result_mincut_id = utils_giswater.getWidgetText(self.dlg_hydro, self.result_mincut_id)
        sql = ("SELECT DISTINCT(connec_id) FROM " + self.schema_name + ".rtc_hydrometer_x_connec AS rtc"
               " INNER JOIN " + self.schema_name + ".anl_mincut_result_hydrometer AS anl"
               " ON anl.hydrometer_id = rtc.hydrometer_id"
               " WHERE result_id = " + str(result_mincut_id))
        rows = self.controller.get_rows(sql)
        if rows:
            expr_filter = "\"connec_id\" IN ("
            for row in rows:                   
                expr_filter += "'" + str(row[0]) + "', "
            expr_filter = expr_filter[:-2] + ")"
            if len(self.connec_list) == 0:
                expr_filter = "\"connec_id\" =''"
            # Check expression
            (is_valid, expr) = self.check_expression(expr_filter)
            if not is_valid:
                return     

            # Select features of the layers filtering by @expr
            self.select_features_group_layers(expr)


        #self.hydro_list = []

        # Get list of 'hydrometer_id' belonging to current result_mincut
        result_mincut_id = utils_giswater.getWidgetText(self.dlg_hydro, self.result_mincut_id)
        sql = ("SELECT hydrometer_id FROM " + self.schema_name + ".anl_mincut_result_hydrometer"
               " WHERE result_id = " + str(result_mincut_id))
        rows = self.controller.get_rows(sql)

        expr_filter = "\"hydrometer_id\" IN ("
        if rows:
            for row in rows:
                if row[0] not in self.hydro_list:
                    self.hydro_list.append(row[0])
        for hyd in self.deleted_list:
            if hyd in self.hydro_list:
                self.hydro_list.remove(hyd)
        for hyd in self.hydro_list:
            expr_filter += "'" + str(hyd) + "', "

        expr_filter = expr_filter[:-2] + ")"
        if len(self.hydro_list) == 0:
            expr_filter = "\"hydrometer_id\" =''"
        # Reload contents of table 'hydro' with expr_filter
        self.reload_table_hydro(expr_filter)


    def insert_connec(self):
        """ Select feature with entered id. Set a model with selected filter.
            Attach that model to selected table 
        """

        self.disconnect_signal_selection_changed()   
        
        # # Clear list of connec_list
        # self.connec_list = []

        # Get 'connec_id' from selected 'customer_code'
        customer_code = utils_giswater.getWidgetText(self.dlg_connec, self.dlg_connec.connec_id)
        if customer_code == 'null':
            message = "You need to enter a customer code"
            self.controller.show_info_box(message) 
            return

        connec_id = self.get_connec_id_from_customer_code(customer_code)
        if connec_id is None:
            return

        # Iterate over all layers
        for layer in self.layers_connec:
            if layer.selectedFeatureCount() > 0:
                # Get selected features of the layer
                features = layer.selectedFeatures()
                for feature in features:
                    # Append 'connec_id' into 'connec_list'
                    selected_id = feature.attribute("connec_id")
                    if selected_id not in self.connec_list:
                        self.connec_list.append(selected_id)

        # Show message if element is already in the list
        if connec_id in self.connec_list:
            message = "Selected element already in the list"
            self.controller.show_info_box(message, parameter=connec_id)
            return
        
        # If feature id doesn't exist in list -> add
        self.connec_list.append(connec_id)

        expr_filter = None
        expr = None
        if len(self.connec_list) > 0:
            
            # Set expression filter with 'connec_list'
            expr_filter = "\"connec_id\" IN ("
            for i in range(len(self.connec_list)):
                expr_filter += "'" + str(self.connec_list[i]) + "', "
            expr_filter = expr_filter[:-2] + ")"
            if len(self.connec_list) == 0:
                expr_filter = "\"connec_id\" =''"
            # Check expression
            (is_valid, expr) = self.check_expression(expr_filter)
            if not is_valid:
                return   
                
            # Select features with previous filter
            for layer in self.layers_connec:
                # Build a list of feature id's and select them
                it = layer.getFeatures(QgsFeatureRequest(expr))
                id_list = [i.id() for i in it]
                layer.selectByIds(id_list)
    
        # Reload contents of table 'connec'
        self.reload_table_connec(expr_filter)

        self.connect_signal_selection_changed("mincut_connec")   
        

    def get_connec_id_from_customer_code(self, customer_code):
        """ Get 'connec_id' from @customer_code """
                   
        sql = ("SELECT connec_id FROM " + self.schema_name + ".v_edit_connec"
               " WHERE customer_code = '" + customer_code + "'")
        row = self.controller.get_row(sql)
        if not row:
            message = "Any 'connec_id' found with this 'customer_code'"
            self.controller.show_info_box(message, parameter=customer_code)
            return None
        else:
            return str(row[0])
        
                
    def check_expression(self, expr_filter, log_info=False):
        """ Check if expression filter @expr is valid """
        
        if log_info:
            self.controller.log_info(expr_filter)
        expr = QgsExpression(expr_filter)
        if expr.hasParserError():
            message = "Expression Error"
            self.controller.log_warning(message, parameter=expr_filter)
            return (False, expr)
        return (True, expr)
                
                
    def select_features_by_expr(self, layer, expr):
        """ Select features of @layer applying @expr """

        if expr is None:
            layer.removeSelection()  
        else:                
            it = layer.getFeatures(QgsFeatureRequest(expr))
            # Build a list of feature id's from the previous result and select them            
            id_list = [i.id() for i in it]
            if len(id_list) > 0:
                layer.selectByIds(id_list)   
            else:
                layer.removeSelection()  
                                
                
    def set_table_model(self, widget, table_name, expr_filter):
        """ Sets a TableModel to @widget attached to @table_name and filter @expr_filter """
        
        expr = None
        if expr_filter:
            # Check expression          
            (is_valid, expr) = self.check_expression(expr_filter)    #@UnusedVariable
            if not is_valid:
                return expr

        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set a model with selected filter expression
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.select()
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())
            return expr
        # Attach model to selected table 
        if expr_filter:
            widget.setModel(model)
            widget.model().setFilter(expr_filter)
            widget.model().select() 
        else:
            widget.setModel(None)
        
        return expr      
        

    def reload_table_connec(self, expr_filter=None):
        """ Reload contents of table 'connec' with selected @expr_filter """
                         
        table_name = self.schema_name + ".v_edit_connec"
        widget = self.dlg_connec.tbl_mincut_connec     
        expr = self.set_table_model(widget, table_name, expr_filter)
        self.set_table_columns(self.dlg_connec, widget, 'v_edit_connec')
        return expr


    def reload_table_hydro(self, expr_filter=None):
        """ Reload contents of table 'hydro' """
        table_name = self.schema_name + ".v_rtc_hydrometer"
        widget = self.dlg_hydro.tbl_hydro  
        expr = self.set_table_model(widget, table_name, expr_filter)
        self.set_table_columns(self.dlg_hydro, widget, 'v_rtc_hydrometer')
        return expr        


    def delete_records_connec(self):  
        """ Delete selected rows of the table """
                
        self.disconnect_signal_selection_changed()   
                        
        # Get selected rows
        widget = self.dlg_connec.tbl_mincut_connec
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        
        del_id = []
        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            # id to delete
            id_feature = widget.model().record(row).value("connec_id")
            list_id = list_id + "'" + str(id_feature) + "', "
            del_id.append(id_feature)
            # id to ask
            customer_code = widget.model().record(row).value("customer_code")
            inf_text += str(customer_code) + ", "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        message = "Are you sure you want to delete these records?"
        title = "Delete records"
        answer = self.controller.ask_question(message, title, inf_text)

        if not answer:
            return
        else:
            for el in del_id:
                self.connec_list.remove(el)
                
        # Select features which are in the list
        expr_filter = "\"connec_id\" IN ("
        for i in range(len(self.connec_list)):
            expr_filter += "'" + str(self.connec_list[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"

        if len(self.connec_list) == 0:
            expr_filter = "connec_id=''"

        # Update model of the widget with selected expr_filter     
        expr = self.reload_table_connec(expr_filter)               

        # Reload selection
        for layer in self.layers_connec:
            # Build a list of feature id's and select them
            it = layer.getFeatures(QgsFeatureRequest(expr))
            id_list = [i.id() for i in it]
            layer.selectByIds(id_list)
            
        self.connect_signal_selection_changed("mincut_connec")               


    def delete_records_hydro(self):  
        """ Delete selected rows of the table """
        
        # Get selected rows
        widget = self.dlg_hydro.tbl_hydro    
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        del_id = []
        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_feature = widget.model().record(row).value("hydrometer_customer_code")
            hydro_id = widget.model().record(row).value("hydrometer_id")
            inf_text += str(id_feature) + ", "
            list_id = list_id + "'" + str(id_feature) + "', "
            del_id.append(hydro_id)
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        message = "Are you sure you want to delete these records?"
        title = "Delete records"
        answer = self.controller.ask_question(message, title, inf_text)

        if not answer:
            return
        else:
            for el in del_id:
                self.hydro_list.remove(el)
                if el not in self.deleted_list:
                    self.deleted_list.append(el)
        # Select features that are in the list
        expr_filter = "\"hydrometer_id\" IN ("
        for i in range(len(self.hydro_list)):
            expr_filter += "'" + str(self.hydro_list[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"

        if len(self.hydro_list) == 0:
            expr_filter = "hydrometer_id=''"

        # Update model of the widget with selected expr_filter
        self.reload_table_hydro(expr_filter)
        
        self.connect_signal_selection_changed("mincut_hydro")
        

    def accept_connec(self, dlg, element):
        """ Slot function widget 'btn_accept' of 'connec' dialog 
            Insert into table 'anl_mincut_result_connec' values of current mincut 
        """
        
        result_mincut_id = utils_giswater.getWidgetText(dlg, self.dlg_mincut.result_mincut_id)
        if result_mincut_id == 'null':
            return

        sql = ("DELETE FROM " + self.schema_name + ".anl_mincut_result_" + str(element) + ""
               " WHERE result_id = " + str(result_mincut_id) + ";\n")
        for element_id in self.connec_list:
            sql += ("INSERT INTO " + self.schema_name + ".anl_mincut_result_" + str(element) + ""
                    " (result_id, " + str(element) + "_id) "
                    " VALUES ('" + str(result_mincut_id) + "', '" + str(element_id) + "');\n")
            # Get hydrometer_id of selected connec
            sql2 = ("SELECT hydrometer_id FROM " + self.schema_name + ".v_rtc_hydrometer"
                    " WHERE connec_id = '" + str(element_id) + "'")
            rows = self.controller.get_rows(sql2)
            if rows:
                for row in rows:
                    # Hydrometers associated to selected connec inserted to the table anl_mincut_result_hydrometer
                    sql += ("INSERT INTO " + self.schema_name + ".anl_mincut_result_hydrometer"
                            " (result_id, hydrometer_id) "
                            " VALUES ('" + str(result_mincut_id) + "', '" + str(row[0]) + "');\n")

        self.sql_connec = sql
        self.dlg_mincut.btn_start.setDisabled(False)
        self.close_dialog(self.dlg_connec)
        

    def accept_hydro(self, dlg, element):
        """ Slot function widget 'btn_accept' of 'hydrometer' dialog 
            Insert into table 'anl_mincut_result_hydrometer' values of current mincut 
        """
        result_mincut_id = utils_giswater.getWidgetText(dlg, self.dlg_mincut.result_mincut_id)
        if result_mincut_id == 'null':
            return

        sql = ("DELETE FROM " + self.schema_name + ".anl_mincut_result_" + str(element) + ""
               " WHERE result_id = " + str(result_mincut_id) + ";\n")
        for element_id in self.hydro_list:
            sql += ("INSERT INTO " + self.schema_name + ".anl_mincut_result_" + str(element) + ""
                    " (result_id, " + str(element) + "_id) "
                    " VALUES ('" + str(result_mincut_id) + "', '" + str(element_id) + "');\n")
        
        self.sql_hydro = sql
        self.dlg_mincut.btn_start.setDisabled(False)
        self.close_dialog(self.dlg_hydro)


    def auto_mincut(self):
        """ B1-126: Automatic mincut analysis """

        self.dlg_mincut.closeMainWin = True
        self.dlg_mincut.canceled = False
        # Vertex marker
        self.vertex_marker = QgsVertexMarker(self.canvas)
        self.vertex_marker.setColor(QColor(255, 100, 255))
        self.vertex_marker.setIconSize(15)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)
        self.vertex_marker.setPenWidth(3)
        
        # On inserting work order
        self.action_add_connec.setDisabled(True)
        self.action_add_hydrometer.setDisabled(True)
            
        # Set signals
        self.canvas.xyCoordinates.connect(self.mouse_move_node_arc)        
        self.emit_point.canvasClicked.connect(self.auto_mincut_snapping)


    def auto_mincut_snapping(self, point, btn):  #@UnusedVariable
        """ Automatic mincut: Snapping to 'node' and 'arc' layers """

        # Get coordinates
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_background_layers(event_point)
        if not self.snapper_manager.result_is_valid():
            return

        # Check feature
        elem_type = None
        layer = self.snapper_manager.get_snapped_layer(result)
        if layer == self.layer_node:
            elem_type = 'node'
        elif layer == self.layer_arc:
            elem_type = 'arc'

        if elem_type:
            # Get the point. Leave selection
            snapped_feat = self.snapper_manager.get_snapped_feature(result)
            feature_id = self.snapper_manager.get_snapped_feature_id(result)
            element_id = snapped_feat.attribute(elem_type + '_id')
            layer.select([feature_id])
            self.auto_mincut_execute(element_id, elem_type, point.x(), point.y())
            self.set_visible_mincut_layers()


    def set_visible_mincut_layers(self, zoom=False):
        """ Set visible mincut result layers """
        
        layer = self.controller.get_layer_by_tablename("v_anl_mincut_result_valve") 
        if layer:
            self.controller.set_layer_visible(layer)
                    
        layer = self.controller.get_layer_by_tablename("v_anl_mincut_result_arc") 
        if layer:
            self.controller.set_layer_visible(layer)
            
        layer = self.controller.get_layer_by_tablename("v_anl_mincut_result_connec") 
        if layer:            
            self.controller.set_layer_visible(layer)

        # Refresh extension of layer
        layer = self.controller.get_layer_by_tablename("v_anl_mincut_result_node")
        if layer:
            self.controller.set_layer_visible(layer)
            if zoom:
                # Refresh extension of layer
                layer.updateExtents()
                # Zoom to executed mincut
                self.iface.setActiveLayer(layer)
                self.iface.zoomToActiveLayer()


    def snapping_node_arc_real_location(self, point, btn):  #@UnusedVariable

        # Get coordinates
        event_point = self.snapper_manager.get_event_point(point=point)

        result_mincut_id_text = self.dlg_mincut.result_mincut_id.text()
        srid = self.controller.plugin_settings_value('srid')

        sql = ("UPDATE " + self.schema_name + ".anl_mincut_result_cat"
               " SET exec_the_geom = ST_SetSRID(ST_Point(" + str(point.x()) + ", "
               + str(point.y()) + ")," + str(srid) + ")"
               " WHERE id = '" + result_mincut_id_text + "'")
        status = self.controller.execute_sql(sql)
        if status:
            message = "Real location has been updated"
            self.controller.show_info(message)

        # Snapping
        result = self.snapper_manager.snap_to_background_layers(event_point)
        if not self.snapper_manager.result_is_valid():
            return

        node_exist = False
        layer = self.snapper_manager.get_snapped_layer(result)
        # Check feature
        if layer == self.layer_node:
            node_exist = True
            self.snapper_manager.get_snapped_feature(result, True)

        if not node_exist:
            layers_arc = self.controller.get_group_layers('arc')
            self.layernames_arc = []
            for layer in layers_arc:
                self.layernames_arc.append(layer.name())

            element_type = layer.name()
            if element_type in self.layernames_arc:
                self.snapper_manager.get_snapped_feature(result, True)


    def auto_mincut_execute(self, elem_id, elem_type, snapping_x, snapping_y):
        """ Automatic mincut: Execute function 'gw_fct_mincut' """

        srid = self.controller.plugin_settings_value('srid')

        if self.is_new:
            self.set_id_val()
            self.is_new = False

        sql = ("INSERT INTO " + self.schema_name + ".anl_mincut_result_cat (mincut_state)"
               " VALUES (0) RETURNING id;")
        new_mincut_id = self.controller.execute_returning(sql, log_sql=True)
        real_mincut_id = new_mincut_id[0]
        utils_giswater.setWidgetText(self.dlg_mincut, self.dlg_mincut.result_mincut_id, real_mincut_id)

        # Execute gw_fct_mincut ('feature_id', 'feature_type', 'result_id')
        # feature_id: id of snapped arc/node
        # feature_type: type of snapped element (arc/node)
        # result_mincut_id: result_mincut_id from form
        sql = ("SELECT " + self.schema_name + ".gw_fct_mincut('" + str(elem_id) + "',"
               " '" + str(elem_type) + "', '" + str(real_mincut_id) + "');")
        row = self.controller.get_row(sql, log_sql=True, commit=True)

        if not row:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return False

        complet_result = row[0]

        if 'mincutOverlap' in complet_result:
            if complet_result['mincutOverlap'] != "":
                message = "Mincut done, but has conflict and overlaps with"
                self.controller.show_info_box(message, parameter=complet_result['mincutOverlap'])
            else:
                message = "Mincut done successfully"
                self.controller.show_info(message)

            # Zoom to rectangle (zoom to mincut)
            polygon = complet_result['geometry']
            polygon = polygon[9:len(polygon)-2]
            polygon = polygon.split(',')
            x1, y1 = polygon[0].split(' ')
            x2, y2 = polygon[2].split(' ')
            self.zoom_to_rectangle(x1, y1, x2, y2, margin=0)
            
            sql = ("UPDATE " + self.schema_name + ".anl_mincut_result_cat"
                   " SET mincut_class = 1, "
                   " anl_the_geom = ST_SetSRID(ST_Point(" + str(snapping_x) + ", "
                   + str(snapping_y) + "), " + str(srid) + "),"
                   " anl_user = current_user, anl_feature_type = '" + str(elem_type.upper()) + "',"
                   " anl_feature_id = '" + str(elem_id) + "'"
                   " WHERE id = '" + str(real_mincut_id) + "'")
            status = self.controller.execute_sql(sql, log_sql=True)

            if not status:
                message = "Error updating element in table, you need to review data"
                self.controller.show_warning(message)
                self.set_cursor_restore()
                return

            # Enable button CustomMincut and button Start
            self.dlg_mincut.btn_start.setDisabled(False)
            self.action_custom_mincut.setDisabled(False)
            self.action_mincut.setDisabled(True)
            self.action_add_connec.setDisabled(True)
            self.action_add_hydrometer.setDisabled(True)
            self.action_mincut_composer.setDisabled(False)

            # Update table 'anl_mincut_result_selector'
            sql = ("DELETE FROM " + self.schema_name + ".anl_mincut_result_selector WHERE cur_user = current_user;\n"
                   "INSERT INTO " + self.schema_name + ".anl_mincut_result_selector (cur_user, result_id) VALUES"
                   " (current_user, " + str(real_mincut_id) + ");")
            self.controller.execute_sql(sql, log_error=True, log_sql=True)

            # Refresh map canvas
            self.refresh_map_canvas()

        # Disconnect snapping and related signals
        self.disconnect_snapping(False)
                    

    def custom_mincut(self):
        """ B2-123: Custom mincut analysis. Working just with layer Valve analytics """
        # Need this 3 lines here becouse if between one action and another we activate Pan, we cant open another valve
        # This is a safety measure

        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)

        # Disconnect previous connections
        self.disconnect_snapping(False)
        
        # Vertex marker
        self.vertex_marker = QgsVertexMarker(self.canvas)
        self.vertex_marker.setColor(QColor(255, 100, 255))
        self.vertex_marker.setIconSize(15)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)
        self.vertex_marker.setPenWidth(3)        
        
        # Set snapping icon to circle
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CIRCLE)

        # Set active layer
        viewname = 'v_anl_mincut_result_valve'
        layer = self.controller.get_layer_by_tablename(viewname, log_info=True)       
        if layer:
            self.iface.setActiveLayer(layer)
            self.controller.set_layer_visible(layer)
            self.canvas.xyCoordinates.connect(self.mouse_move_valve)
            self.emit_point.canvasClicked.connect(self.custom_mincut_snapping)


    def mouse_move_valve(self, point):

        # Get clicked point
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if self.snapper_manager.result_is_valid():
            layer = self.snapper_manager.get_snapped_layer(result)
            # Check feature
            viewname = self.controller.get_layer_source_table_name(layer)
            if viewname == 'v_anl_mincut_result_valve':
                self.snapper_manager.add_marker(result, self.vertex_marker)


    def mouse_move_node_arc(self, point):

        if not self.layer_arc:
            return
        
        # Set active layer
        self.iface.setActiveLayer(self.layer_arc)

        # Get clicked point
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if self.snapper_manager.result_is_valid():
            layer = self.snapper_manager.get_snapped_layer(result)
            # Check feature
            viewname = self.controller.get_layer_source_table_name(layer)
            if viewname == 'v_edit_arc':
                self.snapper_manager.add_marker(result, self.vertex_marker)


    def custom_mincut_snapping(self, point, btn): # @UnusedVariable
        """ Custom mincut snapping function """

        # Get clicked point
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if self.snapper_manager.result_is_valid():
            # Check feature
            layer = self.snapper_manager.get_snapped_layer(result)
            viewname = self.controller.get_layer_source_table_name(layer)
            if viewname == 'v_anl_mincut_result_valve':
                # Get the point. Leave selection
                snapped_feat = self.snapper_manager.get_snapped_feature(result, True)
                element_id = snapped_feat.attribute('node_id')
                self.custom_mincut_execute(element_id)
                self.set_visible_mincut_layers()


    def custom_mincut_execute(self, elem_id):
        """ Custom mincut. Execute function 'gw_fct_mincut_valve_unaccess' """ 
        
        # Change cursor to 'WaitCursor'     
        self.set_cursor_wait()                
        
        cur_user = self.controller.get_project_user()               
        result_mincut_id = utils_giswater.getWidgetText(self.dlg_mincut, "result_mincut_id")
        if result_mincut_id != 'null':
            sql = ("SELECT " + self.schema_name + ".gw_fct_mincut_valve_unaccess"
                   "('" + str(elem_id) + "', '" + str(result_mincut_id) + "', '" + str(cur_user) + "');")
            status = self.controller.execute_sql(sql, log_sql=False)
            if status:
                message = "Custom mincut executed successfully"
                self.controller.show_info(message)

        # Refresh map canvas
        self.refresh_map_canvas(True)
                
        # Disconnect snapping and related signals
        self.disconnect_snapping(False)        


    def remove_selection(self):
        """ Remove selected features of all layers """

        for layer in self.canvas.layers():
            if type(layer) is QgsVectorLayer:
                layer.removeSelection()
        self.canvas.refresh()
        

    def mg_mincut_management(self):
        """ Button 27: Mincut management """

        self.action = "mg_mincut_management"
        self.mincut_config.mg_mincut_management()


    def load_mincut(self, result_mincut_id):
        """ Load selected mincut """

        self.is_new = False
        # Force fill form mincut
        self.result_mincut_id.setText(str(result_mincut_id))

        sql = ("SELECT anl_mincut_result_cat.*, anl_mincut_cat_state.name AS state_name, cat_users.name AS assigned_to_name"
               " FROM " + self.schema_name + ".anl_mincut_result_cat"
               " INNER JOIN " + self.schema_name + ".anl_mincut_cat_state"
               " ON anl_mincut_result_cat.mincut_state = anl_mincut_cat_state.id"
               " INNER JOIN" + self.schema_name + ".cat_users" 
               " ON cat_users.id = anl_mincut_result_cat.assigned_to"
               " WHERE anl_mincut_result_cat.id = '" + str(result_mincut_id) + "'")

        row = self.controller.get_row(sql, log_sql=False)
        if not row:
            return
              
        utils_giswater.setWidgetText(self.dlg_mincut, self.dlg_mincut.work_order, row['work_order'])
        utils_giswater.set_combo_itemData(self.dlg_mincut.type, row['mincut_type'], 0)
        utils_giswater.set_combo_itemData(self.dlg_mincut.cause, row['anl_cause'], 0)
        utils_giswater.setWidgetText(self.dlg_mincut, self.dlg_mincut.state, row['state_name'])
        
        # Manage location
        self.open_mincut_manage_location(row)

        # Manage dates
        self.open_mincut_manage_dates(row)

        utils_giswater.setWidgetText(self.dlg_mincut, "pred_description", row['anl_descript'])
        utils_giswater.setWidgetText(self.dlg_mincut, "real_description", row['exec_descript'])
        utils_giswater.setWidgetText(self.dlg_mincut, "distance", row['exec_from_plot'])
        utils_giswater.setWidgetText(self.dlg_mincut, "depth", row['exec_depth'])
        utils_giswater.setWidgetText(self.dlg_mincut, "assigned_to", row['assigned_to_name'])

        # Update table 'anl_mincut_result_selector'
        self.update_result_selector(result_mincut_id)
        self.refresh_map_canvas()
        self.current_state = str(row['mincut_state'])
        sql = ("SELECT mincut_class FROM " + self.schema_name + ".anl_mincut_result_cat"
               " WHERE id = '" + str(result_mincut_id) + "'")
        row = self.controller.get_row(sql)
        mincut_class_status = None
        if row[0]:
            mincut_class_status = str(row[0])

        self.set_visible_mincut_layers(True)

        # Depend of mincut_state and mincut_clase desable/enable widgets
        # Current_state == '0': Planified
        if self.current_state == '0':
            self.dlg_mincut.work_order.setDisabled(False)
            # Group Location
            self.dlg_mincut.address_exploitation.setDisabled(False)
            self.dlg_mincut.address_postal_code.setDisabled(False)
            self.dlg_mincut.address_street.setDisabled(False)
            self.dlg_mincut.address_number.setDisabled(False)
            # Group Details
            self.dlg_mincut.type.setDisabled(False)
            self.dlg_mincut.cause.setDisabled(False)
            self.dlg_mincut.cbx_recieved_day.setDisabled(False)
            self.dlg_mincut.cbx_recieved_time.setDisabled(False)
            # Group Prediction
            self.dlg_mincut.cbx_date_start_predict.setDisabled(False)
            self.dlg_mincut.cbx_hours_start_predict.setDisabled(False)
            self.dlg_mincut.cbx_date_end_predict.setDisabled(False)
            self.dlg_mincut.cbx_hours_end_predict.setDisabled(False)
            self.dlg_mincut.assigned_to.setDisabled(False)
            self.dlg_mincut.pred_description.setDisabled(False)
            # Group Real Details
            self.dlg_mincut.cbx_date_start.setDisabled(True)
            self.dlg_mincut.cbx_hours_start.setDisabled(True)
            self.dlg_mincut.cbx_date_end.setDisabled(True)
            self.dlg_mincut.cbx_hours_end.setDisabled(True)
            self.dlg_mincut.distance.setDisabled(True)
            self.dlg_mincut.depth.setDisabled(True)
            self.dlg_mincut.appropiate.setDisabled(True)
            self.dlg_mincut.real_description.setDisabled(True)
            self.dlg_mincut.btn_start.setDisabled(False)
            self.dlg_mincut.btn_end.setDisabled(True)
            # Actions
            if mincut_class_status == '1':
                self.action_mincut.setDisabled(True)
                self.action_custom_mincut.setDisabled(False)
                self.action_add_connec.setDisabled(True)
                self.action_add_hydrometer.setDisabled(True)
            if mincut_class_status == '2':
                self.action_mincut.setDisabled(True)
                self.action_custom_mincut.setDisabled(True)
                self.action_add_connec.setDisabled(False)
                self.action_add_hydrometer.setDisabled(True)
            if mincut_class_status == '3':
                self.action_mincut.setDisabled(True)
                self.action_custom_mincut.setDisabled(True)
                self.action_add_connec.setDisabled(True)
                self.action_add_hydrometer.setDisabled(False)
            if mincut_class_status is None:
                self.action_mincut.setDisabled(False)
                self.action_custom_mincut.setDisabled(True)
                self.action_add_connec.setDisabled(False)
                self.action_add_hydrometer.setDisabled(False)
        # Current_state == '1': In progress
        elif self.current_state == '1':

            self.dlg_mincut.work_order.setDisabled(True)
            # Group Location
            self.dlg_mincut.address_exploitation.setDisabled(True)
            self.dlg_mincut.address_postal_code.setDisabled(True)
            self.dlg_mincut.address_street.setDisabled(True)
            self.dlg_mincut.address_number.setDisabled(True)
            # Group Details
            self.dlg_mincut.type.setDisabled(True)
            self.dlg_mincut.cause.setDisabled(True)
            self.dlg_mincut.cbx_recieved_day.setDisabled(True)
            self.dlg_mincut.cbx_recieved_time.setDisabled(True)
            # Group Prediction dates
            self.dlg_mincut.cbx_date_start_predict.setDisabled(True)
            self.dlg_mincut.cbx_hours_start_predict.setDisabled(True)
            self.dlg_mincut.cbx_date_end_predict.setDisabled(True)
            self.dlg_mincut.cbx_hours_end_predict.setDisabled(True)
            self.dlg_mincut.assigned_to.setDisabled(True)
            self.dlg_mincut.pred_description.setDisabled(True)
            # Group Real dates
            self.dlg_mincut.cbx_date_start.setDisabled(False)
            self.dlg_mincut.cbx_hours_start.setDisabled(False)
            self.dlg_mincut.cbx_date_end.setDisabled(True)
            self.dlg_mincut.cbx_hours_end.setDisabled(True)
            self.dlg_mincut.distance.setDisabled(False)
            self.dlg_mincut.depth.setDisabled(False)
            self.dlg_mincut.appropiate.setDisabled(False)
            self.dlg_mincut.real_description.setDisabled(False)
            self.dlg_mincut.btn_start.setDisabled(True)
            self.dlg_mincut.btn_end.setDisabled(False)
            # Actions
            self.action_mincut.setDisabled(True)
            self.action_custom_mincut.setDisabled(True)
            self.action_add_connec.setDisabled(True)
            self.action_add_hydrometer.setDisabled(True)

        # Current_state == '2': Finished, '3':Canceled
        elif self.current_state in ('2', '3'):
            self.dlg_mincut.work_order.setDisabled(True)
            # Group Location
            self.dlg_mincut.address_exploitation.setDisabled(True)
            self.dlg_mincut.address_postal_code.setDisabled(True)
            self.dlg_mincut.address_street.setDisabled(True)
            self.dlg_mincut.address_number.setDisabled(True)
            # Group Details
            self.dlg_mincut.type.setDisabled(True)
            self.dlg_mincut.cause.setDisabled(True)
            self.dlg_mincut.cbx_recieved_day.setDisabled(True)
            self.dlg_mincut.cbx_recieved_time.setDisabled(True)
            # Group Prediction dates
            self.dlg_mincut.cbx_date_start_predict.setDisabled(True)
            self.dlg_mincut.cbx_hours_start_predict.setDisabled(True)
            self.dlg_mincut.cbx_date_end_predict.setDisabled(True)
            self.dlg_mincut.cbx_hours_end_predict.setDisabled(True)
            self.dlg_mincut.assigned_to.setDisabled(True)
            self.dlg_mincut.pred_description.setDisabled(True)
            # Group Real dates
            self.dlg_mincut.cbx_date_start.setDisabled(True)
            self.dlg_mincut.cbx_hours_start.setDisabled(True)
            self.dlg_mincut.cbx_date_end.setDisabled(True)
            self.dlg_mincut.cbx_hours_end.setDisabled(True)
            self.dlg_mincut.distance.setDisabled(True)
            self.dlg_mincut.depth.setDisabled(True)
            self.dlg_mincut.appropiate.setDisabled(True)
            self.dlg_mincut.real_description.setDisabled(True)
            self.dlg_mincut.btn_start.setDisabled(True)
            self.dlg_mincut.btn_end.setDisabled(True)
            # Actions
            self.action_mincut.setDisabled(True)
            self.action_custom_mincut.setDisabled(True)
            self.action_add_connec.setDisabled(True)
            self.action_add_hydrometer.setDisabled(True)

        # Common Actions
        self.action_mincut_composer.setDisabled(False)


    def open_mincut_manage_location(self, row):
        """ Management of location parameters: muni, postcode, street, postnumber """
        
        # Get 'muni_name' from 'muni_id'  
        if row['muni_id'] and row['muni_id'] != -1:
            sql = ("SELECT name FROM " + self.schema_name + ".ext_municipality"
                   " WHERE muni_id = '" + str(row['muni_id']) + "'")
            row_aux = self.controller.get_row(sql)
            if row_aux:                
                utils_giswater.setWidgetText(self.dlg_mincut, self.dlg_mincut.address_exploitation, row_aux['name'])
                    
        utils_giswater.setWidgetText(self.dlg_mincut, self.dlg_mincut.address_postal_code, str(row['postcode']))
        
        # Get 'street_name' from 'streetaxis_id'  
        if row['streetaxis_id'] and row['streetaxis_id'] != -1:
            sql = ("SELECT name FROM " + self.schema_name + ".ext_streetaxis"
                   " WHERE id = '" + str(row['streetaxis_id']) + "'")
            row_aux = self.controller.get_row(sql)
            if row_aux:
                utils_giswater.setWidgetText(self.dlg_mincut, self.dlg_mincut.address_street, row_aux['name'])
                         
        utils_giswater.setWidgetText(self.dlg_mincut, self.dlg_mincut.address_number, str(row['postnumber']))
        
        
    def open_mincut_manage_dates(self, row):
        """ Management of null values in fields of type date """
        
        self.manage_date(row['anl_tstamp'], "cbx_recieved_day", "cbx_recieved_time") 
        self.manage_date(row['forecast_start'], "cbx_date_start_predict", "cbx_hours_start_predict") 
        self.manage_date(row['forecast_end'], "cbx_date_end_predict", "cbx_hours_end_predict") 
        self.manage_date(row['exec_start'], "cbx_date_start", "cbx_hours_start")                                         
        self.manage_date(row['exec_end'], "cbx_date_end", "cbx_hours_end")        
          
          
    def manage_date(self, date_value, widget_date, widget_time):   
        """ Manage date of current field """
        
        if date_value:
            datetime = (str(date_value))            
            date = str(datetime.split()[0])
            time = str(datetime.split()[1])
            qt_date = QDate.fromString(date, 'yyyy-MM-dd')
            qt_time = QTime.fromString(time, 'h:mm:ss')
            utils_giswater.setCalendarDate(self.dlg_mincut, widget_date, qt_date)
            utils_giswater.setTimeEdit(self.dlg_mincut, widget_time, qt_time)


    def searchplus_get_parameters(self):
        """ Get parameters of 'searchplus' from table 'config_param_system' """

        self.params = {}
        sql = ("SELECT parameter, value FROM " + self.controller.schema_name + ".config_param_system"
               " WHERE context = 'searchplus' ORDER BY parameter")
        rows = self.controller.get_rows(sql)
        if rows:
            for row in rows:
                self.params[row['parameter']] = str(row['value'])
        else:
            message = "Parameters related with 'searchplus' not set in table 'config_param_system'"
            self.controller.log_warning(message)
            return False

        # Get scale zoom
        self.scale_zoom = 2500
        sql = ("SELECT value FROM " + self.schema_name + ".config_param_system"
               " WHERE parameter = 'scale_zoom'")
        row = self.controller.get_row(sql)
        if row:
            self.scale_zoom = row['value']
            
        return True            


    def address_fill_postal_code(self, dialog, combo):
        """ Fill @combo """

        # Get exploitation code: 'expl_id'
        expl_id = utils_giswater.get_item_data(dialog, dialog.address_exploitation)

        # Get postcodes related with selected 'expl_id'
        sql = "SELECT DISTINCT(postcode) FROM " + self.controller.schema_name + ".ext_address"
        if expl_id != -1:
            sql += " WHERE " + self.street_field_expl[0] + " = '" + str(expl_id) + "'"
        sql += " ORDER BY postcode"
        rows = self.controller.get_rows(sql)
        if not rows:
            return False

        records = [(-1, '', '')]
        for row in rows:
            field_code = row[0]
            elem = [field_code, field_code, None]
            records.append(elem)

        # Fill combo
        combo.blockSignals(True)
        combo.clear()
        records_sorted = sorted(records, key=operator.itemgetter(1))
        for i in range(len(records_sorted)):
            record = records_sorted[i]
            combo.addItem(record[1], record)
            combo.blockSignals(False)

        return True


    def address_populate(self, dialog, combo, layername, field_code, field_name):
        """ Populate @combo """

        # Check if we have this search option available
        if layername not in self.layers:
            return False

        # Get features
        layer = self.layers[layername]
        records = [(-1, '', '')]
        if Qgis.QGIS_VERSION_INT < 29900:
            idx_field_code = layer.fieldNameIndex(self.params[field_code])
            idx_field_name = layer.fieldNameIndex(self.params[field_name])
        else:
            idx_field_code = layer.fields().indexFromName(self.params[field_code])
            idx_field_name = layer.fields().indexFromName(self.params[field_name])

        if idx_field_code < 0:
            message = "Adress configuration. Field not found"
            self.controller.show_warning(message, parameter=self.params[field_code])
            return
        if idx_field_name < 0:
            message = "Adress configuration. Field not found"
            self.controller.show_warning(message, parameter=self.params[field_name])
            return    
            
        it = layer.getFeatures()

        if layername == 'street_layer':

            # Get 'expl_id'
            elem = dialog.address_exploitation.itemData(dialog.address_exploitation.currentIndex())
            expl_id = elem[0]
            records = [[-1, '']]

            # Set filter expression
            expr_filter = self.street_field_expl[0] + " = '" + str(expl_id) + "'"

            # Check filter and existence of fields
            expr = QgsExpression(expr_filter)
            if expr.hasParserError():
                message = expr.parserErrorString() + ": " + expr_filter
                self.controller.show_warning(message)
                return

            it = layer.getFeatures(QgsFeatureRequest(expr))

        # Iterate over features
        for feature in it:
            geom = feature.geometry()
            attrs = feature.attributes()
            value_code = attrs[idx_field_code]
            value_name = attrs[idx_field_name]
            if value_code is not None and geom is not None:
                if Qgis.QGIS_VERSION_INT < 29900:
                    elem = [value_code, value_name, geom.exportToWkt()]
                else:
                    elem = [value_code, value_name, geom.asWkt()]
            else:
                elem = [value_code, value_name, None]
            records.append(elem)

        # Fill combo
        combo.blockSignals(True)
        combo.clear()
        records_sorted = sorted(records, key=operator.itemgetter(1))
        for record in records_sorted:
            combo.addItem(record[1], record)
        combo.blockSignals(False)

        return True


    def address_get_numbers(self, dialog, combo, field_code, fill_combo=False, zoom=True):
        """ Populate civic numbers depending on value of selected @combo. 
            Build an expression with @field_code
        """      

        # Get selected street
        selected = utils_giswater.getWidgetText(dialog, combo)
        if selected == 'null':
            return

        # Get street code
        elem = combo.itemData(combo.currentIndex())
        code = elem[0]
        records = [[-1, '']]  
        
        # Get 'portal' layer
        if 'portal_layer' not in list(self.layers.keys()):
            message = "Layer not found"
            self.controller.show_warning(message, parameter='portal_layer')
            return
        
        # Set filter expression
        layer = self.layers['portal_layer']
        if Qgis.QGIS_VERSION_INT < 29900:
            idx_field_code = layer.fieldNameIndex(field_code)
            idx_field_number = layer.fieldNameIndex(self.params['portal_field_number'])
        else:
            idx_field_code = layer.fields().indexFromName(field_code)
            idx_field_number = layer.fields().indexFromName(self.params['portal_field_number'])
        expr_filter = field_code + " = '" + str(code) + "'"
        (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
        if not is_valid:
            return     
              
        if idx_field_code == -1:
            message = "Field not found"
            self.controller.show_warning(message, parameter=field_code)
            return            
        if idx_field_number == -1:
            message = "Field not found"
            self.controller.show_warning(message, parameter=self.params['portal_field_number'])
            return
        
        dialog.address_number.blockSignals(True)
        dialog.address_number.clear()
        if fill_combo:
            it = layer.getFeatures(QgsFeatureRequest(expr))
            for feature in it:
                attrs = feature.attributes()
                field_number = attrs[idx_field_number]
                if field_number is not None:
                    elem = [code, field_number]
                    records.append(elem)
        
            # Fill numbers combo
            records_sorted = sorted(records, key=operator.itemgetter(1))
            for record in records_sorted:
                dialog.address_number.addItem(record[1], record)
            dialog.address_number.blockSignals(False)

        if zoom:
            # Select features of @layer applying @expr
            self.select_features_by_expr(layer, expr)
    
            # Zoom to selected feature of the layer
            self.zoom_to_selected_features(layer, 'arc')


    def zoom_to_selected_features(self, layer, geom_type=None, zoom=None):
        """ Zoom to selected features of the @layer with @geom_type """
        
        if not layer:
            return
        
        self.iface.setActiveLayer(layer)
        self.iface.actionZoomToSelected().trigger()
        
        if geom_type:
            
            # Set scale = scale_zoom
            if geom_type in ('node', 'connec', 'gully'):
                scale = self.scale_zoom
            
            # Set scale = max(current_scale, scale_zoom)
            elif geom_type == 'arc':
                scale = self.iface.mapCanvas().scale()
                if int(scale) < int(self.scale_zoom):
                    scale = self.scale_zoom
            else:
                scale = 5000

            if zoom is not None:
                scale = zoom
            
            self.iface.mapCanvas().zoomScale(float(scale))


    def adress_get_layers(self):
        """ Iterate over all layers to get the ones set in table 'config_param_system' """

        # Check if we have any layer loaded
        layers = self.controller.get_layers()
        if len(layers) == 0:
            return

        # Iterate over all layers to get the ones specified parameters '*_layer'
        self.layers = {}

        for cur_layer in layers:
            layer_source = self.controller.get_layer_source(cur_layer)
            uri_table = layer_source['table']
            if uri_table is not None:
                if self.params['expl_layer'] == uri_table:
                    self.layers['expl_layer'] = cur_layer
                elif self.params['street_layer'] == uri_table:
                    self.layers['street_layer'] = cur_layer
                elif self.params['portal_layer'] == uri_table:
                    self.layers['portal_layer'] = cur_layer


    def adress_init_config(self, dialog):
        """ Populate the interface with values get from layers """

        # Get parameters of 'searchplus' from table 'config_param_system' 
        if not self.searchplus_get_parameters():
            return 
            
        # Get layers and full extent
        self.adress_get_layers()

        # Tab 'Address'
        status = self.address_populate(dialog, dialog.address_exploitation, 'expl_layer', 'expl_field_code', 'expl_field_name')
        if not status:
            return
        sql = ("SELECT value FROM " + self.controller.schema_name + ".config_param_system"
               " WHERE parameter = 'street_field_expl'")
        self.street_field_expl = self.controller.get_row(sql)
        if not self.street_field_expl:
            message = "Param street_field_expl not found"
            self.controller.show_warning(message)
            return

        sql = ("SELECT value FROM " + self.controller.schema_name + ".config_param_system"
               " WHERE parameter = 'portal_field_postal'")
        portal_field_postal = self.controller.get_row(sql)
        if not portal_field_postal:
            message = "Param portal_field_postal not found"
            self.controller.show_warning(message)
            return

        # Get project variable 'expl_id'
        if Qgis.QGIS_VERSION_INT < 29900:
            expl_id = QgsExpressionContextUtils.projectScope().variable(str(self.street_field_expl[0]))
        else:
            expl_id = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable(str(self.street_field_expl[0]))

        if expl_id:
            # Set SQL to get 'expl_name'
            sql = ("SELECT " + self.params['expl_field_name'] + ""
                   " FROM " + self.controller.schema_name + "." + self.params['expl_layer'] + ""
                   " WHERE " + self.params['expl_field_code'] + " = " + str(expl_id))
            row = self.controller.get_row(sql, log_sql=False)
            if row:
                utils_giswater.setSelectedItem(dialog, dialog.address_exploitation, row[0])

        # Set signals
        dialog.address_exploitation.currentIndexChanged.connect(
            partial(self.address_fill_postal_code, dialog, dialog.address_postal_code))
        dialog.address_exploitation.currentIndexChanged.connect(
            partial(self.address_populate, dialog, dialog.address_street, 'street_layer', 'street_field_code', 'street_field_name'))
        dialog.address_exploitation.currentIndexChanged.connect(
            partial(self.address_get_numbers, dialog, dialog.address_exploitation, self.street_field_expl[0], False, False))
        dialog.address_postal_code.currentIndexChanged.connect(
            partial(self.address_get_numbers, dialog, dialog.address_postal_code, portal_field_postal[0], False, False))
        dialog.address_street.currentIndexChanged.connect(
            partial(self.address_get_numbers, dialog, dialog.address_street, self.params['portal_field_code'], True))
        dialog.address_number.activated.connect(partial(self.address_zoom_portal, dialog))


    def address_zoom_portal(self, dialog):
        """ Show street data on the canvas when selected street and number in street tab """

        # Get selected street
        street = utils_giswater.getWidgetText(dialog, dialog.address_street)
        civic = utils_giswater.getWidgetText(dialog, dialog.address_number)
        if street == 'null' or civic == 'null':
            return

            # Get selected portal
        elem = dialog.address_number.itemData(dialog.address_number.currentIndex())
        if not elem:
            # that means that user has edited manually the combo but the element
            # does not correspond to any combo element
            message = "Element does not exist"
            self.controller.show_warning(message, parameter=civic)
            return

        # select this feature in order to copy to memory layer
        aux = (self.params['portal_field_code'] + " = '" + str(elem[0]) + "'"
               " AND " + self.params['portal_field_number'] + " = '" + str(elem[1]) + "'")
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = expr.parserErrorString()
            self.controller.show_warning(message, parameter=aux)
            return

            # Get a featureIterator from an expression
        # Build a list of feature Ids from the previous result
        # Select featureswith the ids obtained
        layer = self.layers['portal_layer']
        it = self.layers['portal_layer'].getFeatures(QgsFeatureRequest(expr))
        ids = [i.id() for i in it]
        layer.selectByIds(ids)

        # Zoom to selected feature of the layer
        self.zoom_to_selected_features(self.layers['portal_layer'], 'node')


    def mincut_composer(self):
        """ Open Composer """

        # Set dialog add_connec
        self.dlg_comp = MincutComposer()
        self.load_settings(self.dlg_comp)

        # Fill ComboBox cbx_template with templates *.qpt from ...system_variables/composers_path
        template_folder = self.settings.value('system_variables/composers_path')
        template_files = os.listdir(template_folder)
        self.files_qpt = [i for i in template_files if i.endswith('.qpt')]
        self.dlg_comp.cbx_template.clear()
        self.dlg_comp.cbx_template.addItem('')
        for template in self.files_qpt:
            self.dlg_comp.cbx_template.addItem(str(template))

        # Set signals
        self.dlg_comp.btn_ok.clicked.connect(self.open_composer)
        self.dlg_comp.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_comp))
        self.dlg_comp.rejected.connect(partial(self.close_dialog, self.dlg_comp))
        self.dlg_comp.cbx_template.currentIndexChanged.connect(self.set_template)
        
        # Open dialog
        self.dlg_comp.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_comp.open()


    def set_template(self):

        template = self.dlg_comp.cbx_template.currentText()
        self.template = template[:-4]


    def open_composer(self):

        # Check if template is selected
        if str(self.dlg_comp.cbx_template.currentText()) == "":
            message = "You need to select a template"
            self.controller.show_warning(message)
            return

        # Check if template file exists
        template_path = self.settings.value('system_variables/composers_path/' + os.sep + str(self.template) + '.qpt')
        if not os.path.exists(template_path):
            message = "File not found"
            self.controller.show_warning(message, parameter=template_path)
            return

        # Check if composer exist
        composers = self.get_composers_list()
        index = self.get_composer_index(str(self.template))

        # Composer not found
        if index == len(composers):

            # Create new composer with template selected in combobox(self.template)
            template_file = open(template_path, 'rt')
            template_content = template_file.read()
            template_file.close()
            document = QDomDocument()
            document.setContent(template_content)

            # TODO: Test it!
            if Qgis.QGIS_VERSION_INT < 29900:
                comp_view = self.iface.createNewComposer(str(self.template))
                comp_view.composition().loadFromTemplate(document)
            else:
                project = QgsProject.instance()
                comp_view = QgsLayout(project)
                comp_view.loadFromTemplate(document)
                layout_manager = project.layoutManager()
                layout_manager.addLayout(comp_view)

        else:
            comp_view = composers[index]

        # Manage mincut layout
        self.manage_mincut_layout(comp_view)


    def manage_mincut_layout(self, layout):
        """ Manage mincut layout """

        if layout is None:
            self.controller.log_warning("Layout not found")
            return

        title = self.dlg_comp.title.text()
        rotation = float(self.dlg_comp.rotation.text())

        if Qgis.QGIS_VERSION_INT < 29900:

            # Show layout
            main_window = layout.composerWindow()
            main_window.setWindowFlags(Qt.WindowStaysOnTopHint)
            main_window.show()

            # Zoom map to extent, rotation, title
            composition = layout.composition()
            map_item = composition.getComposerItemById('Mapa')
            map_item.setMapCanvas(self.canvas)
            map_item.zoomToExtent(self.canvas.extent())
            map_item.setMapRotation(rotation)
            profile_title = composition.getComposerItemById('title')
            profile_title.setText(str(title))

            # Preview Atlas and refresh items
            composition.setAtlasMode(QgsComposition.PreviewAtlas)
            composition.refreshItems()
            composition.update()

        # TODO: Test it!
        else:

            # Show layout
            self.iface.openLayoutDesigner(layout)

            # Zoom map to extent, rotation, title
            map_item = layout.itemById('Mapa')
            #map_item.setMapCanvas(self.canvas)
            map_item.zoomToExtent(self.canvas.extent())
            map_item.setMapRotation(rotation)
            profile_title = layout.itemById('title')
            profile_title.setText(str(title))

            # Refresh items
            layout.refresh()
            layout.updateBounds()


    def enable_widgets(self, state):
        """ Enable/Disable widget depending @state """
        
        # Planified
        if state == '0':
            
            self.dlg_mincut.work_order.setDisabled(False)
            # Group Location
            self.dlg_mincut.address_exploitation.setDisabled(False)
            self.dlg_mincut.address_postal_code.setDisabled(False)
            self.dlg_mincut.address_street.setDisabled(False)
            self.dlg_mincut.address_number.setDisabled(False)
            # Group Details
            self.dlg_mincut.type.setDisabled(False)
            self.dlg_mincut.cause.setDisabled(False)
            self.dlg_mincut.cbx_recieved_day.setDisabled(False)
            self.dlg_mincut.cbx_recieved_time.setDisabled(False)
            # Group Prediction
            self.dlg_mincut.cbx_date_start_predict.setDisabled(False)
            self.dlg_mincut.cbx_hours_start_predict.setDisabled(False)
            self.dlg_mincut.cbx_date_end_predict.setDisabled(False)
            self.dlg_mincut.cbx_hours_end_predict.setDisabled(False)
            self.dlg_mincut.assigned_to.setDisabled(False)
            self.dlg_mincut.pred_description.setDisabled(False)
            # Group Real Details
            self.dlg_mincut.cbx_date_start.setDisabled(True)
            self.dlg_mincut.cbx_hours_start.setDisabled(True)
            self.dlg_mincut.cbx_date_end.setDisabled(True)
            self.dlg_mincut.cbx_hours_end.setDisabled(True)
            self.dlg_mincut.distance.setDisabled(True)
            self.dlg_mincut.depth.setDisabled(True)
            self.dlg_mincut.appropiate.setDisabled(True)
            self.dlg_mincut.real_description.setDisabled(True)
            self.dlg_mincut.btn_start.setDisabled(True)
            self.dlg_mincut.btn_end.setDisabled(True)        
            # Actions
            self.action_mincut.setDisabled(False)
            self.action_custom_mincut.setDisabled(True)
            self.action_add_connec.setDisabled(False)
            self.action_add_hydrometer.setDisabled(False)
        
        # In Progess    
        elif state == '1':
            
            self.dlg_mincut.work_order.setDisabled(True)
            # Group Location            
            self.dlg_mincut.address_exploitation.setDisabled(True)
            self.dlg_mincut.address_postal_code.setDisabled(True)
            self.dlg_mincut.address_street.setDisabled(True)
            self.dlg_mincut.address_number.setDisabled(True)
            # Group Details
            self.dlg_mincut.type.setDisabled(True)
            self.dlg_mincut.cause.setDisabled(True)
            self.dlg_mincut.cbx_recieved_day.setDisabled(True)
            self.dlg_mincut.cbx_recieved_time.setDisabled(True)
            # Group Prediction dates
            self.dlg_mincut.cbx_date_start_predict.setDisabled(True)
            self.dlg_mincut.cbx_hours_start_predict.setDisabled(True)
            self.dlg_mincut.cbx_date_end_predict.setDisabled(True)
            self.dlg_mincut.cbx_hours_end_predict.setDisabled(True)
            self.dlg_mincut.assigned_to.setDisabled(True)
            self.dlg_mincut.pred_description.setDisabled(True)
            # Group Real dates
            self.dlg_mincut.cbx_date_start.setDisabled(False)
            self.dlg_mincut.cbx_hours_start.setDisabled(False)
            self.dlg_mincut.cbx_date_end.setDisabled(False)
            self.dlg_mincut.cbx_hours_end.setDisabled(False)
            self.dlg_mincut.distance.setDisabled(False)
            self.dlg_mincut.depth.setDisabled(False)
            self.dlg_mincut.appropiate.setDisabled(False)
            self.dlg_mincut.real_description.setDisabled(False)
            self.dlg_mincut.btn_start.setDisabled(True)
            self.dlg_mincut.btn_end.setDisabled(False)        
            # Actions
            self.action_mincut.setDisabled(False)
            self.action_custom_mincut.setDisabled(True)
            self.action_add_connec.setDisabled(False)
            self.action_add_hydrometer.setDisabled(False)
                       
        # Finished
        elif state == '2':
            
            self.dlg_mincut.work_order.setDisabled(True)
            # Group Location  
            self.dlg_mincut.address_exploitation.setDisabled(True)
            self.dlg_mincut.address_postal_code.setDisabled(True)
            self.dlg_mincut.address_street.setDisabled(True)
            self.dlg_mincut.address_number.setDisabled(True)
            # Group Details
            self.dlg_mincut.type.setDisabled(True)
            self.dlg_mincut.cause.setDisabled(True)
            self.dlg_mincut.cbx_recieved_day.setDisabled(True)
            self.dlg_mincut.cbx_recieved_time.setDisabled(True)
            # Group Prediction dates
            self.dlg_mincut.cbx_date_start_predict.setDisabled(True)
            self.dlg_mincut.cbx_hours_start_predict.setDisabled(True)
            self.dlg_mincut.cbx_date_end_predict.setDisabled(True)
            self.dlg_mincut.cbx_hours_end_predict.setDisabled(True)
            self.dlg_mincut.assigned_to.setDisabled(True)
            self.dlg_mincut.pred_description.setDisabled(True)
            # Group Real dates
            self.dlg_mincut.cbx_date_start.setDisabled(True)
            self.dlg_mincut.cbx_hours_start.setDisabled(True)
            self.dlg_mincut.cbx_date_end.setDisabled(True)
            self.dlg_mincut.cbx_hours_end.setDisabled(True)
            self.dlg_mincut.distance.setDisabled(True)
            self.dlg_mincut.depth.setDisabled(True)
            self.dlg_mincut.appropiate.setDisabled(True)
            self.dlg_mincut.real_description.setDisabled(True)
            self.dlg_mincut.btn_start.setDisabled(True)
            self.dlg_mincut.btn_end.setDisabled(True) 
            # Actions        
            self.action_mincut.setDisabled(True)
            self.action_custom_mincut.setDisabled(True)
            self.action_add_connec.setDisabled(True)
            self.action_add_hydrometer.setDisabled(True)

