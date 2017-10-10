'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.Qt import QDate, QTime
from PyQt4.QtCore import QPoint, Qt
from PyQt4.QtGui import QLineEdit, QTableView, QMenu, QPushButton, QComboBox, QTextEdit, QDateEdit, QTimeEdit, QAction, QStringListModel, QCompleter
from PyQt4.QtSql import QSqlTableModel
from qgis.core import QgsMapLayerRegistry, QgsFeatureRequest, QgsExpression
from qgis.gui import QgsMapToolEmitPoint, QgsMapCanvasSnapper

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


class MincutParent(ParentAction, MultipleSnapping):
    
    def __init__(self, iface, settings, controller, plugin_dir):
        ''' Class to control Management toolbar actions '''

        # Call ParentAction constructor
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)

        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir
        self.canvas = self.iface.mapCanvas()

        # Get layers of node,arc,connec groupe
        self.node_group = []
        self.connec_group = []
        self.arc_group = []

        ''' TODO: Search in table 'sys_feature_cat'
        sql = "SELECT DISTINCT(i18n) FROM " + self.schema_name + ".node_type_cat_type "
        nodes = self.controller.get_rows(sql)
        for node in nodes:
            self.node_group.append(str(node[0]))

        sql = "SELECT DISTINCT(i18n) FROM " + self.schema_name + ".connec_type_cat_type "
        connecs = self.controller.get_rows(sql)
        for connec in connecs:
            self.connec_group.append(str(connec[0]))

        sql = "SELECT DISTINCT(i18n) FROM " + self.schema_name + ".arc_type_cat_type "
        arcs = self.controller.get_rows(sql)
        for arc in arcs:
            self.arc_group.append(str(arc[0]))
        '''


    def init_mincut_form(self):
        ''' Custom form initial configuration '''

        self.canvas = self.iface.mapCanvas()
        # Create the appropriate map tool and connect the gotPoint() signal.
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.snapper = QgsMapCanvasSnapper(self.canvas)

        self.dlg = Mincut()
        utils_giswater.setDialog(self.dlg)
        self.dlg.setWindowFlags(Qt.WindowStaysOnTopHint)

        self.group_layers_connec = ["Wjoin", "Tap" , "Fountain"]
        self.group_pointers_connec = []
        for layer in self.group_layers_connec:
            self.group_pointers_connec.append(QgsMapLayerRegistry.instance().mapLayersByName(layer)[0])
        self.group_layers_node = ["Junction"]
        self.group_layers_arc = ["Pipe"]

        self.state = self.dlg.findChild(QLineEdit, "state")
        self.result_id = self.dlg.findChild(QLineEdit, "result_id")
        self.result_id.setVisible(False)
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

        #self.btn_accept_main.clicked.connect(partial(self.accept_save_data, self.action))
        self.btn_cancel_main.clicked.connect(self.dlg.close)

        # Get status 'planified' (id = 0)
        sql = "SELECT name FROM " + self.schema_name + ".anl_mincut_cat_state WHERE id = 0"
        row = self.controller.get_row(sql)
        if row:
            self.state.setText(str(row[0]))

        # Fill ComboBox exploitation
        sql = "SELECT descript"
        sql += " FROM " + self.schema_name + ".exploitation"
        sql += " ORDER BY descript"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("exploitation", rows)

        # Fill ComboBox type
        sql = "SELECT id"
        sql += " FROM " + self.schema_name + ".anl_mincut_cat_type"
        sql += " ORDER BY id"
        rows = self.controller.get_rows(sql)
        if rows != []:
            utils_giswater.fillComboBoxDefault("type", rows)

        # Fill ComboBox cause
        sql = "SELECT id"
        sql += " FROM " + self.schema_name + ".anl_mincut_cat_cause"
        sql += " ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBoxDefault("cause", rows)

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
        action = self.dlg.findChild(QAction, "actionMincut")
        action.triggered.connect(self.mincut_init)
        self.set_icon(action, "126")
        action = self.dlg.findChild(QAction, "actionCustomMincut")
        #action.triggered.connect(self.custom_mincut_init)
        self.set_icon(action, "123")
        self.actionCustomMincut = action
        action = self.dlg.findChild(QAction, "actionAddConnec")
        action.triggered.connect(self.add_connec)
        self.set_icon(action, "121")
        action = self.dlg.findChild(QAction, "actionAddHydrometer")
        action.triggered.connect(self.add_hydrometer)
        self.set_icon(action, "122")

        self.dlg.show()


    def mg_mincut(self):
        ''' Button 26: New Mincut '''

        self.init_mincut_form()

        self.action = "mg_mincut"

        self.btn_accept_main.clicked.connect(partial(self.accept_save_data, self.action))
        #self.btn_cancel_main.clicked.connect(self.dlg.close)

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


    def real_end(self):

        # Set current date and time
        self.date_end = QDate.currentDate()
        self.cbx_date_end.setDate(self.date_end)

        self.time_end = QTime.currentTime()
        self.cbx_hours_end.setTime(self.time_end)

        # Create the dialog and signals
        self.dlg_fin = Mincut_fin()
        utils_giswater.setDialog(self.dlg_fin)

        self.cbx_date_start_fin = self.dlg_fin.findChild(QDateEdit, "cbx_date_start_fin")

        self.cbx_hours_start_fin = self.dlg_fin.findChild(QTimeEdit, "cbx_hours_start_fin")
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
        utils_giswater.setText("mincut", str(self.result_id.text()))
        utils_giswater.setText("street", str(self.street.text()))
        utils_giswater.setText("number", str(self.number.text()))

        # Get status 'finished' (id = 2)
        sql = "SELECT name FROM " + self.schema_name + ".anl_mincut_cat_state WHERE id = 2"
        row = self.controller.get_row(sql)
        if row:
            self.state.setText(str(row[0]))

        self.dlg_fin.setWindowFlags(Qt.WindowStaysOnTopHint)

        # Open the dialog
        self.dlg_fin.show()


    def accept_save_data(self, action):

        mincut_result_state = self.state.text()
        id_ = self.result_id.text()
        # exploitation =
        street = str(self.street.text())
        number = str(self.number.text())
        mincut_result_type = self.type.currentText()
        anl_cause = self.cause.currentText()

        # anl_descript = str(utils_giswater.getWidgetText("pred_description"))
        anl_descript = self.pred_description.toPlainText()

        exec_limit_distance = self.distance.text()
        exec_depth = self.depth.text()

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

        if action == "mg_mincut" :
            # Insert data to DB
            sql = "INSERT INTO " + self.schema_name + ".anl_mincut_result_cat (mincut_state, id, address_1, address_2," 
            sql += " mincut_type, anl_cause, forecast_start, forecast_end, anl_descript"
            if self.btn_end.isEnabled():
                sql += ", exec_start, exec_end, exec_from_plot, exec_depth, exec_descript)"
            else:
                sql += ")"
            sql += " VALUES ('" + mincut_result_state + "', '" + id_ + "', '" + street + "', '" + number + "', '" + mincut_result_type + "', '" + anl_cause + "', '"
            sql += forecast_start_predict + "', '" + forecast_end_predict + "', '" + anl_descript + "'"
            if self.btn_end.isEnabled():
                sql += ",'" + forecast_start_real + "', '" + forecast_end_real + "', '" + exec_limit_distance + "', '" + exec_depth + "', '" + exec_descript + "')"
            else :
                sql += ")"
            status = self.controller.execute_sql(sql)
            if status:
                message = "Values has been updated"
                self.controller.show_info(message)
            if not status:
                message = "Error inserting element in table, you need to review data"
                self.controller.show_warning(message)
                return

        elif action == "mg_mincut_management" :
            sql = "UPDATE " + self.schema_name + ".anl_mincut_result_cat "
            sql += " SET id = '" + id_ + "', mincut_state = '" + mincut_result_state + "', anl_descript = '" + anl_descript + \
                   "', exec_descript = '" + exec_descript + "', exec_depth = '" + exec_depth + "', exec_from_plot = '" + exec_limit_distance + \
                   "', forecast_start = '" + forecast_start_predict + "', forecast_end = '" + forecast_end_predict + \
                   "', exec_start = '" + forecast_start_real + "', exec_end = '" + forecast_end_real + "' , address_1 = '" + street + \
                   "', address_2 = '" + number + "', mincut_type = '" + mincut_result_type + "', anl_cause = '" + anl_cause + "' "
            sql += " WHERE id = '" + id_ + "'"
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

        self.dlg_fin.close()


    def add_connec(self):
        ''' B3-121: Connec selector '''

        # Remove all previous selections
        self.remove_selection()

        self.ids = []

        # Check if user entered ID
        check = self.check_id()
        if check == 0:
            return
        else:
            pass

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
        # TODO: Check slot function
        #btn_insert_connec.pressed.connect(partial(self.fill_table, self.tbl_connec, self.schema_name + "." + table, "connec_id", self.dlg_connec))
        btn_insert_connec.pressed.connect(partial(self.manual_init, self.tbl_connec, table, "connec_id", self.dlg_connec, self.group_pointers_connec))
        self.set_icon(btn_insert_connec, "111")

        btn_insert_connec_snap = self.dlg_connec.findChild(QPushButton, "btn_snapping")
        btn_insert_connec_snap.pressed.connect(self.snapping_init)
        self.set_icon(btn_insert_connec_snap, "129")

        btn_accept = self.dlg_connec.findChild(QPushButton, "btn_accept")
        btn_accept.pressed.connect(partial(self.exec_sql, "connec_id", "connec"))

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

        # self.fill_table(self.tbl, self.schema_name+"."+table)
        self.dlg_connec.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_connec.show()


    def snapping_init(self):
        ''' Snap connec '''

        self.tool = MultipleSnapping(self.iface, self.settings, self.controller, self.plugin_dir,self.group_layers_connec)
        self.canvas.setMapTool(self.tool)
        self.iface.mapCanvas().selectionChanged.connect(partial(self.snapping_selection,self.group_pointers_connec,"connec_id"))


    def snapping_selection(self, group_pointers,attribute):

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

        self.reload_table()


    def check_id(self):
        ''' Check if user entered ID '''

        customer_state = self.customer_state.text()
        if customer_state == "":
            message = "You need to enter customer code"
            self.controller.show_info_box(message)
            return 0
        else:
            return 1


    def add_hydrometer(self):
        ''' B4-122: Hydrometer selector '''

        self.ids = []

        # Check if user entered ID
        check = self.check_id()
        if check == 0 :
            return
        else:
            pass

        self.dlg_hydro = Mincut_add_hydrometer()
        utils_giswater.setDialog(self.dlg_hydro)
        self.set_icon(self.dlg_hydro.btn_insert, "111")
        self.set_icon(self.dlg_hydro.btn_delete, "112")

        table = "rtc_hydrometer"
        self.tbl = self.dlg_hydro.findChild(QTableView, "tbl")

        #- self.btn_cancel = self.dlg_hydro.findChild(QPushButton, "btn_cancel")
        # -self.btn_cancel.pressed.connect(self.close_dialog_multi)

        self.hydrometer = self.dlg_hydro.findChild(QLineEdit, "hydrometer_id")

        self.btn_delete_hydro = self.dlg_hydro.findChild(QPushButton, "btn_delete")
        self.btn_delete_hydro.pressed.connect(partial(self.delete_records, self.tbl, table,"hydrometer_id"))

        self.btn_insert_hydro = self.dlg_hydro.findChild(QPushButton, "btn_insert")
        # TODO: Check slot function
        #self.btn_insert_hydro.pressed.connect(partial(self.fill_table, self.tbl, self.schema_name + "." + table, "hydrometer_id",self.dlg_hydro))
        self.btn_insert_hydro.pressed.connect(partial(self.manual_init, self.tbl, self.schema_name + "." + table, "hydrometer_id",self.dlg_hydro))
        self.set_icon(self.btn_insert_hydro, "111")

        self.btn_snapping_hydro = self.dlg_hydro.findChild(QPushButton, "btn_snapping")
        self.set_icon(self.btn_snapping_hydro, "129")

        self.btn_accept = self.dlg_hydro.findChild(QPushButton, "btn_accept")
        self.btn_accept.pressed.connect(partial(self.exec_sql,"hydrometer_id", "hydrometer"))

        # Adding auto-completion to a QLineEdit
        self.completer = QCompleter()
        self.hydrometer.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(hydrometer_id) FROM " + self.schema_name + ".rtc_hydrometer "
        row = self.controller.get_rows(sql)

        values = []
        for value in row:
            values.append(str(value[0]))

        model.setStringList(values)
        self.completer.setModel(model)

        # Set signal to reach selected value from QCompleter
        # self.completer.activated.connect(self.autocomplete)

        # self.fill_table(self.tbl, self.schema_name+"."+table)
        self.dlg_hydro.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_hydro.show()


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
            message = str(attribute)+ ":"+element_id+" id already in the list!"
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

        # Reload table
        self.reload_table()


    def reload_table(self):

        # Reload table
        table = "connec"
        table_name = self.schema_name + "." + table
        widget = self.tbl_connec
        expr = "connec_id = '" + self.ids[0] + "'"
        if len(self.ids) > 1:
            for el in range(1, len(self.ids)):
                expr += " OR connec_id = '" + self.ids[el] + "'"

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


    def exec_sql(self, id_el, element):

        sql = "DELETE FROM " + self.schema_name + ".anl_mincut_result_" + str(element)
        self.controller.execute_sql(sql)

        for id_ in self.ids:
            # Insert into anl_mincut_hydrometer all selected connecs
            sql = "INSERT INTO " + self.schema_name + ".anl_mincut_result_"+str(element)+" ("+str(id_el)+")"
            sql += " VALUES ('" + id_ + "')"
            self.controller.log_info(sql)
            status = self.controller.execute_sql(sql)
            if status:
                # TODO: Execute SQL function
                self.result_id_text = utils_giswater.getWidgetText("result_id")
                if self.result_id_text:                
                    function_name = "gw_fct_mincut_result_catalog"
                    sql = "SELECT " + self.schema_name + "." + function_name + "('" + self.result_id_text + "');"
                    self.controller.log_info(sql)                
                    status = self.controller.execute_sql(sql)
                else:
                    self.controller.log_info("id not found")
                    status = False

        if status:
            message = "Function executed successfully"
            self.controller.show_info(message, parameter=function_name)


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


    def mincut_init(self):
        ''' B1-126: Automatic mincut analysis '''

        # Check if user entered ID
        check = self.check_id()
        if check == 0:
            return
        else:
            pass
        
        self.emit_point.canvasClicked.connect(self.snapping_node_arc)        


    def snapping_node_arc(self, point, btn):  #@UnusedVariable

        map_point = self.canvas.getCoordinateTransform().transform(point)
        x = map_point.x()
        y = map_point.y()
        event_point = QPoint(x, y)

        # Snapping
        (retval, result) = self.snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

        # If any feature snapped return
        if result == []:
            self.controller.log_info("Any feature snapped")
            return

        # Check feature
        for snap_point in result:

            element_type = snap_point.layer.name()
            if element_type in self.node_group:
                feat_type = 'node'

                # Get the point
                point = (snap_point.snappedVertex)
                snapp_feat = next(snap_point.layer.getFeatures(QgsFeatureRequest().setFilterFid(snap_point.snappedAtGeometry)))
                element_id = snapp_feat.attribute(feat_type + '_id')

                # LEAVE SELECTION
                snap_point.layer.select([snap_point.snappedAtGeometry])

                self.mincut(element_id, feat_type)

        for snap_point in result:

            element_type = snap_point.layer.name()
            if element_type in self.arc_group :
                feat_type = 'arc'

                # Get the point
                point = (snap_point.snappedVertex)
                snapp_feat = next(snap_point.layer.getFeatures(QgsFeatureRequest().setFilterFid(snap_point.snappedAtGeometry)))
                element_id = snapp_feat.attribute(feat_type + '_id')

                # LEAVE SELECTION
                snap_point.layer.select([snap_point.snappedAtGeometry])

                self.mincut(element_id, feat_type)


    def mincut(self,elem_id,elem_type):

        # Execute SQL function 'gw_fct_mincut'
        sql = "SELECT " + self.schema_name + ".gw_fct_mincut('" + str(elem_id) + "', '" + str(elem_type) + "', '" + self.result_id_text + "');"
        self.hold_elem_id = elem_id
        self.hold_elem_type = elem_type
        self.hold_id_text = self.result_id_text
        self.controller.log_info(sql)
        status = self.controller.execute_sql(sql)

        # Refresh map canvas
        self.iface.mapCanvas().refreshAllLayers()

        if status:
            message = "Mincut done successfully"
            self.controller.show_info(message)

            # If mincut is done enable CustomMincut
            self.actionCustomMincut.setDisabled(False)

        # TRRIGER REPAINT
        for layer_refresh in self.iface.mapCanvas().layers():
            layer_refresh.triggerRepaint()


    def custom_mincut_init(self):
        ''' B2-123: Custom mincut analysis
        Working just with layer Valve analytics '''

        # Check if user entered ID
        check = self.check_id()
        if check == 0:
            return
        else:
            pass

        self.emit_point.canvasClicked.connect(self.snapping_valve_analytics)


    def snapping_valve_analytics(self):
        
        # Set active layer
        layer = QgsMapLayerRegistry.instance().mapLayersByName("Valve analytics")[0]
        self.iface.setActiveLayer(layer)

        # TODO
        map_point = self.canvas.getCoordinateTransform().transform(point)
        x = map_point.x()
        y = map_point.y()
        eventPoint = QPoint(x, y)

        # Snapping
        (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable

        # That's the snapped point
        if result <> []:

            # Check feature
            for snapPoint in result:

                if snapPoint.layer.name() == 'Valve analytics':
                    # Get the point
                    point = (result[0].snappedVertex)  # @UnusedVariable
                    snapp_feat = next(result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))
                    # LEAVE SELECTION
                    result[0].layer.select([result[0].snappedAtGeometry])

                    element_id = snapp_feat.attribute(feat_type + '_id')
                    self.custom_mincut(element_id)


    def custom_mincut(self, elem_id):
        ''' Init function of custom mincut - Valve analytics
        Working just with layer Valve analytics '''

        sql = "INSERT INTO " + self.schema_name + ".anl_mincut_result_valve_unaccess (mincut_result_cat_id, valve_id)"
        sql += " VALUES ('" + self.result_id_text + "', '" + elem_id + "')"

        status = self.controller.execute_sql(sql)
        if status:
            # Show message to user
            message = "Values has been updated"
            self.controller.show_info(message)

        # After executing SQL, call 'gw_fct_mincut' again
        # Use elem id of previous element - repeating automatic mincut
        sql = "SELECT " + self.schema_name + ".gw_fct_mincut"
        sql += "('" + str(self.hold_elem_id) + "', '" + str(self.hold_elem_type) + "', '" + str(self.hold_id_text) + "');"
        self.controller.log_info(sql)
        status = self.controller.execute_sql(sql)

        # Refresh map canvas
        self.iface.mapCanvas().refreshAllLayers()

        if status:
            message = "Mincut done successfully"
            self.controller.show_info(message)

            # If mincut is done enable CustomMincut
            self.actionCustomMincut.setDisabled(False)

        # TRRIGER REPAINT
        for layerRefresh in self.iface.mapCanvas().layers():
            layerRefresh.triggerRepaint()


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
        #self.btn_accept_min.clicked.connect(partial(self.accept_save_data,self.action))

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

        self.combo_state_edit.activated.connect(partial(self.filter_by_state, self.tbl_mincut_edit))

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

        #self.mg_mincut()
        self.init_mincut_form()

        self.btn_accept_main.clicked.connect(partial(self.accept_save_data, self.action))

        # TODO: Force fill form
        sql = "SELECT * FROM " + self.schema_name + ".anl_mincut_result_cat"
        sql += " WHERE id = '" + id_ + "'"
        row = self.controller.get_row(sql)
        if row:    
            self.result_id.setText(row['id'])
            self.state.setText(str(row['mincut_state']))
            utils_giswater.setWidgetText("pred_description", row['anl_descript'])
            utils_giswater.setWidgetText("real_description", row['exec_descript'])
            self.distance.setText(str(row['exec_from_plot']))
            self.depth.setText(str(row['exec_depth']))

            # from address separate street and number
#             address_db = row['address_1']
#             self.street.setText(address_db)
#             number_db = row['address_2']
#             self.number.setText(number_db)
    
            # Set values from mincut to comboBox
            # utils_giswater.fillComboBox("type", rows['mincut_result_type'])
            # utils_giswater.fillComboBox("cause", rows['anl_cause'])
            mincut_result_type = row['mincut_type']
            cause = rows['anl_cause']
            # Clear comboBoxes
            self.type.clear()
            self.cause.clear()

        # Fill comboBoxes
        #self.type.addItem(rows[0]['mincut_result_type'])
        #self.cause.addItem(rows[0]['anl_cause'])

        self.btn_end.setEnabled(True)
        self.distance.setEnabled(True)
        self.depth.setEnabled(True)
        self.real_description.setEnabled(True)
        self.cbx_date_end.setEnabled(True)
        self.cbx_hours_end.setEnabled(True)
        self.cbx_date_start.setEnabled(True)
        self.cbx_hours_start.setEnabled(True)

        # Disable to edit ID
        self.result_id.setEnabled(False)


    def filter_by_id(self, table, widget_txt, tablename):

        id_ = utils_giswater.getWidgetText(widget_txt)
        if id_ != 'null':
            expr = " id LIKE '" + id_ + "'"
            # Refresh model with selected filter
            table.model().setFilter(expr)
            table.model().select()
        else:
            self.fill_table_mincut_management(self.tbl_mincut_edit, self.schema_name + "." + tablename)


    def filter_by_state(self,widget):

        result_select = utils_giswater.getWidgetText("state_edit")
        expr = " mincut_result_state = '"+result_select+"'"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()


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

