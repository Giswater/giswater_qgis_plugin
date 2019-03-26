"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
""" Module with utility functions to interact with dialog and its widgets """
from future import standard_library
standard_library.install_aliases()
from builtins import range

try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    from qgis.PyQt.QtGui import QStringListModel
else:
    from qgis.PyQt.QtCore import QStringListModel
    
from qgis.gui import QgsDateTimeEdit

from qgis.PyQt.QtCore import QSortFilterProxyModel, QDate, QDateTime, QTime, Qt
from qgis.PyQt.QtGui import QPixmap, QDoubleValidator
from qgis.PyQt.QtWidgets import QLineEdit, QComboBox, QWidget, QDoubleSpinBox, QCheckBox, QLabel, QTextEdit, QDateEdit
from qgis.PyQt.QtWidgets import QAbstractItemView, QCompleter, QDateTimeEdit, QTableView, QSpinBox, QTimeEdit, QPushButton

from functools import partial
import os
import sys
import operator
if 'nt' in sys.builtin_module_names:
    import winreg


def setDialog(p_dialog):
    global _dialog
    _dialog = p_dialog


def dialog():
    if '_dialog' in globals():
        return _dialog
    else:
        return None


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


def fillWidgets(rows, index_widget=0, index_text=1):

    if rows:
        for row in rows:
            setWidgetText(str(row[index_widget]), str(row[index_text]))


def getText(dialog, widget, return_string_null=True):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if widget:
        if type(widget) is QLineEdit:
            text = widget.text()
        elif type(widget) is QDoubleSpinBox or type(widget) is QSpinBox:
            text = widget.value()
        elif type(widget) is QTextEdit:
            text = widget.toPlainText()
        if text:
            elem_text = text
        elif return_string_null:
            elem_text = "null"
        else:
            elem_text = ""
    else:
        if return_string_null:
            elem_text = "null"
        else:
            elem_text = ""
    return elem_text


def setText(dialog, widget, text):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return

    value = str(text)
    if type(widget) is QLineEdit or type(widget) is QTextEdit or type(widget) is QLabel:
        if value == 'None':
            value = ""
        widget.setText(value)
    elif type(widget) is QDoubleSpinBox or type(widget) is QSpinBox:
        if value == 'None' or value == 'null':
            value = 0
        widget.setValue(float(value))


def getCalendarDate(dialog, widget, date_format = "yyyy/MM/dd", datetime_format = "yyyy/MM/dd hh:mm:ss"):

    date = None
    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return
    if type(widget) is QDateEdit:
        date = widget.date().toString(date_format)
    elif type(widget) is QDateTimeEdit:
        date = widget.dateTime().toString(datetime_format)
    elif type(widget) is QgsDateTimeEdit and widget.displayFormat() == 'dd/MM/yyyy':
        date = widget.dateTime().toString(date_format)
    elif type(widget) is QgsDateTimeEdit and widget.displayFormat() == 'dd/MM/yyyy hh:mm:ss':
        date = widget.dateTime().toString(datetime_format)

    return date


def setCalendarDate(dialog, widget, date, default_current_date=True):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return
    if type(widget) is QDateEdit \
        or (type(widget) is QgsDateTimeEdit and widget.displayFormat() == 'dd/MM/yyyy'):
        if date is None:
            if default_current_date:
                date = QDate.currentDate()
            else:
                date = QDate.fromString('01/01/2000', 'dd/MM/yyyy')
        widget.setDate(date)
    elif type(widget) is QDateTimeEdit \
        or (type(widget) is QgsDateTimeEdit and widget.displayFormat() == 'dd/MM/yyyy hh:mm:ss'):
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

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return None

    text = None
    if type(widget) is QLineEdit or type(widget) is QTextEdit or type(widget) is QDoubleSpinBox or type(widget) is QSpinBox:
        text = getText(dialog, widget, return_string_null)
    elif type(widget) is QComboBox:
        text = getSelectedItem(dialog, widget, return_string_null)
    if add_quote and text != "null":
        text = "'"+text+"'"
    return text


def setWidgetText(dialog, widget, text):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return
    if type(widget) is QLineEdit or type(widget) is QTextEdit or type(widget) is QTimeEdit or type(widget) is QLabel:
        setText(dialog, widget, text)
    elif type(widget) is QDoubleSpinBox or type(widget) is QSpinBox:
        setText(dialog, widget, text)
    elif type(widget) is QComboBox:
        setSelectedItem(dialog, widget, text)


def isChecked(dialog, widget):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QCheckBox, widget)
    checked = False
    if widget:
        checked = widget.isChecked()
    return checked


def setChecked(dialog, widget, checked=True):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return
    if type(widget) is QCheckBox:
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
        widget.setCurrentIndex(index);


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


def setImage(dialog, widget,cat_shape):
    """ Set pictures for UD"""

    element = cat_shape.lower()
    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return
    if type(widget) is QLabel:
        plugin_dir = os.path.dirname(__file__)
        pic_file = os.path.join(plugin_dir, 'png', ''+element+'')
        pixmap = QPixmap(pic_file)
        widget.setPixmap(pixmap)
        widget.show()


# def setRow(p_row):
#     global _row
#     _row = p_row


def fillWidget(dialog, widget, row):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return
    key = widget.objectName()
    if key in row:
        if row[key] is not None:
            value = str(row[key])
            if type(widget) is QLineEdit or type(widget) is QTextEdit:
                if value == 'None':
                    value = ""
                widget.setText(value)
        else:
            widget.setText("")
    else:
        widget.setText("")


def get_reg(reg_hkey, reg_path, reg_name):

    if 'nt' in sys.builtin_module_names:
        reg_root = None
        if reg_hkey == "HKEY_LOCAL_MACHINE":
            reg_root = winreg.HKEY_LOCAL_MACHINE
        elif reg_hkey == "HKEY_CURRENT_USER":
            reg_root = winreg.HKEY_CURRENT_USER

        if reg_root is not None:
            try:
                registry_key = winreg.OpenKey(reg_root, reg_path)
                value, regtype = winreg.QueryValueEx(registry_key, reg_name)   #@UnusedVariable
                winreg.CloseKey(registry_key)
                return value
            except WindowsError:
                return None
    else:
        return None


def get_settings_value(settings, parameter):
    """ Function that fix problem with network units in Windows """

    file_aux = ""
    try:
        file_aux = settings.value(parameter)
        if file_aux is not None:
            unit = file_aux[:1]
            if unit != '\\' and file_aux[1] != ':':
                path = file_aux[1:]
                file_aux = unit+":"+path
    except IndexError:
        pass
    return file_aux


def set_table_selection_behavior(dialog, widget):
    """ Set selection behavior of @widget """
    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return
    widget.setSelectionBehavior(QAbstractItemView.SelectRows)


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


def get_item_data(dialog, widget, index=0):
    """ Get item data of current index of the @widget """

    code = -1
    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if widget:
        if type(widget) is QComboBox:
            current_index = widget.currentIndex()     
            elem = widget.itemData(current_index)
            code = elem[index]            

    return code


def set_combo_itemData(combo, value, item1):
    """ Set text to combobox populate with more than 1 item for row
        @item1: element to compare
        @item2: element to show
    """
    for i in range(0, combo.count()):
        elem = combo.itemData(i)
        if value == str(elem[item1]):
            combo.setCurrentIndex(i)


def set_item_data(combo, rows, index_to_show=0, combo_clear=True, sort_combo=True):
    """ Populate @combo with list @rows and show field @index_to_show """
    
    records = []
    if rows is None:
        return
    for row in rows:
        elem = []
        for x in range(0, len(row)):
            elem.append(row[x])
        records.append(elem)

    combo.blockSignals(True)
    if combo_clear:
        combo.clear()
    records_sorted = records
    if sort_combo:
        records_sorted = sorted(records, key=operator.itemgetter(1))

    for record in records_sorted:
        combo.addItem(record[index_to_show], record)
        combo.blockSignals(False)


def remove_tab_by_tabName(tab_widget, tab_name):
    """ Look in @tab_widget for a tab with @tab_name and remove it """
    
    for x in range(0, tab_widget.count()):
        if tab_widget.widget(x).objectName() == tab_name:
            tab_widget.removeTab(x)
            break


def double_validator(widget, min=0, max=999999, decimals=3, notation=QDoubleValidator().StandardNotation):
    validator = QDoubleValidator(min, max, decimals)
    validator.setNotation(notation)
    widget.setValidator(validator)


def dis_enable_dialog(dialog, enable, ignore_widgets=['', None]):
    widget_list = dialog.findChildren(QWidget)
    for widget in widget_list:
        if str(widget.objectName()) not in ignore_widgets:
            if type(widget) in (QSpinBox, QDoubleSpinBox, QLineEdit):
                widget.setReadOnly(not enable)
                if enable:
                    widget.setStyleSheet("QWidget { background: rgb(255, 255, 255);"
                                         " color: rgb(0, 0, 0)}")
                else:
                    widget.setStyleSheet("QWidget { background: rgb(242, 242, 242);"
                                         " color: rgb(100, 100, 100)}")
            elif type(widget) in (QComboBox, QCheckBox, QPushButton, QgsDateTimeEdit):
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

