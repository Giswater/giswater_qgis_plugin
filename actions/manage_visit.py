# -*- coding: utf-8 -*-
"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

from PyQt4.QtCore import (
    Qt,
    QDate,
    pyqtSignal,
    QObject)
from PyQt4.QtGui import (
    QCompleter,
    QLineEdit,
    QTableView,
    QStringListModel,
    QPushButton,
    QComboBox,
    QTabWidget,
    QDialogButtonBox)
from PyQt4.QtSql import QSqlTableModel

import os
import sys
import subprocess
from functools import partial

import utils_giswater
from dao.om_visit_event import OmVisitEvent
from dao.om_visit import OmVisit
from dao.om_visit_x_arc import OmVisitXArc
from dao.om_visit_x_connec import OmVisitXConnec
from dao.om_visit_x_node import OmVisitXNode
from dao.om_visit_x_gully import OmVisitXGully
from dao.om_visit_parameter import OmVisitParameter
from ui_manager import AddVisit
from ui_manager import EventStandard
from ui_manager import EventUDarcStandard
from ui_manager import EventUDarcRehabit
from ui_manager import VisitManagement
from actions.parent_manage import ParentManage
from actions.manage_document import ManageDocument


class ManageVisit(ParentManage, QObject):

    # event emitted when a new Visit is added when GUI is closed/accepted
    visit_added = pyqtSignal(int)

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'Add visit' of toolbar 'edit' """
        QObject.__init__(self)
        ParentManage.__init__(self, iface, settings, controller, plugin_dir)


    def manage_visit(self, visit_id=None, geom_type=None, feature_id=None, single_tool=True, expl_id=None):
        """ Button 64. Add visit.
        if visit_id => load record related to the visit_id
        if geom_type => lock geom_type in relations tab
        if feature_id => load related feature basing on geom_type in relation
        if single_tool notify that the tool is used called from another dialog."""

        # parameter to set if the dialog is working as single tool or integrated in another tool
        self.single_tool_mode = single_tool

        # turnoff autocommit of this and base class. Commit will be done at dialog button box level management
        self.autocommit = True

        # bool to distinguish if we entered to edit an exisiting Visit or creating a new one
        self.it_is_new_visit = (not visit_id)

        # set vars to manage if GUI have to lock the relation
        self.locked_geom_type = geom_type
        self.locked_feature_id = feature_id

        # Create the dialog and signals and related ORM Visit class
        self.current_visit = OmVisit(self.controller)
        self.dlg = AddVisit()
        self.load_settings(self.dlg)

        # Get expl_id from previus dialog
        self.expl_id = expl_id

        # save previous dialog and set new one. Previous dialog will be set exiting the current one
        self.previous_dialog = utils_giswater.dialog()
        utils_giswater.setDialog(self.dlg)
        
        # Get layers of every geom_type
        self.reset_lists()
        self.reset_layers()
        self.layers['arc'] = self.controller.get_group_layers('arc')
        self.layers['node'] = self.controller.get_group_layers('node')
        self.layers['connec'] = self.controller.get_group_layers('connec')
        self.layers['element'] = self.controller.get_group_layers('element')
        # Remove 'gully' for 'WS'
        if self.controller.get_project_type() != 'ws':
            self.layers['gully'] = self.controller.get_group_layers('gully')
          
        # Reset geometry  
        self.x = None
        self.y = None

        # Set icons
        self.set_icon(self.dlg.btn_feature_insert, "111")
        self.set_icon(self.dlg.btn_feature_delete, "112")
        self.set_icon(self.dlg.btn_feature_snapping, "137")
        self.set_icon(self.dlg.btn_doc_insert, "111")
        self.set_icon(self.dlg.btn_doc_delete, "112")
        self.set_icon(self.dlg.btn_doc_new, "134")
        self.set_icon(self.dlg.btn_open_doc, "170")
        self.set_icon(self.dlg.btn_add_geom, "133")    
        
        if feature_id is None:
            self.dlg.btn_add_geom.setVisible(False)

        # tab events
        self.tabs = self.dlg.findChild(QTabWidget, 'tab_widget')
        self.button_box = self.dlg.findChild(QDialogButtonBox, 'button_box')
        self.button_box.button(QDialogButtonBox.Ok).setEnabled(False)

        # Tab 'Data'/'Visit'
        self.visit_id = self.dlg.findChild(QLineEdit, "visit_id")
        self.user_name = self.dlg.findChild(QLineEdit, "user_name")
        self.ext_code = self.dlg.findChild(QLineEdit, "ext_code")
        self.visitcat_id = self.dlg.findChild(QComboBox, "visitcat_id")

        # Tab 'Relations'
        self.feature_type = self.dlg.findChild(QComboBox, "feature_type")
        self.tbl_relation = self.dlg.findChild(QTableView, "tbl_relation")

        # tab 'Event'
        self.tbl_event = self.dlg.findChild(QTableView, "tbl_event")
        self.parameter_type_id = self.dlg.findChild(QComboBox, "parameter_type_id")
        self.parameter_id = self.dlg.findChild(QComboBox, "parameter_id")

        # tab 'Document'
        self.doc_id = self.dlg.findChild(QLineEdit, "doc_id")
        self.btn_doc_insert = self.dlg.findChild(QPushButton, "btn_doc_insert")
        self.btn_doc_delete = self.dlg.findChild(QPushButton, "btn_doc_delete")
        self.btn_doc_new = self.dlg.findChild(QPushButton, "btn_doc_new")
        self.btn_open_doc = self.dlg.findChild(QPushButton, "btn_open_doc")
        self.tbl_document = self.dlg.findChild(QTableView, "tbl_document")

        # Set current date and time
        current_date = QDate.currentDate()
        self.dlg.startdate.setDate(current_date)
        self.dlg.enddate.setDate(current_date)

        # set User name get from controller login
        if self.controller.user and self.user_name:
            self.user_name.setText(str(self.controller.user))

        # set the start tab to be shown (e.g. VisitTab)
        self.current_tab_index = self.tab_index('VisitTab')
        self.tabs.setCurrentIndex(self.current_tab_index)

        # Set signals
        self.dlg.rejected.connect(self.manage_rejected)
        self.dlg.rejected.connect(partial(self.close_dialog, self.dlg))
        self.dlg.accepted.connect(self.manage_accepted)
        self.dlg.btn_event_insert.pressed.connect(self.event_insert)
        self.dlg.btn_event_delete.pressed.connect(self.event_delete)
        self.dlg.btn_event_update.pressed.connect(self.event_update)
        self.dlg.btn_feature_insert.pressed.connect(partial(self.insert_feature, self.tbl_relation))
        self.dlg.btn_feature_delete.pressed.connect(partial(self.delete_records, self.tbl_relation))
        self.dlg.btn_feature_snapping.pressed.connect(partial(self.selection_init, self.tbl_relation))
        self.tabs.currentChanged.connect(partial(self.manage_tab_changed))
        self.visit_id.textChanged.connect(self.manage_visit_id_change)
        self.dlg.btn_doc_insert.pressed.connect(self.document_insert)
        self.dlg.btn_doc_delete.pressed.connect(self.document_delete)
        self.dlg.btn_doc_new.pressed.connect(self.manage_document)
        self.dlg.btn_open_doc.pressed.connect(self.document_open)
        self.tbl_document.doubleClicked.connect(partial(self.document_open))
        self.dlg.btn_add_geom.pressed.connect(self.add_point)        

        # Fill combo boxes of the form and related events
        self.feature_type.currentIndexChanged.connect(partial(self.event_feature_type_selected))
        self.parameter_type_id.currentIndexChanged.connect(partial(self.set_parameter_id_combo))
        self.fill_combos()

        # Set autocompleters of the form
        self.set_completers()

        # Show id of visit. If not set, infer a new value
        if not visit_id:
            visit_id = self.current_visit.max_pk(commit=self.autocommit) + 1
        self.visit_id.setText(str(visit_id))

        # manage relation locking
        if self.locked_geom_type:
            self.set_locked_relation()

        # Open the dialog
        self.open_dialog(self.dlg, dlg_name="add_visit")


    def set_locked_relation(self):
        """Set geom_type and listed feature_id in tbl_relation to lock it => disable related tab."""
        
        # disable tab
        index = self.tab_index('RelationsTab')
        self.tabs.setTabEnabled(index, False)

        # set geometry_type
        feature_type_index = self.feature_type.findText(self.locked_geom_type.upper())
        if feature_type_index < 0:
            return

        # set default combo box value = trigger model and selection of related features
        if self.feature_type.currentIndex() != feature_type_index:
            self.feature_type.setCurrentIndex(feature_type_index)
        else:
            self.feature_type.currentIndexChanged.emit(feature_type_index)

        # load feature if in tbl_relation
        # select list of related features
        # Set 'expr_filter' with features that are in the list
        expr_filter = '"{}_id" IN ({})'.format(self.geom_type, self.locked_feature_id)

        # Check expression
        (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
        if not is_valid:
            return

        # do selection allowing the tbl_relation to be linked to canvas selectionChanged
        self.disconnect_signal_selection_changed()
        self.connect_signal_selection_changed(self.tbl_relation)
        self.select_features_by_ids(self.geom_type, expr)
        self.disconnect_signal_selection_changed()


    def manage_accepted(self):
        """Do all action when closed the dialog with Ok.
        e.g. all necessary commits and cleanings.
        A) Trigger SELECT gw_fct_om_visit_multiplier (visit_id, feature_type)
        for multiple visits management."""
        
        # set the previous dialog
        utils_giswater.setDialog(self.previous_dialog)

        # A) Trigger SELECT gw_fct_om_visit_multiplier (visit_id, feature_type)
        # for multiple visits management
        # sql = ("SELECT gw_fct_om_visit_multiplier ({}, {}})".format(self.currentVisit.id, self.feature_type.currentText().upper()))
        # status = self.controller.execute_sql(sql)
        # if not status:
        #     message = "Error triggering"
        #     self.controller.show_warning(message)
        #     return

        # notify that a new visit has been added
        self.visit_added.emit(self.current_visit.id)

        # Remove all previous selections
        self.remove_selection()
        
        # Update geometry field (if user have selected a point)
        if self.x:
            self.update_geom()

        self.refresh_map_canvas()


    def update_geom(self):
        """ Update geometry field """

        srid = self.controller.plugin_settings_value('srid')
        sql = ("UPDATE " + str(self.schema_name) + ".om_visit"
               " SET the_geom = ST_SetSRID(ST_MakePoint(" + str(self.x) + "," + str(self.y) + "), " + str(srid) + ")"
               " WHERE id = " + str(self.current_visit.id))
        self.controller.execute_sql(sql, log_sql=True)


    def manage_rejected(self):
        """Do all action when closed the dialog with Cancel or X.
        e.g. all necessary rollbacks and cleanings."""
        
        # set the previous dialog
        utils_giswater.setDialog(self.previous_dialog)

        # removed current working visit. This should cascade removing of all related records
        if hasattr(self, 'it_is_new_visit') and self.it_is_new_visit:
            self.current_visit.delete()
            
        # Remove all previous selections            
        self.remove_selection()            


    def tab_index(self, tab_name):
        """Get the index of a tab basing on objectName."""
        
        for idx in range(self.tabs.count()):
            if self.tabs.widget(idx).objectName() == tab_name:
                return idx
        return -1


    def manage_visit_id_change(self, text):
        """manage action when the visit id is changed.
        A) Update current Visit record
        B) Fill the GUI values of the current visit
        C) load all related events in the relative table
        D) load all related documents in the relative table."""

        # A) Update current Visit record
        self.current_visit.id = int(text)
        exist = self.current_visit.fetch()
        if exist:
            # B) Fill the GUI values of the current visit
            self.fill_widget_with_fields(self.dlg, self.current_visit, self.current_visit.field_names())

        # C) load all related events in the relative table
        self.filter = "visit_id = '" + str(text) + "'"
        table_name = self.schema_name + ".om_visit_event"
        self.fill_table_visit(self.tbl_event, table_name, self.filter)
        self.set_configuration(self.tbl_event, table_name)
        self.manage_events_changed()

        # D) load all related documents in the relative table
        table_name = self.schema_name + ".v_ui_doc_x_visit"
        self.fill_table_visit(self.tbl_document, self.schema_name + ".v_ui_doc_x_visit", self.filter)
        self.set_configuration(self.tbl_document, table_name)

        # E) load all related Relations in the relative table
        self.set_feature_type_by_visit_id()


    def set_feature_type_by_visit_id(self):
        """Set the feature_type in Relation tab basing on visit_id.
        The steps to follow are:
        1) check geometry type looking what table contain records related with visit_id
        2) set gemetry type."""
        
        feature_type = None
        feature_type_index = None
        for index in range(self.feature_type.count()):
            # feture_type combobox is filled before the visit_id is changed
            # it will contain all the geometry type allows basing on project type
            geometry_type = self.feature_type.itemText(index).lower()
            table_name = 'om_visit_x_' + geometry_type
            sql = ("SELECT id FROM {0}.{1} WHERE visit_id = '{2}'".format(
                self.schema_name, table_name, self.current_visit.id))
            rows = self.controller.get_rows(sql, commit=self.autocommit)
            if not rows or not rows[0]:
                continue

            feature_type = geometry_type
            feature_type_index = index
            break

        # if no related records found do nothing
        if not feature_type:
            return

        # set default combo box value = trigger model and selection
        # of related features
        if self.feature_type.currentIndex() != feature_type_index:
            self.feature_type.setCurrentIndex(feature_type_index)
        else:
            self.feature_type.currentIndexChanged.emit(feature_type_index)


    def manage_leave_visit_tab(self):
        """ manage all the action when leaving the VisitTab
        A) Manage sync between GUI values and Visit record in DB."""

        # A) fill Visit basing on GUI values
        self.current_visit.id = int(self.visit_id.text())
        self.current_visit.startdate = self.dlg.startdate.date().toString(Qt.ISODate)
        self.current_visit.enddate = self.dlg.enddate.date().toString(Qt.ISODate)
        self.current_visit.user_name = self.user_name.text()
        self.current_visit.ext_code = self.ext_code.text()
        self.current_visit.visitcat_id = utils_giswater.get_item_data(self.dlg.visitcat_id, 0)
        self.current_visit.descript = self.dlg.descript.text()
        if self.expl_id:
            self.current_visit.expl_id = self.expl_id
        # update or insert but without closing the transaction: autocommit=False
        self.current_visit.upsert(commit=self.autocommit)


    def update_relations(self):
        """Save current selected features in tbl_relations. Steps are:
        A) remove all old relations related with current visit_id.
        B) save new relations get from that listed in tbl_relations."""
        
        # A) remove all old relations related with current visit_id.
        db_record = None
        for index in range(self.feature_type.count()):
            # feture_type combobox contain all the geometry type 
            # allows basing on project type
            geometry_type = self.feature_type.itemText(index).lower()

            # TODO: the next "if" code can be substituded with something like:
            # exec("db_record = OmVisitX{}{}(self.controller)".format(geometry_type[0].upper(), geometry_type[1:]))"
            if geometry_type == 'arc':
                db_record = OmVisitXArc(self.controller)
            if geometry_type == 'node':
                db_record = OmVisitXNode(self.controller)
            if geometry_type == 'connec':
                db_record = OmVisitXConnec(self.controller)
            if geometry_type == 'gully':
                db_record = OmVisitXGully(self.controller)

            # remove all actual saved records related with visit_id
            where_clause = "visit_id = '{}'".format(self.visit_id.text())
            db_record.delete(where_clause=where_clause, commit=self.autocommit)

        # do nothing if model is None or no element is present
        if not self.tbl_relation.model() or not self.tbl_relation.model().rowCount():
            return

        # set the current db_record tyope to do insert of new records
        # all the new records belong to the same geom_type
        # TODO: the next "if" code can be substituded with something like:
        # exec("db_record = OmVisitX{}{}(self.controller)".format(geometry_type[0].upper(), geometry_type[1:]))"
        if self.geom_type == 'arc':
            db_record = OmVisitXArc(self.controller)
        if self.geom_type == 'node':
            db_record = OmVisitXNode(self.controller)
        if self.geom_type == 'connec':
            db_record = OmVisitXConnec(self.controller)
        if self.geom_type == 'gully':
            db_record = OmVisitXGully(self.controller)

        # for each showed element of a specific geom_type create an db entry
        column_name = self.geom_type + "_id"
        for row in range(self.tbl_relation.model().rowCount()):
            # get modelIndex to get data
            index = self.tbl_relation.model().index(row, 0)

            # set common fields
            db_record.id = db_record.max_pk() + 1
            db_record.visit_id = int(self.visit_id.text())

            # set value for column <geom_type>_id
            setattr(db_record, column_name, index.data())

            # than save the showed records
            db_record.upsert(commit=self.autocommit)


    def manage_tab_changed(self, index):
        """Do actions when tab is exit and entered.
        Actions depend on tab index"""
        
        # manage leaving tab
        # tab Visit
        if self.current_tab_index == self.tab_index('VisitTab'):
            self.manage_leave_visit_tab()
            # need to create the relation record that is done only
            # changing tab
            if self.locked_geom_type:
                self.update_relations()

        # tab Relation
        if self.current_tab_index == self.tab_index('RelationsTab'):
            self.update_relations()

        # manage arriving tab

        # tab Visit
        self.current_tab_index = index
        if index == self.tab_index('VisitTab'):
            pass
        # tab Relation
        if index == self.tab_index('RelationsTab'):
            pass
        # tab Event
        if index == self.tab_index('EventTab'):
            self.entered_event_tab()
        # tab Document
        if index == self.tab_index('DocumentTab'):
            pass


    def entered_event_tab(self):
        """Manage actions when the Event tab is entered."""
        self.set_parameter_id_combo()


    def set_parameter_id_combo(self):
        """set parameter_id combo basing on current selections."""
        sql = ("SELECT id"
               " FROM " + self.schema_name + ".om_visit_parameter"
               " WHERE UPPER (parameter_type) = '" + self.parameter_type_id.currentText().upper() + "'"
               " AND UPPER (feature_type) = '" + self.feature_type.currentText().upper() + "'"
               " ORDER BY id")
        rows = self.controller.get_rows(sql, commit=self.autocommit)
        utils_giswater.fillComboBox("parameter_id", rows, allow_nulls=False)


    def config_relation_table(self, table):
        """Set all actions related to the table, model and selectionModel.
        It's necessary a centralised call because base class can create a None model
        where all callbacks are lost ance can't be registered."""
        
        # Activate Event and Document tabs if at least an element is available
        # if self.tbl_relation.model():
        #     has_elements = self.tbl_relation.model().rowCount()
        # else:
        #     has_elements = False
        # for idx in [self.tab_index('EventTab'), self.tab_index('DocumentTab')]:
        #     self.tabs.setTabEnabled(idx, has_elements)

        # configure model visibility
        table_name = "v_edit_" + self.geom_type
        self.set_configuration(self.tbl_relation, table_name)


    def event_feature_type_selected(self):
        """Manage selection change in feature_type combo box.
        THis means that have to set completer for feature_id QTextLine and
        setup model for features to select table."""
        
        # 1) set the model linked to selecte features
        # 2) check if there are features related to the current visit
        # 3) if so, select them => would appear in the table associated to the model
        self.geom_type = self.feature_type.currentText().lower()
        viewname = "v_edit_" + self.geom_type
        self.set_completer_feature_id(self.geom_type, viewname)

        # set table model and completer
        # set a fake where expression to avoid to set model to None
        fake_filter = '{}_id IN ("-1")'.format(self.geom_type)
        self.set_table_model(self.tbl_relation, self.geom_type, fake_filter)

        # set the callback to setup all events later
        # its not possible to setup listener in this moment beacouse set_table_model without
        # a valid expression parameter return a None model => no events can be triggered
        self.lazy_configuration(self.tbl_relation, self.config_relation_table)

        # check if there are features related to the current visit
        if not self.visit_id.text():
            return

        table_name = 'om_visit_x_' + self.geom_type
        sql = ("SELECT {0}_id FROM {1}.{2} WHERE visit_id = '{3}'".format(
            self.geom_type, self.schema_name, table_name, int(self.visit_id.text())))
        rows = self.controller.get_rows(sql, commit=self.autocommit)
        if not rows or not rows[0]:
            return
        ids = [x[0] for x in rows]

        # select list of related features
        # Set 'expr_filter' with features that are in the list
        expr_filter = '"{}_id" IN ({})'.format(self.geom_type, ','.join(ids))

        # Check expression
        (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
        if not is_valid:
            return

        # do selection allowing the tbl_relation to be linked to canvas selectionChanged
        self.disconnect_signal_selection_changed()
        self.connect_signal_selection_changed(self.tbl_relation)
        self.select_features_by_ids(self.geom_type, expr)
        self.disconnect_signal_selection_changed()


    def edit_visit(self, geom_type=None, feature_id=None):
        """ Button 65: Edit visit """

        # Create the dialog
        self.dlg_man = VisitManagement()
        self.load_settings(self.dlg_man)
        # save previous dialog and set new one.
        # previous dialog will be set exiting the current one
        self.previous_dialog = utils_giswater.dialog()
        utils_giswater.setDialog(self.dlg_man)
        utils_giswater.set_table_selection_behavior(self.dlg_man.tbl_visit)

        if geom_type is None:
            # Set a model with selected filter. Attach that model to selected table
            table_object = "om_visit"
            self.fill_table_object(self.dlg_man.tbl_visit, self.schema_name + "." + table_object)
            self.set_table_columns(self.dlg_man.tbl_visit, table_object)
        else:
            # Set a model with selected filter. Attach that model to selected table
            table_object = "v_ui_om_visit_x_" + str(geom_type)
            expr_filter = geom_type + "_id = '" + feature_id + "'"
            # Refresh model with selected filter            
            self.fill_table_object(self.dlg_man.tbl_visit, self.schema_name + "." + table_object, expr_filter)
            self.set_table_columns(self.dlg_man.tbl_visit, table_object)            

        # manage save and rollback when closing the dialog
        self.dlg_man.rejected.connect(self.manage_rejected)
        self.dlg_man.rejected.connect(partial(self.close_dialog, self.dlg_man))
        self.dlg_man.accepted.connect(partial(self.open_selected_object, self.dlg_man.tbl_visit, table_object))

        # Set dignals
        self.dlg_man.tbl_visit.doubleClicked.connect(
            partial(self.open_selected_object, self.dlg_man.tbl_visit, table_object))
        self.dlg_man.btn_open.pressed.connect(
            partial(self.open_selected_object, self.dlg_man.tbl_visit, table_object))
        self.dlg_man.btn_delete.clicked.connect(
            partial(self.delete_selected_object, self.dlg_man.tbl_visit, table_object))

        # set timeStart and timeEnd as the min/max dave values get from model
        current_date = QDate.currentDate()        
        sql = ("SELECT MIN(startdate), MAX(enddate)"
               " FROM {}.{}".format(self.schema_name, 'om_visit'))
        row = self.controller.get_row(sql, log_info=False, commit=self.autocommit)
        if row:
            if row[0]:
                self.dlg_man.date_event_from.setDate(row[0])
            if row[1]:
                self.dlg_man.date_event_to.setDate(row[1])
            else:
                self.dlg_man.date_event_to.setDate(current_date)

        # set date events
        self.dlg_man.date_event_from.dateChanged.connect(self.set_visit_date_filter)
        self.dlg_man.date_event_to.dateChanged.connect(self.set_visit_date_filter)

        # Open form
        self.open_dialog(self.dlg_man, dlg_name="visit_management")


    def set_visit_date_filter(self):
        """Filter om_visit in self.dlg_man.tbl_visit basing on new date."""
        
        format_low = 'yyyy-MM-dd 00:00:00.000'
        format_high = 'yyyy-MM-dd 23:59:59.999'
        min_date = self.dlg_man.date_event_from.date()
        max_date = self.dlg_man.date_event_to.date()
        interval = "'{}'::timestamp AND '{}'::timestamp".format(
            min_date.toString(format_low), max_date.toString(format_high))
        filter_ = ("(startdate BETWEEN {0}) AND (enddate BETWEEN {0})".format(interval))
        model = self.dlg_man.tbl_visit.model()
        model.setFilter(filter_)
        model.select


    def fill_combos(self):
        """ Fill combo boxes of the form """

        # Visit tab
        # Fill ComboBox visitcat_id
        # save result in self.visitcat_ids to get id depending on selected combo
        sql = ("SELECT id, name"
               " FROM " + self.schema_name + ".om_visit_cat"
               " WHERE active is true"
               " ORDER BY name")
        self.visitcat_ids = self.controller.get_rows(sql, commit=self.autocommit)
        
        if self.visitcat_ids:
            utils_giswater.set_item_data(self.dlg.visitcat_id, self.visitcat_ids, 1)         
            # now get default value to be show in visitcat_id
            sql = ("SELECT value"
                " FROM " + self.schema_name + ".config_param_user"
                " WHERE parameter = 'visitcat_vdefault' AND cur_user = current_user")
            row = self.controller.get_row(sql, commit=self.autocommit)
            if row:
                # if int then look for default row ans set it
                try:
                    utils_giswater.set_combo_itemData(self.dlg.visitcat_id, row[0], 0, 1)
                    for i in range(0, self.dlg.visitcat_id.count()):
                        elem = self.dlg.visitcat_id.itemData(i)
                        if str(row[0]) == str(elem[0]):                         
                            utils_giswater.setWidgetText(self.dlg.visitcat_id, (elem[1]))                    
                except TypeError:
                    pass
                except ValueError:
                    pass

        # Relations tab
        # fill feature_type
        sql = ("SELECT id"
               " FROM " + self.schema_name + ".sys_feature_type"
               " WHERE net_category = 1"
               " ORDER BY id")
        rows = self.controller.get_rows(sql, commit=self.autocommit)
        utils_giswater.fillComboBox("feature_type", rows, allow_nulls=False)

        # Event tab
        # Fill ComboBox parameter_type_id
        sql = ("SELECT id"
               " FROM " + self.schema_name + ".om_visit_parameter_type"
               " ORDER BY id")
        parameter_type_ids = self.controller.get_rows(sql, commit=self.autocommit)
        utils_giswater.fillComboBox("parameter_type_id", parameter_type_ids, allow_nulls=False)

        # now get default value to be show in parameter_type_id
        sql = ("SELECT value"
               " FROM " + self.schema_name + ".config_param_user"
               " WHERE parameter = 'om_param_type_vdefault' AND cur_user = current_user")
        row = self.controller.get_row(sql, commit=self.autocommit)
        if row:
            # if int then look for default row ans set it
            try:
                parameter_type_id = int(row[0])
                combo_value = parameter_type_ids[parameter_type_id]
                combo_index = self.parameter_type_id.findText(combo_value)
                self.parameter_type_id.setCurrentIndex(combo_index)
            except TypeError:
                pass
            except ValueError:
                pass


    def set_completers(self):
        """ Set autocompleters of the form """

        # Adding auto-completion to a QLineEdit - visit_id
        self.completer = QCompleter()
        self.dlg.visit_id.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".om_visit"
        rows = self.controller.get_rows(sql, commit=self.autocommit)
        values = []
        if rows:
            for row in rows:
                values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)

        # Adding auto-completion to a QLineEdit - document_id
        self.completer = QCompleter()
        self.dlg.doc_id.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".v_ui_document"
        rows = self.controller.get_rows(sql, commit=self.autocommit)
        values = []
        if rows:
            for row in rows:
                values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)


    def manage_document(self):
        """Access GUI to manage documents e.g Execute action of button 34 """
        
        manage_document = ManageDocument(
            self.iface, self.settings, self.controller, self.plugin_dir, single_tool=False)
        dlg_docman = manage_document.manage_document()
        dlg_docman.btn_accept.pressed.connect(partial(self.set_completer_object, 'doc'))


    def fill_table_visit(self, widget, table_name, filter_):
        """ Set a model with selected filter. Attach that model to selected table """

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.setFilter(filter_)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

        # Attach model to table view
        widget.setModel(model)
        widget.show()


    def event_insert(self):
        """Add and event basing on form asociated to the selected parameter_id."""
        
        # check a paramet3er_id is selected (can be that no value is available)
        parameter_id = self.parameter_id.currentText()
        if not parameter_id:
            message = "You need to select a valid parameter id"
            self.controller.show_info_box(message)
            return

        # get form asociated
        sql = ("SELECT form_type"
               " FROM " + self.schema_name + ".om_visit_parameter"
               " WHERE id = '" + str(parameter_id) + "'")
        row = self.controller.get_row(sql, commit=False)
        form_type = str(row[0])

        if form_type == 'event_ud_arc_standard':
            self.dlg_event = EventUDarcStandard()
            self.load_settings(self.dlg_event)
            # disable position_x fields because not allowed in multiple view
            self.dlg_event.position_id.setEnabled(False)
            self.dlg_event.position_value.setEnabled(False)
        elif form_type == 'event_ud_arc_rehabit':
            self.dlg_event = EventUDarcRehabit()
            self.load_settings(self.dlg_event)
            # disable position_x fields because not allowed in multiple view
            self.dlg_event.position_id.setEnabled(False)
            self.dlg_event.position_value.setEnabled(False)
        elif form_type == 'event_standard':
            self.dlg_event = EventStandard()
            self.load_settings(self.dlg_event)
        else:
            message = "Unrecognised form type"
            self.controller.show_info_box(message, parameter=form_type)
            return

        # because of multiple view disable add picture and view gallery
        self.dlg_event.btn_add_picture.setEnabled(False)
        self.dlg_event.btn_view_gallery.setEnabled(False)

        # set fixed values
        self.dlg_event.parameter_id.setText(parameter_id)

        utils_giswater.setDialog(self.dlg_event)
        self.dlg_event.setWindowFlags(Qt.WindowStaysOnTopHint)
        ret = self.dlg_event.exec_()
                
        # back to the current dialg
        utils_giswater.setDialog(self.dlg)

        # check return
        if not ret:
            # pressed cancel
            return

        # create an empty Event
        event = OmVisitEvent(self.controller)
        event.id = event.max_pk() + 1
        event.parameter_id = parameter_id
        event.visit_id = int(self.visit_id.text())

        for field_name in event.field_names():
            if not hasattr(self.dlg_event, field_name):
                continue
            value = getattr(self.dlg_event, field_name).text()
            if value:
                setattr(event, field_name, value)

        # save new event
        event.upsert()

        # update Table
        self.tbl_event.model().select()
        self.manage_events_changed()


    def manage_events_changed(self):
        """Action when at a Event model is changed.
        A) if some record is available => enable OK button of VisitDialog"""
        state = (self.tbl_event.model().rowCount() > 0)
        self.button_box.button(QDialogButtonBox.Ok).setEnabled(state)


    def event_update(self):
        """Update selected event."""
        
        if not self.tbl_event.selectionModel().hasSelection():
            message = "Any record selected"
            self.controller.show_info_box(message)
            return

        # Get selected rows
        # TODO: use tbl_event.model().fieldIndex(event.pk()) to be pk name independent
        # 0 is the column of the pk 0 'id'        
        selected_list = self.tbl_event.selectionModel().selectedRows(0)  
        if selected_list == 0:
            message = "Any record selected"
            self.controller.show_info_box(message)
            return

        elif len(selected_list) > 1:
            message = "More then one event selected. Select just one"
            self.controller.show_warning(message)
            return

        # fetch the record
        event = OmVisitEvent(self.controller)
        event.id = selected_list[0].data()
        if not event.fetch(commit=self.autocommit):
            return

        # get parameter_id code to select the widget useful to edit the event
        om_event_parameter = OmVisitParameter(self.controller)
        om_event_parameter.id = event.parameter_id
        if not om_event_parameter.fetch(commit=self.autocommit):
            return

        if om_event_parameter.form_type == 'event_ud_arc_standard':
            self.dlg_event = EventUDarcStandard()
            self.load_settings(self.dlg_event)
            # disable position_x fields because not allowed in multiple view
            self.dlg_event.position_id.setEnabled(False)
            self.dlg_event.position_value.setEnabled(False)

        elif om_event_parameter.form_type == 'event_ud_arc_rehabit':
            self.dlg_event = EventUDarcRehabit()
            self.load_settings(self.dlg_event)
            # disable position_x fields because not allowed in multiple view
            self.dlg_event.position_id.setEnabled(False)
            self.dlg_event.position_value.setEnabled(False)

        elif om_event_parameter.form_type == 'event_standard':
            self.dlg_event = EventStandard()
            self.load_settings(self.dlg_event)

        # because of multiple view disable add picture and view gallery
        self.dlg_event.btn_add_picture.setEnabled(False)
        self.dlg_event.btn_view_gallery.setEnabled(False)

        # fill widget values if the values are present
        for field_name in event.field_names():
            if not hasattr(self.dlg_event, field_name):
                continue
            value = getattr(event, field_name)
            if value:
                getattr(self.dlg_event, field_name).setText(str(value))

        utils_giswater.setDialog(self.dlg_event)
        self.dlg_event.setWindowFlags(Qt.WindowStaysOnTopHint)
        if self.dlg_event.exec_():
            # set record values basing on widget
            for field_name in event.field_names():
                if not hasattr(self.dlg_event, field_name):
                    continue
                value = getattr(self.dlg_event, field_name).text()
                if value:
                    setattr(event, field_name, str(value))

            # update the record
            event.upsert(commit=self.autocommit)

        # update Table
        self.tbl_event.model().select()
        self.tbl_event.setModel(self.tbl_event.model())
        self.manage_events_changed()

        # back to the previous dialog
        utils_giswater.setDialog(self.dlg)


    def event_delete(self):
        """Delete a selected event."""
        
        if not self.tbl_event.selectionModel().hasSelection():
            message = "Any record selected"
            self.controller.show_info_box(message)
            return

        # a fake event to get some ancyllary data
        event = OmVisitEvent(self.controller)

        # Get selected rows
        # TODO: use tbl_event.model().fieldIndex(event.pk()) to be pk name independent
        # 0 is the column of the pk 0 'id'        
        selected_list = self.tbl_event.selectionModel().selectedRows(0)
        selected_id = []
        for index in selected_list:
            selected_id.append(str(index.data()))
        list_id = ','.join(selected_id)

        # ask for deletion
        message = "Are you sure you want to delete these records?"
        title = "Delete records"
        answer = self.controller.ask_question(message, title, list_id)
        if not answer:
            return

        # do the action
        if not event.delete(pks=selected_id, commit=self.autocommit):
            message = "Error deleting records"
            self.controller.show_warning(message)
            return

        message = "Records deleted"
        self.controller.show_info(message)

        # update Table
        self.tbl_event.model().select()
        self.manage_events_changed()


    def document_open(self):
        """Open selected document."""
        
        # Get selected rows
        field_index = self.tbl_document.model().fieldIndex('path')
        selected_list = self.dlg.tbl_document.selectionModel().selectedRows(
            field_index)
        if not selected_list:
            message = "Any record selected"
            self.controller.show_info_box(message)
            return
        elif len(selected_list) > 1:
            message = "More then one document selected. Select just one document."
            self.controller.show_warning(message)
            return

        path = selected_list[0].data()
        # Check if file exist
        if not os.path.exists(path):
            message = "File not found"
            self.controller.show_warning(message, parameter=path)
            return

        # Open the document
        if sys.platform == "win32":
            os.startfile(path)
        else:
            opener = "open" if sys.platform == "darwin" else "xdg-open"
            subprocess.call([opener, path])


    def document_delete(self):
        """Delete record from selected rows in tbl_document."""
        
        # Get selected rows. 0 is the column of the pk 0 'id'
        selected_list = self.tbl_document.selectionModel().selectedRows(0)  
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_info_box(message)
            return

        selected_id = []
        for index in selected_list:
            doc_id = index.data()
            selected_id.append(str(doc_id))
        message = "Are you sure you want to delete these records?"
        title = "Delete records"
        answer = self.controller.ask_question(message, title, ','.join(selected_id))
        if answer:
            sql = ("DELETE FROM " + self.schema_name + ".doc_x_visit"
                   " WHERE id IN ({})".format(','.join(selected_id)))
            status = self.controller.execute_sql(sql)
            if not status:
                message = "Error deleting data"
                self.controller.show_warning(message)
                return
            else:
                message = "Event deleted"
                self.controller.show_info(message)
                self.dlg.tbl_document.model().select()


    def document_insert(self):
        """Insert a docmet related to the current visit."""
        
        doc_id = self.doc_id.text()
        visit_id = self.visit_id.text()
        if not doc_id:
            message = "You need to insert doc_id"
            self.controller.show_warning(message)
            return
        if not visit_id:
            message = "You need to insert visit_id"
            self.controller.show_warning(message)
            return

        # Insert into new table
        sql = ("INSERT INTO " + self.schema_name + ".doc_x_visit (doc_id, visit_id)"
               " VALUES (" + str(doc_id) + ", " + str(visit_id) + ")")
        status = self.controller.execute_sql(sql, commit=self.autocommit)
        if status:
            message = "Document inserted successfully"
            self.controller.show_info(message)

        self.dlg.tbl_document.model().select()


    def set_configuration(self, widget, table_name):
        """Configuration of tables. Set visibility and width of columns."""

        widget = utils_giswater.getWidget(widget)
        if not widget:
            return

        # Set width and alias of visible columns
        columns_to_delete = []
        sql = ("SELECT column_index, width, alias, status"
               " FROM " + self.schema_name + ".config_client_forms"
               " WHERE table_id = '" + table_name + "'"
               " ORDER BY column_index")
        rows = self.controller.get_rows(sql, log_info=False, commit=self.autocommit)
        if not rows:
            return

        for row in rows:
            if not row['status']:
                columns_to_delete.append(row['column_index'] - 1)
            else:
                width = row['width']
                if width is None:
                    width = 100
                widget.setColumnWidth(row['column_index'] - 1, width)
                widget.model().setHeaderData(
                    row['column_index'] - 1, Qt.Horizontal, row['alias'])

        # Set order
        widget.model().setSort(0, Qt.AscendingOrder)
        widget.model().select()

        # Delete columns
        for column in columns_to_delete:
            widget.hideColumn(column)

