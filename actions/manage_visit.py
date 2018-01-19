# -*- coding: utf-8 -*-
"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

from PyQt4.QtCore import Qt, QDate
from PyQt4.QtGui import (
    QCompleter,
    QLineEdit,
    QTableView,
    QStringListModel,
    QPushButton,
    QComboBox,
    QTabWidget)
from PyQt4.QtSql import QSqlTableModel

import os
import sys
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from dao.event import Event
from dao.visit import Visit
from dao.om_visit_x_arc import OmVisitXArc
from dao.om_visit_x_connec import OmVisitXConnec
from dao.om_visit_x_node import OmVisitXNode
from dao.om_visit_x_gully import OmVisitXGully

from ui.event_standard import EventStandard
from ui.event_ud_arc_standard import EventUDarcStandard
from ui.event_ud_arc_rehabit import EventUDarcRehabit
from ui.add_visit import AddVisit
from ui.visit_management import VisitManagement
from actions.parent_manage import ParentManage

class ManageVisit(ParentManage, object):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'Add visit' of toolbar 'edit' """
        super(ManageVisit, self).__init__(iface, settings, controller, plugin_dir)
        # set some vars if not set
        controller.get_postgresql_version()


    def manage_visit(self):
        """ Button 64. Add visit """

        # turnoff autocommit of this and base class
        # commit will be done at dialog button box level management
        self.autocommit = True

        # Create the dialog and signals and related ORM Visit class
        self.currentVisit = Visit(self.controller)
        self.dlg = AddVisit()
        utils_giswater.setDialog(self.dlg)

        # manage save and rollback when closing the dialog
        self.dlg.rejected.connect(self.mange_rejected)
        self.dlg.accepted.connect(self.mange_accepted)

        # Get layers of every geom_type
        self.reset_lists()
        self.reset_layers ()
        self.layers['arc'] = self.controller.get_group_layers('arc')
        self.layers['node'] = self.controller.get_group_layers('node')
        self.layers['connec'] = self.controller.get_group_layers('connec')
        self.layers['element'] = self.controller.get_group_layers('element')
        # Remove 'gully' for 'WS'
        if self.controller.get_project_type() != 'ws':
            self.layers['gully'] = self.controller.get_group_layers('gully')

        # Show future id of visit
        visit_id = self.currentVisit.maxPk(autocommit=self.autocommit) + 1
        self.dlg.visit_id.setText(str(visit_id))

        # Set icons
        self.set_icon(self.dlg.btn_feature_insert, "111")
        self.set_icon(self.dlg.btn_feature_delete, "112")
        self.set_icon(self.dlg.btn_feature_snapping, "137")
        self.set_icon(self.dlg.btn_doc_insert, "111")
        self.set_icon(self.dlg.btn_doc_delete, "112")
        self.set_icon(self.dlg.btn_doc_new, "134")
        self.set_icon(self.dlg.btn_open_doc, "170")

        # tab events
        self.tabs = self.dlg.findChild(QTabWidget, 'tabWidget')

        # Tab 'Data'/'Visit'
        self.visit_id = self.dlg.findChild(QLineEdit, "visit_id")
        self.user_name = self.dlg.findChild(QLineEdit, "cur_user")
        self.ext_code = self.dlg.findChild(QLineEdit, "ext_code")
        self.visitcat_id = self.dlg.findChild(QComboBox, "visitcat_id")
        # self.btn_accept = self.dlg.findChild(QPushButton, "btn_accept")
        # self.btn_cancel = self.dlg.findChild(QPushButton, "btn_cancel")

        # Tab 'Relations'
        self.feature_type = self.dlg.findChild(QComboBox, "feature_type")
        self.tbl_relation = self.dlg.findChild(QTableView, "tbl_relation")

        # tab 'Event'
        #self.event_id = self.dlg.findChild(QLineEdit, "event_id")
        self.tbl_event = self.dlg.findChild(QTableView, "tbl_event")
        self.parameter_type_id = self.dlg.findChild(QComboBox, "parameter_type_id")
        self.parameter_id = self.dlg.findChild(QComboBox, "parameter_id")

        # Set current date and time
        current_date = QDate.currentDate()
        self.dlg.startdate.setDate(current_date)
        self.dlg.enddate.setDate(current_date)

        # set User name get from controller login
        if self.controller.user and self.user_name:
            self.user_name.setText(str(self.controller.user))

        # set the start tab to be shown (e.g. VisitTab)
        self.currentTabIndex = self.tabIndex('VisitTab')
        self.tabs.setCurrentIndex(self.currentTabIndex)

        # Set signals
        self.dlg.btn_event_insert.pressed.connect(self.event_insert)
        self.dlg.btn_event_delete.pressed.connect(self.event_delete)
        self.dlg.btn_event_update.pressed.connect(self.event_update)
        self.dlg.btn_feature_insert.pressed.connect(partial(self.insert_feature, self.tbl_relation))
        self.dlg.btn_feature_delete.pressed.connect(partial(self.delete_records, self.tbl_relation))
        self.dlg.btn_feature_delete.pressed.connect(partial(self.checkIfAnyInTableView))
        self.dlg.btn_feature_snapping.pressed.connect(partial(self.selection_init, self.tbl_relation))
        self.tabs.currentChanged.connect(partial(self.manageTabChanged))

        # Tab 'Document'
        self.doc_id = self.dlg.findChild(QLineEdit, "doc_id")
        self.tbl_document = self.dlg.findChild(QTableView, "tbl_document")

        # Set signals
        self.dlg.btn_doc_insert.pressed.connect(self.document_insert)
        self.dlg.btn_doc_delete.pressed.connect(self.document_delete)
        self.dlg.btn_doc_new.pressed.connect(self.manage_document)
        self.dlg.btn_open_doc.pressed.connect(self.document_open)

        # Fill combo boxes of the form and related events
        self.visitcat_id.currentIndexChanged.connect(partial(self.setTabsState))
        self.feature_type.currentIndexChanged.connect(partial(self.event_feature_type_selected))
        self.parameter_type_id.currentIndexChanged.connect(partial(self.setParameterIdCombo))
        self.fill_combos()

        # Set autocompleters of the form
        self.set_completers()

        # Open the dialog
        self.dlg.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg.show()


    def mange_accepted(self):
        """Do all action when closed the dialog with Ok.
        e.g. all necessary commits and cleanings."""
        pass


    def mange_rejected(self):
        """Do all action when closed the dialog with Cancel or X.
        e.g. all necessary rollbacks and cleanings."""
        # removed current working visit
        # this should cascade removing of all related records
        self.currentVisit.delete()


    def tabIndex(self, tabName):
        """Get the index of a tab basing on objectName."""
        for idx in range(self.tabs.count()):
            if self.tabs.widget(idx).objectName() == tabName:
                return idx
        return -1


    def updateVisit(self):
        """Manage sync between GUI values and Visit record in DB."""
        # fill Visit basing on GUI values
        self.currentVisit.id = int(self.visit_id.text())
        self.currentVisit.startdate = self.dlg.startdate.date().toString(Qt.ISODate)
        self.currentVisit.enddate = self.dlg.enddate.date().toString(Qt.ISODate)
        self.currentVisit.user_name = self.user_name.text()
        self.currentVisit.ext_code = self.ext_code.text()
        self.currentVisit.visitcat_id = self.visitcat_id.itemData(self.visitcat_id.currentIndex())
        self.currentVisit.descript = self.dlg.descript.text()

        # update or insert but without closing the transaction: autocommit=False
        self.currentVisit.upsert(autocommit=self.autocommit)


    def update_relations(self):
        """Save current selected features in tbl_relations."""
        db_record = None
        if self.geom_type == 'arc':
            db_record = OmVisitXArc(self.controller)
        if self.geom_type == 'node':
            db_record = OmVisitXNode(self.controller)
        if self.geom_type == 'connec':
            db_record = OmVisitXConnec(self.controller)
        if self.geom_type == 'gully':
            db_record = OmVisitXGully(self.controller)

        # remove all actual saved records
        db_record.delete(allRecords=True, autocommit=self.autocommit)

        # do nothing if model is None or nothing is selected
        if not self.tbl_relation.selectionModel() or not self.tbl_relation.selectionModel().hasSelection():
            return

        # for each selected element of a specific geom_type create an db entry
        column_name = self.geom_type+"_id"
        selectedGeomIdIndex = self.tbl_relation.selectionModel().selectedRows(0)
        for index in selectedGeomIdIndex:
            # set common fields
            db_record.id = db_record.maxPk() + 1
            db_record.visit_id = int(self.visit_id.text())

            # set value for column <geom_type>_id
            setattr(db_record, column_name, index.data())

            # than save the selcted record
            db_record.upsert(autocommit=self.autocommit)


    def manageTabChanged(self, index):
        """Do actions when tab is exit and entered.
        Action s depend on tab index"""
        # manage leaving tab
        # tab Visit
        if self.currentTabIndex == self.tabIndex('VisitTab'):
            self.updateVisit()
        # tab Relation
        if self.currentTabIndex == self.tabIndex('RelationsTab'):
            self.update_relations()

        # manage arriving tab

        # tab Visit
        self.currentTabIndex = index
        if index == self.tabIndex('VisitTab'):
            pass
        # tab Relation
        if index == self.tabIndex('RelationsTab'):
            pass
        # tab Event
        if index == self.tabIndex('EventTab'):
            self.enteredEventTab()
        # tab Document
        if index == self.tabIndex('DocumentTab'):
            pass


    def enteredEventTab(self):
        """Manage actions when the Event tab is entered."""
        self.setParameterIdCombo()


    def setParameterIdCombo(self):
        """set parameter_id combo basing on current selections."""
        sql = ("SELECT id"
               " FROM " + self.schema_name + ".om_visit_parameter"
               " WHERE parameter_type='" + self.parameter_type_id.currentText().upper() + "'"
               " AND feature_type='" + self.feature_type.currentText().upper() + "'"
               " ORDER BY id")
        rows = self.controller.get_rows(sql, autocommit=self.autocommit)
        utils_giswater.fillComboBox("parameter_id", rows, allow_nulls=False)


    def checkIfAnyInTableView(self):
        """If any element remained in the tableview => activate feature_type."""
        state = (len(self.ids) == 0)

        self.feature_type.setEnabled( state )
        for idx in [self.tabIndex('EventTab'), self.tabIndex('DocumentTab')]:
            self.tabs.setTabEnabled(idx, True)


    def event_feature_selected(self, itemsSelected, itemsDeselected):
        """Manage selection change in tbl_relation.
        THis means that:
        A) have to activate Event and Document tabs if
        at least an element is selected.
        B) Deactivate the hability to select a different feature_type if
        at least an element is selected."""
        hasSelection = self.tbl_relation.selectionModel().hasSelection()

        # A) have to activate Event and Document tabs if at least an element is selected.
        for idx in [self.tabIndex('EventTab'), self.tabIndex('DocumentTab')]:
            self.tabs.setTabEnabled(idx, True)
        # B Deactivate the hability to select a different feature_type if at least an element is selected
        self.feature_type.setEnabled( not hasSelection )


    def setRelationTableEvents(self, table):
        """Set all events related to the table, model and selectionModel.
        It's necessary a centralised call becase base class can create a None model
        where all callbacks are lost ance can't be registered."""
        # what to do when selection change in the current model
        table.selectionModel().selectionChanged.connect(partial(self.event_feature_selected))


    def event_feature_type_selected(self, index):
        """Manage selection change in feature_type combo box.
        THis means that have to set completer for feature_id QTextLine and
        setup model for features to select table."""
        # reset:
        # A) selecetd ids and layer selection
        # B) set previous mapTool
        # C) delete all om_visit_x_* records
        # TODO: check if it is the correct user experience
        self.reset_lists()
        self.remove_selection()
        if self.previousMapTool:
            self.canvas.setMapTool(self.previousMapTool)
        db_record = OmVisitXArc(self.controller)
        db_record.delete(allRecords=True, autocommit=self.autocommit)
        db_record = OmVisitXNode(self.controller)
        db_record.delete(allRecords=True, autocommit=self.autocommit)
        db_record = OmVisitXConnec(self.controller)
        db_record.delete(allRecords=True, autocommit=self.autocommit)
        if self.controller.get_project_type() != 'ws':
            db_record = OmVisitXGully(self.controller)
            db_record.delete(allRecords=True, autocommit=self.autocommit)
        del db_record

        # set feature_id model and completer
        # beware that self.geom_type have to be set not as local variable!
        self.geom_type = self.feature_type.currentText().lower()
        viewname = "v_edit_" + self.geom_type
        self.set_completer_feature_id(self.geom_type, viewname)

        # set table model and completer
        self.set_table_model(self.tbl_relation, self.geom_type, '')

        # set the callback to setup all events later
        # its not possible to setup listener in this moment beacouse set_table_model without 
        # a valid expression parameter return a None model => no events can be triggered
        self.set_lazy_widget_events(self.tbl_relation, self.setRelationTableEvents)


    def edit_visit(self):
        """ Button 65: Edit visit """

        # Create the dialog
        self.dlg_man = VisitManagement()
        utils_giswater.setDialog(self.dlg_man)
        utils_giswater.set_table_selection_behavior(self.dlg_man.tbl_visit)

        # Set a model with selected filter. Attach that model to selected table
        table_object = "om_visit"        
        self.fill_table_object(self.dlg_man.tbl_visit, self.schema_name + "." + table_object)
        self.set_table_columns(self.dlg_man.tbl_visit, table_object)

        # Set dignals
        self.dlg_man.tbl_visit.doubleClicked.connect(partial(self.open_selected_object, self.dlg_man.tbl_visit, table_object))
        self.dlg_man.btn_open.pressed.connect(partial(self.open_selected_object, self.dlg_man.tbl_visit, table_object))        
        self.dlg_man.btn_accept.pressed.connect(partial(self.open_selected_object, self.dlg_man.tbl_visit, table_object))
        self.dlg_man.btn_cancel.pressed.connect(self.dlg_man.close)
        self.dlg_man.btn_delete.clicked.connect(partial(self.delete_selected_object, self.dlg_man.tbl_visit, table_object))

        # Open form
        self.dlg_man.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_man.open()


    def fill_combos(self):
        """ Fill combo boxes of the form """

        # combos in Visit tab

        # Fill ComboBox visitcat_id
        # save result in self.visitcat_ids to get id depending on selected combo
        sql = ("SELECT id, name"
               " FROM " + self.schema_name + ".om_visit_cat where active is true"
               " ORDER BY name")
        self.visitcat_ids = self.controller.get_rows(sql, autocommit=self.autocommit)
        ids = [row[0] for row in self.visitcat_ids]
        comboValues = [[row[1]] for row in self.visitcat_ids]
        utils_giswater.fillComboBox("visitcat_id", zip(comboValues, ids), allow_nulls=False)

        # now get default value to be show in visitcat_id
        sql = ("SELECT value"
               " FROM " + self.schema_name + ".config_param_user WHERE parameter='visitcat_vdefault'"
               " and user='" + self.controller.user + "'")
        rows = self.controller.get_rows(sql, autocommit=self.autocommit)
        if rows and rows[0]:
            # if int then look for default row ans set it
            try:
                visitcat_id_default = int(rows[0][0])
                comboIndex = ids.index(visitcat_id_default)
                self.visitcat_id.setCurrentIndex(comboIndex)
            except TypeError:
                pass
            except ValueError:
                pass

        # combos in Relations tab

        # fill feature_type
        sql = ("SELECT id"
               " FROM " + self.schema_name + ".sys_feature_type"
               " ORDER BY id")
        rows = self.controller.get_rows(sql, autocommit=self.autocommit)
        utils_giswater.fillComboBox("feature_type", rows, allow_nulls=False)

        # combos in Event tab

        # Fill ComboBox parameter_type_id
        sql = ("SELECT id"
               " FROM " + self.schema_name + ".om_visit_parameter_type"
               " ORDER BY id")
        parameter_type_ids = self.controller.get_rows(sql, autocommit=self.autocommit)
        utils_giswater.fillComboBox("parameter_type_id", parameter_type_ids, allow_nulls=False)

        # now get default value to be show in parameter_type_id
        sql = ("SELECT value"
               " FROM " + self.schema_name + ".config_param_user"
               " WHERE parameter='om_param_type_vdefault'"
               " AND user='" + self.controller.user + "'"
               " ORDER BY value")
        rows = self.controller.get_rows(sql, autocommit=self.autocommit)
        if rows and rows[0]:
            # if int then look for default row ans set it
            try:
                parameter_type_id = int(rows[0][0])
                comboIndex = ids.index(parameter_type_id)
                self.parameter_type_id.setCurrentIndex(comboIndex)
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
        rows = self.controller.get_rows(sql, autocommit=self.autocommit)
        values = []
        if rows:
            for row in rows:
                values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)
        self.dlg.visit_id.textChanged.connect(self.check_visit_exist)
                
        # Adding auto-completion to a QLineEdit - document_id
        self.completer = QCompleter()
        self.dlg.doc_id.setCompleter(self.completer)
        model = QStringListModel()
                
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".doc"
        rows = self.controller.get_rows(sql, autocommit=self.autocommit)
        values = []
        if rows:
            for row in rows:
                values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)


    def manage_document(self):
        """ TODO: Execute action of button 34 """
        pass
#         manage_document = ManageDocument(self.iface, self.settings, self.controller, self.plugin_dir)          
#         manage_document.manage_document()
#         self.set_completer_object(self.table_object)


    def fill_table_visit(self, widget, table_name, filter_):
        """ Set a model with selected filter. Attach that model to selected table """

        # Set model
        model = QSqlTableModel();
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


    def check_visit_exist(self):

        # Tab event
        # Check if we already have data with selected visit_id
        visit_id = self.dlg.visit_id.text()
        sql = ("SELECT DISTINCT(id) FROM " + self.schema_name + ".om_visit"
               " WHERE id = '" + str(visit_id) + "'")
        row = self.controller.get_row(sql, commit=False)
        if not row:
            return

        # If element exist: load data ELEMENT
        sql = ("SELECT * FROM " + self.schema_name + ".om_visit" 
               " WHERE id = '" + str(visit_id) + "'")
        row = self.controller.get_row(sql, commit=False)
        if not row:
            return

        # Set data
        self.dlg.ext_code.setText(str(row['ext_code']))

        # TODO: join
        if str(row['visitcat_id']) == '1':
            visitcat_id = "Test"

        utils_giswater.setWidgetText("visitcat_id", str(visitcat_id))
        self.dlg.descript.setText(str(row['descript']))

        # Fill table event depending of visit_id
        visit_id = self.visit_id.text()
        self.filter = "visit_id = '" + str(visit_id) + "'"
        self.fill_table_visit(self.tbl_event, self.schema_name+".om_visit_event", self.filter)

        # Tab document
        self.fill_table_visit(self.tbl_document, self.schema_name + ".v_ui_doc_x_visit", self.filter)


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
        elif form_type == 'event_ud_arc_rehabit':
            self.dlg_event = EventUDarcRehabit()
        elif form_type == 'event_standard':
            self.dlg_event = EventStandard()
        else:
            message = "Unrecognised form type: " + form_type
            self.controller.show_info_box(message)
            return

        utils_giswater.setDialog(self.dlg_event)
        self.dlg_event.setWindowFlags(Qt.WindowStaysOnTopHint)
        ret = self.dlg_event.exec_()

        # back to the current dialg
        utils_giswater.setDialog(self.dlg)

        # check return
        if not ret:
            # pressed cancel
            return

        # create an ampty Event
        event = Event(self.controller)
        event.id = event.maxPk() + 1
        event.parameter_id = parameter_id
        event.visit_id = int(self.visit_id.text())

        if form_type == 'event_standard':
            event.value = self.dlg_event.value.text()
            event.text = self.dlg_event.text.text()

        elif form_type == 'event_ud_arc_standard':
            event.value = self.dlg_event.value.text()
            event.postition_id = self.dlg_event.position_id.text()
            event.position_value = self.dlg_event.position_value.text()
            event.text = self.dlg_event.text.text()

        elif form_type == 'event_ud_arc_rehabit':
            event.position_id = self.dlg_event.position_id.text()
            event.position_value = self.dlg_event.position_value.text()
            event.value1 = self.dlg_event.value1.text()
            event.value2 = self.dlg_event.value2.text()
            event.geom1 = self.dlg_event.geom1.text()
            event.geom2 = self.dlg_event.geom2.text()
            event.geom3 = self.dlg_event.geom3.text()
            event.text = self.dlg_event.text.text()

        # save new event
        event.upsert()


    def setTabsState(self, index=None):
        """"disable/enable all following (skip Visit) tabs basing if no value is selected."""
        # if all Visit mandatory data are set => all following tabs can be enabled
        state = self.visitcat_id.currentText() != ''
        for idx in [self.tabIndex('RelationsTab'), self.tabIndex('EventTab'), self.tabIndex('DocumentTab')]:
            self.tabs.setTabEnabled(idx, True)

        # basing on Releation tab: as stated in the document
        # "una vez tengamos un elemento o más seleccionado se habilitaran
        # los tab de event & document"
        relationTableView = self.dlg.findChild(QTableView, 'tbl_relation')
        selected = relationTableView.selectedIndexes()
        state = (len(selected) != 0)
        for idx in [self.tabIndex('EventTab'), self.tabIndex('DocumentTab')]:
            self.tabs.setTabEnabled(idx, True)


    def event_update(self):

        # Get selected rows
        selected_list = self.dlg.tbl_event.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_info_box(message)
            return

        elif len(selected_list) > 1:
            message = "More then one event selected. Select just one event."
            self.controller.show_warning(message)
            return
        
        row = selected_list[0].row()
        parameter_id = self.dlg.tbl_event.model().record(row).value("parameter_id")
        event_id = self.dlg.tbl_event.model().record(row).value("id")

        sql = ("SELECT form_type FROM " + self.schema_name + ".om_visit_parameter"
               " WHERE id = '" + str(parameter_id) + "'")
        row = self.controller.get_row(sql, commit=False)
        if not row:
            return
        form_type = str(row[0])

        sql = ("SELECT * FROM " + self.schema_name + ".om_visit_event"
               " WHERE id = '" + str(event_id) + "'")
        row = self.controller.get_row(sql, commit=False)
        if not row:
            return

        if form_type == 'event_ud_arc_standard':
            self.dlg_event = EventUDarcStandard()
            # Force fill data
            # TODO set parameter id
            #self.dlg_event.parameter_id
            self.dlg_event.value.setText(str(row['value']))
            self.dlg_event.position_id.setText(str(row['position_id']))
            self.dlg_event.position_value.setText(str(row['position_value']))
            self.dlg_event.text.setText(str(row['text']))

        elif form_type == 'event_ud_arc_rehabit':
            self.dlg_event = EventUDarcRehabit()
            # Force fill data
            # self.dlg_event.parameter_id
            self.dlg_event.position_id.setText(str(row['position_id']))
            self.dlg_event.position_value.setText(str(row['position_value']))
            self.dlg_event.text.setText(str(row['text']))
            self.dlg_event.value1.setText(str(row['value1']))
            self.dlg_event.value2.setText(str(row['value2']))
            self.dlg_event.geom1.setText(str(row['geom1']))
            self.dlg_event.geom2.setText(str(row['geom2']))
            self.dlg_event.geom3.setText(str(row['geom3']))

        elif form_type == 'event_standard':
            self.dlg_event = EventStandard()
            # Force fill data
            # self.dlg_event.parameter_id
            self.dlg_event.value.setText(str(row['value']))
            self.dlg_event.text.setText(str(row['text']))

        utils_giswater.setDialog(self.dlg_event)
        self.dlg_event.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_event.exec_()


    def event_delete(self):

        # Get selected rows
        selected_list = self.dlg.tbl_event.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_info_box(message)
            return
        selected_id = []
        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            event_id = self.dlg.tbl_event.model().record(row).value("id")
            selected_id.append(str(event_id))
            inf_text += str(event_id) + ", "
            list_id = list_id + "'" + str(event_id) + "', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        message = "Are you sure you want to delete these records?"
        answer = self.controller.ask_question(message, "Delete records", inf_text)
        if answer:
            for el in selected_id:
                sql = ("DELETE FROM " + self.schema_name + ".om_visit_event"
                       " WHERE id = '" + str(el) + "'")
                status = self.controller.execute_sql(sql)
                if not status:
                    message = "Error deleting data"
                    self.controller.show_warning(message)
                    return
                elif status:
                    message = "Event deleted"
                    self.controller.show_info(message)
                    self.dlg.tbl_event.model().select()


    def document_open(self):

        # Get selected rows
        selected_list = self.dlg.tbl_document.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_info_box(message)
            return
        elif len(selected_list) > 1:
            message = "More then one document selected. Select just one document."
            self.controller.show_warning(message)
            return
        else:
            row = selected_list[0].row()
            path = self.dlg.tbl_document.model().record(row).value('path')
            # Check if file exist
            if not os.path.exists(path):
                message = "File not found"
                self.controller.show_warning(message)
            else:
                # Open the document
                os.startfile(path)


    def document_delete(self):

        # Get selected rows
        selected_list = self.dlg.tbl_document.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_info_box(message)
            return

        selected_id = []
        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            doc_id = self.dlg.tbl_document.model().record(row).value("id")
            selected_id.append(str(doc_id))
            inf_text += str(doc_id) + ", "
            list_id = list_id + "'" + str(doc_id) + "', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        message = "Are you sure you want to delete these records?"
        answer = self.controller.ask_question(message, "Delete records", inf_text)
        if answer:
            for el in selected_id:
                sql = ("DELETE FROM " + self.schema_name + ".doc_x_visit"
                       " WHERE id = '" + str(el) + "'")
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

        doc_id = self.doc_id.text()
        visit_id = self.visit_id.text()
        if doc_id == 'null':
            message = "You need to insert doc_id"
            self.controller.show_warning(message)
            return
        if visit_id == 'null':
            message = "You need to insert visit_id"
            self.controller.show_warning(message)
            return

        # Insert into new table
        sql = ("INSERT INTO " + self.schema_name + ".doc_x_visit (doc_id, visit_id)"
               " VALUES (" + str(doc_id) + "," + str(visit_id) + ")")
        status = self.controller.execute_sql(sql)
        if status:
            message = "Document inserted successfully"
            self.controller.show_info(message)

        self.dlg.tbl_document.model().select()

