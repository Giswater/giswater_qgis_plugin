/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2022/03/02

-- TAB CONNECTIONS 
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_connection_1', 'lyt_connection_1','lytConnection1');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_connection_2', 'lyt_connection_2','lytConnection2');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_connection_3', 'lyt_connection_3','lytConnection3');

INSERT INTO config_form_list(listname, query_text, device)
    VALUES ('tbl_connection_upstream', 'SELECT * FROM v_ui_node_x_connection_upstream WHERE rid IS NOT NULL', 4);
INSERT INTO config_form_list(listname, query_text, device)
    VALUES ('tbl_connection_downstream', 'SELECT * FROM v_ui_node_x_connection_downstream WHERE rid IS NOT NULL', 4);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('node', 'form_feature', 'connection', 'tbl_upstream', 'lyt_connection_2', 1, 'tableview', 'Upstream features:', false, false, false, false, false, '{"saveValue": false, "labelPosition": "top"}', '{"functionName": "open_selected_feature", "module": "info", "parameters":{"columnfind":"feature_id", "tablefind":"sys_table_id"}}', 'tbl_connection_upstream');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('node', 'form_feature', 'connection', 'tbl_downstream', 'lyt_connection_3', 1, 'tableview', 'Downstream features:', false, false, false, false, false, '{"saveValue": false, "labelPosition": "top"}', '{"functionName": "open_selected_feature", "module": "info", "parameters":{"columnfind":"feature_id", "tablefind":"sys_table_id"}}', 'tbl_connection_downstream');
