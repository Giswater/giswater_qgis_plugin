"""This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: latin-1 -*-

from functools import partial

from qgis.PyQt.QtCore import QDateTime, QDate, QTime
from qgis.PyQt.QtGui import QStandardItemModel
from qgis.PyQt.QtWidgets import QTableView, QWidget, QAbstractItemView, QLabel, QLineEdit, QGridLayout, QScrollArea, QHeaderView

from ..utils import tools_gw
from ..ui.ui_manager import GwAuditManagerUi, GwAuditUi
from ...libs import tools_qt, tools_db, tools_qgis, lib_vars


class GwAudit:

    def __init__(self):
        """Class to control toolbar 'om_ws'"""

    def open_audit_manager(self, feature_id, table_name):
        """Open Audit Manager Dialog dynamic"""
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

        self.dlg_audit_manager.tbl_audit.setSelectionBehavior(QAbstractItemView.SelectionBehavior.SelectRows)
        tools_qt.set_tableview_config(self.dlg_audit_manager.tbl_audit, sectionResizeMode=QHeaderView.ResizeMode.Interactive)

        # Connect signals
        self.dlg_audit_manager.tbl_audit.doubleClicked.connect(partial(self.open_audit))

        # Get today date
        today = QDateTime.currentDateTime()

        # Get date widget
        self.date = self.dlg_audit_manager.findChild(QWidget, "tab_none_date_to")

        # Get open date button
        self.btn_open_date = self.dlg_audit_manager.findChild(QWidget, "tab_none_btn_open_date")

        # Set today as default date and maximum date
        self.date.setDateTime(today)

        # Get first audit log date
        first_log_date = self.get_first_log_date()

        # Check the first audit log date
        if not first_log_date or first_log_date > today.date().toPyDate():
            # Disable open date button and
            self.btn_open_date.setEnabled(False)
            self.date.setEnabled(False)
        else:
            # Convert first_snapshot_date to QDateTime for widget
            q_first_snapshot_date = QDateTime(QDate(first_log_date.year, first_log_date.month, first_log_date.day), QTime(0, 0, 0))

            # Set minimum date to first snapshot date
            self.date.setMinimumDateTime(q_first_snapshot_date)

            self.date.setMaximumDateTime(today)

        # Do not allow null dates
        for widget in self.dlg_audit_manager.findChildren(tools_gw.CustomQgsDateTimeEdit):
            widget.setAllowNull(False)

        # Open dialog
        tools_gw.open_dialog(self.dlg_audit_manager, 'audit_manager')

    def get_first_log_date(self):
        """Get first snapshot date"""
        # Get the first snapshot date
        sql = f"SELECT min(tstamp)::date FROM audit.log WHERE table_name = '{self.table_name}' \
                AND feature_id = '{self.feature_id}' AND \"schema\" = '{lib_vars.schema_name}';"
        result = tools_db.get_row(sql)

        # Check if result is not None
        if result and result[0]:
            return result[0]
        else:
            return None

    def open_audit(self):
        """Open selected audit"""
        # Get selected row from table
        selected_list = self.dlg_audit_manager.tbl_audit.selectionModel().selectedRows()
        if len(selected_list) == 0:
            msg = "Any record selected"
            tools_qgis.show_warning(msg, dialog=self.dlg_audit_manager)
            return
        elif len(selected_list) > 1:
            msg = "Only one record can be selected"
            tools_qgis.show_warning(msg, dialog=self.dlg_audit_manager)
            return

        model = self.dlg_audit_manager.tbl_audit.model()
        row = selected_list[0].row()
        audit_id = model.item(row, 0)
        # Build form list in sorted order
        form = [{"logId": audit_id.text()}]
        self.fill_dialog(form)

    def fill_dialog(self, form):
        """Create and open dialog"""
        results = []
        for log_id in form:
            # Create body
            # body = {"client": {"cur_user": tools_db.current_user}, "form": {"logId": log_id}, "schema": {"parent_schema": lib_vars.schema_name}}
            body = {"client": {"cur_user": tools_db.current_user}, "form": log_id, "schema": {"parent_schema": lib_vars.schema_name}}

            # Execute procedure
            result = tools_gw.execute_procedure('gw_fct_getauditlogdata', body, schema_name='audit')
            results.append(result)

        # Create dialog
        user = tools_db.current_user
        form = {"formName": "generic", "formType": "audit"}
        body = {"client": {"cur_user": user}, "form": form}

        # DB fct
        json_result = tools_gw.execute_procedure('gw_fct_get_dialog', body)

        # Create dialog
        self.dlg_audit = GwAuditUi(self)
        tools_gw.load_settings(self.dlg_audit)

        # Manage dynamic widgets
        tools_gw.manage_dlg_widgets(self, self.dlg_audit, json_result)

        # Open dialog
        tools_gw.open_dialog(self.dlg_audit, 'audit')

        # Get layout to add widgets
        layout = self.dlg_audit.centralwidget.findChild(QScrollArea).findChild(QWidget).findChild(QGridLayout)

        # Create label headers
        label = QLabel(tools_qt.tr("Old value"))
        label.setStyleSheet("font-weight: bold;")
        layout.addWidget(label, 0, 1)

        label = QLabel(tools_qt.tr("New value"))
        label.setStyleSheet("font-weight: bold;")
        layout.addWidget(label, 0, 2)

        # Add widgets in form for each value
        done_values = []
        for result in results:
            old_data = result['olddata']
            new_data = result['newdata']

            # Check results
            if not old_data or not new_data:
                msg = "No results"
                tools_qgis.show_warning(msg, dialog=self.dlg_audit_manager)
                return

            for row, (key, new_value) in enumerate(new_data.items()):
                old_value = str(old_data.get(key, ""))
                new_value = str(new_value)

                # Check if the value has changed
                if old_value != new_value and old_value != "":
                    # Create label
                    label = QLabel(str(key))
                    label.setStyleSheet("font-weight: bold;")
                    layout.addWidget(label, row + 1, 0)

                    # Ensure that the old value is the oldest one
                    done_values.append(new_value)
                    if old_value not in done_values:
                        # Create line edit for old value
                        line_edit = QLineEdit(old_value)
                        line_edit.setEnabled(False)
                        layout.addWidget(line_edit, row + 1, 1)

                    # Create line edit for new value
                    line_edit = QLineEdit(new_value)
                    line_edit.setEnabled(False)
                    layout.addWidget(line_edit, row + 1, 2)

        # Add vertical spacer to the layout
        vertical_spacer = tools_qt.add_verticalspacer()
        final_row = layout.rowCount()
        # layout.addItem(vertical_spacer, final_row, 0, 1, 2)
        layout.addItem(vertical_spacer, final_row, 0)

    # private region

    def _fill_manager_table(self, complet_list) -> bool:
        """Fill log manager table with data from audit.log"""
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
        tools_qt.set_tableview_config(self.dlg_audit_manager.tbl_audit, edit_triggers=QTableView.EditTrigger.NoEditTriggers)

        self.dlg_audit_manager.tbl_audit.setColumnHidden(0, True)

        return True

    def _get_list(self):
        """Mount and execute the query for gw_fct_getlist"""
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
    """Close dialog"""
    tools_gw.close_dialog(kwargs["dialog"])


def open(**kwargs):
    """Open audit"""
    kwargs["class"].open_audit()


def open_date(**kwargs):
    """Open audit in selected date"""
    class_obj = kwargs["class"]
    query = f"""SELECT id FROM audit.log WHERE tstamp::date = '{class_obj.date.dateTime().toString('yyyy-MM-dd')}' AND \"schema\" = '{lib_vars.schema_name}' AND feature_id = '{class_obj.feature_id}' ORDER BY tstamp ASC"""
    rows = tools_db.get_rows(query)

    form = []
    if rows:
        for row in rows:
            form.append({"logId": row[0]})

    class_obj.fill_dialog(form)
