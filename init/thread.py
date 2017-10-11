'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
import threading
import time


class Thread(threading.Thread):

    def __init__(self, feature_dialog, controller, counter):
        """ Class constructor """
        threading.Thread.__init__(self) 
        self.exit_flag = 0            
        self.feature_dialog = feature_dialog  
        self.controller = controller
        self.counter = counter
        self.delay = 0.6     
    
    
    def run(self):
        """ Main function """
        counter = self.counter
        while counter:
            time.sleep(self.delay)
            counter -= 1
            if counter < 2:
                close_dlg = self.controller.plugin_settings_value("close_dlg", "0") 
                if close_dlg == "1" and self.feature_dialog:      
                    self.feature_dialog.reject_dialog()      
                
                