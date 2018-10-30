"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: latin-1 -*-
try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4.QtCore import Qt, QDate
    from PyQt4.QtGui import QApplication, QIntValidator, QDoubleValidator
    from PyQt4.QtGui import QWidget, QAction, QPushButton, QLabel, QLineEdit, QComboBox, QCheckBox, QDateEdit
    from PyQt4.QtGui import QGridLayout, QSpacerItem, QSizePolicy, QStringListModel, QCompleter, QListWidget, \
        QTableView, QListWidgetItem, QStandardItemModel, QStandardItem, QTabWidget
    from PyQt4.QtSql import QSqlTableModel

else:
    from qgis.PyQt.QtCore import Qt, QDate, QStringListModel
    from qgis.PyQt.QtGui import QIntValidator, QDoubleValidator
    from qgis.PyQt.QtWidgets import QApplication, QWidget, QAction, QPushButton, QLabel, QLineEdit, QComboBox, QCheckBox, \
        QGridLayout, QSpacerItem, QSizePolicy, QCompleter, QTableView, QListWidget, QListWidgetItem, QStandardItemModel, \
        QStandardItem, QTabWidget
    from qgis.PyQt.QtSql import QSqlTableModel

from qgis.gui import QgsMapToolEmitPoint, QgsDateTimeEdit

import json
import operator
import os
import subprocess
import sys
import urlparse
import webbrowser
from functools import partial

import utils_giswater
from giswater.actions.api_parent import ApiParent
from giswater.actions.HyperLinkLabel import HyperLinkLabel
from giswater.actions.manage_document import ManageDocument
from giswater.actions.manage_element import ManageElement
from giswater.actions.manage_visit import ManageVisit
from giswater.actions.manage_gallery import ManageGallery
from giswater.actions.api_catalog import ApiCatalog
from giswater.ui_manager import ApiCfUi, NewWorkcat, EventFull, LoadDocuments
from giswater.ui_manager import Sections
from giswater.ui_manager import ApiBasicInfo


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
            complet_result = self.open_form(point)

            if not complet_result:
                print("FAIL get_point")
                return

            self.restore(restore_cursor=True)
            self.draw(complet_result, zoom=False)

            # Set variables
            self.field_id = str(self.geom_type) + "_id"

            # Manage tab signal
            self.tab_element_loaded = False
            self.tab_relations_loaded = False
            self.tab_connections_loaded = False
            self.tab_conections_loaded = False
            self.tab_hydrometer_loaded = False
            self.tab_om_loaded = False
            self.tab_document_loaded = False
            self.tab_plan_loaded = False
            #self.fill_tab_rpt()
            self.filter = str(complet_result[0]['feature']['idName']) + " = '" + str(self.feature_id) + "'"

            self.tab_main.currentChanged.connect(self.tab_activation)

            # Remove unused tabs
            tabs_to_show = []
            # tabs_to_show = [tab['tabname'] for tab in complet_result[0]['form']['visibleTabs']]
            for tab in complet_result[0]['form']['visibleTabs']:
                tabs_to_show.append(tab['tabname'])

            for x in range(self.tab_main.count()-1, 0, -1):
                if self.tab_main.widget(x).objectName() not in tabs_to_show:
                    utils_giswater.remove_tab_by_tabName(self.tab_main, self.tab_main.widget(x).objectName())

            # TODO
            # Manage 'image'
            # self.set_image(self.dlg_cf, "label_image_ws_shape")
        elif button_clicked == Qt.RightButton:
            self.restore()


    def open_form(self, point=None, table_name=None, feature_type=None, feature_id=None):
        """
        :param point: point where use clicked
        :param table_name: table where do sql query
        :param feature_type: (arc, node, connec...)
        :param feature_id: id of feature to do info
        :return:
        """
        
        self.dlg_is_destroyed = False
        self.layer = None
        self.feature = None
        self.my_json = {}
        # Get srid
        self.srid = self.controller.plugin_settings_value('srid')

        if self.iface.activeLayer() is None:
            active_layer = ""
        else:
            active_layer = self.controller.get_layer_source_table_name(self.iface.activeLayer())

        visible_layers = self.get_visible_layers()
        scale_zoom = self.iface.mapCanvas().scale()
        is_project_editable = self.get_editable_project()

        # IF click over canvas
        if point:
            sql = ("SELECT " + self.schema_name + ".gw_api_get_infofromcoordinates(" + str(point.x()) + ", "
                   + str(point.y())+" ,"+str(self.srid) + ", '"+str(active_layer)+"', '"+str(visible_layers)+"', '"
                   + str(is_project_editable)+"', "+str(scale_zoom)+", 9, 100)")
        # IF come from QPushButtons node1 or node2 from custom form
        elif feature_id and feature_type:
            sql = ("SELECT the_geom FROM " + self.schema_name + "."+table_name+" WHERE "+str(feature_type)+" = '" + str(feature_id) + "'")
            row = self.controller.get_row(sql, log_sql=True)
            the_geom = 'null'
            if row:
                the_geom = "'" + str(row[0]) + "'"
            sql = ("SELECT " + self.schema_name + ".gw_api_get_infofromid('"+str(table_name)+"', '"+str(feature_id)+"',"
                   " " + str(the_geom)+", " + str(is_project_editable) + ", 9, 100)")

        row = self.controller.get_row(sql, log_sql=True)
        if not row:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return False
        self.complet_result = row
        result = row[0]['editData']
        if 'fields' not in result:
            self.controller.show_message("NOT fileds in result FOR: " + sql, 2)
            return False
        if self.complet_result[0]['form'] == 'GENERIC':
            # TODO
            print("GENERIC")
            # result = self.open_generic_form(feature_id, self.complet_result)
            # return result
            return
        elif self.complet_result[0]['form']['template'] == 'custom feature':
            result = self.open_custom_form(feature_id, self.complet_result)
            return result

    def open_custom_form(self, feature_id, complet_result):
        # Dialog
        self.dlg_cf = ApiCfUi()
        self.load_settings(self.dlg_cf)

        if feature_id:
            self.dlg_cf.setGeometry(self.dlg_cf.pos().x() + 25, self.dlg_cf.pos().y() + 25, self.dlg_cf.width(),
                                    self.dlg_cf.height())


        # Get widget controls
        self.tab_main = self.dlg_cf.findChild(QTabWidget, "tab_main")
        self.tbl_element = self.dlg_cf.findChild(QTableView, "tbl_element")
        utils_giswater.set_qtv_config(self.tbl_element)
        self.tbl_relations = self.dlg_cf.findChild(QTableView, "tbl_relations")
        utils_giswater.set_qtv_config(self.tbl_relations)
        self.tbl_upstream = self.dlg_cf.findChild(QTableView, "tbl_upstream")
        utils_giswater.set_qtv_config(self.tbl_upstream)
        self.tbl_downstream = self.dlg_cf.findChild(QTableView, "tbl_downstream")
        utils_giswater.set_qtv_config(self.tbl_downstream)
        self.tbl_hydrometer = self.dlg_cf.findChild(QTableView, "tbl_hydrometer")
        utils_giswater.set_qtv_config(self.tbl_hydrometer)
        self.tbl_hydrometer_value = self.dlg_cf.findChild(QTableView, "tbl_hydrometer_value")
        utils_giswater.set_qtv_config(self.tbl_hydrometer_value)
        self.tbl_event = self.dlg_cf.findChild(QTableView, "tbl_event")
        utils_giswater.set_qtv_config(self.tbl_event)
        self.tbl_document = self.dlg_cf.findChild(QTableView, "tbl_document")
        utils_giswater.set_qtv_config(self.tbl_document)
        self.tbl_rpt = self.dlg_cf.findChild(QTableView, "tbl_rpt")
        utils_giswater.set_qtv_config(self.tbl_rpt)
        # Actions
        action_edit = self.dlg_cf.findChild(QAction, "actionEdit")
        action_copy_paste = self.dlg_cf.findChild(QAction, "actionCopyPaste")
        action_rotation = self.dlg_cf.findChild(QAction, "actionRotation")
        action_catalog = self.dlg_cf.findChild(QAction, "actionCatalog")
        action_workcat = self.dlg_cf.findChild(QAction, "actionWorkcat")
        action_zoom_in = self.dlg_cf.findChild(QAction, "actionZoom")
        action_zoom_out = self.dlg_cf.findChild(QAction, "actionZoomOut")
        action_centered = self.dlg_cf.findChild(QAction, "actionCentered")
        action_link = self.dlg_cf.findChild(QAction, "actionLink")
        action_help = self.dlg_cf.findChild(QAction, "actionHelp")
        action_interpolate = self.dlg_cf.findChild(QAction, "actionInterpolate")
        # action_switch_arc_id = self.dlg_cf.findChild(QAction, "actionSwicthArcid")
        action_section = self.dlg_cf.findChild(QAction, "actionSection")


        # Set all action enabled(False) and visible(False) less separators
        actions_list = self.dlg_cf.toolBar.findChildren(QAction)
        for action in actions_list:
            action.setEnabled(False)
            action.setVisible(False)
            if action.objectName() == "":
                action.setEnabled(True)
                action.setVisible(True)

        actions_to_show = complet_result[0]['form']['actions']
        for x in range(0, len(actions_to_show)):
            action = None
            action = self.dlg_cf.toolBar.findChild(QAction, actions_to_show[x]['actionname'])
            if action is not None:
                action.setVisible(True)
                action.setToolTip(actions_to_show[x]['actiontooltip'])

        # Force not edition actions  enabled(True) and visible(True)
        self.set_action(action_zoom_in)
        self.set_action(action_zoom_out)
        self.set_action(action_centered)
        self.set_action(action_link)
        self.set_action(action_help)
        self.set_action(action_section)

        # TODO action_edit.setEnabled(lo que venga del json segun permisos)
        self.set_action(action_edit, visible=True, enabled=True)


        # Set actions icon
        self.set_icon(action_edit, "101")
        self.set_icon(action_copy_paste, "107b")
        self.set_icon(action_rotation, "107c")
        self.set_icon(action_catalog, "195")
        self.set_icon(action_workcat, "193")
        self.set_icon(action_zoom_in, "103")
        self.set_icon(action_zoom_out, "107")
        self.set_icon(action_centered, "104")
        self.set_icon(action_link, "173")
        self.set_icon(action_section, "204")
        self.set_icon(action_help, "73")
        self.set_icon(action_interpolate, "194")
        # self.set_icon(action_switch_arc_id, "141")


        # Set buttons icon
        # tab elements
        self.set_icon(self.dlg_cf.btn_insert, "111b")
        self.set_icon(self.dlg_cf.btn_delete, "112b")
        self.set_icon(self.dlg_cf.btn_new_element, "131b")
        self.set_icon(self.dlg_cf.btn_open_element, "134b")
        # tab scada.hydrometer
        self.set_icon(self.dlg_cf.btn_add_hydrometer, "111b")
        self.set_icon(self.dlg_cf.btn_delete_hydrometer, "112b")
        self.set_icon(self.dlg_cf.btn_link, "70b")
        # tab om
        self.set_icon(self.dlg_cf.btn_open_visit, "65b")
        self.set_icon(self.dlg_cf.btn_new_visit, "64b")
        self.set_icon(self.dlg_cf.btn_open_gallery, "136b")
        self.set_icon(self.dlg_cf.btn_open_visit_doc, "170b")
        self.set_icon(self.dlg_cf.btn_open_visit_event, "134b")
        # tab doc
        self.set_icon(self.dlg_cf.btn_doc_insert, "111b")
        self.set_icon(self.dlg_cf.btn_doc_delete, "112b")
        self.set_icon(self.dlg_cf.btn_doc_new, "131b")
        self.set_icon(self.dlg_cf.btn_open_doc, "170b")

        # Layouts
        top_layout = self.dlg_cf.findChild(QGridLayout, 'top_layout')
        bot_layout_1 = self.dlg_cf.findChild(QGridLayout, 'bot_layout_1')
        bot_layout_2 = self.dlg_cf.findChild(QGridLayout, 'bot_layout_2')

        layout_data_1 = self.dlg_cf.findChild(QGridLayout, 'layout_data_1')
        layout_data_2 = self.dlg_cf.findChild(QGridLayout, 'layout_data_2')
        layout_data_3 = self.dlg_cf.findChild(QGridLayout, 'layout_data_3')

        layout_inp_1 = self.dlg_cf.findChild(QGridLayout, 'layout_inp_1')
        layout_inp_2 = self.dlg_cf.findChild(QGridLayout, 'layout_inp_2')
        layout_inp_3 = self.dlg_cf.findChild(QGridLayout, 'layout_inp_3')

        plan_layout = self.dlg_cf.findChild(QGridLayout, 'plan_layout')
        # Get table name for use as title
        self.tablename = complet_result[0]['feature']['tableName']
        pos_ini = complet_result[0]['feature']['tableName'].rfind("_")
        pos_fi = len(str(complet_result[0]['feature']['tableName']))
        # Get feature type (Junction, manhole, valve, fountain...)
        self.feature_type = complet_result[0]['feature']['tableName'][pos_ini+1:pos_fi]
        self.dlg_cf.setWindowTitle(self.feature_type.capitalize())

        # Get tableParent and select layer
        self.table_parent = str(complet_result[0]['feature']['tableParent'])
        self.layer = self.controller.get_layer_by_tablename(self.table_parent)

        if self.layer:
            self.iface.setActiveLayer(self.layer)
        else:
            self.controller.show_message("Layer not found: " + self.table_parent, 2)
            return False

        # Get feature type as geom_type (node, arc, connec)
        self.geom_type = str(complet_result[0]['feature']['featureType'])

        # Get field id name
        self.field_id = str(complet_result[0]['feature']['idName'])
        self.feature_id = None
        result = complet_result[0]['editData']
        for field in result["fields"]:
            label, widget = self.set_widgets(self.dlg_cf, field)
            # Prepare layouts
            # Common layouts
            if field['layout_id'] == 0:
                top_layout.addWidget(label, 0, field['layout_order'])
                top_layout.addWidget(widget, 1, field['layout_order'])
            elif field['layout_id'] == 4:
                bot_layout_1.addWidget(label, 0, field['layout_order'])
                bot_layout_1.addWidget(widget, 1, field['layout_order'])
            elif field['layout_id'] == 5:
                bot_layout_2.addWidget(label, 0, field['layout_order'])
                bot_layout_2.addWidget(widget, 1, field['layout_order'])
            # Tab data
            elif field['layout_id'] == 1:
                layout_data_1.addWidget(label, field['layout_order'], 0)
                layout_data_1.addWidget(widget, field['layout_order'], 1)
                if field['widgettype'] == 8:
                    v = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
                    layout_data_1.addItem(v, field['layout_order'], 2)
            elif field['layout_id'] == 2:
                layout_data_2.addWidget(label, field['layout_order'], 0)
                layout_data_2.addWidget(widget, field['layout_order'], 1)
            elif field['layout_id'] == 3:
                layout_data_3.addWidget(label, field['layout_order'], 0)
                layout_data_3.addWidget(widget, field['layout_order'], 1)
            # Tab inp
            elif field['layout_id'] == 6:
                layout_inp_1.addWidget(label, field['layout_order'], 0)
                layout_inp_1.addWidget(widget, field['layout_order'], 1)
            elif field['layout_id'] == 7:
                layout_inp_2.addWidget(label, field['layout_order'], 0)
                layout_inp_2.addWidget(widget, field['layout_order'], 1)
            elif field['layout_id'] == 8:
                layout_inp_3.addWidget(label, field['layout_order'], 0)
                layout_inp_3.addWidget(widget, field['layout_order'], 1)
        vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        layout_data_1.addItem(vertical_spacer1)
        vertical_spacer2 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        layout_data_2.addItem(vertical_spacer2)
        vertical_spacer3 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        layout_inp_1.addItem(vertical_spacer3)
        vertical_spacer4 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        layout_inp_2.addItem(vertical_spacer4)
        # Find combo parents:
        for field in result["fields"]:
            if field['isparent']:
                widget = self.dlg_cf.findChild(QComboBox, field['column_id'])
                widget.currentIndexChanged.connect(partial(self.fill_child, self.dlg_cf, widget))

        if self.layer:
            if self.layer.isEditable():
                self.enable_all(result)
            else:
                self.disable_all(result, False)

        if action_edit.isVisible():
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

        action_zoom_in.triggered.connect(partial(self.api_action_zoom_in, self.feature, self.canvas, self.layer))
        action_centered.triggered.connect(partial(self.api_action_centered, self.feature, self.canvas, self.layer))
        action_zoom_out.triggered.connect(partial(self.api_action_zoom_out, self.feature, self.canvas, self.layer))
        action_copy_paste.triggered.connect(partial(self.api_action_copy_paste, self.dlg_cf, self.geom_type))
        #action_rotation.triggered.connect(partial(self.api_action_zoom_out, self.feature, self.canvas, self.layer))
        action_link.triggered.connect(partial(self.action_open_url, self.dlg_cf, result))
        action_section.triggered.connect(partial(self.open_section_form, self.complet_result))
        action_help.triggered.connect(partial(self.api_action_help, 'ud', 'node'))

        # Buttons
        btn_cancel = self.dlg_cf.findChild(QPushButton, 'btn_cancel')
        btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_cf))
        btn_accept = self.dlg_cf.findChild(QPushButton, 'btn_accept')
        btn_accept.clicked.connect(partial(self.accept, self.complet_result[0], self.feature_id, self.my_json))
        self.dlg_cf.dlg_closed.connect(partial(self.close_dialog, self.dlg_cf))
        self.dlg_cf.dlg_closed.connect(partial(self.resetRubberbands))

        # Open dialog
        self.dlg_cf.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_cf.show()
        return self.complet_result

    def set_widgets(self, dialog, field):
        widget = None
        label = QLabel()
        label.setObjectName('lbl_' + field['form_label'])
        label.setText(field['form_label'].capitalize())
        if 'tooltip' in field:
            label.setToolTip(field['tooltip'])
        else:
            label.setToolTip(field['form_label'].capitalize())
        if field['widgettype'] == 1 or field['widgettype'] == 10:
            completer = QCompleter()
            widget = self.add_lineedit(field)
            widget = self.set_auto_update_lineedit(field, dialog, widget)
            widget = self.set_data_type(field, widget)
            widget = self.set_widget_type(field, dialog, widget, completer)
            if widget.objectName() == self.field_id:
                self.feature_id = widget.text()
                # Get selected feature
                self.feature = self.get_feature_by_id(self.layer, self.feature_id, self.field_id)
        elif field['widgettype'] == 2:
            widget = self.add_combobox(dialog, field)
            widget = self.set_auto_update_combobox(field, dialog, widget)
        elif field['widgettype'] == 3:
            widget = self.add_checkbox(dialog, field)
            widget = self.set_auto_update_checkbox(field,dialog, widget)
        elif field['widgettype'] == 4:
            widget = self.add_calendar(dialog, field)
            widget = self.set_auto_update_dateedit(field, dialog, widget)
        elif field['widgettype'] == 8:
            widget = self.add_button(dialog, field)
        elif field['widgettype'] == 9:
            widget = self.add_hyperlink(dialog, field)
        if 'widgetdim' in field:
            if field['widgetdim']:
                widget.setMaximumWidth(field['widgetdim'])
                widget.setMinimumWidth(field['widgetdim'])
        return label, widget


    def open_section_form(self, complet_result):
        dlg_sections = Sections()
        self.load_settings(dlg_sections)
        #section = complet_result[0]['section']
        section = {"y_param": "Arc inspection type 1",

                     "width": "AS_BUILT",
                   "areas": "INSPECTION",
                   "area": "INSPECTION"
                   }
        for key, value in section.items():
            print(key)
            print(value)
            widget = dlg_sections.findChild(QLineEdit, key)
            print(widget)
            if widget:
                utils_giswater.setWidgetText(dlg_sections, widget, value)
        dlg_sections.btn_close.clicked.connect(partial(self.close_dialog, dlg_sections))
        self.open_dialog(dlg_sections, maximize_button=False)

        
    def accept(self, complet_result, feature_id, _json, clear_json=False, close_dialog=True):
        if _json == '' or str(_json) == '{}':
            self.close_dialog(self.dlg_cf)
            return

        my_json = json.dumps(_json)
        p_table_id = complet_result['feature']['tableName']

        sql = ("SELECT " + self.schema_name + ".gw_api_set_upsertfields('"+str(p_table_id)+"', '"+str(feature_id)+""
               "',null, 9, 100, '"+str(my_json)+"')")
        row = self.controller.execute_returning(sql, log_sql=True)
        if not row:
            msg = "Fail in: {0}".format(sql)
            self.controller.show_message(msg, message_level=2)
            self.controller.log_info(str("FAIL IN: ")+str(sql))
            return
        if clear_json:
            _json = {}
        if "Accepted" in str(row[0]):
            message = "Values has been updated"
            self.controller.show_info(message)
        if close_dialog:
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
                                widget.setFocusPolicy(Qt.NoFocus)
                                widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242);"
                                                     " color: rgb(100, 100, 100)}")
                            else:
                                widget.setFocusPolicy(Qt.StrongFocus)
                                widget.setStyleSheet("QLineEdit { background: rgb(255, 255, 255);"
                                                     " color: rgb(0, 0, 0)}")
                        elif type(widget) is QComboBox:
                            widget.setEnabled(field['iseditable'])
                            widget.focusPolicy(Qt.StrongFocus) if widget.setEnabled(
                                field['iseditable']) else widget.setFocusPolicy(Qt.NoFocus)
                        elif type(widget) is QCheckBox:
                            widget.setEnabled(field['iseditable'])
                            widget.focusPolicy(Qt.StrongFocus) if widget.setEnabled(
                                field['iseditable']) else widget.setFocusPolicy(Qt.NoFocus)
                        elif type(widget) is QPushButton:
                            widget.setEnabled(field['iseditable'])
                            widget.focusPolicy(Qt.StrongFocus) if widget.setEnabled(
                                field['iseditable']) else widget.setFocusPolicy(Qt.NoFocus)
                        elif type(widget) is QgsDateTimeEdit:
                            widget.setEnabled(field['iseditable'])
                            widget.focusPolicy(Qt.StrongFocus) if widget.setEnabled(
                                field['iseditable']) else widget.setFocusPolicy(Qt.NoFocus)


    def enable_actions(self, dialog, enabled):
        """ Enable actions according if layer is editable or not"""
        # if dialog.actionEdit.isVisible():
        dialog.actionCopyPaste.setEnabled(enabled)
        dialog.actionRotation.setEnabled(enabled)
        dialog.actionCatalog.setEnabled(enabled)
        dialog.actionWorkcat.setEnabled(enabled)
        #dialog.actionSwicthArcid.setEnabled(enabled)


    def get_values(self, dialog, widget, _json=None):
        value = None

        if type(widget) is QLineEdit and widget.isReadOnly() is False:
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
            if str(value) == '' or value is None:
                _json[str(widget.objectName())] = None
            else:
                _json[str(widget.objectName())] = str(value)
        self.controller.log_info(str(_json))


    def set_auto_update_lineedit(self, field, dialog, widget):
        if field['isautoupdate']:
            _json = {}
            widget.lostFocus.connect(partial(self.get_values, dialog, widget, _json))
            widget.lostFocus.connect(partial(self.accept, self.complet_result[0], self.feature_id, _json, True, False))
        else:
            widget.lostFocus.connect(partial(self.get_values, dialog, widget, self.my_json))
        return widget

    def set_auto_update_combobox(self, field, dialog, widget):
        if field['isautoupdate']:
            _json = {}
            widget.currentIndexChanged.connect(partial(self.get_values, dialog, widget, _json))
            widget.currentIndexChanged.connect(partial(self.accept, self.complet_result[0], self.feature_id, _json, True, False))
        else:
            widget.currentIndexChanged.connect(partial(self.get_values, dialog, widget, self.my_json))
        return widget

    def set_auto_update_dateedit(self, field, dialog, widget):
        if field['isautoupdate']:
            _json = {}
            widget.dateChanged.connect(partial(self.get_values, dialog, widget, _json))
            widget.dateChanged.connect(partial(self.accept, self.complet_result[0], self.feature_id, _json, True, False))
        else:
            widget.dateChanged.connect(partial(self.get_values, dialog, widget, self.my_json))
        return widget

    def set_auto_update_spinbox(self, field, dialog, widget):
        if field['isautoupdate']:
            _json = {}
            widget.valueChanged.connect(partial(self.get_values, dialog, widget, _json))
            widget.valueChanged.connect(partial(self.accept, self.complet_result[0], self.feature_id, _json, True, False))
        else:
            widget.valueChanged.connect(partial(self.get_values, dialog, widget, self.my_json))
        return widget

    def set_auto_update_checkbox(self, field, dialog, widget):
        if field['isautoupdate']:
            _json = {}
            widget.stateChanged.connect(partial(self.get_values, dialog, widget, _json))
            widget.stateChanged.connect(partial(self.accept, self.complet_result[0], self.feature_id, _json, True, False))
        else:
            widget.stateChanged.connect(partial(self.get_values, dialog, widget, self.my_json))
        return widget


    def set_data_type(self, field, widget):
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
        return widget


    def set_widget_type(self, field, dialog, widget, completer):
        if field['widgettype'] == 10:
            if 'dv_table' in field:
                table_name = field['dv_table']
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
        widget.currentIndexChanged.connect(partial(self.get_values, dialog, widget, self.my_json))
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
        widget.stateChanged.connect(partial(self.get_values, dialog, widget, self.my_json))
        return widget


    def add_button(self, dialog, field):
        
        widget = QPushButton()
        widget.setObjectName(field['column_id'])
        if 'value' in field:
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


    def open_catalog(self, dialog, result, message_level=None):
        self.catalog = ApiCatalog(self.iface, self.settings, self.controller, self.plugin_dir)
        self.catalog.api_catalog(self.dlg_cf, self.geom_type+'cat_id', self.geom_type)


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
        self.set_completer_object_api(completer, model, widget, list_items)

    """ MANAGE TABS """
    def tab_activation(self):
        """ Call functions depend on tab selection """

        # Get index of selected tab
        index_tab = self.tab_main.currentIndex()
        # Tab 'Elements'
        if self.tab_main.widget(index_tab).objectName() == 'tab_elements' and not self.tab_element_loaded:
            self.fill_tab_element()
            self.tab_element_loaded = True
        # Tab 'Relations'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_relations' and not self.tab_relations_loaded:
            # if self.geom_type in ('arc', 'node'):
            #     self.manage_tab_relations("v_ui_" + str(self.geom_type) + "_x_relations", str(self.field_id))
            self.fill_tab_relations()
            self.tab_relations_loaded = True
        # Tab 'Conections'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_connections' and not self.tab_connections_loaded:
            self.fill_tab_connections()
            self.tab_connections_loaded = True
        # Tab 'Hydrometer'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_hydrometer' and not self.tab_hydrometer_loaded:
            self.fill_tab_hydrometer()
            self.tab_hydrometer_loaded = True
        # Tab 'O&M'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_om' and not self.tab_om_loaded:
            self.fill_tab_om(self.geom_type)
            self.tab_om_loaded = True
        # Tab 'Documents'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_documents' and not self.tab_document_loaded:
            self.fill_tab_document()
            self.tab_document_loaded = True
        elif self.tab_main.widget(index_tab).objectName() == 'tab_rpt':
            self.fill_tab_rpt()
        # Tab 'Plan'
        elif self.tab_main.widget(index_tab).objectName() == 'tab_plan' and not self.tab_plan_loaded:
            self.fill_tab_plan()
            self.tab_plan_loaded = True


    """ FUNCTIONS RELATED TAB ELEMENT"""
    def fill_tab_element(self):
        """ Fill tab 'Element' """

        table_element = "ve_ui_element_x_" + self.geom_type
        self.fill_tbl_element_man(self.dlg_cf, self.tbl_element, table_element, self.filter)
        self.set_configuration(self.tbl_element, table_element)

    def fill_tbl_element_man(self, dialog, widget, table_name, expr_filter):
        """ Fill the table control to show elements """

        # Get widgets
        self.element_id = self.dlg_cf.findChild(QLineEdit, "element_id")
        btn_open_element = self.dlg_cf.findChild(QPushButton, "btn_open_element")
        btn_delete = self.dlg_cf.findChild(QPushButton, "btn_delete")
        btn_insert = self.dlg_cf.findChild(QPushButton, "btn_insert")
        btn_new_element = self.dlg_cf.findChild(QPushButton, "btn_new_element")

        # Set signals
        self.tbl_element.doubleClicked.connect(partial(self.open_selected_element, dialog, widget))
        btn_open_element.clicked.connect(partial(self.open_selected_element, dialog, widget))
        btn_delete.clicked.connect(partial(self.delete_records, widget, table_name))
        btn_insert.clicked.connect(partial(self.add_object, widget, "element", "ve_ui_element"))
        btn_new_element.clicked.connect(partial(self.manage_element, dialog, feature=self.feature))

        # Set model of selected widget
        table_name = self.schema_name + "." + table_name
        self.set_model_to_table(widget, table_name, expr_filter)

        # Adding auto-completion to a QLineEdit
        self.table_object = "element"
        self.set_completer_object(dialog, self.table_object)

    def open_selected_element(self, dialog, widget):
        """ Open form of selected element of the @widget?? """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            element_id = widget.model().record(row).value("element_id")
            break

        # Open selected element

        self.manage_element(dialog, element_id)

    def add_object(self, widget, table_object, view_object):
        """ Add object (doc or element) to selected feature """

        # Get values from dialog
        object_id = utils_giswater.getWidgetText(self.dlg_cf, table_object + "_id")
        if object_id == 'null':
            message = "You need to insert data"
            self.controller.show_warning(message, parameter=table_object + "_id")
            return

        # Check if this object exists
        field_object_id = "id"
        sql = ("SELECT * FROM " + self.schema_name + "." + view_object + ""
               " WHERE " + field_object_id + " = '" + object_id + "'")
        row = self.controller.get_row(sql)
        if not row:
            self.controller.show_warning("Object id not found", parameter=object_id)
            return

        # Check if this object is already associated to current feature
        field_object_id = table_object + "_id"
        tablename = table_object + "_x_" + self.geom_type
        sql = ("SELECT *"
               " FROM " + self.schema_name + "." + str(tablename) + ""
               " WHERE " + str(self.field_id) + " = '" + str(self.feature_id) + "'"
               " AND " + str(field_object_id) + " = '" + str(object_id) + "'")
        row = self.controller.get_row(sql, log_info=False, log_sql=True)

        # If object already exist show warning message
        if row:
            message = "Object already associated with this feature"
            self.controller.show_warning(message)

        # If object not exist perform an INSERT
        else:
            sql = ("INSERT INTO " + self.schema_name + "." + tablename + ""
                   "(" + str(field_object_id) + ", " + str(self.field_id) + ")"
                   " VALUES ('" + str(object_id) + "', '" + str(self.feature_id) + "');")
            self.controller.execute_sql(sql, log_sql=True)
            widget.model().select()

    def delete_records(self, widget, table_name):
        """ Delete selected objects (elements or documents) of the @widget """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        inf_text = ""
        list_object_id = ""
        row_index = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            object_id = widget.model().record(row).value("doc_id")
            id_ = widget.model().record(row).value("id")
            if object_id is None:
                object_id = widget.model().record(row).value("element_id")
            inf_text += str(object_id) + ", "
            list_id += str(id_) + ", "
            list_object_id = list_object_id + str(object_id) + ", "
            row_index += str(row + 1) + ", "

        row_index = row_index[:-2]
        inf_text = inf_text[:-2]
        list_object_id = list_object_id[:-2]
        list_id = list_id[:-2]

        message = "Are you sure you want to delete these records?"
        answer = self.controller.ask_question(message, "Delete records", list_object_id)
        if answer:
            sql = ("DELETE FROM " + self.schema_name + "." + table_name + ""
                   " WHERE id::integer IN (" + list_id + ")")
            self.controller.execute_sql(sql, log_sql=True)
            widget.model().select()


    def manage_element(self, dialog, element_id=None, feature=None):
        """ Execute action of button 33 """
        elem = ManageElement(self.iface, self.settings, self.controller, self.plugin_dir)
        elem.manage_element(True, feature, self.geom_type)
        elem.dlg_add_element.accepted.connect(partial(self.manage_element_new, dialog, elem))
        elem.dlg_add_element.rejected.connect(partial(self.manage_element_new, dialog, elem))

        # Set completer
        self.set_completer_object(dialog, self.table_object)

        if element_id:
            utils_giswater.setWidgetText(elem.dlg_add_element, "element_id", element_id)

        # Open dialog
        elem.open_dialog(elem.dlg_add_element)


    def manage_element_new(self, dialog, elem):
        """ Get inserted element_id and add it to current feature """
        if elem.element_id is None:
            return

        utils_giswater.setWidgetText(dialog, "element_id", elem.element_id)
        self.add_object(self.tbl_element, "element", "ve_ui_element")

        self.tbl_element.model().select()

    def set_model_to_table(self, widget, table_name, expr_filter):
        """ Set a model with selected filter.
        Attach that model to selected table """

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.setFilter(expr_filter)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

        # Attach model to table view
        if widget:
            widget.setModel(model)
        else:
            self.controller.log_info("set_model_to_table: widget not found")

    """ FUNCTIONS RELATED WITH TAB RELATIONS"""
    def manage_tab_relations(self, viewname, field_id):
        """ Hide tab 'relations' if no data in the view """

        # Check if data in the view
        sql = ("SELECT * FROM " + self.schema_name + "." + viewname + ""
               " WHERE " + str(field_id) + " = '" + str(self.feature_id) + "';")
        row = self.controller.get_row(sql, log_info=True, log_sql=True)

        if not row:
            # Hide tab 'relations'
            utils_giswater.remove_tab_by_tabName(self.tab_main, "relations")

        else:
            # Manage signal 'doubleClicked'
            self.tbl_relations.doubleClicked.connect(partial(self.open_relation, field_id))

    def fill_tab_relations(self):
        """ Fill tab 'Relations' """
        print(self.filter)
        table_relations = "v_ui_"+self.geom_type+"_x_relations"
        self.fill_table(self.tbl_relations, self.schema_name + "." + table_relations, self.filter)
        self.set_configuration(self.tbl_relations, table_relations)
        self.tbl_relations.doubleClicked.connect(partial(self.open_relation, str(self.field_id)))

    def open_relation(self, field_id):
        """ Open feature form of selected element """
        selected_list = self.tbl_relations.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        row = selected_list[0].row()

        # Get object_id from selected row
        field_object_id = "parent_id"
        if field_id == "arc_id":
            field_object_id = "feature_id"
        selected_object_id = self.tbl_relations.model().record(row).value(field_object_id)
        sys_type = self.tbl_relations.model().record(row).value("sys_type")



        table_name = self.tbl_relations.model().record(row).value("sys_table_id")
        sys_id_name = self.tbl_relations.model().record(row).value("sys_id_name")
        feature_id = self.tbl_relations.model().record(row).value("sys_id")
        layer = self.controller.get_layer_by_tablename(table_name, log_info=True)
        if not layer:
            message = "Layer not found"
            self.controller.show_message(message, parameter=table_name)
            return

        api_cf = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir)
        complet_result = api_cf.open_form(table_name=table_name, feature_type=sys_id_name, feature_id=feature_id)
        if not complet_result:
            print("FAIL")
            return
        self.draw(complet_result)


    """ FUNCTIONS RELATED WITH TAB CONECTIONS"""
    def fill_tab_connections(self):
        """ Fill tab 'Connections' """
        self.fill_table(self.dlg_cf.tbl_upstream, self.schema_name + ".v_ui_node_x_connection_upstream")
        self.set_configuration(self.dlg_cf.tbl_upstream, "v_ui_node_x_connection_upstream")

        self.fill_table(self.dlg_cf.tbl_downstream, self.schema_name + ".v_ui_node_x_connection_downstream")
        self.set_configuration(self.dlg_cf.tbl_downstream, "v_ui_node_x_connection_downstream")

        self.dlg_cf.tbl_upstream.doubleClicked.connect(partial(self.open_up_down_stream, self.tbl_upstream))
        self.dlg_cf.tbl_downstream.doubleClicked.connect(partial(self.open_up_down_stream, self.tbl_downstream))

    def open_up_down_stream(self, qtable):
        """ Open selected node from @qtable """

        selected_list = qtable.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        row = selected_list[0].row()
        table_name = qtable.model().record(row).value("sys_table_id")
        sys_id_name = qtable.model().record(row).value("sys_id_name")
        feature_id = qtable.model().record(row).value("sys_id")
        api_cf = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir)
        complet_result = api_cf.open_form(table_name=table_name, feature_type=sys_id_name, feature_id=feature_id)
        if not complet_result:
            print("FAIL")
            return
        self.draw(complet_result)


    """ FUNCTIONS RELATED WITH TAB HYDROMETER"""
    def fill_tab_hydrometer(self):
        """ Fill tab 'Hydrometer' """

        table_hydro = "v_rtc_hydrometer"
        table_hydro_value = "v_edit_rtc_hydro_data_x_connec"
        self.fill_tbl_hydrometer(self.tbl_hydrometer, self.schema_name + "." + table_hydro, self.filter)
        self.set_configuration(self.tbl_hydrometer, table_hydro)
        self.fill_tbl_hydrometer(self.tbl_hydrometer_value, self.schema_name + "." + table_hydro_value, self.filter)
        self.set_configuration(self.tbl_hydrometer_value, table_hydro_value)


    def fill_tbl_hydrometer(self, widget, table_name, filter_):
        """ Fill the table control to show documents"""

        # Get widgets
        self.cmb_cat_period_id_filter = self.dlg_cf.findChild(QComboBox, "cmb_cat_period_id_filter")

        # Populate combo filter hydrometer value
        sql = ("SELECT DISTINCT cat_period_id, cat_period_id "
               " FROM " + self.schema_name + ".v_edit_rtc_hydro_data_x_connec ORDER BY cat_period_id")
        rows = self.controller.get_rows(sql, log_sql=True)
        utils_giswater.set_item_data(self.dlg_cf.cmb_cat_period_id_filter, rows)


        # Set signals
        if widget == self.tbl_hydrometer_value:
            self.cmb_cat_period_id_filter.currentIndexChanged.connect(partial(self.set_filter_hydrometer_values, widget))

        # Set model of selected widget
        self.set_model_to_table(widget, table_name, filter_)


    def set_filter_hydrometer_values(self, widget):
        """ Get Filter for table hydrometer value with combo value"""

        # Get combo value
        cat_period_id_filter = utils_giswater.get_item_data(self.dlg_cf, self.cmb_cat_period_id_filter, 0)

        # Set filter
        expr = self.field_id + " = '" + self.feature_id + "'"
        expr += " AND cat_period_id = '" + cat_period_id_filter + "'"
        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()


    """ FUNCTIONS RELATED WITH TAB OM"""
    def fill_tab_om(self, geom_type):
        """ Fill tab 'O&M' (event) """
        self.set_vdefault_values(self.dlg_cf.date_event_to, self.complet_result[0]['feature']['vdefaultValues'], 'to_date_vdefault')
        self.set_vdefault_values(self.dlg_cf.date_event_from, self.complet_result[0]['feature']['vdefaultValues'], 'from_date_vdefault')

        table_event_geom = "v_ui_event_x_" + geom_type
        self.fill_tbl_event(self.tbl_event, self.schema_name + "." + table_event_geom, self.filter)
        self.tbl_event.doubleClicked.connect(self.open_visit_event)
        self.set_configuration(self.tbl_event, table_event_geom)

        self.set_vdefault_values(self.dlg_cf.event_type, self.complet_result[0]['feature']['vdefaultValues'], 'om_param_type_vdefault')
        self.set_vdefault_values(self.dlg_cf.event_id, self.complet_result[0]['feature']['vdefaultValues'], 'parameter_vdefault')


    def fill_tbl_event(self, widget, table_name, filter_):
        """ Fill the table control to show documents """

        # Get widgets
        event_type = self.dlg_cf.findChild(QComboBox, "event_type")
        event_id = self.dlg_cf.findChild(QComboBox, "event_id")
        self.date_event_to = self.dlg_cf.findChild(QDateEdit, "date_event_to")
        self.date_event_from = self.dlg_cf.findChild(QDateEdit, "date_event_from")

        btn_open_visit = self.dlg_cf.findChild(QPushButton, "btn_open_visit")
        btn_new_visit = self.dlg_cf.findChild(QPushButton, "btn_new_visit")
        btn_open_gallery = self.dlg_cf.findChild(QPushButton, "btn_open_gallery")
        btn_open_visit_doc = self.dlg_cf.findChild(QPushButton, "btn_open_visit_doc")
        btn_open_visit_event = self.dlg_cf.findChild(QPushButton, "btn_open_visit_event")

        btn_open_gallery.setEnabled(False)
        btn_open_visit_doc.setEnabled(False)
        btn_open_visit_event.setEnabled(False)

        # Set signals
        widget.clicked.connect(partial(self.tbl_event_clicked, table_name))
        event_type.currentIndexChanged.connect(partial(self.set_filter_table_event, widget))
        event_id.currentIndexChanged.connect(partial(self.set_filter_table_event2, widget))
        self.date_event_to.dateChanged.connect(partial(self.set_filter_table_event, widget))
        self.date_event_from.dateChanged.connect(partial(self.set_filter_table_event, widget))

        btn_open_visit.clicked.connect(self.open_visit)
        btn_new_visit.clicked.connect(self.new_visit)
        btn_open_gallery.clicked.connect(self.open_gallery)
        btn_open_visit_doc.clicked.connect(self.open_visit_doc)
        btn_open_visit_event.clicked.connect(self.open_visit_event)

        feature_key = self.controller.get_layer_primary_key()
        if feature_key == 'node_id':
            feature_type = 'NODE'
        if feature_key == 'connec_id':
            feature_type = 'CONNEC'
        if feature_key == 'arc_id':
            feature_type = 'ARC'
        if feature_key == 'gully_id':
            feature_type = 'GULLY'

        table_name_event_id = "om_visit_parameter"

        # Fill ComboBox event_id
        sql = ("SELECT DISTINCT(id), id FROM " + self.schema_name + "." + table_name_event_id + ""
               " WHERE feature_type = '" + feature_type + "' OR feature_type = 'ALL'"
               " ORDER BY id")
        rows = self.controller.get_rows(sql)
        rows.append(['', ''])
        utils_giswater.set_item_data(self.dlg_cf.event_id, rows)
        # Fill ComboBox event_type
        sql = ("SELECT DISTINCT(parameter_type), parameter_type FROM " + self.schema_name + "." + table_name_event_id + ""
               " WHERE feature_type = '" + feature_type + "' OR feature_type = 'ALL'"
               " ORDER BY parameter_type")
        rows = self.controller.get_rows(sql)
        rows.append(['', ''])
        utils_giswater.set_item_data(self.dlg_cf.event_type, rows)


        # Get selected dates
        date_from = self.date_event_from.date()
        date_to = self.date_event_to.date()
        if date_from > date_to:
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return

        format_low = 'yyyy-MM-dd 00:00:00.000'
        format_high = 'yyyy-MM-dd 23:59:59.999'
        interval = "'{}'::timestamp AND '{}'::timestamp".format(
            date_from.toString(format_low), date_to.toString(format_high))

        # Set filter
        filter_ += " AND(tstamp BETWEEN {0}) AND (tstamp BETWEEN {0})".format(interval)


        # Set model of selected widget
        self.set_model_to_table(widget, table_name, filter_)

    def open_visit_event(self):
        """ Open event of selected record of the table """

        # Open dialog event_standard
        self.dlg_event_full = EventFull()
        self.load_settings(self.dlg_event_full)
        self.dlg_event_full.rejected.connect(partial(self.close_dialog, self.dlg_event_full))
        # Get all data for one visit
        sql = ("SELECT * FROM " + self.schema_name + ".om_visit_event"
               " WHERE id = '" + str(self.event_id) + "' AND visit_id = '" + str(self.visit_id) + "'")
        row = self.controller.get_row(sql)
        if not row:
            return

        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.id, row['id'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.event_code, row['event_code'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.visit_id, row['visit_id'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.position_id, row['position_id'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.position_value, row['position_value'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.parameter_id, row['parameter_id'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.value, row['value'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.value1, row['value1'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.value2, row['value2'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.geom1, row['geom1'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.geom2, row['geom2'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.geom3, row['geom3'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.xcoord, row['xcoord'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.ycoord, row['ycoord'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.compass, row['compass'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.tstamp, row['tstamp'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.text, row['text'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.index_val, row['index_val'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.is_last, row['is_last'])

        # Set all QLineEdit readOnly(True)
        widget_list = self.dlg_event_full.findChildren(QLineEdit)
        for widget in widget_list:
            widget.setReadOnly(True)
            widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242);"
                                 " color: rgb(100, 100, 100)}")
        self.dlg_event_full.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_event_full))

        self.dlg_event_full.open()

    def tbl_event_clicked(self, table_name):

        # Enable/Disable buttons
        btn_open_gallery = self.dlg_cf.findChild(QPushButton, "btn_open_gallery")
        btn_open_visit_doc = self.dlg_cf.findChild(QPushButton, "btn_open_visit_doc")
        btn_open_visit_event = self.dlg_cf.findChild(QPushButton, "btn_open_visit_event")
        btn_open_gallery.setEnabled(False)
        btn_open_visit_doc.setEnabled(False)
        btn_open_visit_event.setEnabled(True)

        # Get selected row
        selected_list = self.tbl_event.selectionModel().selectedRows()
        selected_row = selected_list[0].row()
        self.visit_id = self.tbl_event.model().record(selected_row).value("visit_id")
        self.event_id = self.tbl_event.model().record(selected_row).value("event_id")
        self.parameter_id = self.tbl_event.model().record(selected_row).value("parameter_id")

        sql = ("SELECT gallery, document FROM " + table_name + ""
               " WHERE event_id = '" + str(self.event_id) + "' AND visit_id = '" + str(self.visit_id) + "'")
        row = self.controller.get_row(sql, log_sql=True)
        if not row:
            return

        # If gallery 'True' or 'False'
        if str(row[0]) == 'True':
            btn_open_gallery.setEnabled(True)

        # If document 'True' or 'False'
        if str(row[1]) == 'True':
            btn_open_visit_doc.setEnabled(True)

    def set_filter_table_event(self, widget):
        """ Get values selected by the user and sets a new filter for its table model """

        # Get selected dates
        date_from = self.date_event_from.date()
        date_to = self.date_event_to.date()

        if date_from > date_to:
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return

        # Cascade filter
        table_name_event_id = "om_visit_parameter"
        event_type_value = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.event_type, 0)

        # Get type of feature
        feature_key = self.controller.get_layer_primary_key()
        if feature_key == 'node_id':
            feature_type = 'NODE'
        if feature_key == 'connec_id':
            feature_type = 'CONNEC'
        if feature_key == 'arc_id':
            feature_type = 'ARC'
        if feature_key == 'gully_id':
            feature_type = 'GULLY'

        # Fill ComboBox event_id
        sql = ("SELECT DISTINCT(id), id FROM " + self.schema_name + "." + table_name_event_id + ""
               " WHERE (feature_type = '" + feature_type + "' OR feature_type = 'ALL')")
        if event_type_value != 'null':
            sql += " AND parameter_type ILIKE '%" + event_type_value + "%'"
        sql += " ORDER BY id"
        rows = self.controller.get_rows(sql, log_sql=True)
        rows.append(['', ''])
        utils_giswater.set_item_data(self.dlg_cf.event_id, rows, 1)

        # End cascading filter
        # Get selected values in Comboboxes
        event_type_value = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.event_type, 0)
        event_id = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.event_id, 0)
        format_low = 'yyyy-MM-dd 00:00:00.000'
        format_high = 'yyyy-MM-dd 23:59:59.999'
        interval = "'{}'::timestamp AND '{}'::timestamp".format(
            date_from.toString(format_low), date_to.toString(format_high))
        # Set filter to model
        expr = self.field_id + " = '" + self.feature_id + "'"
        # Set filter
        expr += " AND(tstamp BETWEEN {0}) AND (tstamp BETWEEN {0})".format(interval)

        if event_type_value != 'null':
            expr += " AND parameter_type ILIKE '%" + event_type_value + "%'"

        if event_id != 'null':
            expr += " AND parameter_id ILIKE '%" + event_id + "%'"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()

    def set_filter_table_event2(self, widget):
        """ Get values selected by the user and sets a new filter for its table model """

        # Get selected dates
        date_from = self.date_event_from.date()
        date_to = self.date_event_to.date()
        if date_from > date_to:
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return

        format_low = 'yyyy-MM-dd 00:00:00.000'
        format_high = 'yyyy-MM-dd 23:59:59.999'
        interval = "'{}'::timestamp AND '{}'::timestamp".format(
            date_from.toString(format_low), date_to.toString(format_high))
        # Set filter to model
        expr = self.field_id + " = '" + self.feature_id + "'"
        # Set filter
        expr += " AND(tstamp BETWEEN {0}) AND (tstamp BETWEEN {0})".format(interval)

        # Get selected values in Comboboxes
        event_type_value = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.event_type, 0)
        if event_type_value != 'null':
            expr += " AND parameter_type ILIKE '%" + event_type_value + "%'"
        event_id = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.event_id, 0)
        if event_id != 'null':
            expr += " AND parameter_id ILIKE '%" + event_id + "%'"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()

    def open_visit(self):
        """ Call button 65: om_visit_management """

        manage_visit = ManageVisit(self.iface, self.settings, self.controller, self.plugin_dir)
        manage_visit.visit_added.connect(self.update_visit_table)
        manage_visit.edit_visit(self.geom_type, self.feature_id)

    # creat the new visit GUI
    def update_visit_table(self):
        """Convenience fuction set as slot to update table after a Visit GUI close."""
        self.tbl_event.model().select()


    def new_visit(self):
        """ Call button 64: om_add_visit """
        # Get expl_id to save it on om_visit and show the geometry of visit
        expl_id = utils_giswater.get_item_data(self.dlg_cf, 'expl_id', 0)
        if expl_id == -1:
            msg = "Widget expl_id not found"
            self.controller.show_warning(msg)
            return
        manage_visit = ManageVisit(self.iface, self.settings, self.controller, self.plugin_dir)
        manage_visit.visit_added.connect(self.update_visit_table)
        # TODO: the following query fix a (for me) misterious bug
        # the DB connection is not available during manage_visit.manage_visit first call
        # so the workaroud is to do a unuseful query to have the dao controller active
        sql = ("SELECT id FROM " + self.schema_name + ".om_visit LIMIT 1")
        self.controller.get_rows(sql, commit=True)
        manage_visit.manage_visit(geom_type=self.geom_type, feature_id=self.feature_id, expl_id=expl_id)

    def open_gallery(self):
        """ Open gallery of selected record of the table """

        # Open Gallery
        gal = ManageGallery(self.iface, self.settings, self.controller, self.plugin_dir)
        gal.manage_gallery()
        gal.fill_gallery(self.visit_id, self.event_id)


    def open_visit_doc(self):
        """ Open document of selected record of the table """

        # Get all documents for one visit
        sql = ("SELECT doc_id FROM " + self.schema_name + ".doc_x_visit"
               " WHERE visit_id = '" + str(self.visit_id) + "'")
        rows = self.controller.get_rows(sql)
        if not rows:
            return

        num_doc = len(rows)

        if num_doc == 1:
            # If just one document is attached directly open

            # Get path of selected document
            sql = ("SELECT path"
                   " FROM " + self.schema_name + ".ve_ui_doc"
                   " WHERE id = '" + str(rows[0][0]) + "'")
            row = self.controller.get_row(sql)
            if not row:
                return

            path = str(row[0])

            # Parse a URL into components
            url = urlparse.urlsplit(path)

            # Open selected document
            # Check if path is URL
            if url.scheme == "http" or url.scheme == "https":
                # If path is URL open URL in browser
                webbrowser.open(path)
            else:
                # If its not URL ,check if file exist
                if not os.path.exists(path):
                    message = "File not found"
                    self.controller.show_warning(message, parameter=path)
                else:
                    # Open the document
                    os.startfile(path)
        else:
            # If more then one document is attached open dialog with list of documents
            self.dlg_load_doc = LoadDocuments()
            self.load_settings(self.dlg_load_doc)
            self.dlg_load_doc.rejected.connect(partial(self.close_dialog, self.dlg_load_doc))
            btn_open_doc = self.dlg_load_doc.findChild(QPushButton, "btn_open")
            btn_open_doc.clicked.connect(self.open_selected_doc)

            lbl_visit_id = self.dlg_load_doc.findChild(QLineEdit, "visit_id")
            lbl_visit_id.setText(str(self.visit_id))

            self.tbl_list_doc = self.dlg_load_doc.findChild(QListWidget, "tbl_list_doc")
            self.tbl_list_doc.itemDoubleClicked.connect(partial(self.open_selected_doc))
            for row in rows:
                item_doc = QListWidgetItem(str(row[0]))
                self.tbl_list_doc.addItem(item_doc)

            self.dlg_load_doc.open()

    def open_selected_doc(self):

        # Selected item from list
        selected_document = self.tbl_list_doc.currentItem().text()

        # Get path of selected document
        sql = ("SELECT path FROM " + self.schema_name + ".ve_ui_doc"
               " WHERE id = '" + str(selected_document) + "'")
        row = self.controller.get_row(sql)
        if not row:
            return

        path = str(row[0])

        # Parse a URL into components
        url = urlparse.urlsplit(path)

        # Open selected document
        # Check if path is URL
        if url.scheme == "http" or url.scheme == "https":
            # If path is URL open URL in browser
            webbrowser.open(path)
        else:
            # If its not URL ,check if file exist
            if not os.path.exists(path):
                message = "File not found"
                self.controller.show_warning(message, parameter=path)
            else:
                # Open the document
                os.startfile(path)


    """ FUNCTIONS RELATED WITH TAB DOC"""
    def fill_tab_document(self):
        """ Fill tab 'Document' """
        self.set_vdefault_values(self.dlg_cf.date_document_to, self.complet_result[0]['feature']['vdefaultValues'], 'to_date_vdefault')
        self.set_vdefault_values(self.dlg_cf.date_document_from, self.complet_result[0]['feature']['vdefaultValues'], 'from_date_vdefault')
        table_document = "v_ui_doc_x_"+self.geom_type
        self.fill_tbl_document_man(self.dlg_cf, self.tbl_document, table_document, self.filter)
        self.set_configuration(self.tbl_document, table_document)
        self.set_vdefault_values(self.dlg_cf.doc_type, self.complet_result[0]['feature']['vdefaultValues'], 'document_type_vdefault')

    def fill_tbl_document_man(self, dialog, widget, table_name, expr_filter):
        """ Fill the table control to show documents """

        # Set model of selected widget
        self.set_model_to_table(widget, self.schema_name + "." + table_name, expr_filter)
        # Get widgets
        txt_doc_id = self.dlg_cf.findChild(QLineEdit, "txt_doc_id")
        doc_type = self.dlg_cf.findChild(QComboBox, "doc_type")
        self.date_document_to = self.dlg_cf.findChild(QDateEdit, "date_document_to")
        self.date_document_from = self.dlg_cf.findChild(QDateEdit, "date_document_from")
        btn_open_doc = self.dlg_cf.findChild(QPushButton, "btn_open_doc")
        btn_doc_delete = self.dlg_cf.findChild(QPushButton, "btn_doc_delete")
        btn_doc_insert = self.dlg_cf.findChild(QPushButton, "btn_doc_insert")
        btn_doc_new = self.dlg_cf.findChild(QPushButton, "btn_doc_new")

        # Set signals
        doc_type.currentIndexChanged.connect(partial(self.set_filter_table_man, widget))
        self.date_document_to.dateChanged.connect(partial(self.set_filter_table_man, widget))
        self.date_document_from.dateChanged.connect(partial(self.set_filter_table_man, widget))
        self.tbl_document.doubleClicked.connect(partial(self.open_selected_document, widget))
        btn_open_doc.clicked.connect(partial(self.open_selected_document, widget))
        btn_doc_delete.clicked.connect(partial(self.delete_records, widget, table_name))
        btn_doc_insert.clicked.connect(partial(self.add_object, widget, "doc", "ve_ui_doc"))
        btn_doc_new.clicked.connect(partial(self.manage_new_document, dialog, None, self.feature))

        # Fill ComboBox doc_type
        sql = ("SELECT id, id FROM " + self.schema_name + ".doc_type ORDER BY id")
        rows = self.controller.get_rows(sql)
        rows.append(['', ''])
        utils_giswater.set_item_data(doc_type, rows)

        # Adding auto-completion to a QLineEdit
        self.table_object = "doc"
        self.set_completer_object(dialog, self.table_object)


    def set_filter_table_man(self, widget):
        """ Get values selected by the user and sets a new filter for its table model """

        # Get selected dates
        date_from = self.date_document_from.date()
        date_to = self.date_document_to.date()
        if (date_from > date_to):
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return
        # Create interval dates
        format_low = 'yyyy-MM-dd 00:00:00.000'
        format_high = 'yyyy-MM-dd 23:59:59.999'
        interval = "'{}'::timestamp AND '{}'::timestamp".format(
            date_from.toString(format_low), date_to.toString(format_high))

        # Set filter
        expr = self.field_id + " = '" + self.feature_id + "'"
        expr += " AND(date BETWEEN {0}) AND (date BETWEEN {0})".format(interval)

        # Get selected values in Comboboxes
        doc_type_value = utils_giswater.get_item_data(self.dlg_cf, self.dlg_cf.doc_type, 0)
        if doc_type_value != 'null' and doc_type_value is not None:
            expr += " AND doc_type ILIKE '%" + str(doc_type_value) + "%'"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()


    def open_selected_document(self, widget):
        """ Open selected document of the @widget """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        elif len(selected_list) > 1:
            message = "Select just one document"
            self.controller.show_warning(message)
            return

        # Get document path (can be relative or absolute)
        row = selected_list[0].row()
        path = widget.model().record(row).value("path")

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

    def manage_new_document(self, dialog, doc_id=None, feature=None):
        """ Execute action of button 34 """
        doc = ManageDocument(self.iface, self.settings, self.controller, self.plugin_dir)
        doc.manage_document(feature=feature)
        doc.dlg_add_doc.accepted.connect(partial(self.manage_document_new, dialog, doc))
        doc.dlg_add_doc.rejected.connect(partial(self.manage_document_new, dialog, doc))

        # Set completer
        self.set_completer_object(dialog, self.table_object)
        if doc_id:
            utils_giswater.setWidgetText(dialog, "doc_id", doc_id)

        # # Open dialog
        # doc.open_dialog(doc.dlg_add_doc)


    def manage_document_new(self, dialog, doc):
        """ Get inserted doc_id and add it to current feature """

        if doc.doc_id is None:
            return

        utils_giswater.setWidgetText(dialog, "doc_id", doc.doc_id)
        self.add_object(self.tbl_document, "doc", "ve_ui_doc")

    """ FUNCTIONS RELATED WITH TAB RPT """
    def fill_tab_rpt(self):
        standar_model = QStandardItemModel()
        complet_list, widget_list = self.init_tbl_rpt(self.dlg_cf, standar_model, "rpt_layout1", "tbl_rpt")
        self.populate_table(complet_list, standar_model, self.dlg_cf, widget_list, filter=False)
        self.set_listeners(complet_list, standar_model, self.dlg_cf, widget_list)
        self.set_configuration(self.tbl_rpt, "table_rpt", sort_order=1, isQStandardItemModel=True)
        self.dlg_cf.btn_filter.clicked.connect(partial(self.populate_table, complet_list, standar_model, self.dlg_cf, widget_list))
        self.dlg_cf.tbl_rpt.doubleClicked.connect(partial(self.open_rpt_result, self.dlg_cf.tbl_rpt,  complet_list))

    def init_tbl_rpt(self, dialog, standar_model, layout_name, qtv_name):
        """ Put filter widgets into layout and set headers into QTableView"""

        rpt_layout1 = dialog.findChild(QGridLayout, layout_name)
        qtable = dialog.findChild(QTableView, qtv_name)
        self.clear_gridlayout(rpt_layout1)
        index_tab = self.tab_main.currentIndex()
        tab_name = self.tab_main.widget(index_tab).objectName()
        complet_list = self.get_list(tab_name='"tabName":"' + tab_name + '"', limit=5000)

        # Put filter widgets into layout
        widget_list = []
        for field in complet_list[0]['data']['filterFields']:
            label, widget = self.set_widgets(dialog, field)
            widget.setMaximumWidth(125)
            widget_list.append(widget)
            rpt_layout1.addWidget(label, 0, field['layout_order'])
            rpt_layout1.addWidget(widget, 1, field['layout_order'])
        vertical_spacer = QSpacerItem(10, 10, QSizePolicy.Expanding, QSizePolicy.Minimum)
        rpt_layout1.addItem(vertical_spacer, field['layout_order'], rpt_layout1.columnCount())
        # Find combo parents:
        for field in complet_list[0]['data']['filterFields']:
            if field['isparent']:
                widget = dialog.findChild(QComboBox, field['column_id'])
                widget.currentIndexChanged.connect(partial(self.fill_child, dialog, widget))

        # Related by Qtable
        qtable.setModel(standar_model)
        qtable.horizontalHeader().setStretchLastSection(True)

        # # Get headers
        headers = []
        for x in complet_list[0]['data']['listValues'][0]:
            headers.append(x)
        # Set headers
        standar_model.setHorizontalHeaderLabels(headers)

        return complet_list, widget_list


    def set_listeners(self, complet_list, standar_model, dialog, widget_list):
        for widget in widget_list:
            if type(widget) is QLineEdit:
                widget.textChanged.connect(partial(self.populate_table, complet_list, standar_model, dialog, widget_list))
            elif type(widget) is QComboBox:
                widget.currentIndexChanged.connect(partial(self.populate_table, complet_list, standar_model, dialog, widget_list))


    def get_list(self, tab_name='', limit=10, filter_fields='"filterFields":{}'):
        header = '"header":{"device":3, "infoType":100, "lang":"ES"}, '
        form = '"form":{' + tab_name + '}, '
        feature = '"feature":{"tableName":"' + self.tablename + '"}, '
        data = '"data":{'+filter_fields+' ,"pageInfo":{"limit":"'+str(limit)+'"}}'
        body = "" + header + form + feature + data
        sql = ("SELECT " + self.schema_name + ".gw_api_get_list($${" + body + "}$$)")
        row = self.controller.get_row(sql, log_sql=True)
        if not row:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return False
        complet_list = row
        return complet_list


    def populate_table(self, complet_list, standar_model, dialog, widget_list, filter=True):
        filter_fields = '"filterFields":{}'
        if filter:
            filter_fields = self.get_filter_qtableview(complet_list, standar_model, dialog, widget_list)
        index_tab = self.tab_main.currentIndex()
        tab_name = self.tab_main.widget(index_tab).objectName()
        cmb_limit = dialog.findChild(QComboBox, tab_name+'_limit')
        limit = 99999
        if cmb_limit:
            limit = utils_giswater.get_item_data(dialog, tab_name+"_limit", 1)
        if limit is None or not limit:
            limit = 99999
        complet_list = self.get_list(tab_name='"tabName":"' + tab_name + '"', limit=limit, filter_fields=filter_fields)

        # for item in complet_list[0]['data']['listValues'][0]:
        #     row = [QStandardItem(str(value)) for value in item.values() if filter in str(item['event_id'])]
        #     if len(row) > 0:
        #         standar_model.appendRow(row)
        for item in complet_list[0]['data']['listValues']:
            row = []
            for value in item.values():
                row.append(QStandardItem(str(value)))
            if len(row) > 0:
                standar_model.appendRow(row)

    def get_filter_qtableview(self, complet_list, standar_model, dialog, widget_list):

        standar_model.clear()
        # Get headers
        headers = []
        for x in complet_list[0]['data']['listValues'][0]:
            headers.append(x)
        # Set headers
        standar_model.setHorizontalHeaderLabels(headers)
        index_tab = dialog.tab_main.currentIndex()
        tab_name = dialog.tab_main.widget(index_tab).objectName()
        filter = ""
        for widget in widget_list:
            if widget.objectName() != tab_name+'_limit':
                column_id = widget.objectName()
                text = utils_giswater.getWidgetText(dialog, widget)
                filter += '"' + column_id + '":"'+text+'", '
        if filter == "":
            return None

        filter=filter[:-2]
        filter_fields = '"filterFields":{'+filter+'}'
        return filter_fields
        #filter = utils_giswater.getWidgetText(self.dlg_cf, self.dlg_cf.txt_rpt_filter, False, False)

        # for item in complet_rpt[0]['mincuts']:
        #     row = [QStandardItem(str(value)) for value in item.values() if filter in str(item['event_id'])]
        #     if len(row) > 0:
        #         standar_model.appendRow(row)
        # for item in complet_list[0]['data']['listValues']:
        #     row = []
        #     for value in item.values():
        #         #if filter in str(item['event_id']):
        #         row.append(QStandardItem(str(value)))
        #     if len(row) > 0:
        #         standar_model.appendRow(row)


    def open_rpt_result(self, qtable,  complet_list):
        """ Open form of selected element of the @widget?? """

        # Get selected rows
        selected_list = qtable.selectionModel().selectedRows()

        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        index = selected_list[0]
        row = index.row()

        table_name = complet_list[0]['feature']['tableName']
        sys_id_name = complet_list[0]['feature']['idName']
        column_index = 0
        column_index = utils_giswater.get_column_by_name(qtable, 'sys_id')
        feature_id = index.sibling(row, column_index).data()

        # return
        api_cf = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir)
        complet_result = api_cf.open_form(table_name=table_name, feature_type=sys_id_name, feature_id=feature_id)
        if not complet_result:
            print("FAIL")
            return
        self.draw(complet_result)



    """ FUNCTIONS RELATED WITH TAB PLAN """
    def fill_tab_plan(self):
        plan_layout = self.dlg_cf.findChild(QGridLayout, 'plan_layout')
        if self.geom_type == 'arc' or self.geom_type == 'node':
            sql = ("SELECT " + self.schema_name + ".gw_api_get_infoplan('infoplan', 9)")
            row = self.controller.get_row(sql, log_sql=True)
            if not row:
                self.controller.show_message("NOT ROW FOR: " + sql, 2)
            else:
                result = row[0]['editData']
                if 'fields' not in result:
                    self.controller.show_message("No fields for: " + row[0]['editData'], 2)
                else:
                    for field in result["fields"]:
                        if field['widgettype'] == 11:
                            y = 2
                            for x in range(0, y):
                                line = self.add_frame(field, x)
                                plan_layout.addWidget(line, field['layout_order'], x)
                        else:
                            label = QLabel()
                            label.setTextInteractionFlags(Qt.TextSelectableByMouse)
                            label.setObjectName('lbl_' + field['form_label'])
                            label.setText(field['form_label'].capitalize())
                            if 'tooltip' in field:
                                label.setToolTip(field['tooltip'])
                            else:
                                label.setToolTip(field['form_label'].capitalize())
                        if field['widgettype'] == 12:
                            widget = self.add_label(field)
                            label.setWordWrap(True)
                            plan_layout.addWidget(label, field['layout_order'], 0)
                            plan_layout.addWidget(widget, field['layout_order'], 1)

                    plan_vertical_spacer = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
                    plan_layout.addItem(plan_vertical_spacer)
    """ ****************************  **************************** """
    """ ****************************  **************************** """
    """ ****************************  **************************** """
    """ NEW WORKCAT"""
    def cf_new_workcat(self, dialog):

        sql = ("SELECT " + self.schema_name + ".gw_api_get_newworkcat('new_workcat', 9)")
        row = self.controller.get_row(sql, log_sql=True)

        self.dlg_new_workcat = ApiBasicInfo()

        self.load_settings(self.dlg_new_workcat)
        # Set signals
        self.dlg_new_workcat.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_new_workcat))
        self.dlg_new_workcat.rejected.connect(partial(self.close_dialog, self.dlg_new_workcat))
        self.dlg_new_workcat.btn_accept.clicked.connect(partial(self.cf_manage_new_workcat_accept, 'cat_work'))

        self.populate_basic_info(self.dlg_new_workcat, row, self.field_id)

        # Open dialog
        self.open_dialog(self.dlg_new_workcat)



    def cf_manage_new_workcat_accept(self, table_object):
        """ Insert table 'cat_work'. Add cat_work """

        # Take widgets
        cat_work_id = self.dlg_new_workcat.findChild(QLineEdit, "cat_work_id")
        descript = self.dlg_new_workcat.findChild(QLineEdit, "descript")
        link = self.dlg_new_workcat.findChild(QLineEdit, "link")
        workid_key_1 = self.dlg_new_workcat.findChild(QLineEdit, "workid_key_1")
        workid_key_2 = self.dlg_new_workcat.findChild(QLineEdit, "workid_key_2")
        builtdate = self.dlg_new_workcat.findChild(QgsDateTimeEdit, "builtdate")

        # Get values from dialog
        values = ""
        fields = ""
        cat_work_id = utils_giswater.getWidgetText(self.dlg_new_workcat, cat_work_id)
        if cat_work_id != "null":
            fields += 'id, '
            values += ("'" + str(cat_work_id) + "', ")
        descript = utils_giswater.getWidgetText(self.dlg_new_workcat, descript)
        if descript != "null":
            fields += 'descript, '
            values += ("'" + str(descript) + "', ")
        link = utils_giswater.getWidgetText(self.dlg_new_workcat, link)
        if link != "null":
            fields += 'link, '
            values += ("'" + str(link) + "', ")
        workid_key_1 = utils_giswater.getWidgetText(self.dlg_new_workcat, workid_key_1)
        if workid_key_1 != "null":
            fields += 'workid_key1, '
            values += ("'" + str(workid_key_1) + "', ")
        workid_key_2 = utils_giswater.getWidgetText(self.dlg_new_workcat, workid_key_2)
        if workid_key_2 != "null":
            fields += 'workid_key2, '
            values += ("'" + str(workid_key_2) + "', ")
        builtdate = builtdate.dateTime().toString('yyyy-MM-dd')
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
                        cmb_workcat_id = self.dlg_cf.findChild(QComboBox, "workcat_id")
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

        path = widget.text()
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

        feature_id = utils_giswater.getWidgetText(dialog, widget)
        self.ApiCF = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir)
        complet_result = self.ApiCF.open_form(table_name='ve_node',  feature_type='node_id', feature_id=feature_id)
        if not complet_result:
            print("FAIL")
            return
        self.draw(complet_result)


    """ OTHER FUNCTIONS """
    def set_vdefault_values(self, widget, values, parameter):
        # Set dates from
        if type(widget) is QDateEdit:
            if parameter in values:
                date = QDate.fromString(values[parameter], 'yyyy/MM/dd')
            else:
                date = QDate.currentDate()
            widget.setDate(date)
        elif type(widget) is QComboBox:
            if parameter in values:
                utils_giswater.set_combo_itemData(widget, values[parameter], 0)


    def restore(self, restore_cursor=True):
        if restore_cursor:
            QApplication.restoreOverrideCursor()
        # TODO buscar la QAction concreta y deschequearla
        actions = self.iface.mainWindow().findChildren(QAction)
        for a in actions:
            a.setChecked(False)
        self.emit_point.canvasClicked.disconnect()


    def set_configuration(self, widget, table_name, sort_order=0, isQStandardItemModel=False):
        """ Configuration of tables. Set visibility and width of columns """

        widget = utils_giswater.getWidget(self.dlg_cf, widget)
        if not widget:
            return

        # Set width and alias of visible columns
        columns_to_delete = []
        sql = ("SELECT column_index, width, alias, status"
               " FROM " + self.schema_name + ".config_client_forms"
               " WHERE table_id = '" + table_name + "'"
               " ORDER BY column_index")
        rows = self.controller.get_rows(sql, log_info=False)
        if not rows:
            return

        for row in rows:
            if not row['status']:
                columns_to_delete.append(row['column_index'] - 1)
            else:
                width = row['width']
                if width is None:
                    width = 100
                widget.setColumnWidth(row['column_index'] - 1, width)
                widget.model().setHeaderData(row['column_index'] - 1, Qt.Horizontal, row['alias'])

        # Set order
        if not isQStandardItemModel:
            widget.model().setSort(sort_order, Qt.AscendingOrder)
            widget.model().select()
        else:
            widget.model().sort(sort_order, Qt.AscendingOrder)
        # Delete columns
        for column in columns_to_delete:
            widget.hideColumn(column)


    def set_image(self, dialog, widget):
        utils_giswater.setImage(dialog, widget, "ws_shape.png")


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

