"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json
import operator
from functools import partial

from qgis.PyQt.QtCore import QDate, QStringListModel
from qgis.PyQt.QtWidgets import QComboBox, QCheckBox, QDateEdit, QDoubleSpinBox, QSizePolicy, QGridLayout, QLabel, \
    QTextEdit, QLineEdit, QCompleter, QTabWidget, QWidget, QGroupBox
from qgis.gui import QgsDateTimeEdit

from ..dialog import GwAction
from ...ui.ui_manager import GwConfigUi
from ...utils import tools_gw
from ....libs import lib_vars, tools_qt, tools_db, tools_qgis


class GwConfigButton(GwAction):
    """ Button 62: Config """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)

    def clicked_event(self):

        self._open_config()

    # region private functions

    def _open_config(self):
        # Manage tab signal
        self.tab_basic_loaded = False
        self.tab_featurecat_loaded = False
        self.tab_mantype_loaded = False
        self.tab_addfields_loaded = False
        self.tab_admin_loaded = False
        self.json_result = None

        # Get user
        cur_user = tools_db.get_current_user()

        self.list_update = []

        # Get visible layers name from TOC
        result = self._get_layers_name()

        # Get dialog
        self.dlg_config = GwConfigUi(self)
        tools_gw.load_settings(self.dlg_config)

        # Call function gw_fct_getconfig and get json_result
        body = tools_gw.create_body(form='"formName":"config"', extras=result)
        self.json_result = tools_gw.execute_procedure('gw_fct_getconfig', body)
        if not self.json_result or self.json_result['status'] == 'Failed':
            return False

        # Get widget controls
        self._get_widget_controls()

        # Event on change from combo parent
        self._get_event_combo_parent(self.json_result['body']['form']['formTabs'])

        # Load first tab
        initial_index = 0
        grbox_list = self.tab_main.widget(initial_index).findChildren(QGroupBox)
        layoutname_list = []
        layout_list = self.tab_main.widget(initial_index).findChildren(QGridLayout)
        for layout in layout_list:
            layoutname_list.append(layout.objectName())
        self._build_dialog_options(self.json_result['body']['form']['formTabs'][0], 'user', layoutname_list)
        self._hide_void_tab_groupbox(grbox_list)

        # Check user/role and remove tabs
        role_admin = tools_db.check_role_user("role_admin", cur_user)
        if not role_admin:
            tools_qt.remove_tab(self.dlg_config.tab_main, "tab_admin")

        # Set Listeners
        self.dlg_config.btn_accept.clicked.connect(partial(self._update_values))
        self.dlg_config.key_escape.connect(partial(tools_gw.close_dialog, self.dlg_config))
        self.dlg_config.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_config))
        self.dlg_config.dlg_closed.connect(partial(tools_gw.save_settings, self.dlg_config))

        # Open form
        tools_gw.open_dialog(self.dlg_config, dlg_name='config')

    def _get_widget_controls(self):
        """ Control the current tab, to load widgets """

        self.tab_main = self.dlg_config.findChild(QTabWidget, "tab_main")

        self._hide_void_tab(self.json_result['body']['form']['formTabs'][0], 'tab_addfields', 'lyt_addfields')

        self.tab_main.currentChanged.connect(partial(self._tab_activation))

    def _tab_activation(self):
        """ Call functions depend on tab selection """

        # Get index of selected tab
        index_tab = self.tab_main.currentIndex()
        grbox_list = self.tab_main.widget(index_tab).findChildren(QGroupBox)
        layoutname_list = []
        layout_list = self.tab_main.widget(index_tab).findChildren(QGridLayout)
        for layout in layout_list:
            layoutname_list.append(layout.objectName())

        match self.tab_main.widget(index_tab).objectName():
            # Tab 'Basic'
            case 'tab_basic' if not self.tab_basic_loaded:
                self._build_dialog_options(self.json_result['body']['form']['formTabs'][0], 'user', layoutname_list)
                self._hide_void_tab_groupbox(grbox_list)
                self.tab_basic_loaded = True
            # Tab 'Featurecat'
            case 'tab_featurecat' if not self.tab_featurecat_loaded:
                self._build_dialog_options(self.json_result['body']['form']['formTabs'][0], 'user', layoutname_list)
                self._hide_void_tab_groupbox(grbox_list)
                self.tab_featurecat_loaded = True
            # Tab 'Man Type'
            case 'tab_mantype' if not self.tab_mantype_loaded:
                self._build_dialog_options(self.json_result['body']['form']['formTabs'][0], 'user', layoutname_list)
                self._hide_void_tab_groupbox(grbox_list)
                self.tab_mantype_loaded = True
            # Tab 'Additional Fields'
            case 'tab_addfields' if not self.tab_addfields_loaded:
                self._build_dialog_options(self.json_result['body']['form']['formTabs'][0], 'user', layoutname_list)
                self._hide_void_tab_groupbox(grbox_list)
                self.tab_addfields_loaded = True
            # Tab 'Admin'
            case 'tab_admin' if not self.tab_admin_loaded:
                self._build_dialog_options(self.json_result['body']['form']['formTabs'][1], 'system', layoutname_list)
                self._hide_void_tab_groupbox(grbox_list)
                self.tab_admin_loaded = True
            
    def _hide_void_tab_groupbox(self, grbox_list):
        """ Recives a list, searches it all the QGroupBox, looks 1 to 1 if the grb have widgets, if it does not have
         (if it is empty), hides the QGroupBox
        :param grbox_list: list of QGroupBox
        """

        for grbox in grbox_list:
            widget_list = grbox.findChildren(QWidget)
            if len(widget_list) == 0:
                grbox.setVisible(False)

    def _hide_void_tab(self, row, tab_name, lyt_name):

        self.hide_tab = any(field['layoutname'] in lyt_name for field in row['fields'])

        if not self.hide_tab:
            tools_qt.remove_tab(self.tab_main, tab_name)

    def _get_layers_name(self):
        """ Returns the name of all the layers visible in the TOC, then populate the cad_combo_layers """

        layers = self.iface.mapCanvas().layers()
        if not layers:
            return
        layers_name = '"list_layers_name":"{'
        tables_name = '"list_tables_name":"{'
        for layer in layers:
            # Check for query layer and/or bad layer
            if not tools_qgis.check_query_layer(layer):
                continue
            layers_name += f"{layer.name()}, "
            tables_name += f"{tools_qgis.get_layer_source_table_name(layer)}, "
        result = layers_name[:-2] + '}", ' + tables_name[:-2] + '}"'

        return result

    def _get_event_combo_parent(self, row):

        for field in row[0]["fields"]:
            if field['isparent']:
                widget = self.dlg_config.findChild(QComboBox, field['widgetname'])
                if widget:
                    widget.currentIndexChanged.connect(partial(tools_gw.fill_child, self.dlg_config, widget, 'config'))

    def _update_values(self):

        my_json = json.dumps(self.list_update)
        extras = f'"fields":{my_json}'
        body = tools_gw.create_body(form='"formName":"config"', extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_setconfig', body)
        if not json_result or json_result['status'] == 'Failed':
            return False

        # Update current_workspace label (status bar)
        tools_gw.manage_current_selections_docker(json_result)

        message = "Values has been updated"
        tools_qgis.show_info(message)
        # Close dialog
        tools_gw.close_dialog(self.dlg_config)

    def _build_dialog_options(self, row, tab, list):

        self.tab = tab

        for field in row['fields']:
            try:
                widget = None
                self.chk = None
                if field['label'] and field['layoutname'] in list:
                    lbl = QLabel()
                    lbl.setObjectName('lbl' + field['widgetname'])
                    lbl.setText(field['label'])
                    lbl.setMinimumSize(160, 0)
                    lbl.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Preferred)
                    lbl.setToolTip(field['tooltip'])

                    if self.tab == 'user':
                        self.chk = QCheckBox()
                        self.chk.setObjectName('chk_' + field['widgetname'])
                        if field['checked'] in ('true', 'True', 'TRUE', True):
                            self.chk.setChecked(True)
                        elif field['checked'] in ('false', 'False', 'FALSE', False):
                            self.chk.setChecked(False)
                        self.chk.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)

                    match field['widgettype']:
                        case 'text' | 'linetext' | 'typeahead':
                            widget = QLineEdit()
                            widget.setText(field['value'])
                            widget.editingFinished.connect(partial(self._get_dialog_changed_values, widget, self.tab, self.chk))
                            widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                            if field['widgettype'] == 'typeahead':
                                completer = QCompleter()
                                if field.get('dv_querytext'):
                                    widget.setProperty('typeahead', True)
                                    model = QStringListModel()
                                    widget.textChanged.connect(
                                        partial(self.populate_typeahead, completer, model, field, self.dlg_config, widget))
                        case 'textarea':
                            widget = QTextEdit()
                            widget.setText(field['value'])
                            widget.editingFinished.connect(partial(self._get_dialog_changed_values, widget, self.tab, self.chk))
                            widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                        case 'combo':
                            widget = QComboBox()
                            self._fill_combo(widget, field)
                            widget.currentIndexChanged.connect(partial(self._get_dialog_changed_values, widget, self.tab, self.chk))
                            widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                        case 'check':
                            self.chk = QCheckBox()
                            self.chk.setObjectName(field['widgetname'])
                            if self.tab == 'user' and field['checked'] in ('true', 'True', 'TRUE', True):
                                self.chk.setChecked(True)
                            elif self.tab == 'user' and field['checked'] in ('false', 'False', 'FALSE', False):
                                self.chk.setChecked(False)
                            elif field['value'] in ('true', 'True', 'TRUE', True):
                                self.chk.setChecked(True)
                            elif field['value'] in ('false', 'False', 'FALSE', False):
                                self.chk.setChecked(False)
                            self.chk.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
                            self.chk.stateChanged.connect(partial(self._get_dialog_changed_values, self.chk, self.tab, self.chk))
                        case 'datetime':
                            widget = QgsDateTimeEdit()
                            widget.setAllowNull(True)
                            widget.setCalendarPopup(True)
                            widget.setDisplayFormat('dd/MM/yyyy')
                            if lib_vars.date_format in ("dd/MM/yyyy", "dd-MM-yyyy", "yyyy/MM/dd", "yyyy-MM-dd"):
                                widget.setDisplayFormat(lib_vars.date_format)
                            if field['value']:
                                field['value'] = field['value'].replace('/', '-')
                            date = QDate.fromString(field['value'], 'yyyy-MM-dd')
                            if date:
                                widget.setDate(date)
                            else:
                                widget.clear()

                            widget.valueChanged.connect(partial(self._get_dialog_changed_values, widget, self.tab, self.chk))
                            widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                        case 'spinbox':
                            widget = QDoubleSpinBox()
                            if field.get('value') is not None:
                                value = float(str(field['value']))
                                widget.setValue(value)
                            widget.valueChanged.connect(partial(self._get_dialog_changed_values, widget, self.tab, self.chk))
                            widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)                                        

                    if widget:
                        widget.setObjectName(field['widgetname'])

                    # Set signals
                    if self.tab == 'user' and widget is not None:
                        self.chk.stateChanged.connect(partial(self._get_dialog_changed_values, widget, self.tab, self.chk))

                    if widget is None:
                        widget = self.chk

                    self._order_widgets(field, lbl, widget)

            except Exception as e:
                msg = f"{type(e).__name__} {e}. widgetname='{field['widgetname']}' AND widgettype='{field['widgettype']}'"
                tools_qgis.show_message(msg, 2, dialog=self.dlg_config)

    def populate_typeahead(self, completer, model, field, dialog, widget):

        if not widget:
            return

        extras = f'"queryText":"{field["dv_querytext"]}"'
        extras += f', "queryTextFilter":"{field["dv_querytext_filterc"]}"'
        extras += f', "textToSearch":"{tools_qt.get_text(dialog, widget)}"'
        body = tools_gw.create_body(extras=extras)
        complet_list = tools_gw.execute_procedure('gw_fct_gettypeahead', body)

        if not complet_list:
            return False

        list_items = []

        for field in complet_list['body']['data']:
            list_items.append(field['idval'])
            tools_qt.set_completer_object(completer, model, widget, list_items)

    def _check_child_to_parent(self, widget_child, widget_parent):

        if widget_child.isChecked():
            widget_parent.setChecked(True)

    def _check_parent_to_child(self, widget_parent, widget_child):

        if not widget_parent.isChecked():
            widget_child.setChecked(False)

    def _fill_combo(self, widget, field):

        # Generate list of items to add into combo
        widget.blockSignals(True)
        widget.clear()
        widget.blockSignals(False)
        combolist = []
        comboIds = field.get('comboIds')
        comboNames = field.get('comboNames')
        if None not in (comboIds, comboNames):
            for i in range(0, len(comboIds)):
                if comboIds[i] is not None and comboNames[i] is not None:
                    elem = [comboIds[i], comboNames[i]]
                    combolist.append(elem)

            records_sorted = sorted(combolist, key=operator.itemgetter(1))
            # Populate combo
            for record in records_sorted:
                widget.addItem(record[1], record)
        value = field.get('value')
        if value not in (None, 'None'):
            tools_qt.set_combo_value(widget, value, 0)

    def _get_dialog_changed_values(self, widget, tab, chk):

        value = None
        elem = {}
        if type(widget) is QLineEdit:
            value = tools_qt.get_text(self.dlg_config, widget, return_string_null=False)
            elem['widget_type'] = 'text'
        elif isinstance(widget, QComboBox):
            value = tools_qt.get_combo_value(self.dlg_config, widget, 0)
            elem['widget_type'] = 'combo'
        elif type(widget) is QCheckBox:
            value = tools_qt.is_checked(self.dlg_config, widget)
            elem['widget_type'] = 'check'
        elif type(widget) is QDateEdit:
            value = tools_qt.get_calendar_date(self.dlg_config, widget)
            elem['widget_type'] = 'datetime'
        elif isinstance(widget, QgsDateTimeEdit):
            value = tools_qt.get_calendar_date(self.dlg_config, widget)
            elem['widget_type'] = 'datetime'
        elif type(widget) is QDoubleSpinBox:
            value = tools_qt.get_text(self.dlg_config, widget, return_string_null=False)

        elem['widget'] = str(widget.objectName())
        elem['value'] = value

        if tab == 'user':
            elem['isChecked'] = str(tools_qt.is_checked(self.dlg_config, chk))
            elem['chk'] = str(chk.objectName())
        else:
            elem['isChecked'] = ''
            elem['chk'] = ''
            elem['sysRoleId'] = 'role_admin'

        self.list_update.append(elem)

    def _get_values_checked_param_user(self, chk, widget, value=None):

        elem = {}

        elem['widget'] = str(widget.objectName())
        elem['chk'] = str(chk.objectName())

        if type(widget) is QLineEdit:
            value = tools_qt.get_text(self.dlg_config, widget, return_string_null=False)
            elem['widget_type'] = 'text'
        elif isinstance(widget, QComboBox):
            value = tools_qt.get_combo_value(self.dlg_config, widget, 0)
            elem['widget_type'] = 'combo'
        elif type(widget) is QCheckBox:
            value = tools_qt.is_checked(self.dlg_config, chk)
            elem['widget_type'] = 'check'
        elif type(widget) is QDateEdit:
            value = tools_qt.get_calendar_date(self.dlg_config, widget)
            elem['widget_type'] = 'datetime'
        elif isinstance(widget, QgsDateTimeEdit):
            value = tools_qt.get_calendar_date(self.dlg_config, widget)
            elem['widget_type'] = 'datetime'

        elem['isChecked'] = str(tools_qt.is_checked(self.dlg_config, chk))
        elem['value'] = value

        self.list_update.append(elem)

    def _order_widgets(self, field, lbl, widget):

        layout = self.dlg_config.tab_main.findChild(QGridLayout, field['layoutname'])
        if layout is not None and field['layoutorder'] is not None:
            layout.addWidget(lbl, field['layoutorder'], 0)

            if field['widgettype'] == 'checkbox' or field['widgettype'] == 'check':
                layout.addWidget(widget, field['layoutorder'], 1)
            elif self.tab == 'user':
                layout.addWidget(self.chk, field['layoutorder'], 1)
                layout.addWidget(widget, field['layoutorder'], 2)
            else:
                layout.addWidget(widget, field['layoutorder'], 2)

    # endregion
