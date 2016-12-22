# -*- coding: utf-8 -*-
"""
/***************************************************************************
 *                                                                         *
 *   This file is part of Giswater 2.0                                     *                                 *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 3 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
"""

''' Module with utility functions to interact with dialog and its widgets '''
from PyQt4.QtGui import QLineEdit, QComboBox, QWidget, QDoubleSpinBox, QCheckBox   #@UnresolvedImport

import inspect


def setDialog(p_dialog):
    global _dialog
    _dialog = p_dialog
 

def fillComboBox(widget, rows, allow_nulls=True):
    
    if type(widget) is str:
        widget = _dialog.findChild(QComboBox, widget)        
    widget.clear()
    if allow_nulls:
        widget.addItem('')     
    for row in rows:       
        elem = row[0]
        if isinstance(elem, int) or isinstance(elem, float):
            widget.addItem(str(elem))
        else:
            widget.addItem(elem)
        
        
def fillComboBoxDict(widget, dict_object, dict_field, allow_nulls=True):

    if type(widget) is str:
        widget = _dialog.findChild(QComboBox, widget)    
    if widget is None:
        print "Combo not found: "+str(widget)
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


def getText(widget):
    
    if type(widget) is str:
        widget = _dialog.findChild(QWidget, widget)          
    if widget:
        if widget.text():
            elem_text = widget.text()
        else:
            elem_text = "null"
    else:
        elem_text = "null"
    return elem_text      


def setText(widget, text):
    
    if type(widget) is str:
        widget = _dialog.findChild(QWidget, widget)      
    if not widget:
        return    
    
    value = unicode(text)
    if type(widget) is QLineEdit: 
        if value == 'None':    
            value = ""        
        widget.setText(value)       
    elif type(widget) is QDoubleSpinBox: 
        if value == 'None':    
            value = 0        
        widget.setValue(float(value))     
          

def getWidgetType(widget):
    
    if type(widget) is str:
        widget = _dialog.findChild(QWidget, widget)      
    if not widget:
        return None   
    return type(widget)


def getWidgetText(widget, add_quote=False):
    
    if type(widget) is str:
        widget = _dialog.findChild(QWidget, widget)      
    if not widget:
        return None   
    text = None
    if type(widget) is QLineEdit:
        text = getText(widget)
    elif type(widget) is QDoubleSpinBox:
        text = getText(widget)        
    elif type(widget) is QComboBox:
        text = getSelectedItem(widget)
    if add_quote and text <> "null":
        text = "'"+text+"'"  
    return text


def setWidgetText(widget, text):
    
    if type(widget) is str:
        widget = _dialog.findChild(QWidget, widget)       
    if not widget:
        return
    if type(widget) is QLineEdit:
        setText(widget, text)
    elif type(widget) is QDoubleSpinBox:
        setText(widget, text)           
    elif type(widget) is QComboBox:
        setSelectedItem(widget, text)


def isChecked(widget):
    
    if type(widget) is str:
        widget = _dialog.findChild(QCheckBox, widget)        
    checked = False    
    if widget:
        checked = widget.isChecked()       
    return checked    


def setChecked(widget, checked):
    
    if type(widget) is str:
        widget = _dialog.findChild(QWidget, widget)       
    if not widget:
        return
    if type(widget) is QCheckBox:
        widget.setChecked(bool(checked))


def getSelectedItem(widget):
    
    if type(widget) is str:
        widget = _dialog.findChild(QComboBox, widget)        
    widget_text = "null"    
    if widget:
        if widget.currentText():
            widget_text = widget.currentText()       
    return widget_text    


def setSelectedItem(widget, text):

    if type(widget) is str:
        widget = _dialog.findChild(QComboBox, widget)    
    if widget:
        index = widget.findText(text)
        if index == -1:
            index = 0
        widget.setCurrentIndex(index);        


def setCurrentIndex(widget, index):

    if type(widget) is str:
        widget = _dialog.findChild(QComboBox, widget)    
    if widget:
        if index == -1:
            index = 0        
        widget.setCurrentIndex(index);        


def isNull(widget):

    if type(widget) is str:
        widget = _dialog.findChild(QLineEdit, widget)    
    empty = True    
    if widget:    
        if widget.text():
            empty = False
    return empty    


def setWidgetVisible(widget, visible=True):

    if type(widget) is str:
        widget = _dialog.findChild(QWidget, widget)    
    if widget:
        widget.setVisible(visible)
                
                