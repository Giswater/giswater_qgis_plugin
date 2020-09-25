"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.gui import QgsDateTimeEdit
from qgis.PyQt.QtCore import QDate, QDateTime, QSortFilterProxyModel, QStringListModel, QTime, Qt, QRegExp
from qgis.PyQt.QtGui import QPixmap, QDoubleValidator, QRegExpValidator
from qgis.PyQt.QtWidgets import QLineEdit, QComboBox, QWidget, QDoubleSpinBox, QCheckBox, QLabel, QTextEdit, QDateEdit
from qgis.PyQt.QtWidgets import QAbstractItemView, QCompleter, QDateTimeEdit, QTableView, QSpinBox, QTimeEdit
from qgis.PyQt.QtWidgets import QPushButton, QPlainTextEdit, QRadioButton

from functools import partial
import os
import operator

from core.utils.hyperlink_label import GwHyperLinkLabel
from lib.tools_other import gw_function_dxf


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


def getText(dialog, widget, return_string_null=True):

    text = ""
    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if widget:
        if type(widget) is QLineEdit or type(widget) is QPushButton or type(widget) is QLabel \
                or type(widget) is GwHyperLinkLabel:
            text = widget.text()
        elif type(widget) is QDoubleSpinBox or type(widget) is QSpinBox:
            text = widget.value()
        elif type(widget) is QTextEdit or type(widget) is QPlainTextEdit:
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
    elif type(widget) is QPlainTextEdit:
        if value == 'None':
            value = ""
        widget.insertPlainText(value)
    elif type(widget) is QDoubleSpinBox or type(widget) is QSpinBox:
        if value == 'None' or value == 'null':
            value = 0
        widget.setValue(float(value))


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

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return None

    text = None
    if type(widget) is QLineEdit or type(widget) is QTextEdit or type(widget) is QLabel or type(widget) is GwHyperLinkLabel \
            or type(widget) is QSpinBox or type(widget) is QDoubleSpinBox or type(widget) is QPushButton \
            or type(widget) is QPlainTextEdit:
        text = getText(dialog, widget, return_string_null)
    elif type(widget) is QComboBox:
        text = getSelectedItem(dialog, widget, return_string_null)
    if add_quote and text != "null":
        text = "'" + text + "'"
    return text


def setWidgetText(dialog, widget, text):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return
    if type(widget) is QLineEdit or type(widget) is QTextEdit or type(widget) is QTimeEdit or type(widget) is QLabel \
            or type(widget) is QPlainTextEdit:
        setText(dialog, widget, text)
    elif type(widget) is QDoubleSpinBox or type(widget) is QSpinBox:
        setText(dialog, widget, text)
    elif type(widget) is QComboBox:
        setSelectedItem(dialog, widget, text)
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
        pic_file = os.path.join(plugin_dir, 'png', '' + element + '')
        pixmap = QPixmap(pic_file)
        widget.setPixmap(pixmap)
        widget.show()


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
            return True
    return False


def set_item_data(combo, rows, index_to_show=0, combo_clear=True, sort_combo=True, sort_by=1, add_empty=False):
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


def double_validator(widget, min_=0, max_=999999, decimals=3, notation=QDoubleValidator().StandardNotation):

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


def set_regexp_date_validator(widget, button=None, regex_type=1):
    """ Set QRegExpression in order to validate QLineEdit(widget) field type date.
    Also allow to enable or disable a QPushButton(button), like typical accept button
    @Type=1 (yyy-mm-dd), @Type=2 (dd-mm-yyyy)
    """

    reg_exp = ""
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
    elif regex_type == 3:
        widget.setPlaceholderText("yyyy/mm/dd")
        placeholder = "yyyy/mm/dd"
        reg_exp = QRegExp("(((\d{4})([/])(0[13578]|10|12)([/])(0[1-9]|[12][0-9]|3[01]))|"
                          "((\d{4})([/])(0[469]|11)([/])([0][1-9]|[12][0-9]|30))|"
                          "((\d{4})([/])(02)([/])(0[1-9]|1[0-9]|2[0-8]))|"
                          "(([02468][048]00)([/])(02)([/])(29))|"
                          "(([13579][26]00)([/])(02)([/])(29))|"
                          "(([0-9][0-9][0][48])([/])(02)([/])(29))|"
                          "(([0-9][0-9][2468][048])([/])(02)([/])(29))|"
                          "(([0-9][0-9][13579][26])([/])(02)([/])(29)))")
    elif regex_type == 4:
        widget.setPlaceholderText("dd/mm/yyyy")
        placeholder = "dd/mm/yyyy"
        reg_exp = QRegExp("(((0[1-9]|[12][0-9]|3[01])([/])(0[13578]|10|12)([/])(\d{4}))|"
                          "(([0][1-9]|[12][0-9]|30)([/])(0[469]|11)([/])(\d{4}))|"
                          "((0[1-9]|1[0-9]|2[0-8])([/])(02)([/])(\d{4}))|"
                          "((29)(-)(02)([/])([02468][048]00))|"
                          "((29)([/])(02)([/])([13579][26]00))|"
                          "((29)([/])(02)([/])([0-9][0-9][0][48]))|"
                          "((29)([/])(02)([/])([0-9][0-9][2468][048]))|"
                          "((29)([/])(02)([/])([0-9][0-9][13579][26])))")

    widget.setValidator(QRegExpValidator(reg_exp))
    widget.textChanged.connect(partial(eval_regex, widget, reg_exp, button, placeholder))


def eval_regex(widget, reg_exp, button, placeholder, text):

    is_valid = False
    if reg_exp.exactMatch(text) is True:
        widget.setStyleSheet(None)
        is_valid = True
    elif str(text) == '':
        widget.setStyleSheet(None)
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


def set_completer_object(dialog, table_object):
    """ Set autocomplete of widget @table_object + "_id"
        getting id's from selected @table_object
    """

    widget = getWidget(dialog, table_object + "_id")
    if not widget:
        return

    # Set SQL
    field_object_id = "id"
    if table_object == "element":
        field_object_id = table_object + "_id"
    sql = (f"SELECT DISTINCT({field_object_id})"
           f" FROM {table_object}")

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


def check_actions(action, enabled):

    try:
        action.setChecked(enabled)
    except RuntimeError:
        pass


def api_action_help(geom_type):
    """ Open PDF file with selected @project_type and @geom_type """

    # Get locale of QGIS application
    locale = QSettings().value('locale/userLocale').lower()
    if locale == 'es_es':
        locale = 'es'
    elif locale == 'es_ca':
        locale = 'ca'
    elif locale == 'en_us':
        locale = 'en'
    project_type = global_vars.controller.get_project_type()
    # Get PDF file
    pdf_folder = os.path.join(global_vars.plugin_dir, 'png')
    pdf_path = os.path.join(pdf_folder, f"{project_type}_{geom_type}_{locale}.png")

    # Open PDF if exists. If not open Spanish version
    if os.path.exists(pdf_path):
        os.system(pdf_path)
    else:
        locale = "es"
        pdf_path = os.path.join(pdf_folder, f"{project_type}_{geom_type}_{locale}.png")
        if os.path.exists(pdf_path):
            os.system(pdf_path)
        else:
            message = "File not found"
            global_vars.controller.show_warning(message, parameter=pdf_path)


def set_widget_size(widget, field):

    if 'widgetdim' in field:
        if field['widgetdim']:
            widget.setMaximumWidth(field['widgetdim'])
            widget.setMinimumWidth(field['widgetdim'])

    return widget


def add_button(dialog, field, temp_layers_added=None, module=sys.modules[__name__]):
    """
    :param dialog: (QDialog)
    :param field: Part of json where find info (Json)
    :param temp_layers_added: List of layers added to the toc
    :param module: Module where find 'function_name', if 'function_name' is not in this module
    :return: (QWidget)
    """
    widget = QPushButton()
    widget.setObjectName(field['widgetname'])

    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    if 'value' in field:
        widget.setText(field['value'])
    widget.resize(widget.sizeHint().width(), widget.sizeHint().height())
    function_name = 'no_function_associated'
    real_name = widget.objectName()[5:len(widget.objectName())]
    if 'widgetfunction' in field:
        if field['widgetfunction'] is not None:
            function_name = field['widgetfunction']
            exist = global_vars.controller.check_python_function(module, function_name)
            if not exist:
                msg = f"widget {real_name} have associated function {function_name}, but {function_name} not exist"
                global_vars.controller.show_message(msg, 2)
                return widget
        else:
            message = "Parameter button_function is null for button"
            global_vars.controller.show_message(message, 2, parameter=widget.objectName())

    kwargs = {'dialog': dialog, 'widget': widget, 'message_level': 1, 'function_name': function_name, 'temp_layers_added': temp_layers_added}
    widget.clicked.connect(partial(getattr(module, function_name), **kwargs))

    return widget


def add_textarea(field):
    """ Add widgets QTextEdit type """

    widget = QTextEdit()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    if 'value' in field:
        widget.setText(field['value'])

    # Set height as a function of text lines
    font = widget.document().defaultFont()
    fm = QFontMetrics(font)
    text_size = fm.size(0, widget.toPlainText())
    if text_size.height() < 26:
        widget.setMinimumHeight(36)
        widget.setMaximumHeight(36)
    else:
        # Need to modify to avoid scroll
        widget.setMaximumHeight(text_size.height() + 10)

    if 'iseditable' in field:
        widget.setReadOnly(not field['iseditable'])
        if not field['iseditable']:
            widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242); color: rgb(100, 100, 100)}")

    return widget


def add_lineedit(field):
    """ Add widgets QLineEdit type """

    widget = QLineEdit()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    if 'placeholder' in field:
        widget.setPlaceholderText(field['placeholder'])
    if 'value' in field:
        widget.setText(field['value'])
    if 'iseditable' in field:
        widget.setReadOnly(not field['iseditable'])
        if not field['iseditable']:
            widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242); color: rgb(100, 100, 100)}")

    return widget


def set_data_type(field, widget):

    widget.setProperty('datatype', field['datatype'])
    return widget


def manage_lineedit(field, dialog, widget, completer):

    if field['widgettype'] == 'typeahead':
        if 'queryText' not in field or 'queryTextFilter' not in field:
            return widget
        model = QStringListModel()
        widget.textChanged.connect(partial(populate_lineedit, completer, model, field, dialog, widget))

    return widget


def populate_lineedit(completer, model, field, dialog, widget):
    """ Set autocomplete of widget @table_object + "_id"
        getting id's from selected @table_object.
        WARNING: Each QLineEdit needs their own QCompleter and their own QStringListModel!!!
    """

    if not widget:
        return
    parent_id = ""
    if 'parentId' in field:
        parent_id = field["parentId"]

    extras = f'"queryText":"{field["queryText"]}"'
    extras += f', "queryTextFilter":"{field["queryTextFilter"]}"'
    extras += f', "parentId":"{parent_id}"'
    extras += f', "parentValue":"{getWidgetText(dialog, "data_" + str(field["parentId"]))}"'
    extras += f', "textToSearch":"{getWidgetText(dialog, widget)}"'
    body = create_body(extras=extras)
    complet_list = global_vars.controller.get_json('gw_fct_gettypeahead', body)
    if not complet_list:
        return False

    list_items = []
    for field in complet_list['body']['data']:
        list_items.append(field['idval'])
    set_completer_object_api(completer, model, widget, list_items)


def add_tableview(complet_result, field):
    """ Add widgets QTableView type """

    widget = QTableView()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    function_name = 'no_function_asociated'
    real_name = widget.objectName()[5:len(widget.objectName())]
    if 'widgetfunction' in field:
        if field['widgetfunction'] is not None:
            function_name = field['widgetfunction']
            exist = global_vars.controller.check_python_function(sys.modules[__name__], function_name)
            if not exist:
                msg = f"widget {real_name} have associated function {function_name}, but {function_name} not exist"
                global_vars.controller.show_message(msg, 2)
                return widget

    # Call def gw_api_open_rpt_result(self, widget, complet_result) of class ApiCf
    # noinspection PyUnresolvedReferences
    widget.doubleClicked.connect(partial(getattr(sys.modules[__name__], function_name), widget, complet_result))

    return widget


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


def add_checkbox(field):

    widget = QCheckBox()
    widget.setObjectName(field['widgetname'])
    widget.setProperty('columnname', field['columnname'])
    if 'value' in field:
        if field['value'] in ("t", "true", True):
            widget.setChecked(True)
    if 'iseditable' in field:
        widget.setEnabled(field['iseditable'])
    return widget


def add_combobox(field):

    widget = QComboBox()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    widget = populate_combo(widget, field)
    if 'selectedId' in field:
        set_combo_itemData(widget, field['selectedId'], 0)
        widget.setProperty('selectedId', field['selectedId'])
    else:
        widget.setProperty('selectedId', None)
    if 'iseditable' in field:
        widget.setEnabled(bool(field['iseditable']))
        if not field['iseditable']:
            widget.setStyleSheet("QComboBox { background: rgb(242, 242, 242); color: rgb(100, 100, 100)}")
    return widget


def fill_child(dialog, widget, feature_type, tablename, field_id):
    """ Find QComboBox child and populate it
    :param dialog: QDialog
    :param widget: QComboBox parent
    :param feature_type: PIPE, ARC, JUNCTION, VALVE...
    :param tablename: view of DB
    :param field_id: Field id of tablename
    """

    combo_parent = widget.property('columnname')
    combo_id = get_item_data(dialog, widget)

    feature = f'"featureType":"{feature_type}", '
    feature += f'"tableName":"{tablename}", '
    feature += f'"idName":"{field_id}"'
    extras = f'"comboParent":"{combo_parent}", "comboId":"{combo_id}"'
    body = create_body(feature=feature, extras=extras)
    result = global_vars.controller.get_json('gw_fct_getchilds', body)
    if not result:
        return False

    for combo_child in result['body']['data']:
        if combo_child is not None:
            manage_child(dialog, widget, combo_child)


def manage_child(dialog, combo_parent, combo_child):
    child = dialog.findChild(QComboBox, str(combo_child['widgetname']))
    if child:
        child.setEnabled(True)

        populate_child(dialog, combo_child)
        if 'widgetcontrols' not in combo_child or not combo_child['widgetcontrols'] or \
                'enableWhenParent' not in combo_child['widgetcontrols']:
            return
        #
        if (str(get_item_data(dialog, combo_parent, 0)) in str(combo_child['widgetcontrols']['enableWhenParent'])) \
                and (get_item_data(dialog, combo_parent, 0) not in (None, '')):
            # The keepDisbled property is used to keep the edition enabled or disabled,
            # when we activate the layer and call the "enable_all" function
            child.setProperty('keepDisbled', False)
            child.setEnabled(True)
        else:
            child.setProperty('keepDisbled', True)
            child.setEnabled(False)


def populate_child(dialog, combo_child):

    child = dialog.findChild(QComboBox, str(combo_child['widgetname']))
    if child:
        populate_combo(child, combo_child)


def populate_combo(widget, field):
    # Generate list of items to add into combo

    widget.blockSignals(True)
    widget.clear()
    widget.blockSignals(False)
    combolist = []
    if 'comboIds' in field:
        if 'isNullValue' in field and field['isNullValue']:
            combolist.append(['', ''])
        for i in range(0, len(field['comboIds'])):
            elem = [field['comboIds'][i], field['comboNames'][i]]
            combolist.append(elem)

    # Populate combo
    for record in combolist:
        widget.addItem(record[1], record)

    return widget


def add_frame(field, x=None):

    widget = QFrame()
    widget.setObjectName(f"{field['widgetname']}_{x}")
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    widget.setFrameShape(QFrame.HLine)
    widget.setFrameShadow(QFrame.Sunken)

    return widget


def add_label(field):
    """ Add widgets QLineEdit type """

    widget = QLabel()
    widget.setTextInteractionFlags(Qt.TextSelectableByMouse)
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    if 'value' in field:
        widget.setText(field['value'])

    return widget


def set_calendar_empty(widget):
    """ Set calendar empty when click inner button of QgsDateTimeEdit because aesthetically it looks better"""
    widget.setEmpty()


def add_hyperlink(field):

    widget = GwHyperLinkLabel()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    if 'value' in field:
        widget.setText(field['value'])
    widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
    widget.resize(widget.sizeHint().width(), widget.sizeHint().height())
    func_name = 'no_function_associated'
    real_name = widget.objectName()[5:len(widget.objectName())]
    if 'widgetfunction' in field:
        if field['widgetfunction'] is not None:
            func_name = field['widgetfunction']
            exist = global_vars.controller.check_python_function(sys.modules[__name__], func_name)
            if not exist:
                msg = f"widget {real_name} have associated function {func_name}, but {func_name} not exist"
                global_vars.controller.show_message(msg, 2)
                return widget
        else:
            message = "Parameter widgetfunction is null for widget"
            global_vars.controller.show_message(message, 2, parameter=real_name)
    else:
        message = "Parameter not found"
        global_vars.controller.show_message(message, 2, parameter='widgetfunction')

    # Call function (self, widget) or def no_function_associated(self, widget=None, message_level=1)
    widget.clicked.connect(partial(getattr(sys.modules[__name__], func_name), widget))

    return widget


def add_horizontal_spacer():

    widget = QSpacerItem(10, 10, QSizePolicy.Expanding, QSizePolicy.Minimum)
    return widget


def add_vertical_spacer():

    widget = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
    return widget


def add_spinbox(field):

    widget = None
    if 'value' in field:
        if field['widgettype'] == 'spinbox':
            widget = QSpinBox()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    if 'value' in field:
        if field['widgettype'] == 'spinbox' and field['value'] != "":
            widget.setValue(int(field['value']))
    if 'iseditable' in field:
        widget.setReadOnly(not field['iseditable'])
        if not field['iseditable']:
            widget.setStyleSheet("QDoubleSpinBox { background: rgb(0, 250, 0); color: rgb(100, 100, 100)}")

    return widget


def fill_table(widget, table_name, filter_=None):
    """ Set a model with selected filter.
    Attach that model to selected table """

    if global_vars.schema_name not in table_name:
        table_name = global_vars.schema_name + "." + table_name

    # Set model
    model = QSqlTableModel()
    model.setTable(table_name)
    model.setEditStrategy(QSqlTableModel.OnManualSubmit)
    model.setSort(0, 0)
    if filter_:
        model.setFilter(filter_)
    model.select()

    # Check for errors
    if model.lastError().isValid():
        global_vars.controller.show_warning(model.lastError().text())

    # Attach model to table view
    widget.setModel(model)


def populate_basic_info(dialog, result, field_id, my_json=None, new_feature_id=None, new_feature=None,
                        layer_new_feature=None, feature_id=None, feature_type=None, layer=None):

    fields = result[0]['body']['data']
    if 'fields' not in fields:
        return
    grid_layout = dialog.findChild(QGridLayout, 'gridLayout')

    for x, field in enumerate(fields["fields"]):

        label = QLabel()
        label.setObjectName('lbl_' + field['label'])
        label.setText(field['label'].capitalize())

        if 'tooltip' in field:
            label.setToolTip(field['tooltip'])
        else:
            label.setToolTip(field['label'].capitalize())

        widget = None
        if field['widgettype'] in ('text', 'textline') or field['widgettype'] == 'typeahead':
            completer = QCompleter()
            widget = add_lineedit(field)
            widget = set_widget_size(widget, field)
            widget = set_data_type(field, widget)
            if field['widgettype'] == 'typeahead':
                widget = manage_lineedit(field, dialog, widget, completer)

        elif field['widgettype'] == 'datetime':
            widget = add_calendar(dialog, field, my_json, new_feature_id=new_feature_id, new_feature=new_feature,
                                  layer_new_feature=layer_new_feature, feature_id=feature_id, feature_type=feature_type,
                                  layer=layer)
        elif field['widgettype'] == 'hyperlink':
            widget = add_hyperlink(field)
        elif field['widgettype'] == 'textarea':
            widget = add_textarea(field)
        elif field['widgettype'] in ('combo', 'combobox'):
            widget = QComboBox()
            populate_combo(widget, field)
            widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
        elif field['widgettype'] in ('check', 'checkbox'):
            widget = add_checkbox(field)
            widget.stateChanged.connect(partial(get_values, dialog, widget, my_json, layer))
        elif field['widgettype'] == 'button':
            widget = add_button(dialog, field)

        grid_layout.addWidget(label, x, 0)
        grid_layout.addWidget(widget, x, 1)

    verticalSpacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
    grid_layout.addItem(verticalSpacer1)

    return result


def clear_gridlayout(layout):
    """  Remove all widgets of layout """

    while layout.count() > 0:
        child = layout.takeAt(0).widget()
        if child:
            child.setParent(None)
            child.deleteLater()


def add_calendar(dialog, field, my_json=None, complet_result=None, new_feature_id=None, new_feature=None,
                 layer_new_feature=None, feature_id=None, feature_type=None, layer=None):

    widget = QgsDateTimeEdit()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    widget.setAllowNull(True)
    widget.setCalendarPopup(True)
    widget.setDisplayFormat('dd/MM/yyyy')
    if 'value' in field and field['value'] not in ('', None, 'null'):
        date = QDate.fromString(field['value'].replace('/', '-'), 'yyyy-MM-dd')
        setCalendarDate(dialog, widget, date)
    else:
        widget.clear()
    btn_calendar = widget.findChild(QToolButton)

    if field['isautoupdate']:
        _json = {}
        btn_calendar.clicked.connect(partial(get_values, dialog, widget, _json, layer))
        btn_calendar.clicked.connect(
            partial(accept, dialog, complet_result[0], _json, p_widget=feature_id, clear_json=True,
                    close_dlg=False, new_feature_id=new_feature_id, new_feature=new_feature,
                    layer_new_feature=layer_new_feature, feature_id=feature_id, feature_type=feature_type))
    else:
        btn_calendar.clicked.connect(partial(get_values, dialog, widget, my_json, layer))
    btn_calendar.clicked.connect(partial(set_calendar_empty, widget))

    return widget


def construct_form_param_user(dialog, row, pos, _json, temp_layers_added=None):

    field_id = ''
    if 'fields' in row[pos]:
        field_id = 'fields'
    elif 'return_type' in row[pos]:
        if row[pos]['return_type'] not in ('', None):
            field_id = 'return_type'

    if field_id == '':
        return

    for field in row[pos][field_id]:
        if field['label']:
            lbl = QLabel()
            lbl.setObjectName('lbl' + field['widgetname'])
            lbl.setText(field['label'])
            lbl.setMinimumSize(160, 0)
            lbl.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Preferred)
            if 'tooltip' in field:
                lbl.setToolTip(field['tooltip'])

            widget = None
            if field['widgettype'] == 'text' or field['widgettype'] == 'linetext':
                widget = QLineEdit()
                if 'isMandatory' in field:
                    widget.setProperty('is_mandatory', field['isMandatory'])
                else:
                    widget.setProperty('is_mandatory', True)
                widget.setText(field['value'])
                if 'widgetcontrols' in field and field['widgetcontrols']:
                    if 'regexpControl' in field['widgetcontrols']:
                        if field['widgetcontrols']['regexpControl'] is not None:
                            pass
                widget.editingFinished.connect(
                    partial(get_values_changed_param_user, dialog, None, widget, field, _json))
                widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
            elif field['widgettype'] == 'combo':
                widget = add_combobox(field)
                widget.currentIndexChanged.connect(
                    partial(get_values_changed_param_user, dialog, None, widget, field, _json))
                widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
            elif field['widgettype'] == 'check':
                widget = QCheckBox()
                if field['value'] is not None and field['value'].lower() == "true":
                    widget.setChecked(True)
                else:
                    widget.setChecked(False)
                widget.stateChanged.connect(partial(get_values_changed_param_user,
                                            dialog, None, widget, field, _json))
                widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
            elif field['widgettype'] == 'datetime':
                widget = QgsDateTimeEdit()
                widget.setAllowNull(True)
                widget.setCalendarPopup(True)
                widget.setDisplayFormat('yyyy/MM/dd')
                date = QDate.currentDate()
                if 'value' in field and field['value'] not in ('', None, 'null'):
                    date = QDate.fromString(field['value'].replace('/', '-'), 'yyyy-MM-dd')
                widget.setDate(date)
                widget.dateChanged.connect(partial(get_values_changed_param_user,
                                           dialog, None, widget, field, _json))
                widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
            elif field['widgettype'] == 'spinbox':
                widget = QDoubleSpinBox()
                if 'value' in field and field['value'] not in(None, ""):
                    value = float(str(field['value']))
                    widget.setValue(value)
                # noinspection PyUnresolvedReferences
                widget.valueChanged.connect(partial(get_values_changed_param_user,
                                            dialog, None, widget, field, _json))
                widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
            elif field['widgettype'] == 'button':
                widget = add_button(dialog, field, temp_layers_added)
                widget = set_widget_size(widget, field)

            # Set editable/readonly
            if type(widget) in (QLineEdit, QDoubleSpinBox):
                if 'iseditable' in field:
                    if str(field['iseditable']) == "False":
                        widget.setReadOnly(True)
                        widget.setStyleSheet("QWidget {background: rgb(242, 242, 242);color: rgb(100, 100, 100)}")
                if type(widget) == QLineEdit:
                    if 'placeholder' in field:
                        widget.setPlaceholderText(field['placeholder'])
            elif type(widget) in (QComboBox, QCheckBox):
                if 'iseditable' in field:
                    if str(field['iseditable']) == "False":
                        widget.setEnabled(False)
            widget.setObjectName(field['widgetname'])
            if 'iseditable' in field:
                widget.setEnabled(bool(field['iseditable']))

            put_widgets(dialog, field, lbl, widget)


def put_widgets(dialog, field, lbl, widget):
    """ Insert widget into layout """

    layout = dialog.findChild(QGridLayout, field['layoutname'])
    if layout in (None, 'null', 'NULL', 'Null'):
        return
    layout.addWidget(lbl, int(field['layoutorder']), 0)
    layout.addWidget(widget, int(field['layoutorder']), 2)
    layout.setColumnStretch(2, 1)


def get_values_changed_param_user(dialog, chk, widget, field, list, value=None):

    elem = {}
    if type(widget) is QLineEdit:
        value = getWidgetText(dialog, widget, return_string_null=False)
    elif type(widget) is QComboBox:
        value = get_item_data(dialog, widget, 0)
    elif type(widget) is QCheckBox:
        value = isChecked(dialog, widget)
    elif type(widget) is QDateEdit:
        value = getCalendarDate(dialog, widget)
    # if chk is None:
    #     elem[widget.objectName()] = value
    elem['widget'] = str(widget.objectName())
    elem['value'] = value
    if chk is not None:
        if chk.isChecked():
            # elem['widget'] = str(widget.objectName())
            elem['chk'] = str(chk.objectName())
            elem['isChecked'] = str(isChecked(dialog, chk))
            # elem['value'] = value

    if 'sys_role_id' in field:
        elem['sys_role_id'] = str(field['sys_role_id'])
    list.append(elem)
    global_vars.controller.log_info(str(list))


def get_values(dialog, widget, _json=None, layer=None):

    value = None
    if type(widget) in (QDoubleSpinBox, QLineEdit, QSpinBox, QTextEdit) and widget.isReadOnly() is False:
        value = getWidgetText(dialog, widget, return_string_null=False)
    elif type(widget) is QComboBox and widget.isEnabled():
        value = get_item_data(dialog, widget, 0)
    elif type(widget) is QCheckBox and widget.isEnabled():
        value = isChecked(dialog, widget)
    elif type(widget) is QgsDateTimeEdit and widget.isEnabled():
        value = getCalendarDate(dialog, widget)
    # Only get values if layer is editable or if layer not exist(need for ApiManageComposer)
    if layer is None or layer.isEditable():
        # If widget.isEditable(False) return None, here control it.
        if str(value) == '' or value is None:
            _json[str(widget.property('columnname'))] = None
        else:
            _json[str(widget.property('columnname'))] = str(value)


def set_setStyleSheet(field, widget, wtype='label'):

    if field['stylesheet'] is not None:
        if wtype in field['stylesheet']:
            widget.setStyleSheet("QWidget{" + field['stylesheet'][wtype] + "}")
    return widget


def manage_all(dialog, widget_all, selector_vars):

    key_modifier = QApplication.keyboardModifiers()
    status = isChecked(dialog, widget_all)
    index = dialog.main_tab.currentIndex()
    widget_list = dialog.main_tab.widget(index).findChildren(QCheckBox)
    if key_modifier == Qt.ShiftModifier:
        return

    for widget in widget_list:
        if widget_all is not None:
            if widget == widget_all or widget.objectName() == widget_all.objectName():
                continue
        widget.blockSignals(True)
        setChecked(dialog, widget, status)
        widget.blockSignals(False)

    set_selector(dialog, widget_all, False, selector_vars)


def disable_all(dialog, result, enable):

    try:
        widget_list = dialog.findChildren(QWidget)
        for widget in widget_list:
            for field in result['fields']:
                if widget.property('columnname') == field['columnname']:
                    if type(widget) in (QDoubleSpinBox, QLineEdit, QSpinBox, QTextEdit):
                        widget.setReadOnly(not enable)
                        widget.setStyleSheet("QWidget { background: rgb(242, 242, 242); color: rgb(0, 0, 0)}")
                    elif type(widget) in (QComboBox, QCheckBox, QgsDateTimeEdit):
                        widget.setEnabled(enable)
                        widget.setStyleSheet("QWidget {color: rgb(0, 0, 0)}")
                    elif type(widget) is QPushButton:
                        # Manage the clickability of the buttons according to the configuration
                        # in the table config_api_form_fields simultaneously with the edition,
                        # but giving preference to the configuration when iseditable is True
                        if not field['iseditable']:
                            widget.setEnabled(field['iseditable'])
                    break

    except RuntimeError as e:
        pass


def enable_all(dialog, result):

    try:
        widget_list = dialog.findChildren(QWidget)
        for widget in widget_list:
            if widget.property('keepDisbled'):
                continue
            for field in result['fields']:
                if widget.property('columnname') == field['columnname']:
                    if type(widget) in (QSpinBox, QDoubleSpinBox, QLineEdit, QTextEdit):
                        widget.setReadOnly(not field['iseditable'])
                        if not field['iseditable']:
                            widget.setFocusPolicy(Qt.NoFocus)
                            widget.setStyleSheet("QWidget { background: rgb(242, 242, 242); color: rgb(0, 0, 0)}")
                        else:
                            widget.setFocusPolicy(Qt.StrongFocus)
                            widget.setStyleSheet(None)
                    elif type(widget) in (QComboBox, QCheckBox, QPushButton, QgsDateTimeEdit):
                        widget.setEnabled(field['iseditable'])
                        if not field['iseditable']:
                            widget.setFocusPolicy(Qt.NoFocus)
                            widget.setStyleSheet("QWidget { background: rgb(242, 242, 242); color: rgb(0, 0, 0)}")
                        else:
                            widget.focusPolicy(Qt.StrongFocus) if widget.setEnabled(
                                field['iseditable']) else widget.setFocusPolicy(Qt.NoFocus)
    except RuntimeError:
        pass