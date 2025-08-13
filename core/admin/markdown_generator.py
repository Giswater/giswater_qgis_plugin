"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
import re
import subprocess
from functools import partial
import json
import ast

import psycopg2
import psycopg2.extras

from ..ui.ui_manager import GwAdminMarkdownGeneratorUi
from ..utils import tools_gw
from ...libs import lib_vars, tools_qt, tools_qgis, tools_log, tools_db

from PyQt5.QtWidgets import QApplication, QFileDialog

class GwAdminMarkdownGenerator:

    def __init__(self):
        self.plugin_dir = lib_vars.plugin_dir
        self.schema_name = lib_vars.schema_name
        self.multiple_languages = False
        self.language = None
        self.lower_lang = None
        self.schema_i18n = None
        self.last_error = None
        self.path_dic = None
        self.dlg_qm = None

    def init_dialog(self):
        """ Constructor """

        self.dlg_qm = GwAdminMarkdownGeneratorUi(self)
        tools_gw.load_settings(self.dlg_qm)

        self.dev_commit = tools_gw.get_config_parser('system', 'force_commit', "user", "init", prefix=True)

        self._load_user_values()
        self._populate_data_schema_name(self.dlg_qm.cmb_projecttype)
        self.schema = tools_qt.get_text(self.dlg_qm, self.dlg_qm.cmb_schema)

        # Mysteriously without the partial the function check_connection is not called
        self.set_signals()
        tools_gw.open_dialog(self.dlg_qm, dlg_name='admin_markdown_generator')
    
    def set_signals(self):
        """ Set all the signals to wait for response """
        self.dlg_qm.btn_generate.clicked.connect(self.generate_markdown_file)
        self.dlg_qm.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_qm))
        self.dlg_qm.rejected.connect(self._save_user_values)
        self.dlg_qm.cmb_projecttype.currentIndexChanged.connect(partial(self._populate_data_schema_name, self.dlg_qm.cmb_projecttype))
        self.dlg_qm.cmb_schema.currentIndexChanged.connect(partial(self._schema_changed))
        self.dlg_qm.btn_path.clicked.connect(partial(self._path_changed))

    def pass_schema_info(self, schema_info, schema_name):
        self.project_epsg = schema_info['project_epsg']
        self.project_version = schema_info['project_version']
        self.project_language = schema_info['project_language']

    def _schema_changed(self):
        """ Schema changed """
        self.schema = tools_qt.get_text(self.dlg_qm, self.dlg_qm.cmb_schema)

    def _path_changed(self):
        """ Path changed """
        directory = QFileDialog.getExistingDirectory(None, "Select Directory")
        if directory:
            self.path = directory
            tools_qt.set_widget_text(self.dlg_qm, 'txt_path', self.path)

    def _populate_data_schema_name(self, widget):
        self.project_type = tools_qt.get_text(self.dlg_qm, widget)
        # Populate Project data schema Name
        sql = "SELECT schema_name FROM information_schema.schemata"
        rows = tools_db.get_rows(sql, commit=self.dev_commit)
        if rows is None:
            return
    
        result_list = []
        for row in rows:
            sql = (f"SELECT EXISTS (SELECT * FROM information_schema.tables "
                   f"WHERE table_schema = '{row[0]}' "
                   f"AND table_name = 'sys_version')")
            exists = tools_db.get_row(sql)
            if exists and str(exists[0]) == 'True':
                sql = f"SELECT project_type FROM {row[0]}.sys_version"
                result = tools_db.get_row(sql)
                if result is not None and result[0] in [self.project_type.upper(), self.project_type.lower()]:
                    elem = [row[0], row[0]]
                    result_list.append(elem)
        if not result_list:
            self.dlg_qm.cmb_schema.clear()
            return

        tools_qt.fill_combo_values(self.dlg_qm.cmb_schema, result_list)
    
    # endregion
    # region MAIN

    def generate_markdown_file(self):
        """ Generate the markdown file """

        sql = f"SELECT * FROM {self.schema}.cat_feature"
        rows = tools_db.get_rows(sql)
        for row in rows:
            feature_type = row['id']
            msg = "Generating markdown for {0}."
            msg_params = (feature_type,)
            self._change_table_lyt(msg, msg_params)

            sql = f"SELECT * FROM {self.schema}.config_form_fields WHERE formname ILIKE '%{feature_type}%'"
            rows_cff = tools_db.get_rows(sql)
        
        msg = "Markdown Generated from {0}."
        msg_params = (self.project_type,)
        self._change_table_lyt(msg, msg_params)
        return

    # endregion

    # region private functions

    def _save_user_values(self):
        """ Save selected user values """

        self.schema = tools_qt.get_text(self.dlg_qm, self.dlg_qm.cmb_schema)
        self.project_type = tools_qt.get_text(self.dlg_qm, self.dlg_qm.cmb_projecttype)
        self.path = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_path)

        tools_gw.set_config_parser('markdown_generator', 'cmb_schema', f"{self.schema}", "user", "session", prefix=False)
        tools_gw.set_config_parser('markdown_generator', 'cmb_project_type', f"{self.project_type}", "user", "session", prefix=False)
        tools_gw.set_config_parser('markdown_generator', 'txt_path', f"{self.path}", "user", "session", prefix=False)

    def _load_user_values(self):
        """
        Load last selected user values
            :return: Dictionary with values
        """

        self.schema = tools_gw.get_config_parser('markdown_generator', 'cmb_schema', "user", "session", False)
        self.project_type = tools_gw.get_config_parser('markdown_generator', 'cmb_project', "user", "session", False)
        self.path = tools_gw.get_config_parser('markdown_generator', 'txt_path', "user", "session", False)

        tools_qt.set_widget_text(self.dlg_qm, 'cmb_schema_name', self.schema)
        tools_qt.set_widget_text(self.dlg_qm, 'cmb_project_type', self.project_type)
        tools_qt.set_widget_text(self.dlg_qm, 'txt_path', self.path)

    def _change_table_lyt(self, msg=None, msg_params=None):
        """ Change the label to inform the user about the table being processed """
        # Update the part the of the program in process
        self.dlg_qm.lbl_info.clear()
        if not msg:
            msg = "Generating markdown from {0}..."
            msg_params = (self.project_type,)
        tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', msg, msg_params)
        QApplication.processEvents()

    # endregion
