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
update config_form_fields SET widgetcontrols=null WHERE formname = 'v_edit_connec'  and columnname in('y1','y2');
update config_form_fields SET 
widgetcontrols= '{"autoupdateReloadFields":["node_1", "y1", "custom_y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1", "node_2", "y2", "custom_y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2","slope"]}'
WHERE widgetcontrols::text like '%slope%';

-- 2020/11/14
INSERT INTO config_toolbox
VALUES (3008, 'Arc reverse', TRUE, '{"featureType":["arc"]}',null, null, TRUE)
ON CONFLICT (id) DO NOTHING;

UPDATE config_toolbox SET id = 2858 WHERE id = 2848;

UPDATE config_toolbox SET id = 2431 WHERE id = 2430;