"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json
from functools import partial

from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtWidgets import QCheckBox, QGridLayout, QLabel, QLineEdit, QSizePolicy, QSpacerItem, QTabWidget,\
    QWidget, QApplication, QDockWidget, QToolButton, QAction, QScrollArea

from ..ui.ui_manager import GwSelectorUi
from ..utils import tools_gw
from ... import global_vars
from ...libs import lib_vars, tools_qgis, tools_qt, tools_os


class GwSelector:

    def __init__(self):
        self.checkall = False
        self.help_button = None
        self.scrolled_amount = 0


    def open_selector(self, selector_type="selector_basic", reload_dlg=None):
        """
        :param selector_type: This parameter must be a string between double quotes. Example: '"selector_basic"'
        """
        if reload_dlg:
            aux_params = None
            if selector_type == "selector_mincut":
                current_tab = tools_gw.get_config_parser('dialogs_tab', "dlg_selector_mincut", "user", "session")
                aux_params = tools_gw.get_config_parser("selector_mincut", f"aux_params", "user", "session")
            else:
                current_tab = tools_gw.get_config_parser('dialogs_tab', "dlg_selector_basic", "user", "session")
            reload_dlg.main_tab.clear()
            self.get_selector(reload_dlg, selector_type, current_tab=current_tab, aux_params=aux_params)
            if self.scrolled_amount:
                reload_dlg.main_tab.currentWidget().verticalScrollBar().setValue(self.scrolled_amount)
            return

        dlg_selector = GwSelectorUi(self)
        tools_gw.load_settings(dlg_selector)
        dlg_selector.setProperty('GwSelector', self)

        # Get the name of the last tab used by the user
        current_tab = tools_gw.get_config_parser('dialogs_tab', "dlg_selector_basic", "user", "session")
        self.get_selector(dlg_selector, selector_type, current_tab=current_tab)

        if lib_vars.session_vars['dialog_docker']:
            tools_gw.docker_dialog(dlg_selector)
            dlg_selector.btn_close.clicked.connect(partial(tools_gw.close_docker, option_name='position'))

            # Set shortcut keys
            dlg_selector.key_escape.connect(partial(tools_gw.close_docker))

        else:
            dlg_selector.rejected.connect(partial(tools_gw.save_settings, dlg_selector))
            tools_gw.open_dialog(dlg_selector, dlg_name='selector')

            # Set shortcut keys
            dlg_selector.key_escape.connect(partial(tools_gw.close_dialog, dlg_selector))

        dlg_selector.btn_close.clicked.connect(partial(self._selector_close, dlg_selector))

        # Manage tab focus
        dlg_selector.findChild(QTabWidget, 'main_tab').currentChanged.connect(partial(self._set_focus, dlg_selector))
        # Save the name of current tab used by the user
        dlg_selector.findChild(QTabWidget, 'main_tab').currentChanged.connect(partial(
            tools_gw.save_current_tab, dlg_selector, dlg_selector.main_tab, 'basic'))

        # Set typeahead focus if configured
        self._set_focus(dlg_selector)


    def _selector_close(self, dialog):

        if lib_vars.session_vars['dialog_docker'] and lib_vars.session_vars['dialog_docker'].isFloating():
            widget = lib_vars.session_vars['dialog_docker'].widget()
            if widget:
                widget.close()
                del widget
                global_vars.iface.removeDockWidget(lib_vars.session_vars['dialog_docker'])
                lib_vars.session_vars['docker_type'] = None
        else:
            tools_gw.close_dialog(dialog)


    def _set_focus(self, dialog):
        """ Sets the focus to the typeahead filter if it's configured in DB """

        index = dialog.main_tab.currentIndex()
        tab = dialog.main_tab.widget(index)
        if tab and tools_os.set_boolean(tab.property('typeahead_forced'), False):
            tab_name = dialog.main_tab.widget(index).objectName()
            widget = dialog.main_tab.widget(index).findChild(QLineEdit, f"txt_filter_{str(tab_name)}")
            if widget:
                widget.setFocus()


    def get_selector(self, dialog, selector_type, filter=False, widget=None, text_filter=None, current_tab=None, aux_params=None):
        """
        Ask to DB for selectors and make dialog
            :param dialog: Is a standard dialog, from file selector.ui, where put widgets
            :param selector_type: List of selectors to ask DB ['exploitation', 'state', ...]
        """

        index = 0
        main_tab = dialog.findChild(QTabWidget, 'main_tab')

        # Set filter
        if filter is not False:
            main_tab = dialog.findChild(QTabWidget, 'main_tab')
            text_filter = tools_qt.get_text(dialog, widget)
            if text_filter in ('null', None):
                text_filter = ''

            # Set current_tab
            index = dialog.main_tab.currentIndex()
            current_tab = dialog.main_tab.widget(index).objectName()

        # Profilactic control of nones
        if text_filter is None:
            text_filter = ''
        if '"' in selector_type:
            selector_type = selector_type.strip('"')
        # Built querytext
        form = f'"currentTab":"{current_tab}"'
        extras = f'"selectorType":"{selector_type}", "filterText":"{text_filter}"'
        if aux_params:
            tools_gw.set_config_parser("selector_mincut", f"aux_params", f"{aux_params}", "user", "session")
            extras = f"{extras}, {aux_params}"
        extras += f', "addSchema":"{lib_vars.project_vars["add_schema"]}"'
        body = tools_gw.create_body(form=form, extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_getselectors', body)


        if not json_result or json_result['status'] == 'Failed':
            return False

        # Get styles
        stylesheet = json_result['body']['form'].get('style')
        color_rows = False
        if stylesheet:
            # Color selectors zebra-styled
            color_rows = tools_os.set_boolean(stylesheet.get('rowsColor'), False)

        selection_modes = {}
        for form_tab in json_result['body']['form']['formTabs']:

            tab_name = form_tab['tabName']
            if filter and tab_name != str(current_tab):
                continue

            selection_mode = form_tab['selectionMode']
            selection_modes[tab_name] = selection_mode

            # Create one tab for each form_tab and add to QTabWidget
            scroll_area = QScrollArea(main_tab)
            scroll_area.setObjectName(tab_name)
            scroll_area.setProperty('selector_type', form_tab['selectorType'])
            scroll_area.viewport().setStyleSheet("background-color: white;")
            tab_widget = QWidget()
            tab_widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.MinimumExpanding)
            if filter:
                main_tab.removeTab(index)
                main_tab.insertTab(index, scroll_area, form_tab['tabLabel'])
            else:
                main_tab.addTab(scroll_area, form_tab['tabLabel'])

            scroll_area.setWidgetResizable(True)  # Allow scroll area to resize its widget
            scroll_area.setWidget(tab_widget)

            typeaheadForced = form_tab.get('typeaheadForced')
            if typeaheadForced is not None:
                tab_widget.setProperty('typeahead_forced', typeaheadForced)

            # Create a new QGridLayout and put it into tab
            gridlayout = QGridLayout()
            gridlayout.setObjectName("lyt" + tab_name)
            tab_widget.setLayout(gridlayout)
            field = {}
            i = 0

            if 'typeaheadFilter' in form_tab:
                label = QLabel()
                label.setObjectName('lbl_filter')
                label.setText('Filter:')
                if tools_qt.get_widget(dialog, 'txt_filter_' + str(tab_name)) is None:
                    widget = QLineEdit()
                    widget.setObjectName('txt_filter_' + str(tab_name))
                    widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
                    widget.textChanged.connect(partial(self.get_selector, dialog, selector_type, filter=True,
                                                       widget=widget, current_tab=current_tab))
                    widget.setLayoutDirection(Qt.RightToLeft)

                else:
                    widget = tools_qt.get_widget(dialog, 'txt_filter_' + str(tab_name))

                field['layoutname'] = gridlayout.objectName()
                field['layoutorder'] = i
                i = i + 1
                gridlayout.addWidget(label, int(field['layoutorder']), 0)
                gridlayout.addWidget(widget, int(field['layoutorder']), 2)
                widget.setFocus()

            if 'manageAll' in form_tab and (form_tab['manageAll']).lower() == 'true':
                # Check check_all if all selectors are checked
                self.checkall = True
                for field in form_tab['fields']:
                    if not tools_os.set_boolean(field.get('value'), default=False):
                        self.checkall = False

                if tools_qt.get_widget(dialog, f"chk_all_{tab_name}") is None:
                    widget = QCheckBox()
                    widget.setObjectName('chk_all_' + str(tab_name))
                    widget.toggled.connect(partial(self._manage_all, dialog, widget))
                    widget.setLayoutDirection(Qt.LeftToRight)
                    chk_all_tooltip = "Shift+Click to uncheck all"
                    widget.setToolTip(chk_all_tooltip)
                else:
                    widget = tools_qt.get_widget(dialog, f"chk_all_{tab_name}")
                widget.setText('Check all')
                if self.checkall is not None:
                    widget.blockSignals(True)
                    widget.setChecked(self.checkall)
                    widget.blockSignals(False)
                field['layoutname'] = gridlayout.objectName()
                field['layoutorder'] = i
                i = i + 1
                gridlayout.addWidget(widget, int(field['layoutorder']), 0, 1, -1)

            for order, field in enumerate(form_tab['fields']):
                try:
                    # Create checkbox
                    kwargs = {'field': field, 'connectsignal': False}
                    widget = tools_gw.add_checkbox(**kwargs)
                    widget.setText(field['label'])
                    widget.stateChanged.connect(partial(self._set_selection_mode, dialog, widget, selection_mode))
                    widget.setLayoutDirection(Qt.LeftToRight)

                    # Set background color every other item (if enabled)
                    if color_rows and order % 2 == 0:
                        widget.setStyleSheet(f"background-color: #E9E7E3")

                    # Add widget to layout
                    field['layoutname'] = gridlayout.objectName()
                    field['layoutorder'] = order + i + 1
                    gridlayout.addWidget(widget, int(field['layoutorder']), 0, 1, -1)
                except Exception:
                    msg = f"key 'comboIds' or/and comboNames not found WHERE columname='{field['columnname']}' AND " \
                          f"widgetname='{field['widgetname']}'"
                    tools_qgis.show_message(msg, 2)

            vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
            gridlayout.addItem(vertical_spacer1)

        # Add help button
        if self.help_button is None:
            self.help_button = QToolButton(None)
            style = "border: none;"
            tools_qt.set_stylesheet(self.help_button, style)
            help_icon = tools_gw.add_icon(self.help_button, '73', sub_folder='24x24')
            action = QAction(help_icon, "Help")
            action.triggered.connect(partial(self._show_help, dialog, selection_modes))
            self.help_button.setDefaultAction(action)
            main_tab.setCornerWidget(self.help_button)
        else:
            main_tab.cornerWidget().setHidden(False)

        # Set last tab used by user as current tab
        tabname = json_result['body']['form']['currentTab']
        tab = main_tab.findChild(QWidget, tabname)

        if tab:
            main_tab.setCurrentWidget(tab)

    # region private functions

    def _show_help(self, dialog, selection_modes):
        """
        Show help dialog depending on current tab's selection mode
            :param dialog:
        """
        index = dialog.main_tab.currentIndex()
        tab_name = dialog.main_tab.widget(index).objectName()
        selection_mode = selection_modes[tab_name]

        msg = "Clicking an item will check/uncheck it. "
        if selection_mode == 'keepPrevious':
            msg += "Checking any item will not uncheck any other item.\n"
        elif selection_mode == 'keepPreviousUsingShift':
            msg += "Checking any item will uncheck all other items unless Shift is pressed.\n"
        elif selection_mode == 'removePrevious':
            msg += "Checking any item will uncheck all other items.\n"
        msg += f"This behaviour can be configured in the table 'config_param_system' (parameter = 'basic_selector_{tab_name}')."
        tools_qt.show_info_box(msg, "Selector help")


    def _set_selection_mode(self, dialog, widget, selection_mode):
        """
        Manage selection mode
            :param dialog: QDialog where search all checkbox
            :param widget: QCheckBox that has changed status (QCheckBox)
            :param selection_mode: "keepPrevious", "keepPreviousUsingShift", "removePrevious" (String)
        """

        # Get QCheckBox check all
        index = dialog.main_tab.currentIndex()
        widget_list = dialog.main_tab.widget(index).findChildren(QCheckBox)
        tab_name = dialog.main_tab.widget(index).objectName()
        widget_all = dialog.findChild(QCheckBox, f'chk_all_{tab_name}')

        is_alone = False
        disable_parent = False
        key_modifier = QApplication.keyboardModifiers()

        if key_modifier == Qt.ShiftModifier:
            disable_parent = True

        if selection_mode == 'removePrevious' or \
                (selection_mode == 'keepPreviousUsingShift' and key_modifier != Qt.ShiftModifier):
            is_alone = True
            if widget_all is not None:
                widget_all.blockSignals(True)
                tools_qt.set_checked(dialog, widget_all, False)
                widget_all.blockSignals(False)
            self._remove_previuos(dialog, widget, widget_all, widget_list)

        self._set_selector(dialog, widget, is_alone, disable_parent)


    def _set_selector(self, dialog, widget, is_alone, disable_parent, check_all_override=None):
        """
        Send values to DB and reload selectors
            :param dialog: QDialog
            :param widget: QCheckBox that contains the information to generate the json (QCheckBox)
            :param is_alone: Defines if the selector is unique (True) or multiple (False) (Boolean)
        """

        # Get current tab name
        index = dialog.main_tab.currentIndex()
        tab_name = dialog.main_tab.widget(index).objectName()
        selector_type = dialog.main_tab.widget(index).property("selector_type")
        qgis_project_add_schema = lib_vars.project_vars['add_schema']
        widget_all = dialog.findChild(QCheckBox, f'chk_all_{tab_name}')

        if widget_all is None or (widget_all is not None and widget.objectName() != widget_all.objectName()):
            extras = (f'"selectorType":"{selector_type}", "tabName":"{tab_name}", "id":"{widget.objectName()}", '
                      f'"isAlone":"{is_alone}", "disableParent":"{disable_parent}", '
                      f'"value":"{tools_qt.is_checked(dialog, widget)}", '
                      f'"addSchema":"{qgis_project_add_schema}"')
        else:
            check_all = tools_qt.is_checked(dialog, widget_all)
            if check_all_override is not None:
                check_all = check_all_override
            extras = (f'"selectorType":"{selector_type}", "tabName":"{tab_name}", "checkAll":"{check_all}", '
                      f'"addSchema":"{qgis_project_add_schema}"')

        body = tools_gw.create_body(extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_setselectors', body)
        if json_result is None or json_result['status'] == 'Failed':
            return
        level = json_result['body']['message']['level']
        if level == 0:
            message = json_result['body']['message']['text']
            tools_qgis.show_message(message, level)

        # Apply zoom only to the selected tabs
        if tab_name in ('tab_exploitation', 'tab_exploitation_add', 'tab_municipality', 'tab_sector'):
            try:
                # Zoom to feature
                x1 = json_result['body']['data']['geometry']['x1']
                y1 = json_result['body']['data']['geometry']['y1']
                x2 = json_result['body']['data']['geometry']['x2']
                y2 = json_result['body']['data']['geometry']['y2']
                if x1 is not None:
                    tools_qgis.zoom_to_rectangle(x1, y1, x2, y2, margin=0)
            except KeyError:
                pass

        # Refresh canvas
        tools_qgis.set_layer_index('v_edit_arc')
        tools_qgis.set_layer_index('v_edit_node')
        tools_qgis.set_layer_index('v_edit_connec')
        tools_qgis.set_layer_index('v_edit_gully')
        tools_qgis.set_layer_index('v_edit_link')
        tools_qgis.set_layer_index('v_edit_plan_psector')
        tools_qgis.refresh_map_canvas()

        # Refresh raster layer
        layer = tools_qgis.get_layer_by_tablename('v_ext_raster_dem', schema_name='')
        if layer:
            layer.dataProvider().reloadData()
            layer.triggerRepaint()
            canvas_extent = global_vars.iface.mapCanvas().extent()
            layer.setExtent(canvas_extent)
            global_vars.iface.mapCanvas().refresh()

        self.scrolled_amount = dialog.main_tab.currentWidget().verticalScrollBar().value()
        # Reload selectors dlg
        self.open_selector(selector_type, reload_dlg=dialog)

        # Update current_workspace label (status bar)
        tools_gw.manage_current_selections_docker(json_result)

        if tab_name == 'tab_exploitation':
            docker_search = global_vars.iface.mainWindow().findChild(QDockWidget, 'dlg_search')
            if docker_search:
                search_class = docker_search.property('class')
                search_class.refresh_tab()
        elif tab_name == 'tab_sector':
            """# TODO: Reload epa world filters if sector changed"""
            # tools_gw.set_epa_world(selector_change=True)

        widget_filter = tools_qt.get_widget(dialog, f"txt_filter_{tab_name}")
        if widget_filter and tools_qt.get_text(dialog, widget_filter, False, False) not in (None, ''):
            widget_filter.textChanged.emit(widget_filter.text())


    def _remove_previuos(self, dialog, widget, widget_all, widget_list):
        """
        Remove checks of not selected QCheckBox
            :param dialog: QDialog
            :param widget: QCheckBox that has changed status (QCheckBox)
            :param widget_all: QCheckBox that handles global selection (QCheckBox)
            :param widget_list: List of all QCheckBox in the current tab ([QCheckBox, QCheckBox, ...])
        """

        for checkbox in widget_list:
            # Some selectors.ui dont have widget_all
            if widget_all is not None:
                if checkbox == widget_all or checkbox.objectName() == widget_all.objectName():
                    continue
                elif checkbox.objectName() != widget.objectName():
                    checkbox.blockSignals(True)
                    tools_qt.set_checked(dialog, checkbox, False)
                    checkbox.blockSignals(False)

            elif checkbox.objectName() != widget.objectName():
                checkbox.blockSignals(True)
                tools_qt.set_checked(dialog, checkbox, False)
                checkbox.blockSignals(False)

    def _manage_all(self, dialog, widget_all):

        status = tools_qt.is_checked(dialog, widget_all)
        index = dialog.main_tab.currentIndex()
        widget_list = dialog.main_tab.widget(index).findChildren(QCheckBox)
        disable_parent = False
        key_modifier = QApplication.keyboardModifiers()
        override = None

        if key_modifier == Qt.ShiftModifier:
            status = False
            override = False

        for widget in widget_list:
            if widget_all is not None:
                if widget == widget_all or widget.objectName() == widget_all.objectName():
                    continue
            widget.blockSignals(True)
            tools_qt.set_checked(dialog, widget, status)
            widget.blockSignals(False)

        self._set_selector(dialog, widget_all, False, disable_parent, check_all_override=override)

    # endregion