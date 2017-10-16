'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtCore import QPoint, Qt, SIGNAL, QDate, QTime
from PyQt4.QtGui import QLineEdit, QTableView, QMenu, QPushButton, QComboBox, QTextEdit, QDateEdit, QTimeEdit, QAction, QStringListModel, QCompleter, QColor
from PyQt4.QtSql import QSqlTableModel
from qgis.core import QgsMapLayerRegistry, QgsFeatureRequest, QgsExpression, QgsPoint
from qgis.gui import QgsMapToolEmitPoint, QgsMapCanvasSnapper, QgsVertexMarker

import os
import sys
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater
from parent import ParentAction

from multiple_snapping import MultipleSnapping                  # @UnresolvedImport  
from ..ui.mincut import Mincut                                  # @UnresolvedImport  
from ..ui.mincut_fin import Mincut_fin                          # @UnresolvedImport  
from ..ui.multi_selector import Multi_selector                  # @UnresolvedImport  
from ..ui.mincut_add_hydrometer import Mincut_add_hydrometer    # @UnresolvedImport  
from ..ui.mincut_add_connec import Mincut_add_connec            # @UnresolvedImport  
from ..ui.mincut_edit import Mincut_edit                        # @UnresolvedImport

from datetime import datetime


class MincutParent(ParentAction, MultipleSnapping):
    
    def __init__(self, iface, settings, controller, plugin_dir):
        ''' Class to control Management toolbar actions '''

        # Call ParentAction constructor
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.canvas = self.iface.mapCanvas()

        # Get layers of node,arc,connec groupe
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
        ''' Custom form initial configuration '''

        # Create the appropriate map tool and connect the gotPoint() signal.
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.snapper = QgsMapCanvasSnapper(self.canvas)

        # Refresh canvas, remove all old selections
        self.remove_selection()

        self.dlg = Mincut()
        utils_giswater.setDialog(self.dlg)
        self.dlg.setWindowFlags(Qt.WindowStaysOnTopHint)

        # TODO: parametrize list of layers
        self.group_pointers_connec = []
        self.group_layers_connec = ["Wjoin", "Tap" , "Fountain", "Greentap"]
        for layername in self.group_layers_connec:
            layer = QgsMapLayerRegistry.instance().mapLayersByName(layername)
            if layer:
                self.group_pointers_connec.append(layer[0])            

        self.group_pointers_node = []
        self.group_layers_node = ["Junction", "Valve", "Reduction", "Tank", "Meter", "Manhole", "Source", "Hydrant", "Pump", "Filter", "Waterwell", "Register", "Netwjoin"]
        for layername in self.group_layers_node:
            layer = QgsMapLayerRegistry.instance().mapLayersByName(layername)
            if layer:
                self.group_pointers_node.append(layer[0])
                
        self.group_layers_arc = ["Pipe", "Varc"]

        # Control current layer (due to QGIS bug in snapping system)
        if self.canvas.currentLayer() is None:
            self.iface.setActiveLayer(self.group_pointers_node[0])

        self.state = self.dlg.findChild(QLineEdit, "state")
        self.result_mincut_id = self.dlg.findChild(QLineEdit, "result_mincut_id")
        self.customer_state = self.dlg.findChild(QLineEdit, "customer_state")
        self.work_order = self.dlg.findChild(QLineEdit, "work_order")
        self.street = self.dlg.findChild(QLineEdit, "street")
        self.number = self.dlg.findChild(QLineEdit, "number")
        self.pred_description = self.dlg.findChild(QTextEdit, "pred_description")
        self.real_description = self.dlg.findChild(QTextEdit, "real_description")
        self.distance = self.dlg.findChild(QLineEdit, "distance")
        self.depth = self.dlg.findChild(QLineEdit, "depth")

        self.exploitation = self.dlg.findChild(QComboBox, "exploitation")
        self.type = self.dlg.findChild(QComboBox, "type")
        self.cause = self.dlg.findChild(QComboBox, "cause")

        # Btn_close and btn_accept
        self.btn_accept_main = self.dlg.findChild(QPushButton, "btn_accept")
        self.btn_cancel_main = self.dlg.findChild(QPushButton, "btn_cancel")
        self.btn_cancel_main.clicked.connect(self.mincut_close)

        #self.btn_accept_main.clicked.connect(partial(self.accept_save_data))
        #self.btn_cancel_main.clicked.connect(self.dlg.close)

        # Get status 'planified' (id = 0)
        sql = "SELECT name FROM " + self.schema_name + ".anl_mincut_cat_state WHERE id = 0"
        row = self.controller.get_row(sql)
        if row:
            self.state.setText(str(row[0]))

        # Fill ComboBox type
        sql = "SELECT id"
        sql += " FROM " + self.schema_name + ".anl_mincut_cat_type"
        sql += " ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("type", rows, False)

        # Fill ComboBox cause
        sql = "SELECT id"
        sql += " FROM " + self.schema_name + ".anl_mincut_cat_cause"
        sql += " ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("cause", rows, False)

        # Fill ComboBox assigned_to
        self.assigned_to = self.dlg.findChild(QComboBox, "assigned_to")
        sql = "SELECT name"
        sql += " FROM " + self.schema_name + ".cat_users"
        sql += " ORDER BY id"
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

        self.cbx_date_start_predict_2 = self.dlg.findChild(QDateEdit, "cbx_date_start_predict_2")

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
        action.triggered.connect(self.config)
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

        # Move dialog to the left side of the screen
        self.dlg.move(0, 300)
        self.dlg.show()


    def mg_mincut(self):
        ''' Button 26: New Mincut '''

        self.init_mincut_form()

        self.action = "mg_mincut"

        self.btn_accept_main.clicked.connect(partial(self.accept_save_data))

        self.dlg.work_order.textChanged.connect(self.activate_actions_mincut)

        # Get current date
        date_start = QDate.currentDate()

        # Set all QDateEdit to current date
        self.cbx_date_start.setDate(date_start)
        self.cbx_date_end.setDate(date_start)

        # Widgets for predict date
        self.cbx_date_start_predict.setDate(date_start)
        self.cbx_date_start_predict_2.setDate(date_start)

        # Widgets for real date
        self.cbx_date_end_predict.setDate(date_start)

        # Btn_end and btn_start
        self.btn_start.clicked.connect(self.real_start)

        self.btn_end.clicked.connect(self.real_end)

        self.dlg.show()


    def mincut_close(self):

        # If id exists in data base on btn_cancel delete
        if self.action == "mg_mincut":
            result_mincut_id = self.dlg.result_mincut_id.text()
            sql = "SELECT id FROM "+self.schema_name+".anl_mincut_result_cat WHERE id = " + str(result_mincut_id)
            row = self.controller.get_row(sql)
            if row:
                sql = "DELETE FROM " + self.schema_name + ".anl_mincut_result_cat WHERE id = " + str(result_mincut_id)
                self.controller.execute_sql(sql)
                self.controller.show_info("Mincut canceled!")                   
        
        self.dlg.close()


    def activate_actions_mincut(self):

        if self.dlg.work_order.text() != '':

            # On inserting work order
            self.action_mincut.setDisabled(False)
            self.action_add_connec.setDisabled(False)
            self.action_add_hydrometer.setDisabled(False)

            self.dlg.exploitation.setDisabled(False)
            self.dlg.postcode.setDisabled(False)
            self.dlg.street.setDisabled(False)
            self.dlg.number.setDisabled(False)
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
            #self.dlg.cbx_date_start.setDisabled(False)
            #self.dlg.cbx_hours_start.setDisabled(False)
            #self.dlg.cbx_date_end.setDisabled(False)
            #self.dlg.cbx_hours_end.setDisabled(False)
            #self.dlg.distance.setDisabled(False)
            #self.dlg.depth.setDisabled(False)
            #self.dlg.appropiate.setDisabled(False)
            #self.dlg.real_description.setDisabled(False)
            #self.dlg.btn_start.setDisabled(False)
        if self.dlg.work_order.text() == '':
            # If work order is empty
            self.action_mincut.setDisabled(True)
            self.action_add_connec.setDisabled(True)
            self.action_add_hydrometer.setDisabled(True)

            self.dlg.exploitation.setDisabled(True)
            self.dlg.postcode.setDisabled(True)
            self.dlg.street.setDisabled(True)
            self.dlg.number.setDisabled(True)
            self.dlg.type.setDisabled(True)
            self.dlg.cause.setDisabled(True)
            self.dlg.cbx_date_start_predict_2.setDisabled(True)
            self.dlg.cbx_hours_start_predict_2.setDisabled(True)
            self.dlg.cbx_date_start_predict.setDisabled(True)
            self.dlg.cbx_hours_start_predict.setDisabled(True)
            self.dlg.cbx_date_end_predict.setDisabled(True)
            self.dlg.cbx_hours_end_predict.setDisabled(True)
            self.dlg.assigned_to.setDisabled(True)
            self.dlg.pred_description.setDisabled(True)


    def activate_actions_custom_mincut(self):

        # On inserting work order
        self.action_mincut.setDisabled(False)
        self.action_custom_mincut.setDisabled(True)
        self.action_add_connec.setDisabled(False)
        self.action_add_hydrometer.setDisabled(False)

        self.dlg.exploitation.setDisabled(False)
        self.dlg.postcode.setDisabled(False)
        self.dlg.street.setDisabled(False)
        self.dlg.number.setDisabled(False)
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
        #self.btn_end.setDisabled(False)
        self.dlg.btn_end.setEnabled(True)


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
        self.dlg.exploitation.setDisabled(True)
        self.dlg.postcode.setDisabled(True)
        self.dlg.street.setDisabled(True)
        self.dlg.number.setDisabled(True)
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
        sql += " SET mincut_state = 1 , exec_start = '" + str(forecast_start_real) + "' "
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
        self.street_fin = self.dlg_fin.findChild(QLineEdit, "street")
        self.number_fin = self.dlg_fin.findChild(QLineEdit, "number")
        self.btn_set_real_location = self.dlg_fin.findChild(QPushButton, "btn_set_real_location")
        self.btn_set_real_location.clicked.connect(self.set_real_location)

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
        self.btn_accept = self.dlg_fin.findChild(QPushButton, "btn_accept")
        self.btn_cancel = self.dlg_fin.findChild(QPushButton, "btn_cancel")

        self.btn_set_real_location = self.dlg_fin.findChild(QPushButton, "btn_set_real_location")

        self.btn_accept.clicked.connect(self.accept)
        self.btn_cancel.clicked.connect(self.dlg_fin.close)

        # Set values mincut and address
        utils_giswater.setText("mincut", str(self.result_mincut_id.text()))
        utils_giswater.setText("street", str(self.street.text()))
        utils_giswater.setText("number", str(self.number.text()))
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

        self.dlg_fin.setWindowFlags(Qt.WindowStaysOnTopHint)
        # Open the dialog
        self.dlg_fin.show()


    def set_real_location(self):

        # Activatre snapping of node and arcs
        self.canvas.connect(self.canvas, SIGNAL("xyCoordinates(const QgsPoint&)"), self.mouse_move_node_arc)

        #self.emit_point.canvasClicked.disconnect(self.snapping_node_arc)

        self.emit_point.canvasClicked.connect(self.snapping_node_arc_real_location)


    def accept_save_data(self):

        # Check if user entered ID
        check = self.check_id()
        if check == 0:
            return
        else:
            pass

        mincut_result_state_text = self.state.text()
        if mincut_result_state_text == 'Planified':
            mincut_result_state = int(0)
        if mincut_result_state_text == 'In Progress':
            mincut_result_state = int(1)
        if mincut_result_state_text == 'Finished':
            mincut_result_state = int(2)

        result_mincut_id = self.result_mincut_id.text()
        # exploitation =
        street = str(self.street.text())
        number = str(self.number.text())
        mincut_result_type = self.type.currentText()
        anl_cause = self.cause.currentText()
        work_order = self.work_order.text()

        # anl_descript = str(utils_giswater.getWidgetText("pred_description"))
        anl_descript = self.pred_description.toPlainText()

        exec_limit_distance = str(self.distance.text())
        exec_depth = str(self.depth.text())

        # exec_descript =  str(utils_giswater.getWidgetText("real_description"))
        exec_descript = self.real_description.toPlainText()
        # Get prediction date - start
        dateStart_predict = self.cbx_date_start_predict.date()
        timeStart_predict = self.cbx_hours_start_predict.time()
        forecast_start_predict = dateStart_predict.toString('yyyy-MM-dd') + " " + timeStart_predict.toString('HH:mm:ss')

        # Get prediction date - end
        dateEnd_predict = self.cbx_date_end_predict.date()
        timeEnd_predict = self.cbx_hours_end_predict.time()
        forecast_end_predict = dateEnd_predict.toString('yyyy-MM-dd') + " " + timeEnd_predict.toString('HH:mm:ss')

        # Get real date - start
        dateStart_real = self.cbx_date_start.date()
        timeStart_real = self.cbx_hours_start.time()
        forecast_start_real = dateStart_real.toString('yyyy-MM-dd') + " " + timeStart_real.toString('HH:mm:ss')

        # Get real date - end
        dateEnd_real = self.cbx_date_end.date()
        timeEnd_real = self.cbx_hours_end.time()
        forecast_end_real = dateEnd_real.toString('yyyy-MM-dd') + " " + timeEnd_real.toString('HH:mm:ss')

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
                message = "Review your data!"
                self.controller.show_warning(message)
                return

        check_data_exec = [str(forecast_start_real), str(forecast_end_real), str(exec_limit_distance), str(exec_depth),str(cur_user)]
        # Check if id exist in .anl_mincut_result_cat
        sql = "SELECT id FROM " + self.schema_name + ".anl_mincut_result_cat WHERE id = '" + str(result_mincut_id) + "'"
        rows = self.controller.get_rows(sql)

        # Before of executing .gw_fct_mincut we already need to have id in .anl_mincut_result_cat
        if not rows:
            sql = "INSERT INTO " + self.schema_name + ".anl_mincut_result_cat (id) "
            sql += " VALUES ('" + str(result_mincut_id) + "')"
            self.controller.execute_sql(sql)

        sql = "UPDATE " + self.schema_name + ".anl_mincut_result_cat "
        sql += " SET  mincut_state = '" + str(mincut_result_state) + "', work_order = '" + str(work_order) + "', number = '" + str(number) + "', streetname = '" + str(street) + "', mincut_type = '" + str(mincut_result_type) + "', anl_cause = '" + str(anl_cause) + \
               "', anl_tstamp = '" + str(received_date) +"', received_date = '" + str(received_date) +"', forecast_start = '" + str(forecast_start_predict) + "', forecast_end = '" + str(forecast_end_predict) + "', anl_descript = '" + str(anl_descript) + \
               "', assigned_to = '" + str(assigned_to) + "', exec_appropiate = '" + str(appropiate_status) + "'"

        if self.btn_end.isEnabled():
            sql += ", exec_start = '" + str(forecast_start_real) +  "', exec_end = '" + str(forecast_end_real) + "', exec_from_plot = '" + str(exec_limit_distance) + "', exec_depth = '" + str(exec_depth) + "', exec_descript = '" + str(exec_descript) + "', exec_user = '" + str(cur_user) + "'"
            #       "',exec_the_geom = ST_SetSRID(ST_Point(" + str(self.real_snapping_position.x()) + ", " + str(self.real_snapping_position.y()) + ")," + str(srid) + "), exec_user = '" + str(cur_user) + "'"
            for data in check_data_exec:
                if data == '':
                    message = "Review your data!"
                    self.controller.show_warning(message)
                    return
        sql += " WHERE id = '" + str(result_mincut_id) + "'"
        status = self.controller.execute_sql(sql)
        if status:
            message = "Values has been updated"
            self.controller.show_info(message)
        if not status:
            message = "Error updating element in table, you need to review data"
            self.controller.show_warning(message)
            return

        self.dlg.close()


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
        self.street.setText(str(self.street_fin.text()))
        self.number.setText(str(self.number_fin.text()))

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

        self.ids = []

        # Check if user entered ID
        check = self.check_id()
        if check == 0:
            return

        result_mincut_id_text = self.dlg.result_mincut_id.text()
        work_order = self.dlg.work_order.text()

        # Check if id exist in .anl_mincut_result_cat
        sql = "SELECT id FROM " + self.schema_name + ".anl_mincut_result_cat WHERE id = '" + str(result_mincut_id_text) + "'"
        exist_id = self.controller.get_rows(sql)

        # Before of updating table anl_mincut_result_cat we already need to have id in anl_mincut_result_cat
        if exist_id == []:
            sql = "INSERT INTO " + self.schema_name + ".anl_mincut_result_cat (id, work_order) "
            sql += " VALUES ('" + str(result_mincut_id_text) + "','" + str(work_order) + "')"
            self.controller.execute_sql(sql)

        # Update table anl_mincut_result_cat, set mincut_class = 2
        sql = "UPDATE " + self.schema_name + ".anl_mincut_result_cat "
        sql += " SET mincut_class = 2"
        sql += " WHERE id = '" + str(result_mincut_id_text) + "'"
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

        table = "connec"
        self.tbl_connec = self.dlg_connec.findChild(QTableView, "tbl_mincut_connec")

        btn_delete_connec = self.dlg_connec.findChild(QPushButton, "btn_delete")
        btn_delete_connec.pressed.connect(partial(self.delete_records, self.tbl_connec, table, "connec_id"))
        self.set_icon(btn_delete_connec, "112")

        btn_insert_connec = self.dlg_connec.findChild(QPushButton, "btn_insert")
        btn_insert_connec.pressed.connect(partial(self.manual_init, self.tbl_connec, table, "connec_id", self.dlg_connec, self.group_pointers_connec))
        self.set_icon(btn_insert_connec, "111")

        btn_insert_connec_snap = self.dlg_connec.findChild(QPushButton, "btn_snapping")
        btn_insert_connec_snap.pressed.connect(self.snapping_init)
        self.set_icon(btn_insert_connec_snap, "129")

        btn_accept = self.dlg_connec.findChild(QPushButton, "btn_accept")
        btn_accept.pressed.connect(partial(self.exec_sql, "connec",self.dlg_connec))

        btn_cancel = self.dlg_connec.findChild(QPushButton, "btn_cancel")
        btn_cancel.pressed.connect(self.dlg_connec.close)

        self.connec = self.dlg_connec.findChild(QLineEdit, "connec_id")
        # Adding auto-completion to a QLineEdit
        self.completer = QCompleter()
        self.connec.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(customer_code) FROM " + self.schema_name + ".connec "
        rows = self.controller.get_rows(sql)
        values = []
        if rows:
            for row in rows:
                values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)

        # Set signal to reach selected value from QCompleter
        # self.completer.activated.connect(self.autocomplete)

        # On opening form check if result_id already exist in anl_mincut_result_connec
        # if exist show data in form / show selection!!!
        if exist_id != []:
            # Read selection and reload table
            self.show_data_add_element(self.group_pointers_connec, "connec")

        # self.fill_table(self.tbl, self.schema_name+"."+table)
        self.dlg_connec.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_connec.show()


    def snapping_init(self):
        ''' Snap connec '''

        self.tool = MultipleSnapping(self.iface, self.settings, self.controller, self.plugin_dir,self.group_layers_connec)
        self.canvas.setMapTool(self.tool)
        self.canvas.selectionChanged.connect(partial(self.snapping_selection,self.group_pointers_connec,"connec_id","connec"))


    def snapping_init_hydro(self):
        ''' Snap connec '''

        self.tool = MultipleSnapping(self.iface, self.settings, self.controller, self.plugin_dir,self.group_layers_connec)
        self.canvas.setMapTool(self.tool)
        self.canvas.selectionChanged.connect(partial(self.snapping_selection_hydro,self.group_pointers_connec,"connec_id","rtc_hydrometer_x_connec"))


    def snapping_selection_hydro(self, group_pointers, attribute, table):

        self.hydrometer_id = ''
        self.ids = []
        for layer in group_pointers:
            if layer.selectedFeatureCount() > 0:

                # Get all selected features at layer
                features = layer.selectedFeatures()
                # Get id from all selected features
                for feature in features:
                    element_id = feature.attribute(attribute)

                    # Add element
                    if element_id in self.ids:
                        message = " Feature :" + element_id + " id already in the list!"
                        self.controller.show_info_box(message)
                        return
                    else:
                        self.ids.append(element_id)

        self.reload_table_hydro(table, attribute)


    def snapping_selection(self, group_pointers,attribute,table):

        self.ids = []

        for layer in group_pointers:

            if layer.selectedFeatureCount() > 0:

                # Get all selected features at layer
                features = layer.selectedFeatures()
                # Get id from all selected features
                for feature in features:
                    element_id = feature.attribute(attribute)

                    # Add element
                    if element_id in self.ids:
                        message = " Feature :" + element_id + " id already in the list!"
                        self.controller.show_info_box(message)
                        return
                    else:
                        self.ids.append(element_id)

        self.reload_table(table, attribute)


    def check_id(self):
        ''' Check if user entered ID '''

        customer_state = self.work_order.text()
        if customer_state == "":
            message = "You need to enter work order"
            self.controller.show_info_box(message)
            return 0
        else:
            return 1


    def add_hydrometer(self):
        ''' B4-122: Hydrometer selector '''

        self.ids = []

        # Check if user entered ID
        check = self.check_id()
        if check == 0:
            return

        result_mincut_id_text = self.dlg.result_mincut_id.text()
        work_order = self.dlg.work_order.text()

        # Check if id exist in .anl_mincut_result_cat
        sql = "SELECT id FROM " + self.schema_name + ".anl_mincut_result_cat WHERE id = '" + str(result_mincut_id_text) + "'"
        exist_id = self.controller.get_rows(sql)

        # Before of updating table anl_mincut_result_cat we already need to have id in .anl_mincut_result_cat
        if exist_id == []:
            sql = "INSERT INTO " + self.schema_name + ".anl_mincut_result_cat (id, work_order) "
            sql += " VALUES ('" + str(result_mincut_id_text) + "','" + str(work_order) + "')"
            self.controller.execute_sql(sql)

        # Update table anl_mincut_result_cat, set mincut_class = 2
        sql = "UPDATE " + self.schema_name + ".anl_mincut_result_cat "
        sql += " SET mincut_class = 3"
        sql += " WHERE id = '" + str(result_mincut_id_text) + "'"
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

        table = "rtc_hydrometer_x_connec"

        self.tbl_hydro = self.dlg_hydro.findChild(QTableView, "tbl_hydro")

        self.btn_delete_hydro = self.dlg_hydro.findChild(QPushButton, "btn_delete")
        self.btn_delete_hydro.pressed.connect(partial(self.delete_records, self.tbl_hydro, table, "connec_id"))

        self.btn_insert_hydro = self.dlg_hydro.findChild(QPushButton, "btn_insert")
        self.btn_insert_hydro.pressed.connect(partial(self.manual_init_hydro, self.tbl_hydro, table, "hydrometer_id", self.dlg_hydro, self.group_pointers_connec))
        self.set_icon(self.btn_insert_hydro, "111")

        btn_snapping_hydro = self.dlg_hydro.findChild(QPushButton, "btn_snapping")
        btn_snapping_hydro.pressed.connect(self.snapping_init_hydro)
        self.set_icon(btn_snapping_hydro, "129")

        self.btn_accept = self.dlg_hydro.findChild(QPushButton, "btn_accept")
        self.btn_accept.pressed.connect(partial(self.exec_sql, "hydrometer", self.dlg_hydro))

        # Adding auto-completion to a QLineEdit - customer_code_connec
        self.completer = QCompleter()
        self.customer_code_connec_hydro = self.dlg_hydro.findChild(QLineEdit, "customer_code_connec")
        self.customer_code_connec_hydro.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(customer_code) FROM " + self.schema_name + ".connec "
        rows = self.controller.get_rows(sql)
        values = []
        for row in rows:
            values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)

        #self.customer_code_connec_hydro.textChanged.connect(self.auto_fill_hydro_id)
        self.completer.activated.connect(self.auto_fill_hydro_id)

        # Set signal to reach selected value from QCompleter
        # self.completer.activated.connect(self.autocomplete)
        if exist_id != []:
            # Read selection and reload table
            self.show_data_add_element_hydro(self.group_pointers_connec, "rtc_hydrometer_x_connec")

        self.dlg_hydro.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_hydro.show()


    def auto_fill_hydro_id(self):

        # Adding auto-completion to a QLineEdit - hydrometer_id
        self.completer_hydro = QCompleter()
        widget_hydrometer_id = self.dlg_hydro.findChild(QLineEdit, "hydrometer_id")
        widget_hydrometer_id.setCompleter(self.completer_hydro)
        model = QStringListModel()

        # If selected customer_code fill hydrometer_id
        selected_customer_code = str(self.customer_code_connec_hydro.text())

        # TODO
        sql = "SELECT connec_id FROM " + self.schema_name + ".connec WHERE customer_code = '"+ str(selected_customer_code) + "'"
        row = self.controller.get_row(sql)
        connec_id = str(row[0])

        sql = "SELECT DISTINCT(hydrometer_id) FROM " + self.schema_name + ".rtc_hydrometer_x_connec WHERE connec_id = '"+ str(connec_id) + "'"
        rows = self.controller.get_rows(sql)
        values = []
        for row in rows:
            values.append(str(row[0]))

        model.setStringList(values)
        self.completer_hydro.setModel(model)


    def manual_init_hydro(self, widget, table, attribute, dialog, group_pointers):
        """ Select feature with entered id
            Set a model with selected filter. Attach that model to selected table """

        self.hydrometer_id = utils_giswater.getWidgetText("hydrometer_id")        
        
        # Clear list of ids
        self.ids = []
        customer_code_text = utils_giswater.getWidgetText("customer_code_connec")
        self.controller.log_info(str(self.ids))        

        sql = "SELECT connec_id FROM " + self.schema_name + ".connec"
        sql += " WHERE customer_code = '" + str(customer_code_text) + "'"
        row = self.controller.get_row(sql)
        if not row:
            return
        
        connec_id = str(row[0])
        element_id = ""
        if self.hydrometer_id == 'null':
            element_id = connec_id
        else:
            sql = "SELECT connec_id FROM " + self.schema_name + ".rtc_hydrometer_x_connec"
            sql += " WHERE hydrometer_id = '" + str(self.hydrometer_id) + "' "
            row = self.controller.get_row(sql)
            if row:
                connec_id = str(row[0])
                element_id = connec_id

        # Get all selected features
        for layer in group_pointers:
            if layer.selectedFeatureCount() > 0:
                # Get all selected features at layer
                features = layer.selectedFeatures()
                # Get id from all selected features
                for feature in features:
                    feature_id = feature.attribute("connec_id")
                    # List of all selected features
                    self.ids.append(str(feature_id))

        # Check if user entered hydrometer_id
        if element_id == "":
            message = "You need to enter id"
            self.controller.show_info_box(message)
            return
        
        if element_id in self.ids:
            message = str(attribute)+ ": " + element_id + " id already in the list!"
            self.controller.show_info_box(message)
            return
        
        # If feature id doesn't exist in list -> add
        self.ids.append(element_id)
        for layer in group_pointers:
            # SELECT features which are in the list
            if self.hydrometer_id != 'null':
                aux = "\"connec_id\" = "
                for i in range(len(self.ids)):
                    aux += "'" +str(self.ids[i]) + "' AND \"hydrometer_id\" = '" + str(self.hydrometer_id) + "'"
                    
            else:           
                aux = "\"connec_id\" IN ("
                for i in range(len(self.ids)):
                    aux += "'" + str(self.ids[i]) + "', "
                aux = aux[:-2] + ")"

            self.controller.log_info(str(aux))
            expr = QgsExpression(aux)
            if expr.hasParserError():
                message = "Expression Error: " + str(expr.parserErrorString())
                self.controller.show_warning(message)
                return

            it = layer.getFeatures(QgsFeatureRequest(expr))

            # Build a list of feature id's from the previous result
            id_list = [i.id() for i in it]

            # Select features with these id's
            layer.setSelectedFeatures(id_list)

        # Reload table
        self.reload_table_hydro(table, attribute)


    def show_data_add_element(self, group_pointers, table):
        
        self.ids = []

        if self.action == "mg_mincut":
            # Get all selected features
            for layer in group_pointers:
                if layer.selectedFeatureCount() > 0:
                    # Get all selected features at layer
                    features = layer.selectedFeatures()
                    # Get id from all selected features
                    for feature in features:
                        feature_id = feature.attribute("connec_id")
                        # List of all selected features
                        self.ids.append(str(feature_id))

            # Reload table
            self.reload_table( table, "connec_id")


    def show_data_add_element_hydro(self, group_pointers, table):
        
        self.ids = []

        if self.action == "mg_mincut":
            # Get all selected features
            for layer in group_pointers:
                if layer.selectedFeatureCount() > 0:

                    # Get all selected features at layer
                    features = layer.selectedFeatures()
                    # Get id from all selected features
                    for feature in features:
                        feature_id = feature.attribute("connec_id")
                        # List of all selected features
                        self.ids.append(str(feature_id))

                # Reload table
                self.reload_table_hydro(table, "connec_id")


    def manual_init(self, widget, table, attribute, dialog, group_pointers) :
        '''  Select feature with entered id
        Set a model with selected filter.
        Attach that model to selected table '''

        widget_id = dialog.findChild(QLineEdit, attribute)
        #element_id = widget_id.text()
        customer_code = widget_id.text()
        # Clear list of ids
        self.ids = []

        # Attribute = "connec_id"
        sql = "SELECT " + attribute + " FROM " + self.schema_name + "." + table
        sql += " WHERE customer_code = '" + customer_code + "'"
        rows = self.controller.get_rows(sql)
        if not rows:
            return
        element_id = str(rows[0][0])

        # Get all selected features
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
            message = str(attribute) + ": " + element_id + " id already in the list!"
            self.controller.show_info_box(message)
            return
        else:
            # If feature id doesn't exist in list -> add
            self.ids.append(element_id)

            for layer in group_pointers:
                # SELECT features which are in the list
                aux = "\"connec_id\" IN ("
                for i in range(len(self.ids)):
                    aux += "'" + str(self.ids[i]) + "', "
                aux = aux[:-2] + ")"

                expr = QgsExpression(aux)
                if expr.hasParserError():
                    message = "Expression Error: " + str(expr.parserErrorString())
                    self.controller.show_warning(message)
                    return

                it = layer.getFeatures(QgsFeatureRequest(expr))

                # Build a list of feature id's from the previous result
                id_list = [i.id() for i in it]

                # Select features with these id's
                layer.setSelectedFeatures(id_list)

        self.reload_table(table,attribute)


    def reload_table(self, table, attribute):

        table_name = self.schema_name + "." + table
        widget = self.tbl_connec
        expr = attribute +"= '" + self.ids[0] + "'"
        if len(self.ids) > 1:
            for el in range(1, len(self.ids)):
                expr += " OR " + attribute + " = '" + self.ids[el] + "'"

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
        widget.model().select()


    def reload_table_hydro(self, table, attribute):

        # Reload table
        table = "rtc_hydrometer_x_connec"
        table_name = self.schema_name + "." + table
        widget = self.tbl_hydro

        if self.hydrometer_id == 'null':
            expr = "connec_id = '" + self.ids[0] + "'"
            if len(self.ids) > 1:
                for el in range(1, len(self.ids)):
                    expr += " OR connec_id = '" + self.ids[el] + "'"

        else:
            expr = "connec_id = '" + self.ids[0] + "' AND hydrometer_id = '" + str(self.hydrometer_id) + "'"

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
        widget.model().select()


    def config(self):
        ''' B5-99: Config '''

        # Dialog multi_selector
        self.dlg_multi = Multi_selector()
        utils_giswater.setDialog(self.dlg_multi)

        self.tbl_config = self.dlg_multi.findChild(QTableView, "tbl")
        self.btn_insert = self.dlg_multi.findChild(QPushButton, "btn_insert")
        self.btn_delete = self.dlg_multi.findChild(QPushButton, "btn_delete")

        table = "anl_mincut_selector_valve"
        self.menu_valve = QMenu()
        self.dlg_multi.btn_insert.pressed.connect(partial(self.fill_insert_menu, table))

        btn_cancel = self.dlg_multi.findChild(QPushButton, "btn_cancel")
        btn_cancel.pressed.connect(self.dlg_multi.close)

        self.menu_valve.clear()
        self.dlg_multi.btn_insert.setMenu(self.menu_valve)
        self.dlg_multi.btn_delete.pressed.connect(partial(self.delete_records_config, self.tbl_config, table))

        self.fill_table_config(self.tbl_config, self.schema_name + "." + table)

        # Open form
        self.dlg_multi.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_multi.open()


    def fill_insert_menu(self, table):
        ''' Insert menu on QPushButton->QMenu'''
        
        self.menu_valve.clear()
        node_type = "VALVE"
        sql = "SELECT id FROM " + self.schema_name + ".node_type WHERE type = '" + node_type + "'"
        sql += " ORDER BY id"
        rows = self.controller.get_rows(sql)
        if not rows:
            return
        
        # Fill menu
        for row in rows:
            elem = row[0]
            # If not exist in table _selector_state insert to menu
            # Check if we already have data with selected id
            sql = "SELECT id FROM " + self.schema_name + "." + table + " WHERE id = '" + elem + "'"
            rows = self.controller.get_rows(sql)
            if not rows:
                self.menu_valve.addAction(elem, partial(self.insert, elem, table))


    def insert(self, id_action, table):
        ''' On action(select value from menu) execute SQL '''

        # Insert value into database
        sql = "INSERT INTO "+self.schema_name+"."+table+" (id) "
        sql+= " VALUES ('"+id_action+"')"
        self.controller.execute_sql(sql)

        self.fill_table_config(self.tbl_config, self.schema_name+"."+table)


    def fill_table_config(self, widget, table_name):
        ''' Set a model with selected filter.
        Attach that model to selected table 
        '''

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


    def delete_records(self, widget, table_name, id_):  
        ''' Delete selected elements of the table '''

        # Get selected rows
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
            id_feature = widget.model().record(row).value(id_)
            inf_text += str(id_feature) + ", "
            list_id = list_id + "'" + str(id_feature) + "', "
            del_id.append(id_feature)
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        answer = self.controller.ask_question("Are you sure you want to delete these records?", "Delete records", inf_text)
        if answer:
            for el in del_id:
                self.ids.remove(el)

        # Reload selection
        #layer = self.iface.activeLayer()
        for layer in self.group_pointers_connec:
            # SELECT features which are in the list
            aux = "\"connec_id\" IN ("
            for i in range(len(self.ids)):
                aux += "'" + str(self.ids[i]) + "', "
            aux = aux[:-2] + ")"

            expr = QgsExpression(aux)
            if expr.hasParserError():
                message = "Expression Error: " + str(expr.parserErrorString())
                self.controller.show_warning(message)
                return
            it = layer.getFeatures(QgsFeatureRequest(expr))

            # Build a list of feature id's from the previous result
            id_list = [i.id() for i in it]

            # Select features with these id's
            layer.setSelectedFeatures(id_list)

        # Reload table
        expr = str(id_)+" = '" + self.ids[0] + "'"
        if len(self.ids) > 1:
            for el in range(1, len(self.ids)):
                expr += " OR "+str(id_)+ "= '" + self.ids[el] + "'"

        widget.model().setFilter(expr)
        widget.model().select()


    def exec_sql(self, element, dlg):

        result_mincut_id = utils_giswater.getWidgetText(self.dlg.result_mincut_id)
        if result_mincut_id == 'null':
            return

        sql = "DELETE FROM " + self.schema_name + ".anl_mincut_result_" + str(element) + ";\n"
        for element_id in self.ids:
            sql += "INSERT INTO " + self.schema_name + ".sanl_mincut_result_" + str(element) + " (result_id, " + str(element) + "_id) "
            sql += " VALUES ('" + str(result_mincut_id) + "', '" + str(element_id) + "');\n"
        
        self.controller.execute_sql(sql)
        self.btn_start.setDisabled(False)
        dlg.close()


    def delete_records_config(self, widget, table_name):
        ''' Delete selected elements of the table '''

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
            id_ = widget.model().record(row).value("id")
            inf_text += str(id_) + ", "
            list_id = list_id + "'" + str(id_) + "', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        answer = self.controller.ask_question("Are you sure you want to delete these records?", "Delete records",
                                              inf_text)
        if answer:
            sql = "DELETE FROM " + self.schema_name + "." + table_name
            sql += " WHERE id IN (" + list_id + ")"
            self.controller.execute_sql(sql)
            widget.model().select()


    def auto_mincut(self):
        """ B1-126: Automatic mincut analysis """

        # Check if user entered ID
        check = self.check_id()
        if check == 0:
            return

        # On inserting work order
        self.action_add_connec.setDisabled(True)
        self.action_add_hydrometer.setDisabled(True)
            
        self.canvas.connect(self.canvas, SIGNAL("xyCoordinates(const QgsPoint&)"), self.mouse_move_node_arc)
        self.emit_point.canvasClicked.connect(self.snapping_node_arc)


    def snapping_node_arc(self, point, btn):  #@UnusedVariable

        snapper = QgsMapCanvasSnapper(self.canvas)
        map_point = self.canvas.getCoordinateTransform().transform(point)
        x = map_point.x()
        y = map_point.y()
        event_point = QPoint(x, y)
        snapping_position = QgsPoint(point.x(), point.y())

        # Snapping
        (retval, result) = snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

        # That's the snapped point
        if result:

            # Check feature
            for snap_point in result:

                element_type = snap_point.layer.name()
                if element_type in self.group_layers_node:
                    feat_type = 'node'
                    self.feat_type = str(feat_type)

                    # Get the point
                    point = QgsPoint(snap_point.snappedVertex)
                    snapp_feature = next(snap_point.layer.getFeatures(QgsFeatureRequest().setFilterFid(snap_point.snappedAtGeometry)))
                    element_id = snapp_feature.attribute(feat_type + '_id')
                    self.element_id = str(element_id)

                    # Leave selection
                    snap_point.layer.select([snap_point.snappedAtGeometry])
                    self.mincut(element_id, feat_type,snapping_position)
                    break
                
            else:
                node_exist = '0'

            if node_exist == '0':
                for snap_point in result:
                    element_type = snap_point.layer.name()

                    if element_type in self.group_layers_arc:
                        feat_type = 'arc'
                        self.feat_type = str(feat_type)

                        # Get the point
                        point = QgsPoint(snap_point.snappedVertex)
                        snapp_feature = next(
                            snap_point.layer.getFeatures(QgsFeatureRequest().setFilterFid(snap_point.snappedAtGeometry)))
                        element_id = snapp_feature.attribute(feat_type + '_id')
                        self.element_id = str(element_id)

                        # Leave selection
                        snap_point.layer.select([snap_point.snappedAtGeometry])

                        self.mincut(element_id, feat_type, snapping_position)
                        break

        # TODO: Check it!
        sql = "UPDATE " + self.schema_name + ".anl_mincut_result_cat "
        sql += " SET mincut_class = 1 , anl_the_geom = ST_SetSRID(ST_Point(" + str(
            self.snapping_position.x()) + ", " + str(self.snapping_position.y()) + ")," + str(
            srid) + "), anl_user = '" + str(cur_user) + "' "
        sql += " WHERE id = '" + result_mincut_id_text + "'"
        self.controller.execute_sql(sql)


    def snapping_node_arc_real_location(self, point, btn):  #@UnusedVariable

        snapper = QgsMapCanvasSnapper(self.canvas)
        map_point = self.canvas.getCoordinateTransform().transform(point)
        x = map_point.x()
        y = map_point.y()
        event_point = QPoint(x, y)
        self.real_snapping_position = QgsPoint(point.x(), point.y())

        result_mincut_id_text = self.dlg.result_mincut_id.text()
        srid = self.controller.plugin_settings_value('srid')

        sql = "UPDATE " + self.schema_name + ".anl_mincut_result_cat "
        sql += " SET exec_the_geom = ST_SetSRID(ST_Point(" + str(self.real_snapping_position.x()) + ", " + str(self.real_snapping_position.y()) + ")," + str(srid) + ")"
        sql += " WHERE id = '" + result_mincut_id_text + "'"
        status = self.controller.execute_sql(sql)
        if status:
            message = "Real location has been updated"
            self.controller.show_info(message)

        # Snapping
        (retval, result) = snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

        # That's the snapped point
        if result <> []:

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


    def mincut(self, elem_id, elem_type, snapping_position):
        ''' Button auto - exec'''

        result_mincut_id_text = self.dlg.result_mincut_id.text()
        work_order = self.dlg.work_order.text()
        cur_user = self.controller.get_project_user()
        srid = self.controller.plugin_settings_value('srid')
        self.snapping_position = snapping_position

        # Check if id exist in .anl_mincut_result_cat
        sql = "SELECT id FROM " + self.schema_name + ".anl_mincut_result_cat WHERE id = '" + str(result_mincut_id_text) + "'"
        rows = self.controller.get_rows(sql)

        # Before of executing .gw_fct_mincut we already need to have id in .anl_mincut_result_cat
        if rows == []:
            sql = "INSERT INTO " + self.schema_name + ".anl_mincut_result_cat (id, work_order, mincut_state) "
            sql += " VALUES ('" + str(result_mincut_id_text) + "','" + str(work_order) + "', 2)"
            self.controller.execute_sql(sql)

        # Execute .gw_fct_mincut ('feature_id','feature_type','result_id')
        # feature_id :id of snapped arc/node
        # feature_type : type od snaped element (arc/node)
        # result_mincut_id : result_mincut_id from form
        sql = "SELECT " + self.schema_name + ".gw_fct_mincut('" + str(elem_id) + "', '" + str(elem_type) + "', '" + str(result_mincut_id_text) + "')"
        status = self.controller.execute_sql(sql)
        if status:
            message = "Mincut done successfully"
            self.controller.show_info(message)

            # Update anl_mincut_result_cat
            # mincut_class = 1, anl_the_geom_pointclicked, anl_user = cur_user
            sql = "UPDATE " + self.schema_name + ".anl_mincut_result_cat "
            sql += " SET mincut_class = 1, anl_the_geom = ST_SetSRID(ST_Point(" + str(snapping_position.x()) + ", " + str(snapping_position.y()) + ")," + str(srid) + "),\
                     anl_user = '" + str(cur_user) + "', anl_feature_type = '" + str(self.feat_type) + "', anl_feature_id = '" + str(self.element_id) + "'"
            sql += " WHERE id = '" + result_mincut_id_text + "'"
            status = self.controller.execute_sql(sql)
            if status:
                message = "Values has been updated"
                self.controller.show_info(message)
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

            # TRRIGER REPAINT
            #for layer_refresh in self.iface.mapCanvas().layers():
            #    layer_refresh.triggerRepaint()


    def custom_mincut(self):
        """ B2-123: Custom mincut analysis. Working just with layer Valve analytics """

        # Check if user entered ID
        check = self.check_id()
        if check == 0:
            return

        # Disconnect previous connections
        self.canvas.disconnect(self.canvas, SIGNAL("xyCoordinates(const QgsPoint&)"), self.mouse_move_node_arc)
        self.emit_point.canvasClicked.disconnect(self.snapping_node_arc)

        # Set active layer
        self.layer_valve_analytics = QgsMapLayerRegistry.instance().mapLayersByName("Mincut valve result")[0]
        self.iface.setActiveLayer(self.layer_valve_analytics)
        self.canvas.connect(self.canvas, SIGNAL("xyCoordinates(const QgsPoint&)"), self.mouse_move_valve)

        self.emit_point.canvasClicked.connect(self.snapping_valve_analytics)


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
            for snapPoint in result:
                # TODO: Layer name hardcoded
                if snapPoint.layer.name() == 'Mincut valve result':
                    point = QgsPoint(snapPoint.snappedVertex)
                    # Add marker
                    self.vertex_marker.setCenter(point)
                    self.vertex_marker.show()
        else :
            self.vertex_marker.hide()


    def mouse_move_node_arc(self, p):
       
        # TODO: Layer name hardcoded   
        layername = "v_edit_arc"     
        self.layer_arc = QgsMapLayerRegistry.instance().mapLayersByName(layername)
        if self.layer_arc:
            self.layer_arc = self.layer_arc[0]
        else:
            self.controller.log_info("Layer not found", parameter=layername)
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


    def snapping_valve_analytics(self, point, btn):

        # TODO
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
                # TODO: Layer name hardcoded                  
                if snapped_point.layer.name() == 'Mincut valve result':
                    # Get the point
                    #point = QgsPoint(snap_point.snappedVertex)  # @UnusedVariable
                    snapp_feat = next(snapped_point.layer.getFeatures(QgsFeatureRequest().setFilterFid(snapped_point.snappedAtGeometry)))
                    # LEAVE SELECTION
                    snapped_point.layer.select([snapped_point.snappedAtGeometry])
                    element_id = snapp_feat.attribute('node_id')
                    self.exec_mincut_valve_unaccess(element_id)


    def exec_mincut_valve_unaccess(self, elem_id):
        """ Init function of custom mincut. Working just with layer Valve analytics """ 

        result_mincut_id = utils_giswater.getWidgetText("result_mincut_id")

        if result_mincut_id != 'null':
            sql = "SELECT " + self.schema_name + ".gw_fct_mincut_valve_unaccess"
            sql += "('" + str(elem_id) + "', '" + str(result_mincut_id) + "');"
            status = self.controller.execute_sql(sql)
            if status:
                message = "Custom Mincut done successfully"
                self.controller.show_info(message)

        # Refresh map canvas
        self.canvas.refreshAllLayers()


    def mg_mincut_management(self):
        ''' Button 27: Mincut management '''

        self.action = "mg_mincut_management"

        # Create the dialog and signals
        self.dlg_min_edit = Mincut_edit()
        utils_giswater.setDialog(self.dlg_min_edit)

        self.combo_state_edit = self.dlg_min_edit.findChild(QComboBox, "state_edit")
        self.tbl_mincut_edit = self.dlg_min_edit.findChild(QTableView, "tbl_mincut_edit")
        self.txt_mincut_id = self.dlg_min_edit.findChild(QLineEdit, "txt_mincut_id")
        
        # Adding auto-completion to a QLineEdit
        self.completer = QCompleter()
        self.txt_mincut_id.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".anl_mincut_result_cat "
        rows = self.controller.get_rows(sql)
        values = []
        for row in rows:
            values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)
        self.txt_mincut_id.textChanged.connect(partial(self.filter_by_id, self.tbl_mincut_edit, self.txt_mincut_id, "anl_mincut_result_cat"))

        self.dlg_min_edit.btn_accept.pressed.connect(self.open_mincut)
        self.dlg_min_edit.btn_cancel.pressed.connect( self.dlg_min_edit.close)
        self.dlg_min_edit.btn_delete.clicked.connect(partial(self.delete_mincut_management, self.tbl_mincut_edit, "anl_mincut_result_cat", "id"))

        #self.btn_accept_min = self.dlg.findChild(QPushButton, "btn_accept")
        #self.btn_accept_min.clicked.connect(partial(self.accept_save_data))

        #self.dlg_min_edit.btn_cancel.pressed.connect(partial(self.close, self.dlg_min_edit))

        # Fill ComboBox state
        sql = "SELECT id"
        sql += " FROM " + self.schema_name + ".anl_mincut_cat_state"
        sql += " ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("state_edit", rows)

        self.fill_table_mincut_management(self.tbl_mincut_edit, self.schema_name + ".anl_mincut_result_cat")

        for i in range(1, 18):
            self.tbl_mincut_edit.hideColumn(i)

        #self.txt_mincut_id.textChanged.connect(partial(self.filter_by_id, self.tbl_mincut_edit, self.txt_mincut_id, "anl_mincut_result_cat"))
        self.combo_state_edit.activated.connect(partial(self.filter_by_state, self.tbl_mincut_edit, self.combo_state_edit, "anl_mincut_result_cat"))

        self.dlg_min_edit.show()


    def open_mincut(self):
        ''' Open form of mincut
        Fill form with selested mincut '''

        selected_list = self.tbl_mincut_edit.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        row = selected_list[0].row()

        # Get mincut_id from selected row
        id_ = self.tbl_mincut_edit.model().record(row).value("id")

        self.dlg_min_edit.close()

        self.init_mincut_form()
        self.activate_actions_custom_mincut()

        self.btn_accept_main.clicked.connect(partial(self.accept_save_data))

        # Force fill form mincut
        self.result_mincut_id.setText(str(id_))

        sql = "SELECT * FROM " + self.schema_name + ".anl_mincut_result_cat"
        sql += " WHERE id = '" + str(id_) + "'"
        row = self.controller.get_row(sql)
        if row:
            self.work_order.setText(str(row['work_order']))
            state = str(row['mincut_state'])
            mincut_class_status = str(row['mincut_class'])

            if state == '2':
                self.state.setText("Planified")
            elif state == '1':
                self.state.setText("In Progress")
            elif state == '0':
                self.state.setText("Finished")

            self.street.setText(str(row['streetname']))
            self.number.setText(str(row['number']))
            utils_giswater.setWidgetText("type", row['mincut_type'])
            utils_giswater.setWidgetText("cause", row['anl_cause'])

            # SET QDATETIME
            datetime = (str(row['anl_tstamp']))
            date = str(datetime.split()[0])
            time = str(datetime.split()[1])

            qtDate = QDate.fromString(date, 'yyyy-MM-dd')
            recieved_date = self.dlg.findChild(QDateEdit, "cbx_recieved_day")
            recieved_date.setDate(qtDate)

            qtTime = QTime.fromString(time, 'h:mm:ss')
            recieved_time = self.dlg.findChild(QTimeEdit, "cbx_recieved_time")
            recieved_time.setTime(qtTime)

            datetime = (str(row['forecast_start']))
            date = str(datetime.split()[0])
            time = str(datetime.split()[1])

            qtDate = QDate.fromString(date, 'yyyy-MM-dd')
            date_start_predict = self.dlg.findChild(QDateEdit, "cbx_date_start_predict")
            date_start_predict.setDate(qtDate)

            datetime = (str(row['forecast_end']))
            date = str(datetime.split()[0])
            time = str(datetime.split()[1])

            qtDate = QDate.fromString(date, 'yyyy-MM-dd')
            date_end_predict = self.dlg.findChild(QDateEdit, "cbx_date_end_predict")
            date_end_predict.setDate(qtDate)

            datetime = (str(row['exec_start']))
            date = str(datetime.split()[0])
            time = str(datetime.split()[1])

            qtDate = QDate.fromString(date, 'yyyy-MM-dd')
            cbx_date_start = self.dlg.findChild(QDateEdit, "cbx_date_start")
            cbx_date_start.setDate(qtDate)

            datetime = (str(row['exec_end']))
            date = str(datetime.split()[0])
            time = str(datetime.split()[1])

            qtDate = QDate.fromString(date, 'yyyy-MM-dd')
            cbx_date_start = self.dlg.findChild(QDateEdit, "cbx_date_end")
            cbx_date_start.setDate(qtDate)

            utils_giswater.setWidgetText("pred_description", row['anl_descript'])
            utils_giswater.setWidgetText("real_description", row['exec_descript'])

            self.distance.setText(str(row['exec_from_plot']))
            self.depth.setText(str(row['exec_depth']))

            #row['assigned_to'] = assigned_to_id
            # get name to fill combo
            sql = "SELECT assigned_to FROM " + self.schema_name + ".anl_mincut_result_cat"
            sql += " WHERE id = '" + str(id_) + "'"
            assigned_to_name = self.controller.get_row(sql)
            utils_giswater.setWidgetText("assigned_to", str(assigned_to_name[0]))

            #self.state.setText(str(row['mincut_state']))
            utils_giswater.setWidgetText("pred_description", row['anl_descript'])
            utils_giswater.setWidgetText("real_description", row['exec_descript'])
            self.distance.setText(str(row['exec_from_plot']))
            self.depth.setText(str(row['exec_depth']))

        # Depend of mincut_state and mincut_clase desable/enable widgets
        if mincut_class_status == '1':
            self.action_mincut.setDisabled(False)
            self.action_custom_mincut.setDisabled(False)
            self.action_add_connec.setDisabled(True)
            self.action_add_hydrometer.setDisabled(True)
        elif mincut_class_status == '2':
            self.action_mincut.setDisabled(True)
            self.actionCustomMMincut.setDisabled(True)
            self.action_add_connec.setDisabled(False)
            self.action_add_hydrometer.setDisabled(True)
        elif mincut_class_status == '3':
            self.action_mincut.setDisabled(True)
            self.action_custom_mincut.setDisabled(True)
            self.action_add_connec.setDisabled(True)
            self.action_add_hydrometer.setDisabled(False)

        if state == '2':
            # Group Location
            self.dlg.exploitation.setDisabled(False)
            self.dlg.postcode.setDisabled(False)
            self.dlg.street.setDisabled(False)
            self.dlg.number.setDisabled(False)
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
            
        elif state == '1':
            # Group Location            
            self.dlg.exploitation.setDisabled(True)
            self.dlg.postcode.setDisabled(True)
            self.dlg.street.setDisabled(True)
            self.dlg.number.setDisabled(True)
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

        elif state == '0':
            # Group Location  
            self.dlg.exploitation.setDisabled(True)
            self.dlg.postcode.setDisabled(True)
            self.dlg.street.setDisabled(True)
            self.dlg.number.setDisabled(True)
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


    def filter_by_id(self, table, widget_txt, tablename):

        id_ = utils_giswater.getWidgetText(widget_txt)
        if id_ != 'null':
            expr = " id = '" + id_ + "'"
            # Refresh model with selected filter
            table.model().setFilter(expr)
            table.model().select()
        else:
            self.fill_table_mincut_management(self.tbl_mincut_edit, self.schema_name + "." + tablename)


    def filter_by_state(self, table, widget_txt, tablename):

        #state = utils_giswater.getWidgetText(widget_txt)
        state = utils_giswater.getWidgetText(widget_txt)
        if state != 'null':
            expr = " mincut_state = '" + str(state) + "'"
            # Refresh model with selected filter
            table.model().setFilter(expr)
            table.model().select()
        else:
            self.fill_table_mincut_management(self.tbl_mincut_edit, self.schema_name + "." + tablename)


    def fill_table_mincut_management(self, widget, table_name):
        ''' Set a model with selected filter.
        Attach that model to selected table '''

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


    def delete_mincut_management(self, widget, table_name, column_id):
        ''' Delete selected elements of the table
         Delete by id '''

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
            inf_text+= str(id_)+", "
            list_id = list_id+"'"+str(id_)+"', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        answer = self.controller.ask_question("Are you sure you want to delete these records?", "Delete records", inf_text)

        if answer:
            sql = "DELETE FROM "+self.schema_name+"."+table_name
            sql+= " WHERE "+column_id+" IN ("+list_id+")"
            self.controller.execute_sql(sql)
            widget.model().select()


    def remove_selection(self):
        ''' Remove all previous selections'''

        for layer in self.canvas.layers():
            layer.removeSelection()
        self.canvas.refresh()

