"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: latin-1 -*-
try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    from qgis.core import QgsComposerMap, QgsComposerLabel as QgsLayoutItemLabel
    from qgis.gui import  QgsComposerView
    from qgis.PyQt.QtGui import QPrintDialog, QPrinter, QDialog
else:
    from qgis.core import QgsLayoutItemMap, QgsPrintLayout, QgsLayoutItemLabel, QgsLayoutExporter
    from qgis.PyQt.QtPrintSupport import QPrinter, QPrintDialog

from qgis.PyQt.QtGui import QRegExpValidator
from qgis.PyQt.QtCore import QRegExp, Qt
from qgis.PyQt.QtWidgets import QLineEdit, QDialog

import json
from collections import OrderedDict
from functools import partial

import utils_giswater
from giswater.actions.api_parent import ApiParent
from giswater.ui_manager import ApiComposerUi


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

        self.dlg_composer = ApiComposerUi()
        self.load_settings(self.dlg_composer)

        # Create and populate dialog
        extras = '"composers":' + str(composers_list)
        body = self.create_body(extras=extras)
        sql = ("SELECT " + self.schema_name + ".gw_api_getprint($${" + body + "}$$)::text")
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if not row or row[0] is None:
            self.controller.show_warning("NOT ROW FOR: " + sql)
            return False

        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
        if complet_result[0]['formTabs']:
            fields = complet_result[0]['formTabs'][0]
            # This dialog is created from config_api_form_fieds
            # where formname == 'printGeneric' and formtype == 'utils'
            # At the moment, u can set column widgetfunction with 'gw_api_setprint' or open_composer
            self.create_dialog(self.dlg_composer, fields)
        self.hide_void_groupbox(self.dlg_composer)

        # Set current values from canvas
        w_rotation = self.dlg_composer.findChild(QLineEdit, "data_rotation")
        w_scale = self.dlg_composer.findChild(QLineEdit, "data_scale")
        reg_exp = QRegExp("\d{0,8}[\r]?")
        w_scale.setValidator(QRegExpValidator(reg_exp))
        rotation = self.iface.mapCanvas().rotation()
        scale = int(self.iface.mapCanvas().scale())
        utils_giswater.setWidgetText(self.dlg_composer, w_rotation, rotation)
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
        self.dlg_composer.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_composer.show()

        # Control if no have composers
        if composers_list != '"{}"':
            self.accept(self.dlg_composer, self.my_json)
            self.iface.mapCanvas().extentsChanged.connect(partial(self.accept, self.dlg_composer, self.my_json))
        else:
            self.dlg_composer.btn_print.setEnabled(False)
            self.dlg_composer.btn_preview.setEnabled(False)


    def check_whidget_exist(self, dialog):
        """ Check if widget exist in composer """

        selected_com = self.get_current_composer()
        widget_list = dialog.grb_option_values.findChildren(QLineEdit)
        for widget in widget_list:
            if Qgis.QGIS_VERSION_INT < 29900:
                composition = selected_com.composition()
                item = composition.getComposerItemById(widget.property('column_id'))
            else:
                item = selected_com.itemById(widget.property('column_id'))
            if type(item) != QgsLayoutItemLabel or item is None:
                widget.clear()
                widget.setStyleSheet("border: 1px solid red")
                widget.setPlaceholderText("Widget '{}' not found into composer".format(widget.property('column_id')))
            elif type(item) == QgsLayoutItemLabel and item is not None:
                widget.setStyleSheet("border: 1px solid gray")


    def load_composer_values(self, dialog, widget=None, my_json=None):
        """ Load values from composer into form dialog """

        selected_com = self.get_current_composer()
        widget_list = dialog.grb_option_values.findChildren(QLineEdit)

        if selected_com is not None:
            if Qgis.QGIS_VERSION_INT < 29900:
                composition = selected_com.composition()
                for widget in widget_list:
                    item = composition.getComposerItemById(widget.property('column_id'))
                    if type(item) == QgsLayoutItemLabel:
                        widget.setText(item.text())
            else:
                for widget in widget_list:
                    item = selected_com.itemById(widget.property('column_id'))
                    if type(item) == QgsLayoutItemLabel:
                        widget.setText(str(item.text()))


    def open_composer(self, dialog):
        """ Open selected composer and load values from composer into form dialog """

        selected_com = self.get_current_composer()
        if selected_com is not None:
            if Qgis.QGIS_VERSION_INT < 29900:
                selected_com.composerWindow().show()
            else:
                self.iface.openLayoutDesigner(layout=selected_com)

        self.load_composer_values(dialog)


    def preview(self, dialog, show):
        """ Export values from widgets(only QLineEdit) into dialog, to selected composer
            if composer.widget.id == dialog.widget.property('column_id')
        """

        selected_com = self.get_current_composer()
        widget_list = dialog.findChildren(QLineEdit)

        if Qgis.QGIS_VERSION_INT < 29900:
            selected_com.composerWindow().show()
            composition = selected_com.composition()
            for widget in widget_list:
                item = composition.getComposerItemById(widget.property('column_id'))
                if type(item) == QgsLayoutItemLabel:
                    item.setText(str(widget.text()))
            composition.refreshItems()
            composition.update()
        else:
            for widget in widget_list:
                item = selected_com.itemById(widget.property('column_id'))
                if type(item) == QgsLayoutItemLabel:
                    item.setText(str(widget.text()))
                    item.refresh()
        if show:
            self.open_composer(dialog)


    def destructor(self):

        self.destroyed = True
        if self.rubber_polygon:
            self.iface.mapCanvas().scene().removeItem(self.rubber_polygon)
            self.rubber_polygon = None


    def get_composer(self, removed=None):
        """ Get all composers from current QGis project """

        composers = '"{'
        active_composers = self.get_composers_list()

        for composer in active_composers:
            if Qgis.QGIS_VERSION_INT < 29900:
                if type(composer) == QgsComposerView:
                    if composer != removed and composer.composerWindow():
                        cur = composer.composerWindow().windowTitle()
                        composers += cur + ', '
            else:
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
            self.put_widgets(dialog, field, label, None, widget)
            self.get_values(dialog, widget, self.my_json)


    def get_current_composer(self):
        """ Get composer selected in QComboBox """

        selected_com = None
        active_composers = self.get_composers_list()
        for composer in active_composers:
            if Qgis.QGIS_VERSION_INT < 29900:
                if composer.composerWindow().windowTitle() == self.my_json['composer']:
                    selected_com = composer
                    break
            else:
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

        if Qgis.QGIS_VERSION_INT < 29900:
            print_ = getattr(selected_com.composition(), 'print')
            success = print_(self.printer)
        else:
            actual_printer = QgsLayoutExporter(selected_com)
            # The correct instruction for python3 is:
            # success = actual_printer.print(self.printer, QgsLayoutExporter.PrintExportSettings())
            # but python2 produces an error in the word 'print' at actual_printer.print(...),
            # then we need to create a fake to cheat python2
            print_ = getattr(actual_printer, 'print')
            success = print_(self.printer, QgsLayoutExporter.PrintExportSettings())


    def update_rectangle(self, dialog, my_json):
        pass


    def gw_api_setprint(self, dialog, my_json):

        if my_json['composer'] != '-1':
            self.check_whidget_exist(self.dlg_composer)
            self.load_composer_values(dialog)
            self.accept(dialog, my_json)


    def gw_api_set_composer(self, dialog, my_json):

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
            if Qgis.QGIS_VERSION_INT < 29900:
                composer_template = {'ComposerTemplate': composer.composerWindow().windowTitle()}
                # Get map(item) from each composer template
                index = 0
                for item in composer.composition().items():
                    cur_map = {}
                    if isinstance(item, QgsComposerMap):
                        cur_map['width'] = item.rect().width()
                        cur_map['height'] = item.rect().height()
                        cur_map['name'] = item.displayName()
                        cur_map['index'] = index
                        composer_map.append(cur_map)
                        composer_template['ComposerMap'] = composer_map
                        index += 1
            else:
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
        body = "" + client + form + feature + data
        sql = ("SELECT " + self.schema_name + ".gw_api_setprint($${" + body + "}$$)::text")
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if not row or row[0] is None:
            self.controller.show_warning("NOT ROW FOR: " + sql)
            return False

        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
        result = complet_result[0]['data']
        self.draw_rectangle(result)
        map_index = complet_result[0]['data']['mapIndex']

        maps = []
        active_composers = self.get_composers_list()
        for composer in active_composers:
            maps = []
            if Qgis.QGIS_VERSION_INT < 29900:
                if composer.composerWindow().windowTitle() == composer_name:
                    for item in composer.composition().items():
                        if isinstance(item, QgsComposerMap):
                            maps.append(item)
                    break
            else:
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
            if Qgis.QGIS_VERSION_INT < 29900:
                maps[map_index].setNewScale(float(scale))
            else:
                maps[map_index].setScale(float(scale))
            maps[map_index].setMapRotation(float(rotation))

        return True

