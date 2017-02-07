"""
/***************************************************************************
        begin                : 2016-01-05
        copyright            : (C) 2016 by BGEO SL
        email                : vicente.medina@gits.ws
        git sha              : $Format:%H$
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

"""

# -*- coding: utf-8 -*-
from qgis.core import QgsPoint, QgsMapLayer, QgsVectorLayer, QgsRectangle, QGis
from qgis.gui import QgsRubberBand, QgsVertexMarker
from PyQt4.QtCore import QPoint, QRect, Qt
from PyQt4.QtGui import QApplication, QColor, QProgressBar ,QPixmap

from PyQt4.QtGui import QLabel, QWidget

from map_tools.parent import ParentMapTool

import datetime, time

from multiprocessing import Process
from threading import Thread

import os
import sys


class ValveAnalytics(ParentMapTool):
    ''' Button 27. '''    

    def __init__(self, iface, settings, action, index_action):
        ''' Class constructor '''

        # Call ParentMapTool constructor
        super(ValveAnalytics, self).__init__(iface, settings, action, index_action)

        # Vertex marker
        self.vertexMarker = QgsVertexMarker(self.canvas)
        self.vertexMarker.setColor(QColor(255, 25, 25))
        self.vertexMarker.setIconSize(11)
        self.vertexMarker.setIconType(QgsVertexMarker.ICON_BOX)  # or ICON_CROSS, ICON_X
        self.vertexMarker.setPenWidth(5)

        # Rubber band
        self.rubberBand = QgsRubberBand(self.canvas, True)
        mFillColor = QColor(100, 0, 0);
        self.rubberBand.setColor(mFillColor)
        self.rubberBand.setWidth(3)
        mBorderColor = QColor(254, 58, 29)
        self.rubberBand.setBorderColor(mBorderColor)
        
        self.reset()



    def reset(self):
        ''' Clear selected features '''
        
        '''
        layer = self.layer_connec
        if layer is not None:
            layer.removeSelection()
        '''

        # Graphic elements
        self.rubberBand.reset()
        
        # Selection
        self.snappFeat = None
          


    ''' QgsMapTools inherited event functions '''

    def canvasMoveEvent(self, event):
        ''' With left click the digitizing is finished '''


        #Plugin reloader bug, MapTool should be deactivated
        if not hasattr(Qt, 'LeftButton'):
            print "Plugin loader bug"
            self.iface.actionPan().trigger()
            return

        # Hide highlight
        self.vertexMarker.hide()

        # Get the click
        x = event.pos().x()
        y = event.pos().y()
        eventPoint = QPoint(x, y)

        # Snapping
        (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable
        # That's the snapped point
        if result <> []:

            # Check Arc or Node
            for snapPoint in result:
                    
                #exist=self.snapperManager.check_connec_group(snapPoint.layer)
                #if exist : 
                #if snapPoint.layer == self.layer_connec:
                if snapPoint.layer.name() == 'Valve':

                    # Get the point
                    point = QgsPoint(result[0].snappedVertex)

                    # Add marker
                    self.vertexMarker.setCenter(point)
                    self.vertexMarker.show()

                    break


    def canvasReleaseEvent(self, event):
        ''' With left click the digitizing is finished '''
        
        if event.button() == Qt.LeftButton:

            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            eventPoint = QPoint(x, y)

            # Snap to node
            (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable
            # That's the snapped point
            if result <> [] :
            #exist=self.snapperManager.check_connec_group(result[0].layer)

                #if exist :
                if result[0].layer.name() == 'Valve':
                    point = QgsPoint(result[0].snappedVertex)   #@UnusedVariable
                    
                    #result[0].layer.removeSelection()
                    result[0].layer.select([result[0].snappedAtGeometry])
    
    
                    # Hide highlight
                    self.vertexMarker.hide()


        elif event.button() == Qt.RightButton:
            '''
            process1 = Process(target = self.mg_analytics())
            process1.start()
            process2 = Process(target = self.show_progressBar())
            process2.start()
            
            Thread(target=self.mg_analytics).start()
            Thread(target=self.show_progressBar).start()
            
            '''

            #self.show_loader()
            self.mg_analytics()
            
    def show_loader(self):
        
        # Create window
        #app = QApplication(sys.argv)
        w = QWidget()
        #w.setWindowTitle("PyQT4 Pixmap @ pythonspot.com ") 
         
        # Create widget
        label = QLabel(w)
        '''
        picfile='logo.png'
        logo = os.getcwd() + '\\' + picfile
        print logo
        '''
        plugin_dir = os.path.dirname(__file__)    
        pic_file = os.path.join(plugin_dir, 'png','loader.gif') 
        #if os.path.isfile(pic_file):
        pixmap = QPixmap(pic_file)
        label.setPixmap(pixmap)
        #w.resize(pixmap.width(),pixmap.height())
         
        # Draw window
        w.show()
        #app.exec_()
        '''
        else:
            print "I expected to find a png picture called logo.png in "+ os.getcwd() 
        '''
    
    def activate(self):

        # Check button
        self.action().setChecked(True)

        # Rubber band
        self.rubberBand.reset()

        # Store user snapping configuration
        self.snapperManager.storeSnappingOptions()

        # Clear snapping
        self.snapperManager.clearSnapping()

        # Set snapping to arc and node
        self.snapperManager.snapToValve()

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Right click to use current select valve point by clicking"
            self.controller.show_info(message, context_name='ui_message' )  

        # Control current layer (due to QGIS bug in snapping system)
        if self.canvas.currentLayer() == None:
            self.iface.setActiveLayer(self.layer_node_man[0])


    def deactivate(self):

        # Check button
        self.action().setChecked(False)

        # Rubber band
        self.rubberBand.reset()

        # Restore previous snapping
        self.snapperManager.recoverSnappingOptions()

        # Recover cursor
        self.canvas.setCursor(self.stdCursor)


    def mg_analytics(self):
        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 27)        
        # Execute SQL function  
        function_name = "gw_fct_valveanalytics"
        sql = "SELECT "+self.schema_name+"."+function_name+"();"  
        result = self.controller.execute_sql(sql)      
        if result:
            message = "Valve analytics executed successfully"
            self.controller.show_info(message, 30, context_name='ui_message')



    def set_rubber_band(self):

        # Coordinates transform
        transform = self.canvas.getCoordinateTransform()

        # Coordinates
        ll = transform.toMapCoordinates(self.selectRect.left(), self.selectRect.bottom())
        lr = transform.toMapCoordinates(self.selectRect.right(), self.selectRect.bottom())
        ul = transform.toMapCoordinates(self.selectRect.left(), self.selectRect.top())
        ur = transform.toMapCoordinates(self.selectRect.right(), self.selectRect.top())

        # Rubber band
        self.rubberBand.reset()
        self.rubberBand.addPoint(ll, False)
        self.rubberBand.addPoint(lr, False)
        self.rubberBand.addPoint(ur, False)
        self.rubberBand.addPoint(ul, False)
        self.rubberBand.addPoint(ll, True)

        self.selectRectMapCoord =     QgsRectangle(ll, ur)


    def show_progressBar(self):
        ''' Show progress bar '''
        
        widget = self.iface.messageBar().createMessage("In progress"," Executing SQL . . .")
        prgBar = QProgressBar()
        prgBar.setAlignment(Qt.AlignLeft)
        prgBar.setValue(0)
        prgBar.setMaximum(100)           
        widget.layout().addWidget(prgBar)
        self.iface.messageBar().pushWidget(widget, self.iface.messageBar().INFO)
        
        for i in range(1,10):
            #errCount += 1
            print i
            time.sleep(1.1)
            prgBar.setValue(i*12)

        self.iface.messageBar().clearWidgets()
        self.iface.mapCanvas().refresh()