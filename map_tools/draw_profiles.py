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
except ImportError:
    from qgis.core import QGis as Qgis

from qgis.core import QgsFeatureRequest, QgsVectorLayer, QgsProject, QgsReadWriteContext, QgsPrintLayout
from qgis.gui import QgsMapToolEmitPoint
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtWidgets import QListWidget, QListWidgetItem, QLineEdit
from qgis.PyQt.QtXml import QDomDocument

from functools import partial
from decimal import Decimal
import matplotlib.pyplot as plt
import math
import os
import json

from .. import utils_giswater
from .parent import ParentMapTool
from ..ui_manager import DrawProfile
from ..ui_manager import LoadProfiles


class NodeData:
    def __init__(self):
        self.start_point = None
        self.top_elev = None
        self.ymax = None
        self.z1 = None
        self.z2 = None
        self.cat_geom = None
        self.geom = None
        self.slope = None
        self.elev1 = None
        self.elev2 = None
        self.y1 = None
        self.y2 = None
        self.node_id = None
        self.elev = None
        self.code = None
        self.node_1 = None
        self.node_2 = None
        

class DrawProfiles(ParentMapTool):
    """ Button 43: Draw_profiles """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        # Call ParentMapTool constructor
        super().__init__(iface, settings, action, index_action)

        self.list_of_selected_nodes = []
        self.nodes = []


    def activate(self):

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
        self.dlg_draw_profile.rejected.connect(self.manage_rejected)
        self.dlg_draw_profile.btn_close.clicked.connect(self.manage_rejected)
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
        template_path = self.settings.value('system_variables/composers_path') + f'{os.sep}{self.template}.qpt'
        if not os.path.exists(template_path):
            message = "File not found"
            self.controller.show_warning(message, parameter=template_path)
            return
        template_files = os.listdir(template_path)
        self.files_qpt = [i for i in template_files if i.endswith('.qpt')]

        self.dlg_draw_profile.cbx_template.clear()
        self.dlg_draw_profile.cbx_template.addItem('')
        for template in self.files_qpt:
            self.dlg_draw_profile.cbx_template.addItem(str(template))
            self.dlg_draw_profile.cbx_template.currentIndexChanged.connect(self.set_template)

        self.layer_node = self.controller.get_layer_by_tablename("v_edit_node")
        self.layer_arc = self.controller.get_layer_by_tablename("v_edit_arc")

        self.list_of_selected_nodes = []

        self.open_dialog(self.dlg_draw_profile)


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
        sql = (f"SELECT DISTINCT(profile_id) "
               f"FROM anl_arc_profile_value "
               f"WHERE profile_id = '{profile_id}'")
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
            sql += (f"INSERT INTO anl_arc_profile_value (profile_id, arc_id, start_point, end_point) "
                    f" VALUES ('{profile_id}', '{list_arc[i]}', '{start_point}', '{end_point}');\n")
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
        
        sql = "SELECT DISTINCT(profile_id) FROM anl_arc_profile_value"
        rows = self.controller.get_rows(sql, commit=True)
        if rows:
            for row in rows:
                item_arc = QListWidgetItem(str(row[0]))
                self.dlg_load.tbl_profiles.addItem(item_arc)

        self.open_dialog(self.dlg_load)
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
               " FROM anl_arc_profile_value"
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
               " FROM anl_arc_profile_value"
               " WHERE profile_id = '" + selected_profile + "'")
        rows = self.controller.get_rows(sql, commit=True)
        if not rows:
            return

        arc_id = []
        for row in rows:
            arc_id.append(str(row[0]))

        # Select arcs of the shortest path
        for element_id in arc_id:
            sql = ("SELECT sys_type"
                   " FROM v_edit_arc"
                   " WHERE arc_id = '" + str(element_id) + "'")
            row = self.controller.get_row(sql)
            if not row:
                return
            
            # Select feature from v_edit_man_@sys_type
            sys_type = str(row[0].lower())
            sql = "SELECT parent_layer FROM cat_feature WHERE system_id = '" + sys_type.upper() + "' LIMIT 1"
            row = self.controller.get_row(sql, log_sql=True, commit=True)
            self.layer_feature = self.controller.get_layer_by_tablename(row[0])
            aux = ""
            for row in arc_id:
                aux += "arc_id = '" + str(row) + "' OR "
            aux = aux[:-3] + ""

            # Select snapped features
            selection = self.layer_feature.getFeatures(QgsFeatureRequest().setFilterExpression(aux))
            self.layer_feature.selectByIds([a.id() for a in selection])

        node_id = []
        for element_id in arc_id:
            sql = ("SELECT node_1, node_2"
                   " FROM arc"
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
        node_id = singles_list

        # Select nodes of shortest path on layers v_edit_man_|feature
        for element_id in node_id:
            sql = ("SELECT sys_type"
                   " FROM v_edit_node"
                   " WHERE node_id = '" + str(element_id) + "'")
            row = self.controller.get_row(sql)
            if not row:
                return
            
            # Select feature from v_edit_man_@sys_type
            sys_type = str(row[0].lower())
            sql = "SELECT parent_layer FROM cat_feature WHERE system_id = '" + sys_type.upper() + "' LIMIT 1"
            row = self.controller.get_row(sql, log_sql=True, commit=True)
            self.layer_feature = self.controller.get_layer_by_tablename(row[0])
            aux = ""
            for row in node_id:
                aux += "node_id = '" + str(row) + "' OR "
            aux = aux[:-3] + ""

            # Select snapped features
            selection = self.layer_feature.getFeatures(QgsFeatureRequest().setFilterExpression(aux))
            self.layer_feature.selectByIds([a.id() for a in selection])

        # Select arcs of shortest path on v_edit_arc for ZOOM SELECTION
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
        self.dlg_draw_profile.scale_vertical.setDisabled(False)
        self.dlg_draw_profile.scale_horizontal.setDisabled(False)
        self.close_dialog(self.dlg_load)


    def activate_snapping(self, emit_point):

        self.canvas.setMapTool(emit_point)
        snapper = self.snapper_manager.get_snapper()
        self.canvas.xyCoordinates.connect(self.mouse_move)
        emit_point.canvasClicked.connect(partial(self.snapping_node, snapper))


    def activate_snapping_node(self, widget):

        # Create the appropriate map tool and connect the gotPoint() signal.
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.snapper = self.snapper_manager.get_snapper()
        self.iface.setActiveLayer(self.layer_node)
        self.canvas.xyCoordinates.connect(self.mouse_move)
        # widget = clicked button
        # self.widget_start_point | self.widget_end_point : QLabels
        if str(widget.objectName()) == "btn_add_start_point":
            self.widget_point =  self.widget_start_point
        if str(widget.objectName()) == "btn_add_end_point":
            self.widget_point =  self.widget_end_point
        if str(widget.objectName()) == "btn_add_additional_point":
            self.widget_point =  self.widget_additional_point

        self.emit_point.canvasClicked.connect(self.snapping_node)


    def mouse_move(self, point):

        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if self.snapper_manager.result_is_valid():
            layer = self.snapper_manager.get_snapped_layer(result)
            if layer == self.layer_node:
                self.snapper_manager.add_marker(result, self.vertex_marker)
        else:
            self.vertex_marker.hide()


    def snapping_node(self, point):   # @UnusedVariable
        # Get clicked point
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)

        if self.snapper_manager.result_is_valid():
            # Check feature
            layer = self.snapper_manager.get_snapped_layer(result)
            if layer == self.layer_node:
                # Get the point
                snapped_feat = self.snapper_manager.get_snapped_feature(result)
                element_id = snapped_feat.attribute('node_id')
                self.element_id = str(element_id)
                # Leave selection
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
                self.layer_feature = self.layer_node
        # widget = clicked button
        # self.widget_start_point | self.widget_end_point : QLabels
        # start_end_node = [0] : node start | start_end_node = [1] : node end
        aux = ""
        if str(self.widget_point.objectName()) == "start_point":
            self.start_end_node[0] = self.widget_point.text()
            aux = f"node_id = '{self.start_end_node[0]}'"

        if str(self.widget_point.objectName()) == "end_point":
            self.start_end_node[1] = self.widget_point.text()
            aux = f"node_id = '{self.start_end_node[0]}' OR node_id = '{self.start_end_node[1]}'"

        if str(self.widget_point.objectName()) == "list_sdditional_points":
            # After start_point and end_point in self.start_end_node add list of additional points from "cbx_additional_point"
            aux = f"node_id = '{self.start_end_node[0]}' OR node_id = '{self.start_end_node[1]}'"
            for i in range(2, len(self.start_end_node)):
                aux += f" OR node_id = '{self.start_end_node[i]}'"

        # Select snapped features
        selection = self.layer_feature.getFeatures(QgsFeatureRequest().setFilterExpression(aux))
        self.layer_feature.selectByIds([k.id() for k in selection])

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
        self.draw_first_node(self.nodes[0])
        
        # Draw nodes between first and last node
        for i in range(1, self.n - 1):

            self.draw_nodes(self.nodes[i], self.nodes[i - 1], i)

            self.draw_ground()

        # Draw last node
        self.draw_last_node(self.nodes[self.n - 1], self.nodes[self.n - 2], self.n - 1)

        # Set correct variable for draw ground (drawn centered)
        self.first_top_x = self.first_top_x + self.nodes[self.n - 2].geom / 2

        self.draw_ground()
        self.draw_table_horizontals()
        self.set_properties()
        self.draw_coordinates()
        self.draw_grid()
        self.plot = plt

        # If file profile.png exist overwrite
        plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
        img_path = plugin_path + os.sep + "templates" + os.sep + "profile.png"
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
        x_min = round(self.nodes[0].start_point - self.fix_x - self.fix_x * Decimal(0.15))
        x_max = round(self.nodes[self.n - 1].start_point + self.fix_x * Decimal(0.15))
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
            # Get gis_length from v_edit_arc
            sql = (f"SELECT gis_length "
                   f"FROM v_edit_arc "
                   f"WHERE arc_id = '{arc_id}'")
            row = self.controller.get_row(sql)
            if row:
                self.gis_length.append(row[0])

        # Calculate start_point (coordinates) of drawing for each node
        n = len(self.gis_length)
        for i in range(1, n):
            x = self.start_point[i - 1] + self.gis_length[i]
            self.start_point.append(x)
            i += 1


    def fill_memory(self):
        """ Get parameters from data base. Fill self.nodes with parameters postgres """

        self.nodes.clear()
        bad_nodes_id = []
        
        # Get parameters and fill the nodes
        for i, node_id in enumerate(self.node_id):
            
            # parameters : list of parameters for one node
            parameters = NodeData()
            parameters.start_point = self.start_point[i]
            # Get data top_elev ,y_max, elev, nodecat_id from v_edit_node
            # Change elev to sys_elev
            sql = (f"SELECT sys_top_elev AS top_elev, sys_ymax AS ymax, sys_elev, nodecat_id, code "
                   f"FROM v_edit_node "
                   f"WHERE node_id = '{node_id}'")
                # query for nodes
                # SELECT elevation AS top_elev, depth AS ymax, top_elev-depth AS sys_elev, nodecat_id, code"

            row = self.controller.get_row(sql)
            columns = ['top_elev', 'ymax', 'sys_elev', 'nodecat_id', 'code']
            if row:
                if row[0] is None or row[1] is None or row[2] is None or row[3] is None or row[4] is None:
                    bad_nodes_id.append(node_id)
                # Check if we have all data for drawing
                for x in range(len(columns)):
                    if row[x] is None:
                        sql = (f"SELECT value::decimal(12,3) "
                               f"FROM config_param_system "
                               f"WHERE parameter = '{columns[x]}_vd'")
                        result = self.controller.get_row(sql)
                        row[x] = result[0]

                parameters.top_elev = row[0]
                parameters.ymax = row[1]
                parameters.elev = row[2]
                nodecat_id = row[3]
                parameters.code = row[4]
                parameters.node_id = str(node_id)

            # Get data z1, z2 ,cat_geom1 ,elev1 ,elev2 , y1 ,y2 ,slope from v_edit_arc
            # Change to elevmax1 and elevmax2
            # Geom1 from cat_node
            sql = (f"SELECT geom1 "
                   f"FROM cat_node "
                   f"WHERE id = '{nodecat_id}'")
            row = self.controller.get_row(sql)
            columns = ['geom1']
            if row:
                if row[0] is None:
                    bad_nodes_id.append(node_id)
                # Check if we have all data for drawing
                for x in range(0, len(columns)):
                    if row[x] is None:
                        sql = (f"SELECT value::decimal(12,3) "
                               f"FROM config_param_system "
                               f"WHERE parameter = '{columns[x]}_vd'")
                        result = self.controller.get_row(sql)
                        row[x] = result[0]

                parameters.geom = row[0]

            # Set node_id in nodes
            parameters.node_id = node_id
            self.nodes.append(parameters)

        n = 0
        for element_id in self.arc_id:

            sql = (f"SELECT z1, z2, cat_geom1, sys_elev1, sys_elev2, sys_y1 AS y1, sys_y2 AS y2, slope, node_1, node_2 "
                   f"FROM v_edit_arc "
                   f"WHERE arc_id = '{element_id}'")
            row = self.controller.get_row(sql)

            # TODO:: v_nodes -> query for arcs
            # SELECT 0 AS z1, 0 AS z2 , dnom/1000, NULL as  sys_elev1,  NULL as  sys_elev2,  NULL as  y1,  NULL as  y2,   NULL as  slope, node_1, node_2,

            columns = ['z1','z2','cat_geom1', 'sys_elev1', 'sys_elev2', 'y1', 'y2', 'slope']

            # Check if self.nodes[n] is out of range
            if n >= len(self.nodes):
                return

            if row:
                # Check if we have all data for drawing
                if row[0] is None or row[1] is None or row[2] is None or row[3] is None or row[4] is None or \
                   row[5] is None or row[6] is None or row[7] is None:
                    bad_nodes_id.append(element_id)
                for x in range(0, len(columns)):
                    if row[x] is None:
                        sql = (f"SELECT value::decimal(12,3) "
                               f"FROM config_param_system "
                               f"WHERE parameter = '{columns[x]}_vd'")
                        result = self.controller.get_row(sql)
                        row[x] = result[0]

                self.nodes[n].z1 = row[0]
                self.nodes[n].z2 = row[1]
                self.nodes[n].cat_geom = row[2]
                self.nodes[n].elev1 = row[3]
                self.nodes[n].elev2 = row[4]
                self.nodes[n].y1 = row[5]
                self.nodes[n].y2 = row[6]
                self.nodes[n].slope = row[7]
                self.nodes[n].node_1 = row[8]
                self.nodes[n].node_2 = row[9]
                
                n += 1

        if not bad_nodes_id:
            return

        message = "Some parameters are missing (Values Defaults used for)"
        self.controller.show_info_box(message, "Info", str(bad_nodes_id))


    def draw_first_node(self, node):
        """ Draw first node """

        if node.node_id == node.node_1:
            z = node.z1
            reverse = False
        else:
            z = node.z2
            reverse = True

        # Get superior points
        s1x = -node.geom / 2
        s1y = node.top_elev
        s2x = node.geom / 2
        s2y = node.top_elev
        s3x = node.geom / 2
        s3y = node.top_elev - node.ymax + z + node.cat_geom

        # Get inferior points
        i1x = -node.geom / 2
        i1y = node.top_elev - node.ymax
        i2x = node.geom / 2
        i2y = node.top_elev - node.ymax
        i3x = node.geom / 2
        i3y = node.top_elev - node.ymax + z

        # Create list points
        xinf = [s1x, i1x, i2x, i3x]
        yinf = [s1y, i1y, i2y, i3y]
        xsup = [s1x, s2x, s3x]
        ysup = [s1y, s2y, s3y]

        sql = "SELECT value FROM config_param_user WHERE parameter = 'draw_profile_conf' AND cur_user = cur_user"
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if row is not None:
            row = json.loads(row[0])
            if 'color' in row:
                # Draw lines acording list points
                plt.plot(xinf, yinf, row['color'])
                plt.plot(xsup, ysup, row['color'])
        else:
            plt.plot(xinf, yinf, 'black', zorder=100)
            plt.plot(xsup, ysup, 'black', zorder=100)


        self.first_top_x = 0
        self.first_top_y = node.top_elev

        # Draw fixed part of table
        self.draw_fix_table(node.start_point, reverse)


        # Save last points for first node
        self.slast = [s3x, s3y]
        self.ilast = [i3x, i3y]

        # Save last points for first node
        self.slast2 = [s3x, s3y]
        self.ilast2 = [i3x, i3y]


    def draw_fix_table(self, start_point, reverse):
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
        self.data_fix_table(start_point, reverse)


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


    def data_fix_table(self, start_point, reverse):  #@UnusedVariable
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
        self.fill_data(0, 0, reverse)


    def draw_nodes(self, node, prev_node, index):
        """ Draw nodes between first and last node """

        if node.node_id == prev_node.node_2:
            z1 = prev_node.z2
            reverse = False
        elif node.node_id == prev_node.node_1:
            z1 = prev_node.z1
            reverse = True

        if node.node_id == node.node_1:
            z2 = node.z1
        elif node.node_id == node.node_2:
            z2 = node.z2

        # Get superior points
        s1x = self.slast[0]
        s1y = self.slast[1]
        s2x = node.start_point - node.geom / 2
        s2y = node.top_elev - node.ymax + z1 + prev_node.cat_geom
        s3x = node.start_point - node.geom / 2
        s3y = node.top_elev
        s4x = node.start_point + node.geom / 2
        s4y = node.top_elev
        s5x = node.start_point + node.geom / 2
        s5y = node.top_elev -node.ymax + z2 + node.cat_geom

        # Get inferior points
        i1x = self.ilast[0]
        i1y = self.ilast[1]
        i2x = node.start_point - node.geom / 2
        i2y = node.top_elev - node.ymax + z1
        i3x = node.start_point - node.geom / 2
        i3y = node.top_elev - node.ymax
        i4x = node.start_point + node.geom / 2
        i4y = node.top_elev - node.ymax
        i5x = node.start_point + node.geom / 2
        i5y = node.top_elev - node.ymax + z2

        # Create list points
        xinf = [i1x, i2x, i3x, i4x, i5x]
        yinf = [i1y, i2y, i3y, i4y, i5y]
        xsup = [s1x, s2x, s3x, s4x, s5x]
        ysup = [s1y, s2y, s3y, s4y, s5y]

        sql = ("SELECT value FROM config_param_user "
               "WHERE parameter = 'draw_profile_conf' AND cur_user = cur_user")
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if row is not None:
            row = json.loads(row[0])
            if 'color' in row:
                # Draw lines acording list points
                plt.plot(xinf, yinf, row['color'])
                plt.plot(xsup, ysup, row['color'])
        else:
            plt.plot(xinf, yinf, 'black', zorder=100)
            plt.plot(xsup, ysup, 'black', zorder=100)

        self.node_top_x = node.start_point
        self.node_top_y = node.top_elev
        self.first_top_x = prev_node.start_point
        self.first_top_y = prev_node.top_elev

        # DRAW TABLE-MARKS
        self.draw_marks(node.start_point)

        # Fill table
        self.fill_data(node.start_point, index, reverse)

        # Save last points before the last node
        self.slast = [s5x, s5y]
        self.ilast = [i5x, i5y]


        # Save last points for draw ground
        self.slast2 = [s3x, s3y]
        self.ilast2 = [i3x, i3y]


    def fill_data(self, start_point, indx, reverse=False):


        # Fill top_elevation and node_id for all nodes
        plt.annotate(' ' + '\n' + str(round(self.nodes[indx].top_elev, 2)) + '\n' + ' ',
                     xy=(Decimal(start_point), self.min_top_elev - Decimal(self.height_row * 2 + self.height_row / 2)),
                     fontsize=6, rotation='vertical', horizontalalignment='center', verticalalignment='center')

        # Draw node_id
        plt.text(0 + start_point, self.min_top_elev - Decimal(self.height_row * 5 + self.height_row / 2),
                 self.nodes[indx].code, fontsize=7.5,
                 horizontalalignment='center', verticalalignment='center')

        # Manage variables elev and y (elev1, elev2, y1, y2) acoording flow trace
        if reverse:
            # Fill y_max and elevation
            # 1st node : y_max,y2 and top_elev, elev2
            if indx == 0:
                # # Fill y_max
                plt.annotate(' ' + '\n' + str(round(self.nodes[0].ymax, 2)) + '\n' + str(round(self.nodes[0].y2, 2)),
                             xy=(Decimal(0 + start_point),
                                 self.min_top_elev - Decimal(self.height_row * 3 + self.height_row / 2)), fontsize=6,
                             rotation='vertical', horizontalalignment='center', verticalalignment='center')
                # Fill elevation
                plt.annotate(' ' + '\n' + str(round(self.nodes[0].elev, 2)) + '\n' + str(round(self.nodes[0].elev2, 2)),
                             xy=(Decimal(0 + start_point),
                                 self.min_top_elev - Decimal(self.height_row * 4 + self.height_row / 2)), fontsize=6,
                             rotation='vertical', horizontalalignment='center', verticalalignment='center')
            # Last node : y_max,y1 and top_elev, elev1
            elif indx == self.n - 1:
                pass
                # Fill y_max
                plt.annotate(
                    str(round(self.nodes[indx - 1].y1, 2)) + '\n' + str(
                        round(self.nodes[indx].ymax, 2)) + '\n' + ' ',
                    xy=(Decimal(0 + start_point),
                        self.min_top_elev - Decimal(self.height_row * 3 + self.height_row / 2)), fontsize=6,
                    rotation='vertical', horizontalalignment='center', verticalalignment='center')
                # Fill elevation
                plt.annotate(
                    str(round(self.nodes[indx - 1].elev1, 2)) + '\n' + str(
                        round(self.nodes[indx].elev, 2)) + '\n' + ' ',
                    xy=(Decimal(0 + start_point),
                        self.min_top_elev - Decimal(self.height_row * 4 + self.height_row / 2)), fontsize=6,
                    rotation='vertical', horizontalalignment='center', verticalalignment='center')
            else:
                # Fill y_max
                plt.annotate(
                    str(round(self.nodes[indx - 1].y1, 2)) + '\n' + str(
                        round(self.nodes[indx].ymax, 2)) + '\n' + str(
                        round(self.nodes[indx].y1, 2)),
                    xy=(Decimal(0 + start_point),
                        self.min_top_elev - Decimal(self.height_row * 3 + self.height_row / 2)), fontsize=6,
                    rotation='vertical', horizontalalignment='center', verticalalignment='center')
                # Fill elevation
                plt.annotate(
                    str(round(self.nodes[indx - 1].elev1, 2)) + '\n' + str(
                        round(self.nodes[indx].elev, 2)) + '\n' + str(
                        round(self.nodes[indx].elev1, 2)),
                    xy=(Decimal(0 + start_point),
                        self.min_top_elev - Decimal(self.height_row * 4 + self.height_row / 2)), fontsize=6,
                    rotation='vertical', horizontalalignment='center', verticalalignment='center')
        else:
            # Fill y_max and elevation
            # 1st node : y_max,y2 and top_elev, elev2
            if indx == 0:
                    # # Fill y_max
                    plt.annotate(' ' + '\n' + str(round(self.nodes[0].ymax, 2)) + '\n' + str(round(self.nodes[0].y1, 2)),
                                 xy=(Decimal(0 + start_point),
                                     self.min_top_elev - Decimal(self.height_row * 3 + self.height_row / 2)), fontsize=6,
                                 rotation='vertical', horizontalalignment='center', verticalalignment='center')

                    # Fill elevation
                    plt.annotate(' ' + '\n' + str(round(self.nodes[0].elev, 2)) + '\n' + str(round(self.nodes[0].elev1, 2)),
                                 xy=(Decimal(0 + start_point),
                                     self.min_top_elev - Decimal(self.height_row * 4 + self.height_row / 2)), fontsize=6,
                                 rotation='vertical', horizontalalignment='center', verticalalignment='center')

            # Last node : y_max,y1 and top_elev, elev1
            elif indx == self.n - 1:
                pass
                # Fill y_max
                plt.annotate(
                    str(round(self.nodes[indx - 1].y2, 2)) + '\n' + str(round(self.nodes[indx].ymax, 2)) + '\n' + ' ',
                    xy=(Decimal(0 + start_point),
                        self.min_top_elev - Decimal(self.height_row * 3 + self.height_row / 2)), fontsize=6,
                    rotation='vertical', horizontalalignment='center', verticalalignment='center')

                # Fill elevation
                plt.annotate(
                    str(round(self.nodes[indx - 1].elev2, 2)) + '\n' + str(
                        round(self.nodes[indx].elev, 2)) + '\n' + ' ',
                    xy=(Decimal(0 + start_point),
                        self.min_top_elev - Decimal(self.height_row * 4 + self.height_row / 2)), fontsize=6,
                    rotation='vertical', horizontalalignment='center', verticalalignment='center')
            # Nodes between 1st and last node : y_max,y1,y2 and top_elev, elev1, elev2
            else:
                # Fill y_max
                plt.annotate(
                    str(round(self.nodes[indx - 1].y2, 2)) + '\n' + str(round(self.nodes[indx].ymax, 2)) + '\n' + str(
                        round(self.nodes[indx].y1, 2)),
                    xy=(Decimal(0 + start_point),
                        self.min_top_elev - Decimal(self.height_row * 3 + self.height_row / 2)), fontsize=6,
                    rotation='vertical', horizontalalignment='center', verticalalignment='center')

                # Fill elevation
                plt.annotate(
                    str(round(self.nodes[indx - 1].elev2, 2)) + '\n' + str(
                        round(self.nodes[indx].elev, 2)) + '\n' + str(
                        round(self.nodes[indx].elev1, 2)),
                    xy=(Decimal(0 + start_point),
                        self.min_top_elev - Decimal(self.height_row * 4 + self.height_row / 2)), fontsize=6,
                    rotation='vertical', horizontalalignment='center', verticalalignment='center')

        # Fill diameter and slope / length for all nodes except last node
        if indx != self.n - 1:
            # Draw diameter
            center = self.gis_length[indx + 1] / 2
            plt.text(center + start_point, self.min_top_elev - 1 * self.height_row - Decimal(0.45) * self.height_row,
                     round(self.nodes[indx].cat_geom, 2),
                     fontsize=7.5, horizontalalignment='center')  # PUT IN THE MIDDLE PARAMETRIZATION
            # Draw slope / length
            slope = str(round((self.nodes[indx].slope * 100), 2))
            length = str(round(self.gis_length[indx + 1], 2))

            plt.text(center + start_point, self.min_top_elev - 1 * self.height_row - Decimal(0.8) * self.height_row,
                     slope + '%/' + length,
                     fontsize=7.5, horizontalalignment='center')  # PUT IN THE MIDDLE PARAMETRIZATION


    def draw_last_node(self, node, prev_node, index):

        if node.node_id == prev_node.node_2:
            z = prev_node.z2
            reverse = False
        else:
            z = prev_node.z1
            reverse = True

        # TODO:: comentar lista slast i ilast
        s1x = self.slast[0]
        s1y = self.slast[1]
        s2x = node.start_point - node.geom / 2
        s2y = node.top_elev - node.ymax + z + prev_node.cat_geom
        s3x = node.start_point - node.geom / 2
        s3y = node.top_elev
        s4x = node.start_point + node.geom /2
        s4y = node.top_elev


        # Get inferior points
        i1x = self.ilast[0]
        i1y = self.ilast[1]
        i2x = node.start_point - node.geom / 2
        i2y = node.top_elev - node.ymax + z
        i3x = node.start_point - node.geom / 2
        i3y = node.top_elev - node.ymax
        i4x = node.start_point + node.geom / 2
        i4y = node.top_elev - node.ymax

        # Create list points
        xinf = [i1x, i2x, i3x, i4x]
        yinf = [i1y, i2y, i3y, i4y]
        xsup = [s1x, s2x, s3x, s4x, i4x]
        ysup = [s1y, s2y, s3y, s4y, i4y]

        sql = "SELECT value FROM config_param_user WHERE parameter = 'draw_profile_conf' AND cur_user = cur_user"
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if row is not None:
            row = json.loads(row[0])
            if 'color' in row:
                # Draw lines acording list points
                plt.plot(xinf, yinf, row['color'])
                plt.plot(xsup, ysup, row['color'])
        else:
            plt.plot(xinf, yinf, 'black', zorder=100)
            plt.plot(xsup, ysup, 'black', zorder=100)

        self.first_top_x = self.slast2[0]
        self.first_top_y = self.slast2[1]

        self.node_top_x = node.start_point
        self.node_top_y = node.top_elev

        # DRAW TABLE
        # DRAW TABLE-MARKS
        self.draw_marks(node.start_point)

        # Fill table
        self.fill_data(node.start_point, index, reverse)


    def set_table_parameters(self):

        # Search y coordinate min_top_elev ( top_elev- ymax)
        self.min_top_elev = self.nodes[0].top_elev - self.nodes[0].ymax
        for i in range(1, self.n):
            if (self.nodes[i].top_elev - self.nodes[i].ymax) < self.min_top_elev:
                self.min_top_elev = self.nodes[i].top_elev - self.nodes[i].ymax
        # Search y coordinate max_top_elev
        self.max_top_elev = self.nodes[0].top_elev
        for i in range(1, self.n):
            if self.nodes[i].top_elev > self.max_top_elev:
                self.max_top_elev = self.nodes[i].top_elev

        # Calculating dimensions of x-fixed part of table
        self.fix_x = Decimal(0.15) * self.nodes[self.n - 1].start_point

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
        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x]
        y = [self.min_top_elev - self.height_row, self.min_top_elev - self.height_row]
        plt.plot(x, y, 'black',zorder=100)

        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x]
        y = [self.min_top_elev - 2 * self.height_row, self.min_top_elev - 2 * self.height_row]
        plt.plot(x, y, 'black',zorder=100)

        # Draw horizontal(shorter) lines
        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x * Decimal(0.75)]
        y = [self.min_top_elev - 3 * self.height_row, self.min_top_elev - 3 * self.height_row]
        plt.plot(x, y, 'black',zorder=100)
        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x * Decimal(0.75)]
        y = [self.min_top_elev - 4 * self.height_row, self.min_top_elev - 4 * self.height_row]
        plt.plot(x, y, 'black',zorder=100)

        # Last two lines
        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x]
        y = [self.min_top_elev - 5 * self.height_row, self.min_top_elev - 5 * self.height_row]
        plt.plot(x, y, 'black',zorder=100)
        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x]
        y = [self.min_top_elev - 6 * self.height_row, self.min_top_elev - 6 * self.height_row]
        plt.plot(x, y, 'black',zorder=100)


    def draw_coordinates(self):

        start_point = self.nodes[self.n - 1].start_point
        geom1 = self.nodes[self.n - 1].geom

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
        start_point = self.nodes[self.n-1].start_point
        geom1 = self.nodes[self.n-1].geom
        plt.annotate('P.C. '+str(round(self.min_top_elev - 1 * self.height_row,2)) + '\n' + ' ',
                     xy=(0 - geom1 * Decimal(1.5) , self.min_top_elev - 1 * self.height_row),
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

    
    # TODO: Not used
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

    
    def shortest_path(self, start_point, end_point):
        """ Calculating shortest path using dijkstra algorithm """
        
        self.arc_id = []
        self.node_id = []
        self.rnode_id = []
        self.rarc_id = []

        rstart_point = None
        sql = (f"SELECT rid "
               f"FROM v_anl_pgrouting_node "
               f"WHERE node_id = '{start_point}'")
        row = self.controller.get_row(sql)
        if row:
            rstart_point = int(row[0])

        rend_point = None
        sql = (f"SELECT rid "
               f"FROM v_anl_pgrouting_node "
               f"WHERE node_id = '{end_point}'")
        row = self.controller.get_row(sql)
        if row:
            rend_point = int(row[0])

        # Check starting and end points | wait to select end_point
        if rstart_point is None or rend_point is None:
            return

        # Clear list of arcs and nodes - preparing for new profile
        sql = (f"SELECT * FROM public.pgr_dijkstra('SELECT id::integer, source, target, cost"
               f" FROM v_anl_pgrouting_arc', {rstart_point}, {rend_point}, false")
        
        if self.version == '2':
            sql += ", false"
        elif self.version == '3':
            pass
        else:
            message = "You need to upgrade your version of pgRouting"
            self.controller.show_info(message)
            return
        sql += ")"

        rows = self.controller.get_rows(sql, commit=True)
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
            sql = (f"SELECT arc_id "
                   f"FROM v_anl_pgrouting_arc "
                   f"WHERE id = '{self.rarc_id[n]}'")
            row = self.controller.get_row(sql)
            if row:
                self.arc_id.append(str(row[0]))

        for m in range(0, len(self.rnode_id)):
            # convert node_ids
            sql = (f"SELECT node_id "
                   f"FROM v_anl_pgrouting_node "
                   f"WHERE rid = '{self.rnode_id[m]}'")
            row = self.controller.get_row(sql)
            if row:
                self.node_id.append(str(row[0]))

        # Select arcs of the shortest path
        for element_id in self.arc_id:
            sql = (f"SELECT sys_type "
                   f"FROM v_edit_arc "
                   f"WHERE arc_id = '{element_id}'")
            row = self.controller.get_row(sql)
            if not row:
                return

            # Select feature of v_edit_man_@sys_type
            sys_type = str(row[0].lower())
            sql = f"SELECT parent_layer FROM cat_feature WHERE system_id = '{sys_type.upper()}' LIMIT 1"
            row = self.controller.get_row(sql, log_sql=True, commit=True)
            self.layer_feature = self.controller.get_layer_by_tablename(row[0])
            aux = ""
            for row in self.arc_id:
                aux += "arc_id = '" + str(row) + "' OR "
            aux = aux[:-3] + ""

            # Select snapped features
            selection = self.layer_feature.getFeatures(QgsFeatureRequest().setFilterExpression(aux))
            self.layer_feature.selectByIds([a.id() for a in selection])

        # Select nodes of shortest path on layers v_edit_man_|feature
        for element_id in self.node_id:
            sql = (f"SELECT sys_type "
                   f"FROM v_edit_node "
                   f"WHERE node_id = '{element_id}'")
            row = self.controller.get_row(sql)
            if not row:
                return

            # Select feature of v_edit_man_@sys_type
            sys_type = str(row[0].lower())
            sql = f"SELECT parent_layer FROM cat_feature WHERE system_id = '{sys_type.upper()}' LIMIT 1"
            row = self.controller.get_row(sql, log_sql=True, commit=True)
            self.layer_feature = self.controller.get_layer_by_tablename(row[0])
            aux = ""
            for row in self.node_id:
                aux += f"node_id = '{row}' OR "
            aux = aux[:-3] + ""

            # Select snapped features
            selection = self.layer_feature.getFeatures(QgsFeatureRequest().setFilterExpression(aux))
            self.layer_feature.selectByIds([a.id() for a in selection])

        # Select nodes of shortest path on v_edit_arc for ZOOM SELECTION
        expr_filter = '"arc_id" IN ('
        for i in range(len(self.arc_id)):
            expr_filter += f"'{self.arc_id[i]}', "
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
        self.arcs = []
        self.nodes = []
        self.start_end_node = []
        self.start_end_node = [None, None]
        self.dlg_draw_profile.list_additional_points.clear()
        self.dlg_draw_profile.btn_add_start_point.setDisabled(False)
        self.dlg_draw_profile.btn_add_end_point.setDisabled(True)
        self.dlg_draw_profile.btn_add_additional_point.setDisabled(True)
        self.dlg_draw_profile.list_additional_points.setDisabled(True)
        self.dlg_draw_profile.title.setDisabled(True)
        self.dlg_draw_profile.rotation.setDisabled(True)
        self.dlg_draw_profile.scale_vertical.setDisabled(True)
        self.dlg_draw_profile.scale_horizontal.setDisabled(True)
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

        # Check if template is selected
        if str(self.dlg_draw_profile.cbx_template.currentText()) == "":
            message = "You need to select a template"
            self.controller.show_warning(message)
            return

        # Check if template file exists
        plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
        template_path = self.settings.value('system_variables/composers_path') + f'{os.sep}{self.template}.qpt'
        if not os.path.exists(template_path):
            message = "File not found"
            self.controller.show_warning(message, parameter=template_path)
            return
        if not os.path.exists(template_path):
            message = "File not found"
            self.controller.show_warning(message, parameter=template_path)
            return

        # Check if composer exist
        composers = self.get_composers_list()
        index = self.get_composer_index(str(self.template))

        # Composer not found
        if index == len(composers):

            # Create new composer with template selected in combobox(self.template)
            template_file = open(template_path, 'rt')
            template_content = template_file.read()
            template_file.close()
            document = QDomDocument()
            document.setContent(template_content)

            project = QgsProject.instance()
            comp_view = QgsPrintLayout(project)

            comp_view.loadFromTemplate(document, QgsReadWriteContext())
            layout_manager = project.layoutManager()
            layout_manager.addLayout(comp_view)

        else:
            comp_view = composers[index]

        # Manage profile layout
        self.manage_profile_layout(comp_view, plugin_path)


    def manage_profile_layout(self, layout, plugin_path):
        """ Manage profile layout """

        if layout is None:
            self.controller.log_warning("Layout not found")
            return

        # Get values from dialog
        profile = plugin_path + os.sep + "templates" + os.sep + "profile.png"
        title = self.dlg_draw_profile.title.text()
        rotation = float(utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.rotation))
        first_node = self.dlg_draw_profile.start_point.text()
        end_node = self.dlg_draw_profile.end_point.text()

        # Show layout
        self.iface.openLayoutDesigner(layout)

        # Set profile
        picture_item = layout.itemById('profile')
        picture_item.setPicturePath(profile)

        # Zoom map to extent, rotation
        map_item = layout.itemById('Mapa')
        map_item.zoomToExtent(self.canvas.extent())
        map_item.setMapRotation(rotation)

        # Fill data in composer template
        first_node_item = layout.itemById('first_node')
        first_node_item.setText(str(first_node))
        end_node_item = layout.itemById('end_node')
        end_node_item.setText(str(end_node))
        length_item = layout.itemById('length')
        length_item.setText(str(self.start_point[-1]))
        profile_title = layout.itemById('title')
        profile_title.setText(str(title))

        # Refresh items
        layout.refresh()
        layout.updateBounds()


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
            if str(rotation) != 'null':
                sql = (f"UPDATE {tablename} "
                       f"SET value = '{rotation}' "
                       f"WHERE parameter = 'rotation_vdefault'")
            else:
                sql = (f"UPDATE {tablename} "
                       f"SET value = '0' "
                       f"WHERE parameter = 'rotation_vdefault'")
        else:
            if str(rotation) != 'null':
                sql = (f"INSERT INTO {tablename} (parameter, value, cur_user) "
                       f"VALUES ('rotation_vdefault', '{rotation}', current_user)")
            else:
                sql = (f"INSERT INTO {tablename} (parameter, value, cur_user) "
                       f"VALUES ('rotation_vdefault', '0', current_user)")

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
            sql = (f"SELECT rid "
                   f"FROM v_anl_pgrouting_node "
                   f"WHERE node_id = '{start_point}'")
            row = self.controller.get_row(sql)
            if row:
                rstart_point = int(row[0])

            rend_point = None
            sql = (f"SELECT rid "
                   f"FROM v_anl_pgrouting_node "
                   f"WHERE node_id = '{end_point}'")
            row = self.controller.get_row(sql)
            if row:
                rend_point = int(row[0])

            # Check starting and end points | wait to select end_point
            if rstart_point is None or rend_point is None:
                return

            # Clear list of arcs and nodes - preparing for new profile
            sql = (f"SELECT * FROM public.pgr_dijkstra('SELECT id::integer, source, target, cost "
                   f"FROM v_anl_pgrouting_arc', {rstart_point}, {rend_point}, false")
            if self.version == '2':
                sql += ", false"
            elif self.version == '3':
                pass
            else:
                message = "You need to upgrade your version of pgRouting"
                self.controller.show_info(message)
                return
            sql += ")"

            rows = self.controller.get_rows(sql, commit=True)
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
                sql = (f"SELECT arc_id "
                       f"FROM v_anl_pgrouting_arc "
                       f"WHERE id = '{self.rarc_id[n]}'")
                row = self.controller.get_row(sql)
                if row:
                    self.arc_id.append(str(row[0]))

            for m in range(0, len(self.rnode_id)):
                # Convert node_ids
                sql = (f"SELECT node_id "
                       f"FROM v_anl_pgrouting_node "
                       f"WHERE rid = '{self.rnode_id[m]}'")
                row = self.controller.get_row(sql)
                if row:
                    self.node_id.append(str(row[0]))

            # Select arcs of the shortest path
            for element_id in self.arc_id:
                sql = (f"SELECT sys_type "
                       f"FROM v_edit_arc "
                       f"WHERE arc_id = '{element_id}'")
                row = self.controller.get_row(sql)
                if not row:
                    return

                # Select feature of v_edit_man_@sys_type
                sys_type = str(row[0].lower())
                sql = f"SELECT parent_layer FROM cat_feature WHERE system_id = '{sys_type.upper()}' LIMIT 1"
                row = self.controller.get_row(sql, log_sql=True, commit=True)
                self.layer_feature = self.controller.get_layer_by_tablename(row[0])
                aux = ""
                for row in self.arc_id:
                    aux += f"arc_id = '{row}' OR "
                aux = aux[:-3] + ""

                # Select snapped features
                selection = self.layer_feature.getFeatures(QgsFeatureRequest().setFilterExpression(aux))
                self.layer_feature.selectByIds([a.id() for a in selection])

            # Select nodes of shortest path on layers v_edit_man_|feature
            for element_id in self.node_id:
                sql = (f"SELECT sys_type "
                       f"FROM v_edit_node "
                       f"WHERE node_id = '{element_id}'")
                row = self.controller.get_row(sql)
                if not row:
                    return

                # Select feature of v_edit_man_@sys_type
                sys_type = str(row[0].lower())
                sql = f"SELECT parent_layer FROM cat_feature WHERE system_id = '{sys_type.upper()}' LIMIT 1"
                row = self.controller.get_row(sql, log_sql=True, commit=True)
                self.layer_feature = self.controller.get_layer_by_tablename(row[0])
                aux = ""
                for row in self.node_id:
                    aux += f"node_id = '{row}' OR "
                aux = aux[:-3] + ""

                # Select snapped features
                selection = self.layer_feature.getFeatures(QgsFeatureRequest().setFilterExpression(aux))
                self.layer_feature.selectByIds([a.id() for a in selection])

            # Select nodes of shortest path on v_edit_arc for ZOOM SELECTION
            expr_filter = '"arc_id" IN ('
            for i in range(len(self.arc_id)):
                expr_filter += f"'{self.arc_id[i]}', "
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
        if str(self.start_end_node[0]) is not None:
            self.dlg_draw_profile.btn_add_end_point.setDisabled(False)

        # Shortest path - if additional point doesn't exist
        if str(self.start_end_node[0]) is not None and self.start_end_node[1] is not None:
            self.shortest_path(str(self.start_end_node[0]), str(self.start_end_node[1]))
            self.dlg_draw_profile.btn_add_additional_point.setDisabled(False)
            self.dlg_draw_profile.list_additional_points.setDisabled(False)
            self.dlg_draw_profile.title.setDisabled(False)
            self.dlg_draw_profile.rotation.setDisabled(False)
            self.dlg_draw_profile.scale_vertical.setDisabled(False)
            self.dlg_draw_profile.scale_horizontal.setDisabled(False)

            # Get rotation vdefaut if exist
            sql = ("SELECT value FROM config_param_user "
                   "WHERE parameter = 'rotation_vdefault' AND cur_user = current_user")
            rows = self.controller.get_rows(sql, commit=True)
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

        if str(self.start_end_node[0]) is not None and self.start_end_node[1] is not None:
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
            sql = (f"DELETE FROM anl_arc_profile_value "
                   f"WHERE profile_id = '{selected_profile}'")
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
        sql = "SELECT DISTINCT(profile_id) FROM anl_arc_profile_value"
        rows = self.controller.get_rows(sql)
        if rows:
            for row in rows:
                item_arc = QListWidgetItem(str(row[0]))
                self.dlg_load.tbl_profiles.addItem(item_arc)


    def delete_additional_point(self):

        self.dlg_draw_profile.btn_delete_additional_point.setDisabled(True)
        self.widget_additional_point.clear()
        self.start_end_node.pop(1)
        self.exec_path()
        
        
    def remove_selection(self):
        """ Remove selected features of all layers """

        for layer in self.canvas.layers():
            if type(layer) is QgsVectorLayer:
                layer.removeSelection()
        self.canvas.refresh()


    def manage_rejected(self):
        self.close_dialog(self.dlg_draw_profile)
        self.remove_vertex()