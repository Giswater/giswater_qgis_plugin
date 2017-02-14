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
from qgis.core import QgsPoint, QgsVectorLayer, QgsRectangle, QGis,QgsExpression
from qgis.gui import QgsRubberBand, QgsVertexMarker
from PyQt4.QtCore import QPoint, QRect, Qt
from PyQt4.QtGui import QApplication, QColor, QLineEdit, QCompleter, QDateTimeEdit, QStringListModel
from qgis.gui import QgsMessageBar

from map_tools.parent import ParentMapTool
from ..ui.add_element import Add_element    # @UnresolvedImport

import utils_giswater  


class AddElementMapTool(ParentMapTool):
    ''' Button 33. Add_element '''    

    def __init__(self, iface, settings, action, index_action):
        ''' Class constructor '''

        # Call ParentMapTool constructor
        super(AddElementMapTool, self).__init__(iface, settings, action, index_action)

        self.dragging = False

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

        # Select rectangle
        self.selectRect = QRect()


    def reset(self):
        ''' Clear selected features '''
        layer = self.layer_connec
        if layer is not None:
            layer.removeSelection()

        # Graphic elements
        self.rubberBand.reset()


    ''' QgsMapTools inherited event functions '''

    def canvasMoveEvent(self, event):
        ''' With left click the digitizing is finished '''

        #Plugin reloader bug, MapTool should be deactivated
        if not hasattr(Qt, 'LeftButton'):
            self.iface.actionPan().trigger()
            return

        if event.buttons() == Qt.LeftButton:

            if not self.dragging:
                self.dragging = True
                self.selectRect.setTopLeft(event.pos())

            self.selectRect.setBottomRight(event.pos())
            self.set_rubber_band()

        else:

            # Hide highlight
            self.vertexMarker.hide()

            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            eventPoint = QPoint(x, y)

            # Snapping
            (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  #@UnusedVariable

            # That's the snapped point
            if result <> []:

                # Check Arc or Node
                for snapPoint in result:
                    layer = self.iface.activeLayer()  
                    #exist=self.snapperManager.check_connec_group(snapPoint.layer)
                    #if exist : 
                    if snapPoint.layer == layer:

                        # Get the point
                        point = QgsPoint(result[0].snappedVertex)

                        # Add marker
                        self.vertexMarker.setCenter(point)
                        self.vertexMarker.show()

                        break


    def canvasPressEvent(self, event):   #@UnusedVariable

        self.selectRect.setRect(0, 0, 0, 0)
        self.rubberBand.reset()


    def canvasReleaseEvent(self, event):
        ''' With left click the digitizing is finished '''

        if event.button() == Qt.LeftButton:

            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            eventPoint = QPoint(x, y)

            # Not dragging, just simple selection
            if not self.dragging:

                # Snap to node
                (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  #@UnusedVariable

                # That's the snapped point
                if result <> [] :

                    for snapPoint in result:
                        layer = self.iface.activeLayer()  
                        if snapPoint.layer == layer:
                            point = QgsPoint(result[0].snappedVertex)   #@UnusedVariable
                            #layer.removeSelection()
                            #layer.select([result[0].snappedAtGeometry])
                            result[0].layer.removeSelection()
                            result[0].layer.select([result[0].snappedAtGeometry])
        
                            # Create link
                            #self.link_connec()
                            self.ed_add_element()
    
                        # Hide highlight
                        self.vertexMarker.hide()

            else:

                # Set valid values for rectangle's width and height
                if self.selectRect.width() == 1:
                    self.selectRect.setLeft( self.selectRect.left() + 1 )

                if self.selectRect.height() == 1:
                    self.selectRect.setBottom( self.selectRect.bottom() + 1 )

                self.set_rubber_band()
                selectGeom = self.rubberBand.asGeometry()   #@UnusedVariable
                self.select_multiple_features(self.selectRectMapCoord)
                self.dragging = False
                self.ed_add_element()
                
        elif event.button() == Qt.RightButton:

            # Check selected records
            numberFeatures = 0

            layer = self.iface.activeLayer()
            #for layer in self.layer_connec_man:
            numberFeatures += layer.selectedFeatureCount()

            if numberFeatures > 0:
                answer = self.controller.ask_question("There are " + str(numberFeatures) + " features selected in the connec group, do you want to update values on them?", "Interpolate value")
                if answer:
                    self.ed_add_element()


    def activate(self):

        # Check button
        self.action().setChecked(True)

        # Rubber band
        self.rubberBand.reset()

        # Store user snapping configuration
        self.snapperManager.storeSnappingOptions()

        # Clear snapping
        self.snapperManager.clearSnapping()
        
        layer = self.iface.activeLayer()
        exist = self.snapperManager.check_connec_group(layer)
        if exist: 
            # Set snapping to connec
            self.snapperManager.snapToConnec()  

        exist = self.snapperManager.check_node_group(layer)
        if exist: 
            # Set snapping to node
            self.snapperManager.snapToNode()
            
        exist = self.snapperManager.check_arc_group(layer)
        if exist: 
            # Set snapping to arc
            self.snapperManager.snapToArc()

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Right click to use current selection, select connec points by clicking or dragging (selection box)"
            self.controller.show_info(message, context_name='ui_message')  

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

        self.selectRectMapCoord = QgsRectangle(ll, ur)


    def select_multiple_features(self, selectGeometry):

        if self.layer_connec_man is None:
            return

        # Change cursor
        QApplication.setOverrideCursor(Qt.WaitCursor)

        if QGis.QGIS_VERSION_INT >= 21600:

            # Default choice
            behaviour = QgsVectorLayer.SetSelection

            # Selection for all connec group layers
            layer = self.iface.activeLayer
            exist=self.snapperManager.check_connec_group(layer)
            if exist : 
                for layer in self.layer_connec_man:
                    layer.selectByRect(selectGeometry, behaviour)
            exist=self.snapperManager.check_node_group(layer)
            if exist : 
                for layer in self.layer_node_man:
                    layer.selectByRect(selectGeometry, behaviour)
            exist=self.snapperManager.check_arc_group(layer)
            if exist : 
                for layer in self.layer_arc_man:
                    layer.selectByRect(selectGeometry, behaviour)

        else:
            layer = self.iface.activeLayer
            exist=self.snapperManager.check_connec_group(layer)
            if exist : 
                for layer in self.layer_connec_man:
                    layer.removeSelection()
                    layer.select(selectGeometry, True)
            exist=self.snapperManager.check_node_group(layer)
            if exist : 
                for layer in self.layer_node_man:
                    layer.removeSelection()
                    layer.select(selectGeometry, True)
            exist=self.snapperManager.check_arc_group(layer)
            if exist : 
                for layer in self.layer_arc_man:
                    layer.removeSelection()
                    layer.select(selectGeometry, True)
            

        # Old cursor
        QApplication.restoreOverrideCursor()


    def ed_add_element(self):
        ''' Button 33. Add element '''
          
        # Create the dialog and signals
        self.dlg = Add_element()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.ed_add_element_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)
        
        # Manage i18n of the form
        self.controller.translate_form(self.dlg, 'element')            
        
        # Check if we have at least one feature selected
        if not self.ed_check():
            return
            
        # Fill combo boxes
        self.populate_combo("elementcat_id", "cat_element")
        self.populate_combo("state", "value_state")
        self.populate_combo("location_type", "man_type_location")
        self.populate_combo("workcat_id", "cat_work")
        self.populate_combo("buildercat_id", "cat_builder")
        self.populate_combo("ownercat_id", "cat_owner")
        self.populate_combo("verified", "value_verified")
        self.populate_combo("workcat_id_end", "cat_work")
        
        # Adding auto-completion to a QLineEdit
        self.edit = self.dlg.findChild(QLineEdit, "element_id")
        self.completer = QCompleter()
        self.edit.setCompleter(self.completer)
        model = QStringListModel()
        sql = "SELECT DISTINCT(element_id) FROM "+self.schema_name+".element "
        row = self.dao.get_rows(sql)
        for i in range(0,len(row)):
            aux = row[i]
            row[i] = str(aux[0])
            
        #self.get_date()
        model.setStringList(row)
        self.completer.setModel(model)
        
        # Set signal to reach selected value from QCompleter
        self.completer.activated.connect(self.ed_add_el_autocomplete)
        
        # Open the dialog
        self.dlg.exec_()    
        
        
    def get_date(self):
        ''' Get date_from and date_to from ComboBoxes
        Filter the table related on selected value
        '''

        self.date_document_from = self.dlg.findChild(QDateTimeEdit, "builtdate") 
        self.date_document_to = self.dlg.findChild(QDateTimeEdit, "enddate")     
        
        date_from=self.date_document_from.date() 
        date_to=self.date_document_to.date() 
      
        # TODO:
        if (date_from < date_to):
            expr = QgsExpression('format_date("date",\'yyyyMMdd\') > ' + self.date_document_from.date().toString('yyyyMMdd')+'AND format_date("date",\'yyyyMMdd\') < ' + self.date_document_to.date().toString('yyyyMMdd')+ ' AND "arc_id" ='+ self.arc_id_selected+'' )
        
        else:
            message = "Valid interval!"
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5) 
            return

        
    def ed_add_el_autocomplete(self):    
        ''' Once we select 'element_id' using autocomplete, fill widgets with current values '''

        self.dlg.element_id.setCompleter(self.completer)
        element_id = utils_giswater.getWidgetText("element_id") 
        
        # Get values from database       
        sql = "SELECT elementcat_id, location_type, ownercat_id, state, workcat_id," 
        sql+= " buildercat_id, annotation, observ, comment, link, verified, rotation"
        sql+= " FROM "+self.schema_name+".element" 
        sql+= " WHERE element_id = '"+element_id+"'"
        row = self.dao.get_row(sql)
        
        # Fill widgets
        columns_length = self.dao.get_columns_length()
        for i in range(0, columns_length):
            column_name = self.dao.get_column_name(i)
            utils_giswater.setWidgetText(column_name, row[column_name]) 

    
    def ed_add_element_accept(self):
           
        # Get values from dialog
        element_id = utils_giswater.getWidgetText("element_id")
        elementcat_id = utils_giswater.getWidgetText("elementcat_id")  
        workcat_id_end = utils_giswater.getWidgetText("workcat_id_end") 
        state = utils_giswater.getWidgetText("state")   
        annotation = utils_giswater.getWidgetText("annotation")
        observ = utils_giswater.getWidgetText("observ")
        comment = utils_giswater.getWidgetText("comment")
        location_type = utils_giswater.getWidgetText("location_type")
        workcat_id = utils_giswater.getWidgetText("workcat_id")
        buildercat_id = utils_giswater.getWidgetText("buildercat_id")
        ownercat_id = utils_giswater.getWidgetText("ownercat_id")
        rotation = utils_giswater.getWidgetText("rotation")
        link = utils_giswater.getWidgetText("link")
        verified = utils_giswater.getWidgetText("verified")

        # Check if we already have data with selected element_id
        sql = "SELECT DISTINCT(element_id) FROM "+self.schema_name+".element WHERE element_id = '"+element_id+"'"    
        row = self.dao.get_row(sql)
        if row:
            answer = self.controller.ask_question("Are you sure you want change the data?")
            if answer:
                sql = "UPDATE "+self.schema_name+".element"
                sql+= " SET element_id = '"+element_id+"', elementcat_id= '"+elementcat_id+"',state = '"+state+"', location_type = '"+location_type+"'"
                sql+= ", workcat_id_end= '"+workcat_id_end+"', workcat_id= '"+workcat_id+"',buildercat_id = '"+buildercat_id+"', ownercat_id = '"+ownercat_id+"'"
                sql+= ", rotation= '"+rotation+"',comment = '"+comment+"', annotation = '"+annotation+"', observ= '"+observ+"',link = '"+link+"', verified = '"+verified+"'"
                sql+= " WHERE element_id = '"+element_id+"'" 
                self.dao.execute_sql(sql)  
            else:
                self.close_dialog(self.dlg)
        else:
            sql = "INSERT INTO "+self.schema_name+".element (element_id, elementcat_id, state, location_type"
            sql+= ", workcat_id, buildercat_id, ownercat_id, rotation, comment, annotation, observ, link, verified,workcat_id_end) "
            sql+= " VALUES ('"+element_id+"', '"+elementcat_id+"', '"+state+"', '"+location_type+"', '"
            sql+= workcat_id+"', '"+buildercat_id+"', '"+ownercat_id+"', '"+rotation+"', '"+comment+"', '"
            sql+= annotation+"','"+observ+"','"+link+"','"+verified+"','"+workcat_id_end+"')"
            status = self.controller.execute_sql(sql) 
            if not status:
                message = "Error inserting element in table, you need to review data"
                self.controller.show_warning(message, context_name='ui_message') 
                return
        
        # Add document to selected feature
        self.ed_add_to_feature("element", element_id)
                
        # Show message to user
        message = "Values has been updated"
        self.controller.show_info(message, context_name='ui_message')
        self.close_dialog()