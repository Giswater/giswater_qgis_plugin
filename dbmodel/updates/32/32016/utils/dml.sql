/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_csv2pg_cat SET functionname='gw_fct_utils_csv2pg_import_timeseries', name='Import timeseries', name_i18n='Import timeseries', sys_role='role_edit'
WHERE functionname='gw_fct_utils_csv2pg_import_patterns';

INSERT INTO sys_fprocess_cat VALUES (48, 'Pipe leak probability', 'om', 'Pipe leak probability', 'ws');
INSERT INTO sys_fprocess_cat VALUES (49, 'EPA calibration', 'epa', 'EPA calibration', 'utils');
INSERT INTO sys_fprocess_cat VALUES (50, 'EPA vnodes trim arcs' , 'epa', 'EPA vnodes trim arcs', 'ws');
INSERT INTO sys_fprocess_cat VALUES (51, 'Set feature relations', 'edit', 'Set feature relations', 'utils');
INSERT INTO sys_fprocess_cat VALUES (52, 'Delete feature', 'edit', 'Delete feature', 'utils');

UPDATE audit_cat_error SET error_message = 'Node with state 2 over another node with state=2 on same alternative it is not allowed. The node is:' 
WHERE id=1096;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2725, 'gw_fct_get_feature_relation', 'utils', 'function', 'Function get the informations about all the relations that feature has', 'role_edit',false,false,false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2736, 'gw_fct_set_delete_feature', 'utils', 'function', 'Delete feature and all relations that it has', 'role_edit',false,false,false);

INSERT INTO audit_cat_function 
VALUES (2728, 'gw_fct_pg2epa_vnodetrimarcs', 'ws', 'function', NULL, NULL, NULL, 'Function to trim arcs on model using vnodes', 'role_epa', false, false, NULL, false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2732, 'gw_trg_connect_update', 'utils', 'trigger function', 'Manage capabilities after update fields on connect (connec & gullt)', 'role_edit',false,false,false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2734, 'gw_fct_duplicate_psector', 'utils', 'function', 'Create a copy of existing psector', 'role_master',false,false,false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2735, 'gw_fct_admin_manage_child_config', 'utils', 'function', 'Create custom form configuration for child views', 'role_master',false,false,false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2738, 'gw_fct_utils_csv2pg_import_timeseries', 'utils', 'function', 'Import any timeseries as you want', 'role_edit',false,false,false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2740, 'gw_api_get_visit', 'api', 'function', 'FUnction to build the form of visits', 'role_om',false,false,false);


UPDATE audit_cat_function SET isdeprecated=TRUE where id=2688;
UPDATE audit_cat_function SET isdeprecated=TRUE where id=1108;

INSERT INTO sys_csv2pg_cat VALUES (21, 'Import visit lot', 'Import visit lot', 'The csv file must contains next columns on same position: feature_id, 
feature_type, visitclass_id, lot_id, status (4 is finished), date (AAAA/MM/DD), param1, param2', 'role_om', 'importcsv', 'gw_fct_utils_csv2pg_import_omvisitlot', NULL, NULL, false);

INSERT INTO sys_fprocess_cat VALUES (54, 'Import lot visits', 'om', 'Import lot visits', 'utils');

INSERT INTO sys_fprocess_cat VALUES (55, 'Nodes single capacity', 'epa', 'Nodes single capacity', 'ws');
INSERT INTO sys_fprocess_cat VALUES (56, 'Nodes double capacity', 'epa', 'Nodes double capacity', 'ws');
INSERT INTO sys_fprocess_cat VALUES (57, 'Nodes single capacity but not double', 'epa', 'Nodes single capacity but not double', 'ws');
INSERT INTO sys_fprocess_cat VALUES (58, 'Nodes coupled capacity', 'epa', 'Nodes coupled capacity', 'ws');
INSERT INTO sys_fprocess_cat VALUES (59, 'EPA check vnodes over nod2arc', 'epa', 'EPA check vnodes over nod2arc', 'ws');
INSERT INTO sys_fprocess_cat VALUES (60, 'EPA connecs with no hydrometer', 'epa', 'EPA connecs with no hydrometer', 'ws');
INSERT INTO sys_fprocess_cat VALUES (61, 'Check pattern related to dma', 'epa', 'Check pattern related to dma', 'ws');
INSERT INTO sys_fprocess_cat VALUES (62, 'Check pattern related to hydro', 'epa', 'Check pattern related to hydro', 'ws');


INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3020,'This planified feature (state=2) is already used in another psector.','Create a new feature in order to assign it.', 2, true,'utils',false);

UPDATE config_param_system SET context=null, parameter='_api_search_visit' WHERE parameter='api_search_visit';

UPDATE audit_cat_param_user  SET isparent= TRUE WHERE id='state_vdefault';
UPDATE audit_cat_param_user  SET dv_parent_id= 'state_vdefault', 
dv_querytext = 'SELECT id as id, name as idval FROM value_state_type WHERE id IS NOT NULL ', dv_querytext_filterc = ' AND state = '
WHERE id='statetype_vdefault';