/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2018/10/10
SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);

INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
			VALUES ('sys_role_permissions', 'FALSE', 'Boolean', 'System', 'Utils');
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
			VALUES ('sys_daily_updates', 'FALSE', 'Boolean', 'System', 'Utils');
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
			VALUES ('sys_crm_schema', 'FALSE', 'Boolean', 'System', 'Utils');
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
			VALUES ('sys_utils_schema', 'FALSE', 'Boolean', 'System', 'Utils');
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
			VALUES ('sys_api_service', 'FALSE', 'Boolean', 'System', 'Utils');

INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
			VALUES ('edit_automatic_insert_link', 'FALSE', 'Boolean', 'System', 'If true link parameter will be the same as element id');

INSERT INTO sys_csv2pg_cat VALUES (8, 'Import dxf blocks', 'Import dxf blocks', 'The CSV file must contain only one column and need to be generated as R12 ASCII file', 'role_edit');

INSERT INTO audit_cat_function VALUES (2498, 'gw_trg_visit_event_update_xy', 'om', NULL, 'p_event_id', 'Enables the posibility to update the xcoord, ,ycoord columns using position_id and position_value.', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2500, 'gw_trg_edit_field_node', 'edit', NULL, 'p_node_id', 'To update data on field', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2502, 'gw_fct_utils_role_permisions', 'amin', NULL, '', 'To role permissionf of the schema', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2504, 'gw_fct_utils_csv2pg_importblock', 'edit', NULL, '', '', 'Enables the possibility to import dxf blocks', NULL, NULL);
INSERT INTO audit_cat_function VALUES (2506, 'gw_fct_create_utils_trigger', 'edit', NULL, '', '', NULL, NULL, NULL);


--2018/10/15
INSERT INTO audit_cat_table VALUES ('v_plan_aux_arc_pavement', 'Auxiliar layer', 'Layer to relate pavements againts arc', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL);

--2018/10/22
DELETE FROM audit_cat_table WHERE id='audit_cat_table_x_column';
UPDATE audit_cat_table SET sys_role_id='role_basic' WHERE id='plan_psector_selector';


-- 2018/10/24
INSERT INTO audit_cat_function VALUES (2508, 'gw_fct_getinsertform_vdef', 'edit', NULL, '', '', NULL, NULL, NULL);
