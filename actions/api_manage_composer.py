"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: latin-1 -*-
import re

try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    pass
else:
    from builtins import range

from qgis.core import QgsComposerMap, QgsPoint, QgsGeometry, QgsRectangle, QgsComposerLabel
from qgis.gui import QgsVertexMarker, QgsRubberBand


from qgis.PyQt.QtCore import Qt, QRectF, QPointF, QRegExp
from qgis.PyQt.QtGui import QColor, QIntValidator, QRegExpValidator, QPrintDialog, QPrinter, QDialog
from qgis.PyQt.QtWidgets import QMessageBox, QLineEdit


import json
import utils_giswater

from collections import OrderedDict
from functools import partial

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
        self.dlg_composer = ApiComposerUi()
        self.load_settings(self.dlg_composer)

        # Create and populate dialog
        composers_list = self.get_composer()
        extras = '"composers":' + str(composers_list)
        body = self.create_body(extras=extras)
        sql = ("SELECT " + self.schema_name + ".gw_api_getprint($${" + body + "}$$)::text")
        row = self.controller.get_row(sql, log_sql=True)
        if not row:
            self.controller.show_warning("NOT ROW FOR: " + sql)
            return False
        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
        if complet_result[0]['formTabs']:
            fields = complet_result[0]['formTabs'][0]
            self.create_dialog(self.dlg_composer, fields)
        self.hide_void_groupbox(self.dlg_composer)
        # Set current values from canvas
        w_rotation = self.dlg_composer.findChild(QLineEdit, "data_rotation")
        w_scale = self.dlg_composer.findChild(QLineEdit, "data_scale")
        reg_exp = QRegExp("\d{8}")
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
        self.dlg_composer.show()

        self.iface.mapCanvas().extentsChanged.connect(partial(self.accept, self.dlg_composer, self.my_json))


    def preview(self, dialog, show):
        """ Export values from widgets(only QLineEdit) into dialog, to selected composer
            if composer.widget.id == dialog.widget.property('column_id')
        """

        selected_com = self.get_current_composer()
        if show:
            selected_com.composerWindow().show()
        composition = selected_com.composition()

        widget_list = dialog.findChildren(QLineEdit)
        for widget in widget_list:
            item = composition.getComposerItemById(widget.property('column_id'))
            if type(item) == QgsComposerLabel:
                item.setText(str(widget.text()))

        composition.refreshItems()
        composition.update()


    def destructor(self):
        self.destroyed = True
        if self.rubber_polygon:
            self.iface.mapCanvas().scene().removeItem(self.rubber_polygon)
            self.rubber_polygon = None


    def get_composer(self, removed=None):
        """ Get all composers from current QGis project """
        composers = '"{'

        for composer in self.iface.activeComposers():
            if composer != removed and composer.composerWindow():
                cur = composer.composerWindow().windowTitle()
                composers += cur + ', '
        if len(composers) > 1:
            composers = composers[:-2] + '}"'
        else:
            composers += '}"'
        return composers


    def create_dialog(self, dialog, fields):
        for field in fields['fields']:
            label, widget = self.set_widgets(dialog, field)
            self.put_widgets(dialog, field, label, widget)
            self.get_values(dialog, widget, self.my_json)


    def get_current_composer(self):
        """ Get composer selected in QComboBox """
        selected_com = None
        for composer in self.iface.activeComposers():
            if composer.composerWindow().windowTitle() == self.my_json['composer']:
                selected_com = composer
                break
        return selected_com


    def __print(self, dialog):
        if not self.printer:
            self.printer = QPrinter()

        printdialog = QPrintDialog(self.printer)
        if printdialog.exec_() != QDialog.Accepted:
            return
        self.preview(dialog, False)
        selected_com = self.get_current_composer()
        if selected_com is None:
            return
        print_ = getattr(selected_com.composition(), 'print')
        success = print_(self.printer)
        # self.controller.log_info(str(success))
        # if not success:
        #     QMessageBox.warning(self.iface.mainWindow(), self.controller.tr("Print Failed"), self.controller.tr("Failed to print the composition."))

    def update_rectangle(self, dialog, my_json):
        pass

    def gw_api_setprint(self, dialog, widget, my_json):
        self.accept(dialog, my_json)

    def accept(self, dialog, my_json):
        scale = None
        rotation = None
        if self.destroyed:
            return
        if my_json == '' or str(my_json) == '{}':
            self.close_dialog(dialog)
            return False
        composer_templates = []
        for composer in self.iface.activeComposers():
            composer_map = []
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
        row = self.controller.get_row(sql, log_sql=True)
        if not row or row[0] is None:
            self.controller.show_warning("NOT ROW FOR: " + sql)
            return False
        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
        result = complet_result[0]['data']
        self.draw_rectangle(result)
        map_index = complet_result[0]['data']['mapIndex']

        maps = []
        for composer in self.iface.activeComposers():
            maps = []
            if composer.composerWindow().windowTitle() == composer_name:
                for item in composer.composition().items():
                    if isinstance(item, QgsComposerMap):
                        maps.append(item)
                break
        if len(maps) > 0:
            if rotation is None or rotation == 0:
                rotation = self.iface.mapCanvas().rotation()
            if scale is None or scale == 0:
                scale = self.iface.mapCanvas().scale()
            self.iface.mapCanvas().setRotation(float(rotation))
            maps[map_index].zoomToExtent(self.iface.mapCanvas().extent())
            maps[map_index].setNewScale(float(scale))
            maps[map_index].setMapRotation(float(rotation))


        return True