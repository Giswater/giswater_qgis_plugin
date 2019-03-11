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
VALUES (1, 've_arc_pipe', 'SELECT arc_id as sys_id, * FROM ve_arc_pipe WHERE arc_id IS NOT NULL', 3, '{"geometry":{"name":"the_geom"}, "linkpath":{"name":"link"}}');
INSERT INTO config_api_list 
VALUES (2, 'v_ui_arc_x_relations', 'SELECT rid as sys_id, * FROM v_ui_arc_x_relations  WHERE rid IS NOT NULL', 3, '{"geometry":{"name":"the_geom"}, "linkpath":{"name":"link"}}');
INSERT INTO config_api_list 
VALUES (3, 'v_ui_node_x_connection_upstream', 'SELECT rid as sys_id, * FROM v_ui_node_x_connection_upstream  WHERE rid IS NOT NULL', 3, '{"geometry":{"name":"the_geom"}, "linkpath":{"name":"link"}}');


INSERT INTO config_api_layer (layer_id, is_parent, tableparent_id, is_editable, tableinfo_id, formtemplate, headertext, orderby, link_id, is_tiled) VALUES ('ve_arc', true, 've_arc_parent', false, NULL, 'custom feature', 'Arc', 2, NULL, NULL);
INSERT INTO config_api_layer (layer_id, is_parent, tableparent_id, is_editable, tableinfo_id, formtemplate, headertext, orderby, link_id, is_tiled) VALUES ('ve_node', true, 've_node_parent', false, NULL, 'custom feature', 'Node', 1, NULL, NULL);
INSERT INTO config_api_layer (layer_id, is_parent, tableparent_id, is_editable, tableinfo_id, formtemplate, headertext, orderby, link_id, is_tiled) VALUES ('v_edit_cad_auxpoint', true, 'v_edit_cad_auxpoint_parent', true, NULL, 'GENERIC', 'Basic Info', 4, NULL, NULL);
INSERT INTO config_api_layer (layer_id, is_parent, tableparent_id, is_editable, tableinfo_id, formtemplate, headertext, orderby, link_id, is_tiled) VALUES ('ve_connec', true, 've_connec_parent', false, NULL, 'custom feature', 'Connec', 3, NULL, NULL);


INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('SHUTOFF-VALVE', 've_node_shutoffvalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('CHECK-VALVE', 've_node_checkoffvalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('PR-BREAK.VALVE', 've_node_prbkvalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('FL-CONTR.VALVE', 've_node_flcontrvalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('GEN-PURP.VALVE', 've_node_genpurpvalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('THROTTLE-VALVE', 've_node_throttlevalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('PR-REDUC.VALVE', 've_node_prreducvalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('PR-SUSTA.VALVE', 've_node_prsustavalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('AIR-VALVE', 've_node_airvalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('GREEN-VALVE', 've_node_greenvalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('OUTFALL-VALVE', 've_node_outfallvalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('REGISTER', 've_node_register');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('BYPASS-REGISTER', 've_node_bypassregister');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('VALVE-REGISTER', 've_node_valveregister');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('CONTROL-REGISTER', 've_node_controlregister');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('EXPANTANK', 've_node_expansiontank');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('FILTER', 've_node_filter');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('FLEXUNION', 've_node_flexunion');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('HYDRANT', 've_node_hydrant');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('X', 've_node_x');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('ADAPTATION', 've_node_adaptation');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('ENDLINE', 've_node_endline');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('T', 've_node_t');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('CURVE', 've_node_curve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('JUNCTION', 've_node_junction');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('MANHOLE', 've_node_manhole');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('FLOWMETER', 've_node_flowmeter');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('PRESSURE-METER', 've_node_pressuremeter');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('NETELEMENT', 've_node_netelement');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('NETSAMPLEPOINT', 've_node_netsamplepoint');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('WATER-CONNECTION', 've_node_waterconnection');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('PUMP', 've_node_pump');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('REDUCTION', 've_node_reduction');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('SOURCE', 've_node_source');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('TANK', 've_node_tank');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('WATERWELL', 've_node_waterwell');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('WTP', 've_node_wtp');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('PIPE', 've_arc_pipe');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('VARC', 've_arc_varc');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('WJOIN', 've_connec_wjoin');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('FOUNTAIN', 've_connec_fountain');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('TAP', 've_connec_tap');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('GREENTAP', 've_connec_greentap');


INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (1, 've_node_shutoffvalve', 100, 've_node_shutoffvalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (2, 've_node_checkoffvalve', 100, 've_node_checkoffvalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (3, 've_node_prbkvalve', 100, 've_node_prbkvalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (4, 've_node_flcontrvalve', 100, 've_node_flcontrvalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (5, 've_node_genpurpvalve', 100, 've_node_genpurpvalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (6, 've_node_throttlevalve', 100, 've_node_throttlevalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (7, 've_node_prreducvalve', 100, 've_node_prreducvalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (8, 've_node_prsustavalve', 100, 've_node_prsustavalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (9, 've_node_airvalve', 100, 've_node_airvalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (10, 've_node_greenvalve', 100, 've_node_greenvalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (11, 've_node_outfallvalve', 100, 've_node_outfallvalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (12, 've_node_register', 100, 've_node_register');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (13, 've_node_bypassregister', 100, 've_node_bypassregister');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (14, 've_node_valveregister', 100, 've_node_valveregister');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (15, 've_node_controlregister', 100, 've_node_controlregister');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (16, 've_node_expansiontank', 100, 've_node_expansiontank');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (17, 've_node_filter', 100, 've_node_filter');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (18, 've_node_flexunion', 100, 've_node_flexunion');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (19, 've_node_hydrant', 100, 've_node_hydrant');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (20, 've_node_x', 100, 've_node_x');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (21, 've_node_adaptation', 100, 've_node_adaptation');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (22, 've_node_endline', 100, 've_node_endline');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (23, 've_node_t', 100, 've_node_t');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (24, 've_node_curve', 100, 've_node_curve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (25, 've_node_junction', 100, 've_node_junction');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (26, 've_node_manhole', 100, 've_node_manhole');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (27, 've_node_flowmeter', 100, 've_node_flowmeter');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (28, 've_node_pressuremeter', 100, 've_node_pressuremeter');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (29, 've_node_netelement', 100, 've_node_netelement');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (30, 've_node_netsamplepoint', 100, 've_node_netsamplepoint');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (31, 've_node_waterconnection', 100, 've_node_waterconnection');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (32, 've_node_pump', 100, 've_node_pump');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (33, 've_node_reduction', 100, 've_node_reduction');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (34, 've_node_source', 100, 've_node_source');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (35, 've_node_tank', 100, 've_node_tank');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (36, 've_node_waterwell', 100, 've_node_waterwell');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (37, 've_node_wtp', 100, 've_node_wtp');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (38, 've_arc_pipe', 100, 've_arc_pipe');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (39, 've_arc_varc', 100, 've_arc_varc');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (40, 've_connec_wjoin', 100, 've_connec_wjoin');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (41, 've_connec_fountain', 100, 've_connec_fountain');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (42, 've_connec_tap', 100, 've_connec_tap');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (43, 've_connec_greentap', 100, 've_connec_greentap');

