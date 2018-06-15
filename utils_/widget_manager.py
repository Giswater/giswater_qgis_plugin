"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
""" Module with utility functions to interact with dialog and its widgets """
from qgis.gui import QgsDateTimeEdit
from PyQt4.QtGui import QLineEdit, QComboBox, QWidget, QDoubleSpinBox, QCheckBox, QLabel, QTextEdit, QDateEdit, QSpinBox, QTimeEdit
from PyQt4.QtGui import QSortFilterProxyModel,  QDateTimeEdit
from PyQt4.Qt import QDate, QDateTime

from functools import partial


class WidgetManager:

    def __init__(self, dlg):
        self.setDialog(dlg)

    def getDialog(self):
        return self.dialog

    def setDialog(self, dlg):
        self.dialog = dlg

    def setCalendarDate(self, widget, date, default_current_date=True):

        if type(widget) is str or type(widget) is unicode:
            widget = self.dialog.findChild(QWidget, widget)
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

    def getWidgetText(self, widget, add_quote=False, return_string_null=True):

        if type(widget) is str or type(widget) is unicode:
            widget = self.dialog.findChild(QWidget, widget)
        if not widget:
            return None
        text = None
        if type(widget) is QLineEdit or type(widget) is QTextEdit or type(widget) is QDoubleSpinBox or type(
                widget) is QSpinBox:
            text = self.getText(widget, return_string_null)
        elif type(widget) is QComboBox:
            text = self.getSelectedItem(widget, return_string_null)
        if add_quote and text <> "null":
            text = "'" + text + "'"
        return text

    def getText(self, widget, return_string_null=True):

        if type(widget) is str or type(widget) is unicode:
            widget = self.dialog.findChild(QWidget, widget)
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

    def getSelectedItem(self, widget, return_string_null=True):

        if type(widget) is str or type(widget) is unicode:
            widget = self.dialog.findChild(QComboBox, widget)
        if return_string_null:
            widget_text = "null"
        else:
            widget_text = ""
        if widget:
            if widget.currentText():
                widget_text = widget.currentText()
        return widget_text

    def fillComboBox(self, widget, rows, allow_nulls=True, clear_combo=True):

        if rows is None:
            return
        if type(widget) is str or type(widget) is unicode:
            widget = self.dialog.findChild(QComboBox, widget)
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



