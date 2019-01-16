# -*- coding: utf-8 -*-
"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""


from PyQt4.QtCore import QDate, Qt
from PyQt4.QtCore import QModelIndex
from PyQt4.QtGui import QBrush
from PyQt4.QtGui import QColor
from PyQt4.QtGui import QCompleter, QLineEdit, QTableView, QStringListModel, QComboBox, QAction, QAbstractItemView
from functools import partial

from PyQt4.QtGui import QPalette
from PyQt4.QtGui import QStandardItem
from PyQt4.QtGui import QStandardItemModel
from PyQt4.QtGui import QStyledItemDelegate
from PyQt4.QtGui import QTableWidgetItem
from PyQt4.QtSql import QSqlQueryModel, QSqlTableModel

import utils_giswater
from datetime import datetime
from giswater.actions.multiple_selection import MultipleSelection
from giswater.actions.parent_manage import ParentManage
from giswater.ui_manager import AddLot
from giswater.ui_manager import VisitManagement

from actions.CustomModel import CustomSqlModel


class AddNewLot(ParentManage):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'Add basic visit' of toolbar 'edit' """
        ParentManage.__init__(self, iface, settings, controller, plugin_dir)
        self.ids = []


    def manage_lot(self, lot_id=None, is_new=True, feature_type=None):
        # turnoff autocommit of this and base class. Commit will be done at dialog button box level management
        self.autocommit = True
        self.remove_ids = False
        self.is_new_lot = is_new
        # Get layers of every geom_type
        self.reset_lists()
        self.reset_layers()
        self.layers['arc'] = [self.controller.get_layer_by_tablename('v_edit_arc')]
        self.layers['node'] = [self.controller.get_layer_by_tablename('v_edit_node')]
        self.layers['connec'] = [self.controller.get_layer_by_tablename('v_edit_connec')]

        # Remove 'gully' for 'WS'
        if self.controller.get_project_type() != 'ws':
            self.layers['gully'] = self.controller.get_group_layers('gully')

        self.dlg_lot = AddLot()
        self.load_settings(self.dlg_lot)
        self.dlg_lot.open()

        # Set icons
        self.set_icon(self.dlg_lot.btn_feature_insert, "111")
        self.set_icon(self.dlg_lot.btn_feature_delete, "112")
        self.set_icon(self.dlg_lot.btn_feature_snapping, "137")
        self.set_icon(self.dlg_lot.btn_expr_filter, "204")

        self.lot_id = self.dlg_lot.findChild(QLineEdit, "lot_id")
        self.id_val = self.dlg_lot.findChild(QLineEdit, "txt_idval")
        self.user_name = self.dlg_lot.findChild(QLineEdit, "user_name")
        self.visit_class = self.dlg_lot.findChild(QComboBox, "visit_class")

        # Tab 'Relations'
        self.feature_type = self.dlg_lot.findChild(QComboBox, "feature_type")
        self.tbl_relation = self.dlg_lot.findChild(QTableView, "tbl_relation")

        self.set_selectionbehavior(self.dlg_lot)

        # Fill QWidgets of the form
        self.fill_fields()
        # TODO populate Qtable visits
        new_lot_id = lot_id
        if lot_id is None:
            new_lot_id = self.get_next_id('om_visit_lot', 'id')
        utils_giswater.setWidgetText(self.dlg_lot, self.lot_id, new_lot_id)

        self.geom_type = self.feature_type.currentText().lower()
        viewname = "v_edit_" + self.geom_type
        self.set_completer_feature_id(self.dlg_lot.feature_id, self.geom_type, viewname)

        self.event_feature_type_selected(self.dlg_lot)
        self.clear_selection()

        if lot_id is not None:
            utils_giswater.setWidgetText(self.dlg_lot, self.feature_type, feature_type.upper())
            self.geom_type = self.feature_type.currentText().lower()
            self.set_values(lot_id)
            self.populate_table(lot_id)
            self.update_id_list()
        self.enable_feature_type(self.dlg_lot)
        # Set signals
        self.feature_type.currentIndexChanged.connect(partial(self.event_feature_type_selected, self.dlg_lot))
        self.dlg_lot.btn_expr_filter.clicked.connect(partial(self.open_expression, self.dlg_lot, self.feature_type, layer_name=None))
        self.dlg_lot.btn_feature_insert.clicked.connect(partial(self.insert_row))
        self.dlg_lot.btn_feature_delete.clicked.connect(partial(self.remove_selection, self.dlg_lot, self.tbl_relation))
        self.dlg_lot.btn_feature_snapping.clicked.connect(partial(self.set_active_layer, self.dlg_lot, self.feature_type, layer_name=None))
        self.dlg_lot.btn_feature_snapping.clicked.connect(partial(self.selection_init, self.dlg_lot))
        self.dlg_lot.btn_cancel.clicked.connect(partial(self.manage_rejected))
        self.dlg_lot.rejected.connect(partial(self.manage_rejected))
        self.dlg_lot.btn_accept.clicked.connect(partial(self.save_lot))
        self.dlg_lot.btn_accept.clicked.connect(partial(self.manage_rejected))

        # Set autocompleters of the form
        self.set_completers()

        # p = self.dlg_lot.tbl_relation.palette()
        # p.setColor(QPalette.Base, QColor("yellow"))
        # self.dlg_lot.tbl_relation.setPalette(p)
        # Open the dialog
        self.open_dialog(self.dlg_lot, dlg_name="add_lot")


    def fill_fields(self):
        """ Fill combo boxes of the form """
        # Visit tab
        # Set current date and time
        current_date = QDate.currentDate()
        self.dlg_lot.startdate.setDate(current_date)
        self.dlg_lot.enddate.setDate(current_date)

        # Set current user
        sql = "SELECT current_user"
        row = self.controller.get_row(sql, commit=self.autocommit)
        utils_giswater.setWidgetText(self.dlg_lot, self.user_name, row[0])

        # Fill ComboBox cmb_visit_class
        sql = ("SELECT id, idval"
               " FROM " + self.schema_name + ".om_visit_class"
               " ORDER BY idval")
        self.visitclass_ids = self.controller.get_rows(sql, commit=self.autocommit)
        if self.visitclass_ids:
            utils_giswater.set_item_data(self.dlg_lot.cmb_visit_class, self.visitclass_ids, 1)

        # Fill ComboBox cmb_assigned_to
        sql = ("SELECT id, name"
               " FROM " + self.schema_name + ".cat_users"
               " ORDER BY name")
        self.users = self.controller.get_rows(sql, commit=self.autocommit)
        if self.users:
            utils_giswater.set_item_data(self.dlg_lot.cmb_assigned_to, self.users, 1)

        # Relations tab
        # fill feature_type
        sql = ("SELECT id, id"
               " FROM " + self.schema_name + ".sys_feature_type"
               " WHERE net_category = 1"
               " ORDER BY id")
        feature_type = self.controller.get_rows(sql, log_sql=False, commit=self.autocommit)
        if feature_type:
            utils_giswater.set_item_data(self.dlg_lot.feature_type, feature_type, 1)


    def get_next_id(self, table_name, pk):
        sql = ("SELECT max("+pk+"::integer) FROM " + self.schema_name + "."+table_name+";")
        row = self.controller.get_row(sql, log_sql=False)
        if not row or not row[0]:
            return 0
        else:
            return row[0]+1


    def event_feature_type_selected(self, dialog):
        """Manage selection change in feature_type combo box.
        THis means that have to set completer for feature_id QTextLine and
        setup model for features to select table."""

        # 1) set the model linked to selecte features
        # 2) check if there are features related to the current visit
        # 3) if so, select them => would appear in the table associated to the model
        self.geom_type = self.feature_type.currentText().lower()

        viewname = "v_edit_" + self.geom_type
        self.set_completer_feature_id(dialog.feature_id, self.geom_type, viewname)

        # set table model and completer
        # set a fake where expression to avoid to set model to None
        # fake_filter = '{}_id IN ("-1")'.format(self.geom_type)
        # self.set_table_model(dialog, self.tbl_relation, self.geom_type, fake_filter)

        self.set_headers(self.tbl_relation)

    def clear_selection(self, remove_groups=True):
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

        try:
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
        except:
            pass

        self.canvas.refresh()


    def set_values(self, lot_id):
        sql = ("SELECT * FROM " + self.schema_name + ".om_visit_lot "
               " WHERE id ='"+str(lot_id)+"'")
        lot = self.controller.get_row(sql, log_sql=False)
        if lot is not None:
            utils_giswater.setWidgetText(self.dlg_lot, 'txt_idval', lot['idval'])
            utils_giswater.setCalendarDate(self.dlg_lot, 'startdate', lot['startdate'])
            utils_giswater.setCalendarDate(self.dlg_lot, 'enddate', lot['enddate'])
            utils_giswater.set_combo_itemData(self.dlg_lot.cmb_visit_class, lot['visitclass_id'], 0)
            utils_giswater.set_combo_itemData(self.dlg_lot.cmb_assigned_to, lot['assigned_to'], 0)
            utils_giswater.setWidgetText(self.dlg_lot, 'descript', lot['descript'])
            utils_giswater.setChecked(self.dlg_lot, 'chk_active', lot['active'])
            utils_giswater.set_combo_itemData(self.dlg_lot.feature_type, lot['feature_type'], 0)
        feature_type = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.feature_type, 1).lower()
        table_name = "v_edit_" + str(feature_type)

        self.set_headers(self.tbl_relation)
        self.set_table_columns(self.dlg_lot, self.dlg_lot.tbl_relation, table_name)


    def set_headers(self, qtable):
        feature_type = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.feature_type, 1).lower()
        columns_name = self.controller.get_columns_list('om_visit_lot_x_' + str(feature_type))
        standar_model = QStandardItemModel()
        qtable.setModel(standar_model)
        qtable.horizontalHeader().setStretchLastSection(True)

        # # Get headers
        headers = []
        self.controller.log_info(str(columns_name))
        for x in columns_name:
            headers.append(x[0])
        # Set headers
        standar_model.setHorizontalHeaderLabels(headers)


    def populate_table(self, lot_id):
        standar_model = self.tbl_relation.model()
        feature_type = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.feature_type, 1).lower()
        sql = ("SELECT * FROM " + self.schema_name + ".om_visit_lot_x_" + str(feature_type) + ""
               " WHERE lot_id ='"+str(lot_id)+"'")
        rows = self.controller.get_rows(sql, log_sql=False)
        for row in rows:
            item = []
            for value in row:
                item.append(QStandardItem(str(value)))
            if len(row) > 0:
                standar_model.appendRow(item)


    def update_id_list(self):
        feature_type = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.feature_type, 1).lower()
        list_ids = self.get_table_values(self.tbl_relation, feature_type)
        for id_ in list_ids:
            if id_ not in self.ids:
                self.ids.append(id_)


    def get_table_values(self, qtable, geom_type):
        column_index = utils_giswater.get_col_index_by_col_name(qtable, geom_type+'_id')
        model = qtable.model()
        id_list = []
        for i in range(0, model.rowCount()):
            i = model.index(i, column_index)
            id_list.append(i.data())
        return id_list


    def open_expression(self, dialog, widget, layer_name=None):
        self.set_active_layer(dialog, widget, layer_name)
        self.disconnect_signal_selection_changed()
        self.iface.mainWindow().findChild(QAction, 'mActionSelectByExpression').triggered.connect(
            partial(self.selection_changed_by_expr, dialog, self.layer_lot, self.geom_type))
        self.iface.mainWindow().findChild(QAction, 'mActionSelectByExpression').trigger()


    def selection_changed_by_expr(self, dialog, layer, geom_type):
        # "arc_id" = '2020'
        self.canvas.selectionChanged.connect(partial(self.manage_selection, dialog,  layer, geom_type))


    def manage_selection(self, dialog, layer, geom_type):
        """ Slot function for signal 'canvas.selectionChanged' """
        field_id = geom_type + "_id"
        # Iterate over layer
        if layer.selectedFeatureCount() > 0:
            # Get selected features of the layer
            features = layer.selectedFeatures()
            for feature in features:
                # Append 'feature_id' into the list
                selected_id = feature.attribute(field_id)
                if selected_id not in self.ids:
                    self.ids.append(selected_id)

        self.reload_table()
        self.enable_feature_type(dialog)


    def reload_table(self):
        """ Reload @widget with contents of @tablename applying selected @expr_filter """
        standar_model = self.tbl_relation.model()
        feature_type = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.feature_type, 1).lower()
        lot_id = utils_giswater.getWidgetText(self.dlg_lot, self.lot_id)
        id_list = self.get_table_values(self.tbl_relation, feature_type)

        for id_ in self.ids:
            item = []
            self.controller.log_info(str(id_))
            if id_ not in id_list:
                row = []
                item.append(lot_id)
                item.append(id_)
                item.append(0)
                for value in item:
                    row.append(QStandardItem(str(value)))

                if len(row) > 0:
                    standar_model.appendRow(row)


    def insert_row(self):
        feature_id = utils_giswater.getWidgetText(self.dlg_lot, self.dlg_lot.feature_id)
        lot_id = utils_giswater.getWidgetText(self.dlg_lot, self.lot_id)
        standar_model = self.tbl_relation.model()


        if feature_id not in self.ids:
            item = []
            item.append(lot_id)
            item.append(feature_id)
            item.append(0)
            row = []
            for value in item:
                row.append(QStandardItem(str(value)))
            if len(row) > 0:
                standar_model.appendRow(row)
                self.ids.append(feature_id)


    def remove_selection(self, dialog, qtable):
        self.disconnect_signal_selection_changed()
        feature_type = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.feature_type, 0).lower()
        # Get selected rows
        index_list = qtable.selectionModel().selectedRows()
        index = index_list[0]

        if len(index_list) == 0:
            message = "Any record selected"
            self.controller.show_info_box(message)
            return
        model = qtable.model()


        for i in range(len(index_list)-1, -1, -1):

            row = index_list[i].row()
            column_index = utils_giswater.get_col_index_by_col_name(qtable, feature_type + '_id')
            feature_id = index.sibling(row, column_index).data()
            self.ids.remove(feature_id)
            model.takeRow(row)

        self.enable_feature_type(dialog)

    def set_active_layer(self,  dialog, widget, layer_name=None):
        self.current_layer = self.iface.activeLayer()
        # Set active layer
        if layer_name is None:
            layer_name = 'v_edit_' + utils_giswater.get_item_data(dialog, widget, 0).lower()

        viewname = layer_name
        self.layer_lot = self.controller.get_layer_by_tablename(viewname)
        self.iface.setActiveLayer(self.layer_lot)
        self.iface.legendInterface().setLayerVisible(self.layer_lot, True)


    def selection_init(self, dialog):
        """ Set canvas map tool to an instance of class 'MultipleSelection' """
        self.disconnect_signal_selection_changed()
        self.iface.actionSelect().trigger()
        self.connect_signal_selection_changed(dialog)

    def connect_signal_selection_changed(self, dialog):
        """ Connect signal selectionChanged """

        try:
            self.canvas.selectionChanged.connect(partial(self.manage_selection, dialog,  self.layer_lot, self.geom_type))

        except Exception:
            pass





    def manage_rejected(self):
        self.disconnect_signal_selection_changed()
        self.close_dialog(self.dlg_lot)







    def save_lot(self):
        lot = {}
        lot['idval'] = utils_giswater.getWidgetText(self.dlg_lot, 'txt_idval', False, False)
        lot['startdate'] = utils_giswater.getCalendarDate(self.dlg_lot, 'startdate')
        lot['enddate'] = utils_giswater.getCalendarDate(self.dlg_lot, 'enddate')
        lot['visitclass_id'] = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.cmb_visit_class, 0)
        lot['descript'] = utils_giswater.getWidgetText(self.dlg_lot, 'descript', False, False)
        lot['active'] = utils_giswater.isChecked(self.dlg_lot, 'chk_active')
        lot['feature_type'] = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.feature_type, 0).lower()
        lot['assigned_to'] = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.cmb_assigned_to, 0)
        keys = ""
        values = ""

        for key, value in lot.items():
            if value != '':
                keys += ""+key+", "
                if type(value) in (int, bool):
                    values += "$$"+str(value)+"$$, "
                else:
                    values += "$$" + value + "$$, "
        keys = keys[:-2]
        values = values[:-2]

        if self.is_new_lot is True:
            sql = ("INSERT INTO " + self.schema_name + ".om_visit_lot("+keys+") "
                   " VALUES (" + values + ") RETURNING id")
            row = self.controller.execute_returning(sql, log_sql=False)
            _id = row[0]
        else:
            _id = utils_giswater.getWidgetText(self.dlg_lot, 'lot_id', False, False)

        sql = ("DELETE FROM " + self.schema_name + ".om_visit_lot_x_"+lot['feature_type'] + " "
               " WHERE lot_id = '"+str(_id)+"';")

        id_list = self.get_table_values(self.tbl_relation, lot['feature_type'])

        for x in range(0, len(id_list)):
            sql += ("INSERT INTO " + self.schema_name + ".om_visit_lot_x_"+lot['feature_type'] + " "
                    "(lot_id, "+lot['feature_type']+"_id, status)"
                    " VALUES('" + str(_id) + "', '" + str(id_list[x]) + "', '0'); \n")
        self.controller.execute_sql(sql, log_sql=False)






















        # Attach model to table view

    # def fill_custom_model(self, widget, table_name, expr_filter=None):
    #     """ Set a model with selected filter. Attach that model to selected table """
    #     if self.schema_name not in table_name:
    #         table_name = self.schema_name + "." + table_name
    #     # Set model
    #
    #     model = CustomSqlModel()
    #     model.setTable(table_name)
    #     model.setEditStrategy(QSqlTableModel.OnManualSubmit)
    #     model.sort(0, 1)
    #     if expr_filter:
    #         model.setFilter(expr_filter)
    #     model.select()
    #
    #     # Check for errors
    #     if model.lastError().isValid():
    #         self.controller.show_warning(model.lastError().text())
    #
    #     # Attach model to table view
    #     widget.setModel(model)


    def set_completers(self):
        """ Set autocompleters of the form """

        # Adding auto-completion to a QLineEdit - lot_id
        self.completer = QCompleter()
        self.dlg_lot.lot_id.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".om_visit"
        rows = self.controller.get_rows(sql, commit=self.autocommit)
        values = []
        if rows:
            for row in rows:
                values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)


    def lot_manager(self):
        """ Button 75: Lot manager """

        # Create the dialog
        self.dlg_lot_man = VisitManagement()
        self.load_settings(self.dlg_lot_man)
        self.dlg_lot_man.setWindowTitle("Lot management")
        self.dlg_lot_man.lbl_filter.setText('Filter by idval: ')
        self.dlg_lot_man.btn_open.setText('Open lot')
        self.dlg_lot_man.btn_delete.setText('Delete lot')
        # save previous dialog and set new one.
        # previous dialog will be set exiting the current one
        # self.previous_dialog = utils_giswater.dialog()
        self.dlg_lot_man.tbl_visit.setSelectionBehavior(QAbstractItemView.SelectRows)

        # Set a model with selected filter. Attach that model to selected table
        table_object = "om_visit_lot"
        self.fill_table_object(self.dlg_lot_man.tbl_visit, self.schema_name + "." + table_object)
        self.set_table_columns(self.dlg_lot_man, self.dlg_lot_man.tbl_visit, table_object)


        # manage save and rollback when closing the dialog
        self.dlg_lot_man.rejected.connect(partial(self.close_dialog, self.dlg_lot_man))
        self.dlg_lot_man.accepted.connect(partial(self.open_lot, self.dlg_lot_man, self.dlg_lot_man.tbl_visit, table_object))

        # Set dignals
        self.dlg_lot_man.tbl_visit.doubleClicked.connect(partial(self.open_lot, self.dlg_lot_man, self.dlg_lot_man.tbl_visit))
        self.dlg_lot_man.btn_open.clicked.connect(partial(self.open_lot, self.dlg_lot_man, self.dlg_lot_man.tbl_visit))
        self.dlg_lot_man.btn_delete.clicked.connect(partial(self.delete_lot, self.dlg_lot_man.tbl_visit))
        self.dlg_lot_man.txt_filter.textChanged.connect(partial(self.filter_lot, self.dlg_lot_man, self.dlg_lot_man.tbl_visit, self.dlg_lot_man.txt_filter))

        # set timeStart and timeEnd as the min/max dave values get from model
        current_date = QDate.currentDate()
        sql = ("SELECT MIN(startdate), MAX(enddate)"
               " FROM {}.{}".format(self.schema_name, table_object))
        row = self.controller.get_row(sql, log_info=True, commit=self.autocommit)

        if row:
            if row[0]:
                self.dlg_lot_man.date_event_from.setDate(row[0])
            if row[1]:
                self.dlg_lot_man.date_event_to.setDate(row[1])
            else:
                self.dlg_lot_man.date_event_to.setDate(current_date)

        # set date events
        self.dlg_lot_man.date_event_from.dateChanged.connect(
            partial(self.filter_lot, self.dlg_lot_man, self.dlg_lot_man.tbl_visit, self.dlg_lot_man.txt_filter))
        self.dlg_lot_man.date_event_to.dateChanged.connect(
            partial(self.filter_lot, self.dlg_lot_man, self.dlg_lot_man.tbl_visit, self.dlg_lot_man.txt_filter))

        # Open form
        self.open_dialog(self.dlg_lot_man, dlg_name="visit_management")

    def delete_lot(self, qtable):
        selected_list = qtable.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        for x in range(0, len(selected_list)):
            row = selected_list[x].row()
            _id = qtable.model().record(row).value('id')
            feature_type = qtable.model().record(row).value('feature_type')
            sql = ("DELETE FROM " + self.schema_name + ".om_visit_lot_x_" + str(feature_type) + " "
                   " WHERE lot_id = '" + str(_id) + "'; \n "
                   "DELETE FROM " + self.schema_name + ".om_visit_lot "
                   " WHERE id ='"+str(_id)+"'")
            self.controller.execute_sql(sql, log_sql=False)
        self.filter_lot(self.dlg_lot_man, self.dlg_lot_man.tbl_visit, self.dlg_lot_man.txt_filter)


    def open_lot(self, dialog, widget):
        """ Open object form with selected record of the table """

        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        row = selected_list[0].row()

        # Get object_id from selected row
        selected_object_id = widget.model().record(row).value('id')
        feature_type = widget.model().record(row).value('feature_type')

        # Close this dialog and open selected object
        dialog.close()

        # set previous dialog
        # if hasattr(self, 'previous_dialog'):
        self.manage_lot(selected_object_id, feature_type=feature_type)

    def filter_lot(self, dialog, widget_table, widget_txt):
        """ Filter om_visit in self.dlg_lot_man.tbl_visit based on (id AND text AND between dates)"""
        object_id = utils_giswater.getWidgetText(dialog, widget_txt)
        visit_start = dialog.date_event_from.date()
        visit_end = dialog.date_event_to.date()

        if visit_start > visit_end:
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return

        # Create interval dates
        format_low = 'yyyy-MM-dd 00:00:00.000'
        format_high = 'yyyy-MM-dd 23:59:59.999'
        interval = "'{}'::timestamp AND '{}'::timestamp".format(
            visit_start.toString(format_low), visit_end.toString(format_high))

        expr_filter = ("(startdate BETWEEN {0}) AND (enddate BETWEEN {0} or enddate is null)".format(interval))
        if object_id != 'null':
            expr_filter += " AND idval::TEXT ILIKE '%" + str(object_id) + "%'"

        # Refresh model with selected filter
        widget_table.model().setFilter(expr_filter)
        widget_table.model().select()


