from qgis.core import QgsApplication, QgsProviderRegistry

from test.test_giswater import TestGiswater


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
        self.test_giswater = TestGiswater(self.iface)
        self.test_giswater.init_plugin(False)

        return True


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

        status = self.test_giswater.controller.connect_to_database_service(service_name)
        self.test_giswater.controller.logged = status
        if self.test_giswater.controller.last_error:
            msg = self.test_giswater.controller.last_error
            print(f"Database connection error: {msg}")
            return False

        return True


    def create_project(self):

        print("\nStart create_project")

        # Load main plugin class
        if not self.load_plugin():
            return False

        # Connect to a database providing a service_name set in .pg_service.conf
        service_name = "localhost_giswater"
        if not self.connect_to_database(service_name):
            return False

        user = "gisadmin"
        self.test_giswater.update_sql.init_sql(False, user)
        self.test_giswater.update_sql.init_dialog_create_project()
        self.test_giswater.update_sql.create_project_data_schema('test_ws', 'test_ws_title', 'ws', '25831', 'EN', True)

        print("Finish create_project")

        return True


def test_create_project():
    test = TestQgis()
    status = test.create_project()
    print(status)


if __name__ == '__main__':
    print("MAIN")
    test = TestQgis()
    test.create_project()

