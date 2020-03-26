from qgis.core import QgsApplication, QgsProviderRegistry
from test_giswater import TestGiswater
from actions.create_gis_project import CreateGisProject


# dummy instance to replace qgis.utils.iface
class QgisInterfaceDummy(object):

    def __getattr__(self, name):
        # return an function that accepts any arguments and does nothing
        def dummy(*args, **kwargs):
            return None

        return dummy


class TestQgis:

    def __init__(self):

        self.service_name = "localhost_giswater"
        self.user = "gisadmin"


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


    def create_project(self, project_type='ws'):

        print("\nStart create_project")

        # Load main plugin class
        if not self.load_plugin():
            return False

        # Connect to a database providing a service_name set in .pg_service.conf
        if not self.connect_to_database(self.service_name):
            return False

        self.test_giswater.update_sql.init_sql(False, self.user, show_dialog=False)
        self.test_giswater.update_sql.init_dialog_create_project(project_type)
        project_name = f"test_{project_type}"
        project_title = f"test_{project_type}"
        self.test_giswater.update_sql.create_project_data_schema(project_name, project_title, project_type,
            '25831', 'EN', is_test=True, exec_last_process=True, example_data=True)

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

        self.test_giswater.update_sql.init_sql(False, self.user, show_dialog=False)
        self.test_giswater.update_sql.init_dialog_create_project(project_type)
        project_name = f"test_{project_type}"
        self.test_giswater.update_sql.load_updates(project_type, schema_name=project_name)

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

        self.test_giswater.update_sql.init_sql(False, self.user, show_dialog=False)
        self.test_giswater.update_sql.init_dialog_create_project(project_type)

        # Generate QGIS project
        project_name = f"test_{project_type}"
        gis_folder = "C:/Users/David/giswater/qgs"
        gis_file = project_name
        export_passwd = True
        roletype = 'admin'
        sample = True
        get_database_parameters = False
        gis = CreateGisProject(self.test_giswater.controller, self.test_giswater.plugin_dir)
        gis.set_database_parameters("host", "port", "db", "user", "password", "25831")
        gis.gis_project_database(gis_folder, gis_file, project_type, project_name, export_passwd,
            roletype, sample, get_database_parameters)

        print("Finish create_gis_project")

        return True


def test_create_project():
    test = TestQgis()
    status = test.create_project()
    print(status)


def test_update_project():
    test = TestQgis()
    status = test.update_project('ud')
    print(status)


def test_create_gis_project():
    test = TestQgis()
    status = test.create_gis_project('ws')
    print(status)


if __name__ == '__main__':
    print("MAIN")
    test = TestQgis()
    test.create_gis_project('ws')

