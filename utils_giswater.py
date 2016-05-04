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
    widget.clear()
    if allow_nulls:
        widget.addItem('')     
    for row in rows:
        widget.addItem(row[0])    
        
        
def getStringValue(widget_name):
    elem = _dialog.findChild(QLineEdit, widget_name)
    if elem:    
        if elem.text():
            elem_text = widget_name + " = '"+elem.text()+"'"
        else:
            elem_text = widget_name + " = null"
    else:
        elem_text = widget_name + " = null"
    return elem_text


def getStringValue2(widget_name):
    elem = _dialog.findChild(QLineEdit, widget_name)
    if elem:
        if elem.text():
            elem_text = "'"+elem.text()+"'"
        else:
            elem_text = "null"
    else:
        elem_text = "null"
    return elem_text      


def setText(widget_name, text):
    elem = _dialog.findChild(QWidget, widget_name)   
    if not elem:
        return    
    value = unicode(text)
    if value == 'None':    
        elem.setText("")         
    else:
        elem.setText(value)     


def setSelectedItem(widget_name, value):  
    widget = _dialog.findChild(QComboBox, widget_name)
    if widget:
        index = widget.findText(value)
        if index == -1:
            index = 0
        widget.setCurrentIndex(index);        


def getSelectedItem(widget_name):
    widget_text = "null"    
    widget = _dialog.findChild(QComboBox, widget_name)
    if widget:
        if widget.currentText():
            widget_text = widget.currentText()    
    return widget_text    


def isNull(widget_name):
    elem = _dialog.findChild(QLineEdit, widget_name)
    empty = True    
    if elem:    
        if elem.text():
            empty = False
    return empty    


def setWidgetVisible(widget_name, visible=True):
    elem = _dialog.findChild(QWidget, widget_name)        
    if elem:
        elem.setVisible(visible)


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

