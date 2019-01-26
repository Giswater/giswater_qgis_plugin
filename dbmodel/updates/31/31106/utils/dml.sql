/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2019/01/26
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2640, 'gw_api_getvisitmanager', 'role_om', FALSE, 'To call visit from user');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2642, 'gw_api_setvisitmanager', 'role_om', FALSE,'To update values');
