from qgis.core import QgsProject, QgsApplication, QgsProviderRegistry, QgsVectorLayer, QgsFeature, QgsGeometry
from qgis.gui import QgsMapCanvas
from qgis.PyQt.QtGui import QColor

import os


# dummy instance to replace qgis.utils.iface
class QgisInterfaceDummy(object):

    def __getattr__(self, name):
        # return an function that accepts any arguments and does nothing
        def dummy(*args, **kwargs):
            return None

        return dummy


class TestQgis():

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


    def load_layer(self):

        # Check using assertion versus normal check
        layer_path = r'/home/david/workspace/temp/comarques.shp'
        if not os.path.exists(layer_path):
            print(f"File not found: {layer_path}")
            return False

        # Make assert if file exists
        assert os.path.exists(layer_path) == True

        # Set layer
        layer = QgsVectorLayer(layer_path, 'input', 'ogr')
        if not layer.isValid():
            print(f"Layer failed to load: {layer_path}")
            assert False

        # Set canvas
        self.canvas = QgsMapCanvas()
        title = "PyQGIS Standalone Application Example"
        self.canvas.setWindowTitle(title)
        #canvas.setCanvasColor(QColor("#222222"))

        # Set memory layer
        layer_info = 'LineString?crs=epsg:4326'
        mem_layer = QgsVectorLayer(layer_info, 'MyLine', "memory")
        pr = mem_layer.dataProvider()
        linstr = QgsFeature()
        wkt = "LINESTRING (1 1, 10 15, 40 35)"
        geom = QgsGeometry.fromWkt(wkt)
        linstr.setGeometry(geom)
        pr.addFeatures([linstr])
        mem_layer.updateExtents()

        # Add layer to the map
        QgsProject.instance().addMapLayer(layer)

        self.canvas.setExtent(layer.extent())
        self.canvas.setLayers([layer])
        #QgsProject.instance().layerTreeRoot().findLayer(layer.id()).setItemVisibilityChecked(True)
        #canvas.zoomToFullExtent()


    def import_plugin(self):

        import first_plugin

        self.plugin = first_plugin.classFactory(self.iface)
        self.plugin.initGui()
        self.dlg = self.plugin.dlg
        self.dlg.btn_prova.setText("PROVA")
        self.dlg.show()


    def open_qgis(self, open_qgis=False):

        user_name = self.qgs.userFullName()
        #print(user_name)
        if open_qgis:
            self.canvas.show()
            exitcode = self.qgs.exec_()
            self.qgs.exitQgis()

        return True


    def create_project(self):

        import giswater

        print("\nStart create_project")
        self.giswater = giswater.classFactory(self.iface)
        #print(self.plugin.plugin_dir)
        self.giswater.init_plugin(False)

        # Connect to a database providing a service_name set in .pg_service.conf
        user = "gisadmin"
        service_name = 'localhost_giswater'
        status = self.giswater.controller.connect_to_database_service(service_name)
        self.giswater.controller.logged = status
        if self.giswater.controller.last_error:
            msg = self.giswater.controller.last_error
            print(msg)
            return

        self.giswater.update_sql.init_sql(False, user)
        self.giswater.update_sql.init_dialog_create_project()
        self.giswater.update_sql.create_project_data_schema('test_ws', 'test_ws_title', 'ws', '25831', 'EN', True)


def test_open_qgis():

    test = TestQgis()
    test.init_config()
    test.load_layer()
    test.open_qgis(True)


def test_create_project():

    test = TestQgis()
    test.init_config()
    test.create_project()
    print("Finish create_project")


if __name__ == '__main__':

    test = TestQgis()
    test.init_config()
    test.create_project()

