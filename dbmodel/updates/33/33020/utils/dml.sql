/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2019/12/20
INSERT INTO audit_cat_param_user VALUES 
('qgis_form_initproject_hidden', 'config', 'Hide initial form when project is loaded', 'role_basic', NULL, NULL, 'Hide initproject form', NULL, NULL, true, 8, 12, 'utils', false, NULL, NULL, NULL, 
false, 'boolean', 'check', true, NULL, 'false', NULL, NULL, NULL, NULL, NULL, NULL, NULL, false)
ON conflict (id) DO NOTHING;

INSERT INTO audit_cat_param_user VALUES 
('audit_project_user_control', 'config', 'Check database on load project', 'role_edit', NULL, NULL, 'Check database on load project', NULL, NULL, true, 8, 13, 'utils', false, NULL, NULL, NULL, 
false, 'boolean', 'check', true, NULL, 'false', NULL, NULL, NULL, NULL, NULL, NULL, NULL, false)
ON conflict (id) DO NOTHING;

UPDATE audit_cat_param_user SET iseditable=TRUE where iseditable is null;