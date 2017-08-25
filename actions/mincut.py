'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-

from PyQt4.QtCore import Qt, QSettings, QObject, QTimer, QPoint, SIGNAL
from PyQt4.QtGui import QFileDialog, QMessageBox, QCheckBox, QLineEdit, QTableView, QMenu, QPushButton, QComboBox, QTextEdit, QDateEdit, QTimeEdit, QAbstractItemView, QAction
from PyQt4.QtSql import QSqlTableModel, QSqlQueryModel
from PyQt4.Qt import QDate, QTime
from qgis.core import QgsMapLayerRegistry


from qgis.gui import QgsMapToolEmitPoint, QgsMapCanvasSnapper

from ..ui.mincut import Mincut
from ..ui.mincut_fin import Mincut_fin
from ..ui.multi_selector import Multi_selector
from ..ui.mincut_add_hydrometer import Mincut_add_hydrometer
from ..ui.mincut_add_connec import Mincut_add_connec
from ..ui.mincut_edit import Mincut_edit

from datetime import datetime, date
import os
import sys
import webbrowser
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater


from PyQt4.QtGui import QPushButton, QLineEdit
from PyQt4.QtCore import QObject, QTimer, QPoint, SIGNAL
from qgis.core import QgsMapLayerRegistry, QgsFeatureRequest, QgsPoint
from qgis.gui import QgsMapToolEmitPoint, QgsMapTip, QgsMapCanvasSnapper


from qgis.core import *
from qgis.gui import *
from PyQt4.QtCore import *
from PyQt4.QtGui import *

from PyQt4.Qt import *

from parent import ParentAction


class MincutParent(ParentAction):
    def __init__(self, iface, settings, controller, plugin_dir):
        ''' Class to control Management toolbar actions '''

        # Call ParentAction constructor
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)

        self.canvas = self.iface.mapCanvas()
        # Create the appropriate map tool and connect the gotPoint() signal.
        self.emitPoint = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emitPoint)
        self.snapper = QgsMapCanvasSnapper(self.canvas)

        # Get layers of node,arc,connec groupe
        self.node_group = []
        self.connec_group = []
        self.arc_group = []

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


    def mg_mincut(self):
        ''' Btn 26 - New Mincut '''

        self.dlg = Mincut()
        utils_giswater.setDialog(self.dlg)
        self.dlg.setWindowFlags(Qt.WindowStaysOnTopHint)

        self.state = self.dlg.findChild(QLineEdit, "state")
        self.id = self.dlg.findChild(QLineEdit, "id")
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

        self.btn_accept_main.clicked.connect(self.accept_save_data)
        self.btn_cancel_main.clicked.connect(self.dlg.close)

        # Fill widgets
        sql = "SELECT id FROM " + self.schema_name + ".anl_mincut_cat_state"
        self.state_values = self.controller.get_rows(sql)
        if self.state_values != []:
            self.state.setText(str(self.state_values[0][0]))

        # Fill ComboBox exploitation
        sql = "SELECT descript"
        sql += " FROM " + self.schema_name + ".exploitation"
        sql += " ORDER BY descript"
        rows = self.controller.get_rows(sql)
        if rows != [] :
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
        if rows != []:
            utils_giswater.fillComboBoxDefault("cause", rows)

        # Get current date
        date_start = QDate.currentDate()

        # Set all QDateEdit to current date
        self.cbx_date_start = self.dlg.findChild(QDateEdit, "cbx_date_start")
        self.cbx_date_start.setDate(date_start)
        self.cbx_hours_start = self.dlg.findChild(QTimeEdit, "cbx_hours_start")

        self.cbx_date_end = self.dlg.findChild(QDateEdit, "cbx_date_end")
        self.cbx_date_end.setDate(date_start)
        self.cbx_hours_end = self.dlg.findChild(QTimeEdit, "cbx_hours_end")

        # Widgets for predict date
        self.cbx_date_start_predict = self.dlg.findChild(QDateEdit, "cbx_date_start_predict")
        self.cbx_date_start_predict.setDate(date_start)
        self.cbx_hours_start_predict = self.dlg.findChild(QTimeEdit, "cbx_hours_start_predict")

        self.cbx_date_start_predict_2 = self.dlg.findChild(QDateEdit, "cbx_date_start_predict_2")
        self.cbx_date_start_predict_2.setDate(date_start)

        # Widgets for real date
        self.cbx_date_end_predict = self.dlg.findChild(QDateEdit, "cbx_date_end_predict")
        self.cbx_date_end_predict.setDate(date_start)
        self.cbx_hours_end_predict = self.dlg.findChild(QTimeEdit, "cbx_hours_end_predict")

        # Btn_end and btn_start
        self.btn_start = self.dlg.findChild(QPushButton, "btn_start")
        self.btn_start.clicked.connect(self.real_start)

        self.btn_end = self.dlg.findChild(QPushButton, "btn_end")
        self.btn_end.clicked.connect(self.real_end)

        # Toolbar actions
        self.dlg.findChild(QAction, "actionConfig").triggered.connect(self.config)
        self.dlg.findChild(QAction, "actionMincut").triggered.connect(self.mincutInit)
        #self.actionCustomMincut = self.dlg.findChild(QAction, "actionCustomMincut")
        #self.actionCustomMincut.triggered.connect(self.customMincatInit)
        self.dlg.findChild(QAction, "actionAddConnec").triggered.connect(self.addConnec)
        self.dlg.findChild(QAction, "actionAddHydrometer").triggered.connect(self.addHydrometer)

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

        # Set status
        self.state.setText(str(self.state_values[1][0]))


    def real_end(self):

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
        self.mincut_fin = self.dlg_fin.findChild(QLineEdit, "mincut")
        self.street_fin = self.dlg_fin.findChild(QLineEdit, "street")
        self.number_fin = self.dlg_fin.findChild(QLineEdit, "number")

        id_fin = str(self.id.text())
        street_fin = str(self.street.text())
        number_fin = str(self.number.text())

        self.mincut_fin.setText(id_fin)
        self.street_fin.setText(street_fin)
        self.number_fin.setText(number_fin)
        # set status
        if self.state_values != []:
            self.state.setText(str(self.state_values[2][0]))

        self.dlg_fin.setWindowFlags(Qt.WindowStaysOnTopHint)

        # Open the dialog
        self.dlg_fin.show()


    def accept_save_data(self):

        anl_cause = " "
        mincut_result_state = self.state.text()
        id = self.id.text()
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

        # Insert data to DB
        sql = "INSERT INTO " + self.schema_name + ".anl_mincut_result_cat (mincut_state, id, address_1, address_2, mincut_type, anl_cause, forecast_start, forecast_end, anl_descript,exec_start, exec_end,exec_limit_distance, exec_depth, exec_descript)"
        sql += " VALUES ('" + mincut_result_state + "','" + id + "','" + street + "','" + number + "','" + mincut_result_type + "','" + anl_cause + "','" + forecast_start_predict + "','" + forecast_end_predict + "','" + anl_descript + "','" + forecast_start_real + "','" + forecast_end_real + "','" + exec_limit_distance + "','" + exec_depth + "','" + exec_descript + "')"
        message = str(sql)
        self.controller.show_info(message, context_name='ui_message')
        status = self.controller.execute_sql(sql)
        if status:
            message = "Values has been updated"
            self.controller.show_info(message, context_name='ui_message')

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


    def addConnec(self):
        ''' B3-121: Connec selector  '''
        self.ids = []

        # Check if user entered ID
        check = self.check_id()
        if check == 0:
            return
        else:
            pass

        self.dlg_connec = Mincut_add_connec()
        utils_giswater.setDialog(self.dlg_connec)

        table = "connec"

        self.tbl_connec = self.dlg_connec.findChild(QTableView, "tbl_mincut_connec")

        #- self.btn_cancel = self.dlg_hydro.findChild(QPushButton, "btn_cancel")
        # -self.btn_cancel.pressed.connect(self.close_dialog_multi)

        self.btn_delete_connec = self.dlg_connec.findChild(QPushButton, "btn_delete")
        self.btn_delete_connec.pressed.connect(partial(self.delete_records, self.tbl_connec, table, "connec_id"))
        self.set_icon(self.btn_delete_connec,"112.png")

        self.btn_insert_connec = self.dlg_connec.findChild(QPushButton, "btn_insert")
        self.btn_insert_connec.pressed.connect(partial(self.fill_table, self.tbl_connec, self.schema_name + "." + table,"connec_id",self.dlg_connec))
        self.set_icon(self.btn_insert_connec, "111.png")

        self.btn_insert_connec_snap = self.dlg_connec.findChild(QPushButton, "btn_snapping")
        self.btn_insert_connec_snap.pressed.connect(self.snapping_init)

        btn_accept = self.dlg_connec.findChild(QPushButton, "btn_accept")
        btn_accept.pressed.connect(partial(self.exec_sql,"connec_id", "connec"))

        self.connec = self.dlg_connec.findChild(QLineEdit, "connec_id")
        # Adding auto-completion to a QLineEdit
        self.completer = QCompleter()
        self.connec.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(connec_id) FROM " + self.schema_name + ".connec "
        row = self.controller.get_rows(sql)

        values = []
        for value in row:
            values.append(str(value[0]))

        model.setStringList(values)
        self.completer.setModel(model)

        # Set signal to reach selected value from QCompleter
        # self.completer.activated.connect(self.autocomplete)

        # self.fill_table(self.tbl, self.schema_name+"."+table)
        self.dlg_connec.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_connec.show()

    def snapping_init(self):
        QObject.connect(self.emitPoint, SIGNAL("canvasClicked(const QgsPoint &, Qt::MouseButton)"),self.snappingConnec)


    def snappingConnec(self, point, btn):

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

                element_type = snapPoint.layer.name()

                if element_type in self.connec_group:
                    feat_type = 'connec'
                else:
                    continue

                # Get the point
                point = QgsPoint(snapPoint.snappedVertex)
                snappFeat = next(snapPoint.layer.getFeatures(QgsFeatureRequest().setFilterFid(snapPoint.snappedAtGeometry)))
                feature = snappFeat
                element_id = feature.attribute(feat_type + '_id')

                # LEAVE SELECTION
                snapPoint.layer.select([snapPoint.snappedAtGeometry])


                # Add element
                #self.addConnec(element_id)
                table_name = self.schema_name + ".connec"
                if element_id in self.ids:
                    message = " Connec_id :" + element_id + " id already in the list!"
                    self.controller.show_info_box(message, context_name='ui_message')
                    return
                else:
                    self.ids.append(element_id)

                # Reload table
                expr = "connec_id = '" + self.ids[0] + "'"
                if len(self.ids) > 1:
                    for el in range(1, len(self.ids)):
                        expr += " OR connec_id= '" + self.ids[el] + "'"

                # expr = "hydrometer_id = '368' OR hydrometer_id = '334' OR hydrometer_id = '675'"
                # Set model
                model = QSqlTableModel();
                model.setTable(table_name)
                model.setEditStrategy(QSqlTableModel.OnManualSubmit)

                model.select()

                # Check for errors
                if model.lastError().isValid():
                    self.controller.show_warning(model.lastError().text())

                # Attach model to table view
                #widget.setModel(model)
                self.tbl_connec.setModel(model)

                self.tbl_connec.model().setFilter(expr)
                self.tbl_connec.model().select()


    def check_id(self):
        ''' Check if user entered ID '''

        self.id_text = self.id.text()

        if self.id_text == "id":
            message = "You need to enter id"
            self.controller.show_info_box(message, context_name='ui_message')
            return 0
        else :
            return 1


    def addHydrometer(self):
        ''' B4-122: Hydrometer selector '''

        self.ids = []

        # Check if user entered ID
        check = self.check_id()
        if check == 0 :
            return
        else :
            pass

        self.dlg_hydro = Mincut_add_hydrometer()
        utils_giswater.setDialog(self.dlg_hydro)

        table = "rtc_hydrometer"

        self.tbl = self.dlg_hydro.findChild(QTableView, "tbl")

        #- self.btn_cancel = self.dlg_hydro.findChild(QPushButton, "btn_cancel")
        # -self.btn_cancel.pressed.connect(self.close_dialog_multi)

        self.hydrometer = self.dlg_hydro.findChild(QLineEdit, "hydrometer_id")

        self.btn_delete_hydro = self.dlg_hydro.findChild(QPushButton, "btn_delete")
        self.btn_delete_hydro.pressed.connect(partial(self.delete_records, self.tbl, table,"hydrometer_id"))
        self.set_icon(self.btn_delete_hydro, "112.png")

        self.btn_insert_hydro = self.dlg_hydro.findChild(QPushButton, "btn_insert")
        self.btn_insert_hydro.pressed.connect(partial(self.fill_table, self.tbl, self.schema_name + "." + table, "hydrometer_id",self.dlg_hydro))
        self.set_icon(self.btn_insert_hydro, "111.png")

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


    def fill_table(self, widget, table_name ,id, dialog) :
        ''' Set a model with selected filter.
        Attach that model to selected table '''

        expr = ""
        # el_id->hydro_id = self.hydrometer.text()
        widget_id = dialog.findChild(QLineEdit, id )
        el_id = widget_id.text()

        # Check if user entered hydrometer_id
        if el_id == "":
            message = "You need to enter id"
            self.controller.show_info_box(message, context_name='ui_message')
            return

        if el_id in self.ids:
            message = str(id)+ ":"+el_id+" id already in the list!"
            self.controller.show_info_box(message, context_name='ui_message')
            return
        else :
            self.ids.append(el_id)

        # Reload table
        expr = str(id) + " = '" + self.ids[0] + "'"
        if len(self.ids) > 1:
            for el in range(1, len(self.ids)):
                expr += " OR " + str(id) + "= '" + self.ids[el] + "'"

        # expr = "hydrometer_id = '368' OR hydrometer_id = '334' OR hydrometer_id = '675'"
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

        table = "man_selector_valve"

        self.menu_valve = QMenu()

        # self.menu_valve.clear()
        self.dlg_multi.btn_insert.pressed.connect(partial(self.fill_insert_menu, table))

        btn_cancel = self.dlg_multi.findChild(QPushButton, "btn_cancel")
        btn_cancel.pressed.connect(self.dlg_multi.close)
        # self.menu=QMenu()
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


        table = "man_selector_valve"
        # self.menu_valve.clear()
        type = "VALVE"
        sql = "SELECT id FROM " + self.schema_name + ".node_type WHERE type = '" + type + "'"
        sql += " ORDER BY id"
        rows = self.controller.get_rows(sql)

        # Fill menu
        for row in rows:
            elem = row[0]
            # If not exist in table _selector_state isert to menu
            # Check if we already have data with selected id
            sql = "SELECT id FROM " + self.schema_name + "." + table + " WHERE id = '" + elem + "'"
            rows = self.controller.get_rows(sql)

            if not rows:
                # if rows == None:
                self.menu_valve.addAction(elem, partial(self.insert, elem, table))
                # self.menu.addAction(elem,self.test)


    def insert(self, id_action, table):
        ''' On action(select value from menu) execute SQL '''

        # Insert value into database
        sql = "INSERT INTO "+self.schema_name+"."+table+" (id) "
        sql+= " VALUES ('"+id_action+"')"
        self.controller.execute_sql(sql)

        self.fill_table_config(self.tbl_config, self.schema_name+"."+table)


    def fill_table_config(self, widget, table_name):
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


    def delete_records(self, widget, table_name, id) :
        ''' Delete selected elements of the table '''

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message')
            return

        del_id = []
        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            #id_ = widget.model().record(row).value("hydrometer_id")
            id_ = widget.model().record(row).value(id)
            inf_text += str(id_) + ", "
            list_id = list_id + "'" + str(id_) + "', "
            #del_id.append(str(list_id))
            del_id.append(id_)
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        answer = self.controller.ask_question("Are you sure you want to delete these records?", "Delete records",inf_text)

        if answer:
            for el in del_id:
                self.ids.remove(el)

        expr = ""
        # Reload table
        expr = str(id)+" = '" + self.ids[0] + "'"
        if len(self.ids) > 1:
            for el in range(1, len(self.ids)):
                expr += " OR "+str(id)+ "= '" + self.ids[el] + "'"

        widget.model().setFilter(expr)
        widget.model().select()


    def exec_sql(self, id_el, element):

        # delete * from anl_mincut_hydrometer
        sql = "DELETE FROM " + self.schema_name + ".anl_mincut_result_"+str(element)
        self.controller.execute_sql(sql)

        for id in self.ids:
            # Insert into anl_mincut_hydrometer all selected connecs
            sql = "INSERT INTO " + self.schema_name + ".anl_mincut_result_"+str(element)+" ("+str(id_el)+")"
            sql += " VALUES ('" + id + "')"
            status = self.controller.execute_sql(sql)

            if status:
                # Show message to user
                # message = "Values has been updated"
                # self.controller.show_info(message, context_name='ui_message')

                # Execute SQL function
                self.id = self.dlg.findChild(QLineEdit, "id")
                self.id_text = self.id.text()
                function_name = "gw_fct_mincut_result_catalog"
                sql = "SELECT " + self.schema_name + "." + function_name + "('" + self.id_text + "');"

                status = self.controller.execute_sql(sql)

        if status:
            # Show message to user
            message = "Values has been updated"
            self.controller.show_info(message, context_name='ui_message')

            message = "Execute gw_fct_mincut_result_catalog done successfully"
            self.controller.show_info(message, context_name='ui_message')


    def delete_records_config(self, widget, table_name):
        ''' Delete selected elements of the table '''

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message')
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


    def mincutInit(self):
        ''' B1-126: Automatic mincut analysis '''

        # Check if user entered ID
        check = self.check_id()
        if check == 0:
            return
        else:
            pass

        QObject.connect(self.emitPoint, SIGNAL("canvasClicked(const QgsPoint &, Qt::MouseButton)"), self.snappingNodeArc)


    def snappingNodeArc(self, point, btn):

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

                element_type = snapPoint.layer.name()
                if element_type in self.node_group:
                    feat_type = 'node'
                #else:
                #    continue

                    # Get the point
                    point = QgsPoint(snapPoint.snappedVertex)
                    snappFeat = next(snapPoint.layer.getFeatures(QgsFeatureRequest().setFilterFid(snapPoint.snappedAtGeometry)))
                    feature = snappFeat
                    element_id = feature.attribute(feat_type + '_id')

                    # LEAVE SELECTION
                    snapPoint.layer.select([snapPoint.snappedAtGeometry])

                    self.mincut(element_id,feat_type)

            for snapPoint in result:

                element_type = snapPoint.layer.name()
                if element_type in self.arc_group :
                    feat_type = 'arc'
                #else:
                #    continue

                    # Get the point
                    point = QgsPoint(snapPoint.snappedVertex)
                    snappFeat = next(snapPoint.layer.getFeatures(QgsFeatureRequest().setFilterFid(snapPoint.snappedAtGeometry)))
                    feature = snappFeat
                    element_id = feature.attribute(feat_type + '_id')

                    # LEAVE SELECTION
                    snapPoint.layer.select([snapPoint.snappedAtGeometry])

                    self.mincut(element_id,feat_type)


    def mincut(self,elem_id,elem_type):

        # Execute SQL function
        function_name = "gw_fct_mincut"
        sql = "SELECT " + self.schema_name + "." + function_name + "('" + str(elem_id) + "', '" + str(elem_type) + "', '" + self.id_text + "');"

        self.hold_elem_id = elem_id
        self.hold_elem_type = self.elem_type
        self.hold_id_text = self.id_text
        status = self.controller.execute_sql(sql)

        # Refresh map canvas
        self.iface.mapCanvas().refreshAllLayers()

        if status:
            message = "Mincut done successfully"
            self.controller.show_info(message, context_name='ui_message')

            # If mincut is done enable CustomMincut
            self.actionCustomMincut.setDisabled(False)

        # TRRIGER REPAINT
        for layerRefresh in self.iface.mapCanvas().layers():
            layerRefresh.triggerRepaint()


    def customMincatInit(self):
        ''' B2-123: Custom mincut analysis '''
        # Check if user entered ID
        check = self.check_id()
        if check == 0:
            return
        else:
            pass

        QObject.connect(self.emitPoint, SIGNAL("canvasClicked(const QgsPoint &, Qt::MouseButton)"), self.snappingValveAnalytics)


    def snappingValveAnalytics(self):
        # Set active layer
        layer = QgsMapLayerRegistry.instance().mapLayersByName("Valve analytics")[0]
        self.iface.setActiveLayer(layer)

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
                    point = QgsPoint(result[0].snappedVertex)  # @UnusedVariable
                    snappFeat = next(result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))
                    # LEAVE SELECTION
                    result[0].layer.select([result[0].snappedAtGeometry])

                    element_id = feature.attribute(feat_type + '_id')

                    self.customMincut(element_id)


    def customMincut(self,elem_id):
        ''' Init function of custom mincut - Valve analytics
        Working just with layer Valve analytics '''

        sql = "INSERT INTO " + self.schema_name + ".anl_mincut_result_valve_unaccess (mincut_result_cat_id, valve_id)"
        sql += " VALUES ('" + self.id_text + "', '" + elem_id + "')"

        status = self.controller.execute_sql(sql)
        if status:
            # Show message to user
            message = "Values has been updated"
            self.controller.show_info(message, context_name='ui_message')

        # After executing SQL call mincut action again
        # Execute SQL function
        function_name = "gw_fct_mincut"
        # Use elem id of previous element - repeatin automatic mincut
        sql = "SELECT " + self.schema_name + "." + function_name + "('" + str(self.hold_elem_id) + "', '" + str(self.hold_elem_type) + "', '" + str(self.hold_id_text) + "');"
        message = str(sql)
        self.controller.show_info(message, context_name='ui_message')
        status = self.controller.execute_sql(sql)

        # Refresh map canvas
        self.iface.mapCanvas().refreshAllLayers()

        if status:
            message = "Mincut done successfully"
            self.controller.show_info(message, context_name='ui_message')

            # If mincut is done enable CustomMincut
            self.actionCustomMincut.setDisabled(False)

        # TRRIGER REPAINT
        for layerRefresh in self.iface.mapCanvas().layers():
            layerRefresh.triggerRepaint()


    def mg_mincut_management(self):
        ''' Btn 27 - Mincut management'''

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
        row = self.controller.get_rows(sql)

        values = []
        for value in row:
            values.append(str(value[0]))

        model.setStringList(values)
        self.completer.setModel(model)
        self.txt_mincut_id.textChanged.connect(partial(self.filter_by_id, self.tbl_mincut_edit, self.txt_mincut_id, "anl_mincut_result_cat"))

        self.dlg_min_edit.btn_accept.pressed.connect(self.open_mincut)
        self.dlg_min_edit.btn_cancel.pressed.connect( self.dlg_min_edit.close)
        self.dlg_min_edit.btn_delete.clicked.connect(partial(self.delete_mincut_management, self.tbl_mincut_edit, "anl_mincut_result_cat", "id"))


        #self.btn_accept_min = self.dlg_min_edit.findChild(QPushButton, "btn_accept")
        #self.btn_accept_min.clicked.connect(self.accept_min)

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
        Fill form with selested mincut'''

        selected_list = self.tbl_mincut_edit.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message')
            return
        row = selected_list[0].row()
        # Get mincut_id from selected row
        id = self.tbl_mincut_edit.model().record(row).value("id")
        self.dlg_min_edit.close()

        self.mg_mincut()


        #TO DO-force fill form
        sql = "SELECT * FROM " + self.schema_name + ".anl_mincut_result_cat"
        sql += " WHERE id = '" + id + "'"
        rows = self.controller.get_rows(sql)

        self.id.setText(rows[0]['id'])
        self.state.setText(rows[0]['mincut_result_state_unused'])
        utils_giswater.setWidgetText("pred_description", rows[0]['anl_descript'])
        utils_giswater.setWidgetText("real_description", rows[0]['exec_descript'])
        self.distance.setText(str(rows[0]['exec_limit_distance']))
        self.depth.setText(str(rows[0]['exec_depth']))

        # from address separate street and number
        address_db = rows[0]['address_1']

        self.street.setText(address_db)
        number_db = rows[0]['address_2']
        self.number.setText(number_db)

        # Set values from mincut to comboBox
        # utils_giswater.fillComboBox("type", rows['mincut_result_type'])
        # utils_giswater.fillComboBox("cause", rows['anl_cause'])
        mincut_result_type = rows[0]['mincut_type']
        cause = rows[0]['anl_cause']
        # Clear comboBoxes
        self.type.clear()
        self.cause.clear()

        # Fill comboBoxes
        self.type.addItem(rows[0]['mincut_result_type'])
        self.cause.addItem(rows[0]['anl_cause'])


        '''
        # Fill ComboBox type
        sql = "SELECT id"
        sql += " FROM " + self.schema_name + ".anl_mincut_result_cat_type"
        sql += " ORDER BY id"
        rows = self.controller.get_rows(sql)
        # utils_giswater.fillComboBox("type", rows)
        for row in rows:
            elem = str(row[0])
            if elem != mincut_result_type:
                self.type.addItem(elem)

        # Fill ComboBox cause
        sql = "SELECT id"
        sql += " FROM " + self.schema_name + ".anl_mincut_result_cat_cause"
        sql += " ORDER BY id"
        rows = self.controller.get_rows(sql)
        # utils_giswater.fillComboBox("cause", rows)
        for row in rows:
            elem = str(row[0])
            if elem != cause:
                self.cause.addItem(elem)

        self.old_id = self.id.text()

        self.btn_start = self.dlg_mincut.findChild(QPushButton, "btn_start")
        self.btn_start.clicked.connect(self.real_start)

        self.btn_end = self.dlg_mincut.findChild(QPushButton, "btn_end")
        self.btn_end.clicked.connect(self.real_end)

        self.cbx_date_start = self.dlg_mincut.findChild(QDateEdit, "cbx_date_start")
        self.cbx_hours_start = self.dlg_mincut.findChild(QTimeEdit, "cbx_hours_start")

        self.real_description = self.dlg_mincut.findChild(QTextEdit, "real_description")
        self.distance = self.dlg_mincut.findChild(QLineEdit, "distance")
        self.depth = self.dlg_mincut.findChild(QLineEdit, "depth")

        self.btn_end.setEnabled(True)

        self.distance.setEnabled(True)
        self.depth.setEnabled(True)
        self.real_description.setEnabled(True)

        self.cbx_date_end.setEnabled(True)
        self.cbx_hours_end.setEnabled(True)
        self.cbx_date_start.setEnabled(True)
        self.cbx_hours_start.setEnabled(True)

        # Disable to edit ID
        self.id.setEnabled(False)
        '''


    def filter_by_id(self, table, widget_txt, tablename):

        #result_select = utils_giswater.getWidgetText(widget_txt)
        id = utils_giswater.getWidgetText(widget_txt)
        if id != 'null':
            expr = " id LIKE '" + id + "'"
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
            self.controller.show_warning(message, context_name='ui_message' )
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


    def set_icon(self,widget,indx):
        self.plugin_dir = os.path.dirname(__file__)[:-7]
        self.icon_folder = self.plugin_dir + '\icons'
        widget.setIcon(QIcon(self.icon_folder + "\\" + indx))