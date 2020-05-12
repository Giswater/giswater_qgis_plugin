"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: latin-1 -*-
from qgis.core import QgsLayoutItemMap, QgsPrintLayout, QgsLayoutItemLabel, QgsLayoutExporter
from qgis.PyQt.QtGui import QRegExpValidator
from qgis.PyQt.QtCore import QRegExp
from qgis.PyQt.QtPrintSupport import QPrinter, QPrintDialog
from qgis.PyQt.QtWidgets import QLineEdit, QDialog

import json
from functools import partial

from .. import utils_giswater
from .api_parent import ApiParent
from ..ui_manager import FastPrintUi


class ApiManageComposer(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control Composer button """

        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.destroyed = False
        self.printer = None


    def composer(self):

        self.my_json = {}
        composers_list = self.get_composer()
        if composers_list == '"{}"':
            msg = "No composers found."
            self.controller.show_info_box(msg, "Info")
            return

        self.initial_rotation = self.iface.mapCanvas().rotation()

        self.dlg_composer = FastPrintUi()
        self.load_settings(self.dlg_composer)

        # Create and populate dialog
        extras = '"composers":' + str(composers_list)
        body = self.create_body(extras=extras)
        complet_result = self.controller.get_json('gw_fct_getprint', body, log_sql=True)
        if not complet_result: return False

        if complet_result['formTabs']:
            fields = complet_result['formTabs'][0]
            # This dialog is created from config_api_form_fieds
            # where formname == 'printGeneric' and formtype == 'utils'
            # At the moment, u can set column widgetfunction with 'gw_fct_setprint' or open_composer
            self.create_dialog(self.dlg_composer, fields)
        self.hide_void_groupbox(self.dlg_composer)

        # Set current values from canvas
        rotation = self.iface.mapCanvas().rotation()
        scale = int(self.iface.mapCanvas().scale())

        w_rotation = self.dlg_composer.findChild(QLineEdit, "data_rotation")
        if w_rotation:
            w_rotation.editingFinished.connect(partial(self.set_rotation, w_rotation))
            utils_giswater.setWidgetText(self.dlg_composer, w_rotation, rotation)

        w_scale = self.dlg_composer.findChild(QLineEdit, "data_scale")
        if w_scale:
            w_scale.editingFinished.connect(partial(self.set_scale, w_scale))
            reg_exp = QRegExp("\d{0,8}[\r]?")
            w_scale.setValidator(QRegExpValidator(reg_exp))
            utils_giswater.setWidgetText(self.dlg_composer, w_scale, scale)
        self.my_json['rotation'] = rotation
        self.my_json['scale'] = scale

        # Signals
        self.dlg_composer.btn_print.clicked.connect(partial(self.__print, self.dlg_composer))
        self.dlg_composer.btn_preview.clicked.connect(partial(self.preview, self.dlg_composer, True))
        self.dlg_composer.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_composer))
        self.dlg_composer.btn_close.clicked.connect(partial(self.save_settings, self.dlg_composer))
        self.dlg_composer.btn_close.clicked.connect(self.destructor)
        self.dlg_composer.rejected.connect(partial(self.save_settings, self.dlg_composer))
        self.dlg_composer.rejected.connect(self.destructor)

        self.check_whidget_exist(self.dlg_composer)
        self.load_composer_values(self.dlg_composer)
        
        self.open_dialog(self.dlg_composer, dlg_name='fastprint')

        # Control if no have composers
        if composers_list != '"{}"':
            self.accept(self.dlg_composer, self.my_json)
            self.iface.mapCanvas().extentsChanged.connect(partial(self.accept, self.dlg_composer, self.my_json))
        else:
            self.dlg_composer.btn_print.setEnabled(False)
            self.dlg_composer.btn_preview.setEnabled(False)

    def set_rotation(self, widget):
        """ Set rotation to mapCanvas """
        self.iface.mapCanvas().setRotation(float(widget.text()))


    def set_scale(self, widget):
        """ Set zoomScale to mapCanvas """
        self.iface.mapCanvas().zoomScale(float(widget.text()))

    def check_whidget_exist(self, dialog):
        """ Check if widget exist in composer """

        selected_com = self.get_current_composer()
        widget_list = dialog.grb_option_values.findChildren(QLineEdit)
        for widget in widget_list:
            item = selected_com.itemById(widget.property('column_id'))
            if type(item) != QgsLayoutItemLabel or item is None:
                widget.clear()
                widget.setStyleSheet("border: 1px solid red")
                widget.setPlaceholderText(f"Widget '{widget.property('column_id')}' not found in the composer")
            elif type(item) == QgsLayoutItemLabel and item is not None:
                widget.setStyleSheet(None)


    def load_composer_values(self, dialog):
        """ Load values from composer into form dialog """

        selected_com = self.get_current_composer()
        widget_list = dialog.grb_option_values.findChildren(QLineEdit)

        if selected_com is not None:
            for widget in widget_list:
                item = selected_com.itemById(widget.property('column_id'))
                if type(item) == QgsLayoutItemLabel:
                    widget.setText(str(item.text()))


    def open_composer(self, dialog):
        """ Open selected composer and load values from composer into form dialog """

        selected_com = self.get_current_composer()
        if selected_com is not None:
            self.iface.openLayoutDesigner(layout=selected_com)

        self.load_composer_values(dialog)


    def preview(self, dialog, show):
        """ Export values from widgets(only QLineEdit) into dialog, to selected composer
            if composer.widget.id == dialog.widget.property('column_id')
        """

        selected_com = self.get_current_composer()
        widget_list = dialog.findChildren(QLineEdit)

        for widget in widget_list:
            item = selected_com.itemById(widget.property('column_id'))
            if type(item) == QgsLayoutItemLabel:
                item.setText(str(widget.text()))
                item.refresh()
        if show:
            self.open_composer(dialog)


    def destructor(self):
        self.iface.mapCanvas().setRotation(self.initial_rotation)
        self.destroyed = True
        if self.rubber_polygon:
            self.iface.mapCanvas().scene().removeItem(self.rubber_polygon)
            self.rubber_polygon = None


    def get_composer(self, removed=None):
        """ Get all composers from current QGis project """

        composers = '"{'
        active_composers = self.get_composers_list()

        for composer in active_composers:
            if type(composer) == QgsPrintLayout:
                if composer != removed and composer.name():
                    cur = composer.name()
                    composers += cur + ', '
        if len(composers) > 2:
            composers = composers[:-2] + '}"'
        else:
            composers += '}"'
        return composers


    def create_dialog(self, dialog, fields):

        for field in fields['fields']:
            label, widget = self.set_widgets_into_composer(dialog, field)
            self.put_widgets(dialog, field, label, widget)
            self.get_values(dialog, widget, self.my_json)


    def get_current_composer(self):
        """ Get composer selected in QComboBox """

        selected_com = None
        active_composers = self.get_composers_list()
        for composer in active_composers:
            if composer.name() == self.my_json['composer']:
                selected_com = composer
                break

        return selected_com


    def __print(self, dialog):

        if not self.printer:
            self.printer = QPrinter()
        self.preview(dialog, False)
        selected_com = self.get_current_composer()
        if selected_com is None:
            return

        printdialog = QPrintDialog(self.printer)
        if printdialog.exec_() != QDialog.Accepted:
            return

        actual_printer = QgsLayoutExporter(selected_com)
        # The correct instruction for python3 is:
        # success = actual_printer.print(self.printer, QgsLayoutExporter.PrintExportSettings())
        # but python2 produces an error in the word 'print' at actual_printer.print(...),
        # then we need to create a fake to cheat python2
        print_ = getattr(actual_printer, 'print')
        success = print_(self.printer, QgsLayoutExporter.PrintExportSettings())


    def update_rectangle(self, dialog, my_json):
        pass


    def gwSetPrint(self, dialog, my_json):

        if my_json['composer'] != '-1':
            self.check_whidget_exist(self.dlg_composer)
            self.load_composer_values(dialog)
            self.accept(dialog, my_json)


    def gwSetComposer(self, dialog, my_json):

        if my_json['composer'] != '-1':
            self.preview(dialog, False)
            self.accept(dialog, my_json)


    def accept(self, dialog, my_json):

        if self.destroyed:
            return

        if my_json == '' or str(my_json) == '{}':
            self.close_dialog(dialog)
            return False

        composer_templates = []
        active_composers = self.get_composers_list()
        for composer in active_composers:
            composer_map = []
            composer_template = {'ComposerTemplate': composer.name()}
            index = 0
            for item in composer.items():
                cur_map = {}
                if isinstance(item, QgsLayoutItemMap):
                    cur_map['width'] = item.rect().width()
                    cur_map['height'] = item.rect().height()
                    cur_map['name'] = item.displayName()
                    cur_map['index'] = index
                    composer_map.append(cur_map)
                    composer_template['ComposerMap'] = composer_map
                    index += 1
            composer_templates.append(composer_template)
            my_json['ComposerTemplates'] = composer_templates

        composer_name = my_json['composer']
        rotation = my_json['rotation']
        scale = my_json['scale']
        extent = self.iface.mapCanvas().extent()

        p1 = {'xcoord': extent.xMinimum(), 'ycoord': extent.yMinimum()}
        p2 = {'xcoord': extent.xMaximum(), 'ycoord': extent.yMaximum()}
        ext = {'p1': p1, 'p2': p2}
        my_json['extent'] = ext

        my_json = json.dumps(my_json)
        client = '"client":{"device":9, "infoType":100, "lang":"ES"}, '
        form = '"form":{''}, '
        feature = '"feature":{''}, '
        data = '"data":' + str(my_json)
        body = "$${" + client + form + feature + data + "}$$"
        complet_result = self.controller.get_json('gw_fct_setprint', body, log_sql=True)
        if not complet_result: return False

        result = complet_result['data']
        self.draw_rectangle(result)
        map_index = complet_result['data']['mapIndex']

        maps = []
        active_composers = self.get_composers_list()
        for composer in active_composers:
            maps = []
            if composer.name() == composer_name:
                for item in composer.items():
                    if isinstance(item, QgsLayoutItemMap):
                        maps.append(item)
                break

        if len(maps) > 0:
            if rotation is None or rotation == 0:
                rotation = self.iface.mapCanvas().rotation()
            if scale is None or scale == 0:
                scale = self.iface.mapCanvas().scale()
            self.iface.mapCanvas().setRotation(float(rotation))
            maps[map_index].zoomToExtent(self.iface.mapCanvas().extent())
            maps[map_index].setScale(float(scale))
            maps[map_index].setMapRotation(float(rotation))

        return True

