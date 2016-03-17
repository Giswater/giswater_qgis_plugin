# -*- coding: utf-8 -*-
from PyQt4.QtGui import QLineEdit, QComboBox
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


def fillComboBox(widget, rows):
    widget.clear()
    widget.addItem('')     
    for row in rows:
        widget.addItem(row[0])    


def setSelectedItem(widget_name, value):  
    widget = _dialog.findChild(QComboBox, widget_name)
    if widget:
        index = widget.findText(value)
        widget.setCurrentIndex(index);        


def getSelectedItem(widget_name):
    
    widget_text = "null"    
    widget = _dialog.findChild(QComboBox, widget_name)
    if widget:
        if widget.currentText():
            widget_text = widget.currentText()    
    return widget_text    


def isNull(param_elem):
    
    elem = _dialog.findChild(QLineEdit, param_elem)
    empty = True    
    if elem:    
        if elem.text():
            empty = False
    return empty    


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


