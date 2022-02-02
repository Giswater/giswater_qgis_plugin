"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QDialog
from qgis.core import QgsApplication, QgsProviderRegistry

from .test_giswater import GwTest
from ..core.admin.gis_file_create import GwGisFileCreate
from .. import global_vars
from ..lib import tools_db


# dummy instance to replace qgis.utils.iface
class GwQgisInterfaceDummy(object):

    def __getattr__(self, name):
        # return an function that accepts any arguments and does nothing
        # noinspection PyUnusedLocal
        def dummy(*args, **kwargs):
            return None

        return dummy


class GwTestQgis:

    def __init__(self):

        super(GwTestQgis, self).__init__()
        self.service_name = "localhost_giswater"
        self.user = "gisadmin"


    def load_plugin(self, schema_name=None):
        """ Load main plugin class """

        self.init_config()
        self.test_giswater = GwTest(self.iface)
        self.test_giswater.init_plugin(schema_name)

        return True


    def init_config(self):

        # Set QGIS path
        # From QGIS console execute QgsApplication.prefixPath()
        QgsApplication.setPrefixPath('/usr', True)
        self.qgs = QgsApplication([], True)
        self.qgs.initQgis()
        self.iface = GwQgisInterfaceDummy()

        aux = len(QgsProviderRegistry.instance().providerList())
        if aux == 0:
            raise RuntimeError('No data providers available.')


    def connect_to_database(self, service_name):
        """ Connect to a database providing a service_name set in .pg_service.conf """

        status = tools_db.connect_to_database_service(service_name)
        global_vars.session_vars['logged_status'] = status

        if self.test_giswater.global_vars.session_vars['last_error']:
            msg = self.test_giswater.global_vars.session_vars['last_error']
            print(f"Database connection error: {msg}")
            return False

        return True


    def create_project(self, project_type='ws', project_name=None, project_title=None):

        print("\nStart create_project")

        # Load main plugin class
        if not self.load_plugin():
            return False

        # Connect to a database providing a service_name set in .pg_service.conf
        if not self.connect_to_database(self.service_name):
            return False

        self.test_giswater.gw_admin.init_sql(False, self.user, show_dialog=False)
        self.test_giswater.gw_admin.init_dialog_create_project(project_type)
        if project_name is None:
            project_name = f"test_{project_type}"
        if project_title is None:
            project_title = f"test_{project_type}"
        self.test_giswater.gw_admin.create_project_data_schema(project_name, project_title, project_type,
            '25831', 'US', is_test=True, exec_last_process=True, example_data=True)

        print("Finish create_project")

        return True


    def update_project(self, project_type='ws'):

        print("\nStart update_project")

        # Load main plugin class
        if not self.load_plugin():
            return False

        # Connect to a database providing a service_name set in .pg_service.conf
        if not self.connect_to_database(self.service_name):
            return False

        self.test_giswater.gw_admin.init_sql(False, self.user, show_dialog=False)
        self.test_giswater.gw_admin.init_dialog_create_project(project_type)
        project_name = f"test_{project_type}"
        self.test_giswater.gw_admin.load_updates(project_type, schema_name=project_name)

        print("Finish update_project")

        return True


    def create_gis_project(self, project_type='ws'):

        print("\nStart create_gis_project")

        # Load main plugin class
        if not self.load_plugin():
            return False

        # Connect to a database providing a service_name set in .pg_service.conf
        if not self.connect_to_database(self.service_name):
            return False

        self.test_giswater.gw_admin.init_sql(False, self.user, show_dialog=False)
        self.test_giswater.gw_admin.init_dialog_create_project(project_type)

        # Generate QGIS project
        project_name = f"test_{project_type}"
        gis_folder = "C:/Users/David/giswater/qgs"
        gis_file = project_name
        export_passwd = True
        roletype = 'admin'
        sample = True
        gis = GwGisFileCreate(self.test_giswater.plugin_dir)
        layer_source = {'host': "host", 'port': "port", 'db': "db",
                        'user': "user", 'password': "password", "srid": "25831"}
        gis.gis_project_database(gis_folder, gis_file, project_type, project_name, export_passwd,
            roletype, sample, layer_source=layer_source)

        print("Finish create_gis_project")

        return True


    def manage_visit(self, project_name='test_ud'):

        print("\nStart manage_visit")

        # Load main plugin class
        if not self.load_plugin(project_name):
            return False

        # Connect to a database providing a service_name set in .pg_service.conf
        if not self.connect_to_database(self.service_name):
            return False

        tools_db.set_search_path(project_name)
        dlg = self.test_giswater.visit_manager.dlg_add_visit
        res = dlg.exec()
        if res == QDialog.Accepted:
            print('Accepted')

        return


def test_create_project():
    test = GwTestQgis()
    status = test.create_project()
    print(status)


def test_update_project():
    test = GwTestQgis()
    status = test.update_project('ud')
    print(status)


def test_create_gis_project():
    test = GwTestQgis()
    status = test.create_gis_project('ud')
    print(status)


def test_manage_visit():
    test = GwTestQgis()
    status = test.manage_visit()
    print(status)


if __name__ == '__main__':
    print("MAIN")
    test = GwTestQgis()
    test.create_project('ws', 'ws_dev34')

