from qgis.core import QgsApplication, QgsProviderRegistry

import os

from test_giswater import TestGiswater


# dummy instance to replace qgis.utils.iface
class QgisInterfaceDummy(object):

    def __getattr__(self, name):
        # return an function that accepts any arguments and does nothing
        def dummy(*args, **kwargs):
            return None

        return dummy


class TestQgis:

    def load_plugin(self):
        """ Load main plugin class """

        self.init_config()
        self.giswater_lite = TestGiswater(self.iface)
        self.giswater_lite.init_plugin(False)


    def init_config(self):

        # Set QGIS path
        # From QGIS console execute QgsApplication.prefixPath()
        QgsApplication.setPrefixPath('/usr', True)
        self.qgs = QgsApplication([], True)
        self.qgs.initQgis()
        self.iface = QgisInterfaceDummy()

        aux = len(QgsProviderRegistry.instance().providerList())
        if aux == 0:
            raise RuntimeError('No data providers available.')


    def connect_to_database(self, service_name):
        """ Connect to a database providing a service_name set in .pg_service.conf """

        status = self.giswater_lite.controller.connect_to_database_service(service_name)
        self.giswater_lite.controller.logged = status
        if self.giswater_lite.controller.last_error:
            msg = self.giswater_lite.controller.last_error
            print(f"Database connection error: {msg}")
            return False

        return True


    def create_project(self):

        print("\nStart create_project_lite")

        # Load main plugin class
        self.load_plugin()

        # Connect to a database providing a service_name set in .pg_service.conf
        service_name = "localhost_giswater"
        if not self.connect_to_database(service_name):
            return

        user = "gisadmin"
        self.giswater_lite.update_sql.init_sql(False, user)
        self.giswater_lite.update_sql.init_dialog_create_project()
        self.giswater_lite.update_sql.create_project_data_schema('test_ws', 'test_ws_title', 'ws', '25831', 'EN', True)

        print("Finish create_project")


def test_create_project():
    test = TestQgis()
    test.create_project()


if __name__ == '__main__':
    print("MAIN")
    test = TestQgis()
    test.create_project()

