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
from qgis.core import QgsPoint, QgsFeatureRequest
from qgis.gui import QgsVertexMarker
from PyQt4.QtCore import QPoint, Qt
from PyQt4.QtGui import QApplication, QColor, QAction, QPushButton, QDateEdit, QTimeEdit, QLineEdit, QComboBox, QTextEdit, QMenu,  QTableView, QCompleter,QStringListModel
from qgis.core import QgsProject,QgsMapLayerRegistry,QgsExpression,QgsFeatureRequest

from map_tools.parent import ParentMapTool

from ..ui.mincut import Mincut
#from ..ui.selector_hydro import SelectorHydro
from ..ui.mincut_fin import Mincut_fin
from ..ui.mincut_config import Mincut_config
from ..ui.multi_selector import Multi_selector                  # @UnresolvedImport
from ..ui.mincut_add_hydrometer import Mincut_add_hydrometer

from ..ui.flow_regulator import Flow_regulator

from PyQt4.QtSql import QSqlTableModel, QSqlQueryModel

import utils_giswater
from functools import partial

from PyQt4.Qt import  QDate, QTime

class MincutMapTool(ParentMapTool):
    ''' Button 17. User select one node.
    Execute SQL function: 'gw_fct_delete_node' '''

    def __init__(self, iface, settings, action, index_action):
        ''' Class constructor '''

        # Call ParentMapTool constructor
        super(MincutMapTool, self).__init__(iface, settings, action, index_action)

        # Vertex marker
        self.vertexMarker = QgsVertexMarker(self.canvas)
        self.vertexMarker.setColor(QColor(255, 25, 25))
        self.vertexMarker.setIconSize(12)
        self.vertexMarker.setIconType(QgsVertexMarker.ICON_CIRCLE)  # or ICON_CROSS, ICON_X
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
        (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable

        # That's the snapped point
        if result <> []:

            # Check Arc or Node
            for snapPoint in result:
                ''' *************************
                    CONTROLING RUBBER BAND 
                ************************* '''
                exist=self.snapperManager.check_node_group(snapPoint.layer)
                if exist:
                #if snapPoint.layer.name() == self.layer_node.name():
                    # Get the point
                    point = QgsPoint(result[0].snappedVertex)

                    # Add marker
                    self.vertexMarker.setCenter(point)
                    self.vertexMarker.show()

                    self.elem_type = 'node'
                    self.action = 'mincut'
                    break
                    
                layer_valve_anl = self.iface.activeLayer()    
                if snapPoint.layer.name() == layer_valve_anl.name():
                    point = QgsPoint(result[0].snappedVertex)

                    # Add marker
                    self.vertexMarker.setCenter(point)
                    self.vertexMarker.show()
                    
                    self.elem_type = 'node'
                    self.action = 'customMincut'
                    break
                    
                exist=self.snapperManager.check_connec_group(snapPoint.layer)
                if exist:
                #if snapPoint.layer.name() == self.layer_node.name():
                    # Get the point
                    point = QgsPoint(result[0].snappedVertex)

                    # Add marker
                    self.vertexMarker.setCenter(point)
                    self.vertexMarker.show()

                    self.elem_type = 'connec'
                    self.action = 'addConnec'
                    break
                
                

    def canvasReleaseEvent(self, event):

        # With left click the digitizing is finished
        if event.button() == Qt.LeftButton:

            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            eventPoint = QPoint(x, y)

            snappFeat = None

            # Snapping
            (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable

            # That's the snapped point
            if result <> []:

                # Check feature
                for snapPoint in result:

                    exist=self.snapperManager.check_node_group(snapPoint.layer)
                    #if snapPoint.layer.name() == self.layer_node.name():
                    if exist : 
                        # Get the point
                        point = QgsPoint(result[0].snappedVertex)   #@UnusedVariable
                        snappFeat = next(result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))
                        # LEAVE SELECTION
                        result[0].layer.select([result[0].snappedAtGeometry])
                        break
                        
                    layer_valve_anl = self.iface.activeLayer()    
                    if snapPoint.layer.name() == layer_valve_anl.name():
                        # Get the point
                        point = QgsPoint(result[0].snappedVertex)   #@UnusedVariable
                        snappFeat = next(result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))
                        # LEAVE SELECTION
                        result[0].layer.select([result[0].snappedAtGeometry])
                        break
                        
                    exist=self.snapperManager.check_connec_group(snapPoint.layer)
                    #if snapPoint.layer.name() == self.layer_node.name():
                    if exist : 
                        # Get the point
                        point = QgsPoint(result[0].snappedVertex)   #@UnusedVariable
                        snappFeat = next(result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))
                        # LEAVE SELECTION
                        result[0].layer.select([result[0].snappedAtGeometry])
                        break
  
  
            if snappFeat is not None:
                ''' **********************
                    ACTION ON RELEASE
                ********************** '''
                
                # Get selected features and layer type: 'node'
                feature = snappFeat
                #node_id = feature.attribute('node_id')
                elem_id = feature.attribute(self.elem_type+'_id')

                # ACTION Mincut 
                if self.action == 'mincut':
                    # Execute SQL function
                    function_name = "gw_fct_mincut"
                    sql = "SELECT "+self.schema_name+"."+function_name+"('"+str(elem_id)+"', '"+self.elem_type+"', '"+self.id_text+"');"
                    hold_elem_id = elem_id
                    hold_elem_type = self.elem_type
                    hold_id_text = self.id_text
                    status = self.controller.execute_sql(sql)
      
                    # Refresh map canvas
                    self.iface.mapCanvas().refreshAllLayers()
                    
                    if status:
                        message = "Mincut done successfully"
                        self.controller.show_info(message, context_name='ui_message' ) 

                        # If mincut is done enable CustomMincut
                        self.actionCustomMincut.setDisabled(False)

                    # TRRIGER REPAINT
                    for layerRefresh in self.iface.mapCanvas().layers():
                        layerRefresh.triggerRepaint()
                
                # ACTION customMincut 
                elif self.action == 'customMincut':

                    sql = "INSERT INTO "+self.schema_name+".anl_mincut_result_valve_unaccess (mincut_result_cat_id, valve_id)"
                    sql+= " VALUES ('"+self.id_text+"', '"+elem_id+"')"

                    status = self.controller.execute_sql(sql)
                    if status:
                        # Show message to user
                        message = "Values has been updated"
                        self.controller.show_info(message, context_name='ui_message')
                        
                   
                    # After executing SQL call mincut action again
                    # Execute SQL function
                    function_name = "gw_fct_mincut"
                    # Use elem id of previous element - repeatin automatic mincut
                    sql = "SELECT "+self.schema_name+"."+function_name+"('"+str(hold_elem_id)+"', '"+hold_elem_type+"', '"+hold_id_text+"');"
      
                    status = self.controller.execute_sql(sql)
      
                    # Refresh map canvas
                    self.iface.mapCanvas().refreshAllLayers()
                    
                    if status:
                        message = "Mincut done successfully"
                        self.controller.show_info(message, context_name='ui_message' ) 

                        # If mincut is done enable CustomMincut
                        self.actionCustomMincut.setDisabled(False)

                    # TRRIGER REPAINT
                    for layerRefresh in self.iface.mapCanvas().layers():
                        layerRefresh.triggerRepaint()
                    
                
                # ACTION customMincut 
                elif self.action == 'addConnec':
                    # delete * from anl_mincut_connec
                    sql = "DELETE FROM "+self.schema_name+".anl_mincut_connec"
                    self.controller.execute_sql(sql)

                    #Insert into anl_mincut_connec all selected connecs
                    sql = "INSERT INTO "+self.schema_name+".anl_mincut_connec (connec_id)"
                    sql+= " VALUES ('"+elem_id+"')"
                    status = self.controller.execute_sql(sql)
                    if status:
                        # Show message to user
                        message = "Values has been updated"
                        self.controller.show_info(message, context_name='ui_message')
                        
                    # Execute SQL function
                    function_name = "gw_fct_mincut_result_catalog"
                    sql = "SELECT "+self.schema_name+"."+function_name+"('"+self.id_text+"');"
                    
                    status = self.controller.execute_sql(sql)
                    
                    if status:
                        message = "Execute gw_fct_mincut_result_catalog done successfully"
                        self.controller.show_info(message, context_name='ui_message' ) 


                    
                
                    
    def activate(self):

        # Check button
        self.action().setChecked(True)

        # Store user snapping configuration
        self.snapperManager.storeSnappingOptions()
        
        # Clear snapping
        self.snapperManager.clearSnapping()
        
        '''
        # Set snapping to node
        self.snapperManager.snapToNode()

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Select the node inside a pipe by clicking on it and it will be removed"
            self.controller.show_warning(message, context_name='ui_message')
        '''       
        # Control current layer (due to QGIS bug in snapping system)
        if self.canvas.currentLayer() == None:
            self.iface.setActiveLayer(self.layer_node_man[0])
        
            
        ''' *****************
            SET DIALOG
        ***************** '''
            
        # Create the dialog and signals
        self.dlg = Mincut()
        utils_giswater.setDialog(self.dlg)
        # Set QMainWindow always on top
        self.dlg.setWindowFlags(Qt.WindowStaysOnTopHint)
        
        # Toolbar actions
        self.dlg.findChild(QAction, "actionConfig").triggered.connect(self.config)
        self.dlg.findChild(QAction, "actionMincut").triggered.connect(self.mincut)
        self.actionCustomMincut = self.dlg.findChild(QAction, "actionCustomMincut")
        self.actionCustomMincut.triggered.connect(self.customMincut)
        self.dlg.findChild(QAction, "actionAddConnec").triggered.connect(self.addConnec)
        self.dlg.findChild(QAction, "actionAddHydrometer").triggered.connect(self.addHydrometer)

        self.id = self.dlg.findChild(QLineEdit, "id")
        
        
        
        # **************
        self.btn_accept_main = self.dlg.findChild(QPushButton, "btn_accept")
        self.btn_cancel_main = self.dlg.findChild(QPushButton, "btn_cancel")
        
        self.btn_accept_main.clicked.connect(self.accept_save_data)
        self.btn_cancel_main.clicked.connect(self.dlg.close)

        
        self.dlg.findChild(QPushButton, "btn_start").clicked.connect(self.real_start)
        self.btn_start = self.dlg.findChild(QPushButton, "btn_start")  
        self.btn_start.clicked.connect(self.real_start)
        self.dlg.findChild(QPushButton, "btn_end").clicked.connect(self.real_end)
       
        self.btn_end = self.dlg.findChild(QPushButton, "btn_end")  
        
        self.btn_end.clicked.connect(self.real_end)
        
        # Get current date
        date_start = QDate.currentDate()
        
        self.cbx_date_start = self.dlg.findChild(QDateEdit, "cbx_date_start")
        self.cbx_date_start.setDate(date_start)
        self.cbx_hours_start = self.dlg.findChild(QTimeEdit, "cbx_hours_start")
        
        self.cbx_date_end = self.dlg.findChild(QDateEdit, "cbx_date_end")
        self.cbx_date_end.setDate(date_start)
        self.cbx_hours_end = self.dlg.findChild(QTimeEdit, "cbx_hours_end")
        
        # Widgets for predict date
        self.cbx_date_start_predict = self.dlg.findChild(QDateEdit, "cbx_date_start_predict")
        self.cbx_date_start_predict.setDate(date_start)
        self.cbx_hours_start_predict = self.dlg.findChild(QTimeEdit, "cbx_hours_start_predict")
        
        self.cbx_date_start_predict_2 = self.dlg.findChild(QDateEdit, "cbx_date_start_predict_2")
        self.cbx_date_start_predict_2.setDate(date_start)

        # Widgets for real date
        self.cbx_date_end_predict = self.dlg.findChild(QDateEdit, "cbx_date_end_predict")
        self.cbx_date_end_predict.setDate(date_start)
        self.cbx_hours_end_predict = self.dlg.findChild(QTimeEdit, "cbx_hours_end_predict")
        
     
        # Widgets for predict date
        #self.cbx_date_start = self.dlg.findChild(QDateEdit, "cbx_date_start_predict")
        #self.cbx_hours_start = self.dlg.findChild(QTimeEdit, "cbx_hours_start_predict")
     
        
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
        utils_giswater.fillComboBoxDefault("type", rows) 
        
        # Fill ComboBox cause
        sql = "SELECT id"
        sql+= " FROM "+ self.schema_name + ".anl_mincut_result_cat_cause"
        sql+= " ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBoxDefault("cause", rows) 
        
        # Open the dialog
        #self.dlg.exec_() 
        self.dlg.show() 


    def deactivate(self):
 
        # Check button
        self.action().setChecked(False)

        # Restore previous snapping
        self.snapperManager.recoverSnappingOptions()

        # Recover cursor
        self.canvas.setCursor(self.stdCursor)

        # Removehighlight
        self.h = None   
      

    def mincut(self):
    
        ''' ********************
            ACTIVATE SNAPPING
        ******************** '''
        
        # Clear snapping
        self.snapperManager.clearSnapping()
        
        # Check if user enter id
        self.id_text = self.id.text()
                
        if self.id_text == "id":
            message = "You need to enter id"
            self.controller.show_info_box(message, context_name='ui_message')
        else : 
            # Set snapping to node
            self.snapperManager.snapToNode()

            # Change cursor
            self.canvas.setCursor(self.cursor)

            
    def customMincut(self):

        # Clear snapping
        self.snapperManager.clearSnapping()

        # Set active layer
        layer = QgsMapLayerRegistry.instance().mapLayersByName("Valve analytics")[0]
        self.iface.setActiveLayer(layer)

        # Set snapping - just Valve analytics
        QgsProject.instance().blockSignals(True)
        if layer.name() == 'Valve analytics':
            QgsProject.instance().setSnapSettingsForLayer(layer.id(), True, 2, 2, 1.0, False)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snapSettingsChanged.emit()  # update the gui

        # Change cursor
        self.canvas.setCursor(self.cursor)
        
        
    def addConnec(self):
        self.id_text = self.id.text()

        if self.id_text == "id":
            message = "You need to enter id"
            self.controller.show_info_box(message, context_name='ui_message')
            
        else : 
            # Set snapping to node
            self.snapperManager.snapToConnec()

            # Change cursor
            self.canvas.setCursor(self.cursor)
        
        
    def addHydrometer(self):
        self.dlg_hydro = Mincut_add_hydrometer()
        utils_giswater.setDialog(self.dlg_hydro)
        
        table = "rtc_hydrometer"

        self.tbl = self.dlg_hydro.findChild(QTableView, "tbl")

        #self.btn_cancel = self.dlg_hydro.findChild(QPushButton, "btn_cancel")
        #self.btn_cancel.pressed.connect(self.close_dialog_multi)


        self.btn_delete_hydro = self.dlg_hydro.findChild(QPushButton, "btn_delete")
        self.btn_delete_hydro.pressed.connect(partial(self.delete_records, self.tbl, table))
        
        self.btn_insert_hydro = self.dlg_hydro.findChild(QPushButton, "btn_insert")
        self.hydro_ids = []
        self.btn_insert_hydro.pressed.connect(partial(self.fill_table,self.tbl, self.schema_name+"."+table))
        
        self.btn_accept = self.dlg_hydro.findChild(QPushButton, "btn_accept")
        self.btn_accept.pressed.connect(self.exec_hydro)
        
        self.hydrometer = self.dlg_hydro.findChild(QLineEdit, "hydrometer_id" )
        # Adding auto-completion to a QLineEdit
        self.completer = QCompleter()
        self.hydrometer.setCompleter(self.completer)
        model = QStringListModel()
        sql = "SELECT DISTINCT(hydrometer_id) FROM "+self.schema_name+".rtc_hydrometer "
        row = self.controller.get_rows(sql)
        values= []
        for value in row:
            values.append(str(value[0]))

        model.setStringList(values)
        self.completer.setModel(model)
        
        # Set signal to reach selected value from QCompleter
        #self.completer.activated.connect(self.autocomplete)
        
       
        #self.fill_table(self.tbl, self.schema_name+"."+table)
        self.dlg_hydro.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_hydro.show() 
        

    def fill_table(self, widget, table_name):
        ''' Set a model with selected filter.
        Attach that model to selected table '''
        expr = ""
        hydro_id = self.hydrometer.text()
        self.hydro_ids.append(hydro_id)
        message = str(self.hydro_ids)
        self.controller.show_info(message, context_name='ui_message' )
        if hydro_id == "":
            message = "You need to enter id"
            self.controller.show_info_box(message, context_name='ui_message')
            return
        expr = "hydrometer_id = '"+self.hydro_ids[0]+"'"
        if len(self.hydro_ids) > 1:
            for id in range(1,len(self.hydro_ids)):
                expr +=" OR hydrometer_id = '"+self.hydro_ids[id]+"'"
        
        #expr = "hydrometer_id = '368' OR hydrometer_id = '334' OR hydrometer_id = '675'"
        # Set model
        message = str(expr)
        self.controller.show_info(message, context_name='ui_message' )
        
        model = QSqlTableModel();
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)

        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

        # Attach model to table view
        widget.setModel(model)
        
        
        widget.model().setFilter(expr)
        widget.model().select()
        
        
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
            id_ = widget.model().record(row).value("hydrometer_id")
            inf_text+= str(id_)+", "
            list_id = list_id+"'"+str(id_)+"', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        answer = self.controller.ask_question("Are you sure you want to delete these records?", "Delete records", inf_text)
        '''
        if answer:
            sql = "DELETE FROM "+self.schema_name+"."+table_name
            sql+= " WHERE id IN ("+list_id+")"
            self.controller.execute_sql(sql)
            widget.model().select()
        '''
        if answer:
            #self.hydro_ids.append(hydro_id)
            #if b exists in array
            #remove b and elements after
            '''
            if str(inf_text) in self.hydro_ids:
                del self.hydro_ids[self.hydro_ids.index(str(inf_text)):]
            '''
            if str(inf_text) in self.hydro_ids:

                del self.hydro_ids[self.hydro_ids.index(str(inf_text)):]

        # Reload table
        
        expr = "hydrometer_id = '"+self.hydro_ids[0]+"'"
        if len(self.hydro_ids) > 1:
            for id in range(1,len(self.hydro_ids)):
                expr +=" OR hydrometer_id = '"+self.hydro_ids[id]+"'"                
        
        widget.model().setFilter(expr)
        widget.model().select()
      
    def exec_hydro(self):
        # delete * from anl_mincut_hydrometer
        sql = "DELETE FROM "+self.schema_name+".anl_mincut_result_hydrometer"
        self.controller.execute_sql(sql)
        
        for id in self.hydro_ids:
            #Insert into anl_mincut_hydrometer all selected connecs
            sql = "INSERT INTO "+self.schema_name+".anl_mincut_result_hydrometer (hydrometer_id)"
            sql+= " VALUES ('"+id+"')"
            status_insert = self.controller.execute_sql(sql)
            
            if status_insert:
                # Show message to user
                #message = "Values has been updated"
                #self.controller.show_info(message, context_name='ui_message')
                            
                # Execute SQL function
                self.id = self.dlg.findChild(QLineEdit, "id")
                self.id_text = self.id.text()
                function_name = "gw_fct_mincut_result_catalog"
                sql = "SELECT "+self.schema_name+"."+function_name+"('"+self.id_text+"');"
                        
                status = self.controller.execute_sql(sql)
               
            if status:
                # Show message to user
                message = "Values has been updated"
                self.controller.show_info(message, context_name='ui_message')
                
                message = "Execute gw_fct_mincut_result_catalog done successfully"
                self.controller.show_info(message, context_name='ui_message' )
        
        
    def config(self):
        # Create the dialog and signals config format
        self.dlg_config = Mincut_config()
        utils_giswater.setDialog(self.dlg_config)
        self.dlg_config.setWindowFlags(Qt.WindowStaysOnTopHint)
        
        # Dialog multi_selector
        self.dlg_multi = Multi_selector()
        utils_giswater.setDialog(self.dlg_multi)
        
        
        self.tbl_config = self.dlg_multi.findChild(QTableView, "tbl")
        self.btn_insert =  self.dlg_multi.findChild(QPushButton, "btn_insert")
        self.btn_delete =  self.dlg_multi.findChild(QPushButton, "btn_delete")
       

        # Dialog config
        self.btn_analysis_selector = self.dlg_config.findChild(QPushButton, "btn_analysis_selector")  
        self.btn_analysis_selector.clicked.connect(self.analysis_selector)
        
        self.btn_valve_selector= self.dlg_config.findChild(QPushButton, "btn_valve_selector")  
        self.btn_valve_selector.clicked.connect(self.valve_selector)
        
        self.dlg_config.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_config.open()
        #self.dlg_config.show()
           
        
    def analysis_selector(self):
     
        table= "anl_selector_state"
        self.fill_table_config(self.tbl_config, self.schema_name+"."+table)
        self.menu_analysis=QMenu()
        #self.menu_analysis.clear()
        self.dlg_multi.btn_insert.pressed.connect(partial(self.fill_insert_menu,table)) 

        #self.menu=QMenu()
        #self.menu.clear()
        self.dlg_multi.btn_insert.setMenu(self.menu_analysis)

        self.dlg_multi.btn_delete.pressed.connect(partial(self.delete_records_config, self.tbl_config, table))  

        btn_cancel=self.dlg_multi.findChild(QPushButton,"btn_cancel")
        btn_cancel.pressed.connect(self.dlg_multi.close)
        # Open form
        self.dlg_multi.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_config.close()
        self.dlg_multi.open()
        
        
    def valve_selector(self):
    
        table= "man_selector_valve"
        self.fill_table_config(self.tbl_config, self.schema_name+"."+table)
        self.menu_valve=QMenu()
        #self.menu_valve.clear()
        self.dlg_multi.btn_insert.pressed.connect(partial(self.fill_insert_menu,table)) 
        
        btn_cancel=self.dlg_multi.findChild(QPushButton,"btn_cancel")
        btn_cancel.pressed.connect(self.dlg_multi.close)
        #self.menu=QMenu()
        #self.menu_valve.clear()
        self.dlg_multi.btn_insert.setMenu(self.menu_valve)
        self.dlg_multi.btn_delete.pressed.connect(partial(self.delete_records_config, self.tbl_config, table))  
        # Open form
        self.dlg_config.close()
        
        self.dlg_multi.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_multi.open()
        
        
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
                    
                    
    def delete_records_config(self, widget, table_name):
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
            
            
    def insert(self, id_action, table):
        ''' On action(select value from menu) execute SQL '''
        # Insert value into database
        sql = "INSERT INTO "+self.schema_name+"."+table+" (id) "
        sql+= " VALUES ('"+id_action+"')"
        self.controller.execute_sql(sql)   

        self.fill_table_config(self.tbl_config, self.schema_name+"."+table)

        
    def fill_table_config(self, widget, table_name): 
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


    ''' main DIALOG functions'''
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


        exec_limit_distance =  self.distance.text()
        exec_depth =  self.depth.text()
        
        #exec_descript =  str(utils_giswater.getWidgetText("real_description")) 
        exec_descript = self.real_description.toPlainText()


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
        status = self.controller.execute_sql(sql)
        if status :
            message = "Values has been updated"
            self.controller.show_info(message, context_name='ui_message')
                
        self.dlg.close()
        
        
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
        
   
        self.btn_accept = self.dlg_fin.findChild(QPushButton, "btn_accept")
        self.btn_cancel = self.dlg_fin.findChild(QPushButton, "btn_cancel")
        
        self.btn_accept.clicked.connect(self.accept)
        self.btn_cancel.clicked.connect(self.dlg_fin.close)

        
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
        self.state.setText(str(self.state_values[2][0]))
        
        self.dlg_fin.setWindowFlags(Qt.WindowStaysOnTopHint)
        # Open the dialog
        self.dlg_fin.show()
        
        
    def accept(self):
        # reach end_date and end_hour from mincut_fin dialog
        datestart = self.cbx_date_start_fin.date()
        timestart = self.cbx_hours_start_fin.time()
        dateend = self.cbx_date_end_fin.date()
        timeend = self.cbx_hours_end_fin.time()

        # set new values of date in mincut dialog
        self.cbx_date_start.setDate(datestart)
        self.cbx_hours_start.setTime(timestart)
        self.cbx_date_end.setDate(dateend)
        self.cbx_hours_end.setTime(timeend)

        self.dlg_fin.close()
           
 
