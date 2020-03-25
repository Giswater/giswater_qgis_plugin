"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: latin-1 -*-
from qgis.gui import QgsDateTimeEdit
from qgis.PyQt.QtCore import QDate
from qgis.PyQt.QtWidgets import QComboBox, QCheckBox, QDateEdit, QDoubleSpinBox, QGroupBox, QSpacerItem, QSizePolicy
from qgis.PyQt.QtWidgets import QGridLayout, QWidget, QLabel, QTextEdit, QLineEdit

import json
import operator
from functools import partial

from .. import utils_giswater
from .api_parent import ApiParent
from ..ui_manager import ConfigUi


class ApiConfig(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'om_ws' """
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)


    def set_project_type(self, project_type):
        self.project_type = project_type


    def api_config(self):
        """ Button 99: Dynamic config form """

        # Remove layers name from temp_table
        sql = "DELETE FROM temp_table WHERE fprocesscat_id = '63' AND user_name = current_user;"
        self.controller.execute_sql(sql)
        # Set layers name in temp_table
        self.set_layers_name()

        # Get user and role
        super_users = self.settings.value('system_variables/super_users')
        cur_user = self.controller.get_current_user()

        self.list_update = []
        body = self.create_body(form='"formName":"config"')
        complet_list = self.controller.get_json('gw_api_getconfig', body, log_sql=True)
        if not complet_list: return False

        self.dlg_config = ConfigUi()
        self.load_settings(self.dlg_config)
        self.dlg_config.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_config))
        self.dlg_config.btn_accept.clicked.connect(partial(self.update_values))

        page1_layout1 = self.dlg_config.tab_main.findChild(QGridLayout, 'page1_layout1')
        page1_layout2 = self.dlg_config.tab_main.findChild(QGridLayout, 'page1_layout2')
        page2_layout1 = self.dlg_config.tab_main.findChild(QGridLayout, 'page2_layout1')
        page2_layout2 = self.dlg_config.tab_main.findChild(QGridLayout, 'page2_layout2')

        admin_layout1 = self.dlg_config.tab_main.findChild(QGridLayout, 'admin_layout1')
        admin_layout2 = self.dlg_config.tab_main.findChild(QGridLayout, 'admin_layout2')

        man_layout1 = self.dlg_config.tab_main.findChild(QGridLayout, 'man_layout1')
        man_layout2 = self.dlg_config.tab_main.findChild(QGridLayout, 'man_layout2')

        addfields_layout1 = self.dlg_config.tab_main.findChild(QGridLayout, 'addfields_layout1')

        groupBox_1 = QGroupBox("Basic")
        groupBox_2 = QGroupBox("O&&M")
        groupBox_3 = QGroupBox("Inventory")
        groupBox_4 = QGroupBox("Mapzones")
        groupBox_5 = QGroupBox("Edit")
        groupBox_6 = QGroupBox("Epa")
        groupBox_7 = QGroupBox("MasterPlan")
        groupBox_8 = QGroupBox("Other")

        groupBox_9 = QGroupBox("Node")
        groupBox_10 = QGroupBox("Arc")
        groupBox_11 = QGroupBox("Utils")
        groupBox_12 = QGroupBox(f"Connec&&Gully")

        groupBox_13 = QGroupBox("Topology")
        groupBox_14 = QGroupBox("Builder")
        groupBox_15 = QGroupBox("Review")
        groupBox_16 = QGroupBox("Analysis")
        groupBox_17 = QGroupBox("System")

        groupBox_18 = QGroupBox("Fluid type")
        groupBox_19 = QGroupBox("Location type")
        groupBox_20 = QGroupBox("Category type")
        groupBox_21 = QGroupBox("Function type")

        groupBox_22 = QGroupBox("Addfields")


        self.basic_form = QGridLayout()
        self.om_form = QGridLayout()
        self.inventory_form = QGridLayout()
        self.mapzones_form = QGridLayout()
        self.cad_form = QGridLayout()
        self.epa_form = QGridLayout()
        self.masterplan_form = QGridLayout()
        self.other_form = QGridLayout()

        self.node_type_form = QGridLayout()
        self.cat_form = QGridLayout()
        self.utils_form = QGridLayout()
        self.connec_form = QGridLayout()

        self.topology_form = QGridLayout()
        self.builder_form = QGridLayout()
        self.review_form = QGridLayout()
        self.analysis_form = QGridLayout()
        self.system_form = QGridLayout()

        self.fluid_type_form = QGridLayout()
        self.location_type_form = QGridLayout()
        self.category_type_form = QGridLayout()
        self.function_type_form = QGridLayout()

        self.addfields_form = QGridLayout()

        # Construct form for config and admin
        self.construct_form_param_user(complet_list['body']['form']['formTabs'], 0)
        self.construct_form_param_system(complet_list['body']['form']['formTabs'], 1)

        groupBox_1.setLayout(self.basic_form)
        groupBox_2.setLayout(self.om_form)
        groupBox_3.setLayout(self.inventory_form)
        groupBox_4.setLayout(self.mapzones_form)
        groupBox_5.setLayout(self.cad_form)
        groupBox_6.setLayout(self.epa_form)
        groupBox_7.setLayout(self.masterplan_form)
        groupBox_8.setLayout(self.other_form)

        groupBox_9.setLayout(self.node_type_form)
        groupBox_10.setLayout(self.cat_form)
        groupBox_11.setLayout(self.utils_form)
        groupBox_12.setLayout(self.connec_form)

        groupBox_13.setLayout(self.topology_form)
        groupBox_14.setLayout(self.builder_form)
        groupBox_15.setLayout(self.review_form)
        groupBox_16.setLayout(self.analysis_form)
        groupBox_17.setLayout(self.system_form)

        groupBox_18.setLayout(self.fluid_type_form)
        groupBox_19.setLayout(self.location_type_form)
        groupBox_20.setLayout(self.category_type_form)
        groupBox_21.setLayout(self.function_type_form)

        groupBox_22 .setLayout(self.addfields_form)

        page1_layout1.addWidget(groupBox_1)
        page1_layout1.addWidget(groupBox_2)
        page1_layout1.addWidget(groupBox_3)
        page1_layout1.addWidget(groupBox_4)
        page1_layout2.addWidget(groupBox_5)
        page1_layout2.addWidget(groupBox_6)
        page1_layout2.addWidget(groupBox_7)
        page1_layout2.addWidget(groupBox_8)

        page2_layout1.addWidget(groupBox_9)
        page2_layout1.addWidget(groupBox_10)
        page2_layout2.addWidget(groupBox_11)
        page2_layout2.addWidget(groupBox_12)

        admin_layout1.addWidget(groupBox_13)
        admin_layout2.addWidget(groupBox_14)
        admin_layout2.addWidget(groupBox_15)
        admin_layout2.addWidget(groupBox_16)
        admin_layout2.addWidget(groupBox_17)

        man_layout1.addWidget(groupBox_18)
        man_layout2.addWidget(groupBox_19)
        man_layout2.addWidget(groupBox_20)
        man_layout2.addWidget(groupBox_21)

        addfields_layout1.addWidget(groupBox_22)

        verticalSpacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)

        page1_layout1.addItem(verticalSpacer1)
        page1_layout2.addItem(verticalSpacer1)
        page2_layout1.addItem(verticalSpacer1)
        page2_layout2.addItem(verticalSpacer1)
        admin_layout1.addItem(verticalSpacer1)
        admin_layout2.addItem(verticalSpacer1)
        man_layout1.addItem(verticalSpacer1)
        man_layout2.addItem(verticalSpacer1)
        addfields_layout1.addItem(verticalSpacer1)

        # Event on change from combo parent
        self.get_event_combo_parent(complet_list['body']['form']['formTabs'])

        # Set signals Combo parent/child
        chk_expl = self.dlg_config.tab_main.findChild(QWidget, 'chk_exploitation_vdefault')
        chk_dma = self.dlg_config.tab_main.findChild(QWidget, 'chk_dma_vdefault')
        if chk_dma and chk_expl:
            chk_dma.stateChanged.connect(partial(self.check_child_to_parent, chk_dma, chk_expl))
            chk_expl.stateChanged.connect(partial(self.check_parent_to_child,  chk_expl, chk_dma))
        self.hide_void_groupbox(self.dlg_config)
        # Check user/role and remove tabs
        role_admin = self.controller.check_role_user("role_admin", cur_user)
        if not role_admin and cur_user not in super_users:
            utils_giswater.remove_tab_by_tabName(self.dlg_config.tab_main, "tab_admin")

        # Open form
        self.open_dialog(self.dlg_config, dlg_name='config')
        


    def construct_form_param_user(self, row, pos):

        widget = None
        for field in row[pos]['fields']:
            if field['label']:
                lbl = QLabel()
                lbl.setObjectName('lbl' + field['widgetname'])
                lbl.setText(field['label'])
                lbl.setMinimumSize(160, 0)
                lbl.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Preferred)
                lbl.setToolTip(field['tooltip'])

                chk = QCheckBox()
                chk.setObjectName('chk_' + field['widgetname'])
                if field['checked'] == "True":
                    chk.setChecked(True)
                elif field['checked'] == "False":
                    chk.setChecked(False)
                chk.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)

                if field['widgettype'] == 'text' or field['widgettype'] == 'linetext':
                    widget = QLineEdit()
                    widget.setText(field['value'])
                    widget.editingFinished.connect(partial(self.get_values_changed_param_user, chk, widget, field))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'textarea':
                    widget = QTextEdit()
                    widget.setText(field['value'])
                    widget.editingFinished.connect(partial(self.get_values_changed_param_user, chk, widget, field))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'combo':
                    widget = QComboBox()
                    self.populate_combo(widget, field)
                    widget.currentIndexChanged.connect(partial(self.get_values_changed_param_user, chk, widget, field))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'check':
                    widget = chk
                    widget.stateChanged.connect(partial(self.get_values_changed_param_user, chk, chk, field))
                    widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
                elif field['widgettype'] == 'datepickertime':
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
                    widget.dateChanged.connect(partial(self.get_values_changed_param_user, chk, widget, field))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'spinbox':
                    widget = QDoubleSpinBox()
                    if 'value' in field and field['value'] is not None:
                        value = float(str(field['value']))
                        widget.setValue(value)
                    widget.valueChanged.connect(partial(self.get_values_changed_param_user, chk, widget, field))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                else:
                    pass

                widget.setObjectName(field['widgetname'])

                # Set signals
                chk.stateChanged.connect(partial(self.get_values_checked_param_user, chk, widget, field))

                if field['layoutname'] == 'lyt_basic':
                    self.order_widgets(field, self.basic_form, lbl, chk, widget)
                elif field['layoutname'] == 'lyt_om':
                    self.order_widgets(field, self.om_form, lbl, chk, widget)
                elif field['layoutname'] == 'lyt_inventory':
                    self.order_widgets(field, self.inventory_form, lbl, chk, widget)
                elif field['layoutname'] == 'lyt_mapzones':
                    self.order_widgets(field, self.mapzones_form, lbl, chk, widget)
                elif field['layoutname'] == 'lyt_edit':
                    self.order_widgets(field, self.cad_form, lbl, chk, widget)
                elif field['layoutname'] == 'lyt_epa':
                    self.order_widgets(field, self.epa_form, lbl, chk, widget)
                elif field['layoutname'] == 'lyt_masterplan':
                    self.order_widgets(field, self.masterplan_form, lbl, chk, widget)
                elif field['layoutname'] == 'lyt_other':
                    self.order_widgets(field, self.other_form, lbl, chk, widget)
                elif field['layoutname'] == 'lyt_node_vdef':
                    self.order_widgets(field, self.node_type_form, lbl, chk, widget)
                elif field['layoutname'] == 'lyt_arc_vdef':
                    self.order_widgets(field, self.cat_form, lbl, chk, widget)
                elif field['layoutname'] == 'lyt_utils_vdef':
                    self.order_widgets(field, self.utils_form, lbl, chk, widget)
                elif field['layoutname'] == 'lyt_connec_gully_vdef':
                    self.order_widgets(field, self.connec_form, lbl, chk, widget)
                elif field['layoutname'] == 'lyt_fluid_type':
                    self.order_widgets(field, self.fluid_type_form, lbl, chk, widget)
                elif field['layoutname'] == 'lyt_location_type':
                    self.order_widgets(field, self.location_type_form, lbl, chk, widget)
                elif field['layoutname'] == 'lyt_category_type':
                    self.order_widgets(field, self.category_type_form, lbl, chk, widget)
                elif field['layoutname'] == 'lyt_function_type':
                    self.order_widgets(field, self.function_type_form, lbl, chk, widget)
                elif field['layoutname'] == 'lyt_addfields':
                    self.order_widgets(field, self.addfields_form, lbl, chk, widget)


    def construct_form_param_system(self, row, pos):

        widget = None
        for field in row[pos]['fields']:
            if field['label']:
                lbl = QLabel()
                lbl.setObjectName('lbl' + field['widgetname'])
                lbl.setText(field['label'])
                lbl.setMinimumSize(160, 0)
                lbl.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Preferred)
                lbl.setToolTip(field['tooltip'])

                if field['widgettype'] == 'text' or field['widgettype'] == 'linetext':
                    widget = QLineEdit()
                    widget.setText(field['value'])
                    widget.editingFinished.connect(partial(self.get_values_changed_param_system, widget))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'textarea':
                    widget = QTextEdit()
                    widget.setText(field['value'])
                    widget.editingFinished.connect(partial(self.get_values_changed_param_system, widget))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'combo':
                    widget = QComboBox()
                    self.populate_combo(widget, field)
                    widget.currentIndexChanged.connect(partial(self.get_values_changed_param_system, widget))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'checkbox' or field['widgettype'] == 'check':
                    widget = QCheckBox()
                    if field['value'].lower() == 'true':
                        widget.setChecked(True)
                    elif field['value'].lower() == 'FALSE':
                        widget.setChecked(False)
                    widget.stateChanged.connect(partial(self.get_values_changed_param_system, widget))
                    widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
                elif field['widgettype'] == 'datepickertime':
                    widget = QDateEdit()
                    widget.setCalendarPopup(True)
                    if field['value']: field['value'] = field['value'].replace('/', '-')
                    date = QDate.fromString(field['value'], 'yyyy-MM-dd')
                    widget.setDate(date)
                    widget.dateChanged.connect(partial(self.get_values_changed_param_system, widget))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'spinbox':
                    widget = QDoubleSpinBox()
                    if 'value' in field and field['value'] is not None:
                        value = float(str(field['value']))
                        widget.setValue(value)
                    widget.valueChanged.connect(partial(self.get_values_changed_param_system, widget))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                else:
                    pass

                if widget:
                    widget.setObjectName(field['widgetname'])
                else:
                    pass

                # Order Widgets
                if 'layoutname' in field:
                    if field['layoutname'] == 'lyt_topology':
                        self.order_widgets_system(field, self.topology_form, lbl,  widget)
                    elif field['layoutname'] == 'lyt_builder':
                        self.order_widgets_system(field, self.builder_form, lbl,  widget)
                    elif field['layoutname'] == 'lyt_review':
                        self.order_widgets_system(field, self.review_form, lbl,  widget)
                    elif field['layoutname'] == 'lyt_analysis':
                        self.order_widgets_system(field, self.analysis_form, lbl,  widget)
                    elif field['layoutname'] == 'lyt_system':
                        self.order_widgets_system(field, self.system_form, lbl,  widget)


    def get_event_combo_parent(self, row):

        for field in row[0]["fields"]:
            if field['isparent']:
                widget = self.dlg_config.findChild(QComboBox, field['widgetname'])
                if widget:
                    widget.currentIndexChanged.connect(partial(self.fill_child, widget))


    def populate_combo(self, widget, field):

        # Generate list of items to add into combo
        widget.blockSignals(True)
        widget.clear()
        widget.blockSignals(False)
        combolist = []
        if 'comboIds' in field:
            for i in range(0, len(field['comboIds'])):
                elem = [field['comboIds'][i], field['comboNames'][i]]
                combolist.append(elem)
            records_sorted = sorted(combolist, key=operator.itemgetter(1))
            # Populate combo
            for record in records_sorted:
                widget.addItem(record[1], record)
        if 'value' in field:
            if str(field['value']) != 'None':
                utils_giswater.set_combo_itemData(widget, field['value'], 0)


    def fill_child(self, widget):

        combo_parent = widget.objectName()
        combo_id = utils_giswater.get_item_data(self.dlg_config, widget)
        # TODO cambiar por gw_api_getchilds
        sql = f"SELECT gw_api_get_combochilds('config' ,'' ,'' ,'{combo_parent}', '{combo_id}','')"
        row = self.controller.get_row(sql, log_sql=True)
        #TODO::Refactor input and output for function "gw_api_get_combochilds" and refactor "row[0]['fields']"
        for combo_child in row[0]['fields']:
            if combo_child is not None:
                self.populate_child(combo_child)


    def populate_child(self, combo_child):

        child = self.dlg_config.findChild(QComboBox, str(combo_child['widgetname']))
        if child:
            self.populate_combo(child, combo_child)


    def order_widgets(self, field, form, lbl, chk, widget):

        form.addWidget(lbl, field['layout_order'], 0)
        if field['widgettype'] != 'check':
            form.addWidget(chk, field['layout_order'], 1)
            form.addWidget(widget, field['layout_order'], 2)
        else:
            form.addWidget(chk, field['layout_order'], 1)


    def order_widgets_system(self, field, form, lbl,  widget):

        form.addWidget(lbl, field['layout_order'], 0)
        if field['widgettype'] == 'checkbox' or field['widgettype'] == 'check':
            form.addWidget(widget, field['layout_order'], 2)
        elif field['widgettype'] != 'checkbox' and field['widgettype'] != 'check':
            form.addWidget(widget, field['layout_order'], 3)
        else:
            form.addWidget(widget, field['layout_order'], 1)


    def get_values_checked_param_user(self, chk, widget, field, value=None):

        elem = {}

        elem['widget'] = str(widget.objectName())
        elem['chk'] = str(chk.objectName())

        if type(widget) is QLineEdit:
            value = utils_giswater.getWidgetText(self.dlg_config, widget, return_string_null=False)
            elem['widget_type'] = 'text'
        elif type(widget) is QComboBox:
            value = utils_giswater.get_item_data(self.dlg_config, widget, 0)
            elem['widget_type'] = 'combo'
        elif type(widget) is QCheckBox:
            value = utils_giswater.isChecked(self.dlg_config, chk)
            elem['widget_type'] = 'check'
        elif type(widget) is QDateEdit:
            value = utils_giswater.getCalendarDate(self.dlg_config, widget)
            elem['widget_type'] = 'datepickertime'
        elif type(widget) is QgsDateTimeEdit:
            value = utils_giswater.getCalendarDate(self.dlg_config, widget)
            elem['widget_type'] = 'datepickertime'
            
        elem['isChecked'] = str(utils_giswater.isChecked(self.dlg_config, chk))
        elem['value'] = value

        self.list_update.append(elem)


    def get_values_changed_param_user(self, chk, widget, field, value=None):

        elem = {}
        if type(widget) is QLineEdit:
            value = utils_giswater.getWidgetText(self.dlg_config, widget, return_string_null=False)
        elif type(widget) is QComboBox:
            value = utils_giswater.get_item_data(self.dlg_config, widget, 0)
        elif type(widget) is QCheckBox:
            value = utils_giswater.isChecked(self.dlg_config, chk)
        elif type(widget) is QDateEdit:
            value = utils_giswater.getCalendarDate(self.dlg_config, widget)
        elif type(widget) is QgsDateTimeEdit:
            value = utils_giswater.getCalendarDate(self.dlg_config, widget)
        if chk.isChecked():
            elem['widget'] = str(widget.objectName())
            elem['chk'] = str(chk.objectName())
            elem['isChecked'] = str(utils_giswater.isChecked(self.dlg_config, chk))
            elem['value'] = value

            self.list_update.append(elem)


    def get_values_changed_param_system(self, widget, value=None):

        elem = {}

        if type(widget) is QLineEdit:
            value = utils_giswater.getWidgetText(self.dlg_config, widget, return_string_null=False)
        elif type(widget) is QComboBox:
            value = utils_giswater.get_item_data(self.dlg_config, widget, 0)
        elif type(widget) is QCheckBox:
            value = utils_giswater.isChecked(self.dlg_config, widget)
        elif type(widget) is QDateEdit:
            value = utils_giswater.getCalendarDate(self.dlg_config, widget)

        elem['widget'] = str(widget.objectName())
        elem['chk'] = str('')
        elem['isChecked'] = str('')
        elem['value'] = value

        self.list_update.append(elem)


    def update_values(self):

        my_json = json.dumps(self.list_update)
        extras = f'"fields":{my_json}'
        body = self.create_body(form='"formName":"config"', extras=extras)
        result = self.controller.get_json('gw_api_setconfig', body, log_sql=True)
        if not result: return False

        message = "Values has been updated"
        self.controller.show_info(message)
        # Close dialog
        self.close_dialog(self.dlg_config)


    def check_child_to_parent(self, widget_child, widget_parent):
        if widget_child.isChecked():
            widget_parent.setChecked(True)


    def check_parent_to_child(self, widget_parent, widget_child):
        if not widget_parent.isChecked():
            widget_child.setChecked(False)


    def set_layers_name(self):
        """ Insert the name of all the TOC layers, then populate the cad_combo_layers """
        layers = self.iface.mapCanvas().layers()
        if not layers:
            return
        layers_name = '{"list_layers_name":"{'
        tables_name = '"list_tables_name":"{'
        for layer in layers:
            layers_name += f"{layer.name()}, "
            tables_name += f"{self.controller.get_layer_source_table_name(layer)}, "

        result = layers_name[:-2] + '}", ' + tables_name[:-2] + '}"}'

        sql = (f'INSERT INTO temp_table (fprocesscat_id, text_column, user_name) VALUES (63, $${result}$$, current_user);')
        self.controller.execute_sql(sql, log_sql = True)