"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtWidgets import (
    QAbstractItemView,
    QMenu,
    QAction,
    QActionGroup,
    QTableView,
    QCompleter,
)
from qgis.PyQt.QtCore import QStringListModel, Qt
from qgis.PyQt.QtSql import QSqlRelation, QSqlRelationalTableModel

from .priority_btn import CalculatePriority
from ...ui.ui_manager import GwPriorityUi, GwPriorityManagerUi, GwStatusSelectorUi

from ....libs import lib_vars, tools_db, tools_qgis, tools_os, tools_qt
from ...utils import tools_gw
from ..dialog import GwAction

from .... import global_vars


class GwResultManagerButton(GwAction):
    """ """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.iface = global_vars.iface

        self.icon_path = icon_path
        self.action_name = action_name
        self.text = text
        self.toolbar = toolbar
        self.action_group = action_group

    def clicked_event(self):
        self.open_manager()

    def open_manager(self):

        self.dlg_priority_manager = GwPriorityManagerUi(self)

        # Fill filters
        rows = tools_db.get_rows("SELECT id, idval FROM am.value_result_type")
        tools_qt.fill_combo_values(
            self.dlg_priority_manager.cmb_type, rows, 1, add_empty=True
        )

        rows = tools_db.get_rows(
            f"SELECT expl_id, name FROM {lib_vars.schema_name}.exploitation"
        )
        tools_qt.fill_combo_values(
            self.dlg_priority_manager.cmb_expl, rows, 1, add_empty=True
        )

        rows = tools_db.get_rows("SELECT id, idval FROM am.value_status")
        tools_qt.fill_combo_values(
            self.dlg_priority_manager.cmb_status, rows, 1, add_empty=True
        )

        # Fill results table
        self._fill_table(
            self.dlg_priority_manager,
            self.dlg_priority_manager.tbl_results,
            "am.cat_result",
            [
                (2, "am.value_result_type", "id", "idval"),
                (5, f"{lib_vars.schema_name}.exploitation", "expl_id", "name"),
                (10, "am.value_status", "id", "idval"),
            ],
        )
        tools_gw.set_tablemodel_config(
            self.dlg_priority_manager,
            self.dlg_priority_manager.tbl_results,
            "cat_result",
            schema_name="am",
        )
        rows = tools_db.get_rows(
            """
            select columnname, alias
            from am.config_form_tableview
            where objectname = 'cat_result'
            """
        )
        self.headers = {row["columnname"]: row["alias"] for row in rows}
        self.headers["value_result_type_idval_2"] = self.headers.get(
            "result_type", "Type"
        )
        self.headers["name"] = self.headers.get("expl_id", "Explotation")
        self.headers["idval"] = self.headers.get("status", "Status")

        self._set_signals()

        # Create dicts for i18n labels:
        self._value_status = {}
        for id, idval in tools_db.get_rows("select id, idval from am.value_status"):
            self._value_status[idval] = id

        self._value_result_type = {}
        for id, idval in tools_db.get_rows(
            "select id, idval from am.value_result_type"
        ):
            self._value_result_type[idval] = id

        # Open the dialog
        tools_gw.open_dialog(
            self.dlg_priority_manager,
            dlg_name="priority_manager"
        )

    def _manage_txt_report(self):

        dlg = self.dlg_priority_manager

        selected_list = dlg.tbl_results.selectionModel().selectedRows()

        if len(selected_list) == 0 or len(selected_list) > 1:
            dlg.txt_info.setText("")
            return

        row = selected_list[0].row()
        record = dlg.tbl_results.model().record(row)
        txt = ""
        for i in range(len(record)):
            if not record.value(i):
                continue

            field_name = record.fieldName(i)
            value = record.value(i)

            txt += f"<b>{self.headers.get(field_name, field_name)}:</b><br>"
            if field_name == "report":
                txt += value.replace("\n", "<br>") + "<br><br>"
            elif field_name == "tstamp":
                txt += value.toString() + "<br><br>"
            else:
                txt += f"{value}<br><br>"

        dlg.txt_info.setText(txt)

    def _manage_btn_action(self):

        dlg = self.dlg_priority_manager

        selected_list = dlg.tbl_results.selectionModel().selectedRows()

        if len(selected_list) == 0 or len(selected_list) > 1:
            dlg.btn_delete.setEnabled(False)
            dlg.btn_status.setEnabled(False)
            dlg.btn_duplicate.setEnabled(False)
            dlg.btn_edit.setEnabled(False)
            dlg.btn_corporate.setEnabled(False)
            return

        row = selected_list[0].row()
        status_i18n = dlg.tbl_results.model().record(row).value(10)
        status = self._value_status.get(status_i18n, "")

        if status == "FINISHED":
            dlg.btn_corporate.setEnabled(True)
            dlg.btn_edit.setEnabled(False)
            dlg.btn_duplicate.setEnabled(True)
            dlg.btn_status.setEnabled(False)
            dlg.btn_delete.setEnabled(False)
        elif status == "ON PLANNING":
            dlg.btn_corporate.setEnabled(True)
            dlg.btn_edit.setEnabled(True)
            dlg.btn_duplicate.setEnabled(True)
            dlg.btn_status.setEnabled(True)
            dlg.btn_delete.setEnabled(False)
        else:
            dlg.btn_corporate.setEnabled(False)
            dlg.btn_edit.setEnabled(False)
            dlg.btn_duplicate.setEnabled(False)
            dlg.btn_status.setEnabled(True)
            dlg.btn_delete.setEnabled(True)

    def _filter_table(self):

        dlg = self.dlg_priority_manager

        tbl_result = dlg.tbl_results

        expr = ""
        id_ = tools_qt.get_text(dlg, dlg.txt_filter, False, False)
        result_type = tools_qt.get_combo_value(dlg, dlg.cmb_type, 0)
        expl_id = tools_qt.get_combo_value(dlg, dlg.cmb_expl, 0)
        status = tools_qt.get_combo_value(dlg, dlg.cmb_status, 0)

        expr += f" result_id is NOT NULL"

        if id_:
            expr += f" AND result_name ILIKE '%{id_}%'"
        if result_type:
            expr += f" AND (result_type ILIKE '%{result_type}%')"
        if expl_id:
            expr += f" AND (expl_id = {expl_id})"
        if status:
            expr += f" AND (status::text ILIKE '%{status}%')"

        # Refresh model with selected filter
        tbl_result.model().setFilter(expr)
        tbl_result.model().select()

    def _delete_result(self):

        table = self.dlg_priority_manager.tbl_results
        selected = [x.data() for x in table.selectedIndexes() if x.column() == 0]
        for result_id in selected:
            row = tools_db.get_row(
                f"""
                SELECT result_name, status 
                FROM am.cat_result 
                WHERE result_id = {result_id}
                """
            )
            if not row:
                continue
            result_name, status = row
            if status == "CANCELED":
                msg = "You are about to delete the result"
                info = "This action cannot be undone. Do you want to proceed?"
                if tools_qt.show_question(
                    msg,
                    inf_text=info,
                    context_name=lib_vars.plugin_name,
                    parameter=f"{result_id}-{result_name}",
                ):
                    tools_db.execute_sql(
                        f"""
                        DELETE FROM am.cat_result
                        WHERE result_id = {result_id}
                        """
                    )
            else:
                msg = "The result cannot be deleted"
                info = "You can only delete results with the status 'CANCELED'."
                tools_qt.show_info_box(
                    msg,
                    inf_text=info,
                    context_name=lib_vars.plugin_name,
                    parameter=f"{result_id}-{result_name}",
                )
        table.model().select()

    def _dlg_status_accept(self, result_id):

        new_status = tools_qt.get_combo_value(self.dlg_status, "cmb_status")
        tools_db.execute_sql(
            f"""
            UPDATE am.cat_result
            SET status = '{new_status}'
            WHERE result_id = {result_id}
            """
        )
        self.dlg_status.close()
        self.dlg_priority_manager.tbl_results.model().select()

    def _edit_result(self):

        # Get parameters

        dlg = self.dlg_priority_manager
        selected_list = dlg.tbl_results.selectionModel().selectedRows()
        row = selected_list[0].row()
        result_id = dlg.tbl_results.model().record(row).value("result_id")
        result_type_i18n = dlg.tbl_results.model().record(row).value(2)

        if not result_type_i18n:
            tools_gw.show_warning("Please select a result with not empty type", dialog=dlg)
            return
        result_type = self._value_result_type[result_type_i18n]

        calculate_priority = CalculatePriority(
           type=result_type, mode="edit", result_id=result_id
        )
        calculate_priority.clicked_event()

    def _duplicate_result(self):

        dlg = self.dlg_priority_manager
        selected_list = dlg.tbl_results.selectionModel().selectedRows()
        row = selected_list[0].row()
        result_id = dlg.tbl_results.model().record(row).value("result_id")
        result_type_i18n = dlg.tbl_results.model().record(row).value(2)

        if not result_type_i18n:
            tools_gw.show_warning("Please select a result with not empty type", dialog=dlg)
            return

        result_type = self._value_result_type[result_type_i18n]

        calculate_priority = CalculatePriority(
           type=result_type, mode="duplicate", result_id=result_id
        )
        calculate_priority.clicked_event()

    def _fill_table(
        self,
        dialog,
        widget,
        table_name,
        relations=[],
        hidde=False,
        set_edit_triggers=QTableView.NoEditTriggers,
        expr=None,
    ):
        """Set a model with selected filter.
        Attach that model to selected table
        @setEditStrategy:
        0: OnFieldChange
        1: OnRowChange
        2: OnManualSubmit
        """
        try:

            # Set model
            model = QSqlRelationalTableModel(db=lib_vars.qgis_db_credentials)
            model.setTable(table_name)
            model.setJoinMode(QSqlRelationalTableModel.JoinMode.LeftJoin)
            for column, table, key, value in relations:
                model.setRelation(column, QSqlRelation(table, key, value))
            model.setEditStrategy(QSqlRelationalTableModel.OnManualSubmit)
            model.setSort(0, 0)
            model.select()

            widget.setEditTriggers(set_edit_triggers)
            widget.setSelectionBehavior(QAbstractItemView.SelectRows)

            # Check for errors
            if model.lastError().isValid():
                print(f"ERROR -> {model.lastError().text()}")

            # Attach model to table view
            if expr:
                widget.setModel(model)
                widget.model().setFilter(expr)
            else:
                widget.setModel(model)

            if hidde:
                self.refresh_table(dialog, widget)
        except Exception as e:
            print(f"EXCEPTION -> {e}")

    def _open_status_selector(self):

        table = self.dlg_priority_manager.tbl_results
        selected = [x.data() for x in table.selectedIndexes() if x.column() == 0]

        if len(selected) != 1:
            msg = "Please select only one result before changing its status."
            tools_qt.show_info_box(msg, context_name=lib_vars.plugin_name)
            return

        row = tools_db.get_row(
            f"""
            SELECT result_id, result_name, status
            FROM am.cat_result
            WHERE result_id = {selected[0]}
            """
        )
        if not row:
            return

        result_id, result_name, status = row
        if status == "FINISHED":
            msg = "You cannot change the status of a result with status 'FINISHED'."
            tools_qt.show_info_box(msg, context_name=lib_vars.plugin_name)
            return

        self.dlg_status = GwStatusSelectorUi(self)
        self.dlg_status.lbl_result.setText(f"{result_id}: {result_name}")
        rows = tools_db.get_rows("SELECT id, idval FROM am.value_status")
        tools_qt.fill_combo_values(self.dlg_status.cmb_status, rows, 1)
        tools_qt.set_combo_value(self.dlg_status.cmb_status, status, 0, add_new=False)
        self.dlg_status.btn_accept.clicked.connect(
            partial(self._dlg_status_accept, result_id)
        )
        self.dlg_status.btn_cancel.clicked.connect(self.dlg_status.reject)

        tools_gw.open_dialog(
            self.dlg_status,
            dlg_name="status_selector"
        )

    def _set_corporate(self):
        table = self.dlg_priority_manager.tbl_results
        selected_list = table.selectionModel().selectedRows()

        if len(selected_list) != 1:
            return

        row_index = selected_list[0].row()
        row = table.model().record(row_index)
        result_id = row.value("result_id")
        iscorporate = row.value("iscorporate")

        if iscorporate:
            tools_db.execute_sql(
                f"""
                UPDATE am.cat_result
                SET iscorporate = FALSE
                WHERE result_id = {result_id}
                """
            )
            table.model().select()
            return

        # Get the exploitations of result_id
        sql = (
            f"SELECT DISTINCT expl_id FROM am.arc_output WHERE result_id={result_id}"
        )
        rows = tools_db.get_rows(sql)
        result_expl = set()
        if rows:
            result_expl = {row[0] for row in rows}

        # get the result_ids that arecorporate and it exploitations
        sql = "SELECT DISTINCT result_id, expl_id FROM am.v_asset_arc_corporate"
        rows = tools_db.get_rows(sql)
        corporate_expl = {}
        if rows:
            for result, expl in rows:
                if result not in corporate_expl:
                    corporate_expl[result] = {expl}
                else:
                    corporate_expl[result].add(expl)

        # get result_ids that share exploitations with this
        conflict_results = []
        for result, exploitations in corporate_expl.items():
            if result_expl.isdisjoint(exploitations):
                continue
            conflict_results.append(result)

        if not conflict_results:
            tools_db.execute_sql(
                f"""
                UPDATE am.cat_result
                SET iscorporate = TRUE
                WHERE result_id = {result_id}
                """
            )
            table.model().select()
            return

        conflict_results_str = ", ".join(str(x) for x in conflict_results)
        message = tools_qt.tr(
            "To make the result id {result_id} corporate, "
            "is necessary to make not corporate the following result ids: "
            "{conflict_ids}."
        )
        message += " " + tools_qt.tr("Do you want to proceed?")
        answer = tools_qt.show_question(
            message.format(result_id=result_id, conflict_ids=conflict_results_str)
        )

        if not answer:
            return

        tools_db.execute_sql(
            f"""
            UPDATE am.cat_result
            SET iscorporate = FALSE
            WHERE result_id IN ({conflict_results_str});

            UPDATE am.cat_result
            SET iscorporate = TRUE
            WHERE result_id = {result_id};
            """
        )
        table.model().select()

    def _set_signals(self):
        dlg = self.dlg_priority_manager
        dlg.btn_corporate.clicked.connect(self._set_corporate)
        dlg.btn_edit.clicked.connect(self._edit_result)
        dlg.btn_duplicate.clicked.connect(self._duplicate_result)
        dlg.btn_status.clicked.connect(self._open_status_selector)
        dlg.btn_delete.clicked.connect(self._delete_result)
        dlg.btn_close.clicked.connect(dlg.reject)

        dlg.txt_filter.textChanged.connect(partial(self._filter_table))
        dlg.cmb_type.currentIndexChanged.connect(partial(self._filter_table))
        dlg.cmb_expl.currentIndexChanged.connect(partial(self._filter_table))
        dlg.cmb_status.currentIndexChanged.connect(partial(self._filter_table))

        selection_model = dlg.tbl_results.selectionModel()
        selection_model.selectionChanged.connect(partial(self._manage_btn_action))
        selection_model.selectionChanged.connect(partial(self._manage_txt_report))
