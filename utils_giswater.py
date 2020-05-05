"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-


""" Module with utility functions to interact with dialog and its widgets """
from qgis.gui import QgsDateTimeEdit
from PyQt4.QtGui import QLineEdit, QComboBox, QWidget, QPixmap, QDoubleSpinBox, QCheckBox, QLabel, QTextEdit, QDateEdit
from PyQt4.QtGui import QAbstractItemView, QCompleter, QSortFilterProxyModel, QStringListModel, QDateTimeEdit
from PyQt4.QtGui import QTableView, QDoubleValidator, QSpinBox, QTimeEdit, QRegExpValidator, QPushButton
from PyQt4.Qt import QDate, QDateTime
from PyQt4.QtCore import QTime, Qt, QRegExp

from functools import partial
import inspect
import os
import sys
import operator
if 'nt' in sys.builtin_module_names:
    import _winreg


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
    if type(widget) is str or type(widget) is unicode:
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

    if type(widget) is str or type(widget) is unicode:
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

    if type(widget) is str or type(widget) is unicode:
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

    if type(widget) is str or type(widget) is unicode:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return

    value = unicode(text)
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
    if type(widget) is str or type(widget) is unicode:
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

    if type(widget) is str or type(widget) is unicode:
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

    if type(widget) is str or type(widget) is unicode:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return
    if type(widget) is QTimeEdit:
        if time is None:
            time = QTime(00, 00, 00)
        widget.setTime(time)


def getWidget(dialog, widget):

    if type(widget) is str or type(widget) is unicode:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return None
    return widget


def getWidgetType(dialog, widget):

    if type(widget) is str or type(widget) is unicode:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return None
    return type(widget)


def getWidgetText(dialog, widget, add_quote=False, return_string_null=True):

    if type(widget) is str or type(widget) is unicode:
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

    if type(widget) is str or type(widget) is unicode:
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

    if type(widget) is str or type(widget) is unicode:
        widget = dialog.findChild(QCheckBox, widget)
    checked = False
    if widget:
        checked = widget.isChecked()
    return checked


def setChecked(dialog, widget, checked=True):

    if type(widget) is str or type(widget) is unicode:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return
    if type(widget) is QCheckBox:
        widget.setChecked(bool(checked))


def getSelectedItem(dialog, widget, return_string_null=True):

    if type(widget) is str or type(widget) is unicode:
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

    if type(widget) is str or type(widget) is unicode:
        widget = dialog.findChild(QComboBox, widget)
    if widget:
        index = widget.findText(text)
        if index == -1:
            index = 0
        widget.setCurrentIndex(index)


def setCurrentIndex(dialog, widget, index):

    if type(widget) is str or type(widget) is unicode:
        widget = dialog.findChild(QComboBox, widget)
    if widget:
        if index == -1:
            index = 0
        widget.setCurrentIndex(index);


def setWidgetVisible(dialog, widget, visible=True):

    if type(widget) is str or type(widget) is unicode:
        widget = dialog.findChild(QWidget, widget)
    if widget:
        widget.setVisible(visible)


def setWidgetEnabled(dialog, widget, enabled=True):

    if type(widget) is str or type(widget) is unicode:
        widget = dialog.findChild(QWidget, widget)
    if widget:
        widget.setEnabled(enabled)


def setImage(dialog, widget,cat_shape):
    """ Set pictures for UD"""

    element = cat_shape.lower()
    if type(widget) is str or type(widget) is unicode:
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

    if type(widget) is str or type(widget) is unicode:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return
    key = widget.objectName()
    if key in row:
        if row[key] is not None:
            value = unicode(row[key])
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
            reg_root = _winreg.HKEY_LOCAL_MACHINE
        elif reg_hkey == "HKEY_CURRENT_USER":
            reg_root = _winreg.HKEY_CURRENT_USER

        if reg_root is not None:
            try:
                registry_key = _winreg.OpenKey(reg_root, reg_path)
                value, regtype = _winreg.QueryValueEx(registry_key, reg_name)   #@UnusedVariable
                _winreg.CloseKey(registry_key)
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
    if type(widget) is str or type(widget) is unicode:
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


def get_item_data(dialog, widget, index=0, add_quote=False):
    """ Get item data of current index of the @widget """

    code = -1
    if add_quote:
        code = ''
    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if widget:
        if type(widget) is QComboBox:
            current_index = widget.currentIndex()
            elem = widget.itemData(current_index)
            if index == -1:
                return elem
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


def set_regexp_date_validator(widget, button=None, regex_type=1):
    """ Set QRegExpression in order to validate QLineEdit(widget) field type date.
    Also allow to enable or disable a QPushButton(button), like typical accept button
    @Type=1 (yyy-mm-dd), @Type=2 (dd-mm-yyyy)
    """
    placeholder = "yyyy-mm-dd"
    if regex_type == 1:
        widget.setPlaceholderText("yyyy-mm-dd")
        placeholder = "yyyy-mm-dd"
        reg_exp = QRegExp("(((\d{4})([-])(0[13578]|10|12)([-])(0[1-9]|[12][0-9]|3[01]))|"
                          "((\d{4})([-])(0[469]|11)([-])([0][1-9]|[12][0-9]|30))|"
                          "((\d{4})([-])(02)([-])(0[1-9]|1[0-9]|2[0-8]))|"
                          "(([02468][048]00)([-])(02)([-])(29))|"
                          "(([13579][26]00)([-])(02)([-])(29))|"
                          "(([0-9][0-9][0][48])([-])(02)([-])(29))|"
                          "(([0-9][0-9][2468][048])([-])(02)([-])(29))|"
                          "(([0-9][0-9][13579][26])([-])(02)([-])(29)))")
    elif regex_type == 2:
        widget.setPlaceholderText("dd-mm-yyyy")
        placeholder = "dd-mm-yyyy"
        reg_exp = QRegExp("(((0[1-9]|[12][0-9]|3[01])([-])(0[13578]|10|12)([-])(\d{4}))|"
                          "(([0][1-9]|[12][0-9]|30)([-])(0[469]|11)([-])(\d{4}))|"
                          "((0[1-9]|1[0-9]|2[0-8])([-])(02)([-])(\d{4}))|"
                          "((29)(-)(02)([-])([02468][048]00))|"
                          "((29)([-])(02)([-])([13579][26]00))|"
                          "((29)([-])(02)([-])([0-9][0-9][0][48]))|"
                          "((29)([-])(02)([-])([0-9][0-9][2468][048]))|"
                          "((29)([-])(02)([-])([0-9][0-9][13579][26])))")

    widget.setValidator(QRegExpValidator(reg_exp))
    widget.textChanged.connect(partial(eval_regex, widget, reg_exp, button, placeholder))


def eval_regex(widget, reg_exp, button, placeholder, text):
    is_valid = False
    if reg_exp.exactMatch(text) is True:
        widget.setStyleSheet("border: 1px solid gray")
        is_valid = True
    elif str(text) == '':
        widget.setStyleSheet("border: 1px solid gray")
        widget.setPlaceholderText(placeholder)
        is_valid = True
    elif reg_exp.exactMatch(text) is False:
        widget.setStyleSheet("border: 1px solid red")
        is_valid = False

    if button is not None and type(button) == QPushButton:
        if is_valid is False:
            button.setEnabled(False)
        else:
            button.setEnabled(True)

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

