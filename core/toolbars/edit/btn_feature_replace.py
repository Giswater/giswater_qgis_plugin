"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QCompleter
from qgis.PyQt.QtCore import QDate, QStringListModel

import json
from collections import OrderedDict
from datetime import datetime

from ....ui_manager import FeatureReplace, InfoWorkcatUi
from ...actions.basic.catalog import GwCatalog
from ...utils.giswater_tools import *

from ..parent_maptool import GwParentMapTool


class GwFeatureReplaceButton(GwParentMapTool):
    """ Button 44: User select one feature. Execute SQL function: 'gw_fct_feature_replace' """

    def __init__(self, icon_path, text, toolbar, action_group):
        """ Class constructor """

        super().__init__(icon_path, text, toolbar, action_group)
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
        load_settings(self.dlg_replace, self.controller)

        sql = "SELECT id FROM cat_work ORDER BY id"
        rows = self.controller.get_rows(sql)
        if rows:
            qt_tools.fillComboBox(self.dlg_replace, self.dlg_replace.workcat_id_end, rows)
            qt_tools.set_autocompleter(self.dlg_replace.workcat_id_end)

        row = self.controller.get_config('edit_workcat_end_vdefault')
        if row:
            edit_workcat_vdefault = self.dlg_replace.workcat_id_end.findText(row[0])
            self.dlg_replace.workcat_id_end.setCurrentIndex(edit_workcat_vdefault)


        row = self.controller.get_config('edit_enddate_vdefault')
        if row:
            self.enddate_aux = self.manage_dates(row[0]).date()
        else:
            work_id = qt_tools.getWidgetText(self.dlg_replace, self.dlg_replace.workcat_id_end)
            sql = (f"SELECT builtdate FROM cat_work "
                   f"WHERE id = '{work_id}'")
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
                sql = f"SELECT DISTINCT(id) FROM {self.cat_table} ORDER BY id"
                rows = self.controller.get_rows(sql)
                qt_tools.fillComboBox(self.dlg_replace, "featurecat_id", rows, allow_nulls=False)
            elif self.geom_type in 'gully':
                sql = f"SELECT DISTINCT(id) FROM cat_grate ORDER BY id"
                rows = self.controller.get_rows(sql)
                qt_tools.fillComboBox(self.dlg_replace, "featurecat_id", rows, allow_nulls=False)

        self.dlg_replace.feature_type.setText(feature_type)
        self.dlg_replace.feature_type_new.currentIndexChanged.connect(self.edit_change_elem_type_get_value)
        self.dlg_replace.btn_catalog.clicked.connect(partial(self.open_catalog))
        self.dlg_replace.workcat_id_end.currentIndexChanged.connect(self.update_date)

        # Fill 1st combo boxes-new system node type
        sql = (f"SELECT DISTINCT(id) FROM cat_feature WHERE lower(feature_type) = '{self.geom_type}' "
               f"AND active is True "
               f"ORDER BY id")
        rows = self.controller.get_rows(sql)
        qt_tools.fillComboBox(self.dlg_replace, "feature_type_new", rows)

        self.dlg_replace.btn_new_workcat.clicked.connect(partial(self.new_workcat))
        self.dlg_replace.btn_accept.clicked.connect(partial(self.get_values, self.dlg_replace))
        self.dlg_replace.btn_cancel.clicked.connect(partial(close_dialog, self.dlg_replace, self.controller))
        self.dlg_replace.rejected.connect(self.cancel_map_tool)
        # Open dialog
        open_dialog(self.dlg_replace, self.controller, maximize_button=False)


    def open_catalog(self):

        # Get feature_type
        feature_type = qt_tools.getWidgetText(self.dlg_replace, self.dlg_replace.feature_type_new)
        if feature_type is 'null':
            msg = "New feature type is null. Please, select a valid value."
            self.controller.show_info_box(msg, "Info")
            return

        sql = f"SELECT lower(feature_type) FROM cat_feature WHERE id = '{feature_type}'"
        row = self.controller.get_row(sql)

        self.catalog = GwCatalog()
        self.catalog.api_catalog(self.dlg_replace, 'featurecat_id', row[0], feature_type)


    def update_date(self):

        row = self.controller.get_config('edit_enddate_vdefault')
        if row:
            self.enddate_aux = self.manage_dates(row[0]).date()
        else:
            work_id = qt_tools.getWidgetText(self.dlg_replace, self.dlg_replace.workcat_id_end)
            sql = (f"SELECT builtdate FROM cat_work "
                   f"WHERE id = '{work_id}'")
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

        self.dlg_new_workcat = InfoWorkcatUi()
        load_settings(self.dlg_new_workcat, self.controller)
        qt_tools.setCalendarDate(self.dlg_new_workcat, self.dlg_new_workcat.builtdate, None, True)

        table_object = "cat_work"
        self.set_completer_object(table_object, self.dlg_new_workcat.cat_work_id, 'id')

        # Set signals
        self.dlg_new_workcat.btn_accept.clicked.connect(partial(self.manage_new_workcat_accept, table_object))
        self.dlg_new_workcat.btn_cancel.clicked.connect(partial(close_dialog, self.dlg_new_workcat, self.controller))

        # Open dialog
        open_dialog(self.dlg_new_workcat, self.controller, dlg_name='info_workcat')


    def manage_new_workcat_accept(self, table_object):
        """ Insert table 'cat_work'. Add cat_work """

        # Get values from dialog
        values = ""
        fields = ""
        cat_work_id = qt_tools.getWidgetText(self.dlg_new_workcat, self.dlg_new_workcat.cat_work_id)
        if cat_work_id != "null":
            fields += 'id, '
            values += ("'" + str(cat_work_id) + "', ")
        descript = qt_tools.getWidgetText(self.dlg_new_workcat, "descript")
        if descript != "null":
            fields += 'descript, '
            values += ("'" + str(descript) + "', ")
        link = qt_tools.getWidgetText(self.dlg_new_workcat, "link")
        if link != "null":
            fields += 'link, '
            values += ("'" + str(link) + "', ")
        workid_key_1 = qt_tools.getWidgetText(self.dlg_new_workcat, "workid_key_1")
        if workid_key_1 != "null":
            fields += 'workid_key1, '
            values += ("'" + str(workid_key_1) + "', ")
        workid_key_2 = qt_tools.getWidgetText(self.dlg_new_workcat, "workid_key_2")
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
                sql = (f"SELECT DISTINCT(id) "
                       f"FROM {table_object} "
                       f"WHERE id = '{cat_work_id}'")
                row = self.controller.get_row(sql, log_info=False)
                if row is None:
                    sql = f"INSERT INTO cat_work ({fields}) VALUES ({values})"
                    self.controller.execute_sql(sql, log_sql=True)

                    sql = "SELECT id FROM cat_work ORDER BY id"
                    rows = self.controller.get_rows(sql)
                    if rows:
                        qt_tools.fillComboBox(self.dlg_replace, self.dlg_replace.workcat_id_end, rows)
                        current_index = self.dlg_replace.workcat_id_end.findText(str(cat_work_id))
                        self.dlg_replace.workcat_id_end.setCurrentIndex(current_index)

                    close_dialog(self.dlg_new_workcat, self.controller)
                else:
                    msg = "This Workcat is already exist"
                    self.controller.show_info_box(msg, "Warning")


    def set_completer_object(self, tablename, widget, field_id):
        """ Set autocomplete of widget @table_object + "_id"
            getting id's from selected @table_object
        """

        if not widget:
            return

        sql = (f"SELECT DISTINCT({field_id}) "
               f"FROM {tablename} "
               f"ORDER BY {field_id}")
        rows = self.controller.get_rows(sql)
        if rows is None:
            return

        for i in range(0, len(rows)):
            aux = rows[i]
            rows[i] = str(aux[0])

        # Set completer and model: add autocomplete in the widget
        self.completer = QCompleter()
        self.completer.setCaseSensitivity(Qt.CaseInsensitive)
        widget.setCompleter(self.completer)
        model = QStringListModel()
        model.setStringList(rows)
        self.completer.setModel(model)


    def get_values(self, dialog):

        self.workcat_id_end_aux = qt_tools.getWidgetText(dialog, dialog.workcat_id_end)
        self.enddate_aux = dialog.enddate.date().toString('yyyy-MM-dd')

        # Check null values
        if self.workcat_id_end_aux in (None, 'null'):
            message = "Mandatory field is missing. Please, set a value"
            self.controller.show_warning(message, parameter='Workcat_id')
            return

        feature_type_new = qt_tools.getWidgetText(dialog, dialog.feature_type_new)
        featurecat_id = qt_tools.getWidgetText(dialog, dialog.featurecat_id)

        # Ask question before executing
        message = "Are you sure you want to replace selected feature with a new one?"
        answer = self.controller.ask_question(message, "Replace feature")
        if answer:

            # Get function input parameters
            feature = f'"type":"{self.geom_type}"'
            extras = f'"old_feature_id":"{self.feature_id}"'
            extras += f', "workcat_id_end":"{self.workcat_id_end_aux}"'
            extras += f', "enddate":"{self.enddate_aux}"'
            extras += f', "keep_elements":"{qt_tools.isChecked(dialog, "keep_elements")}"'
            body = create_body(feature=feature, extras=extras)

            # Execute SQL function and show result to the user
            function_name = "gw_fct_feature_replace"
            sql = f"SELECT {function_name}({body})::text"
            row = self.controller.get_row(sql, log_sql=True)
            if not row:
                message = "Error replacing feature"
                self.controller.show_warning(message)
                self.deactivate()
                self.set_action_pan()
                close_dialog(dialog, self.controller, set_action_pan=False)
                return

            complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
            message = "Feature replaced successfully"
            self.controller.show_info(message)

            # Force user to manage with state = 1 features
            current_user = self.controller.get_project_user()
            sql = (f"DELETE FROM selector_state "
                   f"WHERE state_id = 1 AND cur_user = '{current_user}';"
                   f"\nINSERT INTO selector_state (state_id, cur_user) "
                   f"VALUES (1, '{current_user}');")
            self.controller.execute_sql(sql)

            if feature_type_new != "null" and featurecat_id != "null":
                # Get id of new generated feature
                sql = (f"SELECT {self.geom_type}_id "
                       f"FROM {self.geom_view} "
                       f"ORDER BY {self.geom_type}_id::int4 DESC LIMIT 1")
                row = self.controller.get_row(sql)
                if row:
                    if self.geom_type == 'connec':
                        field_cat_id = "connecat_id"
                    else:
                        field_cat_id = self.geom_type + "cat_id"
                    if self.geom_type != 'gully':
                        sql = (f"UPDATE {self.geom_view} "
                               f"SET {field_cat_id} = '{featurecat_id}' "
                               f"WHERE {self.geom_type}_id = '{row[0]}'")
                    self.controller.execute_sql(sql, log_sql=True)
                    if self.project_type == 'ud':
                        sql = (f"UPDATE {self.geom_view} "
                               f"SET {self.geom_type}_type = '{feature_type_new}' "
                               f"WHERE {self.geom_type}_id = '{row[0]}'")
                        self.controller.execute_sql(sql, log_sql=True)

                message = "Values has been updated"
                self.controller.show_info(message)

            # Fill tab 'Info log'
            if complet_result and complet_result[0]['status'] == "Accepted":
                populate_info_text(self.dlg_replace, complet_result[0]['body']['data'])

            # Refresh canvas
            self.refresh_map_canvas()
            self.controller.set_layer_index('v_edit_arc')
            self.controller.set_layer_index('v_edit_connec')
            self.controller.set_layer_index('v_edit_gully')
            self.controller.set_layer_index('v_edit_node')
            refresh_legend(self.controller)

            # Deactivate map tool
            self.deactivate()
            self.set_action_pan()

            # Disable ok button at the end of process
            self.dlg_replace.btn_accept.setEnabled(False)



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

        # Set active and current layer
        self.layer_node = self.controller.get_layer_by_tablename("v_edit_node")
        self.iface.setActiveLayer(self.layer_node)
        self.current_layer = self.layer_node

        # Check button
        self.action.setChecked(True)

        # Set main snapping layers
        self.snapper_manager.set_snapping_layers()

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Disable snapping
        self.snapper_manager.enable_snapping()

        # Set snapping to 'node', 'connec' and 'gully'
        self.snapper_manager.snap_to_node()
        self.snapper_manager.snap_to_connec_gully()

        self.snapper_manager.set_snapping_mode()

        # Change cursor
        self.canvas.setCursor(self.cursor)

        self.project_type = self.controller.get_project_type()

        # Show help message when action is activated
        if self.show_help:
            message = "Select the feature by clicking on it and it will be replaced"
            self.controller.show_info(message)


    def deactivate(self):
        super().deactivate()


    def edit_change_elem_type_get_value(self, index):
        """ Just select item to 'real' combo 'featurecat_id' (that is hidden) """

        if index == -1:
            return

        # Get selected value from 2nd combobox
        feature_type_new = qt_tools.getWidgetText(self.dlg_replace, "feature_type_new")

        # When value is selected, enabled 3rd combo box
        if feature_type_new == 'null':
            return

        if self.project_type == 'ws':
            # Fill 3rd combo_box-catalog_id
            qt_tools.setWidgetEnabled(self.dlg_replace, self.dlg_replace.featurecat_id, True)
            sql = (f"SELECT DISTINCT(id) "
                   f"FROM {self.cat_table} "
                   f"WHERE {self.feature_type_ws} = '{feature_type_new}'")
            rows = self.controller.get_rows(sql)
            qt_tools.fillComboBox(self.dlg_replace, self.dlg_replace.featurecat_id, rows)

