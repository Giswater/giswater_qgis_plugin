"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtCore import QPoint, Qt, SIGNAL, QDate, QTime, QPyNullVariant
from PyQt4.QtGui import QLineEdit, QPushButton, QComboBox, QTextEdit, QDateEdit, QTimeEdit, QAction, QStringListModel, QCompleter, QColor
from PyQt4.QtSql import QSqlTableModel
from qgis.core import QgsFeatureRequest, QgsExpression, QgsPoint, QgsExpressionContextUtils
from qgis.gui import QgsMapToolEmitPoint, QgsMapCanvasSnapper, QgsVertexMarker

import os
import sys
import operator
from functools import partial
from datetime import datetime

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater
from parent import ParentAction

from mincut_config import MincutConfig
from multiple_snapping import MultipleSnapping                  # @UnresolvedImport  
from ..ui.mincut import Mincut                                  # @UnresolvedImport  
from ..ui.mincut_fin import Mincut_fin                          # @UnresolvedImport  
from ..ui.mincut_add_hydrometer import Mincut_add_hydrometer    # @UnresolvedImport  
from ..ui.mincut_add_connec import Mincut_add_connec            # @UnresolvedImport  


class MincutParent(ParentAction, MultipleSnapping):
    
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class constructor """

        # Call ParentAction constructor
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.canvas = self.iface.mapCanvas()
        
        # Create separate class to manage 'actionConfig'
        self.mincut_config = MincutConfig(self)                

        # Get layers of node, arc, connec group
        self.node_group = []
        self.connec_group = []
        self.arc_group = []

        # Vertex marker
        self.vertex_marker = QgsVertexMarker(self.canvas)
        self.vertex_marker.setColor(QColor(255, 0, 255))
        self.vertex_marker.setIconSize(11)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)  # or ICON_CROSS, ICON_X, ICON_BOX
        self.vertex_marker.setPenWidth(3)


    def init_mincut_form(self):
        """ Custom form initial configuration """

        # Create the appropriate map tool and connect the gotPoint() signal.
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.snapper = QgsMapCanvasSnapper(self.canvas)

        # Refresh canvas, remove all old selections
        self.remove_selection()      

        self.dlg = Mincut()
        utils_giswater.setDialog(self.dlg)
        self.load_settings(self.dlg)
        self.dlg.setWindowFlags(Qt.WindowStaysOnTopHint)

        # TODO: parametrize list of layers
        self.group_pointers_connec = []
        self.group_layers_connec = ["Wjoin", "Tap", "Fountain", "Greentap"]
        for layername in self.group_layers_connec:
            layer = self.controller.get_layer_by_layername(layername)
            if layer:
                self.group_pointers_connec.append(layer)            

        self.group_pointers_node = []
        self.group_layers_node = ["Junction", "Valve", "Reduction", "Tank", "Meter", "Manhole", "Source", 
                                  "Hydrant", "Pump", "Filter", "Waterwell", "Register", "Netwjoin"]
        for layername in self.group_layers_node:
            layer = self.controller.get_layer_by_layername(layername)
            if layer:
                self.group_pointers_node.append(layer)
                
        self.group_layers_arc = ["Pipe", "Varc"]

        # Control current layer (due to QGIS bug in snapping system)
        if self.canvas.currentLayer() is None:
            self.iface.setActiveLayer(self.group_pointers_node[0])

        self.state = self.dlg.findChild(QLineEdit, "state")
        self.result_mincut_id = self.dlg.findChild(QLineEdit, "result_mincut_id")
        self.customer_state = self.dlg.findChild(QLineEdit, "customer_state")
        self.work_order = self.dlg.findChild(QLineEdit, "work_order")
        self.pred_description = self.dlg.findChild(QTextEdit, "pred_description")
        self.real_description = self.dlg.findChild(QTextEdit, "real_description")
        self.distance = self.dlg.findChild(QLineEdit, "distance")
        self.depth = self.dlg.findChild(QLineEdit, "depth")

        self.address_exploitation = self.dlg.findChild(QComboBox, "address_exploitation")
        self.address_postal_code = self.dlg.findChild(QComboBox, "address_postal_code")
        self.address_street = self.dlg.findChild(QComboBox, "address_street")
        self.address_number = self.dlg.findChild(QComboBox, "address_number")

        # Get parameters of 'searchplus' from table 'config_param_system' 
        if not self.searchplus_get_parameters():
            self.enabled = False
            return
        
        self.adress_init_config()
        
        # Set signals
        self.dlg.address_exploitation.currentIndexChanged.connect(partial(self.address_fill_postal_code, self.dlg.address_postal_code))
        self.dlg.address_exploitation.currentIndexChanged.connect(partial(self.address_populate, self.dlg.address_street, 'street_layer', 'street_field_code', 'street_field_name'))
        self.dlg.address_exploitation.currentIndexChanged.connect(partial(self.address_get_numbers, self.dlg.address_exploitation, 'expl_id', False))
        self.dlg.address_postal_code.currentIndexChanged.connect(partial(self.address_get_numbers, self.dlg.address_postal_code, 'postcode', False))
        self.dlg.address_street.currentIndexChanged.connect(partial(self.address_get_numbers, self.dlg.address_street, self.params['portal_field_code'], True))

        self.type = self.dlg.findChild(QComboBox, "type")
        self.cause = self.dlg.findChild(QComboBox, "cause")

        # Btn_close and btn_accept
        self.btn_accept_main = self.dlg.findChild(QPushButton, "btn_accept")
        self.btn_cancel_main = self.dlg.findChild(QPushButton, "btn_cancel")
        self.btn_cancel_main.clicked.connect(self.mincut_close)

        # Get status 'planified' (id = 0)
        sql = "SELECT name FROM " + self.schema_name + ".anl_mincut_cat_state WHERE id = 0"
        row = self.controller.get_row(sql)
        if row:
            self.state.setText(str(row[0]))

        # Fill ComboBox type
        sql = ("SELECT id"
               " FROM " + self.schema_name + ".anl_mincut_cat_type"
               " ORDER BY id")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("type", rows, False)

        # Fill ComboBox cause
        sql = ("SELECT id"
               " FROM " + self.schema_name + ".anl_mincut_cat_cause"
               " ORDER BY id")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("cause", rows, False)

        # Fill ComboBox assigned_to
        self.assigned_to = self.dlg.findChild(QComboBox, "assigned_to")
        sql = ("SELECT name"
               " FROM " + self.schema_name + ".cat_users"
               " ORDER BY id")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("assigned_to", rows, False)

        self.cbx_recieved_day = self.dlg.findChild(QDateEdit, "cbx_recieved_day")
        self.cbx_recieved_time = self.dlg.findChild(QTimeEdit, "cbx_recieved_time")

        # Set all QDateEdit to current date
        self.cbx_date_start = self.dlg.findChild(QDateEdit, "cbx_date_start")
        self.cbx_hours_start = self.dlg.findChild(QTimeEdit, "cbx_hours_start")

        self.cbx_date_end = self.dlg.findChild(QDateEdit, "cbx_date_end")
        self.cbx_hours_end = self.dlg.findChild(QTimeEdit, "cbx_hours_end")

        # Widgets for predict date
        self.cbx_date_start_predict = self.dlg.findChild(QDateEdit, "cbx_date_start_predict")
        self.cbx_hours_start_predict = self.dlg.findChild(QTimeEdit, "cbx_hours_start_predict")

        # Widgets for real date
        self.cbx_date_end_predict = self.dlg.findChild(QDateEdit, "cbx_date_end_predict")
        self.cbx_hours_end_predict = self.dlg.findChild(QTimeEdit, "cbx_hours_end_predict")

        # Btn_end and btn_start
        self.btn_start = self.dlg.findChild(QPushButton, "btn_start")
        self.btn_start.clicked.connect(self.real_start)

        self.btn_end = self.dlg.findChild(QPushButton, "btn_end")
        self.btn_end.clicked.connect(self.real_end)

        # Toolbar actions
        action = self.dlg.findChild(QAction, "actionConfig")
        action.triggered.connect(self.mincut_config.config)
        self.set_icon(action, "99")
        self.action_config = action

        action = self.dlg.findChild(QAction, "actionMincut")
        action.triggered.connect(self.auto_mincut)
        self.set_icon(action, "126")
        self.action_mincut = action

        action = self.dlg.findChild(QAction, "actionCustomMincut")
        action.triggered.connect(self.custom_mincut)
        self.set_icon(action, "123")
        self.action_custom_mincut = action

        action = self.dlg.findChild(QAction, "actionAddConnec")
        action.triggered.connect(self.add_connec)
        self.set_icon(action, "121")
        self.action_add_connec = action

        action = self.dlg.findChild(QAction, "actionAddHydrometer")
        action.triggered.connect(self.add_hydrometer)
        self.set_icon(action, "122")
        self.action_add_hydrometer = action

        # Show future id of mincut
        sql = "SELECT MAX(id) FROM " + self.schema_name + ".anl_mincut_result_cat "
        row = self.controller.get_row(sql)
        if row:
            result_mincut_id = row[0] + 1
            self.result_mincut_id.setText(str(result_mincut_id))

        self.dlg.show()


    def mg_mincut(self):
        """ Button 26: New Mincut """

        self.init_mincut_form()

        self.action = "mg_mincut"
        self.btn_accept_main.clicked.connect(partial(self.accept_save_data))
        self.dlg.work_order.textChanged.connect(self.activate_actions_mincut)

        # Get current date. Set all QDateEdit to current date
        date_start = QDate.currentDate()
        self.cbx_date_start.setDate(date_start)
        self.cbx_date_end.setDate(date_start)

        self.cbx_recieved_day.setDate(date_start)
        self.cbx_date_start_predict.setDate(date_start)
        self.cbx_date_end_predict.setDate(date_start)

        # Btn_end and btn_start
        self.btn_start.clicked.connect(self.real_start)
        self.btn_end.clicked.connect(self.real_end)

        self.dlg.show()


    def mincut_close(self):

        # If id exists in data base on btn_cancel delete
        if self.action == "mg_mincut":
            result_mincut_id = self.dlg.result_mincut_id.text()
            sql = ("SELECT id FROM " + self.schema_name + ".anl_mincut_result_cat"
                   " WHERE id = " + str(result_mincut_id))
            row = self.controller.get_row(sql)
            if row:
                sql = ("DELETE FROM " + self.schema_name + ".anl_mincut_result_cat"
                       " WHERE id = " + str(result_mincut_id))
                self.controller.execute_sql(sql)
                self.controller.show_info("Mincut canceled!")                   
        
        # Close dialog, save dialog position, and disconnect snapping
        self.close_dialog(self.dlg)
        self.disconnect_snapping()
        
    
    def disconnect_snapping(self):
        """ Select 'Pan' as current map tool and disconnect snapping """
        
        try:
            self.iface.actionPan().trigger()     
            self.canvas.xyCoordinates.disconnect()             
            self.emit_point.canvasClicked.disconnect()
        except Exception:          
            pass


    def activate_actions_mincut(self):

        disabled = (self.dlg.work_order.text() == '')
        self.action_mincut.setDisabled(disabled)
        self.action_add_connec.setDisabled(disabled)
        self.action_add_hydrometer.setDisabled(disabled)

        self.dlg.address_exploitation.setDisabled(disabled)
        self.dlg.address_postal_code.setDisabled(disabled)
        self.dlg.address_street.setDisabled(disabled)
        self.dlg.address_number.setDisabled(disabled)

        self.dlg.type.setDisabled(disabled)
        self.dlg.cause.setDisabled(disabled)
        self.dlg.cbx_date_start_predict.setDisabled(disabled)
        self.dlg.cbx_hours_start_predict.setDisabled(disabled)
        self.dlg.cbx_date_end_predict.setDisabled(disabled)
        self.dlg.cbx_hours_end_predict.setDisabled(disabled)
        self.dlg.assigned_to.setDisabled(disabled)
        self.dlg.pred_description.setDisabled(disabled)


    def activate_actions_custom_mincut(self):

        # On inserting work order
        self.action_mincut.setDisabled(False)
        self.action_custom_mincut.setDisabled(True)
        self.action_add_connec.setDisabled(False)
        self.action_add_hydrometer.setDisabled(False)

        self.dlg.address_exploitation.setDisabled(False)
        self.dlg.address_postal_code.setDisabled(False)
        self.dlg.address_street.setDisabled(False)
        self.dlg.address_number.setDisabled(False)
        self.dlg.type.setDisabled(False)
        self.dlg.cause.setDisabled(False)
        self.dlg.cbx_recieved_day.setDisabled(False)
        self.dlg.cbx_recieved_time.setDisabled(False)
        self.dlg.cbx_date_start_predict.setDisabled(False)
        self.dlg.cbx_hours_start_predict.setDisabled(False)
        self.dlg.cbx_date_end_predict.setDisabled(False)
        self.dlg.cbx_hours_end_predict.setDisabled(False)
        self.dlg.assigned_to.setDisabled(False)
        self.dlg.pred_description.setDisabled(False)
        self.dlg.cbx_date_start.setDisabled(False)
        self.dlg.cbx_hours_start.setDisabled(False)
        self.dlg.cbx_date_end.setDisabled(False)
        self.dlg.cbx_hours_end.setDisabled(False)
        self.dlg.distance.setDisabled(False)
        self.dlg.depth.setDisabled(False)
        self.dlg.appropiate.setDisabled(False)
        self.dlg.real_description.setDisabled(False)
        self.dlg.btn_start.setDisabled(False)
        self.dlg.btn_end.setDisabled(False)


    def real_start(self):

        self.date_start = QDate.currentDate()
        self.cbx_date_start.setDate(self.date_start)

        self.time_start = QTime.currentTime()
        self.cbx_hours_start.setTime(self.time_start)

        self.btn_end.setEnabled(True)

        self.distance.setEnabled(True)
        self.depth.setEnabled(True)
        self.real_description.setEnabled(True)

        # Get status 'in progress' (id = 1)
        sql = "SELECT name FROM " + self.schema_name + ".anl_mincut_cat_state WHERE id = 1"
        row = self.controller.get_row(sql)
        if row:
            self.state.setText(str(row[0]))

        # Deactivate group of widgets location, details, prediction dates
        self.dlg.address_exploitation.setDisabled(True)
        self.dlg.address_postal_code.setDisabled(True)
        self.dlg.address_street.setDisabled(True)
        self.dlg.address_number.setDisabled(True)
        self.dlg.type.setDisabled(True)
        self.dlg.cause.setDisabled(True)
        self.dlg.cbx_recieved_day.setDisabled(True)
        self.dlg.cbx_recieved_time.setDisabled(True)
        self.dlg.cbx_date_start_predict.setDisabled(True)
        self.dlg.cbx_hours_start_predict.setDisabled(True)
        self.dlg.cbx_date_end_predict.setDisabled(True)
        self.dlg.cbx_hours_end_predict.setDisabled(True)
        self.dlg.assigned_to.setDisabled(True)
        self.dlg.pred_description.setDisabled(True)

        self.action_custom_mincut.setDisabled(True)
        self.dlg.work_order.setDisabled(True)

        dateStart_real = self.cbx_date_start.date()
        timeStart_real = self.cbx_hours_start.time()
        forecast_start_real = dateStart_real.toString('yyyy-MM-dd') + " " + timeStart_real.toString('HH:mm:ss')
        result_mincut_id_text = self.dlg.result_mincut_id.text()
        sql = "UPDATE " + self.schema_name + ".anl_mincut_result_cat "
        sql += " SET mincut_state = 1, exec_start = '" + str(forecast_start_real) + "' "
        sql += " WHERE id = '" + str(result_mincut_id_text) + "'"
        self.controller.execute_sql(sql)


    def real_end(self):

        # Set current date and time
        self.date_end = QDate.currentDate()
        self.cbx_date_end.setDate(self.date_end)

        self.time_end = QTime.currentTime()
        self.cbx_hours_end.setTime(self.time_end)

        # Create the dialog and signals
        self.dlg_fin = Mincut_fin()
        utils_giswater.setDialog(self.dlg_fin)

        self.work_order_fin = self.dlg_fin.findChild(QLineEdit, "work_order")
        self.street_fin = self.dlg_fin.findChild(QLineEdit, "address_street")
        self.number_fin = self.dlg_fin.findChild(QLineEdit, "address_number")
        btn_set_real_location = self.dlg_fin.findChild(QPushButton, "btn_set_real_location")
        btn_set_real_location.clicked.connect(self.set_real_location)

        # Fill ComboBox assigned_to
        sql = "SELECT name"
        sql += " FROM " + self.schema_name + ".cat_users"
        sql += " ORDER BY id"
        rows = self.controller.get_rows(sql)
        self.assigned_to_fin = self.dlg_fin.findChild(QComboBox, "assigned_to_fin")
        utils_giswater.fillComboBox("assigned_to_fin", rows, False)
        self.assigned_to_current = str(self.assigned_to.currentText())
        # Set value
        utils_giswater.setWidgetText("assigned_to_fin", str(self.assigned_to_current))

        self.cbx_date_start_fin = self.dlg_fin.findChild(QDateEdit, "cbx_date_start_fin")
        self.cbx_hours_start_fin = self.dlg_fin.findChild(QTimeEdit, "cbx_hours_start_fin")
        self.date_start = self.cbx_date_start.date()
        self.time_start = self.cbx_hours_start.time()
        self.cbx_date_start_fin.setDate(self.date_start)
        self.cbx_hours_start_fin.setTime(self.time_start)
        self.cbx_date_end_fin = self.dlg_fin.findChild(QDateEdit, "cbx_date_end_fin")
        self.cbx_hours_end_fin = self.dlg_fin.findChild(QTimeEdit, "cbx_hours_end_fin")

        self.cbx_date_end_fin.setDate(self.date_end)
        self.cbx_hours_end_fin.setTime(self.time_end)
        btn_accept = self.dlg_fin.findChild(QPushButton, "btn_accept")
        btn_accept.clicked.connect(self.accept)
        btn_cancel = self.dlg_fin.findChild(QPushButton, "btn_cancel")
        btn_cancel.clicked.connect(self.dlg_fin.close)

        # TODO: Set values mincut and address
        utils_giswater.setText("mincut", str(self.result_mincut_id.text()))
        utils_giswater.setText("address_street", str(self.address_street.text()))
        utils_giswater.setText("address_number", str(self.address_number.text()))
        self.work_order_fin.setText(str(self.work_order.text()))
        
        # Get status 'finished' (id = 2)
        sql = "SELECT name FROM " + self.schema_name + ".anl_mincut_cat_state WHERE id = 2"
        row = self.controller.get_row(sql)
        if row:
            self.state.setText(str(row[0]))

        self.dlg.work_order.setDisabled(True)

        self.dlg.cbx_date_start.setDisabled(True)
        self.dlg.cbx_hours_start.setDisabled(True)
        self.dlg.cbx_date_end.setDisabled(True)
        self.dlg.cbx_hours_end.setDisabled(True)
        self.dlg.distance.setDisabled(True)
        self.dlg.depth.setDisabled(True)
        self.dlg.appropiate.setDisabled(True)
        self.dlg.real_description.setDisabled(True)
        self.dlg.btn_start.setDisabled(True)
        self.dlg.btn_end.setDisabled(True)

        self.action_mincut.setDisabled(True)
        self.action_custom_mincut.setDisabled(True)
        self.action_add_connec.setDisabled(True)
        self.action_add_hydrometer.setDisabled(True)

        # Open the dialog
        self.dlg_fin.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_fin.show()


    def set_real_location(self):

        # Activatre snapping of node and arcs
        self.canvas.connect(self.canvas, SIGNAL("xyCoordinates(const QgsPoint&)"), self.mouse_move_node_arc)

        #self.emit_point.canvasClicked.disconnect(self.auto_mincut_snapping)

        self.emit_point.canvasClicked.connect(self.snapping_node_arc_real_location)


    def accept_save_data(self):
        """ Slot function button 'Accept' """
        
        # Check if user entered a work order
        if not self.check_work_order():
            return

        # TODO:
        mincut_result_state_text = self.state.text()
        mincut_result_state = None      
        if mincut_result_state_text == 'Planified':
            mincut_result_state = int(0)
        elif mincut_result_state_text == 'In Progress':
            mincut_result_state = int(1)
        elif mincut_result_state_text == 'Finished':
            mincut_result_state = int(2) 

        # Manage 'address'
        address_exploitation = utils_giswater.getWidgetText(self.dlg.address_exploitation, return_string_null=False)
        sql = ("SELECT expl_id, name"
               " FROM " + self.controller.schema_name + ".exploitation"
               " WHERE name ='" + str(address_exploitation) + "'")
        row = self.controller.get_row(sql, log_sql=True)
        if row:
            address_exploitation_id = row[0]
            address_exploitation_name = row[1]
            
        address_postal_code = utils_giswater.getWidgetText(self.dlg.address_postal_code, return_string_null=False)
        address_street = utils_giswater.getWidgetText("address_street", return_string_null=False)
        address_number = utils_giswater.getWidgetText(self.dlg.address_number, return_string_null=False)

        mincut_result_type = self.type.currentText()
        anl_cause = self.cause.currentText()
        work_order = self.work_order.text()

        anl_descript = utils_giswater.getWidgetText("pred_description", return_string_null=False)
        exec_limit_distance = str(self.distance.text())
        exec_depth = str(self.depth.text())
        exec_descript =  utils_giswater.getWidgetText("real_description")
        
        # Get prediction date - start
        date_start_predict = self.cbx_date_start_predict.date()
        time_start_predict = self.cbx_hours_start_predict.time()
        forecast_start_predict = date_start_predict.toString('yyyy-MM-dd') + " " + time_start_predict.toString('HH:mm:ss')

        # Get prediction date - end
        date_end_predict = self.cbx_date_end_predict.date()
        time_end_predict = self.cbx_hours_end_predict.time()
        forecast_end_predict = date_end_predict.toString('yyyy-MM-dd') + " " + time_end_predict.toString('HH:mm:ss')

        # Get real date - start
        date_start_real = self.cbx_date_start.date()
        time_start_real = self.cbx_hours_start.time()
        forecast_start_real = date_start_real.toString('yyyy-MM-dd') + " " + time_start_real.toString('HH:mm:ss')

        # Get real date - end
        date_end_real = self.cbx_date_end.date()
        time_end_real = self.cbx_hours_end.time()
        forecast_end_real = date_end_real.toString('yyyy-MM-dd') + " " + time_end_real.toString('HH:mm:ss')

        # Check data
        received_day = self.cbx_recieved_day.date()
        received_time = self.cbx_recieved_time.time()
        received_date = received_day.toString('yyyy-MM-dd') + " " + received_time.toString('HH:mm:ss')

        assigned_to = self.assigned_to.currentText()
        cur_user = self.controller.get_project_user()
        appropiate_status = utils_giswater.isChecked("appropiate")

        check_data = [str(mincut_result_state), str(work_order), str(anl_cause), str(received_date), str(forecast_start_predict), str(forecast_end_predict)]
        for data in check_data:
            if data == '':
                message = "Some mandatory field is missing. Please, review your data"
                self.controller.show_warning(message)
                return
        
        # Check if id exist in table 'anl_mincut_result_cat'
        result_mincut_id = self.result_mincut_id.text()        
        sql = ("SELECT id FROM " + self.schema_name + ".anl_mincut_result_cat" 
               " WHERE id = '" + str(result_mincut_id) + "'")        
        rows = self.controller.get_rows(sql)
        # If not found Insert just its 'id'
        if not rows:
            sql = ("INSERT INTO " + self.schema_name + ".anl_mincut_result_cat (id) "
                   " VALUES ('" + str(result_mincut_id) + "')")
            self.controller.execute_sql(sql)

        # Update all the fields
        sql = ("UPDATE " + self.schema_name + ".anl_mincut_result_cat"
               " SET mincut_state = '" + str(mincut_result_state) + "', work_order = '" + str(work_order) + "',"
               " muni_name ='" + str(address_exploitation_name) + "',"
               " muni_id = '" + str(address_exploitation_id) +"', postcode = '" + str(address_postal_code) + "',"
               " postnumber = '" + str(address_number) + "', streetaxis_id = '" + str(address_street) + "',"
               " mincut_type = '" + str(mincut_result_type) + "', anl_cause = '" + str(anl_cause) + "',"
               " anl_tstamp = '" + str(received_date) +"', received_date = '" + str(received_date) +"',"
               " forecast_start = '" + str(forecast_start_predict) + "', forecast_end = '" + str(forecast_end_predict) + "',"
               " anl_descript = '" + str(anl_descript) + "', assigned_to = '" + str(assigned_to) + "', exec_appropiate = '" + str(appropiate_status) + "'")

        if self.btn_end.isEnabled():
            sql += (", exec_start = '" + str(forecast_start_real) +  "', exec_end = '" + str(forecast_end_real) + "',"
                    " exec_from_plot = '" + str(exec_limit_distance) + "', exec_depth = '" + str(exec_depth) + "', "
                    " exec_descript = '" + str(exec_descript) + "', exec_user = '" + str(cur_user) + "'")
            check_data_exec = [str(forecast_start_real), str(forecast_end_real), str(exec_limit_distance), str(exec_depth), str(cur_user)]            
            for data in check_data_exec:
                if data == '':
                    message = "Some mandatory field is missing. Please, review your data"
                    self.controller.show_warning(message, parameter='exec fields')
                    return
                
        sql += " WHERE id = '" + str(result_mincut_id) + "'"
        status = self.controller.execute_sql(sql, log_error=True)
        if status:
            message = "Values has been updated"
            self.controller.show_info(message)
            self.update_result_selector(result_mincut_id)                         
        else:
            message = "Error updating element in table, you need to review data"
            self.controller.show_warning(message)
            return

        # Close dialog and disconnect snapping
        self.dlg.close()
        self.disconnect_snapping()


    def update_result_selector(self, result_mincut_id):
        """ Update table 'anl_mincut_result_selector' """
        
        sql = ("DELETE FROM " + self.schema_name + ".anl_mincut_result_selector WHERE cur_user = current_user;\n"
               "INSERT INTO " + self.schema_name + ".anl_mincut_result_selector (cur_user, result_id) VALUES"
               " (current_user, " + str(result_mincut_id) + ");")
        status = self.controller.execute_sql(sql)
        if not status:
            message = "Error updating table 'anl_mincut_result_selector'"
            self.controller.show_warning(message)   
                

    def accept(self):

        # reach end_date and end_hour from mincut_fin dialog
        datestart = self.cbx_date_start_fin.date()
        timestart = self.cbx_hours_start_fin.time()
        dateend = self.cbx_date_end_fin.date()
        timeend = self.cbx_hours_end_fin.time()

        # set new values of date in mincut dialog
        self.cbx_date_start.setDate(datestart)
        self.cbx_hours_start.setTime(timestart)
        self.cbx_date_end.setDate(dateend)
        self.cbx_hours_end.setTime(timeend)

        self.work_order.setText(str(self.work_order_fin.text()))
        self.address_street.setText(str(self.street_fin.text()))
        self.address_number.setText(str(self.number_fin.text()))

        # Set value
        assigned_to_fin = self.assigned_to_fin.currentText()
        assigned_to = self.dlg.findChild(QComboBox, "assigned_to")
        index = assigned_to.findText(str(assigned_to_fin))
        assigned_to.setCurrentIndex(index)

        exec_start_day = self.cbx_date_start_fin.date()
        exec_start_time = self.cbx_hours_start_fin.time()
        exec_start = exec_start_day.toString('yyyy-MM-dd') + " " + exec_start_time.toString('HH:mm:ss')

        exec_end_day = self.cbx_date_end_fin.date()
        exec_end_time = self.cbx_hours_end_fin.time()
        exec_end = exec_end_day.toString('yyyy-MM-dd') + " " + exec_end_time.toString('HH:mm:ss')

        sql = "UPDATE " + self.schema_name + ".anl_mincut_result_cat"
        sql += " SET  exec_start = '" + str(exec_start) + "', exec_end = '" + str(exec_end) + "', mincut_state = 0, exec_user = '" + str(assigned_to_fin) + "'"
        self.controller.execute_sql(sql)
        
        self.dlg_fin.close()


    def add_connec(self):
        """ B3-121: Connec selector """

        # Check if user entered a work order
        if not self.check_work_order():
            return

        result_mincut_id_text = self.dlg.result_mincut_id.text()
        work_order = self.dlg.work_order.text()

        # Check if id exist in anl_mincut_result_cat
        sql = ("SELECT id FROM " + self.schema_name + ".anl_mincut_result_cat"
               " WHERE id = '" + str(result_mincut_id_text) + "'")
        exist_id = self.controller.get_row(sql)
        if not exist_id:
            sql = ("INSERT INTO " + self.schema_name + ".anl_mincut_result_cat (id, work_order, mincut_class) "
                   " VALUES ('" + str(result_mincut_id_text) + "','" + str(work_order) + "', 2)")
            self.controller.execute_sql(sql)

        # Disable Auto, Custom, Hydrometer
        self.action_mincut.setDisabled(True)
        self.action_custom_mincut.setDisabled(True)
        self.action_add_hydrometer.setDisabled(True)

        # Set dialog add_connec
        self.dlg_connec = Mincut_add_connec()
        utils_giswater.setDialog(self.dlg_connec)

        self.set_icon(self.dlg_connec.btn_insert, "111")
        self.set_icon(self.dlg_connec.btn_delete, "112")
        self.set_icon(self.dlg_connec.btn_snapping, "129")

        btn_delete_connec = self.dlg_connec.findChild(QPushButton, "btn_delete")
        btn_delete_connec.pressed.connect(partial(self.delete_records_connec))
        self.set_icon(btn_delete_connec, "112")

        btn_insert_connec = self.dlg_connec.findChild(QPushButton, "btn_insert")
        btn_insert_connec.pressed.connect(partial(self.insert_connec))
        self.set_icon(btn_insert_connec, "111")

        btn_insert_connec_snap = self.dlg_connec.findChild(QPushButton, "btn_snapping")
        btn_insert_connec_snap.pressed.connect(self.snapping_init_connec)
        self.set_icon(btn_insert_connec_snap, "129")

        btn_accept = self.dlg_connec.findChild(QPushButton, "btn_accept")
        btn_accept.pressed.connect(partial(self.accept_connec, "connec", self.dlg_connec))

        btn_cancel = self.dlg_connec.findChild(QPushButton, "btn_cancel")
        btn_cancel.pressed.connect(partial(self.close_dialog, self.dlg_connec))
        
        # Set autocompleter for 'customer_code'
        self.set_completer_customer_code(self.dlg_connec.connec_id)

        # On opening form check if result_id already exist in anl_mincut_result_connec
        # if exist show data in form / show selection!!!
        if exist_id:
            # Read selection and reload table
            self.select_features_connec()

        self.dlg_connec.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_connec.show()

        
    def set_completer_customer_code(self, widget, set_signal=False):
        """ Set autocompleter for 'customer_code' """
        
        # Get list of 'customer_code'
        sql = "SELECT DISTINCT(customer_code) FROM " + self.schema_name + ".connec"
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

        self.tool = MultipleSnapping(self.iface, self.controller, self.group_layers_connec)
        self.canvas.setMapTool(self.tool)
        self.canvas.selectionChanged.connect(partial(self.snapping_selection_connec))


    def snapping_init_hydro(self):
        """ Snap also to connec (hydrometers has no geometry) """

        self.tool = MultipleSnapping(self.iface, self.controller, self.group_layers_connec)
        self.canvas.setMapTool(self.tool)
        self.canvas.selectionChanged.connect(partial(self.snapping_selection_hydro, self.group_pointers_connec, "rtc_hydrometer_x_connec", "connec_id"))


    def snapping_selection_hydro(self):
        """ Snap to connec layers to add its hydrometers """
        
        self.connec_list = []
        
        for layer in self.group_pointers_connec:                      
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

        # Check expression
        self.connec_expr_filter = expr_filter
        (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
        if not is_valid:
            return        

        self.reload_table_hydro()


    def snapping_selection_connec(self):
        """ Snap to connec layers """
        
        self.connec_list = []
        
        for layer in self.group_pointers_connec:                      
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

        # Check expression
        self.connec_expr_filter = expr_filter
        (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
        if not is_valid:
            return                           
        
        self.reload_table_connec()


    def check_work_order(self):
        """ Check if user entered a work order """

        work_order = self.work_order.text()
        if work_order == "":
            message = "You need to enter work order"
            self.controller.show_info_box(message)
            return False
        else:
            return True


    def add_hydrometer(self):
        """ B4-122: Hydrometer selector """

        self.connec_list = []
            
        # Check if user entered a work order
        if not self.check_work_order():
            return

        result_mincut_id_text = self.dlg.result_mincut_id.text()
        work_order = self.dlg.work_order.text()

        # Check if id exist in table 'anl_mincut_result_cat'
        sql = ("SELECT id FROM " + self.schema_name + ".anl_mincut_result_cat"
               " WHERE id = '" + str(result_mincut_id_text) + "'")
        exist_id = self.controller.get_row(sql)

        # Before updating table 'anl_mincut_result_cat' we already need to have an id into it
        if not exist_id:
            sql = ("INSERT INTO " + self.schema_name + ".anl_mincut_result_cat (id, work_order)"
                   " VALUES ('" + str(result_mincut_id_text) + "','" + str(work_order) + "')")
            self.controller.execute_sql(sql)

        # Update table anl_mincut_result_cat, set mincut_class = 3
        sql = ("UPDATE " + self.schema_name + ".anl_mincut_result_cat"
               " SET mincut_class = 3"
               " WHERE id = '" + str(result_mincut_id_text) + "'")
        self.controller.execute_sql(sql)

        # On inserting work order
        self.action_mincut.setDisabled(True)
        self.action_custom_mincut.setDisabled(True)
        self.action_add_connec.setDisabled(True)

        # Set dialog Mincut_add_hydrometer
        self.dlg_hydro = Mincut_add_hydrometer()
        utils_giswater.setDialog(self.dlg_hydro)
        self.set_icon(self.dlg_hydro.btn_insert, "111")
        self.set_icon(self.dlg_hydro.btn_delete, "112")
        self.set_icon(self.dlg_hydro.btn_snapping, "129")
        self.dlg_hydro.btn_snapping.setEnabled(False)

        btn_delete_hydro = self.dlg_hydro.findChild(QPushButton, "btn_delete")
        btn_delete_hydro.pressed.connect(partial(self.delete_records_hydro))
        btn_insert_hydro = self.dlg_hydro.findChild(QPushButton, "btn_insert")  
        btn_insert_hydro.pressed.connect(partial(self.insert_hydro))
        btn_snapping_hydro = self.dlg_hydro.findChild(QPushButton, "btn_snapping")
        btn_snapping_hydro.pressed.connect(self.snapping_init_hydro)
      
        btn_accept = self.dlg_hydro.findChild(QPushButton, "btn_accept")
        btn_accept.pressed.connect(partial(self.accept_hydro, "hydrometer", self.dlg_hydro))
        btn_cancel = self.dlg_hydro.findChild(QPushButton, "btn_cancel")
        btn_cancel.pressed.connect(partial(self.close_dialog, self.dlg_hydro))     

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
        self.dlg_hydro.hydrometer_id.setCompleter(self.completer_hydro)
        model = QStringListModel()

        # Get 'connec_id' from 'customer_code'
        customer_code = str(self.dlg_hydro.customer_code_connec.text())
        connec_id = self.get_connec_id_from_customer_code(customer_code)
        if connec_id is None:
            return        
        
        # Get 'hydrometers' related with this 'connec'
        sql = ("SELECT DISTINCT(hydrometer_id)"
               " FROM " + self.schema_name + ".rtc_hydrometer_x_connec"
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
        hydrometer_id = utils_giswater.getWidgetText(self.dlg_hydro.hydrometer_id)
        if hydrometer_id == "null":
            message = "You need to enter hydrometer_id"
            self.controller.show_info_box(message)
            return
                        
        # Show message if element is already in the list
        if hydrometer_id in self.hydro_list:
            message = "Selected element already in the list"
            self.controller.show_info_box(message, parameter=hydrometer_id)
            return
                                
        # Set expression filter with 'hydro_list'
        self.hydro_list.append(hydrometer_id)
        expr_filter = "\"hydrometer_id\" IN ("
        for i in range(len(self.hydro_list)):
            expr_filter += "'" + str(self.hydro_list[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"
        
        # Reload table
        self.hydro_expr_filter = expr_filter
        self.reload_table_hydro(expr_filter)

#         # Get 'connec_id' of selected hydrometer
#         sql = ("SELECT connec_id FROM " + self.schema_name + ".rtc_hydrometer_x_connec"
#                " WHERE hydrometer_id = '" + str(hydrometer_id) + "'")
#         row = self.controller.get_row(sql)
#         if not row:
#             message = "Selected hydrometer not found"
#             self.controller.show_info_box(message, parameter=hydrometer_id)
#             return
#         connec_id = str(row[0])


    def select_features_group_layers(self, expr):
        """ Select features of the layers filtering by @expr """
        
        # Iterate over all layers of type 'connec'
        # Select features and them to 'connec_list'
        for layer in self.group_pointers_connec:
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
                    
        self.connec_list = []
        self.connec_expr_filter = None

        # Set 'expr_filter' of connecs related with current mincut
        expr_filter = "\"connec_id\" IN ("
        result_mincut_id = utils_giswater.getWidgetText(self.result_mincut_id)
        sql = ("SELECT connec_id FROM " + self.schema_name + ".anl_mincut_result_connec"
               " WHERE result_id = " + str(result_mincut_id))
        rows = self.controller.get_rows(sql)
        if rows:
            for row in rows:                   
                expr_filter += "'" + str(row[0]) + "', "
            expr_filter = expr_filter[:-2] + ")"                    

        # Check expression
        self.connec_expr_filter = expr_filter
        (is_valid, expr) = self.check_expression(expr_filter, True)
        if not is_valid:
            return     

        # Select features of the layers filtering by @expr
        self.select_features_group_layers(expr)         
                                                    
        # Reload table
        self.reload_table_connec()


    def select_features_hydro(self):
        
        self.connec_list = []
        self.connec_expr_filter = None  

        # Set 'expr_filter' of connecs related with current mincut
        expr_filter = "\"connec_id\" IN ("
        result_mincut_id = utils_giswater.getWidgetText(self.result_mincut_id)
        sql = ("SELECT DISTINCT(connec_id) FROM " + self.schema_name + ".rtc_hydrometer_x_connec AS rtc"
               " INNER JOIN " + self.schema_name + ".anl_mincut_result_hydrometer AS anl"
               " ON anl.hydrometer_id = rtc.hydrometer_id"
               " WHERE result_id = " + str(result_mincut_id))
        rows = self.controller.get_rows(sql)
        if rows:
            for row in rows:                   
                expr_filter += "'" + str(row[0]) + "', "
            expr_filter = expr_filter[:-2] + ")"                    

        # Check expression
        self.connec_expr_filter = expr_filter
        (is_valid, expr) = self.check_expression(expr_filter, True)
        if not is_valid:
            return     

        # Select features of the layers filtering by @expr
        self.select_features_group_layers(expr)
        
        self.hydro_list = []
        self.hydro_expr_filter = None              

        # Get list of 'hydrometer_id' belonging to current result_mincut
        expr_filter = "\"hydrometer_id\" IN ("            
        result_mincut_id = utils_giswater.getWidgetText(self.result_mincut_id)
        sql = ("SELECT hydrometer_id FROM " + self.schema_name + ".anl_mincut_result_hydrometer"
               " WHERE result_id = " + str(result_mincut_id))
        rows = self.controller.get_rows(sql)
        if rows:
            for row in rows:                   
                expr_filter += "'" + str(row[0]) + "', "
                self.hydro_list.append(str(row[0]))
            expr_filter = expr_filter[:-2] + ")"   
            
        # Reload contents of table 'hydro' with expr_filter
        self.hydro_expr_filter = expr_filter               
        self.reload_table_hydro() 
            

    def insert_connec(self):
        """ Select feature with entered id. Set a model with selected filter.
            Attach that model to selected table 
        """

        # Clear list of connec_list
        self.connec_list = []

        # Get 'connec_id' from selected 'customer_code'
        customer_code = utils_giswater.getWidgetText(self.dlg_connec.connec_id)
        if customer_code == 'null':
            message = "You need to enter a customer code"
            self.controller.show_info_box(message) 
            return

        connec_id = self.get_connec_id_from_customer_code(customer_code)
        if connec_id is None:
            return

        # Iterate over all layers
        for layer in self.group_pointers_connec:
            if layer.selectedFeatureCount() > 0:
                # Get selected features of the layer
                features = layer.selectedFeatures()
                for feature in features:
                    # Append 'connec_id' into 'connec_list'
                    feature_id = feature.attribute("connec_id")
                    self.connec_list.append(str(feature_id))

        # Show message if element is already in the list
        if connec_id in self.connec_list:
            message = "Selected element already in the list"
            self.controller.show_info_box(message, parameter=connec_id)
            return
        
        # If feature id doesn't exist in list -> add
        self.connec_list.append(connec_id)

        # Set expression filter with 'connec_list'
        expr_filter = "\"connec_id\" IN ("
        for i in range(len(self.connec_list)):
            expr_filter += "'" + str(self.connec_list[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"

        # Check expression
        self.connec_expr_filter = expr_filter
        (is_valid, expr) = self.check_expression(expr_filter, True)
        if not is_valid:
            return   
            
        # Select features with previous filter
        for layer in self.group_pointers_connec:
            # Build a list of feature id's and select them
            it = layer.getFeatures(QgsFeatureRequest(expr))
            id_list = [i.id() for i in it]
            layer.selectByIds(id_list)

        # Reload contents of table 'connec'
        self.reload_table_connec()


    def get_connec_id_from_customer_code(self, customer_code):
        """ Get 'connec_id' from @customer_code """
                   
        sql = ("SELECT connec_id FROM " + self.schema_name + ".connec"
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
                
                
    def set_table_model(self, widget, table_name, expr_filter):
        """ Sets a TableModel to @widget attached to @table_name and filter @expr_filter """
        
        # Check expression          
        (is_valid, expr) = self.check_expression(expr_filter, True)    #@UnusedVariable
        if not is_valid:
            return expr              

        # Set a model with selected filter expression
        model = QSqlTableModel();
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.select()
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())
        
        # Attach model to selected table 
        widget.setModel(model)
        if expr_filter:
            widget.model().setFilter(expr_filter)
        widget.model().select()        
        
        return expr      
        

    def reload_table_connec(self, expr_filter=None):
        """ Reload contents of table 'connec' with selected @expr_filter """
                         
        table_name = self.schema_name + ".connec"
        widget = self.dlg_connec.tbl_mincut_connec
        if expr_filter is None:
            expr_filter = self.connec_expr_filter        
        expr = self.set_table_model(widget, table_name, expr_filter)
        return expr


    def reload_table_hydro(self, expr_filter=None):
        """ Reload contents of table 'hydro' """
        
        table_name = self.schema_name + ".rtc_hydrometer_x_connec"
        widget = self.dlg_hydro.tbl_hydro  
        if expr_filter is None:
            expr_filter = self.hydro_expr_filter
        expr = self.set_table_model(widget, table_name, expr_filter)
        return expr        


    def delete_records_connec(self):  
        ''' Delete selected rows of the table '''
                
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
            id_feature = widget.model().record(row).value("connec_id")
            inf_text += str(id_feature) + ", "
            list_id = list_id + "'" + str(id_feature) + "', "
            del_id.append(id_feature)
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        message = "Are you sure you want to delete these records?"
        answer = self.controller.ask_question(message, "Delete records", inf_text)
        if answer:
            for el in del_id:
                self.connec_list.remove(el)
                
        # Select features which are in the list
        expr_filter = "\"connec_id\" IN ("
        for i in range(len(self.connec_list)):
            expr_filter += "'" + str(self.connec_list[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"

        # Update model of the widget with selected expr_filter
        self.connec_expr_filter = expr_filter     
        expr = self.reload_table_connec(expr_filter)               

        # Reload selection
        for layer in self.group_pointers_connec:
            # Build a list of feature id's and select them
            it = layer.getFeatures(QgsFeatureRequest(expr))
            id_list = [i.id() for i in it]
            self.controller.log_info(str(id_list))
            layer.selectByIds(id_list)


    def delete_records_hydro(self):  
        ''' Delete selected rows of the table '''
        
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
            id_feature = widget.model().record(row).value("hydrometer_id")
            inf_text += str(id_feature) + ", "
            list_id = list_id + "'" + str(id_feature) + "', "
            del_id.append(id_feature)
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        message = "Are you sure you want to delete these records?"
        answer = self.controller.ask_question(message, "Delete records", inf_text)
        if answer:
            for el in del_id:
                self.hydro_list.remove(el)

        # Select features that are in the list
        expr_filter = "\"hydrometer_id\" IN ("
        for i in range(len(self.hydro_list)):
            expr_filter += "'" + str(self.hydro_list[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"

        # Update model of the widget with selected expr_filter
        self.hydro_expr_filter = expr_filter     
        self.reload_table_hydro(expr_filter)    
        

    def accept_connec(self, element, dlg):
        """ Slot function widget 'btn_accept' of 'connec' dialog 
            Insert into table 'anl_mincut_result_connec' values of current mincut 
        """
        
        result_mincut_id = utils_giswater.getWidgetText(self.dlg.result_mincut_id)
        if result_mincut_id == 'null':
            return

        sql = ("DELETE FROM " + self.schema_name + ".anl_mincut_result_" + str(element) + ""
               " WHERE result_id = " + str(result_mincut_id) + ";\n")
        for element_id in self.connec_list:
            sql += ("INSERT INTO " + self.schema_name + ".anl_mincut_result_" + str(element) + ""
                    " (result_id, " + str(element) + "_id) "
                    " VALUES ('" + str(result_mincut_id) + "', '" + str(element_id) + "');\n")
        
        self.controller.execute_sql(sql)
        self.btn_start.setDisabled(False)
        dlg.close()
        

    def accept_hydro(self, element, dlg):
        """ Slot function widget 'btn_accept' of 'hydrometer' dialog 
            Insert into table 'anl_mincut_result_hydrometer' values of current mincut 
        """
        
        result_mincut_id = utils_giswater.getWidgetText(self.dlg.result_mincut_id)
        if result_mincut_id == 'null':
            return

        sql = ("DELETE FROM " + self.schema_name + ".anl_mincut_result_" + str(element) + ""
               " WHERE result_id = " + str(result_mincut_id) + ";\n")
        for element_id in self.hydro_list:
            sql += ("INSERT INTO " + self.schema_name + ".anl_mincut_result_" + str(element) + " (result_id, " + str(element) + "_id) "
                    " VALUES ('" + str(result_mincut_id) + "', '" + str(element_id) + "');\n")
        
        self.controller.execute_sql(sql)
        self.btn_start.setDisabled(False)
        dlg.close()


    def auto_mincut(self):
        """ B1-126: Automatic mincut analysis """

        # Check if user entered a work order
        if not self.check_work_order():
            return

        # On inserting work order
        self.action_add_connec.setDisabled(True)
        self.action_add_hydrometer.setDisabled(True)
            
        self.canvas.connect(self.canvas, SIGNAL("xyCoordinates(const QgsPoint&)"), self.mouse_move_node_arc)
        self.emit_point.canvasClicked.connect(self.auto_mincut_snapping)


    def auto_mincut_snapping(self, point, btn):  #@UnusedVariable
        """ Automatic mincut: Snapping to 'node' and 'arc' layers """
        
        snapper = QgsMapCanvasSnapper(self.canvas)
        map_point = self.canvas.getCoordinateTransform().transform(point)
        x = map_point.x()
        y = map_point.y()
        event_point = QPoint(x, y)
        snapping_position = QgsPoint(point.x(), point.y())

        # Snapping
        (retval, result) = snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

        # That's the snapped point
        if not result:
            return

        # Check feature
        for snap_point in result:

            elem_type = None
            layername = snap_point.layer.name()
            if layername in self.group_layers_node:
                elem_type = 'node'

            elif layername in self.group_layers_arc:
                elem_type = 'arc'

            if elem_type:
                # Get the point
                point = QgsPoint(snap_point.snappedVertex)
                snapp_feature = next(snap_point.layer.getFeatures(QgsFeatureRequest().setFilterFid(snap_point.snappedAtGeometry)))
                element_id = snapp_feature.attribute(elem_type + '_id')
                self.element_id = str(element_id)
    
                # Leave selection
                snap_point.layer.select([snap_point.snappedAtGeometry])
                self.auto_mincut_execute(element_id, elem_type, snapping_position)
                break   


    def snapping_node_arc_real_location(self, point, btn):  #@UnusedVariable

        snapper = QgsMapCanvasSnapper(self.canvas)
        map_point = self.canvas.getCoordinateTransform().transform(point)
        x = map_point.x()
        y = map_point.y()
        event_point = QPoint(x, y)
        self.real_snapping_position = QgsPoint(point.x(), point.y())

        result_mincut_id_text = self.dlg.result_mincut_id.text()
        srid = self.controller.plugin_settings_value('srid')

        sql = ("UPDATE " + self.schema_name + ".anl_mincut_result_cat"
               " SET exec_the_geom = ST_SetSRID(ST_Point(" + str(self.real_snapping_position.x()) + ", " + str(self.real_snapping_position.y()) + ")," + str(srid) + ")"
               " WHERE id = '" + result_mincut_id_text + "'")
        status = self.controller.execute_sql(sql)
        if status:
            message = "Real location has been updated"
            self.controller.show_info(message)

        # Snapping
        (retval, result) = snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

        # That's the snapped point
        if result:

            # Check feature
            for snap_point in result:

                element_type = snap_point.layer.name()

                if element_type in self.group_layers_node:
                    feat_type = 'node'

                    # Get the point
                    point = QgsPoint(snap_point.snappedVertex)
                    snapp_feature = next(snap_point.layer.getFeatures(QgsFeatureRequest().setFilterFid(snap_point.snappedAtGeometry)))
                    element_id = snapp_feature.attribute(feat_type + '_id')

                    # Leave selection
                    snap_point.layer.select([snap_point.snappedAtGeometry])

                    #self.mincut(element_id, feat_type,snapping_position)
                    break
                
            else:
                node_exist = '0'

            if node_exist == '0':
                for snap_point in result:
                    element_type = snap_point.layer.name()
                    if element_type in self.group_layers_arc:
                        feat_type = 'arc'
                        # Get the point
                        point = QgsPoint(snap_point.snappedVertex)
                        snapp_feature = next(snap_point.layer.getFeatures(QgsFeatureRequest().setFilterFid(snap_point.snappedAtGeometry)))
                        element_id = snapp_feature.attribute(feat_type + '_id')

                        # Leave selection
                        snap_point.layer.select([snap_point.snappedAtGeometry])

                        #self.mincut(element_id, feat_type, snapping_position)
                        break


    def auto_mincut_execute(self, elem_id, elem_type, snapping_position):
        """ Automatic mincut: Execute function 'gw_fct_mincut' """

        result_mincut_id_text = self.dlg.result_mincut_id.text()
        work_order = self.dlg.work_order.text()
        srid = self.controller.plugin_settings_value('srid')
        self.snapping_position = snapping_position

        # Check if id exist in 'anl_mincut_result_cat'
        sql = ("SELECT id FROM " + self.schema_name + ".anl_mincut_result_cat"
               " WHERE id = '" + str(result_mincut_id_text) + "'")
        row = self.controller.get_row(sql)
        # Before of executing 'gw_fct_mincut' we already need to have id in 'anl_mincut_result_cat'
        if not row:
            sql = ("INSERT INTO " + self.schema_name + ".anl_mincut_result_cat (id, work_order, mincut_state)"
                   " VALUES ('" + str(result_mincut_id_text) + "', '" + str(work_order) + "', 2)")
            self.controller.execute_sql(sql)

        # Execute gw_fct_mincut ('feature_id', 'feature_type', 'result_id')
        # feature_id: id of snapped arc/node
        # feature_type: type od snaped element (arc/node)
        # result_mincut_id: result_mincut_id from form
        sql = "SELECT " + self.schema_name + ".gw_fct_mincut('" + str(elem_id) + "', '" + str(elem_type) + "', '" + str(result_mincut_id_text) + "')"
        status = self.controller.execute_sql(sql)
        if status:
            message = "Mincut done successfully"
            self.controller.show_info(message)

            # Update table 'anl_mincut_result_cat'
            sql = ("UPDATE " + self.schema_name + ".anl_mincut_result_cat"
                   " SET mincut_class = 1, anl_the_geom = ST_SetSRID(ST_Point(" + str(snapping_position.x()) + ", " + str(snapping_position.y()) + "), " + str(srid) + "),"
                   " anl_user = current_user, anl_feature_type = '" + str(elem_type) + "', anl_feature_id = '" + str(self.element_id) + "'"
                   " WHERE id = '" + result_mincut_id_text + "'")
            status = self.controller.execute_sql(sql)
            if not status:
                message = "Error updating element in table, you need to review data"
                self.controller.show_warning(message)
                return

            # Refresh map canvas
            self.canvas.refreshAllLayers()

            # If mincut is executed : enable button CustomMincut and button Start
            self.action_custom_mincut.setDisabled(False)
            self.btn_start.setDisabled(False)
            # If mincut is executed : disable button
            self.action_mincut.setDisabled(True)
            self.action_add_connec.setDisabled(True)
            self.action_add_hydrometer.setDisabled(True)


    def custom_mincut(self):
        """ B2-123: Custom mincut analysis. Working just with layer Valve analytics """

        # Check if user entered a work order
        if not self.check_work_order():
            return

        # Disconnect previous connections
        self.canvas.disconnect(self.canvas, SIGNAL("xyCoordinates(const QgsPoint&)"), self.mouse_move_node_arc)
        self.emit_point.canvasClicked.disconnect(self.auto_mincut_snapping)

        # Set active layer
        viewname = 'v_anl_mincut_result_valve'
        layer = self.controller.get_layer_by_tablename(viewname)       
        if layer:
            self.iface.setActiveLayer(layer)
            self.canvas.connect(self.canvas, SIGNAL("xyCoordinates(const QgsPoint&)"), self.mouse_move_valve)
            self.emit_point.canvasClicked.connect(self.custom_mincut_snapping)
        else:
            self.controller.log_info("Layer not found", parameter=viewname)


    def mouse_move_valve(self, p):

        map_point = self.canvas.getCoordinateTransform().transform(p)
        x = map_point.x()
        y = map_point.y()
        eventPoint = QPoint(x, y)

        # Snapping
        (retval, result) = self.snapper.snapToCurrentLayer(eventPoint, 2)  # @UnusedVariable

        # That's the snapped point
        if result:
            # Check feature
            for snapped_point in result:
                viewname = self.controller.get_layer_source_table_name(snapped_point.layer)
                if viewname == 'v_anl_mincut_result_valve':
                    point = QgsPoint(snapped_point.snappedVertex)
                    # Add marker
                    self.vertex_marker.setCenter(point)
                    self.vertex_marker.show()
        else:
            self.vertex_marker.hide()


    def mouse_move_node_arc(self, p):
       
        viewname = "v_edit_arc"     
        self.layer_arc = self.controller.get_layer_by_tablename(viewname)
        if self.layer_arc:
            layername = self.layer_arc.name()
        else:
            self.controller.log_info("Layer not found", parameter=viewname)
            return
        
        # Set active layer
        self.iface.setActiveLayer(self.layer_arc)

        map_point = self.canvas.getCoordinateTransform().transform(p)
        x = map_point.x()
        y = map_point.y()
        event_point = QPoint(x, y)

        # Snapping
        (retval, result) = self.snapper.snapToCurrentLayer(event_point, 2)  # @UnusedVariable

        # That's the snapped point
        if result:
            # Check feature
            for snapped_point in result:              
                if snapped_point.layer.name() == layername:
                    point = QgsPoint(snapped_point.snappedVertex)
                    # Add marker
                    self.vertex_marker.setCenter(point)
                    self.vertex_marker.show()
        else:
            self.vertex_marker.hide()


    def custom_mincut_snapping(self, point, btn): # @UnusedVariable
        """ Custom mincut snapping function """
        
        map_point = self.canvas.getCoordinateTransform().transform(point)
        x = map_point.x()
        y = map_point.y()
        event_point = QPoint(x, y)

        # Snapping
        (retval, result) = self.snapper.snapToCurrentLayer(event_point, 2)   # @UnusedVariable

        # That's the snapped point
        if result:
            # Check feature
            for snapped_point in result:
                viewname = self.controller.get_layer_source_table_name(snapped_point.layer)
                if viewname == 'v_anl_mincut_result_valve':
                    # Get the point
                    snapp_feat = next(snapped_point.layer.getFeatures(QgsFeatureRequest().setFilterFid(snapped_point.snappedAtGeometry)))
                    # LEAVE SELECTION
                    snapped_point.layer.select([snapped_point.snappedAtGeometry])
                    element_id = snapp_feat.attribute('node_id')
                    self.custom_mincut_execute(element_id)


    def custom_mincut_execute(self, elem_id):
        """ Init function of custom mincut. Working just with layer Valve analytics """ 

        result_mincut_id = utils_giswater.getWidgetText("result_mincut_id")
        if result_mincut_id != 'null':
            sql = ("SELECT " + self.schema_name + ".gw_fct_mincut_valve_unaccess"
                   "('" + str(elem_id) + "', '" + str(result_mincut_id) + "');")
            status = self.controller.execute_sql(sql)
            if status:
                message = "Custom mincut executed successfully"
                self.controller.show_info(message)

        # Refresh map canvas
        self.canvas.refreshAllLayers()


    def remove_selection(self):
        """ Remove selected features of all layers """

        for layer in self.canvas.layers():
            layer.removeSelection()
        self.canvas.refresh()
        

    def mg_mincut_management(self):
        """ Button 27: Mincut management """

        self.action = "mg_mincut_management"
        self.mincut_config.mg_mincut_management()


    def load_mincut(self, result_mincut_id):
        """ Load selected mincut """
                
        self.btn_accept_main.clicked.connect(partial(self.accept_save_data))

        # Force fill form mincut
        self.result_mincut_id.setText(str(result_mincut_id))

        sql = ("SELECT * FROM " + self.schema_name + ".anl_mincut_result_cat"
               " WHERE id = '" + str(result_mincut_id) + "'")
        row = self.controller.get_row(sql)
        if not row:
            return
              
        self.work_order.setText(str(row['work_order']))
        state = str(row['mincut_state'])
        if state == '0':
            self.state.setText("Planified")
        elif state == '1':
            self.state.setText("In Progress")
        elif state == '2':
            self.state.setText("Finished")   

        utils_giswater.setWidgetText(self.dlg.address_exploitation, row['muni_name'])
        utils_giswater.setWidgetText(self.dlg.address_postal_code, row['postcode'])
        utils_giswater.setWidgetText(self.dlg.address_street, row['streetaxis_id'])
        utils_giswater.setWidgetText(self.dlg.address_number, row['postnumber'])

        utils_giswater.setWidgetText(self.dlg.type, row['mincut_type'])
        utils_giswater.setWidgetText(self.dlg.cause, row['anl_cause'])

        # Manage dates
        self.open_mincut_manage_dates(row)

        utils_giswater.setWidgetText("pred_description", row['anl_descript'])
        utils_giswater.setWidgetText("real_description", row['exec_descript'])
        utils_giswater.setWidgetText("distance", row['exec_from_plot'])
        utils_giswater.setWidgetText("depth", row['exec_depth'])
        utils_giswater.setWidgetText("assigned_to", str(row['assigned_to']))
                        
        # Update table 'anl_mincut_result_selector'
        self.update_result_selector(result_mincut_id)                      
                                
        # Depend of mincut_state and mincut_clase desable/enable widgets
        mincut_class_status = str(row['mincut_class'])        
        if mincut_class_status == '1':
            self.action_mincut.setDisabled(False)
            self.action_custom_mincut.setDisabled(False)
            self.action_add_connec.setDisabled(True)
            self.action_add_hydrometer.setDisabled(True)
        elif mincut_class_status == '2':
            self.action_mincut.setDisabled(True)
            self.action_custom_mincut.setDisabled(True)
            self.action_add_connec.setDisabled(False)
            self.action_add_hydrometer.setDisabled(True)
        elif mincut_class_status == '3':
            self.action_mincut.setDisabled(True)
            self.action_custom_mincut.setDisabled(True)
            self.action_add_connec.setDisabled(True)
            self.action_add_hydrometer.setDisabled(False)

        # Planified
        if state == '0':
            # Group Location
            self.dlg.address_exploitation.setDisabled(False)
            self.dlg.address_postal_code.setDisabled(False)
            self.dlg.address_street.setDisabled(False)
            self.dlg.address_number.setDisabled(False)
            # Group Details
            self.dlg.type.setDisabled(False)
            self.dlg.cause.setDisabled(False)
            self.dlg.cbx_recieved_day.setDisabled(False)
            self.dlg.cbx_recieved_time.setDisabled(False)
            # Group Prediction
            self.dlg.cbx_date_start_predict.setDisabled(False)
            self.dlg.cbx_hours_start_predict.setDisabled(False)
            self.dlg.cbx_date_end_predict.setDisabled(False)
            self.dlg.cbx_hours_end_predict.setDisabled(False)
            self.dlg.assigned_to.setDisabled(False)
            self.dlg.pred_description.setDisabled(False)
            # Group Real Details
            self.dlg.cbx_date_start.setDisabled(True)
            self.dlg.cbx_hours_start.setDisabled(True)
            self.dlg.cbx_date_end.setDisabled(True)
            self.dlg.cbx_hours_end.setDisabled(True)
            self.dlg.distance.setDisabled(True)
            self.dlg.depth.setDisabled(True)
            self.dlg.appropiate.setDisabled(True)
            self.dlg.real_description.setDisabled(True)
            self.dlg.btn_start.setDisabled(False)
            self.dlg.btn_end.setDisabled(True)
            
        # In Progess    
        elif state == '1':
            # Group Location            
            self.dlg.address_exploitation.setDisabled(True)
            self.dlg.address_postal_code.setDisabled(True)
            self.dlg.address_street.setDisabled(True)
            self.dlg.address_number.setDisabled(True)
            # Group Details
            self.dlg.type.setDisabled(True)
            self.dlg.cause.setDisabled(True)
            self.dlg.cbx_recieved_day.setDisabled(True)
            self.dlg.cbx_recieved_time.setDisabled(True)
            # Group Prediction
            self.dlg.cbx_date_start_predict.setDisabled(True)
            self.dlg.cbx_hours_start_predict.setDisabled(True)
            self.dlg.cbx_date_end_predict.setDisabled(True)
            self.dlg.cbx_hours_end_predict.setDisabled(True)
            self.dlg.assigned_to.setDisabled(True)
            self.dlg.pred_description.setDisabled(True)
            # Group Real Details
            self.dlg.cbx_date_start.setDisabled(False)
            self.dlg.cbx_hours_start.setDisabled(False)
            self.dlg.cbx_date_end.setDisabled(False)
            self.dlg.cbx_hours_end.setDisabled(False)
            self.dlg.distance.setDisabled(False)
            self.dlg.depth.setDisabled(False)
            self.dlg.appropiate.setDisabled(False)
            self.dlg.real_description.setDisabled(False)
            self.dlg.btn_start.setDisabled(True)
            self.dlg.btn_end.setDisabled(False)

        # Finished
        elif state == '2':
            # Group Location  
            self.dlg.address_exploitation.setDisabled(True)
            self.dlg.address_postal_code.setDisabled(True)
            self.dlg.address_street.setDisabled(True)
            self.dlg.address_number.setDisabled(True)
            # Group Details
            self.dlg.type.setDisabled(True)
            self.dlg.cause.setDisabled(True)
            self.dlg.cbx_recieved_day.setDisabled(True)
            self.dlg.cbx_recieved_time.setDisabled(True)
            # Group Prediction
            self.dlg.cbx_date_start_predict.setDisabled(True)
            self.dlg.cbx_hours_start_predict.setDisabled(True)
            self.dlg.cbx_date_end_predict.setDisabled(True)
            self.dlg.cbx_hours_end_predict.setDisabled(True)
            self.dlg.assigned_to.setDisabled(True)
            self.dlg.pred_description.setDisabled(True)
            # Group Real Details
            self.dlg.cbx_date_start.setDisabled(True)
            self.dlg.cbx_hours_start.setDisabled(True)
            self.dlg.cbx_date_end.setDisabled(True)
            self.dlg.cbx_hours_end.setDisabled(True)
            self.dlg.distance.setDisabled(True)
            self.dlg.depth.setDisabled(True)
            self.dlg.appropiate.setDisabled(True)
            self.dlg.real_description.setDisabled(True)
            self.dlg.btn_start.setDisabled(True)
            self.dlg.btn_end.setDisabled(True)

            self.dlg.work_order.setDisabled(True)
            self.action_mincut.setDisabled(True)
            self.action_custom_mincut.setDisabled(True)
            self.action_add_connec.setDisabled(True)
            self.action_add_hydrometer.setDisabled(True)

        
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
            utils_giswater.setCalendarDate(widget_date, qt_date) 
            utils_giswater.setTimeEdit(widget_time, qt_time)


    def searchplus_get_parameters(self):
        """ Get parameters of 'searchplus' from table 'config_param_system' """

        self.params = {}
        sql = "SELECT parameter, value FROM " + self.controller.schema_name + ".config_param_system"
        sql += " WHERE context = 'searchplus' ORDER BY parameter"
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
        sql = "SELECT value FROM " + self.schema_name + ".config_param_system"
        sql += " WHERE parameter = 'scale_zoom'"
        row = self.controller.get_row(sql)
        if row:
            self.scale_zoom = row['value']
            
        return True            


    def address_fill_postal_code(self, combo):
        """ Fill @combo """

        # Get exploitation code: 'expl_id'
        current_index = self.dlg.address_exploitation.currentIndex()     
        elem = self.dlg.address_exploitation.itemData(current_index)
        code = elem[0]

        # Get postcodes related with selected 'expl_id'
        sql = "SELECT DISTINCT(postcode) FROM " + self.controller.schema_name + ".ext_address"
        if code != -1:
            sql += " WHERE expl_id = '" + str(code) + "'"
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
            combo.addItem(str(record[1]), record)
            combo.blockSignals(False)

        return True


    def address_populate(self, combo, layername, field_code, field_name):
        """ Populate @combo """

        # Check if we have this search option available
        if layername not in self.layers:
            return False

        # Get features
        layer = self.layers[layername]
        records = [(-1, '', '')]
        idx_field_code = layer.fieldNameIndex(self.params[field_code])
        idx_field_name = layer.fieldNameIndex(self.params[field_name])

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
            field_expl_id = 'expl_id'
            elem = self.dlg.address_exploitation.itemData(self.dlg.address_exploitation.currentIndex())
            expl_id = elem[0]
            records = [[-1, '']]

            # Set filter expression
            expr_filter = field_expl_id + " = '" + str(expl_id) + "'"

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
            if not type(value_code) is QPyNullVariant and geom is not None:
                elem = [value_code, value_name, geom.exportToWkt()]
            else:
                elem = [value_code, value_name, None]
            records.append(elem)

        # Fill combo
        combo.blockSignals(True)
        combo.clear()
        records_sorted = sorted(records, key=operator.itemgetter(1))
        for record in records_sorted:
            combo.addItem(str(record[1]), record)
        combo.blockSignals(False)

        return True


    def address_get_numbers(self, combo, field_code, fill_combo=False):
        """ Populate civic numbers depending on value of selected @combo. 
            Build an expression with @field_code
        """      

        # Get selected street
        selected = utils_giswater.getWidgetText(combo)
        if selected == 'null':
            return

        # Get street code
        elem = combo.itemData(combo.currentIndex())
        code = elem[0]
        records = [[-1, '']]  
        
        # Get 'portal' layer
        if 'portal_layer' not in self.layers.keys():
            message = "Layer not found"
            self.controller.show_warning(message, parameter='portal_layer')
            return
        
        # Set filter expression
        layer = self.layers['portal_layer']        
        idx_field_code = layer.fieldNameIndex(field_code)        
        idx_field_number = layer.fieldNameIndex(self.params['portal_field_number'])        
        expr_filter = field_code + " = '" + str(code) + "'"
                
        # Check filter and existence of fields
        self.controller.log_info(str(expr_filter))         
        expr = QgsExpression(expr_filter)       
        if expr.hasParserError():
            message = expr.parserErrorString() + ": " + expr_filter
            self.controller.show_warning(message)
            return
        self.controller.log_info(str(idx_field_code))           
        if idx_field_code == -1:
            message = "Field not found"
            self.controller.show_warning(message, parameter=field_code)
            return
        self.controller.log_info(str(idx_field_number))            
        if idx_field_number == -1:
            message = "Field not found"
            self.controller.show_warning(message, parameter=self.params['portal_field_number'])
            return
        
        self.dlg.address_number.blockSignals(True)
        self.dlg.address_number.clear()
        if fill_combo:
            it = layer.getFeatures(QgsFeatureRequest(expr))
            for feature in it:
                attrs = feature.attributes()
                field_number = attrs[idx_field_number]
                if not type(field_number) is QPyNullVariant:
                    elem = [code, field_number]
                    records.append(elem)
        
            # Fill numbers combo
            records_sorted = sorted(records, key=operator.itemgetter(1))
            for record in records_sorted:
                self.dlg.address_number.addItem(str(record[1]), record)
            self.dlg.address_number.blockSignals(False)

        # Get a featureIterator from an expression:
        # Select featureswith the ids obtained
        self.controller.log_info(str(expr_filter))
        it = layer.getFeatures(QgsFeatureRequest(expr))
        ids = [i.id() for i in it]
        layer.selectByIds(ids)
        
        # Zoom to selected feature of the layer
        # self.zoom_to_selected_features(layer)


    def zoom_to_selected_features(self, layer):
        """ Zoom to selected features of the @layer """

        if not layer:
            return
        self.iface.setActiveLayer(layer)
        self.iface.actionZoomToSelected().trigger()
        scale = self.iface.mapCanvas().scale()
        if int(scale) < int(self.scale_zoom):
            self.iface.mapCanvas().zoomScale(float(self.scale_zoom))


    def adress_get_layers(self):
        """ Iterate over all layers to get the ones set in table 'config_param_system' """

        # Check if we have any layer loaded
        layers = self.iface.legendInterface().layers()
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


    def adress_init_config(self):
        """ Populate the interface with values get from layers """

        # Get layers and full extent
        self.adress_get_layers()
        
        # Tab 'Address'
        status = self.address_populate(self.dlg.address_exploitation, 'expl_layer', 'expl_field_code', 'expl_field_name')
        if not status:
            return

        # Get project variable 'expl_id'
        expl_id = QgsExpressionContextUtils.projectScope().variable('expl_id')
        if expl_id:
            # Set SQL to get 'expl_name'
            sql = ("SELECT " + self.params['expl_field_name'] + ""
                   " FROM " + self.controller.schema_name + "." + self.params['expl_layer'] + ""
                   " WHERE " + self.params['expl_field_code'] + " = " + str(expl_id))
            row = self.controller.get_row(sql, log_sql=True)
            if row:
                utils_giswater.setSelectedItem(self.dlg.address_exploitation, row[0])
                    
