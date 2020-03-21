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


UPDATE config_param_system SET value = gw_fct_json_object_set_key (value::json, 'sys_table_id'::text, 'cat_work'::text) WHERE parameter = 'api_search_workcat';
UPDATE config_param_system SET value = gw_fct_json_object_set_key (value::json, 'sys_id_field'::text, 'id'::text) WHERE parameter = 'api_search_workcat';
UPDATE config_param_system SET value = gw_fct_json_object_set_key (value::json, 'sys_search_field'::text, 'id'::text) WHERE parameter = 'api_search_workcat';

UPDATE audit_cat_table SET deprecated = true WHERE id = 'v_ui_workcat_polygon_aux';