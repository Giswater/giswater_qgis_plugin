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
    QWidget, QApplication

from ..ui.ui_manager import GwSelectorUi
from ..utils import tools_gw
from ... import global_vars
from ...lib import tools_qgis, tools_qt, tools_os, tools_db


class GwSelector:

    def __init__(self):
        pass


    def open_selector(self, selector_type='"selector_basic"', reload_dlg=None):
        """
        :param selector_type: This parameter must be a string between double quotes. Example: '"selector_basic"'
        """

        if reload_dlg:
            current_tab = tools_gw.get_config_parser('dialogs_tab', "dlg_selector_basic", "user", "session")
            reload_dlg.main_tab.clear()
            self.get_selector(reload_dlg, selector_type, current_tab=current_tab)
            return

        dlg_selector = GwSelectorUi()
        tools_gw.load_settings(dlg_selector)
        dlg_selector.setProperty('GwSelector', self)

        # Get the name of the last tab used by the user
        current_tab = tools_gw.get_config_parser('dialogs_tab', "dlg_selector_basic", "user", "session")
        self.get_selector(dlg_selector, selector_type, current_tab=current_tab)

        if global_vars.session_vars['dialog_docker']:
            tools_gw.docker_dialog(dlg_selector)
            dlg_selector.btn_close.clicked.connect(partial(tools_gw.close_docker, option_name='position'))

            # Set shortcut keys
            dlg_selector.key_escape.connect(partial(tools_gw.close_docker))

        else:
            dlg_selector.btn_close.clicked.connect(partial(tools_gw.close_dialog, dlg_selector))
            dlg_selector.rejected.connect(partial(tools_gw.save_settings, dlg_selector))
            tools_gw.open_dialog(dlg_selector, dlg_name='selector')

            # Set shortcut keys
            dlg_selector.key_escape.connect(partial(tools_gw.close_dialog, dlg_selector))

        dlg_selector.findChild(QTabWidget, 'main_tab').currentChanged.connect(partial(self._set_focus, dlg_selector))
        # Save the name of current tab used by the user
        dlg_selector.findChild(QTabWidget, 'main_tab').currentChanged.connect(partial(
            tools_gw.save_current_tab, dlg_selector, dlg_selector.main_tab, 'basic'))

        # Set typeahead focus if configured
        self._set_focus(dlg_selector)


    def _set_focus(self, dialog):
        """ Sets the focus to the typeahead filter if it's configured in DB """

        index = dialog.main_tab.currentIndex()
        tab = dialog.main_tab.widget(index)
        if tab and tools_os.set_boolean(tab.property('typeahead_forced'), False):
            tab_name = dialog.main_tab.widget(index).objectName()
            widget = dialog.main_tab.widget(index).findChild(QLineEdit, f"txt_filter_{str(tab_name)}")
            if widget:
                widget.setFocus()


    def get_selector(self, dialog, selector_type, filter=False, widget=None, text_filter=None, current_tab=None):
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
        # Built querytext
        form = f'"currentTab":"{current_tab}"'
        extras = f'"selectorType":{selector_type}, "filterText":"{text_filter}"'
        body = tools_gw.create_body(form=form, extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_getselectors', body)


        if not json_result or json_result['status'] == 'Failed':
            return False

        # Get styles
        stylesheet = json_result['body']['form']['style'] if 'style' in json_result['body']['form'] else None
        color_rows = False
        if stylesheet:
            # Color selectors zebra-styled
            if 'rowsColor' in stylesheet and stylesheet['rowsColor'] is not None:
                color_rows = tools_os.set_boolean(stylesheet['rowsColor'], False)

        for form_tab in json_result['body']['form']['formTabs']:

            if filter and form_tab['tabName'] != str(current_tab):
                continue

            selection_mode = form_tab['selectionMode']

            # Create one tab for each form_tab and add to QTabWidget
            tab_widget = QWidget(main_tab)
            tab_widget.setObjectName(form_tab['tabName'])
            tab_widget.setProperty('selector_type', form_tab['selectorType'])
            if filter:
                main_tab.removeTab(index)
                main_tab.insertTab(index, tab_widget, form_tab['tabLabel'])
            else:
                main_tab.addTab(tab_widget, form_tab['tabLabel'])
            if 'typeaheadForced' in form_tab and form_tab['typeaheadForced'] is not None:
                tab_widget.setProperty('typeahead_forced', form_tab['typeaheadForced'])

            # Create a new QGridLayout and put it into tab
            gridlayout = QGridLayout()
            gridlayout.setObjectName("lyt" + form_tab['tabName'])
            tab_widget.setLayout(gridlayout)
            field = {}
            i = 0

            if 'typeaheadFilter' in form_tab:
                label = QLabel()
                label.setObjectName('lbl_filter')
                label.setText('Filter:')
                if tools_qt.get_widget(dialog, 'txt_filter_' + str(form_tab['tabName'])) is None:
                    widget = QLineEdit()
                    widget.setObjectName('txt_filter_' + str(form_tab['tabName']))
                    widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
                    widget.textChanged.connect(partial(self.get_selector, dialog, selector_type, filter=True,
                                                       widget=widget, current_tab=current_tab))
                    widget.setLayoutDirection(Qt.RightToLeft)

                else:
                    widget = tools_qt.get_widget(dialog, 'txt_filter_' + str(form_tab['tabName']))

                field['layoutname'] = gridlayout.objectName()
                field['layoutorder'] = i
                i = i + 1
                gridlayout.addWidget(label, int(field['layoutorder']), 0)
                gridlayout.addWidget(widget, int(field['layoutorder']), 2)
                widget.setFocus()

            if 'manageAll' in form_tab:
                if (form_tab['manageAll']).lower() == 'true':
                    if tools_qt.get_widget(dialog, f"chk_all_{form_tab['tabName']}") is None:
                        widget = QCheckBox()
                        widget.setObjectName('chk_all_' + str(form_tab['tabName']))
                        widget.stateChanged.connect(partial(self._manage_all, dialog, widget))
                        widget.setLayoutDirection(Qt.LeftToRight)
                    else:
                        widget = tools_qt.get_widget(dialog, f"chk_all_{form_tab['tabName']}")
                    widget.setText('Check all')
                    field['layoutname'] = gridlayout.objectName()
                    field['layoutorder'] = i
                    i = i + 1
                    gridlayout.addWidget(widget, int(field['layoutorder']), 0, 1, -1)

            for order, field in enumerate(form_tab['fields']):
                try:
                    # Create checkbox
                    widget = tools_gw.add_checkbox(field)
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

        # Set last tab used by user as current tab
        tabname = json_result['body']['form']['currentTab']
        tab = main_tab.findChild(QWidget, tabname)

        if tab:
            main_tab.setCurrentWidget(tab)

    # region private functions

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


    def _set_selector(self, dialog, widget, is_alone, disable_parent):
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
        qgis_project_add_schema = global_vars.project_vars['add_schema']
        widget_all = dialog.findChild(QCheckBox, f'chk_all_{tab_name}')

        if widget_all is None or (widget_all is not None and widget.objectName() != widget_all.objectName()):
            extras = (f'"selectorType":"{selector_type}", "tabName":"{tab_name}", "id":"{widget.objectName()}", '
                      f'"isAlone":"{is_alone}", "disableParent":"{disable_parent}", '
                      f'"value":"{tools_qt.is_checked(dialog, widget)}", '
                      f'"addSchema":"{qgis_project_add_schema}"')
        else:
            check_all = tools_qt.is_checked(dialog, widget_all)
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

        # Reload selectors dlg
        self.open_selector(reload_dlg=dialog)

        # Update current_workspace label (status bar)
        tools_gw.manage_current_selections_docker(json_result)

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

        if key_modifier == Qt.ShiftModifier:
            disable_parent = True

        for widget in widget_list:
            if widget_all is not None:
                if widget == widget_all or widget.objectName() == widget_all.objectName():
                    continue
            widget.blockSignals(True)
            tools_qt.set_checked(dialog, widget, status)
            widget.blockSignals(False)

        self._set_selector(dialog, widget_all, False, disable_parent)

    # endregion