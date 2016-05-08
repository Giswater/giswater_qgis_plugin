# -*- coding: utf-8 -*-
from PyQt4.QtGui import QLineEdit, QComboBox, QWidget
from PyQt4.QtCore import *   # @UnusedWildImport
from qgis.gui import QgsMessageBar


#    
# Utility funcions    
#
def tr(context, message):
    return QCoreApplication.translate(context, message)


def setDialog(p_dialog):
    global _dialog
    _dialog = p_dialog
 
         
def setInterface(p_iface):
    global _iface, MSG_DURATION
    _iface = p_iface
    MSG_DURATION = 5        
 
    
def isFirstTime():
    global first
    if not 'first' in globals():
        first = True
    else:    
        first = False
    return first


def fillComboBox(widget, rows, allow_nulls=True):
    
    if type(widget) is str:
        widget = _dialog.findChild(QComboBox, widget)        
    widget.clear()
    if allow_nulls:
        widget.addItem('')     
    for row in rows:
        widget.addItem(row[0])    
        
        
def getStringValue(widget):
    
    if type(widget) is str:
        widget = _dialog.findChild(QLineEdit, widget)        
    widget_name = widget.objectName()
    if widget:    
        if widget.text():
            elem_text = widget_name + " = '"+widget.text()+"'"
        else:
            elem_text = widget_name + " = null"
    else:
        elem_text = widget_name + " = null"
    return elem_text


def getStringValue2(widget):
    
    if type(widget) is str:
        widget = _dialog.findChild(QLineEdit, widget)          
    if widget:
        if widget.text():
            elem_text = "'"+widget.text()+"'"
        else:
            elem_text = "null"
    else:
        elem_text = "null"
    return elem_text      


def getText(widget):
    
    if type(widget) is str:
        widget = _dialog.findChild(QLineEdit, widget)          
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
    if value == 'None':    
        widget.setText("")         
    else:
        widget.setText(value)     


def getWidgetText(widget, add_quote=False):
    
    if type(widget) is str:
        widget = _dialog.findChild(QWidget, widget)      
    if not widget:
        return None   
    text = None
    if type(widget) is QLineEdit:
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
    elif type(widget) is QComboBox:
        setSelectedItem(widget, text)


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


def showInfo(text, duration = None):
    if duration is None:
        _iface.messageBar().pushMessage("", text, QgsMessageBar.INFO, MSG_DURATION)  
    else:
        _iface.messageBar().pushMessage("", text, QgsMessageBar.INFO, duration)              
    
    
def showWarning(text, duration = None):
    if duration is None:
        _iface.messageBar().pushMessage("", text, QgsMessageBar.WARNING, MSG_DURATION)  
    else:
        _iface.messageBar().pushMessage("", text, QgsMessageBar.WARNING, duration)   

