"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json
import math
import os
from collections import OrderedDict
from datetime import timedelta
from decimal import Decimal
from functools import partial
from time import time

from qgis.PyQt.QtCore import QDate, QTimer
from qgis.PyQt.QtWidgets import QCheckBox, QComboBox, QLineEdit, QRadioButton, QWidget, QLabel
from qgis.PyQt.sip import isdeleted
from qgis.core import QgsApplication, QgsProject, QgsTask, Qgis

from ..utils import tools_gw, tools_backend_calls
from ..ui.ui_manager import GwToolboxManagerUi
from ..threads.toolbox_execute import GwToolBoxTask
from ... import global_vars
from ...libs import lib_vars, tools_qt, tools_os, tools_qgis, tools_log

_NODE_INTERPOLATE_FUNCTION_ID = 3248
_INTERP_CONFIG_SECTION = 'btn_network_utilities'

# GwProfile: draw/show longitudinal profiles.
# GwProfileInterpolation: FLOWEXIT node interpolate (3248), then show profile.
# TODO: replace GwToolboxManagerUi with a dedicated profile-interpolation dialog.
#       Function 3248 will be removed/hidden from the main toolbox catalog.


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


class GwProfile:
    """Longitudinal profile drawing and display."""

    def __init__(self):
        self.nodes = []
        self.links = []
        self.none_values = []
        self.rotation_vd_exist = False
        self.lastnode_datatype = 'REAL'
        self.profile_json = None
        self.plot = None
        self._dlg = None
        self._title = None
        self._date = None
        self._init_node = None
        self._end_node = None

    def set_draw_context(self, init_node=None, end_node=None, title=None, date=None, dlg=None):
        self._init_node = init_node
        self._end_node = end_node
        self._title = title
        self._date = date
        self._dlg = dlg

    @staticmethod
    def check_matplotlib():
        try:
            tools_os.get_dep("matplotlib.pyplot")
            return True
        except ImportError:
            tools_qgis.show_critical(
                "Python package 'matplotlib' is not installed. "
                "Please install it using pip or the 'qpip' QGIS plugin."
            )
            return False

    def fetch_profile_values(self, init_node, end_node, links_distance=None, mid_features=None):
        if links_distance in ("", "None", None):
            links_distance = tools_gw.get_config_parser(
                'btn_profile', 'min_distance_profile', "user", "session")
        if links_distance in ("", "None", None):
            links_distance = 1
        extras = (
            f'"initNode":"{init_node}", "endNode":"{end_node}", '
            f'"linksDistance":{links_distance}, "scale":{{"eh":1000, "ev":1000}}'
        )
        if mid_features:
            points_list = str(mid_features).replace("'", "")
            extras += f', "midFeatures":{points_list}'
        body = tools_gw.create_body(extras=extras)
        return tools_gw.execute_procedure('gw_fct_getprofilevalues', body), links_distance

    def show_profile(self, init_node, end_node, links_distance=None, mid_features=None,
                     title=None, date=None, dlg=None):
        if not self.check_matplotlib():
            return False
        self.nodes = []
        self.links = []
        self.none_values = []
        self.set_draw_context(init_node, end_node, title, date, dlg)
        profile_json, _ = self.fetch_profile_values(init_node, end_node, links_distance, mid_features)
        if profile_json is None or profile_json.get('status') == 'Failed':
            return False
        if profile_json.get('message'):
            level = int(profile_json['message']['level'])
            msg = profile_json['message']['text']
            tools_qgis.show_message(msg, Qgis.MessageLevel(level))
            if profile_json['message']['level'] != 3:
                return False
        return self.draw_from_json(profile_json)

    def draw_from_json(self, profile_json):
        self.profile_json = profile_json
        data = profile_json['body']['data']
        self.draw(data['arc'], data['node'], data['terrain'])
        self.show_window()
        if self.none_values:
            msg = "There are missing values in these nodes:"
            tools_qt.show_info_box(msg, inf_text=self.none_values)
        return True

    def show_window(self):
        self.plot.show()
        mng = self.plot.get_current_fig_manager()
        mng.window.showMaximized()

    def draw(self, arcs, nodes, terrains):
        """Draw the longitudinal profile chart from arc, node and terrain data."""
        plt = tools_os.get_dep("matplotlib.pyplot")

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

        # Save profile.png under the plugin temp folder (overwrite if it exists)
        temp_folder = f"{lib_vars.user_folder_dir}{os.sep}core{os.sep}temp"
        img_path = f"{temp_folder}{os.sep}profile.png"
        if not os.path.exists(temp_folder):
            os.makedirs(temp_folder)
        else:
            msg = "Profile image path: {0}"
            msg_params = (img_path,)
            tools_log.log_info(msg, msg_params=msg_params)

        fig_size = plt.rcParams["figure.figsize"]

        # Set figure width to 10.4  and height to 4.8
        fig_size[0] = 10.4
        fig_size[1] = 4.8
        plt.rcParams["figure.figsize"] = fig_size

        # Save profile with dpi = 300
        plt.savefig(img_path, dpi=300)

    def _set_profile_layout(self):
        """ Set properties of main window """
        plt = tools_os.get_dep("matplotlib.pyplot")

        # Set window name
        self.win = plt.gcf()
        title = tools_qt.tr("Draw Profile")
        mng = plt.get_current_fig_manager()
        mng.set_window_title(title)

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
        plt = tools_os.get_dep("matplotlib.pyplot")

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
        xinf = []
        yinf = []
        xsup = []
        ysup = []
        if node.surface_type == 'TOP':
            xinf = [s1x, i1x, i2x, i3x]
            yinf = [s1y, i1y, i2y, i3y]
            xsup = [s1x, s2x, s3x]
            ysup = [s1y, s2y, s3y]
        else:
            s0x = -node.geom / 2
            s0y = node.top_elev - node.ymax + node.z1 + node.cat_geom
            xinf = [s0x, i1x, i2x, i3x]
            yinf = [s0y, i1y, i2y, i3y]
            xsup = [s0x, s3x]
            ysup = [s0y, s3y]

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
        plt = tools_os.get_dep("matplotlib.pyplot")

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
        plt = tools_os.get_dep("matplotlib.pyplot")

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
        plt = tools_os.get_dep("matplotlib.pyplot")

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
        title = self._legend_title()
        plt.text(-self.fix_x * Decimal(1), self.min_top_elev - Decimal(5.75) * self.height_row - self.height_row / 2,
                 title, fontsize=title_size, color=title_color, fontweight=title_weight,
                 verticalalignment='center')

        date = self._legend_date()
        plt.text(-self.fix_x * Decimal(1), self.min_top_elev - Decimal(6) * self.height_row - self.height_row / 2,
                 date, fontsize=title_size * 0.7, color=title_color, fontweight=title_weight, verticalalignment='center')

    def _draw_nodes(self, node, prev_node, index):
        """ Draw nodes between first and last node """
        plt = tools_os.get_dep("matplotlib.pyplot")

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
        xnsup = []
        ynsup = []
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
        plt = tools_os.get_dep("matplotlib.pyplot")

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
        plt = tools_os.get_dep("matplotlib.pyplot")

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
        """draws last arc and nodes of profile
        :param node:
        :param prev_node:
        :param index:
        :return:
        """
        plt = tools_os.get_dep("matplotlib.pyplot")

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
        xnsup = []
        ynsup = []
        if node.surface_type == 'TOP':
            xnsup = [s2x, s3x, s4x, i4x]
            ynsup = [s2y, s3y, s4y, i4y]
        else:
            s0x = node.start_point + node.geom / 2
            s0y = node.top_elev - node.ymax + prev_node.z2 + prev_node.cat_geom
            xnsup = [s2x, s0x, i4x]
            ynsup = [s2y, s0y, i4y]

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
        plt = tools_os.get_dep("matplotlib.pyplot")
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
        plt = tools_os.get_dep("matplotlib.pyplot")

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
        plt = tools_os.get_dep("matplotlib.pyplot")

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


    def _legend_title(self):
        if self._title not in (None, ''):
            return self._title
        if self._dlg is not None:
            title = tools_qt.get_text(self._dlg, self._dlg.txt_title, False, False)
            if title not in ('', None):
                return title
        if self._init_node and self._end_node:
            return f"PROFILE {self._init_node} - {self._end_node}"
        return ''

    def _legend_date(self):
        if self._date not in (None, ''):
            return self._date
        if self._dlg is not None:
            return tools_qt.get_calendar_date(self._dlg, self._dlg.date)
        return ''
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


class GwProfileInterpolation:
    """FLOWEXIT node interpolation (function 3248) then show profile.

    Entry point: Network utilities menu only (not the main toolbox tree).
    UI: temporary reuse of GwToolboxManagerUi until a dedicated dialog is added.
    """

    def __init__(self, parent_widget):
        self.parent_widget = parent_widget
        self.rbt_checked = {}
        self.function_list = []
        self.temp_layers_added = []
        self.ignore_widgets = ['qt_spinbox_lineedit', 'qt_calendar_yearedit']
        self.interp_task = None
        self._interp_process_data = None
        self._interp_function_name = None
        self._interp_task_handler = None
        self._interp_timer = None
        self._profile = GwProfile()

    def run(self):
        dlg = self._open_dialog()
        if not dlg:
            return
        type_combo = dlg.findChild(QComboBox, 'type')
        if type_combo:
            tools_qt.set_combo_value(type_combo, 'FLOWEXIT', 0)
            type_combo.setVisible(False)
        profile_mode = dlg.findChild(QComboBox, 'profileMode')
        if profile_mode:
            tools_qt.set_combo_value(profile_mode, 'SMOOTH', 0)
        try:
            dlg.btn_run.clicked.disconnect()
        except TypeError:
            pass
        dlg.btn_run.clicked.connect(partial(self._execute_and_profile, dlg))

    def _open_dialog(self):
        """Open the interpolate process form (3248). TODO: dedicated UI, not toolbox_tool."""
        dlg = GwToolboxManagerUi(self.parent_widget)
        tools_gw.load_settings(dlg)
        dlg.progressBar.setVisible(False)
        dlg.btn_cancel.hide()
        dlg.btn_close.show()
        dlg.btn_cancel.clicked.connect(self._cancel_task)
        dlg.cmb_layers.currentIndexChanged.connect(partial(self.set_selected_layer, dlg, dlg.cmb_layers))
        dlg.rbt_previous.toggled.connect(partial(self._rbt_state, dlg.rbt_previous))
        dlg.rbt_layer.toggled.connect(partial(self._rbt_state, dlg.rbt_layer))
        dlg.rbt_layer.setChecked(True)
        extras = f'"functionId":{_NODE_INTERPOLATE_FUNCTION_ID}'
        body = tools_gw.create_body(extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_getprocess', body)
        if not json_result or json_result['status'] == 'Failed':
            return None
        self._interp_process_data = json_result['body']['data']
        self._interp_function_name = self._interp_process_data['functionname']
        if not self._populate_dialog(dlg, self._interp_process_data):
            tools_qgis.show_message("Function not found", parameter=self._interp_function_name)
            return None
        tools_gw.disable_tab_log(dlg)
        dlg.mainTab.currentChanged.connect(partial(self._manage_btn_run, dlg))
        dlg.btn_close.clicked.connect(partial(tools_gw.close_dialog, dlg))
        dlg.rejected.connect(partial(tools_gw.close_dialog, dlg))
        dlg.btn_cancel.clicked.connect(partial(self.remove_layers))
        tools_gw.open_dialog(dlg, dlg_name='toolbox')
        dlg.setWindowTitle(self._interp_process_data.get('alias', self._interp_function_name))
        return dlg

    def _populate_dialog(self, dialog, result, module=tools_backend_calls):
        if not result or result['functionparams'].get('featureType'):
            return False
        dialog.setWindowTitle(result['alias'])
        dialog.txt_info.setText(str(result['descript']))
        dialog.grb_input_layer.setVisible(False)
        dialog.grb_selection_type.setVisible(False)
        tools_gw.build_dialog_options(dialog, result, 0, self.function_list, self.temp_layers_added, module)
        self._load_parametric_values(dialog, result)
        for field in result.get('fields') or []:
            signal = field.get('signal')
            if signal:
                getattr(module, signal)(dialog)
        return True

    def _execute_and_profile(self, dlg):
        node1_widget = dlg.findChild(QLineEdit, 'node1')
        node2_widget = dlg.findChild(QLineEdit, 'node2')
        node1 = tools_qt.get_text(dlg, node1_widget, False, False) if node1_widget else None
        node2 = tools_qt.get_text(dlg, node2_widget, False, False) if node2_widget else None
        if not node1 or not node2:
            tools_qt.show_info_box("node1 and node2 are required for profile interpolation.")
            return
        self._disconnect_task_handler()
        self._interp_task_handler = partial(self._on_task_completed, node1, node2)
        QgsApplication.taskManager().taskCompleted.connect(self._interp_task_handler)
        self._execute(dlg, self._interp_process_data, aux_params="null", use_aux_conn=False)

    def _execute(self, dialog, result, aux_params="null", use_aux_conn=True):
        if self.interp_task is not None:
            try:
                if self.interp_task.isActive():
                    tools_qgis.show_warning("Toolbox task is already active!")
                    return
            except RuntimeError:
                pass
        dialog.btn_cancel.show()
        dialog.btn_close.hide()
        dialog.progressBar.setRange(0, 0)
        dialog.progressBar.setVisible(True)
        dialog.progressBar.setStyleSheet(
            "QProgressBar {border: 0px solid #000000; border-radius: 5px; background-color: #E0E0E0;}"
            "QProgressBar::chunk {background-color:#0bd82c; width: 10 px; margin: 0.5px;}")
        t0 = time()
        self._interp_timer = QTimer()
        self._interp_timer.timeout.connect(partial(self._update_elapsed_time, dialog, t0))
        self._interp_timer.start(1000)
        self.interp_task = GwToolBoxTask(
            self, self._interp_function_name, dialog, dialog.cmb_layers, result,
            timer=self._interp_timer, aux_params=aux_params)
        self.interp_task.use_aux_conn = use_aux_conn
        QgsApplication.taskManager().addTask(self.interp_task)
        QgsApplication.taskManager().triggerTask(self.interp_task)

    def _disconnect_task_handler(self):
        if self._interp_task_handler is not None:
            try:
                QgsApplication.taskManager().taskCompleted.disconnect(self._interp_task_handler)
            except TypeError:
                pass
            self._interp_task_handler = None

    def _on_task_completed(self, node1, node2, task):
        if task != self.interp_task:
            return
        self._disconnect_task_handler()
        if task.status() != QgsTask.TaskStatus.Complete:
            return
        json_result = getattr(self.interp_task, 'json_result', None)
        if not json_result or json_result.get('status') == 'Failed':
            return
        self._profile.show_profile(node1, node2)

    def _cancel_task(self):
        if self.interp_task is not None:
            self.interp_task.cancel()

    def _manage_btn_run(self, dialog, index):
        if index == 1:
            dialog.btn_run.setEnabled(False)
        elif self.interp_task is not None:
            try:
                dialog.btn_run.setEnabled(not self.interp_task.isActive())
            except RuntimeError:
                dialog.btn_run.setEnabled(True)
        else:
            dialog.btn_run.setEnabled(True)

    def _update_elapsed_time(self, dialog, t0):
        if isdeleted(dialog):
            if self._interp_timer:
                self._interp_timer.stop()
            return
        elapsed = timedelta(seconds=round(time() - t0))
        lbl_time = dialog.findChild(QLabel, 'lbl_time')
        if lbl_time:
            lbl_time.setText(f"Exec. time: {elapsed}")

    def _rbt_state(self, rbt, state):
        if rbt.objectName() == 'rbt_previous' and state is True:
            self.rbt_checked['widget'] = 'previousSelection'
        elif rbt.objectName() == 'rbt_layer' and state is True:
            self.rbt_checked['widget'] = 'wholeSelection'
        self.rbt_checked['value'] = state

    def _load_parametric_values(self, dialog, function):
        function_name = function['functionname']
        layout = dialog.findChild(QWidget, 'grb_parameters')
        if not layout:
            return
        for widget in layout.findChildren(QWidget):
            if type(widget) in (QCheckBox, QRadioButton) and widget.property('value') in (None, ''):
                value = tools_gw.get_config_parser(
                    _INTERP_CONFIG_SECTION, f"{function_name}_{widget.objectName()}", "user", "session")
                if value not in (None, 'None'):
                    tools_qt.set_checked(dialog, widget, value)
            elif isinstance(widget, QComboBox) and widget.property('selectedId') in (None, ''):
                value = tools_gw.get_config_parser(
                    _INTERP_CONFIG_SECTION, f"{function_name}_{widget.objectName()}", "user", "session")
                if value in (None, '', 'NULL') and widget.property('selectedId') not in (None, '', 'NULL'):
                    value = widget.property('selectedId')
                tools_qt.set_combo_value(widget, value, 0)
            elif isinstance(widget, QLineEdit) and widget.property('value') in (None, ''):
                value = tools_gw.get_config_parser(
                    _INTERP_CONFIG_SECTION, f"{function_name}_{widget.objectName()}", "user", "session")
                tools_qt.set_widget_text(dialog, widget, value)
            elif isinstance(widget, tools_gw.CustomQgsDateTimeEdit) and widget.property('value') in (None, ''):
                value = tools_gw.get_config_parser(
                    _INTERP_CONFIG_SECTION, f"{function_name}_{widget.objectName()}", "user", "session")
                date = QDate.fromString(value, lib_vars.date_format)
                tools_qt.set_calendar(dialog, widget, date)

    def save_parametric_values(self, dialog, function_name):
        layout = dialog.findChild(QWidget, 'grb_parameters')
        if not layout:
            return
        for widget in layout.findChildren(QWidget):
            if widget.objectName() in self.ignore_widgets:
                continue
            key = f"{function_name}_{widget.objectName()}"
            if isinstance(widget, QCheckBox):
                tools_gw.set_config_parser(_INTERP_CONFIG_SECTION, key, f"{widget.isChecked()}")
            elif isinstance(widget, QComboBox):
                value = tools_qt.get_combo_value(dialog, widget, 0)
                tools_gw.set_config_parser(_INTERP_CONFIG_SECTION, key, f"{value}")
            elif isinstance(widget, QLineEdit):
                value = tools_qt.get_text(dialog, widget, False, False)
                tools_gw.set_config_parser(_INTERP_CONFIG_SECTION, key, f"{value}")
            elif isinstance(widget, tools_gw.CustomQgsDateTimeEdit):
                value = tools_qt.get_calendar_date(dialog, widget, date_format=lib_vars.date_format)
                tools_gw.set_config_parser(_INTERP_CONFIG_SECTION, key, f"{value}")

    def save_settings_values(self, dialog, function_name):
        feature_type = tools_qt.get_combo_value(dialog, dialog.cmb_feature_type, 0)
        tools_gw.set_config_parser(_INTERP_CONFIG_SECTION, f"{function_name}_cmb_feature_type", f"{feature_type}")
        layer = tools_qt.get_combo_value(dialog, dialog.cmb_layers, 0)
        tools_gw.set_config_parser(_INTERP_CONFIG_SECTION, f"{function_name}_cmb_layers", f"{layer}")
        tools_gw.set_config_parser(
            _INTERP_CONFIG_SECTION, f"{function_name}_rbt_previous", f"{dialog.rbt_previous.isChecked()}")

    def set_selected_layer(self, dialog, combo):
        layer_name = tools_qt.get_combo_value(dialog, combo, 1)
        layer = tools_qgis.get_layer_by_tablename(layer_name)
        if layer is None:
            tools_qgis.show_warning("Layer not found", parameter=layer_name)
            return None
        global_vars.iface.setActiveLayer(layer)
        return layer

    def remove_layers(self):
        root = QgsProject.instance().layerTreeRoot()
        for layer in reversed(self.temp_layers_added):
            self.temp_layers_added.remove(layer)
            try:
                dem_raster = root.findLayer(layer.id())
            except RuntimeError:
                continue
            parent_group = dem_raster.parent()
            try:
                QgsProject.instance().removeMapLayer(layer.id())
            except Exception:
                pass
            if len(parent_group.findLayers()) == 0:
                root.removeChildNode(parent_group)
        global_vars.iface.mapCanvas().refresh()
