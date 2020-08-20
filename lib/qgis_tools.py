"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsExpressionContextUtils, QgsProject, QgsSnappingConfig, QgsVectorLayer, QgsPointLocator, \
    QgsSnappingUtils, QgsTolerance, QgsPointXY, QgsFeatureRequest

from qgis.gui import QgsMapCanvas

from qgis.PyQt.QtWidgets import QDockWidget

from qgis.PyQt.QtCore import QPoint

import configparser
import os.path


class QgisTools:

    def __init__(self, iface, plugin_dir):
        """ Constructor
        :param iface: An interface instance that will be passed to this class
            which provides the hook by which you can manipulate the QGIS
            application at run time.
        :type iface: QgsInterface
        """

        self.iface = iface
        self.plugin_dir = plugin_dir

        self.previous_snapping = None

        # Snapper
        self.snapping_config = self.get_snapping_options()
        self.snapping_config.setEnabled(True)
        self.snapper = self.get_snapper()
        proj = QgsProject.instance()
        proj.writeEntry('Digitizing', 'SnappingMode', 'advanced')


    def get_value_from_metadata(self, parameter, default_value):
        """ Get @parameter from metadata.txt file """

        # Check if metadata file exists
        metadata_file = os.path.join(self.plugin_dir, 'metadata.txt')
        if not os.path.exists(metadata_file):
            message = f"Metadata file not found: {metadata_file}"
            self.iface.messageBar().pushMessage("", message, 1, 20)
            return default_value

        value = None
        try:
            metadata = configparser.ConfigParser()
            metadata.read(metadata_file)
            value = metadata.get('general', parameter)
        except configparser.NoOptionError:
            message = f"Parameter not found: {parameter}"
            self.iface.messageBar().pushMessage("", message, 1, 20)
            value = default_value
        finally:
            return value


    def get_qgis_project_variables(self):
        """ Manage QGIS project variables """

        project_vars = {}
        project_vars['infotype'] = self.get_project_variable('gwInfoType')
        project_vars['add_schema'] = self.get_project_variable('gwAddSchema')
        project_vars['main_schema'] = self.get_project_variable('gwMainSchema')
        project_vars['role'] = self.get_project_variable('gwProjectRole')
        return project_vars


    def enable_python_console(self):
        """ Enable Python console and Log Messages panel if parameter 'enable_python_console' = True """

        # Manage Python console
        python_console = self.iface.mainWindow().findChild(QDockWidget, 'PythonConsole')
        if python_console:
            python_console.setVisible(True)
        else:
            import console
            console.show_console()

        # Manage Log Messages panel
        message_log = self.iface.mainWindow().findChild(QDockWidget, 'MessageLog')
        if message_log:
            message_log.setVisible(True)


    def get_project_variable(self, var_name):
        """ Get project variable """

        value = None
        try:
            value = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable(var_name)
        except Exception:
            pass
        finally:
            return value


    def qgis_get_layers(self):
        """ Return layers in the same order as listed in TOC """

        layers = [layer.layer() for layer in QgsProject.instance().layerTreeRoot().findLayers()]

        return layers


    def qgis_get_layer_source(self, layer):
        """ Get database connection paramaters of @layer """

        # Initialize variables
        layer_source = {'db': None, 'schema': None, 'table': None, 'service': None,
                        'host': None, 'port': None, 'user': None, 'password': None, 'sslmode': None}

        if layer is None:
            return layer_source

        # Get dbname, host, port, user and password
        uri = layer.dataProvider().dataSourceUri()
        pos_db = uri.find('dbname=')
        pos_host = uri.find(' host=')
        pos_port = uri.find(' port=')
        pos_user = uri.find(' user=')
        pos_password = uri.find(' password=')
        pos_sslmode = uri.find(' sslmode=')
        pos_key = uri.find(' key=')
        if pos_db != -1 and pos_host != -1:
            uri_db = uri[pos_db + 8:pos_host - 1]
            layer_source['db'] = uri_db
        if pos_host != -1 and pos_port != -1:
            uri_host = uri[pos_host + 6:pos_port]
            layer_source['host'] = uri_host
        if pos_port != -1:
            if pos_user != -1:
                pos_end = pos_user
            elif pos_sslmode != -1:
                pos_end = pos_sslmode
            elif pos_key != -1:
                pos_end = pos_key
            else:
                pos_end = pos_port + 10
            uri_port = uri[pos_port + 6:pos_end]
            layer_source['port'] = uri_port
        if pos_user != -1 and pos_password != -1:
            uri_user = uri[pos_user + 7:pos_password - 1]
            layer_source['user'] = uri_user
        if pos_password != -1 and pos_sslmode != -1:
            uri_password = uri[pos_password + 11:pos_sslmode - 1]
            layer_source['password'] = uri_password

            # Get schema and table or view name
        pos_table = uri.find('table=')
        pos_end_schema = uri.rfind('.')
        pos_fi = uri.find('" ')
        if pos_table != -1 and pos_fi != -1:
            uri_schema = uri[pos_table + 6:pos_end_schema]
            uri_table = uri[pos_end_schema + 2:pos_fi]
            layer_source['schema'] = uri_schema
            layer_source['table'] = uri_table

        return layer_source


    def qgis_get_layer_source_table_name(self, layer):
        """ Get table or view name of selected layer """

        if layer is None:
            return None

        uri_table = None
        uri = layer.dataProvider().dataSourceUri().lower()
        pos_ini = uri.find('table=')
        pos_end_schema = uri.rfind('.')
        pos_fi = uri.find('" ')
        if pos_ini != -1 and pos_fi != -1:
            uri_table = uri[pos_end_schema + 2:pos_fi]

        return uri_table


    def qgis_get_layer_primary_key(self, layer=None):
        """ Get primary key of selected layer """

        uri_pk = None
        if layer is None:
            layer = self.iface.activeLayer()
        if layer is None:
            return uri_pk
        uri = layer.dataProvider().dataSourceUri().lower()
        pos_ini = uri.find('key=')
        pos_end = uri.rfind('srid=')
        if pos_ini != -1:
            uri_pk = uri[pos_ini + 5:pos_end - 2]

        return uri_pk


    def qgis_get_layer_by_tablename(self, tablename, show_warning=False, log_info=False):
        """ Iterate over all layers and get the one with selected @tablename """

        # Check if we have any layer loaded
        layers = self.qgis_get_layers()
        if len(layers) == 0:
            return None

        # Iterate over all layers
        layer = None
        for cur_layer in layers:
            uri_table = self.qgis_get_layer_source_table_name(cur_layer)
            if uri_table is not None and uri_table == tablename:
                layer = cur_layer
                break

        if layer is None and show_warning:
            pass
            #self.show_warning("Layer not found", parameter=tablename)

        if layer is None and log_info:
            pass
            #self.log_info("Layer not found", parameter=tablename)

        return layer


    def qgis_manage_snapping_layer(self, layername, snapping_type=0, tolerance=15.0):
        """ Manage snapping of @layername """

        layer = self.qgis_get_layer_by_tablename(layername)
        if not layer:
            return
        if snapping_type == 0:
            snapping_type = QgsPointLocator.Vertex
        elif snapping_type == 1:
            snapping_type = QgsPointLocator.Edge
        elif snapping_type == 2:
            snapping_type = QgsPointLocator.All

        QgsSnappingUtils.LayerConfig(layer, snapping_type, tolerance, QgsTolerance.Pixels)

    def init_snapping_config(self):
        pass


    def set_controller(self, controller):
        self.controller = controller


    def set_snapping_layers(self):
        """ Set main snapping layers """

        self.layer_arc = self.controller.get_layer_by_tablename('v_edit_arc')
        self.layer_connec = self.controller.get_layer_by_tablename('v_edit_connec')
        self.layer_gully = self.controller.get_layer_by_tablename('v_edit_gully')
        self.layer_node = self.controller.get_layer_by_tablename('v_edit_node')


    def get_snapping_options(self):
        """ Function that collects all the snapping options """

        global_snapping_config = QgsProject.instance().snappingConfig()
        return global_snapping_config


    def store_snapping_options(self):
        """ Store the project user snapping configuration """

        # Get an array containing the snapping options for all the layers
        self.previous_snapping = self.get_snapping_options()


    def enable_snapping(self, enable=False):
        """ Enable/Disable snapping of all layers """

        QgsProject.instance().blockSignals(True)

        layers = self.controller.get_layers()
        # Loop through all the layers in the project
        for layer in layers:
            if type(layer) != QgsVectorLayer:
                continue
            layer_settings = self.snapping_config.individualLayerSettings(layer)
            layer_settings.setEnabled(enable)
            self.snapping_config.setIndividualLayerSettings(layer, layer_settings)

        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snappingConfigChanged.emit(self.snapping_config)


    def set_snapping_mode(self, mode=3):
        """ Defines on which layer the snapping is performed
        :param mode: 1 = ActiveLayer, 2=AllLayers, 3=AdvancedConfiguration (int or SnappingMode)
        """

        snapping_options = self.get_snapping_options()
        if snapping_options:
            QgsProject.instance().blockSignals(True)
            snapping_options.setMode(mode)
            QgsProject.instance().setSnappingConfig(snapping_options)
            QgsProject.instance().blockSignals(False)
            QgsProject.instance().snappingConfigChanged.emit(snapping_options)


    def snap_to_arc(self):
        """ Set snapping to 'arc' """

        QgsProject.instance().blockSignals(True)
        layer_settings = self.snap_to_layer(self.layer_arc, QgsPointLocator.All, True)
        if layer_settings:
            layer_settings.setType(2)
            layer_settings.setTolerance(15)
            layer_settings.setEnabled(True)
        else:
            layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, 2, 15, 1)
        self.snapping_config.setIndividualLayerSettings(self.layer_arc, layer_settings)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snappingConfigChanged.emit(self.snapping_config)


    def snap_to_node(self):
        """ Set snapping to 'node' """

        QgsProject.instance().blockSignals(True)
        layer_settings = self.snap_to_layer(self.layer_node, QgsPointLocator.Vertex, True)
        if layer_settings:
            layer_settings.setType(1)
            layer_settings.setTolerance(15)
            layer_settings.setEnabled(True)
        else:
            layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, 1, 15, 1)
        self.snapping_config.setIndividualLayerSettings(self.layer_node, layer_settings)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snappingConfigChanged.emit(self.snapping_config)


    def snap_to_connec_gully(self):
        """ Set snapping to 'connec' and 'gully' """

        QgsProject.instance().blockSignals(True)
        layer_settings = self.snap_to_layer(self.layer_connec, QgsPointLocator.Vertex, True)
        if layer_settings:
            layer_settings.setType(1)
            layer_settings.setTolerance(15)
            layer_settings.setEnabled(True)
        else:
            layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, 1, 15, 1)
        self.snapping_config.setIndividualLayerSettings(self.layer_connec, layer_settings)

        layer_settings = self.snap_to_layer(self.layer_gully, QgsPointLocator.Vertex, True)
        if layer_settings:
            layer_settings.setType(1)
            layer_settings.setTolerance(15)
            layer_settings.setEnabled(True)
        else:
            layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, 1, 15, 1)

        self.snapping_config.setIndividualLayerSettings(self.layer_gully, layer_settings)

        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snappingConfigChanged.emit(self.snapping_config)


    def snap_to_layer(self, layer, point_locator=QgsPointLocator.All, set_settings=False):
        """ Set snapping to @layer """

        if layer is None:
            return

        QgsSnappingUtils.LayerConfig(layer, point_locator, 15, QgsTolerance.Pixels)
        if set_settings:
            layer_settings = self.snapping_config.individualLayerSettings(layer)
            layer_settings.setEnabled(True)
            self.snapping_config.setIndividualLayerSettings(layer, layer_settings)
            return layer_settings


    def apply_snapping_options(self, snappings_options):
        """ Function that applies selected snapping configuration """

        QgsProject.instance().blockSignals(True)
        if snappings_options:
            QgsProject.instance().setSnappingConfig(snappings_options)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snappingConfigChanged.emit(self.snapping_config)


    def recover_snapping_options(self):
        """ Function to restore the previous snapping configuration """

        self.apply_snapping_options(self.previous_snapping)


    def check_arc_group(self, snapped_layer):
        """ Check if snapped layer is in the arc group """

        return snapped_layer == self.layer_arc


    def check_node_group(self, snapped_layer):
        """ Check if snapped layer is in the node group """

        return snapped_layer == self.layer_node


    def check_connec_group(self, snapped_layer):
        """ Check if snapped layer is in the connec group """

        return snapped_layer == self.layer_connec


    def check_gully_group(self, snapped_layer):
        """ Check if snapped layer is in the gully group """

        return snapped_layer == self.layer_gully


    def get_snapper(self):
        """ Return snapper """

        snapper = QgsMapCanvas.snappingUtils(self.iface.mapCanvas())
        return snapper


    def snap_to_current_layer(self, event_point, vertex_marker=None):

        self.is_valid = False
        if event_point is None:
            return None, None

        result = self.snapper.snapToCurrentLayer(event_point, QgsPointLocator.All)
        if vertex_marker:
            if result.isValid():
                # Get the point and add marker on it
                point = QgsPointXY(result.point())
                vertex_marker.setCenter(point)
                vertex_marker.show()

        self.is_valid = result.isValid()
        return result


    def snap_to_background_layers(self, event_point, vertex_marker=None):

        self.is_valid = False
        if event_point is None:
            return None, None

        result = self.snapper.snapToMap(event_point)
        if vertex_marker:
            if result.isValid():
                # Get the point and add marker on it
                point = QgsPointXY(result.point())
                vertex_marker.setCenter(point)
                vertex_marker.show()

        self.is_valid = result.isValid()
        return result


    def add_marker(self, result, vertex_marker=None, icon_type=None):

        if not result.isValid():
            return None

        if vertex_marker is None:
            vertex_marker = self.vertex_marker

        point = result.point()
        if icon_type:
            vertex_marker.setIconType(icon_type)
        vertex_marker.setCenter(point)
        vertex_marker.show()

        return point


    def remove_marker(self, vertex_marker=None):

        if vertex_marker is None:
            vertex_marker = self.vertex_marker

        vertex_marker.hide()


    def get_event_point(self, event=None, point=None):
        """ Get point """

        event_point = None
        x = None
        y = None
        try:
            if event:
                x = event.pos().x()
                y = event.pos().y()
            if point:
                map_point = self.canvas.getCoordinateTransform().transform(point)
                x = map_point.x()
                y = map_point.y()
            event_point = QPoint(x, y)
        except:
            pass
        finally:
            return event_point


    def get_snapped_layer(self, result):

        layer = None
        if result.isValid():
            layer = result.layer()

        return layer


    def get_snapped_point(self, result):

        point = None
        if result.isValid():
            point = QgsPointXY(result.point())

        return point


    def get_snapped_feature_id(self, result):

        feature_id = None
        if result.isValid():
            feature_id = result.featureId()

        return feature_id


    def get_snapped_feature(self, result, select_feature=False):

        if not result.isValid():
            return None

        snapped_feat = None
        try:
            layer = result.layer()
            feature_id = result.featureId()
            feature_request = QgsFeatureRequest().setFilterFid(feature_id)
            snapped_feat = next(layer.getFeatures(feature_request))
            if select_feature and snapped_feat:
                self.select_snapped_feature(result, feature_id)
        except:
            pass
        finally:
            return snapped_feat


    def select_snapped_feature(self, result, feature_id):

        if not result.isValid():
            return

        layer = result.layer()
        layer.select([feature_id])


    def result_is_valid(self):

        return self.is_valid