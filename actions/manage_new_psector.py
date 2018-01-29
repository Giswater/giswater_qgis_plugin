"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-


import os
import sys
import csv

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)

import utils_giswater
import operator

from functools import partial

from qgis.core import  QgsComposition, QgsComposerMap, QgsComposerAttributeTable, QgsFeatureRequest

from PyQt4.QtGui import QAbstractItemView, QDoubleValidator,QIntValidator, QTableView
from PyQt4.QtGui import QCheckBox, QLineEdit, QComboBox, QDateEdit, QLabel
from PyQt4.QtGui import QPrinter, QPainter

from PyQt4.QtSql import QSqlQueryModel, QSqlTableModel
from PyQt4.QtCore import Qt, QSizeF

from ui.plan_psector import Plan_psector
from ui.psector_rapport import Psector_rapport
from actions.parent_manage import ParentManage
from actions.multiple_selection import MultipleSelection



class ManageNewPsector(ParentManage):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'New Psector' of toolbar 'master' """
        ParentManage.__init__(self, iface, settings, controller, plugin_dir)

    def master_new_psector(self, psector_id=None, psector_type=None):
        """ Buttons 45 and 81: New psector """
        # Create the dialog and signals
        self.dlg = Plan_psector()
        utils_giswater.setDialog(self.dlg)
        self.psector_type = str(psector_type)
        # Capture the current layer to return it at the end of the operation
        cur_active_layer = self.iface.activeLayer()
        self.set_selectionbehavior(self.dlg)
        self.project_type = self.controller.get_project_type()

        # Get layers of every geom_type
        self.list_elemets = {}
        self.reset_lists()
        self.reset_layers()
        self.layers['arc'] = self.controller.get_group_layers('arc')
        self.layers['node'] = self.controller.get_group_layers('node')
        update = False  # if false: insert; if true: update

        # Remove all previous selections
        self.remove_selection(True)

        # Set icons
        self.set_icon(self.dlg.btn_insert, "111")
        self.set_icon(self.dlg.btn_delete, "112")
        self.set_icon(self.dlg.btn_snapping, "137")

        table_object = "psector"

        # tab General elements
        self.psector_id = self.dlg.findChild(QLineEdit, "psector_id")
        self.cmb_psector_type = self.dlg.findChild(QComboBox, "psector_type")
        self.cmb_expl_id = self.dlg.findChild(QComboBox, "expl_id")
        self.cmb_sector_id = self.dlg.findChild(QComboBox, "sector_id")
        self.cmb_result_id = self.dlg.findChild(QComboBox, "result_id")
        scale = self.dlg.findChild(QLineEdit, "scale")
        scale.setValidator(QDoubleValidator())
        rotation = self.dlg.findChild(QLineEdit, "rotation")
        rotation.setValidator(QDoubleValidator())
        atlas_id = self.dlg.findChild(QLineEdit, "atlas_id")
        atlas_id.setValidator(QIntValidator())

        self.populate_combos(self.dlg.psector_type, 'name', 'id', self.psector_type + '_psector_cat_type', False)
        self.populate_combos(self.cmb_expl_id, 'name', 'expl_id', 'exploitation', False)
        self.populate_combos(self.cmb_sector_id, 'name', 'sector_id', 'sector', False)
        if self.psector_type == 'om':
            self.populate_result_id(self.dlg.result_id, self.psector_type + '_result_cat')
        else:
            self.dlg.lbl_result_id.setVisible(False)
            self.cmb_result_id.setVisible(False)


        self.priority = self.dlg.findChild(QComboBox, "priority")
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".value_priority ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("priority", rows, False)


        # tab Bugdet
        total_arc = self.dlg.findChild(QLineEdit, "total_arc")
        self.double_validator(total_arc)
        total_node = self.dlg.findChild(QLineEdit, "total_node")
        self.double_validator(total_node)
        total_other = self.dlg.findChild(QLineEdit, "total_other")
        self.double_validator(total_other)

        pem = self.dlg.findChild(QLineEdit, "pem")
        self.double_validator(pem)
        pec_pem = self.dlg.findChild(QLineEdit, "pec_pem")
        self.double_validator(pec_pem)
        pec = self.dlg.findChild(QLineEdit, "pec")
        self.double_validator(pec)
        pec_vat = self.dlg.findChild(QLineEdit, "pec_vat")
        self.double_validator(pec_vat)
        pca = self.dlg.findChild(QLineEdit, "pca")
        self.double_validator(pca)

        gexpenses = self.dlg.findChild(QLineEdit, "gexpenses")
        self.double_validator(gexpenses)
        vat = self.dlg.findChild(QLineEdit, "vat")
        self.double_validator(vat)
        other = self.dlg.findChild(QLineEdit, "other")
        self.double_validator(other)



        self.enable_tabs(False)
        self.enable_buttons(False)

        # Tables
        # tab Elements
        self.qtbl_arc = self.dlg.findChild(QTableView, "tbl_psector_x_arc")
        self.qtbl_arc.setSelectionBehavior(QAbstractItemView.SelectRows)

        self.qtbl_node = self.dlg.findChild(QTableView, "tbl_psector_x_node")
        self.qtbl_node.setSelectionBehavior(QAbstractItemView.SelectRows)

        all_rows = self.dlg.findChild(QTableView, "all_rows")
        all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        selected_rows = self.dlg.findChild(QTableView, "selected_rows")
        selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        ##
        # if a row is selected from mg_psector_mangement(button 46 or button 81)
        # Si psector_id contiene "1" o "0" python lo toma como boolean, si es True, quiere decir que no contiene valor
        # y por lo tanto es uno nuevo. Convertimos ese valor en 0 ya que ningun id va a ser 0. de esta manera si psector_id
        # tiene un valor distinto de 0, es que el sector ya existe y queremos hacer un update.
        ##
        if isinstance(psector_id, bool):
            psector_id = 0
        if self.psector_type == 'om':
            self.delete_psector_selector('om_psector_selector')
        else:
            self.delete_psector_selector('selector_psector')
        if psector_id != 0:
            self.enable_tabs(True)
            self.enable_buttons(True)
            self.dlg.name.setEnabled(False)
            self.fill_table(self.qtbl_arc, self.schema_name + "." + self.psector_type + "_psector_x_arc")
            self.fill_table(self.qtbl_node, self.schema_name + "." + self.psector_type + "_psector_x_node")

            sql = "SELECT psector_id, name, psector_type, expl_id, sector_id, priority, descript, text1, text2, observ, atlas_id, scale, rotation, active "
            sql += " FROM " + self.schema_name + "." + self.psector_type + "_psector"
            sql += " WHERE psector_id = " + str(psector_id)
            row = self.dao.get_row(sql)
            if row is None:
                return
            self.psector_id.setText(str(row['psector_id']))
            utils_giswater.set_combo_itemData(self.cmb_psector_type, row['psector_type'], 0, 1)
            utils_giswater.set_combo_itemData(self.cmb_expl_id, row['expl_id'], 0, 1)
            utils_giswater.set_combo_itemData(self.cmb_sector_id, row['sector_id'], 0, 1)

            utils_giswater.setRow(row)
            utils_giswater.setChecked("active", row['active'])
            utils_giswater.fillWidget("name")
            utils_giswater.fillWidget("descript")
            index = self.priority.findText(row["priority"], Qt.MatchFixedString)
            if index >= 0:
                self.priority.setCurrentIndex(index)
            utils_giswater.fillWidget("text1")
            utils_giswater.fillWidget("text2")
            utils_giswater.fillWidget("observ")
            utils_giswater.fillWidget("atlas_id")
            utils_giswater.fillWidget("scale")
            utils_giswater.fillWidget("rotation")

            # Fill tables tbl_arc_plan, tbl_node_plan, tbl_v_plan/om_other_x_psector with selected filter
            expr = " psector_id = " + str(psector_id)
            self.qtbl_arc.model().setFilter(expr)
            self.qtbl_arc.model().select()

            expr = " psector_id = " + str(psector_id)
            self.qtbl_node.model().setFilter(expr)
            self.qtbl_node.model().select()

            self.populate_budget(psector_id)
            update = True
            if utils_giswater.getWidgetText(self.dlg.psector_id) != 'null':
                if self.psector_type == 'om':
                    self.insert_psector_selector('om_psector_selector', 'psector_id', utils_giswater.getWidgetText(self.dlg.psector_id))
                else:
                    self.insert_psector_selector('selector_psector', 'psector_id', utils_giswater.getWidgetText(self.dlg.psector_id))


        sql = ("SELECT state_id FROM " + self.schema_name + ".selector_state WHERE cur_user = current_user")
        rows = self.controller.get_rows(sql)
        self.all_states = rows
        self.delete_psector_selector('selector_state')
        self.insert_psector_selector('selector_state', 'state_id', '1')

        # Set signals
        self.dlg.btn_accept.pressed.connect(partial(self.insert_or_update_new_psector, update, "v_edit_"+self.psector_type + '_psector', True))
        self.dlg.tabWidget.currentChanged.connect(partial(self.check_tab_position, update))
        self.dlg.btn_cancel.pressed.connect(partial(self.close_psector, cur_active_layer))
        self.dlg.psector_type.currentIndexChanged.connect(partial(self.populate_result_id, self.dlg.result_id, self.psector_type + '_result_cat'))
        self.dlg.rejected.connect(partial(self.close_psector, cur_active_layer))
        #self.dlg.psector_type.currentIndexChanged.connect(partial(self.enable_combos))
        self.lbl_descript = self.dlg.findChild(QLabel, "lbl_descript")
        self.dlg.all_rows.clicked.connect(partial(self.show_description))
        self.dlg.btn_select.clicked.connect(partial(self.update_total, self.dlg.selected_rows))
        self.dlg.btn_unselect.clicked.connect(partial(self.update_total, self.dlg.selected_rows))
        self.dlg.btn_insert.pressed.connect(partial(self.insert_features, table_object, self.psector_type))
        self.dlg.btn_delete.pressed.connect(partial(self.delete_record, table_object, self.psector_type))
        self.dlg.btn_snapping.pressed.connect(partial(self.init_selection, table_object, self.psector_type))

        self.dlg.btn_rapports.pressed.connect(partial(self.open_dlg_rapports, self.dlg))
        self.dlg.tab_feature.currentChanged.connect(partial(self.tab_feature_changed, table_object))
        self.dlg.name.textChanged.connect(partial(self.enable_relation_tab, self.psector_type + '_psector'))
        self.dlg.txt_name.textChanged.connect(partial(self.query_like_widget_text, self.dlg.txt_name, self.dlg.all_rows, 'v_price_compost', 'v_edit_'+self.psector_type + '_psector_x_other', "id"))

        self.dlg.gexpenses.returnPressed.connect(partial(self.calulate_percents, self.psector_type + '_psector', psector_id, 'gexpenses'))
        self.dlg.vat.returnPressed.connect(partial(self.calulate_percents, self.psector_type + '_psector', psector_id, 'vat'))
        self.dlg.other.returnPressed.connect(partial(self.calulate_percents, self.psector_type + '_psector', psector_id, 'other'))


        sql = ("SELECT other, gexpenses, vat FROM " + self.schema_name + "." + self.psector_type + "_psector "
               " WHERE psector_id='"+str(psector_id)+"'")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(self.dlg.other, row[0])
            utils_giswater.setWidgetText(self.dlg.gexpenses, row[1])
            utils_giswater.setWidgetText(self.dlg.vat, row[2])

        # Adding auto-completion to a QLineEdit for default feature
        self.geom_type = "arc"
        viewname = "v_edit_" + self.geom_type
        self.set_completer_feature_id(self.geom_type, viewname)

        # Set default tab 'arc'
        self.dlg.tab_feature.setCurrentIndex(0)
        self.geom_type = "arc"
        self.tab_feature_changed(table_object)
        self.dlg.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg.open()


    def update_total(self, qtable):
        """ Show description of product plan/om _psector as label"""
        selected_list = qtable.model()
        if selected_list is None:
            return
        total = 0
        psector_id = utils_giswater.getWidgetText('psector_id')
        for x in range(0, selected_list.rowCount()):
            if int(qtable.model().record(x).value('psector_id')) == int(psector_id):
                total = total + float(qtable.model().record(x).value('total_budget'))
        utils_giswater.setText('lbl_total', str(total))


    def open_dlg_rapports(self, previous_dialog):

        default_file_name = utils_giswater.getWidgetText(previous_dialog.name)

        viewname = 'v_plan_psector_budget_detail'

        if self.psector_type == 'om' and previous_dialog.psector_type.currentIndex == 0:
            viewname ='v_om_psector_budget_detail_rec'
        elif self.psector_type == 'om' and previous_dialog.psector_type.currentIndex == 1:
            viewname = 'v_om_psector_budget_detail_reh'

        self.dlg_psector_rapport = Psector_rapport()
        utils_giswater.setDialog(self.dlg_psector_rapport)
        self.dlg_psector_rapport.chk_composer.setChecked(True)

        utils_giswater.setWidgetText('txt_composer_path', default_file_name + " comp.pdf")
        utils_giswater.setWidgetText('txt_pdf_path', default_file_name + " detail.pdf")
        utils_giswater.setWidgetText('txt_csv_path', default_file_name + ".csv")

        self.dlg_psector_rapport.btn_cancel.pressed.connect(partial(self.set_prev_dialog, self.dlg_psector_rapport, previous_dialog))
        self.dlg_psector_rapport.btn_ok.pressed.connect(partial(self.generate_rapports, previous_dialog, self.dlg_psector_rapport, viewname))
        self.dlg_psector_rapport.btn_path.pressed.connect(partial(self.get_folder_dialog, self.dlg_psector_rapport.txt_path))
        #TODO abrir composer
        self.dlg_psector_rapport.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_psector_rapport.open()



    def set_prev_dialog(self, current_dialog, previous_dialog):
        """ Close current dialog and set previous dialog as current dialog"""
        self.close_dialog(current_dialog)
        utils_giswater.setDialog(previous_dialog)

    def generate_rapports(self, previous_dialog, dialog, viewname):
        folder_path = utils_giswater.getWidgetText(dialog.txt_path)
        if folder_path is None or folder_path == 'null' or not os.path.exists(folder_path):
            self.get_folder_dialog(dialog.txt_path)
            folder_path = utils_giswater.getWidgetText(dialog.txt_path)
        # Generate Composer
        if utils_giswater.isChecked(dialog.chk_composer):
            file_name = utils_giswater.getWidgetText('txt_composer_path')
            if file_name is None or file_name == 'null':
                msg = "Detail pdf file name is required"
                self.controller.show_warning(msg)
            if file_name.find('.pdf') == False:
                file_name = file_name + '.pdf'
            path = folder_path + '/' + file_name
            self.generate_composer(path)

        # Generate pdf
        if utils_giswater.isChecked(dialog.chk_pdf):
            file_name = utils_giswater.getWidgetText('txt_pdf_path')
            viewname = "v_"+self.psector_type+"_psector_budget"
            # viewname = "v_edit_node"
            if file_name is None or file_name == 'null':
                msg = "Detail pdf file name is required"
                self.controller.show_warning(msg)
            if file_name.find('.pdf') == False:
                file_name = file_name + '.pdf'
            path = folder_path + '/' + file_name

            self.generate_pdf(path, viewname)

        #Generate csv
        if utils_giswater.isChecked(dialog.chk_csv):
            file_name = utils_giswater.getWidgetText('txt_csv_path')
            if file_name is None or file_name == 'null':
                msg = "Price list csv file name is required"
                self.controller.show_warning(msg)
            if file_name.find('.csv') == False:
                file_name = file_name + '.csv'
            path = folder_path + '/' + file_name
            self.generate_csv(path, viewname, previous_dialog)


        self.set_prev_dialog(dialog, previous_dialog)


    def generate_composer(self, path):
        compView = self.iface.activeComposers()[0]
        myComp = compView.composition()
        if myComp is not None:
            myComp.setAtlasMode(QgsComposition.PreviewAtlas)
            result = myComp.exportAsPDF(path)
            if result:
                msg = "Document PDF generat a: " + path
                self.controller.log_info(str(msg))
                os.startfile(path)
            else:
                msg = "Document PDF no ha pogut ser generat a: " + path +". Comprova que no esta en us"
                self.controller.show_warning(str(msg))


    def generate_pdf(self, path, viewname):
        cur_layer = self.iface.activeLayer()
        layer = self.controller.get_layer_by_tablename(viewname)

        if layer is None:
            msg = "Layer " + viewname + " not found"
            self.controller.show_warning(msg)
            return
        self.iface.setActiveLayer(layer)


        mapRenderer = self.iface.mapCanvas().mapRenderer()
        c = QgsComposition(mapRenderer)
        c.setPlotStyle(QgsComposition.Print)

        x, y = 0, 0
        w, h = c.paperWidth(), c.paperHeight()
        composerMap = QgsComposerMap(c, x, y, w, h)

        table = QgsComposerAttributeTable(c)
        table.setMaximumNumberOfFeatures(layer.featureCount())
        table.setComposerMap(composerMap)

        table.setVectorLayer(layer)
        c.addItem(table)

        printer = QPrinter()
        printer.setOutputFormat(QPrinter.PdfFormat)
        printer.setOutputFileName(path)
        printer.setPaperSize(QSizeF(c.paperWidth(), c.paperHeight()), QPrinter.Millimeter)
        printer.setFullPage(True)

        pdfPainter = QPainter(printer)
        paperRectMM = printer.pageRect(QPrinter.Millimeter)
        paperRectPixel = printer.pageRect(QPrinter.DevicePixel)
        c.render(pdfPainter, paperRectPixel, paperRectMM)
        pdfPainter.end()

        self.iface.setActiveLayer(cur_layer)



    def generate_csv(self, path, viewname, previous_dialog):

        # Get columns name in order of the table
        sql = ("SELECT column_name FROM information_schema.columns WHERE table_name='" + "v_" + self.psector_type + "_psector' AND table_schema='"+self.schema_name.replace('"', '') +"' order by ordinal_position" )
        cabecera = self.controller.get_rows(sql)

        columns = []
        for i in range(0, len(cabecera)):
            column_name = cabecera[i]
            columns.append(str(column_name[0]))

        sql = ("SELECT * FROM "+self.schema_name+"." + viewname + " WHERE psector_id ='"+str(utils_giswater.getWidgetText(previous_dialog.psector_id)) +"'" )
        rows = self.controller.get_rows(sql)
        all_rows = []
        all_rows.append(columns)
        for i in rows:
            all_rows.append(i)

        #csvfile = utils_giswater.getWidgetText(dialog.txt_path) + '\\rapport.csv'
        with open(path, "w") as output:
            writer = csv.writer(output, lineterminator='\n')
            writer.writerows(all_rows)


    def populate_budget(self, psector_id):
        sql = ("SELECT DISTINCT(column_name) FROM information_schema.columns WHERE table_name='"+"v_" + self.psector_type + "_psector"+"'")
        rows = self.controller.get_rows(sql)
        columns = []
        for i in range(0, len(rows)):
            column_name = rows[i]
            columns.append(str(column_name[0]))

        sql = ("SELECT total_arc, total_node, total_other, pem, pec, pec_vat, gexpenses, vat, other, pca FROM " + self.schema_name + ".v_" + self.psector_type + "_psector")
        sql += " WHERE psector_id = '" + str(psector_id) + "'"
        row = self.controller.get_row(sql)

        if row is not None:
            for column_name in columns:
                if column_name in row:
                    if row[column_name] is not None:
                        utils_giswater.setText(column_name, row[column_name])
                    else:
                        utils_giswater.setText(column_name, 0)

        self.calc_pec_pem()
        self.calc_pecvat_pec()
        self.calc_pca_pecvat()


    def calc_pec_pem(self):
        if str(utils_giswater.getWidgetText('pec')) != 'null':
            pec = float(utils_giswater.getWidgetText('pec'))
        else:
            pec = 0
        if str(utils_giswater.getWidgetText('pem')) != 'null':
            pem = float(utils_giswater.getWidgetText('pem'))
        else:
            pem = 0
        res = pec - pem
        utils_giswater.setWidgetText('pec_pem', res)

    def calc_pecvat_pec(self):
        if str(utils_giswater.getWidgetText('pec_vat')) != 'null':
            pec_vat = float(utils_giswater.getWidgetText('pec_vat'))
        else:
            pec_vat = 0
        if str(utils_giswater.getWidgetText('pec')) != 'null':
            pec = float(utils_giswater.getWidgetText('pec'))
        else:
            pec = 0
        res = pec_vat - pec
        utils_giswater.setWidgetText('pecvat_pem', res)

    def calc_pca_pecvat(self):
        if str(utils_giswater.getWidgetText('pca')) != 'null':
            pca = float(utils_giswater.getWidgetText('pca'))
        else:
            pca = 0
        if str(utils_giswater.getWidgetText('pec_vat')) != 'null':
            pec_vat = float(utils_giswater.getWidgetText('pec_vat'))
        else:
            pec_vat = 0
        res = pca - pec_vat
        utils_giswater.setWidgetText('pca_pecvat', res)

    def calulate_percents(self, tablename, psector_id, field):
        sql = ("UPDATE " + self.schema_name + "." + tablename + " "
               " SET "+field+"='"+utils_giswater.getText(field)+"' "
               " WHERE psector_id='"+str(psector_id)+"'")
        self.controller.execute_sql(sql)
        self.populate_budget(psector_id)

    def show_description(self):
        """ Show description of product plan/om _psector as label"""
        index = self.dlg.all_rows.currentIndex()
        selected_list = self.dlg.all_rows.selectionModel().selectedRows()
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            des = self.dlg.all_rows.model().record(row).value('descript')
        utils_giswater.setText(self.lbl_descript, des)

    def double_validator(self, widget):
        validator = QDoubleValidator(-9999999, 99, 2)
        validator.setNotation(QDoubleValidator().StandardNotation)
        widget.setValidator(validator)

    def enable_tabs(self, enabled):
        self.dlg.tabWidget.setTabEnabled(1, enabled)
        self.dlg.tabWidget.setTabEnabled(2, enabled)
        self.dlg.tabWidget.setTabEnabled(3, enabled)


    def enable_buttons(self, enabled):
        self.dlg.btn_insert.setEnabled(enabled)
        self.dlg.btn_delete.setEnabled(enabled)
        self.dlg.btn_snapping.setEnabled(enabled)


    def insert_features(self, table_object, psector_type):
        """ Select feature with entered id. Set a model with selected filter.
            Attach that model to selected table
        """

        self.disconnect_signal_selection_changed()

        # Clear list of ids
        self.ids = []
        field_id = self.geom_type + "_id"

        feature_id = utils_giswater.getWidgetText("feature_id")
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
        self.insert_feature_to_plan(self.geom_type, psector_type)

        # Update list
        self.list_ids[self.geom_type] = self.ids

        self.connect_selection_changed(table_object, psector_type)

    def delete_record(self, table_object, psector_type):
        """ Delete selected elements of the table """

        self.disconnect_signal_selection_changed()

        widget_name = "tbl_" + table_object + "_x_" + self.geom_type
        widget = utils_giswater.getWidget(widget_name)
        if not widget:
            self.controller.show_warning("Widget not found", parameter=widget_name)
            return

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_info_box(message)
            return

        full_list = widget.model()
        for x in range(0, full_list.rowCount()):
            self.ids.append(widget.model().record(x).value(str(self.geom_type) + "_id"))

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
        answer = self.controller.ask_question(message, "Delete records", inf_text)
        if answer:
            for el in del_id:
                self.ids.remove(el)

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
        self.delete_feature_at_plan_psector(self.geom_type, list_id, psector_type)
        self.reload_qtable(self.geom_type, psector_type)


        # Select features with previous filter
        # Build a list of feature id's and select them
        for layer in self.layers[self.geom_type]:
            it = layer.getFeatures(QgsFeatureRequest(expr))
            id_list = [i.id() for i in it]
            if len(id_list) > 0:
                layer.selectByIds(id_list)

        # Update list
        self.list_ids[self.geom_type] = self.ids

        self.connect_selection_changed(table_object, psector_type)


    def delete_feature_at_plan_psector(self, geom_type, list_id, psector_type):
        """ Delete features_id to table plan_@geom_type_x_psector"""

        value = utils_giswater.getWidgetText(self.dlg.psector_id)
        sql = ("DELETE FROM " + self.schema_name + "."+psector_type+"_psector_x_"+geom_type+" "
               " WHERE " + geom_type + "_id IN (" + list_id + ") AND psector_id='" + str(value) + "'")
        self.controller.execute_sql(sql)
    def reload_qtable(self, geom_type, psector_type):
        """ Reload QtableView """
        value = utils_giswater.getWidgetText(self.dlg.psector_id)
        sql = ("SELECT * FROM " + self.schema_name + "."+psector_type+"_psector_x_"+geom_type+" "
               "WHERE psector_id='" + str(value) + "'")
        qtable = utils_giswater.getWidget('tbl_psector_x_' + geom_type)
        self.fill_table_by_query(qtable, sql)


    def init_selection(self, table_object, psector_type):
        """ Set canvas map tool to an instance of class 'MultipleSelection' """

        multiple_selection = MultipleSelection(self.iface, self.controller, self.layers[self.geom_type],
                                               parent_manage=self, table_object=table_object)
        self.canvas.setMapTool(multiple_selection)
        self.disconnect_signal_selection_changed()

        self.connect_selection_changed(table_object, psector_type)

        cursor = self.get_cursor_multiple_selection()
        self.canvas.setCursor(cursor)

    # def connect_selection_changed(self, table_object, psector_type):
    #     """ Connect signal selectionChanged """
    #
    #     try:
    #         self.canvas.selectionChanged.connect(partial(self.sel_changed, table_object, self.geom_type, psector_type))
    #     except Exception:
    #         pass

    # def sel_changed(self, table_object, geom_type, psector_type):
    #     """ Slot function for signal 'canvas.selectionChanged' """
    #     self.controller.log_info(str("TESST 10"))
    #     self.disconnect_signal_selection_changed()
    #
    #     field_id = geom_type + "_id"
    #     self.ids = []
    #
    #     # Iterate over all layers of the group
    #     for layer in self.layers[self.geom_type]:
    #         if layer.selectedFeatureCount() > 0:
    #             # Get selected features of the layer
    #             features = layer.selectedFeatures()
    #             for feature in features:
    #                 # Append 'feature_id' into the list
    #                 selected_id = feature.attribute(field_id)
    #                 if selected_id not in self.ids:
    #                     self.ids.append(selected_id)
    #
    #     if geom_type == 'arc':
    #         self.list_ids['arc'] = self.ids
    #     elif geom_type == 'node':
    #         self.list_ids['node'] = self.ids
    #     elif geom_type == 'connec':
    #         self.list_ids['connec'] = self.ids
    #     elif geom_type == 'gully':
    #         self.list_ids['gully'] = self.ids
    #     elif geom_type == 'element':
    #         self.list_ids['element'] = self.ids
    #
    #     expr_filter = None
    #     if len(self.ids) > 0:
    #         # Set 'expr_filter' with features that are in the list
    #         expr_filter = "\"" + field_id + "\" IN ("
    #         for i in range(len(self.ids)):
    #             expr_filter += "'" + str(self.ids[i]) + "', "
    #         expr_filter = expr_filter[:-2] + ")"
    #
    #         # Check expression
    #         (is_valid, expr) = self.check_expression(expr_filter)  # @UnusedVariable
    #         if not is_valid:
    #             return
    #
    #         self.select_features_by_ids(geom_type, expr, True)
    #
    #     # Reload contents of table 'tbl_@table_object_x_@geom_type'
    #     self.controller.log_info(str("TESST 100"))
    #     self.insert_feature_to_plan(self.geom_type, psector_type)
    #     self.reload_qtable(geom_type, psector_type)
    #
    #     # Remove selection in generic 'v_edit' layers
    #     self.remove_selection(False)
    #
    #     self.connect_selection_changed(table_object, psector_type)



    def enable_relation_tab(self, tablename):
        sql = ("SELECT name FROM " + self.schema_name + "." + tablename + " "
               " WHERE LOWER(name)='" + utils_giswater.getWidgetText(self.dlg.name) + "'")
        rows = self.controller.get_rows(sql)
        if not rows:
            if self.dlg.name.text() != '':
                self.enable_tabs(True)
            else:
                self.enable_tabs(False)
        else:
            self.enable_tabs(False)


    def delete_psector_selector(self, tablename):
        sql = ("DELETE FROM "+self.schema_name + "." + tablename + " "
               " WHERE cur_user = current_user")
        self.controller.execute_sql(sql)

    def insert_psector_selector(self, tablename, field, value):
        self.delete_psector_selector(tablename)
        sql = ("INSERT INTO "+self.schema_name + "." + tablename + " ("+field+", cur_user)"
               " VALUES ('" + str(value) + "', current_user)")

        self.controller.execute_sql(sql)


    def check_tab_position(self, update):
        self.dlg.name.setEnabled(False)

        if self.dlg.tabWidget.currentIndex() == 1 and utils_giswater.getWidgetText(self.dlg.psector_id) == 'null':
            self.insert_or_update_new_psector(update, tablename='v_edit_'+self.psector_type + '_psector', close_dlg=False)
        if self.dlg.tabWidget.currentIndex() == 2:
            tableleft = "v_price_compost"
            tableright = "v_edit_" + self.psector_type + "_psector_x_other"
            field_id_left = "id"
            field_id_right = "price_id"
            self.multi_row_selector(self.dlg, tableleft, tableright, field_id_left, field_id_right)
            self.update_total(self.dlg.selected_rows)
        if self.dlg.tabWidget.currentIndex() == 3:
            self.populate_budget(utils_giswater.getWidgetText('psector_id'))


        sql = ("SELECT other, gexpenses, vat FROM " + self.schema_name + "." + self.psector_type + "_psector "
               " WHERE psector_id='" + str(utils_giswater.getWidgetText('psector_id')) + "'")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(self.dlg.other, row[0])
            utils_giswater.setWidgetText(self.dlg.gexpenses, row[1])
            utils_giswater.setWidgetText(self.dlg.vat, row[2])

    def populate_result_id(self, combo, table_name):

        index = self.dlg.psector_type.itemData(self.dlg.psector_type.currentIndex())
        sql = ("SELECT result_type, name FROM " + self.schema_name + "." + table_name + " "
               "WHERE result_type = "+str(index[0]) + " ORDER BY name DESC")
        rows = self.controller.get_rows(sql)
        if not rows:
            return False

        records = []
        for row in rows:
            elem = [row[0], row[1]]
            records.append(elem)

        combo.blockSignals(True)
        combo.clear()

        records_sorted = sorted(records, key=operator.itemgetter(1))

        for record in records_sorted:
            combo.addItem(str(record[1]), record)
        combo.blockSignals(False)

    def populate_combos(self, combo, field, id, table_name, allow_nulls=True):
        sql = ("SELECT DISTINCT("+id+"), "+field+" FROM "+self.schema_name+"."+table_name+" ORDER BY "+field+"")
        rows = self.dao.get_rows(sql)
        combo.blockSignals(True)
        combo.clear()
        if allow_nulls:
            combo.addItem("", "")
        records_sorted = sorted(rows, key=operator.itemgetter(1))
        for record in records_sorted:
            combo.addItem(str(record[1]), record)
        combo.blockSignals(False)

    def reload_states_selector(self):
        self.delete_psector_selector('selector_state')
        for x in range(0, len(self.all_states)):
            sql = ("INSERT INTO "+self.schema_name + ".selector_state (state_id, cur_user)"
                   " VALUES ('"+str(self.all_states[x][0]) + "', current_user)")
            self.controller.execute_sql(sql)

    def close_psector(self, cur_active_layer=None):
        """ Close dialog and disconnect snapping """
        self.reload_states_selector()
        if cur_active_layer:
            self.iface.setActiveLayer(cur_active_layer)
        self.remove_selection(True)
        self.reset_model_psector("arc")
        self.reset_model_psector("node")
        self.reset_model_psector("other")
        self.close_dialog()
        self.hide_generic_layers()
        self.disconnect_snapping()
        self.disconnect_signal_selection_changed()

    def reset_model_psector(self, geom_type):
        """ Reset model of the widget """
        table_relation = "" + geom_type + "_plan"
        widget_name = "tbl_" + table_relation
        widget = utils_giswater.getWidget(widget_name)
        if widget:
            widget.setModel(None)


    def check_name(self):
        """ Check if name of new psector exist or not """
        exist = False
        sql =("SELECT name FROM "+ self.schema_name + "." + self.psector_type + "_psector "
              "WHERE name='"+utils_giswater.getWidgetText(self.dlg.name)+"'")
        row = self.controller.get_row(sql)
        if row:
            exist = True
        return exist


    def insert_or_update_new_psector(self, update, tablename, close_dlg=False):

        name_exist = self.check_name()
        if name_exist and not update:
            msg = "The name is current in use"
            self.controller.show_warning(msg)
            return
        else:
            self.enable_tabs(True)
            self.enable_buttons(True)
        # if name_exist and update:
        #     msg = "The name is current in use"
        #     self.controller.show_warning(msg)
        #     return
        #

        sql = ("SELECT column_name FROM information_schema.columns "
               " WHERE table_name='" + "v_edit_" + self.psector_type + "_psector' "
               " AND table_schema='" + self.schema_name.replace('"', '') + "' order by ordinal_position")
        rows = self.controller.get_rows(sql)

        columns = []
        for i in range(0, len(rows)):
            column_name = rows[i]
            columns.append(str(column_name[0]))

        if update:
            if columns is not None:
                sql = "UPDATE " + self.schema_name + "." + tablename + " SET "
                for column_name in columns:
                    if column_name != 'psector_id':
                        widget_type = utils_giswater.getWidgetType(column_name)
                        if widget_type is QCheckBox:
                            value = utils_giswater.isChecked(column_name)
                        elif widget_type is QDateEdit:
                            date = self.dlg.findChild(QDateEdit, str(column_name))
                            value = date.dateTime().toString('yyyy-MM-dd HH:mm:ss')
                        elif (widget_type is QComboBox) and (column_name == 'expl_id' or column_name == 'sector_id'
                              or column_name == 'result_id' or column_name == 'psector_type'):
                            combo = utils_giswater.getWidget(column_name)
                            elem = combo.itemData(combo.currentIndex())
                            value = str(elem[0])
                        else:
                            value = utils_giswater.getWidgetText(column_name)
                        if value is None or value == 'null':
                            sql += column_name + " = null, "
                        else:
                            if type(value) is not bool:
                                value = value.replace(",", ".")
                            sql += column_name + " = '" + str(value) + "', "

                sql = sql[:len(sql) - 2]
                sql += " WHERE psector_id = '" + utils_giswater.getWidgetText(self.psector_id) + "'"

        else:
            values = "VALUES("
            if columns is not None:
                sql = "INSERT INTO " + self.schema_name + "." + tablename + " ("
                for column_name in columns:
                    if column_name != 'psector_id':
                        widget_type = utils_giswater.getWidgetType(column_name)
                        if widget_type is not None:
                            if widget_type is QCheckBox:
                                value = str(utils_giswater.isChecked(column_name)).upper()
                            elif widget_type is QDateEdit:
                                date = self.dlg.findChild(QDateEdit, str(column_name))
                                values += date.dateTime().toString('yyyy-MM-dd HH:mm:ss') + ", "
                            elif (widget_type is QComboBox) and (column_name == 'expl_id' or column_name == 'sector_id' or column_name == 'result_id' or column_name == 'psector_type'):
                                combo = utils_giswater.getWidget(column_name)
                                elem = combo.itemData(combo.currentIndex())
                                value = str(elem[0])
                            else:
                                value = utils_giswater.getWidgetText(column_name)
                            if value is None or value == 'null':
                                sql += column_name + ", "
                                values += "null, "
                            else:
                                values += "'" + value + "', "
                                sql += column_name + ", "


                sql = sql[:len(sql) - 2] + ") "
                values = values[:len(values) - 2] + ")"
                sql += values

        if not update:
            sql += "RETURNING psector_id"

            new_psector_id = self.controller.execute_returning(sql, search_audit=False)
            utils_giswater.setText(self.dlg.psector_id, str(new_psector_id[0]))
        else:
            self.controller.execute_sql(sql)
        self.dlg.tabWidget.setTabEnabled(1, True)

        if self.psector_type == 'om':
            self.insert_psector_selector('om_psector_selector', 'psector_id', utils_giswater.getWidgetText(self.dlg.psector_id))
        else:
            self.insert_psector_selector('selector_psector', 'psector_id', utils_giswater.getWidgetText(self.dlg.psector_id))
        if close_dlg:
            self.reload_states_selector()
            self.close_dialog()


    def multi_row_selector(self, dialog, tableleft, tableright, field_id_left, field_id_right):

        # fill QTableView all_rows
        tbl_all_rows = dialog.findChild(QTableView, "all_rows")
        tbl_all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        query_left = "SELECT * FROM " + self.schema_name + "." + tableleft + " WHERE id NOT IN "
        query_left += "(SELECT price_id FROM " + self.schema_name + "." + tableleft
        query_left += " RIGHT JOIN " + self.schema_name + "." + tableright + " ON " + tableleft + "." + field_id_left + " = " + tableright + "." + field_id_right + "::text)"

        self.fill_table_by_query(tbl_all_rows, query_left)
        self.hide_colums(tbl_all_rows, [2, 3])
        tbl_all_rows.setColumnWidth(0, 175)
        tbl_all_rows.setColumnWidth(1, 115)
        tbl_all_rows.setColumnWidth(4, 115)

        # fill QTableView selected_rows
        tbl_selected_rows = dialog.findChild(QTableView, "selected_rows")
        tbl_selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        query_right = "SELECT "+tableright + ".unit, " +tableright + "."+field_id_right+", " + tableright + ".price, " + tableright + ".measurement, " + tableright + ".total_budget"
        query_right += " FROM " + self.schema_name + "." + tableleft
        query_right += " JOIN " + self.schema_name + "." + tableright + " ON " + tableleft + "." + field_id_left + " = " + tableright + "." + field_id_right + "::text"
        query_right += " WHERE psector_id='"+utils_giswater.getWidgetText('psector_id')+"'"

        self.fill_table(tbl_selected_rows, self.schema_name+".v_edit_" + self.psector_type + "_psector_x_other", True)
        self.hide_colums(tbl_selected_rows, [0, 1, 4, 8])
        tbl_selected_rows.setColumnWidth(2, 60)
        tbl_selected_rows.setColumnWidth(5, 60)
        tbl_selected_rows.setColumnWidth(7, 92)

        # Button select
        dialog.btn_select.pressed.connect(
            partial(self.multi_rows_selector, tbl_all_rows, tbl_selected_rows, 'id', tableright, "price_id",
                    query_left, query_right, 'id'))

        # Button unselect
        query_delete = "DELETE FROM " + self.schema_name + "." + tableright
        query_delete += " WHERE  " + tableright + "." + field_id_right + "="
        dialog.btn_unselect.pressed.connect(
            partial(self.unselector, tbl_all_rows, tbl_selected_rows, query_delete, query_left, query_right,
                    field_id_right))


    def multi_rows_selector(self, qtable_left, qtable_right, id_ori,
                            tablename_des, id_des, query_left, query_right, field_id):
        """
            :param qtable_left: QTableView origin
            :param qtable_right: QTableView destini
            :param id_ori: Refers to the id of the source table
            :param tablename_des: table destini
            :param id_des: Refers to the id of the target table, on which the query will be made
            :param query_right:
            :param query_left:
            :param field_id:
        """

        selected_list = qtable_left.selectionModel().selectedRows()

        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        expl_id = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = qtable_left.model().record(row).value(id_ori)
            expl_id.append(id_)

        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            values = ""
            psector_id = utils_giswater.getWidgetText('psector_id')
            values += "'" + str(psector_id) + "', "
            if qtable_left.model().record(row).value('unit') != None:
                values += "'" + str(qtable_left.model().record(row).value('unit')) + "', "
            else:
                values += 'null, '
            if qtable_left.model().record(row).value('id') != None:
                values += "'" + str(qtable_left.model().record(row).value('id')) + "', "
            else:
                values += 'null, '
            if qtable_left.model().record(row).value('description') != None:
                values += "'" + str(qtable_left.model().record(row).value('description')) + "', "
            else:
                values += 'null, '
            if qtable_left.model().record(row).value('price') != None:
                values += "'" + str(qtable_left.model().record(row).value('price')) + "', "
            else:
                values += 'null, '
            values = values[:len(values) - 2]
            # Check if expl_id already exists in expl_selector
            sql = ("SELECT DISTINCT(" + id_des + ")"
                   " FROM " + self.schema_name + "." + tablename_des + ""
                   " WHERE " + id_des + " = '" + str(expl_id[i]) + "'")
            row = self.controller.get_row(sql)
            if row:
                # if exist - show warning
                self.controller.show_info_box("Id " + str(expl_id[i]) + " is already selected!", "Info")
            else:
                sql = ("INSERT INTO " + self.schema_name + "." + tablename_des + " (psector_id, unit, price_id, descript, price) "
                       " VALUES (" +values+")")
                self.controller.execute_sql(sql)

        # Refresh
        self.fill_table(qtable_right, self.schema_name + ".v_edit_" + self.psector_type + "_psector_x_other", True)
        self.fill_table_by_query(qtable_left, query_left)


    def unselector(self, qtable_left, qtable_right, query_delete, query_left, query_right, field_id_right):

        selected_list = qtable_right.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        expl_id = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = str(qtable_right.model().record(row).value(field_id_right))
            expl_id.append(id_)
        for i in range(0, len(expl_id)):
            sql = (query_delete + "'" + str(expl_id[i]) + "' AND psector_id ='"+utils_giswater.getWidgetText('psector_id') +"'")
            self.controller.execute_sql(sql)

        # Refresh
        self.fill_table_by_query(qtable_left, query_left)
        self.fill_table(qtable_right, self.schema_name + ".v_edit_" + self.psector_type + "_psector_x_other", True)



    def query_like_widget_text(self, text_line, qtable, tableleft, tableright, field_id):
        """ Populate the QTableView by filtering through the QLineEdit"""
        query = utils_giswater.getWidgetText(text_line).lower()
        if query == 'null':
            query = ""
        sql = ("SELECT * FROM " + self.schema_name + "." + tableleft + " WHERE LOWER("+field_id+") "
               " LIKE '%"+query+"%' AND "+field_id+" NOT IN("
               " SELECT price_id FROM " + self.schema_name + "." + tableright + " "
               " WHERE psector_id='"+utils_giswater.getWidgetText('psector_id') + "')")
        self.fill_table_by_query(qtable, sql)


    def fill_table_by_query(self, qtable, query):
        """
        :param qtable: QTableView to show
        :param query: query to set model
        """

        model = QSqlQueryModel()
        model.setQuery(query)
        qtable.setModel(model)
        qtable.show()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

    def fill_table(self, widget, table_name, hidde=False):
        """ Set a model with selected filter.
        Attach that model to selected table
        @setEditStrategy:
            0: OnFieldChange
            1: OnRowChange
            2: OnManualSubmit
        """

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnFieldChange)
        model.setSort(0, 0)
        model.select()
        # When change some field we need to refresh Qtableview and filter by psector_id
        model.dataChanged.connect(partial(self.refresh_table, widget))
        model.dataChanged.connect(partial(self.update_total, widget))

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())
        # Attach model to table view
        widget.setModel(model)

        if hidde:
            self.refresh_table(widget)

    def refresh_table(self, widget):
        """ Refresh qTableView 'selected_rows' """
        widget.selectAll()
        selected_list = widget.selectionModel().selectedRows()
        widget.clearSelection()
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            if str(widget.model().record(row).value('psector_id')) != utils_giswater.getWidgetText('psector_id'):
                widget.hideRow(i)

