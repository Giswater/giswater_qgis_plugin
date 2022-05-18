"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

from qgis.PyQt import QtCore
from qgis.PyQt.QtWidgets import QStyledItemDelegate, QLineEdit


class ReadOnlyDelegate(QStyledItemDelegate):
    """ Item delegate for read-only fields """

    def editorEvent(self, *args, **kwargs):
        return False

    def createEditor(self, *args, **kwargs):
        return None


class EditableDelegate(QStyledItemDelegate):
    """ Item delegate for editable fields (can set null values) """

    def createEditor(self, parent, options, index):
        le = QLineEdit(parent)
        return le

    def setModelData(self, editor, model, index):
        value = editor.text()
        if not value:
            model.setData(index, None, QtCore.Qt.EditRole)
        else:
            try:
                number = float(value)
            except (TypeError, ValueError):
                model.setData(index, value, QtCore.Qt.EditRole)
            else:
                model.setData(index, number, QtCore.Qt.EditRole)
