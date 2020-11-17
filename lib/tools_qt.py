"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsExpression, QgsProject
from qgis.gui import QgsDateTimeEdit
from qgis.PyQt.QtCore import QDate, QDateTime, QSortFilterProxyModel, QStringListModel, QTime, Qt, QRegExp, pyqtSignal
from qgis.PyQt.QtGui import QPixmap, QDoubleValidator, QRegExpValidator, QStandardItemModel, \
    QStandardItem, QIcon
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QAction, QLineEdit, QComboBox, QWidget, QDoubleSpinBox, QCheckBox, QLabel, QTextEdit, QDateEdit, \
    QAbstractItemView, QCompleter, QDateTimeEdit, QTableView, QSpinBox, QTimeEdit, QPushButton, QPlainTextEdit, \
    QRadioButton, QSizePolicy, QSpacerItem, QFileDialog, QGroupBox

import os
import operator
import re
import sys
import subprocess
import webbrowser
from functools import partial

from .. import global_vars
from ..core.utils import tools_gw
from . import tools_qgis


class GwExtendedQLabel(QLabel):
    clicked = pyqtSignal()

    def __init(self, parent):
        QLabel.__init__(self, parent)

    def mouseReleaseEvent(self, ev):
        self.clicked.emit()


class GwHyperLinkLabel(QLabel):
    clicked = pyqtSignal()

    def __init__(self):
        QLabel.__init__(self)
        self.setStyleSheet("QLabel{color:blue; text-decoration: underline;}")

    def mouseReleaseEvent(self, ev):
        self.clicked.emit()
        self.setStyleSheet("QLabel{color:purple; text-decoration: underline;}")


def fillComboBox(dialog, widget, rows, allow_nulls=True, clear_combo=True):

    if rows is None:
        return
    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QComboBox, widget)
    if clear_combo:
        widget.clear()
    if allow_nulls:
        widget.addItem('')
    for row in rows:
        if len(row) > 1:
            elem = row[0]
            user_data = row[1]
        else:
            elem = row[0]
            user_data = None
        if elem is not None:
            try:
                if type(elem) is int or type(elem) is float:
                    widget.addItem(str(elem), user_data)
                else:
                    widget.addItem(elem, user_data)
            except:
                widget.addItem(str(elem), user_data)


def fillComboBoxList(dialog, widget, list_object, allow_nulls=True, clear_combo=True):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QComboBox, widget)
    if widget is None:
        return None

    if clear_combo:
        widget.clear()
    if allow_nulls:
        widget.addItem('')
    for elem in list_object:
        widget.addItem(str(elem))


def getCalendarDate(dialog, widget, date_format="yyyy/MM/dd", datetime_format="yyyy/MM/dd hh:mm:ss"):

    date = None
    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return
    if type(widget) is QDateEdit:
        date = widget.date().toString(date_format)
    elif type(widget) is QDateTimeEdit:
        date = widget.dateTime().toString(datetime_format)
    elif type(widget) is QgsDateTimeEdit and widget.displayFormat() in ('dd/MM/yyyy', 'yyyy/MM/dd'):
        date = widget.dateTime().toString(date_format)
    elif type(widget) is QgsDateTimeEdit and widget.displayFormat() in ('dd/MM/yyyy hh:mm:ss', 'yyyy/MM/dd hh:mm:ss'):
        date = widget.dateTime().toString(datetime_format)

    return date


def setCalendarDate(dialog, widget, date, default_current_date=True):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return
    if type(widget) is QDateEdit \
            or (type(widget) is QgsDateTimeEdit and widget.displayFormat() in ('dd/MM/yyyy', 'yyyy/MM/dd')):
        if date is None:
            if default_current_date:
                date = QDate.currentDate()
            else:
                date = QDate.fromString('01-01-2000', 'dd-MM-yyyy')
        widget.setDate(date)
    elif type(widget) is QDateTimeEdit \
            or (type(widget) is QgsDateTimeEdit and widget.displayFormat() in ('dd/MM/yyyy hh:mm:ss', 'yyyy/MM/dd hh:mm:ss')):
        if date is None:
            date = QDateTime.currentDateTime()
        widget.setDateTime(date)


def setTimeEdit(dialog, widget, time):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return
    if type(widget) is QTimeEdit:
        if time is None:
            time = QTime(00, 00, 00)
        widget.setTime(time)


def getWidget(dialog, widget):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return None
    return widget


def getWidgetType(dialog, widget):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return None
    return type(widget)


def getWidgetText(dialog, widget, add_quote=False, return_string_null=True):

    if type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    text = None
    if widget:
        if type(widget) in (QLineEdit, QPushButton, QLabel, GwHyperLinkLabel):
            text = widget.text()
        elif type(widget) in (QDoubleSpinBox, QSpinBox):
            text = widget.value()
        elif type(widget) in (QTextEdit, QPlainTextEdit):
            text = widget.toPlainText()
        elif type(widget) is QComboBox:
            text = widget.currentText()

        if not text and return_string_null:
            text = "null"
        elif not text:
            text = ""
        if add_quote and text != "null":
            text = "'" + text + "'"
    else:
        if return_string_null:
            text = "null"
        else:
            text = ""

    return text


def setWidgetText(dialog, widget, text):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return

    if type(widget) in (QLabel, QLineEdit, QTextEdit):
        if str(text) == 'None':
            text = ""
        widget.setText(f"{text}")
    elif type(widget) is QPlainTextEdit:
        if str(text) == 'None':
            text = ""
        widget.insertPlainText(f"{text}")
    elif type(widget) is QDoubleSpinBox or type(widget) is QSpinBox:
        if text == 'None' or text == 'null':
            text = 0
        widget.setValue(float(text))
    elif type(widget) is QComboBox:
        setSelectedItem(dialog, widget, text)
    elif type(widget) is QTimeEdit:
        setTimeEdit(dialog, widget, text)
    elif type(widget) is QCheckBox:
        setChecked(dialog, widget, text)


def isChecked(dialog, widget):

    if type(widget) is str:
        widget = dialog.findChild(QCheckBox, widget)
        if widget is None:
            widget = dialog.findChild(QRadioButton, widget)
    checked = False
    if widget:
        checked = widget.isChecked()
    return checked


def setChecked(dialog, widget, checked=True):

    if str(checked) in ('true', 't', 'True'):
        checked = True
    elif str(checked) in ('false', 'f', 'False'):
        checked = False

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return
    if type(widget) is QCheckBox or type(widget) is QRadioButton:
        widget.setChecked(bool(checked))


def getSelectedItem(dialog, widget, return_string_null=True):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QComboBox, widget)
    if return_string_null:
        widget_text = "null"
    else:
        widget_text = ""
    if widget:
        if widget.currentText():
            widget_text = widget.currentText()
    return widget_text


def setSelectedItem(dialog, widget, text):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QComboBox, widget)
    if widget:
        index = widget.findText(text)
        if index == -1:
            index = 0
        widget.setCurrentIndex(index)


def setCurrentIndex(dialog, widget, index):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QComboBox, widget)
    if widget:
        if index == -1:
            index = 0
        widget.setCurrentIndex(index)


def setWidgetVisible(dialog, widget, visible=True):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if widget:
        widget.setVisible(visible)


def setWidgetEnabled(dialog, widget, enabled=True):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if widget:
        widget.setEnabled(enabled)


def setImage(dialog, widget, cat_shape):
    """ Set pictures for UD"""

    element = cat_shape.lower()
    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return
    if type(widget) is QLabel:
        plugin_dir = os.path.dirname(__file__)
        pic_file = os.path.join(plugin_dir, f'resources{os.sep}png', '' + element + '')
        pixmap = QPixmap(pic_file)
        widget.setPixmap(pixmap)
        widget.show()


def set_autocompleter(combobox, list_items=None):
    """ Iterate over the items in the QCombobox, create a list,
        create the model, and set the model according to the list
    """

    if list_items is None:
        list_items = [combobox.itemText(i) for i in range(combobox.count())]
    proxy_model = QSortFilterProxyModel()
    set_model_by_list(list_items, combobox, proxy_model)
    combobox.editTextChanged.connect(partial(filter_by_list, combobox, proxy_model))


def filter_by_list(widget, proxy_model):
    """ Create the model """
    proxy_model.setFilterFixedString(widget.currentText())


def set_model_by_list(string_list, widget, proxy_model):
    """ Set the model according to the list """

    model = QStringListModel()
    model.setStringList(string_list)
    proxy_model.setSourceModel(model)
    proxy_model.setFilterKeyColumn(0)
    proxy_model_aux = QSortFilterProxyModel()
    proxy_model_aux.setSourceModel(model)
    proxy_model_aux.setFilterKeyColumn(0)
    widget.setModel(proxy_model_aux)
    widget.setModelColumn(0)
    completer = QCompleter()
    completer.setModel(proxy_model)
    completer.setCompletionColumn(0)
    completer.setCompletionMode(QCompleter.UnfilteredPopupCompletion)
    widget.setCompleter(completer)


def get_combo_value(dialog, widget, index=0, add_quote=False):
    """ Get item data of current index of the @widget """

    value = -1
    if add_quote:
        value = ''
    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if widget:
        if type(widget) is QComboBox:
            current_index = widget.currentIndex()
            elem = widget.itemData(current_index)
            if index == -1:
                return elem
            value = elem[index]

    return value


def set_combo_value(combo, value, item1):
    """ Set text to combobox populate with more than 1 item for row
        @item1: element to compare
        @item2: element to show
    """
    for i in range(0, combo.count()):
        elem = combo.itemData(i)
        if value == str(elem[item1]):
            combo.setCurrentIndex(i)
            return True
    return False


def fill_combo_values(combo, rows, index_to_show=0, combo_clear=True, sort_combo=True, sort_by=1, add_empty=False):
    """ Populate @combo with list @rows and show field @index_to_show
    :param sort_by: sort combo by this element (column)
    """

    records = []
    if rows is None:
        rows = [['', '']]

    if sort_by > len(rows[0]) - 1:
        sort_by = 1

    for row in rows:
        elem = []
        for x in range(0, len(row)):
            elem.append(row[x])
        records.append(elem)

    combo.blockSignals(True)
    if combo_clear:
        combo.clear()
    records_sorted = records

    try:
        if sort_combo:
            records_sorted = sorted(records, key=operator.itemgetter(sort_by))
    except:
        pass
    finally:
        if add_empty:
            records_sorted.insert(0, ['', ''])

        for record in records_sorted:
            combo.addItem(record[index_to_show], record)
            combo.blockSignals(False)


def set_combo_item_unselectable_by_id(qcombo, list_id=[]):
    """ Make items of QComboBox visibles but not selectable"""
    for x in range(0, qcombo.count()):
        if x in list_id:
            index = qcombo.model().index(x, 0)
            qcombo.model().setData(index, 0, Qt.UserRole - 1)


def set_combo_item_selectable_by_id(qcombo, list_id=[]):
    """ Make items of QComboBox selectable """
    for x in range(0, qcombo.count()):
        if x in list_id:
            index = qcombo.model().index(x, 0)
            qcombo.model().setData(index, (1 | 32), Qt.UserRole - 1)


def set_combo_item_select_unselectable(qcombo, list_id=[], column=0, opt=0):
    """ Make items of QComboBox visibles but not selectable
        :param qcombo: QComboBox widget to manage
        :param list_id: list of strings to manage ex. ['1','3','...'] or ['word1', 'word3','...']
        :param column: column where to look up the values in the list
        :param opt: 0 to set item not selectable
        :param opt: (1 | 32 ) to set item selectable
    """
    for x in range(0, qcombo.count()):
        elem = qcombo.itemData(x)
        if str(elem[column]) in list_id:
            index = qcombo.model().index(x, 0)
            qcombo.model().setData(index, opt, Qt.UserRole - 1)


def remove_tab_by_tabName(tab_widget, tab_name):
    """ Look in @tab_widget for a tab with @tab_name and remove it """

    for x in range(0, tab_widget.count()):
        if tab_widget.widget(x).objectName() == tab_name:
            tab_widget.removeTab(x)
            break


def enable_disable_tab_by_tabName(tab_widget, tab_name, action):
    """ Look in @tab_widget for a tab with @tab_name and remove it """

    for x in range(0, tab_widget.count()):
        if tab_widget.widget(x).objectName() == tab_name:
            tab_widget.setTabEnabled(x, action)
            break


def double_validator(widget, min_=-9999999, max_=9999999, decimals=2, notation=QDoubleValidator().StandardNotation):

    validator = QDoubleValidator(min_, max_, decimals)
    validator.setNotation(notation)
    widget.setValidator(validator)


def dis_enable_dialog(dialog, enable, ignore_widgets=['', None]):

    widget_list = dialog.findChildren(QWidget)
    for widget in widget_list:
        if str(widget.objectName()) not in ignore_widgets:
            if type(widget) in (QSpinBox, QDoubleSpinBox, QLineEdit):
                widget.setReadOnly(not enable)
                if enable:
                    widget.setStyleSheet(None)
                else:
                    widget.setStyleSheet("QWidget { background: rgb(242, 242, 242);"
                                         " color: rgb(100, 100, 100)}")
            elif type(widget) in (QComboBox, QCheckBox, QPushButton, QgsDateTimeEdit, QTableView):
                widget.setEnabled(enable)


def set_qtv_config(widget, selection=QAbstractItemView.SelectRows, edit_triggers=QTableView.NoEditTriggers):
    """ Set QTableView configurations """

    widget.setSelectionBehavior(selection)
    widget.setEditTriggers(edit_triggers)


def get_col_index_by_col_name(qtable, column_name):
    """ Return column index searching by column name """

    column_index = False
    for x in range(0, qtable.model().columnCount()):
        if qtable.model().headerData(x, Qt.Horizontal) == column_name:
            column_index = x
            break
    return column_index


def set_completer_object_api(completer, model, widget, list_items, max_visible=10):
    """ Set autocomplete of widget @table_object + "_id"
        getting id's from selected @table_object.
        WARNING: Each QLineEdit needs their own QCompleter and their own QStringListModel!!!
    """

    # Set completer and model: add autocomplete in the widget
    completer.setCaseSensitivity(Qt.CaseInsensitive)
    completer.setMaxVisibleItems(max_visible)
    widget.setCompleter(completer)
    completer.setCompletionMode(1)
    model.setStringList(list_items)
    completer.setModel(model)


def set_completer_object(dialog, table_object, field_object_id="id"):
    """ Set autocomplete of widget @table_object + "_id"
        getting id's from selected @table_object
    """

    widget = getWidget(dialog, table_object + "_id")
    if not widget:
        return

    # Set SQL
    if table_object == "element":
        field_object_id = table_object + "_id"
    sql = (f"SELECT DISTINCT({field_object_id})"
           f" FROM {table_object}"
           f" ORDER BY {field_object_id}")

    rows = global_vars.controller.get_rows(sql)
    if rows is None:
        return

    for i in range(0, len(rows)):
        aux = rows[i]
        rows[i] = str(aux[0])

    # Set completer and model: add autocomplete in the widget
    completer = QCompleter()
    completer.setCaseSensitivity(Qt.CaseInsensitive)
    widget.setCompleter(completer)
    model = QStringListModel()
    model.setStringList(rows)
    completer.setModel(model)


def set_completer_widget(tablename, widget, field_id):
    """ Set autocomplete of widget @table_object + "_id"
        getting id's from selected @table_object
    """

    if not widget:
        return

    # Set SQL
    sql = (f"SELECT DISTINCT({field_id})"
           f" FROM {tablename}"
           f" ORDER BY {field_id}")
    row = global_vars.controller.get_rows(sql)
    for i in range(0, len(row)):
        aux = row[i]
        row[i] = str(aux[0])

    # Set completer and model: add autocomplete in the widget
    completer = QCompleter()
    completer.setCaseSensitivity(Qt.CaseInsensitive)
    widget.setCompleter(completer)
    model = QStringListModel()
    model.setStringList(row)
    completer.setModel(model)


def check_actions(action, enabled, dialog=None):
    if type(action) is str:
        action = dialog.findChild(QAction, action)
    try:
        action.setChecked(enabled)
    except RuntimeError:
        pass


def set_headers(widget, field):

    standar_model = widget.model()
    if standar_model is None:
        standar_model = QStandardItemModel()
    # Related by Qtable
    widget.setModel(standar_model)
    widget.horizontalHeader().setStretchLastSection(True)

    # # Get headers
    headers = []
    for x in field['value'][0]:
        headers.append(x)
    # Set headers
    standar_model.setHorizontalHeaderLabels(headers)

    return widget


def populate_table(widget, field):

    standar_model = widget.model()
    for item in field['value']:
        row = []
        for value in item.values():
            row.append(QStandardItem(str(value)))
        if len(row) > 0:
            standar_model.appendRow(row)

    return widget


def set_columns_config(widget, table_name, sort_order=0, isQStandardItemModel=False):
    """ Configuration of tables. Set visibility and width of columns """

    # Set width and alias of visible columns
    columns_to_delete = []
    sql = (f"SELECT columnindex, width, alias, status FROM config_form_tableview"
           f" WHERE tablename = '{table_name}' ORDER BY columnindex")
    rows = global_vars.controller.get_rows(sql, log_info=True)
    if not rows:
        return widget

    for row in rows:
        if not row['status']:
            columns_to_delete.append(row['columnindex'] - 1)
        else:
            width = row['width']
            if width is None:
                width = 100
            widget.setColumnWidth(row['columnindex'] - 1, width)
            if row['alias'] is not None:
                widget.model().setHeaderData(row['columnindex'] - 1, Qt.Horizontal, row['alias'])

    # Set order
    if isQStandardItemModel:
        widget.model().sort(sort_order, Qt.AscendingOrder)
    else:
        widget.model().setSort(sort_order, Qt.AscendingOrder)
        widget.model().select()
    # Delete columns
    for column in columns_to_delete:
        widget.hideColumn(column)

    return widget


def set_calendar_empty(widget):
    """ Set calendar empty when click inner button of QgsDateTimeEdit because aesthetically it looks better"""
    widget.setEmpty()


def add_horizontal_spacer():

    widget = QSpacerItem(10, 10, QSizePolicy.Expanding, QSizePolicy.Minimum)
    return widget


def add_verticalspacer():

    widget = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
    return widget


def check_expression_filter(expr_filter, log_info=False):
    """ Check if expression filter @expr is valid """

    if log_info:
        global_vars.controller.log_info(expr_filter)
    expr = QgsExpression(expr_filter)
    if expr.hasParserError():
        message = "Expression Error"
        global_vars.controller.log_warning(message, parameter=expr_filter)
        return False, expr

    return True, expr


def fill_table(widget, table_name, expr_filter=None, set_edit_strategy=QSqlTableModel.OnManualSubmit):
    """ Set a model with selected filter.
    Attach that model to selected table """

    if global_vars.schema_name not in table_name:
        table_name = global_vars.schema_name + "." + table_name

    # Set model
    model = QSqlTableModel(db=global_vars.controller.db)
    model.setTable(table_name)
    model.setEditStrategy(set_edit_strategy)
    model.setSort(0, 0)
    model.select()

    # Check for errors
    if model.lastError().isValid():
        tools_gw.show_warning(model.lastError().text())

    # Attach model to table view
    widget.setModel(model)
    if expr_filter:
        widget.model().setFilter(expr_filter)


def add_layer_to_toc(layer, group=None):
    """ If the function receives a group name, check if it exists or not and put the layer in this group
    :param layer: (QgsVectorLayer)
    :param group: Name of the group that will be created in the toc (string)
    """

    if group is None:
        QgsProject.instance().addMapLayer(layer)
    else:
        QgsProject.instance().addMapLayer(layer, False)
        root = QgsProject.instance().layerTreeRoot()
        my_group = root.findGroup(group)
        if my_group is None:
            my_group = root.insertGroup(0, group)
        my_group.insertLayer(0, layer)


def delete_records(dialog, table_object, query=False, geom_type=None, layers=None, ids=None, list_ids=None,
                   lazy_widget=None, lazy_init_function=None):
    """ Delete selected elements of the table """

    tools_qgis.disconnect_signal_selection_changed()
    geom_type = tools_gw.tab_feature_changed(dialog, table_object)
    if type(table_object) is str:
        widget_name = f"tbl_{table_object}_x_{geom_type}"
        widget = getWidget(dialog, widget_name)
        if not widget:
            message = "Widget not found"
            tools_gw.show_warning(message, parameter=widget_name)
            return
    elif type(table_object) is QTableView:
        widget = table_object
    else:
        msg = "Table_object is not a table name or QTableView"
        global_vars.controller.log_info(msg)
        return

    # Control when QTableView is void or has no model
    try:
        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
    except AttributeError:
        selected_list = []

    if len(selected_list) == 0:
        message = "Any record selected"
        global_vars.controller.show_info_box(message)
        return

    if query:
        full_list = widget.model()
        for x in range(0, full_list.rowCount()):
            ids.append(widget.model().record(x).value(f"{geom_type}_id"))
    else:
        ids = list_ids[geom_type]

    field_id = geom_type + "_id"

    del_id = []
    inf_text = ""
    list_id = ""
    for i in range(0, len(selected_list)):
        row = selected_list[i].row()
        id_feature = widget.model().record(row).value(field_id)
        inf_text += f"{id_feature}, "
        list_id += f"'{id_feature}', "
        del_id.append(id_feature)
    inf_text = inf_text[:-2]
    list_id = list_id[:-2]
    message = "Are you sure you want to delete these records?"
    title = "Delete records"
    answer = global_vars.controller.ask_question(message, title, inf_text)
    if answer:
        for el in del_id:
            ids.remove(el)
    else:
        return

    expr_filter = None
    expr = None
    if len(ids) > 0:

        # Set expression filter with features in the list
        expr_filter = f'"{field_id}" IN ('
        for i in range(len(ids)):
            expr_filter += f"'{ids[i]}', "
        expr_filter = expr_filter[:-2] + ")"

        # Check expression
        (is_valid, expr) = check_expression_filter(expr_filter)  # @UnusedVariable
        if not is_valid:
            return

    # Update model of the widget with selected expr_filter
    if query:
        delete_feature_at_plan(dialog, geom_type, list_id)
        reload_qtable(dialog, geom_type)
    else:
        reload_table(dialog, table_object, geom_type, expr_filter)
        set_lazy_init(table_object, lazy_widget=lazy_widget, lazy_init_function=lazy_init_function)

    # Select features with previous filter
    # Build a list of feature id's and select them
    tools_qgis.select_features_by_ids(geom_type, expr, layers=layers)

    if query:
        layers = tools_qgis.remove_selection(layers=layers)

    # Update list
    list_ids[geom_type] = ids
    tools_gw.enable_feature_type(dialog, table_object, ids=ids)
    tools_qgis.connect_signal_selection_changed(dialog, table_object, geom_type)

    return ids, layers, list_ids


def set_lazy_init(widget, lazy_widget=None, lazy_init_function=None):
    """Apply the init function related to the model. It's necessary
    a lazy init because model is changed everytime is loaded."""

    if lazy_widget is None:
        return
    if widget != lazy_widget:
        return
    lazy_init_function(lazy_widget)


def manage_close(dialog, table_object, cur_active_layer=None, excluded_layers=[], single_tool_mode=None, layers=None):
    """ Close dialog and disconnect snapping """

    if cur_active_layer:
        global_vars.iface.setActiveLayer(cur_active_layer)
    # some tools can work differently if standalone or integrated in
    # another tool
    if single_tool_mode is not None:
        layers = tools_qgis.remove_selection(single_tool_mode, layers=layers)
    else:
        layers = tools_qgis.remove_selection(True, layers=layers)

    reset_model(dialog, table_object, "arc")
    reset_model(dialog, table_object, "node")
    reset_model(dialog, table_object, "connec")
    reset_model(dialog, table_object, "element")
    if global_vars.project_type == 'ud':
        reset_model(dialog, table_object, "gully")
    tools_gw.close_dialog(dialog)
    tools_gw.hide_generic_layers(excluded_layers=excluded_layers)
    tools_qgis.disconnect_snapping()
    tools_qgis.disconnect_signal_selection_changed()

    return layers


def delete_feature_at_plan(dialog, geom_type, list_id):
    """ Delete features_id to table plan_@geom_type_x_psector"""

    value = getWidgetText(dialog, dialog.psector_id)
    sql = (f"DELETE FROM plan_psector_x_{geom_type} "
           f"WHERE {geom_type}_id IN ({list_id}) AND psector_id = '{value}'")
    global_vars.controller.execute_sql(sql)


def fill_table_object(widget, table_name, expr_filter=None):
    """ Set a model with selected filter. Attach that model to selected table """

    if global_vars.schema_name not in table_name:
        table_name = global_vars.schema_name + "." + table_name

    # Set model
    model = QSqlTableModel(db=global_vars.controller.db)
    model.setTable(table_name)
    model.setEditStrategy(QSqlTableModel.OnManualSubmit)
    model.sort(0, 1)
    if expr_filter:
        model.setFilter(expr_filter)
    model.select()

    # Check for errors
    if model.lastError().isValid():
        tools_gw.show_warning(model.lastError().text())

    # Attach model to table view
    widget.setModel(model)


def filter_by_id(dialog, widget_table, widget_txt, table_object):

    field_object_id = "id"
    if table_object == "element":
        field_object_id = table_object + "_id"
    object_id = getWidgetText(dialog, widget_txt)
    if object_id != 'null':
        expr = f"{field_object_id}::text ILIKE '%{object_id}%'"
        # Refresh model with selected filter
        widget_table.model().setFilter(expr)
        widget_table.model().select()
    else:
        fill_table_object(widget_table, global_vars.schema_name + "." + table_object)


def set_selectionbehavior(dialog):

    # Get objects of type: QTableView
    widget_list = dialog.findChildren(QTableView)
    for widget in widget_list:
        widget.setSelectionBehavior(QAbstractItemView.SelectRows)


def set_model_to_table(widget, table_name, expr_filter):
    """ Set a model with selected filter.
    Attach that model to selected table """

    if global_vars.schema_name not in table_name:
        table_name = global_vars.schema_name + "." + table_name

    # Set model
    model = QSqlTableModel(db=global_vars.controller.db)
    model.setTable(table_name)
    model.setEditStrategy(QSqlTableModel.OnManualSubmit)
    model.setFilter(expr_filter)
    model.select()

    # Check for errors
    if model.lastError().isValid():
        tools_gw.show_warning(model.lastError().text())

    # Attach model to table view
    if widget:
        widget.setModel(model)
    else:
        global_vars.controller.log_info("set_model_to_table: widget not found")


def get_folder_path(dialog, widget):
    """ Get folder path """

    # Check if selected folder exists. Set default value if necessary
    folder_path = getWidgetText(dialog, widget)
    if folder_path is None or folder_path == 'null' or not os.path.exists(folder_path):
        folder_path = os.path.expanduser("~")

    # Open dialog to select folder
    os.chdir(folder_path)
    file_dialog = QFileDialog()
    file_dialog.setFileMode(QFileDialog.Directory)
    message = "Select folder"
    folder_path = file_dialog.getExistingDirectory(
        parent=None, caption=tools_gw.tr(message), directory=folder_path)
    if folder_path:
        setWidgetText(dialog, widget, str(folder_path))


def set_icon(widget, icon):
    """ Set @icon to selected @widget """

    # Get icons folder
    icons_folder = os.path.join(global_vars.plugin_dir, f"icons{os.sep}shared")
    icon_path = os.path.join(icons_folder, str(icon) + ".png")
    if os.path.exists(icon_path):
        widget.setIcon(QIcon(icon_path))
    else:
        global_vars.controller.log_info("File not found", parameter=icon_path)


def set_table_columns(dialog, widget, table_name, sort_order=0, isQStandardItemModel=False, schema_name=None):
    """ Configuration of tables. Set visibility and width of columns """

    widget = getWidget(dialog, widget)
    if not widget:
        return

    if schema_name is not None:
        config_table = f"{schema_name}.config_form_tableview"
    else:
        config_table = f"config_form_tableview"

    # Set width and alias of visible columns
    columns_to_delete = []
    sql = (f"SELECT columnindex, width, alias, status"
           f" FROM {config_table}"
           f" WHERE tablename = '{table_name}'"
           f" ORDER BY columnindex")
    rows = global_vars.controller.get_rows(sql, log_info=False)
    if not rows:
        return

    for row in rows:
        if not row['status']:
            columns_to_delete.append(row['columnindex'] - 1)
        else:
            width = row['width']
            if width is None:
                width = 100
            widget.setColumnWidth(row['columnindex'] - 1, width)
            widget.model().setHeaderData(row['columnindex'] - 1, Qt.Horizontal, row['alias'])

    # Set order
    if isQStandardItemModel:
        widget.model().sort(0, sort_order)
    else:
        widget.model().setSort(0, sort_order)
        widget.model().select()
    # Delete columns
    for column in columns_to_delete:
        widget.hideColumn(column)

    return widget


def multi_rows_delete(widget, table_name, column_id):
    """ Delete selected elements of the table
    :param QTableView widget: origin
    :param table_name: table origin
    :param column_id: Refers to the id of the source table
    """

    # Get selected rows
    selected_list = widget.selectionModel().selectedRows()
    if len(selected_list) == 0:
        message = "Any record selected"
        tools_gw.show_warning(message)
        return

    inf_text = ""
    list_id = ""
    for i in range(0, len(selected_list)):
        row = selected_list[i].row()
        id_ = widget.model().record(row).value(str(column_id))
        inf_text += f"{id_}, "
        list_id += f"'{id_}', "
    inf_text = inf_text[:-2]
    list_id = list_id[:-2]
    message = "Are you sure you want to delete these records?"
    title = "Delete records"
    answer = global_vars.controller.ask_question(message, title, inf_text)
    if answer:
        sql = f"DELETE FROM {table_name}"
        sql += f" WHERE {column_id} IN ({list_id})"
        global_vars.controller.execute_sql(sql)
        widget.model().select()


def hide_void_groupbox(dialog):
    """ Rceives a dialog, searches it all the QGroupBox, looks 1 to 1 if the grb have widgets, if it does not have
     (if it is empty), hides the QGroupBox
    :param dialog: QDialog or QMainWindow
    :return:
    """

    grb_list = {}
    grbox_list = dialog.findChildren(QGroupBox)
    for grbox in grbox_list:

        widget_list = grbox.findChildren(QWidget)
        if len(widget_list) == 0:
            grb_list[grbox.objectName()] = 0
            grbox.setVisible(False)

    return grb_list


def set_completer_lineedit(qlineedit, list_items):
    """ Set a completer into a QLineEdit
    :param qlineedit: Object where to set the completer (QLineEdit)
    :param list_items: List of items to set into the completer (List)["item1","item2","..."]
    """

    completer = QCompleter()
    completer.setCaseSensitivity(Qt.CaseInsensitive)
    completer.setMaxVisibleItems(10)
    completer.setCompletionMode(0)
    completer.setFilterMode(Qt.MatchContains)
    completer.popup().setStyleSheet("color: black;")
    qlineedit.setCompleter(completer)
    model = QStringListModel()
    model.setStringList(list_items)
    completer.setModel(model)



def set_dates_from_to(widget_from, widget_to, table_name, field_from, field_to):

    sql = (f"SELECT MIN(LEAST({field_from}, {field_to})),"
           f" MAX(GREATEST({field_from}, {field_to}))"
           f" FROM {table_name}")
    row = global_vars.controller.get_row(sql, log_sql=False)
    current_date = QDate.currentDate()
    if row:
        if row[0]:
            widget_from.setDate(row[0])
        else:
            widget_from.setDate(current_date)
        if row[1]:
            widget_to.setDate(row[1])
        else:
            widget_to.setDate(current_date)


def integer_validator(value, widget, btn_accept):
    """ Check if the value is an integer or not.
        This function is called in def set_datatype_validator(self, value, widget, btn)
        widget = getattr(self, f"{widget.property('datatype')}_validator")( value, widget, btn)
    """

    if value is None or bool(re.search("^\d*$", value)):
        widget.setStyleSheet(None)
        btn_accept.setEnabled(True)
    else:
        widget.setStyleSheet("border: 1px solid red")
        btn_accept.setEnabled(False)


def put_combobox(qtable, rows, field, widget_pos, combo_values):
    """ Set one column of a QtableView as QComboBox with values from database.
    :param qtable: QTableView to fill
    :param rows: List of items to set QComboBox (["..", "..."])
    :param field: Field to set QComboBox (String)
    :param widget_pos: Position of the column where we want to put the QComboBox (integer)
    :param combo_values: List of items to populate QComboBox (["..", "..."])
    :return:
    """

    for x in range(0, len(rows)):
        combo = QComboBox()
        row = rows[x]
        # Populate QComboBox
        fill_combo_values(combo, combo_values, 1)
        # Set QCombobox to wanted item
        set_combo_value(combo, str(row[field]), 1)
        # Get index and put QComboBox into QTableView at index position
        idx = qtable.model().index(x, widget_pos)
        qtable.setIndexWidget(idx, combo)
        # noinspection PyUnresolvedReferences
        combo.currentIndexChanged.connect(partial(update_status, combo, qtable, x, widget_pos))


def update_status(qtable, combo, pos_x, combo_pos, col_update):
    """ Update values from QComboBox to QTableView
    :param qtable: QTableView Where update values
     :param combo: QComboBox from which we will take the value
    :param pos_x: Position of the row where we want to update value (integer)
    :param combo_pos: Position of the column where we want to put the QComboBox (integer)
    :param col_update: Column to update into QTableView.Model() (integer)
    :return:
    """
    elem = combo.itemData(combo.currentIndex())
    i = qtable.model().index(pos_x, combo_pos)
    qtable.model().setData(i, elem[0])
    i = qtable.model().index(pos_x, col_update)
    qtable.model().setData(i, elem[0])


def document_open(qtable):
    """ Open selected document """

    # Get selected rows
    field_index = qtable.model().fieldIndex('path')
    selected_list = qtable.selectionModel().selectedRows(field_index)
    if not selected_list:
        message = "Any record selected"
        global_vars.controller.show_info_box(message)
        return
    elif len(selected_list) > 1:
        message = "More then one document selected. Select just one document."
        tools_gw.show_warning(message)
        return

    path = selected_list[0].data()
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


def document_delete(qtable, tablename):
    """ Delete record from selected rows in tbl_document """

    # Get selected rows. 0 is the column of the pk 0 'id'
    selected_list = qtable.selectionModel().selectedRows(0)
    if len(selected_list) == 0:
        message = "Any record selected"
        global_vars.controller.show_info_box(message)
        return

    selected_id = []
    for index in selected_list:
        doc_id = index.data()
        selected_id.append(str(doc_id))
    message = "Are you sure you want to delete these records?"
    title = "Delete records"
    answer = global_vars.controller.ask_question(message, title, ','.join(selected_id))
    if answer:
        sql = (f"DELETE FROM {tablename}"
               f" WHERE id IN ({','.join(selected_id)})")
        status = global_vars.controller.execute_sql(sql)
        if not status:
            message = "Error deleting data"
            tools_gw.show_warning(message)
            return
        else:
            message = "Document deleted"
            tools_gw.show_info(message)
            qtable.model().select()


def exist_object(dialog, table_object, single_tool_mode=None, layers=None, ids=None, list_ids=None):
    """ Check if selected object (document or element) already exists """

    # Reset list of selected records
    tools_gw.reset_lists(ids, list_ids)

    field_object_id = "id"
    if table_object == "element":
        field_object_id = table_object + "_id"
    object_id = getWidgetText(dialog, table_object + "_id")

    # Check if we already have data with selected object_id
    sql = (f"SELECT * "
           f" FROM {table_object}"
           f" WHERE {field_object_id} = '{object_id}'")
    row = global_vars.controller.get_row(sql, log_info=False)

    # If object_id not found: Clear data
    if not row:
        reset_widgets(dialog, table_object)
        if table_object == 'element':
            set_combo(dialog, 'state', 'value_state', 'edit_state_vdefault', field_name='name')
            set_combo(dialog, 'expl_id', 'exploitation', 'edit_exploitation_vdefault',
                      field_id='expl_id', field_name='name')
            set_calendars(dialog, 'builtdate', 'config_param_user', 'value', 'edit_builtdate_vdefault')
            set_combo(dialog, 'workcat_id', 'cat_work',
                      'edit_workcat_vdefault', field_id='id', field_name='id')

        if single_tool_mode is not None:
            layers = tools_qgis.remove_selection(single_tool_mode, layers=layers)
        else:
            layers = tools_qgis.remove_selection(True, layers=layers)
        reset_model(dialog, table_object, "arc")
        reset_model(dialog, table_object, "node")
        reset_model(dialog, table_object, "connec")
        reset_model(dialog, table_object, "element")
        if global_vars.project_type == 'ud':
            reset_model(dialog, table_object, "gully")

        return layers, ids, list_ids

    # Fill input widgets with data of the @row
    fill_widgets(dialog, table_object, row)

    # Check related 'arcs'
    ids, layers, list_ids = get_records_geom_type(dialog, table_object, "arc", ids=ids, list_ids=list_ids, layers=layers)

    # Check related 'nodes'
    ids, layers, list_ids = get_records_geom_type(dialog, table_object, "node", ids=ids, list_ids=list_ids, layers=layers)

    # Check related 'connecs'
    ids, layers, list_ids = get_records_geom_type(dialog, table_object, "connec", ids=ids, list_ids=list_ids, layers=layers)

    # Check related 'elements'
    ids, layers, list_ids = get_records_geom_type(dialog, table_object, "element", ids=ids, list_ids=list_ids, layers=layers)

    # Check related 'gullys'
    if global_vars.project_type == 'ud':
        ids, layers, list_ids = get_records_geom_type(dialog, table_object, "gully", ids=ids, list_ids=list_ids, layers=layers)

    return layers, ids, list_ids


def get_records_geom_type(dialog, table_object, geom_type, ids=None, list_ids=None, layers=None):
    """ Get records of @geom_type associated to selected @table_object """

    object_id = getWidgetText(dialog, table_object + "_id")
    table_relation = table_object + "_x_" + geom_type
    widget_name = "tbl_" + table_relation

    exists = global_vars.controller.check_table(table_relation)
    if not exists:
        global_vars.controller.log_info(f"Not found: {table_relation}")
        return ids, layers, list_ids

    sql = (f"SELECT {geom_type}_id "
           f"FROM {table_relation} "
           f"WHERE {table_object}_id = '{object_id}'")
    rows = global_vars.controller.get_rows(sql, log_info=False)
    if rows:
        for row in rows:
            list_ids[geom_type].append(str(row[0]))
            ids.append(str(row[0]))

        expr_filter = tools_gw.get_expression_filter(geom_type, list_ids=list_ids, layers=layers)
        set_table_model(dialog, widget_name, geom_type, expr_filter)

    return ids, layers, list_ids


def set_table_model(dialog, table_object, geom_type, expr_filter):
    """ Sets a TableModel to @widget_name attached to
        @table_name and filter @expr_filter
    """

    expr = None
    if expr_filter:
        # Check expression
        (is_valid, expr) = check_expression_filter(expr_filter)  # @UnusedVariable
        if not is_valid:
            return expr

    # Set a model with selected filter expression
    table_name = f"v_edit_{geom_type}"
    if global_vars.schema_name not in table_name:
        table_name = global_vars.schema_name + "." + table_name

    # Set the model
    model = QSqlTableModel(db=global_vars.controller.db)
    model.setTable(table_name)
    model.setEditStrategy(QSqlTableModel.OnManualSubmit)
    model.select()
    if model.lastError().isValid():
        tools_gw.show_warning(model.lastError().text())
        return expr

    # Attach model to selected widget
    if type(table_object) is str:
        widget = getWidget(dialog, table_object)
        if not widget:
            message = "Widget not found"
            global_vars.controller.log_info(message, parameter=table_object)
            return expr
    elif type(table_object) is QTableView:
        # parent_vars.controller.log_debug(f"set_table_model: {table_object.objectName()}")
        widget = table_object
    else:
        msg = "Table_object is not a table name or QTableView"
        global_vars.controller.log_info(msg)
        return expr

    if expr_filter:
        widget.setModel(model)
        widget.model().setFilter(expr_filter)
        widget.model().select()
    else:
        widget.setModel(None)

    return expr


def reload_table(dialog, table_object, geom_type, expr_filter):
    """ Reload @widget with contents of @tablename applying selected @expr_filter """

    if type(table_object) is str:
        widget_name = f"tbl_{table_object}_x_{geom_type}"
        widget = getWidget(dialog, widget_name)
        if not widget:
            message = "Widget not found"
            global_vars.controller.log_info(message, parameter=widget_name)
            return None
    elif type(table_object) is QTableView:
        widget = table_object
    else:
        msg = "Table_object is not a table name or QTableView"
        global_vars.controller.log_info(msg)
        return None

    expr = set_table_model(dialog, widget, geom_type, expr_filter)
    return expr


def reset_model(dialog, table_object, geom_type):
    """ Reset model of the widget """

    table_relation = f"{table_object}_x_{geom_type}"
    widget_name = f"tbl_{table_relation}"
    widget = getWidget(dialog, widget_name)
    if widget:
        widget.setModel(None)


def reset_widgets(dialog, table_object):
    """ Clear contents of input widgets """

    if table_object == "doc":
        setWidgetText(dialog, "doc_type", "")
        setWidgetText(dialog, "observ", "")
        setWidgetText(dialog, "path", "")
    elif table_object == "element":
        setWidgetText(dialog, "elementcat_id", "")
        setWidgetText(dialog, "state", "")
        setWidgetText(dialog, "expl_id", "")
        setWidgetText(dialog, "ownercat_id", "")
        setWidgetText(dialog, "location_type", "")
        setWidgetText(dialog, "buildercat_id", "")
        setWidgetText(dialog, "workcat_id", "")
        setWidgetText(dialog, "workcat_id_end", "")
        setWidgetText(dialog, "comment", "")
        setWidgetText(dialog, "observ", "")
        setWidgetText(dialog, "path", "")
        setWidgetText(dialog, "rotation", "")
        setWidgetText(dialog, "verified", "")
        setWidgetText(dialog, dialog.num_elements, "")


def fill_widgets(dialog, table_object, row):
    """ Fill input widgets with data int he @row """

    if table_object == "doc":

        setWidgetText(dialog, "doc_type", row["doc_type"])
        setWidgetText(dialog, "observ", row["observ"])
        setWidgetText(dialog, "path", row["path"])

    elif table_object == "element":

        state = ""
        if row['state']:
            sql = (f"SELECT name FROM value_state"
                   f" WHERE id = '{row['state']}'")
            row_aux = global_vars.controller.get_row(sql)
            if row_aux:
                state = row_aux[0]

        expl_id = ""
        if row['expl_id']:
            sql = (f"SELECT name FROM exploitation"
                   f" WHERE expl_id = '{row['expl_id']}'")
            row_aux = global_vars.controller.get_row(sql)
            if row_aux:
                expl_id = row_aux[0]

        setWidgetText(dialog, "code", row['code'])
        sql = (f"SELECT elementtype_id FROM cat_element"
               f" WHERE id = '{row['elementcat_id']}'")
        row_type = global_vars.controller.get_row(sql)
        if row_type:
            setWidgetText(dialog, "element_type", row_type[0])

        setWidgetText(dialog, "elementcat_id", row['elementcat_id'])
        setWidgetText(dialog, "num_elements", row['num_elements'])
        setWidgetText(dialog, "state", state)
        set_combo_value(dialog.state_type, f"{row['state_type']}", 0)
        setWidgetText(dialog, "expl_id", expl_id)
        setWidgetText(dialog, "ownercat_id", row['ownercat_id'])
        setWidgetText(dialog, "location_type", row['location_type'])
        setWidgetText(dialog, "buildercat_id", row['buildercat_id'])
        setWidgetText(dialog, "builtdate", row['builtdate'])
        setWidgetText(dialog, "workcat_id", row['workcat_id'])
        setWidgetText(dialog, "workcat_id_end", row['workcat_id_end'])
        setWidgetText(dialog, "comment", row['comment'])
        setWidgetText(dialog, "observ", row['observ'])
        setWidgetText(dialog, "link", row['link'])
        setWidgetText(dialog, "verified", row['verified'])
        setWidgetText(dialog, "rotation", row['rotation'])
        if str(row['undelete']) == 'True':
            dialog.undelete.setChecked(True)


def set_combo(dialog, widget, table_name, parameter, field_id='id', field_name='id'):
    """ Executes query and set combo box """

    sql = (f"SELECT t1.{field_name} FROM {table_name} as t1"
           f" INNER JOIN config_param_user as t2 ON t1.{field_id}::text = t2.value::text"
           f" WHERE parameter = '{parameter}' AND cur_user = current_user")
    row = global_vars.controller.get_row(sql)
    if row:
        setWidgetText(dialog, widget, row[0])


def set_calendars(dialog, widget, table_name, value, parameter):
    """ Executes query and set QDateEdit """

    sql = (f"SELECT {value} FROM {table_name}"
           f" WHERE parameter = '{parameter}' AND cur_user = current_user")
    row = global_vars.controller.get_row(sql)
    if row:
        if row[0]:
            row[0] = row[0].replace('/', '-')
        date = QDate.fromString(row[0], 'yyyy-MM-dd')
    else:
        date = QDate.currentDate()
    setCalendarDate(dialog, widget, date)


def reload_qtable(dialog, geom_type):
    """ Reload QtableView """

    value = getWidgetText(dialog, dialog.psector_id)
    expr = f"psector_id = '{value}'"
    qtable = getWidget(dialog, f'tbl_psector_x_{geom_type}')
    fill_table_by_expr(qtable, f"plan_psector_x_{geom_type}", expr)
    set_table_columns(dialog, qtable, f"plan_psector_x_{geom_type}")
    tools_qgis.refresh_map_canvas()


def fill_table_by_expr(qtable, table_name, expr):
    """
    :param qtable: QTableView to show
    :param expr: expression to set model
    """
    if global_vars.schema_name not in table_name:
        table_name = global_vars.schema_name + "." + table_name

    model = QSqlTableModel(db=global_vars.controller.db)
    model.setTable(table_name)
    model.setFilter(expr)
    model.setEditStrategy(QSqlTableModel.OnFieldChange)
    qtable.setEditTriggers(QTableView.DoubleClicked)
    model.select()
    qtable.setModel(model)
    qtable.show()

    # Check for errors
    if model.lastError().isValid():
        tools_gw.show_warning(model.lastError().text())


def set_open_url(widget):

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


def get_feature_by_id(layer, id, field_id=None):

    features = layer.getFeatures()
    for feature in features:
        if field_id is None:
            if feature.id() == id:
                return feature
        else:
            if feature[field_id] == id:
                return feature
    return False
