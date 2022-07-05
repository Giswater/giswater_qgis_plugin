"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json
import math
import matplotlib.pyplot as plt
import os
from collections import OrderedDict
from decimal import Decimal
from functools import partial

from qgis.PyQt.QtCore import Qt, QDate
from qgis.PyQt.QtGui import QDoubleValidator
from qgis.PyQt.QtWidgets import QListWidgetItem, QLineEdit, QAction
from qgis.core import QgsFeatureRequest, QgsVectorLayer, QgsExpression
from qgis.gui import QgsMapToolEmitPoint

from ..dialog import GwAction
from ...ui.ui_manager import GwProfileUi, GwProfilesListUi
from ...utils import tools_gw
from ...utils.snap_manager import GwSnapManager
from ....lib import tools_qt, tools_log, tools_qgis
from .... import global_vars


class GwNodeData:

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
        self.descript = None
        self.data_type = None
        self.surface_type = None
        self.none_values = None


class GwProfileButton(GwAction):
    """ Button 43: Profile """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        # Call ParentDialog constructor
        super().__init__(icon_path, action_name, text, toolbar, action_group)

        self.snapper_manager = GwSnapManager(self.iface)
        self.vertex_marker = self.snapper_manager.vertex_marker
        self.list_of_selected_nodes = []
        self.nodes = []
        self.links = []
        self.rotation_vd_exist = False
        self.lastnode_datatype = 'REAL'
        self.none_values = []
        self.add_points = False
        self.add_points_list = []


    def clicked_event(self):

        self.action.setChecked(True)

        # Remove all selections on canvas
        self._remove_selection()

        # Set dialog
        self.dlg_draw_profile = GwProfileUi()
        tools_gw.load_settings(self.dlg_draw_profile)
        self.dlg_draw_profile.setWindowFlags(Qt.WindowStaysOnTopHint)

        # Declare composer path widget
        self.composers_path = self.dlg_draw_profile.findChild(QLineEdit, "composers_path")

        # Set layer_node
        self.layer_node = tools_qgis.get_layer_by_tablename('v_edit_node', show_warning_=False)

        # Toolbar actions
        action = self.dlg_draw_profile.findChild(QAction, "actionProfile")
        tools_gw.add_icon(action, "131", sub_folder="24x24")
        action.triggered.connect(partial(self._activate_add_points, False))
        action.triggered.connect(partial(self._activate_snapping_node))
        self.action_profile = action

        action = self.dlg_draw_profile.findChild(QAction, "actionAddPoint")
        tools_gw.add_icon(action, "111", sub_folder="24x24")
        action.triggered.connect(partial(self._activate_add_points, True))
        action.triggered.connect(partial(self._activate_snapping_node))
        self.action_add_point = action
        self.action_add_point.setDisabled(True)

        # Set validators
        self.dlg_draw_profile.txt_min_distance.setValidator(QDoubleValidator())

        # Triggers
        self.dlg_draw_profile.btn_draw_profile.clicked.connect(partial(self._get_profile))
        self.dlg_draw_profile.btn_save_profile.clicked.connect(self._save_profile)
        self.dlg_draw_profile.btn_load_profile.clicked.connect(self._open_profile)
        self.dlg_draw_profile.btn_clear_profile.clicked.connect(self._clear_profile)
        self.dlg_draw_profile.dlg_closed.connect(partial(tools_gw.save_settings, self.dlg_draw_profile))
        self.dlg_draw_profile.dlg_closed.connect(partial(self._remove_selection, actionpan=True))
        self.dlg_draw_profile.dlg_closed.connect(partial(self._reset_profile_variables))
        self.dlg_draw_profile.dlg_closed.connect(partial(tools_gw.disconnect_signal, 'profile'))

        # Set shortcut keys
        self.dlg_draw_profile.key_escape.connect(partial(tools_gw.close_dialog, self.dlg_draw_profile))

        # Set calendar date as today
        tools_qt.set_calendar(self.dlg_draw_profile, "date", None)

        # Set last parameters
        tools_qt.set_widget_text(self.dlg_draw_profile, self.dlg_draw_profile.txt_min_distance,
                                 tools_gw.get_config_parser('btn_profile', 'min_distance_profile', "user", "session"))
        tools_qt.set_widget_text(self.dlg_draw_profile, self.dlg_draw_profile.txt_title,
                                 tools_gw.get_config_parser('btn_profile', 'title_profile', "user", "session"))

        # Show form in docker
        tools_gw.init_docker('qgis_form_docker')
        if global_vars.session_vars['dialog_docker']:
            tools_gw.docker_dialog(self.dlg_draw_profile)
        else:
            tools_gw.open_dialog(self.dlg_draw_profile)


    # region private functions

    def _reset_profile_variables(self):

        self.initNode = None
        self.endNode = None
        self.first_node = True
        self.add_points = False
        self.add_points_list = []


    def _activate_add_points(self, activate=True):
        self.add_points = activate


    def _get_profile(self):

        # Clear main variables
        self.nodes.clear()
        self.links.clear()
        self.nodes = []
        self.links = []
        self.none_values = []

        # Get parameters
        links_distance = tools_qt.get_text(self.dlg_draw_profile, self.dlg_draw_profile.txt_min_distance, False, False)
        if links_distance in ("", "None", None):
            links_distance = 1

        # Create variable with all the content of the form
        extras = f'"initNode":"{self.initNode}", "endNode":"{self.endNode}", ' \
                 f'"linksDistance":{links_distance}, "scale":{{ "eh":1000, "ev":1000}}'
        if self.add_points_list:
            l = str(self.add_points_list).replace("'", "")
            extras += f', "midNodes":{l}'

        body = tools_gw.create_body(extras=extras)

        # Execute query
        self.profile_json = tools_gw.execute_procedure('gw_fct_getprofilevalues', body)
        if self.profile_json is None or self.profile_json['status'] == 'Failed':
            return

        # Manage level and message from query result
        if self.profile_json['message']:
            level = int(self.profile_json['message']['level'])
            tools_qgis.show_message(self.profile_json['message']['text'], level)
            if self.profile_json['message']['level'] != 3:
                return

        if not self.profile_json:
            return

        # Execute draw profile
        self._draw_profile(self.profile_json['body']['data']['arc'], self.profile_json['body']['data']['node'],
                           self.profile_json['body']['data']['terrain'])

        # Save profile values
        tools_gw.set_config_parser('btn_profile', 'min_distance_profile', f'{links_distance}')
        title = tools_qt.get_text(self.dlg_draw_profile, self.dlg_draw_profile.txt_title, False, False)
        tools_gw.set_config_parser('btn_profile', 'title_profile', f'{title}')

        # Maximize window (after drawing)
        self.plot.show()
        mng = self.plot.get_current_fig_manager()
        mng.window.showMaximized()

        if len(self.none_values) > 0:
            message = "There are missing values in these nodes:"
            tools_qt.show_info_box(message, inf_text=self.none_values)


    def _save_profile(self):
        """ Save profile """

        profile_id = tools_qt.get_text(self.dlg_draw_profile, self.dlg_draw_profile.txt_profile_id)
        if profile_id in (None, 'null'):
            message = "Profile name is mandatory."
            tools_qgis.show_warning(message)
            return

        # Clear and populate list with new arcs
        list_arc = []
        n = self.dlg_draw_profile.tbl_list_arc.count()
        for i in range(n):
            list_arc.append(int(self.dlg_draw_profile.tbl_list_arc.item(i).text()))

        # Get values from profile form
        links_distance = tools_qt.get_text(self.dlg_draw_profile, self.dlg_draw_profile.txt_min_distance)
        if links_distance in ("", "None", None):
            links_distance = 1
        title = tools_qt.get_text(self.dlg_draw_profile, self.dlg_draw_profile.txt_title)
        date = tools_qt.get_calendar_date(self.dlg_draw_profile, self.dlg_draw_profile.date, date_format='dd/MM/yyyy')

        # Create variable with all the content of the form
        extras = f'"profile_id":"{profile_id}", "listArcs":"{list_arc}","initNode":"{self.initNode}", ' \
            f'"endNode":"{self.endNode}", ' \
            f'"linksDistance":{links_distance}, "scale":{{ "eh":1000, ' \
            f'"ev":1000}}, "title":"{title}", "date":"{date}"'
        body = tools_gw.create_body(extras=extras)
        result = tools_gw.execute_procedure('gw_fct_setprofile', body)
        if result is None or result['status'] == 'Failed':
            return
        message = f"{result['message']}"
        tools_qgis.show_info(message)


    def _open_profile(self):
        """ Open dialog profile_list.ui """

        self.dlg_load = GwProfilesListUi()
        tools_gw.load_settings(self.dlg_load)

        # Get profils on database
        body = tools_gw.create_body()
        result_profile = tools_gw.execute_procedure('gw_fct_getprofile', body)
        if not result_profile or result_profile['status'] == 'Failed':
            return
        message = f"{result_profile['message']}"
        tools_qgis.show_info(message)

        self.dlg_load.btn_open.clicked.connect(partial(self._load_profile, result_profile))
        self.dlg_load.btn_delete_profile.clicked.connect(partial(self._delete_profile))

        # Populate profile list
        for profile in result_profile['body']['data']:
            item_arc = QListWidgetItem(str(profile['profile_id']))
            self.dlg_load.tbl_profiles.addItem(item_arc)

        tools_gw.open_dialog(self.dlg_load)


    def _load_profile(self, parameters):
        """ Open selected profile from dialog load_profiles.ui """

        selected_list = self.dlg_load.tbl_profiles.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        tools_gw.close_dialog(self.dlg_load)

        profile_id = self.dlg_load.tbl_profiles.currentItem().text()

        # Setting parameters on profile form
        self.dlg_draw_profile.btn_draw_profile.setEnabled(True)
        self.dlg_draw_profile.btn_save_profile.setEnabled(True)
        for profile in parameters['body']['data']:
            if profile['profile_id'] == profile_id:
                # Get data
                self.initNode = profile['values']['initNode']
                self.endNode = profile['values']['endNode']
                list_arcs = profile['values']['listArcs']

                # Get arcs from profile
                expr_filter = "\"arc_id\" IN ("
                for arc in list_arcs.strip('][').split(', '):
                    expr_filter += f"'{arc}', "
                expr_filter = expr_filter[:-2] + ")"
                expr = QgsExpression(expr_filter)
                # Get a featureIterator from this expression:
                self.layer_arc = tools_qgis.get_layer_by_tablename("v_edit_arc")
                it = self.layer_arc.getFeatures(QgsFeatureRequest(expr))

                self.id_list = [i.id() for i in it]
                if not self.id_list:
                    message = "Couldn't draw profile. You may need to select another exploitation."
                    tools_qgis.show_warning(message)
                    return

                # Set data in dialog
                self.dlg_draw_profile.txt_profile_id.setText(str(profile_id))
                self.dlg_draw_profile.tbl_list_arc.clear()

                for arc in list_arcs.strip('][').split(', '):
                    item_arc = QListWidgetItem(str(arc))
                    self.dlg_draw_profile.tbl_list_arc.addItem(item_arc)
                self.dlg_draw_profile.txt_min_distance.setText(str(profile['values']['linksDistance']))

                self.dlg_draw_profile.txt_title.setText(str(profile['values']['title']))
                date = QDate.fromString(profile['values']['date'], 'dd-MM-yyyy')
                tools_qt.set_calendar(self.dlg_draw_profile, self.dlg_draw_profile.date, date)

                # Select features in map
                self._remove_selection()
                self.layer_arc.selectByIds(self.id_list)

                # Center shortest path in canvas - ZOOM SELECTION
                self.canvas.zoomToSelected(self.layer_arc)


    def _activate_snapping_node(self):

        if hasattr(self, "first_node"):
            self.snapper_manager.remove_marker()
        self.initNode = None if not hasattr(self, "initNode") else self.initNode
        self.endNode = None if not hasattr(self, "endNode") else self.endNode
        self.first_node = True if not hasattr(self, "first_node") else self.first_node

        if self.first_node is False and not self.add_points:
            message = f"First node already selected with id: {self.initNode}. Select second one."
            tools_qgis.show_info(message)

        # Set vertex marker propierties
        self.snapper_manager.set_vertex_marker(self.vertex_marker, icon_type=4)

        # Create the appropriate map tool and connect the gotPoint() signal.
        if hasattr(self, "emit_point") and self.emit_point is not None:
            tools_gw.disconnect_signal('profile', 'ep_canvasClicked_snapping_node')
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.snapper = self.snapper_manager.get_snapper()
        self.iface.setActiveLayer(self.layer_node)

        tools_gw.connect_signal(self.canvas.xyCoordinates, self._mouse_move,
                                'profile', 'activate_snapping_node_xyCoordinates_mouse_move')
        tools_gw.connect_signal(self.emit_point.canvasClicked, partial(self._snapping_node),
                                'profile', 'ep_canvasClicked_snapping_node')
        # To activate action pan and not move the canvas accidentally we have to override the canvasReleaseEvent.
        # The "e" is the QgsMapMouseEvent given by the function
        self.emit_point.canvasReleaseEvent = lambda e: self._action_pan()


    def _mouse_move(self, point):

        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if result.isValid():
            layer = self.snapper_manager.get_snapped_layer(result)
            if layer == self.layer_node:
                self.snapper_manager.add_marker(result, self.vertex_marker)
        else:
            self.vertex_marker.hide()


    def _snapping_node(self, point):   # @UnusedVariable

        # Get clicked point
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)

        if result.isValid():
            # Check feature
            layer = self.snapper_manager.get_snapped_layer(result)
            if layer == self.layer_node:
                # Get the point
                snapped_feat = self.snapper_manager.get_snapped_feature(result)
                element_id = snapped_feat.attribute('node_id')
                self.element_id = str(element_id)

                if self.first_node and not self.add_points:
                    self.initNode = element_id
                    self.first_node = False
                    message = f"Node 1 selected"
                    tools_qgis.show_info(message, parameter=element_id)
                else:
                    if self.add_points:
                        self.add_points_list.append(element_id)
                    else:
                        self.endNode = element_id
                    tools_qgis.disconnect_snapping(False, self.emit_point, self.vertex_marker)
                    tools_gw.disconnect_signal('profile')
                    self.dlg_draw_profile.btn_draw_profile.setEnabled(True)
                    self.dlg_draw_profile.btn_save_profile.setEnabled(True)

                    # Clear old list arcs
                    self.dlg_draw_profile.tbl_list_arc.clear()

                    # Populate list arcs
                    extras = f'"initNode":"{self.initNode}", "endNode":"{self.endNode}"'
                    if self.add_points and self.add_points_list:
                        l = str(self.add_points_list).replace("'", "")
                        extras += f', "midNodes":{l}'
                    body = tools_gw.create_body(extras=extras)
                    result = tools_gw.execute_procedure('gw_fct_getprofilevalues', body)
                    if result is None or result['status'] == 'Failed':
                        return
                    self.layer_arc = tools_qgis.get_layer_by_tablename("v_edit_arc")

                    # Manage level and message from query result
                    if result['message']:
                        level = int(result['message']['level'])
                        tools_qgis.show_message(result['message']['text'], level)
                        if result['message']['level'] != 3:
                            # If error reset profile
                            self._clear_profile()
                            return

                    self._remove_selection()
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

                    # Next profile will be done from scratch
                    self.first_node = True
                    if self.add_points:
                        self.add_points = False
                    self.action_add_point.setDisabled(False)


    def _action_pan(self):
        if self.first_node:
            # Set action pan
            self.iface.actionPan().trigger()


    def _draw_profile(self, arcs, nodes, terrains):
        """ Parent function - Draw profiles """

        # Clear plot
        plt.gcf().clear()

        # Set main parameters
        self._set_profile_variables(arcs, nodes, terrains)
        self._fill_profile_variables(arcs, nodes, terrains)
        self._set_guitar_parameters()

        # Draw start node
        self._draw_start_node(self.nodes[0])

        # Draw nodes and precedessor arcs between start and end nodes
        for i in range(1, self.n - 1):
            self._draw_nodes(self.nodes[i], self.nodes[i - 1], i)

        # Draw terrain
        for i in range(1, self.t):

            # define variables
            self.first_top_x = self.links[i - 1].start_point  # start_point = total_x
            self.node_top_x = self.links[i].start_point  # start_point = total_x
            self.first_top_y = self.links[i - 1].node_id  # node_id = top_n1
            self.node_top_y = self.links[i - 1].geom  # geom = top_n2

            # Draw terrain
            self._draw_terrain(i)

            # Fill text terrain
            self._fill_guitar_text_terrain(self.node_top_x, i)
            self._draw_guitar_auxiliar_lines(self.node_top_x, first_vl=False)

        # Draw last node and precedessor arc
        self._draw_end_node(self.nodes[self.n - 1], self.nodes[self.n - 2], self.n - 1)

        # Draw guitar & grid
        self._draw_guitar_horitzontal_lines()
        self._draw_grid()

        # Manage layout and plot
        self._set_profile_layout()
        self.plot = plt

        # If file profile.png exist overwrite
        temp_folder = f"{global_vars.user_folder_dir}{os.sep}core{os.sep}temp"
        img_path = f"{temp_folder}{os.sep}profile.png"
        if not os.path.exists(temp_folder):
            os.makedirs(temp_folder)
        else:
            tools_log.log_info(f"User settings file: {img_path}")

        fig_size = plt.rcParams["figure.figsize"]

        # Set figure width to 10.4  and height to 4.8
        fig_size[0] = 10.4
        fig_size[1] = 4.8
        plt.rcParams["figure.figsize"] = fig_size

        # Save profile with dpi = 300
        plt.savefig(img_path, dpi=300)
        

    def _set_profile_layout(self):
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


    def _set_profile_variables(self, arcs, nodes, terrains):
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
        self.arc_dimensions = []
        self.arc_catalog = []
        self.start_point = [0]

        # Get arcs between nodes (on shortest path)
        self.n = len(self.list_of_selected_nodes)
        self.t = len(self.list_of_selected_terrains)

        for arc in arcs:
            self.gis_length.append(arc['length'])
            self.arc_dimensions.append(json.loads(arc['descript'], object_pairs_hook=OrderedDict)['dimensions'])
            self.arc_catalog.append(json.loads(arc['descript'], object_pairs_hook=OrderedDict)['catalog'])

        # Calculate start_point (coordinates) of drawing for each node
        n = len(self.gis_length)
        for i in range(1, n):
            x = self.start_point[i - 1] + self.gis_length[i]
            self.start_point.append(x)
            i += 1

    def _fill_profile_variables(self, arcs, nodes, terrains):
        """ Get parameters from database. Fill self.nodes with parameters postgres """

        # Get parameters and fill the nodes
        n = 0
        for node in nodes:
            parameters = GwNodeData()
            parameters.start_point = self.start_point[n]
            parameters.top_elev = node['top_elev']
            parameters.ymax = node['ymax']
            parameters.elev = node['elev']
            parameters.node_id = node['node_id']
            parameters.geom = node['cat_geom1']
            parameters.descript = [json.loads(node['descript'], object_pairs_hook=OrderedDict)][0]
            parameters.data_type = node['data_type']
            parameters.surface_type = node['surface_type']

            self.nodes.append(parameters)
            n = n + 1

        # Get parameters and fill the links
        n = 0
        for terrain in terrains:
            parameters = GwNodeData()
            parameters.start_point = terrain['total_x']
            parameters.top_elev = json.loads(terrain['label_n1'], object_pairs_hook=OrderedDict)['top_elev']
            parameters.node_id = terrain['top_n1']
            parameters.geom = terrain['top_n2']
            parameters.descript = [json.loads(terrain['label_n1'], object_pairs_hook=OrderedDict)][0]
            parameters.surface_type = terrain['surface_type']

            self.links.append(parameters)
            n = n + 1

        # Populate node parameters with associated arcs
        n = 0
        for arc in arcs:
            self.nodes[n].z1 = arc['z1']
            self.nodes[n].z2 = arc['z2']
            self.nodes[n].cat_geom = arc['cat_geom1']
            self.nodes[n].elev1 = arc['elev1']
            self.nodes[n].elev2 = arc['elev2']
            self.nodes[n].y1 = arc['y1']
            self.nodes[n].y2 = arc['y2']
            self.nodes[n].slope = 1
            self.nodes[n].node_1 = arc['node_1']
            self.nodes[n].node_2 = arc['node_2']
            n += 1


    def _draw_start_node(self, node):
        """ Draw first node """

        # Get superior points
        s1x = -node.geom / 2
        s1y = node.top_elev
        s2x = node.geom / 2
        s2y = node.top_elev
        s3x = node.geom / 2
        s3y = node.top_elev - node.ymax + node.z1 + node.cat_geom

        # Get inferior points
        i1x = -node.geom / 2
        i1y = node.top_elev - node.ymax
        i2x = node.geom / 2
        i2y = node.top_elev - node.ymax
        i3x = node.geom / 2
        i3y = node.top_elev - node.ymax + node.z1

        # Create list points
        xinf = [s1x, i1x, i2x, i3x]
        yinf = [s1y, i1y, i2y, i3y]
        xsup = [s1x, s2x, s3x]
        ysup = [s1y, s2y, s3y]

        # draw first node bottom line
        plt.plot(xinf, yinf, zorder=100, linestyle=self._get_stylesheet(node.data_type)[0],
                 color=self._get_stylesheet(node.data_type)[1], linewidth=self._get_stylesheet(node.data_type)[2])

        # draw first node upper line
        plt.plot(xsup, ysup, zorder=100, linestyle=self._get_stylesheet(node.data_type)[0],
                 color=self._get_stylesheet(node.data_type)[1], linewidth=self._get_stylesheet(node.data_type)[2])

        self.first_top_x = 0
        self.first_top_y = node.top_elev

        # Save last points for first node
        self.slast = [s3x, s3y]
        self.ilast = [i3x, i3y]

        # Save last points for first node
        self.slast2 = [s3x, s3y]
        self.ilast2 = [i3x, i3y]

        # Fill table with start node values
        self._fill_guitar_text_node(0, 0)

        # Draw header
        self._draw_guitar_vertical_lines(node.start_point)
        self._fill_guitar_text_legend()
        self._draw_guitar_auxiliar_lines(0)


    def _draw_guitar_vertical_lines(self, start_point):
        """ Draw fixed part of table """

        # Get stylesheet
        line_color = self.profile_json['body']['data']['stylesheet']['guitar']['lines']['color']
        line_style = self.profile_json['body']['data']['stylesheet']['guitar']['lines']['style']
        line_width = self.profile_json['body']['data']['stylesheet']['guitar']['lines']['width']

        # Vertical line [-1,0]
        # x = [start_point - self.fix_x * Decimal(0.2), start_point - self.fix_x * Decimal(0.2)]
        # y = [self.min_top_elev - 1 * self.height_row, self.min_top_elev - Decimal(5.85) * self.height_row]
        # plt.plot(x, y, linestyle=line_style, color=line_color, linewidth=line_width, zorder=100)

        # Vertical line [-2,0]
        x = [start_point - self.fix_x * Decimal(0.75), start_point - self.fix_x * Decimal(0.75)]
        y = [self.min_top_elev - Decimal(1.9) * self.height_row, self.min_top_elev - Decimal(5.10) * self.height_row]
        plt.plot(x, y, linestyle=line_style, color=line_color, linewidth=line_width, zorder=100)

        # Vertical line [-3,0]
        x = [start_point - self.fix_x, start_point - self.fix_x]
        y = [self.min_top_elev - 1 * self.height_row, self.min_top_elev - Decimal(5.85) * self.height_row]
        plt.plot(x, y, linestyle=line_style, color=line_color, linewidth=line_width, zorder=100)


    def _draw_guitar_auxiliar_lines(self, start_point, first_vl=True):
        """ Draw marks for each node """

        # Get stylesheet
        auxline_color = self.profile_json['body']['data']['stylesheet']['guitar']['auxiliarlines']['color']
        auxline_style = self.profile_json['body']['data']['stylesheet']['guitar']['auxiliarlines']['style']
        auxline_width = self.profile_json['body']['data']['stylesheet']['guitar']['auxiliarlines']['width']

        if first_vl:  # separator for first slope / length (only for nodes)
            # Vertical line [0,0]
            x = [start_point, start_point]
            y = [self.min_top_elev - 1 * self.height_row,
                 self.min_top_elev - Decimal(1.9) * self.height_row]
            plt.plot(x, y, linestyle=auxline_style, color=auxline_color, linewidth=auxline_width, zorder=100)

        # Vertical lines
        x = [start_point, start_point]
        y = [self.min_top_elev - Decimal(1.90) * self.height_row, self.min_top_elev - Decimal(2.05) * self.height_row]
        plt.plot(x, y, linestyle=auxline_style, color=auxline_color, linewidth=auxline_width, zorder=100)

        x = [start_point, start_point]
        y = [self.min_top_elev - Decimal(2.60) * self.height_row, self.min_top_elev - Decimal(2.85) * self.height_row]
        plt.plot(x, y, linestyle=auxline_style, color=auxline_color, linewidth=auxline_width, zorder=100)

        x = [start_point, start_point]
        y = [self.min_top_elev - Decimal(3.4) * self.height_row, self.min_top_elev - Decimal(3.65) * self.height_row]
        plt.plot(x, y, linestyle=auxline_style, color=auxline_color, linewidth=auxline_width, zorder=100)

        x = [start_point, start_point]
        y = [self.min_top_elev - Decimal(4.20) * self.height_row, self.min_top_elev - Decimal(4.45) * self.height_row]
        plt.plot(x, y, linestyle=auxline_style, color=auxline_color, linewidth=auxline_width, zorder=100)

        x = [start_point, start_point]
        y = [self.min_top_elev - Decimal(5) * self.height_row, self.min_top_elev - Decimal(5.25) * self.height_row]
        plt.plot(x, y, linestyle=auxline_style, color=auxline_color, linewidth=auxline_width, zorder=100)

        x = [start_point, start_point]
        y = [self.min_top_elev - Decimal(5.85) * self.height_row, self.min_top_elev - Decimal(5.7) * self.height_row]
        plt.plot(x, y, linestyle=auxline_style, color=auxline_color, linewidth=auxline_width, zorder=100)


    def _fill_guitar_text_legend(self):

        # Get stylesheet values
        text_color = self.profile_json['body']['data']['stylesheet']['guitar']['text']['color']
        text_weight = self.profile_json['body']['data']['stylesheet']['guitar']['text']['weight']
        title_color = self.profile_json['body']['data']['stylesheet']['title']['text']['color']
        title_weight = self.profile_json['body']['data']['stylesheet']["title"]['text']['weight']
        title_size = self.profile_json['body']['data']['stylesheet']["title"]['text']['size']

        legend = self.profile_json['body']['data']['legend']
        c = (self.fix_x - self.fix_x * Decimal(0.2)) / 2
        plt.text(-(c + self.fix_x * Decimal(0.2)),
                 self.min_top_elev - 1 * self.height_row - Decimal(0.35) * self.height_row, legend['catalog'],
                 fontsize=7.5, color=text_color, fontweight=text_weight, horizontalalignment='center')

        plt.text(-(c + self.fix_x * Decimal(0.2)),
                 self.min_top_elev - 1 * self.height_row - Decimal(0.68) * self.height_row, legend['dimensions'],
                 fontsize=7.5, color=text_color, fontweight=text_weight, horizontalalignment='center')

        c = (self.fix_x * Decimal(0.25)) / 2
        plt.text(-(c + self.fix_x * Decimal(0.74)),
                 self.min_top_elev - Decimal(2) * self.height_row - self.height_row * 3 / 2, legend['ordinates'],
                 fontsize=7.5, color=text_color, fontweight=text_weight, rotation='vertical',
                 horizontalalignment='center', verticalalignment='center')

        plt.text(-self.fix_x * Decimal(0.70), self.min_top_elev - Decimal(1.85) * self.height_row - self.height_row / 2,
                 legend['topelev'], fontsize=7.5, color=text_color, fontweight=text_weight, verticalalignment='center')

        plt.text(-self.fix_x * Decimal(0.70), self.min_top_elev - Decimal(2.65) * self.height_row - self.height_row / 2,
                 legend['ymax'], fontsize=7.5, color=text_color, fontweight=text_weight, verticalalignment='center')

        plt.text(-self.fix_x * Decimal(0.70), self.min_top_elev - Decimal(3.45) * self.height_row - self.height_row / 2,
                 legend['elev'], fontsize=7.5, color=text_color, fontweight=text_weight, verticalalignment='center')

        plt.text(-self.fix_x * Decimal(0.70), self.min_top_elev - Decimal(4.25) * self.height_row - self.height_row / 2,
                 legend['distance'], fontsize=7.5, color=text_color, fontweight=text_weight, verticalalignment='center')

        c = (self.fix_x - self.fix_x * Decimal(0.2)) / 2
        plt.text(-(c + self.fix_x * Decimal(0.2)),
                 self.min_top_elev - Decimal(self.height_row * 5 + self.height_row / 2), legend['code'],
                 fontsize=7.5, color=text_color, fontweight=text_weight, horizontalalignment='center',
                 verticalalignment='center')

        # Print title
        title = tools_qt.get_text(self.dlg_draw_profile, self.dlg_draw_profile.txt_title, False, False)
        # Set default value if no title is given
        if title in ('', None):
            title = f"PROFILE {self.initNode} - {self.endNode}"
        plt.text(-self.fix_x * Decimal(1), self.min_top_elev - Decimal(5.75) * self.height_row - self.height_row / 2,
                 title, fontsize=title_size, color=title_color, fontweight=title_weight,
                 verticalalignment='center')

        date = tools_qt.get_calendar_date(self.dlg_draw_profile, self.dlg_draw_profile.date)
        plt.text(-self.fix_x * Decimal(1), self.min_top_elev - Decimal(6) * self.height_row - self.height_row / 2,
                 date, fontsize=title_size * 0.7, color=title_color, fontweight=title_weight, verticalalignment='center')


    def _draw_nodes(self, node, prev_node, index):
        """ Draw nodes between first and last node """

        z1 = prev_node.z2
        z2 = node.z1

        if node.node_1 is None:
            return

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
        s5y = node.top_elev - node.ymax + z2 + node.cat_geom

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

        # Create arc list points
        xainf = [i1x, i2x]
        yainf = [i1y, i2y]
        xasup = [s1x, s2x]
        yasup = [s1y, s2y]

        # Create node list points
        xninf = [i2x, i3x, i4x, i5x]
        yninf = [i2y, i3y, i4y, i5y]

        if node.surface_type == 'TOP':
            xnsup = [s2x, s3x, s4x, s5x]
            ynsup = [s2y, s3y, s4y, s5y]
        else:
            xnsup = [s2x, s5x]
            ynsup = [s2y, s5y]

        # draw node bottom line
        plt.plot(xninf, yninf,
                 zorder=100,
                 linestyle=self._get_stylesheet(node.data_type)[0],
                 color=self._get_stylesheet(node.data_type)[1],
                 linewidth=self._get_stylesheet(node.data_type)[2])

        # draw node upper line
        plt.plot(xnsup, ynsup,
                 zorder=100,
                 linestyle=self._get_stylesheet(node.data_type)[0],
                 color=self._get_stylesheet(node.data_type)[1],
                 linewidth=self._get_stylesheet(node.data_type)[2])

        if self.lastnode_datatype == 'INTERPOLATED' or node.data_type == 'INTERPOLATED':
            data_type = 'INTERPOLATED'
        else:
            data_type = 'REAL'

        # draw arc bottom line
        plt.plot(xainf, yainf,
                 zorder=100,
                 linestyle=self._get_stylesheet(data_type)[0],
                 color=self._get_stylesheet(data_type)[1],
                 linewidth=self._get_stylesheet(data_type)[2])

        # draw arc upper line
        plt.plot(xasup, yasup,
                 zorder=100,
                 linestyle=self._get_stylesheet(data_type)[0],
                 color=self._get_stylesheet(data_type)[1],
                 linewidth=self._get_stylesheet(data_type)[2])

        self.node_top_x = node.start_point
        self.node_top_y = node.top_elev
        self.first_top_x = prev_node.start_point
        self.first_top_y = prev_node.top_elev

        # Draw guitar auxiliar lines
        self._draw_guitar_auxiliar_lines(node.start_point)

        # Fill table
        self._fill_guitar_text_node(node.start_point, index)

        # Save last points before the last node
        self.slast = [s5x, s5y]
        self.ilast = [i5x, i5y]
        self.lastnode_datatype = node.data_type

        # Save last points for draw ground
        self.slast2 = [s3x, s3y]
        self.ilast2 = [i3x, i3y]


    def _fill_guitar_text_node(self, start_point, index):

        # Get stylesheet values
        text_color = self.profile_json['body']['data']['stylesheet']['guitar']['text']['color']
        text_weight = self.profile_json['body']['data']['stylesheet']['guitar']['text']['weight']

        # Fill top_elevation
        s = ' ' + '\n' + str(self.nodes[index].descript['top_elev']) + '\n' + ' '
        xy = (Decimal(start_point), self.min_top_elev - Decimal(self.height_row * Decimal(1.8) + self.height_row / 2))
        plt.annotate(s, xy=xy, fontsize=6, color=text_color, fontweight=text_weight, rotation='vertical',
                     horizontalalignment='center', verticalalignment='center')
        # Fill code
        plt.text(0 + start_point, self.min_top_elev - Decimal(self.height_row * 5 + self.height_row / 2),
                 self.nodes[index].descript['code'], fontsize=7.5, color=text_color, fontweight=text_weight,
                 horizontalalignment='center', verticalalignment='center')

        # Node init
        if index == 0:

            y1 = self.nodes[0].y1
            elev1 = self.nodes[0].elev1

            # Fill y_max
            plt.annotate(' ' + '\n' + str(self.nodes[0].descript['ymax']) + '\n' + str(y1),
                         xy=(Decimal(0 + start_point),
                             self.min_top_elev - Decimal(self.height_row * Decimal(2.60) + self.height_row / 2)),
                         fontsize=6,
                         color=text_color, fontweight=text_weight,
                         rotation='vertical', horizontalalignment='center', verticalalignment='center')

            # Fill elevation
            plt.annotate(' ' + '\n' + str(self.nodes[0].descript['elev']) + '\n' + str(elev1),
                         xy=(Decimal(0 + start_point),
                             self.min_top_elev - Decimal(self.height_row * Decimal(3.40) + self.height_row / 2)),
                         fontsize=6,
                         color=text_color, fontweight=text_weight,
                         rotation='vertical', horizontalalignment='center', verticalalignment='center')

            # Fill total length
            plt.annotate(str(self.nodes[index].descript['total_distance']),
                         xy=(Decimal(0 + start_point),
                             self.min_top_elev - Decimal(
                                 self.height_row * Decimal(4.20) + self.height_row / 2)),
                         fontsize=6,
                         color=text_color, fontweight=text_weight,
                         rotation='vertical', horizontalalignment='center', verticalalignment='center')

        # Nodes between init and end
        elif index < self.n - 1:

            # defining variables
            y2_prev = self.nodes[index - 1].y2
            elev2_prev = self.nodes[index - 1].elev2
            y1 = self.nodes[index].y1
            elev1 = self.nodes[index].elev1

            if y2_prev in (None, 'None') or self.nodes[index].descript['ymax'] in (None, 'None') or y1 in (None, 'None')\
                    or elev2_prev in (None, 'None') or self.nodes[index].descript['elev'] in (None, 'None') or elev1 in (None, 'None'):
                self.none_values.append(self.nodes[index].descript['code'])

            # Fill y_max
            plt.annotate(
                str(y2_prev) + '\n' + str(self.nodes[index].descript['ymax']) + '\n' + str(y1),
                xy=(Decimal(0 + start_point),
                    self.min_top_elev - Decimal(self.height_row * Decimal(2.60) + self.height_row / 2)),
                fontsize=6,
                color=text_color, fontweight=text_weight,
                rotation='vertical', horizontalalignment='center', verticalalignment='center')

            # Fill elevation
            plt.annotate(
                str(elev2_prev) + '\n' + str(self.nodes[index].descript['elev']) + '\n' + str(elev1),
                xy=(Decimal(0 + start_point),
                    self.min_top_elev - Decimal(self.height_row * Decimal(3.40) + self.height_row / 2)),
                fontsize=6,
                color=text_color, fontweight=text_weight,
                rotation='vertical', horizontalalignment='center', verticalalignment='center')

            # Fill total length
            plt.annotate(str(self.nodes[index].descript['total_distance']),
                         xy=(Decimal(0 + start_point),
                         self.min_top_elev - Decimal(self.height_row * Decimal(4.20) + self.height_row / 2)),
                         fontsize=6,
                         color=text_color, fontweight=text_weight,
                         rotation='vertical', horizontalalignment='center', verticalalignment='center')
        # Node end
        elif index == self.n - 1:

            # Fill y_max
            plt.annotate(
                str(self.nodes[index - 1].y2) + '\n' + str(self.nodes[index].descript['ymax']),
                xy=(Decimal(0 + start_point),
                    self.min_top_elev - Decimal(self.height_row * Decimal(2.60) + self.height_row / 2)),
                fontsize=6,
                color=text_color, fontweight=text_weight,
                rotation='vertical', horizontalalignment='center', verticalalignment='center')

            # Fill elevation
            plt.annotate(
                str(self.nodes[index - 1].elev2) + '\n' + str(self.nodes[index].descript['elev']),
                xy=(Decimal(0 + start_point),
                    self.min_top_elev - Decimal(self.height_row * Decimal(3.40) + self.height_row / 2)),
                fontsize=6,
                color=text_color, fontweight=text_weight,
                rotation='vertical', horizontalalignment='center', verticalalignment='center')

            # Fill total length
            plt.annotate(str(self.nodes[index].descript['total_distance']),
                         xy=(Decimal(0 + start_point),
                         self.min_top_elev - Decimal(self.height_row * Decimal(4.20) + self.height_row / 2)),
                         fontsize=6,
                         color=text_color, fontweight=text_weight,
                         rotation='vertical', horizontalalignment='center', verticalalignment='center')


        # Fill diameter and slope / length
        if index != self.n - 1:

            # Fill diameter
            center = self.gis_length[index + 1] / 2
            plt.text(center + start_point, self.min_top_elev - 1 * self.height_row - Decimal(0.35) * self.height_row,
                     self.arc_catalog[index],
                     fontsize=7.5,
                     color=text_color, fontweight=text_weight,
                     horizontalalignment='center')  # PUT IN THE MIDDLE PARAMETRIZATION

            # Fill slope / length
            plt.text(center + start_point, self.min_top_elev - 1 * self.height_row - Decimal(0.68) * self.height_row,
                     self.arc_dimensions[index],
                     fontsize=7.5,
                     color=text_color, fontweight=text_weight,
                     horizontalalignment='center')  # PUT IN THE MIDDLE PARAMETRIZATION


    def _fill_guitar_text_terrain(self, start_point, index):

        if str(self.links[index].surface_type) == 'VNODE':

            # Get stylesheet values
            text_color = self.profile_json['body']['data']['stylesheet']['guitar']['text']['color']
            text_weight = self.profile_json['body']['data']['stylesheet']['guitar']['text']['weight']

            # Fill top_elevation
            s = ' ' + '\n' + str(self.links[index].descript['top_elev']) + '\n' + ' '
            xy = (Decimal(start_point), self.min_top_elev - Decimal(self.height_row * Decimal(1.8) + self.height_row / 2))
            plt.annotate(s, xy=xy, fontsize=6, color=text_color, fontweight=text_weight, rotation='vertical',
                         horizontalalignment='center', verticalalignment='center')

            # Fill code
            plt.text(0 + start_point, self.min_top_elev - Decimal(self.height_row * Decimal(5) + self.height_row / 2),
                     self.links[index].descript['code'],
                     fontsize=7.5,
                     color=text_color, fontweight=text_weight,
                     horizontalalignment='center', verticalalignment='center')

            # Fill y_max
            plt.annotate(
                str(self.links[index].descript['ymax']),
                xy=(Decimal(0 + start_point),
                    self.min_top_elev - Decimal(self.height_row * Decimal(2.60) + self.height_row / 2)),
                fontsize=6,
                color=text_color, fontweight=text_weight,
                rotation='vertical', horizontalalignment='center', verticalalignment='center')

            # Fill elevation
            plt.annotate(
                str(self.links[index].descript['elev']),
                xy=(Decimal(0 + start_point),
                    self.min_top_elev - Decimal(self.height_row * Decimal(3.40) + self.height_row / 2)),
                fontsize=6,
                color=text_color, fontweight=text_weight,
                rotation='vertical', horizontalalignment='center', verticalalignment='center')

            # Fill total length
            plt.annotate(str(self.links[index].descript['total_distance']),
                 xy=(Decimal(0 + start_point),
                     self.min_top_elev - Decimal(self.height_row * Decimal(4.20) + self.height_row / 2)),
                fontsize=6,
                color=text_color, fontweight=text_weight,
                rotation='vertical', horizontalalignment='center', verticalalignment='center')


    def _draw_end_node(self, node, prev_node, index):
        """
        draws last arc and nodes of profile
        :param node:
        :param prev_node:
        :param index:
        :return:
        """

        s1x = self.slast[0]
        s1y = self.slast[1]

        s2x = node.start_point - node.geom / 2
        s2y = node.top_elev - node.ymax + prev_node.z2 + prev_node.cat_geom
        s3x = node.start_point - node.geom / 2
        s3y = node.top_elev
        s4x = node.start_point + node.geom / 2
        s4y = node.top_elev

        # Get inferior points
        i1x = self.ilast[0]
        i1y = self.ilast[1]
        i2x = node.start_point - node.geom / 2
        i2y = node.top_elev - node.ymax + prev_node.z2
        i3x = node.start_point - node.geom / 2
        i3y = node.top_elev - node.ymax
        i4x = node.start_point + node.geom / 2
        i4y = node.top_elev - node.ymax

        # Create arc list points
        xainf = [i1x, i2x]
        yainf = [i1y, i2y]
        xasup = [s1x, s2x]
        yasup = [s1y, s2y]

        # Create node list points
        xninf = [i2x, i3x, i4x]
        yninf = [i2y, i3y, i4y]
        xnsup = [s2x, s3x, s4x, i4x]
        ynsup = [s2y, s3y, s4y, i4y]

        # draw node bottom line
        plt.plot(xninf, yninf,
                 zorder=100,
                 linestyle=self._get_stylesheet(node.data_type)[0],
                 color=self._get_stylesheet(node.data_type)[1],
                 linewidth=self._get_stylesheet(node.data_type)[2])

        # draw node upper line
        plt.plot(xnsup, ynsup,
                 zorder=100,
                 linestyle=self._get_stylesheet(node.data_type)[0],
                 color=self._get_stylesheet(node.data_type)[1],
                 linewidth=self._get_stylesheet(node.data_type)[2])

        # draw arc bottom line
        plt.plot(xainf, yainf,
                 zorder=100,
                 linestyle=self._get_stylesheet(self.lastnode_datatype)[0],
                 color=self._get_stylesheet(self.lastnode_datatype)[1],
                 linewidth=self._get_stylesheet(self.lastnode_datatype)[2])

        # draw arc upper line
        plt.plot(xasup, yasup,
                 zorder=100,
                 linestyle=self._get_stylesheet(self.lastnode_datatype)[0],
                 color=self._get_stylesheet(self.lastnode_datatype)[1],
                 linewidth=self._get_stylesheet(self.lastnode_datatype)[2])

        self.first_top_x = self.slast2[0]
        self.first_top_y = self.slast2[1]

        self.node_top_x = node.start_point
        self.node_top_y = node.top_elev

        # Draw table-marks
        self._draw_guitar_auxiliar_lines(node.start_point)

        # Fill table
        self._fill_guitar_text_node(node.start_point, index)

        # Reset lastnode_datatype
        self.lastnode_datatype = 'REAL'


    def _set_guitar_parameters(self):
        """
        Define parameters of table
        :return:
        """

        # Search y coordinate min_top_elev ( top_elev- ymax)
        self.min_top_elev = Decimal(self.nodes[0].top_elev - self.nodes[0].ymax)

        # self.min_top_elev_descript = Decimal(self.nodes[0].descript['top_elev'] - self.nodes[0].descript['ymax'])
        for i in range(1, self.n):
            if (self.nodes[i].top_elev - self.nodes[i].ymax) < self.min_top_elev:
                self.min_top_elev = Decimal(self.nodes[i].top_elev - self.nodes[i].ymax)

        # Search y coordinate max_top_elev
        self.max_top_elev = self.nodes[0].top_elev
        self.max_top_elev_descript = self.nodes[0].descript['top_elev']
        for i in range(1, self.n):
            if self.nodes[i].top_elev > self.max_top_elev:
                self.max_top_elev = self.nodes[i].top_elev

        # Calculating dimensions of x-fixed part of table
        self.fix_x = Decimal(Decimal(0.15) * Decimal(self.nodes[self.n - 1].start_point))

        # Calculating dimensions of y-fixed part of table
        # Height y = height of table + height of graph
        self.z = Decimal(self.max_top_elev) - Decimal(self.min_top_elev)
        self.height_row = (Decimal(self.z) * Decimal(0.97)) / Decimal(5)

        # Height of graph + table
        self.height_y = Decimal(self.z * 2)


    def _draw_guitar_horitzontal_lines(self):
        """
        Draw horitzontal lines of table
        :return:
        """
        line_color = self.profile_json['body']['data']['stylesheet']['guitar']['lines']['color']
        line_style = self.profile_json['body']['data']['stylesheet']['guitar']['lines']['style']
        line_width = self.profile_json['body']['data']['stylesheet']['guitar']['lines']['width']

        self._set_guitar_parameters()

        # Draw upper horizontal lines (long ones)
        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x]
        y = [self.min_top_elev - self.height_row, self.min_top_elev - self.height_row]
        plt.plot(x, y, color=line_color, linestyle=line_style, linewidth=line_width, zorder=100)

        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x]
        y = [self.min_top_elev - Decimal(1.9) * self.height_row, self.min_top_elev - Decimal(1.9) * self.height_row]
        plt.plot(x, y, color=line_color, linestyle=line_style, linewidth=line_width, zorder=100)

        # Draw middle horizontal lines (short ones)
        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x * Decimal(0.75)]
        y = [self.min_top_elev - Decimal(2.70) * self.height_row, self.min_top_elev - Decimal(2.70) * self.height_row]
        plt.plot(x, y, color=line_color, linestyle=line_style, linewidth=line_width, zorder=100)
        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x * Decimal(0.75)]
        y = [self.min_top_elev - Decimal(3.50) * self.height_row, self.min_top_elev - Decimal(3.50) * self.height_row]
        plt.plot(x, y, color=line_color, linestyle=line_style, linewidth=line_width, zorder=100)
        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x * Decimal(0.75)]
        y = [self.min_top_elev - Decimal(4.30) * self.height_row, self.min_top_elev - Decimal(4.30) * self.height_row]
        plt.plot(x, y, color=line_color, linestyle=line_style, linewidth=line_width, zorder=100)

        # Draw lower horizontal lines (long ones)
        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x]
        y = [self.min_top_elev - Decimal(5.10) * self.height_row, self.min_top_elev - Decimal(5.10) * self.height_row]
        plt.plot(x, y, color=line_color, linestyle=line_style, linewidth=line_width, zorder=100)
        x = [self.nodes[self.n - 1].start_point, self.nodes[0].start_point - self.fix_x]
        y = [self.min_top_elev - Decimal(5.85) * self.height_row, self.min_top_elev - Decimal(5.85) * self.height_row]
        plt.plot(x, y, color=line_color, linestyle=line_style, linewidth=line_width, zorder=100)


    def _draw_grid(self):

        # get values for lines
        line_color = self.profile_json['body']['data']['stylesheet']['grid']['lines']['color']
        line_style = self.profile_json['body']['data']['stylesheet']['grid']['lines']['style']
        line_width = self.profile_json['body']['data']['stylesheet']['grid']['lines']['width']

        # get values for boundary
        boundary_color = self.profile_json['body']['data']['stylesheet']['grid']['boundary']['color']
        boundary_style = self.profile_json['body']['data']['stylesheet']['grid']['boundary']['style']
        boundary_width = self.profile_json['body']['data']['stylesheet']['grid']['boundary']['width']

        # get values for text
        text_color = self.profile_json['body']['data']['stylesheet']['grid']['text']['color']
        text_weight = self.profile_json['body']['data']['stylesheet']['grid']['text']['weight']

        start_point = self.nodes[self.n - 1].start_point
        geom1 = self.nodes[self.n - 1].geom

        # Draw main text
        try:
            reference_plane = self.profile_json['body']['data']['legend']['referencePlane']
        except KeyError:
            reference_plane = "REFERENCE"
        plt.text(-self.fix_x * Decimal(1), self.min_top_elev - Decimal(0.5) * self.height_row - self.height_row / 2,
                 f"{reference_plane}: {round(self.min_top_elev - 1 * self.height_row, 2)}\n ",
                 fontsize=8.5,
                 color=text_color, fontweight=text_weight,
                 verticalalignment='center')

        # Draw boundary
        x = [0, 0]
        y = [self.min_top_elev - 1 * self.height_row, int(math.ceil(self.max_top_elev) + 1)]
        plt.plot(x, y, color=boundary_color, linestyle=boundary_style, linewidth=boundary_width, zorder=100)
        x = [start_point, start_point]
        y = [self.min_top_elev - 1 * self.height_row, int(math.ceil(self.max_top_elev) + 1)]
        plt.plot(x, y, color=boundary_color, linestyle=boundary_style, linewidth=boundary_width, zorder=100)
        x = [0, start_point]
        y = [int(math.ceil(self.max_top_elev) + 1), int(math.ceil(self.max_top_elev) + 1)]
        plt.plot(x, y, color=boundary_color, linestyle=boundary_style, linewidth=boundary_width, zorder=100)

        # Draw horitzontal lines
        y = int(math.ceil(self.min_top_elev - 1 * self.height_row))
        x = int(math.floor(self.max_top_elev))
        if x % 2 == 0:
            x = x + 2
        else:
            x = x + 1

        for i in range(y, x):
            if i % 2 == 0:
                x1 = [0, start_point]
                y1 = [i, i]
            else:
                i = i + 1
                x1 = [0, start_point]
                y1 = [i, i]

            # set line
            plt.plot(x1, y1, color=line_color, linestyle=line_style, linewidth=line_width, zorder=1)

            # set texts
            plt.text(0 - Decimal(geom1) * Decimal(1.5), i, str(i),
                     fontsize=7.5,
                     color=text_color, fontweight=text_weight,
                     horizontalalignment='right', verticalalignment='center')
            plt.text(Decimal(start_point) + Decimal(geom1) * Decimal(1.5), i, str(i),
                     fontsize=7.5,
                     color=text_color, fontweight=text_weight,
                     horizontalalignment='left', verticalalignment='center')

        # Draw vertical lines
        x = int(math.floor(start_point))
        for i in range(50, x, 50):
            x1 = [i, i]
            y1 = [self.min_top_elev - 1 * self.height_row, int(math.ceil(self.max_top_elev) + 1)]

            # set line
            plt.plot(x1, y1, color=line_color, linestyle=line_style, linewidth=line_width, zorder=1)

            # set texts
            plt.annotate(str(i) + '\n' + ' ', xy=(i, int(math.ceil(self.max_top_elev) + 1)),
                         fontsize=6.5, color=text_color, fontweight=text_weight, horizontalalignment='center')


    def _draw_terrain(self, index):

        # getting variables
        line_color = self.profile_json['body']['data']['stylesheet']['terrain']['color']
        line_style = self.profile_json['body']['data']['stylesheet']['terrain']['style']
        line_width = self.profile_json['body']['data']['stylesheet']['terrain']['width']

        # Draw marker
        if index == 1:
            plt.plot(self.first_top_x, self.first_top_y, marker='|', color=line_color)
        else:
            plt.plot(self.node_top_x, self.node_top_y, marker='|', color=line_color)

        # Draw line
        x = [self.first_top_x, self.node_top_x]
        y = [self.first_top_y, self.node_top_y]
        plt.plot(x, y, color=line_color, linewidth=line_width, linestyle=line_style)


    def _clear_profile(self):
        """ Manage button clear profile and leave form empty """

        # Clear list of nodes and arcs
        self.list_of_selected_nodes = []
        self.list_of_selected_arcs = []
        self.arcs = []
        self.nodes = []

        # Clear widgets
        self.dlg_draw_profile.tbl_list_arc.clear()
        self.dlg_draw_profile.txt_profile_id.clear()
        self.action_profile.setDisabled(False)
        self.action_add_point.setDisabled(True)
        self.dlg_draw_profile.btn_draw_profile.setEnabled(False)
        self.dlg_draw_profile.btn_save_profile.setEnabled(False)

        # Clear selection
        self._remove_selection()
        self._reset_profile_variables()


    def _delete_profile(self):
        """ Delete profile """

        selected_list = self.dlg_load.tbl_profiles.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        # Selected item from list
        profile_id = self.dlg_load.tbl_profiles.currentItem().text()

        extras = f'"profile_id":"{profile_id}", "action":"delete"'
        body = tools_gw.create_body(extras=extras)
        result = tools_gw.execute_procedure('gw_fct_setprofile', body)
        if result and 'message' in result:
            message = f"{result['message']}"
            tools_qgis.show_info(message)

        # Remove profile from list
        self.dlg_load.tbl_profiles.takeItem(self.dlg_load.tbl_profiles.row(self.dlg_load.tbl_profiles.currentItem()))


    def _remove_selection(self, actionpan=False):
        """ Remove selected features of all layers """

        for layer in self.canvas.layers():
            if type(layer) is QgsVectorLayer:
                layer.removeSelection()
        self.canvas.refresh()
        if actionpan:
            self.iface.actionPan().trigger()


    def _get_stylesheet(self, data_type='REAL'):

        # TODO: Enhance this function, manage all case for data_type, harmonie REAL/TOP-REAL...
        # getting stylesheet
        line_style = ''
        line_color = ''
        line_width = ''
        if data_type in ('REAL', 'TOP-REAL'):
            line_style = self.profile_json['body']['data']['stylesheet']['infra']['real']['style']
            line_color = self.profile_json['body']['data']['stylesheet']['infra']['real']['color']
            line_width = self.profile_json['body']['data']['stylesheet']['infra']['real']['width']
        elif data_type == 'INTERPOLATED':
            line_style = self.profile_json['body']['data']['stylesheet']['infra']['interpolated']['style']
            line_color = self.profile_json['body']['data']['stylesheet']['infra']['interpolated']['color']
            line_width = self.profile_json['body']['data']['stylesheet']['infra']['interpolated']['width']

        return line_style, line_color, line_width

    # endregion
