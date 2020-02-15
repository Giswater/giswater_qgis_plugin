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



-- 15/02/2020
INSERT INTO audit_cat_param_user VALUES ('connectype_vdefault', 'config', 'Default value for connec type', 'role_edit', NULL, NULL, 'Connec type:', 
	'SELECT id AS id, id AS idval FROM connec_type WHERE id IS NOT NULL', NULL, true, 12, 0, 'ud', false, NULL, NULL, NULL, false, 'string', 
	'combo', false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);
UPDATE audit_cat_param_user SET label = 'Gully type',id='gullytype_vdefault' WHERE id='gullycat_vdefault'
UPDATE audit_cat_param_user SET label = 'Default catalog for node (parent layer)', description='Default node catalog when parent layer (v_edit_node) is used' WHERE id='nodecat_vdefault';
UPDATE audit_cat_param_user SET label = 'Default catalog for arc (parent layer)', description='Default arc catalog when parent layer (v_edit_arc) is used' WHERE id='arccat_vdefault';
UPDATE audit_cat_param_user SET label = 'Default catalog for connec (parent layer)', description='Default connec catalog when parent layer (v_edit_connec) is used' WHERE id='connecat_vdefault';
UPDATE audit_cat_param_user SET label = 'Default grate catalog', description='Default grate catalog' WHERE id='gratecat_vdefault';
UPDATE audit_cat_param_user SET label = 'Default type for node (parent layer)', description='Default type for node when parent layer (v_edit_node) is used' WHERE id='nodetype_vdefault';
UPDATE audit_cat_param_user SET label = 'Default type for arc (parent layer)', description='Default type for arc when parent layer (v_edit_arc) is used' WHERE id='arctype_vdefault';
UPDATE audit_cat_param_user SET label = 'Default type for connec (parent layer)', description='Default type for connec when parent layer (v_edit_connec) is used' WHERE id='connectype_vdefault';
UPDATE audit_cat_param_user SET label = 'Default type for gully (parent layer)', description='Default type for gully when parent layer (v_edit_gully) is used' WHERE id='gullytype_vdefault';
