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

if Qgis.QGIS_VERSION_INT < 29900:
    import ConfigParser as configparser
    from qgis.PyQt.QtGui import QCursor, QIcon, QPixmap, QCompleter, QStringListModel, QApplication, QTableView
else:
    import configparser
    from qgis.PyQt.QtCore import QStringListModel
    from qgis.PyQt.QtGui import QCursor, QIcon, QPixmap
    from qgis.PyQt.QtWidgets import QCompleter, QApplication, QTableView

from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.core import QgsExpression

import os
import sys
if 'nt' in sys.builtin_module_names:
    import ctypes

from .. import utils_giswater
from ..ui_manager import GwDialog, GwMainWindow


class TmParentAction(object):
    
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class constructor """

        # Initialize instance attributes
        self.tree_manage_version = "1.0"
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir
        self.dao = self.controller.dao
        self.schema_name = self.controller.schema_name
        self.project_type = None
        self.file_gsw = None
        self.gsw_settings = None
        self.lazy_widget = None


    def set_controller(self, controller):
        """ Set controller class """

        self.controller = controller
        self.schema_name = self.controller.schema_name


    def get_plugin_version(self):
        """ Get plugin version from metadata.txt file """

        # Check if metadata file exists
        metadata_file = os.path.join(self.plugin_dir, 'metadata.txt')
        if not os.path.exists(metadata_file):
            message = "Metadata file not found" + metadata_file
            self.controller.show_warning(message, parameter=metadata_file)
            return None

        metadata = configparser.ConfigParser()
        metadata.read(metadata_file)
        plugin_version = metadata.get('general', 'version')
        if plugin_version is None:
            message = "Plugin version not found"
            self.controller.show_warning(message)

        return plugin_version


    def load_settings(self, dialog=None):
        """ Load QGIS settings related with dialog position and size """

        if dialog is None:
            dialog = self.dlg

        try:
            screens = ctypes.windll.user32
            screen_x = screens.GetSystemMetrics(78)
            screen_y = screens.GetSystemMetrics(79)
            x = self.controller.plugin_settings_value(dialog.objectName() + "_x")
            y = self.controller.plugin_settings_value(dialog.objectName() + "_y")
            width = self.controller.plugin_settings_value(dialog.objectName() + "_width", dialog.property('width'))
            height = self.controller.plugin_settings_value(dialog.objectName() + "_height", dialog.property('height'))

            if int(x) < 0 or int(y) < 0:
                dialog.resize(int(width), int(height))
            else:
                if int(x) > screen_x:
                    x = int(screen_x) - int(width)
                if int(y) > screen_y:
                    y = int(screen_y)
                dialog.setGeometry(int(x), int(y), int(width), int(height))
        except:
            pass


    def save_settings(self, dialog=None):
        """ Save QGIS settings related with dialog position and size """

        if dialog is None:
            dialog = self.dlg

        self.controller.plugin_settings_set_value(dialog.objectName() + "_width", dialog.width())
        self.controller.plugin_settings_set_value(dialog.objectName() + "_height", dialog.height())
        self.controller.plugin_settings_set_value(dialog.objectName() + "_x", dialog.pos().x() + 8)
        self.controller.plugin_settings_set_value(dialog.objectName() + "_y", dialog.pos().y() + 31)


    def open_dialog(self, dlg=None, dlg_name=None, info=True, maximize_button=True, stay_on_top=True):
        """ Open dialog """

        if dlg is None or type(dlg) is bool:
            dlg = self.dlg

        # Manage i18n of the dialog
        if dlg_name:
            self.controller.manage_translation(dlg_name, dlg)

        # Manage stay on top, maximize/minimize button and information button
        # if info is True maximize flag will be ignored
        # To enable maximize button you must set info to False
        flags = Qt.WindowCloseButtonHint
        if info:
            flags |= Qt.WindowSystemMenuHint | Qt.WindowContextHelpButtonHint
        else:
            if maximize_button:
                flags |= Qt.WindowMinMaxButtonsHint

        if stay_on_top:
            flags |= Qt.WindowStaysOnTopHint

        dlg.setWindowFlags(flags)

        # Open dialog
        if issubclass(type(dlg), GwDialog):
            dlg.open()
        elif issubclass(type(dlg), GwMainWindow):
            dlg.show()
        else:
            print(f"WARNING: dialog type {type(dlg)} is not handled!")
            dlg.show()


    def close_dialog(self, dlg=None):
        """ Close dialog """

        try:
            self.save_settings(dlg)
            dlg.close()
            map_tool = self.canvas.mapTool()
            # If selected map tool is from the plugin, set 'Pan' as current one
            if map_tool.toolName() == '':
                self.iface.actionPan().trigger()
        except AttributeError:
            pass


    def hide_colums(self, widget, comuns_to_hide):
        for i in range(0, len(comuns_to_hide)):
            widget.hideColumn(comuns_to_hide[i])


    def set_icon(self, widget, icon):
        """ Set @icon to selected @widget """

        # Get icons folder
        icons_folder = os.path.join(self.plugin_dir, 'icons')
        icon_path = os.path.join(icons_folder, str(icon) + ".png")
        if os.path.exists(icon_path):
            widget.setIcon(QIcon(icon_path))
        else:
            self.controller.log_info("File not found", parameter=icon_path)


    def check_expression(self, expr_filter, log_info=False):
        """ Check if expression filter @expr_filter is valid """

        if log_info:
            self.controller.log_info(expr_filter)
        expr = QgsExpression(expr_filter)
        if expr.hasParserError():
            message = "Expression Error"
            self.controller.log_warning(message, parameter=expr_filter)
            return False, expr
        
        return True, expr


    def set_table_columns(self, dialog, widget, table_name, project_type=None):
        """ Configuration of tables. Set visibility and width of columns """

        widget = utils_giswater.getWidget(dialog, widget)
        if not widget:
            return

        # Set width and alias of visible columns
        columns_to_delete = []
        sql = (f"SELECT column_index, width, alias, status"
               f" FROM config_client_forms"
               f" WHERE table_id = '{table_name}'")
        if project_type is not None:
            sql += f" AND project_type = '{project_type}' "
        sql += " ORDER BY column_index"

        rows = self.controller.get_rows(sql, log_info=False)
        if not rows:
            return

        for row in rows:
            if not row['status']:
                columns_to_delete.append(row['column_index'] - 1)
            else:
                width = row['width']
                if width is not None:
                    widget.setColumnWidth(row['column_index'] - 1, width)
                widget.model().setHeaderData(row['column_index'] - 1, Qt.Horizontal, row['alias'])

        widget.model().select()

        # Delete columns
        for column in columns_to_delete:
            widget.hideColumn(column)


    def set_completer_object(self, tablename, widget, field_search):
        """ Set autocomplete of widget @table_object + "_id"
            getting id's from selected @table_object
        """
        
        if not widget:
            return

        # Set SQL
        sql = (f"SELECT DISTINCT({field_search})"
               f" FROM {tablename}"
               f" ORDER BY {field_search}")
        rows = self.controller.get_rows(sql)
        if not rows:
            return

        for i in range(0, len(rows)):
            aux = rows[i]
            rows[i] = aux[0]

        # Set completer and model: add autocomplete in the widget
        self.completer = QCompleter()
        self.completer.setCaseSensitivity(Qt.CaseInsensitive)
        self.completer.setCompletionMode(0)
        widget.setCompleter(self.completer)
        model = QStringListModel()
        model.setStringList(rows)
        self.completer.setModel(model)


    def refresh_map_canvas(self, restore_cursor=False):
        """ Refresh all layers present in map canvas """

        self.canvas.refreshAllLayers()
        for layer_refresh in self.canvas.layers():
            layer_refresh.triggerRepaint()

        if restore_cursor:
            self.set_cursor_restore()


    def set_cursor_restore(self):
        """ Restore to previous cursors """
        QApplication.restoreOverrideCursor()


    def get_cursor_multiple_selection(self):
        """ Set cursor for multiple selection """

        path_folder = os.path.join(os.path.dirname(__file__), os.pardir)
        path_cursor = os.path.join(path_folder, 'icons', '201.png')
        if os.path.exists(path_cursor):
            cursor = QCursor(QPixmap(path_cursor))
        else:
            cursor = QCursor(Qt.ArrowCursor)

        return cursor


    def fill_table(self, qtable, table_name, set_edit_triggers=QTableView.NoEditTriggers, expr_filter=None):
        """ Fill table @widget filtering query by @workcat_id
            Set a model with selected filter.
            Attach that model to selected table
            @setEditStrategy:
             0: OnFieldChange
             1: OnRowChange
             2: OnManualSubmit
        """

        expr = None
        if expr_filter:
            # Check expression
            (is_valid, expr) = self.check_expression(expr_filter)  # @UnusedVariable
            if not is_valid:
                return expr

        # Set a model with selected filter expression
        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.setSort(0, 0)
        model.select()

        # When change some field we need to refresh Qtableview and filter by psector_id
        qtable.setEditTriggers(set_edit_triggers)

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())
        # Attach model to table view
        if expr:
            qtable.setModel(model)
            qtable.model().setFilter(expr_filter)
        else:
            qtable.setModel(model)

        return expr


    def get_feature_by_id(self, layer, id, field_id):

        features = layer.getFeatures()
        for feature in features:
            if feature[field_id] == id:
                return feature

        return False

