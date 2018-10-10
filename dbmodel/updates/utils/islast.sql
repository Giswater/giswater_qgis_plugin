/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2018/10/05
ALTER TABLE anl_node ADD COLUMN arc_distance numeric(12,3);
ALTER TABLE anl_node ADD COLUMN arc_id varchar(16);


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
			VALUES ('edit_automatic_insert_link', 'FALSE', 'Boolean', 'System', 'If true, link parameter will be the same as element id');

