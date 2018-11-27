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
try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4.QtCore import QPoint, Qt, QDate
else:
    from qgis.PyQt.QtCore import QPoint, Qt, QDate
    
from qgis.core import QgsPoint, QgsFeatureRequest

import utils_giswater
from functools import partial
from map_tools.parent import ParentMapTool
from ui_manager import ArcFusion


class DeleteNodeMapTool(ParentMapTool):
    """ Button 17: User select one node. Execute SQL function: 'gw_fct_delete_node' """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        # Call ParentMapTool constructor
        super(DeleteNodeMapTool, self).__init__(iface, settings, action, index_action)



    """ QgsMapTools inherited event functions """
                
    def keyPressEvent(self, event):
        if event.key() == Qt.Key_Escape:
            self.cancel_map_tool()
            return


    def canvasReleaseEvent(self, event):

        if event.button() == Qt.RightButton:
            self.cancel_map_tool()
            return

        # Get the click
        x = event.pos().x()
        y = event.pos().y()
        event_point = QPoint(x, y)
        snapped_feat = None

        # Snapping
        (retval, result) = self.snapper.snapToCurrentLayer(event_point, 2)  # @UnusedVariable
            
        # That's the snapped features
        if result:
            # Get the first feature
            snapped_feat = result[0]
            point = QgsPoint(snapped_feat.snappedVertex)   #@UnusedVariable
            snapped_feat = next(snapped_feat.layer.getFeatures(QgsFeatureRequest().setFilterFid(snapped_feat.snappedAtGeometry)))

        if snapped_feat:
            self.node_id = snapped_feat.attribute('node_id')
            self.dlg_fusion = ArcFusion()
            self.load_settings(self.dlg_fusion)

            # Fill ComboBox workcat_id_end
            sql = ("SELECT id FROM " + self.schema_name + ".cat_work ORDER BY id")
            rows = self.controller.get_rows(sql)
            utils_giswater.fillComboBox(self.dlg_fusion, "workcat_id_end", rows, False)

            # Set QDateEdit to current date
            current_date = QDate.currentDate()
            utils_giswater.setCalendarDate(self.dlg_fusion, "enddate", current_date)

            # Set signals
            self.dlg_fusion.btn_accept.clicked.connect(self.exec_fusion)
            self.dlg_fusion.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_fusion))

            self.dlg_fusion.setWindowFlags(Qt.WindowStaysOnTopHint)
            self.dlg_fusion.open()


    def exec_fusion(self):

        workcat_id_end = self.dlg_fusion.workcat_id_end.currentText()
        enddate = self.dlg_fusion.enddate.date()
        enddate_str = enddate.toString('yyyy-MM-dd')

        # Execute SQL function and show result to the user
        function_name = "gw_fct_arc_fusion"
        row = self.controller.check_function(function_name)
        if not row:
            message = "Database function not found"
            self.controller.show_warning(message, parameter=function_name)
            return
        sql = ("SELECT " + self.schema_name + "." + function_name + "('"
               + str(self.node_id) + "','" + str(workcat_id_end) + "','" + str(enddate_str) + "');")
        status = self.controller.execute_sql(sql, log_sql=True)
        if status:
            message = "Node deleted successfully"
            self.controller.show_info(message)

            # Refresh map canvas
            self.refresh_map_canvas()

        # Deactivate map tool
        self.deactivate()
        self.dlg_fusion.close()
        self.set_action_pan()


    def activate(self):
        self.controller.restore_info()
        # Check button
        self.action().setChecked(True)

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Clear snapping
        self.snapper_manager.clear_snapping()

        # Set active layer to 've_node'
        self.layer_node = self.controller.get_layer_by_tablename("ve_node")
        self.iface.setActiveLayer(self.layer_node)            

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Select the node inside a pipe by clicking on it and it will be removed"
            self.controller.show_info(message)
            

    def deactivate(self):

        # Call parent method     
        ParentMapTool.deactivate(self)
    
