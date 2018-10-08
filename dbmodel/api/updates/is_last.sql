/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


--2018/10/06
INSERT INTO config_param_system VALUES (210, 'sys_role_permissions', 'FALSE', 'Boolean', 'System', 'Utils');
INSERT INTO config_param_system VALUES (212, 'sys_daily_updates', 'FALSE', 'Boolean', 'System', 'Utils');
INSERT INTO config_param_system VALUES (214, 'sys_crm_schema', 'FALSE', 'Boolean', 'System', 'Utils');
INSERT INTO config_param_system VALUES (216, 'sys_utils_schema', 'FALSE', 'Boolean', 'System', 'Utils');
INSERT INTO config_param_system VALUES (218, 'sys_api_service', 'FALSE', 'Boolean', 'System', 'Utils');

INSERT INTO config_param_system VALUES (220, 'edit_automatic_insert_link', 'FALSE', 'Boolean', 'System', 'If true, link parameter will be the same as element id');


