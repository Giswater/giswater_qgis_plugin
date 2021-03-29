"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtCore import QPoint, Qt
from qgis.PyQt.QtWidgets import QAction, QApplication, QMenu
from qgis.PyQt.QtGui import QCursor
from qgis.core import QgsApplication

from ..dialog import GwAction
from ...load_project_check import GwLoadProjectCheck
from ...threads.project_layers_config import GwProjectLayersConfig
from ...utils import tools_gw
from ....lib import tools_qgis, tools_log, tools_db
from .... import global_vars


class GwAddChildLayerButton(GwAction):
    """ Button 306: Add child layer """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        tools_qgis.get_project_variables()
        self.qgis_project_infotype = global_vars.project_vars['info_type']
        self.qgis_project_add_schema = global_vars.project_vars['add_schema']
        self.available_layers = None
        self._config_layers()


    def clicked_event(self):

        self._add_child_layer()


    # region private functions

    def _add_child_layer(self):

        # Create main menu and get cursor click position
        main_menu = QMenu()
        cursor = QCursor()
        x = cursor.pos().x()
        y = cursor.pos().y()
        click_point = QPoint(x + 5, y + 5)
        schema_name = self.schema_name.replace('"', '')
        # Get parent layers
        sql = ("SELECT distinct ( CASE parent_layer WHEN 'v_edit_node' THEN 'Node' "
               "WHEN 'v_edit_arc' THEN 'Arc' WHEN 'v_edit_connec' THEN 'Connec' "
               "WHEN 'v_edit_gully' THEN 'Gully' END ), parent_layer FROM cat_feature "
               "ORDER BY parent_layer")
        parent_layers = tools_db.get_rows(sql)

        for parent_layer in parent_layers:

            # Get child layers
            sql = (f"SELECT DISTINCT(child_layer), lower(feature_type), cat_feature.id as alias, style as style_id, "
                   f" group_layer "
                   f" FROM cat_feature "
                   f" LEFT JOIN config_table ON config_table.id = child_layer "
                   f"WHERE parent_layer = '{parent_layer[1]}' "
                   f"AND child_layer IN ("
                   f"   SELECT table_name FROM information_schema.tables"
                   f"   WHERE table_schema = '{schema_name}')"
                   f" ORDER BY child_layer")

            child_layers = tools_db.get_rows(sql)
            if not child_layers: continue

            # Create sub menu
            sub_menu = main_menu.addMenu(str(parent_layer[0]))
            child_layers.insert(0, ['Load all', 'Load all', 'Load all', 'Load all', 'Load all'])
            for child_layer in child_layers:
                # Create actions
                action = QAction(str(child_layer[2]), sub_menu, checkable=True)

                # Get load layers and create child layers menu (actions)
                layers_list = []
                layers = self.iface.mapCanvas().layers()
                for layer in layers:
                    layers_list.append(str(layer.name()))
                if str(child_layer[0]) in layers_list:
                    action.setChecked(True)

                sub_menu.addAction(action)
                if child_layer[0] == 'Load all':
                    action.triggered.connect(partial(self._check_action_ischecked, None, "the_geom", "id", child_layers,
                                                     "GW Layers", "-1"))
                else:
                    layer_name = child_layer[0]
                    the_geom = "the_geom"
                    geom_field = child_layer[1] + "_id"
                    style_id = child_layer[3]
                    group = child_layer[4] if child_layer[4] is not None else 'GW Layers'
                    action.triggered.connect(partial(self._check_action_ischecked, layer_name, the_geom, geom_field,
                                                     None, group, style_id))

        main_menu.exec_(click_point)


    def _check_action_ischecked(self, tablename, the_geom, field_id, child_layers, group, style_id, is_checked):
        """ Control if user check or uncheck action menu, then add or remove layer from toc
        :param tablename: Postgres table name (String)
        :param the_geom: Geometry field of the table (String)
        :param field_id: Field id of the table (String)
        :param child_layers: List of layers (StringList)
        :param group: Name of the group that will be created in the toc (String)
        :param style_id: Id of the style we want to load (integer or String)
        :param is_checked: This parameter is sent by the action itself with the trigger (Bool)
        """

        if is_checked:
            layer = tools_qgis.get_layer_by_tablename(tablename)
            if layer is None:
                tools_gw.add_layer_database(tablename, the_geom, field_id, child_layers, group, style_id)
        else:
            layer = tools_qgis.get_layer_by_tablename(tablename)
            if layer is not None:
                tools_qgis.remove_layer_from_toc(tablename, group)


    def _config_layers(self):

        status = self._manage_layers()
        if not status:
            return False

        # Set config layer fields when user add new layer into the TOC
        # QgsProject.instance().legendLayersAdded.connect(self.get_new_layers_name)

        # Put add layers button into toc
        # self.add_layers_button()

        # Set project layers with gw_fct_getinfofromid: This process takes time for user
        # Set background task 'ConfigLayerFields'
        schema_name = self.schema_name.replace('"', '')
        sql = (f"SELECT DISTINCT(parent_layer) FROM cat_feature "
               f"UNION "
               f"SELECT DISTINCT(child_layer) FROM cat_feature "
               f"WHERE child_layer IN ("
               f"     SELECT table_name FROM information_schema.tables"
               f"     WHERE table_schema = '{schema_name}')")
        rows = tools_db.get_rows(sql)
        description = f"ConfigLayerFields"
        params = {"project_type": self.project_type, "schema_name": self.schema_name,
                  "qgis_project_infotype": self.qgis_project_infotype, "db_layers": rows}
        task_get_layers = GwProjectLayersConfig(description, params)
        QgsApplication.taskManager().addTask(task_get_layers)
        QgsApplication.taskManager().triggerTask(task_get_layers)

        return True


    def _manage_layers(self):
        """ Get references to project main layers """

        # Check if we have any layer loaded
        layers = tools_qgis.get_project_layers()
        if len(layers) == 0:
            return False

        if self.project_type in ('ws', 'ud'):
            QApplication.setOverrideCursor(Qt.ArrowCursor)
            self.check_project = GwLoadProjectCheck()

            # check project
            status, result = self.check_project.fill_check_project_table(layers, "true")
            try:
                if 'actions' in result['body']:
                    if 'useGuideMap' in result['body']['actions']:
                        guided_map = result['body']['actions']['useGuideMap']
                        if guided_map:
                            tools_log.log_info("manage_guided_map")
                            self._manage_guided_map()
            except Exception as e:
                tools_log.log_info(str(e))
            finally:
                QApplication.restoreOverrideCursor()
                return status

        return True


    def _manage_guided_map(self):
        """ Guide map works using ext_municipality """

        self.layer_muni = tools_qgis.get_layer_by_tablename('ext_municipality')
        if self.layer_muni is None:
            return

        self.iface.setActiveLayer(self.layer_muni)
        tools_qgis.set_layer_visible(self.layer_muni)
        self.layer_muni.selectAll()
        self.iface.actionZoomToSelected().trigger()
        self.layer_muni.removeSelection()
        self.iface.actionSelect().trigger()
        self.iface.mapCanvas().selectionChanged.connect(self._selection_changed)
        cursor = tools_gw.get_cursor_multiple_selection()
        if cursor:
            self.iface.mapCanvas().setCursor(cursor)


    def _selection_changed(self):
        """ Get selected muni_id and execute function setselectors """

        muni_id = None
        features = self.layer_muni.getSelectedFeatures()
        for feature in features:
            muni_id = feature["muni_id"]
            tools_log.log_info(f"Selected muni_id: {muni_id}")
            break

        self.iface.mapCanvas().selectionChanged.disconnect()
        self.iface.actionZoomToSelected().trigger()
        self.layer_muni.removeSelection()

        if muni_id is None:
            return

        extras = f'"selectorType":"explfrommuni", "id":{muni_id}, "value":true, "isAlone":true, '
        extras += f'"addSchema":"{self.qgis_project_add_schema}"'
        body = tools_gw.create_body(extras=extras)
        complet_result = tools_gw.execute_procedure('gw_fct_setselectors', body)
        if complet_result:
            self.iface.mapCanvas().refreshAllLayers()
            self.layer_muni.triggerRepaint()
            self.iface.actionPan().trigger()
            self.iface.actionZoomIn().trigger()
            tools_gw.set_style_mapzones()

    # endregion