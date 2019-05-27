# -*- coding: utf-8 -*-
from qgis.PyQt import uic
from qgis.PyQt.QtWidgets import QDialog
import os

FORM_CLASS, _ = uic.loadUiType(os.path.join(os.path.dirname(__file__), 'month_manage.ui'))


class MonthManage(QDialog, FORM_CLASS):

    def __init__(self, parent=None):
        """ Constructor """
        super(MonthManage, self).__init__(parent)
        self.setupUi(self)

