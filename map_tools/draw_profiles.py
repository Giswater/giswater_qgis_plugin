"""
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
    from PyQt4.QtCore import QPoint, Qt, SIGNAL
    from PyQt4.QtGui import QListWidget, QListWidgetItem, QLineEdit
    from PyQt4.QtXml import QDomDocument
    from qgis.core import QgsComposition
else:
    from qgis.PyQt.QtCore import QPoint, Qt
    from qgis.PyQt.QtWidgets import QListWidget, QListWidgetItem, QLineEdit
    from qgis.PyQt.QtXml import QDomDocument
    
from qgis.core import QgsPoint, QgsFeatureRequest, QgsVectorLayer
from qgis.gui import  QgsMapToolEmitPoint, QgsVertexMarker

from functools import partial
from decimal import Decimal
import matplotlib.pyplot as plt
import math
import os

import utils_giswater
from giswater.map_tools.parent import ParentMapTool
from giswater.ui_manager import DrawProfile
from giswater.ui_manager import LoadProfiles


class DrawProfiles(ParentMapTool):
    """ Button 43: Draw_profiles """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        # Call ParentMapTool constructor
        super(DrawProfiles, self).__init__(iface, settings, action, index_action)

        self.list_of_selected_nodes = []
        self.nodes = []


    def activate(self):
        self.controller.restore_info()
        # Remove all selections on canvas
        self.remove_selection()

        # Get version of pgRouting
        sql = "SELECT version FROM pgr_version()"
        row = self.controller.get_row(sql)
        if not row:
            message = "Error getting pgRouting version"
            self.controller.show_warning(message)
            return
        self.version = str(row[0][:1])

        # Set dialog
        self.dlg_draw_profile = DrawProfile()
        self.load_settings(self.dlg_draw_profile)
        self.dlg_draw_profile.setWindowFlags(Qt.WindowStaysOnTopHint)

        # Set icons
        self.set_icon(self.dlg_draw_profile.btn_add_start_point, "111")
        self.set_icon(self.dlg_draw_profile.btn_add_end_point, "111")
        self.set_icon(self.dlg_draw_profile.btn_add_additional_point, "111")
        self.set_icon(self.dlg_draw_profile.btn_delete_additional_point, "112")

        self.widget_start_point = self.dlg_draw_profile.findChild(QLineEdit, "start_point")
        self.widget_end_point = self.dlg_draw_profile.findChild(QLineEdit, "end_point")
        self.widget_additional_point = self.dlg_draw_profile.findChild(QListWidget, "list_additional_points")

        start_point = QgsMapToolEmitPoint(self.canvas)
        end_point = QgsMapToolEmitPoint(self.canvas)
        self.start_end_node = [None, None]

        # Set signals
        self.dlg_draw_profile.rejected.connect(partial(self.close_dialog, self.dlg_draw_profile))
        self.dlg_draw_profile.btn_add_start_point.clicked.connect(partial(self.activate_snapping, start_point))
        self.dlg_draw_profile.btn_add_end_point.clicked.connect(partial(self.activate_snapping, end_point))
        self.dlg_draw_profile.btn_add_start_point.clicked.connect(partial(self.activate_snapping_node, self.dlg_draw_profile.btn_add_start_point))
        self.dlg_draw_profile.btn_add_end_point.clicked.connect(partial(self.activate_snapping_node, self.dlg_draw_profile.btn_add_end_point))
        self.dlg_draw_profile.btn_add_additional_point.clicked.connect(partial(self.activate_snapping, start_point))
        self.dlg_draw_profile.btn_add_additional_point.clicked.connect(partial(self.activate_snapping_node, self.dlg_draw_profile.btn_add_additional_point))
        self.dlg_draw_profile.btn_delete_additional_point.clicked.connect(self.delete_additional_point)
        self.dlg_draw_profile.btn_save_profile.clicked.connect(self.save_profile)
        self.dlg_draw_profile.btn_load_profile.clicked.connect(self.load_profile)

        self.dlg_draw_profile.btn_draw.clicked.connect(self.execute_profiles)
        self.dlg_draw_profile.btn_clear_profile.clicked.connect(self.clear_profile)
        self.dlg_draw_profile.btn_export_pdf.clicked.connect(self.export_pdf)
        self.dlg_draw_profile.btn_export_pdf.clicked.connect(self.save_rotation_vdefault)

        # Plugin path
        plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))

        # Fill ComboBox cbx_template with templates *.qpt from ...giswater/templates
        template_folder = plugin_path + os.sep + "templates"
        template_files = os.listdir(template_folder)
        self.files_qpt = [i for i in template_files if i.endswith('.qpt')]

        self.dlg_draw_profile.cbx_template.clear()
        self.dlg_draw_profile.cbx_template.addItem('')
        for template in self.files_qpt:
            self.dlg_draw_profile.cbx_template.addItem(str(template))

            self.dlg_draw_profile.cbx_template.currentIndexChanged.connect(self.set_template)

        self.layer_node = self.controller.get_layer_by_tablename("ve_node")
        self.layer_arc = self.controller.get_layer_by_tablename("ve_arc")
        
        self.nodes = []
        self.list_of_selected_nodes = []

        self.dlg_draw_profile.open()


    def save_profile(self):
        """ Save profile """
        
        profile_id = self.dlg_draw_profile.profile_id.text()
        start_point = self.widget_start_point.text()
        end_point = self.widget_end_point.text()
        
        # Check if all data are entered
        if profile_id == '' or start_point == '' or end_point == '':
            message = "Some data is missing"
            self.controller.show_info_box(message, "Info")
            return
        
        # Check if id of profile already exists in DB
        sql = ("SELECT DISTINCT(profile_id)"
               " FROM " + self.schema_name + ".anl_arc_profile_value"
               " WHERE profile_id = '" + profile_id + "'")
        row = self.controller.get_row(sql)
        if row:
            message = "Selected 'profile_id' already exist in database"
            self.controller.show_warning(message, parameter=profile_id)
            return

        list_arc = []
        n = self.dlg_draw_profile.tbl_list_arc.count()
        for i in range(n):
            list_arc.append(str(self.dlg_draw_profile.tbl_list_arc.item(i).text()))

        sql = ""
        for i in range(n):
            sql += ("INSERT INTO " + self.schema_name + ".anl_arc_profile_value (profile_id, arc_id, start_point, end_point) "
                    " VALUES ('" + profile_id + "', '" + list_arc[i] + "', '" + start_point + "', '" + end_point + "');\n")
        status = self.controller.execute_sql(sql) 
        if not status:
            message = "Error inserting profile table, you need to review data"
            self.controller.show_warning(message)
            return
      
        # Show message to user
        message = "Values has been updated"
        self.controller.show_info(message)
        self.deactivate()
        
        
    def load_profile(self):
        """ Open dialog load_profiles.ui """

        self.dlg_load = LoadProfiles()
        self.load_settings(self.dlg_load)

        self.dlg_load.rejected.connect(partial(self.close_dialog, self.dlg_load.rejected))
        self.dlg_load.btn_open.clicked.connect(self.open_profile)
        self.dlg_load.btn_delete_profile.clicked.connect(self.delete_profile)
        
        sql = "SELECT DISTINCT(profile_id) FROM " + self.schema_name + ".anl_arc_profile_value"
        rows = self.controller.get_rows(sql)
        if rows:
            for row in rows:
                item_arc = QListWidgetItem(str(row[0]))
                self.dlg_load.tbl_profiles.addItem(item_arc)

        self.dlg_load.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_load.open()
        self.deactivate()


    def open_profile(self):
        """ Open selected profile from dialog load_profiles.ui """

        selected_list = self.dlg_load.tbl_profiles.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        # Selected item from list 
        selected_profile = self.dlg_load.tbl_profiles.currentItem().text()

        # Get data from DB for selected item| profile_id, start_point, end_point
        sql = ("SELECT start_point, end_point"
               " FROM " + self.schema_name + ".anl_arc_profile_value" 
               " WHERE profile_id = '" + selected_profile + "'")
        row = self.controller.get_row(sql)
        if not row:
            return
        
        start_point = row['start_point']
        end_point = row['end_point']
        
        # Fill widgets of form draw_profile | profile_id, start_point, end_point
        self.widget_start_point.setText(str(start_point))
        self.widget_end_point.setText(str(end_point))
        self.dlg_draw_profile.profile_id.setText(str(selected_profile))

        # Get all arcs from selected profile
        sql = ("SELECT arc_id"
               " FROM " + self.schema_name + ".anl_arc_profile_value"
               " WHERE profile_id = '" + selected_profile + "'")
        rows = self.controller.get_rows(sql)
        if not rows:
            return

        arc_id = []
        for row in rows:
            arc_id.append(str(row[0]))

        # Select arcs of the shortest path
        for element_id in arc_id:
            sql = ("SELECT sys_type"
                   " FROM " + self.schema_name + ".ve_arc"
                   " WHERE arc_id = '" + str(element_id) + "'")
            row = self.controller.get_row(sql)
            if not row:
                return
            
            # Select feature from v_edit_man_@sys_type
            sys_type = str(row[0].lower())
            viewname = "v_edit_man_" + str(sys_type)
            self.layer_feature = self.controller.get_layer_by_tablename(viewname)
            aux = ""
            for row in arc_id:
                aux += "arc_id = '" + str(row) + "' OR "
            aux = aux[:-3] + ""

            # Select snapped features
            selection = self.layer_feature.getFeatures(QgsFeatureRequest().setFilterExpression(aux))
            self.layer_feature.setSelectedFeatures([a.id() for a in selection])

        node_id = []
        for element_id in arc_id:
            sql = ("SELECT node_1, node_2"
                   " FROM " + self.schema_name + ".arc"
                   " WHERE arc_id = '" + str(element_id) + "'")
            row = self.controller.get_row(sql)
            node_id.append(row[0])
            node_id.append(row[1])
            if not row:
                return

        # Remove duplicated nodes
        singles_list = []
        for element in node_id:
            if element not in singles_list:
                singles_list.append(element)
        node_id = []
        node_id = singles_list

        # Select nodes of shortest path on layers v_edit_man_|feature
        for element_id in node_id:
            sql = ("SELECT sys_type"
                   " FROM " + self.schema_name + ".ve_node"
                   " WHERE node_id = '" + str(element_id) + "'")
            row = self.controller.get_row(sql)
            if not row:
                return
            
            # Select feature from v_edit_man_@sys_type
            sys_type = str(row[0].lower())
            viewname = "v_edit_man_" + str(sys_type)
            self.layer_feature = self.controller.get_layer_by_tablename(viewname)
            aux = ""
            for row in node_id:
                aux += "node_id = '" + str(row) + "' OR "
            aux = aux[:-3] + ""

            # Select snapped features
            selection = self.layer_feature.getFeatures(QgsFeatureRequest().setFilterExpression(aux))
            self.layer_feature.setSelectedFeatures([a.id() for a in selection])

        # Select arcs of shortest path on ve_arc for ZOOM SELECTION
        expr_filter = "\"arc_id\" IN ("
        for i in range(len(arc_id)):
            expr_filter += "'" + str(arc_id[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"
        (is_valid, expr) = self.check_expression(expr_filter, True)   #@UnusedVariable       
        if not is_valid:
            return             

        # Build a list of feature id's from the previous result
        # Select features with these id's
        it = self.layer_arc.getFeatures(QgsFeatureRequest(expr))
        self.id_list = [i.id() for i in it]
        self.layer_arc.selectByIds(self.id_list)

        # Center shortest path in canvas - ZOOM SELECTION
        self.canvas.zoomToSelected(self.layer_arc)

        # After executing of profile enable btn_draw
        self.dlg_draw_profile.btn_draw.setDisabled(False)

        # Clear list
        list_arc = []
        self.dlg_draw_profile.tbl_list_arc.clear()

        # Load list of arcs
        for i in range(len(arc_id)):
            item_arc = QListWidgetItem(arc_id[i])
            self.dlg_draw_profile.tbl_list_arc.addItem(item_arc)
            list_arc.append(arc_id[i])

        self.node_id = node_id
        self.arc_id = arc_id

        # Draw profile
        self.paint_event(self.arc_id, self.node_id)

        self.dlg_draw_profile.cbx_template.setDisabled(False)
        self.dlg_draw_profile.btn_export_pdf.setDisabled(False)
        self.dlg_draw_profile.title.setDisabled(False)
        self.dlg_draw_profile.rotation.setDisabled(False)

        self.close_dialog(self.dlg_load)
        

    def activate_snapping(self, emit_point):

        self.canvas.setMapTool(emit_point)
        snapper = self.snapper_manager.get_snapper()

        self.canvas.connect(self.canvas, SIGNAL("xyCoordinates(const QgsPoint&)"), self.mouse_move)
        emit_point.canvasClicked.connect(partial(self.snapping_node, snapper))


    def activate_snapping_node(self, widget):
        
        # Create the appropriate map tool and connect the gotPoint() signal.
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.snapper = self.snapper_manager.get_snapper()

        self.iface.setActiveLayer(self.layer_node)
        self.canvas.connect(self.canvas, SIGNAL("xyCoordinates(const QgsPoint&)"), self.mouse_move)

        # widget = clicked button
        # self.widget_start_point | self.widget_end_point : QLabels
        if str(widget.objectName()) == "btn_add_start_point":
            self.widget_point =  self.widget_start_point
        if str(widget.objectName()) == "btn_add_end_point":
            self.widget_point =  self.widget_end_point
        if str(widget.objectName()) == "btn_add_additional_point":
            self.widget_point =  self.widget_additional_point

        self.emit_point.canvasClicked.connect(self.snapping_node)


    def mouse_move(self, p):

        map_point = self.canvas.getCoordinateTransform().transform(p)
        x = map_point.x()
        y = map_point.y()
        eventPoint = QPoint(x, y)

        # Snapping
        (retval, result) = self.snapper.snapToCurrentLayer(eventPoint, 2)  # @UnusedVariable

        # That's the snapped features
        if result:
            for snapped_point in result:
                if snapped_point.layer == self.layer_node:                
                    point = QgsPoint(snapped_point.snappedVertex)
                    # Add marker
                    self.vertex_marker.setCenter(point)
                    self.vertex_marker.show()
        else:
            self.vertex_marker.hide()


    def snapping_node(self, point):   # @UnusedVariable

        aux = ""
        map_point = self.canvas.getCoordinateTransform().transform(point)
        x = map_point.x()
        y = map_point.y()
        event_point = QPoint(x, y)

        # Snapping
        (retval, result) = self.snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

        # That's the snapped point
        if result:
            # Check feature
            for snapped_point in result:
                if snapped_point.layer == self.layer_node:
                    # Get the point
                    #point = QgsPoint(snapped_point.snappedVertex)
                    snapp_feature = next(snapped_point.layer.getFeatures(
                        QgsFeatureRequest().setFilterFid(snapped_point.snappedAtGeometry)))
                    element_id = snapp_feature.attribute('node_id')
                    self.element_id = str(element_id)
                    # Leave selection
                    #snapped_point.layer.select([snapped_point.snappedAtGeometry])
                    if self.widget_point == self.widget_start_point or self.widget_point == self.widget_end_point:
                        self.widget_point.setText(str(element_id))
                    if self.widget_point == self.widget_additional_point:
                        # Check if node already exist in list of additional points
                        # Clear list, its possible to have just one additional point
                        self.widget_additional_point.clear()
                        item_arc = QListWidgetItem(str(self.element_id))
                        self.widget_additional_point.addItem(item_arc)

                        n = len(self.start_end_node)
                        if n <=2:
                            self.start_end_node.insert(1, str(self.element_id))
                        if n > 2:
                            self.start_end_node[1] = str(self.element_id)
                        self.exec_path()

                    sys_type = snapp_feature.attribute('sys_type').lower()
                    # Select feature of v_edit_man_|feature 
                    viewname = "v_edit_man_" + str(sys_type)
                    self.layer_feature = self.controller.get_layer_by_tablename(viewname)

        # widget = clicked button
        # self.widget_start_point | self.widget_end_point : QLabels
        # start_end_node = [0] : node start | start_end_node = [1] : node end
        if str(self.widget_point.objectName()) == "start_point":
            self.start_end_node[0] = self.widget_point.text()
            aux = "node_id = '" + str(self.start_end_node[0]) + "'"

        if str(self.widget_point.objectName()) == "end_point":
            self.start_end_node[1] = self.widget_point.text()
            aux = "node_id = '" + str(self.start_end_node[0]) + "' OR node_id = '" + str(self.start_end_node[1]) + "'"

        if str(self.widget_point.objectName()) == "list_sdditional_points":
            # After start_point and end_point in self.start_end_node add list of additional points from "cbx_additional_point"
            aux = "node_id = '" + str(self.start_end_node[0]) + "' OR node_id = '" + str(self.start_end_node[1]) + "'"
            for i in range(2, len(self.start_end_node)):
                aux += " OR node_id = '" + str(self.start_end_node[i]) + "'"

        # Select snapped features
        selection = self.layer_feature.getFeatures(QgsFeatureRequest().setFilterExpression(aux))
        self.layer_feature.setSelectedFeatures([k.id() for k in selection])

        self.exec_path()


    def paint_event(self, arc_id, node_id):
        """ Parent function - Draw profiles """

        # Clear plot
        plt.gcf().clear()
        # arc_id ,node_id list of nodes and arc form dijkstra algoritam
        self.set_parameters(arc_id, node_id)

        self.fill_memory()
        self.set_table_parameters()

        # Start drawing
        # Draw first | start node
        # Function self.draw_first_node(start_point, top_elev, ymax, z1, z2, cat_geom1, geom1)
        self.draw_first_node(self.memory[0][0], self.memory[0][1], self.memory[0][2], self.memory[0][3],
                             self.memory[0][4], self.memory[0][5], self.memory[0][6], 0)
        # Draw nodes between first and last node
        # Function self.draw_nodes(start_point, top_elev, ymax, z1, z2, cat_geom1, geom1, index)
        for i in range(1, self.n - 1):
            self.draw_nodes(self.memory[i][0], self.memory[i][1], self.memory[i][2], self.memory[i][3],
                            self.memory[i][4], self.memory[i][5], self.memory[i][6], i,self.memory[i-1][4], self.memory[i-1][5])
            self.draw_arc()
            self.draw_ground()

        # Draw last node
        self.draw_last_node(self.memory[self.n - 1][0], self.memory[self.n - 1][1], self.memory[self.n - 1][2], self.memory[self.n - 2][3],
                            self.memory[self.n - 2][4], self.memory[self.n - 2][5], self.memory[self.n - 1][6], self.n - 1,self.memory[self.n - 2][4], self.memory[self.n - 2][5])
        self.draw_arc()
        self.draw_ground()
        self.draw_table_horizontals()
        self.set_properties()
        self.draw_coordinates()
        self.draw_grid()
        self.plot = plt

        # If file profile.png exist overwrite
        plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
        img_path = plugin_path + "\\templates\\profile.png"
        fig_size = plt.rcParams["figure.figsize"]

        # Set figure width to 10.4  and height to 4.8
        fig_size[0] = 10.4
        fig_size[1] = 4.8
        plt.rcParams["figure.figsize"] = fig_size

        # Save profile with dpi = 300
        plt.savefig(img_path, dpi=300)


    def set_properties(self):
        """ Set properties of main window """

        # Set window name
        self.win = plt.gcf()
        self.win.canvas.set_window_title('Draw Profile')

        # Hide axes
        self.axes = plt.gca()
        self.axes.set_axis_off()

        # Set background color of window
        self.fig1 = plt.figure(1)
        self.fig1.tight_layout()
        self.rect = self.fig1.patch
        self.rect.set_facecolor('white')

        # Set axes
        x_min = round(self.memory[0][0] - self.fix_x - self.fix_x * Decimal(0.15))
        x_max = round(self.memory[self.n - 1][0] + self.fix_x * Decimal(0.15))
        self.axes.set_xlim([x_min, x_max])

        # Set y-axes
        y_min = round(self.min_top_elev - self.z - self.height_row*Decimal(1.5))
        y_max = round(self.max_top_elev +self.height_row*Decimal(1.5))
        self.axes.set_ylim([y_min, y_max + 1 ])


    def set_parameters(self, arc_id, node_id):
        """ Get and calculate parameters and values for drawing """

        self.list_of_selected_arcs = arc_id
        self.list_of_selected_nodes = node_id

        self.gis_length = [0]
        self.start_point = [0]

        # Get arcs between nodes (on shortest path)
        self.n = len(self.list_of_selected_nodes)

        # Get length (gis_length) of arcs and save them in separate list ( self.gis_length )
        for arc_id in self.list_of_selected_arcs:
            # Get gis_length from ve_arc
            sql = ("SELECT gis_length"
                   " FROM " + self.schema_name + ".ve_arc"
                   " WHERE arc_id = '" + str(arc_id) + "'")
            row = self.controller.get_row(sql)
            if row:
                self.gis_length.append(row[0])

        # Calculate start_point (coordinates) of drawing for each node
        n = len(self.gis_length)
        for i in range(1, n):
            x = self.start_point[i - 1] + self.gis_length[i]
            self.start_point.append(x)
            i = i + 1


    def fill_memory(self):
        """ Get parameters from data base. Fill self.memory with parameters postgres """

        self.memory = []
        i = 0
        # Get parameters and fill the memory
        for node_id in self.node_id:
            # self.parameters : list of parameters for one node
            # self.parameters [start_point, top_elev, y_max,z1, z2, cat_geom1, geom1, slope, elev1, elev2,y1 ,y2, node_id, elev]
            parameters = [self.start_point[i], None, None, None, None, None, None, None, None, None, None, None, None, None, None]
            # Get data top_elev ,y_max, elev, nodecat_id from ve_node
            # Change elev to sys_elev
            sql = ("SELECT sys_top_elev AS top_elev, sys_ymax AS ymax, sys_elev, nodecat_id, code"
                   " FROM  " + self.schema_name + ".ve_node"
                   " WHERE node_id = '" + str(node_id) + "'")
            row = self.controller.get_row(sql)
            columns = ['top_elev', 'ymax', 'sys_elev', 'nodecat_id', 'code']

            if row:
                if row[0] is None or row[1] is None or row[2] is None or row[3] is None or row[4] is None:
                    message = "Some parameters are missing for node (Values Defaults used for)"
                    self.controller.show_info_box(message, "Info", node_id)
                # Check if we have all data for drawing
                for x in range(0, len(columns)):
                    if row[x] is None:
                        sql = ("SELECT value::decimal(12,3) FROM  " + self.schema_name + ".config_param_system WHERE parameter = '" + str(columns[x]) + "_vd'")
                        result = self.controller.get_row(sql)
                        row[x] = result[0]

                parameters[1] = row[0]
                parameters[2] = row[1]
                parameters[13] = row[2]
                nodecat_id = row[3]
                parameters[14] = row[4]

            # Get data z1, z2 ,cat_geom1 ,elev1 ,elev2 , y1 ,y2 ,slope from ve_arc
            # Change to elevmax1 and elevmax2
            # Geom1 from cat_node
            sql = ("SELECT geom1"
                   " FROM " + self.schema_name + ".cat_node"
                   " WHERE id = '" + str(nodecat_id) + "'")
            row = self.controller.get_row(sql)
            columns = ['geom1']
            if row:
                if row[0] is None:
                    message = "Some parameters are missing for node catalog (Values Defaults used for)"
                    self.controller.show_info_box(message, "Info", node_id)
                # Check if we have all data for drawing
                for x in range(0, len(columns)):
                    if row[x] is None:
                        sql = ("SELECT value::decimal(12,3) FROM  " + self.schema_name + ".config_param_system WHERE parameter = '" + str(columns[x]) + "_vd'")
                        result = self.controller.get_row(sql)
                        row[x] = result[0]

                parameters[6] = row[0]

            # Set node_id in memory
            parameters[12] = node_id
            self.memory.append(parameters)
            i = i + 1

        n = 0
        for element_id in self.arc_id:

            sql = ("SELECT z1, z2, cat_geom1, sys_elev1, sys_elev2, sys_y1 AS y1, sys_y2 AS y2, slope"
                   " FROM " + self.schema_name + ".ve_arc"
                   " WHERE arc_id = '" + str(element_id) + "'")
            row = self.controller.get_row(sql)
            columns = ['z1','z2','cat_geom1', 'sys_elev1', 'sys_elev2', 'y1', 'y2', 'slope']
            if row:
                # Check if we have all data for drawing
                if row[0] is None or row[1] is None or row[2] is None or row[3] is None or row[4] is None or \
                   row[5] is None or row[6] is None or row[7] is None:
                    message = "Some parameters are missing for arc (Values Defaults used for)"
                    self.controller.show_info_box(message, "Info", element_id)
                for x in range(0, len(columns)):
                    if row[x] is None:
                        sql = ("SELECT value::decimal(12,3) FROM  " + self.schema_name + ".config_param_system WHERE parameter = '" + str(columns[x]) + "_vd'")
                        result = self.controller.get_row(sql)
                        row[x] = result[0]

                self.memory[n][3] = row[0]
                self.memory[n][4] = row[1]
                self.memory[n][5] = row[2]
                self.memory[n][8] = row[3]
                self.memory[n][9] = row[4]
                self.memory[n][10] = row[5
				]
                self.memory[n][11] = row[6]
                self.memory[n][7] = row[7]
                n = n + 1


    def draw_first_node(self, start_point, top_elev, ymax, z1, z2, cat_geom1, geom1, indx): #@UnusedVariable
        """ Draw first node """

        # Draw first node
        x = [0, -(geom1), -(geom1), (geom1), (geom1)]
        y = [top_elev, top_elev, top_elev - ymax, top_elev - ymax, top_elev - ymax + z1]

        x1 = [geom1, geom1, 0]
        y1 = [top_elev - ymax + z1 + cat_geom1, top_elev, top_elev]
        plt.plot(x, y, 'black', zorder=100)
        plt.plot(x1, y1, 'black', zorder=100)

        self.first_top_x = 0
        self.first_top_y = top_elev

        # Draw fixed part of table
        self.draw_fix_table(start_point)


    def draw_fix_table(self, start_point):
        """ Draw fixed part of table """

        # DRAW TABLE - FIXED PART
        # Draw fixed part of table
        self.draw_marks(0)

        # Vertical line [-1,0]
        x = [start_point - self.fix_x * Decimal(0.2), start_point - self.fix_x * Decimal(0.2)]
        y = [self.min_top_elev - 1 * self.height_row, self.min_top_elev - 6 * self.height_row]
        plt.plot(x, y, 'black', zorder=100)

        # Vertical line [-2,0]
        x = [start_point - self.fix_x * Decimal(0.75), start_point - self.fix_x * Decimal(0.75)]
        y = [self.min_top_elev - 2 * self.height_row, self.min_top_elev - 5 * self.height_row]
        plt.plot(x, y, 'black', zorder=100)

        # Vertical line [-3,0]
        x = [start_point - self.fix_x, start_point - self.fix_x]
        y = [self.min_top_elev - 1 * self.height_row, self.min_top_elev - 6 * self.height_row]
        plt.plot(x, y, 'black', zorder=100)

        # Fill the fixed part of table with data - draw text
        # Called just with first node
        self.data_fix_table(start_point)


    def draw_marks(self, start_point):
        """ Draw marks for each node """

        # Vertical line [0,0]
        x = [start_point, start_point]
        y = [self.min_top_elev - 1 * self.height_row,
             self.min_top_elev - 2 * self.height_row - Decimal(0.15) * self.height_row]
        plt.plot(x, y, 'black', zorder=100)

        # Vertical lines [0,0] - marks
        x = [start_point, start_point]
        y = [self.min_top_elev - Decimal(2.9) * self.height_row, self.min_top_elev - Decimal(3.15) * self.height_row]
        plt.plot(x, y, 'black', zorder=100)

        x = [start_point, start_point]
        y = [self.min_top_elev - Decimal(3.9) * self.height_row, self.min_top_elev - Decimal(4.15) * self.height_row]
        plt.plot(x, y, 'black', zorder=100)

        x = [start_point, start_point]
        y = [self.min_top_elev - Decimal(4.9) * self.height_row, self.min_top_elev - Decimal(5.15) * self.height_row]
        plt.plot(x, y, 'black', zorder=100)

        x = [start_point, start_point]
        y = [self.min_top_elev - Decimal(5.9) * self.height_row, self.min_top_elev - Decimal(6.15) * self.height_row]
        plt.plot(x, y, 'black', zorder=100)


    def data_fix_table(self, start_point):  #@UnusedVariable
        """ FILL THE FIXED PART OF TABLE WITH DATA - DRAW TEXT """

        c = (self.fix_x - self.fix_x * Decimal(0.2)) / 2
        plt.text(-(c + self.fix_x * Decimal(0.2)),
                 self.min_top_elev - 1 * self.height_row - Decimal(0.45) * self.height_row, 'DIAMETER', fontsize=7.5,
                 horizontalalignment='center')

        plt.text(-(c + self.fix_x * Decimal(0.2)),
                 self.min_top_elev - 1 * self.height_row - Decimal(0.80) * self.height_row, 'SLP. / LEN.', fontsize=7.5,
                 horizontalalignment='center')

        c = (self.fix_x * Decimal(0.25)) / 2
        plt.text(-(c + self.fix_x * Decimal(0.74)),
                 self.min_top_elev - Decimal(2) * self.height_row - self.height_row * 3 / 2, 'ORDINATES', fontsize=7.5,
                 rotation='vertical', horizontalalignment='center', verticalalignment='center')

        plt.text(-self.fix_x * Decimal(0.70), self.min_top_elev - Decimal(2.05) * self.height_row - self.height_row / 2,
                 'TOP ELEV', fontsize=7.5, verticalalignment='center')
        plt.text(-self.fix_x * Decimal(0.70), self.min_top_elev - Decimal(3.05) * self.height_row - self.height_row / 2,
                 'Y MAX', fontsize=7.5, verticalalignment='center')
        plt.text(-self.fix_x * Decimal(0.70), self.min_top_elev - Decimal(4.05) * self.height_row - self.height_row / 2,
                 'ELEV', fontsize=7.5, verticalalignment='center')

        c = (self.fix_x - self.fix_x * Decimal(0.2)) / 2
        plt.text(-(c + self.fix_x * Decimal(0.2)),
                 self.min_top_elev - Decimal(self.height_row * 5 + self.height_row / 2), 'CODE', fontsize=7.5,
                 horizontalalignment='center', verticalalignment='center')

        # Fill table with values
        self.fill_data(0, 0)


    def draw_nodes(self, start_point, top_elev, ymax, z1, z2, cat_geom1, geom1, indx,z22, cat2):    #@UnusedVariable
        """ Draw nodes between first and last node """

        ytop1 = ymax - z1 - cat_geom1
        # cat_geom_1 from node before
        ytop2 = ymax - z22 - cat2

        x = [start_point, start_point - (geom1), start_point - (geom1)]
        y = [top_elev, top_elev, top_elev  - ymax + z22 + cat2]
        x1 = [start_point - (geom1), start_point - (geom1), start_point + (geom1), start_point + (geom1)]
        y1 = [top_elev - ymax + z22, top_elev - ymax, top_elev - ymax, top_elev - ymax + z1]
        x2 = [start_point + (geom1),start_point + (geom1), start_point]
        y2 = [top_elev - ytop1, top_elev, top_elev]

        plt.plot(x, y, 'black',zorder=100)
        plt.plot(x1, y1, 'black',zorder=100)
        plt.plot(x2, y2, 'black',zorder=100)

        # Index -1 for node before
        self.x = self.memory[indx - 1][6] + self.memory[indx - 1][0]
        self.y = self.memory[indx - 1][1] - self.memory[indx - 1][2] + self.memory[indx - 1][3] + self.memory[indx - 1][5]
        self.x1 = self.memory[indx - 1][6] + self.memory[indx - 1][0]
        self.y1 = self.y1 = self.memory[indx - 1][1] - self.memory[indx - 1][2] + self.memory[indx - 1][3]
        self.x2 = (start_point - (geom1))
        self.y2 = top_elev - ytop2
        self.x3 = (start_point - (geom1))
        self.y3 = top_elev - ymax + z22

        self.node_top_x = start_point
        self.node_top_y = top_elev

        self.first_top_x = self.memory[indx - 1][0]
        self.first_top_y = self.memory[indx - 1][1]

        # DRAW TABLE-MARKS
        self.draw_marks(start_point)

        # Fill table
        self.fill_data(start_point,indx)


    def fill_data(self,start_point,indx):

        # Fill top_elevation and node_id for all nodes
        # Fill top_elevation
        plt.annotate(' ' + '\n' + str(round(self.memory[indx][1], 2)) + '\n' + ' ',
                     xy=(Decimal(start_point), self.min_top_elev - Decimal(self.height_row * 2 + self.height_row / 2)),
                     fontsize=6, rotation='vertical', horizontalalignment='center', verticalalignment='center')

        # Draw node_id
        plt.text(0 + start_point, self.min_top_elev - Decimal(self.height_row * 5 + self.height_row / 2),
                 self.memory[indx][14], fontsize=7.5,
                 horizontalalignment='center', verticalalignment='center')


        # Fill y_max and elevation
        # 1st node : y_max,y2 and top_elev, elev2
        if indx == 0:
            # Fill y_max
            plt.annotate(' ' + '\n' + str(round(self.memory[0][2], 2)) + '\n' + str(round(self.memory[0][10], 2)),
                         xy=(Decimal(0 + start_point),
                             self.min_top_elev - Decimal(self.height_row * 3 + self.height_row / 2)), fontsize=6,
                         rotation='vertical', horizontalalignment='center', verticalalignment='center')

            # Fill elevation
            plt.annotate(' ' + '\n' + str(round(self.memory[0][13], 2)) + '\n' + str(round(self.memory[0][8], 2)),
                         xy=(Decimal(0 + start_point),
                             self.min_top_elev - Decimal(self.height_row * 4 + self.height_row / 2)), fontsize=6,
                         rotation='vertical', horizontalalignment='center', verticalalignment='center')

        # Last node : y_max,y1 and top_elev, elev1
        elif (indx == self.n-1):
            pass
            # Fill y_max
            plt.annotate(str(round(self.memory[indx-1][11], 2)) + '\n' + str(round(self.memory[indx][2], 2)) + '\n' + ' ',
                         xy=(Decimal(0 + start_point),
                             self.min_top_elev - Decimal(self.height_row * 3 + self.height_row / 2)), fontsize=6,
                         rotation='vertical', horizontalalignment='center', verticalalignment='center')

            # Fill elevation
            plt.annotate(str(round(self.memory[indx-1][9], 2)) + '\n' + str(round(self.memory[indx][13], 2)) + '\n' + ' ',
                         xy=(Decimal(0 + start_point),
                             self.min_top_elev - Decimal(self.height_row * 4 + self.height_row / 2)), fontsize=6,
                         rotation='vertical', horizontalalignment='center', verticalalignment='center')
        # Nodes between 1st and last node : y_max,y1,y2 and top_elev, elev1, elev2

        else:
            # Fill y_max
            plt.annotate(str(round(self.memory[indx-1][11], 2)) + '\n' + str(round(self.memory[indx][2], 2)) + '\n' + str(round(self.memory[indx][10], 2)),
                         xy=(Decimal(0 + start_point),
                             self.min_top_elev - Decimal(self.height_row * 3 + self.height_row / 2)), fontsize=6,
                             rotation='vertical', horizontalalignment='center', verticalalignment='center')

            # Fill elevation
            plt.annotate(str(round(self.memory[indx-1][9], 2)) + '\n' + str(round(self.memory[indx][13], 2)) + '\n' + str(round(self.memory[indx][8], 2)),
                         xy=(Decimal(0 + start_point),
                             self.min_top_elev - Decimal(self.height_row * 4 + self.height_row / 2)), fontsize=6,
                             rotation='vertical', horizontalalignment='center', verticalalignment='center')

        # Fill diameter and slope / length for all nodes except last node
        if (indx != self.n - 1):
            # Draw diameter
            center = self.gis_length[indx + 1] / 2
            plt.text(center + start_point, self.min_top_elev - 1*self.height_row - Decimal(0.45)*self.height_row, round(self.memory[indx][5], 2),
                     fontsize=7.5,horizontalalignment='center')  # PUT IN THE MIDDLE PARAMETRIZATION
            # Draw slope / length
            slope = str(round((self.memory[indx][7]*100),2))
            length = str(round(self.gis_length[indx+1],2))

            plt.text(center + start_point, self.min_top_elev - 1*self.height_row - Decimal(0.8)*self.height_row, slope + '%/' + length,
                     fontsize=7.5, horizontalalignment='center')  # PUT IN THE MIDDLE PARAMETRIZATION


    def draw_last_node(self, start_point, top_elev, ymax, z1, z2, cat_geom1, geom1, indx, z22, cat2):  #@UnusedVariable

        x = [start_point, start_point - (geom1), start_point - (geom1)]
        y = [top_elev, top_elev, top_elev  - ymax + z22 + cat2]
        x1 = [start_point - geom1, start_point - geom1, start_point + geom1, start_point + geom1, start_point]
        y1 = [top_elev - ymax + z2, top_elev - ymax, top_elev - ymax, top_elev, top_elev]

        plt.plot(x, y, 'black',zorder=100)
        plt.plot(x1, y1, 'black',zorder=100)

        self.x = self.memory[indx - 1][6] + self.memory[indx - 1][0]
        self.y = self.memory[indx - 1][1] - self.memory[indx - 1][2] + self.memory[indx - 1][3] + self.memory[indx - 1][5]
        self.x1 = self.memory[indx - 1][6] + self.memory[indx - 1][0]
        self.y1 = self.y1 = self.memory[indx - 1][1] - self.memory[indx - 1][2] + self.memory[indx - 1][3]

        ytop2 = ymax - z22 - cat2
        self.x2 = (start_point - (geom1))
        self.y2 = top_elev - ytop2
        self.x3 = (start_point - (geom1))
        self.y3 = top_elev - ymax + z22

        self.first_top_x = self.memory[indx - 1][0]
        self.first_top_y = self.memory[indx - 1][1]

        self.node_top_x = start_point
        self.node_top_y = top_elev

        # DRAW TABLE
        # DRAW TABLE-MARKS
        self.draw_marks(start_point)

        # Fill table
        self.fill_data(start_point, indx)


    def set_table_parameters(self):

        # Search y coordinate min_top_elev ( top_elev- ymax)
        self.min_top_elev = self.memory[0][1] - self.memory[0][2]
        for i in range(1, self.n):
            if (self.memory[i][1] - self.memory[i][2]) < self.min_top_elev:
                self.min_top_elev = self.memory[i][1] - self.memory[i][2]
        # Search y coordinate max_top_elev
        self.max_top_elev = self.memory[0][1]
        for i in range(1, self.n):
            if (self.memory[i][1]) > self.max_top_elev:
                self.max_top_elev = self.memory[i][1]

        # Calculating dimensions of x-fixed part of table
        self.fix_x = Decimal(0.15) * self.memory[self.n - 1][0]

        # Calculating dimensions of y-fixed part of table 
        # Height y = height of table + height of graph
        self.z = self.max_top_elev - self.min_top_elev
        self.height_row = (self.z * Decimal(0.97)) / Decimal(5)

        # Height of graph + table 
        self.height_y = self.z * 2


    def draw_table_horizontals(self):

        self.set_table_parameters()

        # DRAWING TABLE
        # Draw horizontal lines
        x = [self.memory[self.n - 1][0], self.memory[0][0] - self.fix_x]
        y = [self.min_top_elev - self.height_row, self.min_top_elev - self.height_row]
        plt.plot(x, y, 'black',zorder=100)

        x = [self.memory[self.n - 1][0], self.memory[0][0] - self.fix_x]
        y = [self.min_top_elev - 2 * self.height_row, self.min_top_elev - 2 * self.height_row]
        plt.plot(x, y, 'black',zorder=100)

        # Draw horizontal(shorter) lines
        x = [self.memory[self.n - 1][0], self.memory[0][0] - self.fix_x * Decimal(0.75)]
        y = [self.min_top_elev - 3 * self.height_row, self.min_top_elev - 3 * self.height_row]
        plt.plot(x, y, 'black',zorder=100)
        x = [self.memory[self.n - 1][0], self.memory[0][0] - self.fix_x * Decimal(0.75)]
        y = [self.min_top_elev - 4 * self.height_row, self.min_top_elev - 4 * self.height_row]
        plt.plot(x, y, 'black',zorder=100)
        
        # Last two lines
        x = [self.memory[self.n - 1][0], self.memory[0][0] - self.fix_x]
        y = [self.min_top_elev - 5 * self.height_row, self.min_top_elev - 5 * self.height_row]
        plt.plot(x, y, 'black',zorder=100)
        x = [self.memory[self.n - 1][0], self.memory[0][0] - self.fix_x]
        y = [self.min_top_elev - 6 * self.height_row, self.min_top_elev - 6 * self.height_row]
        plt.plot(x, y, 'black',zorder=100)


    def draw_coordinates(self):

        start_point = self.memory[self.n - 1][0]
        geom1 = self.memory[self.n - 1][6]
        
        # Draw coocrdinates
        x = [0, 0]
        y = [self.min_top_elev - 1 * self.height_row, int(math.ceil(self.max_top_elev) + 1 )]
        plt.plot(x, y, 'black',zorder=100)
        x = [start_point,start_point]
        y = [self.min_top_elev - 1 * self.height_row, int(math.ceil(self.max_top_elev) + 1 )]
        plt.plot(x, y, 'black',zorder=100)
        x = [0,start_point]
        y = [int(math.ceil(self.max_top_elev) + 1 ),int(math.ceil(self.max_top_elev) + 1 )]
        plt.plot(x, y, 'black',zorder=100)

        # Loop till self.max_top_elev + height_row
        y = int(math.ceil(self.min_top_elev - 1 * self.height_row))
        x = int(math.floor(self.max_top_elev))
        if x%2 == 0 :
            x = x + 2
        else :
            x = x + 1

        for i in range(y, x):
            if i%2 == 0:
                x1 = [0, start_point]
                y1 = [i, i]
            else:
                i = i+1
                x1 = [0, start_point]
                y1 = [i, i]
            plt.plot(x1, y1, 'lightgray', zorder=1)
            # Values left y_ordinate_all
            plt.text(0 - geom1 * Decimal(1.5), i,str(i), fontsize=7.5, horizontalalignment='right', verticalalignment='center')


    def draw_grid(self):

        # Values right y_ordinate_max
        start_point = self.memory[self.n-1][0]
        geom1 = self.memory[self.n-1][6]
        plt.annotate('P.C. '+str(round(self.min_top_elev - 1 * self.height_row,2)) + '\n' + ' ',
                     xy=(0 - geom1*Decimal(1.5) , self.min_top_elev - 1 * self.height_row),
                     fontsize=6.5, horizontalalignment='right', verticalalignment='center')

        # Values right x_ordinate_min
        plt.annotate('0'+ '\n' + ' ',
                     xy=(0,int(math.ceil(self.max_top_elev) + 1 )),
                     fontsize=6.5, horizontalalignment='center')

        # Values right x_ordinate_max
        plt.annotate(str(round(start_point,2))+ '\n' + ' ',
                     xy=(start_point, int(math.ceil(self.max_top_elev) + 1 ) ),
                     fontsize=6.5, horizontalalignment='center')

        # Loop from 0 to start_point(of last node) 
        x = int(math.floor(start_point))
        # First after 0 (first is drawn ,start from i(0)+1) 
        for i in range(50, x, 50):
            x1 = [i, i]
            y1 = [self.min_top_elev - 1 * self.height_row, int(math.ceil(self.max_top_elev) + 1 )]
            plt.plot(x1, y1, 'lightgray',zorder=1 )
            # values left y_ordinate_all
            plt.text(0 - geom1 * Decimal(1.5), i, str(i), fontsize=6.5, 
                horizontalalignment='right', verticalalignment='center')
            plt.text(start_point + geom1 * Decimal(1.5), i, str(i), fontsize=6.5, 
                horizontalalignment='left', verticalalignment='center')
            # values right x_ordinate_all
            plt.annotate(str(i) + '\n' + ' ', xy=(i, int(math.ceil(self.max_top_elev) + 1 )), 
                fontsize=6.5, horizontalalignment='center')


    def draw_arc(self):
        
        x = [self.x, self.x2]
        y = [self.y, self.y2]
        x1 = [self.x1, self.x3]
        y1 = [self.y1, self.y3]
        plt.plot(x, y, 'black', zorder=100)
        plt.plot(x1, y1, 'black', zorder=100)


    def draw_ground(self):

        # Green triangle
        plt.plot(self.first_top_x,self.first_top_y,'g^',linewidth=3.5)
        plt.plot(self.node_top_x, self.node_top_y, 'g^',linewidth=3.5)
        x = [self.first_top_x, self.node_top_x]
        y = [self.first_top_y, self.node_top_y]
        plt.plot(x, y, 'green', linestyle='dashed')

    
    def shortest_path(self,start_point, end_point):
        """ Calculating shortest path using dijkstra algorithm """
        
        self.arc_id = []
        self.node_id = []
        self.rnode_id = []
        self.rarc_id = []

        rstart_point = None
        sql = ("SELECT rid"
               " FROM " + self.schema_name + ".v_anl_pgrouting_node"
               " WHERE node_id = '" + start_point + "'")
        row = self.controller.get_row(sql)
        if row:
            rstart_point = int(row[0])

        rend_point = None
        sql = ("SELECT rid"
              " FROM " + self.schema_name + ".v_anl_pgrouting_node"
              " WHERE node_id = '" + end_point + "'")
        row = self.controller.get_row(sql)
        if row:
            rend_point = int(row[0])

        # Check starting and end points | wait to select end_point
        if rstart_point is None or rend_point is None:
            return
                    
        # Clear list of arcs and nodes - preparing for new profile
        sql = ("SELECT * FROM public.pgr_dijkstra('SELECT id::integer, source, target, cost" 
               " FROM " + self.schema_name + ".v_anl_pgrouting_arc', "
               + str(rstart_point) + ", " + str(rend_point) + ", false")
        if self.version == '2':
            sql += ", false"
        elif self.version == '3':
            pass
        else:
            message = "You need to upgrade your version of pgRouting"
            self.controller.show_info(message)
            return
        sql += ")"

        rows = self.controller.get_rows(sql)
        for i in range(0, len(rows)):
            if self.version == '2':
                self.rnode_id.append(str(rows[i][1]))
                self.rarc_id.append(str(rows[i][2]))
            elif self.version == '3':
                self.rnode_id.append(str(rows[i][2]))
                self.rarc_id.append(str(rows[i][3]))

        self.rarc_id.pop()
        self.arc_id = []
        self.node_id = []
 
        for n in range(0, len(self.rarc_id)):
            # convert arc_ids
            sql = ("SELECT arc_id"
                   " FROM " + self.schema_name + ".v_anl_pgrouting_arc"
                   " WHERE id = '" +str(self.rarc_id[n]) + "'")
            row = self.controller.get_row(sql)
            if row:
                self.arc_id.append(str(row[0]))
        
        for m in range(0, len(self.rnode_id)):
            # convert node_ids
            sql = ("SELECT node_id"
                   " FROM " + self.schema_name + ".v_anl_pgrouting_node"
                   " WHERE rid = '" + str(self.rnode_id[m]) + "'")
            row = self.controller.get_row(sql)
            if row:
                self.node_id.append(str(row[0]))

        # Select arcs of the shortest path
        for element_id in self.arc_id:
            sql = ("SELECT sys_type"
                   " FROM " + self.schema_name + ".ve_arc"
                   " WHERE arc_id = '" + str(element_id) + "'")
            row = self.controller.get_row(sql)
            if not row:
                return
            
            # Select feature of v_edit_man_@sys_type
            sys_type = str(row[0].lower())
            viewname = "v_edit_man_" + str(sys_type)
            self.layer_feature = self.controller.get_layer_by_tablename(viewname)
            aux = ""
            for row in self.arc_id:
                aux += "arc_id = '" + str(row) + "' OR "
            aux = aux[:-3] + ""

            # Select snapped features
            selection = self.layer_feature.getFeatures(QgsFeatureRequest().setFilterExpression(aux))
            self.layer_feature.setSelectedFeatures([a.id() for a in selection])

        # Select nodes of shortest path on layers v_edit_man_|feature
        for element_id in self.node_id:
            sql = ("SELECT sys_type"
                   " FROM " + self.schema_name + ".ve_node"
                   " WHERE node_id = '" + str(element_id) + "'")
            row = self.controller.get_row(sql)
            if not row:
                return
            
            # Select feature of v_edit_man_@sys_type
            sys_type = str(row[0].lower())
            viewname = "v_edit_man_" + str(sys_type)
            self.layer_feature = self.controller.get_layer_by_tablename(viewname)
            aux = ""
            for row in self.node_id:
                aux += "node_id = '" + str(row) + "' OR "
            aux = aux[:-3] + ""

            # Select snapped features
            selection = self.layer_feature.getFeatures(QgsFeatureRequest().setFilterExpression(aux))
            self.layer_feature.setSelectedFeatures([a.id() for a in selection])

        # Select nodes of shortest path on ve_arc for ZOOM SELECTION
        expr_filter = "\"arc_id\" IN ("
        for i in range(len(self.arc_id)):
            expr_filter += "'" + str(self.arc_id[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"        
        (is_valid, expr) = self.check_expression(expr_filter, True)   #@UnusedVariable       
        if not is_valid:
            return              

        # Build a list of feature id's from the previous result
        # Select features with these id's
        it = self.layer_arc.getFeatures(QgsFeatureRequest(expr))
        self.id_list = [i.id() for i in it]
        self.layer_arc.selectByIds(self.id_list)

        # Center shortest path in canvas - ZOOM SELECTION
        self.canvas.zoomToSelected(self.layer_arc)

        # Clear list
        list_arc = []
        self.dlg_draw_profile.tbl_list_arc.clear()
        
        for i in range(len(self.arc_id)):
            item_arc = QListWidgetItem(self.arc_id[i])
            self.dlg_draw_profile.tbl_list_arc.addItem(item_arc)
            list_arc.append(self.arc_id[i])


    def execute_profiles(self):
        
        # Remove duplicated nodes
        singles_list = []
        for element in self.node_id:
            if element not in singles_list:
                singles_list.append(element)
        self.node_id = []
        self.node_id = singles_list
        self.paint_event(self.arc_id, self.node_id)

        # Maximize window (after drawing)
        self.plot.show()
        mng = self.plot.get_current_fig_manager()
        mng.window.showMaximized()


    def execute_profiles_composer(self):

        # Remove duplicated nodes
        singles_list = []
        for element in self.node_id:
            if element not in singles_list:
                singles_list.append(element)
        self.node_id = []
        self.node_id = singles_list
        self.paint_event(self.arc_id, self.node_id)


    def clear_profile(self):

        # Clear list of nodes and arcs
        self.list_of_selected_nodes = []
        self.list_of_selected_arcs = []
        self.nodes = []
        self.arcs = []
        self.start_end_node = []
        self.start_end_node = [None, None]
        self.dlg_draw_profile.list_additional_points.clear()
        self.dlg_draw_profile.btn_add_start_point.setDisabled(False)
        self.dlg_draw_profile.btn_add_end_point.setDisabled(True)
        self.dlg_draw_profile.btn_add_additional_point.setDisabled(True)
        self.dlg_draw_profile.list_additional_points.setDisabled(True)
        self.dlg_draw_profile.title.setDisabled(True)
        self.dlg_draw_profile.rotation.setDisabled(True)
        self.dlg_draw_profile.btn_export_pdf.setDisabled(True)
        self.dlg_draw_profile.cbx_template.setDisabled(True)
        self.dlg_draw_profile.start_point.clear()
        self.dlg_draw_profile.end_point.clear()
        self.dlg_draw_profile.profile_id.clear()
        
        # Get data from DB for selected item| tbl_list_arc
        self.dlg_draw_profile.tbl_list_arc.clear()
        
        # Clear selection 
        self.remove_selection()
        self.deactivate()


    def generate_composer(self):
        
        # Plugin path
        plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
        composers = self.iface.activeComposers()

        # Check if template is selected
        if str(self.dlg_draw_profile.cbx_template.currentText()) == "":
            message = "You need to select a template"
            self.controller.show_warning(str(message))
            return

        # Check if title
        title = self.dlg_draw_profile.title.text()

        # Check if composer exist
        index = 0
        num_comp = len(composers)
        for comp_view in composers:
            if comp_view.composerWindow().windowTitle() == str(self.template):
                break
            index += 1
            
        if index == num_comp:
            # Create new composer with template selected in combobox(self.template)
            template_path = plugin_path + "\\" + "templates" + "\\" + str(self.template) + ".qpt"
            template_file = file(template_path, 'rt')
            template_content = template_file.read()
            template_file.close()
            document = QDomDocument()
            document.setContent(template_content)
            comp_view = self.iface.createNewComposer(str(self.template))
            comp_view.composition().loadFromTemplate(document)
        index = 0
        composers = self.iface.activeComposers()
        for comp_view in composers:
            if comp_view.composerWindow().windowTitle() == str(self.template):
                break
            index += 1

        comp_view = self.iface.activeComposers()[index]
        composition = comp_view.composition()
        comp_view.composerWindow().show()
        
        # Set profile
        picture_item = composition.getComposerItemById('profile')
        profile = plugin_path + "\\templates\\profile.png"
        picture_item.setPictureFile(profile)

        # Refresh map, zoom map to extent
        map_item = composition.getComposerItemById('Mapa')
        map_item.setMapCanvas(self.canvas)
        map_item.zoomToExtent(self.canvas.extent())

        first_node = self.dlg_draw_profile.start_point.text()
        end_node = self.dlg_draw_profile.end_point.text()

        # Fill data in composer template
        first_node_item = composition.getComposerItemById('first_node')
        first_node_item.setText(str(first_node))
        end_node_item = composition.getComposerItemById('end_node')
        end_node_item.setText(str(end_node))
        length_item = composition.getComposerItemById('length')
        length_item.setText(str(self.start_point[-1]))
        profile_title = composition.getComposerItemById('title')
        profile_title.setText(str(title))

        self.manage_composition(composition, map_item)


    def manage_composition(self, composition, map_item):
        """ Manage composition in QGIS 2.x and 3.x """
        
        try:
            if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
                composition.setAtlasMode(QgsComposition.PreviewAtlas)
                rotation = float(utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.rotation))
                map_item.setMapRotation(rotation)
                composition.refreshItems()
                composition.update()
            # TODO: 3.x
            else:
                pass
        except:
            pass
                

    def set_template(self):
        template = self.dlg_draw_profile.cbx_template.currentText()
        self.template = template[:-4]


    def export_pdf(self):
        """ Export PDF of selected template"""

        # Generate Composer
        self.execute_profiles_composer()
        self.generate_composer()

    def save_rotation_vdefault(self):

        # Save vdefault value from rotation
        tablename = "config_param_user"
        rotation = utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.rotation)

        if self.rotation_vd_exist:
            self.controller.log_info(str("test1") + str(rotation))
            if str(rotation) != 'null':
                sql = ("UPDATE " + self.schema_name + "." + tablename + ""
                       " SET value = '" + str(rotation) + "'"
                       " WHERE parameter = 'rotation_vdefault'")
            else:
                sql = ("UPDATE " + self.schema_name + "." + tablename + ""
                       " SET value = '0'"
                       " WHERE parameter = 'rotation_vdefault'")
        else:
            if str(rotation) != 'null':
                sql = ("INSERT INTO " + self.schema_name + "." + tablename + "(parameter, value, cur_user)"
                       " VALUES ('rotation_vdefault', '" + str(
                    rotation) + "', current_user)")
            else:
                sql = ("INSERT INTO " + self.schema_name + "." + tablename + "(parameter, value, cur_user)"
                       " VALUES ('rotation_vdefault', '0', current_user)")

        if sql:
            self.controller.execute_sql(sql)


    def manual_path(self, list_points):
        """ Calculating shortest path using dijkstra algorithm """

        self.arc_id = []
        self.node_id = []
        for i in range(0, (len(list_points)-1)):
            
            # return
            start_point = list_points[i]
            end_point = list_points[i+1]

            self.rnode_id = []
            self.rarc_id = []

            rstart_point = None
            sql = ("SELECT rid"
                   " FROM " + self.schema_name + ".v_anl_pgrouting_node"
                   " WHERE node_id = '" + start_point + "'")
            row = self.controller.get_row(sql)
            if row:
                rstart_point = int(row[0])

            rend_point = None
            sql = ("SELECT rid"
                   " FROM " + self.schema_name + ".v_anl_pgrouting_node"
                   " WHERE node_id = '" + end_point + "'")
            row = self.controller.get_row(sql)
            if row:
                rend_point = int(row[0])

            # Check starting and end points | wait to select end_point
            if rstart_point is None or rend_point is None:
                return

            # Clear list of arcs and nodes - preparing for new profile
            sql = ("SELECT * FROM public.pgr_dijkstra('SELECT id::integer, source, target, cost"
                   " FROM " + self.schema_name + ".v_anl_pgrouting_arc', "
                   + str(rstart_point) + ", " + str(rend_point) + ", false")
            if self.version == '2':
                sql += ", false"
            elif self.version == '3':
                pass
            else:
                message = "You need to upgrade your version of pgRouting"
                self.controller.show_info(message)
                return
            sql += ")"

            rows = self.controller.get_rows(sql)
            for i in range(0, len(rows)):
                if self.version == '2':
                    self.rnode_id.append(str(rows[i][1]))
                    self.rarc_id.append(str(rows[i][2]))
                elif self.version == '3':
                    self.rnode_id.append(str(rows[i][2]))
                    self.rarc_id.append(str(rows[i][3]))

            self.rarc_id.pop()

            for n in range(0, len(self.rarc_id)):
                # Convert arc_ids
                sql = ("SELECT arc_id"
                       " FROM " + self.schema_name + ".v_anl_pgrouting_arc"
                       " WHERE id = '" + str(self.rarc_id[n]) + "'")
                row = self.controller.get_row(sql)
                if row:
                    self.arc_id.append(str(row[0]))

            for m in range(0, len(self.rnode_id)):
                # Convert node_ids
                sql = ("SELECT node_id"
                       " FROM " + self.schema_name + ".v_anl_pgrouting_node"
                       " WHERE rid = '" + str(self.rnode_id[m]) + "'")
                row = self.controller.get_row(sql)
                if row:
                    self.node_id.append(str(row[0]))

            # Select arcs of the shortest path
            for element_id in self.arc_id:
                sql = ("SELECT sys_type"
                       " FROM " + self.schema_name + ".ve_arc"
                       " WHERE arc_id = '" + str(element_id) + "'")
                row = self.controller.get_row(sql)
                if not row:
                    return
                
                # Select feature of v_edit_man_@sys_type
                sys_type = str(row[0].lower())
                viewname = "v_edit_man_" + str(sys_type)
                self.layer_feature = self.controller.get_layer_by_tablename(viewname)
                aux = ""
                for row in self.arc_id:
                    aux += "arc_id = '" + str(row) + "' OR "
                aux = aux[:-3] + ""

                # Select snapped features
                selection = self.layer_feature.getFeatures(QgsFeatureRequest().setFilterExpression(aux))
                self.layer_feature.setSelectedFeatures([a.id() for a in selection])

            # Select nodes of shortest path on layers v_edit_man_|feature
            for element_id in self.node_id:
                sql = ("SELECT sys_type"
                       " FROM " + self.schema_name + ".ve_node"
                       " WHERE node_id = '" + str(element_id) + "'")
                row = self.controller.get_row(sql)
                if not row:
                    return
                
                # Select feature of v_edit_man_@sys_type
                sys_type = str(row[0].lower())
                viewname = "v_edit_man_" + str(sys_type)
                self.layer_feature = self.controller.get_layer_by_tablename(viewname)
                aux = ""
                for row in self.node_id:
                    aux += "node_id = '" + str(row) + "' OR "
                aux = aux[:-3] + ""

                # Select snapped features
                selection = self.layer_feature.getFeatures(QgsFeatureRequest().setFilterExpression(aux))
                self.layer_feature.setSelectedFeatures([a.id() for a in selection])

            # Select nodes of shortest path on ve_arc for ZOOM SELECTION
            expr_filter = "\"arc_id\" IN ("
            for i in range(len(self.arc_id)):
                expr_filter += "'" + str(self.arc_id[i]) + "', "
            expr_filter = expr_filter[:-2] + ")"
            (is_valid, expr) = self.check_expression(expr_filter, True)   #@UnusedVariable       
            if not is_valid:
                return                    

            # Build a list of feature id's from the previous result
            # Select features with these id's
            it = self.layer_arc.getFeatures(QgsFeatureRequest(expr))
            self.id_list = [i.id() for i in it]
            self.layer_arc.selectByIds(self.id_list)

            # Center shortest path in canvas - ZOOM SELECTION
            self.canvas.zoomToSelected(self.layer_arc)

            # Clear list
            self.list_arc = []
            self.dlg_draw_profile.tbl_list_arc.clear()

            for i in range(len(self.arc_id)):
                item_arc = QListWidgetItem(self.arc_id[i])
                self.dlg_draw_profile.tbl_list_arc.addItem(item_arc)
                self.list_arc.append(self.arc_id[i])


    def exec_path(self):

        self.rotation_vd_exist = False
        if str(self.start_end_node[0]) != None:
            self.dlg_draw_profile.btn_add_end_point.setDisabled(False)
        # Shortest path - if additional point doesn't exist
        if str(self.start_end_node[0]) != None and self.start_end_node[1] != None:
            self.shortest_path(str(self.start_end_node[0]), str(self.start_end_node[1]))
            self.dlg_draw_profile.btn_add_additional_point.setDisabled(False)
            self.dlg_draw_profile.list_additional_points.setDisabled(False)
            self.dlg_draw_profile.title.setDisabled(False)
            self.dlg_draw_profile.rotation.setDisabled(False)

            # Get rotation vdefaut if exist
            sql = "SELECT value FROM " + self.schema_name + ".config_param_user WHERE parameter = 'rotation_vdefault' AND cur_user = current_user"
            rows = self.controller.get_rows(sql)
            if rows:
                row = rows[0]
                if row:
                    utils_giswater.setWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.rotation, row[0])
                    self.rotation_vd_exist = True
            else:
                utils_giswater.setWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.rotation, '0')

            # After executing of path enable btn_draw and open_composer
            self.dlg_draw_profile.btn_draw.setDisabled(False)
            self.dlg_draw_profile.btn_save_profile.setDisabled(False)
            self.dlg_draw_profile.btn_export_pdf.setDisabled(False)
            self.dlg_draw_profile.cbx_template.setDisabled(False)

        if str(self.start_end_node[0]) != None and self.start_end_node[1] != None:
            self.dlg_draw_profile.btn_delete_additional_point.setDisabled(False)

        # Manual path - if additional point exist
        if len(self.start_end_node) > 2:
            self.dlg_draw_profile.btn_add_start_point.setDisabled(True)
            self.dlg_draw_profile.btn_add_end_point.setDisabled(True)
            self.manual_path(self.start_end_node)


    def delete_profile(self):
        """ Delete profile """

        selected_list = self.dlg_load.tbl_profiles.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        # Selected item from list
        selected_profile = self.dlg_load.tbl_profiles.currentItem().text()

        message = "Are you sure you want to delete these profile?"
        answer = self.controller.ask_question(message, "Delete profile", selected_profile)
        if answer:
            # Delete selected profile
            sql = ("DELETE FROM " + self.schema_name + ".anl_arc_profile_value"
                   " WHERE profile_id = '" + str(selected_profile) + "'")
            status = self.controller.execute_sql(sql)
            if not status:
                message = "Error deleting profile"
                self.controller.show_warning(message)
                return
            else:
                message = "Profile deleted"
                self.controller.show_info(message)

        # Refresh list of arcs
        self.dlg_load.tbl_profiles.clear()
        sql = "SELECT DISTINCT(profile_id) FROM " + self.schema_name + ".anl_arc_profile_value"
        rows = self.controller.get_rows(sql)
        if rows:
            for row in rows:
                item_arc = QListWidgetItem(str(row[0]))
                self.dlg_load.tbl_profiles.addItem(item_arc)


    def delete_additional_point(self):

        self.dlg_draw_profile.btn_delete_additional_point.setDisabled(True)
        self.widget_additional_point.clear()
        self.start_end_node.pop(1)
        # Reload path
        self.exec_path()
        
        
    def remove_selection(self):
        """ Remove selected features of all layers """

        for layer in self.canvas.layers():
            if type(layer) is QgsVectorLayer:
                layer.removeSelection()
        self.canvas.refresh()
        
