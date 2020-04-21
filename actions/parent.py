"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsVectorLayerExporter, QgsDataSourceUri, QgsExpression, QgsFeature, QgsFeatureRequest, QgsField, QgsGeometry, QgsPointXY, QgsProject, QgsRectangle, QgsVectorLayer
from qgis.gui import QgsRubberBand
from qgis.PyQt.QtCore import Qt, QDate, QStringListModel, QTimer, QVariant
from qgis.PyQt.QtWidgets import QGroupBox, QAbstractItemView, QTableView, QFileDialog, QApplication, QCompleter, QAction, QWidget, QSpacerItem, QLabel, QComboBox, QCheckBox, QSizePolicy, QPushButton, QLineEdit, QDoubleSpinBox, QTextEdit, QTabWidget, QGridLayout
from qgis.PyQt.QtGui import QIcon, QColor, QCursor, QPixmap
from qgis.PyQt.QtSql import QSqlTableModel, QSqlQueryModel

import configparser, json, os, re, subprocess, sys, webbrowser
if 'nt' in sys.builtin_module_names:
    import ctypes

from collections import OrderedDict
from functools import partial

from .. import utils_giswater
from .add_layer import AddLayer
from ..ui_manager import BasicInfoUi, GwDialog, GwMainWindow, DockerUi


class ParentAction(object):

    def __init__(self, iface, settings, controller, plugin_dir):  
        """ Class constructor """

        # Initialize instance attributes
        self.iface = iface
        self.canvas = self.iface.mapCanvas()        
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir       
        self.dao = self.controller.dao         
        self.schema_name = self.controller.schema_name
        self.project_type = None
        self.plugin_version = self.get_plugin_version()
        self.add_layer = AddLayer(iface, settings, controller, plugin_dir)
        self.rubber_point = QgsRubberBand(self.canvas, 0)
        self.rubber_point.setColor(Qt.yellow)
        self.rubber_point.setIconSize(10)
        self.rubber_polygon = QgsRubberBand(self.canvas, 2)
        self.rubber_polygon.setColor(Qt.darkRed)
        self.rubber_polygon.setIconSize(20)
        self.user_current_layer = None
        self.dlg_docker = None


    def set_controller(self, controller):
        """ Set controller class """
        
        self.controller = controller
        self.schema_name = self.controller.schema_name       


    def open_web_browser(self, dialog, widget=None):
        """ Display url using the default browser """
        
        if widget is not None:           
            url = utils_giswater.getWidgetText(dialog, widget)
            if url == 'null':
                url = 'http://www.giswater.org'
        else:
            url = 'http://www.giswater.org'
                     
        webbrowser.open(url)


    def get_plugin_version(self):
        """ Get plugin version from metadata.txt file """

        # Check if metadata file exists
        metadata_file = os.path.join(self.plugin_dir, 'metadata.txt')
        if not os.path.exists(metadata_file):
            message = "Metadata file not found"
            self.controller.show_warning(message, parameter=metadata_file)
            return None

        metadata = configparser.ConfigParser()
        metadata.read(metadata_file)
        plugin_version = metadata.get('general', 'version')
        if plugin_version is None:
            message = "Plugin version not found"
            self.controller.show_warning(message)

        return plugin_version


    def get_file_dialog(self, dialog, widget):
        """ Get file dialog """
        
        # Check if selected file exists. Set default value if necessary
        file_path = utils_giswater.getWidgetText(dialog, widget)
        if file_path is None or file_path == 'null' or not os.path.exists(str(file_path)): 
            folder_path = self.plugin_dir   
        else:     
            folder_path = os.path.dirname(file_path) 
                
        # Open dialog to select file
        os.chdir(folder_path)
        file_dialog = QFileDialog()
        file_dialog.setFileMode(QFileDialog.AnyFile)        
        message = "Select file"
        folder_path, filter_ = file_dialog.getOpenFileName(parent=None, caption=self.controller.tr(message))
        if folder_path:
            utils_giswater.setWidgetText(dialog, widget, str(folder_path))
                
                
    def get_folder_dialog(self, dialog, widget):
        """ Get folder dialog """
        
        # Check if selected folder exists. Set default value if necessary
        folder_path = utils_giswater.getWidgetText(dialog, widget)
        if folder_path is None or folder_path == 'null' or not os.path.exists(folder_path): 
            folder_path = os.path.expanduser("~")

        # Open dialog to select folder
        os.chdir(folder_path)
        file_dialog = QFileDialog()
        file_dialog.setFileMode(QFileDialog.Directory)      
        message = "Select folder"
        folder_path = file_dialog.getExistingDirectory(parent=None, caption=self.controller.tr(message), directory=folder_path)
        if folder_path:
            utils_giswater.setWidgetText(dialog, widget, str(folder_path))


    def load_settings(self, dialog=None):
        """ Load QGIS settings related with dialog position and size """

        if dialog is None:
            dialog = self.dlg
                    
        try:
            x = self.controller.plugin_settings_value(dialog.objectName() + "_x")
            y = self.controller.plugin_settings_value(dialog.objectName() + "_y")
            width = self.controller.plugin_settings_value(dialog.objectName() + "_width", dialog.property('width'))
            height = self.controller.plugin_settings_value(dialog.objectName() + "_height", dialog.property('height'))

            if int(x) < 0 or int(y) < 0:
                dialog.resize(int(width), int(height))
            else:
                screens = ctypes.windll.user32
                screen_x = screens.GetSystemMetrics(78)
                screen_y = screens.GetSystemMetrics(79)                
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
            
        self.controller.plugin_settings_set_value(dialog.objectName() + "_width", dialog.property('width'))
        self.controller.plugin_settings_set_value(dialog.objectName() + "_height", dialog.property('height'))
        self.controller.plugin_settings_set_value(dialog.objectName() + "_x", dialog.pos().x()+8)
        self.controller.plugin_settings_set_value(dialog.objectName() + "_y", dialog.pos().y()+31)


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

        if dlg is None or type(dlg) is bool:
            dlg = self.dlg
        try:
            self.save_settings(dlg)
            dlg.close()
            map_tool = self.canvas.mapTool()
            # If selected map tool is from the plugin, set 'Pan' as current one
            if map_tool.toolName() == '':
                self.iface.actionPan().trigger() 
        except AttributeError:
            pass
        except Exception as e:
            print(type(e).__name__)
        
        
    def multi_row_selector(self, dialog, tableleft, tableright, field_id_left, field_id_right, name='name',
                           hide_left=[0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
                                  25, 26, 27, 28, 29, 30], hide_right=[1, 2, 3], aql=""):
        """
        :param dialog:
        :param tableleft: Table to consult and load on the left side
        :param tableright: Table to consult and load on the right side
        :param field_id_left: ID field of the left table
        :param field_id_right: ID field of the right table
        :param name: field name (used in add_lot.py)
        :param hide_left: Columns to hide from the left table
        :param hide_right: Columns to hide from the right table
        :param aql: (add query left) Query added to the left side (used in basic.py def basic_exploitation_selector())
        :return:
        """
        # fill QTableView all_rows
        tbl_all_rows = dialog.findChild(QTableView, "all_rows")
        tbl_all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        schema_name = self.schema_name.replace('"', '')
        query_left = f"SELECT * FROM {schema_name}.{tableleft} WHERE {name} NOT IN "
        query_left += f"(SELECT {schema_name}.{tableleft}.{name} FROM {schema_name}.{tableleft}"
        query_left += f" RIGHT JOIN {schema_name}.{tableright} ON {tableleft}.{field_id_left} = {tableright}.{field_id_right}"
        query_left += f" WHERE cur_user = current_user)"
        query_left += f" AND  {field_id_left} > -1"
        query_left += aql

        self.fill_table_by_query(tbl_all_rows, query_left + f" ORDER BY {name};")
        self.hide_colums(tbl_all_rows, hide_left)
        tbl_all_rows.setColumnWidth(1, 200)

        # fill QTableView selected_rows
        tbl_selected_rows = dialog.findChild(QTableView, "selected_rows")
        tbl_selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        query_right = f"SELECT {tableleft}.{name}, cur_user, {tableleft}.{field_id_left}, {tableright}.{field_id_right}"
        query_right += f" FROM {schema_name}.{tableleft}"
        query_right += f" JOIN {schema_name}.{tableright} ON {tableleft}.{field_id_left} = {tableright}.{field_id_right}"

        query_right += " WHERE cur_user = current_user"

        self.fill_table_by_query(tbl_selected_rows, query_right + f" ORDER BY {name};")
        self.hide_colums(tbl_selected_rows, hide_right)
        tbl_selected_rows.setColumnWidth(0, 200)
        # Button select
        dialog.btn_select.clicked.connect(partial(self.multi_rows_selector, tbl_all_rows, tbl_selected_rows, field_id_left, tableright, field_id_right, query_left, query_right, field_id_right))

        # Button unselect
        query_delete = f"DELETE FROM {schema_name}.{tableright}"
        query_delete += f" WHERE current_user = cur_user AND {tableright}.{field_id_right}="
        dialog.btn_unselect.clicked.connect(partial(self.unselector, tbl_all_rows, tbl_selected_rows, query_delete, query_left, query_right, field_id_right))

        # QLineEdit
        dialog.txt_name.textChanged.connect(partial(self.query_like_widget_text, dialog, dialog.txt_name, tbl_all_rows, tableleft, tableright, field_id_right, field_id_left, name, aql))

        # Order control
        tbl_all_rows.horizontalHeader().sectionClicked.connect(partial(self.order_by_column, tbl_all_rows, query_left))
        tbl_selected_rows.horizontalHeader().sectionClicked.connect(partial(self.order_by_column, tbl_selected_rows, query_right))


    def order_by_column(self, qtable, query, idx):
        """
        :param qtable: QTableView widget
        :param query: Query for populate QsqlQueryModel
        :param idx: The index of the clicked column
        :return:
        """
        oder_by = {0: "ASC", 1: "DESC"}
        sort_order = qtable.horizontalHeader().sortIndicatorOrder()
        col_to_sort = qtable.model().headerData(idx, Qt.Horizontal)
        query += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
        self.fill_table_by_query(qtable, query)
        self.refresh_map_canvas()


    def hide_colums(self, widget, comuns_to_hide):
        for i in range(0, len(comuns_to_hide)):
            widget.hideColumn(comuns_to_hide[i])


    def unselector(self, qtable_left, qtable_right, query_delete, query_left, query_right, field_id_right):

        selected_list = qtable_right.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        expl_id = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = str(qtable_right.model().record(row).value(field_id_right))
            expl_id.append(id_)
        for i in range(0, len(expl_id)):
            self.controller.execute_sql(query_delete + str(expl_id[i]))

        # Refresh
        oder_by = {0: "ASC", 1: "DESC"}
        sort_order = qtable_left.horizontalHeader().sortIndicatorOrder()
        idx = qtable_left.horizontalHeader().sortIndicatorSection()
        col_to_sort = qtable_left.model().headerData(idx, Qt.Horizontal)
        query_left += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
        self.fill_table_by_query(qtable_left, query_left)
        
        sort_order = qtable_right.horizontalHeader().sortIndicatorOrder()
        idx = qtable_right.horizontalHeader().sortIndicatorSection()
        col_to_sort = qtable_right.model().headerData(idx, Qt.Horizontal)
        query_right += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
        self.fill_table_by_query(qtable_right, query_right)
        self.refresh_map_canvas()


    def multi_rows_selector(self, qtable_left, qtable_right, id_ori, 
                            tablename_des, id_des, query_left, query_right, field_id):
        """
            :param qtable_left: QTableView origin
            :param qtable_right: QTableView destini
            :param id_ori: Refers to the id of the source table
            :param tablename_des: table destini
            :param id_des: Refers to the id of the target table, on which the query will be made
            :param query_right:
            :param query_left:
            :param field_id:
        """

        selected_list = qtable_left.selectionModel().selectedRows()

        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        expl_id = []
        curuser_list = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = qtable_left.model().record(row).value(id_ori)
            expl_id.append(id_)
            curuser = qtable_left.model().record(row).value("cur_user")
            curuser_list.append(curuser)
        for i in range(0, len(expl_id)):
            # Check if expl_id already exists in expl_selector
            sql = (f"SELECT DISTINCT({id_des}, cur_user)"
                   f" FROM {tablename_des}"
                   f" WHERE {id_des} = '{expl_id[i]}' AND cur_user = current_user")
            row = self.controller.get_row(sql)

            if row:
                # if exist - show warning
                message = "Id already selected"
                self.controller.show_info_box(message, "Info", parameter=str(expl_id[i]))
            else:
                sql = (f"INSERT INTO {tablename_des} ({field_id}, cur_user) "
                       f" VALUES ({expl_id[i]}, current_user)")
                self.controller.execute_sql(sql)

        # Refresh
        oder_by = {0: "ASC", 1: "DESC"}
        sort_order = qtable_left.horizontalHeader().sortIndicatorOrder()
        idx = qtable_left.horizontalHeader().sortIndicatorSection()
        col_to_sort = qtable_left.model().headerData(idx, Qt.Horizontal)
        query_left += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
        self.fill_table_by_query(qtable_right, query_right)

        sort_order = qtable_right.horizontalHeader().sortIndicatorOrder()
        idx = qtable_right.horizontalHeader().sortIndicatorSection()
        col_to_sort = qtable_right.model().headerData(idx, Qt.Horizontal)
        query_right += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
        self.fill_table_by_query(qtable_left, query_left)
        self.refresh_map_canvas()


    def fill_table_psector(self, widget, table_name, set_edit_strategy=QSqlTableModel.OnManualSubmit):
        """ Set a model with selected @table_name. Attach that model to selected table """

        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set model
        self.model = QSqlTableModel()
        self.model.setTable(table_name)
        self.model.setEditStrategy(set_edit_strategy)
        self.model.setSort(0, 0)
        self.model.select()

        # Check for errors
        if self.model.lastError().isValid():
            self.controller.show_warning(self.model.lastError().text())
            
        # Attach model to table view
        widget.setModel(self.model)


    def fill_table(self, widget, table_name, set_edit_strategy=QSqlTableModel.OnManualSubmit, expr_filter=None):
        """ Set a model with selected filter.
        Attach that model to selected table """

        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set model
        self.model = QSqlTableModel()
        self.model.setTable(table_name)
        self.model.setEditStrategy(set_edit_strategy)
        self.model.setSort(0, 0)
        self.model.select()

        # Check for errors
        if self.model.lastError().isValid():
            self.controller.show_warning(self.model.lastError().text())

        # Attach model to table view
        widget.setModel(self.model)
        if expr_filter:
            widget.model().setFilter(expr_filter)


    def fill_table_by_query(self, qtable, query):
        """
        :param qtable: QTableView to show
        :param query: query to set model
        """

        model = QSqlQueryModel()
        model.setQuery(query)
        qtable.setModel(model)
        qtable.show()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())  
            

    def query_like_widget_text(self, dialog, text_line, qtable, tableleft, tableright, field_id_r, field_id_l, name='name', aql=''):
        """ Fill the QTableView by filtering through the QLineEdit"""

        schema_name = self.schema_name.replace('"', '')
        query = utils_giswater.getWidgetText(dialog, text_line, return_string_null=False).lower()
        sql = (f"SELECT * FROM {schema_name}.{tableleft} WHERE {name} NOT IN "
               f"(SELECT {tableleft}.{name} FROM {schema_name}.{tableleft}"
               f" RIGHT JOIN {schema_name}.{tableright}"
               f" ON {tableleft}.{field_id_l} = {tableright}.{field_id_r}"
               f" WHERE cur_user = current_user) AND LOWER({name}::text) LIKE '%{query}%'"
               f"  AND  {field_id_l} > -1")
        sql += aql
        self.fill_table_by_query(qtable, sql)
        
        
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
        

    def refresh_map_canvas(self, restore_cursor=False):
        """ Refresh all layers present in map canvas """
        
        self.canvas.refreshAllLayers()
        for layer_refresh in self.canvas.layers():
            layer_refresh.triggerRepaint()

        if restore_cursor:
            self.set_cursor_restore() 


    def set_cursor_wait(self):
        """ Change cursor to 'WaitCursor' """
        QApplication.setOverrideCursor(Qt.WaitCursor)
            
            
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
                    
                
    def set_table_columns(self, dialog, widget, table_name, sort_order=0, isQStandardItemModel=False):
        """ Configuration of tables. Set visibility and width of columns """

        widget = utils_giswater.getWidget(dialog, widget)
        if not widget:
            return

        # Set width and alias of visible columns
        columns_to_delete = []
        sql = (f"SELECT column_index, width, alias, status"
               f" FROM config_client_forms"
               f" WHERE table_id = '{table_name}'"
               f" ORDER BY column_index")
        rows = self.controller.get_rows(sql, log_info=False)
        if not rows:
            return

        for row in rows:
            if not row['status']:
                columns_to_delete.append(row['column_index'] - 1)
            else:
                width = row['width']
                if width is None:
                    width = 100
                widget.setColumnWidth(row['column_index'] - 1, width)
                widget.model().setHeaderData(row['column_index'] - 1, Qt.Horizontal, row['alias'])

        # Set order
        if isQStandardItemModel:
            widget.model().sort(sort_order, Qt.AscendingOrder)
        else:
            widget.model().setSort(sort_order, Qt.AscendingOrder)
            widget.model().select()
        # Delete columns
        for column in columns_to_delete:
            widget.hideColumn(column)

        return widget


    def connect_signal_selection_changed(self, option):
        """ Connect signal selectionChanged """
            
        try:            
            if option == "mincut_connec":
                self.canvas.selectionChanged.connect(partial(self.snapping_selection_connec))                 
            elif option == "mincut_hydro":
                self.canvas.selectionChanged.connect(partial(self.snapping_selection_hydro))                 
        except Exception:    
            pass
    
    
    def disconnect_signal_selection_changed(self):
        """ Disconnect signal selectionChanged """
        
        try:                     
            self.canvas.selectionChanged.disconnect()  
        except Exception:                     
            pass
        finally:
            self.iface.actionPan().trigger()


    def set_label_current_psector(self, dialog):

        sql = ("SELECT t1.name FROM plan_psector AS t1 "
               " INNER JOIN config_param_user AS t2 ON t1.psector_id::text = t2.value "
               " WHERE t2.parameter='psector_vdefault' AND cur_user = current_user")
        row = self.controller.get_row(sql)
        if not row:
            return
        utils_giswater.setWidgetText(dialog, 'lbl_vdefault_psector', row[0])


    def multi_rows_delete(self, widget, table_name, column_id):
        """ Delete selected elements of the table
        :param QTableView widget: origin
        :param table_name: table origin
        :param column_id: Refers to the id of the source table
        """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = widget.model().record(row).value(str(column_id))
            inf_text += f"{id_}, "
            list_id += f"'{id_}', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        message = "Are you sure you want to delete these records?"
        title = "Delete records"
        answer = self.controller.ask_question(message, title, inf_text)
        if answer:
            sql = f"DELETE FROM {table_name}"
            sql += f" WHERE {column_id} IN ({list_id})"
            self.controller.execute_sql(sql)
            widget.model().select()


    def select_features_by_expr(self, layer, expr):
        """ Select features of @layer applying @expr """

        if not layer:
            return

        if expr is None:
            layer.removeSelection()
        else:
            it = layer.getFeatures(QgsFeatureRequest(expr))
            # Build a list of feature id's from the previous result and select them
            id_list = [i.id() for i in it]
            if len(id_list) > 0:
                layer.selectByIds(id_list)
            else:
                layer.removeSelection()



    def hide_void_groupbox(self, dialog):
        """ Hide empty groupbox """
        grb_list = {}
        grbox_list = dialog.findChildren(QGroupBox)
        for grbox in grbox_list:

            widget_list = grbox.findChildren(QWidget)
            if len(widget_list) == 0:
                grb_list[grbox.objectName()] = 0
                grbox.setVisible(False)

        return grb_list

    def zoom_to_selected_features(self, layer, geom_type=None, zoom=None):
        """ Zoom to selected features of the @layer with @geom_type """

        if not layer:
            return

        self.iface.setActiveLayer(layer)
        self.iface.actionZoomToSelected().trigger()

        if geom_type:

            # Set scale = scale_zoom
            if geom_type in ('node', 'connec', 'gully'):
                scale = self.scale_zoom

            # Set scale = max(current_scale, scale_zoom)
            elif geom_type == 'arc':
                scale = self.iface.mapCanvas().scale()
                if int(scale) < int(self.scale_zoom):
                    scale = self.scale_zoom
            else:
                scale = 5000

            if zoom is not None:
                scale = zoom

            self.iface.mapCanvas().zoomScale(float(scale))


    def make_list_for_completer(self, sql):
        """ Prepare a list with the necessary items for the completer
        :param sql: Query to be executed, where will we get the list of items (string)
        :return list_items: List with the result of the query executed (List) ["item1","item2","..."]
        """
        rows = self.controller.get_rows(sql)
        list_items = []
        if rows:
            for row in rows:
                list_items.append(str(row[0]))
        return list_items


    def set_completer_lineedit(self, qlineedit, list_items):
        """ Set a completer into a QLineEdit
        :param qlineedit: Object where to set the completer (QLineEdit)
        :param list_items: List of items to set into the completer (List)["item1","item2","..."]
        """
        completer = QCompleter()
        completer.setCaseSensitivity(Qt.CaseInsensitive)
        completer.setMaxVisibleItems(10)
        completer.setCompletionMode(0)
        completer.setFilterMode(Qt.MatchContains)
        completer.popup().setStyleSheet("color: black;")
        qlineedit.setCompleter(completer)
        model = QStringListModel()
        model.setStringList(list_items)
        completer.setModel(model)


    def get_max_rectangle_from_coords(self, list_coord):
        """ Returns the minimum rectangle(x1, y1, x2, y2) of a series of coordinates
        :type list_coord: list of coors in format ['x1 y1', 'x2 y2',....,'x99 y99']
        """

        coords = list_coord.group(1)
        polygon = coords.split(',')
        x, y = polygon[0].split(' ')
        min_x = x  # start with something much higher than expected min
        min_y = y
        max_x = x  # start with something much lower than expected max
        max_y = y
        for i in range(0, len(polygon)):
            x, y = polygon[i].split(' ')
            if x < min_x:
                min_x = x
            if x > max_x:
                max_x = x
            if y < min_y:
                min_y = y
            if y > max_y:
                max_y = y

        return max_x, max_y, min_x, min_y

    def zoom_to_rectangle(self, x1, y1, x2, y2, margin=5):

        rect = QgsRectangle(float(x1)-margin, float(y1)-margin, float(x2)+margin, float(y2)+margin)
        self.canvas.setExtent(rect)
        self.canvas.refresh()


    def create_action(self, action_name, action_group, icon_num=None, text=None):
        """ Creates a new action with selected parameters """

        icon = None
        icon_folder = self.plugin_dir + '/icons/'
        icon_path = icon_folder + icon_num + '.png'
        if os.path.exists(icon_path):
            icon = QIcon(icon_path)

        if icon is None:
            action = QAction(text, action_group)
        else:
            action = QAction(icon, text, action_group)
        action.setObjectName(action_name)

        return action


    def set_wait_cursor(self):
        QApplication.instance().setOverrideCursor(Qt.WaitCursor)


    def set_arrow_cursor(self):
        QApplication.instance().setOverrideCursor(Qt.ArrowCursor)


    def delete_layer_from_toc(self, layer_name):
        """ Delete layer from toc if exist """

        layer = None
        for lyr in list(QgsProject.instance().mapLayers().values()):
            if lyr.name() == layer_name:
                layer = lyr
                break
        if layer is not None:
            # Remove layer
            QgsProject.instance().removeMapLayer(layer)

            # Remove group if is void
            root = QgsProject.instance().layerTreeRoot()
            group = root.findGroup('GW Temporal Layers')
            if group:
                layers = group.findLayers()
                if not layers:
                    root.removeChildNode(group)
            self.delete_layer_from_toc(layer_name)


    def create_body(self, form='', feature='', filter_fields='', extras=None):
        """ Create and return parameters as body to functions"""
        # f'$${{{body}}}$$'
        client = f'$${{"client":{{"device":9, "infoType":100, "lang":"ES"}}, '
        form = f'"form":{{{form}}}, '
        feature = f'"feature":{{{feature}}}, '
        filter_fields = f'"filterFields":{{{filter_fields}}}'
        page_info = f'"pageInfo":{{}}'
        data = f'"data":{{{filter_fields}, {page_info}'
        if extras is not None:
            data += ', ' + extras
        data += f'}}}}$$'
        body = "" + client + form + feature + data

        return body


    def get_composers_list(self):

        layour_manager = QgsProject.instance().layoutManager().layouts()
        active_composers = [layout for layout in layour_manager]
        return active_composers


    def get_composer_index(self, name):

        index = 0
        composers = self.get_composers_list()
        for comp_view in composers:
            composer_name = comp_view.name()
            if composer_name == name:
                break
            index += 1

        return index


    def set_restriction(self, dialog, widget_to_ignore, restriction):
        """
        Set all widget enabled(False) or readOnly(True) except those on the tuple
        :param dialog:
        :param widget_to_ignore: tuple = ('widgetname1', 'widgetname2', 'widgetname3', ...)
        :param restriction: roles that do not have access. tuple = ('role1', 'role1', 'role1', ...)
        :return:
        """

        role = self.controller.get_restriction()
        if role in restriction:
            widget_list = dialog.findChildren(QWidget)
            for widget in widget_list:
                if widget.objectName() in widget_to_ignore:
                    continue
                # Set editable/readonly
                if type(widget) in (QLineEdit, QDoubleSpinBox, QTextEdit):
                    widget.setReadOnly(True)
                    widget.setStyleSheet("QWidget {background: rgb(242, 242, 242);color: rgb(100, 100, 100)}")
                elif type(widget) in (QComboBox, QCheckBox, QTableView, QPushButton):
                    widget.setEnabled(False)


    def set_dates_from_to(self, widget_from, widget_to, table_name, field_from, field_to):

        sql = (f"SELECT MIN(LEAST({field_from}, {field_to})),"
               f" MAX(GREATEST({field_from}, {field_to}))"
               f" FROM {table_name}")
        row = self.controller.get_row(sql, log_sql=False)
        current_date = QDate.currentDate()
        if row:
            if row[0]:
                widget_from.setDate(row[0])
            else:
                widget_from.setDate(current_date)
            if row[1]:
                widget_to.setDate(row[1])
            else:
                widget_to.setDate(current_date)


    def get_values_from_catalog(self, table_name, typevalue, order_by='id'):

        sql = (f"SELECT id, idval"
               f" FROM {table_name}"
               f" WHERE typevalue = '{typevalue}'"
               f" ORDER BY {order_by}")
        rows = self.controller.get_rows(sql)
        return rows


    def integer_validator(self, value, widget, btn_accept):
        """ Check if the value is an integer or not.
            This function is called in def set_datatype_validator(self, value, widget, btn)
            widget = getattr(self, f"{widget.property('datatype')}_validator")( value, widget, btn)
        """
        if value is None or bool(re.search("^\d*$", value)):
            widget.setStyleSheet(None)
            btn_accept.setEnabled(True)
        else:
            widget.setStyleSheet("border: 1px solid red")
            btn_accept.setEnabled(False)


    def double_validator(self, value, widget, btn_accept):
        """ Check if the value is double or not.
            This function is called in def set_datatype_validator(self, value, widget, btn)
            widget = getattr(self, f"{widget.property('datatype')}_validator")( value, widget, btn)
        """
        if value is None or bool(re.search("^\d*$", value)) or bool(re.search("^\d+\.\d+$", value)):
            widget.setStyleSheet(None)
            btn_accept.setEnabled(True)
        else:
            widget.setStyleSheet("border: 1px solid red")
            btn_accept.setEnabled(False)


    def load_qml(self, layer, qml_path):
        """ Apply QML style located in @qml_path in @layer """

        if layer is None:
            return False

        if not os.path.exists(qml_path):
            self.controller.log_warning("File not found", parameter=qml_path)
            return False

        if not qml_path.endswith(".qml"):
            self.controller.log_warning("File extension not valid", parameter=qml_path)
            return False

        layer.loadNamedStyle(qml_path)
        layer.triggerRepaint()

        return True


    def open_file_path(self, filter_="All (*.*)"):
        """ Open QFileDialog """
        msg = self.controller.tr("Select DXF file")
        path, filter_ = QFileDialog.getOpenFileName(None, msg, "", filter_)

        return path, filter_


    def show_exceptions_msg(self, title, msg=""):
        cat_exception = {'KeyError': 'Key on returned json from ddbb is missed.'}
        self.dlg_info = BasicInfoUi()
        self.dlg_info.btn_accept.setVisible(False)
        self.dlg_info.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_info))
        self.dlg_info.setWindowTitle(title)
        utils_giswater.setWidgetText(self.dlg_info, self.dlg_info.txt_infolog, msg)
        self.open_dialog(self.dlg_info)



    def put_combobox(self, qtable, rows, field, widget_pos, combo_values):
        """ Set one column of a QtableView as QComboBox with values from database.
        :param qtable: QTableView to fill
        :param rows: List of items to set QComboBox (["..", "..."])
        :param field: Field to set QComboBox (String)
        :param widget_pos: Position of the column where we want to put the QComboBox (integer)
        :param combo_values: List of items to populate QComboBox (["..", "..."])
        :return:
        """

        for x in range(0, len(rows)):
            combo = QComboBox()
            row = rows[x]
            # Populate QComboBox
            utils_giswater.set_item_data(combo, combo_values, 1)
            # Set QCombobox to wanted item
            utils_giswater.set_combo_itemData(combo, str(row[field]), 1)
            # Get index and put QComboBox into QTableView at index position
            idx = qtable.model().index(x, widget_pos)
            qtable.setIndexWidget(idx, combo)
            combo.currentIndexChanged.connect(partial(self.update_status, combo, qtable, x, widget_pos))


    def update_status(self, combo, qtable, pos_x, widget_pos):
        """ Update values from QComboBox to QTableView
        :param combo: QComboBox from which we will take the value
        :param qtable: QTableView Where update values
        :param pos_x: Position of the row where we want to update value (integer)
        :param widget_pos:Position of the widget where we want to update value (integer)
        :return:
        """

        elem = combo.itemData(combo.currentIndex())
        i = qtable.model().index(pos_x, widget_pos)
        qtable.model().setData(i, elem[0])
        i = qtable.model().index(pos_x, widget_pos+1)
        qtable.model().setData(i, elem[1])


    def document_insert(self, dialog, tablename, field, field_value):
        """ Insert a document related to the current visit
        :param dialog: (QDialog )
        :param tablename: Name of the table to make the queries (string)
        :param field: Field of the table to make the where clause (string)
        :param field_value: Value to compare in the clause where (string)
        """
        doc_id = dialog.doc_id.text()
        if not doc_id:
            message = "You need to insert doc_id"
            self.controller.show_warning(message)
            return

        # Check if document already exist
        sql = (f"SELECT doc_id"
               f" FROM {tablename}"
               f" WHERE doc_id = '{doc_id}' AND {field} = '{field_value}'")
        row = self.controller.get_row(sql)
        if row:
            msg = "Document already exist"
            self.controller.show_warning(msg)
            return

        # Insert into new table
        sql = (f"INSERT INTO {tablename} (doc_id, {field})"
               f" VALUES ('{doc_id}', '{field_value}')")
        status = self.controller.execute_sql(sql)
        if status:
            message = "Document inserted successfully"
            self.controller.show_info(message)

        dialog.tbl_document.model().select()


    def document_open(self, qtable):
        """ Open selected document """

        # Get selected rows
        field_index = qtable.model().fieldIndex('path')
        selected_list = qtable.selectionModel().selectedRows(field_index)
        if not selected_list:
            message = "Any record selected"
            self.controller.show_info_box(message)
            return
        elif len(selected_list) > 1:
            message = "More then one document selected. Select just one document."
            self.controller.show_warning(message)
            return

        path = selected_list[0].data()
        # Check if file exist
        if os.path.exists(path):
            # Open the document
            if sys.platform == "win32":
                os.startfile(path)
            else:
                opener = "open" if sys.platform == "darwin" else "xdg-open"
                subprocess.call([opener, path])
        else:
            webbrowser.open(path)


    def document_delete(self, qtable, tablename):
        """ Delete record from selected rows in tbl_document """

        # Get selected rows. 0 is the column of the pk 0 'id'
        selected_list = qtable.selectionModel().selectedRows(0)
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_info_box(message)
            return

        selected_id = []
        for index in selected_list:
            doc_id = index.data()
            selected_id.append(str(doc_id))
        message = "Are you sure you want to delete these records?"
        title = "Delete records"
        answer = self.controller.ask_question(message, title, ','.join(selected_id))
        if answer:
            sql = (f"DELETE FROM {tablename}"
                   f" WHERE id IN ({','.join(selected_id)})")
            status = self.controller.execute_sql(sql)
            if not status:
                message = "Error deleting data"
                self.controller.show_warning(message)
                return
            else:
                message = "Document deleted"
                self.controller.show_info(message)
                qtable.model().select()


    def dock_dialog(self, docker, dialog):

        positions = {8:Qt.BottomDockWidgetArea, 4:Qt.TopDockWidgetArea,
                     2:Qt.RightDockWidgetArea, 1:Qt.LeftDockWidgetArea}
        try:
            docker.setWindowTitle(dialog.windowTitle())
            docker.setWidget(dialog)
            docker.setWindowFlags(Qt.WindowContextHelpButtonHint)
            self.iface.addDockWidget(positions[docker.position], docker)
        except RuntimeError as e:
            self.controller.log_warning(f"{type(e).__name__} --> {e}")
            pass


    def manage_docker_options(self):
        """ Check if user want dock the dialog or not """

        # Load last docker position
        cur_user = self.controller.get_current_user()
        pos = self.controller.plugin_settings_value(f"docker_info_{cur_user}")

        # Docker positions: 1=Left, 2=right, 8=bottom, 4= top
        if type(pos) is int and pos in (1, 2, 4, 8):
            self.dlg_docker.position = pos
        else:
            self.dlg_docker.position = 2

        # If user want to dock the dialog, we reset rubberbands for each info
        # For the first time, cf_info does not exist, therefore we cannot access it and reset rubberbands
        try:
            self.info_cf.resetRubberbands()
        except AttributeError as e:
            pass


    def get_all_actions(self):

        actions_list = self.iface.mainWindow().findChildren(QAction)
        for action in actions_list:
           self.controller.log_info(str(action.objectName()))
           action.triggered.connect(partial(self.show_action_name, action))


    def show_action_name(self, action):
        self.controller.log_info(str(action.objectName()))


    def get_points(self, list_coord=None):
        """ Return list of QgsPoints taken from geometry
        :type list_coord: list of coors in format ['x1 y1', 'x2 y2',....,'x99 y99']
        """

        coords = list_coord.group(1)
        polygon = coords.split(',')
        points = []

        for i in range(0, len(polygon)):
            x, y = polygon[i].split(' ')
            point = QgsPointXY(float(x), float(y))
            points.append(point)

        return points


    def draw_polyline(self, points, color=QColor(255, 0, 0, 100), width=5, duration_time=None):
        """ Draw 'line' over canvas following list of points
         :param duration_time: integer milliseconds ex: 3000 for 3 seconds
         """

        rb = self.rubber_polygon
        polyline = QgsGeometry.fromPolylineXY(points)
        rb.setToGeometry(polyline, None)
        rb.setColor(color)
        rb.setWidth(width)
        rb.show()

        # wait to simulate a flashing effect
        if duration_time is not None:
            QTimer.singleShot(duration_time, self.resetRubberbands)

        return rb

    def resetRubberbands(self):

        self.rubber_point.reset(0)
        self.rubber_polygon.reset(2)


    def restore_user_layer(self):
        if self.user_current_layer:
            self.iface.setActiveLayer(self.user_current_layer)
        else:
            layer = self.controller.get_layer_by_tablename('v_edit_node')
            if layer: self.iface.setActiveLayer(layer)