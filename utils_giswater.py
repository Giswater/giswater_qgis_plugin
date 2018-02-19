'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

''' Module with utility functions to interact with dialog and its widgets '''
from PyQt4.QtGui import QLineEdit, QComboBox, QWidget, QPixmap, QDoubleSpinBox, QCheckBox, QLabel, QTextEdit, QDateEdit, QSpinBox, QTimeEdit
from PyQt4.QtGui import QAbstractItemView, QCompleter, QSortFilterProxyModel, QStringListModel, QDateTimeEdit
from PyQt4.Qt import QDate, QDateTime
from PyQt4.QtCore import QTime
from qgis.gui import QgsDateTimeEdit

from functools import partial
import inspect
import os
import sys 
if 'nt' in sys.builtin_module_names: 
    import _winreg 


def setDialog(p_dialog):
    global _dialog
    _dialog = p_dialog


def dialog():
    return _dialog


def fillComboBox(widget, rows, allow_nulls=True, clear_combo=True):

    if rows is None:
        return
    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QComboBox, widget)        
    if clear_combo:
        widget.clear()
    if allow_nulls:
        widget.addItem('')
    for row in rows:
        if len(row) > 1:
            elem = row[0][0]
            userData = row[1]
        else:
            elem = row[0]
            userData = None
        if elem:
            try:
                if isinstance(elem, int) or isinstance(elem, float):
                    widget.addItem(str(elem), userData)
                else:
                    widget.addItem(elem, userData)
            except:
                widget.addItem(str(elem), userData)
                
                
def fillComboBoxDict(widget, dict_object, dict_field, allow_nulls=True):

    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QComboBox, widget)    
    if widget is None:
        return None

    # Populate combo with values stored in dictionary variable
    if allow_nulls:
        widget.addItem('') 
    for key, value in dict_object.iteritems():   # @UnusedVariable 
        # Get variables of selected objects
        # Search for the one specified in parameter <dict_field>
        aux = inspect.getmembers(value)
        for elem in aux:
            if elem[0] == dict_field:
                widget.addItem(elem[1])          
        
        
def fillComboBoxList(widget, list_object, allow_nulls=True, clear_combo=True):

    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QComboBox, widget)    
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
            

def getText(widget, return_string_null=True):
    
    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QWidget, widget)          
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


def setText(widget, text):
    
    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QWidget, widget)      
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


def getCalendarDate(widget, date_format = "yyyy/MM/dd", datetime_format = "yyyy/MM/dd hh:mm:ss"):
    
    date = None
    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QWidget, widget)
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
        

def setCalendarDate(widget, date, default_current_date=True):
    
    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QWidget, widget)
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


def setTimeEdit(widget, time):
    
    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QWidget, widget)
    if not widget:
        return
    if type(widget) is QTimeEdit:
        if time is None:
            time = QTime(00, 00, 00)
        widget.setTime(time)


def getWidget(widget):
    
    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QWidget, widget)  
    if not widget:
        return None           
    return widget    


def getWidgetType(widget):
    
    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QWidget, widget)
    if not widget:
        return None   
    return type(widget)


def getWidgetText(widget, add_quote=False, return_string_null=True):
    
    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QWidget, widget)      
    if not widget:
        return None   
    text = None
    if type(widget) is QLineEdit or type(widget) is QTextEdit or type(widget) is QDoubleSpinBox:
        text = getText(widget, return_string_null)    
    elif type(widget) is QComboBox:
        text = getSelectedItem(widget, return_string_null)
    if add_quote and text <> "null":
        text = "'"+text+"'"  
    return text


def setWidgetText(widget, text):
    
    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QWidget, widget)       
    if not widget:
        return
    if type(widget) is QLineEdit or type(widget) is QTextEdit or type(widget) is QTimeEdit or type(widget) is QLabel:
        setText(widget, text)
    elif type(widget) is QDoubleSpinBox:
        setText(widget, text)           
    elif type(widget) is QComboBox:
        setSelectedItem(widget, text)


def isChecked(widget):
    
    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QCheckBox, widget)        
    checked = False    
    if widget:
        checked = widget.isChecked()       
    return checked    


def setChecked(widget, checked=True):
    
    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QWidget, widget)       
    if not widget:
        return
    if type(widget) is QCheckBox:
        widget.setChecked(bool(checked))


def getSelectedItem(widget, return_string_null=True):
    
    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QComboBox, widget)        
    if return_string_null:
        widget_text = "null"   
    else:
        widget_text = "" 
    if widget:
        if widget.currentText():
            widget_text = widget.currentText()       
    return widget_text    


def setSelectedItem(widget, text):

    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QComboBox, widget)    
    if widget:
        index = widget.findText(str(text))
        if index == -1:
            index = 0
        widget.setCurrentIndex(index);        


def setCurrentIndex(widget, index):

    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QComboBox, widget)    
    if widget:
        if index == -1:
            index = 0        
        widget.setCurrentIndex(index);        


def isNull(widget):

    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QLineEdit, widget)    
    empty = True    
    if widget:    
        if widget.text():
            empty = False
    return empty    


def setWidgetVisible(widget, visible=True):

    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QWidget, widget)    
    if widget:
        widget.setVisible(visible)
        
        
def setWidgetEnabled(widget, enabled=True):

    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QWidget, widget)    
    if widget:
        widget.setEnabled(enabled)
                

def setImage(widget,cat_shape):
    ''' Set pictures for UD'''
    
    element = cat_shape.lower()
    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QWidget, widget)  
    if not widget:
        return
    if type(widget) is QLabel:
        plugin_dir = os.path.dirname(__file__)    
        pic_file = os.path.join(plugin_dir, 'png', ''+element+'')
        pixmap = QPixmap(pic_file)
        widget.setPixmap(pixmap)
        widget.show()  
        
        
def setRow(p_row):
    global _row
    _row = p_row
    
                        
def fillWidget(widget):
    
    key = widget
    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QWidget, widget)      
    if not widget:
        return    
    
    if key in _row: 
        if _row[key] is not None:
            value = unicode(_row[key])
            if type(widget) is QLineEdit or type(widget) is QTextEdit: 
                if value == 'None':    
                    value = ""        
                widget.setText(value)
        else:
            widget.setText("")       
    else:
        widget.setText("")


def set_combo_itemData(combo, value, item1, item2):
    """ Set text to combobox populate with more than 1 item for row
        @item1: element to compare
        @item2: element to show
    """
    for i in range(0, combo.count()):
        elem = combo.itemData(i)
        if value == elem[item1]:
            setWidgetText(combo, (elem[item2]))


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
    ''' Function that fix problem with network units in Windows '''
    
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


def set_table_selection_behavior(widget):
    """ Set selection behavior of @widget """
    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QWidget, widget)      
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


def get_item_data(widget, index=0):
    """ Get item data of current index of the @widget """
    
    code = -1
    if type(widget) is str or type(widget) is unicode:
        widget = _dialog.findChild(QWidget, widget)          
    if widget:
        if type(widget) is QComboBox:
            current_index = widget.currentIndex()     
            elem = widget.itemData(current_index)
            code = elem[index]            

    return code

