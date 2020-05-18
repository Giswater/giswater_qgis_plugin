/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/03/13
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_param_system", "column":"layout_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"audit_cat_param_user", "column":"layout_id"}}$$);

INSERT INTO config_param_system (parameter, value, context, descript, label, isenabled, project_type, datatype, widgettype, ismandatory, isdeprecated, standardvalue) 
VALUES ('sys_transaction_db', '{"status":false, "server":""}', 'system', 'Parameteres for use an additional database to scape transtaction logics of PostgreSQL in order to audit processes step by step', 
'Additional transactional database:', TRUE, 'utils', 'json', 'linetext', false, false, 'false') 
ON CONFLICT (parameter) DO NOTHING;


UPDATE audit_cat_param_user SET layoutname = 'lyt_other', formname='config', iseditable = true, layout_order=19 WHERE id ='debug_mode';
UPDATE audit_cat_param_user SET layoutname = 'lyt_inventory' , layout_order=9 WHERE id ='verified_vdefault';
UPDATE audit_cat_param_user SET layoutname = 'lyt_inventory' , layout_order=9 WHERE id ='verified_vdefault';
UPDATE audit_cat_param_user SET layoutname = 'lyt_inventory' , layout_order=10 WHERE id ='cad_tools_base_layer_vdefault';
UPDATE audit_cat_param_user SET layoutname = 'lyt_inventory' , layout_order=11 WHERE id ='edit_gully_doublegeom';
UPDATE audit_cat_param_user SET layoutname = 'lyt_other' , layout_order=17 WHERE id ='edit_upsert_elevation_from_dem';
UPDATE audit_cat_param_user SET formname ='hidden_param' WHERE id IN ('audit_project_epa_result', 'audit_project_plan_result');
UPDATE audit_cat_param_user SET layoutname = 'lyt_other' , layout_order=18 WHERE id ='api_form_show_columname_on_label';

UPDATE audit_cat_param_user SET formname ='hidden_param' , project_type = 'utils' WHERE id IN ('qgis_qml_linelayer_path', 'qgis_qml_pointlayer_path', 'qgis_qml_polygonlayer_path');

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2828, 'gw_api_get_visit', 'utils','api function', 'Get visit', 'role_basic',FALSE, FALSE, FALSE)
ON conflict (id) DO NOTHING;


--2020/02/26
INSERT INTO audit_cat_param_user (id, formname, descript, sys_role_id, idval, label, dv_querytext, dv_parent_id, isenabled, layoutname, 
layout_order, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, widgettype, 
ismandatory, widgetcontrols, vdefault, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, isdeprecated) 
VALUES ('qgis_form_log_hidden', 'config', 'Hide log form after executing a process', 'role_edit', NULL, 'Hide log form', NULL, NULL, true, 'lyt_other', 
20, 'utils', false, NULL, NULL, NULL, false, 'boolean', 'check', true, NULL, 'true', NULL, NULL, NULL, NULL, NULL, false)
ON conflict (id) DO NOTHING;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2830, 'gw_fct_debug', 'utils','Function to manage messages', 'Function to manage messages', 'role_basic',FALSE, FALSE, FALSE)
ON conflict (id) DO NOTHING;