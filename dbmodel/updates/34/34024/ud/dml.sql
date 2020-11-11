/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/11/04
UPDATE config_info_layer SET orderby=2 WHERE layer_id='v_edit_connec';
UPDATE config_info_layer SET orderby=3 WHERE layer_id='v_edit_gully';
UPDATE config_info_layer SET orderby=4 WHERE layer_id='v_edit_om_visit';
UPDATE config_info_layer SET orderby=5 WHERE layer_id='v_edit_arc';
UPDATE config_info_layer SET orderby=6 WHERE layer_id='v_edit_dimensions';
DELETE FROM config_info_layer WHERE layer_id='v_edit_cad_auxpoint';

-- 2020/11/11
update config_form_fields SET widgetcontrols=null WHERE formname = 'v_edit_connec'  and columnname in('y1','y2')
update config_form_fields SET widgetcontrols= '{"autoupdateReloadFields":["node_1", "y1", "custom_y1", "custom_elev1, "sys_y1", "sys_elev1", "z1", "r1", "node_2", "y2", "custom_y2", "custom_elev2, "sys_y2", "sys_elev2", "z2", "r2","slope"]}' WHERE widgetcontrols::text like '%slope%'

INSERT INTO sys_param_user(id, formname, 
descript, 
sys_role, project_type, isdeprecated)
VALUES ('edit_arc_keepdepthval_when_reverse_geom', 'hidden', 
'If value, when arc is reversed only id values from node_1 and node_2 will be exchanged, keeping depth values on same node (y1, y2, custom_y1, custom_y2, elev_1, elev_2, custom_elev_1, custom_elev_2, sys_elev_1, sys_elev_2) will remain on same node', 
'role_edit', 'ud', 'false') ON CONFLICT (id) DO NOTHING;