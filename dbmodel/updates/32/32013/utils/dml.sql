/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE audit_cat_error SET error_message='It is impossible to use the node to fusion two arcs' WHERE id=2004;
UPDATE audit_cat_error SET error_message='It is impossible to use the node to fusion two arcs' WHERE id=2006;

UPDATE config_param_system SET label = 'Force arc direction using slope direction:', layout_order=8 WHERE parameter='geom_slp_direction';

UPDATE config_param_system SET label = 'Change topocontrol error by log message:', layout_order=5,
descript='If TRUE, topocontrol function is used but the elements which violates topology also can get inside the network. As a result log message of errors it is inserted on audit_log_data table (fprocesscat_id=3). Be careful, this function can lead to errors'
WHERE parameter='edit_topocontrol_dsbl_error';


UPDATE config_param_system SET label = 'Arc topology:', layout_order=9 WHERE parameter='arc_searchnodes';
UPDATE config_param_system SET label = 'Node topology:', layout_order=10 WHERE parameter='node_proximity';
UPDATE config_param_system SET label = 'Connec topology:', layout_order=11 WHERE parameter='connec_proximity';
UPDATE config_param_system SET label = 'Gully topology:', isenabled=true, layout_id=13, layout_order=12, iseditable=true WHERE parameter='gully_proximity';
UPDATE config_param_system SET label = 'Node double geometry enabled:', layout_order=16 WHERE parameter='insert_double_geometry';

UPDATE config_param_system SET isenabled=false, isdeprecated=true WHERE parameter='node_duplicated_tolerance';
UPDATE config_param_system SET isenabled=false, isdeprecated=true WHERE parameter='connec_duplicated_tolerance';


UPDATE audit_cat_param_user SET feature_field_id ='state' WHERE id='state_vdefault';
UPDATE audit_cat_param_user SET feature_field_id ='builtdate' WHERE id='builtdate_vdefault';
UPDATE audit_cat_param_user SET feature_field_id ='enddate' WHERE id='enddate_vdefault';
UPDATE audit_cat_param_user SET feature_field_id ='workcat_id' WHERE id='workcat_vdefault';
UPDATE audit_cat_param_user SET feature_field_id ='workcat_id_end' WHERE id='workcat_id_end_vdefault';
UPDATE audit_cat_param_user SET feature_field_id ='soilcat_id' WHERE id='soilcat_vdefault';
			
UPDATE audit_cat_param_user SET label='Automatic link from connec to network:'
			WHERE id='edit_connect_force_automatic_connect2network';

UPDATE audit_cat_param_user SET formname=null
			WHERE id='edit_arc_division_dsbl';
			
UPDATE audit_cat_param_user SET formname=null
			WHERE id='edit_connect_force_downgrade_linkvnode';

UPDATE om_visit_type SET idval='unexpected' WHERE idval ='unspected';

--2019/05/30
INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2690, 'gw_fct_admin_schema_manage_addfields', 'utils','function', 'Create addfields definition and related custom view','role_admin',FALSE, FALSE,FALSE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2692, 'gw_fct_utils_export_ui_xml', 'utils','function', 'Export UI xml in order to modify fields order in the custom form','role_admin',FALSE, FALSE,FALSE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2694, 'gw_fct_utils_import_ui_xml', 'utils','function', 'Import UI xml and update fields order in the custom form','role_admin',FALSE, FALSE,FALSE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2696, 'gw_fct_om_visit_event_manager', 'utils','function', 'Manager to work with advanced functionalities on events configurable using action_type on parameter_x_parameter table' ,'role_admin',FALSE, FALSE,FALSE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2697, 'gw_fct_pg2epa_singlenodecapacity', 'ws','function', 'Function with unlimited steps to analyze full network with different demands on one single node on network' ,'role_epa',FALSE, FALSE,FALSE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2698, 'gw_fct_pg2epa_nodescouplecapacity', 'ws','function', 'Function with five steps to analyze full network with different demands using couples of nodes on network (according spanish rules for firetap analytics)' ,'role_epa',FALSE, FALSE,FALSE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2700, 'gw_fct_admin_manage_fields', 'utils','function', 'Function to administrate fields on tables used on sql file to prevent conflict when field exists' ,'role_admin',FALSE, FALSE,FALSE);


INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3016, 'New field overlaps the existing one', 'Modify the order value.', 2, TRUE, 'utils',FALSE);

--03/06/2019
UPDATE config_param_system SET value='{"status":"TRUE" , "field":"code"}' WHERE parameter='customer_code_autofill';
UPDATE config_param_system SET descript='If status is TRUE, when insert a new connec, customer_code will be the same as field (connec_id or code)' WHERE parameter='customer_code_autofill';

--19/06/2019
INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated,istoolbox, isparametric)
VALUES (2702,'gw_trg_unique_field','utils', 'trigger function','Check unique values of attributes in a table', 'role_edit', FALSE, FALSE, FALSE);

INSERT INTO audit_cat_error( id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3018, 'Customer code is duplicated for connecs with state=1','Review your data.',2, TRUE, 'utils', FALSE);

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (43, 'Replace feature','Edit','Replace feature', 'utils');

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox,isparametric)
VALUES (2742, 'gw_trg_edit_config_sys_fields','utils','trigger', 'Edit fields of config api form fields','role_admin',false,false,false);
