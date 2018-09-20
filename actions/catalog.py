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
    from PyQt4.QtCore import Qt
    from PyQt4.QtGui import QLineEdit
else:
    from qgis.PyQt.QtCore import Qt
    from qgis.PyQt.QtWidgets import QLineEdit
    
import os
from functools import partial

import utils_giswater
from ui_manager import Multirow_selector
from ui_manager import WScatalog
from ui_manager import UDcatalog
from parent import ParentAction


class Catalog(ParentAction):
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'basic' """
        self.minor_version = "3.0"
        self.search_plus = None
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)


    def catalog(self,  previous_dialog, widget_name, wsoftware, geom_type, node_type=None):



        # Get key
        layer = self.iface.activeLayer()
        viewname = self.controller.get_layer_source_table_name(layer)
        viewname = 'v_edit_man_junction'
        sql = ("SELECT id FROM " + self.schema_name + ".sys_feature_cat"
               " WHERE tablename = '" + str(viewname) + "'")
        row = self.controller.get_row(sql, log_sql= True)
        self.controller.log_info(str(row))
        self.sys_type = str(row[0])

        # Set dialog depending water software
        if wsoftware == 'ws':
            self.dlg_cat = WScatalog()
            self.field2 = 'pnom'
            self.field3 = 'dnom'
        elif wsoftware == 'ud':
            self.dlg_cat = UDcatalog()
            self.field2 = 'shape'
            self.field3 = 'geom1'

        self.dlg_cat.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_cat.open()

        self.dlg_cat.btn_ok.clicked.connect(partial(self.fill_geomcat_id, previous_dialog, widget_name))
        self.dlg_cat.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_cat))
        self.dlg_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))
        self.dlg_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_filter2, wsoftware, geom_type))
        self.dlg_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_filter3, wsoftware, geom_type))
        self.dlg_cat.filter2.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))
        self.dlg_cat.filter2.currentIndexChanged.connect(partial(self.fill_filter3, wsoftware, geom_type))
        self.dlg_cat.filter3.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))

        self.node_type_text = None
        if wsoftware == 'ws' and geom_type == 'node':
            self.node_type_text = node_type
        sql = "SELECT DISTINCT(matcat_id) AS matcat_id "
        sql += " FROM " + self.schema_name + ".cat_" + geom_type
        if wsoftware == 'ws' and geom_type == 'node':
            sql += " WHERE " + geom_type + "type_id IN"
            sql += " (SELECT DISTINCT (id) AS id FROM " + self.schema_name+"."+geom_type+"_type"
            sql += " WHERE type = '" + str(self.sys_type) + "')"
        sql += " ORDER BY matcat_id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat, self.dlg_cat.matcat_id, rows)

        sql = "SELECT DISTINCT(" + self.field2 + ")"
        sql += " FROM " + self.schema_name + ".cat_" + geom_type
        if wsoftware == 'ws' and geom_type == 'node':
            sql += " WHERE " + geom_type + "type_id IN"
            sql += " (SELECT DISTINCT (id) AS id FROM " + self.schema_name+"."+geom_type+"_type"
            sql += " WHERE type = '" + str(self.sys_type) + "')"
        sql += " ORDER BY "+self.field2
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat, self.dlg_cat.filter2, rows)

        if wsoftware == 'ws':
            if geom_type == 'node':
                sql = "SELECT "+self.field3
                sql += " FROM (SELECT DISTINCT(regexp_replace(trim(' nm' FROM "+self.field3+"), '-', '', 'g')::int) as x, "+self.field3
                sql += " FROM "+self.schema_name+".cat_"+geom_type+" WHERE "+self.field2 + " LIKE '%"+self.dlg_cat.filter2.currentText()+"%' "
                sql += " AND matcat_id LIKE '%"+self.dlg_cat.matcat_id.currentText()+"%' AND "+geom_type+"type_id IN "
                sql += "(SELECT id FROM "+self.schema_name+"."+geom_type+"_type WHERE type LIKE '%" + str(self.sys_type) + "%')"
                sql += " ORDER BY x) AS "+self.field3
            elif geom_type == 'arc':
                sql = "SELECT DISTINCT("+self.field3+"), (trim('mm' from "+self.field3+")::int) AS x, "+self.field3
                sql += " FROM "+self.schema_name+".cat_"+geom_type+" ORDER BY x"
            elif geom_type == 'connec':
                sql = "SELECT DISTINCT(TRIM(TRAILING ' ' from "+self.field3+")) AS "+self.field3
                sql += " FROM "+self.schema_name+".cat_"+geom_type+" ORDER BY "+self.field3
        else:
            if geom_type == 'node':
                sql = "SELECT DISTINCT("+self.field3+") AS "+self.field3
                sql += " FROM "+self.schema_name+".cat_"+geom_type
                sql += " ORDER BY "+self.field3
            elif geom_type == 'arc':
                sql = "SELECT DISTINCT("+self.field3+") "
                sql += " FROM "+self.schema_name+".cat_"+geom_type+" ORDER BY " + self.field3
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat, self.dlg_cat.filter3, rows)
        self.fill_catalog_id(wsoftware, geom_type)

    def fill_geomcat_id(self,  previous_dialog, widget_name):

        catalog_id = utils_giswater.getWidgetText(self.dlg_cat, self.dlg_cat.id)
        widget = previous_dialog.findChild(QLineEdit, widget_name)
        if widget:
            widget.setText(catalog_id)
            widget.setFocus()
        else:
            msg = ("Widget not found: " + str(widget_name))
            self.controller.show_message(msg, 2)
        self.close_dialog(self.dlg_cat)

        # if geom_type == 'node':
        #     utils_giswater.setWidgetText(widget_to_set, catalog_id)
        # elif geom_type == 'arc':
        #     utils_giswater.setWidgetText(widget_to_set, catalog_id)
        # else:
        #     utils_giswater.setWidgetText(widget_to_set, catalog_id)

    def fill_catalog_id(self, wsoftware, geom_type):

        # Set SQL query
        sql_where = None
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".cat_" + geom_type

        if wsoftware == 'ws':
            sql_where = (" WHERE " + geom_type + "type_id IN"
                         " (SELECT DISTINCT (id) FROM " + self.schema_name + "." + geom_type + "_type"
                         " WHERE type = '" + str(self.sys_type) + "')")

        if self.dlg_cat.matcat_id.currentText() != 'null':
            if sql_where is None:
                sql_where = " WHERE "
            else:
                sql_where += " AND "
            sql_where += " (matcat_id LIKE '%" + self.dlg_cat.matcat_id.currentText() + "%' or matcat_id is null)"

        if self.dlg_cat.filter2.currentText() != 'null':
            if sql_where is None:
                sql_where = " WHERE "
            else:
                sql_where += " AND "
            sql_where += ("(" + self.field2 + " LIKE '%" + self.dlg_cat.filter2.currentText() + ""
                                                                                                "%' OR " + self.field2 + " is null)")

        if self.dlg_cat.filter3.currentText() != 'null':
            if sql_where is None:
                sql_where = " WHERE "
            else:
                sql_where += " AND "
            sql_where += ("(" + self.field3 + "::text LIKE '%" + self.dlg_cat.filter3.currentText() + ""
                          "%' OR " + self.field3 + " is null)")

        if sql_where is not None:
            sql += str(sql_where) + " ORDER BY id"
        else:
            sql += " ORDER BY id"

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat, self.dlg_cat.id, rows)

    def fill_filter2(self, wsoftware, geom_type):

        # Get values from filters
        mats = utils_giswater.getWidgetText(self.dlg_cat, self.dlg_cat.matcat_id)

        # Set SQL query
        sql_where = None
        sql = "SELECT DISTINCT(" + self.field2 + ")"
        sql += " FROM " + self.schema_name + ".cat_" + geom_type

        # Build SQL filter
        if mats != "null":
            if sql_where is None:
                sql_where = " WHERE "
            sql_where += " matcat_id = '" + mats + "'"
        if wsoftware == 'ws':
            if sql_where is None:
                sql_where = " WHERE "
            else:
                sql_where += " AND "
            sql_where += geom_type + "type_id IN (SELECT DISTINCT (id) AS id FROM " + self.schema_name + "." + geom_type + "_type "
            sql_where += " WHERE type = '" + str(self.sys_type) + "')"
        if sql_where is not None:
            sql += str(sql_where) + " ORDER BY " + str(self.field2)
        else:
            sql += " ORDER BY " + str(self.field2)

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat, self.dlg_cat.filter2, rows)
        self.fill_filter3(wsoftware, geom_type)

    def fill_filter3(self, wsoftware, geom_type):

        if wsoftware == 'ws':
            if geom_type == 'node':
                sql = "SELECT " + self.field3
                sql += " FROM (SELECT DISTINCT(regexp_replace(trim(' nm' FROM " + self.field3 + "), '-', '', 'g')::int) as x, " + self.field3
                sql += " FROM " + self.schema_name + ".cat_" + geom_type
                sql += " WHERE (" + self.field2 + " LIKE '%" + self.dlg_cat.filter2.currentText() + "%' OR " + self.field2 + " is null) "
                sql += " AND (matcat_id LIKE '%" + self.dlg_cat.matcat_id.currentText() + "%' OR matcat_id is null)"
                sql += " AND " + geom_type + "type_id IN "
                sql += "(SELECT id FROM " + self.schema_name + "." + geom_type + "_type WHERE type LIKE '%" + str(
                    self.sys_type) + "%')"
                sql += " ORDER BY x) AS " + self.field3
            elif geom_type == 'arc':
                sql = "SELECT " + self.field3
                sql += " FROM (SELECT DISTINCT(regexp_replace(trim(' nm' FROM " + self.field3 + "), '-', '', 'g')::int) as x, " + self.field3
                sql += " FROM " + self.schema_name + ".cat_" + geom_type
                sql += " WHERE " + geom_type + "type_id IN "
                sql += "(SELECT id FROM " + self.schema_name + "." + geom_type + "_type WHERE type LIKE '%" + str(
                    self.sys_type) + "%')"
                sql += " AND (" + self.field2 + " LIKE '%" + self.dlg_cat.filter2.currentText() + "%' OR " + self.field2 + " is null) "
                sql += " AND (matcat_id LIKE '%" + self.dlg_cat.matcat_id.currentText() + "%' OR matcat_id is null)"
                sql += " ORDER BY x) AS " + self.field3
            elif geom_type == 'connec':
                sql = "SELECT DISTINCT(TRIM(TRAILING ' ' from " + self.field3 + ")) AS " + self.field3
                sql += " FROM " + self.schema_name + ".cat_" + geom_type + " ORDER BY " + self.field3
        else:
            if geom_type == 'node' or geom_type == 'arc':
                sql = "SELECT DISTINCT(" + self.field3 + ") FROM " + self.schema_name + ".cat_" + geom_type
                sql += " WHERE (matcat_id LIKE '%" + self.dlg_cat.matcat_id.currentText() + "%' OR matcat_id is null) "
                sql += " AND (" + self.field2 + " LIKE '%" + self.dlg_cat.filter2.currentText() + "%' OR " + self.field2 + " is null) "
                sql += " ORDER BY " + self.field3

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat, self.dlg_cat.filter3, rows)
        self.fill_catalog_id(wsoftware, geom_type)



