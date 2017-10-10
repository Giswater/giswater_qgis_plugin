from qgis.core import QgsMessageLog
from qgis.gui import QgsMapTool, QgsMapCanvasSnapper
from PyQt4.QtCore import Qt, pyqtSignal
#from qgis.core import QgsPoint
from qgis.core import *
from qgis.gui import  *
from PyQt4.QtCore import *
from PyQt4.QtGui import *

from PyQt4.QtGui import QProgressBar
from qgis.gui import QgsMessageBar
from qgis.core import QgsMapLayerRegistry, QgsFeatureRequest

from qgis.core import QgsPoint, QgsVectorLayer, QgsRectangle, QGis
from qgis.gui import QgsRubberBand, QgsVertexMarker
from PyQt4.QtCore import QPoint, QRect, Qt
from PyQt4.QtGui import QApplication, QColor



class MultipleSnapping(QgsMapTool):
    #canvasClicked = pyqtSignal(['QgsPoint', 'Qt::MouseButton'])
    canvasClicked = pyqtSignal()

    def __init__(self, iface, settings, controller, plugin_dir, group):
        # Class constructor

        self.group_layers = group
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        # Call superclass constructor and set current action
        QgsMapTool.__init__(self, self.canvas)

        self.controller = controller

        self.rubberBand = QgsRubberBand(self.canvas, QGis.Polygon)
        mFillColor = QColor(254, 178, 76, 63);
        self.rubberBand.setColor(mFillColor)
        self.rubberBand.setWidth(1)
        self.reset()

        self.snapper = QgsMapCanvasSnapper(self.canvas)

        self.selected_features = []


    def reset(self):
        self.startPoint = self.endPoint = None
        self.isEmittingPoint = False
        self.rubberBand.reset(QGis.Polygon)


    def canvasPressEvent(self, e):

        if e.button() == Qt.LeftButton:
            self.startPoint = self.toMapCoordinates(e.pos())
            self.endPoint = self.startPoint
            self.isEmittingPoint = True
            self.showRect(self.startPoint, self.endPoint)


    def canvasReleaseEvent(self, e):
        self.isEmittingPoint = False
        r = self.rectangle()

        # Use CTRL button to unselect features
        key = QApplication.keyboardModifiers()

        numberFeatures = 0
        if e.button() == Qt.LeftButton:
            for layer in self.group_pointers:
                # Check number of selections
                #numberFeatures = layer.selectedFeatureCount()
                #self.controller.log_info(str(numberFeature))
                if r is not None:
                    # Selection by rectange
                    lRect = self.canvas.mapSettings().mapToLayerCoordinates(layer, r)
                    layer.select(lRect, True) # True for leave previous selection
                    # if CTRL pressed : unselect features
                    if key == Qt.ControlModifier:
                        layer.selectByRect(lRect, layer.RemoveFromSelection)
                else:
                    # Selection one by one
                    x = e.pos().x()
                    y = e.pos().y()
                    eventPoint = QPoint(x, y)
                    (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)
                    if result <> []:

                        # Check feature
                        for snapPoint in result:
                            # Get the point
                            #point = QgsPoint(snapPoint.snappedVertex)
                            snappFeat = next(snapPoint.layer.getFeatures(QgsFeatureRequest().setFilterFid(snapPoint.snappedAtGeometry)))

                            # LEAVE SELECTION
                            snapPoint.layer.select([snapPoint.snappedAtGeometry])

            self.rubberBand.hide()


    def canvasMoveEvent(self, e):
        if not self.isEmittingPoint:
            return
        self.endPoint = self.toMapCoordinates(e.pos())
        self.showRect(self.startPoint, self.endPoint)


    def showRect(self, startPoint, endPoint):
        self.rubberBand.reset(QGis.Polygon)
        if startPoint.x() == endPoint.x() or startPoint.y() == endPoint.y():
            return
        point1 = QgsPoint(startPoint.x(), startPoint.y())
        point2 = QgsPoint(startPoint.x(), endPoint.y())
        point3 = QgsPoint(endPoint.x(), endPoint.y())
        point4 = QgsPoint(endPoint.x(), startPoint.y())

        self.rubberBand.addPoint(point1, False)
        self.rubberBand.addPoint(point2, False)
        self.rubberBand.addPoint(point3, False)
        self.rubberBand.addPoint(point4, True)  # true to update canvas
        self.rubberBand.show()


    def rectangle(self):
        if self.startPoint is None or self.endPoint is None:
            return None
        elif self.startPoint.x() == self.endPoint.x() or self.startPoint.y() == self.endPoint.y():
            return None

        return QgsRectangle(self.startPoint, self.endPoint)


    def deactivate(self):
        self.rubberBand.hide()
        QgsMapTool.deactivate(self)


    def activate(self):
        #self.group_layers = ["Wjoin", "Fountain"]
        self.group_pointers = []

        for layer in self.group_layers:
            self.group_pointers.append(QgsMapLayerRegistry.instance().mapLayersByName(layer)[0])

        #QgsMapTool.activate(self)


