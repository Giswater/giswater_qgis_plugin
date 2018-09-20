"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4.Qt import QDate
    from PyQt4.QtCore import Qt, QPoint
    from PyQt4.QtGui import QTableView, QDateEdit, QLineEdit, QTextEdit, QDateTimeEdit, QComboBox
    from PyQt4.QtGui import QColor, QCompleter, QStringListModel, QAbstractItemView
    from PyQt4.QtSql import QSqlTableModel
    from qgis.gui import QgsMapToolEmitPoint, QgsMapCanvasSnapper, QgsVertexMarker    
else:
    from qgis.PyQt.QtCore import Qt, QPoint, QStringListModel, QDate
    from qgis.PyQt.QtGui import QColor
    from qgis.PyQt.QtWidgets import QTableView, QDateEdit, QLineEdit, QTextEdit, QDateTimeEdit, QComboBox
    from qgis.PyQt.QtWidgets import QCompleter, QAbstractItemView
    from qgis.PyQt.QtSql import QSqlTableModel
    from qgis.gui import QgsMapToolEmitPoint, QgsMapCanvas, QgsVertexMarker    

from qgis.core import QgsFeatureRequest, QgsPoint

from functools import partial

import utils_giswater
from giswater.actions.parent import ParentAction
from giswater.actions.multiple_selection import MultipleSelection


class ParentManage(ParentAction, object):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to keep common functions of classes
            'ManageDocument', 'ManageElement' and 'ManageVisit' of toolbar 'edit'."""
        super(ParentManage, self).__init__(iface, settings, controller, plugin_dir)

        self.x = ""
        self.y = ""
        self.canvas = self.iface.mapCanvas()
        self.plan_om = None
        self.previous_map_tool = None
        self.autocommit = True
        self.lazy_widget = None
        self.workcat_id_end = None
        self.xyCoordinates_conected = False


    def reset_lists(self):
        """ Reset list of selected records """

        self.ids = []
        self.list_ids = {}
        self.list_ids['arc'] = []
        self.list_ids['node'] = []
        self.list_ids['connec'] = []
        self.list_ids['gully'] = []
        self.list_ids['element'] = []


    def reset_layers(self):
        """ Reset list of layers """

        self.layers = {}
        self.layers['arc'] = []
        self.layers['node'] = []
        self.layers['connec'] = []
        self.layers['gully'] = []
        self.layers['element'] = []


    def reset_model(self, dialog, table_object, geom_type):
        """ Reset model of the widget """ 

        table_relation = table_object + "_x_" + geom_type
        widget_name = "tbl_" + table_relation
        widget = utils_giswater.getWidget(dialog, widget_name)
        if widget:              
            widget.setModel(None)


    def remove_selection(self, remove_groups=True):
        """ Remove all previous selections """

        layer = self.controller.get_layer_by_tablename("v_edit_arc")
        if layer:
            layer.removeSelection()
        layer = self.controller.get_layer_by_tablename("v_edit_node")
        if layer:
            layer.removeSelection()
        layer = self.controller.get_layer_by_tablename("v_edit_connec")
        if layer:
            layer.removeSelection()
        layer = self.controller.get_layer_by_tablename("v_edit_element")
        if layer:
            layer.removeSelection()
            
        if self.project_type == 'ud':
            layer = self.controller.get_layer_by_tablename("v_edit_gully")
            if layer:
                layer.removeSelection()

        try:
            if remove_groups:
                for layer in self.layers['arc']:
                    layer.removeSelection()
                for layer in self.layers['node']:
                    layer.removeSelection()
                for layer in self.layers['connec']:
                    layer.removeSelection()
                for layer in self.layers['gully']:
                    layer.removeSelection()
                for layer in self.layers['element']:
                    layer.removeSelection()
        except:
            pass

        self.canvas.refresh()
    
    
    def reset_widgets(self, dialog, table_object):
        """ Clear contents of input widgets """
        
        if table_object == "doc":
            utils_giswater.setWidgetText(dialog, "doc_type", "")
            utils_giswater.setWidgetText(dialog, "observ", "")
            utils_giswater.setWidgetText(dialog, "path", "")
        elif table_object == "element":
            utils_giswater.setWidgetText(dialog, "elementcat_id", "")
            utils_giswater.setWidgetText(dialog, "state", "")
            utils_giswater.setWidgetText(dialog, "expl_id","")
            utils_giswater.setWidgetText(dialog, "ownercat_id", "")
            utils_giswater.setWidgetText(dialog, "location_type", "")
            utils_giswater.setWidgetText(dialog, "buildercat_id", "")
            utils_giswater.setWidgetText(dialog, "workcat_id", "")
            utils_giswater.setWidgetText(dialog, "workcat_id_end", "")
            utils_giswater.setWidgetText(dialog, "comment", "")
            utils_giswater.setWidgetText(dialog, "observ", "")
            utils_giswater.setWidgetText(dialog, "path", "")
            utils_giswater.setWidgetText(dialog, "rotation", "")
            utils_giswater.setWidgetText(dialog, "verified", "")
            utils_giswater.setWidgetText(dialog, dialog.num_elements, "")
                    
    
    def fill_widgets(self, dialog, table_object, row):
        """ Fill input widgets with data int he @row """
        
        if table_object == "doc":
            
            utils_giswater.setWidgetText(dialog, "doc_type", row["doc_type"])
            utils_giswater.setWidgetText(dialog, "observ",  row["observ"])
            utils_giswater.setWidgetText(dialog, "path",  row["path"])
             
        elif table_object == "element":
                    
            state = ""  
            if row['state']:          
                sql = ("SELECT name FROM " + self.schema_name + ".value_state"
                       " WHERE id = '" + str(row['state']) + "'")
                row_aux = self.controller.get_row(sql, commit=self.autocommit)
                if row_aux:
                    state = row_aux[0]
    
            expl_id = ""
            if row['expl_id']:
                sql = ("SELECT name FROM " + self.schema_name + ".exploitation"
                       " WHERE expl_id = '" + str(row['expl_id']) + "'")
                row_aux = self.controller.get_row(sql, commit=self.autocommit)
                if row_aux:
                    expl_id = row_aux[0]

            utils_giswater.setWidgetText(dialog, "num_elements", row['num_elements'])
            utils_giswater.setWidgetText(dialog, "state", state)
            utils_giswater.setWidgetText(dialog, "expl_id", expl_id)
            sql = ("SELECT elementtype_id FROM " + self.schema_name + ".cat_element"
                   " WHERE id = '" + str(row['elementcat_id']) + "'")
            row_type = self.controller.get_row(sql)
            if row_type:
                utils_giswater.setWidgetText(dialog, "element_type", row_type[0])
            utils_giswater.setWidgetText(dialog, "ownercat_id", row['ownercat_id'])
            utils_giswater.setWidgetText(dialog, "location_type", row['location_type'])
            utils_giswater.setWidgetText(dialog, "buildercat_id", row['buildercat_id'])
            utils_giswater.setWidgetText(dialog, "workcat_id", row['workcat_id'])
            utils_giswater.setWidgetText(dialog, "workcat_id_end", row['workcat_id_end'])
            utils_giswater.setWidgetText(dialog, "comment", row['comment'])
            utils_giswater.setWidgetText(dialog, "observ", row['observ'])
            utils_giswater.setWidgetText(dialog, "link", row['link'])
            utils_giswater.setWidgetText(dialog, "verified", row['verified'])
            utils_giswater.setWidgetText(dialog, "rotation", row['rotation'])
            if str(row['undelete'])== 'True':
                dialog.undelete.setChecked(True)
            builtdate = QDate.fromString(str(row['builtdate']), 'yyyy-MM-dd')
            enddate = QDate.fromString(str(row['enddate']), 'yyyy-MM-dd')

            dialog.builtdate.setDate(builtdate)
            dialog.enddate.setDate(enddate)
            
              
    def get_records_geom_type(self, dialog, table_object, geom_type):
        """ Get records of @geom_type associated to selected @table_object """
        
        object_id = utils_giswater.getWidgetText(dialog, table_object + "_id")
        table_relation = table_object + "_x_" + geom_type
        widget_name = "tbl_" + table_relation           
        
        exists = self.controller.check_table(table_relation)
        if not exists:
            self.controller.log_info("Not found: " + str(table_relation))
            return
              
        sql = ("SELECT " + geom_type + "_id"
               " FROM " + self.schema_name + "." + table_relation + ""
               " WHERE " + table_object + "_id = '" + str(object_id) + "'")
        rows = self.controller.get_rows(sql, log_info=False)
        if rows:
            for row in rows:
                self.list_ids[geom_type].append(str(row[0]))
                self.ids.append(str(row[0]))

            expr_filter = self.get_expr_filter(geom_type)
            self.set_table_model(dialog, widget_name, geom_type, expr_filter)
            
                                
    def exist_object(self, dialog, table_object):
        """ Check if selected object (document or element) already exists """
        
        # Reset list of selected records
        self.reset_lists()
        
        field_object_id = "id"
        if table_object == "element":
            field_object_id = table_object + "_id"           
        object_id = utils_giswater.getWidgetText(dialog, table_object + "_id")

        # Check if we already have data with selected object_id
        sql = ("SELECT * " 
            " FROM " + self.schema_name + "." + str(table_object) + ""
            " WHERE " + str(field_object_id) + " = '" + str(object_id) + "'")
        row = self.controller.get_row(sql, log_info=False)

        # If object_id not found: Clear data
        if not row:    
            self.reset_widgets(dialog, table_object)
            if table_object == 'element':
                self.set_combo(dialog, 'state', 'value_state', 'state_vdefault', field_name='name')
                self.set_combo(dialog, 'expl_id', 'exploitation', 'exploitation_vdefault', field_id='expl_id',field_name='name')
                self.set_calendars(dialog, 'builtdate', 'config_param_user', 'value', 'builtdate_vdefault')
                self.set_combo(dialog, 'workcat_id', 'cat_work', 'workcat_vdefault', field_id='id', field_name='id')
            if hasattr(self, 'single_tool_mode'):
                # some tools can work differently if standalone or integrated in
                # another tool
                if self.single_tool_mode:
                    self.remove_selection(True)
            else:
                self.remove_selection(True)
            self.reset_model(dialog, table_object, "arc")
            self.reset_model(dialog, table_object, "node")
            self.reset_model(dialog, table_object, "connec")
            self.reset_model(dialog, table_object, "element")
            if self.project_type == 'ud':
                self.reset_model(dialog, table_object, "gully")
            if table_object != 'doc':
                dialog.enddate.setEnabled(False)
            return

        if table_object != 'doc':
            dialog.enddate.setEnabled(True)

        # Fill input widgets with data of the @row
        self.fill_widgets(dialog, table_object, row)

        # Check related 'arcs'
        self.get_records_geom_type(dialog, table_object, "arc")
        
        # Check related 'nodes'
        self.get_records_geom_type(dialog, table_object, "node")
        
        # Check related 'connecs'
        self.get_records_geom_type(dialog, table_object, "connec")

        # Check related 'elements'
        self.get_records_geom_type(dialog, table_object, "element")

        # Check related 'gullys'
        if self.project_type == 'ud':        
            self.get_records_geom_type(dialog, table_object, "gully")


    def populate_combo(self, dialog, widget, table_name, field_name="id"):
        """ Executes query and fill combo box """

        sql = ("SELECT " + field_name + ""
               " FROM " + self.schema_name + "." + table_name + ""
               " ORDER BY " + field_name)
        rows = self.controller.get_rows(sql, commit=self.autocommit)
        utils_giswater.fillComboBox(dialog, widget, rows)
        if rows:
            utils_giswater.setCurrentIndex(dialog, widget, 0)


    def set_combo(self, dialog, widget, table_name, parameter, field_id='id', field_name='id'):
        """ Executes query and set combo box """
        
        sql = ("SELECT t1." + field_name + " FROM " + self.schema_name + "." + table_name + " as t1"
               " INNER JOIN " + self.schema_name + ".config_param_user as t2 ON t1." + field_id + "::text = t2.value::text"
               " WHERE parameter = '" + parameter + "' AND cur_user = current_user")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(dialog, widget, row[0])


    def set_calendars(self, dialog, widget, table_name, value, parameter):
        """ Executes query and set QDateEdit """
        
        sql = ("SELECT " + value + " FROM " + self.schema_name + "." + table_name + ""
               " WHERE parameter = '" + parameter + "' AND cur_user = current_user")
        row = self.controller.get_row(sql)
        if row:
            date = QDate.fromString(row[0], 'yyyy-MM-dd')
        else:
            date = QDate.currentDate()
        utils_giswater.setCalendarDate(dialog, widget, date)


    def add_point(self):
        """ Create the appropriate map tool and connect to the corresponding signal """
        
        active_layer = self.iface.activeLayer()
        if active_layer is None:
            active_layer = self.controller.get_layer_by_tablename('version')
            self.iface.setActiveLayer(active_layer)

        # Vertex marker
        self.vertex_marker = QgsVertexMarker(self.canvas)
        self.vertex_marker.setColor(QColor(255, 100, 255))
        self.vertex_marker.setIconSize(15)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)
        self.vertex_marker.setPenWidth(3)

        # Snapper
        if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
            self.snapper = QgsMapCanvasSnapper(self.canvas)
        else:
            # TODO Snapping
            self.snapper = QgsMapCanvas.snappingUtils()

        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.previous_map_tool = self.canvas.mapTool()
        self.canvas.setMapTool(self.emit_point)
        self.canvas.xyCoordinates.connect(self.mouse_move)
        self.xyCoordinates_conected = True
        self.emit_point.canvasClicked.connect(partial(self.get_xy))


    def mouse_move(self, p):
        self.snapped_point = None
        self.vertex_marker.hide()
        map_point = self.canvas.getCoordinateTransform().transform(p)
        x = map_point.x()
        y = map_point.y()
        eventPoint = QPoint(x, y)

        # Snapping
        (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable

        # That's the snapped point
        if result:
            # Check feature
            for snapped_point in result:
                self.snapped_point = QgsPoint(snapped_point.snappedVertex)
                self.vertex_marker.setCenter(self.snapped_point)
                self.vertex_marker.show()
        else:
            self.vertex_marker.hide()


    def get_xy(self, point):
        """ Get coordinates of selected point """

        if self.snapped_point:
            self.x = self.snapped_point.x()
            self.y = self.snapped_point.y()
        else:
            self.x = point.x()
            self.y = point.y()
        message = "Geometry has been added!"
        self.controller.show_info(message)
        self.emit_point.canvasClicked.disconnect()
        self.canvas.xyCoordinates.disconnect()
        self.iface.mapCanvas().refreshAllLayers()
        self.vertex_marker.hide()


    def get_values_from_form(self, dialog):
        
        self.enddate = utils_giswater.getCalendarDate(dialog, "enddate")
        self.workcat_id_end = utils_giswater.getWidgetText(dialog, "workcat_id_end")
        self.description = utils_giswater.getWidgetText(dialog, "descript")
        
        
    def tab_feature_changed(self, dialog, table_object, feature_id=None):
        """ Set geom_type and layer depending selected tab
            @table_object = ['doc' | 'element' | 'cat_work']
        """
        
        self.get_values_from_form(dialog)
        if dialog.tab_feature.currentIndex() == 3:
            dialog.btn_snapping.setEnabled(False)
        else:
            dialog.btn_snapping.setEnabled(True)

        tab_position = dialog.tab_feature.currentIndex()
        if tab_position == 0:
            self.geom_type = "arc"   
        elif tab_position == 1:
            self.geom_type = "node"
        elif tab_position == 2:
            self.geom_type = "connec"
        elif tab_position == 3:
            self.geom_type = "element"
        elif tab_position == 4:
            self.geom_type = "gully"

        self.hide_generic_layers()                  
        widget_name = "tbl_" + table_object + "_x_" + str(self.geom_type)
        viewname = "v_edit_" + str(self.geom_type)
        self.widget = utils_giswater.getWidget(dialog, widget_name)
            
        # Adding auto-completion to a QLineEdit
        self.set_completer_feature_id(dialog.feature_id, self.geom_type, viewname)
        
        self.iface.actionPan().trigger()    
        

    def set_completer_object(self, dialog, table_object):
        """ Set autocomplete of widget @table_object + "_id" 
            getting id's from selected @table_object 
        """
                     
        widget = utils_giswater.getWidget(dialog, table_object + "_id")
        if not widget:
            return
        
        # Set SQL
        field_object_id = "id"
        if table_object == "element":
            field_object_id = table_object + "_id"
        sql = ("SELECT DISTINCT(" + field_object_id + ")"
               " FROM " + self.schema_name + "." + table_object)
        row = self.controller.get_rows(sql, commit=self.autocommit)
        for i in range(0, len(row)):
            aux = row[i]
            row[i] = str(aux[0])

        # Set completer and model: add autocomplete in the widget
        self.completer = QCompleter()
        self.completer.setCaseSensitivity(Qt.CaseInsensitive)
        widget.setCompleter(self.completer)
        model = QStringListModel()
        model.setStringList(row)
        self.completer.setModel(model)
        
        
    def set_completer_widget(self, tablename, widget, field_id):
        """ Set autocomplete of widget @table_object + "_id"
            getting id's from selected @table_object
        """
        if not widget:
            return

        # Set SQL
        sql = ("SELECT DISTINCT(" + field_id + ")"
               " FROM " + self.schema_name + "." + tablename +""
               " ORDER BY "+ field_id + "")
        row = self.controller.get_rows(sql)
        for i in range(0, len(row)):
            aux = row[i]
            row[i] = str(aux[0])

        # Set completer and model: add autocomplete in the widget
        self.completer = QCompleter()
        self.completer.setCaseSensitivity(Qt.CaseInsensitive)
        widget.setCompleter(self.completer)
        model = QStringListModel()
        model.setStringList(row)
        self.completer.setModel(model)
                

    def set_completer_feature_id(self, widget, geom_type, viewname):
        """ Set autocomplete of widget 'feature_id' 
            getting id's from selected @viewname 
        """
             
        # Adding auto-completion to a QLineEdit
        self.completer = QCompleter()
        self.completer.setCaseSensitivity(Qt.CaseInsensitive)
        widget.setCompleter(self.completer)
        model = QStringListModel()

        sql = ("SELECT " + geom_type + "_id"
               " FROM " + self.schema_name + "." + viewname)
        row = self.controller.get_rows(sql, commit=self.autocommit)
        if row:
            for i in range(0, len(row)):
                aux = row[i]
                row[i] = str(aux[0])

            model.setStringList(row)
            self.completer.setModel(model)


    def get_expr_filter(self, geom_type):
        """ Set an expression filter with the contents of the list.
            Set a model with selected filter. Attach that model to selected table 
        """

        list_ids = self.list_ids[geom_type]
        field_id = geom_type + "_id"
        if len(list_ids) == 0:
            return None

        # Set expression filter with features in the list        
        expr_filter = field_id + " IN ("
        for i in range(len(list_ids)):
            expr_filter += "'" + str(list_ids[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"

        # Check expression
        (is_valid, expr) = self.check_expression(expr_filter)
        if not is_valid:
            return None

        # Select features of layers applying @expr
        self.select_features_by_ids(geom_type, expr)
        
        return expr_filter


    def reload_table(self, dialog, table_object, geom_type, expr_filter):
        """ Reload @widget with contents of @tablename applying selected @expr_filter """

        if type(table_object) is str:
            widget_name = "tbl_" + table_object + "_x_" + geom_type
            widget = utils_giswater.getWidget(dialog, widget_name)

            if not widget:
                message = "Widget not found"
                self.controller.log_info(message, parameter=widget_name)
                return None

        elif type(table_object) is QTableView:
            widget = table_object
        else:
            message = "Table_object is not a table name or QTableView"
            self.controller.log_info(message)
            return None

        expr = self.set_table_model(dialog, widget, geom_type, expr_filter)
        return expr


    def set_table_model(self, dialog, table_object, geom_type, expr_filter):
        """ Sets a TableModel to @widget_name attached to
            @table_name and filter @expr_filter 
        """

        expr = None
        if expr_filter:
            # Check expression
            (is_valid, expr) = self.check_expression(expr_filter)    #@UnusedVariable
            if not is_valid:
                return expr

        # Set a model with selected filter expression
        table_name = "v_edit_" + geom_type
        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set the model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.select()
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())
            return expr

        # Attach model to selected widget
        if type(table_object) is str:
            widget = utils_giswater.getWidget(dialog, table_object)
            if not widget:
                message = "Widget not found"
                self.controller.log_info(message, parameter=table_object)
                return expr
        elif type(table_object) is QTableView:
            widget = table_object
        else:
            message = "Table_object is not a table name or QTableView"
            self.controller.log_info(message)
            return expr

        if expr_filter:
            widget.setModel(model)
            widget.model().setFilter(expr_filter)
            widget.model().select()
        else:
            widget.setModel(None)

        return expr


    def apply_lazy_init(self, widget):
        """Apply the init function related to the model. It's necessary
        a lazy init because model is changed everytime is loaded."""
        if self.lazy_widget is None:
            return
        if widget != self.lazy_widget:
            return
        self.lazy_init_function(self.lazy_widget)


    def lazy_configuration(self, widget, init_function):
        """set the init_function where all necessary events are set.
        This is necessary to allow a lazy setup of the events because set_table_events
        can create a table with a None model loosing any event connection."""
        # TODO: create a dictionary with key:widged.objectName value:initFuction
        # to allow multiple lazy initialization
        self.lazy_widget = widget
        self.lazy_init_function = init_function


    def select_features_by_ids(self, geom_type, expr):
        """ Select features of layers of group @geom_type applying @expr """

        # Build a list of feature id's and select them
        for layer in self.layers[geom_type]:
            if expr is None:
                layer.removeSelection()  
            else:                
                it = layer.getFeatures(QgsFeatureRequest(expr))
                id_list = [i.id() for i in it]
                if len(id_list) > 0:
                    layer.selectByIds(id_list)   
                else:
                    layer.removeSelection()             
        
             
    def delete_records(self, dialog, table_object, query=False):
        """ Delete selected elements of the table """

        self.disconnect_signal_selection_changed()

        if type(table_object) is str:
            widget_name = "tbl_" + table_object + "_x_" + self.geom_type
            widget = utils_giswater.getWidget(dialog, widget_name)
            if not widget:
                message = "Widget not found"
                self.controller.show_warning(message, parameter=widget_name)
                return
        elif type(table_object) is QTableView:
            widget = table_object
        else:
            message = "Table_object is not a table name or QTableView"
            self.controller.log_info(message)
            return

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_info_box(message)
            return

        if query:
            full_list = widget.model()
            for x in range(0, full_list.rowCount()):
                self.ids.append(widget.model().record(x).value(str(self.geom_type)+"_id"))
        else:
            self.ids = self.list_ids[self.geom_type]

        field_id = self.geom_type + "_id"
        
        del_id = []
        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_feature = widget.model().record(row).value(field_id)
            inf_text += str(id_feature) + ", "
            list_id = list_id + "'" + str(id_feature) + "', "
            del_id.append(id_feature)
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        message = "Are you sure you want to delete these records?"
        title = "Delete records"
        answer = self.controller.ask_question(message, title, inf_text)
        if answer:
            for el in del_id:
                self.ids.remove(el)
        else:
            return

        expr_filter = None
        expr = None
        if len(self.ids) > 0:

            # Set expression filter with features in the list
            expr_filter = "\"" + field_id + "\" IN ("
            for i in range(len(self.ids)):
                expr_filter += "'" + str(self.ids[i]) + "', "
            expr_filter = expr_filter[:-2] + ")"

            # Check expression
            (is_valid, expr) = self.check_expression(expr_filter) #@UnusedVariable
            if not is_valid:
                return

        # Update model of the widget with selected expr_filter
        if query:
            self.delete_feature_at_plan(dialog, self.geom_type, list_id)
            self.reload_qtable(dialog, self.geom_type, self.plan_om)
        else:
            self.reload_table(dialog, table_object, self.geom_type, expr_filter)
            self.apply_lazy_init(table_object)

        # Select features with previous filter
        # Build a list of feature id's and select them
        self.select_features_by_ids(self.geom_type, expr)

        if query:
            self.remove_selection()
        # Update list
        self.list_ids[self.geom_type] = self.ids                        
        
        self.connect_signal_selection_changed(dialog, table_object)


    def manage_close(self, dialog, table_object, cur_active_layer=None):
        """ Close dialog and disconnect snapping """

        if cur_active_layer:
            self.iface.setActiveLayer(cur_active_layer)
        if hasattr(self, 'single_tool_mode'):
            # some tools can work differently if standalone or integrated in
            # another tool
            if self.single_tool_mode:
                self.remove_selection(True)
        else:
            self.remove_selection(True)
        self.reset_model(dialog, table_object, "arc")
        self.reset_model(dialog, table_object, "node")
        self.reset_model(dialog, table_object, "connec")
        self.reset_model(dialog, table_object, "element")
        if self.project_type == 'ud':
            self.reset_model(dialog, table_object, "gully")
        self.close_dialog(dialog)
        self.hide_generic_layers()
        self.disconnect_snapping()   
        self.disconnect_signal_selection_changed()
        # reset previous dialog in not in single_tool_mode
        # if hasattr(self, 'single_tool_mode') and not self.single_tool_mode:
        #     if hasattr(self, 'previous_dialog'):


    def selection_init(self, dialog, table_object, query=False):
        """ Set canvas map tool to an instance of class 'MultipleSelection' """

        multiple_selection = MultipleSelection(self.iface, self.controller, self.layers[self.geom_type], 
                                             parent_manage=self, table_object=table_object, dialog=dialog)
        self.previous_map_tool = self.canvas.mapTool()        
        self.canvas.setMapTool(multiple_selection)              
        self.disconnect_signal_selection_changed()        
        self.connect_signal_selection_changed(dialog, table_object, query)
        cursor = self.get_cursor_multiple_selection()
        self.canvas.setCursor(cursor)


    def selection_changed(self, dialog, table_object, geom_type, query=False):
        """ Slot function for signal 'canvas.selectionChanged' """

        self.disconnect_signal_selection_changed()

        field_id = geom_type + "_id"
        self.ids = []

        # Iterate over all layers of the group
        for layer in self.layers[self.geom_type]:
            if layer.selectedFeatureCount() > 0:
                # Get selected features of the layer
                features = layer.selectedFeatures()
                for feature in features:
                    # Append 'feature_id' into the list
                    selected_id = feature.attribute(field_id)
                    if selected_id not in self.ids:
                        self.ids.append(selected_id)

        if geom_type == 'arc':
            self.list_ids['arc'] = self.ids
        elif geom_type == 'node':
            self.list_ids['node'] = self.ids
        elif geom_type == 'connec':
            self.list_ids['connec'] = self.ids
        elif geom_type == 'gully':
            self.list_ids['gully'] = self.ids
        elif geom_type == 'element':
            self.list_ids['element'] = self.ids

        expr_filter = None
        if len(self.ids) > 0:
            # Set 'expr_filter' with features that are in the list
            expr_filter = "\"" + field_id + "\" IN ("
            for i in range(len(self.ids)):
                expr_filter += "'" + str(self.ids[i]) + "', "
            expr_filter = expr_filter[:-2] + ")"

            # Check expression
            (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
            if not is_valid:
                return                                           
                          
            self.select_features_by_ids(geom_type, expr)
                        
        # Reload contents of table 'tbl_@table_object_x_@geom_type'
        if query:
            self.insert_feature_to_plan(dialog, self.geom_type)
            if self.plan_om == 'plan':
                self.remove_selection()
            self.reload_qtable(dialog, geom_type, self.plan_om)
        else:
            self.reload_table(dialog, table_object, self.geom_type, expr_filter)
            self.apply_lazy_init(table_object)            
        # Remove selection in generic 'v_edit' layers
        if self.plan_om == 'plan':
            self.remove_selection(False)
                    
        self.connect_signal_selection_changed(dialog, table_object)


    def delete_feature_at_plan(self, dialog, geom_type, list_id):
        """ Delete features_id to table plan_@geom_type_x_psector"""

        value = utils_giswater.getWidgetText(dialog, dialog.psector_id)
        sql = ("DELETE FROM " + self.schema_name + "." + self.plan_om + "_psector_x_" + geom_type + ""
               " WHERE " + geom_type + "_id IN (" + list_id + ") AND psector_id = '" + str(value) + "'")
        self.controller.execute_sql(sql)


    def insert_feature(self, dialog, table_object, query=False):
        """ Select feature with entered id. Set a model with selected filter.
            Attach that model to selected table
        """

        self.disconnect_signal_selection_changed()

        # Clear list of ids
        self.ids = []
        field_id = self.geom_type + "_id"
        feature_id = utils_giswater.getWidgetText(dialog, "feature_id")
        if feature_id == 'null':
            message = "You need to enter a feature id"
            self.controller.show_info_box(message)
            return

        # Iterate over all layers of the group
        for layer in self.layers[self.geom_type]:
            if layer.selectedFeatureCount() > 0:
                # Get selected features of the layer
                features = layer.selectedFeatures()
                for feature in features:
                    # Append 'feature_id' into the list
                    selected_id = feature.attribute(field_id)
                    self.ids.append(selected_id)
            if feature_id not in self.ids:
                # If feature id doesn't exist in list -> add
                self.ids.append(str(feature_id))

        # Set expression filter with features in the list
        expr_filter = "\"" + field_id + "\" IN ("
        for i in range(len(self.ids)):
            expr_filter += "'" + str(self.ids[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"

        # Check expression
        (is_valid, expr) = self.check_expression(expr_filter)
        if not is_valid:
            return

        # Select features with previous filter
        # Build a list of feature id's and select them
        for layer in self.layers[self.geom_type]:
            it = layer.getFeatures(QgsFeatureRequest(expr))
            id_list = [i.id() for i in it]
            if len(id_list) > 0:
                layer.selectByIds(id_list)

        # Reload contents of table 'tbl_???_x_@geom_type'
        if query:
            self.insert_feature_to_plan(dialog, self.geom_type)
            self.remove_selection()
        else:
            self.reload_table(dialog, table_object, self.geom_type, expr_filter)
            self.apply_lazy_init(table_object)            

        # Update list
        self.list_ids[self.geom_type] = self.ids

        self.connect_signal_selection_changed(dialog, table_object)


    def insert_feature_to_plan(self, dialog, geom_type):
        """ Insert features_id to table plan_@geom_type_x_psector"""

        value = utils_giswater.getWidgetText(dialog, dialog.psector_id)
        for i in range(len(self.ids)):
            sql = ("SELECT " + geom_type + "_id"
                   " FROM " + self.schema_name + "." + self.plan_om + "_psector_x_" + geom_type + ""
                   " WHERE " + geom_type + "_id = '" + str(self.ids[i]) + "' AND psector_id = '" + str(value) + "'")

            row = self.controller.get_row(sql)
            if not row:
                sql = ("INSERT INTO " + self.schema_name + "." + self.plan_om + "_psector_x_" + geom_type + ""
                       "(" + geom_type + "_id, psector_id) VALUES('" + str(self.ids[i]) + "', '" + str(value) + "')")
                self.controller.execute_sql(sql)
            self.reload_qtable(dialog, geom_type, self.plan_om)


    def reload_qtable(self, dialog, geom_type, plan_om):
        """ Reload QtableView """
        
        value = utils_giswater.getWidgetText(dialog, dialog.psector_id)
        sql = ("SELECT * FROM " + self.schema_name + "." + plan_om + "_psector_x_" + geom_type + ""
               " WHERE psector_id = '" + str(value) + "'")
        qtable = utils_giswater.getWidget(dialog, 'tbl_psector_x_' + geom_type)
        self.fill_table_by_query(qtable, sql)
        self.set_table_columns(dialog, qtable, plan_om + "_psector_x_"+geom_type)
        self.refresh_map_canvas()


    def disconnect_snapping(self):
        """ Select 'Pan' as current map tool and disconnect snapping """

        try:
            self.iface.actionPan().trigger()
            self.canvas.xyCoordinates.disconnect()
            if self.emit_point:       
                self.emit_point.canvasClicked.disconnect()
        except:
            pass


    def fill_table_object(self, widget, table_name, expr_filter=None):
        """ Set a model with selected filter. Attach that model to selected table """

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.sort(0, 1)
        if expr_filter:
            model.setFilter(expr_filter)            
        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

        # Attach model to table view
        widget.setModel(model)


    def filter_by_id(self, dialog, widget_table, widget_txt, table_object, field_object_id='id'):

        field_object_id = "id"
        if table_object == "element":
            field_object_id = table_object + "_id"
        object_id = utils_giswater.getWidgetText(dialog, widget_txt)
        if object_id != 'null':
            expr = field_object_id + "::text ILIKE '%" + str(object_id) + "%'"
            self.controller.log_info(str(expr))
            # Refresh model with selected filter
            widget_table.model().setFilter(expr)
            widget_table.model().select()
        else:
            self.fill_table_object(widget_table, self.schema_name + "." + table_object)


    def delete_selected_object(self, widget, table_object):
        """ Delete selected objects of the table (by object_id) """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        inf_text = ""
        list_id = ""
        field_object_id = "id"

        if table_object == "element":
            field_object_id = table_object + "_id"
        elif "v_ui_om_visitman_x_" in table_object:
            field_object_id = "visit_id"

        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = widget.model().record(row).value(str(field_object_id))
            inf_text += str(id_) + ", "
            list_id = list_id + "'" + str(id_) + "', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        message = "Are you sure you want to delete these records?"
        title = "Delete records"
        answer = self.controller.ask_question(message, title, inf_text)
        if answer:
            sql = ("DELETE FROM " + self.schema_name + "." + table_object + ""
                   " WHERE " + field_object_id + " IN (" + list_id + ")")
            self.controller.execute_sql(sql, commit=self.autocommit)
            widget.model().select()

    
    def open_selected_object(self, dialog, widget, table_object):
        """ Open object form with selected record of the table """

        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        row = selected_list[0].row()

        # Get object_id from selected row
        field_object_id = "id"
        widget_id = table_object + "_id"
        if table_object == "element":
            field_object_id = table_object + "_id"
        if table_object == "om_visit":
            widget_id = "visit_id"
        elif "v_ui_om_visitman_x_" in table_object:
            field_object_id = "visit_id"
        selected_object_id = widget.model().record(row).value(field_object_id)

        # Close this dialog and open selected object
        dialog.close()

        # set previous dialog
        # if hasattr(self, 'previous_dialog'):

        if table_object == "doc":
            self.manage_document()
            utils_giswater.setWidgetText(self.dlg_add_doc, widget_id, selected_object_id)
        elif table_object == "element":
            self.manage_element(new_element_id=False)
            utils_giswater.setWidgetText(self.dlg_add_element, widget_id, selected_object_id)
        elif table_object == "om_visit":
            self.manage_visit(visit_id=selected_object_id)
        elif "v_ui_om_visitman_x_" in table_object:
            self.manage_visit(visit_id=selected_object_id)


    def set_selectionbehavior(self, dialog):
        
        # Get objects of type: QTableView
        widget_list = dialog.findChildren(QTableView)
        for widget in widget_list:
            widget.setSelectionBehavior(QAbstractItemView.SelectRows) 
        
        
    def hide_generic_layers(self, visible=False):       
        """ Hide generic layers """
        
        layer = self.controller.get_layer_by_tablename("v_edit_arc")
        if layer:
            self.iface.legendInterface().setLayerVisible(layer, visible)
        layer = self.controller.get_layer_by_tablename("v_edit_node")
        if layer:
            self.iface.legendInterface().setLayerVisible(layer, visible)
        layer = self.controller.get_layer_by_tablename("v_edit_connec")
        if layer:
            self.iface.legendInterface().setLayerVisible(layer, visible)
        layer = self.controller.get_layer_by_tablename("v_edit_element")
        if layer:
            self.iface.legendInterface().setLayerVisible(layer, visible)
            
        if self.project_type == 'ud':
            layer = self.controller.get_layer_by_tablename("v_edit_gully")
            if layer:
                self.iface.legendInterface().setLayerVisible(layer, visible)            
        
    
    def connect_signal_selection_changed(self, dialog, table_object, query=False):
        """ Connect signal selectionChanged """
        
        try:
            self.canvas.selectionChanged.connect(partial(self.selection_changed, dialog,  table_object, self.geom_type, query))
        except Exception:    
            pass
    
    
    def disconnect_signal_selection_changed(self):
        """ Disconnect signal selectionChanged """
        
        try:
            self.canvas.selectionChanged.disconnect()  
        except Exception:   
            pass
        

    def fill_widget_with_fields(self, dialog, data_object, field_names):
        """Fill the Widget with value get from data_object limited to 
        the list of field_names."""
        
        for field_name in field_names:
            value = getattr(data_object, field_name)
            if not hasattr(dialog, field_name):
                continue

            widget = getattr(dialog, field_name)
            if type(widget) in [QDateEdit, QDateTimeEdit]:
                widget.setDateTime(value if value else QDate.currentDate() )
            if type(widget) in [QLineEdit, QTextEdit]:
                if value:
                    widget.setText(value)
                else:
                    widget.clear()
            if type(widget) in [QComboBox]:
                if not value:
                    widget.setCurrentIndex(0)
                    continue
                # look the value in item text
                index = widget.findText(str(value))
                if index >= 0:
                    widget.setCurrentIndex(index)
                    continue
                # look the value in itemData
                index = widget.findData(value)
                if index >= 0:
                    widget.setCurrentIndex(index)
                    continue


    def set_model_to_table(self, widget, table_name, expr_filter):
        """ Set a model with selected filter.
        Attach that model to selected table """

        # Set model
        model = QSqlTableModel();
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.setFilter(expr_filter)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

        # Attach model to table view
        if widget:
            widget.setModel(model)
        else:
            self.controller.log_info("set_model_to_table: widget not found")
            
