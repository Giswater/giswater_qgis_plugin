"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json
import operator
from functools import partial

from qgis.PyQt.QtCore import QDate
from qgis.PyQt.QtWidgets import QComboBox, QCheckBox, QDateEdit, QDoubleSpinBox, QSpinBox, QGroupBox, QSpacerItem, \
    QSizePolicy, QGridLayout, QWidget, QLabel, QTextEdit, QLineEdit
from qgis.gui import QgsDateTimeEdit

from ..dialog import GwAction
from ...ui.ui_manager import GwConfigUi
from ...utils import tools_gw
from ....lib import tools_qt, tools_db, tools_qgis


class GwConfigButton(GwAction):
    """ Button 99: Config """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)


    def clicked_event(self):

        self._open_config()


    # region private functions

    def _open_config(self):

        # Get user and role
        super_users = tools_gw.get_config_parser('system', 'super_users', "project", "giswater")
        cur_user = tools_db.get_current_user()

        self.list_update = []

        # Get visible layers name from TOC
        result = self._get_layers_name()


        self.dlg_config = GwConfigUi()
        tools_gw.load_settings(self.dlg_config)


        # Call function gw_fct_getconfig and get json_result
        body = tools_gw.create_body(form='"formName":"config"', extras=result)
        json_result = tools_gw.execute_procedure('gw_fct_getconfig', body)
        if not json_result or json_result['status'] == 'Failed':
            return False

        # Construct form for config and admin
        # User
        self._build_dialog_options(json_result['body']['form']['formTabs'][0], 'user')
        # System
        self._build_dialog_options(json_result['body']['form']['formTabs'][1], 'system')

        # Event on change from combo parent
        self._get_event_combo_parent(json_result['body']['form']['formTabs'])

        tools_qt.hide_void_groupbox(self.dlg_config)

        # Check user/role and remove tabs
        role_admin = tools_db.check_role_user("role_admin", cur_user)
        if not role_admin and cur_user not in super_users:
            tools_qt.remove_tab(self.dlg_config.tab_main, "tab_admin")

        # Set Listeners
        self.dlg_config.btn_accept.clicked.connect(partial(self._update_values))
        self.dlg_config.key_escape.connect(partial(tools_gw.close_dialog, self.dlg_config))
        self.dlg_config.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_config))
        self.dlg_config.dlg_closed.connect(partial(tools_gw.save_settings, self.dlg_config))

        # Open form
        tools_gw.open_dialog(self.dlg_config, dlg_name='config')


    def _get_layers_name(self):
        """ Returns the name of all the layers visible in the TOC, then populate the cad_combo_layers """

        layers = self.iface.mapCanvas().layers()
        if not layers:
            return
        layers_name = '"list_layers_name":"{'
        tables_name = '"list_tables_name":"{'
        for layer in layers:
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
        json_result = tools_gw.execute_procedure('gw_fct_setconfig', body, log_sql=True)
        if not json_result or json_result['status'] == 'Failed':
            return False

        message = "Values has been updated"
        tools_qgis.show_info(message)
        # Close dialog
        tools_gw.close_dialog(self.dlg_config)


    # noinspection PyUnresolvedReferences
    def _build_dialog_options(self, row, tab):

        self.tab = tab
        for field in row['fields']:
            widget = None
            self.chk = None
            if field['label']:
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

                if field['widgettype'] in ('text', 'linetext', 'typeahead'):
                    widget = QLineEdit()
                    widget.setText(field['value'])
                    widget.editingFinished.connect(partial(self._get_dialog_changed_values, widget, self.tab, self.chk))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)

                    if field['widgettype'] == 'typeahead':
                        completer = QCompleter()
                        if 'dv_querytext' in field:
                            widget.setProperty('typeahead', True)
                            model = QStringListModel()
                            widget.textChanged.connect(
                                partial(self.populate_typeahead, completer, model, field, self.dlg_config, widget))

                elif field['widgettype'] == 'textarea':
                    widget = QTextEdit()
                    widget.setText(field['value'])
                    widget.editingFinished.connect(partial(self._get_dialog_changed_values, widget, self.tab, self.chk))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'combo':
                    widget = QComboBox()
                    self._fill_combo(widget, field)
                    widget.currentIndexChanged.connect(partial(self._get_dialog_changed_values, widget, self.tab, self.chk))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'check':
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
                elif field['widgettype'] == 'datetime':
                    widget = QgsDateTimeEdit()
                    widget.setAllowNull(True)
                    widget.setCalendarPopup(True)
                    widget.setDisplayFormat('dd/MM/yyyy')

                    if field['value']:
                        field['value'] = field['value'].replace('/', '-')
                    date = QDate.fromString(field['value'], 'yyyy-MM-dd')
                    if date:
                        widget.setDate(date)
                    else:
                        widget.clear()
                    widget.dateChanged.connect(partial(self._get_dialog_changed_values, widget, self.tab, self.chk))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'spinbox':
                    widget = QDoubleSpinBox()
                    if 'value' in field and field['value'] is not None:
                        value = float(str(field['value']))
                        widget.setValue(value)
                    widget.valueChanged.connect(partial(self._get_dialog_changed_values, widget, self.tab, self.chk))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                else:
                    pass

                if widget:
                    widget.setObjectName(field['widgetname'])

                # Set signals
                if self.tab == 'user' and widget is not None:
                    self.chk.stateChanged.connect(partial(self._get_dialog_changed_values, widget, self.tab, self.chk))

                if widget is None:
                    widget = self.chk

                self._order_widgets(field, lbl, widget)


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
        if 'comboIds' in field:
            for i in range(0, len(field['comboIds'])):
                if field['comboIds'][i] is not None and field['comboNames'][i] is not None:
                    elem = [field['comboIds'][i], field['comboNames'][i]]
                    combolist.append(elem)

            records_sorted = sorted(combolist, key=operator.itemgetter(1))
            # Populate combo
            for record in records_sorted:
                widget.addItem(record[1], record)
        if 'value' in field:
            if str(field['value']) != 'None':
                tools_qt.set_combo_value(widget, field['value'], 0)


    def _get_dialog_changed_values(self, widget, tab, chk):
        value = None
        elem = {}
        if type(widget) is QLineEdit:
            value = tools_qt.get_text(self.dlg_config, widget, return_string_null=False)
        elif type(widget) is QComboBox:
            value = tools_qt.get_combo_value(self.dlg_config, widget, 0)
        elif type(widget) is QCheckBox:
            value = tools_qt.is_checked(self.dlg_config, widget)
        elif type(widget) is QDateEdit:
            value = tools_qt.get_calendar_date(self.dlg_config, widget)
        elif type(widget) is QgsDateTimeEdit:
            value = tools_qt.get_calendar_date(self.dlg_config, widget)
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
        elif type(widget) is QComboBox:
            value = tools_qt.get_combo_value(self.dlg_config, widget, 0)
            elem['widget_type'] = 'combo'
        elif type(widget) is QCheckBox:
            value = tools_qt.is_checked(self.dlg_config, chk)
            elem['widget_type'] = 'check'
        elif type(widget) is QDateEdit:
            value = tools_qt.get_calendar_date(self.dlg_config, widget)
            elem['widget_type'] = 'datetime'
        elif type(widget) is QgsDateTimeEdit:
            value = tools_qt.get_calendar_date(self.dlg_config, widget)
            elem['widget_type'] = 'datetime'

        elem['isChecked'] = str(tools_qt.is_checked(self.dlg_config, chk))
        elem['value'] = value

        self.list_update.append(elem)


    def _order_widgets(self, field, lbl, widget):

        layout = self.dlg_config.tab_main.findChild(QGridLayout, field['layoutname'])
        if layout is not None:
            layout.addWidget(lbl, field['layoutorder'], 0)

            if field['widgettype'] == 'checkbox' or field['widgettype'] == 'check':
                layout.addWidget(widget, field['layoutorder'], 1)
            elif self.tab == 'user':
                layout.addWidget(self.chk, field['layoutorder'], 1)
                layout.addWidget(widget, field['layoutorder'], 2)
            else:
                layout.addWidget(widget, field['layoutorder'], 2)

    # endregion