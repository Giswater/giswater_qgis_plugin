# -*- coding: utf-8 -*-

from qgis.core import QgsExpression, QgsFeatureRequest, QgsProject, QgsLayerTreeLayer, QgsExpressionContextUtils
from PyQt4 import uic
from PyQt4.QtCore import QObject, QPyNullVariant, Qt
from PyQt4.QtSql import QSqlTableModel
from PyQt4.QtGui import QCompleter, QSortFilterProxyModel, QStringListModel, QAbstractItemView, QTableView, QFileDialog, QGridLayout, QPushButton, QLineEdit, QLabel

from functools import partial

import sys
import operator
import os
import csv
import webbrowser
if 'nt' in sys.builtin_module_names:
    import ctypes

import utils_giswater
from giswater.search.ui.list_items import ListItems
from giswater.search.ui.hydro_info import HydroInfo
from giswater.search.ui.search_plus_dockwidget import SearchPlusDockWidget
from giswater.actions.manage_new_psector import ManageNewPsector


class SearchPlus(QObject):

    def __init__(self, iface, srid, controller, settings, plugin_dir):
        """ Constructor """

        self.manage_new_psector = ManageNewPsector(iface, settings, controller, plugin_dir)
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.srid = srid
        self.controller = controller
        self.schema_name = self.controller.schema_name
        self.project_type = self.controller.get_project_type()
        self.feature_cat = {}


    def init_config(self):
        """ Initial configuration """

        # Load configuration data from tables
        if not self.load_config_data():
            return False

        # Create dialog
        self.dlg_search = SearchPlusDockWidget(self.iface.mainWindow())
        utils_giswater.remove_tab_by_tabName(self.dlg_search.tab_main, 'tab')
        
        # Check address parameters
        message = "Parameter not found"
        if not 'street_field_expl' in self.params:
            self.controller.show_warning(message, parameter='street_field_expl')
            return False
        if not 'portal_field_postal' in self.params:
            self.controller.show_warning(message, parameter='portal_field_postal')
            return False

        self.street_field_expl = self.params['street_field_expl']

        # Set signals
        self.dlg_search.address_exploitation.currentIndexChanged.connect(partial
            (self.address_populate, self.dlg_search.address_street, 'street_layer', 'street_field_code', 'street_field_name'))
        # self.dlg_search.address_exploitation.currentIndexChanged.connect(partial
        #     (self.zoom_to_polygon, self.dlg_search.address_exploitation, 'ext_municipality', 'muni_id', 'name'))
        
        # self.dlg_search.address_postal_code.currentIndexChanged.connect(partial
        #     (self.address_get_numbers, self.dlg_search.address_postal_code, portal_field_postal, False, False))
        self.dlg_search.address_street.activated.connect(partial
            (self.address_get_numbers, self.dlg_search.address_street, self.params['portal_field_code'], True))
        self.dlg_search.address_number.activated.connect(partial(self.address_zoom_portal))

        self.dlg_search.network_geom_type.activated.connect(partial(self.network_geom_type_changed))
        self.dlg_search.network_code.activated.connect(partial
            (self.network_zoom, self.dlg_search.network_code, self.dlg_search.network_geom_type))
        self.dlg_search.network_code.editTextChanged.connect(partial(self.filter_by_list, self.dlg_search.network_code))
        if self.project_type == 'ws':
            self.hydro_create_list()
            self.dlg_search.expl_name.activated.connect(partial(self.expl_name_changed))
            self.dlg_search.hydro_id.activated.connect(partial(self.hydro_zoom, self.dlg_search.hydro_id, self.dlg_search.expl_name))
            self.dlg_search.hydro_id.editTextChanged.connect(partial(self.filter_by_list, self.dlg_search.hydro_id))
            self.set_model_by_list(self.list_hydro, self.dlg_search.hydro_id)
            self.filter_by_list(self.dlg_search.hydro_id)
        self.dlg_search.workcat_id.activated.connect(partial(self.workcat_open_table_items))

        self.dlg_search.btn_clear_workcat.clicked.connect(self.clear_workcat)
        self.dlg_search.btn_refresh_workcat.clicked.connect(self.refresh_workcat)
        self.dlg_search.psector_id.activated.connect(partial(self.open_plan_psector))

        return True

    def workcat_populate(self, dialog, combo):
        """ Fill @combo """

        sql = ("SELECT id FROM " + self.schema_name + ".cat_work")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(dialog, combo, rows)
        return rows


    def psector_populate(self, dialog, combo):
        """ Fill @combo """

        sql = ("SELECT name FROM " + self.controller.schema_name + ".plan_psector "
               " WHERE expl_id IN(SELECT expl_id FROM " + self.controller.schema_name + ".selector_expl WHERE cur_user=current_user)")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(dialog, combo, rows)
        return rows


    def update_selector_workcat(self, workcat_id):
        """  Update table selector_workcat """
        
        sql = ("DELETE FROM " + self.schema_name + ".selector_workcat "
               " WHERE cur_user = current_user;\n")
        sql += ("INSERT INTO " + self.schema_name + ".selector_workcat(workcat_id, cur_user) "
                " VALUES('" + workcat_id + "', current_user);\n")
        self.controller.execute_sql(sql)


    def zoom_to_polygon(self, widget, table_name, field_id, field_name):

        layer = self.controller.get_layer_by_tablename(table_name)
        if not layer:
            return

        polygon_name = utils_giswater.getWidgetText(self.dlg_search, widget)
        sql = ("SELECT " + str(field_id) + " FROM " + self.schema_name + "." + str(table_name) + " "
               " WHERE " + str(field_name) + "=$$" + str(polygon_name) + "$$")
        row = self.controller.get_row(sql, log_sql=True)

        # Check if the expression is valid
        expr_filter = str(field_id) + " = '" + str(row[0]) + "'"
        (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
        if not is_valid:
            return
        if polygon_name is not None:
            sql = ("SELECT the_geom FROM " + self.schema_name + "." + str(table_name) + " "
                   " WHERE "+str(field_id)+"=$$"+str(row[0]) + "$$")
            row = self.controller.get_row(sql, log_sql=True)
            if row[0] is None or row[0] == 'null':
                msg = "Cant zoom to selection because has no geometry: "
                self.controller.show_warning(msg, parameter=polygon_name)
                self.iface.legendInterface().setLayerVisible(layer, False)
                return

        # Select features of @layer applying @expr
        self.select_features_by_expr(layer, expr)

        # If any feature found, zoom it and exit function
        if layer.selectedFeatureCount() > 0:
            self.iface.setActiveLayer(layer)
            self.iface.legendInterface().setLayerVisible(layer, True)
            self.iface.actionZoomToSelected().trigger()
            layer.removeSelection()


    def workcat_open_table_items(self):
        """ Create the view and open the dialog with his content """

        workcat_id = utils_giswater.getWidgetText(self.dlg_search, self.dlg_search.workcat_id)
        if workcat_id == "null":
            return False

        self.update_selector_workcat(workcat_id)
        self.force_expl(workcat_id)

        self.zoom_to_polygon(self.dlg_search.workcat_id, 'v_ui_workcat_polygon', 'workcat_id', 'workcat_id')

        self.items_dialog = ListItems()
        self.load_settings(self.items_dialog)
        self.items_dialog.btn_state1.setEnabled(False)
        self.items_dialog.btn_state0.setEnabled(False)
        utils_giswater.setWidgetText(self.items_dialog, self.items_dialog.txt_path, self.controller.plugin_settings_value('search_csv_path'))
        text_lbl = self.params['basic_search_workcat_filter']
        utils_giswater.setWidgetText(self.items_dialog, self.items_dialog.label_init, "Filter by: "+str(text_lbl))
        utils_giswater.setWidgetText(self.items_dialog, self.items_dialog.label_end, "Filter by: "+str(text_lbl))

        self.items_dialog.tbl_psm.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.items_dialog.tbl_psm_end.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.disable_qatable_by_state(self.items_dialog.tbl_psm, 1, self.items_dialog.btn_state1)
        self.disable_qatable_by_state(self.items_dialog.tbl_psm_end, 0, self.items_dialog.btn_state0)

        table_name = "v_ui_workcat_x_feature"
        table_name_end = "v_ui_workcat_x_feature_end"
        self.items_dialog.btn_close.clicked.connect(partial(self.close_dialog, self.items_dialog))
        self.items_dialog.btn_path.clicked.connect(partial(self.get_folder_dialog, self.items_dialog, self.items_dialog.txt_path))
        self.items_dialog.rejected.connect(partial(self.close_dialog, self.items_dialog))
        self.items_dialog.btn_state1.clicked.connect(partial(self.force_state, self.items_dialog.btn_state1, 1, self.items_dialog.tbl_psm, workcat_id))
        self.items_dialog.btn_state0.clicked.connect(partial(self.force_state, self.items_dialog.btn_state0, 0, self.items_dialog.tbl_psm_end, workcat_id))
        self.items_dialog.export_to_csv.clicked.connect(
            partial(self.export_to_csv, self.items_dialog, self.items_dialog.tbl_psm, self.items_dialog.tbl_psm_end,
                    self.items_dialog.txt_path))

        self.items_dialog.txt_name.textChanged.connect(partial
            (self.workcat_filter_by_text, self.items_dialog, self.items_dialog.tbl_psm, self.items_dialog.txt_name, table_name, workcat_id))
        self.items_dialog.txt_name_end.textChanged.connect(partial
            (self.workcat_filter_by_text, self.items_dialog, self.items_dialog.tbl_psm_end, self.items_dialog.txt_name_end, table_name_end, workcat_id))
        self.items_dialog.tbl_psm.doubleClicked.connect(partial
            (self.workcat_zoom, self.items_dialog.tbl_psm))
        self.items_dialog.tbl_psm_end.doubleClicked.connect(partial(self.workcat_zoom, self.items_dialog.tbl_psm_end))

        expr = "workcat_id ILIKE '%" + str(workcat_id) + "%'"
        self.workcat_fill_table(self.items_dialog.tbl_psm, table_name, expr=expr)
        self.set_table_columns(self.items_dialog, self.items_dialog.tbl_psm, table_name)
        expr = "workcat_id ILIKE '%" + str(workcat_id) + "%'"
        self.workcat_fill_table(self.items_dialog.tbl_psm_end, table_name_end, expr=expr)
        self.set_table_columns(self.items_dialog, self.items_dialog.tbl_psm_end, table_name_end)

        # Add data to workcat search form
        table_name = "v_ui_workcat_x_feature"
        table_name_end = "v_ui_workcat_x_feature_end"
        extension = '_end'
        self.fill_label_data(table_name)
        self.fill_label_data(table_name_end, extension)

        self.items_dialog.setWindowFlags(Qt.WindowMaximizeButtonHint | Qt.WindowStaysOnTopHint)
        self.items_dialog.open()


    def force_state(self, qbutton, state, qtable, workcat_id):
        """ Force selected state and set qtable enabled = True """
        sql = ("SELECT state_id FROM " + self.schema_name + ".selector_state "
               " WHERE cur_user=current_user AND state_id ='" + str(state) + "'")
        row = self.controller.get_row(sql)
        if row is not None:
            return
        sql = ("INSERT INTO " + self.schema_name + ".selector_state(state_id, cur_user) "
               " VALUES('" + str(state) + "', current_user)")
        self.controller.execute_sql(sql)
        qtable.setEnabled(True)
        qbutton.setEnabled(False)
        self.refresh_map_canvas()

        table_name = "v_ui_workcat_x_feature"
        table_name_end = "v_ui_workcat_x_feature_end"
        expr = "workcat_id ILIKE '%" + str(workcat_id) + "%'"
        self.workcat_fill_table(self.items_dialog.tbl_psm, table_name, expr=expr)
        self.set_table_columns(self.items_dialog, self.items_dialog.tbl_psm, table_name)
        expr = "workcat_id ILIKE '%" + str(workcat_id) + "%'"
        self.workcat_fill_table(self.items_dialog.tbl_psm_end, table_name_end, expr=expr)
        self.set_table_columns(self.items_dialog, self.items_dialog.tbl_psm_end, table_name_end)

    def disable_qatable_by_state(self, qtable, _id, qbutton):

        sql = ("SELECT state_id FROM " + self.schema_name + ".selector_state "
               " WHERE cur_user = current_user AND state_id ='" + str(_id) + "'")
        row = self.controller.get_row(sql)
        if row is None:
            qtable.setEnabled(False)
            qbutton.setEnabled(True)

    def force_expl(self,  workcat_id):
        """ Active exploitations are compared with workcat farms.
            If there is consistency nothing happens, if there is no consistency force this exploitations to selector."""

        sql = ("SELECT a.expl_id, a.expl_name FROM "
               "  (SELECT expl_id, expl_name FROM " + self.schema_name + ".v_ui_workcat_x_feature "
               "   WHERE workcat_id='" + str(workcat_id) + "' "
               "   UNION SELECT expl_id, expl_name FROM " + self.schema_name + ".v_ui_workcat_x_feature_end "
               "   WHERE workcat_id='" + str(workcat_id) + "'"
               "   ) AS a "
               " WHERE expl_id NOT IN "
               "  (SELECT expl_id FROM " + self.schema_name + ".selector_expl "
               "   WHERE cur_user=current_user)")
        rows = self.controller.get_rows(sql)

        if len(rows) > 0:
            for row in rows:
                sql = ("INSERT INTO " + self.schema_name + ".selector_expl(expl_id, cur_user) "
                       " VALUES('" + str(row[0]) + "', current_user)")
                self.controller.execute_sql(sql)
            msg = "Your exploitation selector has been updated"
            self.controller.show_warning(msg)


    def fill_label_data(self, table_name, extension=None):

        workcat_id = utils_giswater.getWidgetText(self.dlg_search, self.dlg_search.workcat_id)
        if workcat_id == "null":
            return

        features = ['NODE', 'CONNEC', 'GULLY', 'ELEMENT', 'ARC']
        for feature in features:
            sql = ("SELECT feature_id "
                   " FROM " + self.schema_name + "." + str(table_name) + "")
            sql += (" WHERE workcat_id = '" + str(workcat_id)) + "' AND feature_type = '" + str(feature) + "'"
            rows = self.controller.get_rows(sql)
            if not rows:
                pass

            if extension is not None:
                widget_name = "lbl_total_" + str(feature.lower()) + str(extension)
            else:
                widget_name = "lbl_total_" + str(feature.lower())

            widget = self.items_dialog.findChild(QLabel, str(widget_name))

            if self.project_type == 'ws' and feature == 'GULLY':
                widget.hide()
            total = len(rows)
            # Add data to workcat search form
            widget.setText(str(feature.lower().title()) + "s: " + str(total))
            # TODO 1 DESCOMENTAR ESTO Y COMPROBAR, FALLA EL gis_length de la capa arc
            length = 0
            if feature == 'ARC':
                for row in rows:
                    arc_id = str(row[0])
                    sql = ("SELECT st_length2d(the_geom)::numeric(12,2) "
                           " FROM " + self.schema_name + ".arc"
                           " WHERE arc_id = '" + arc_id + "'")
                    row = self.controller.get_row(sql)
                    if row:
                        length = length + row[0]
                    else:
                        message = "Some data is missing. Check gis_length for arc"
                        self.controller.show_warning(message, parameter = arc_id)
                        return
                if extension != None:
                    widget = self.items_dialog.findChild(QLabel, "lbl_length" + str(extension))
                else:
                    widget = self.items_dialog.findChild(QLabel, "lbl_length")

                # Add data to workcat search form
                widget.setText("Total arcs length: " + str(length))
            # TODO END

    def export_to_csv(self, dialog, qtable_1=None, qtable_2=None, path=None):

        folder_path = utils_giswater.getWidgetText(dialog, path)
        if folder_path is None or folder_path == 'null':
            return
        if folder_path.find('.csv') == -1:
            folder_path += '.csv'
        if qtable_1:
            model_1 = qtable_1.model()
        else:
            return
        if qtable_2:
            model_2 = qtable_2.model()

        # Convert qtable values into list
        all_rows = []
        headers = []
        for i in range(0, model_1.columnCount()):
            headers.append(str(model_1.headerData(i, Qt.Horizontal)))
        all_rows.append(headers)
        for rows in range(0, model_1.rowCount()):
            row = []
            for col in range(0, model_1.columnCount()):
                row.append(str(model_1.data(model_1.index(rows, col))))
            all_rows.append(row)
        if qtable_2 is not None:
            headers = []
            for i in range(0, model_2.columnCount()):
                headers.append(str(model_2.headerData(i, Qt.Horizontal)))
            all_rows.append(headers)
            for rows in range(0, model_2.rowCount()):
                row = []
                for col in range(0, model_2.columnCount()):
                    row.append(str(model_2.data(model_2.index(rows, col))))
                all_rows.append(row)
        # Write list into csv file
        try:
            if os.path.exists(folder_path):
                msg = "Are you sure you want to overwrite this file?"
                answer = self.controller.ask_question(msg, "Overwrite")
                if answer:
                    self.write_csv(dialog, folder_path, all_rows)
            else:
                self.write_csv(dialog, folder_path, all_rows)
        except:
            msg = "File path doesn't exist or you dont have permission or file is opened"
            self.controller.show_warning(msg)
            pass
        

    def write_csv(self, dialog, folder_path=None, all_rows=None):
        
        with open(folder_path, "w") as output:
            writer = csv.writer(output, lineterminator='\n')
            writer.writerows(all_rows)
        self.controller.plugin_settings_set_value("search_csv_path", utils_giswater.getWidgetText(dialog, 'txt_path'))
        message = "Values has been updated"
        self.controller.show_info(message)


    def get_folder_dialog(self, dialog, widget):
        """ Get folder dialog """
        if 'nt' in sys.builtin_module_names:
            folder_path = os.path.expanduser("~\Documents")
        else:
            folder_path = os.path.expanduser("~")

        # Open dialog to select folder
        os.chdir(folder_path)
        file_dialog = QFileDialog()
        file_dialog.setFileMode(QFileDialog.Directory)

        msg = "Save as"
        folder_path = file_dialog.getSaveFileName(None, self.controller.tr(msg), folder_path, '*.csv')
        if folder_path:
            utils_giswater.setWidgetText(dialog, widget, str(folder_path))


    def workcat_zoom(self, qtable):
        """ Zoom feature with the code set in 'network_code' of the layer set in 'network_geom_type' """

        # Get selected code from combo
        element = qtable.selectionModel().selectedRows()
        if len(element) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        row = element[0].row()
        feature_id = qtable.model().record(row).value('feature_id')

        # Get selected layer
        if str(qtable.model().record(row).value('feature_type')) == 'NULL':
            message = "FeatureType is null"
            self.controller.show_warning(message)
            return
        geom_type = qtable.model().record(row).value('feature_type').lower()
        fieldname = geom_type + "_id"

        # Check if the expression is valid
        expr_filter = fieldname + " = '" + str(feature_id) + "'"
        (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
        if not is_valid:
            return

        for value in self.feature_cat.itervalues():
            if value.type.lower() == geom_type:
                layer = self.controller.get_layer_by_layername(value.layername)
                if layer:
                    # Select features of @layer applying @expr
                    self.select_features_by_expr(layer, expr)               
                    # If any feature found, zoom it and exit function
                    if layer.selectedFeatureCount() > 0:
                        self.iface.setActiveLayer(layer)
                        self.iface.legendInterface().setLayerVisible(layer, True)
                        self.open_custom_form(layer, expr)
                        self.zoom_to_selected_features(layer, geom_type)
                        return

        # If the feature is not in views because the selectors are "disabled"...
        message = "Modify values of selectors to see the feature"
        self.controller.show_warning(message)


    def open_custom_form(self, layer, expr):
        """ Open custom from selected layer """

        it = layer.getFeatures(QgsFeatureRequest(expr))
        features = [i for i in it]
        if features:
            self.iface.openFeatureForm(layer, features[0])
       

    def workcat_fill_table(self, widget, table_name, hidde=False, set_edit_triggers=QTableView.NoEditTriggers, expr=None):
        """ Fill table @widget filtering query by @workcat_id
        Set a model with selected filter.
        Attach that model to selected table
        @setEditStrategy:
            0: OnFieldChange
            1: OnRowChange
            2: OnManualSubmit
        """

        # Set model
        model = QSqlTableModel()
        model.setTable(self.schema_name+"."+table_name)
        model.setEditStrategy(QSqlTableModel.OnFieldChange)
        model.setSort(0, 0)
        model.select()

        widget.setEditTriggers(set_edit_triggers)
        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())
        # Attach model to table view
        if expr:
            widget.setModel(model)
            widget.model().setFilter(expr)
        else:
            widget.setModel(model)

        if hidde:
            self.refresh_table(widget)


    def workcat_filter_by_text(self, dialog, qtable, widget_txt, table_name, workcat_id):

        result_select = utils_giswater.getWidgetText(dialog, widget_txt)
        if result_select != 'null':
            expr = ("workcat_id = '" + str(workcat_id) + "'"
                    " and "+self.params['basic_search_workcat_filter'] +" ILIKE '%" + str(result_select) + "%'")
        else:
            expr = "workcat_id ILIKE '%" + str(workcat_id) + "%'"
        self.workcat_fill_table(qtable, table_name, expr=expr)
        self.set_table_columns(dialog, qtable, table_name)


    def load_config_data(self):
        """ Load configuration data from tables """

        self.params = {}
        sql = ("SELECT parameter, value FROM " + self.controller.schema_name + ".config_param_system"
               " WHERE context = 'searchplus' ORDER BY parameter")
        rows = self.controller.get_rows(sql)
        if not rows:             
            message = "Parameters related with 'searchplus' not set in table 'config_param_system'"
            self.controller.log_warning(message)
            return False            

        for row in rows:              
            self.params[row['parameter']] = str(row['value'])     

        # Get scale zoom
        if not 'scale_zoom' in self.params: 
            self.scale_zoom = 2500
        else:
            self.scale_zoom = self.params['scale_zoom']  
                    
        return True


    def dock_dialog(self):
        """ Dock dialog into left dock widget area """
        
        if not self.populate_dialog():
            return False
        
        # Get path of .ui file
        ui_path = os.path.join(self.controller.plugin_dir, 'search', 'ui', 'search_plus_dialog.ui')
        if not os.path.exists(ui_path):
            self.controller.show_warning("File not found", parameter=ui_path)
            return False
        
        # Make it dockable in left dock widget area
        self.dock = uic.loadUi(ui_path)
        self.iface.addDockWidget(Qt.LeftDockWidgetArea, self.dlg_search)
        self.dlg_search.setFixedHeight(162)
        
        # Set his backgroundcolor
        p = self.dlg_search.palette()
        self.dlg_search.setAutoFillBackground(True)
        p.setColor(self.dlg_search.backgroundRole(), Qt.white)
        self.dlg_search.setPalette(p)
        
        return True
    
            
    def get_layers(self): 
        """ Iterate over all layers to get the ones set in config file """
        
        # Check if we have any layer loaded
        layers = self.iface.legendInterface().layers()
        if len(layers) == 0:
            return            
        
        # Iterate over all layers to get the ones specified parameters '*_layer'
        self.layers = {}

        for cur_layer in layers:     
            layer_source = self.controller.get_layer_source(cur_layer)  
            uri_table = layer_source['table']
            if uri_table is not None:
                if self.params['expl_layer'] == uri_table:
                    self.layers['expl_layer'] = cur_layer
                if self.params['street_layer'] == uri_table:
                    self.layers['street_layer'] = cur_layer
                if self.params['portal_layer'] == uri_table:
                    self.layers['portal_layer'] = cur_layer
                if self.params['network_layer_arc'] == uri_table:
                    self.layers['network_layer_arc'] = cur_layer               
                if self.params['network_layer_connec'] == uri_table:
                    self.layers['network_layer_connec'] = cur_layer               
                if self.params['network_layer_element'] == uri_table:
                    self.layers['network_layer_element'] = cur_layer               
                if self.params['network_layer_gully'] == uri_table:
                    self.layers['network_layer_gully'] = cur_layer               
                if self.params['network_layer_node'] == uri_table:
                    self.layers['network_layer_node'] = cur_layer
                if self.params['basic_search_hyd_hydro_layer_name'] == uri_table:
                    self.layers['basic_search_hyd_hydro_layer_name'] = cur_layer


    def populate_dialog(self):
        """ Populate the interface with values get from layers """

        # Get layers and full extent
        self.get_layers()

        # Tab 'WorkCat'
        status = self.workcat_populate(self.dlg_search, self.dlg_search.workcat_id)
        if not status:
            self.dlg_search.tab_main.removeTab(3)

        # Tab 'Address'
        status = self.address_populate(self.dlg_search.address_exploitation, 'expl_layer', 'expl_field_code', 'expl_field_name')
        if not status:
            self.dlg_search.tab_main.removeTab(2)
        else:
            # Get project variable 'expl_id'
            expl_id = QgsExpressionContextUtils.projectScope().variable(str(self.street_field_expl))
            if expl_id:           
                # Set SQL to get 'expl_name'
                sql = ("SELECT " + self.params['expl_field_name'] + ""
                       " FROM " + self.controller.schema_name + "." + self.params['expl_layer'] + ""
                       " WHERE " + self.params['expl_field_code'] + " = " + str(expl_id))
                row = self.controller.get_row(sql)
                if row:
                    utils_giswater.setSelectedItem(self.dlg_search, self.dlg_search.address_exploitation, row[0])

        # Tab 'Hydrometer'
        if self.project_type == 'ws':
            self.populate_cmb_expl_name('basic_search_hyd_hydro_layer_name', self.dlg_search.expl_name, self.params['basic_search_hyd_hydro_field_expl_name'])
            self.hydro_create_list()
        else:
            utils_giswater.remove_tab_by_tabName(self.dlg_search.tab_main, 'tab_hydro')

        # Tab 'Network'
        self.network_code_create_lists()
        status = self.network_geom_type_populate()
        if not status:
            self.dlg_search.tab_main.removeTab(0)

        # Tab 'Psector'
        status = self.psector_populate(self.dlg_search, self.dlg_search.psector_id)
        
        return True
    
    
    def state_list(self):
        """ Get states from state selector and return as string list """
        
        sql = ("SELECT t1.name FROM " + self.schema_name + ".value_state AS t1 "
               " INNER JOIN " + self.schema_name + ".selector_state AS t2 ON t2.state_id = t1.id "
               " WHERE cur_user = current_user")
        rows = self.controller.get_rows(sql)
        if not rows:
            return False
        
        # Create list with selected states
        list_state = ""
        for row in rows:
            list_state += "'" + str(row[0]) + "', "
        list_state = list_state[:-2]
        
        return list_state
    

    def hydro_create_list(self):
        
        self.list_hydro = []
        expl_name = utils_giswater.getWidgetText(self.dlg_search, self.dlg_search.expl_name)
        if expl_name is None or expl_name == "None":
            self.set_model_by_list([], self.dlg_search.hydro_id)
            return

        if not self.params['basic_search_hyd_hydro_field_1']:
            return

        sql = ("SELECT " + self.params['basic_search_hyd_hydro_field_1'] + ", "
               + self.params['basic_search_hyd_hydro_field_2'].replace("'", "''") + ", "
               + self.params['basic_search_hyd_hydro_field_3'].replace("'", "''") + " "
               " FROM " + self.schema_name + ".v_rtc_hydrometer "
               " WHERE " + self.params['basic_search_hyd_hydro_field_expl_name'] + " = '" + str(expl_name) + "' "
               " or " + self.params['basic_search_hyd_hydro_field_expl_name'] + " is null"
               # " AND state IN (" + str(list_state) + ") "
               " ORDER BY " + self.params['basic_search_hyd_hydro_field_1'].replace("'", "''"))
        rows = self.controller.get_rows(sql)
        if not rows:
            return False
            
        self.list_hydro.append("")
        for row in rows:
            append_to_list = True
            for x in range(0, len(row)):
                if row[x] is None:
                    append_to_list = False
            if append_to_list:
                self.list_hydro.append(row[0] + " . " + row[1] + " . " + row[2])
                
        self.list_hydro = sorted(set(self.list_hydro))
        self.set_model_by_list(self.list_hydro, self.dlg_search.hydro_id)


    def hydro_zoom(self, hydro, expl_name):
        """ Zoom feature with the code set in 'network_code' of the layer set in 'network_geom_type' """
        
        # Get selected code from combo
        element = utils_giswater.getWidgetText(self.dlg_search, hydro)
        if element == 'null':
            return

        # Split element. [0]: hydro_id, [1]: connec_customer_code
        row = element.split(' . ', 2)
        hydro_id = str(row[0])
        connec_customer_code = str(row[1])
        expl_name = utils_giswater.getWidgetText(self.dlg_search, expl_name, return_string_null=False)
        sql = ("SELECT " + self.params['basic_search_hyd_hydro_field_cc'] + ", " + self.params['basic_search_hyd_hydro_field_1'] + ""
               " FROM " + self.schema_name + ".v_rtc_hydrometer "
               " WHERE " + self.params['basic_search_hyd_hydro_field_ccc'] + " = '"+str(connec_customer_code)+"' "
               " AND "+self.params['basic_search_hyd_hydro_field_expl_name']+" ILIKE '%" + str(expl_name) + "%' "
               " AND " + self.params['basic_search_hyd_hydro_field_1'] + " = '" + str(hydro_id) + "'")
        row = self.controller.get_row(sql)
        if not row:
            return

        connec_id = row[0]
        hydrometer_customer_code = row[1]

        # Check if the expression is valid
        aux = "connec_id = '" + connec_id + "'"
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = expr.parserErrorString() + ": " + aux
            self.controller.show_warning(message)
            return
        connec_group = self.controller.get_group_layers('connec')
        for layer in connec_group:
            layer_source = self.controller.get_layer_source(layer)
            layer = self.controller.get_layer_by_tablename(layer_source['table'])
            if layer:
                it = layer.getFeatures(QgsFeatureRequest(expr))
                ids = [i.id() for i in it]
                layer.selectByIds(ids)
                # If any feature found, zoom it and exit function
                if layer.selectedFeatureCount() > 0:
                    self.iface.setActiveLayer(layer)
                    self.iface.legendInterface().setLayerVisible(layer, True)
                    self.open_hydrometer_dialog(connec_id, hydrometer_customer_code)
                    self.zoom_to_selected_features(layer, expl_name, 250)
                    return
                

    def open_hydrometer_dialog(self, connec_id, hydrometer_customer_code):
        
        self.hydro_info_dlg = HydroInfo()
        self.load_settings(self.hydro_info_dlg)

        self.hydro_info_dlg.btn_close.clicked.connect(partial(self.close_dialog, self.hydro_info_dlg))
        self.hydro_info_dlg.rejected.connect(partial(self.close_dialog, self.hydro_info_dlg))

        expl_name = utils_giswater.getWidgetText(self.dlg_search, self.dlg_search.expl_name)
        if expl_name == 'null':
            expl_name = ''
        sql = ("SELECT * FROM " + self.schema_name + "." + self.params['basic_search_hyd_hydro_layer_name'] + ""
               " WHERE " + self.params['basic_search_hyd_hydro_field_cc'] + " = '" + connec_id + "'"
               " AND " + self.params['basic_search_hyd_hydro_field_erhc'] + " = '" + hydrometer_customer_code + "'"
               " AND "+self.params['basic_search_hyd_hydro_field_expl_name']+" ILIKE '%" + str(expl_name) + "%'")
        rows = self.controller.get_rows(sql)
        if rows:
            row = rows[0]
        else:
            return

        # Get columns name in order of the table
        sql = ("SELECT column_name FROM information_schema.columns"
               " WHERE table_name = '" + "v_rtc_hydrometer'"
               " AND table_schema = '" + self.schema_name.replace('"', '') + "'"
               " ORDER BY ordinal_position")
        column_name = self.controller.get_rows(sql)

        grid_layout = self.hydro_info_dlg.findChild(QGridLayout, 'gridLayout')
        for x in range(0, len(row)):
            label = QLabel()
            label.setObjectName("lbl_" + column_name[x][0])
            label.setText(str(column_name[x][0] + ": "))
            grid_layout.addWidget(label, x, 0, 1, 1)
            if column_name[x][0] != 'hydrometer_link':
                lineedit = QLineEdit()
                lineedit.setObjectName("txt_"+column_name[x][0])
                lineedit.setText(str(row[x]))
                lineedit.setDisabled(True)
                grid_layout.addWidget(lineedit, x, 1, 1, 1)
            else:
                button = QPushButton()
                button.setObjectName("txt_"+column_name[x][0])
                button.setText(str(row[x]))
                button.setStyleSheet("Text-align:left")
                button.setFlat(True)
                grid_layout.addWidget(button, x, 1, 1, 1)
                self.button_link = button


        url = str(row['hydrometer_link'])
        if url is not None or url != '':
            self.button_link.clicked.connect(partial(self.open_url, url))

        self.hydro_info_dlg.open()

    def open_url(self, url):
        """ Open URL """
        if url:
            webbrowser.open(url)

    def network_code_create_lists(self):
        """ Create one list for each geom type and other one with all geom types """
     
        self.list_arc = []     
        self.list_connec = []     
        self.list_element = []     
        self.list_gully = []     
        self.list_node = []  
        self.list_all = []  
           
        # Check which layers are available and get its list of codes
        if 'network_layer_arc' in self.layers:
            self.list_arc = self.network_code_layer('network_layer_arc')
        if 'network_layer_connec' in self.layers:
            self.list_connec = self.network_code_layer('network_layer_connec')
        if 'network_layer_element' in self.layers:
            self.list_element = self.network_code_layer('network_layer_element')
        if 'network_layer_gully' in self.layers:
            self.list_gully = self.network_code_layer('network_layer_gully')
        if 'network_layer_node' in self.layers:
            self.list_node = self.network_code_layer('network_layer_node')
        
        try: 
            self.list_all = self.list_arc + self.list_connec + self.list_element + self.list_gully + self.list_node
            self.list_all = sorted(set(self.list_all))
            self.set_model_by_list(self.list_all, self.dlg_search.network_code)
        except:
            pass
        
        return True
    
    
    def network_code_layer(self, layername):
        """ Get codes of selected layer and add them to the combo 'network_code' """
        
        viewname = self.params[layername]
        viewname_parts = viewname.split("_")
        if len(viewname_parts) < 3:
            return
        feature_type = str(viewname_parts[2]).lower()

        field_type = ""
        if self.project_type == 'ws':
            if str(viewname_parts[2]) == "arc":
                viewname_parts[2] = "cat_arc"
            field_type = viewname_parts[2] + "type_id"
        elif self.project_type == 'ud':
            field_type = viewname_parts[2] + "_type"

        self.field_to_search = self.params['network_field_' + str(feature_type) + '_code']
        sql = ("SELECT DISTINCT(t1." + str(self.field_to_search) + "), t1." + str(feature_type) + "_id,"
               " t1." + str(field_type) + ", t2.name , t3.name"
               " FROM " + self.controller.schema_name + "." + viewname + " AS t1 "
               " INNER JOIN " + self.controller.schema_name + ".value_state AS t2 ON t2.id = t1.state"
               " INNER JOIN " + self.controller.schema_name + ".exploitation AS t3 ON t3.expl_id = t1.expl_id "
               " WHERE  t1.expl_id IN "
               " (SELECT expl_id FROM " + self.controller.schema_name + ".selector_expl WHERE cur_user = current_user)"
               " AND t1.state IN "
               " (SELECT state_id FROM " + self.controller.schema_name + ".selector_state WHERE cur_user = current_user)"               
               " ORDER BY " + str(self.field_to_search))
        rows = self.controller.get_rows(sql, log_sql=False)
        if not rows:
            return False
        list_codes = ['']
        for row in rows:
            for x in range(0, len(row)):
                if row[x] is None:
                    row[x] = ''
            list_codes.append(row[0] + " . " + row[1] + " . " + row[2] + " . " + row[3] + " . " + row[4]+"")
        return list_codes
        
     
    def network_geom_type_populate(self):
        """ Populate combo 'network_geom_type' """
        
        # Add null value
        self.dlg_search.network_geom_type.clear()
        self.dlg_search.network_geom_type.addItem('')
                   
        # Check which layers are available
        if 'network_layer_arc' in self.layers:  
            self.dlg_search.network_geom_type.addItem(self.controller.tr('Arc'))
        if 'network_layer_connec' in self.layers:  
            self.dlg_search.network_geom_type.addItem(self.controller.tr('Connec'))
        if 'network_layer_element' in self.layers:  
            self.dlg_search.network_geom_type.addItem(self.controller.tr('Element'))
        if 'network_layer_gully' in self.layers:  
            self.dlg_search.network_geom_type.addItem(self.controller.tr('Gully'))
        if 'network_layer_node' in self.layers:  
            self.dlg_search.network_geom_type.addItem(self.controller.tr('Node'))

        return self.dlg_search.network_geom_type > 0


    def expl_name_changed(self):
        #self.zoom_to_polygon(self.dlg_search.expl_name, 'exploitation', 'expl_id','name')
        expl_name = utils_giswater.getWidgetText(self.dlg_search, self.dlg_search.expl_name)

        if expl_name == "null" or expl_name is None or expl_name == "None":
            expl_name = ""
        list_hydro = []

        sql = ("SELECT " + self.params['basic_search_hyd_hydro_field_1'].replace("'", "''") + ", "
               + self.params['basic_search_hyd_hydro_field_2'].replace("'", "''") + ", "
               + self.params['basic_search_hyd_hydro_field_3'].replace("'", "''") + " "
               " FROM " + self.schema_name + ".v_rtc_hydrometer "
               " WHERE " + self.params['basic_search_hyd_hydro_field_expl_name']+" = '" + str(expl_name) + "' "
               # " AND state IN (" + str(list_state) + ") "
               " ORDER BY " + self.params['basic_search_hyd_hydro_field_1'].replace("'", "''"))
        rows = self.controller.get_rows(sql)
        if not rows:
            return
        
        for row in rows:
            append_to_list = True
            for x in range(0, len(row)):
                if row[x] is None:
                    append_to_list = False
            if append_to_list:
                list_hydro.append(row[0] + " . " + row[1] + " . " + row[2])
        list_hydro = sorted(set(list_hydro))
        self.set_model_by_list(list_hydro, self.dlg_search.hydro_id)


    def network_geom_type_changed(self):
        """ Get 'geom_type' to filter 'code' values """        
            
        geom_type = utils_giswater.getWidgetText(self.dlg_search, self.dlg_search.network_geom_type)
        list_codes = []
        if geom_type == self.controller.tr('Arc'):
            list_codes = self.list_arc
        elif geom_type == self.controller.tr('Connec'):
            list_codes = self.list_connec
        elif geom_type == self.controller.tr('Element'):
            list_codes = self.list_element
        elif geom_type == self.controller.tr('Gully'):
            list_codes = self.list_gully
        elif geom_type == self.controller.tr('Node'):
            list_codes = self.list_node
        else:
            list_codes = self.list_all
        self.set_model_by_list(list_codes, self.dlg_search.network_code)
        
        return True


    def network_zoom(self, network_code, network_geom_type):
        """ Zoom feature with the code set in 'network_code' of the layer set in 'network_geom_type' """
        
        # Get selected code from combo
        element = utils_giswater.getWidgetText(self.dlg_search, network_code)
        if element == 'null':
            return

        # Split element. [0]: feature_id, [1]: cat_feature_id
        row = element.split(' . ', 3)
        feature_id = str(row[0])
        geom_id = str(row[1])
        cat_feature_id = str(row[2])

        # Get selected layer
        geom_type = utils_giswater.getWidgetText(self.dlg_search, network_geom_type).lower()
        if geom_type == "null":
            sql = ("SELECT feature_type FROM " + self.controller.schema_name + ".cat_feature"
                   " WHERE id = '" + cat_feature_id + "'")
            row = self.controller.get_row(sql)
            if not row:
                return
            geom_type = row[0].lower()

        # Check if the expression is valid

        expr_filter = "" + geom_type + "_id = '" + geom_id + "'"
        if feature_id:
            expr_filter += " AND " + self.field_to_search + " = '" + feature_id + "'"
        (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
        if not is_valid:
            return

        for value in self.feature_cat.itervalues():
            if value.type.lower() == geom_type:
                layer = self.controller.get_layer_by_layername(value.layername)
                if layer:
                    # Select features of @layer applying @expr
                    self.select_features_by_expr(layer, expr)
                    # If any feature found, zoom it and exit function
                    if layer.selectedFeatureCount() > 0:
                        self.zoom_to_selected_features(layer, geom_type)
                        # Set the layer checked (i.e. set it's visibility)
                        self.iface.legendInterface().setLayerVisible(layer, True)
                        self.open_custom_form(layer, expr)
                        return

                
    def address_populate(self, combo, layername, field_code, field_name):
        """ Populate @combo """
        self.dlg_search.address_street.blockSignals(True)
        self.dlg_search.address_street.clear()
        self.dlg_search.address_street.blockSignals(False)
        # Check if we have this search option available
        if layername not in self.layers:
            return False

        # Get features
        layer = self.layers[layername]        
        records = [(-1, '', '')]
        idx_field_code = layer.fieldNameIndex(self.params[field_code])
        idx_field_name = layer.fieldNameIndex(self.params[field_name])
        
        it = layer.getFeatures()
                             
        if layername == 'street_layer':
            
            # Get 'expl_id'
            field_expl_id = self.street_field_expl
            elem = self.dlg_search.address_exploitation.itemData(self.dlg_search.address_exploitation.currentIndex())
            expl_id = elem[0]
            records = [[-1, '']]
            
            # Set filter expression
            expr_filter = field_expl_id + " = '" + str(expl_id) + "'"
            (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
            if not is_valid:
                return            
            
            it = layer.getFeatures(QgsFeatureRequest(expr))                        
        
        # Iterate over features
        for feature in it:        
            geom = feature.geometry()
            attrs = feature.attributes()                
            value_code = attrs[idx_field_code]
            value_name = attrs[idx_field_name]
            if not type(value_code) is QPyNullVariant and geom is not None:
                elem = [value_code, value_name, geom.exportToWkt()]
            else:
                elem = [value_code, value_name, None]
            records.append(elem)

        # Clear combo address_number
        self.dlg_search.address_number.blockSignals(True)
        self.dlg_search.address_number.clear()
        self.dlg_search.address_number.blockSignals(False)

        # Fill combo     
        combo.blockSignals(True)
        combo.clear()
        records_sorted = sorted(records, key = operator.itemgetter(1))
        for record in records_sorted:
            combo.addItem(record[1], record)        
        combo.blockSignals(False)     
        
        return True
           

    def address_get_numbers(self, combo, field_code, fill_combo=False, zoom=True):
        """ Populate civic numbers depending on value of selected @combo. 
        Build an expression with @field_code """

        # Clear combo address_number
        self.dlg_search.address_number.blockSignals(True)
        self.dlg_search.address_number.clear()
        self.dlg_search.address_number.blockSignals(False)
        # Get selected street
        selected = utils_giswater.getWidgetText(self.dlg_search, combo)
        if selected == 'null':
            return

        # Get street code
        elem = combo.itemData(combo.currentIndex())
        code = elem[0]  # to know the index see the query that populate the combo
        records = [[-1, '']]
        
        # Check if layer exists
        if not 'portal_layer' in self.layers:
            message = "Layer not found. Check parameter"
            self.controller.show_warning(message, parameter='portal_layer')
            return 
        
        # Set filter expression
        layer = self.layers['portal_layer']
        idx_field_code = layer.fieldNameIndex(field_code)
        idx_field_number = layer.fieldNameIndex(self.params['portal_field_number'])
        expr_filter = field_code + "  = '" + str(code) + "'"
        (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
        if not is_valid:
            return      

        if idx_field_code == -1:
            message = "Field '{}' not found in layer '{}'. Open '{}' and check parameter '{}'" \
                .format(self.params['portal_field_code'], layer.name(), self.setting_file, 'portal_field_code')
            self.controller.show_warning(message)
            return
        if idx_field_number == -1:
            message = "Field '{}' not found in layer '{}'. Open '{}' and check parameter '{}'" \
                .format(self.params['portal_field_number'], layer.name(), self.setting_file, 'portal_field_number')
            self.controller.show_warning(message)
            return

        self.dlg_search.address_number.blockSignals(True)
        self.dlg_search.address_number.clear()

        if fill_combo:
            it = layer.getFeatures(QgsFeatureRequest(expr))
            for feature in it:
                attrs = feature.attributes()
                field_number = attrs[idx_field_number]
                if not type(field_number) is QPyNullVariant:
                    elem = [code, field_number]
                    records.append(elem)

            # Fill numbers combo
            records_sorted = sorted(records, key=operator.itemgetter(1))

            for record in records_sorted:
                self.dlg_search.address_number.addItem(record[1], record)
            self.dlg_search.address_number.blockSignals(False)

        if zoom:
            # Select features of @layer applying @expr
            self.select_features_by_expr(layer, expr)
    
            # Zoom to selected feature of the layer
            self.zoom_to_selected_features(layer, 'arc')
        
                
    def address_zoom_portal(self):
        """ Show street data on the canvas when selected street and number in street tab """  
                
        # Get selected street
        street = utils_giswater.getWidgetText(self.dlg_search, self.dlg_search.address_street)
        civic = utils_giswater.getWidgetText(self.dlg_search, self.dlg_search.address_number)
        if street == 'null' or civic == 'null':
            return  
                
        # Get selected portal
        elem = self.dlg_search.address_number.itemData(self.dlg_search.address_number.currentIndex())
        if not elem:
            # that means that user has edited manually the combo but the element
            # does not correspond to any combo element
            message = 'Element {} does not exist'.format(civic)
            self.controller.show_warning(message)
            return
        
        # select this feature in order to copy to memory layer        
        expr_filter = (self.params['portal_field_code'] + " = '" + str(elem[0]) + "'"
               " AND " + self.params['portal_field_number'] + " = '" + str(elem[1]) + "'")
        (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
        if not is_valid:
            return
           
        # Select features of @layer applying @expr
        layer = self.layers['portal_layer']    
        self.select_features_by_expr(layer, expr)

        # Zoom to selected feature of the layer
        self.zoom_to_selected_features(self.layers['portal_layer'], 'node')
                    
        # Toggles 'Show feature count'
        self.show_feature_count()                  
          
    
    def generic_zoom(self, fieldname, combo, field_index=0):  #@UnusedFuntion
        """ Get selected element from the combo, and returns a feature request expression """
        
        # Get selected element from combo
        element = utils_giswater.getWidgetText(combo)                    
        if element == 'null':
            return None
                
        elem = combo.itemData(combo.currentIndex())
        if not elem:
            # that means that user has edited manually the combo but the element
            # does not correspond to any combo element
            message = 'Element {} does not exist'.format(element)
            self.controller.show_warning(message)
            return None
        
        # Check if the expression is valid
        expr_filter = fieldname + " = '" + str(elem[field_index]) + "'"
        (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
        if not is_valid:
            return        
        
        return expr
                        
            
    def populate_cmb_expl_name(self, parameter, combo, fieldname):
        """ Populate selected combo from features of selected layer """        
        
        # Check if we have this search option available
        if not parameter in self.layers: 
            return False

        # Fields management
        layer = self.layers[parameter]
        records = []
        idx_field = layer.fieldNameIndex(fieldname) 
        if idx_field == -1:
            message = "Field '{}' not found in the layer specified in parameter '{}'".format(fieldname, parameter)
            self.controller.show_warning(message)
            return False


        # Iterate over all features to get distinct records
        list_elements = []
        for feature in layer.getFeatures():                                
            attrs = feature.attributes() 
            field = attrs[idx_field]
            if not type(field) is QPyNullVariant:
                if field not in list_elements:
                    elem = [field, field]
                    list_elements.append(field)
                    records.append(elem)

        if not records:
            utils_giswater.remove_tab_by_tabName(self.dlg_search.tab_main, "tab_hydro")
            return
        sql = ("SELECT t1.name FROM " + self.schema_name + ".exploitation AS t1 "
               " INNER JOIN " + self.schema_name + ".selector_expl AS t2 ON t2.expl_id = t1.expl_id "
               " WHERE cur_user = current_user")
        rows = self.controller.get_rows(sql)
        # Create list with selected exploitations
        list_expl = []
        if rows:
            list_expl = [x[0] for x in rows]
        # Fill combo box
        combo.blockSignals(True)
        combo.clear()
        records_sorted = sorted(records, key=operator.itemgetter(1))
        expl_list = []
        for i in range(len(records_sorted)):
            record = records_sorted[i]
            if record[1] != '':
                if record[1] in list_expl:
                    expl_list.append(record[1])

        self.set_model_by_list(expl_list, combo)
        combo.blockSignals(False)

        self.expl_name_changed()
        return True    
        
                
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
        
        
    def clear_workcat(self):

        sql = ("DELETE FROM " + self.schema_name + ".selector_workcat")
        status = self.controller.execute_sql(sql)
        if status:
            message = "Workcat cleared successfully"
            self.controller.show_info(message)
            # Clear combo workcat_id
            utils_giswater.setWidgetText(self.dlg_search, self.dlg_search.workcat_id, "")
            # Get layer by table_name
            layer = self.iface.activeLayer()
            # Refresh canvas
            self.refresh_map_canvas()


    def refresh_workcat(self):

        sql = "SELECT " + self.schema_name + ".gw_fct_refresh_mat_view();"
        status = self.controller.execute_sql(sql)
        if status:
            message = "Polygon refreshed successfully"
            self.controller.show_info(message)
            self.refresh_map_canvas()
                                               

    def open_plan_psector(self):

        psector_name = self.dlg_search.psector_id.currentText()
        sql = ("SELECT psector_id"
               " FROM " + self.schema_name + ".plan_psector"
               " WHERE name = '" + str(psector_name)+"'")
        row = self.controller.get_row(sql)
        psector_id = row[0]
        self.manage_new_psector.new_psector(psector_id, 'plan')
        self.zoom_to_psector(self.dlg_search, self.dlg_search.psector_id, 'v_edit_plan_psector', 'psector_id', 'name')


    def zoom_to_psector(self, dialog, widget, table_name, field_id, field_name):

        polygon_name = utils_giswater.getWidgetText(dialog, widget)
        sql = ("SELECT " + str(field_id) + " FROM " + self.schema_name + "." + str(table_name) + " "
               " WHERE " + str(field_name) + "=$$" + str(polygon_name) + "$$")
        row = self.controller.get_row(sql, log_sql=True)

        layer = self.controller.get_layer_by_tablename(table_name)
        if not layer:
            return

        # Check if the expression is valid
        expr_filter = str(field_id) + " = '" + str(row[0]) + "'"
        (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
        if not is_valid:
            return

        # Select features of @layer applying @expr
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

        # If any feature found, zoom it and exit function
        if layer.selectedFeatureCount() > 0:
            self.iface.setActiveLayer(layer)
            self.iface.legendInterface().setLayerVisible(layer, True)
            self.iface.actionZoomToSelected().trigger()
            layer.removeSelection()


    def refresh_data(self):
        
        self.network_code_create_lists()            
        if self.project_type == 'ws':
            self.populate_cmb_expl_name('basic_search_hyd_hydro_layer_name', self.dlg_search.expl_name,
                self.params['basic_search_hyd_hydro_field_expl_name'])
            self.hydro_create_list()
        self.psector_populate(self.dlg_search, self.dlg_search.psector_id)
                    

    def unload(self):
        """ Removes dialog """       
        if self.dlg_search:
            self.dlg_search.deleteLater()
            del self.dlg_search


    #TODO: Move to a common class
    def set_model_by_list(self, string_list, widget):

        model = QStringListModel()
        model.setStringList(string_list)
        self.proxy_model = QSortFilterProxyModel()
        self.proxy_model.setSourceModel(model)
        self.proxy_model.setFilterKeyColumn(0)
        proxy_model_aux = QSortFilterProxyModel()
        proxy_model_aux.setSourceModel(model)
        proxy_model_aux.setFilterKeyColumn(0)
        widget.setModel(proxy_model_aux)
        widget.setModelColumn(0)
        completer = QCompleter()
        completer.setModel(self.proxy_model)
        completer.setCompletionColumn(0)
        completer.setCompletionMode(QCompleter.UnfilteredPopupCompletion)
        widget.setCompleter(completer)


    def filter_by_list(self, widget):
        self.proxy_model.setFilterFixedString(widget.currentText())


    def set_table_columns(self, dialog, widget, table_name):
        """ Configuration of tables. Set visibility and width of columns """

        widget = utils_giswater.getWidget(dialog, widget)
        if not widget:
            return

        # Set width and alias of visible columns
        columns_to_delete = []
        sql = ("SELECT column_index, width, alias, status"
               " FROM " + self.schema_name + ".config_client_forms"
               " WHERE table_id = '" + table_name + "'"
               " ORDER BY column_index")
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
        # widget.model().setSort(0, Qt.AscendingOrder)
        widget.model().select()

        # Delete columns
        for column in columns_to_delete:
            widget.hideColumn(column)

            
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
            dialog = self.dlg_search

        self.controller.plugin_settings_set_value(dialog.objectName() + "_width", dialog.property('width'))
        self.controller.plugin_settings_set_value(dialog.objectName() + "_height", dialog.property('height'))
        self.controller.plugin_settings_set_value(dialog.objectName() + "_x", dialog.pos().x() + 8)
        self.controller.plugin_settings_set_value(dialog.objectName() + "_y", dialog.pos().y() + 31)


    def close_dialog(self, dlg=None):
        """ Close dialog """

        if dlg is None or type(dlg) is bool:
            dlg = self.dlg_search
        try:
            self.save_settings(dlg)
            dlg.close()
        except AttributeError:
            pass
        

    def check_expression(self, expr_filter, log_info=False):
        """ Check if expression filter @expr is valid """
        
        if log_info:
            self.controller.log_info(expr_filter)
        expr = QgsExpression(expr_filter)
        if expr.hasParserError():
            message = "Expression Error"
            self.controller.log_warning(message, parameter=expr_filter)
            return (False, expr)
        return (True, expr)
    

    def select_features_by_expr(self, layer, expr):
        """ Select features of @layer applying @expr """

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


    def refresh_map_canvas(self):
        """ Refresh all layers present in map canvas """

        self.canvas.refreshAllLayers()
        for layer_refresh in self.canvas.layers():
            layer_refresh.triggerRepaint()


    def show_feature_count(self):
        """ Toggles 'Show Feature Count' of all the layers in the root path of the TOC """   
                     
        root = QgsProject.instance().layerTreeRoot()
        for child in root.children():
            if isinstance(child, QgsLayerTreeLayer):
                child.setCustomProperty("showFeatureCount", True) 
                
                
