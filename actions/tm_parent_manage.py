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

from qgis.PyQt.Qt import QDate
from qgis.PyQt.QtCore import Qt, QStringListModel
from qgis.PyQt.QtWidgets import QCompleter, QTableView, QDateEdit, QLineEdit, QTextEdit, QDateTimeEdit, QComboBox
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.core import QgsFeatureRequest
from qgis.gui import QgsMapToolEmitPoint

from functools import partial

from .. import widget_manager
from .tm_parent import TmParentAction
from .tm_multiple_selection import TmMultipleSelection


class TmParentManage(TmParentAction, object):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to keep common functions of classes
        'ManageDocument', 'ManageElement' and 'ManageVisit' of toolbar 'edit' """

        super(TmParentManage, self).__init__(iface, settings, controller, plugin_dir)
        self.x = ""
        self.y = ""
        self.canvas = self.iface.mapCanvas()
        self.plan_om = None
        self.previous_map_tool = None
        self.autocommit = True
        self.lazy_widget = None
        self.workcat_id_end = None


    def reset_lists(self):
        """ Reset list of selected records """

        self.ids = []
        self.list_ids = {}
        self.list_ids['node'] = []


    def reset_layers(self):
        """ Reset list of layers """

        self.layers = {}
        self.layers['node'] = []
        self.visible_layers = []


    def remove_selection(self):
        """ Remove all previous selections """

        try:
            for layer in self.layers['node']:
                if layer in self.visible_layers:
                    self.controller.set_layer_visible(layer, False)
            for layer in self.layers['node']:
                if layer in self.visible_layers:
                    self.controller.set_layer_visible(layer, True)
                    layer.removeSelection()
        except:
            pass

        self.canvas.refresh()
        self.canvas.setMapTool(self.previous_map_tool)


    def add_point(self):
        """ Create the appropriate map tool and connect to the corresponding signal """

        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.previous_map_tool = self.canvas.mapTool()
        self.canvas.setMapTool(self.emit_point)
        self.emit_point.canvasClicked.connect(partial(self.get_xy))


    def get_xy(self, point):
        """ Get coordinates of selected point """

        self.x = point.x()
        self.y = point.y()
        message = "Geometry has been added!"
        self.controller.show_info(message)
        self.emit_point.canvasClicked.disconnect()


    def set_completer_feature_id(self, widget, geom_type, viewname):
        """ Set autocomplete of widget 'feature_id'. Getting id's from selected @viewname """

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


    def set_table_model(self, qtable, geom_type, expr_filter):
        """ Sets a TableModel to @widget_name attached to @table_name and filter @expr_filter """

        expr = None
        if expr_filter:
            # Check expression
            (is_valid, expr) = self.check_expression(expr_filter)  # @UnusedVariable
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
        if type(qtable) is QTableView:
            widget = qtable
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
        """ Apply the init function related to the model. It's necessary
        a lazy init because model is changed everytime is loaded """

        if self.lazy_widget is None:
            return
        if widget != self.lazy_widget:
            return
        self.lazy_init_function(self.lazy_widget)
        

    def lazy_configuration(self, widget, init_function):
        """ set the init_function where all necessary events are set.
        This is necessary to allow a lazy setup of the events because set_table_events
        can create a table with a None model loosing any event connection """

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


    def delete_records(self, dialog, table_object):
        """ Delete selected elements of the table """

        self.disconnect_signal_selection_changed()

        if type(table_object) is str:
            widget_name = "tbl_" + table_object + "_x_" + self.geom_type
            widget = widget_manager.getWidget(dialog, widget_name)
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

        self.ids = self.list_ids[self.geom_type]
        field_id = self.geom_type + "_id"

        del_id = []
        inf_text = ""

        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_feature = widget.model().record(row).value(field_id)
            inf_text += str(id_feature) + ", "

            del_id.append(id_feature)
        inf_text = inf_text[:-2]

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
            (is_valid, expr) = self.check_expression(expr_filter)  # @UnusedVariable
            if not is_valid:
                return

        # Update model of the widget with selected expr_filter
        self.reload_table(table_object, self.geom_type, expr_filter)
        self.apply_lazy_init(table_object)

        # Select features with previous filter
        # Build a list of feature id's and select them
        self.select_features_by_ids(self.geom_type, expr)

        # Update list
        self.list_ids[self.geom_type] = self.ids

        self.connect_signal_selection_changed(table_object)


    def selection_init(self, table_object):
        """ Set canvas map tool to an instance of class 'MultipleSelection' """

        current_visible_layers = self.get_visible_layers()
        for layer in current_visible_layers:
            if layer not in self.visible_layers:
                self.visible_layers.append(layer)
        self.controller.log_info(str(self.visible_layers))
        multiple_selection = TmMultipleSelection(self.iface, self.controller, self.layers[self.geom_type],
                                                 parent_manage=self, table_object=table_object)
        self.previous_map_tool = self.canvas.mapTool()
        self.canvas.setMapTool(multiple_selection)
        self.disconnect_signal_selection_changed()
        self.connect_signal_selection_changed(table_object)
        cursor = self.get_cursor_multiple_selection()
        self.canvas.setCursor(cursor)


    def selection_changed(self, qtable, geom_type):
        """ Slot function for signal 'canvas.selectionChanged' """

        self.disconnect_signal_selection_changed()

        field_id = geom_type + "_id"
        self.ids = []

        # Iterate over all layers of the group
        for layer in self.layers[self.geom_type]:
            if layer.selectedFeatureCount() > 0 and self.controller.is_layer_visible(layer):
                # Get selected features of the layer
                features = layer.selectedFeatures()
                for feature in features:
                    # Append 'feature_id' into the list
                    selected_id = feature.attribute(field_id)
                    if selected_id not in self.ids:
                        self.ids.append(selected_id)

        if geom_type == 'node':
            self.list_ids['node'] = self.ids

        expr_filter = None
        if len(self.ids) > 0:
            # Set 'expr_filter' with features that are in the list
            expr_filter = "\"" + field_id + "\" IN ("
            for i in range(len(self.ids)):
                expr_filter += "'" + str(self.ids[i]) + "', "
            expr_filter = expr_filter[:-2] + ")"

            # Check expression
            (is_valid, expr) = self.check_expression(expr_filter)  # @UnusedVariable
            if not is_valid:
                return

            self.select_features_by_ids(geom_type, expr)

        # Reload contents of table 'tbl_@table_object_x_@geom_type'
        self.reload_table(qtable, self.geom_type, expr_filter)
        self.apply_lazy_init(qtable)
        # Remove selection in generic 'v_edit' layers
        #self.remove_selection(False)

        self.connect_signal_selection_changed(qtable)


    def insert_feature(self, widget, table_object):
        """ Select feature with entered id. Set a model with selected filter.
        Attach that model to selected table
        """

        self.disconnect_signal_selection_changed()

        # Clear list of ids
        self.ids = []
        field_id = self.geom_type + "_id"

        feature_id = widget.text()
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
        self.reload_table(table_object, self.geom_type, expr_filter)
        self.apply_lazy_init(table_object)

        # Update list
        self.list_ids[self.geom_type] = self.ids

        self.connect_signal_selection_changed(table_object)


    def disconnect_snapping(self):
        """ Select 'Pan' as current map tool and disconnect snapping """

        try:
            self.iface.actionPan().trigger()
            self.canvas.xyCoordinates.disconnect()
            if self.emit_point:
                self.emit_point.canvasClicked.disconnect()
        except:
            pass


    def connect_signal_selection_changed(self, table_object):
        """ Connect signal selectionChanged """

        try:
            self.canvas.selectionChanged.connect(partial(self.selection_changed, table_object, self.geom_type))
        except Exception:
            pass


    def disconnect_signal_selection_changed(self):
        """ Disconnect signal selectionChanged """

        try:
            self.canvas.selectionChanged.disconnect()
        except Exception:
            pass


    def fill_widget_with_fields(self, dialog, data_object, field_names):
        """ Fill the Widget with value get from data_object limited to the list of field_names. """

        for field_name in field_names:
            value = getattr(data_object, field_name)
            if not hasattr(dialog, field_name):
                continue

            widget = getattr(dialog, field_name)
            if type(widget) in [QDateEdit, QDateTimeEdit]:
                widget.setDateTime(value if value else QDate.currentDate())
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


    def reload_table(self, qtable, geom_type, expr_filter):
        """ Reload @widget with contents of @tablename applying selected @expr_filter """

        if type(qtable) is QTableView:
            widget = qtable
        else:
            message = "Table_object is not a table name or QTableView"
            self.controller.log_info(message)
            return None

        expr = self.set_table_model(widget, geom_type, expr_filter)
        return expr


    def get_visible_layers(self, return_as_list=True):
        """ Return list or string as {...} with all visible layer in TOC """

        visible_layer = []
        layers = self.controller.get_layers()
        if return_as_list:
            for layer in layers:
                if self.controller.is_layer_visible(layer):
                    visible_layer.append(layer)
            return visible_layer

        for layer in layers:
            if self.controller.is_layer_visible(layer):
                visible_layer += '"' + str(layer.name()) + '", '
        visible_layer = visible_layer[:-2] + "}"

        return visible_layer

