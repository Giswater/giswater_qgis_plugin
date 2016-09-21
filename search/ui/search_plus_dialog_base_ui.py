# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'search_plus_dialog_base.ui'
#
# Created: Wed Sep 21 12:19:27 2016
#      by: PyQt4 UI code generator 4.11.3
#
# WARNING! All changes made in this file will be lost!

from PyQt4 import QtCore, QtGui

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    def _fromUtf8(s):
        return s

try:
    _encoding = QtGui.QApplication.UnicodeUTF8
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig, _encoding)
except AttributeError:
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig)

class Ui_searchPlusDockWidget(object):
    def setupUi(self, searchPlusDockWidget):
        searchPlusDockWidget.setObjectName(_fromUtf8("searchPlusDockWidget"))
        searchPlusDockWidget.resize(357, 179)
        self.tab_main = QtGui.QTabWidget(searchPlusDockWidget)
        self.tab_main.setGeometry(QtCore.QRect(10, 20, 331, 153))
        self.tab_main.setObjectName(_fromUtf8("tab_main"))
        self.tab_2 = QtGui.QWidget()
        self.tab_2.setObjectName(_fromUtf8("tab_2"))
        self.label_press_zone_2 = QtGui.QLabel(self.tab_2)
        self.label_press_zone_2.setGeometry(QtCore.QRect(15, 22, 55, 16))
        self.label_press_zone_2.setObjectName(_fromUtf8("label_press_zone_2"))
        self.urban_properties_pzone = SearchableComboBox(self.tab_2)
        self.urban_properties_pzone.setGeometry(QtCore.QRect(90, 20, 221, 20))
        self.urban_properties_pzone.setEditable(True)
        self.urban_properties_pzone.setObjectName(_fromUtf8("urban_properties_pzone"))
        self.label_number_2 = QtGui.QLabel(self.tab_2)
        self.label_number_2.setGeometry(QtCore.QRect(15, 90, 55, 16))
        self.label_number_2.setObjectName(_fromUtf8("label_number_2"))
        self.urban_properties_number = SearchableComboBox(self.tab_2)
        self.urban_properties_number.setGeometry(QtCore.QRect(90, 88, 221, 20))
        self.urban_properties_number.setEditable(True)
        self.urban_properties_number.setObjectName(_fromUtf8("urban_properties_number"))
        self.label_block = QtGui.QLabel(self.tab_2)
        self.label_block.setGeometry(QtCore.QRect(15, 56, 55, 16))
        self.label_block.setObjectName(_fromUtf8("label_block"))
        self.urban_properties_block = SearchableComboBox(self.tab_2)
        self.urban_properties_block.setGeometry(QtCore.QRect(90, 54, 221, 20))
        self.urban_properties_block.setEditable(True)
        self.urban_properties_block.setObjectName(_fromUtf8("urban_properties_block"))
        self.tab_main.addTab(self.tab_2, _fromUtf8(""))
        self.tab = QtGui.QWidget()
        self.tab.setObjectName(_fromUtf8("tab"))
        self.ppoint_press_zone = SearchableComboBox(self.tab)
        self.ppoint_press_zone.setGeometry(QtCore.QRect(90, 20, 221, 20))
        self.ppoint_press_zone.setEditable(True)
        self.ppoint_press_zone.setObjectName(_fromUtf8("ppoint_press_zone"))
        self.label_press_zone = QtGui.QLabel(self.tab)
        self.label_press_zone.setGeometry(QtCore.QRect(15, 22, 55, 16))
        self.label_press_zone.setObjectName(_fromUtf8("label_press_zone"))
        self.label_number = QtGui.QLabel(self.tab)
        self.label_number.setGeometry(QtCore.QRect(15, 56, 55, 16))
        self.label_number.setObjectName(_fromUtf8("label_number"))
        self.ppoint_number = SearchableComboBox(self.tab)
        self.ppoint_number.setGeometry(QtCore.QRect(90, 54, 221, 20))
        self.ppoint_number.setEditable(True)
        self.ppoint_number.setObjectName(_fromUtf8("ppoint_number"))
        self.tab_main.addTab(self.tab, _fromUtf8(""))
        self.tab_3 = QtGui.QWidget()
        self.tab_3.setObjectName(_fromUtf8("tab_3"))
        self.label_street = QtGui.QLabel(self.tab_3)
        self.label_street.setGeometry(QtCore.QRect(15, 22, 55, 16))
        self.label_street.setObjectName(_fromUtf8("label_street"))
        self.label_number_3 = QtGui.QLabel(self.tab_3)
        self.label_number_3.setGeometry(QtCore.QRect(15, 56, 55, 16))
        self.label_number_3.setObjectName(_fromUtf8("label_number_3"))
        self.adress_street = SearchableComboBox(self.tab_3)
        self.adress_street.setGeometry(QtCore.QRect(90, 20, 221, 20))
        self.adress_street.setEditable(True)
        self.adress_street.setObjectName(_fromUtf8("adress_street"))
        self.adress_number = SearchableComboBox(self.tab_3)
        self.adress_number.setGeometry(QtCore.QRect(90, 54, 221, 20))
        self.adress_number.setEditable(True)
        self.adress_number.setObjectName(_fromUtf8("adress_number"))
        self.tab_main.addTab(self.tab_3, _fromUtf8(""))
        self.tab_4 = QtGui.QWidget()
        self.tab_4.setObjectName(_fromUtf8("tab_4"))
        self.label_code = QtGui.QLabel(self.tab_4)
        self.label_code.setGeometry(QtCore.QRect(15, 22, 55, 16))
        self.label_code.setObjectName(_fromUtf8("label_code"))
        self.hydrometer_code = SearchableComboBox(self.tab_4)
        self.hydrometer_code.setGeometry(QtCore.QRect(90, 20, 221, 20))
        self.hydrometer_code.setEditable(True)
        self.hydrometer_code.setObjectName(_fromUtf8("hydrometer_code"))
        self.tab_main.addTab(self.tab_4, _fromUtf8(""))

        self.retranslateUi(searchPlusDockWidget)
        self.tab_main.setCurrentIndex(0)
        QtCore.QMetaObject.connectSlotsByName(searchPlusDockWidget)

    def retranslateUi(self, searchPlusDockWidget):
        searchPlusDockWidget.setWindowTitle(_translate("searchPlusDockWidget", "Search plus", None))
        self.label_press_zone_2.setText(_translate("searchPlusDockWidget", "Press zone:", None))
        self.label_number_2.setText(_translate("searchPlusDockWidget", "Number:", None))
        self.label_block.setText(_translate("searchPlusDockWidget", "Block:", None))
        self.tab_main.setTabText(self.tab_main.indexOf(self.tab_2), _translate("searchPlusDockWidget", "Urban Properties", None))
        self.label_press_zone.setText(_translate("searchPlusDockWidget", "Press zone:", None))
        self.label_number.setText(_translate("searchPlusDockWidget", "Number:", None))
        self.tab_main.setTabText(self.tab_main.indexOf(self.tab), _translate("searchPlusDockWidget", "Ppoint", None))
        self.label_street.setText(_translate("searchPlusDockWidget", "Street:", None))
        self.label_number_3.setText(_translate("searchPlusDockWidget", "Number:", None))
        self.tab_main.setTabText(self.tab_main.indexOf(self.tab_3), _translate("searchPlusDockWidget", "Adress", None))
        self.label_code.setText(_translate("searchPlusDockWidget", "Code:", None))
        self.tab_main.setTabText(self.tab_main.indexOf(self.tab_4), _translate("searchPlusDockWidget", "Hydrometer", None))

from custom_widgets.searchable_combobox import SearchableComboBox
