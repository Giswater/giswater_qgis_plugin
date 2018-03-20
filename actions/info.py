"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
import sys
from functools import partial

import utils_giswater
from parent import ParentAction
from ui.info_show_info import InfoShowInfo


class Info(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'om_ws' """
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)


    def set_project_type(self, project_type):
        self.project_type = project_type


    def info_show_info(self):
        """ Button 36: Info show info, open giswater and visit web page """
        
        # Create form
        self.dlg_info = InfoShowInfo()
        utils_giswater.setDialog(self.dlg_info)
        self.load_settings(self.dlg_info)
        
        # Get Plugin, Giswater, PostgreSQL and Postgis version
        postgresql_version = self.controller.get_postgresql_version()
        postgis_version = self.controller.get_postgis_version()
        plugin_version = self.get_plugin_version()
        (giswater_file_path, giswater_build_version) = self.get_giswater_jar()  #@UnusedVariable         
        project_version = self.controller.get_project_version()      
        
        message = ("Plugin version:     " + str(plugin_version) + "\n"
                   "Project version:    " + str(project_version) + "\n"                    
                   "Giswater version:   " + str(giswater_build_version) + "\n" 
                   "PostgreSQL version: " + str(postgresql_version) + "\n" 
                   "Postgis version:    " + str(postgis_version))
        utils_giswater.setWidgetText(self.dlg_info.txt_info, message)
        
        # Set signals
        self.dlg_info.btn_open_giswater.clicked.connect(self.open_giswater)
        self.dlg_info.btn_open_web.clicked.connect(partial(self.open_web_browser, None))
        self.dlg_info.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_info))
        
        # Open dialog
        self.open_dialog(self.dlg_info, maximize_button=False)


    def open_giswater(self):
        """ Open giswater.jar with last opened .gsw file """

        if 'nt' in sys.builtin_module_names:
            self.execute_giswater("ed_giswater_jar")
        else:
            self.controller.show_info("Function not supported in this Operating System")
            
                    