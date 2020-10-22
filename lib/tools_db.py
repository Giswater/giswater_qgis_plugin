"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QTabWidget
from qgis.PyQt.QtWidgets import QWidget, QGridLayout, QLabel, QLineEdit, QSizePolicy, QCheckBox, QSpacerItem, \
    QApplication
from qgis.PyQt.QtCore import Qt

from functools import partial

from .. import global_vars
from . import tools_qt
from .tools_qgis import zoom_to_rectangle
from ..core.utils import tools_giswater


def get_visible_layers(as_list=False):
    """ Return string as {...} or [...] with name of table in DB of all visible layer in TOC """

    visible_layer = '{'
    if as_list is True:
        visible_layer = '['
    layers = global_vars.controller.get_layers()
    for layer in layers:
        if global_vars.controller.is_layer_visible(layer):
            table_name = global_vars.controller.get_layer_source_table_name(layer)
            table = layer.dataProvider().dataSourceUri()
            # TODO:: Find differences between PostgreSQL and query layers, and replace this if condition.
            if 'SELECT row_number() over ()' in str(table) or 'srid' not in str(table):
                continue

            visible_layer += f'"{table_name}", '
    visible_layer = visible_layer[:-2]

    if as_list is True:
        visible_layer += ']'
    else:
        visible_layer += '}'
    return visible_layer


def get_editable_layers():
    """ Return string as {...}  with name of table in DB of all editable layer in TOC """

    editable_layer = '{'
    layers = global_vars.controller.get_layers()
    for layer in layers:
        if not layer.isReadOnly():
            table_name = global_vars.controller.get_layer_source_table_name(layer)
            editable_layer += f'"{table_name}", '
    editable_layer = editable_layer[:-2] + "}"
    return editable_layer


def get_selector(dialog, selector_type, filter=False, widget=None, text_filter=None, current_tab=None,
                 is_setselector=None, selector_vars={}):
    """ Ask to DB for selectors and make dialog
    :param dialog: Is a standard dialog, from file api_selectors.ui, where put widgets
    :param selector_type: list of selectors to ask DB ['exploitation', 'state', ...]
    """

    index = 0
    main_tab = dialog.findChild(QTabWidget, 'main_tab')

    # Set filter
    if filter is not False:
        main_tab = dialog.findChild(QTabWidget, 'main_tab')
        text_filter = tools_qt.getWidgetText(dialog, widget)
        if text_filter in ('null', None):
            text_filter = ''

        # Set current_tab
        index = dialog.main_tab.currentIndex()
        current_tab = dialog.main_tab.widget(index).objectName()

    # Profilactic control of nones
    if text_filter is None:
        text_filter = ''
    if is_setselector is None:
        # Built querytext
        form = f'"currentTab":"{current_tab}"'
        extras = f'"selectorType":{selector_type}, "filterText":"{text_filter}"'
        body = tools_giswater.create_body(form=form, extras=extras)
        json_result = global_vars.controller.get_json('gw_fct_getselectors', body)
    else:
        json_result = is_setselector
        for x in range(dialog.main_tab.count() - 1, -1, -1):
            dialog.main_tab.widget(x).deleteLater()

    if not json_result or json_result['status'] == 'Failed':
        return False

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

        # Create a new QGridLayout and put it into tab
        gridlayout = QGridLayout()
        gridlayout.setObjectName("grl_" + form_tab['tabName'])
        tab_widget.setLayout(gridlayout)
        field = {}
        i = 0

        if 'typeaheadFilter' in form_tab:
            label = QLabel()
            label.setObjectName('lbl_filter')
            label.setText('Filter:')
            if tools_qt.getWidget(dialog, 'txt_filter_' + str(form_tab['tabName'])) is None:
                widget = QLineEdit()
                widget.setObjectName('txt_filter_' + str(form_tab['tabName']))
                widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
                selector_vars[f"var_txt_filter_{form_tab['tabName']}"] = ''
                widget.textChanged.connect(partial(get_selector, dialog, selector_type, filter=True,
                                                   widget=widget, current_tab=current_tab, selector_vars=selector_vars))
                widget.textChanged.connect(partial(manage_filter, dialog, widget, 'save', selector_vars))
                widget.setLayoutDirection(Qt.RightToLeft)

            else:
                widget = tools_qt.getWidget(dialog, 'txt_filter_' + str(form_tab['tabName']))

            field['layoutname'] = gridlayout.objectName()
            field['layoutorder'] = i
            i = i + 1
            tools_qt.put_widgets(dialog, field, label, widget)
            widget.setFocus()

        if 'manageAll' in form_tab:
            if (form_tab['manageAll']).lower() == 'true':
                if tools_qt.getWidget(dialog, f"lbl_manage_all_{form_tab['tabName']}") is None:
                    label = QLabel()
                    label.setObjectName(f"lbl_manage_all_{form_tab['tabName']}")
                    label.setText('Check all')
                else:
                    label = tools_qt.getWidget(dialog, f"lbl_manage_all_{form_tab['tabName']}")

                if tools_qt.getWidget(dialog, f"chk_all_{form_tab['tabName']}") is None:
                    widget = QCheckBox()
                    widget.setObjectName('chk_all_' + str(form_tab['tabName']))
                    widget.stateChanged.connect(partial(tools_qt.manage_all, dialog, widget, selector_vars))
                    widget.setLayoutDirection(Qt.RightToLeft)

                else:
                    widget = tools_qt.getWidget(dialog, f"chk_all_{form_tab['tabName']}")
                field['layoutname'] = gridlayout.objectName()
                field['layoutorder'] = i
                i = i + 1
                chk_all = widget
                tools_qt.put_widgets(dialog, field, label, widget)

        for order, field in enumerate(form_tab['fields']):
            label = QLabel()
            label.setObjectName('lbl_' + field['label'])
            label.setText(field['label'])

            widget = tools_qt.add_checkbox(field)
            widget.stateChanged.connect(partial(set_selection_mode, dialog, widget, selection_mode, selector_vars))
            widget.setLayoutDirection(Qt.RightToLeft)

            field['layoutname'] = gridlayout.objectName()
            field['layoutorder'] = order + i
            tools_qt.put_widgets(dialog, field, label, widget)

        vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        gridlayout.addItem(vertical_spacer1)

    # Set last tab used by user as current tab
    tabname = json_result['body']['form']['currentTab']
    tab = main_tab.findChild(QWidget, tabname)

    if tab:
        main_tab.setCurrentWidget(tab)

    if is_setselector is not None:
        widget = dialog.main_tab.findChild(QLineEdit, f'txt_filter_{tabname}')
        if widget:
            widget.blockSignals(True)
            index = dialog.main_tab.currentIndex()
            tab_name = dialog.main_tab.widget(index).objectName()
            value = selector_vars[f"var_txt_filter_{tab_name}"]
            tools_qt.setWidgetText(dialog, widget, f'{value}')
            widget.blockSignals(False)


def set_selection_mode(dialog, widget, selection_mode, selector_vars):
    """ Manage selection mode
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
    key_modifier = QApplication.keyboardModifiers()

    if selection_mode == 'removePrevious' or \
            (selection_mode == 'keepPreviousUsingShift' and key_modifier != Qt.ShiftModifier):
        is_alone = True
        if widget_all is not None:
            widget_all.blockSignals(True)
            tools_qt.setChecked(dialog, widget_all, False)
            widget_all.blockSignals(False)
        remove_previuos(dialog, widget, widget_all, widget_list)

    set_selector(dialog, widget, is_alone, selector_vars)


def set_selector(dialog, widget, is_alone, selector_vars):
    """  Send values to DB and reload selectors
    :param dialog: QDialog
    :param widget: QCheckBox that contains the information to generate the json (QCheckBox)
    :param is_alone: Defines if the selector is unique (True) or multiple (False) (Boolean)
    """

    # Get current tab name
    index = dialog.main_tab.currentIndex()
    tab_name = dialog.main_tab.widget(index).objectName()
    selector_type = dialog.main_tab.widget(index).property("selector_type")
    qgis_project_add_schema = global_vars.controller.plugin_settings_value('gwAddSchema')
    widget_all = dialog.findChild(QCheckBox, f'chk_all_{tab_name}')

    if widget_all is None or (widget_all is not None and widget.objectName() != widget_all.objectName()):
        extras = (f'"selectorType":"{selector_type}", "tabName":"{tab_name}", '
                  f'"id":"{widget.objectName()}", "isAlone":"{is_alone}", "value":"{tools_qt.isChecked(dialog, widget)}", '
                  f'"addSchema":"{qgis_project_add_schema}"')
    else:
        check_all = tools_qt.isChecked(dialog, widget_all)
        extras = f'"selectorType":"{selector_type}", "tabName":"{tab_name}", "checkAll":"{check_all}",  ' \
            f'"addSchema":"{qgis_project_add_schema}"'

    body = tools_giswater.create_body(extras=extras)
    json_result = global_vars.controller.get_json('gw_fct_setselectors', body)
    if json_result['status'] == 'Failed': return
    if str(tab_name) == 'tab_exploitation':
        try:
            # Zoom to exploitation
            x1 = json_result['body']['data']['geometry']['x1']
            y1 = json_result['body']['data']['geometry']['y1']
            x2 = json_result['body']['data']['geometry']['x2']
            y2 = json_result['body']['data']['geometry']['y2']
            if x1 is not None:
                zoom_to_rectangle(x1, y1, x2, y2, margin=0)
        except KeyError:
            pass

    # Refresh canvas
    global_vars.controller.set_layer_index('v_edit_arc')
    global_vars.controller.set_layer_index('v_edit_node')
    global_vars.controller.set_layer_index('v_edit_connec')
    global_vars.controller.set_layer_index('v_edit_gully')
    global_vars.controller.set_layer_index('v_edit_link')
    global_vars.controller.set_layer_index('v_edit_plan_psector')

    get_selector(dialog, f'"{selector_type}"', is_setselector=json_result, selector_vars=selector_vars)

    widget_filter = tools_qt.getWidget(dialog, f"txt_filter_{tab_name}")
    if widget_filter and tools_qt.getWidgetText(dialog, widget_filter, False, False) not in (None, ''):
        widget_filter.textChanged.emit(widget_filter.text())


def remove_previuos(dialog, widget, widget_all, widget_list):
    """ Remove checks of not selected QCheckBox
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
                tools_qt.setChecked(dialog, checkbox, False)
                checkbox.blockSignals(False)

        elif checkbox.objectName() != widget.objectName():
            checkbox.blockSignals(True)
            tools_qt.setChecked(dialog, checkbox, False)
            checkbox.blockSignals(False)


def manage_filter(dialog, widget, action, selector_vars):
    index = dialog.main_tab.currentIndex()
    tab_name = dialog.main_tab.widget(index).objectName()
    if action == 'save':
        selector_vars[f"var_txt_filter_{tab_name}"] = tools_qt.getWidgetText(dialog, widget)
    else:
        selector_vars[f"var_txt_filter_{tab_name}"] = ''


def make_list_for_completer(sql):
    """ Prepare a list with the necessary items for the completer
    :param sql: Query to be executed, where will we get the list of items (string)
    :return list_items: List with the result of the query executed (List) ["item1","item2","..."]
    """

    rows = global_vars.controller.get_rows(sql)
    list_items = []
    if rows:
        for row in rows:
            list_items.append(str(row[0]))
    return list_items