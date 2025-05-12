"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: latin-1 -*-

from functools import partial
from qgis.PyQt.QtCore import QDateTime
from qgis.PyQt.QtGui import QStandardItemModel
from ..utils import tools_gw
from ..ui.ui_manager import GwAuditManagerUi, GwAuditUi
from ...libs import tools_qt, tools_db, tools_qgis
from qgis.PyQt.QtWidgets import QTableView, QWidget, QAbstractItemView, QLabel, QLineEdit, QGridLayout, QScrollArea


class GwAudit:

    def __init__(self):
        """ Class to control toolbar 'om_ws' """
        pass

    def open_audit_manager(self, feature_id, table_name):
        """ Open Audit Manager Dialog dynamic """

        self.feature_id = feature_id
        self.table_name = table_name

        user = tools_db.current_user
        form = {"formName": "generic", "formType": "audit_manager"}
        body = {"client": {"cur_user": user}, "form": form}

        # DB fct
        json_result = tools_gw.execute_procedure('gw_fct_get_dialog', body)

        # Create and open dialog
        self.dlg_audit_manager = GwAuditManagerUi(self)
        tools_gw.load_settings(self.dlg_audit_manager)
        tools_gw.manage_dlg_widgets(self, self.dlg_audit_manager, json_result)

        # Get logs from db
        complet_list = self._get_list()

        if not complet_list or complet_list['body']['data']['fields'][0]['value'] is None:
            # Show warning
            msg = "This feature has no log changes, please update this feature before."
            tools_qgis.show_warning(msg)
            return

        # Fill audit table
        self._fill_manager_table(complet_list)

        self.dlg_audit_manager.tbl_audit.setSelectionBehavior(QAbstractItemView.SelectRows)
        tools_qt.set_tableview_config(self.dlg_audit_manager.tbl_audit, sectionResizeMode=0)

        # Connect signals
        self.dlg_audit_manager.tbl_audit.doubleClicked.connect(partial(self.open_audit))

        # Set calendar options
        self.date = self.dlg_audit_manager.findChild(QWidget, "tab_none_date_to")
        self.date.setDateTime(QDateTime.currentDateTime())
        self.date.setMaximumDateTime(QDateTime.currentDateTime())

        # Open dialog
        tools_gw.open_dialog(self.dlg_audit_manager, 'audit_manager')

    def open_audit(self):
        """ Open selected audit """

        # Get selected row from table
        selected_list = self.dlg_audit_manager.tbl_audit.selectionModel().selectedRows()
        if len(selected_list) == 0:
            msg = "Any record selected"
            tools_qgis.show_warning(msg, dialog=self.dlg_audit_manager)
            return
        row = selected_list[0].row()

        model = self.dlg_audit_manager.tbl_audit.model()
        audit_id = model.item(row, 0)
        self.fill_dialog({"logId": audit_id.text()})

    def fill_dialog(self, form):
        """ Create and open dialog """

        # Create body
        body = {"client": {"cur_user": tools_db.current_user}, "form": form}

        # Execute procedure
        result = tools_gw.execute_procedure('gw_fct_getauditlogdata', body, schema_name='audit')
        old_data = result['olddata']
        new_data = result['newdata']

        # Check results
        if not old_data or not new_data:
            msg = "No results"
            tools_qgis.show_warning(msg, dialog=self.dlg_audit_manager)
            return

        # Create dialog
        user = tools_db.current_user
        form = {"formName": "generic", "formType": "audit"}
        body = {"client": {"cur_user": user}, "form": form}

        # DB fct
        json_result = tools_gw.execute_procedure('gw_fct_get_dialog', body)

        self.dlg_audit = GwAuditUi(self)
        tools_gw.load_settings(self.dlg_audit)
        tools_gw.manage_dlg_widgets(self, self.dlg_audit, json_result)
        tools_gw.open_dialog(self.dlg_audit, 'audit')

        # Get layouts
        layout = self.dlg_audit.centralwidget.findChild(QScrollArea).findChild(QWidget).findChild(QGridLayout)

        # Add widgets in form for each value
        for row, (key, new_value) in enumerate(new_data.items()):
            old_value = old_data.get(key, "")

            # Check if the value has changed
            if str(old_value) != str(new_value):
                # Create label
                label = QLabel(str(key))
                layout.addWidget(label, row, 0)

                # Create line edit for old value
                line_edit = QLineEdit(str(old_value) + " (old)")
                line_edit.setEnabled(False)
                line_edit.setStyleSheet("color: orange;")
                layout.addWidget(line_edit, row, 1)

                # Create line edit for new value
                line_edit = QLineEdit(str(new_value) + " (new)")
                line_edit.setEnabled(False)
                layout.addWidget(line_edit, row, 2)

        # Add vertical spacer to the layout
        vertical_spacer = tools_qt.add_verticalspacer()
        final_row = layout.rowCount()
        # layout.addItem(vertical_spacer, final_row, 0, 1, 2)
        layout.addItem(vertical_spacer, final_row , 0)

    # private region

    def _fill_manager_table(self, complet_list)-> bool:
        """ Fill log manager table with data from audit.log """

        if complet_list is False:
            return False

        for field in complet_list['body']['data']['fields']:
            if field.get('hidden'):
                continue
            model = self.dlg_audit_manager.tbl_audit.model()
            if model is None:
                model = QStandardItemModel()
                self.dlg_audit_manager.tbl_audit.setModel(model)
            model.removeRows(0, model.rowCount())

            # Check if has data
            if field['value']:
                self.dlg_audit_manager.tbl_audit = tools_gw.add_tableview_header(self.dlg_audit_manager.tbl_audit, field)
                self.dlg_audit_manager.tbl_audit = tools_gw.fill_tableview_rows(self.dlg_audit_manager.tbl_audit, field)

        tools_gw.set_tablemodel_config(self.dlg_audit_manager, self.dlg_audit_manager.tbl_audit, 'audit_results')
        tools_qt.set_tableview_config(self.dlg_audit_manager.tbl_audit, edit_triggers=QTableView.NoEditTriggers)

        self.dlg_audit_manager.tbl_audit.setColumnHidden(0, True)

        return True

    def _get_list(self):
        """ Mount and execute the query for gw_fct_getlist """

        feature = '"tableName":"audit_results"'
        filter_fields = f""""limit": -1, 
                        "feature_id": {{"filterSign":"=", "value":"{self.feature_id}"}},
                        "table_name": {{"filterSign":"=", "value":"{self.table_name}"}}
                        """
        page_info = '"pageInfo":{"orderBy":"tstamp", "orderType":"DESC"}'

        # Create json body
        body = tools_gw.create_body(feature=feature, filter_fields=filter_fields, extras=page_info)
        json_result = tools_gw.execute_procedure('gw_fct_getlist', body)
        if json_result is None or json_result['status'] == 'Failed':
            return False

        return json_result

    # end private region


def close_dlg(**kwargs):
    """ Close dialog """

    tools_gw.close_dialog(kwargs["dialog"])


def open(**kwargs):
    """ Open audit """

    kwargs["class"].open_audit()


def open_date(**kwargs):
    """ Open audit in selected date """

    this = kwargs["class"]

    form = {
        "date": this.date.dateTime().toString("yyyy-MM-dd"),
        "featureId": this.feature_id,
        "tableName": this.table_name
    }

    this.fill_dialog(form)


