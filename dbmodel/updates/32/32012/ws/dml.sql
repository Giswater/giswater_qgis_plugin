/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-----------------------
-- config api values
-----------------------

INSERT INTO config_api_list 
VALUES (1000, 've_arc_pipe', 'SELECT arc_id as sys_id, * FROM ve_arc_pipe WHERE arc_id IS NOT NULL', 3, '{"geometry":{"name":"the_geom"}, "linkpath":{"name":"link"}}');
INSERT INTO config_api_list 
VALUES (2000, 'v_ui_arc_x_relations', 'SELECT rid as sys_id, * FROM v_ui_arc_x_relations  WHERE rid IS NOT NULL', 3, '{"geometry":{"name":"the_geom"}, "linkpath":{"name":"link"}}');
INSERT INTO config_api_list 
VALUES (3000, 'v_ui_node_x_connection_upstream', 'SELECT rid as sys_id, * FROM v_ui_node_x_connection_upstream  WHERE rid IS NOT NULL', 3, '{"geometry":{"name":"the_geom"}, "linkpath":{"name":"link"}}');


INSERT INTO config_api_layer VALUES ('v_edit_arc', true, 'vp_basic_arc', false, NULL, 'custom feature', 'Arc', 2, NULL, NULL,'vp_epa_arc');
INSERT INTO config_api_layer VALUES ('v_edit_node', true, 'vp_basic_node', false, NULL, 'custom feature', 'Node', 1, NULL, NULL, 'vp_epa_node');
INSERT INTO config_api_layer VALUES ('v_edit_cad_auxpoint', true, 'v_edit_cad_auxpoint_parent', true, NULL, 'GENERIC', 'Basic Info', 4, NULL, NULL);
INSERT INTO config_api_layer VALUES ('v_edit_connec', true, 'vp_basic_connec', false, NULL, 'custom feature', 'Connec', 3, NULL, NULL);


UPDATE config_api_form_tabs set formname='v_edit_node' WHERE formname='ve_node';
UPDATE config_api_form_tabs set formname='v_edit_arc' WHERE formname='ve_arc';
UPDATE config_api_form_tabs set formname='v_edit_connec' WHERE formname='ve_connec';
UPDATE config_api_form_tabs set formname='v_edit_gully' WHERE formname='ve_gully';
UPDATE config_api_form_tabs set formname='v_edit_element' WHERE formname='ve_element';