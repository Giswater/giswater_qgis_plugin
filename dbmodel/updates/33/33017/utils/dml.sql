/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 24/11/2019
INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (100, 'Set to_arc values for graf delimiters', 'EPA', 'Set to_arc values for graf delimiters','ws') ON CONFLICT (id) DO NOTHING;

--25/11/2019

UPDATE audit_cat_table SET notify_action = NULL WHERE id = 'config_param_system' OR id = 'config_param_user';

--26/11/2019
INSERT INTO audit_cat_table(id, context, description, sys_role_id, sys_criticity, qgis_criticity,isdeprecated)
VALUES ('ext_district', 'table to external', 'Catalog of districts', 'role_edit', 0, 0, false) ON CONFLICT (id) DO NOTHING;