"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from .load_project import LoadProject


class LoadProjectPl(LoadProject):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to manage load project of type 'tm' """

        LoadProject.__init__(self, iface, settings, controller, plugin_dir)


    def project_read_pl(self):
        """ Function executed when a user opens a QGIS project of type 'pl' """

        # Manage actions of the different plugin_toolbars
        self.manage_toolbars_common()

        # Set actions to controller class for further management
        self.controller.set_actions(self.actions)

        # Log it
        message = "Project read successfully ('pl')"
        self.controller.log_info(message)

