"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import inspect
import os
import operator
import sys
import subprocess
import traceback
import webbrowser
from functools import partial
from encodings.aliases import aliases

from qgis.PyQt.QtCore import QDate, QDateTime, QSortFilterProxyModel, QStringListModel, QTime, Qt, QRegExp, pyqtSignal, \
    QPersistentModelIndex, QCoreApplication, QTranslator, QSettings
from qgis.PyQt.QtGui import QPixmap, QDoubleValidator, QTextCharFormat, QFont
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QAction, QLineEdit, QComboBox, QWidget, QDoubleSpinBox, QCheckBox, QLabel, QTextEdit, \
    QDateEdit,  QAbstractItemView, QCompleter, QDateTimeEdit, QTableView, QSpinBox, QTimeEdit, QPushButton, \
    QPlainTextEdit, QRadioButton, QSizePolicy, QSpacerItem, QFileDialog, QGroupBox, QMessageBox, QTabWidget, QToolBox
from qgis.core import QgsExpression, QgsProject
from qgis.gui import QgsDateTimeEdit

from . import tools_log, tools_os, tools_qgis
from .. import global_vars
from .ui.ui_manager import DialogTextUi


translator = QTranslator()


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


def get_calendar_date(dialog, widget, date_format="yyyy/MM/dd", datetime_format="yyyy/MM/dd hh:mm:ss"):

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


def set_calendar(dialog, widget, date, default_current_date=True):

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


def set_time(dialog, widget, time):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return
    if type(widget) is QTimeEdit:
        if time is None:
            time = QTime(00, 00, 00)
        widget.setTime(time)


def get_widget(dialog, widget):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return None
    return widget


def get_widget_type(dialog, widget):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if not widget:
        return None
    return type(widget)


def get_text(dialog, widget, add_quote=False, return_string_null=True):

    if type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    text = None
    if widget:
        if type(widget) in (QLineEdit, QPushButton, QLabel, GwHyperLinkLabel):
            text = widget.text()
        elif type(widget) in (QDoubleSpinBox, QSpinBox):
            # When the QDoubleSpinbox contains decimals, for example 2,0001 when collecting the value,
            # the spinbox itself sends 2.0000999999, as in reality we only want, maximum 4 decimal places, we round up,
            # thus fixing this small failure of the widget
            text = round(widget.value(), 4)
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


def set_widget_text(dialog, widget, text):

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
        set_selected_item(dialog, widget, text)
    elif type(widget) is QTimeEdit:
        set_time(dialog, widget, text)
    elif type(widget) is QCheckBox:
        set_checked(dialog, widget, text)


def isChecked(dialog, widget):

    if type(widget) is str:
        widget = dialog.findChild(QCheckBox, widget)
        if widget is None:
            widget = dialog.findChild(QRadioButton, widget)
    checked = False
    if widget:
        checked = widget.isChecked()
    return checked


def set_checked(dialog, widget, checked=True):

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


def set_selected_item(dialog, widget, text):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QComboBox, widget)
    if widget:
        index = widget.findText(text)
        if index == -1:
            index = 0
        widget.setCurrentIndex(index)


def set_current_index(dialog, widget, index):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QComboBox, widget)
    if widget:
        if index == -1:
            index = 0
        widget.setCurrentIndex(index)


def set_widget_visible(dialog, widget, visible=True):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if widget:
        widget.setVisible(visible)


def set_widget_enabled(dialog, widget, enabled=True):

    if type(widget) is str or type(widget) is str:
        widget = dialog.findChild(QWidget, widget)
    if widget:
        widget.setEnabled(enabled)


def add_image(dialog, widget, cat_shape):
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

    # Add new value if @value not in combo
    new_elem = []
    for x in range(len(combo.itemData(0))):
        new_elem.append("")
    new_elem[0] = value
    new_elem[1] = f"({value})"
    combo.addItem(new_elem[1], new_elem)
    combo.setCurrentIndex(combo.count() - 1)
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


def remove_tab(tab_widget, tab_name):
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


def set_action_checked(action, enabled, dialog=None):
    if type(action) is str and dialog is not None:
        action = dialog.findChild(QAction, action)
    try:
        action.setChecked(enabled)
    except RuntimeError:
        pass


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
        tools_log.log_info(expr_filter)
    expr = QgsExpression(expr_filter)
    if expr.hasParserError():
        message = "Expression Error"
        tools_log.log_warning(message, parameter=expr_filter)
        return False, expr

    return True, expr


def fill_table(widget, table_name, expr_filter=None, set_edit_strategy=QSqlTableModel.OnManualSubmit):
    """ Set a model with selected filter.
    Attach that model to selected table """

    if global_vars.schema_name not in table_name:
        table_name = global_vars.schema_name + "." + table_name

    # Set model
    model = QSqlTableModel(db=global_vars.session_vars['db'])
    model.setTable(table_name)
    model.setEditStrategy(set_edit_strategy)
    model.setSort(0, 0)
    model.select()

    # Check for errors
    if model.lastError().isValid():
        tools_log(f"fill_table: {model.lastError().text()}")

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


def set_lazy_init(widget, lazy_widget=None, lazy_init_function=None):
    """Apply the init function related to the model. It's necessary
    a lazy init because model is changed everytime is loaded."""

    if lazy_widget is None:
        return
    if widget != lazy_widget:
        return
    lazy_init_function(lazy_widget)


def fill_table_object(widget, table_name, expr_filter=None):
    """ Set a model with selected filter. Attach that model to selected table """

    if global_vars.schema_name not in table_name:
        table_name = global_vars.schema_name + "." + table_name

    # Set model
    model = QSqlTableModel(db=global_vars.session_vars['db'])
    model.setTable(table_name)
    model.setEditStrategy(QSqlTableModel.OnManualSubmit)
    model.sort(0, 1)
    if expr_filter:
        model.setFilter(expr_filter)
    model.select()

    # Check for errors
    if model.lastError().isValid():
        tools_log(f"fill_table_object: {model.lastError().text()}")

    # Attach model to table view
    widget.setModel(model)


def filter_by_id(dialog, widget_table, widget_txt, table_object):

    field_object_id = "id"
    if table_object == "element":
        field_object_id = table_object + "_id"
    object_id = get_text(dialog, widget_txt)
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


def set_model_to_table(widget, table_name, expr_filter=None, edit_strategy=QSqlTableModel.OnManualSubmit):
    """ Set a model with selected filter.
    Attach that model to selected table """

    if global_vars.schema_name not in table_name:
        table_name = global_vars.schema_name + "." + table_name

    # Set model
    model = QSqlTableModel(db=global_vars.session_vars['db'])
    model.setTable(table_name)
    model.setEditStrategy(edit_strategy)
    if expr_filter:
        model.setFilter(expr_filter)
    model.select()

    # Check for errors
    if model.lastError().isValid():
        tools_log(f"set_model_to_table: {model.lastError().text()}")

    # Attach model to table view
    if widget:
        widget.setModel(model)
    else:
        tools_log.log_info("set_model_to_table: widget not found")


def get_folder_path(dialog, widget):
    """ Get folder path """

    # Check if selected folder exists. Set default value if necessary
    folder_path = get_text(dialog, widget)
    if folder_path is None or folder_path == 'null' or not os.path.exists(folder_path):
        folder_path = os.path.expanduser("~")

    # Open dialog to select folder
    os.chdir(folder_path)
    file_dialog = QFileDialog()
    file_dialog.setFileMode(QFileDialog.Directory)
    message = "Select folder"
    folder_path = file_dialog.getExistingDirectory(
        parent=None, caption=tr(message, aux_context='ui_message'), directory=folder_path)
    if folder_path:
        set_widget_text(dialog, widget, str(folder_path))


def hide_void_groupbox(dialog):
    """ Rceives a dialog, searches it all the QGroupBox, looks 1 to 1 if the grb have widgets, if it does not have
     (if it is empty), hides the QGroupBox
    :param dialog: QDialog or QMainWindow
    :return: Dictionario with names of hidden QGroupBox
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


def set_completer_rows(widget, rows):
    """ Set a completer into a widget
    :param widget: Object where to set the completer (QLineEdit)
    :param rows: rows to set into the completer (List)["item1","item2","..."]
    """

    if rows is None:
        return

    list_values = []
    for row in rows:
        list_values.append(str(row[0]))

    # Set completer and model: add autocomplete in the widget
    completer = QCompleter()
    completer.setCaseSensitivity(Qt.CaseInsensitive)
    widget.setCompleter(completer)
    model = QStringListModel()
    model.setStringList(list_values)
    completer.setModel(model)


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
        combo.currentIndexChanged.connect(partial(set_status, combo, qtable, x, widget_pos))


def set_status(qtable, combo, pos_x, combo_pos, col_update):
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


def document_open(qtable, field_name):
    """ Open selected document """

    message = None

    # Get selected rows
    field_index = qtable.model().fieldIndex(field_name)
    selected_list = qtable.selectionModel().selectedRows(field_index)
    if not selected_list:
        message = "Any record selected"
    elif len(selected_list) > 1:
        message = "More then one document selected. Select just one document."

    if message:
        tools_qgis.show_warning(message)
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


def delete_rows_qtv(qtable):
    """ Delete record from selected rows in a QTableView """

    # Get selected rows. 0 is the column of the pk 0 'id'
    selected_list = qtable.selectionModel().selectedRows(0)
    if len(selected_list) == 0:
        message = "Any record selected"
        show_info_box(message)
        return

    selected_id = []
    for index in selected_list:
        doc_id = index.data()
        selected_id.append(str(doc_id))
    message = "Are you sure you want to delete these records?"
    title = "Delete records"
    answer = ask_question(message, title, ','.join(selected_id))
    if answer:
        # Get current editStrategy
        edit_strategy = qtable.model().editStrategy()

        qtable.model().setEditStrategy(QSqlTableModel.OnManualSubmit)
        for model_index in qtable.selectionModel().selectedRows():
            index = QPersistentModelIndex(model_index)
            qtable.model().removeRow(index.row())
        status = qtable.model().submitAll()
        qtable.model().select()
        
        # Return original editStrategy
        qtable.model().setEditStrategy(edit_strategy)

        if not status:
            error = qtable.model().lastError().text()
            message = "Error deleting data"
            tools_qgis.show_warning(message, parameter=error)
        else:
            msg = "Record deleted"
            tools_qgis.show_info(msg)
            qtable.model().select()


def reset_model(dialog, table_object, geom_type):
    """ Reset model of the widget """

    table_relation = f"{table_object}_x_{geom_type}"
    widget_name = f"tbl_{table_relation}"
    widget = get_widget(dialog, widget_name)
    if widget:
        widget.setModel(None)


def fill_table_by_expr(qtable, table_name, expr):
    """
    :param qtable: QTableView to show
    :param expr: expression to set model
    """

    if global_vars.schema_name not in table_name:
        table_name = global_vars.schema_name + "." + table_name

    model = QSqlTableModel(db=global_vars.session_vars['db'])
    model.setTable(table_name)
    model.setFilter(expr)
    model.setEditStrategy(QSqlTableModel.OnFieldChange)
    qtable.setEditTriggers(QTableView.DoubleClicked)
    model.select()
    qtable.setModel(model)
    qtable.show()

    # Check for errors
    message = None
    if model.lastError().isValid():
        message = model.lastError().text()

    return message


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


def show_details(detail_text, title=None, inf_text=None):
    """ Shows a message box with detail information """

    global_vars.iface.messageBar().clearWidgets()
    msg_box = QMessageBox()
    msg_box.setText(detail_text)
    if title:
        title = tr(title, aux_context='ui_message')
        msg_box.setWindowTitle(title)
    if inf_text:
        inf_text = tr(inf_text, aux_context='ui_message')
        msg_box.setInformativeText(inf_text)
    msg_box.setWindowFlags(Qt.WindowStaysOnTopHint)
    msg_box.setStandardButtons(QMessageBox.Ok)
    msg_box.setDefaultButton(QMessageBox.Ok)
    msg_box.exec_()


def show_warning_open_file(text, inf_text, file_path, context_name=None):
    """ Show warning message with a button to open @file_path """

    widget = global_vars.iface.messageBar().createMessage(tr(text, context_name, aux_context='ui_message'),
                                                          tr(inf_text, aux_context='ui_message'))
    button = QPushButton(widget)
    button.setText(tr("Open file", aux_context='ui_message'))
    button.clicked.connect(partial(tools_os.open_file, file_path))
    widget.layout().addWidget(button)
    global_vars.iface.messageBar().pushWidget(widget, 1)


def ask_question(text, title=None, inf_text=None, context_name=None, parameter=None):
    """ Ask question to the user """

    msg_box = QMessageBox()
    msg = tr(text, context_name, aux_context='ui_message')
    if parameter:
        msg += ": " + str(parameter)
    msg_box.setText(msg)
    if title:
        title = tr(title, context_name, aux_context='ui_message')
        msg_box.setWindowTitle(title)
    if inf_text:
        inf_text = tr(inf_text, context_name, aux_context='ui_message')
        msg_box.setInformativeText(inf_text)
    msg_box.setStandardButtons(QMessageBox.Cancel | QMessageBox.Ok)
    msg_box.setDefaultButton(QMessageBox.Ok)
    msg_box.setWindowFlags(Qt.WindowStaysOnTopHint)
    ret = msg_box.exec_()
    if ret == QMessageBox.Ok:
        return True
    elif ret == QMessageBox.Discard:
        return False


def show_info_box(text, title=None, inf_text=None, context_name=None, parameter=None):
    """ Show information box to the user """

    msg = ""
    if text:
        msg = tr(text, context_name, aux_context='ui_message')
        if parameter:
            msg += ": " + str(parameter)

    msg_box = QMessageBox()
    msg_box.setText(msg)
    msg_box.setWindowFlags(Qt.WindowStaysOnTopHint)
    if title:
        title = tr(title, context_name, aux_context='ui_message')
        msg_box.setWindowTitle(title)
    if inf_text:
        inf_text = tr(inf_text, context_name, aux_context='ui_message')
        msg_box.setInformativeText(inf_text)
    msg_box.setDefaultButton(QMessageBox.No)
    msg_box.exec_()


def set_text_bold(widget, pattern):
    """ Set bold text when word match with pattern
    :param widget: QTextEdit
    :param pattern: Text to find used as pattern for QRegExp (String)
    :return:
    """

    cursor = widget.textCursor()
    format = QTextCharFormat()
    format.setFontWeight(QFont.Bold)
    regex = QRegExp(pattern)
    pos = 0
    index = regex.indexIn(widget.toPlainText(), pos)
    while index != -1:
        # Set cursor at begin of match
        cursor.setPosition(index, 0)
        pos = index + regex.matchedLength()
        # Set cursor at end of match
        cursor.setPosition(pos, 1)
        # Select the matched text and apply the desired format
        cursor.mergeCharFormat(format)
        # Move to the next match
        index = regex.indexIn(widget.toPlainText(), pos)


def set_stylesheet(widget, style="border: 2px solid red"):
    widget.setStyleSheet(style)


def tr(message, context_name=None, aux_context=None):
    """ Translate @message looking it in @context_name """

    if context_name is None:
        context_name = global_vars.plugin_name

    value = None
    try:
        value = QCoreApplication.translate(context_name, message)
    except TypeError:
        value = QCoreApplication.translate(context_name, str(message))
    finally:
        # If not translation has been found, check into 'ui_message' context
        if value == message:
            value = QCoreApplication.translate(aux_context, message)

    return value


def manage_translation(context_name, dialog=None, log_info=False):
    """ Manage locale and corresponding 'i18n' file """

    # Get locale of QGIS application
    try:
        locale = QSettings().value('locale/userLocale').lower()
    except AttributeError:
        locale = "en"

    locales = {'en': 'en','en_us': 'en', 'es':'es', 'es_es': 'es', 'es_ca': 'ca'}

    # If user locale file not found, set English one by default
    locale_path = os.path.join(global_vars.plugin_dir, 'i18n', f'{global_vars.plugin_name}_{locales.get(locale,"en")}.qm')
    if not os.path.exists(locale_path):
        if log_info:
            tools_log.log_info("Locale not found", parameter=locale_path)
        locale_default = 'en'
        locale_path = os.path.join(global_vars.plugin_dir, 'i18n', f'{global_vars.plugin_name}_{locale_default}.qm')
        # If English locale file not found, exit function
        # It means that probably that form has not been translated yet
        if not os.path.exists(locale_path):
            if log_info:
                tools_log.log_info("Locale not found", parameter=locale_path)
            return

    # Add translation file
    add_translator(locale_path)

    # If dialog is set, then translate form
    if dialog:
        translate_form(dialog, context_name)


def add_translator(locale_path, log_info=False):
    """ Add translation file to the list of translation files to be used for translations """

    if os.path.exists(locale_path):
        translator.load(locale_path)
        QCoreApplication.installTranslator(translator)
        if log_info:
            tools_log.log_info("Add translator", parameter=locale_path)
    else:
        if log_info:
            tools_log.log_info("Locale not found", parameter=locale_path)


def translate_form(dialog, context_name, aux_context='ui_message'):
    """ Translate widgets of the form to current language """

    type_widget_list = [QCheckBox, QGroupBox, QLabel, QPushButton, QRadioButton, QTabWidget]
    for widget_type in type_widget_list:
        widget_list = dialog.findChildren(widget_type)
        for widget in widget_list:
            translate_widget(context_name, widget)

    # Translate title of the form
    text = tr('title', context_name, aux_context=aux_context)
    if text != 'title':
        dialog.setWindowTitle(text)


def translate_widget(context_name, widget, aux_context='ui_message'):
    """ Translate widget text """

    if not widget:
        return

    widget_name = ""
    try:
        if type(widget) is QTabWidget:
            num_tabs = widget.count()
            for i in range(0, num_tabs):
                widget_name = widget.widget(i).objectName()
                text = tr(widget_name, context_name, aux_context=aux_context)
                if text not in (widget_name, None, 'None'):
                    widget.setTabText(i, text)
                else:
                    widget_text = widget.tabText(i)
                    text = tr(widget_text, context_name, aux_context=aux_context)
                    if text != widget_text:
                        widget.setTabText(i, text)
                translate_tooltip(context_name, widget, i)
        elif type(widget) is QToolBox:
            num_tabs = widget.count()
            for i in range(0, num_tabs):
                widget_name = widget.widget(i).objectName()
                text = tr(widget_name, context_name, aux_context=aux_context)
                if text not in (widget_name, None, 'None'):
                    widget.setItemText(i, text)
                else:
                    widget_text = widget.itemText(i)
                    text = tr(widget_text, context_name, aux_context=aux_context)
                    if text != widget_text:
                        widget.setItemText(i, text)
                translate_tooltip(context_name, widget.widget(i))
        elif type(widget) is QGroupBox:
            widget_name = widget.objectName()
            text = tr(widget_name, context_name, aux_context=aux_context)
            if text not in (widget_name, None, 'None'):
                widget.setTitle(text)
            else:
                widget_title = widget.title()
                text = tr(widget_title, context_name, aux_context=aux_context)
                if text != widget_title:
                    widget.setTitle(text)
            translate_tooltip(context_name, widget)
        else:
            widget_name = widget.objectName()
            text = tr(widget_name, context_name, aux_context=aux_context)
            if text not in (widget_name, None, 'None'):
                widget.setText(text)
            else:
                widget_text = widget.text()
                text = tr(widget_text, context_name, aux_context=aux_context)
                if text != widget_text:
                    widget.setText(text)
            translate_tooltip(context_name, widget)

    except Exception as e:
        tools_log.log_info(f"{widget_name} --> {type(e).__name__} --> {e}")


def translate_tooltip(context_name, widget, idx=None, aux_context='ui_message'):
    """ Translate tooltips widgets of the form to current language
        If we find a translation, it will be put
        If the object does not have a tooltip we will put the object text itself as a tooltip
    """

    if type(widget) is QTabWidget:
        widget_name = widget.widget(idx).objectName()
        tooltip = tr(f'tooltip_{widget_name}', context_name, aux_context=aux_context)
        if tooltip not in (f'tooltip_{widget_name}', None, 'None'):
            widget.setTabToolTip(idx, tooltip)
        elif widget.toolTip() in ("", None):
            widget.setTabToolTip(idx, widget.tabText(idx))
    else:
        widget_name = widget.objectName()
        tooltip = tr(f'tooltip_{widget_name}', context_name, aux_context=aux_context)
        if tooltip not in (f'tooltip_{widget_name}', None, 'None'):
            widget.setToolTip(tooltip)
        elif widget.toolTip() in ("", None):
            if type(widget) is QGroupBox:
                widget.setToolTip(widget.title())
            else:
                widget.setToolTip(widget.text())


def manage_exception_db(exception=None, sql=None, stack_level=2, stack_level_increase=0, filepath=None,
                        schema_name=None):
    """ Manage exception in database queries and show information to the user """
    show_exception_msg = True
    description = ""
    if exception:
        description = str(exception)
        if 'unknown error' in description:
            show_exception_msg = False

    try:
        stack_level += stack_level_increase
        module_path = inspect.stack()[stack_level][1]
        file_name = tools_os.get_relative_path(module_path, 2)
        function_line = inspect.stack()[stack_level][2]
        function_name = inspect.stack()[stack_level][3]

        # Set exception message details
        msg = ""
        msg += f"File name: {file_name}\n"
        msg += f"Function name: {function_name}\n"
        msg += f"Line number: {function_line}\n"
        if exception:
            msg += f"Description:\n{description}\n"
        if filepath:
            msg += f"SQL file:\n{filepath}\n\n"
        if sql:
            msg += f"SQL:\n {sql}\n\n"
        msg += f"Schema name: {schema_name}"

        # Show exception message in dialog and log it
        if show_exception_msg:
            title = "Database error"
            show_exceptions_msg(title, msg)
        else:
            tools_log.log_warning("Exception message not shown to user")
        tools_log.log_warning(msg, stack_level_increase=2)

    except Exception:
        manage_exception("Unhandled Error")


def show_exceptions_msg(title=None, msg="", window_title="Information about exception", pattern=None):
    """ Show exception message in dialog """

    global_vars.session_vars['dlg_info'] = DialogTextUi()
    global_vars.session_vars['dlg_info'].btn_accept.setVisible(False)
    global_vars.session_vars['dlg_info'].btn_close.clicked.connect(lambda: global_vars.session_vars['dlg_info'].close())
    global_vars.session_vars['dlg_info'].setWindowTitle(window_title)
    if title:
        global_vars.session_vars['dlg_info'].lbl_text.setText(title)
    set_widget_text(global_vars.session_vars['dlg_info'], global_vars.session_vars['dlg_info'].txt_infolog, msg)
    global_vars.session_vars['dlg_info'].setWindowFlags(Qt.WindowStaysOnTopHint)
    if pattern is None:
        pattern = "File\sname:|Function\sname:|Line\snumber:|SQL:|SQL\sfile:|Detail:|Context:|Description|Schema name"
    set_text_bold(global_vars.session_vars['dlg_info'].txt_infolog, pattern)

    # Show dialog only if we are not in a task process
    if global_vars.session_vars['show_db_exception']:
        global_vars.session_vars['dlg_info'].show()


def manage_exception(title=None, description=None, sql=None, schema_name=None):
    """ Manage exception and show information to the user """

    # Get traceback
    trace = traceback.format_exc()
    exc_type, exc_obj, exc_tb = sys.exc_info()
    path = exc_tb.tb_frame.f_code.co_filename
    file_name = os.path.split(path)[1]
    #folder_name = os.path.dirname(path)

    # Set exception message details
    msg = ""
    msg += f"Error type: {exc_type}\n"
    msg += f"File name: {file_name}\n"
    msg += f"Line number: {exc_tb.tb_lineno}\n"
    msg += f"{trace}\n"
    if description:
        msg += f"Description: {description}\n"
    if sql:
        msg += f"SQL:\n {sql}\n\n"
    msg += f"Schema name: {schema_name}"

    # Show exception message in dialog and log it
    show_exceptions_msg(title, msg)
    tools_log.log_warning(msg)

    # Log exception message
    tools_log.log_warning(msg)

    # Show exception message only if we are not in a task process
    if global_vars.session_vars['show_db_exception']:
        show_exceptions_msg(title, msg)


def populate_cmb_unicodes(combo):
    """ Populate combo with full list of codes """

    unicode_list = []
    sorted_list = None
    for item in list(aliases.items()):
        unicode_list.append(str(item[0]))
        sorted_list = sorted(unicode_list, key=str.lower)

    if sorted_list:
        set_autocompleter(combo, sorted_list)


def set_table_model(dialog, table_object, table_name, expr_filter):
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

    if global_vars.schema_name not in table_name:
        table_name = global_vars.schema_name + "." + table_name

    # Set the model
    model = QSqlTableModel(db=global_vars.session_vars['db'])
    model.setTable(table_name)
    model.setEditStrategy(QSqlTableModel.OnManualSubmit)
    model.select()
    if model.lastError().isValid():
        tools_qgis.show_warning(model.lastError().text())
        return expr

    # Attach model to selected widget
    if type(table_object) is str:
        widget = get_widget(dialog, table_object)
        if not widget:
            message = "Widget not found"
            tools_log.log_info(message, parameter=table_object)
            return expr
    elif type(table_object) is QTableView:
        widget = table_object
    else:
        msg = "Table_object is not a table name or QTableView"
        tools_log.log_info(msg)
        return expr

    if expr_filter:
        widget.setModel(model)
        widget.model().setFilter(expr_filter)
        widget.model().select()
    else:
        widget.setModel(None)

    return expr
