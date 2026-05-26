/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = am, public;

INSERT INTO PARENT_SCHEMA.sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES
('config_catalog_def', 'Table to define the catalogs', 'role_om', NULL, '34', NULL, 'Config catalog', NULL, NULL, NULL, 'am', NULL),
('config_engine_def', 'Table to define engines configuration', 'role_om', NULL, '34', NULL, 'Config engine', NULL, NULL, NULL, 'am', NULL),
('config_material_def', 'Table to define the materials', 'role_om', NULL, '34', NULL, 'Config material', NULL, NULL, NULL, 'am', NULL)
ON CONFLICT (id) DO NOTHING;
