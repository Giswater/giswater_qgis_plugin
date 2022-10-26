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