"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    from qgis.PyQt.QtGui import QStringListModel
else:
    from qgis.PyQt.QtCore import QStringListModel

from qgis.PyQt.QtWidgets import QCompleter
from qgis.PyQt.QtCore import Qt, QDate

import json
from collections import OrderedDict
from functools import partial
from datetime import datetime

from .. import utils_giswater
from .parent import ParentMapTool
from ..ui_manager import UDcatalog
from ..ui_manager import WScatalog
from ..ui_manager import FeatureReplace
from ..ui_manager import NewWorkcat
from ..actions.api_catalog import ApiCatalog


class ReplaceFeatureMapTool(ParentMapTool):
    """ Button 44: User select one feature. Execute SQL function: 'gw_fct_feature_replace' """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        super(ReplaceFeatureMapTool, self).__init__(iface, settings, action, index_action)
        self.current_date = QDate.currentDate().toString('yyyy-MM-dd')
        self.project_type = None
        self.geom_type = None
        self.geom_view = None
        self.cat_table = None
        self.feature_type_ws = None
        self.feature_type_ud = None


    def manage_dates(self, date_value):
        """ Manage dates """

        date_result = None
        try:
            date_result = str(date_value)
            date_result = date_result.replace("-", "/")
            date_result = datetime.strptime(date_result, '%Y/%m/%d')
        except Exception as e:
            self.controller.log_warning(str(e))
        finally:
            return date_result


    def init_replace_feature_form(self, feature):

        # Create the dialog and signals
        self.dlg_replace = FeatureReplace()
        self.load_settings(self.dlg_replace)

        sql = "SELECT id FROM cat_work ORDER BY id"
        rows = self.controller.get_rows(sql)
        if rows:
            utils_giswater.fillComboBox(self.dlg_replace, self.dlg_replace.workcat_id_end, rows)
            utils_giswater.set_autocompleter(self.dlg_replace.workcat_id_end)

        sql = ("SELECT value FROM config_param_user "
               "WHERE cur_user = current_user AND parameter = 'workcat_vdefault'")
        row = self.controller.get_row(sql)
        if row:
            workcat_vdefault = self.dlg_replace.workcat_id_end.findText(row[0])
            self.dlg_replace.workcat_id_end.setCurrentIndex(workcat_vdefault)

        sql = ("SELECT value FROM config_param_user "
               "WHERE cur_user = current_user AND parameter = 'enddate_vdefault'")
        row = self.controller.get_row(sql, log_info=False)
        if row:
            self.enddate_aux = self.manage_dates(row[0]).date()
        else:
            work_id = utils_giswater.getWidgetText(self.dlg_replace, self.dlg_replace.workcat_id_end)
            sql = ("SELECT builtdate FROM cat_work "
                   "WHERE id = '" + str(work_id) + "'")
            row = self.controller.get_row(sql)
            current_date = self.manage_dates(self.current_date)
            if row and row[0]:
                builtdate = self.manage_dates(row[0])
                if builtdate != 'null' and builtdate:
                    self.enddate_aux = builtdate.date()
                else:
                    self.enddate_aux = current_date.date()
            else:
                self.enddate_aux = current_date.date()

        self.dlg_replace.enddate.setDate(self.enddate_aux)

        # Get feature type from current feature
        feature_type = None
        if self.project_type == 'ws':
            feature_type = feature.attribute(self.feature_type_ws)
        elif self.project_type == 'ud':
            feature_type = feature.attribute(self.feature_type_ud)
            if self.geom_type in ('node', 'connec'):
                sql = "SELECT DISTINCT(id) FROM " + self.cat_table + " ORDER BY id"
                rows = self.controller.get_rows(sql)
                utils_giswater.fillComboBox(self.dlg_replace, "featurecat_id", rows, allow_nulls=False)

        self.dlg_replace.feature_type.setText(feature_type)
        self.dlg_replace.feature_type_new.currentIndexChanged.connect(self.edit_change_elem_type_get_value)
        self.dlg_replace.btn_catalog.clicked.connect(partial(self.open_catalog))
        self.dlg_replace.workcat_id_end.currentIndexChanged.connect(self.update_date)

        # Fill 1st combo boxes-new system node type
        sql = ("SELECT DISTINCT(id) FROM " + self.geom_type + "_type "
               "WHERE active is True "
               "ORDER BY id")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_replace, "feature_type_new", rows)

        self.dlg_replace.btn_new_workcat.clicked.connect(partial(self.new_workcat))
        self.dlg_replace.btn_accept.clicked.connect(partial(self.get_values, self.dlg_replace))
        self.dlg_replace.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_replace))

        # Open dialog
        self.open_dialog(self.dlg_replace, maximize_button=False)


    def open_catalog(self):

        # Get feature_type
        feature_type = utils_giswater.getWidgetText(self.dlg_replace,self.dlg_replace.feature_type_new)

        if feature_type is 'null':
            msg = "New feature type is null. Please, select a valid value."
            self.controller.show_info_box(msg, "Info")
            return
        self.catalog = ApiCatalog(self.iface, self.settings, self.controller, self.plugin_dir)
        self.catalog.api_catalog(self.dlg_replace, 'featurecat_id', 'node', feature_type)


    def update_date(self):

        sql = ("SELECT value FROM config_param_user "
               "WHERE cur_user = current_user AND parameter = 'enddate_vdefault'")
        row = self.controller.get_row(sql, log_info=False)
        if row:
            self.enddate_aux = self.manage_dates(row[0]).date()
        else:
            work_id = utils_giswater.getWidgetText(self.dlg_replace, self.dlg_replace.workcat_id_end)
            sql = ("SELECT builtdate FROM cat_work "
                   "WHERE id = '" + str(work_id) + "'")
            row = self.controller.get_row(sql)
            current_date = self.manage_dates(self.current_date)
            if row and row[0]:
                builtdate = self.manage_dates(row[0])
                if builtdate != 'null' and builtdate:
                    self.enddate_aux = builtdate.date()
                else:
                    self.enddate_aux = current_date.date()
            else:
                self.enddate_aux = current_date.date()

        self.dlg_replace.enddate.setDate(self.enddate_aux)


    def new_workcat(self):

        self.dlg_new_workcat = NewWorkcat()
        self.load_settings(self.dlg_new_workcat)
        utils_giswater.setCalendarDate(self.dlg_new_workcat, self.dlg_new_workcat.builtdate, None, True)

        table_object = "cat_work"
        self.set_completer_object(table_object,self.dlg_new_workcat.cat_work_id,'id')

        # Set signals
        self.dlg_new_workcat.btn_accept.clicked.connect(partial(self.manage_new_workcat_accept, table_object))
        self.dlg_new_workcat.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_new_workcat))

        # Open dialog
        self.open_dialog(self.dlg_new_workcat)


    def manage_new_workcat_accept(self, table_object):
        """ Insert table 'cat_work'. Add cat_work """

        # Get values from dialog
        values = ""
        fields = ""
        cat_work_id = utils_giswater.getWidgetText(self.dlg_new_workcat, self.dlg_new_workcat.cat_work_id)
        if cat_work_id != "null":
            fields += 'id, '
            values += ("'" + str(cat_work_id) + "', ")
        descript = utils_giswater.getWidgetText(self.dlg_new_workcat, "descript")
        if descript != "null":
            fields += 'descript, '
            values += ("'" + str(descript) + "', ")
        link = utils_giswater.getWidgetText(self.dlg_new_workcat, "link")
        if link != "null":
            fields += 'link, '
            values += ("'" + str(link) + "', ")
        workid_key_1 = utils_giswater.getWidgetText(self.dlg_new_workcat, "workid_key_1")
        if workid_key_1 != "null":
            fields += 'workid_key1, '
            values += ("'" + str(workid_key_1) + "', ")
        workid_key_2 = utils_giswater.getWidgetText(self.dlg_new_workcat, "workid_key_2")
        if workid_key_2 != "null":
            fields += 'workid_key2, '
            values += ("'" + str(workid_key_2) + "', ")
        builtdate = self.dlg_new_workcat.builtdate.dateTime().toString('yyyy-MM-dd')
        if builtdate != "null":
            fields += 'builtdate, '
            values += ("'" + str(builtdate) + "', ")

        if values != "":
            fields = fields[:-2]
            values = values[:-2]
            if cat_work_id == 'null':
                msg = "Work_id field is empty"
                self.controller.show_info_box(msg, "Warning")
            else:
                # Check if this element already exists
                sql = ("SELECT DISTINCT(id)"
                       " FROM " + str(table_object) + ""
                       " WHERE id = '" + str(cat_work_id) + "'")
                row = self.controller.get_row(sql, log_info=False, log_sql=True)
                if row is None:
                    sql = ("INSERT INTO cat_work (" + fields + ") VALUES (" + values + ")")
                    self.controller.execute_sql(sql, log_sql=True)

                    sql = ("SELECT id FROM cat_work ORDER BY id")
                    rows = self.controller.get_rows(sql)
                    if rows:
                        utils_giswater.fillComboBox(self.dlg_replace, self.dlg_replace.workcat_id_end, rows)
                        current_index = self.dlg_replace.workcat_id_end.findText(str(cat_work_id))
                        self.dlg_replace.workcat_id_end.setCurrentIndex(current_index)

                    self.close_dialog(self.dlg_new_workcat)
                else:
                    msg = "This Workcat is already exist"
                    self.controller.show_info_box(msg, "Warning")


    def cancel(self):
        
        self.close_dialog(self.dlg_cat)


    def set_completer_object(self, tablename, widget, field_id):
        """ Set autocomplete of widget @table_object + "_id"
            getting id's from selected @table_object
        """
        
        if not widget:
            return

        sql = ("SELECT DISTINCT(" + field_id + ") "
               "FROM " + tablename + " "
               "ORDER BY "+ field_id + "")
        row = self.controller.get_rows(sql)
        for i in range(0, len(row)):
            aux = row[i]
            row[i] = str(aux[0])

        # Set completer and model: add autocomplete in the widget
        self.completer = QCompleter()
        self.completer.setCaseSensitivity(Qt.CaseInsensitive)
        widget.setCompleter(self.completer)
        model = QStringListModel()
        model.setStringList(row)
        self.completer.setModel(model)


    def get_values(self, dialog):

        self.workcat_id_end_aux = utils_giswater.getWidgetText(dialog, dialog.workcat_id_end)
        self.enddate_aux = dialog.enddate.date().toString('yyyy-MM-dd')

        feature_type_new = utils_giswater.getWidgetText(dialog, dialog.feature_type_new)
        featurecat_id = utils_giswater.getWidgetText(dialog, dialog.featurecat_id)

        # Ask question before executing
        message = "Are you sure you want to replace selected feature with a new one?"
        answer = self.controller.ask_question(message, "Replace feature")
        if answer:

            # Get function input parameters
            feature = '"type":"' + str(self.geom_type) + '"'
            extras = '"old_feature_id":"' + str(self.feature_id) + '"'
            extras += ', "workcat_id_end":"' + str(self.workcat_id_end_aux) + '"'
            extras += ', "enddate":"' + str(self.enddate_aux) + '"'
            extras += ', "keep_elements":"' + str(utils_giswater.isChecked(dialog, "keep_elements")) + '"'
            body = self.create_body(feature=feature, extras=extras)

            # Execute SQL function and show result to the user
            function_name = "gw_fct_feature_replace"
            sql = ("SELECT " + str(function_name) + "($${" + body + "}$$)::text")
            row = self.controller.get_row(sql, log_sql=True, commit=True)
            if not row:
                message = "Error replacing feature"
                self.controller.show_warning(message)
                self.deactivate()
                self.set_action_pan()
                self.close_dialog(dialog, set_action_pan=False)
                return

            complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
            message = "Feature replaced successfully"
            self.controller.show_info(message)

            # Force user to manage with state = 1 features
            current_user = self.controller.get_project_user()
            sql = ("DELETE FROM selector_state "
                   "WHERE state_id = 1 AND cur_user = '" + str(current_user) + "';"
                   "\nINSERT INTO selector_state (state_id, cur_user) "
                   "VALUES (1, '" + str(current_user) + "');")
            self.controller.execute_sql(sql)

            if feature_type_new != "null" and featurecat_id != "null":
                # Get id of new generated feature
                sql = ("SELECT " + self.geom_type + "_id "
                       "FROM " + self.geom_view + " "
                       "ORDER BY " + self.geom_type + "_id::int4 DESC LIMIT 1")
                row = self.controller.get_row(sql)
                if row:
                    if self.geom_type == 'connec':
                        field_cat_id = "connecat_id"
                    else:
                        field_cat_id = self.geom_type + "cat_id"
                    if self.geom_type != 'gully':
                        sql = ("UPDATE " + self.geom_view + " "
                               "SET " + field_cat_id + " = '" + str(featurecat_id) + "' "
                               "WHERE " + self.geom_type + "_id = '" + str(row[0]) + "'")
                    self.controller.execute_sql(sql, log_sql=True)
                    if self.project_type == 'ud':
                        sql = ("UPDATE " + self.geom_view + " "
                               "SET " + self.geom_type + "_type = '" + str(feature_type_new) + "' "
                               "WHERE " + self.geom_type + "_id = '" + str(row[0]) + "'")
                        self.controller.execute_sql(sql, log_sql=True)

                message = "Values has been updated"
                self.controller.show_info(message)

            # Fill tab 'Info log'
            if complet_result and complet_result[0]['status'] == "Accepted":
                qtabwidget = self.dlg_replace.info_log
                qtextedit = self.dlg_replace.txt_infolog
                self.populate_info_text(self.dlg_replace, qtabwidget, qtextedit, complet_result[0]['body']['data'])

            # Refresh canvas
            self.refresh_map_canvas()

            # Deactivate map tool
            self.deactivate()
            self.set_action_pan()


    """ QgsMapTools inherited event functions """

    def keyPressEvent(self, event):

        if event.key() == Qt.Key_Escape:
            self.cancel_map_tool()
            return


    def canvasMoveEvent(self, event):

        # Hide marker and get coordinates
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(event)

        # Snapping layers 'v_edit_'
        result = self.snapper_manager.snap_to_background_layers(event_point)
        if self.snapper_manager.result_is_valid():
            layer = self.snapper_manager.get_snapped_layer(result)
            tablename = self.controller.get_layer_source_table_name(layer)
            if tablename and 'v_edit' in tablename:
                self.snapper_manager.add_marker(result, self.vertex_marker)


    def canvasReleaseEvent(self, event):
        
        if event.button() == Qt.RightButton:
            self.cancel_map_tool()
            return

        event_point = self.snapper_manager.get_event_point(event)

        # Snapping
        result = self.snapper_manager.snap_to_background_layers(event_point)
        if not self.snapper_manager.result_is_valid():
            return

        # Get snapped feature
        snapped_feat = self.snapper_manager.get_snapped_feature(result)
        if snapped_feat:
            layer = self.snapper_manager.get_snapped_layer(result)
            tablename = self.controller.get_layer_source_table_name(layer)
            if tablename and 'v_edit' in tablename:
                if tablename == 'v_edit_node':
                    self.geom_type = 'node'
                elif tablename == 'v_edit_connec':
                    self.geom_type = 'connec'
                elif tablename == 'v_edit_gully':
                    self.geom_type = 'gully'

                self.geom_view = tablename
                self.cat_table = 'cat_' + self.geom_type
                self.feature_type_ws = self.geom_type + 'type_id'
                self.feature_type_ud = self.geom_type + '_type'
                self.feature_id = snapped_feat.attribute(self.geom_type + '_id')
                self.init_replace_feature_form(snapped_feat)


    def activate(self):

        # Check button
        self.action().setChecked(True)

        # Set main snapping layers
        self.snapper_manager.set_snapping_layers()

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Disable snapping
        self.snapper_manager.enable_snapping()

        # Set snapping to 'node', 'connec' and 'gully'
        self.snapper_manager.snap_to_node()
        self.snapper_manager.snap_to_connec_gully()

        # Change cursor
        self.canvas.setCursor(self.cursor)

        self.project_type = self.controller.get_project_type()

        # Show help message when action is activated
        if self.show_help:
            message = "Select the feature by clicking on it and it will be replaced"
            self.controller.show_info(message)


    def deactivate(self):

        ParentMapTool.deactivate(self)


    def edit_change_elem_type_get_value(self, index):
        """ Just select item to 'real' combo 'featurecat_id' (that is hidden) """

        if index == -1:
            return

        # Get selected value from 2nd combobox
        feature_type_new = utils_giswater.getWidgetText(self.dlg_replace, "feature_type_new")

        # When value is selected, enabled 3rd combo box
        if feature_type_new == 'null':
            return

        if self.project_type == 'ws':
            # Fill 3rd combo_box-catalog_id
            utils_giswater.setWidgetEnabled(self.dlg_replace, self.dlg_replace.featurecat_id, True)
            sql = ("SELECT DISTINCT(id) "
                   "FROM " + self.cat_table + " "
                   "WHERE " + self.feature_type_ws + " = '" + str(feature_type_new) + "'")
            rows = self.controller.get_rows(sql)
            utils_giswater.fillComboBox(self.dlg_replace, self.dlg_replace.featurecat_id, rows)


    def open_catalog_form(self, wsoftware, geom_type):
        """ Set dialog depending water software """

        feature_type_new = utils_giswater.getWidgetText(self.dlg_replace, "feature_type_new")
        if feature_type_new == 'null':
            message = "Select a custom feature type"
            self.controller.show_warning(message)
            return

        if wsoftware == 'ws':
            self.dlg_cat = WScatalog()
            self.field2 = 'pnom'
            self.field3 = 'dnom'
        elif wsoftware == 'ud':
            self.dlg_cat = UDcatalog()
            self.field2 = 'shape'
            self.field3 = 'geom1'
        self.load_settings(self.dlg_cat)

        self.feature_type_new = None
        if wsoftware == 'ws':
            self.feature_type_new = feature_type_new

        sql = ("SELECT DISTINCT(matcat_id) as matcat_id "
               "FROM cat_" + geom_type)
        if wsoftware == 'ws':
            sql += " WHERE " + str(geom_type) + "type_id = '" + str(self.feature_type_new) + "'"

        sql += " ORDER BY matcat_id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat, self.dlg_cat.matcat_id, rows)

        sql = ("SELECT DISTINCT(" + self.field2 + ") "
               "FROM cat_" + geom_type)
        if wsoftware == 'ws':
            sql += " WHERE " + str(geom_type) + "type_id = '" + str(self.feature_type_new) + "'"

        sql += " ORDER BY " + str(self.field2)
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat, self.dlg_cat.filter2, rows)

        self.fill_filter3(wsoftware, geom_type)

        # Set signals and open dialog
        self.dlg_cat.btn_ok.clicked.connect(self.fill_geomcat_id)
        self.dlg_cat.btn_cancel.clicked.connect(partial(self.cancel))
        self.dlg_cat.rejected.connect(partial(self.cancel))
        self.dlg_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))
        self.dlg_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_filter2, wsoftware, geom_type))
        self.dlg_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_filter3, wsoftware, geom_type))
        self.dlg_cat.filter2.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))
        self.dlg_cat.filter2.currentIndexChanged.connect(partial(self.fill_filter3, wsoftware, geom_type))
        self.dlg_cat.filter3.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))
        self.open_dialog(self.dlg_cat)


    def fill_geomcat_id(self):

        catalog_id = utils_giswater.getWidgetText(self.dlg_cat, self.dlg_cat.id)
        utils_giswater.setWidgetEnabled(self.dlg_replace, self.dlg_replace.featurecat_id, True)
        utils_giswater.setWidgetText(self.dlg_replace, self.dlg_replace.featurecat_id, catalog_id)
        self.close_dialog(self.dlg_cat)


    def fill_filter2(self, wsoftware, geom_type):

        # Get values from filters
        mats = utils_giswater.getWidgetText(self.dlg_cat, self.dlg_cat.matcat_id)

        # Set SQL query
        sql_where = ""
        sql = ("SELECT DISTINCT(" + self.field2 + ") "
               "FROM cat_" + geom_type)

        # Build SQL filter
        if mats != "null":
            if sql_where == "":
                sql_where = " WHERE"
            sql_where += " matcat_id = '" + mats + "'"
        if wsoftware == 'ws' and self.feature_type_new is not None:
            if sql_where == "":
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " " + geom_type + "type_id = '" + self.feature_type_new + "'"
        sql += sql_where + " ORDER BY " + self.field2

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat, self.dlg_cat.filter2, rows)
        self.fill_filter3(wsoftware, geom_type)


    def fill_filter3(self, wsoftware, geom_type):

        # Get values from filters
        mats = utils_giswater.getWidgetText(self.dlg_cat, self.dlg_cat.matcat_id)
        filter2 = utils_giswater.getWidgetText(self.dlg_cat, self.dlg_cat.filter2)

        # Set SQL query
        sql_where = ""
        if wsoftware == 'ws' and geom_type != 'connec':
            sql = "SELECT " + str(self.field3)
            sql += " FROM (SELECT DISTINCT(regexp_replace(trim(' nm' FROM " + str(self.field3) + "),'-','', 'g')) as x, " + str(self.field3)
        elif wsoftware == 'ws' and geom_type == 'connec':
            sql = "SELECT DISTINCT(TRIM(TRAILING ' ' from " + str(self.field3) + ")) as " + str(self.field3)
        else:
            sql = "SELECT DISTINCT(" + self.field3 + ")"
        sql += " FROM cat_" + str(geom_type)

        # Build SQL filter
        if wsoftware == 'ws' and self.feature_type_new is not None:
            sql_where = " WHERE " + str(geom_type) + "type_id = '" + str(self.feature_type_new) + "'"

        if mats != "null":
            if sql_where == "":
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " matcat_id = '" + str(mats) + "'"

        if filter2 is not None and filter2 != "null":
            if sql_where == "":
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " " + str(self.field2) + " = '" + str(filter2) + "'"
        if wsoftware == 'ws' and geom_type != 'connec':
            sql += sql_where + " ORDER BY x) AS " + str(self.field3)
        else:
            sql += sql_where + " ORDER BY " + str(self.field3)

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat, self.dlg_cat.filter3, rows)

        self.fill_catalog_id(wsoftware, geom_type)


    def fill_catalog_id(self, wsoftware, geom_type):

        # Get values from filters
        mats = utils_giswater.getWidgetText(self.dlg_cat, self.dlg_cat.matcat_id)
        filter2 = utils_giswater.getWidgetText(self.dlg_cat, self.dlg_cat.filter2)
        filter3 = utils_giswater.getWidgetText(self.dlg_cat, self.dlg_cat.filter3)

        # Set SQL query
        sql_where = ""
        sql = ("SELECT DISTINCT(id) as id "
               "FROM cat_" + geom_type)

        if wsoftware == 'ws' and self.feature_type_new is not None:
            sql_where = " WHERE " + geom_type + "type_id = '" + self.feature_type_new + "'"
        if mats != "null":
            if sql_where == "":
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " matcat_id = '" + mats + "'"

        if filter2 is not None and filter2 != "null":
            self.controller.log_info("filter2")
            if sql_where == "":
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " " + self.field2 + " = '" + filter2 + "'"

        if filter3 is not None and filter3 != "null":
            if sql_where == "":
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " " + self.field3 + " = '" + filter3 + "'"
        sql += sql_where + " ORDER BY id"

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat, self.dlg_cat.id, rows)
        

    def populate_info_text(self, dialog, qtabwidget, qtextedit, data, force_tab=True, reset_text=True):

        change_tab = False
        text = utils_giswater.getWidgetText(dialog, qtextedit, return_string_null=False)
        if reset_text:
            text = ""
        for item in data['info']['values']:
            if 'message' in item:
                if item['message'] is not None:
                    text += str(item['message']) + "\n"
                    if force_tab:
                        change_tab = True
                else:
                    text += "\n"

        utils_giswater.setWidgetText(dialog, qtextedit, text+"\n")
        if change_tab:
            qtabwidget.setCurrentIndex(1)

