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
from qgis.core import QgsPoint, QgsFeatureRequest, QgsExpression
from qgis.gui import QgsVertexMarker
from PyQt4.QtCore import QPoint, Qt ,QDateTime
from PyQt4.QtGui import QApplication, QColor, QAction, QPushButton, QDateEdit, QTimeEdit, QLineEdit, QComboBox, QTextEdit, QMenu,  QTableView
from PyQt4.Qt import  QDate, QTime

from map_tools.parent import ParentMapTool

from ..ui.mincut import Mincut
from ..ui.mincut_fin import Mincut_fin
from ..ui.mincut_config import Mincut_config
from ..ui.multi_selector import Multi_selector                  # @UnresolvedImport

from datetime import *
from functools import partial

import utils_giswater
from PyQt4.QtSql import QSqlTableModel


class MincutMapTool(ParentMapTool):
    ''' Button 26. User select one node or arc.
    Execute SQL function: 'gw_fct_mincut'
    This function fills 3 temporary tables with id's: node_id, arc_id and valve_id
    Returns and integer: error code
    Get these id's and select them in its corresponding layers '''    

    def __init__(self, iface, settings, action, index_action):  
        ''' Class constructor '''
        
        # Call ParentMapTool constructor     
        super(MincutMapTool, self).__init__(iface, settings, action, index_action)  

        # Vertex marker
        self.vertexMarker = QgsVertexMarker(self.canvas)
        self.vertexMarker.setColor(QColor(255, 25, 25))
        self.vertexMarker.setIconSize(11)
        self.vertexMarker.setIconType(QgsVertexMarker.ICON_BOX) # or ICON_CROSS, ICON_X
        self.vertexMarker.setPenWidth(5)
       
        
        
    ''' QgsMapTools inherited event functions '''

    def canvasMoveEvent(self, event):

        # Hide highlight
        self.vertexMarker.hide()

        # Get the click
        x = event.pos().x()
        y = event.pos().y()

        #Plugin reloader bug, MapTool should be deactivated
        try:
            eventPoint = QPoint(x, y)
        except(TypeError, KeyError):
            self.iface.actionPan().trigger()
            return

        # Snapping        
        (retval,result) = self.snapper.snapToBackgroundLayers(eventPoint)   #@UnusedVariable   
        self.current_layer = None

        # That's the snapped point
        if result <> []:

            # Check Arc or Node
            for snapPoint in result:

                exist_node = self.snapperManager.check_node_group(snapPoint.layer)
                exist_arc  = self.snapperManager.check_arc_group(snapPoint.layer)

                if exist_node or exist_arc:
                #if snapPoint.layer.name() == self.layer_node.name() or snapPoint.layer.name() == self.layer_arc.name():
                    
                    # Get the point
                    point = QgsPoint(result[0].snappedVertex)

                    # Add marker
                    self.vertexMarker.setCenter(point)
                    self.vertexMarker.show()

                    # Data for function
                    self.current_layer = result[0].layer
                    self.snappFeat = next(result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))

                    # Change symbol
                    if exist_node:
                        self.vertexMarker.setIconType(QgsVertexMarker.ICON_CIRCLE)
                    else:
                        self.vertexMarker.setIconType(QgsVertexMarker.ICON_BOX)

                    break


    def canvasReleaseEvent(self, event):
        ''' With left click the digitizing is finished '''
        
        if event.button() == Qt.LeftButton and self.current_layer is not None:

            # Get selected layer type: 'arc' or 'node'
    
            if self.snapperManager.check_arc_group(self.current_layer):
                elem_type = 'arc'
            elif self.snapperManager.check_node_group(self.current_layer):
                elem_type = 'node'
            else:
                message = "Current layer not valid"
                self.controller.show_warning(message, context_name='ui_message')
                return

            feature = self.snappFeat
            elem_id = feature.attribute(elem_type+'_id')

            # Execute SQL function
            function_name = "gw_fct_mincut"
            sql = "SELECT "+self.schema_name+"."+function_name+"('"+str(elem_id)+"', '"+elem_type+"');"

            # Change cursor
            QApplication.setOverrideCursor(Qt.WaitCursor)

            result = self.controller.execute_sql(sql)
            if result:
                # Get 'arc' and 'node' list and select them
                self.mg_mincut_select_features()

            # Old cursor
            QApplication.restoreOverrideCursor()

            # Refresh map canvas
            self.iface.mapCanvas().refreshAllLayers()

            for layerRefresh in self.iface.mapCanvas().layers():
                layerRefresh.triggerRepaint()


    def mg_mincut_select_features(self):

        sql = "SELECT * FROM "+self.schema_name+".anl_mincut_arc ORDER BY arc_id"
        rows = self.controller.get_rows(sql)
        if rows:
    
            # Build an expression to select them
            aux = "\"arc_id\" IN ("
            for elem in rows:
                aux += "'" + elem[0] + "', "
            aux = aux[:-2] + ")"

            # Get a featureIterator from this expression:
            expr = QgsExpression(aux)
            if expr.hasParserError():
                message = "Expression Error: " + str(expr.parserErrorString())
                self.controller.show_warning(message, context_name='ui_message')
                return

            for layer_arc in self.layer_arc_man:

                it = layer_arc.getFeatures(QgsFeatureRequest(expr))
    
                # Build a list of feature id's from the previous result
                id_list = [i.id() for i in it]

                # Select features with these id's
                layer_arc.setSelectedFeatures(id_list)

        sql = "SELECT * FROM " + self.schema_name + ".anl_mincut_node ORDER BY node_id"
        rows = self.controller.get_rows(sql)
        if rows:

            # Build an expression to select them
            aux = "\"node_id\" IN ("
            for elem in rows:
                aux += "'" + elem[0] + "', "
            aux = aux[:-2] + ")"

            # Get a featureIterator from this expression:
            expr = QgsExpression(aux)
            if expr.hasParserError():
                message = "Expression Error: " + str(expr.parserErrorString())
                self.controller.show_warning(message, context_name='ui_message')
                return

            for layer_node in self.layer_node_man:

                it = layer_node.getFeatures(QgsFeatureRequest(expr))

                # Build a list of feature id's from the previous result
                id_list = [i.id() for i in it]

                # Select features with these id's
                layer_node.setSelectedFeatures(id_list)


    def mincut(self):
        ''' mincut function'''
        
        # Store user snapping configuration
        self.snapperManager.storeSnappingOptions()

        # Clear snapping
        self.snapperManager.clearSnapping()

        # Set snapping to arc and node
        self.snapperManager.snapToArc()
        self.snapperManager.snapToNode()

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Select a node or pipe and click on it, the valves minimum cut polygon is computed"
            self.controller.show_info(message, context_name='ui_message' )

        # Control current layer (due to QGIS bug in snapping system)
        if self.canvas.currentLayer() == None:
            self.iface.setActiveLayer(self.layer_node_man[0])
        
        
    def mincut2(self):
        print "valve analytics"
        
    def config(self):
        # Create the dialog and signals config format
        self.dlg_config = Mincut_config()
        utils_giswater.setDialog(self.dlg_config)
        
        # Dialog multi_selector
        self.dlg_multi = Multi_selector()
        utils_giswater.setDialog(self.dlg_multi)
        
        
        self.tbl = self.dlg_multi.findChild(QTableView, "tbl")
        self.btn_insert =  self.dlg_multi.findChild(QPushButton, "btn_insert")
        self.btn_delete =  self.dlg_multi.findChild(QPushButton, "btn_delete")
        

        # Dialog config
        self.btn_analysis_selector = self.dlg_config.findChild(QPushButton, "btn_analysis_selector")  
        self.btn_analysis_selector.clicked.connect(self.analysis_selector)
        
        self.btn_valve_selector= self.dlg_config.findChild(QPushButton, "btn_valve_selector")  
        self.btn_valve_selector.clicked.connect(self.valve_selector)
        
        self.dlg_config.open()
        #self.dlg_config.show()
           
        
    def analysis_selector(self):
        
        table= "anl_selector_state"
        self.fill_table(self.tbl, self.schema_name+"."+table)
        self.menu_analysis=QMenu()
        #self.menu_analysis.clear()
        self.dlg_multi.btn_insert.pressed.connect(partial(self.fill_insert_menu,table)) 
        #self.menu=QMenu()
        #self.menu.clear()
        self.dlg_multi.btn_insert.setMenu(self.menu_analysis)
        self.dlg_multi.btn_delete.pressed.connect(partial(self.delete_records, self.tbl, table))  
        # Open form
        
        self.dlg_config.close()
        self.dlg_multi.open()
        
        
    def valve_selector(self):
    
        table= "man_selector_valve"
        self.fill_table(self.tbl, self.schema_name+"."+table)
        self.menu_valve=QMenu()
        #self.menu_valve.clear()
        self.dlg_multi.btn_insert.pressed.connect(partial(self.fill_insert_menu,table)) 
        #self.menu=QMenu()
        #self.menu_valve.clear()
        self.dlg_multi.btn_insert.setMenu(self.menu_valve)
        self.dlg_multi.btn_delete.pressed.connect(partial(self.delete_records, self.tbl, table))  
        # Open form
        self.dlg_config.close()
        self.dlg_multi.open()
        
        
    def delete_records(self, widget, table_name):
        ''' Delete selected elements of the table '''

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()    
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message' ) 
            return
        
        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = widget.model().record(row).value("id")
            inf_text+= str(id_)+", "
            list_id = list_id+"'"+str(id_)+"', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        answer = self.controller.ask_question("Are you sure you want to delete these records?", "Delete records", inf_text)
        if answer:
            sql = "DELETE FROM "+self.schema_name+"."+table_name 
            sql+= " WHERE id IN ("+list_id+")"
            self.controller.execute_sql(sql)
            widget.model().select()
            
        
    def fill_table(self, widget, table_name): 
        ''' Set a model with selected filter.
        Attach that model to selected table '''
        
        # Set model
        model = QSqlTableModel();
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)        
        model.select()         

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())      

        # Attach model to table view
        widget.setModel(model)    
        
        
    
    def fill_insert_menu(self,table):
        ''' Insert menu on QPushButton->QMenu''' 

        #self.menu.clear()
        
        if table == "anl_selector_state":
            table = "anl_selector_state"
            #self.menu_analysis.clear()
            sql = "SELECT id FROM "+self.schema_name+".value_state"
            sql+= " ORDER BY id"
            rows = self.controller.get_rows(sql) 

            # Fill menu
            for row in rows:   
                elem = row[0]
                # If not exist in table _selector_state isert to menu
                # Check if we already have data with selected id
                sql = "SELECT id FROM "+self.schema_name+"."+table+" WHERE id = '"+elem+"'"    
                rows = self.controller.get_rows(sql)  
     
                if not rows:
                #if rows == None:
                    self.menu_analysis.addAction(elem,partial(self.insert, elem,table))
                    #self.menu.addAction(elem,self.test)
                 
        if table == "man_selector_valve":
            table = "man_selector_valve"
            #self.menu_valve.clear()
            type = "VALVE"
            sql = "SELECT id FROM "+self.schema_name+".node_type WHERE type = '"+type+"'"
            sql+= " ORDER BY id"
            rows = self.controller.get_rows(sql) 

            # Fill menu
            for row in rows:   
                elem = row[0]
                # If not exist in table _selector_state isert to menu
                # Check if we already have data with selected id
                sql = "SELECT id FROM "+self.schema_name+"."+table+" WHERE id = '"+elem+"'"    
                rows = self.controller.get_rows(sql)  
     
                if not rows:
                #if rows == None:
                    self.menu_valve.addAction(elem,partial(self.insert, elem,table))
                    #self.menu.addAction(elem,self.test)


                
    def insert(self, id_action, table):
        ''' On action(select value from menu) execute SQL '''
        # Insert value into database
        sql = "INSERT INTO "+self.schema_name+"."+table+" (id) "
        sql+= " VALUES ('"+id_action+"')"
        self.controller.execute_sql(sql)   
        self.fill_table(self.tbl, self.schema_name+"."+table)
           
        
    def real_start(self):
       
        #date=datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        #print date
        
        self.date_start = QDate.currentDate()
        self.cbx_date_start.setDate(self.date_start)
        
        self.time_start = QTime.currentTime()
        self.cbx_hours_start.setTime(self.time_start)
        
        self.btn_end.setEnabled(True)  

        self.distance.setEnabled(True) 
        self.depth.setEnabled(True) 
        self.real_description.setEnabled(True) 
        
        # set status
        self.state.setText(str(self.state_values[1][0]) )
        
       
    def real_end(self):

        self.date_end = QDate.currentDate()
        self.cbx_date_end.setDate(self.date_end)
        
        self.time_end = QTime.currentTime()
        self.cbx_hours_end.setTime(self.time_end)
        

        
        # Create the dialog and signals
        self.dlg_fin = Mincut_fin()
        utils_giswater.setDialog(self.dlg_fin)
        
        self.cbx_date_start_fin = self.dlg_fin.findChild(QDateEdit, "cbx_date_start_fin")
        self.cbx_hours_start_fin = self.dlg_fin.findChild(QTimeEdit, "cbx_hours_start_fin")
        self.cbx_date_start_fin.setDate(self.date_start)
        self.cbx_hours_start_fin.setTime(self.time_start)
        
        self.cbx_date_end_fin = self.dlg_fin.findChild(QDateEdit, "cbx_date_end_fin")
        self.cbx_hours_end_fin = self.dlg_fin.findChild(QTimeEdit, "cbx_hours_end_fin")
        self.cbx_date_end_fin.setDate(self.date_end)
        self.cbx_hours_end_fin.setTime(self.time_end)   
        
        self.cbx_date_start_predict = self.dlg_fin.findChild(QDateEdit, "cbx_date_start_predict")
        self.cbx_hours_start_predict = self.dlg_fin.findChild(QTimeEdit, "cbx_hours_start_predict")
        
        self.cbx_date_end_predict = self.dlg_fin.findChild(QDateEdit, "cbx_date_end_predict")
        self.cbx_hours_end_predict = self.dlg_fin.findChild(QTimeEdit, "cbx_hours_end_predict")
        
        
        self.btn_accept = self.dlg_fin.findChild(QPushButton, "btn_accept")
        self.btn_cancel = self.dlg_fin.findChild(QPushButton, "btn_cancel")
        
        self.btn_accept.clicked.connect(self.accept)
        
        #self.btn_cancel.clicked.connect(self.close)

        
        # Set values mincut and address
        self.mincut_fin = self.dlg_fin.findChild(QLineEdit, "mincut")
        self.address_fin = self.dlg_fin.findChild(QLineEdit, "address")
        id_fin = self.id.text()
        street_fin = self.street.text()
        number_fin = str(self.number.text())
        address_fin = street_fin +" "+ number_fin
        self.mincut_fin.setText(id_fin)
        self.address_fin.setText(address_fin)
        
        # set status
        self.state.setText(str(self.state_values[2][0]) )
        
        # Open the dialog
        self.dlg_fin.show() 
        
    def accept(self):
        
        print "test"
        # reach end_date and end_hour from mincut_fin dialog
        date = self.cbx_date_end_fin.date()
        time = self.cbx_hours_end_fin.time()  
     
        # set new values of date in mincut dialog
        self.cbx_date_end.setDate(date)
        self.cbx_hours_end.setTime(time)

        self.dlg_fin.close()
        

        
    def activate(self):

        # Check button
        self.action().setChecked(True)
        print "test"
        # Create the dialog and signals
        self.dlg = Mincut()
        utils_giswater.setDialog(self.dlg)
        
        self.btn_accept = self.dlg.findChild(QPushButton, "btn_accept")
        self.btn_cancel = self.dlg.findChild(QPushButton, "btn_cancel")
        
        self.btn_accept.clicked.connect(self.accept_save_data)
        
        #self.dlg.findChild(QPushButton, "btn_start").clicked.connect(self.real_start)
        self.btn_start = self.dlg.findChild(QPushButton, "btn_start")  
        self.btn_start.clicked.connect(self.real_start)
        #self.dlg.findChild(QPushButton, "btn_end").clicked.connect(self.real_end)
        self.btn_end = self.dlg.findChild(QPushButton, "btn_end")  
        self.btn_end.clicked.connect(self.real_end)
               
        # Toolbar actions
        self.dlg.findChild(QAction, "actionConfig").triggered.connect(self.config)
        self.dlg.findChild(QAction, "actionMincut").triggered.connect(self.mincut)
        self.dlg.findChild(QAction, "actionMincut2").triggered.connect(self.mincut2)
        
        self.cbx_date_start = self.dlg.findChild(QDateEdit, "cbx_date_start")
        self.cbx_hours_start = self.dlg.findChild(QTimeEdit, "cbx_hours_start")
        
        self.cbx_date_end = self.dlg.findChild(QDateEdit, "cbx_date_end")
        self.cbx_hours_end = self.dlg.findChild(QTimeEdit, "cbx_hours_end")
        
        
        self.state = self.dlg.findChild(QLineEdit, "state")
        self.id = self.dlg.findChild(QLineEdit, "id")
        self.street = self.dlg.findChild(QLineEdit, "street")
        self.number = self.dlg.findChild(QLineEdit, "number")
        self.pred_description = self.dlg.findChild(QTextEdit, "pred_description")
        self.real_description = self.dlg.findChild(QTextEdit, "real_description")
        self.distance = self.dlg.findChild(QLineEdit, "distance")
        self.depth = self.dlg.findChild(QLineEdit, "depth")
        
        self.exploitation = self.dlg.findChild(QComboBox, "exploitation")
        self.type = self.dlg.findChild(QComboBox, "type")
        self.cause = self.dlg.findChild(QComboBox ,"cause")
        
        # Fill widgets
        sql = "SELECT id FROM " + self.schema_name + ".anl_mincut_result_cat_state"
        self.state_values = self.controller.get_rows(sql)
        self.state.setText(str(self.state_values[0][0]) )

        
         
        
        # Fill ComboBox exploitation
        sql = "SELECT short_descript"
        sql+= " FROM "+ self.schema_name + ".exploitation"
        sql+= " ORDER BY short_descript"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("exploitation", rows)   
        
        # Fill ComboBox type
        sql = "SELECT id"
        sql+= " FROM "+ self.schema_name + ".anl_mincut_result_cat_type"
        sql+= " ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("type", rows) 
        
        # Fill ComboBox cause
        sql = "SELECT id"
        sql+= " FROM "+ self.schema_name + ".anl_mincut_result_cat_cause"
        sql+= " ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("cause", rows) 
        
         
        # Open the dialog
        self.dlg.show() 
        
    def accept_save_data(self):
        
        anl_cause = " "
        mincut_result_state = self.state.text() 
        id = self.id.text()
        #exploitation =
        street = str(self.street.text())
        number = str(self.number.text())
        #address = str(street +" "+ number)
        #mincut_result_type = str(utils_giswater.getWidgetText("type")) 
        #anl_cause = str(utils_giswater.getWidgetText("cause")) 
        mincut_result_type = self.type.currentText()
        anl_cause = self.cause.currentText()

        #anl_descript = str(utils_giswater.getWidgetText("pred_description")) 
        anl_descript = self.pred_description.toPlainText()
        print anl_descript

        exec_limit_distance =  self.distance.text()
        exec_depth =  self.depth.text()
        
        #exec_descript =  str(utils_giswater.getWidgetText("real_description")) 
        exec_descript = self.real_description.toPlainText()
        print exec_descript
        
        # Widgets for predict date
        self.cbx_date_start_predict = self.dlg.findChild(QDateEdit, "cbx_date_start_predict")
        self.cbx_hours_start_predict = self.dlg.findChild(QTimeEdit, "cbx_hours_start_predict")
        
        self.cbx_date_end_predict = self.dlg.findChild(QDateEdit, "cbx_date_end_predict")
        self.cbx_hours_end_predict = self.dlg.findChild(QTimeEdit, "cbx_hours_end_predict")
        
        # Widgets for real date
        self.cbx_date_start = self.dlg.findChild(QDateEdit, "cbx_date_start_predict")
        self.cbx_hours_start = self.dlg.findChild(QTimeEdit, "cbx_hours_start_predict")
        
        self.cbx_date_end = self.dlg.findChild(QDateEdit, "cbx_date_end")
        self.cbx_hours_end = self.dlg.findChild(QTimeEdit, "cbx_hours_end")
        
        # Get prediction date - start
        dateStart_predict=self.cbx_date_start_predict.date()
        timeStart_predict=self.cbx_hours_start_predict.time()
        forecast_start_predict=dateStart_predict.toString('yyyy-MM-dd')+ " "+ timeStart_predict.toString('HH:mm:ss')
        
        # Get prediction date - end
        dateEnd_predict=self.cbx_date_end_predict.date()
        timeEnd_predict=self.cbx_hours_end_predict.time()
        forecast_end_predict=dateEnd_predict.toString('yyyy-MM-dd')+ " "+ timeEnd_predict.toString('HH:mm:ss')
        
        # Get real date - start
        dateStart_real = self.cbx_date_start.date()
        timeStart_real = self.cbx_hours_start.time()
        forecast_start_real = dateStart_real.toString('yyyy-MM-dd')+ " "+ timeStart_real.toString('HH:mm:ss')
        
        # Get real date - end
        dateEnd_real = self.cbx_date_end.date()
        timeEnd_real=self.cbx_hours_end.time()
        forecast_end_real=dateEnd_real.toString('yyyy-MM-dd')+ " "+ timeEnd_real.toString('HH:mm:ss')

        
        sql = "INSERT INTO "+self.schema_name+".anl_mincut_result_cat (mincut_result_state,id,address,address_num,mincut_result_type,anl_cause,forecast_start,forecast_end,anl_descript,exec_start,exec_end,exec_limit_distance,exec_depth,exec_descript) "
        sql+= " VALUES ('"+mincut_result_state+"','"+id+"','"+street+"','"+number+"','"+mincut_result_type+"','"+anl_cause+"','"+forecast_start_predict+"','"+forecast_end_predict+"','"+anl_descript+"','"+forecast_start_real+"','"+forecast_end_real+"','"+exec_limit_distance+"','"+exec_depth+"','"+exec_descript+"')"
        self.controller.execute_sql(sql)
 
        self.dlg.close()
        

    def deactivate(self):

        # Check button
        self.action().setChecked(False)

        # Restore previous snapping
        self.snapperManager.recoverSnappingOptions()

        # Recover cursor
        self.canvas.setCursor(self.stdCursor)

        # Remove highlight
        self.h = None
        
        