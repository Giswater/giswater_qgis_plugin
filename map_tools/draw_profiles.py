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

from qgis.core import QgsFeatureRequest, QgsVectorLayer, QgsProject, QgsReadWriteContext, QgsPrintLayout, QgsExpression
from qgis.gui import QgsMapToolEmitPoint
from qgis.PyQt.QtCore import Qt, QDate
from qgis.PyQt.QtWidgets import QListWidget, QListWidgetItem, QLineEdit, QFileDialog, QAction
from qgis.PyQt.QtXml import QDomDocument

from functools import partial
from decimal import Decimal
from collections import OrderedDict
import matplotlib.pyplot as plt
import math
import os
import json

from .. import utils_giswater
from .parent import ParentMapTool
from ..ui_manager import Profile
from ..ui_manager import ProfilesList



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
        self.total_distance = None


class DrawProfiles(ParentMapTool):
    """ Button 43: Draw_profiles """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        # Call ParentMapTool constructor
        super().__init__(iface, settings, action, index_action)

        self.list_of_selected_nodes = []
        self.nodes = []
        self.links = []
        self.rotation_vd_exist = False


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
        self.dlg_draw_profile = Profile()
        self.load_settings(self.dlg_draw_profile)
        self.dlg_draw_profile.setWindowFlags(Qt.WindowStaysOnTopHint)

        self.composers_path = self.dlg_draw_profile.findChild(QLineEdit, "composers_path")

        self.start_end_node = [None, None]
        layername = f'v_edit_node'
        self.layer_node = self.controller.get_layer_by_tablename(layername, show_warning=False)

        # Toolbar actions
        action = self.dlg_draw_profile.findChild(QAction, "actionProfile")
        action.triggered.connect(partial(self.activate_snapping_node))
        self.set_icon(action, "100")
        self.action_profile = action

        self.dlg_draw_profile.btn_draw_profile.clicked.connect(partial(self.get_profile))
        self.dlg_draw_profile.btn_save_profile.clicked.connect(self.save_profile)
        self.dlg_draw_profile.chk_scalte_to_fit.stateChanged.connect(partial(self.manage_scale))
        self.dlg_draw_profile.cmb_papersize.currentIndexChanged.connect(partial(self.manage_papersize))
        self.dlg_draw_profile.btn_load_profile.clicked.connect(self.open_profile)
        self.dlg_draw_profile.btn_clear_profile.clicked.connect(self.clear_profile)

        # Populate cmb_papersize
        sql = ("SELECT id, idval, addparam "
               "FROM om_typevalue WHERE typevalue = 'profile_papersize' "
               "ORDER BY id")
        rows = self.controller.get_rows(sql)
        utils_giswater.set_item_data(self.dlg_draw_profile.cmb_papersize, rows, 1)

        utils_giswater.setCalendarDate(self.dlg_draw_profile, "date", None)

        #Populate composer combo
        # self.dlg_draw_profile.cmb_composer.addItem('')
        # self.list_composers = []
        # composers_list = self.get_composer()
        # self.list_composers.append(['', ''])
        # for composer in composers_list:
        #     elem = [composer, composer]
        #     self.list_composers.append(elem)
        # utils_giswater.set_item_data(self.dlg_draw_profile.cmb_composer, self.list_composers, 0)

        # Set parameters vdefault
        utils_giswater.setWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_min_distance, '1')
        utils_giswater.setWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_legend_factor, '1')
        utils_giswater.setWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_x_dim, '300')
        utils_giswater.setWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_y_dim, '100')
        utils_giswater.setWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_horizontal, '2000')
        utils_giswater.setWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_vertical, '500')
        utils_giswater.setWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_title, 'Test title')
        self.open_dialog(self.dlg_draw_profile)


    def get_profile(self):

        # Get parameters
        # composer = utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.cmb_composer)
        links_distance = utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_min_distance)
        legend_factor = utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_legend_factor)
        scale_to_fit =  utils_giswater.isChecked(self.dlg_draw_profile, "chk_scalte_to_fit")
        eh = utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_horizontal)
        ev = utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_vertical)

        papersize_id = utils_giswater.get_item_data(self.dlg_draw_profile, self.dlg_draw_profile.cmb_papersize, 0)
        x_dim = utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_x_dim)
        y_dim = utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_y_dim)
        if int(papersize_id) != 0:
            custom_dim = f'{{}}'
        else:
            custom_dim = f'{{"xdim":{x_dim}, "ydim":{y_dim}}}}}'
        title = utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_title)
        date = utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.date)


        # extras = f'"initNode":"116", "endNode":"111", "composer":"mincutA4", "legendFactor":1, "linksDistance":1, "scale":{{"scaleToFit":false, "eh":2000, "ev":500}},"papersize":{{"id":0, "customDim":{{"xdim":300, "ydim":100}}}}, "ComposerTemplates":[{{"ComposerTemplate":"mincutA4", "ComposerMap":[{{"width":"179.0","height":"140.826","index":0, "name":"map0"}},{{"width":"77.729","height":"55.9066","index":1, "name":"map7"}}]}},{{"ComposerTemplate":"mincutA3","ComposerMap":[{{"width":"53.44","height":"55.9066","index":0, "name":"map7"}},{{"width":"337.865","height":"275.914","index":1, "name":"map6"}}]}}]'
        extras = f'"initNode":"{self.initNode}", "endNode":"{self.endNode}", "composer":"mincutA4", "legendFactor":{legend_factor}, "linksDistance":{links_distance}, "scale":{{"scaleToFit":"{scale_to_fit}", "eh":{eh}, "ev":{ev}}}, "papersize":{{"id":{int(papersize_id)}, "customDim":{custom_dim}, "ComposerTemplates":[{{"ComposerTemplate":"mincutA4", "ComposerMap":[{{"width":"179.0","height":"140.826","index":0, "name":"map0"}},{{"width":"77.729","height":"55.9066","index":1, "name":"map7"}}]}},{{"ComposerTemplate":"mincutA3","ComposerMap":[{{"width":"53.44","height":"55.9066","index":0, "name":"map7"}},{{"width":"337.865","height":"275.914","index":1, "name":"map6"}}]}}]'
        body = self.create_body(extras=extras)
        self.profile_json = self.controller.get_json('gw_fct_getprofilevalues', body, log_sql=True)
        if not self.profile_json: return
        self.paint_event(self.profile_json['body']['data']['arc'], self.profile_json['body']['data']['node'],self.profile_json['body']['data']['terrain'])

        # Maximize window (after drawing)
        self.plot.show()
        mng = self.plot.get_current_fig_manager()
        mng.window.showMaximized()


    def save_profile(self):
        """ Save profile """

        profile_id = utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_profile_id)

        list_arc = []
        n = self.dlg_draw_profile.tbl_list_arc.count()
        for i in range(n):
            list_arc.append(int(self.dlg_draw_profile.tbl_list_arc.item(i).text()))

        links_distance = utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_min_distance)
        legend_factor = utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_legend_factor)
        scale_to_fit = utils_giswater.isChecked(self.dlg_draw_profile, "chk_scalte_to_fit")
        eh = utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_horizontal)
        ev = utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_vertical)

        papersize_id = utils_giswater.get_item_data(self.dlg_draw_profile, self.dlg_draw_profile.cmb_papersize, 0)
        x_dim = utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_x_dim)
        y_dim = utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_y_dim)
        if int(papersize_id) != 0:
            custom_dim = f'{{}}'
        else:
            custom_dim = f'{{"xdim":{x_dim}, "ydim":{y_dim}}}'
        title = utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_title)
        date = utils_giswater.getCalendarDate(self.dlg_draw_profile, self.dlg_draw_profile.date, date_format='dd/MM/yyyy')

        extras = f'"profile_id":"{profile_id}", "listArcs":"{list_arc}","initNode":"{self.initNode}", "endNode":"{self.endNode}", "composer":"mincutA4", "legendFactor":{legend_factor}, "linksDistance":{links_distance}, "scale":{{"scaleToFit":"{scale_to_fit}", "eh":{eh}, "ev":{ev}}}, "title":"{title}", "date":"{date}", "papersize":{{"id":{int(papersize_id)}, "customDim":{custom_dim}}}'
        body = self.create_body(extras=extras)
        result = self.controller.get_json('gw_fct_setprofile', body, log_sql=True)
        message = f"{result['message']}"
        self.controller.show_info(message)


    def open_profile(self):
        """ Open dialog load_profiles.ui """

        self.dlg_load = ProfilesList()
        self.load_settings(self.dlg_load)

        self.dlg_load.rejected.connect(partial(self.close_dialog, self.dlg_load.rejected))
        self.dlg_load.btn_open.clicked.connect(self.load_profile)
        self.dlg_load.btn_delete_profile.clicked.connect(self.delete_profile)

        sql = "SELECT DISTINCT(profile_id) FROM om_profile ORDER BY profile_id"
        rows = self.controller.get_rows(sql)
        if rows:
            for row in rows:
                item_arc = QListWidgetItem(str(row[0]))
                self.dlg_load.tbl_profiles.addItem(item_arc)

        self.open_dialog(self.dlg_load)
        self.deactivate()


    def load_profile(self):
        """ Open selected profile from dialog load_profiles.ui """

        selected_list = self.dlg_load.tbl_profiles.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        # Selected item from list
        profile_id = self.dlg_load.tbl_profiles.currentItem().text()

        extras = f'"profile_id":"{profile_id}", "action":"load"'
        body = self.create_body(extras=extras)
        result = self.controller.get_json('gw_fct_getprofile', body, log_sql=True)
        if not result: return
        message = f"{result['message']}"
        self.controller.show_info(message)
        self.close_dialog(self.dlg_load)

        # Setting parameters on profile form
        self.dlg_draw_profile.btn_draw_profile.setEnabled(True)
        self.dlg_draw_profile.btn_save_profile.setEnabled(True)
        self.initNode = result['body']['data']['initNode']
        self.endNode = result['body']['data']['endNode']

        self.dlg_draw_profile.txt_profile_id.setText(str(profile_id))
        list_arcs = json.loads(result['body']['data']['listArcs'])
        self.dlg_draw_profile.tbl_list_arc.clear()
        for arc in list_arcs:
            item_arc = QListWidgetItem(str(arc))
            self.dlg_draw_profile.tbl_list_arc.addItem(item_arc)
        self.dlg_draw_profile.txt_min_distance.setText(str(result['body']['data']['linksDistance']))
        self.dlg_draw_profile.txt_legend_factor.setText(str(result['body']['data']['legendFactor']))

        utils_giswater.set_combo_itemData(self.dlg_draw_profile.cmb_papersize, result['body']['data']['papersize']['id'], 0)
        if 'customDim' in result['body']['data']['papersize']:
            self.dlg_draw_profile.txt_x_dim.setText(str(result['body']['data']['papersize']['customDim']['xdim']))
            self.dlg_draw_profile.txt_y_dim.setText(str(result['body']['data']['papersize']['customDim']['ydim']))
        self.dlg_draw_profile.txt_title.setText(str(result['body']['data']['title']))
        date = QDate.fromString(result['body']['data']['date'], 'dd-MM-yyyy')
        utils_giswater.setCalendarDate(self.dlg_draw_profile, self.dlg_draw_profile.date, date)
        self.dlg_draw_profile.chk_scalte_to_fit.setChecked(result['body']['data']['scale']['scaleToFit'])
        self.dlg_draw_profile.txt_horizontal.setText(str(result['body']['data']['scale']['eh']))
        self.dlg_draw_profile.txt_vertical.setText(str(result['body']['data']['scale']['ev']))

        self.layer_arc = self.controller.get_layer_by_tablename("v_edit_arc")
        self.remove_selection()
        list_arcs = json.loads(result['body']['data']['listArcs'])
        expr_filter = "\"arc_id\" IN ("
        for arc in list_arcs:
            expr_filter += f"'{arc}', "
        expr_filter = expr_filter[:-2] + ")"
        expr = QgsExpression(expr_filter)
        # Get a featureIterator from this expression:
        it = self.layer_arc.getFeatures(QgsFeatureRequest(expr))

        self.id_list = [i.id() for i in it]
        self.layer_arc.selectByIds(self.id_list)

        # Center shortest path in canvas - ZOOM SELECTION
        self.canvas.zoomToSelected(self.layer_arc)


    def activate_snapping_node(self):

        self.initNode = None
        self.endNode = None
        self.first_node = True
        # Create the appropriate map tool and connect the gotPoint() signal.
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.snapper = self.snapper_manager.get_snapper()
        self.iface.setActiveLayer(self.layer_node)
        self.canvas.xyCoordinates.connect(self.mouse_move)

        self.emit_point.canvasClicked.connect(partial(self.snapping_node))


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

                if self.first_node:
                    self.initNode = element_id
                    self.first_node = False
                else:
                    self.endNode = element_id
                    self.action_profile.setDisabled(True)
                    self.disconnect_snapping()
                    self.dlg_draw_profile.btn_draw_profile.setEnabled(True)
                    self.dlg_draw_profile.btn_save_profile.setEnabled(True)

                    # Populate list arcs
                    extras = f'"initNode":"{self.initNode}", "endNode":"{self.endNode}"'
                    body = self.create_body(extras=extras)
                    result = self.controller.get_json('gw_fct_getprofilevalues', body, log_sql=True)

                    self.layer_arc = self.controller.get_layer_by_tablename("v_edit_arc")
                    self.remove_selection()
                    list_arcs = []
                    for arc in result['body']['data']['arc']:
                        item_arc = QListWidgetItem(str(arc['arc_id']))
                        self.dlg_draw_profile.tbl_list_arc.addItem(item_arc)
                        list_arcs.append(arc['arc_id'])


                    expr_filter = "\"arc_id\" IN ("
                    for arc in result['body']['data']['arc']:
                        expr_filter += f"'{arc['arc_id']}', "
                    expr_filter = expr_filter[:-2] + ")"
                    expr = QgsExpression(expr_filter)
                    # Get a featureIterator from this expression:
                    it = self.layer_arc.getFeatures(QgsFeatureRequest(expr))

                    self.id_list = [i.id() for i in it]
                    self.layer_arc.selectByIds(self.id_list)

                    # Center shortest path in canvas - ZOOM SELECTION
                    self.canvas.zoomToSelected(self.layer_arc)


    def disconnect_snapping(self, action_pan=True):
        """ Select 'Pan' as current map tool and disconnect snapping """

        try:
            self.canvas.xyCoordinates.disconnect()
        except TypeError as e:
            self.controller.log_info(f"{type(e).__name__} --> {e}")

        try:
            self.emit_point.canvasClicked.disconnect()
        except TypeError as e:
            self.controller.log_info(f"{type(e).__name__} --> {e}")

        if action_pan:
            self.iface.actionPan().trigger()
        try:
            self.vertex_marker.hide()
        except AttributeError as e:
            self.controller.log_info(f"{type(e).__name__} --> {e}")


    def paint_event(self, arcs, nodes, terrains):
        """ Parent function - Draw profiles """

        # Clear plot
        plt.gcf().clear()

        # arc_id ,node_id list of nodes and arc form dijkstra algoritam
        self.set_parameters(arcs, nodes, terrains)

        self.fill_memory(arcs, nodes, terrains)
        self.set_table_parameters()

        # Start drawing
        # Draw first | start node
        self.draw_first_node(self.nodes[0])

        # Draw nodes between first and last node
        for i in range(1, self.n - 1):
            self.draw_nodes(self.nodes[i], self.nodes[i - 1], i)

        # Draw ground first node and nodes between first and last node
        for i in range(1, self.t):
            self.first_top_x = self.links[i-1].start_point
            self.node_top_x = self.links[i].start_point
            self.first_top_y = self.links[i-1].node_id # node_id = top_n1
            self.node_top_y =  self.links[i-1].geom # geom = top_n2
            self.draw_ground()

            # DRAW TABLE-MARKS
            self.draw_marks(self.node_top_x, first_vl=False)
            # Fill table
            self.fill_link_data(self.node_top_x, i, self.reverse)

        # Draw ground last nodes
        self.first_top_x = self.links[-1].start_point
        self.node_top_x = self.nodes[-1].start_point
        self.first_top_y = self.links[-1].top_elev
        self.node_top_y = self.nodes[-1].top_elev
        self.draw_ground()

        # Draw last node
        self.draw_last_node(self.nodes[self.n - 1], self.nodes[self.n - 2], self.n - 1)

        # self.draw_ground()
        # Set correct variable for draw ground (drawn centered)
        # self.first_top_x = self.first_top_x + self.nodes[self.n - 2].geom / 2

        # self.draw_ground()
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
        # x_max = self.profile_json['body']['data']['extension']['width']
        self.axes.set_xlim([x_min, x_max])

        # Set y-axes
        y_min = round(self.min_top_elev - self.z - self.height_row*Decimal(1.5))
        y_max = round(Decimal(self.max_top_elev) +Decimal(self.height_row)*Decimal(1.5))
        # y_max = self.profile_json['body']['data']['extension']['height']
        self.axes.set_ylim([y_min, y_max + 1 ])

        # Draw margins
        x = [x_min, x_min]
        y = [y_min, y_max]
        plt.plot(x, y, 'black', zorder=100)

        x = [x_min, x_max]
        y = [y_min, y_min]
        plt.plot(x, y, 'black', zorder=100)

        x = [x_max, x_max]
        y = [y_min, y_max]
        plt.plot(x, y, 'black', zorder=100)

        x = [x_max, x_min]
        y = [y_max, y_max]
        plt.plot(x, y, 'black', zorder=100)


    def set_parameters(self, arcs, nodes, terrains):
        """ Get and calculate parameters and values for drawing """

        # Declare list elements
        self.list_of_selected_arcs = arcs
        self.list_of_selected_nodes = []
        self.list_of_selected_terrains = []

        # Populate list nodes
        for node in nodes:
            self.list_of_selected_nodes.append(node)
        # Populate list terrains
        for terrain in terrains:
            self.list_of_selected_terrains.append(terrain)

        self.gis_length = [0]
        self.start_point = [0]

        # Get arcs between nodes (on shortest path)
        self.n = len(self.list_of_selected_nodes)
        self.t = len(self.list_of_selected_terrains)

        for arc in arcs:
            self.gis_length.append(arc['length'])
        # Calculate start_point (coordinates) of drawing for each node
        n = len(self.gis_length)
        for i in range(1, n):
            x = self.start_point[i - 1] + self.gis_length[i]
            self.start_point.append(x)
            i += 1


    def fill_memory(self, arcs, nodes, terrains):
        """ Get parameters from data base. Fill self.nodes with parameters postgres """

        # Get parameters and fill the nodes
        n = 0
        for node in nodes:
            parameters = NodeData()
            parameters.start_point = self.start_point[n]

            parameters.top_elev = [json.loads(node['descript'], object_pairs_hook=OrderedDict)][0]['top_elev']
            parameters.ymax = [json.loads(node['descript'], object_pairs_hook=OrderedDict)][0]['ymax']
            parameters.elev = [json.loads(node['descript'], object_pairs_hook=OrderedDict)][0]['elev']
            parameters.code = [json.loads(node['descript'], object_pairs_hook=OrderedDict)][0]['code']
            parameters.total_distance = [json.loads(node['descript'], object_pairs_hook=OrderedDict)][0]['total_distance']
            parameters.node_id = node['node_id']
            parameters.geom = node['cat_geom1']

            self.nodes.append(parameters)
            n = n + 1

        n = 0
        for terrain in terrains:
            parameters = NodeData()
            parameters.start_point = terrain['total_x']

            parameters.top_elev = [json.loads(terrain['label_n1'], object_pairs_hook=OrderedDict)][0]['top_elev']
            parameters.ymax = [json.loads(terrain['label_n1'], object_pairs_hook=OrderedDict)][0]['ymax']
            parameters.elev = [json.loads(terrain['label_n1'], object_pairs_hook=OrderedDict)][0]['elev']
            parameters.code = [json.loads(terrain['label_n1'], object_pairs_hook=OrderedDict)][0]['code']
            parameters.total_distance = [json.loads(terrain['label_n1'], object_pairs_hook=OrderedDict)][0]['total_distance']
            parameters.node_id = terrain['top_n1']
            parameters.geom = terrain['top_n2']

            self.links.append(parameters)
            n = n + 1

        n = 0
        # Check if is reverse profile
        if self.nodes[n] == arcs[0]['node_1']:
            for arc in arcs:
                self.nodes[n].z1 = arc['z1']
                self.nodes[n].z2 = arc['z2']
                self.nodes[n].cat_geom = arc['cat_geom1']
                self.nodes[n].elev1 = arc['elev1']
                self.nodes[n].elev2 = arc['elev2']
                self.nodes[n].y1 = arc['y1']
                self.nodes[n].y2 = arc['y2']
                # TODO:: Send SLOPE for arc
                self.nodes[n].slope = 1
                self.nodes[n].node_1 = arc['node_1']
                self.nodes[n].node_2 = arc['node_2']

                n += 1
        else:
            # TODO:: Dont use reversed and sort arcs
            for arc in (arcs):
                self.nodes[n].z1 = arc['z1']
                self.nodes[n].z2 = arc['z2']
                self.nodes[n].cat_geom = arc['cat_geom1']
                self.nodes[n].elev1 = arc['elev1']
                self.nodes[n].elev2 = arc['elev2']
                self.nodes[n].y1 = arc['y1']
                self.nodes[n].y2 = arc['y2']
                #TODO:: Send SLOPE for arc
                self.nodes[n].slope = 1
                self.nodes[n].node_1 = arc['node_1']
                self.nodes[n].node_2 = arc['node_2']
                n += 1



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

        row = self.controller.get_config('draw_profile_conf')
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
        y = [self.min_top_elev -  Decimal(1.9) * self.height_row, self.min_top_elev -  Decimal(5.10) * self.height_row]
        plt.plot(x, y, 'black', zorder=100)

        # Vertical line [-3,0]
        x = [start_point - self.fix_x, start_point - self.fix_x]
        y = [self.min_top_elev - 1 * self.height_row, self.min_top_elev - 6 * self.height_row]
        plt.plot(x, y, 'black', zorder=100)

        # Fill the fixed part of table with data - draw text
        # Called just with first node
        self.data_fix_table(start_point, reverse)


    def draw_marks(self, start_point, first_vl=True):
        """ Draw marks for each node """

        if first_vl:
            # Vertical line [0,0]
            x = [start_point, start_point]
            y = [self.min_top_elev - 1 * self.height_row,
                 self.min_top_elev - Decimal(1.9) * self.height_row - Decimal(0.15) * self.height_row]
            plt.plot(x, y, 'black', zorder=100)

        # Vertical lines [0,0] - marks
        x = [start_point, start_point]
        y = [self.min_top_elev - Decimal(2.60) * self.height_row, self.min_top_elev - Decimal(2.85) * self.height_row]
        plt.plot(x, y, 'black', zorder=100)

        x = [start_point, start_point]
        y = [self.min_top_elev - Decimal(3.4) * self.height_row, self.min_top_elev - Decimal(3.65) * self.height_row]
        plt.plot(x, y, 'black', zorder=100)

        x = [start_point, start_point]
        y = [self.min_top_elev - Decimal(4.20) * self.height_row, self.min_top_elev - Decimal(4.45) * self.height_row]
        plt.plot(x, y, 'black', zorder=100)

        x = [start_point, start_point]
        y = [self.min_top_elev - Decimal(5) * self.height_row, self.min_top_elev - Decimal(5.25) * self.height_row]
        plt.plot(x, y, 'black', zorder=100)


    def data_fix_table(self, start_point, reverse):  #@UnusedVariable
        """ FILL THE FIXED PART OF TABLE WITH DATA - DRAW TEXT """

        legend = self.profile_json['body']['data']['legend']
        c = (self.fix_x - self.fix_x * Decimal(0.2)) / 2
        plt.text(-(c + self.fix_x * Decimal(0.2)),
                 self.min_top_elev - 1 * self.height_row - Decimal(0.35) * self.height_row, 'DIAMETER', fontsize=7.5,
                 horizontalalignment='center')

        plt.text(-(c + self.fix_x * Decimal(0.2)),
                 self.min_top_elev - 1 * self.height_row - Decimal(0.68) * self.height_row, legend['dimensions'],
                 fontsize=7.5,
                 horizontalalignment='center')

        c = (self.fix_x * Decimal(0.25)) / 2
        plt.text(-(c + self.fix_x * Decimal(0.74)),
                 self.min_top_elev - Decimal(2) * self.height_row - self.height_row * 3 / 2, legend['ordinates'], fontsize=7.5,
                 rotation='vertical', horizontalalignment='center', verticalalignment='center')

        plt.text(-self.fix_x * Decimal(0.70), self.min_top_elev - Decimal(1.85) * self.height_row - self.height_row / 2,
                 legend['topelev'], fontsize=7.5, verticalalignment='center')
        plt.text(-self.fix_x * Decimal(0.70), self.min_top_elev - Decimal(2.65) * self.height_row - self.height_row / 2,
                 legend['ymax'], fontsize=7.5, verticalalignment='center')
        plt.text(-self.fix_x * Decimal(0.70), self.min_top_elev - Decimal(3.45) * self.height_row - self.height_row / 2,
                 legend['elev'], fontsize=7.5, verticalalignment='center')
        plt.text(-self.fix_x * Decimal(0.70), self.min_top_elev - Decimal(4.25) * self.height_row - self.height_row / 2,
                 'TOTAL LENGTH', fontsize=7.5, verticalalignment='center')

        c = (self.fix_x - self.fix_x * Decimal(0.2)) / 2
        plt.text(-(c + self.fix_x * Decimal(0.2)),
                 self.min_top_elev - Decimal(self.height_row * 5 + self.height_row / 2), legend['code'], fontsize=7.5,
                 horizontalalignment='center', verticalalignment='center')

        scale = self.profile_json['body']['data']['scale']
        title = utils_giswater.getWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.txt_title)
        if title in (None, 'null'):
            title = ''

        plt.text(-self.fix_x * Decimal(1), self.min_top_elev - Decimal(5.75) * self.height_row - self.height_row / 2,
                 title, fontsize=11, verticalalignment='center')
        plt.text(-self.fix_x * Decimal(1), self.min_top_elev - Decimal(6) * self.height_row - self.height_row / 2,
                 str(scale) + " / " + str(utils_giswater.getCalendarDate(self.dlg_draw_profile, self.dlg_draw_profile.date)),  verticalalignment='center')

        # Fill table with values
        self.fill_data(0, 0, reverse)


    def draw_nodes(self, node, prev_node, index):
        """ Draw nodes between first and last node """

        if node.node_id == prev_node.node_2:
            z1 = prev_node.z2
            self.reverse = False
        elif node.node_id == str(prev_node.node_1):
            z1 = prev_node.z1
            self.reverse = True

        if node.node_1 is None:
            return
        if node.node_id == node.node_1:
            z2 = node.z1
        elif node.node_id == node.node_2:
            z2 = node.z2

        # Get superior points
        s1x = self.slast[0]
        s1y = self.slast[1]
        if node.geom is None:
            node.geom = 0
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

        row = self.controller.get_config('draw_profile_conf')
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
        self.fill_data(node.start_point, index, self.reverse)

        # Save last points before the last node
        self.slast = [s5x, s5y]
        self.ilast = [i5x, i5y]


        # Save last points for draw ground
        self.slast2 = [s3x, s3y]
        self.ilast2 = [i3x, i3y]


    def fill_data(self, start_point, indx, reverse=False):

        # Fill top_elevation and node_id for all nodes
        plt.annotate(' ' + '\n' + str(round(self.nodes[indx].top_elev, 2)) + '\n' + ' ',
                     xy=(Decimal(start_point), self.min_top_elev - Decimal(self.height_row * Decimal(1.8) + self.height_row / 2)),
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
                                 self.min_top_elev - Decimal(self.height_row * Decimal(2.60) + self.height_row / 2)), fontsize=6,
                             rotation='vertical', horizontalalignment='center', verticalalignment='center')
                # Fill elevation
                plt.annotate(' ' + '\n' + str(round(self.nodes[0].elev, 2)) + '\n' + str(round(self.nodes[0].elev2, 2)),
                             xy=(Decimal(0 + start_point),
                                 self.min_top_elev - Decimal(self.height_row * Decimal(3.40) + self.height_row / 2)), fontsize=6,
                             rotation='vertical', horizontalalignment='center', verticalalignment='center')

                # Fill total length
                plt.annotate(str(round(self.nodes[indx].total_distance, 2)),
                             xy=(Decimal(0 + start_point),
                                 self.min_top_elev - Decimal(self.height_row * Decimal(4.20) + self.height_row / 2)),
                             fontsize=6,
                             rotation='vertical', horizontalalignment='center', verticalalignment='center')

            # Last node : y_max,y1 and top_elev, elev1
            elif indx == self.n - 1:
                pass
                # Fill y_max
                plt.annotate(
                    str(round(self.nodes[indx - 1].y1, 2)) + '\n' + str(
                        round(self.nodes[indx].ymax, 2)) + '\n' + ' ',
                    xy=(Decimal(0 + start_point),
                        self.min_top_elev - Decimal(self.height_row * Decimal(2.60) + self.height_row / 2)), fontsize=6,
                    rotation='vertical', horizontalalignment='center', verticalalignment='center')
                # Fill elevation
                plt.annotate(
                    str(round(self.nodes[indx - 1].elev1, 2)) + '\n' + str(
                        round(self.nodes[indx].elev, 2)) + '\n' + ' ',
                    xy=(Decimal(0 + start_point),
                        self.min_top_elev - Decimal(self.height_row * Decimal(3.40) + self.height_row / 2)), fontsize=6,
                    rotation='vertical', horizontalalignment='center', verticalalignment='center')

                # Fill total length
                plt.annotate(str(round(self.nodes[indx].total_distance, 2)),
                             xy=(Decimal(0 + start_point),
                                 self.min_top_elev - Decimal(self.height_row * Decimal(4.20) + self.height_row / 2)),
                             fontsize=6,
                             rotation='vertical', horizontalalignment='center', verticalalignment='center')
            else:
                # Fill y_max
                plt.annotate(
                    str(round(self.nodes[indx - 1].y1, 2)) + '\n' + str(
                        round(self.nodes[indx].ymax, 2)) + '\n' + str(
                        round(self.nodes[indx].y1, 2)),
                    xy=(Decimal(0 + start_point),
                        self.min_top_elev - Decimal(self.height_row * Decimal(2.60) + self.height_row / 2)), fontsize=6,
                    rotation='vertical', horizontalalignment='center', verticalalignment='center')
                # Fill elevation
                plt.annotate(
                    str(round(self.nodes[indx - 1].elev1, 2)) + '\n' + str(
                        round(self.nodes[indx].elev, 2)) + '\n' + str(
                        round(self.nodes[indx].elev1, 2)),
                    xy=(Decimal(0 + start_point),
                        self.min_top_elev - Decimal(self.height_row * Decimal(3.40) + self.height_row / 2)), fontsize=6,
                    rotation='vertical', horizontalalignment='center', verticalalignment='center')

                # Fill total length
                plt.annotate(str(round(self.nodes[indx].total_distance, 2)),
                             xy=(Decimal(0 + start_point),
                                 self.min_top_elev - Decimal(self.height_row * Decimal(4.20) + self.height_row / 2)),
                             fontsize=6,
                             rotation='vertical', horizontalalignment='center', verticalalignment='center')
        else:
            # Fill y_max and elevation
            # 1st node : y_max,y2 and top_elev, elev2
            if indx == 0:
                    # # Fill y_max
                    plt.annotate(' ' + '\n' + str(round(self.nodes[0].ymax, 2)) + '\n' + str(round(self.nodes[0].y1, 2)),
                                 xy=(Decimal(0 + start_point),
                                     self.min_top_elev - Decimal(self.height_row * Decimal(2.60) + self.height_row / 2)), fontsize=6,
                                 rotation='vertical', horizontalalignment='center', verticalalignment='center')

                    # Fill elevation
                    plt.annotate(' ' + '\n' + str(round(self.nodes[0].elev, 2)) + '\n' + str(round(self.nodes[0].elev1, 2)),
                                 xy=(Decimal(0 + start_point),
                                     self.min_top_elev - Decimal(self.height_row * Decimal(3.40) + self.height_row / 2)), fontsize=6,
                                 rotation='vertical', horizontalalignment='center', verticalalignment='center')

                    # Fill total length
                    plt.annotate(str(round(self.nodes[indx].total_distance, 2)),
                                 xy=(Decimal(0 + start_point),
                                     self.min_top_elev - Decimal(
                                         self.height_row * Decimal(4.20) + self.height_row / 2)),
                                 fontsize=6,
                                 rotation='vertical', horizontalalignment='center', verticalalignment='center')

            # Last node : y_max,y1 and top_elev, elev1
            elif indx == self.n - 1:
                pass
                # Fill y_max
                plt.annotate(
                    str(round(self.nodes[indx - 1].y2, 2)) + '\n' + str(round(self.nodes[indx].ymax, 2)) + '\n' + ' ',
                    xy=(Decimal(0 + start_point),
                        self.min_top_elev - Decimal(self.height_row * Decimal(2.60) + self.height_row / 2)), fontsize=6,
                    rotation='vertical', horizontalalignment='center', verticalalignment='center')

                # Fill elevation
                plt.annotate(
                    str(round(self.nodes[indx - 1].elev2, 2)) + '\n' + str(
                        round(self.nodes[indx].elev, 2)) + '\n' + ' ',
                    xy=(Decimal(0 + start_point),
                        self.min_top_elev - Decimal(self.height_row * Decimal(3.40) + self.height_row / 2)), fontsize=6,
                    rotation='vertical', horizontalalignment='center', verticalalignment='center')

                # Fill total length
                plt.annotate(str(round(self.nodes[indx].total_distance, 2)),
                             xy=(Decimal(0 + start_point),
                                 self.min_top_elev - Decimal(self.height_row * Decimal(4.20) + self.height_row / 2)),
                             fontsize=6,
                             rotation='vertical', horizontalalignment='center', verticalalignment='center')
            # Nodes between 1st and last node : y_max,y1,y2 and top_elev, elev1, elev2
            else:
                # Fill y_max
                plt.annotate(
                    str(round(self.nodes[indx - 1].y2, 2)) + '\n' + str(round(self.nodes[indx].ymax, 2)) + '\n' + str(
                        round(self.nodes[indx].y1, 2)),
                    xy=(Decimal(0 + start_point),
                        self.min_top_elev - Decimal(self.height_row * Decimal(2.60) + self.height_row / 2)), fontsize=6,
                    rotation='vertical', horizontalalignment='center', verticalalignment='center')

                # Fill elevation
                plt.annotate(
                    str(round(self.nodes[indx - 1].elev2, 2)) + '\n' + str(
                        round(self.nodes[indx].elev, 2)) + '\n' + str(
                        round(self.nodes[indx].elev1, 2)),
                    xy=(Decimal(0 + start_point),
                        self.min_top_elev - Decimal(self.height_row * Decimal(3.40) + self.height_row / 2)), fontsize=6,
                    rotation='vertical', horizontalalignment='center', verticalalignment='center')

                # Fill total length
                plt.annotate(str(round(self.nodes[indx].total_distance, 2)),
                             xy=(Decimal(0 + start_point),
                                 self.min_top_elev - Decimal(self.height_row * Decimal(4.20) + self.height_row / 2)),
                             fontsize=6,
                             rotation='vertical', horizontalalignment='center', verticalalignment='center')

        # Fill diameter and slope / length for all nodes except last node
        if indx != self.n - 1:
            # Draw diameter
            center = self.gis_length[indx + 1] / 2
            plt.text(center + start_point, self.min_top_elev - 1 * self.height_row - Decimal(0.35) * self.height_row,
                     round(self.nodes[indx].cat_geom, 2),
                     fontsize=7.5, horizontalalignment='center')  # PUT IN THE MIDDLE PARAMETRIZATION
            # Draw slope / length
            slope = str(round((self.nodes[indx].slope * 100), 2))
            length = str(round(self.gis_length[indx + 1], 2))

            plt.text(center + start_point, self.min_top_elev - 1 * self.height_row - Decimal(0.68) * self.height_row,
                     slope + '%/' + length,
                     fontsize=7.5, horizontalalignment='center')  # PUT IN THE MIDDLE PARAMETRIZATION


    def fill_link_data(self, start_point, indx, reverse=False):

        # Fill top_elevation and node_id for all nodes
        plt.annotate(' ' + '\n' + str(round(self.links[indx].top_elev, 2)) + '\n' + ' ',
                     xy=(Decimal(start_point), self.min_top_elev - Decimal(self.height_row * Decimal(1.8) + self.height_row / 2)),
                     fontsize=6, rotation='vertical', horizontalalignment='center', verticalalignment='center')

        # Draw node_id
        plt.text(0 + start_point, self.min_top_elev - Decimal(self.height_row * Decimal(5) + self.height_row / 2),
                 self.links[indx].code, fontsize=7.5,
                 horizontalalignment='center', verticalalignment='center')

        # Manage variables elev and y (elev1, elev2, y1, y2) acoording flow trace
        if reverse:
            # # Fill y_max
            plt.annotate(' ' + '\n' + str(round(self.links[0].ymax, 2)),
                 xy=(Decimal(0 + start_point),
                     self.min_top_elev - Decimal(self.height_row * Decimal(2.60) + self.height_row / 2)), fontsize=6,
                 rotation='vertical', horizontalalignment='center', verticalalignment='center')
            # Fill elevation
            plt.annotate(' ' + '\n' + str(round(self.links[0].elev, 2)),
                 xy=(Decimal(0 + start_point),
                     self.min_top_elev - Decimal(self.height_row * Decimal(3.40) + self.height_row / 2)), fontsize=6,
                 rotation='vertical', horizontalalignment='center', verticalalignment='center')
            # Fill total length
            plt.annotate(str(round(self.links[0].total_distance, 2)),
                 xy=(Decimal(0 + start_point),
                     self.min_top_elev - Decimal(self.height_row * Decimal(4.20) + self.height_row / 2)),
                 fontsize=6,
                 rotation='vertical', horizontalalignment='center', verticalalignment='center')
        else:
            # Fill y_max
            plt.annotate(
                str(round(self.links[indx].ymax, 2)),
                xy=(Decimal(0 + start_point),
                    self.min_top_elev - Decimal(self.height_row * Decimal(2.60) + self.height_row / 2)), fontsize=6,
                rotation='vertical', horizontalalignment='center', verticalalignment='center')

            # Fill elevation
            plt.annotate(
                str(round(self.links[indx].elev, 2)),
                xy=(Decimal(0 + start_point),
                    self.min_top_elev - Decimal(self.height_row * Decimal(3.40) + self.height_row / 2)), fontsize=6,
                rotation='vertical', horizontalalignment='center', verticalalignment='center')

            # Fill total length
            plt.annotate(str(round(self.links[indx].total_distance, 2)),
                 xy=(Decimal(0 + start_point),
                     self.min_top_elev - Decimal(self.height_row * Decimal(4.20) + self.height_row / 2)),
                 fontsize=6,
                 rotation='vertical', horizontalalignment='center', verticalalignment='center')


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

        row = self.controller.get_config('draw_profile_conf')
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
        self.min_top_elev = Decimal(self.nodes[0].top_elev - self.nodes[0].ymax)

        for i in range(1, self.n):
            if (self.nodes[i].top_elev - self.nodes[i].ymax) < self.min_top_elev:
                self.min_top_elev = Decimal(self.nodes[i].top_elev - self.nodes[i].ymax)
        # Search y coordinate max_top_elev
        self.max_top_elev = self.nodes[0].top_elev
        for i in range(1, self.n):
            if self.nodes[i].top_elev > self.max_top_elev:
                self.max_top_elev = self.nodes[i].top_elev
        # Calculating dimensions of x-fixed part of table
        self.fix_x = Decimal(Decimal(0.15) * self.nodes[self.n - 1].start_point)
        # Calculating dimensions of y-fixed part of table
        # Height y = height of table + height of graph
        self.z = Decimal(self.max_top_elev) - Decimal(self.min_top_elev)
        self.height_row = (Decimal(self.z) * Decimal(0.97)) / Decimal(5)
        # Height of graph + table
        self.height_y = Decimal(self.z * 2)

    def draw_table_horizontals(self):

        self.set_table_parameters()

        # DRAWING TABLE
        # Draw horizontal lines
        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x]
        y = [self.min_top_elev - self.height_row, self.min_top_elev - self.height_row]
        plt.plot(x, y, 'black',zorder=100)

        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x]
        y = [self.min_top_elev - Decimal(1.9) * self.height_row, self.min_top_elev - Decimal(1.9) * self.height_row]
        plt.plot(x, y, 'black',zorder=100)

        # Draw horizontal(shorter) lines
        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x * Decimal(0.75)]
        y = [self.min_top_elev - Decimal(2.70) * self.height_row, self.min_top_elev - Decimal(2.70) * self.height_row]
        plt.plot(x, y, 'black', zorder=100)
        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x * Decimal(0.75)]
        y = [self.min_top_elev - Decimal(3.50) * self.height_row, self.min_top_elev - Decimal(3.50) * self.height_row]
        plt.plot(x, y, 'black', zorder=100)
        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x * Decimal(0.75)]
        y = [self.min_top_elev - Decimal(4.30) * self.height_row, self.min_top_elev - Decimal(4.30) * self.height_row]
        plt.plot(x, y, 'black', zorder=100)


        # Last two lines
        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x]
        y = [self.min_top_elev - Decimal(5.10) * self.height_row, self.min_top_elev - Decimal(5.10) * self.height_row]
        plt.plot(x, y, 'black',zorder=100)
        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x]
        y = [self.min_top_elev - Decimal(6) * self.height_row, self.min_top_elev - Decimal(6) * self.height_row]
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
            row = self.controller.get_row(sql, log_sql=True)
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
            row = self.controller.get_row(sql, log_sql=True)
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

    def clear_profile(self):

        # Clear list of nodes and arcs
        self.list_of_selected_nodes = []
        self.list_of_selected_arcs = []
        self.arcs = []
        self.nodes = []
        self.start_end_node = []
        self.start_end_node = [None, None]

        self.dlg_draw_profile.txt_profile_id.clear()
        self.dlg_draw_profile.tbl_list_arc.clear()
        self.dlg_draw_profile.txt_min_distance.clear()
        self.dlg_draw_profile.txt_legend_factor.clear()
        self.dlg_draw_profile.txt_x_dim.clear()
        self.dlg_draw_profile.txt_y_dim.clear()
        self.dlg_draw_profile.txt_title.clear()
        self.dlg_draw_profile.txt_horizontal.clear()
        self.dlg_draw_profile.txt_vertical.clear()
        self.dlg_draw_profile.chk_scalte_to_fit.setChecked(False)
        self.action_profile.setDisabled(False)
        self.dlg_draw_profile.btn_draw_profile.setEnabled(False)
        self.dlg_draw_profile.btn_save_profile.setEnabled(False)

        # Clear selection
        self.remove_selection()
        self.deactivate()


    def set_template(self):

        template = self.dlg_draw_profile.cmb_composer.currentText()
        self.template = template[:-4]


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
                row = self.controller.get_row(sql, log_sql=True)
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
                row = self.controller.get_row(sql, log_sql=True)
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
            if str(self.start_end_node[0]) == self.start_end_node[1]:
                msg = "Start and End point must be different."
                self.controller.show_info_box(msg, "Info")
                disabled = True
                self.dlg_draw_profile.tbl_list_arc.clear()
            else:
                disabled = False
                self.shortest_path(str(self.start_end_node[0]), str(self.start_end_node[1]))
            self.dlg_draw_profile.btn_add_additional_point.setDisabled(disabled)
            self.dlg_draw_profile.list_additional_points.setDisabled(disabled)
            self.dlg_draw_profile.title.setDisabled(disabled)
            self.dlg_draw_profile.rotation.setDisabled(disabled)
            self.dlg_draw_profile.scale_vertical.setDisabled(disabled)
            self.dlg_draw_profile.scale_horizontal.setDisabled(disabled)

            # Get rotation vdefaut if exist
            row = self.controller.get_config('rotation_vdefault')
            if row:
                utils_giswater.setWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.rotation, row[0])
                self.rotation_vd_exist = True
            else:
                utils_giswater.setWidgetText(self.dlg_draw_profile, self.dlg_draw_profile.rotation, '0')

            # After executing of path enable btn_draw and open_composer
            self.dlg_draw_profile.btn_draw.setDisabled(disabled)
            self.dlg_draw_profile.btn_save_profile.setDisabled(disabled)
            self.dlg_draw_profile.btn_export_pdf.setDisabled(disabled)
            self.dlg_draw_profile.cbx_template.setDisabled(disabled)
            self.dlg_draw_profile.btn_update_path.setDisabled(disabled)

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
        profile_id = self.dlg_load.tbl_profiles.currentItem().text()

        extras = f'"profile_id":"{profile_id}", "action":"delete"'
        body = self.create_body(extras=extras)
        result = self.controller.get_json('gw_fct_loadprofile', body, log_sql=True)
        message = f"{result['message']}"
        self.controller.show_info(message)

        self.dlg_load.tbl_profiles.clear()
        sql = "SELECT DISTINCT(profile_id) FROM om_profile ORDER BY profile_id"
        rows = self.controller.get_rows(sql)
        if rows:
            for row in rows:
                item_arc = QListWidgetItem(str(row[0]))
                self.dlg_load.tbl_profiles.addItem(item_arc)


    def remove_selection(self):
        """ Remove selected features of all layers """

        for layer in self.canvas.layers():
            if type(layer) is QgsVectorLayer:
                layer.removeSelection()
        self.canvas.refresh()


    def manage_scale(self):

        status = self.dlg_draw_profile.chk_scalte_to_fit.isChecked()
        if status:
            self.dlg_draw_profile.txt_horizontal.setText('')
            self.dlg_draw_profile.txt_vertical.setText('')
            self.dlg_draw_profile.txt_horizontal.setReadOnly(True)
            self.dlg_draw_profile.txt_vertical.setReadOnly(True)
            self.dlg_draw_profile.txt_horizontal.setStyleSheet("QWidget { background: rgb(242, 242, 242);"
                                 " color: rgb(100, 100, 100)}")
            self.dlg_draw_profile.txt_vertical.setStyleSheet("QWidget { background: rgb(242, 242, 242);"
                                 " color: rgb(100, 100, 100)}")
        else:
            self.dlg_draw_profile.txt_horizontal.setReadOnly(False)
            self.dlg_draw_profile.txt_vertical.setReadOnly(False)
            self.dlg_draw_profile.txt_horizontal.setStyleSheet(None)
            self.dlg_draw_profile.txt_vertical.setStyleSheet(None)


    def manage_papersize(self):

        id = utils_giswater.get_item_data(self.dlg_draw_profile, self.dlg_draw_profile.cmb_papersize, 0)
        if int(id) == 0:
            self.dlg_draw_profile.txt_x_dim.setText('')
            self.dlg_draw_profile.txt_y_dim.setText('')
            self.dlg_draw_profile.txt_x_dim.setReadOnly(False)
            self.dlg_draw_profile.txt_y_dim.setReadOnly(False)
            self.dlg_draw_profile.txt_x_dim.setStyleSheet(None)
            self.dlg_draw_profile.txt_y_dim.setStyleSheet(None)
        else:
            dim = utils_giswater.get_item_data(self.dlg_draw_profile, self.dlg_draw_profile.cmb_papersize, 2)
            self.dlg_draw_profile.txt_x_dim.setText(str(dim['xdim']))
            self.dlg_draw_profile.txt_y_dim.setText(str(dim['ydim']))
            self.dlg_draw_profile.txt_x_dim.setReadOnly(True)
            self.dlg_draw_profile.txt_y_dim.setReadOnly(True)

            self.dlg_draw_profile.txt_x_dim.setStyleSheet("QWidget { background: rgb(242, 242, 242);"
                                                          " color: rgb(100, 100, 100)}")
            self.dlg_draw_profile.txt_y_dim.setStyleSheet("QWidget { background: rgb(242, 242, 242);"
                                                          " color: rgb(100, 100, 100)}")
