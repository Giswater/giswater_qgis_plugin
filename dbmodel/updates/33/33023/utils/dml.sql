/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/01/10
INSERT INTO audit_cat_param_user VALUES 
('audit_project_layer_log', 'config', 'Show temporal layer log when warnings on check database for load project', 'role_edit', NULL, NULL, 'Show layer log for warnings when check database', NULL, NULL, true, 8, 14, 'utils', false, NULL, NULL, NULL, 
false, 'boolean', 'check', true, NULL, 'false', NULL, NULL, NULL, NULL, NULL, NULL, NULL, false)
ON conflict (id) DO NOTHING;