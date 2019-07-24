/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_fprocess_cat VALUES (48, 'Pipe leak probability', 'om', '', 'ws');
INSERT INTO sys_fprocess_cat VALUES (49, 'EPA calibration', 'epa', '', 'utils');
INSERT INTO sys_fprocess_cat VALUES (50, 'go2epa vnode arc trim', 'epa', '', 'ws');
INSERT INTO sys_fprocess_cat VALUES (51, 'Set feature relations', 'edit', 'Set feature relations', 'utils');
INSERT INTO sys_fprocess_cat VALUES (52, 'Delete feature', 'edit', 'Delete feature', 'utils');


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

UPDATE audit_cat_function SET isdeprecated=TRUE where id=2688;
UPDATE audit_cat_function SET isdeprecated=TRUE where id=1108;