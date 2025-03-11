"""
This file is part of Giswater 4
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: latin-1 -*-
import operator
from functools import partial

from qgis.PyQt.QtGui import QStandardItemModel
from ..utils import tools_gw
from ..ui.ui_manager import GwAuditManagerUi, GwAuditUi
from ...libs import tools_qt, tools_log, tools_db, tools_qgis
from qgis.PyQt.QtWidgets import QTableView, QWidget, QAbstractItemView, QLabel, QLineEdit, QGridLayout, QScrollArea
import json
class GwAudit:

    def __init__(self):
        """ Class to control toolbar 'om_ws' """
        pass


    def open_audit_manager(self, feature_id):
        """ Open Audit Manager Dialog dynamic """

        user = tools_db.current_user
        form = { "formName" : "generic", "formType" : "audit_manager" }
        body = { "client" : { "cur_user": user }, "form" : form }

        # db fct
        json_result = tools_gw.execute_procedure('gw_fct_get_dialog', body)

        # Create and open dialog
        self.dlg_audit_manager = GwAuditManagerUi(self)
        tools_gw.load_settings(self.dlg_audit_manager)
        tools_gw.manage_dlg_widgets(self, self.dlg_audit_manager, json_result)
        tools_gw.open_dialog(self.dlg_audit_manager, 'audit_manager')

        # fill audit table
        self._fill_manager_table(feature_id)

        self.dlg_audit_manager.tbl_audit.setSelectionBehavior(QAbstractItemView.SelectRows)
        tools_qt.set_tableview_config(self.dlg_audit_manager.tbl_audit, sectionResizeMode=0)

        # connect signals
        self.dlg_audit_manager.tbl_audit.doubleClicked.connect(partial(self.open_audit))


    def open_audit(self):
        """ Open selected audit """

        # Get selected row from table
        selected_list = self.dlg_audit_manager.tbl_audit.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.dlg_psector_mng)
            return
        row = selected_list[0].row()

        model = self.dlg_audit_manager.tbl_audit.model()
        audit_id = model.item(row, 0)

        # Create and open dialog
        self.dlg_audit = GwAuditUi(self)
        tools_gw.load_settings(self.dlg_audit)
        tools_gw.open_dialog(self.dlg_audit, 'audit')

        # get json data
        sql = f"SELECT olddata, newdata FROM audit.log WHERE id = {audit_id.text()};"
        result = tools_db.dao.execute_returning(sql)

        if result:
            # get layouts
            layout = self.dlg_audit.centralwidget.findChild(QScrollArea).findChild(QWidget).findChild(QGridLayout)

            # add widgets in form for each value
            row = 0
            for old_data, new_data in zip(result[0].items(), result[1].items()):
                # create widgets
                label = QLabel(str(old_data[0]))
                line_edit = QLineEdit(str(old_data[1]))

                # check if previous data is diferent from the current
                if str(old_data[1]) != str(new_data[1]):
                    line_edit.setStyleSheet("color: orange;")

                line_edit.setEnabled(False)
                layout.addWidget(label, row, 0)
                layout.addWidget(line_edit, row, 1)
                row += 1
        else:
            tools_gw.close_dialog(self.dlg_audit)
            tools_qgis.show_warning("No results", dialog=self.dlg_audit_manager)



    # private region

    def _fill_manager_table(self, feature_id=None):
        """ Fill dscenario manager table with data from v_edit_cat_dscenario """

        complet_list = self._get_list(feature_id)

        if complet_list is False:
            return False, False
        for field in complet_list['body']['data']['fields']:
            if field.get('hidden'):
                continue
            model = self.dlg_audit_manager.tbl_audit.model()
            if model is None:
                model = QStandardItemModel()
                self.dlg_audit_manager.tbl_audit.setModel(model)
            model.removeRows(0, model.rowCount())

            if field['value']:
                self.dlg_audit_manager.tbl_audit = tools_gw.add_tableview_header(self.dlg_audit_manager.tbl_audit, field)
                self.dlg_audit_manager.tbl_audit = tools_gw.fill_tableview_rows(self.dlg_audit_manager.tbl_audit, field)

        tools_gw.set_tablemodel_config(self.dlg_audit_manager, self.dlg_audit_manager.tbl_audit, 'audit_results')
        tools_qt.set_tableview_config(self.dlg_audit_manager.tbl_audit, edit_triggers=QTableView.NoEditTriggers)

        return complet_list

    def _get_list(self, feature_id=None):
        """ Mount and execute the query for gw_fct_getlist """

        feature = f'"tableName":"audit_results"'
        filter_fields = f'"limit": -1'
        if feature_id:
            filter_fields += f', "feature_id": {{"filterSign":"ILIKE", "value":"{feature_id}"}}'

        page_info = f'"pageInfo":{{"orderBy":"tstamp", "orderType":"DESC"}}'
        body = tools_gw.create_body(feature=feature, filter_fields=filter_fields, extras=page_info)
        json_result = tools_gw.execute_procedure('gw_fct_getlist', body)
        if json_result is None or json_result['status'] == 'Failed':
            return False
        complet_list = json_result
        if not complet_list:
            return False

        return complet_list

    # end private region


def close_dlg(**kwargs):
    """ Close form """

    dialog = kwargs["dialog"]
    tools_gw.close_dialog(dialog)
