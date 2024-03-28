/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (518, 'Set end feature', 'utils', null, 'core', true, 'Function process', null) 
ON CONFLICT (fid) DO NOTHING;

-- 21/10/2023
INSERT INTO config_typevalue (typevalue, id, addparam) VALUES ('sys_table_context','{"level_1":"INVENTORY","level_2":"VALUE DOMAIN"}', '{"orderBy":99}')
ON CONFLICT (typevalue, id) DO NOTHING;

UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"VALUE DOMAIN"}' , alias = 'Category type' WHERE id = 'man_type_category';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"VALUE DOMAIN"}' , alias = 'Fluid type' WHERE id = 'man_type_fluid';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"VALUE DOMAIN"}' , alias = 'Location type' WHERE id = 'man_type_location';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"VALUE DOMAIN"}' , alias = 'Function type' WHERE id = 'man_type_function';

-- 24/10/23
UPDATE sys_param_user SET ismandatory = True WHERE id = 'plan_psector_vdefault';

-- 27/10/23
UPDATE sys_message SET error_message = 'IT iS IMPOSSIBLE TO UPDATE ARC_ID FROM PSECTOR DIALOG BECAUSE THIS PLANNED LINK HAS NOT ARC AS EXIT-TYPE',
hint_message = 'TO UPDATE IT USE ARC_ID CONNECT(CONNEC or GULLY) DIALOG OR EDIT THE ENDPOINT OF LINK''S GEOMETRY ON CANVAS'
where id = 3212;

-- 29/10/2023
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3282, 'gw_fct_getfeatureboundary', 'utils', 'function', 'json', 'json', 'Function to return boundary feature in function of different input parameters', 'role_edit', null, 'core') ON CONFLICT (id) DO NOTHING;

-- 31/10/2023
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3284, 'gw_fct_psector_merge', 'utils', 'function', 'json', 'json', 'Function to merge two or more psectors into one', 'role_master', null, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam) 
VALUES (520, 'Psector merge', 'utils', NULL, 'core', true, 'Function process', NULL)
ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device) 
VALUES(3284, 'Merge two or more psectors into one', '{"featureType":[]}'::json, '[{"widgetname":"psector_ids", "label":"Psector ids: (*)", "widgettype":"text", "datatype":"text", "layoutname":"grl_option_parameters","layoutorder":0, "isMandatory":true}, {"widgetname":"new_psector_name", "label":"New psector name: (*)", "widgettype":"text", "datatype":"text", "layoutname":"grl_option_parameters","layoutorder":1, "isMandatory":true}]'::json, NULL, true, '{4}');

-- 31/10/2023
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3286, 'gw_trg_refresh_state_expl_matviews', 'utils', 'Trigger function', null, null, 'Trigger function to refresh matviews in order to enhance performe', 'role_basic', null, 'core') ON CONFLICT (id) DO NOTHING;

DELETE FROM sys_table WHERE id = 'arc_border_expl';

UPDATE config_form_tabs SET orderby=4 WHERE tabname='tab_event' AND orderby IS NULL;

-- 7/11/2023
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3288, 'gw_fct_setrepairpsector', 'utils', 'function', null, null, 'Function to fix possible errors on psector', 'role_master', null, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (521, 'Set repair psector', 'utils', null, 'core', true, 'Function process', null) 
ON CONFLICT (fid) DO NOTHING;

UPDATE config_csv SET alias = 'Import scada values', descript = 'Import scada values into table ext_rtc_scada_x_data according example file scada_values.csv', 
functionname = 'gw_fct_import_scada_values' WHERE fid = 469;

UPDATE config_csv SET descript='The csv file must have the following fields:
hydrometer_id, cat_period_id, sum, value_date (optional), value_type (optional), value_status (optional), value_state (optional)' WHERE fid=470 AND alias='Import hydrometer_x_data';

UPDATE config_csv SET descript='The csv file must have the following fields:
id, start_date, end_date, period_seconds (optional), code', active = true WHERE fid=471 AND alias='Import crm period values';

--11/11/2023
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam) 
VALUES(522, 'Check outfalls with more than 1 arc', 'utils', NULL, 'core', true, 'Function process', NULL);

INSERT INTO sys_message (id, error_message, log_level, show_user, project_type, "source")
VALUES(3250, 'Value 0 for exploitation it is not enabled on network objects. It is only used to relate undefined mapzones', 2, true, 'utils', 'core') ON CONFLICT DO NOTHING;

--24/11/2023
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) 
VALUES('psector form', 'utils', 'v_price_compost', 'id', 0, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) 
VALUES('psector form', 'utils', 'v_price_compost', 'unit', 1, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) 
VALUES('psector form', 'utils', 'v_price_compost', 'descript', 2, true, NULL, NULL, '{"stretch": true}'::json, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) 
VALUES('psector form', 'utils', 'v_price_compost', 'price', 3, true, NULL, NULL, NULL, NULL);

-- 30/11/2023

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_cat", "column":"feature_type", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_cat", "column":"alias", "dataType":"text"}}$$);
UPDATE om_visit_cat set alias = name;

-- 12/12/2023
-- node
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('node', 'form_feature', 'tab_visit', 'date_visit_from', 'lyt_visit_1', 1, 'date', 'datetime', 'From:', NULL, NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":">="}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_node', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('node', 'form_feature', 'tab_visit', 'date_visit_to', 'lyt_visit_1', 2, 'date', 'datetime', 'To:', NULL, NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":"<="}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_node', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('node', 'form_feature', 'tab_visit', 'hspacer_lyt_document_1', 'lyt_visit_2', 1, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('node', 'form_feature', 'tab_visit', 'open_gallery', 'lyt_visit_2', 2, NULL, 'button', NULL, 'Open gallery', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"136b", "size":"24x24"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{"functionName": "open_visit_files", "module": "info", "parameters":{"targetwidget":"tab_visit_tbl_visits"}}'::json, 'tbl_visit_x_node', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('node', 'form_feature', 'tab_visit', 'tbl_visits', 'lyt_visit_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{"functionName": "open_selected_path", "parameters":{"columnfind":"path"}}'::json, 'tbl_visit_x_node', false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('node', 'form_feature', 'tab_visit', 'visit_class', 'lyt_visit_1', 3, 'string', 'combo', 'Visit class:', NULL, NULL, false, false, true, false, true, 'SELECT id, idval FROM config_visit_class WHERE feature_type IN (''NODE'',''ALL'') ', NULL, true, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_visit_x_node', false, 3);

-- connec
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('connec', 'form_feature', 'tab_visit', 'date_visit_from', 'lyt_visit_1', 1, 'date', 'datetime', 'From:', NULL, NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":">="}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_connec', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('connec', 'form_feature', 'tab_visit', 'date_visit_to', 'lyt_visit_1', 2, 'date', 'datetime', 'To:', NULL, NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":"<="}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_connec', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('connec', 'form_feature', 'tab_visit', 'visit_class', 'lyt_visit_1', 3, 'string', 'combo', 'Visit class:', NULL, NULL, false, false, true, false, true, 'SELECT id, idval FROM config_visit_class WHERE feature_type IN (''CONNEC'',''ALL'') ', NULL, true, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_visit_x_connec', false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('connec', 'form_feature', 'tab_visit', 'hspacer_lyt_document_1', 'lyt_visit_2', 1, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('connec', 'form_feature', 'tab_visit', 'open_gallery', 'lyt_visit_2', 2, NULL, 'button', NULL, 'Open gallery', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"136b", "size":"24x24"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{"functionName": "open_visit_files", "module": "info", "parameters":{"targetwidget":"tab_visit_tbl_visits"}}'::json, 'tbl_visit_x_connec', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('connec', 'form_feature', 'tab_visit', 'tbl_visits', 'lyt_visit_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{"functionName": "open_selected_path", "parameters":{"columnfind":"path"}}'::json, 'tbl_visit_x_connec', false, 4);

-- arc
UPDATE config_form_fields SET widgetcontrols='{"labelPosition": "top", "filterSign":">="}'::json WHERE formname='arc' AND formtype='form_feature' AND columnname='date_visit_from' AND tabname='tab_visit';
UPDATE config_form_fields SET widgetcontrols='{"labelPosition": "top", "filterSign":"<="}'::json WHERE formname='arc' AND formtype='form_feature' AND columnname='date_visit_to' AND tabname='tab_visit';
UPDATE config_form_fields SET widgetcontrols='{"labelPosition": "top"}'::json WHERE formname='arc' AND formtype='form_feature' AND columnname='visit_class' AND tabname='tab_visit';

-- 13/12/2023
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('basic_search_hydrometer_show_connec', 'FALSE', 'If the variable is set to False, the workflow remains as it is right now (open basic form). If variable is set to True, you have to make an infofromid to the specific connec, directly in the "hydrometer" tab.', 'Show connec hydrometer:', NULL, NULL, true, 16, 'utils', NULL, NULL, 'boolean', 'check', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_admin_other');
