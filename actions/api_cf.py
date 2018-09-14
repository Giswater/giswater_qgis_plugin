"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: latin-1 -*-
import json
import operator
import os
import subprocess
import sys
import webbrowser
import operator

from functools import partial

from PyQt4.QtCore import Qt, SIGNAL, SLOT
from PyQt4.QtGui import QApplication, QIntValidator, QDoubleValidator
from PyQt4.QtGui import QWidget, QAction, QPushButton, QLabel, QLineEdit, QComboBox, QCheckBox
from PyQt4.QtGui import QGridLayout, QSpacerItem, QSizePolicy, QStringListModel, QCompleter
from actions.HyperLinkLabel import HyperLinkLabel
from qgis.gui import QgsMessageBar, QgsMapCanvasSnapper, QgsMapToolEmitPoint,  QgsDateTimeEdit

import utils_giswater
from giswater.actions.api_parent import ApiParent
from catalog import Catalog
from ui_manager import ApiCfUi
from ui_manager import NewWorkcat


class ApiCF(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class constructor """
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir


    def api_info(self):
        """ Button 37: Own Giswater info """

        # Create the appropriate map tool and connect the gotPoint() signal.
        QApplication.setOverrideCursor(Qt.WhatsThisCursor)
        self.canvas = self.iface.mapCanvas()
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.emit_point.canvasClicked.connect(self.get_point)


    def get_point(self, point, button_clicked):
        if button_clicked == Qt.LeftButton:
            self.open_form(point)
        elif button_clicked == Qt.RightButton:
            QApplication.restoreOverrideCursor()
            # TODO buscar la QAction concreta y deschequearla
            actions = self.iface.mainWindow().findChildren(QAction)
            for a in actions:
                a.setChecked(False)

            self.emit_point.canvasClicked.disconnect()


    def open_form(self, point=None, table_name=None, node_type=None, node_id=None):

        """
        :param point: point where use clicked
        :param table_name: table where do sql query
        :param node_type: (arc, node, connec...)
        :param node_id: id of feature to do info
        :return:
        """
        self.dlg_is_destroyed = False
        self.layer = None
        self.my_json = ''
        # Get srid
        self.srid = self.controller.plugin_settings_value('srid')

        # Dialog
        self.dlg_cf = ApiCfUi()
        self.load_settings(self.dlg_cf)

        if node_id:
            self.dlg_cf.setGeometry(self.dlg_cf.pos().x() + 25, self.dlg_cf.pos().y() + 25, self.dlg_cf.width(),
                                    self.dlg_cf.height())

        # Actions
        action_edit = self.dlg_cf.findChild(QAction, "actionEdit")
        action_copy_paste = self.dlg_cf.findChild(QAction, "actionCopyPaste")
        action_rotation = self.dlg_cf.findChild(QAction, "actionRotation")
        action_catalog = self.dlg_cf.findChild(QAction, "actionCatalog")
        action_workcat = self.dlg_cf.findChild(QAction, "actionWorkcat")
        action_zoom = self.dlg_cf.findChild(QAction, "actionZoom")
        action_zoom_out = self.dlg_cf.findChild(QAction, "actionZoomOut")
        action_centered = self.dlg_cf.findChild(QAction, "actionCentered")
        action_link = self.dlg_cf.findChild(QAction, "actionLink")
        # action_switch_arc_id = self.dlg_cf.findChild(QAction, "actionSwicthArcid")


        # Set actions icon
        self.set_icon(action_edit, "101")
        self.set_icon(action_copy_paste, "107b")
        self.set_icon(action_rotation, "107c")
        # self.set_icon(action_catalog, "107c")
        # self.set_icon(action_workcat, "107c")
        self.set_icon(action_zoom, "103")
        self.set_icon(action_zoom_out, "107")
        self.set_icon(action_centered, "104")
        self.set_icon(action_link, "173")
        # self.set_icon(action_switch_arc_id, "141")

        # Layouts
        top_layout = self.dlg_cf.findChild(QGridLayout, 'top_layout')
        tab1_layout1 = self.dlg_cf.findChild(QGridLayout, 'tab1_layout1')
        tab1_layout2 = self.dlg_cf.findChild(QGridLayout, 'tab1_layout2')
        tab1_layout3 = self.dlg_cf.findChild(QGridLayout, 'tab1_layout3')
        bot_layout_1 = self.dlg_cf.findChild(QGridLayout, 'bot_layout_1')
        bot_layout_2 = self.dlg_cf.findChild(QGridLayout, 'bot_layout_2')

        if self.iface.activeLayer() is None:
            active_layer = ""
        else:
            active_layer = self.controller.get_layer_source_table_name(self.iface.activeLayer())

        visible_layers = self.get_visible_layers()
        # TODO editables han de ser null
        # editable_layers = self.get_editable_layers()
        editable_layers = ''
        scale_zoom = self.iface.mapCanvas().scale()
        if point:
            sql = ("SELECT " + self.schema_name + ".gw_api_get_infofromcoordinates(" + str(point.x()) + ", "
                   + str(point.y())+" ,"+str(self.srid) + ", '"+str(active_layer)+"', '"+str(visible_layers)+"', '"
                   + str(editable_layers)+"', "+str(scale_zoom)+", 9, 100)")
        elif node_id:
            sql = ("SELECT the_geom FROM " + self.schema_name + "."+table_name+" WHERE "+str(node_type)+"_id = '" + str(node_id) + "'")
            row = self.controller.get_row(sql, log_sql=True)
            sql = ("SELECT " + self.schema_name + ".gw_api_get_infofromid('"+str(table_name)+"', '"+str(node_id)+"',"
                   " '" + str(row[0])+"', True, 9, 100)")
        row = self.controller.get_row(sql, log_sql=True)
        if not row:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return
        complet_result = row
        result = row[0]['editData']
        if 'fields' not in result:
            return

        # Get table name for use as title
        self.tablename = row[0]['tableName']
        pos_ini = row[0]['tableName'].rfind("_")
        pos_fi = len(str(row[0]['tableName']))
        self.node_type = row[0]['tableName'][pos_ini+1:pos_fi]
        self.dlg_cf.setWindowTitle(self.node_type.capitalize())

        # Get tableParent and select layer
        table_parent = str(row[0]['tableParent'])
        self.layer = self.controller.get_layer_by_tablename(table_parent)
        self.iface.setActiveLayer(self.layer)

        # Get field id name
        field_id = str(row[0]['idName'])
        feature_id = None

        for field in result["fields"]:
            label = QLabel()
            label.setObjectName('lbl_' + field['form_label'])
            label.setText(field['form_label'].capitalize())
            if field['widgettype'] == 1 or field['widgettype'] == 10:
                widget = self.add_lineedit(self.dlg_cf, field)
                if widget.objectName() == field_id:
                    feature_id = widget.text()
            elif field['widgettype'] == 2:
                widget = self.add_combobox(self.dlg_cf, field)
            elif field['widgettype'] == 3:
                widget = self.add_checkbox(self.dlg_cf, field)
            elif field['widgettype'] == 4:
                widget = self.add_calendar(self.dlg_cf, field)
            elif field['widgettype'] == 6:
                pass
            elif field['widgettype'] == 8:
                widget = self.add_button(self.dlg_cf, field)
            elif field['widgettype'] == 9:
                widget = self.add_hyperlink(self.dlg_cf, field)
            if field['layout_id'] == 0:
                top_layout.addWidget(label, 0, field['layout_order'])
                top_layout.addWidget(widget, 1, field['layout_order'])
            elif field['layout_id'] == 1:
                tab1_layout1.addWidget(label, field['layout_order'], 0)
                tab1_layout1.addWidget(widget, field['layout_order'], 1)
                if field['widgettype'] == 8:
                    v = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
                    tab1_layout1.addItem(v, field['layout_order'], 2)
            elif field['layout_id'] == 2:
                tab1_layout2.addWidget(label, field['layout_order'], 0)
                tab1_layout2.addWidget(widget, field['layout_order'], 1)
            elif field['layout_id'] == 3:
                tab1_layout3.addWidget(label, field['layout_order'], 0)
                tab1_layout3.addWidget(widget, field['layout_order'], 1)
            elif field['layout_id'] == 4:
                bot_layout_1.addWidget(label, 0, field['layout_order'])
                bot_layout_1.addWidget(widget, 1, field['layout_order'])
            elif field['layout_id'] == 5:
                bot_layout_2.addWidget(label, 0, field['layout_order'])
                bot_layout_2.addWidget(widget, 1, field['layout_order'])

        verticalSpacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        tab1_layout1.addItem(verticalSpacer1)
        verticalSpacer2 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        tab1_layout2.addItem(verticalSpacer2)

        for field in result["fields"]:
            if field['dv_isparent']:
                widget = self.dlg_cf.findChild(QComboBox, field['column_id'])
                widget.currentIndexChanged.connect(partial(self.fill_child, self.dlg_cf, widget))

        if self.layer.isEditable():
            self.enable_all(result)
        else:
            self.disable_all(result, False)

        # SIGNALS

        self.layer.editingStarted.connect(partial(self.check_actions, action_edit, True))
        self.layer.editingStopped.connect(partial(self.check_actions, action_edit, False))
        self.layer.editingStarted.connect(partial(self.enable_all, result))
        self.layer.editingStopped.connect(partial(self.disable_all, result, False))

        # Actions
        self.enable_actions(self.dlg_cf, self.layer.isEditable())
        self.layer.editingStarted.connect(partial(self.enable_actions, self.dlg_cf, True))
        self.layer.editingStopped.connect(partial(self.enable_actions, self.dlg_cf, False))
        action_edit.setChecked(self.layer.isEditable())
        action_edit.triggered.connect(self.start_editing)
        action_catalog.triggered.connect(partial(self.open_catalog, self.dlg_cf, result))
        action_workcat.triggered.connect(partial(self.cf_new_workcat, self.dlg_cf))

        # Buttons
        btn_cancel = self.dlg_cf.findChild(QPushButton, 'btn_cancel')
        btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_cf))
        btn_accept = self.dlg_cf.findChild(QPushButton, 'btn_accept')
        btn_accept.clicked.connect(partial(self.accept, complet_result[0], feature_id))
        self.dlg_cf.dlg_closed.connect(partial(self.close_dialog, self.dlg_cf))

        #QApplication.restoreOverrideCursor()
        # Open dialog
        self.dlg_cf.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_cf.show()


    def accept(self, complet_result, feature_id):

        if self.my_json == '':
            self.close_dialog(self.dlg_cf)
            return

        my_json = '{' + self.my_json[:-2] + '}'
        p_table_id = complet_result['tableName']

        sql = ("SELECT " + self.schema_name + ".gw_api_set_upsertfields('"+str(p_table_id)+"', '"+str(feature_id)+""
               "',null, 9, 100, '"+str(my_json)+"')")
        row = self.controller.execute_returning(sql, log_sql=True)

        if "Accepted" in str(row[0]):
            message = "Values has been updated"
            self.controller.show_info(message)
            self.close_dialog(self.dlg_cf)


    def get_scale_zoom(self):
        scale_zoom = self.iface.mapCanvas().scale()
        return scale_zoom


    def disable_all(self, result, enable):
        if not self.dlg_is_destroyed:
            widget_list = self.dlg_cf.findChildren(QWidget)
            for widget in widget_list:
                for field in result['fields']:
                    if widget.objectName() == field['column_id']:
                        if type(widget) is QLineEdit:
                            widget.setReadOnly(not enable)
                            widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242);"
                                                 " color: rgb(100, 100, 100)}")
                        elif type(widget) is QComboBox:
                            widget.setEnabled(enable)
                        elif type(widget) is QCheckBox:
                            widget.setEnabled(enable)
                        elif type(widget) is QPushButton:
                            widget.setEnabled(enable)
                        elif type(widget) is QgsDateTimeEdit:
                            widget.setEnabled(enable)


    def enable_all(self, result):
        if not self.dlg_is_destroyed:
            widget_list = self.dlg_cf.findChildren(QWidget)
            for widget in widget_list:
                for field in result['fields']:
                    if widget.objectName() == field['column_id']:
                        if type(widget) is QLineEdit:
                            widget.setReadOnly(not field['iseditable'])
                            if not field['iseditable']:
                                widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242);"
                                                     " color: rgb(100, 100, 100)}")
                            else:
                                widget.setStyleSheet("QLineEdit { background: rgb(255, 255, 255);"
                                                     " color: rgb(0, 0, 0)}")

                        elif type(widget) is QComboBox:
                            widget.setEnabled(field['iseditable'])
                        elif type(widget) is QCheckBox:
                            widget.setEnabled(field['iseditable'])
                        elif type(widget) is QPushButton:
                            widget.setEnabled(field['iseditable'])
                        elif type(widget) is QgsDateTimeEdit:
                            widget.setEnabled(field['iseditable'])


    def enable_actions(self, dialog, enabled):
        """ Enable actions according if layer is editable or not"""
        dialog.actionCopyPaste.setEnabled(enabled)
        dialog.actionRotation.setEnabled(enabled)
        dialog.actionCatalog.setEnabled(enabled)
        dialog.actionWorkcat.setEnabled(enabled)
        #dialog.actionSwicthArcid.setEnabled(enabled)


    def get_values(self, dialog, widget, value=None):
        if type(widget) is QLineEdit and not widget.isReadOnly():
            value = utils_giswater.getWidgetText(dialog, widget, return_string_null=False)
        elif type(widget) is QComboBox and widget.isEnabled():
            value = utils_giswater.get_item_data(dialog, widget, 0)
        elif type(widget) is QCheckBox and widget.isEnabled():
            value = utils_giswater.isChecked(dialog, widget)
        elif type(widget) is QgsDateTimeEdit and widget.isEnabled():
            value = utils_giswater.getCalendarDate(dialog, widget)

        # Only get values if layer is editable
        if self.layer.isEditable():
            # If widget.isEditable(False) return None, here control it.
            if value is not None:
                self.my_json += '"'+str(widget.objectName())+'": "'+str(value)+'", '
        self.controller.log_info(str(self.my_json))

    def add_lineedit(self, dialog, field):

        widget = QLineEdit()
        widget.setObjectName(field['column_id'])
        if 'value' in field:
            widget.setText(field['value'])
        if 'iseditable' in field:
            widget.setReadOnly(not field['iseditable'])
            if not field['iseditable']:
                widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242);"
                                     " color: rgb(100, 100, 100)}")

        widget.lostFocus.connect(partial(self.get_values, dialog, widget))

        if 'datatype' in field:
            if field['datatype'] == 1:  # Integer
                widget.setValidator(QIntValidator())
            elif field['datatype'] == 2:  # String
                function_name = "test"
                widget.returnPressed.connect(partial(getattr(self, function_name)))
            elif field['datatype'] == 3:  # Date
                pass
            elif field['datatype'] == 4:  # Boolean
                pass
            elif field['datatype'] == 5:  # Double
                validator = QDoubleValidator()
                validator.setRange(-9999999.0, 9999999.0, 3)
                validator.setNotation(QDoubleValidator().StandardNotation)
                widget.setValidator(validator)

        if field['widgettype'] == 10:
            if 'dv_table' in field:
                table_name = field['dv_table']
                completer = QCompleter()
                model = QStringListModel()
                self.populate_lineedit(completer, model, table_name, dialog, widget, 'id')
                widget.textChanged.connect(partial(self.populate_lineedit, completer, model, table_name, dialog, widget, 'id'))
        return widget


    def add_combobox(self, dialog, field):
        widget = QComboBox()
        widget.setObjectName(field['column_id'])
        self.populate_combo(widget, field)
        if 'selectedId' in field:
            utils_giswater.set_combo_itemData(widget, field['selectedId'], 0)
        widget.currentIndexChanged.connect(partial(self.get_values, dialog, widget))

        return widget

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


    def fill_child(self, dialog, widget):
        combo_parent = widget.objectName()
        combo_id = utils_giswater.get_item_data(dialog, widget)
        sql = ("SELECT " + self.schema_name + ".gw_api_get_combochilds('" + str(self.tablename) + "' ,'' ,'' ,'" + str(combo_parent) + "', '" + str(combo_id) + "')")
        row = self.controller.get_row(sql, log_sql=True)
        for combo_child in row[0]['fields']:
            if combo_child is not None:
                self.populate_child(combo_child)


    def populate_child(self, combo_child):
        child = self.dlg_cf.findChild(QComboBox, str(combo_child['childName']))
        if child:
            self.populate_combo(child, combo_child)

    def add_checkbox(self, dialog, field):
        widget = QCheckBox()
        widget.setObjectName(field['column_id'])
        if 'value' in field:
            if field['value'] == "t":
                widget.setChecked(True)
        widget.stateChanged.connect(partial(self.get_values, dialog, widget))
        return widget


    def add_calendar(self, dialog, field):
        widget = QgsDateTimeEdit()
        widget.setObjectName(field['column_id'])
        widget.setCalendarPopup(True)
        return widget


    def add_button(self, dialog, field):
        widget = QPushButton()
        widget.setObjectName(field['column_id'])
        widget.setText(field['value'])
        # widget.setStyleSheet("Text-align:left; Text-decoration:underline")
        # widget.setFlat(True)
        widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
        widget.resize(widget.sizeHint().width(), widget.sizeHint().height())
        function_name = 'no_function_asociated'

        if 'button_function' in field:
            if field['button_function'] is not None:
                function_name = field['button_function']
            else:
                msg = ("parameter button_function is null for button " + widget.objectName())
                self.controller.show_message(msg, 2)
        else:
            msg = "parameter button_function not found"
            self.controller.show_message(msg, 2)

        widget.clicked.connect(partial(getattr(self, function_name), dialog, widget, 2))
        return widget

    def add_hyperlink(self, dialog, field):
        widget = HyperLinkLabel()
        widget.setObjectName(field['column_id'])
        widget.setText(field['value'])
        widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
        widget.resize(widget.sizeHint().width(), widget.sizeHint().height())
        function_name = 'no_function_asociated'

        if 'button_function' in field:
            if field['button_function'] is not None:
                function_name = field['button_function']
            else:
                msg = ("parameter button_function is null for button " + widget.objectName())
                self.controller.show_message(msg, 2)
        else:
            msg = "parameter button_function not found"
            self.controller.show_message(msg, 2)

        widget.clicked.connect(partial(getattr(self, function_name), dialog, widget, 2))
        return widget

    def open_catalog(self, dialog, result, message_level=None):
        self.catalog = Catalog(self.iface, self.settings, self.controller, self.plugin_dir)
        wsoftware = self.controller.get_project_type()
        geom_type = "node"
        widget = None

        for field in result["fields"]:
            if field['action_function'] == 'action_catalog':
                widget = dialog.findChild(QLineEdit, field['column_id'])
                break

        if widget:
            widget_name = widget.objectName()
            self.catalog.catalog(dialog, widget_name, wsoftware, geom_type, self.node_type)
        else:
            msg = ("No function associated to this action, review column action_function "
                   "from table config_api_layer_field for " + str(self.tablename) + " ")
            self.controller.show_message(msg, 2)

    def populate_lineedit(self, completer, model, tablename, dialog, widget, field_id):
        """ Set autocomplete of widget @table_object + "_id"
            getting id's from selected @table_object.
            WARNING: Each QlineEdit needs their own QCompleter and their own QStringListModel!!!
        """
        if not widget:
            return

        # Set SQL
        sql = ("SELECT " + self.schema_name + ".gw_api_get_rowslineedit('" + str(tablename) + "', '" +
               "" + str(field_id) + "', '" + str(utils_giswater.getWidgetText(dialog, widget)) + "')")
        row = self.controller.get_rows(sql, log_sql=False)
        result = row[0][0]['data']

        list_items = []
        for _id in result:
            list_items.append(_id['id'])
        self.set_completer_object(completer, model, widget, list_items)


    """ NEW WORKCAT"""
    def cf_new_workcat(self, dialog):

        self.dlg_previous_cf = dialog
        self.dlg_new_workcat = NewWorkcat()
        self.load_settings(self.dlg_new_workcat)
        utils_giswater.setCalendarDate(dialog, self.dlg_new_workcat.builtdate, None, True)

        table_name = "cat_work"
        completer = QCompleter()
        model = QStringListModel()
        self.populate_lineedit(completer, model, table_name, dialog, self.dlg_new_workcat.cat_work_id, 'id')
        self.dlg_new_workcat.cat_work_id.textChanged.connect(partial(self.populate_lineedit, completer, model, table_name,  dialog, self.dlg_new_workcat.cat_work_id, 'id'))
        # Set signals
        self.dlg_new_workcat.btn_accept.clicked.connect(partial(self.cf_manage_new_workcat_accept, table_name))
        self.dlg_new_workcat.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_new_workcat))

        # Open dialog
        self.cf_open_dialog(self.dlg_new_workcat)

    def cf_manage_new_workcat_accept(self, table_object):
        """ Insert table 'cat_work'. Add cat_work """

        # Get values from dialog
        values = ""
        fields = ""
        cat_work_id = utils_giswater.getWidgetText(self.dlg_new_workcat, self.dlg_new_workcat.cat_work_id)
        if cat_work_id != "null":
            fields += 'id, '
            values += ("'" + str(cat_work_id) + "', ")
        descript = utils_giswater.getWidgetText(self.dlg_new_workcat, self.dlg_new_workcat.descript)
        if descript != "null":
            fields += 'descript, '
            values += ("'" + str(descript) + "', ")
        link = utils_giswater.getWidgetText(self.dlg_new_workcat, self.dlg_new_workcat.link)
        if link != "null":
            fields += 'link, '
            values += ("'" + str(link) + "', ")
        workid_key_1 = utils_giswater.getWidgetText(self.dlg_new_workcat, self.dlg_new_workcat.workid_key_1)
        if workid_key_1 != "null":
            fields += 'workid_key1, '
            values += ("'" + str(workid_key_1) + "', ")
        workid_key_2 = utils_giswater.getWidgetText(self.dlg_new_workcat, self.dlg_new_workcat.workid_key_2)
        if workid_key_2 != "null":
            fields += 'workid_key2, '
            values += ("'" + str(workid_key_2) + "', ")
        builtdate = self.dlg_new_workcat.builtdate.dateTime().toString('yyyy-MM-dd')
        if builtdate != "null":
            fields += 'builtdate, '
            values += ("'" + str(builtdate) + "', ")

        if values != "":
            fields = fields[:-2]
            values = values[:-2]
            if cat_work_id == 'null':
                msg = "El campo Work id esta vacio"
                self.controller.show_info_box(msg, "Warning")
            else:
                # Check if this element already exists
                sql = ("SELECT DISTINCT(id)"
                       " FROM " + self.schema_name + "." + str(table_object) + ""
                       " WHERE id = '" + str(cat_work_id) + "'")
                row = self.controller.get_row(sql, log_info=False)

                if row is None :
                    sql = ("INSERT INTO " + self.schema_name + ".cat_work (" + fields + ") VALUES (" + values + ")")
                    self.controller.execute_sql(sql)

                    sql = ("SELECT id, id FROM " + self.schema_name + ".cat_work ORDER BY id")
                    rows = self.controller.get_rows(sql)
                    if rows:
                        cmb_workcat_id = self.dlg_previous_cf.findChild(QComboBox, "workcat_id")
                        utils_giswater.set_item_data(cmb_workcat_id, rows, index_to_show=1, combo_clear=True)
                        utils_giswater.set_combo_itemData(cmb_workcat_id, cat_work_id, 1)
                    self.close_dialog(self.dlg_new_workcat)
                else:
                    msg = "Este Workcat ya existe"
                    self.controller.show_info_box(msg, "Warning")


    def cf_open_dialog(self, dlg=None, dlg_name=None, maximize_button=True, stay_on_top=True):
        """ Open dialog """

        if dlg is None or type(dlg) is bool:
            dlg = self.dlg

        # Manage i18n of the dialog
        if dlg_name:
            self.controller.manage_translation(dlg_name, dlg)

        # Manage stay on top and maximize button
        if maximize_button and stay_on_top:
            dlg.setWindowFlags(Qt.WindowMinimizeButtonHint | Qt.WindowMaximizeButtonHint | Qt.WindowStaysOnTopHint)
        elif not maximize_button and stay_on_top:
            dlg.setWindowFlags(Qt.WindowMinimizeButtonHint | Qt.WindowStaysOnTopHint)
        elif maximize_button and not stay_on_top:
            dlg.setWindowFlags(Qt.WindowMaximizeButtonHint)

        # Open dialog
        dlg.open()


    """ FUNCTIONS ASSOCIATED TO BUTTONS FROM POSTGRES"""
    def no_function_asociated(self, widget=None, message_level=1):
        self.controller.show_message(str("no_function_asociated for button: ") + str(widget.objectName()), message_level)

    def action_open_url(self, dialog, result, message_level=None):
        widget = None
        function_name = 'no_function_associated'
        for field in result["fields"]:
                if field['action_function'] == 'action_link':
                    function_name = field['button_function']
                    widget = dialog.findChild(HyperLinkLabel, field['column_id'])
                    break
        if widget:
            getattr(self, function_name)(dialog, widget, 2)


    def open_url(self, dialog, widget, message_level=None):
        path = utils_giswater.getWidgetText(dialog, widget)
        self.controller.log_info(str(path))
        # Check if file exist
        if os.path.exists(path):
            # Open the document
            if sys.platform == "win32":
                os.startfile(path)
            else:
                opener = "open" if sys.platform == "darwin" else "xdg-open"
                subprocess.call([opener, path])
        else:
            webbrowser.open(path)

    def open_node(self, dialog, widget=None, message_level=None):
        node_id = utils_giswater.getWidgetText(dialog, widget)
        self.ApiCF = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir)
        self.ApiCF.open_form(table_name='ve_node',  node_type='node', node_id=node_id)



    # def disconnect_snapping(self, refresh_canvas=True):
    #     """ Select 'refreshAllLayers' as current map tool and disconnect snapping """
    #
    #     try:
    #         self.canvas.xyCoordinates.disconnect()
    #         self.emit_point.canvasClicked.disconnect()
    #         if refresh_canvas:
    #             self.iface.mapCnavas().refreshAllLayers()
    #
    #     except Exception:
    #         pass



