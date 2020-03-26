from qgis.core import QgsProject, QgsApplication, QgsProviderRegistry, QgsVectorLayer, QgsFeature, QgsGeometry
from qgis.gui import QgsMapCanvas
from qgis.PyQt.QtGui import QColor

import os

import giswater


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
        self.giswater = giswater.classFactory(self.iface)
        self.giswater.init_plugin(False)
        #print(self.plugin.plugin_dir)


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

        status = self.giswater.controller.connect_to_database_service(service_name)
        self.giswater.controller.logged = status
        if self.giswater.controller.last_error:
            msg = self.giswater.controller.last_error
            print(f"Database connection error: {msg}")
            return False

        return True


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


    def check_project(self):

        print("\nStart check_project")

        # Load main plugin class
        self.load_plugin()

        # Connect to a database providing a service_name set in .pg_service.conf
        service_name = "localhost_giswater"
        if not self.connect_to_database(service_name):
            return

        layers = self.giswater.controller.get_layers()
        status = self.giswater.populate_audit_check_project(layers)

        print("Finish check_project")


def test_open_qgis():

    test = TestQgis()
    test.init_config()
    test.load_layer()
    test.open_qgis(True)


def test_check_project():

    test = TestQgis()
    test.check_project()


if __name__ == '__main__':

    test = TestQgis()
    test.check_project()

