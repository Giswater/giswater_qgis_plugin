/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/01/10
insert into audit_cat_function (id,function_name, project_type, function_type,descript, sys_role_id, isdeprecated, istoolbox, 
       isparametric)
VALUES (2794,'gw_fct_audit_check_project','utils','function','Functions that controls the qgis project',
'role_basic', false,false,false);