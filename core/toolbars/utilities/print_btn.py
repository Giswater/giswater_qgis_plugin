"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtCore import QPoint
from qgis.PyQt.QtWidgets import QAction, QMenu

from .print.fastprint import GwFastprint
from .print.massive_composer import GwMassiveComposer
from ..dialog import GwAction


class GwPrintButton(GwAction):
    """ Button 65: Print """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)

        # First add the menu before adding it to the toolbar
        if toolbar is not None:
            toolbar.removeAction(self.action)

        self.menu = QMenu()
        self.menu.setObjectName("GW_print_menu")
        self._fill_print_menu()

        self.menu.aboutToShow.connect(self._fill_print_menu)

        if toolbar is not None:
            self.action.setMenu(self.menu)
            toolbar.addAction(self.action)

    def clicked_event(self):

        if self.menu.property('last_selection') is not None:
            getattr(self, self.menu.property('last_selection'))()
            return
        button = self.action.associatedWidgets()[1]
        menu_point = button.mapToGlobal(QPoint(0, button.height()))
        self.menu.popup(menu_point)

    # region private functions

    def _fill_print_menu(self):
        """ Fill add arc menu """

        # disconnect and remove previuos signals and actions
        actions = self.menu.actions()
        for action in actions:
            action.disconnect()
            self.menu.removeAction(action)
            del action
        action_group = self.action.property('action_group')

        buttons = [['Fast print', '_fastprint'], ['Massive composer', '_massive_composer']]

        for button in buttons:
            button_name = button[0]
            button_function = button[1]
            obj_action = QAction(str(button_name), action_group)
            obj_action.setObjectName(button_name)
            obj_action.setProperty('action_group', action_group)
            self.menu.addAction(obj_action)
            obj_action.triggered.connect(partial(getattr(self, button_function)))
            obj_action.triggered.connect(partial(self._save_last_selection, self.menu, button_function))

    def _save_last_selection(self, menu, button_function):
        menu.setProperty("last_selection", button_function)

    def _fastprint(self):
        print("fastprint")
        self.fastprint = GwFastprint()
        self.fastprint.open_print()

    def _massive_composer(self):
        print("massive composer")
        self.massive_composer = GwMassiveComposer()
        self.massive_composer.open_massive_composer()
