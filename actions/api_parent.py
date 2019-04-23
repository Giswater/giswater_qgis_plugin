"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4.QtCore import Qt
    from PyQt4.QtGui import QLineEdit, QColor,  QComboBox, QGridLayout, QLabel, QSpinBox, QDoubleSpinBox
    from PyQt4.QtGui import QIntValidator, QDoubleValidator, QGroupBox, QWidget

else:
    from qgis.PyQt.QtCore import Qt
    from qgis.PyQt.QtGui import QColor, QIntValidator, QDoubleValidator
    from qgis.PyQt.QtWidgets import QLineEdit,  QComboBox, QGridLayout,  QLabel, QSpinBox, QDoubleSpinBox, QGroupBox
    from qgis.PyQt.QtWidgets import QWidget
    from qgis.core import QgsWkbTypes


from qgis.core import QgsRectangle, QgsPoint, QgsGeometry
from qgis.gui import QgsVertexMarker, QgsMapToolEmitPoint, QgsRubberBand, QgsDateTimeEdit


import re
from functools import partial
import utils_giswater
from giswater.actions.parent import ParentAction


class ApiParent(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
    
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.my_json = {}
        if Qgis.QGIS_VERSION_INT < 20000:
            self.vMarker = QgsVertexMarker(self.canvas)
            self.vMarker.setIconSize(10)
            return
            
        if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
            self.rubber_point = QgsRubberBand(self.canvas, Qgis.Point)
        else:
            self.rubber_point = QgsRubberBand(self.canvas, QgsWkbTypes.PointGeometry)

        self.rubber_point.setColor(Qt.yellow)
        # self.rubberBand.setIcon(QgsRubberBand.IconType.ICON_CIRCLE)
        self.rubber_point.setIconSize(10)
        self.rubber_polygon = QgsRubberBand(self.canvas)
        self.rubber_polygon.setColor(Qt.darkRed)
        self.rubber_polygon.setIconSize(20)



    def create_body(self, form='', feature='', filter_fields='', extras=None):
        """ Create and return parameters as body to functions"""

        client = '"client":{"device":9, "infoType":100, "lang":"ES"}, '
        form = '"form":{' + form + '}, '
        feature = '"feature":{' + feature + '}, '
        filter_fields = '"filterFields":{' + filter_fields + '}'
        page_info = '"pageInfo":{}'
        data = '"data":{' + filter_fields + ', ' + page_info
        if extras is not None:
            data += ', ' + extras
        data += '}'

        body = "" + client + form + feature + data
        return body


    def put_widgets(self, dialog, field, lbl, widget):
        """ Insert widget into layout """
        layout = dialog.findChild(QGridLayout, field['layoutname'])
        if layout is None:
            return
        layout.addWidget(lbl, int(field['layout_order']), 0)
        layout.addWidget(widget, int(field['layout_order']), 2)
        layout.setColumnStretch(2, 1)


    def set_widgets(self, dialog, field):
        widget = None
        label = None
        if field['label']:
            label = QLabel()
            label.setObjectName('lbl_' + field['widgetname'])
            label.setText(field['label'].capitalize())
            if field['stylesheet'] is not None and 'label' in field['stylesheet']:
                label = self.set_setStyleSheet(field, label)
            if 'tooltip' in field:
                label.setToolTip(field['tooltip'])
            else:
                label.setToolTip(field['label'].capitalize())
        if field['widgettype'] == 'text' or field['widgettype'] == 'typeahead':
            widget = self.add_lineedit(field)
            widget = self.set_widget_size(widget, field)
            widget = self.set_data_type(field, widget)
            if Qgis.QGIS_VERSION_INT < 29900:
                widget.lostFocus.connect(partial(self.get_values, dialog, widget, self.my_json))
            else:
                widget.editingFinished.connect(partial(self.get_values, dialog, widget, self.my_json))
            widget = self.set_function_associated(dialog, widget, field)
        elif field['widgettype'] == 'combo':
            widget = self.add_combobox(field)
            widget = self.set_widget_size(widget, field)
            widget.currentIndexChanged.connect(partial(self.get_values, dialog, widget, self.my_json))
        return label, widget


    def set_setStyleSheet(self, field, widget, wtype='label'):
        if field['stylesheet'] is not None:
            if wtype in field['stylesheet']:
                widget.setStyleSheet("QWidget{" + field['stylesheet'][wtype] + "}")
        return widget

    def set_function_associated(self, dialog, widget, field):
        function_name = 'no_function_associated'
        if 'widgetfunction' in field:
            if field['widgetfunction'] is not None:
                function_name = field['widgetfunction']
            else:
                msg = ("parameter button_function is null for button " + widget.objectName())
                self.controller.show_message(msg, 2)
        else:
            msg = "parameter button_function not found"
            self.controller.show_message(msg, 2)
        if type(widget) == QLineEdit:
            if Qgis.QGIS_VERSION_INT < 29900:
                widget.lostFocus.connect(partial(getattr(self, function_name), dialog, widget, self.my_json))
                #widget.textChanged.connect(partial(getattr(self, function_name), dialog, widget, self.my_json))
            else:
                widget.editingFinished.connect(partial(getattr(self, function_name), dialog, widget, self.my_json))
        #elif type(widget) == QComboBox:
        return widget
    def add_lineedit(self, field):
        """ Add widgets QLineEdit type """

        widget = QLineEdit()
        widget.setObjectName(field['widgetname'])
        widget.setProperty('column_id', field['column_id'])
        if 'value' in field:
            widget.setText(field['value'])
        if 'iseditable' in field:
            widget.setReadOnly(not field['iseditable'])
            if not field['iseditable']:
                widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242);"
                                     " color: rgb(100, 100, 100)}")
        if 'placeholder' in field:
            if field['placeholder'] is not None:
                widget.setPlaceholderText(field['placeholder'])

        return widget


    def set_data_type(self, field, widget):
        if 'dataType' in field:
            if field['dataType'] == 'integer':  # Integer
                widget.setValidator(QIntValidator())
            elif field['dataType'] == 'string':  # String
                pass
                # function_name = "test"
                # widget.returnPressed.connect(partial(getattr(self, function_name)))
            elif field['dataType'] == 'date':  # Date
                pass
            elif field['dataType'] == 'datetime':  # DateTime
                pass
            elif field['dataType'] == 'boolean':  # Boolean
                pass
            elif field['dataType'] == 'double':  # Double
                validator = QDoubleValidator()
                validator.setRange(-9999999.0, 9999999.0, 3)
                validator.setNotation(QDoubleValidator().StandardNotation)
                widget.setValidator(validator)
        return widget


    def add_combobox(self, field):
        widget = QComboBox()
        widget.setObjectName(field['widgetname'])
        widget.setProperty('column_id', field['column_id'])
        self.populate_combo(widget, field)
        if 'selectedId' in field:
            utils_giswater.set_combo_itemData(widget, field['selectedId'], 0)
        return widget


    def populate_combo(self, widget, field):
        """ Generate list of items to add into combo """
        widget.blockSignals(True)
        widget.clear()
        widget.blockSignals(False)
        combolist = []
        if 'comboIds' in field:
            for i in range(0, len(field['comboIds'])):
                elem = [field['comboIds'][i], field['comboNames'][i]]
                combolist.append(elem)

        # Populate combo
        for record in combolist:
            widget.addItem(record[1], record)


    def set_widget_size(self, widget, field):
        if 'widgetdim' in field:
            if field['widgetdim']:
                widget.setMaximumWidth(field['widgetdim'])
                widget.setMinimumWidth(field['widgetdim'])
        return widget

    def get_values(self, dialog, widget, _json=None):
        value = None
        if type(widget) in(QLineEdit, QSpinBox, QDoubleSpinBox) and widget.isReadOnly() is False:
            value = utils_giswater.getWidgetText(dialog, widget, return_string_null=False)
        elif type(widget) is QComboBox and widget.isEnabled():
            value = utils_giswater.get_item_data(dialog, widget, 0)

        if str(value) == '' or value is None:
            _json[str(widget.property('column_id'))] = None
        else:
            _json[str(widget.property('column_id'))] = str(value)


    def draw_rectangle(self, result, reset_rb=True):
        """ Draw lines based on geometry """
        if result['geometry'] is None:
            return
        list_coord = re.search('\((.*)\)', str(result['geometry']['st_astext']))
        # if reset_rb is True:
        #     self.resetRubberbands()
        points = self.get_points(list_coord)
        self.draw_polygon(points)

    def get_points(self, list_coord=None):
        """ Return list of QgsPoints taken from geometry
        :type list_coord: list of coors in format ['x1 y1', 'x2 y2',....,'x99 y99']
        """

        coords = list_coord.group(1)
        polygon = coords.split(',')
        points = []

        for i in range(0, len(polygon)):
            x, y = polygon[i].split(' ')
            print(x)
            point = QgsPoint(float(x), float(y))
            points.append(point)
        return points

    def draw_polygon(self, points, color=QColor(255, 0, 0, 100), width=5, duration_time=None):
        """ Draw 'line' over canvas following list of points """

        if Qgis.QGIS_VERSION_INT < 29900:
            rb = self.rubber_polygon
            rb.setToGeometry(QgsGeometry.fromPolyline(points), None)
            rb.setColor(color)
            rb.setWidth(width)
            rb.show()
            return rb
        else:
            self.vMarker = QgsVertexMarker(self.canvas)
            self.vMarker.setIconSize(width)
            self.vMarker.setCenter(points)
            self.vMarker.show()
            return self.vMarker

        # # wait to simulate a flashing effect
        # if duration_time is not None:
        #     QTimer.singleShot(duration_time, self.resetRubberbands)
    def hide_void_groupbox(self, dialog):
        # Hide empty grupbox
        grbox_list = dialog.findChildren(QGroupBox)
        for grbox in grbox_list:
            widget_list = grbox.findChildren(QWidget)
            if len(widget_list) == 0:
                grbox.setVisible(False)
    # def resetRubberbands(self):
    #
    #     canvas = self.canvas
    #     if Qgis.QGIS_VERSION_INT < 20000:
    #         self.vMarker.hide()
    #         canvas.scene().removeItem(self.vMarker)
    #     elif Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
    #         self.rubber_point.reset(Qgis.Point)
    #         self.rubber_polygon.reset()
    #     else:
    #         self.rubber_point.reset(QgsWkbTypes.PointGeometry)
    #         self.rubber_polygon.reset()

