'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from map_tools.parent import ParentMapTool


class CadAddCircle(ParentMapTool):
    """ Button 71: Add circle """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        # Call ParentMapTool constructor
        super(CadAddCircle, self).__init__(iface, settings, action, index_action)


    """ QgsMapTools inherited event functions """

    def canvasMoveEvent(self, event):
        pass
                

    def canvasReleaseEvent(self, event):
        pass


    def activate(self):
        pass


    def deactivate(self):

        # Call parent method     
        ParentMapTool.deactivate(self)
    
