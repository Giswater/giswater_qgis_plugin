"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsEditorWidgetSetup, QgsFieldConstraints, QgsProject, QgsApplication
from qgis.PyQt.QtCore import QPoint, Qt
from qgis.PyQt.QtWidgets import QAction, QApplication, QDockWidget, QMenu, QToolBar, QToolButton
from qgis.PyQt.QtGui import QCursor, QIcon, QPixmap

import os
from functools import partial

from .actions.add_layer import AddLayer
from .actions.check_project_result import CheckProjectResult
from .actions.task_config_layer_fields import TaskConfigLayerFields


class LoadProject:

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to manage layers. Refactor code from giswater.py """

        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir
        self.available_layers = None
        self.hide_form = None
        self.add_layer = None
        self.project_type = None
        self.schema_name = None
        self.qgis_project_infotype = None


    def set_params(self, project_type, schema_name, qgis_project_infotype, qgis_project_add_schema):

        self.project_type = project_type
        self.schema_name = schema_name
        self.qgis_project_infotype = qgis_project_infotype
        self.qgis_project_add_schema = qgis_project_add_schema
        self.add_layer = AddLayer(self.iface, self.settings, self.controller, self.plugin_dir)


    def config_layers(self):

        status = self.manage_layers()
        if not status:
            return False

        # Set config layer fields when user add new layer into the TOC
        # QgsProject.instance().legendLayersAdded.connect(self.get_new_layers_name)

        # Put add layers button into toc
        self.add_layers_button()

        # Set project layers with gw_fct_getinfofromid: This process takes time for user
        if self.hide_form is False:
            # Set background task 'ConfigLayerFields'
            description = f"ConfigLayerFields"
            self.task_get_layers = TaskConfigLayerFields(description, self.controller)
            self.task_get_layers.set_params(self.project_type, self.schema_name, self.qgis_project_infotype)
            QgsApplication.taskManager().addTask(self.task_get_layers)
            QgsApplication.taskManager().triggerTask(self.task_get_layers)
        else:
            self.controller.log_info(f"hideForm is True")

        return True


    def manage_layers(self):
        """ Get references to project main layers """

        # Check if we have any layer loaded
        layers = self.controller.get_layers()
        if len(layers) == 0:
            return False

        if self.project_type in ('ws', 'ud'):
            QApplication.setOverrideCursor(Qt.ArrowCursor)
            self.check_project_result = CheckProjectResult(self.iface, self.settings, self.controller, self.plugin_dir)
            self.check_project_result.set_controller(self.controller)

            # check project
            status, result = self.check_project_result.populate_audit_check_project(layers, "true")
            self.hide_form = False
            try:
                if 'actions' in result['body']:
                    if 'useGuideMap' in result['body']['actions']:
                        guided_map = result['body']['actions']['useGuideMap']
                        self.hide_form = result['body']['actions']['hideForm']
                        if guided_map:
                            self.controller.log_info("manage_guided_map")
                            self.manage_guided_map()
            except Exception as e:
                self.controller.log_info(str(e))
            finally:
                QApplication.restoreOverrideCursor()
                return status

        return True


    def get_new_layers_name(self, layers_list):

        layers_name = []
        for layer in layers_list:
            layer_source = self.controller.get_layer_source(layer)
            # Collect only the layers of the work scheme
            if 'schema' in layer_source:
                schema = layer_source['schema']
                if schema and schema.replace('"', '') == self.schema_name:
                    layers_name.append(layer.name())

        self.set_layer_config(layers_name)


    def set_layer_config(self, layers):
        """ Set layer fields configured according to client configuration.
            At the moment manage:
                Column names as alias, combos as ValueMap, typeahead as textedit"""

        self.controller.log_info("Start set_layer_config")

        msg_failed = ""
        msg_key = ""
        for layer_name in layers:
            layer = self.controller.get_layer_by_tablename(layer_name)
            if not layer:
                continue

            feature = '"tableName":"' + str(layer_name) + '", "id":"", "isLayer":true'
            extras = f'"infoType":"{self.qgis_project_infotype}"'
            body = self.create_body(feature=feature, extras=extras)
            complet_result = self.controller.get_json('gw_fct_getinfofromid', body)
            if not complet_result:
                continue

            for field in complet_result['body']['data']['fields']:
                valuemap_values = {}

                # Get column index
                fieldIndex = layer.fields().indexFromName(field['columnname'])

                # Hide selected fields according table config_api_form_fields.hidden
                if 'hidden' in field:
                    self.set_column_visibility(layer, field['columnname'], field['hidden'])

                # Set alias column
                if field['label']:
                    layer.setFieldAlias(fieldIndex, field['label'])

                if 'widgetcontrols' in field:
                    # Set multiline fields according table config_api_form_fields.widgetcontrols['setQgisMultiline']
                    if field['widgetcontrols'] is not None and 'setQgisMultiline' in field['widgetcontrols']:
                        self.set_column_multiline(layer, field, fieldIndex)

                    # Set field constraints
                    if field['widgetcontrols'] and 'setQgisConstraints' in field['widgetcontrols']:
                        if field['widgetcontrols']['setQgisConstraints'] is True:
                            layer.setFieldConstraint(fieldIndex, QgsFieldConstraints.ConstraintNotNull,
                                QgsFieldConstraints.ConstraintStrengthSoft)
                            layer.setFieldConstraint(fieldIndex, QgsFieldConstraints.ConstraintUnique,
                                QgsFieldConstraints.ConstraintStrengthHard)

                if 'ismandatory' in field and not field['ismandatory']:
                    layer.setFieldConstraint(fieldIndex, QgsFieldConstraints.ConstraintNotNull,
                        QgsFieldConstraints.ConstraintStrengthSoft)

                # Manage editability
                self.set_read_only(layer, field, fieldIndex)

                # delete old values on ValueMap
                editor_widget_setup = QgsEditorWidgetSetup('ValueMap', {'map': valuemap_values})
                layer.setEditorWidgetSetup(fieldIndex, editor_widget_setup)

                # Manage new values in ValueMap
                if field['widgettype'] == 'combo':
                    if 'comboIds' in field:
                        # Set values
                        for i in range(0, len(field['comboIds'])):
                            valuemap_values[field['comboNames'][i]] = field['comboIds'][i]
                    # Set values into valueMap
                    editor_widget_setup = QgsEditorWidgetSetup('ValueMap', {'map': valuemap_values})
                    layer.setEditorWidgetSetup(fieldIndex, editor_widget_setup)

        if msg_failed != "":
            self.controller.show_exceptions_msg("Execute failed.", msg_failed)

        if msg_key != "":
            self.controller.show_exceptions_msg("Key on returned json from ddbb is missed.", msg_key)

        self.controller.log_info("Finish set_layer_config")


    def set_form_suppress(self, layers_list):
        """ Set form suppress on "Hide form on add feature (global settings) """

        for layer_name in layers_list:
            layer = self.controller.get_layer_by_tablename(layer_name)
            if layer is None: continue
            config = layer.editFormConfig()
            config.setSuppress(0)
            layer.setEditFormConfig(config)


    def set_read_only(self, layer, field, field_index):
        """ Set field readOnly according to client configuration into config_api_form_fields (field 'iseditable') """

        # Get layer config
        config = layer.editFormConfig()
        try:
            # Set field editability
            config.setReadOnly(field_index, not field['iseditable'])
        except KeyError:
            pass
        finally:
            # Set layer config
            layer.setEditFormConfig(config)


    def set_column_visibility(self, layer, col_name, hidden):
        """ Hide selected fields according table config_api_form_fields.hidden """

        config = layer.attributeTableConfig()
        columns = config.columns()
        for column in columns:
            if column.name == str(col_name):
                column.hidden = hidden
                break
        config.setColumns(columns)
        layer.setAttributeTableConfig(config)


    def set_column_multiline(self, layer, field, fieldIndex):
        """ Set multiline selected fields according table config_api_form_fields.widgetcontrols['setQgisMultiline'] """

        if field['widgettype'] == 'text':
            if field['widgetcontrols'] and 'setQgisMultiline' in field['widgetcontrols']:
                editor_widget_setup = QgsEditorWidgetSetup('TextEdit', {'IsMultiline': field['widgetcontrols']['setQgisMultiline']})
                layer.setEditorWidgetSetup(fieldIndex, editor_widget_setup)


    def create_body(self, form='', feature='', filter_fields='', extras=None):
        """ Create and return parameters as body to functions"""

        client = f'$${{"client":{{"device":4, "infoType":1, "lang":"ES"}}, '
        form = '"form":{' + form + '}, '
        feature = '"feature":{' + feature + '}, '
        filter_fields = '"filterFields":{' + filter_fields + '}'
        page_info = '"pageInfo":{}'
        data = '"data":{' + filter_fields + ', ' + page_info
        if extras is not None:
            data += ', ' + extras
        data += f'}}}}$$'
        body = "" + client + form + feature + data

        return body


    def manage_guided_map(self):
        """ Guide map works using ext_municipality """

        self.layer_muni = self.controller.get_layer_by_tablename('ext_municipality')
        if self.layer_muni is None:
            return

        self.iface.setActiveLayer(self.layer_muni)
        self.controller.set_layer_visible(self.layer_muni)
        self.layer_muni.selectAll()
        self.iface.actionZoomToSelected().trigger()
        self.layer_muni.removeSelection()
        self.iface.actionSelect().trigger()
        self.iface.mapCanvas().selectionChanged.connect(self.selection_changed)
        cursor = self.get_cursor_multiple_selection()
        if cursor:
            self.iface.mapCanvas().setCursor(cursor)


    def selection_changed(self):
        """ Get selected muni_id and execute function setselectors """

        muni_id = None
        features = self.layer_muni.getSelectedFeatures()
        for feature in features:
            muni_id = feature["muni_id"]
            self.controller.log_info(f"Selected muni_id: {muni_id}")
            break

        self.iface.mapCanvas().selectionChanged.disconnect()
        self.iface.actionZoomToSelected().trigger()
        self.layer_muni.removeSelection()

        if muni_id is None:
            return

        extras = f'"selectorType":"explfrommuni", "id":{muni_id}, "value":true, "isAlone":true, '
        extras += f'"addSchema":"{self.qgis_project_add_schema}"'
        body = self.create_body(extras=extras)
        sql = f"SELECT gw_fct_setselectors({body})::text"
        row = self.controller.get_row(sql, commit=True)
        if row:
            self.iface.mapCanvas().refreshAllLayers()
            self.layer_muni.triggerRepaint()
            self.iface.actionPan().trigger()
            self.iface.actionZoomIn().trigger()


    def get_cursor_multiple_selection(self):
        """ Set cursor for multiple selection """

        icon_path = self.plugin_dir + '/icons/211.png'
        if os.path.exists(icon_path):
            cursor = QCursor(QPixmap(icon_path))
        else:
            cursor = None

        return cursor


    def add_layers_button(self):

        icon_path = self.plugin_dir + '/icons/306.png'
        dockwidget = self.iface.mainWindow().findChild(QDockWidget, 'Layers')
        toolbar = dockwidget.findChildren(QToolBar)[0]
        btn_exist = toolbar.findChild(QToolButton, 'gw_add_layers')
        if btn_exist is None:
            self.btn_add_layers = QToolButton()
            self.btn_add_layers.setIcon(QIcon(icon_path))
            self.btn_add_layers.setObjectName('gw_add_layers')
            self.btn_add_layers.setToolTip('Load giswater layer')
            toolbar.addWidget(self.btn_add_layers)
            self.btn_add_layers.clicked.connect(partial(self.create_add_layer_menu))


    def create_add_layer_menu(self):

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
        parent_layers = self.controller.get_rows(sql)

        for parent_layer in parent_layers:

            # Get child layers
            sql = (f"SELECT DISTINCT(child_layer), lower(feature_type), id as alias FROM cat_feature "
                   f"WHERE parent_layer = '{parent_layer[1]}' "
                   f"AND child_layer IN ("
                   f"   SELECT table_name FROM information_schema.tables"
                   f"   WHERE table_schema = '{schema_name}')"
                   f" ORDER BY child_layer")

            child_layers = self.controller.get_rows(sql)
            if not child_layers: continue

            # Create sub menu
            sub_menu = main_menu.addMenu(str(parent_layer[0]))
            child_layers.insert(0, ['Load all', 'Load all', 'Load all'])
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
                    action.triggered.connect(partial(self.add_layer.from_postgres_to_toc,
                        child_layers=child_layers, group=None))
                else:
                    action.triggered.connect(partial(self.add_layer.from_postgres_to_toc,
                        child_layer[0], "the_geom", child_layer[1]+"_id", None, None))

        main_menu.exec_(click_point)

