"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QLabel, QPixmap, QPushButton, QTableView, QLineEdit
from PyQt4.QtCore import Qt

from functools import partial

import utils_giswater
from parent_init import ParentDialog
from ui.gallery import Gallery              
from ui.gallery_zoom import GalleryZoom
      
     
class ManageGallery(ParentDialog):   
    
    def __init__(self, dialog, layer, feature):
        """ Constructor class """
        super(ManageGallery, self).__init__(dialog, layer, feature)      
            
                    
    def open_selected_event_from_table(self):
        """ Button - Open EVENT | gallery from table event """

        # Get selected rows
        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_node")
        selected_list = self.tbl_event.selectionModel().selectedRows()    
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message')
            return

        row = selected_list[0].row()
        self.visit_id = self.tbl_event.model().record(row).value("visit_id")
        self.event_id = self.tbl_event.model().record(row).value("event_id")
        
        # Get all events | pictures for visit_id
        sql = "SELECT value FROM "+self.schema_name+".v_ui_om_visit_x_node"
        sql +=" WHERE visit_id = '"+str(self.visit_id)+"'"
        rows = self.controller.get_rows(sql)

        # Get absolute path
        sql = "SELECT value FROM "+self.schema_name+".config_param_system"
        sql += " WHERE parameter = 'doc_absolute_path'"
        row = self.controller.get_row(sql)

        self.img_path_list = []
        self.img_path_list1D = []
        # Creates a list containing 5 lists, each of 8 items, all set to 0

        # Fill 1D array with full path
        if row is None:
            message = "Parameter not set in table 'config_param_system'"
            self.controller.show_warning(message, parameter='doc_absolute_path')
            return
        else:
            for value in rows:
                full_path = str(row[0]) + str(value[0])
                self.img_path_list1D.append(full_path)

        # Create the dialog and signals
        self.dlg_gallery = Gallery()
        utils_giswater.setDialog(self.dlg_gallery)
        
        txt_visit_id = self.dlg_gallery.findChild(QLineEdit, 'visit_id')
        txt_visit_id.setText(str(self.visit_id))
        
        txt_event_id = self.dlg_gallery.findChild(QLineEdit, 'event_id')
        txt_event_id.setText(str(self.event_id))
        
        # Add picture to gallery
       
        # Fill one-dimensional array till the end with "0"
        self.num_events = len(self.img_path_list1D)

        limit = self.num_events % 9
        for k in range(0, limit):   # @UnusedVariable
            self.img_path_list1D.append(0)

        # Inicialization of two-dimensional array
        rows = self.num_events / 9+1
        columns = 9 
        self.img_path_list = [[0 for x in range(columns)] for x in range(rows)] # @UnusedVariable
        message = str(self.img_path_list)

        # Convert one-dimensional array to two-dimensional array
        idx = 0 
        if rows == 1:
            for br in range(0,len(self.img_path_list1D)):
                self.img_path_list[0][br]=self.img_path_list1D[br]
        else:
            for h in range(0,rows):
                for r in range(0,columns):
                    self.img_path_list[h][r]=self.img_path_list1D[idx]    
                    idx=idx+1

        # List of pointers(in memory) of clicableLabels
        self.list_widget=[]
        self.list_labels=[]

        for i in range(0, 9):

            widget_name = "img_"+str(i)
            widget = self.dlg_gallery.findChild(QLabel, widget_name)
            if widget:
                # Set image to QLabel
                pixmap = QPixmap(str(self.img_path_list[0][i]))
                pixmap = pixmap.scaled(171, 151, Qt.IgnoreAspectRatio, Qt.SmoothTransformation)
                widget.setPixmap(pixmap)
                self.start_indx = 0
                self.clickable(widget).connect(partial(self.zoom_img, i))
                self.list_widget.append(widget)
                self.list_labels.append(widget)
      
        self.start_indx = 0
        self.btn_next = self.dlg_gallery.findChild(QPushButton,"btn_next")
        self.btn_next.clicked.connect(self.next_gallery)
        self.btn_previous = self.dlg_gallery.findChild(QPushButton,"btn_previous")
        self.btn_previous.clicked.connect(self.previous_gallery)
        self.set_icon(self.btn_previous, "109")
        self.set_icon(self.btn_next, "108")
        self.btn_close = self.dlg_gallery.findChild(QPushButton, "btn_close")
        self.btn_close.clicked.connect(self.dlg_gallery.close)

        self.dlg_gallery.exec_()


    def next_gallery(self):

        self.start_indx = self.start_indx + 1
        # Clear previous
        for i in self.list_widget:
            i.clear()

        # Add new 9 images
        for i in range(0, 9):
            pixmap = QPixmap(self.img_path_list[self.start_indx][i])
            pixmap = pixmap.scaled(171,151,Qt.IgnoreAspectRatio,Qt.SmoothTransformation)
            self.list_widget[i].setPixmap(pixmap)

        # Control sliding buttons
        if self.start_indx > 0 :
            self.btn_previous.setEnabled(True) 
            
        if self.start_indx == 0 :
            self.btn_previous.setEnabled(False)
     
        control = len(self.img_path_list1D) / 9
        if self.start_indx == (control-1):
            self.btn_next.setEnabled(False)


    def previous_gallery(self):

        self.start_indx = self.start_indx - 1

        # First clear previous
        for i in self.list_widget:
            i.clear()

        # Add new 9 images
        for i in range(0, 9):
            pixmap = QPixmap(self.img_path_list[self.start_indx][i])
            pixmap = pixmap.scaled(171, 151, Qt.IgnoreAspectRatio, Qt.SmoothTransformation)
            self.list_widget[i].setPixmap(pixmap)

        # Control sliding buttons
        if self.start_indx == 0:
            self.btn_previous.setEnabled(False)

        control = len(self.img_path_list1D) / 9
        if self.start_indx < (control - 1):
            self.btn_next.setEnabled(True)


    def zoom_img(self, i):

        handelerIndex = i

        self.dlg_gallery_zoom = GalleryZoom()
        pixmap = QPixmap(self.img_path_list[self.start_indx][i])

        self.lbl_img = self.dlg_gallery_zoom.findChild(QLabel, "lbl_img_zoom")
        self.lbl_img.setPixmap(pixmap)
        #lbl_img.show()

        zoom_visit_id = self.dlg_gallery_zoom.findChild(QLineEdit, "visit_id")
        zoom_event_id = self.dlg_gallery_zoom.findChild(QLineEdit, "event_id")

        zoom_visit_id.setText(str(self.visit_id))
        zoom_event_id.setText(str(self.event_id))

        self.btn_slidePrevious = self.dlg_gallery_zoom.findChild(QPushButton, "btn_slidePrevious")
        self.btn_slideNext = self.dlg_gallery_zoom.findChild(QPushButton, "btn_slideNext")
        self.set_icon(self.btn_slidePrevious, "109")
        self.set_icon(self.btn_slideNext, "108")

        self.i = i
        self.btn_slidePrevious.clicked.connect(self.slide_previous)
        self.btn_slideNext.clicked.connect(self.slide_next)
        self.dlg_gallery_zoom.exec_() 
        
        # Controling start index
        if handelerIndex != i:
            self.start_indx = self.start_indx+1
        
        
    def slide_previous(self):
    
        indx = (self.start_indx*9) + self.i -1
        pixmap = QPixmap(self.img_path_list1D[indx])
        self.lbl_img.setPixmap(pixmap)
        self.i=self.i-1
        
        # Control sliding buttons
        if indx == 0 :
            self.btn_slidePrevious.setEnabled(False) 
            
        if indx < (self.num_events - 1):
            self.btn_slideNext.setEnabled(True) 

        
    def slide_next(self):

        indx = (self.start_indx*9) + self.i + 1
        pixmap = QPixmap(self.img_path_list1D[indx])
        self.lbl_img.setPixmap(pixmap)
        self.i = self.i + 1

        # Control sliding buttons
        if indx > 0 :
            self.btn_slidePrevious.setEnabled(True)

        if indx == (self.num_events - 1):
            self.btn_slideNext.setEnabled(False)
            
            