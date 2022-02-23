"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import urllib
from functools import partial

from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QPixmap
from qgis.PyQt.QtWidgets import QLabel, QPushButton, QLineEdit

from ..ui.ui_manager import GwGalleryUi, GwGalleryZoomUi
from ..utils import tools_gw
from ...lib import tools_db
from ...lib.tools_qt import GwExtendedQLabel


class GwVisitGallery:

    def __init__(self):
        """ Class to control 'Add element' of toolbar 'edit' """

        pass


    def manage_gallery(self):

        # Create the dialog and signals
        self.dlg_gallery = GwGalleryUi()
        tools_gw.load_settings(self.dlg_gallery)


    def fill_gallery(self, visit_id, event_id):

        self.img_path_list = []
        self.img_path_list1D = []

        # Get all pictures for event_id | visit_id
        sql = (f"SELECT value FROM om_visit_event_photo"
               f" WHERE event_id = '{event_id}' AND visit_id = '{visit_id}'")
        rows = tools_db.get_rows(sql)
        num = len(rows)
        for m in range(0, num):
            self.img_path_list1D.append(rows[m][0])

        # Add picture to gallery
        # Fill one-dimensional array till the end with "0"
        self.num_events = len(self.img_path_list1D)

        # Fill the rest of the fields in gallery with 0
        limit = self.num_events % 9
        limit = 9 - limit
        for k in range(0, limit):  # @UnusedVariable
            self.img_path_list1D.append(0)

        # Inicialization of two-dimensional array
        columns = 9
        rows = self.num_events
        # noinspection PyUnusedLocal
        self.img_path_list = [[0 for x in range(columns)] for x in range(rows)]

        # Convert one-dimensional array to two-dimensional array
        # Fill self.img_path_list with values from self.img_path_list1D
        idx = 0
        if rows == 1:
            for br in range(0, len(self.img_path_list1D)):
                self.img_path_list[0][br] = self.img_path_list1D[br]
        else:
            for h in range(0, rows):
                for r in range(0, columns - 1):
                    if idx >= columns:
                        break
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

                # Parse a URL into components
                url = urllib.parse.urlsplit(str(self.img_path_list[0][i]))

                # Check if path is URL
                if url.scheme == "http" or url.scheme == "https":
                    url = str(self.img_path_list[0][i])
                    data = urllib.request.urlopen(url).read()
                    pixmap = QPixmap()
                    pixmap.loadFromData(data)
                else:
                    pixmap = QPixmap(str(self.img_path_list[0][i]))

                pixmap = pixmap.scaled(171, 151, Qt.IgnoreAspectRatio, Qt.SmoothTransformation)
                widget_extended = GwExtendedQLabel(widget)
                widget_extended.setPixmap(pixmap)
                widget_extended.clicked.connect(partial(self._zoom_img, i, visit_id, event_id))
                self.list_widget.append(widget_extended)
                self.list_labels.append(widget)

        txt_visit_id = self.dlg_gallery.findChild(QLineEdit, 'visit_id')
        txt_visit_id.setText(str(visit_id))
        txt_event_id = self.dlg_gallery.findChild(QLineEdit, 'event_id')
        txt_event_id.setText(str(event_id))

        self.start_indx = 0
        self.btn_next = self.dlg_gallery.findChild(QPushButton, "btn_next")
        self.btn_next.clicked.connect(self._next_gallery)
        self.btn_previous = self.dlg_gallery.findChild(QPushButton, "btn_previous")
        self.btn_previous.clicked.connect(self._previous_gallery)
        tools_gw.add_icon(self.btn_previous, "109", sub_folder="24x24")
        tools_gw.add_icon(self.btn_next, "108", sub_folder="24x24")
        self.btn_close = self.dlg_gallery.findChild(QPushButton, "btn_close")
        self.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_gallery))

        # If all images set in one page, disable button next
        if num <= 9:
            self.btn_next.setDisabled(True)

        # Open dialog
        tools_gw.open_dialog(self.dlg_gallery, dlg_name='visit_gallery')


    # region private functions


    def _next_gallery(self):

        self.start_indx = self.start_indx + 1

        # Clear previous
        for i in self.list_widget:
            i.clear()

        # Add new 9 images
        for i in range(0, 9):

            # Parse a URL into components
            url = urllib.parse.urlsplit(str(self.img_path_list[self.start_indx][i]))

            # Check if path is URL
            if url.scheme == "http" or url.scheme == "https":
                url = str(self.img_path_list[self.start_indx][i])
                data = urllib.request.urlopen(url).read()
                pixmap = QPixmap()
                pixmap.loadFromData(data)
            else:
                pixmap = QPixmap(str(self.img_path_list[self.start_indx][i]))

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


    def _previous_gallery(self):

        self.start_indx = self.start_indx - 1

        # First clear previous
        for i in self.list_widget:
            i.clear()

        # Add new 9 images
        for i in range(0, 9):

            # Parse a URL into components
            url = urllib.parse.urlsplit(str(self.img_path_list[self.start_indx][i]))

            # Check if path is URL
            if url.scheme == "http" or url.scheme == "https":
                url = str(self.img_path_list[self.start_indx][i])
                data = urllib.request.urlopen(url).read()
                pixmap = QPixmap()
                pixmap.loadFromData(data)
            else:
                pixmap = QPixmap(str(self.img_path_list[self.start_indx][i]))

            pixmap = pixmap.scaled(171, 151, Qt.IgnoreAspectRatio, Qt.SmoothTransformation)
            self.list_widget[i].setPixmap(pixmap)

        # Control sliding buttons
        if self.start_indx == 0:
            self.btn_previous.setEnabled(False)

        control = len(self.img_path_list1D) / 9
        if self.start_indx < (control - 1):
            self.btn_next.setEnabled(True)


    def _zoom_img(self, i, visit_id, event_id):

        handeler_index = i

        self.dlg_gallery_zoom = GwGalleryZoomUi()
        tools_gw.load_settings(self.dlg_gallery_zoom)
        self.lbl_img = self.dlg_gallery_zoom.findChild(QLabel, "lbl_img_zoom")

        # Parse a URL into components
        url = urllib.parse.urlsplit(str(self.img_path_list[self.start_indx][i]))

        # Check if path is URL
        if url.scheme == "http" or url.scheme == "https":
            url = str(self.img_path_list[self.start_indx][i])
            data = urllib.request.urlopen(url).read()
            pixmap = QPixmap()
            pixmap.loadFromData(data)
        else:
            pixmap = QPixmap(str(self.img_path_list[self.start_indx][i]))

        self.lbl_img.setPixmap(pixmap)

        # lbl_img.show()
        zoom_visit_id = self.dlg_gallery_zoom.findChild(QLineEdit, "visit_id")
        zoom_event_id = self.dlg_gallery_zoom.findChild(QLineEdit, "event_id")

        zoom_visit_id.setText(str(visit_id))
        zoom_event_id.setText(str(event_id))

        self.btn_slidePrevious = self.dlg_gallery_zoom.findChild(QPushButton, "btn_slidePrevious")
        self.btn_slideNext = self.dlg_gallery_zoom.findChild(QPushButton, "btn_slideNext")
        tools_gw.add_icon(self.btn_slidePrevious, "109", sub_folder="24x24")
        tools_gw.add_icon(self.btn_slideNext, "108", sub_folder="24x24")

        self.dlg_gallery_zoom.rejected.connect(partial(tools_gw.close_dialog, self.dlg_gallery_zoom))

        self.i = i
        self.btn_slidePrevious.clicked.connect(self._slide_previous)
        self.btn_slideNext.clicked.connect(self._slide_next)

        # Open dialog
        tools_gw.open_dialog(self.dlg_gallery_zoom, dlg_name='visit_gallery_zoom')

        # Controling start index
        if handeler_index != i:
            self.start_indx = self.start_indx + 1


    def _slide_previous(self):

        indx = (self.start_indx * 9) + self.i - 1

        # Parse a URL into components
        url = urllib.parse.urlsplit(str(self.img_path_list1D[indx]))

        # Check if path is URL
        if url.scheme == "http" or url.scheme == "https":
            url = str(self.img_path_list1D[indx])
            data = urllib.request.urlopen(url).read()
            pixmap = QPixmap()
            pixmap.loadFromData(data)
        else:
            pixmap = QPixmap(str(self.img_path_list1D[indx]))

        self.lbl_img.setPixmap(pixmap)
        self.i = self.i - 1

        # Control sliding buttons
        if indx == 0:
            self.btn_slidePrevious.setEnabled(False)

        if indx < (self.num_events - 1):
            self.btn_slideNext.setEnabled(True)


    def _slide_next(self):

        indx = (self.start_indx * 9) + self.i + 1

        # Parse a URL into components
        url = urllib.parse.urlsplit(str(self.img_path_list1D[indx]))

        # Check if path is URL
        if url.scheme == "http" or url.scheme == "https":
            url = str(self.img_path_list1D[indx])
            data = urllib.request.urlopen(url).read()
            pixmap = QPixmap()
            pixmap.loadFromData(data)

        else:
            pixmap = QPixmap(str(self.img_path_list1D[indx]))

        self.lbl_img.setPixmap(pixmap)
        self.i = self.i + 1

        # Control sliding buttons
        if indx > 0:
            self.btn_slidePrevious.setEnabled(True)

        if indx == (self.num_events - 1):
            self.btn_slideNext.setEnabled(False)

    # endregion
