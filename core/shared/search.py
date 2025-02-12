"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
import re
from functools import partial

from qgis.PyQt.QtCore import QStringListModel, Qt, QTimer
from qgis.PyQt.QtWidgets import QAbstractItemView, QComboBox, QCompleter, QFileDialog, QGridLayout, QHeaderView, \
    QLabel, QLineEdit, QSizePolicy, QSpacerItem, QTableView, QTabWidget, QWidget, QDockWidget, QCheckBox
from qgis.core import QgsPointXY

from libs import tools_os
from .info import GwInfo
from .psector import GwPsector
from .visit import GwVisit
from .workcat import GwWorkcat
from ..ui.ui_manager import GwInfoGenericUi
from ..utils import tools_gw
from ... import global_vars
from ...libs import lib_vars, tools_qgis, tools_qt


class GwSearch:

    def __init__(self):

        self.manage_new_psector = GwPsector()
        self.manage_visit = GwVisit()
        self.iface = global_vars.iface
        self.project_type = global_vars.project_type
        self.canvas = global_vars.canvas
        self.schema_name = lib_vars.schema_name
        self.json_search = {}
        self.lbl_visible = False
        self.dlg_search = None
        self.is_mincut = False
        self.rubber_band = tools_gw.create_rubberband(self.canvas)
        self.aux_rubber_band = tools_gw.create_rubberband(self.canvas)


    def open_search(self, dlg_search, dlg_mincut=None):

        # If dlg_search is not None we are going to open search independently.
        if dlg_search:
            self.dlg_search = dlg_search
            self.dlg_search.setProperty('class', self)

        # If dlg_mincut is None we are not opening from mincut
        form = ""
        if dlg_mincut:
            self.dlg_search = dlg_mincut
            self.is_mincut = True
            form = f'"singleTab":"tab_address"'

        self.dlg_search.lbl_msg.setStyleSheet("QLabel{color:red;}")
        self.dlg_search.lbl_msg.setVisible(False)
        qgis_project_add_schema = lib_vars.project_vars['add_schema']
        if qgis_project_add_schema is None:
            body = tools_gw.create_body(form=form)
        else:
            extras = f'"addSchema":"{qgis_project_add_schema}"'
            body = tools_gw.create_body(form=form, extras=extras)
        complet_list = tools_gw.execute_procedure('gw_fct_getsearch', body)
        if not complet_list or complet_list['status'] == 'Failed':
            return False

        main_tab = self.dlg_search.findChild(QTabWidget, 'main_tab')
        if dlg_mincut and len(complet_list["form"]) == 1:
            main_tab = self.dlg_search.findChild(QTabWidget, 'main_tab')
            main_tab.setStyleSheet("QTabBar::tab { background-color: transparent; text-align:left;"
                                   "border: 1px solid transparent;}"
                                   "QTabWidget::pane { background-color: #fcfcfc; border: 1 solid #dadada;}")

        first_tab = None
        self.lineedit_list = []
        for tab in complet_list["form"]:
            if first_tab is None:
                first_tab = tab['tabName']
            tab_widget = QWidget(main_tab)
            tab_widget.setObjectName(tab['tabName'])
            main_tab.addTab(tab_widget, tab['tabLabel'])
            gridlayout = QGridLayout()
            tab_widget.setLayout(gridlayout)
            x = 0

            for field in tab['fields']:
                try:
                    label = QLabel()
                    label.setObjectName('lbl_' + field['label'])
                    label.setText(field['label'].capitalize())

                    tooltip = field.get('tooltip')
                    if tooltip:
                        label.setToolTip(field['tooltip'])
                    else:
                        label.setToolTip(field['label'].capitalize())

                    widget = None
                    if field['widgettype'] == 'typeahead':
                        completer = QCompleter()
                        widget = tools_gw.add_lineedit(field)
                        widget = self._set_typeahead_completer(widget, completer)
                        self.lineedit_list.append(widget)
                    elif field['widgettype'] == 'combo':
                        widget = self._add_combobox(field)
                    elif field['widgettype'] == 'check':
                        kwargs = {"dialog": self.dlg_search, "field": field}
                        widget = tools_gw.add_checkbox(**kwargs)
                    gridlayout.addWidget(label, x, 0)
                    gridlayout.addWidget(widget, x, 1)
                    x += 1
                except Exception:
                    msg = f"key 'comboIds' or/and comboNames not found WHERE columname='{field['columnname']}' AND " \
                          f"widgetname='{field['widgetname']}' AND widgettype='{field['widgettype']}'"
                    tools_qgis.show_message(msg, 2)

            vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
            gridlayout.addItem(vertical_spacer1)

        if self.is_mincut is False:
            tools_qt.manage_translation('search', self.dlg_search)
            self._init_dialog()


    def export_to_csv(self, dialog, qtable_1=None, qtable_2=None, path=None):

        folder_path = tools_qt.get_text(dialog, path)
        if folder_path is None or folder_path == 'null':
            path.setStyleSheet("border: 1px solid red")
            return

        path.setStyleSheet(None)
        if folder_path.find('.csv') == -1:
            folder_path += '.csv'
        if qtable_1:
            model_1 = qtable_1.model()
        else:
            return

        model_2 = None
        if qtable_2:
            model_2 = qtable_2.model()

        # Convert qtable values into list
        all_rows = []
        headers = []
        for i in range(0, model_1.columnCount()):
            headers.append(str(model_1.headerData(i, Qt.Horizontal)))
        all_rows.append(headers)
        for rows in range(0, model_1.rowCount()):
            row = []
            for col in range(0, model_1.columnCount()):
                row.append(str(model_1.data(model_1.index(rows, col))))
            all_rows.append(row)
        if qtable_2 is not None:
            headers = []
            for i in range(0, model_2.columnCount()):
                headers.append(str(model_2.headerData(i, Qt.Horizontal)))
            all_rows.append(headers)
            for rows in range(0, model_2.rowCount()):
                row = []
                for col in range(0, model_2.columnCount()):
                    row.append(str(model_2.data(model_2.index(rows, col))))
                all_rows.append(row)

        # Write list into csv file
        try:
            if os.path.exists(folder_path):
                msg = "Are you sure you want to overwrite this file?"
                answer = tools_qt.show_question(msg, "Overwrite")
                if answer:
                    self._write_to_csv(dialog, folder_path, all_rows)
            else:
                self._write_to_csv(dialog, folder_path, all_rows)
        except Exception:
            msg = "File path doesn't exist or you dont have permission or file is opened"
            tools_qgis.show_warning(msg, dialog=dialog)


    def refresh_tab(self, tab_name=None):
        
        if tab_name:
            form = f'"singleTab":"{tab_name}"'
        else:
            form = ''

        qgis_project_add_schema = lib_vars.project_vars['add_schema']
        if qgis_project_add_schema is None:
            body = tools_gw.create_body(form=form)
        else:
            extras = f'"addSchema":"{qgis_project_add_schema}"'
            body = tools_gw.create_body(form=form, extras=extras)
        complet_list = tools_gw.execute_procedure('gw_fct_getsearch', body)

        main_tab = self.dlg_search.findChild(QTabWidget, 'main_tab')
        for tab in complet_list["form"]:
            for field in tab['fields']:
                try:
                    if field['widgettype'] == 'combo':
                        widget = main_tab.findChild(QComboBox, field['widgetname'])
                        tools_gw.fill_combo(widget, field)
                except Exception:
                    msg = f"key 'comboIds' or/and comboNames not found WHERE columname='{field['columnname']}' AND " \
                          f"widgetname='{field['widgetname']}' AND widgettype='{field['widgettype']}'"
                    tools_qgis.show_message(msg, 2)


    # region private functions


    def _init_dialog(self):
        """ Initialize dialog. Make it dockable in left dock widget area """

        self.iface.addDockWidget(Qt.LeftDockWidgetArea, self.dlg_search)
        self.dlg_search.dlg_closed.connect(self._reset_rubber_band)
        self.dlg_search.dlg_closed.connect(self._close_search)
        docker_search = self.iface.mainWindow().findChild(QDockWidget, 'dlg_search')


    def _reset_rubber_band(self):

        tools_gw.reset_rubberband(self.rubber_band)
        tools_gw.reset_rubberband(self.aux_rubber_band)


    def _close_search(self):

        self.dlg_search = None


    def _set_typeahead_completer(self, widget, completer=None):
        """ Set completer and add listeners """

        if completer:
            model = QStringListModel()
            completer.highlighted.connect(partial(self._check_tab, completer))
            self._make_list(completer, model, widget)
            widget.textChanged.connect(partial(self._make_list, completer, model, widget))

        return widget


    def _check_tab(self, completer):

        is_add_schema = False
        # We look for the index of current tab so we can search by name
        index = self.dlg_search.main_tab.currentIndex()

        # Get all QLineEdit for activate or we cant write when tab have more than 1 QLineEdit
        line_list = self.dlg_search.main_tab.widget(index).findChildren(QLineEdit)
        for line_edit in line_list:
            line_edit.setReadOnly(False)
            line_edit.setStyleSheet(None)

        # Get selected row
        row = completer.popup().currentIndex().row()
        if row == -1:
            return

        # Get text from selected row
        _key = completer.completionModel().index(row, 0).data()
        # Search text into self.result_data: this variable contains all matching objects in the function "make_list()"
        item = None
        for data in self.result_data['data']:
            if _key == data['display_name']:
                item = data
                break

        for line_edit in line_list:
            if 'id' in item:
                line_edit.setProperty('id_', item['id'])

        # Show info in docker?
        if self.is_mincut is False:
            tools_gw.init_docker()

        # Get selected tab name
        tab_selected = self.dlg_search.main_tab.widget(index).objectName()

        # check for addschema
        if tab_selected == 'add_network':
            is_add_schema = True

        # Tab 'network or add_network'
        if tab_selected == 'network' or tab_selected == 'add_network':
            self.customForm = GwInfo(tab_type='data')
            complet_result, dialog = self.customForm.get_info_from_id(
                item['sys_table_id'], tab_type='data', feature_id=item['sys_id'], is_add_schema=is_add_schema)

            if not complet_result:
                return

            # self.customForm.get_info_from_id (...) in turn ends up calling self.open_custom_form (...) which will draw
            # the line on the feature but not zoom. Here, with draw we redraw simply to zoom and so that there are not
            # two ruberbands (the one from self.open_custom_form (...) and this one) we delete these

            try:
                margin = float(complet_result['body']['feature']['zoomCanvasMargin']['mts'])
            except ValueError:
                margin = 50

            tools_gw.draw_by_json(complet_result, self.rubber_band, margin)
            self._reset_rubber_band()

        # Tab 'address' (streets)
        elif tab_selected == 'address' and 'id' in item and 'sys_id' not in item:
            polygon = item['st_astext']
            if polygon:
                polygon = polygon[9:len(polygon) - 2]
                polygon = polygon.split(',')
                x1, y1 = polygon[0].split(' ')
                x2, y2 = polygon[2].split(' ')
                tools_qgis.zoom_to_rectangle(x1, y1, x2, y2)
            else:
                message = f"Zoom unavailable. Doesn't exist the geometry for the street"
                tools_qgis.show_info(message, parameter=item['display_name'])

        # Tab 'address'
        elif tab_selected == 'address' and 'sys_x' in item and 'sys_y' in item:
            x1 = item['sys_x']
            y1 = item['sys_y']
            point = QgsPointXY(float(x1), float(y1))
            tools_qgis.draw_point(point, self.rubber_band, duration_time=5000)
            tools_qgis.zoom_to_rectangle(x1, y1, x1, y1, margin=100)
            self.canvas.refresh()

        # Tab 'hydro'
        elif tab_selected == 'hydro':
            # Get basic_search_hydrometer_show_connec param
            row = tools_gw.get_config_value("basic_search_hydrometer_show_connec", table='config_param_system')
            basic_search_hydrometer = tools_os.set_boolean(row['value'])
            if not basic_search_hydrometer:
                x1 = item['sys_x']
                y1 = item['sys_y']
                point = QgsPointXY(float(x1), float(y1))
                tools_qgis.draw_point(point, self.rubber_band)
                tools_qgis.zoom_to_rectangle(x1, y1, x1, y1, margin=100)
            self._open_hydrometer_dialog(table_name=item['sys_table_id'], feature_id=item['sys_id'],
                                         sys_feature_type_id=item['sys_feature_type_id'],
                                         basic_search_hydrometer=basic_search_hydrometer,
                                         feature_type=item['sys_feature'])

        # Tab 'workcat'
        elif tab_selected == 'workcat':
            workcat_instance = GwWorkcat(global_vars.iface, global_vars.canvas)
            workcat_instance.workcat_open_table_items(item)
            return

        # Tab 'psector'
        elif tab_selected == 'psector':
            list_coord = re.search('\(\((.*)\)\)', str(item['sys_geometry']))
            self.manage_new_psector.get_psector(item['sys_id'], list_coord)

        # Tab 'visit'
        elif tab_selected == 'visit':
            list_coord = re.search('\((.*)\)', str(item['sys_geometry']))
            if not list_coord:
                msg = "Empty coordinate list"
                tools_qgis.show_info(msg)
                self.manage_visit.get_visit(visit_id=item['sys_id'])
                return
            max_x, max_y, min_x, min_y = tools_qgis.get_max_rectangle_from_coords(list_coord)
            self._reset_rubber_band()
            point = QgsPointXY(float(max_x), float(max_y))
            tools_qgis.draw_point(point, self.rubber_band)
            tools_qgis.zoom_to_rectangle(max_x, max_y, min_x, min_y, margin=100)
            self.manage_visit.get_visit(visit_id=item['sys_id'])
            self.manage_visit.dlg_add_visit.rejected.connect(self.rubber_band.reset)
            return

        self.lbl_visible = False
        self.dlg_search.lbl_msg.setVisible(self.lbl_visible)


    def _make_list(self, completer, model, widget):
        """ Create a list of ids and populate widget (QLineEdit) """

        # Create 2 json, one for first QLineEdit and other for second QLineEdit
        form_search = ''
        extras_search = ''
        form_search_add = ''
        extras_search_add = ''
        result = None
        line_edit = None
        index = self.dlg_search.main_tab.currentIndex()
        combo_list = self.dlg_search.main_tab.widget(index).findChildren(QComboBox)
        line_list = self.dlg_search.main_tab.widget(index).findChildren(QLineEdit)
        chk_list = self.dlg_search.main_tab.widget(index).findChildren(QCheckBox)
        form_search += f'"tabName":"{self.dlg_search.main_tab.widget(index).objectName()}"'
        form_search_add += f'"tabName":"{self.dlg_search.main_tab.widget(index).objectName()}"'

        if combo_list:
            combo = combo_list[0]
            id = tools_qt.get_combo_value(self.dlg_search, combo, 0)
            name = tools_qt.get_combo_value(self.dlg_search, combo, 1)
            try:
                feature_type = tools_qt.get_combo_value(self.dlg_search, combo, 2)
                extras_search += f'"searchType":"{feature_type}", '
            except IndexError:
                pass
            extras_search += f'"{combo.property("columnname")}":{{"id":"{id}", "name":"{name}"}}, '
            extras_search_add += f'"{combo.property("columnname")}":{{"id":"{id}", "name":"{name}"}}, '

        if line_list:
            line_edit = line_list[0]
            # If current tab have more than one QLineEdit, clear second QLineEdit
            if len(line_list) == 2:
                line_edit.textChanged.connect(partial(self._clear_line_edit_add, line_list))

            value = tools_qt.get_text(self.dlg_search, line_edit, return_string_null=False)
            if str(value) == '':
                return

            qgis_project_add_schema = lib_vars.project_vars['add_schema']
            extras_search += f'"{line_edit.property("columnname")}":{{"text":"{value}"}}, '
            extras_search += f'"addSchema":"{qgis_project_add_schema}"'
            if chk_list:
                chk_list = chk_list[0]
                extras_search += f', "{chk_list.property("columnname")}":"{chk_list.isChecked()}"'
            extras_search_add += f'"{line_edit.property("columnname")}":{{"text":"{value}"}}'
            body = tools_gw.create_body(form=form_search, extras=extras_search)
            result = tools_gw.execute_procedure('gw_fct_setsearch', body, rubber_band=self.rubber_band)
            if not result or result['status'] == 'Failed':
                return False

            if result:
                self.result_data = result

        # Set label visible
        display_list = []
        if result:
            if self.result_data['data'] == {} and self.lbl_visible:
                self.dlg_search.lbl_msg.setVisible(True)
                if len(line_list) == 2:
                    widget_add = line_list[1]
                    widget_add.setReadOnly(True)
                    widget_add.setStyleSheet("QLineEdit { background: rgb(242, 242, 242); color: rgb(100, 100, 100)}")
            else:
                self.lbl_visible = True
                self.dlg_search.lbl_msg.setVisible(False)

            # Get list of items from returned json from database and make a list for completer
            for data in self.result_data['data']:
                display_list.append(data['display_name'])
            tools_qt.set_completer_object(completer, model, widget, sorted(display_list))

        if len(line_list) == 2:
            line_edit_add = line_list[1]
            value = tools_qt.get_text(self.dlg_search, line_edit_add)
            if str(value) in display_list:
                if line_edit:
                    line_edit.setText(value)
                return
            if str(value) == 'null':
                return

            extras_search_add += f', "{line_edit_add.property("columnname")}":{{"text":"{value}"}}'
            body = tools_gw.create_body(form=form_search_add, extras=extras_search_add)
            result = tools_gw.execute_procedure('gw_fct_setsearchadd', body, rubber_band=self.rubber_band)
            if not result or result['status'] == 'Failed':
                return False

            self.result_data = result
            if result is not None:
                display_list = []
                for data in self.result_data['data']:
                    display_list.append(data['display_name'])
                tools_qt.set_completer_object(completer, model, line_edit_add, sorted(display_list))


    def _clear_line_edit_add(self, line_list):
        """ Clear second line edit if exist """

        line_edit_add = line_list[1]
        line_edit_add.blockSignals(True)
        line_edit_add.setText('')
        line_edit_add.blockSignals(False)


    def _add_combobox(self, field):

        widget = QComboBox()
        widget.setObjectName(field['widgetname'])
        widget.setProperty('columnname', field['columnname'])
        tools_gw.fill_combo(widget, field)
        # noinspection PyUnresolvedReferences
        widget.currentIndexChanged.connect(partial(self._clear_lineedits))

        return widget


    def _clear_lineedits(self):

        # Clear all lineedit widgets from search tabs
        for widget in self.lineedit_list:
            tools_qt.set_widget_text(self.dlg_search, widget, '')

    def _open_hydrometer_dialog(self, table_name=None, feature_id=None, sys_feature_type_id=None,
                                basic_search_hydrometer=False, feature_type=None):

        if basic_search_hydrometer:
            self.customForm = GwInfo(tab_type='data')
            # feature_type (v_edit_connec or v_edit_node) is the exact view to see the details of the feature
            complet_result, dialog = self.customForm.get_info_from_id(
                feature_type, tab_type='data', feature_id=sys_feature_type_id, is_add_schema=False)

            if not complet_result:
                return
            tab_main = dialog.findChild(QTabWidget, "tab_main")
            tab_main.setCurrentIndex(3)
            self._select_row_by_feature_id(tab_main, feature_id)
        else:
            qgis_project_infotype = lib_vars.project_vars['info_type']

            feature = f'"tableName":"{table_name}", "id":"{feature_id}"'
            extras = f'"infoType":"{qgis_project_infotype}"'
            body = tools_gw.create_body(feature=feature, extras=extras)
            json_result = tools_gw.execute_procedure('gw_fct_getinfofromid', body)

            if json_result is None or json_result['status'] == 'Failed':
                return
            result = json_result

            self.hydro_info_dlg = GwInfoGenericUi(self)
            tools_gw.load_settings(self.hydro_info_dlg)

            self.hydro_info_dlg.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.hydro_info_dlg))
            self.hydro_info_dlg.dlg_closed.connect(partial(tools_gw.close_dialog, self.hydro_info_dlg))
            self.hydro_info_dlg.dlg_closed.connect(self._reset_rubber_band)
            tools_gw.build_dialog_info(self.hydro_info_dlg, result)
            tools_gw.open_dialog(self.hydro_info_dlg, dlg_name='info_generic')

    def _select_row_by_feature_id(self, tab_main, feature_id, column_index=0):
        # Get the index of the current tab
        current_tab_index = tab_main.currentIndex()
        current_tab = tab_main.widget(current_tab_index)

        # Find the first QTableView within the current tab
        tbl_hydro = current_tab.findChild(QTableView, "tab_hydrometer_tbl_hydrometer")

        if tbl_hydro:
            model = tbl_hydro.model()

            # Find items in the "hydrometer_customer_code" column that match the feature_id
            # Adjust according to the specific column
            matching_items = model.findItems(feature_id, Qt.MatchExactly, column_index)

            if matching_items:
                # Select the found row
                row = matching_items[0].row()
                tbl_hydro.selectRow(row)

    # endregion
