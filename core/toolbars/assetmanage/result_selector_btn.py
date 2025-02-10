"""
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QMenu, QAction, QActionGroup, QTableView

from ....libs import lib_vars, tools_db,tools_qgis, tools_os, tools_qt
from ...utils import tools_gw
from ..dialog import GwAction

from .... import global_vars

from ...ui.ui_manager import ResultSelectorUi


class GwResultSelectorButton(GwAction):
    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.iface = global_vars.iface

        self.icon_path = icon_path
        self.action_name = action_name
        self.text = text
        self.toolbar = toolbar
        self.action_group = action_group

    def clicked_event(self):
        self.dlg_result_selector = ResultSelectorUi(self)
        if not self._fill_combos():
            return
        self._update_descriptions()
        self._set_signals()
        tools_gw.open_dialog(
            self.dlg_result_selector,
            dlg_name="result_selector"
        )

    def _fill_combos(self):
        dlg = self.dlg_result_selector
        results = tools_db.get_rows(
            """
            select result_id id, result_name idval, descript
            from asset.cat_result
            """
        )
        if not results:
            msg = "There are no results available to display."
            tools_qt.show_info_box(msg, context_name=lib_vars.plugin_name)
            return False

        # Combo result_main
        tools_qt.fill_combo_values(dlg.cmb_result_main, results, 1, sort_by=1)
        selected_main = tools_db.get_row(
            """
            select result_id
            from asset.selector_result_main
            where cur_user = current_user
            """
        )
        if selected_main:
            tools_qt.set_combo_value(
                dlg.cmb_result_main, str(selected_main[0]), 0, add_new=False
            )

        # Combo result_compare
        tools_qt.fill_combo_values(dlg.cmb_result_compare, results, 1, sort_by=1)
        selected_compare = tools_db.get_row(
            """
            select result_id
            from asset.selector_result_compare
            where cur_user = current_user
            """
        )
        if selected_compare:
            tools_qt.set_combo_value(
                dlg.cmb_result_compare, str(selected_compare[0]), 0, add_new=False
            )

        return True

    def _save_selection(self):
        dlg = self.dlg_result_selector
        result_main = tools_qt.get_combo_value(dlg, dlg.cmb_result_main)
        result_compare = tools_qt.get_combo_value(dlg, dlg.cmb_result_compare)
        tools_db.execute_sql(
            f"""
            delete from asset.selector_result_main
                where cur_user = current_user;
            delete from asset.selector_result_compare
                where cur_user = current_user;
            insert into asset.selector_result_main
                (result_id, cur_user)
                values ({result_main}, current_user);
            insert into asset.selector_result_compare
                (result_id, cur_user)
                values ({result_compare}, current_user);
            """
        )
        dlg.close()
        tools_qgis.set_layer_index("v_asset_arc_output")
        tools_qgis.set_layer_index("v_asset_arc_output_compare")

    def _set_signals(self):
        dlg = self.dlg_result_selector
        dlg.btn_cancel.clicked.connect(dlg.reject)
        dlg.btn_accept.clicked.connect(self._save_selection)
        dlg.cmb_result_main.currentIndexChanged.connect(self._update_descriptions)
        dlg.cmb_result_compare.currentIndexChanged.connect(self._update_descriptions)

    def _update_descriptions(self):
        dlg = self.dlg_result_selector
        desc_main = tools_qt.get_combo_value(dlg, dlg.cmb_result_main, 2)
        dlg.txt_result_main_desc.setText(desc_main)
        desc_compare = tools_qt.get_combo_value(dlg, dlg.cmb_result_compare, 2)
        dlg.txt_result_compare_desc.setText(desc_compare)
