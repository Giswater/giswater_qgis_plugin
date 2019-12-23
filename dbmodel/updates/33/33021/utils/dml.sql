/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2019/12/20
INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (107,'Role upsertuser','admin','Role upsertuser','utils') ON CONFLICT (id) DO NOTHING;

UPDATE audit_cat_function set function_name = 'fct_plan_check_data' WHERE id = 2436;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, alias, isparametric)
VALUES (2788, 'gw_api_get_widgetcontrols', 'api', 'function', 'role_om', false, false, null,false);
