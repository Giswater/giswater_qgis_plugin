/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/02/12

INSERT INTO audit_cat_table(id, context, description, sys_role_id, sys_criticity, sys_rows, qgis_role_id, qgis_criticity, qgis_message, isdeprecated)
VALUES ('v_edit_dqa','GIS feature','Shows editable information about dqa', 'role_edit',0,null, 'role_basic', 2, 'Cannot manage dqa''s', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_table(id, context, description, sys_role_id, sys_criticity, sys_rows, qgis_role_id, qgis_criticity, qgis_message, isdeprecated)
VALUES ('v_edit_presszone','GIS feature','Shows editable information about presszones', 'role_edit',0,null, 'role_basic', 2, 'Cannot manage presszones', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_table(id, context, description, sys_role_id, sys_criticity, sys_rows, qgis_role_id, qgis_criticity, qgis_message, isdeprecated)
VALUES ('v_minsector','GIS feature','Shows editable information about misectors', 'role_edit',0,null, 'role_basic', 2, 'Cannot manage minsectors', false) ON CONFLICT (id) DO NOTHING;