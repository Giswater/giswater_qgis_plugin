"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import global_vars

from qgis.core import QgsMapToPixel
from qgis.gui import QgsVertexMarker
from qgis.PyQt.QtCore import Qt

from core.toolbars.parent_maptool import GwParentMapTool
from core.ui.ui_manager import DialogTextUi
from core.utils.tools_giswater import populate_info_text, create_body, refresh_legend
from lib.tools_qgis import get_snapping_options, enable_snapping, get_event_point, snap_to_current_layer, \
    add_marker, get_snapped_layer, get_snapped_point, get_snapped_feature, get_snapped_feature_id

class GwArcDivideButton(GwParentMapTool):
    """ Button 16. Move node
    Execute SQL function: 'gw_fct_node2arc' """

    def __init__(self, icon_path, text, toolbar, action_group):
        """ Class constructor """
        super().__init__(icon_path, text, toolbar, action_group)


    def move_node(self, node_id, point):
        """ Move selected node to the current point """

        srid = global_vars.srid

        # Update node geometry
        the_geom = f"ST_GeomFromText('POINT({point.x()} {point.y()})', {srid})"
        sql = (f"UPDATE node SET the_geom = {the_geom} "
               f"WHERE node_id = '{node_id}'")
        status = self.controller.execute_sql(sql)
        if status:
            feature_id = f'"id":["{node_id}"]'
            body = create_body(feature=feature_id)
            result = self.controller.get_json('gw_fct_arc_divide', body)
            if not result:
                return
            if 'hideForm' not in result['body']['actions'] or not result['body']['actions']['hideForm']:
                self.dlg_dtext = DialogTextUi()
                self.dlg_dtext.btn_accept.hide()
                self.dlg_dtext.btn_close.clicked.connect(lambda: self.dlg_dtext.close())
                populate_info_text(self.dlg_dtext, result['body']['data'], False, True, 1)
                self.dlg_dtext.exec()

        else:
            message = "Move node: Error updating geometry"
            self.controller.show_warning(message)

        # Rubberband reset
        self.reset()

        # Refresh map canvas
        self.refresh_map_canvas()

        # Deactivate map tool
        self.deactivate()
        self.set_action_pan()



    """ QgsMapTool inherited event functions """

    def keyPressEvent(self, event):
        if event.key() == Qt.Key_Escape:
            self.cancel_map_tool()
            return


    def activate(self):
        """ Called when set as currently active map tool """

        # Check button
        self.action.setChecked(True)

        # Store user snapping configuration
        self.previous_snapping = get_snapping_options()

        # Clear snapping
        enable_snapping()

        # Get active layer
        self.active_layer = self.iface.activeLayer()

        # Set active layer to 'v_edit_node'
        self.layer_node = self.controller.get_layer_by_tablename("v_edit_node")
        self.iface.setActiveLayer(self.layer_node)

        # Get layer to 'v_edit_arc'
        self.layer_arc = self.controller.get_layer_by_tablename("v_edit_arc")

        # Set the mapTool's parent cursor
        self.canvas.setCursor(self.cursor)

        # Reset
        self.reset()

        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CIRCLE)

        # Show help message when action is activated
        if self.show_help:
            message = "Select the disconnected node by clicking on it, move the pointer to desired location inside a pipe and click again"
            self.controller.show_info(message)


    def deactivate(self):
        """ Called when map tool is being deactivated """

        # Call parent method
        super().deactivate()

        # Restore previous active layer
        if self.active_layer:
            self.iface.setActiveLayer(self.active_layer)

        try:
            self.reset_rubber_band("line")
        except AttributeError:
            pass


    def canvasMoveEvent(self, event):
        """ Mouse movement event """

        # Hide marker and get coordinates
        self.vertex_marker.hide()
        x = event.pos().x()
        y = event.pos().y()
        event_point = get_event_point(event)

        # Snap to node
        if self.snapped_feat is None:

            # Make sure active layer is 'v_edit_node'
            cur_layer = self.iface.activeLayer()
            if cur_layer != self.layer_node:
                self.iface.setActiveLayer(self.layer_node)
            # Snapping
            result = snap_to_current_layer(event_point)
            if result.isValid():
                # Get the point and add marker on it
                point = add_marker(result, self.vertex_marker)
            else:
                point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)

            # Set a new point to go on with
            self.rubber_band.movePoint(point)

        # Snap to arc
        else:

            # Make sure active layer is 'v_edit_arc'
            cur_layer = self.iface.activeLayer()
            if cur_layer != self.layer_arc:
                self.iface.setActiveLayer(self.layer_arc)

            # Snapping
            result = snap_to_current_layer(event_point)

            # if result and result[0].snappedVertexNr == -1:
            if result.isValid():
                layer = get_snapped_layer(result)
                feature_id = get_snapped_feature_id(result)
                point = add_marker(result, self.vertex_marker, QgsVertexMarker.ICON_CROSS)
                # Select the arc
                layer.removeSelection()
                layer.select([feature_id])
            else:
                # Bring the rubberband to the cursor i.e. the clicked point
                point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)

            self.rubber_band.movePoint(point)


    def canvasReleaseEvent(self, event):
        """ Mouse release event """

        if event.button() == Qt.LeftButton:

            event_point = get_event_point(event)

            # Snap to node
            if self.snapped_feat is None:

                result = snap_to_current_layer(event_point)
                if not result.isValid():
                    return

                self.snapped_feat = get_snapped_feature(result)
                point = get_snapped_point(result)

                # Hide marker
                self.vertex_marker.hide()

                # Set a new point to go on with
                self.rubber_band.addPoint(point)

                # Add arc snapping
                self.iface.setActiveLayer(self.layer_arc)

            # Snap to arc
            else:

                result = snap_to_current_layer(event_point)
                if not result.isValid():
                    return

                layer = get_snapped_layer(result)
                point = get_snapped_point(result)
                point = self.toLayerCoordinates(layer, point)

                # Get selected feature (at this moment it will have one and only one)
                node_id = self.snapped_feat.attribute('node_id')

                # Move selected node to the released point
                # Show message before executing
                message = ("The procedure will delete features on database unless it is a node that doesn't divide arcs.\n"
                           "Please ensure that features has no undelete value on true.\n"
                           "On the other hand you must know that traceability table will storage precedent information.")
                title = "Info"
                answer = self.controller.ask_question(message, title)
                if answer:
                    self.move_node(node_id, point)
                    self.controller.set_layer_index('v_edit_arc')
                    self.controller.set_layer_index('v_edit_connec')
                    self.controller.set_layer_index('v_edit_gully')
                    self.controller.set_layer_index('v_edit_node')
                    refresh_legend(self.controller)


        elif event.button() == Qt.RightButton:
            self.cancel_map_tool()

