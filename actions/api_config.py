"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: latin-1 -*-
from collections import OrderedDict

try:
    from qgis.core import Qgis as Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4.QtCore import QDate
    from PyQt4.QtGui import QComboBox, QCheckBox, QDateEdit, QDoubleSpinBox, QGroupBox, QSpacerItem, QSizePolicy, QLineEdit
    from PyQt4.QtGui import QGridLayout, QWidget, QLabel
else:
    from qgis.PyQt.QtCore import QDate
    from qgis.PyQt.QtWidgets import QComboBox, QCheckBox, QDateEdit, QDoubleSpinBox, QGroupBox, QSpacerItem, QSizePolicy, QLineEdit, QGridLayout, QWidget, QLabel

import json
import sys
import operator
from functools import partial

import utils_giswater
from giswater.actions.api_parent import ApiParent
from giswater.ui_manager import ApiConfigUi


class ApiConfig(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'om_ws' """
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)


    def set_project_type(self, project_type):
        self.project_type = project_type


    def api_config(self):
        """ Button 36: Info show info, open giswater and visit web page """
        self.controller.restore_info()
        self.list_update = []

        body = '"client":{"device":3, "infoType":100, "lang":"ES"}, '
        body += '"form":{"formName":"config"}, '
        body += '"feature":{}, '
        body += '"data":{}'

        # Get layers under mouse clicked
        sql = ("SELECT " + self.schema_name + ".gw_api_getconfig($${" + body + "}$$)::text")

        row = self.controller.get_row(sql, log_sql=True)
        complet_list = [json.loads(row[0], object_pairs_hook=OrderedDict)]

        self.dlg_config = ApiConfigUi()
        self.load_settings(self.dlg_config)
        self.dlg_config.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_config))
        self.dlg_config.btn_accept.clicked.connect(partial(self.update_values))

        page1_layout1 = self.dlg_config.tab_main.findChild(QGridLayout, 'page1_layout1')
        page1_layout2 = self.dlg_config.tab_main.findChild(QGridLayout, 'page1_layout2')
        page2_layout1 = self.dlg_config.tab_main.findChild(QGridLayout, 'page2_layout1')
        page2_layout2 = self.dlg_config.tab_main.findChild(QGridLayout, 'page2_layout2')

        admin_layout1 = self.dlg_config.tab_main.findChild(QGridLayout, 'admin_layout1')
        admin_layout2 = self.dlg_config.tab_main.findChild(QGridLayout, 'admin_layout2')

        groupBox_1 = QGroupBox("Basic")
        groupBox_2 = QGroupBox("Om")
        groupBox_3 = QGroupBox("Workcat")
        groupBox_4 = QGroupBox("Mapzones")
        groupBox_5 = QGroupBox("Cad")
        groupBox_6 = QGroupBox("Epa")
        groupBox_7 = QGroupBox("MasterPlan")
        groupBox_8 = QGroupBox("Other")
        groupBox_9 = QGroupBox("Node ws / Type ud")
        groupBox_10 = QGroupBox("Cat ud")
        groupBox_11 = QGroupBox("Utils")
        groupBox_12 = QGroupBox("Connec ws")
        groupBox_13 = QGroupBox("Topology")
        groupBox_14 = QGroupBox("Builder")
        groupBox_15 = QGroupBox("Review")
        groupBox_16 = QGroupBox("Analysis")
        groupBox_17 = QGroupBox("System")

        self.basic_form = QGridLayout()
        self.om_form = QGridLayout()
        self.workcat_form = QGridLayout()
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

        # Construct form for config and admin
        self.construct_form_param_user(complet_list[0]['body']['form']['formTabs'], 0)
        self.construct_form_param_system(complet_list[0]['body']['form']['formTabs'], 1)

        groupBox_1.setLayout(self.basic_form)
        groupBox_2.setLayout(self.om_form)
        groupBox_3.setLayout(self.workcat_form)
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
        admin_layout2.addWidget(groupBox_17)
        admin_layout2.addWidget(groupBox_14)
        admin_layout2.addWidget(groupBox_15)
        admin_layout2.addWidget(groupBox_16)

        verticalSpacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        verticalSpacer2 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        verticalSpacer3 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        verticalSpacer4 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        verticalSpacer5 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        verticalSpacer6 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)

        page1_layout1.addItem(verticalSpacer1)
        page1_layout2.addItem(verticalSpacer2)
        page2_layout1.addItem(verticalSpacer3)
        page2_layout2.addItem(verticalSpacer4)
        admin_layout1.addItem(verticalSpacer5)
        admin_layout2.addItem(verticalSpacer6)

        #TODO:
        # self.remove_empty_groupBox(page1_layout1)
        # self.remove_empty_groupBox(page1_layout2)
        # self.remove_empty_groupBox(page2_layout1)
        # self.remove_empty_groupBox(page2_layout2)
        # self.remove_empty_groupBox(admin_layout1)
        # self.remove_empty_groupBox(admin_layout2)

        # Event on change from combo parent
        self.get_event_combo_parent('fields', complet_list[0]['body']['form']['formTabs'])

        # Set signals Combo parent/child
        self.chk_expl = self.dlg_config.tab_main.findChild(QWidget, 'chk_exploitation_vdefault')
        self.chk_dma = self.dlg_config.tab_main.findChild(QWidget, 'chk_dma_vdefault')

        self.chk_dma.stateChanged.connect(partial(self.check_child_to_parent, self.chk_dma,self.chk_expl))
        self.chk_expl.stateChanged.connect(partial(self.check_parent_to_child,  self.chk_expl,self.chk_dma))

        # Open form
        self.dlg_config.show()


    def open_giswater(self):
        """ Open giswater.jar with last opened .gsw file """

        if 'nt' in sys.builtin_module_names:
            self.execute_giswater("ed_giswater_jar")
        else:
            self.controller.show_info("Function not supported in this Operating System")


    def construct_form_param_user(self, row, pos):

        for field in row[pos]['fields']:

            if field['label']:
                lbl = QLabel()
                lbl.setObjectName('lbl' + field['name'])
                lbl.setText(field['label'])
                lbl.setMinimumSize(160, 0)
                lbl.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Preferred)

                chk = QCheckBox()
                chk.setObjectName('chk_' + field['name'])
                if field['checked'] == "True":
                    chk.setChecked(True)
                elif field['checked'] == "False":
                    chk.setChecked(False)
                chk.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)

                if field['widgettype'] == 'linetext':
                    widget = QLineEdit()
                    widget.setText(field['value'])
                    widget.lostFocus.connect(partial(self.get_values_changed_param_user, chk, widget, field))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'combo':
                    widget = QComboBox()
                    self.populate_combo(widget, field)
                    widget.currentIndexChanged.connect(partial(self.get_values_changed_param_user, chk, widget, field))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'checkbox':
                    widget = chk
                    widget.stateChanged.connect(partial(self.get_values_changed_param_user, chk, chk, field))
                    widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
                elif field['widgettype'] == 'date':
                    widget = QDateEdit()
                    widget.setCalendarPopup(True)
                    date = QDate.fromString(field['value'], 'yyyy/MM/dd')
                    widget.setDate(date)
                    widget.dateChanged.connect(partial(self.get_values_changed_param_user, chk, widget, field))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'spinbox':
                    widget = QDoubleSpinBox()
                    if 'value' in field and field['value'] is not None:
                        value = float(str(field['value']))
                        widget.setValue(value)
                    widget.valueChanged.connect(partial(self.get_values_changed_param_user, chk, widget, field))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)

                widget.setObjectName(field['name'])

                # Set signals
                chk.stateChanged.connect(partial(self.get_values_checked_param_user, chk, widget, field))

                if field['layout_id'] == 1:
                    self.order_widgets(field, self.basic_form, lbl, chk, widget)
                elif field['layout_id'] == 2:
                    self.order_widgets(field, self.om_form, lbl, chk, widget)
                elif field['layout_id'] == 3:
                    self.order_widgets(field, self.workcat_form, lbl, chk, widget)
                elif field['layout_id'] == 4:
                    self.order_widgets(field, self.mapzones_form, lbl, chk, widget)
                elif field['layout_id'] == 5:
                    self.order_widgets(field, self.cad_form, lbl, chk, widget)
                elif field['layout_id'] == 6:
                    self.order_widgets(field, self.epa_form, lbl, chk, widget)
                elif field['layout_id'] == 7:
                    self.order_widgets(field, self.masterplan_form, lbl, chk, widget)
                elif field['layout_id'] == 8:
                    self.order_widgets(field, self.other_form, lbl, chk, widget)
                elif field['layout_id'] == 9:
                    self.order_widgets(field, self.node_type_form, lbl, chk, widget)
                elif field['layout_id'] == 10:
                    self.order_widgets(field, self.cat_form, lbl, chk, widget)
                elif field['layout_id'] == 11:
                    self.order_widgets(field, self.utils_form, lbl, chk, widget)
                elif field['layout_id'] == 12:
                    self.order_widgets(field, self.connec_form, lbl, chk, widget)
                elif field['layout_id'] == 13:
                    self.order_widgets(field, self.topology_form, lbl, chk, widget)
                elif field['layout_id'] == 14:
                    self.order_widgets(field, self.builder_form, lbl, chk, widget)
                elif field['layout_id'] == 15:
                    self.order_widgets(field, self.review_form, lbl, chk, widget)
                elif field['layout_id'] == 16:
                    self.order_widgets(field, self.analysis_form, lbl, chk, widget)
                elif field['layout_id'] == 17:
                    self.order_widgets(field, self.system_form, lbl, chk, widget)

    def construct_form_param_system(self, row, pos):
        for field in row[pos]['fields']:
            if field['label']:
                lbl = QLabel()
                lbl.setObjectName('lbl' + field['name'])
                lbl.setText(field['label'])
                lbl.setMinimumSize(160, 0)
                lbl.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Preferred)

                if field['widgettype'] == 'linetext':
                    widget = QLineEdit()
                    widget.setText(field['value'])
                    widget.lostFocus.connect(partial(self.get_values_changed_param_system, widget))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'combo':
                    widget = QComboBox()
                    self.populate_combo(widget, field)
                    widget.currentIndexChanged.connect(partial(self.get_values_changed_param_system, widget))
                    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                elif field['widgettype'] == 'checkbox':
                    widget = QCheckBox()
                    if field['value'].lower() == 'true':
                        widget.setChecked(True)
                    elif field['value'].lower() == 'false':
                        widget.setChecked(False)
                    widget.stateChanged.connect(partial(self.get_values_changed_param_system, widget))
                    widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
                elif field['widgettype'] == 'date':
                    widget = QDateEdit()
                    widget.setCalendarPopup(True)
                    date = QDate.fromString(field['value'], 'yyyy/MM/dd')
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

                widget.setObjectName(field['name'])


                # Order Widgets
                if field['layout_id'] == 1:
                    self.order_widgets_system(field, self.basic_form, lbl,  widget)
                elif field['layout_id'] == 2:
                    self.order_widgets_system(field, self.om_form, lbl,  widget)
                elif field['layout_id'] == 3:
                    self.order_widgets_system(field, self.workcat_form, lbl,  widget)
                elif field['layout_id'] == 4:
                    self.order_widgets_system(field, self.mapzones_form, lbl,  widget)
                elif field['layout_id'] == 5:
                    self.order_widgets_system(field, self.cad_form, lbl,  widget)
                elif field['layout_id'] == 6:
                    self.order_widgets_system(field, self.epa_form, lbl,  widget)
                elif field['layout_id'] == 7:
                    self.order_widgets_system(field, self.masterplan_form, lbl,  widget)
                elif field['layout_id'] == 8:
                    self.order_widgets_system(field, self.other_form, lbl,  widget)
                elif field['layout_id'] == 9:
                    self.order_widgets_system(field, self.node_type_form, lbl,  widget)
                elif field['layout_id'] == 10:
                    self.order_widgets_system(field, self.cat_form, lbl,  widget)
                elif field['layout_id'] == 11:
                    self.order_widgets_system(field, self.utils_form, lbl,  widget)
                elif field['layout_id'] == 12:
                    self.order_widgets_system(field, self.connec_form, lbl,  widget)
                elif field['layout_id'] == 13:
                    self.order_widgets_system(field, self.topology_form, lbl,  widget)
                elif field['layout_id'] == 14:
                    self.order_widgets_system(field, self.builder_form, lbl,  widget)
                elif field['layout_id'] == 15:
                    self.order_widgets_system(field, self.review_form, lbl,  widget)
                elif field['layout_id'] == 16:
                    self.order_widgets_system(field, self.analysis_form, lbl,  widget)
                elif field['layout_id'] == 17:
                    self.order_widgets_system(field, self.system_form, lbl,  widget)

    def get_event_combo_parent(self, fields, row):

        if fields == 'fields':
            for field in row[0]["fields"]:
                if field['isparent']:
                    widget = self.dlg_config.findChild(QComboBox, field['name'])
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

        sql = ("SELECT " + self.schema_name + ".gw_api_get_combochilds('config" + "' ,'' ,'' ,'" + str(combo_parent) + "', '" + str(combo_id) + "','')")
        row = self.controller.get_row(sql, log_sql=True)
        #TODO::Refactor input and output for function "gw_api_get_combochilds" and refactor "row[0]['fields']"
        for combo_child in row[0]['fields']:
            if combo_child is not None:
                self.populate_child(combo_child, row)


    def populate_child(self, combo_child, result):

        child = self.dlg_config.findChild(QComboBox, str(combo_child['childName']))
        if child:
            self.populate_combo(child, combo_child)


    def order_widgets(self, field, form, lbl, chk, widget):

        if field['widgettype'] != 'checkbox':
            form.addWidget(lbl, field['layout_order'], 0)
            form.addWidget(chk, field['layout_order'], 1)
            form.addWidget(widget, field['layout_order'], 2)
        else:
            form.addWidget(lbl, field['layout_order'], 0)
            form.addWidget(chk, field['layout_order'], 1)


    def order_widgets_system(self, field, form, lbl,  widget):


        if field['widgettype'] != 'checkbox':
            form.addWidget(lbl, field['layout_order'], 0)
            form.addWidget(widget, field['layout_order'], 2)
        else:
            form.addWidget(lbl, field['layout_order'], 0)
            form.addWidget(widget, field['layout_order'], 1)

    def get_values_checked_param_user(self, chk, widget, field, value=None):

        elem = {}
        elem['widget'] = str(widget.objectName())
        elem['chk'] = str(chk.objectName())

        if type(widget) is QLineEdit:
            value = utils_giswater.getWidgetText(self.dlg_config, widget, return_string_null=False)
        elif type(widget) is QComboBox:
            value = utils_giswater.get_item_data(self.dlg_config, widget, 0)
        elif type(widget) is QCheckBox:
            value = utils_giswater.isChecked(self.dlg_config, chk)
        elif type(widget) is QDateEdit:
            value = utils_giswater.getCalendarDate(self.dlg_config, widget)
        elem['widget'] = str(widget.objectName())
        elem['chk'] = str(chk.objectName())
        elem['isChecked'] = str(utils_giswater.isChecked(self.dlg_config, chk))
        elem['value'] = value
        if 'sys_role_id' in field:
            elem['sys_role_id'] = str(field['sys_role_id'])
        else:
            elem['sys_role_id'] = 'role_admin'

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

        if chk.isChecked():
            elem['widget'] = str(widget.objectName())
            elem['chk'] = str(chk.objectName())
            elem['isChecked'] = str(utils_giswater.isChecked(self.dlg_config, chk))
            elem['value'] = value
            elem['sys_role_id'] = str(field['sys_role_id'])
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
        elem['sysRoleId'] = 'role_admin'

        self.list_update.append(elem)


    def update_values(self):

        my_json = json.dumps(self.list_update)
        body = '"client":{"device":3, "infoType":100, "lang":"ES"}, '
        body += '"form":{"formName":"config"}, '
        body += '"feature":{}, '
        body += '"data":{"fields":'+my_json+'}'

        sql = ("SELECT " + self.schema_name + ".gw_api_setconfig($${" + body + "}$$)")
        self.controller.log_info(str(sql))
        self.controller.execute_sql(sql)

        message = "Values has been updated"
        self.controller.show_info(message)
        # Close dialog
        self.close_dialog(self.dlg_config)


    def check_child_to_parent(self, widget_child, widget_parent):
        if widget_child.isChecked():
            widget_parent.setChecked(True)


    def check_parent_to_child(self, widget_parent, widget_child):
        if widget_parent.isChecked() == False:
            widget_child.setChecked(False)


    # TODO:
    def remove_empty_groupBox(self, layout):

        self.controller.log_info(str("TEST"))
        groupBox_list = layout.findChild(QWidget)
        self.controller.log_info(str(layout.objectName()))
        self.controller.log_info(str(groupBox_list))
        if groupBox_list is None:
            return
        for groupBox in groupBox_list:
            widget_list = groupBox.findChildren(QWidget)
            if not widget_list:
                groupBox.setVisible(False)