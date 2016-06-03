# -*- coding: utf-8 -*-
# 2To3 python compatibility
from __future__ import print_function
from __future__ import unicode_literals

from PyQt4 import QtCore, QtGui


class SearchableComboBox(QtGui.QComboBox):


    def __init__(self, parent=None, **kwargs):
    
        QtGui.QComboBox.__init__(self, parent, editable=True, focusPolicy=QtCore.Qt.StrongFocus, **kwargs)

        self._proxy=QtGui.QSortFilterProxyModel(self, filterCaseSensitivity=QtCore.Qt.CaseInsensitive)
        self._proxy.setSourceModel(self.model())
 
        self._completer=QtGui.QCompleter(
            self._proxy,
            self,
            activated=self.onCompleterActivated
        )
        self._completer.setCompletionMode(QtGui.QCompleter.UnfilteredPopupCompletion)
        self.setCompleter(self._completer)
 
        self.lineEdit().textEdited.connect(self._proxy.setFilterFixedString)
 
 
    @QtCore.pyqtSlot(str)
    def onCompleterActivated(self, text):
        if not text: return
        self.setCurrentIndex(self.findText(text))
        self.activated[str].emit(self.currentText())
        
        