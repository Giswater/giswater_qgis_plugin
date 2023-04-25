/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3212, 'gw_trg_edit_ve_epa', 'utils', 'function trigger', NULL, NULL, 'Allows editing ve_epa views', 'role_epa', NULL, 'core')
ON CONFLICT (id) DO NOTHING;


INSERT INTO config_typevalue VALUES('widgettype_typevalue', 'hspacer', 'hspacer','hSpacer');
INSERT INTO config_typevalue VALUES('widgettype_typevalue', 'vspacer', 'vspacer','vSpacer');
INSERT INTO config_typevalue VALUES('widgettype_typevalue', 'tableview', 'tableview','tableview');


INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_epa_1', 'lyt_epa_1','lytEpa1');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_epa_data_1', 'lyt_epa_data_1','lytEpaData1');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_epa_data_2', 'lyt_epa_data_2','lytEpaData2');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_epa_3', 'lyt_epa_3','lytEpa3');

INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_element_1', 'lyt_element_1','lytElements1');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_element_2', 'lyt_element_2','lytElements2');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_element_3', 'lyt_element_3','lytElements3');


--ELEMENT ARC
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
VALUES ('tbl_element_x_arc', 'SELECT id as sys_id, * FROM v_ui_element_x_arc WHERE id IS NOT NULL', 4, 'tab', 'list');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('arc', 'form_feature', 'element', 'tbl_elements', 'lyt_element_2', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_selected_element", "module": "info", "parameters":{"columnfind":"element_id"}}', 'tbl_element_x_arc', 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
VALUES ('arc', 'form_feature', 'element', 'hspacer_lyt_element', 'lyt_element_1', 10, 'hspacer', false, false, true, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter, web_layoutorder)
VALUES ('arc', 'form_feature', 'element', 'element_id', 'lyt_element_1', 1, 'string', 'typeahead', 'Element id:', 'Element id', false, false, true, false, 'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ','{"saveValue": false, "filterSign":"ILIKE"}', '{"functionName": "filter_table"}', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('arc', 'form_feature', 'element', 'insert_element', 'lyt_element_1', 3, 'button', 'Insert element', false, false, true, false,  '{"icon":"111b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "add_object", "parameters":{"sourcewidget":"element_element_id", "targetwidget":"element_tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_arc');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('arc', 'form_feature', 'element', 'delete_element', 'lyt_element_1', 4, 'button', 'Delete element', false, false, true, false,  '{"icon":"112b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "delete_object", "parameters":{"columnfind":"feature_id", "targetwidget":"element_tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_arc');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('arc', 'form_feature', 'element', 'new_element', 'lyt_element_1', 5, 'button', 'New element', false, false, true, false,  '{"icon":"131b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "manage_element", "module": "info", "parameters":{"sourcewidget":"element_element_id", "targetwidget":"element_tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_arc');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('arc', 'form_feature', 'element', 'open_element', 'lyt_element_1', 11, 'button', 'Open element', false, false, true, false,  '{"icon":"134b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_selected_element", "module": "info", "parameters":{"columnfind":"element_id", "targetwidget":"element_tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_arc');

--ELEMENT NODE
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
VALUES ('tbl_element_x_node', 'SELECT id as sys_id, * FROM v_ui_element_x_node WHERE id IS NOT NULL', 4, 'tab', 'list');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('node', 'form_feature', 'element', 'tbl_elements', 'lyt_element_2', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_selected_element", "module": "info", "parameters":{"columnfind":"element_id"}}', 'tbl_element_x_node', 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
VALUES ('node', 'form_feature', 'element', 'hspacer_lyt_element', 'lyt_element_1', 10, 'hspacer', false, false, true, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter, web_layoutorder)
VALUES ('node', 'form_feature', 'element', 'element_id', 'lyt_element_1', 1, 'string', 'typeahead', 'Element id:', 'Element id', false, false, true, false, 'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ','{"saveValue": false, "filterSign":"ILIKE"}', '{"functionName": "filter_table"}', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('node', 'form_feature', 'element', 'insert_element', 'lyt_element_1', 3, 'button', 'Insert element', false, false, true, false,  '{"icon":"111b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "add_object", "parameters":{"sourcewidget":"element_element_id", "targetwidget":"element_tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_node');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('node', 'form_feature', 'element', 'delete_element', 'lyt_element_1', 4, 'button', 'Delete element', false, false, true, false,  '{"icon":"112b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "delete_object", "parameters":{"columnfind":"feature_id", "targetwidget":"element_tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_node');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('node', 'form_feature', 'element', 'new_element', 'lyt_element_1', 5, 'button', 'New element', false, false, true, false,  '{"icon":"131b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "manage_element", "module": "info", "parameters":{"sourcewidget":"element_element_id", "targetwidget":"element_tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_node');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('node', 'form_feature', 'element', 'open_element', 'lyt_element_1', 11, 'button', 'Open element', false, false, true, false,  '{"icon":"134b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_selected_element", "module": "info", "parameters":{"columnfind":"element_id", "targetwidget":"element_tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_node');

--ELEMENT CONNEC
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
VALUES ('tbl_element_x_connec', 'SELECT id as sys_id, * FROM v_ui_element_x_connec WHERE id IS NOT NULL', 4, 'tab', 'list');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('connec', 'form_feature', 'element', 'tbl_elements', 'lyt_element_2', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_selected_element", "module": "info", "parameters":{"columnfind":"element_id"}}', 'tbl_element_x_connec', 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
VALUES ('connec', 'form_feature', 'element', 'hspacer_lyt_element', 'lyt_element_1', 10, 'hspacer', false, false, true, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter, web_layoutorder)
VALUES ('connec', 'form_feature', 'element', 'element_id', 'lyt_element_1', 1, 'string', 'typeahead', 'Element id:', 'Element id', false, false, true, false, 'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ','{"saveValue": false, "filterSign":"ILIKE"}', '{"functionName": "filter_table"}', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('connec', 'form_feature', 'element', 'insert_element', 'lyt_element_1', 3, 'button', 'Insert element', false, false, true, false,  '{"icon":"111b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "add_object", "parameters":{"sourcewidget":"element_element_id", "targetwidget":"element_tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_connec');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('connec', 'form_feature', 'element', 'delete_element', 'lyt_element_1', 4, 'button', 'Delete element', false, false, true, false,  '{"icon":"112b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "delete_object", "parameters":{"columnfind":"feature_id", "targetwidget":"element_tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_connec');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('connec', 'form_feature', 'element', 'new_element', 'lyt_element_1', 5, 'button', 'New element', false, false, true, false,  '{"icon":"131b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "manage_element", "module": "info", "parameters":{"sourcewidget":"element_element_id", "targetwidget":"element_tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_connec');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('connec', 'form_feature', 'element', 'open_element', 'lyt_element_1', 11, 'button', 'Open element', false, false, true, false,  '{"icon":"134b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_selected_element", "module": "info", "parameters":{"columnfind":"element_id", "targetwidget":"element_tbl_elements", "sourceview":"element"}}', false, 'tbl_element_x_connec');

--RELATIONS
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_relation_1', 'lyt_relation_1','lytRelations1');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_relation_2', 'lyt_relation_2','lytRelations2');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_relation_3', 'lyt_relation_3','lytRelations3');
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
VALUES ('tbl_relations', 'SELECT rid as sys_id, * FROM v_ui_arc_x_relations WHERE rid IS NOT NULL', 4, 'tab', 'list');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject, web_layoutorder)
VALUES ('arc', 'form_feature', 'relation', 'tbl_relations', 'lyt_relation_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}','{"functionName": "open_selected_feature", "module": "info", "parameters":{"columnfind":"feature_id", "tablefind":"sys_table_id"}}', false, 'tbl_relations', 1);


-- TAB VISIT
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_visit_1', 'lyt_visit_1','lytVisits1');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_visit_2', 'lyt_visit_2','lytVisits2');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_visit_3', 'lyt_visit_3','lytVisits3');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetfunction, linkedobject, web_layoutorder)
VALUES ('arc', 'form_feature', 'visit', 'date_visit_from', 'lyt_visit_1', 1, 'date', 'datetime',  'From:', false, false, true, false, true,  '{"functionName": "filter_table", "parameters":{}}', 'tbl_doc_x_arc', 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetfunction, linkedobject, web_layoutorder)
VALUES ('arc', 'form_feature', 'visit', 'date_visit_to', 'lyt_visit_1', 2, 'date', 'datetime',  'To:', false, false, true, false, true, '{"functionName": "filter_table", "parameters":{}}', 'tbl_doc_x_arc', 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetfunction, linkedobject, web_layoutorder)
VALUES ('arc', 'form_feature', 'visit', 'visit_class', 'lyt_visit_1', 3, 'string', 'combo',  'Visit class:', false, false, true, false, true, 'SELECT id as id, id as idval FROM config_visit_class WHERE feature_type IN (''ARC'',''ALL'') ', True, '{"functionName": "filter_table", "parameters":{}}', 'tbl_visit_x_arc', 3);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
VALUES ('arc', 'form_feature', 'visit', 'hspacer_lyt_document_1', 'lyt_visit_2', 1, 'hspacer', false, false, true, false);
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('arc', 'form_feature', 'visit', 'open_gallery', 'lyt_visit_2', 2, 'button', 'Open gallery', false, false, true, false,  '{"icon":"136b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_visit_files", "module": "info", "parameters":{"targetwidget":"visit_tbl_visits"}}', false, 'tbl_visit_x_arc');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('arc', 'form_feature', 'visit', 'tbl_visits', 'lyt_visit_3', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_selected_path", "parameters":{"columnfind":"path"}}', 'tbl_visit_x_arc', 4);


-- TAB HYDROMETER
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_hydrometer_1', 'lyt_hydrometer_1','lytHydrometer1');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_hydrometer_2', 'lyt_hydrometer_2','lytHydrometer2');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_hydrometer_3', 'lyt_hydrometer_3','lytHydrometer3');

INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_hydrometer', 'SELECT * FROM v_ui_hydrometer WHERE hydrometer_id IS NOT NULL', 4, 'tab', 'list');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter, linkedobject, web_layoutorder)
    VALUES ('connec', 'form_feature', 'hydrometer', 'hydrometer_id', 'lyt_hydrometer_1', 1, 'string', 'text', '', 'Hydrometer id', false, false, true, false, '','{"saveValue": false, "filterSign":"ILIKE"}', '{"functionName": "filter_table", "parameters": {"columnfind": "hydrometer_customer_code"}}', true, 'v_ui_hydrometer', 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('connec', 'form_feature', 'hydrometer', 'hspacer_lyt_hydrometer_1', 'lyt_hydrometer_1', 10, 'hspacer', false, false, true, false);
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('connec', 'form_feature', 'hydrometer', 'btn_link', 'lyt_hydrometer_1', 11, 'button', 'Open link', false, false, true, false,  '{"icon":"70", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_selected_path", "parameters":{"targetwidget":"hydrometer_tbl_hydrometer", "columnfind": "hydrometer_link"}}', false, 'v_ui_hydrometer');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
    VALUES ('connec', 'form_feature', 'hydrometer', 'tbl_hydrometer', 'lyt_hydrometer_3', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_selected_hydro", "module": "info", "parameters":{}}', 'v_ui_hydrometer', 2);


-- TAB HYDROMETER VALUES
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_hydro_val_1', 'lyt_hydro_val_1','lytHydroVal1');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_hydro_val_2', 'lyt_hydro_val_2','lytHydroVal2');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_hydro_val_3', 'lyt_hydro_val_3','lytHydroVal3');

INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_hydrometer_value', 'SELECT * FROM v_ui_hydroval_x_connec WHERE hydrometer_id IS NOT NULL', 4, 'tab', 'list');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetfunction, linkedobject, web_layoutorder)
    VALUES ('connec', 'form_feature', 'hydro_val', 'cat_period_id', 'lyt_hydro_val_1', 0, 'string', 'combo', 'Cat period filter:', false, false, true, false, true, 'SELECT DISTINCT(t1.id) as id, t2.cat_period_id as idval FROM ext_cat_period AS t1 JOIN (SELECT * FROM v_ui_hydroval_x_connec) AS t2 on t1.id = t2.cat_period_id ', True, '{"functionName": "filter_table", "parameters":{}}', 'tbl_hydrometer_value', 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetfunction, linkedobject, web_layoutorder)
    VALUES ('connec', 'form_feature', 'hydro_val', 'hydrometer_id', 'lyt_hydro_val_1', 2, 'string', 'combo', 'Customer code:', false, false, true, false, true, 'SELECT hydrometer_id as id, hydrometer_customer_code as idval FROM v_rtc_hydrometer ', True, '{"functionName": "filter_table", "parameters":{}}', 'tbl_hydrometer_value', 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('connec', 'form_feature', 'hydro_val', 'hspacer_lyt_hydro_val_1', 'lyt_hydro_val_1', 10, 'hspacer', false, false, true, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
    VALUES ('connec', 'form_feature', 'hydro_val', 'tbl_hydrometer_value', 'lyt_hydro_val_3', 1, 'tableview', false, false, true, false, false, '{"saveValue": false}', NULL, 'tbl_hydrometer_value', 3);


-- TAB EVENT ARC
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_event_1', 'lyt_event_1','lytEvents1');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_event_2', 'lyt_event_2','lytEvents2');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_event_3', 'lyt_event_3','lytEvents3');

INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
VALUES ('tbl_visit_x_arc', 'SELECT * FROM v_ui_event_x_arc WHERE event_id IS NOT NULL', 4, 'tab', 'list');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('arc', 'form_feature', 'event', 'date_event_from', 'lyt_event_1', 1, 'date', 'datetime',  'From:', false, false, true, false, true, '{"labelPosition": "top"}', '{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}', 'tbl_visit_x_arc', 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('arc', 'form_feature', 'event', 'date_event_to', 'lyt_event_1', 2, 'date', 'datetime',  'To:', false, false, true, false, true, '{"labelPosition": "top"}', '{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}', 'tbl_visit_x_arc', 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('arc', 'form_feature', 'event', 'parameter_type', 'lyt_event_1', 3, 'string', 'combo',  'Parameter type:', false, false, true, false, true, 'SELECT DISTINCT parameter_type as id, parameter_type as idval FROM config_visit_parameter WHERE feature_type IN (''ARC'', ''ALL'') ', True, '{"labelPosition": "top"}', '{"functionName": "filter_table", "parameters":{}}', 'tbl_visit_x_arc', 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('arc', 'form_feature', 'event', 'parameter_id', 'lyt_event_1', 4, 'string', 'combo',  'Parameter:', false, false, true, false, true, 'SELECT id as id, id as idval FROM config_visit_parameter WHERE feature_type IN (''ARC'', ''ALL'') ', True, '{"labelPosition": "top"}', '{"functionName": "filter_table", "parameters":{}}', 'tbl_visit_x_arc', 4);

INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('arc', 'form_feature', 'event', 'btn_open_visit', 'lyt_event_2', 1, 'button', 'Open visit', false, false, true, false, '{"icon":"65", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_visit_manager", "parameters":{"columnfind": "visit_id", "targetwidget": "event_tbl_event_cf", "sourceview": "event"}}', false, 'tbl_visit_x_arc');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('arc', 'form_feature', 'event', 'btn_new_visit', 'lyt_event_2', 2, 'button', 'New visit', false, false, true, false, '{"icon":"64", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "new_visit", "module": "info", "parameters":{}}', false, 'tbl_visit_x_arc');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
VALUES ('arc', 'form_feature', 'event', 'hspacer_event_1', 'lyt_event_2', 10, 'hspacer', false, false, true, false);
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetfunction, isfilter, linkedobject)
VALUES ('arc', 'form_feature', 'event', 'btn_open_gallery', 'lyt_event_2', 11, 'button', 'Open gallery', false, false, true, false, '{"icon":"136b", "size":"24x24"}', '{"functionName": "open_gallery", "module": "info", "parameters":{"targetwidget":"event_tbl_event_cf", "columnfind": ["visit_id", "event_id"], "sourceview":"visit"}}', false, 'tbl_visit_x_arc');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('arc', 'form_feature', 'event', 'btn_open_visit_doc', 'lyt_event_2', 12, 'button', 'Open visit document', false, false, true, false, '{"icon":"170b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_visit_document", "module": "info", "parameters":{"targetwidget": "event_tbl_event_cf", "columnfind": "visit_id"}}', false, 'tbl_visit_x_arc');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('arc', 'form_feature', 'event', 'btn_open_visit_event', 'lyt_event_2', 13, 'button', 'Open visit event', false, false, true, false, '{"icon":"134b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_visit_event", "module": "info", "parameters":{"targetwidget": "event_tbl_event_cf", "columnfind":["visit_id", "event_id"]}}', false, 'tbl_visit_x_arc');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('arc', 'form_feature', 'event', 'tbl_event_cf', 'lyt_event_3', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_visit_event", "module": "info", "parameters":{"columnfind":["visit_id", "event_id"]}}', 'tbl_visit_x_arc', 5);

-- TAB EVENT NODE
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
VALUES ('tbl_visit_x_node', 'SELECT * FROM v_ui_event_x_node WHERE event_id IS NOT NULL', 4, 'tab', 'list');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('node', 'form_feature', 'event', 'date_event_from', 'lyt_event_1', 1, 'date', 'datetime',  'From:', false, false, true, false, true, '{"labelPosition": "top"}', '{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}', 'tbl_visit_x_node', 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('node', 'form_feature', 'event', 'date_event_to', 'lyt_event_1', 2, 'date', 'datetime',  'To:', false, false, true, false, true, '{"labelPosition": "top"}', '{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}', 'tbl_visit_x_node', 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('node', 'form_feature', 'event', 'parameter_type', 'lyt_event_1', 3, 'string', 'combo',  'Parameter type:', false, false, true, false, true, 'SELECT DISTINCT parameter_type as id, parameter_type as idval FROM config_visit_parameter WHERE feature_type IN (''NODE'', ''ALL'') ', True, '{"labelPosition": "top"}', '{"functionName": "filter_table", "parameters":{}}', 'tbl_visit_x_node', 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('node', 'form_feature', 'event', 'parameter_id', 'lyt_event_1', 4, 'string', 'combo',  'Parameter:', false, false, true, false, true, 'SELECT id as id, id as idval FROM config_visit_parameter WHERE feature_type IN (''NODE'', ''ALL'') ', True, '{"labelPosition": "top"}', '{"functionName": "filter_table", "parameters":{}}', 'tbl_visit_x_node', 4);

INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('node', 'form_feature', 'event', 'btn_open_visit', 'lyt_event_2', 1, 'button', 'Open visit', false, false, true, false, '{"icon":"65", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_visit_manager", "parameters":{"columnfind": "visit_id", "targetwidget": "event_tbl_event_cf", "sourceview": "event"}}', false, 'tbl_visit_x_node');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('node', 'form_feature', 'event', 'btn_new_visit', 'lyt_event_2', 2, 'button', 'New visit', false, false, true, false, '{"icon":"64", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "new_visit", "module": "info", "parameters":{}}', false, 'tbl_visit_x_node');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
VALUES ('node', 'form_feature', 'event', 'hspacer_event_1', 'lyt_event_2', 10, 'hspacer', false, false, true, false);
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetfunction, isfilter, linkedobject)
VALUES ('node', 'form_feature', 'event', 'btn_open_gallery', 'lyt_event_2', 11, 'button', 'Open gallery', false, false, true, false, '{"icon":"136b", "size":"24x24"}', '{"functionName": "open_gallery", "module": "info", "parameters":{"targetwidget":"event_tbl_event_cf", "columnfind": ["visit_id", "event_id"], "sourceview":"visit"}}', false, 'tbl_visit_x_node');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('node', 'form_feature', 'event', 'btn_open_visit_doc', 'lyt_event_2', 12, 'button', 'Open visit document', false, false, true, false, '{"icon":"170b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_visit_document", "module": "info", "parameters":{"targetwidget": "event_tbl_event_cf", "columnfind": "visit_id"}}', false, 'tbl_visit_x_node');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('node', 'form_feature', 'event', 'btn_open_visit_event', 'lyt_event_2', 13, 'button', 'Open visit event', false, false, true, false, '{"icon":"134b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_visit_event", "module": "info", "parameters":{"targetwidget": "event_tbl_event_cf", "columnfind":["visit_id", "event_id"]}}', false, 'tbl_visit_x_node');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('node', 'form_feature', 'event', 'tbl_event_cf', 'lyt_event_3', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_visit_event", "module": "info", "parameters":{"columnfind":["visit_id", "event_id"]}}', 'tbl_visit_x_node', 5);

-- TAB EVENT CONNEC
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
VALUES ('tbl_visit_x_connec', 'SELECT * FROM v_ui_event_x_connec WHERE event_id IS NOT NULL', 4, 'tab', 'list');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('connec', 'form_feature', 'event', 'date_event_from', 'lyt_event_1', 1, 'date', 'datetime',  'From:', false, false, true, false, true, '{"labelPosition": "top"}', '{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}', 'tbl_visit_x_connec', 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('connec', 'form_feature', 'event', 'date_event_to', 'lyt_event_1', 2, 'date', 'datetime',  'To:', false, false, true, false, true, '{"labelPosition": "top"}', '{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}', 'tbl_visit_x_connec', 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('connec', 'form_feature', 'event', 'parameter_type', 'lyt_event_1', 3, 'string', 'combo',  'Parameter type:', false, false, true, false, true, 'SELECT DISTINCT parameter_type as id, parameter_type as idval FROM config_visit_parameter WHERE feature_type IN (''CONNEC'', ''ALL'') ', True, '{"labelPosition": "top"}', '{"functionName": "filter_table", "parameters":{}}', 'tbl_visit_x_connec', 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('connec', 'form_feature', 'event', 'parameter_id', 'lyt_event_1', 4, 'string', 'combo',  'Parameter:', false, false, true, false, true, 'SELECT id as id, id as idval FROM config_visit_parameter WHERE feature_type IN (''CONNEC'', ''ALL'') ', True, '{"labelPosition": "top"}', '{"functionName": "filter_table", "parameters":{}}', 'tbl_visit_x_connec', 4);

INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('connec', 'form_feature', 'event', 'btn_open_visit', 'lyt_event_2', 1, 'button', 'Open visit', false, false, true, false, '{"icon":"65", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_visit_manager", "parameters":{"columnfind": "visit_id", "targetwidget": "event_tbl_event_cf", "sourceview": "event"}}', false, 'tbl_visit_x_connec');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('connec', 'form_feature', 'event', 'btn_new_visit', 'lyt_event_2', 2, 'button', 'New visit', false, false, true, false, '{"icon":"64", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "new_visit", "module": "info", "parameters":{}}', false, 'tbl_visit_x_connec');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
VALUES ('connec', 'form_feature', 'event', 'hspacer_event_1', 'lyt_event_2', 10, 'hspacer', false, false, true, false);
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetfunction, isfilter, linkedobject)
VALUES ('connec', 'form_feature', 'event', 'btn_open_gallery', 'lyt_event_2', 11, 'button', 'Open gallery', false, false, true, false, '{"icon":"136b", "size":"24x24"}', '{"functionName": "open_gallery", "module": "info", "parameters":{"targetwidget":"event_tbl_event_cf", "columnfind": ["visit_id", "event_id"], "sourceview":"visit"}}', false, 'tbl_visit_x_connec');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('connec', 'form_feature', 'event', 'btn_open_visit_doc', 'lyt_event_2', 12, 'button', 'Open visit document', false, false, true, false, '{"icon":"170b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_visit_document", "module": "info", "parameters":{"targetwidget": "event_tbl_event_cf", "columnfind": "visit_id"}}', false, 'tbl_visit_x_connec');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('connec', 'form_feature', 'event', 'btn_open_visit_event', 'lyt_event_2', 13, 'button', 'Open visit event', false, false, true, false, '{"icon":"134b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_visit_event", "module": "info", "parameters":{"targetwidget": "event_tbl_event_cf", "columnfind":["visit_id", "event_id"]}}', false, 'tbl_visit_x_connec');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('connec', 'form_feature', 'event', 'tbl_event_cf', 'lyt_event_3', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_visit_event", "module": "info", "parameters":{"columnfind":["visit_id", "event_id"]}}', 'tbl_visit_x_connec', 5);


-- TAB DOCUMENTS ARC
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_document_1', 'lyt_document_1','lytDocuments1');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_document_2', 'lyt_document_2','lytDocuments2');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_document_3', 'lyt_document_3','lytDocuments3');
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
VALUES ('tbl_doc_x_arc', 'SELECT id as sys_id, * FROM v_ui_doc_x_arc WHERE id IS NOT NULL', 4, 'tab', 'list');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('arc', 'form_feature', 'document', 'tbl_documents', 'lyt_document_3', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_selected_path", "parameters":{"targetwidget": "document_tbl_documents", "columnfind":"path"}}', 'tbl_doc_x_arc', 5);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter, web_layoutorder)
VALUES ('arc', 'form_feature', 'document', 'doc_id', 'lyt_document_2', 0, 'string', 'typeahead', 'Doc id:', false, false, true, false, 'SELECT id as id, id as idval FROM doc WHERE id IS NOT NULL ','{"saveValue": false, "filterSign":"ILIKE"}', '{"functionName": "filter_table"}', false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('arc', 'form_feature', 'document', 'btn_doc_insert', 'lyt_document_2', 2, 'button', 'Insert document', false, false, true, false,  '{"icon":"111b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "add_object", "parameters":{"sourcewidget":"doc_id", "targetwidget":"document_tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_arc');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('arc', 'form_feature', 'document', 'btn_doc_delete', 'lyt_document_2', 3, 'button', 'Delete document', false, false, true, false,  '{"icon":"112b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "delete_object", "parameters":{"columnfind":"feature_id", "targetwidget":"document_tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_arc');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('arc', 'form_feature', 'document', 'btn_doc_new', 'lyt_document_2', 4, 'button', 'New document', false, false, true, false,  '{"icon":"131b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "manage_document", "parameters":{"sourcewidget":"doc_id", "targetwidget":"document_tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_arc');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
VALUES ('arc', 'form_feature', 'document', 'hspacer_document_1', 'lyt_document_2', 10, 'hspacer', false, false, true, false);
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('arc', 'form_feature', 'document', 'open_doc', 'lyt_document_2', 11, 'button', 'Open document', false, false, true, false,  '{"icon":"170b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_selected_path", "parameters":{"columnfind":"path", "targetwidget":"document_tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_arc');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('arc', 'form_feature', 'document', 'date_from', 'lyt_document_1', 1, 'date', 'datetime',  'Date from:', false, false, true, false, true, '{"labelPosition": "top", "filterSign":">="}', '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}', 'tbl_doc_x_arc', 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('arc', 'form_feature', 'document', 'date_to', 'lyt_document_1', 2, 'date', 'datetime',  'Date to:', false, false, true, false, true, '{"labelPosition": "top", "filterSign":"<="}', '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}', 'tbl_doc_x_arc', 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, dv_querytext, dv_isnullvalue, widgetfunction, linkedobject, web_layoutorder)
VALUES ('arc', 'form_feature', 'document', 'doc_type', 'lyt_document_1', 3, 'string', 'combo',  'Doc type:', false, false, true, false, true, '{"labelPosition": "top"}', 'SELECT id as id, id as idval FROM doc_type WHERE id IS NOT NULL ', True, '{"functionName": "filter_table", "parameters":{}}', 'tbl_doc_x_arc', 3);

-- TAB DOCUMENTS NODE
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
VALUES ('tbl_doc_x_node', 'SELECT id as sys_id, * FROM v_ui_doc_x_node WHERE id IS NOT NULL', 4, 'tab', 'list');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('node', 'form_feature', 'document', 'tbl_documents', 'lyt_document_3', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_selected_path", "parameters":{"targetwidget": "document_tbl_documents", "columnfind":"path"}}', 'tbl_doc_x_node', 5);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter, web_layoutorder)
VALUES ('node', 'form_feature', 'document', 'doc_id', 'lyt_document_2', 0, 'string', 'typeahead', 'Doc id:', false, false, true, false, 'SELECT id as id, id as idval FROM doc WHERE id IS NOT NULL ','{"saveValue": false, "filterSign":"ILIKE"}', '{"functionName": "filter_table"}', false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('node', 'form_feature', 'document', 'btn_doc_insert', 'lyt_document_2', 2, 'button', 'Insert document', false, false, true, false,  '{"icon":"111b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "add_object", "parameters":{"sourcewidget":"doc_id", "targetwidget":"document_tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_node');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('node', 'form_feature', 'document', 'btn_doc_delete', 'lyt_document_2', 3, 'button', 'Delete document', false, false, true, false,  '{"icon":"112b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "delete_object", "parameters":{"columnfind":"feature_id", "targetwidget":"document_tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_node');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('node', 'form_feature', 'document', 'btn_doc_new', 'lyt_document_2', 4, 'button', 'New document', false, false, true, false,  '{"icon":"131b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "manage_document", "parameters":{"sourcewidget":"doc_id", "targetwidget":"document_tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_node');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
VALUES ('node', 'form_feature', 'document', 'hspacer_document_1', 'lyt_document_2', 10, 'hspacer', false, false, true, false);
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('node', 'form_feature', 'document', 'open_doc', 'lyt_document_2', 11, 'button', 'Open document', false, false, true, false,  '{"icon":"170b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_selected_path", "parameters":{"columnfind":"path", "targetwidget":"document_tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_node');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('node', 'form_feature', 'document', 'date_from', 'lyt_document_1', 1, 'date', 'datetime',  'Date from:', false, false, true, false, true, '{"labelPosition": "top", "filterSign":">="}', '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}', 'tbl_doc_x_node', 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('node', 'form_feature', 'document', 'date_to', 'lyt_document_1', 2, 'date', 'datetime',  'Date to:', false, false, true, false, true, '{"labelPosition": "top", "filterSign":"<="}', '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}', 'tbl_doc_x_node', 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, dv_querytext, dv_isnullvalue, widgetfunction, linkedobject, web_layoutorder)
VALUES ('node', 'form_feature', 'document', 'doc_type', 'lyt_document_1', 3, 'string', 'combo',  'Doc type:', false, false, true, false, true, '{"labelPosition": "top"}', 'SELECT id as id, id as idval FROM doc_type WHERE id IS NOT NULL ', True, '{"functionName": "filter_table", "parameters":{}}', 'tbl_doc_x_node', 3);

-- TAB DOCUMENTS CONNEC
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
VALUES ('tbl_doc_x_connec', 'SELECT id as sys_id, * FROM v_ui_doc_x_connec WHERE id IS NOT NULL', 4, 'tab', 'list');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('connec', 'form_feature', 'document', 'tbl_documents', 'lyt_document_3', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_selected_path", "parameters":{"targetwidget": "document_tbl_documents", "columnfind":"path"}}', 'tbl_doc_x_connec', 5);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter, web_layoutorder)
VALUES ('connec', 'form_feature', 'document', 'doc_id', 'lyt_document_2', 0, 'string', 'typeahead', 'Doc id:', false, false, true, false, 'SELECT id as id, id as idval FROM doc WHERE id IS NOT NULL ','{"saveValue": false, "filterSign":"ILIKE"}', '{"functionName": "filter_table"}', false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('connec', 'form_feature', 'document', 'btn_doc_insert', 'lyt_document_2', 2, 'button', 'Insert document', false, false, true, false,  '{"icon":"111b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "add_object", "parameters":{"sourcewidget":"doc_id", "targetwidget":"document_tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_connec');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('connec', 'form_feature', 'document', 'btn_doc_delete', 'lyt_document_2', 3, 'button', 'Delete document', false, false, true, false,  '{"icon":"112b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "delete_object", "parameters":{"columnfind":"feature_id", "targetwidget":"document_tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_connec');
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('connec', 'form_feature', 'document', 'btn_doc_new', 'lyt_document_2', 4, 'button', 'New document', false, false, true, false,  '{"icon":"131b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "manage_document", "parameters":{"sourcewidget":"doc_id", "targetwidget":"document_tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_connec');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
VALUES ('connec', 'form_feature', 'document', 'hspacer_document_1', 'lyt_document_2', 10, 'hspacer', false, false, true, false);
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
VALUES ('connec', 'form_feature', 'document', 'open_doc', 'lyt_document_2', 11, 'button', 'Open document', false, false, true, false,  '{"icon":"170b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_selected_path", "parameters":{"columnfind":"path", "targetwidget":"document_tbl_documents", "sourceview":"doc"}}', false, 'tbl_doc_x_connec');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('connec', 'form_feature', 'document', 'date_from', 'lyt_document_1', 1, 'date', 'datetime',  'Date from:', false, false, true, false, true, '{"labelPosition": "top", "filterSign":">="}', '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}', 'tbl_doc_x_connec', 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
VALUES ('connec', 'form_feature', 'document', 'date_to', 'lyt_document_1', 2, 'date', 'datetime',  'Date to:', false, false, true, false, true, '{"labelPosition": "top", "filterSign":"<="}', '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}', 'tbl_doc_x_connec', 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, dv_querytext, dv_isnullvalue, widgetfunction, linkedobject, web_layoutorder)
VALUES ('connec', 'form_feature', 'document', 'doc_type', 'lyt_document_1', 3, 'string', 'combo',  'Doc type:', false, false, true, false, true, '{"labelPosition": "top"}', 'SELECT id as id, id as idval FROM doc_type WHERE id IS NOT NULL ', True, '{"functionName": "filter_table", "parameters":{}}', 'tbl_doc_x_connec', 3);


-- SET TOP & BOT WIDGETS' LABELS ON-TOP OF THE WIDGET
UPDATE config_form_fields
SET widgetcontrols = '{"labelPosition": "top"}'
WHERE formname LIKE 've_%' AND (layoutname LIKE 'lyt_top%' OR layoutname LIKE 'lyt_bot%') AND widgetcontrols IS NULL;

UPDATE config_form_fields
SET widgetcontrols = jsonb_set(widgetcontrols::jsonb, '{labelPosition}', '"top"', true)
WHERE formname LIKE 've_%' AND (layoutname LIKE 'lyt_top%' OR layoutname LIKE 'lyt_bot%');

-- SET epa_type WIDGET AS AUTOUPDATE
UPDATE config_form_fields 
SET isautoupdate = true 
WHERE columnname = 'epa_type' and formname like 've_%';


-- TAB EPA
INSERT INTO config_form_tabs VALUES ('v_edit_arc','tab_epa','EPA results',NULL,'role_basic',NULL,'[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},
{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false}, {"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},
{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false}, {"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},
{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false}, {"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},
{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false}, {"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false},
{"actionName":"actionMapZone", "actionTooltip":"Add Mapzone",  "disabled":false}, {"actionName":"actionSetToArc", "actionTooltip":"Set to_arc",  "disabled":false},
{"actionName":"actionGetParentId", "actionTooltip":"Set parent_id",  "disabled":false}, {"actionName":"actionGetArcId", "actionTooltip":"Set arc_id",  "disabled":false},
{"actionName": "actionRotation", "actionTooltip": "Rotation","disabled": false}]',4, 1) ON CONFLICT (formname, tabname, device) DO NOTHING;

INSERT INTO config_form_tabs VALUES ('v_edit_node','tab_epa','EPA results',NULL,'role_basic',NULL,'[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},
{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false}, {"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},
{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false}, {"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},
{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false}, {"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},
{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false}, {"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false},
{"actionName":"actionMapZone", "actionTooltip":"Add Mapzone",  "disabled":false}, {"actionName":"actionSetToArc", "actionTooltip":"Set to_arc",  "disabled":false},
{"actionName":"actionGetParentId", "actionTooltip":"Set parent_id",  "disabled":false}, {"actionName":"actionGetArcId", "actionTooltip":"Set arc_id",  "disabled":false},
{"actionName": "actionRotation", "actionTooltip": "Rotation","disabled": false}]',4, 1) ON CONFLICT (formname, tabname, device) DO NOTHING;

INSERT INTO config_form_tabs VALUES ('v_edit_connec','tab_epa','EPA results',NULL,'role_basic',NULL,'[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},
{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false}, {"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},
{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false}, {"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},
{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false}, {"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},
{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false}, {"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false},
{"actionName":"actionMapZone", "actionTooltip":"Add Mapzone",  "disabled":false}, {"actionName":"actionSetToArc", "actionTooltip":"Set to_arc",  "disabled":false},
{"actionName":"actionGetParentId", "actionTooltip":"Set parent_id",  "disabled":false}, {"actionName":"actionGetArcId", "actionTooltip":"Set arc_id",  "disabled":false},
{"actionName": "actionRotation", "actionTooltip": "Rotation","disabled": false}]',4, 1) ON CONFLICT (formname, tabname, device) DO NOTHING;

INSERT INTO sys_function
(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3206, 'gw_fct_checknode', 'utils', 'function', 'json', 'json', 'Function to get node from coordinate', 'role_basic', NULL, 'core') ON CONFLICT (id) DO NOTHING;

-- 15/03/2023
UPDATE config_toolbox SET device = '{4,5}';
UPDATE config_report SET device = '{4,5}';

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES (3210, 'gw_fct_getprocess', 'utils', 'function','json', 'json',
'Function to manage open form for specific process execution on toolbox', 'role_basic', NULL) ON CONFLICT (id) DO NOTHING;


INSERT INTO config_form_fields VALUES('v_edit_link', 'form_feature', 'main', 'epa_type', 'lyt_data_1', 18, 'string', 'text', 'epa_type', NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
'{"setMultiline":false}'::json, NULL, NULL, false, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES('v_edit_link', 'form_feature', 'main', 'is_operative', 'lyt_data_1', 19, 'boolean', 'check', 'is_operative', NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
'{"setMultiline":false}'::json, NULL, NULL, false, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

-- 29/03/2023
INSERT INTO config_typevalue (typevalue,id,idval,camelstyle)
	VALUES ('widgettype_typevalue','tablewidget','tablewidget','tablewidget');

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) 
    VALUES('datatype_typevalue', 'datetime', 'datetime', 'datetime', '{"createAddfield":"TRUE"}'::json);

UPDATE sys_fprocess SET fprocess_name='Repair nodes duplicated', project_type='utils', fprocess_type='Function process' WHERE fid=405;

UPDATE sys_function
SET descript='It allows to repair the problem of having two nodes on the same location.
- Node: the node_id where we want to perform the action.
- Target node: the other node_id on the process. It is optative. If NULL, system will try to find the closest node.
- Action: 5 actions can be performed: 
DELETE: Node is deleted. Target node gets topology.
DOWNGRADE: Node is downgraded. Target node gets topology.
MOVE AND LOSE TOPOLOGY: Node is moved and lose topology. Target node gets topology.
MOVE AND KEEP TOPOLOGY: Node is moved and keep topology. Target node lose topology.
MOVE AND GET TOPOLOGY: Node is moved and get topology. Target node lose topology.
- For moving actions, set the X and Y axis movement (in meters) where node will be displaced.'
WHERE id=3080;

UPDATE config_toolbox
SET inputparams='[{"widgetname":"node", "label":"Node:", "widgettype":"text", "datatype":"text", "layoutname":"grl_option_parameters","layoutorder":1, "value":null},
  {"widgetname":"action", "label":"Action:", "widgettype":"combo", "datatype":"text", "comboIds":["DELETE", "DOWNGRADE", "MOVE-LOSE-TOPO", "MOVE-KEEP-TOPO", "MOVE-GET-TOPO"], "comboNames":["DELETE", "DOWNGRADE", "MOVE & LOSE TOPOLOGY", "MOVE & KEEP TOPOLOGY", "MOVE & GET TOPOLOGY"], "layoutname":"grl_option_parameters","layoutorder":3, "selectedId":null},
  {"widgetname":"targetNode", "label":"Target node (optional):", "tooltip": "Value for target node is optative. If null system will try to check closest node.", "widgettype":"text", "datatype":"text", "layoutname":"grl_option_parameters","layoutorder":2, "value":null},
  {"widgetname":"dx", "label":"Movement on X axis (m):", "tooltip": "Node displacement on X axis (m)", "widgettype":"text", "datatype":"float", "layoutname":"grl_option_parameters","layoutorder":4, "value":null},
  {"widgetname":"dy", "label":"Movement on Y axis (m):", "tooltip": "Node displacement on Y axis (m)", "widgettype":"text", "datatype":"float", "layoutname":"grl_option_parameters","layoutorder":5, "value":null}
  ]'::json
WHERE id=3080;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3232, 'gw_trg_dscenario_demand_feature', 'ws', 'function trigger', NULL, NULL, 'Trigger that controls if node or connec set as feature_id exists on inventory tables', 'role_epa', NULL, 'core');

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, "source")
VALUES(3230, 'Inserted feature_id does not exist on node/connec table', 'Review your data', 2, true, 'utils', 'core');

INSERT INTO config_param_system("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname)
VALUES('edit_link_check_arcdnom', '{"status":false , "diameter":250}', 'If true, inserted links could not connect to arcs with diameter bigger or equal than the configured', 'Links check arc diameter', NULL, NULL, false, NULL, 'ws', NULL, NULL, 'json', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, "source")
VALUES(3232, 'It''s not possible to connect to this arc because it exceed the maximum diameter configured:', 'Connect to a smaller arc or change system configuration', 2, true, 'utils', 'core');

UPDATE config_param_system
SET value='{"rowsColor":true}'
WHERE "parameter"='qgis_form_selector_stylesheet';

INSERT INTO sys_fprocess
(fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam)
VALUES(488, 'Check connecs related to arcs with diameter bigger than defined value', 'ws', NULL, 'core', true, 'Check om-data', NULL);

UPDATE sys_fprocess SET fprocess_name='Check connects with more than 1 link on service', fprocess_type='Check om-data' WHERE fid=480;

DELETE FROM sys_table WHERE id='selector_plan_psector';

UPDATE config_form_tabs
	SET orderby=3
	WHERE formname='selector_basic' AND tabname='tab_network_state' AND device=4;
UPDATE config_form_tabs
	SET orderby=4
	WHERE formname='selector_basic' AND tabname='tab_hydro_state' AND device=4;
UPDATE config_form_tabs
	SET orderby=2
	WHERE formname='selector_basic' AND tabname='tab_sector' AND device=4;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate,  dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, hidden)
WITH lyt as (SELECT distinct formname, max(layoutorder) as lytorder from config_form_fields 
where layoutname ='lyt_data_3' and formname  in ('v_edit_node','v_edit_arc','v_edit_connec','ve_node','ve_arc','ve_connec','v_edit_gully', 've_gully') group by formname)
SELECT c.formname, formtype, tabname, 'region_id', 'lyt_data_3', lytorder+1, datatype, widgettype, 'Region', 'region_id', NULL, false, false, 
false, false, 'SELECT region_id as id, name as idval FROM ext_region WHERE region_id IS NOT NULL', true, true, null, null, true
FROM config_form_fields c join lyt using (formname) WHERE c.formname  in ('v_edit_node','v_edit_arc','v_edit_connec','ve_node','ve_arc','ve_connec','v_edit_gully', 've_gully')
AND columnname='muni_id'
group by c.formname, formtype, tabname,  layoutname, datatype, widgettype, label, tooltip, placeholder, ismandatory, false, 
iseditable, isautoupdate,  dv_querytext, dv_orderby_id, dv_isnullvalue, lytorder, hidden
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate,  dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, hidden)
WITH lyt as (SELECT distinct formname, max(layoutorder) as lytorder from config_form_fields 
where layoutname ='lyt_data_3' and formname  in ('v_edit_node','v_edit_arc','v_edit_connec','ve_node','ve_arc','ve_connec','v_edit_gully', 've_gully') group by formname)
SELECT c.formname, formtype, tabname, 'province_id', 'lyt_data_3', lytorder+1, datatype, widgettype, 'Province', 'province_id', NULL, false, false, 
false, false, 'SELECT province_id as id, name as idval FROM ext_province WHERE province_id IS NOT NULL', true, true, null, null, true
FROM config_form_fields c join lyt using (formname) WHERE c.formname  in ('v_edit_node','v_edit_arc','v_edit_connec','ve_node','ve_arc','ve_connec','v_edit_gully', 've_gully')
AND columnname='muni_id'
group by c.formname, formtype, tabname,  layoutname, datatype, widgettype, label, tooltip, placeholder, ismandatory, false, 
iseditable, isautoupdate,  dv_querytext, dv_orderby_id, dv_isnullvalue, lytorder, hidden
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO sys_table(id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", style_id, addparam)
VALUES('ext_region', 'Table of regions', 'role_edit', 2, '{"level_1":"INVENTORY","level_2":"MAP ZONES"}', 10, 'Region', NULL, NULL, NULL, 'core', NULL, NULL);

INSERT INTO sys_table(id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", style_id, addparam)
VALUES('ext_province', 'Table of provinces', 'role_edit', 2, '{"level_1":"INVENTORY","level_2":"MAP ZONES"}', 11, 'Province', NULL, NULL, NULL, 'core', NULL, NULL);

UPDATE config_function SET id=3228 WHERE function_name='gw_fct_anl_node_proximity';