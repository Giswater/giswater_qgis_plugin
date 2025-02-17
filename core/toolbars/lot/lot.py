"""
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import QDate, Qt
from qgis.PyQt.QtWidgets import QTableView, QAbstractItemView, QLineEdit, QDateEdit, QPushButton

from datetime import datetime
from functools import partial

from .add_lot import AddNewLot
from .manage_visit import ManageVisit
from .manage_new_psector import ManageNewPsector
from .parent import ParentAction
from ..ui_manager import PsectorManagerUi


class Lot(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'om_ws' """

        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.new_lot = AddNewLot(iface, settings, controller, plugin_dir)
        self.manage_visit = ManageVisit(iface, settings, controller, plugin_dir)
        self.manage_new_psector = ManageNewPsector(iface, settings, controller, plugin_dir)


    def om_add_lot(self):
        """ Button 74: Add new lot """
        self.new_lot.manage_lot()


    def om_lot_management(self):
        """ Button 75: Lot management """
        self.new_lot.lot_manager()


    def om_resource_management(self):
        """ Button 76: Resources Management """
        self.new_lot.resources_management()


