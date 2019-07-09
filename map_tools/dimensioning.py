"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from .parent import ParentMapTool


class Dimensioning(ParentMapTool):
    """ Button 39: Dimensioning """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        # Call ParentMapTool constructor
        super(Dimensioning, self).__init__(iface, settings, action, index_action)



    """ QgsMapTools inherited event functions """
          
          
    def canvasMoveEvent(self, event):
        pass
                    

    def canvasReleaseEvent(self, event):
        pass


    def activate(self):

        # Check button
        self.action().setChecked(True)          

        layer = self.controller.get_layer_by_tablename("v_edit_dimensions", show_warning=True)        
        if layer:
            self.iface.setActiveLayer(layer)
            self.controller.set_layer_visible(layer)
            layer.startEditing()
            # Implement the Add Feature button
            self.iface.actionAddFeature().trigger()
            

    def deactivate(self):

        # Call parent method     
        ParentMapTool.deactivate(self)
    
