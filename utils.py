# -*- coding: utf-8 -*-
from PyQt4.QtGui import QLineEdit, QComboBox
from qgis.gui import QgsMessageBar

#    
# Utility funcions    
#
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


def setCursor(p_cursor):
    
    global cursor
    cursor = p_cursor


def fillComboBox(widget, rows):
    widget.clear()
    widget.addItem('')     
    for row in rows:
        widget.addItem(row[0])    


def setSelectedItem(combo, row):  
    elem = _dialog.findChild(QComboBox, combo)
    if elem:
        index = elem.findText(row[0])
        elem.setCurrentIndex(index);        


def getSelectedItem(param_elem):
    
    elem = _dialog.findChild(QComboBox, param_elem)
    if not elem.currentText():
        elem_text = "null"
    else:
        elem_text = "'"+elem.currentText()+"'"    
    elem_text = param_elem+"="+elem_text
    return elem_text    


def getValue(param_elem):
    
    elem = _dialog.findChild(QLineEdit, param_elem)
    if elem:    
        if elem.text():
            elem_text = param_elem + " = "+elem.text().replace(",", ".")              
        else:
            elem_text = param_elem + " = null"
    else:
        elem_text = param_elem + " = null"
    return elem_text


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


