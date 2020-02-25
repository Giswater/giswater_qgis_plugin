import os
from qgis.core import QgsProject, QgsApplication, QgsProviderRegistry, QgsVectorLayer, QgsFeature, QgsGeometry
from qgis.gui import QgsMapCanvas
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QColor


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


    def exec_layer(self):

        # Check using assertion versus normal check
        layer_path = r'/home/david/workspace/temp/comarques.shp'
        #self.assertTrue(os.path.exists(layer_path), f"File not found: {layer_path}")
        if not os.path.exists(layer_path):
            print("File not found")
            return

        layer = QgsVectorLayer(layer_path, 'input', 'ogr')

        # Check using assertion versus normal check
        #self.assertTrue(layer.isValid(), 'Failed to load "{}".'.format(layer.source()))
        if not layer.isValid():
            print("Layer failed to load: " + layer_path)

        # Set canvas
        canvas = QgsMapCanvas()
        title = "PyQGIS Standalone Application Example"
        canvas.setWindowTitle(title)
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

        canvas.setExtent(layer.extent())
        canvas.setLayers([layer])
        #QgsProject.instance().layerTreeRoot().findLayer(layer.id()).setItemVisibilityChecked(True)
        #canvas.zoomToFullExtent()

        canvas.show()
        exitcode = self.qgs.exec_()
        self.qgs.exitQgis()


    def import_plugin(self):

        import first_plugin

        self.plugin = first_plugin.classFactory(self.iface)
        self.plugin.initGui()
        self.dlg = self.plugin.dlg
        self.dlg.btn_prova.setText("PROVA")
        self.dlg.show()


    def exec_qgis(self):

        exitcode = self.qgs.exec_()
        self.qgs.exitQgis()


    def import_giswater(self):

        import giswater

        self.plugin = giswater.classFactory(self.iface)
        self.plugin.initGui()
        print(self.plugin.plugin_dir)
        #self.plugin.project_read()


if __name__ == '__main__':

    test = TestQgis()
    test.init_config()
    test.exec_layer()
    #test.import_giswater()
    test.exec_qgis()

