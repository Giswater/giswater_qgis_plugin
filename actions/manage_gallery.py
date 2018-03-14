"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QLabel, QPixmap, QPushButton, QLineEdit
from PyQt4.QtCore import Qt

import ExtendedQLabel
from functools import partial

import utils_giswater
from ui.gallery import Gallery
from ui.gallery_zoom import GalleryZoom
from actions.parent_manage import ParentManage


class ManageGallery(ParentManage):
    
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'Add element' of toolbar 'edit' """
        ParentManage.__init__(self, iface, settings, controller, plugin_dir)


    def manage_gallery(self):
        
        # Create the dialog and signals
        self.dlg_gallery = Gallery()
        utils_giswater.setDialog(self.dlg_gallery)
        self.load_settings(self.dlg_gallery)


    def fill_gallery(self, visit_id, event_id):

        # Get all pictures for event_id | visit_id
        sql = ("SELECT value FROM " + self.schema_name + ".om_visit_event_photo"
               " WHERE event_id = '" + str(event_id) + "' AND visit_id = '" + str(visit_id) + "'")
        rows = self.controller.get_rows(sql)

        self.img_path_list = []
        self.img_path_list1D = []

        # Creates a list containing 5 lists, each of 8 items, all set to 0
        num = len(rows)
        for nm in range(0, num):
            self.img_path_list1D.append(rows[nm][0])

        # Add picture to gallery
        # Fill one-dimensional array till the end with "0"
        self.num_events = len(self.img_path_list1D)

        # Fill the rest of the fields in gallery with 0
        limit = self.num_events % 9
        limit = 9 - limit
        for k in range(0, limit):  # @UnusedVariable
            self.img_path_list1D.append(0)

        # Inicialization of two-dimensional array
        rows = (self.num_events / 9) + 1
        columns = 9
        self.img_path_list = [[0 for x in range(columns)] for x in range(rows)]  # @UnusedVariable

        # Convert one-dimensional array to two-dimensional array
        # Fill self.img_path_list with values from self.img_path_list1D
        idx = 0
        if rows == 1:
            for br in range(0, len(self.img_path_list1D)):
                self.img_path_list[0][br] = self.img_path_list1D[br]
        else:
            for h in range(0, rows):
                for r in range(0, columns):
                    self.img_path_list[h][r] = self.img_path_list1D[idx]
                    idx = idx + 1

        # List of pointers(in memory) of clicableLabels
        self.list_widget = []
        self.list_labels = []

        # Fill first slide of gallery
        for i in range(0, 9):
            widget_name = "img_" + str(i)
            widget = self.dlg_gallery.findChild(QLabel, widget_name)
            if widget:
                # Set image to QLabel
                pixmap = QPixmap(str(self.img_path_list[0][i]))
                pixmap = pixmap.scaled(171, 151, Qt.IgnoreAspectRatio, Qt.SmoothTransformation)
                widget_extended = ExtendedQLabel.ExtendedQLabel(widget)
                widget_extended.setPixmap(pixmap)
                widget_extended.clicked.connect(partial(self.zoom_img, i, visit_id, event_id))
                self.list_widget.append(widget_extended)
                self.list_labels.append(widget)

        txt_visit_id = self.dlg_gallery.findChild(QLineEdit, 'visit_id')
        txt_visit_id.setText(str(visit_id))
        txt_event_id = self.dlg_gallery.findChild(QLineEdit, 'event_id')
        txt_event_id.setText(str(event_id))

        self.start_indx = 0
        self.btn_next = self.dlg_gallery.findChild(QPushButton, "btn_next")
        self.btn_next.clicked.connect(self.next_gallery)
        self.btn_previous = self.dlg_gallery.findChild(QPushButton, "btn_previous")
        self.btn_previous.clicked.connect(self.previous_gallery)
        self.set_icon(self.btn_previous, "109")
        self.set_icon(self.btn_next, "108")
        self.btn_close = self.dlg_gallery.findChild(QPushButton, "btn_close")
        self.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_gallery))
         
        # If all images set in one page, disable button next   
        if num <= 9:
            self.btn_next.setDisabled(True)        

        # Open dialog
        self.open_dialog(self.dlg_gallery, maximize_button=False)        


    def next_gallery(self):

        self.start_indx = self.start_indx + 1
        
        # Clear previous
        for i in self.list_widget:
            i.clear()

        # Add new 9 images
        for i in range(0, 9):
            pixmap = QPixmap(self.img_path_list[self.start_indx][i])
            pixmap = pixmap.scaled(171, 151, Qt.IgnoreAspectRatio, Qt.SmoothTransformation)
            self.list_widget[i].setPixmap(pixmap)

        # Control sliding buttons
        if self.start_indx > 0:
            self.btn_previous.setEnabled(True)
        else:
            self.btn_previous.setEnabled(False)

        control = len(self.img_path_list1D) / 9
        if self.start_indx == (control - 1):
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


    def zoom_img(self, i, visit_id, event_id):
        
        handeler_index = i

        self.dlg_gallery_zoom = GalleryZoom()
        utils_giswater.setDialog(self.dlg_gallery_zoom)
        self.load_settings(self.dlg_gallery_zoom)
        pixmap = QPixmap(self.img_path_list[self.start_indx][i])

        self.lbl_img = self.dlg_gallery_zoom.findChild(QLabel, "lbl_img_zoom")
        self.lbl_img.setPixmap(pixmap)
        # lbl_img.show()
        zoom_visit_id = self.dlg_gallery_zoom.findChild(QLineEdit, "visit_id")
        zoom_event_id = self.dlg_gallery_zoom.findChild(QLineEdit, "event_id")

        zoom_visit_id.setText(str(visit_id))
        zoom_event_id.setText(str(event_id))

        self.btn_slidePrevious = self.dlg_gallery_zoom.findChild(QPushButton, "btn_slidePrevious")
        self.btn_slideNext = self.dlg_gallery_zoom.findChild(QPushButton, "btn_slideNext")
        self.set_icon(self.btn_slidePrevious, "109")
        self.set_icon(self.btn_slideNext, "108")

        self.dlg_gallery_zoom.rejected.connect(partial(self.close_dialog, self.dlg_gallery_zoom))

        self.i = i
        self.btn_slidePrevious.clicked.connect(self.slide_previous)
        self.btn_slideNext.clicked.connect(self.slide_next)
    
        # Open dialog
        self.open_dialog(self.dlg_gallery_zoom, maximize_button=False)      

        # Controling start index
        if handeler_index != i:
            self.start_indx = self.start_indx + 1


    def slide_previous(self):

        indx = (self.start_indx * 9) + self.i - 1
        pixmap = QPixmap(self.img_path_list1D[indx])
        self.lbl_img.setPixmap(pixmap)
        self.i = self.i - 1

        # Control sliding buttons
        if indx == 0:
            self.btn_slidePrevious.setEnabled(False)

        if indx < (self.num_events - 1):
            self.btn_slideNext.setEnabled(True)


    def slide_next(self):

        indx = (self.start_indx * 9) + self.i + 1
        pixmap = QPixmap(self.img_path_list1D[indx])
        self.lbl_img.setPixmap(pixmap)
        self.i = self.i + 1

        # Control sliding buttons
        if indx > 0:
            self.btn_slidePrevious.setEnabled(True)

        if indx == (self.num_events - 1):
            self.btn_slideNext.setEnabled(False)

