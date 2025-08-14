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

        sql = f"SELECT lower(feature_type) as feature_type, lower(id) as id, lower(feature_class) as feature_class "
        sql += f"FROM {self.schema}.cat_feature ORDER BY (feature_type, id)"
        rows = tools_db.get_rows(sql)
        self.add_feature_to_index(rows)

        for row in rows:
            msg = "Generating markdown for {0}."
            msg_params = (row['id'],)
            self._change_table_lyt(msg, msg_params)

            # Create tab index
            self.create_tab_index(row['id'], row['feature_type'], row['feature_class'])

            # Create dinamic tab_data
            self.create_dinamic_tab_data(row['id'], row['feature_type'])

        msg = "Markdown Generated from {0}."
        msg_params = (self.project_type,)
        self._change_table_lyt(msg, msg_params)
        return

    def add_feature_to_index(self, rows):
        """ Add feature to the object index """
        feature_index_path = f"{self.path}/info_feature_index.rst"

        if not os.path.exists(feature_index_path):
            os.makedirs(os.path.dirname(feature_index_path), exist_ok=True)
        
        done_types = []
        with open(feature_index_path, 'w') as file:
            file.write(f".. _info-feature-index\n\n")

            # Title
            self.title(file, "Feature Index", 1)
    
            # Introduction  
            file.write(f"\n\nIn a giswater project for {self.project_type} the following features can be created and edited:\n\n")

            # Create toctree structure
            file.write(".. toctree::\n\t:maxdepth: 2\n\t:caption: Features\n\n")
            
            for row in rows:
                if row['feature_type'] not in done_types:
                    done_types.append(row['feature_type'])
                    # Add a comment for the feature type
                    file.write(f"\t# {row['feature_type'].title()}\n")            
                file.write(f"\t_tab-index-{row['id']}\n")

    def create_tab_index(self, feature_cat, feature_type, feature_class):
        """ Create tab index """
        sql = f"SELECT replace(tabname, '_', ' ') as tabname FROM {self.schema}.config_form_tabs WHERE "
        sql += f"formname = 've_{feature_type}_{feature_cat}' OR formname = 've_{feature_type}' OR "
        sql += f"formname = 've_man_{feature_class}'"
        rows_cft = tools_db.get_rows(sql)

        tab_index_path = f"{self.path}/{feature_cat}/index_{feature_cat}.rst"
        
        if not os.path.exists(tab_index_path):
            os.makedirs(os.path.dirname(tab_index_path), exist_ok=True)

        with open(tab_index_path, 'w') as file:
            file.write(f".. _tab-index-{feature_cat}\n\n")

            # Title
            self.title(file, f"{feature_cat.title()} Tabs", 1)

            # Introduction
            file.write(f"\n\nThe feature {feature_cat}, has the following tabs:\n\n")

            # Create toctree structure for tabs
            file.write(".. toctree::\n\t:maxdepth: 1\n\t:caption: Tabs\n\n")

            for row in rows_cft:
                # Check if this is the "Data" tab to link to the dynamic tab_data file
                file.write(f"\ttab_data_{feature_cat}\n")

    def create_dinamic_tab_data(self, feature_cat, feature_type):
        """ Create dinamic tab_data """
        # Get rows from config_form_fields
        sql = (f"""SELECT * FROM {self.schema}.config_form_fields WHERE formname = 've_{feature_type}_{feature_cat}'
                AND tabname = 'tab_data' AND formtype = 'form_feature' ORDER BY
                CASE
                    WHEN layoutname ILIKE 'lyt_top%' THEN 1
                    WHEN layoutname ILIKE 'lyt_data%' THEN 2
                    WHEN layoutname ILIKE 'lyt_bottom%' THEN 3
                ELSE 4
                END, layoutorder;""")
        rows_cff = tools_db.get_rows(sql)
        
        tab_data_path = f"{self.path}/{feature_cat}/tab_data_{feature_cat}.rst"
        
        if not os.path.exists(tab_data_path):
            os.makedirs(os.path.dirname(tab_data_path), exist_ok=True)

        with open(tab_data_path, 'w') as file:
            # Header
            file.write(f".. _tab-data-{feature_cat}\n\n")
            self.title(file, f"{feature_cat.title()}: Tab Data", 1)
            file.write(f"\n\nThe feature {feature_cat}, has the following data:\n\n")

            for row in rows_cff:
                # Define variables
                mandatory = 'No' if not row['ismandatory'] else 'Sí'
                editable = 'No' if not row['iseditable'] else 'Sí'
                isparent = row['isparent']
                dv_querytext = row['dv_querytext']
                dv_querytext_filterc = row['dv_querytext_filterc']
                style = row['stylesheet']
                widgetcontrols = row['widgetcontrols']

                # Write tooltip
                if f'{row['columnname']} - ' in row['tooltip']:
                    tooltip = row['tooltip'].split(f'{row['columnname']} - ')[1]
                else:
                    tooltip = row['tooltip']

                # Mandatory camps
                file.write(f".. raw:: html\n")
                file.write(f"\t<details>\n\t\t<summary>{row['label'].title()}: {row['columnname']} - {tooltip}</summary>\n")
                file.write(f"\t\t<ul>\n")
                file.write(f"\t\t\t<li>**Tipo de dato:** {row['datatype']}.</li>\n")
                file.write(f"\t\t\t<li>**Obligatorio:** {mandatory}.</li>\n")
                file.write(f"\t\t\t<li>**Editable:** {editable}.</li>\n")
                if dv_querytext:
                    file.write(f"\t\t\t<li>**Valores:** Los valores de este desplegable estan determinados por la consulta: {dv_querytext}.</li>\n")
                
                if dv_querytext_filterc:
                    file.write(f"\t\t\t<li>**Filtrado:** La consulta anterior esta filtrada por: {dv_querytext_filterc}.</li>\n")
                
                # Json camps
                if style:
                    file.write(f"\t\t\t<li>\n")
                    file.write(f"\t\t\t\t<details class='no-square'>\n")
                    file.write(f"\t\t\t\t\t<summary><b>Estilos:</b> Modificaciones esteticas del campo</summary>\n")
                    file.write(f"\t\t\t\t\t<ul>\n")
                    for key, item in style.items():
                        file.write(f"\t\t\t\t\t\t<li>{key} ({item})</li>\n")
                    file.write(f"\t\t\t\t\t</ul>\n")
                    file.write(f"\t\t\t\t</details>\n")
                    file.write(f"\t\t\t</li>\n")
                if widgetcontrols:
                    file.write(f"\t\t\t<li>\n")
                    file.write(f"\t\t\t\t<details class='no-square'>\n")
                    file.write(f"\t\t\t\t\t<summary><b>Controles:</b> Controles del campo</summary>\n")
                    file.write(f"\t\t\t\t\t<ul>\n")
                    for key, item in widgetcontrols.items():
                        file.write(f"\t\t\t\t\t\t<li>{key} ({item}): Hola</li>\n")
                    file.write(f"\t\t\t\t\t</ul>\n")
                    file.write(f"\t\t\t\t</details>\n")
                    file.write(f"\t\t\t</li>\n")
                file.write(f"\t\t</ul>\n")
                file.write(f"\t</details>\n\n")
                
    def get_column_and_table_name(self, dv_querytext):
        """ Get column and table name from dv_querytext """
        column_name = None
        table_name = None

        # Check if the query contains id pattern
        id_pattern = None
        if 'id, ' in dv_querytext:
            id_pattern = 'id, '
        elif 'id,' in dv_querytext:
            id_pattern = 'id,'
        
        if id_pattern:
            # Determine FROM clause (case insensitive)
            from_clause = None
            if ' FROM ' in dv_querytext:
                from_clause = ' FROM '
            elif ' from ' in dv_querytext:
                from_clause = ' from '
            
            # Extract column and table information
            if ' JOIN ' in dv_querytext:
                # Handle JOIN queries
                column_info = dv_querytext.split(id_pattern)[1].split(' ')[0]
                column_name = column_info.split('.')[1]
                table_alias = column_info.split('.')[0]
                table_name = dv_querytext.split(f' {table_alias} ')[0].split(' ')[-1]
            else:
                # Handle simple queries
                column_name = dv_querytext.split(id_pattern)[1].split(' ')[0]
                if from_clause:
                    table_name = dv_querytext.split(from_clause)[1].split(' ')[0]
                else:
                    # This case might not occur based on the original logic, but keeping it safe
                    table_name = "unknown"
        return column_name, table_name

    def title(self, file, text, level=1):
        """ Create a title """
        if level == 1:
            for i in range(len(text)):
                file.write(f"=")
        file.write(f"\n{text.title()}\n")
        for i in range(len(text)):
            file.write(f"=")
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
