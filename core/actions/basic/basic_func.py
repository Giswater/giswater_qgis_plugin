"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from ....ui_manager import SelectorUi

from .... import global_vars

from ....actions.api_parent_functs import load_settings, get_selector, close_dialog, open_dialog, save_settings
from ....actions.parent_functs import get_last_tab, save_current_tab

class GwBasic:

    def __init__(self):
        """ Class to control toolbar 'basic' """
        pass


    def basic_filter_selectors(self):
        """ Button 142: Filter selector """

        selector_values = '"selector_basic"'

        # Show form in docker?
        global_vars.controller.init_docker('qgis_form_docker')

        self.dlg_selector = SelectorUi()
        load_settings(self.dlg_selector)

        # Get the name of the last tab used by the user
        current_tab = get_last_tab(self.dlg_selector, 'basic')
        get_selector(self.dlg_selector, selector_values, current_tab=current_tab)

        if global_vars.controller.dlg_docker:
            global_vars.controller.dock_dialog(self.dlg_selector)
            self.dlg_selector.btn_close.clicked.connect(global_vars.controller.close_docker)
        else:
            self.dlg_selector.btn_close.clicked.connect(partial(close_dialog, self.dlg_selector))
            self.dlg_selector.rejected.connect(partial(save_settings, self.dlg_selector))
            open_dialog(self.dlg_selector, dlg_name='selector', maximize_button=False)

        # Save the name of current tab used by the user
        self.dlg_selector.rejected.connect(partial(
            save_current_tab, self.dlg_selector, self.dlg_selector.main_tab, 'basic'))
