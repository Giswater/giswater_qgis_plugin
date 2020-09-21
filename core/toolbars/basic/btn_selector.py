"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from core.toolbars.parent_dialog import GwParentAction
from functools import partial

from core.utils.tools_giswater import close_dialog, get_parser_value, load_settings, open_dialog, save_current_tab, \
    save_settings
from core.ui.ui_manager import SelectorUi
import global_vars
from actions.api_parent_functs import get_selector


class GwSelectorButton(GwParentAction):

    def __init__(self, icon_path, text, toolbar, action_group):
        super().__init__(icon_path, text, toolbar, action_group)

    def clicked_event(self):

        selector_values = '"selector_basic"'

        # Show form in docker?
        global_vars.controller.init_docker('qgis_form_docker')

        dlg_selector = SelectorUi()
        load_settings(dlg_selector)

        # Get the name of the last tab used by the user
        selector_vars = {}
        current_tab = get_parser_value('last_tabs', f"{dlg_selector.objectName()}_basic")
        get_selector(dlg_selector, selector_values, current_tab=current_tab, selector_vars=selector_vars)

        if global_vars.controller.dlg_docker:
            global_vars.controller.dock_dialog(dlg_selector)
            dlg_selector.btn_close.clicked.connect(global_vars.controller.close_docker)
        else:
            dlg_selector.btn_close.clicked.connect(partial(close_dialog, dlg_selector))
            dlg_selector.rejected.connect(partial(save_settings, dlg_selector))
            open_dialog(dlg_selector, dlg_name='selector', maximize_button=False)

        # Save the name of current tab used by the user
        dlg_selector.rejected.connect(partial(
            save_current_tab, dlg_selector, dlg_selector.main_tab, 'basic'))
