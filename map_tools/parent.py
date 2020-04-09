"""
/***************************************************************************
        begin                : 2016-08-24
        copyright            : (C) 2016 by BGEO SL
        email                : derill@bgeo.es
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

from qgis.core import QgsDataSourceUri, QgsExpression, QgsProject, QgsVectorLayer, QgsWkbTypes
from qgis.gui import QgsMapTool, QgsVertexMarker, QgsRubberBand
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QCursor, QColor, QIcon, QPixmap
from qgis.PyQt.QtWidgets import QTabWidget

import os
import sys
if 'nt' in sys.builtin_module_names:
    import ctypes
from .. import utils_giswater
from .snapping_utils_v3 import SnappingConfigManager
from ..ui_manager import GwDialog, GwMainWindow

class ParentMapTool(QgsMapTool):

    def __init__(self, iface, settings, action, index_action):  
        """ Class constructor """

        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.settings = settings
        self.show_help = bool(int(self.settings.value('status/show_help', 1)))
        self.index_action = index_action
        self.layer_arc = None        
        self.layer_connec = None
        self.layer_gully = None
        self.layer_node = None
        self.schema_name = None        
        self.controller = None        
        self.dao = None
        self.snapper_manager = None
        
        # Call superclass constructor and set current action        
        QgsMapTool.__init__(self, self.canvas)
        self.setAction(action)

        # Change map tool cursor
        self.cursor = QCursor()
        self.cursor.setShape(Qt.CrossCursor)

        # Get default cursor
        self.std_cursor = self.parent().cursor()

        # Set default vertex marker
        color = QColor(255, 100, 255)
        self.vertex_marker = QgsVertexMarker(self.canvas)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CIRCLE)
        self.vertex_marker.setColor(color)
        self.vertex_marker.setIconSize(15)
        self.vertex_marker.setPenWidth(3)

        # Set default rubber band
        color_selection = QColor(254, 178, 76, 63)
        self.rubber_band = QgsRubberBand(self.canvas, 2)
        self.rubber_band.setColor(color)
        self.rubber_band.setFillColor(color_selection)
        self.rubber_band.setWidth(1)
        self.reset()
        
        self.force_active_layer = True

        
    def get_cursor_multiple_selection(self):
        """ Set cursor for multiple selection """
        
        path_folder = os.path.join(os.path.dirname(__file__), os.pardir) 
        path_cursor = os.path.join(path_folder, 'icons', '201.png')                
        if os.path.exists(path_cursor):      
            cursor = QCursor(QPixmap(path_cursor))    
        else:        
            cursor = QCursor(Qt.ArrowCursor)  
                
        return cursor


    def set_controller(self, controller):

        self.controller = controller
        self.schema_name = controller.schema_name
        self.plugin_dir = self.controller.plugin_dir
        if self.snapper_manager is None:
            self.snapper_manager = SnappingConfigManager(self.iface)
        self.snapper_manager.controller = controller
        
        
    def deactivate(self):

        # Uncheck button
        self.action().setChecked(False)

        # Restore previous snapping
        self.snapper_manager.recover_snapping_options()

        # Enable snapping
        self.snapper_manager.enable_snapping(True)

        # Recover cursor
        self.canvas.setCursor(self.std_cursor)

        # Remove highlight
        self.vertex_marker.hide()



    def remove_vertex(self):
        """ Remove vertex_marker from canvas"""
        vertex_items = [i for i in self.iface.mapCanvas().scene().items() if issubclass(type(i), QgsVertexMarker)]

        for ver in vertex_items:
            if ver in self.iface.mapCanvas().scene().items():
                if self.vertex_marker == ver:
                    self.iface.mapCanvas().scene().removeItem(ver)


    def set_icon(self, widget, icon):
        """ Set @icon to selected @widget """

        # Get icons folder
        icons_folder = os.path.join(self.plugin_dir, 'icons')           
        icon_path = os.path.join(icons_folder, str(icon) + ".png")           
        if os.path.exists(icon_path):
            widget.setIcon(QIcon(icon_path))
        else:
            self.controller.log_info("File not found", parameter=icon_path)
            
    
    def set_action_pan(self):
        """ Set action 'Pan' """  
        try:
            self.iface.actionPan().trigger()     
        except Exception:          
            pass


    def reset_rubber_band(self, geom_type="polygon"):

        try:
            if geom_type == "polygon":
                geom_type = QgsWkbTypes.PolygonGeometry
            elif geom_type == "line":
                geom_type = QgsWkbTypes.LineString
            self.rubber_band.reset(geom_type)
        except:
            pass


    def reset(self):

        self.reset_rubber_band()
        self.snapped_feat = None      
        
    
    def cancel_map_tool(self):
        """ Executed if user press right button or escape key """
        
        # Reset rubber band
        self.reset()

        # Deactivate map tool
        self.deactivate()
        self.set_action_pan()
                        

    def remove_markers(self):
        """ Remove previous markers """
             
        vertex_items = [i for i in list(self.canvas.scene().items()) if issubclass(type(i), QgsVertexMarker)]
        for ver in vertex_items:
            if ver in list(self.canvas.scene().items()):
                self.canvas.scene().removeItem(ver)
        

    def refresh_map_canvas(self):
        """ Refresh all layers present in map canvas """
        
        self.canvas.refreshAllLayers()
        for layer_refresh in self.canvas.layers():
            layer_refresh.triggerRepaint()


    def open_dialog(self, dlg=None, dlg_name=None, info=True, maximize_button=True, stay_on_top=True):
        """ Open dialog """

        # Check database connection before opening dialog
        if not self.controller.check_db_connection():
            return

        if dlg is None or type(dlg) is bool:
            dlg = self.dlg
            
        # Manage i18n of the dialog
        if dlg_name:
            self.controller.manage_translation(dlg_name, dlg)

        # Manage stay on top, maximize/minimize button and information button
        # if info is True maximize flag will be ignored
        # To enable maximize button you must set info to False
        flags = Qt.WindowCloseButtonHint
        if info:
            flags |= Qt.WindowSystemMenuHint | Qt.WindowContextHelpButtonHint
        else:
            if maximize_button:
                flags |= Qt.WindowMinMaxButtonsHint

        if stay_on_top:
            flags |= Qt.WindowStaysOnTopHint

        dlg.setWindowFlags(flags)

        # Open dialog
        if issubclass(type(dlg), GwDialog):
            dlg.open()
        elif issubclass(type(dlg), GwMainWindow):
            dlg.show()
        else:
            dlg.show()
                    

    def close_dialog(self, dlg=None, set_action_pan=True): 
        """ Close dialog """
        
        if dlg is None or type(dlg) is bool:
            dlg = self.dlg
        try:
            self.save_settings(dlg)
            dlg.close()
            if set_action_pan:
                map_tool = self.canvas.mapTool()
                # If selected map tool is from the plugin, set 'Pan' as current one 
                if map_tool.toolName() == '':
                    self.set_action_pan()
        except AttributeError:
            pass


    def load_settings(self, dialog=None):
        """ Load QGIS settings related with dialog position and size """

        if dialog is None:
            dialog = self.dlg

        try:
            x = self.controller.plugin_settings_value(dialog.objectName() + "_x")
            y = self.controller.plugin_settings_value(dialog.objectName() + "_y")
            width = self.controller.plugin_settings_value(dialog.objectName() + "_width", dialog.property('width'))
            height = self.controller.plugin_settings_value(dialog.objectName() + "_height", dialog.property('height'))

            if int(x) < 0 or int(y) < 0:
                dialog.resize(int(width), int(height))
            else:
                screens = ctypes.windll.user32
                screen_x = screens.GetSystemMetrics(78)
                screen_y = screens.GetSystemMetrics(79)
                if int(x) > screen_x:
                    x = int(screen_x) - int(width)
                if int(y) > screen_y:
                    y = int(screen_y)
                dialog.setGeometry(int(x), int(y), int(width), int(height))
        except:
            pass
            
            
    def save_settings(self, dialog=None):
        """ Save QGIS settings related with dialog position and size """   
                   
        if dialog is None:
            dialog = self.dlg
            
        try:             
            self.controller.plugin_settings_set_value(dialog.objectName() + "_width", dialog.property('width'))
            self.controller.plugin_settings_set_value(dialog.objectName() + "_height", dialog.property('height'))
            self.controller.plugin_settings_set_value(dialog.objectName() + "_x", dialog.pos().x())
            self.controller.plugin_settings_set_value(dialog.objectName() + "_y", dialog.pos().y())  
        except:
            pass                      
            
        
    def check_expression(self, expr_filter, log_info=False):
        """ Check if expression filter @expr is valid """
        
        if log_info:
            self.controller.log_info(expr_filter)
        expr = QgsExpression(expr_filter)
        if expr.hasParserError():
            message = "Expression Error"
            self.controller.log_warning(message, parameter=expr_filter)      
            return False, expr

        return True, expr


    def get_composers_list(self):

        layour_manager = QgsProject.instance().layoutManager().layouts()
        active_composers = [layout for layout in layour_manager]

        return active_composers


    def get_composer_index(self, name):

        index = 0
        composers = self.get_composers_list()
        for comp_view in composers:
            composer_name = comp_view.name()
            if composer_name == name:
                break
            index += 1

        return index

        
    def canvasMoveEvent(self, event):

        # Make sure active layer is always 'v_edit_node'
        cur_layer = self.iface.activeLayer()
        if cur_layer != self.layer_node and self.force_active_layer:
            self.iface.setActiveLayer(self.layer_node)

        # Hide highlight and get coordinates
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(event)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if self.snapper_manager.result_is_valid():
            self.snapper_manager.add_marker(result, self.vertex_marker)


    def create_body(self, form='', feature='', filter_fields='', extras=None):
        """ Create and return parameters as body to functions"""

        client = f'$${{"client":{{"device":9, "infoType":100, "lang":"ES"}}, '
        form = f'"form":{{{form}}}, '
        feature = '"feature":{' + feature + '}, '
        filter_fields = '"filterFields":{' + filter_fields + '}'
        page_info = '"pageInfo":{}'
        data = '"data":{' + filter_fields + ', ' + page_info
        if extras:
            data += ', ' + extras
        data += f'}}}}$$'
        body = "" + client + form + feature + data

        return body


    def refresh_legend(self):
        """ This function solves the bug generated by changing the type of feature.
        Mysteriously this bug is solved by checking and unchecking the categorization of the tables.
        # TODO solve this bug
        """
        layers =[self.controller.get_layer_by_tablename('v_edit_node'),
                 self.controller.get_layer_by_tablename('v_edit_connec'),
                 self.controller.get_layer_by_tablename('v_edit_gully')]

        for layer in layers:
            if layer:
                ltl = QgsProject.instance().layerTreeRoot().findLayer(layer.id())
                ltm = self.iface.layerTreeView().model()
                legendNodes = ltm.layerLegendNodes(ltl)
                for ln in legendNodes:
                    current_state = ln.data(Qt.CheckStateRole)
                    ln.setData(Qt.Unchecked, Qt.CheckStateRole)
                    ln.setData(Qt.Checked, Qt.CheckStateRole)
                    ln.setData(current_state, Qt.CheckStateRole)


    def put_layer_into_toc(self, tablename=None, the_geom="the_geom", field_id="id", group='GW Layers'):
        """ Put layer from postgres DB into TOC"""
        schema_name = self.controller.credentials['schema'].replace('"', '')
        uri = QgsDataSourceUri()
        uri.setConnection(self.controller.credentials['host'], self.controller.credentials['port'],
                          self.controller.credentials['db'], self.controller.credentials['user'],
                          self.controller.credentials['password'])
        if not field_id:
            field_id = self.controller.get_pk(tablename)
            if not field_id:
                field_id = "id"
        uri.setDataSource(schema_name, f'{tablename}', the_geom, None, field_id)
        layer = QgsVectorLayer(uri.uri(), f'{tablename}', "postgres")

        root = QgsProject.instance().layerTreeRoot()
        my_group = root.findGroup(group)
        if my_group is None:
            my_group = root.insertGroup(0, group)

        my_group.insertLayer(0, layer)
        self.iface.mapCanvas().refresh()
        return layer


    def populate_info_text(self, dialog, data, force_tab=True, reset_text=True, tab_idx=1):

        change_tab = False
        text = utils_giswater.getWidgetText(dialog, 'txt_infolog', return_string_null=False)
        if reset_text:
            text = ""
        for item in data['info']['values']:
            if 'message' in item:
                if item['message'] is not None:
                    text += str(item['message']) + "\n"
                    if force_tab:
                        change_tab = True
                else:
                    text += "\n"

        utils_giswater.setWidgetText(dialog, 'txt_infolog', text + "\n")
        qtabwidget = dialog.findChild(QTabWidget, 'mainTab')
        if change_tab and qtabwidget is not None:
            qtabwidget.setCurrentIndex(tab_idx)

        return change_tab



