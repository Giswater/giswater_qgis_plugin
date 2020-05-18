/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/05/05
UPDATE audit_cat_table SET sys_role_id = 'role_basic'  WHERE id = 'audit_check_data';

--2020/05/09
UPDATE audit_cat_table SET sys_role_id = 'role_master' WHERE id = 'config_form_fields';

--2020/05/14
INSERT INTO config_param_system (parameter, value, data_type, context, descript, label, isenabled, layout_id, layout_order, project_type, datatype, widgettype, ismandatory, isdeprecated) 
VALUES ('mapzones_dynamic_symbology', 'false', 'boolean', 'system', 'Mapzones dynamic symbology', null, FALSE, null, null, 'ws', 'boolean', null, null, false) 
ON CONFLICT (parameter) DO NOTHING;

--2020/05/17
INSERT INTO audit_cat_param_user
VALUES ('qgis_init_guide_map','config','If true, qgis starts with all extension for exploitations', 'role_basic', NULL, NULL, 
'QGIS init guide map', NULL, NULL, true, 8, 20, 'utils', false, NULL, NULL, NULL, 
false, 'boolean', 'check', true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false)
ON conflict (id) DO NOTHING;


