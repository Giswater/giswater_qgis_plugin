'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from map_tools.parent import ParentMapTool
from ..ui.create_circle import Create_circle             # @UnresolvedImport
import utils_giswater


class CadAddCircle(ParentMapTool):
    """ Button 71: Add circle """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        # Call ParentMapTool constructor
        super(CadAddCircle, self).__init__(iface, settings, action, index_action)

    def init_create_circle_form(self):
        # Create the dialog and signals
        self.dlg_create_circle = Create_circle()
        utils_giswater.setDialog(self.dlg_create_circle)

        self.dlg_create_circle.btn_accept.pressed.connect(self.get_radius)
        self.dlg_create_circle.btn_cancel.pressed.connect(self.dlg_create_circle.close)

        self.dlg_create_circle.exec_()

    def get_radius(self):

        radius = self.dlg_create_circle.radius.text()



    """ QgsMapTools inherited event functions """

    def canvasMoveEvent(self, event):
        pass
                

    def canvasReleaseEvent(self, event):
        pass


    def activate(self):
        self.init_create_circle_form()


    def deactivate(self):

        # Call parent method     
        ParentMapTool.deactivate(self)
    
