"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from datetime import datetime
from functools import partial

from qgis.PyQt.QtCore import QDate, Qt

from ..maptool import GwMaptool
from ...ui.ui_manager import GwFeatureReplaceUi, GwInfoWorkcatUi
from ...shared.catalog import GwCatalog
from ...utils import tools_gw
from ....lib import tools_qt, tools_log, tools_qgis, tools_db
from .... import global_vars


class GwFeatureReplaceButton(GwMaptool):
    """ Button 44: Replace feature
    User select one feature. Execute SQL function: 'gw_fct_setfeaturereplace' """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.current_date = QDate.currentDate().toString('yyyy-MM-dd')
        self.project_type = None
        self.feature_type = None
        self.geom_view = None
        self.cat_table = None
        self.feature_type_ws = None
        self.feature_type_ud = None


    # region QgsMapTools inherited
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
        result = self.snapper_manager.snap_to_project_config_layers(event_point)
        if result.isValid():
            layer = self.snapper_manager.get_snapped_layer(result)
            tablename = tools_qgis.get_layer_source_table_name(layer)
            if tablename and 'v_edit' in tablename:
                self.snapper_manager.add_marker(result, self.vertex_marker)


    def canvasReleaseEvent(self, event):

        if event.button() == Qt.RightButton:
            self.cancel_map_tool()
            return

        event_point = self.snapper_manager.get_event_point(event)

        # Snapping
        result = self.snapper_manager.snap_to_project_config_layers(event_point)
        if not result.isValid():
            return

        # Get snapped feature
        snapped_feat = self.snapper_manager.get_snapped_feature(result)
        if snapped_feat:
            layer = self.snapper_manager.get_snapped_layer(result)
            tablename = tools_qgis.get_layer_source_table_name(layer)

            if tablename and 'v_edit' in tablename:
                if tablename == 'v_edit_node':
                    self.feature_type = 'node'
                elif tablename == 'v_edit_connec':
                    self.feature_type = 'connec'
                elif tablename == 'v_edit_gully':
                    self.feature_type = 'gully'

                self.geom_view = tablename
                self.cat_table = 'cat_' + self.feature_type
                self.feature_type_ws = self.feature_type + 'type_id'
                self.feature_type_ud = self.feature_type + '_type'
                self.feature_id = snapped_feat.attribute(self.feature_type + '_id')
                self._init_replace_feature_form(snapped_feat)


    def activate(self):

        # Set active and current layer
        self.layer_node = tools_qgis.get_layer_by_tablename("v_edit_node")
        self.iface.setActiveLayer(self.layer_node)
        self.current_layer = self.layer_node

        # Check button
        self.action.setChecked(True)

        # Store user snapping configuration
        self.previous_snapping = self.snapper_manager.get_snapping_options()

        # Disable snapping
        self.snapper_manager.set_snapping_status()

        # Set snapping to 'node', 'connec' and 'gully'
        self.snapper_manager.set_snapping_layers()
        self.snapper_manager.config_snap_to_node(False)
        self.snapper_manager.config_snap_to_connec(False)
        self.snapper_manager.config_snap_to_gully(False)
        self.snapper_manager.set_snap_mode()

        # Change cursor
        self.canvas.setCursor(self.cursor)

        self.project_type = tools_gw.get_project_type()

        # Show help message when action is activated
        if self.show_help:
            message = "Click on node to replace it with a new one"
            tools_qgis.show_info(message)


    def deactivate(self):
        super().deactivate()

    # endregion

    # region private functions

    def _manage_dates(self, date_value):
        """ Manage dates """

        date_result = None
        try:
            date_result = str(date_value)
            date_result = date_result.replace("-", "/")
            date_result = datetime.strptime(date_result, '%Y/%m/%d')
        except Exception as e:
            tools_log.log_warning(str(e))
        finally:
            return date_result


    def _init_replace_feature_form(self, feature):

        # Create the dialog and signals
        self.dlg_replace = GwFeatureReplaceUi()
        tools_gw.load_settings(self.dlg_replace)
        tools_gw.add_icon(self.dlg_replace.btn_new_workcat, "193")
        tools_gw.add_icon(self.dlg_replace.btn_catalog, "195")

        sql = "SELECT id FROM cat_work ORDER BY id"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_box(self.dlg_replace, self.dlg_replace.workcat_id_end, rows)
            tools_qt.set_autocompleter(self.dlg_replace.workcat_id_end)

        row = tools_gw.get_config_value('edit_workcat_vdefault')
        if row:
            edit_workcat_vdefault = self.dlg_replace.workcat_id_end.findText(row[0])
            self.dlg_replace.workcat_id_end.setCurrentIndex(edit_workcat_vdefault)

        row = tools_gw.get_config_value('edit_enddate_vdefault')
        if row:
            self.enddate_aux = self._manage_dates(row[0]).date()
        else:
            work_id = tools_qt.get_text(self.dlg_replace, self.dlg_replace.workcat_id_end)
            sql = (f"SELECT builtdate FROM cat_work "
                   f"WHERE id = '{work_id}'")
            row = tools_db.get_row(sql)
            current_date = self._manage_dates(self.current_date)
            if row and row[0]:
                builtdate = self._manage_dates(row[0])
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
            feature_type_new = tools_qt.get_text(self.dlg_replace, "feature_type_new")
            if feature_type_new:
                if self.feature_type in ('node', 'connec'):
                    sql = f"SELECT DISTINCT(id) FROM {self.cat_table} " \
                          f"WHERE {self.feature_type}_type = '{feature_type_new}' or {self.feature_type}_type IS NULL ORDER BY id"
                    rows = tools_db.get_rows(sql)
                    tools_qt.fill_combo_box(self.dlg_replace, "featurecat_id", rows, allow_nulls=False)
                elif self.feature_type in 'gully':
                    sql = f"SELECT DISTINCT(id) FROM cat_grate " \
                          f"WHERE gully_type = '{feature_type_new}' OR gully_type IS NULL ORDER BY id"
                    rows = tools_db.get_rows(sql)
                    tools_qt.fill_combo_box(self.dlg_replace, "featurecat_id", rows, allow_nulls=False)

        self.dlg_replace.feature_type.setText(feature_type)
        self.dlg_replace.feature_type_new.currentIndexChanged.connect(self._edit_change_elem_type_get_value)
        self.dlg_replace.btn_catalog.clicked.connect(partial(self._open_catalog, self.feature_type))
        self.dlg_replace.workcat_id_end.currentIndexChanged.connect(self._update_date)

        # Fill 1st combo boxes-new system node type
        sql = (f"SELECT DISTINCT(id) FROM cat_feature WHERE lower(feature_type) = '{self.feature_type}' "
               f"AND active is True "
               f"ORDER BY id")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_box(self.dlg_replace, "feature_type_new", rows)

        self.dlg_replace.btn_new_workcat.clicked.connect(partial(self._new_workcat))
        self.dlg_replace.btn_accept.clicked.connect(partial(self._replace_feature, self.dlg_replace))
        self.dlg_replace.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_replace))

        # Open dialog
        tools_gw.open_dialog(self.dlg_replace, maximize_button=False)


    def _open_catalog(self, feature_type):

        # Get feature_type
        child_type = tools_qt.get_text(self.dlg_replace, self.dlg_replace.feature_type_new)
        if child_type == 'null':
            msg = "New feature type is null. Please, select a valid value."
            tools_qt.show_info_box(msg, "Info")
            return

        self.catalog = GwCatalog()
        self.catalog.open_catalog(self.dlg_replace, 'featurecat_id', feature_type, child_type)


    def _update_date(self):

        row = tools_gw.get_config_value('edit_enddate_vdefault')
        if row:
            self.enddate_aux = self._manage_dates(row[0]).date()
        else:
            work_id = tools_qt.get_text(self.dlg_replace, self.dlg_replace.workcat_id_end)
            sql = (f"SELECT builtdate FROM cat_work "
                   f"WHERE id = '{work_id}'")
            row = tools_db.get_row(sql)
            current_date = self._manage_dates(self.current_date)
            if row and row[0]:
                builtdate = self._manage_dates(row[0])
                if builtdate != 'null' and builtdate:
                    self.enddate_aux = builtdate.date()
                else:
                    self.enddate_aux = current_date.date()
            else:
                self.enddate_aux = current_date.date()

        self.dlg_replace.enddate.setDate(self.enddate_aux)


    def _new_workcat(self):

        self.dlg_new_workcat = GwInfoWorkcatUi()

        tools_gw.load_settings(self.dlg_new_workcat)
        tools_qt.set_calendar(self.dlg_new_workcat, self.dlg_new_workcat.builtdate, None, True)
        table_object = "cat_work"
        tools_gw.set_completer_object(self.dlg_new_workcat, "cat_work")

        # Set signals
        self.dlg_new_workcat.btn_accept.clicked.connect(partial(self._manage_new_workcat_accept, table_object))
        self.dlg_new_workcat.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_new_workcat))

        # Open dialog
        tools_gw.open_dialog(self.dlg_new_workcat, dlg_name='info_workcat')


    def _manage_new_workcat_accept(self, table_object):
        """ Insert table 'cat_work'. Add cat_work """

        # Get values from dialog
        values = ""
        fields = ""
        cat_work_id = tools_qt.get_text(self.dlg_new_workcat, self.dlg_new_workcat.cat_work_id)
        if cat_work_id != "null":
            fields += 'id, '
            values += ("'" + str(cat_work_id) + "', ")
        descript = tools_qt.get_text(self.dlg_new_workcat, "descript")
        if descript != "null":
            fields += 'descript, '
            values += ("'" + str(descript) + "', ")
        link = tools_qt.get_text(self.dlg_new_workcat, "link")
        if link != "null":
            fields += 'link, '
            values += ("'" + str(link) + "', ")
        workid_key_1 = tools_qt.get_text(self.dlg_new_workcat, "workid_key_1")
        if workid_key_1 != "null":
            fields += 'workid_key1, '
            values += ("'" + str(workid_key_1) + "', ")
        workid_key_2 = tools_qt.get_text(self.dlg_new_workcat, "workid_key_2")
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
                tools_qt.show_info_box(msg, "Warning")
            else:
                # Check if this element already exists
                sql = (f"SELECT DISTINCT(id) "
                       f"FROM {table_object} "
                       f"WHERE id = '{cat_work_id}'")
                row = tools_db.get_row(sql, log_info=False)
                if row is None:
                    sql = f"INSERT INTO cat_work ({fields}) VALUES ({values})"
                    tools_db.execute_sql(sql)

                    sql = "SELECT id FROM cat_work ORDER BY id"
                    rows = tools_db.get_rows(sql)
                    if rows:
                        tools_qt.fill_combo_box(self.dlg_replace, self.dlg_replace.workcat_id_end, rows)
                        current_index = self.dlg_replace.workcat_id_end.findText(str(cat_work_id))
                        self.dlg_replace.workcat_id_end.setCurrentIndex(current_index)

                    tools_gw.close_dialog(self.dlg_new_workcat)
                else:
                    msg = "This Workcat is already exist"
                    tools_qt.show_info_box(msg, "Warning")


    def _replace_feature(self, dialog):

        self.workcat_id_end_aux = tools_qt.get_text(dialog, dialog.workcat_id_end)
        self.enddate_aux = dialog.enddate.date().toString('yyyy-MM-dd')

        feature_type_new = tools_qt.get_text(dialog, dialog.feature_type_new)
        featurecat_id = tools_qt.get_text(dialog, dialog.featurecat_id)

        # Check null values
        if feature_type_new in (None, 'null') or featurecat_id in (None, 'null'):
            message = "Mandatory fields are missing. Please, set values"
            tools_qgis.show_warning(message, parameter='Workcat id, New feature type and Catalog id')
            return

        # Ask question before executing
        message = "Are you sure you want to replace selected feature with a new one?"
        answer = tools_qt.show_question(message, "Replace feature")
        if answer:

            # Get function input parameters
            feature = f'"type":"{self.feature_type}"'
            extras = f'"old_feature_id":"{self.feature_id}"'
            extras += f', "feature_type_new":"{feature_type_new}"'
            extras += f', "featurecat_id":"{featurecat_id}"'
            extras += f', "workcat_id_end":"{self.workcat_id_end_aux}"'
            extras += f', "enddate":"{self.enddate_aux}"'
            extras += f', "keep_elements":"{tools_qt.is_checked(dialog, "keep_elements")}"'
            body = tools_gw.create_body(feature=feature, extras=extras)

            # Execute SQL function and show result to the user
            complet_result = tools_gw.execute_procedure('gw_fct_setfeaturereplace', body, log_sql=True)
            if not complet_result:
                message = "Error replacing feature"
                tools_qgis.show_warning(message)
                self.deactivate()
                self.set_action_pan()
                tools_gw.close_dialog(dialog)
                return

            feature_id = complet_result['body']['data']['featureId']
            message = "Feature replaced successfully"
            tools_qgis.show_info(message)

            # Fill tab 'Info log'
            if complet_result and complet_result['status'] == "Accepted":
                tools_gw.fill_tab_log(self.dlg_replace, complet_result['body']['data'])

            # Refresh canvas
            self.refresh_map_canvas()
            tools_qgis.set_layer_index('v_edit_arc')
            tools_qgis.set_layer_index('v_edit_connec')
            tools_qgis.set_layer_index('v_edit_gully')
            tools_qgis.set_layer_index('v_edit_node')

            # Deactivate map tool
            self.deactivate()
            self.set_action_pan()

            # Disable ok button at the end of process
            self.dlg_replace.btn_accept.setEnabled(False)


    def _edit_change_elem_type_get_value(self, index):
        """ Just select item to 'real' combo 'featurecat_id' (that is hidden) """

        if index == -1:
            return

        # Get selected value from 2nd combobox
        feature_type_new = tools_qt.get_text(self.dlg_replace, "feature_type_new")

        # When value is selected, enabled 3rd combo box
        if feature_type_new == 'null':
            return

        if self.project_type == 'ws':
            # Fill 3rd combo_box-catalog_id
            tools_qt.set_widget_enabled(self.dlg_replace, self.dlg_replace.featurecat_id, True)
            sql = (f"SELECT DISTINCT(id) "
                   f"FROM {self.cat_table} "
                   f"WHERE {self.feature_type_ws} = '{feature_type_new}'")
            rows = tools_db.get_rows(sql)
            tools_qt.fill_combo_box(self.dlg_replace, self.dlg_replace.featurecat_id, rows)
        elif self.project_type == 'ud':
            self.dlg_replace.featurecat_id.clear()
            if self.feature_type in ('node', 'connec'):
                sql = f"SELECT DISTINCT(id) FROM {self.cat_table} " \
                      f"WHERE {self.feature_type}_type = '{feature_type_new}' or {self.feature_type}_type IS NULL ORDER BY id"
                rows = tools_db.get_rows(sql)
                tools_qt.fill_combo_box(self.dlg_replace, "featurecat_id", rows, allow_nulls=False)
            elif self.feature_type in 'gully':
                sql = f"SELECT DISTINCT(id) FROM cat_grate " \
                      f"WHERE gully_type = '{feature_type_new}' OR gully_type IS NULL ORDER BY id"
                rows = tools_db.get_rows(sql)
                tools_qt.fill_combo_box(self.dlg_replace, "featurecat_id", rows, allow_nulls=False)

    # endregion