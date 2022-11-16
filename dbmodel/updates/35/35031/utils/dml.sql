/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DELETE FROM config_toolbox WHERE id=2766;
DELETE FROM sys_function WHERE id=2766;

UPDATE sys_function SET project_type='utils' WHERE id =2710 OR id=2768;


INSERT INTO sys_function(id, function_name, project_type, function_type, descript, sys_role,  source)
VALUES (3174, 'gw_trg_edit_setarcdata', 'utils', 'trigger function', 
'Trigger that fills arc with values captured or calculated based on attributes stored on final nodes', 'role_edit', 'core');

INSERT INTO config_param_system(parameter, value, descript, isenabled,  project_type, datatype)
VALUES ('admin_isproduction' , False, 'If true, deleting the schema using Giswater button will not be possible', FALSE, 'utils', 'boolean');

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (478, 'Check features without defined sector_id', 'utils', NULL, 'core', true, 'Check om-data', NULL);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (479, 'Check duplicated arcs', 'utils', NULL, 'core', true, 'Check om-data', NULL);

INSERT INTO config_param_system(parameter, value, descript, project_type,  datatype)
VALUES ('admin_node_code_on_arc', false, 'If true, on codes of final nodes will be visible on arc''s form. If false, node_id would be displayed', 'utils', 'boolean');

update sys_param_user set dv_isnullvalue =null where formname='epaoptions';