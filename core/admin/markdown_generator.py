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

        msg = "Markdown Generated from {0}."
        msg_params = (self.project_type,)
        self._change_table_lyt(msg, msg_params)
        return

    def add_feature_to_index(self, rows):
        """ Add feature to the object index """
        feature_index_path = f"{self.path}/info_feature/index.rst"

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
            file.write(".. toctree::\n\t:maxdepth: 1\n\t:caption: Features\n\n")
            
            for row in rows:
                if row['feature_type'] not in done_types:
                    done_types.append(row['feature_type'])
                    # Add a comment for the feature type
                    file.write(f"\t# {row['feature_type'].title()}\n")            
                file.write(f"\t{row['feature_type']}/{row['id']}/index_{row['id']}\n")

    def create_tab_index(self, feature_cat, feature_type, feature_class):
        """ Create tab index """
        sql = f"SELECT replace(tabname, '_', ' ') as tabname FROM {self.schema}.config_form_tabs WHERE "
        sql += f"formname = 've_{feature_type}_{feature_cat}' OR formname = 've_{feature_type}' OR "
        sql += f"formname = 've_man_{feature_class}'"
        rows_cft = tools_db.get_rows(sql)

        tab_index_path = f"{self.path}/info_feature/{feature_type}/{feature_cat}/index_{feature_cat}.rst"
        
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
                if row['tabname'] == 'tab data':
                    file.write(f"\ttab_data_{feature_cat}\n")
                    self.create_dinamic_tab(f've_{feature_type}', feature_cat, f'{feature_type}/{feature_cat}/tab_data_{feature_cat}.rst')
                elif row['tabname'] == 'tab epa':
                    file.write(f"\ttab_epa_{feature_cat}\n")
                    self.create_index_tab_epa(feature_cat, feature_type, feature_class)
                else:
                    file.write(f"\t../../{row['tabname'].split(' ')[1]}\n")
                    self.create_other_tab(row)

    def create_index_tab_epa(self, feature_cat, feature_type, feature_class):
        """ Create dinamic tab_epa """
        sql = f"SELECT * FROM {self.schema}.sys_feature_epa_type WHERE feature_type = '{feature_type.upper()}'"
        rows_sfet = tools_db.get_rows(sql)

        tab_epa_path = f"{self.path}/info_feature/{feature_type}/{feature_cat}/tab_epa_{feature_cat}.rst"
        
        if not os.path.exists(tab_epa_path):
            os.makedirs(os.path.dirname(tab_epa_path), exist_ok=True)

        with open(tab_epa_path, 'w') as file:
            # Header
            file.write(f".. _index-epa-{feature_cat}\n\n")
            self.title(file, f"{feature_cat.title()}: Tab EPA", 1)
            file.write(f"\n\nThe feature {feature_cat}, has the following EPA types:\n\n")
            file.write(f".. toctree::\n\t:maxdepth: 1\n\t:caption: EPA Types\n\n")

            for row in rows_sfet:
                epa_type = row['id'].lower()
                if epa_type == 'undefined':
                    continue 
                file.write(f"\t../tab_epa/epa_type_{epa_type}\n")
                self.create_dinamic_tab('ve_epa', epa_type, f'{feature_type}/tab_epa/epa_type_{epa_type}.rst')

    def create_other_tab(self, row):
        """ Create other tab """

        tabname = row['tabname'].split(' ')[1]
        tab_path = f"{self.path}/info_feature/{tabname}.rst"
        if not os.path.exists(tab_path):
            os.makedirs(os.path.dirname(tab_path), exist_ok=True)

            with open(tab_path, 'w') as file:
                file.write(f".. _tab-{tabname}\n\n")
                self.title(file, f"Tab {tabname}", 1)

    def create_dinamic_tab(self, prefix, feature, extra_path):
        """ Create dinamic tab_data """
        # Get rows from config_form_fields
        done_layouts = []
        tabname = 'tab_epa' if 'epa' in prefix else 'tab_data'
        sql = (f"""SELECT * FROM {self.schema}.config_form_fields WHERE formname = '{prefix}_{feature}'
                AND tabname = '{tabname}' AND formtype = 'form_feature' AND layoutname != 'lyt_none' AND hidden = False ORDER BY
                CASE
                    WHEN layoutname ILIKE 'lyt_top%' THEN 1
                    WHEN layoutname ILIKE 'lyt_data%' THEN 2
                    WHEN layoutname ILIKE 'lyt_bot%' THEN 3
                ELSE 4
                END, layoutname, layoutorder;""")
        rows_cff = tools_db.get_rows(sql)
        
        tab_data_path = f"{self.path}/info_feature/{extra_path}"
        
        if not os.path.exists(tab_data_path):
            os.makedirs(os.path.dirname(tab_data_path), exist_ok=True)

        with open(tab_data_path, 'w') as file:
            # Header
            file.write(f".. _tab-{tabname.split('_')[1]}-{feature}\n\n")
            self.title(file, f"{feature.title()}: Tab {tabname.split('_')[1].title()}", 1)
            file.write(f"\n\nThe feature {feature}, has the following data:\n\n")

            if not rows_cff:
                print(f"No data found for {feature}: {prefix}_{feature}")
                return

            for row in rows_cff:
                if row['layoutname'] not in done_layouts:
                    done_layouts.append(row['layoutname'])
                    file.write(f".. raw:: html\n\n")
                    file.write(f"\t<p class='layout-header'>The widgets in the layout {row['layoutname']} are:</p>\n\n")
                # Define variables
                mandatory = 'No' if not row['ismandatory'] else 'Sí'
                editable = 'No' if not row['iseditable'] else 'Sí'
                datatype = row['datatype'].capitalize() if row['datatype'] else 'Unknown'
                dv_querytext = row['dv_querytext']
                dv_querytext_filterc = row['dv_querytext_filterc']
                style = row['stylesheet']
                widgetcontrols = row['widgetcontrols']

                # Write tooltip
                if f'{row['columnname']} - ' in (row['tooltip'] or ''):
                    tooltip = row['tooltip'].split(f'{row['columnname']} - ')[1]
                else:
                    tooltip = row['tooltip']

                if row['label']:
                    if row['label'].endswith(':'):
                        label = row['label'][0:-1]
                    else:
                        label = f"{row['label']}"  
                elif row['columnname'].startswith('tbl_'):
                    label = f"Tabla {row['columnname'].split('_')[2].title()}"
                elif row['columnname'].startswith('hspacer_'):
                    continue
                else:
                    label = row['columnname']

                # Mandatory camps
                file.write(f".. raw:: html\n\n")
                file.write(f"\t<details>\n\t\t<summary><strong>{label.title()}:</strong> {row['columnname']} - {tooltip}</summary>\n")
                file.write(f"\t\t<ul>\n")
                file.write(f"\t\t\t<li><strong>Datatype:</strong> {datatype}.</li>\n")
                file.write(f"\t\t\t<li><strong>Mandatory:</strong> {mandatory}.</li>\n")
                file.write(f"\t\t\t<li><strong>Editable:</strong> {editable}.</li>\n")
                if dv_querytext:
                    file.write(f"\t\t\t<li><strong>Dvquerytext:</strong> Los valores de este desplegable estan determinados por la consulta:\n")
                    file.write(f"\t\t\t\t<code>\n")
                    file.write(f"\t\t\t\t\t{dv_querytext.replace(chr(10), ' ').replace(chr(13), ' ')}\n")
                    file.write(f"\t\t\t\t</code>\n")
                    file.write(f"\t\t\t</li>\n")
                
                if dv_querytext_filterc:
                    file.write(f"\t\t\t<li><strong>Filterc:</strong> La consulta anterior esta filtrada por:\n")
                    file.write(f"\t\t\t\t<code>\n")
                    file.write(f"\t\t\t\t\t{dv_querytext_filterc}\n")
                    file.write(f"\t\t\t\t</code>\n")
                    file.write(f"\t\t\t</li>\n")
                
                # Json camps
                if style:
                    file.write(f"\t\t\t<li>\n")
                    file.write(f"\t\t\t\t<details class='no-square'>\n")
                    file.write(f"\t\t\t\t\t<summary><strong>Stylesheet:</strong> Modificaciones esteticas del campo</summary>\n")
                    file.write(f"\t\t\t\t\t<ul>\n")
                    for key, item in style.items():
                        self._write_item_with_nested_toggle(file, key, item, "\t\t\t\t\t\t", False)
                    file.write(f"\t\t\t\t\t</ul>\n")
                    file.write(f"\t\t\t\t</details>\n")
                    file.write(f"\t\t\t</li>\n")
                if widgetcontrols:
                    self._write_widgetcontrols_dict()
                    file.write(f"\t\t\t<li>\n")
                    file.write(f"\t\t\t\t<details class='no-square'>\n")
                    file.write(f"\t\t\t\t\t<summary><strong>Widgetcontrols:</strong> Controles del campo</summary>\n")
                    file.write(f"\t\t\t\t\t<ul>\n")
                    for key, item in widgetcontrols.items():
                        self._write_item_with_nested_toggle(file, key, item, "\t\t\t\t\t\t", True)
                    file.write(f"\t\t\t\t\t</ul>\n")
                    file.write(f"\t\t\t\t</details>\n")
                    file.write(f"\t\t\t</li>\n")
                file.write(f"\t\t</ul>\n")
                file.write(f"\t</details>\n\n\n")
                
    def _is_dict_like(self, item):
        """ Check if item is a dictionary or JSON-like string """
        if isinstance(item, dict):
            return True
        
        if isinstance(item, str):
            # Try to parse as JSON
            try:
                parsed = json.loads(item)
                return isinstance(parsed, dict)
            except (json.JSONDecodeError, ValueError):
                pass
            
            # Try to parse as Python literal (dict-like string)
            try:
                parsed = ast.literal_eval(item)
                return isinstance(parsed, dict)
            except (ValueError, SyntaxError):
                pass
            
            # Check for CSS-style properties (key:value; key:value;)
            if self._is_css_style(item):
                return True
        
        return False
    
    def _parse_dict_like(self, item):
        """ Parse dict-like item into a dictionary """
        if isinstance(item, dict):
            return item
        
        if isinstance(item, str):
            # Try JSON first
            try:
                parsed = json.loads(item)
                if isinstance(parsed, dict):
                    return parsed
            except (json.JSONDecodeError, ValueError):
                pass
            
            # Try Python literal
            try:
                parsed = ast.literal_eval(item)
                if isinstance(parsed, dict):
                    return parsed
            except (ValueError, SyntaxError):
                pass
            
            # Try CSS-style parsing
            if self._is_css_style(item):
                return self._parse_css_style(item)
        
        return {}
    
    def _is_css_style(self, item):
        """ Check if item is a CSS-style property string """
        if not isinstance(item, str):
            return False
        
        # Remove whitespace and check basic pattern
        item = item.strip()
        if not item:
            return False
        
        # Must contain at least one colon and should end with semicolon or not
        if ':' not in item:
            return False
        
        # Split by semicolon and check each part
        parts = [part.strip() for part in item.split(';') if part.strip()]
        if not parts:
            return False
        
        # Each part should have exactly one colon
        for part in parts:
            if part.count(':') != 1:
                return False
            key_part, value_part = part.split(':', 1)
            if not key_part.strip() or not value_part.strip():
                return False
        
        return True
    
    def _parse_css_style(self, item):
        """ Parse CSS-style property string into dictionary """
        if not isinstance(item, str):
            return {}
        
        result = {}
        item = item.strip()
        
        # Split by semicolon and process each property
        parts = [part.strip() for part in item.split(';') if part.strip()]
        
        for part in parts:
            if ':' in part:
                key, value = part.split(':', 1)
                key = key.strip()
                value = value.strip()
                if key and value:
                    result[key] = value
        
        return result
    
    def _write_item_with_nested_toggle(self, file, key, item, indent, is_main_widget=False):
        """ Write item with nested toggle if it's a dictionary/JSON """
        if self._is_dict_like(item):
            parsed_dict = self._parse_dict_like(item)
            if parsed_dict:
                if is_main_widget:
                    # For main widget controls with toggles, format as "Key: description"
                    description = self.widgetcontrols_simple.get(key, "")
                    file.write(f"{indent}<li>\n")
                    file.write(f"{indent}\t<details class='no-square'>\n")
                    file.write(f"{indent}\t\t<summary><strong>{key}:</strong> {description}</summary>\n")
                    file.write(f"{indent}\t\t<ul>\n")
                    for nested_key, nested_item in parsed_dict.items():
                        self._write_item_with_nested_toggle(file, nested_key, nested_item, indent + "\t\t\t", False)
                    file.write(f"{indent}\t\t</ul>\n")
                    file.write(f"{indent}\t</details>\n")
                    file.write(f"{indent}</li>\n")
                else:
                    file.write(f"{indent}<li>\n")
                    file.write(f"{indent}\t<details class='no-square'>\n")
                    file.write(f"{indent}\t\t<summary><strong>{key}:</strong></summary>\n")
                    file.write(f"{indent}\t\t<ul>\n")
                    for nested_key, nested_item in parsed_dict.items():
                        self._write_item_with_nested_toggle(file, nested_key, nested_item, indent + "\t\t\t", False)
                    file.write(f"{indent}\t\t</ul>\n")
                    file.write(f"{indent}\t</details>\n")
                    file.write(f"{indent}</li>\n")
            else:
                # Fallback if parsing failed
                if is_main_widget:
                    # For main widget controls, format as "KEY (value): Description"
                    description = self.widgetcontrols_simple.get(key, "")
                    file.write(f"{indent}<li><strong>{key}</strong> ({item}): {description}</li>\n")
                else:
                    file.write(f"{indent}<li>{key}: {item}</li>\n")
        else:
            # Regular item
            if is_main_widget:
                # For main widget controls, format as "KEY (value): Description"
                description = self.widgetcontrols_simple.get(key, "")
                file.write(f"{indent}<li><strong>{key}</strong> ({item}): {description}</li>\n")
            else:
                file.write(f"{indent}<li>{key}: {item}</li>\n")

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

    def _write_widgetcontrols_dict(self):
        self.widgetcontrols_simple = {
            "autoupdateReloadFields": "Recarga al momento otros campos en caso de que uno sea modificado. Actua en combinación con isautoupdate",
            "enableWhenParent": "Habilita un combo solo en caso que el campo parent tenga ciertos valores", 
            "regexpControl": "Control de lo que puede escribir usuario mediante expresion regular en widgets tipo texto libre",
            "maxMinValues": "Establece un valor máximo para campos numéricos en widgets de texto libre",
            "setMultiline": "Establece la posibilidad de campos multilinea para escritura con enter",
            "spinboxDecimals": "Establece numero decimales concretos para el widget spinbox (vdef 2)",
            "widgetdim": "Dimensiones para el widget",
            "vdefault_value": "Valor por defecto del widget. Tiene sentido para aquellos widgets que no pertenecen a datos de un feature, puesto que los valores por defecto se definen en los que el usuario ya tiene establecidos en config_param_user. De especial interés para los widgets filtro.",
            "vdefault_querytext": "Valor por defecto del widget a partir del resultado de la query. Tiene sentido para aquellos widgets que no pertenecen a datos de un feature, puesto que los valores por defecto se definen en los que el usuario ya tiene establecidos en config_param_user. De especial interés para los widgets filtro.",
            "listFilterSign": "Signo (LIKE, ILIKE, =, >, < ) para los campos tipo filtro. En caso de omisión se usará ILIKE para listas tipo tableview e = para listas tipo tab",
            "skipSaveValue": "Si se define este valor como true, no se guardaran los cambios realizados en el widget correspondiente. Por defecto no hace falta poner nada porque se sobreentiende true.",
            "labelPosition": "Si se define este valor [top, left, none], el label ocupará la posición relativa respecto al widget. Por defecto se sobreentiende left. Si el campo label está vacío, labelPosition se omite."
        }
    
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
