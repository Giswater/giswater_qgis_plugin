"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import Qt
from qgis.core import QgsMapToPixel
from qgis.gui import QgsVertexMarker

from ..maptool import GwMaptool
from ...ui.ui_manager import GwDialogTextUi
from ...utils import tools_gw
from ....lib import tools_qt, tools_qgis, tools_db
from .... import global_vars


class GwArcDivideButton(GwMaptool):
    """ Button 16: Divide arc
    Execute SQL function: 'gw_fct_node2arc' """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)


    # region QgsMapTools inherited
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
        self.previous_snapping = self.snapper_manager.get_snapping_options()

        # Clear snapping
        self.snapper_manager.set_snapping_status()

        # Get active layer
        self.active_layer = self.iface.activeLayer()

        # Set active layer to 'v_edit_node'
        self.layer_node = tools_qgis.get_layer_by_tablename("v_edit_node")
        self.iface.setActiveLayer(self.layer_node)

        # Get layer to 'v_edit_arc'
        self.layer_arc = tools_qgis.get_layer_by_tablename("v_edit_arc")

        # Set the mapTool's parent cursor
        self.canvas.setCursor(self.cursor)

        # Reset
        self.reset()

        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CIRCLE)

        # Show help message when action is activated
        if self.show_help:
            message = "Click on disconnected node, move the pointer to the desired location on pipe to break it"
            tools_qgis.show_info(message)


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
        event_point = self.snapper_manager.get_event_point(event)

        # Snap to node
        if self.snapped_feat is None:

            # Make sure active layer is 'v_edit_node'
            cur_layer = self.iface.activeLayer()
            if cur_layer != self.layer_node:
                self.iface.setActiveLayer(self.layer_node)
            # Snapping
            result = self.snapper_manager.snap_to_current_layer(event_point)
            if result.isValid():
                # Get the point and add marker on it
                point = self.snapper_manager.add_marker(result, self.vertex_marker)
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
            result = self.snapper_manager.snap_to_current_layer(event_point)

            # if result and result[0].snappedVertexNr == -1:
            if result.isValid():
                layer = self.snapper_manager.get_snapped_layer(result)
                feature_id = self.snapper_manager.get_snapped_feature_id(result)
                point = self.snapper_manager.add_marker(result, self.vertex_marker, QgsVertexMarker.ICON_CROSS)
                # Select the arc
                layer.removeSelection()
                layer.select([feature_id])
            else:
                # Bring the rubberband to the cursor i.e. the clicked point
                point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)

            self.rubber_band.movePoint(point)


    def canvasReleaseEvent(self, event):

        self._get_arc_divide(event)



    # endregion

    # region private functions

    def _move_node(self, node_id, point):
        """ Move selected node to the current point """

        srid = global_vars.srid

        # Update node geometry
        the_geom = f"ST_GeomFromText('POINT({point.x()} {point.y()})', {srid})"
        sql = (f"UPDATE node SET the_geom = {the_geom} "
               f"WHERE node_id = '{node_id}'")
        status = tools_db.execute_sql(sql)
        if status:
            feature_id = f'"id":["{node_id}"]'
            body = tools_gw.create_body(feature=feature_id)
            result = tools_gw.execute_procedure('gw_fct_setarcdivide', body)
            if not result or result['status'] == 'Failed':
                return
            if 'hideForm' not in result['body']['actions'] or not result['body']['actions']['hideForm']:
                self.dlg_dtext = GwDialogTextUi('arc_divide')
                tools_gw.fill_tab_log(self.dlg_dtext, result['body']['data'], False, True, 1)
                tools_gw.open_dialog(self.dlg_dtext)

        else:
            message = "Move node: Error updating geometry"
            tools_qgis.show_warning(message)

        # Rubberband reset
        self.reset()

        # Refresh map canvas
        self.refresh_map_canvas()

        # Deactivate map tool
        self.deactivate()
        self.set_action_pan()

    def _get_arc_divide(self, event):

        if event.button() == Qt.LeftButton:

            event_point = self.snapper_manager.get_event_point(event)

            # Snap to node
            if self.snapped_feat is None:

                result = self.snapper_manager.snap_to_current_layer(event_point)
                if not result.isValid():
                    return

                self.snapped_feat = self.snapper_manager.get_snapped_feature(result)
                point = self.snapper_manager.get_snapped_point(result)

                # Hide marker
                self.vertex_marker.hide()

                # Set a new point to go on with
                self.rubber_band.addPoint(point)

                # Add arc snapping
                self.iface.setActiveLayer(self.layer_arc)

            # Snap to arc
            else:

                result = self.snapper_manager.snap_to_current_layer(event_point)
                if not result.isValid():
                    return

                layer = self.snapper_manager.get_snapped_layer(result)
                point = self.snapper_manager.get_snapped_point(result)
                point = self.toLayerCoordinates(layer, point)

                # Get selected feature (at this moment it will have one and only one)
                node_id = self.snapped_feat.attribute('node_id')

                # Move selected node to the released point
                # Show message before executing
                message = ("The procedure will delete features on database unless it is a node that doesn't divide arcs.\n"
                           "Please ensure that features has no undelete value on true.\n"
                           "On the other hand you must know that traceability table will storage precedent information.")
                title = "Info"
                answer = tools_qt.show_question(message, title)
                if answer:
                    self._move_node(node_id, point)
                    tools_qgis.set_layer_index('v_edit_arc')
                    tools_qgis.set_layer_index('v_edit_connec')
                    tools_qgis.set_layer_index('v_edit_gully')
                    tools_qgis.set_layer_index('v_edit_node')

        elif event.button() == Qt.RightButton:
            self.cancel_map_tool()

    # endregion