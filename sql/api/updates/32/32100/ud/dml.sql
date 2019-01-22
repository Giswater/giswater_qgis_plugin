/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;
-----------------------
-- config api values
-----------------------

INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('CHAMBER', 've_node_chamber');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('WEIR', 've_node_weir');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('PUMP-STATION', 've_node_pumpstation');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('REGISTER', 've_node_register');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('CHANGE', 've_node_change');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('VNODE', 've_node_vnode');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('JUNCTION', 've_node_junction');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('HIGHPOINT', 've_node_highpoint');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('CIRC-MANHOLE', 've_node_circmanhole');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('RECT-MANHOLE', 've_node_rectmanhole');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('NETELEMENT', 've_node_netelement');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('NETGULLY', 've_node_netgully');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('SANDBOX', 've_node_sandbox');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('OUTFALL', 've_node_outfall');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('OWERFLOW-STORAGE', 've_node_overflowstorage');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('SEWER-STORAGE', 've_node_sewerstorage');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('VALVE', 've_node_valve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('JUMP', 've_node_jump');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('WWTP', 've_node_wwtp');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('PUMP-PIPE', 've_arc_pumppipe');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('CONDUIT', 've_arc_conduit');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('SIPHON', 've_arc_siphon');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('VARC', 've_arc_varc');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('WACCEL', 've_arc_waccel');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('CONNEC', 've_connec');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('GULLY', 've_gully');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('PGULLY', 've_gully');


INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (1, 've_node_chamber', 100, 've_node_chamber');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (2, 've_node_weir', 100, 've_node_weir');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (3, 've_node_pumpstation', 100, 've_node_pumpstation');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (4, 've_node_register', 100, 've_node_register');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (5, 've_node_change', 100, 've_node_change');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (6, 've_node_vnode', 100, 've_node_vnode');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (7, 've_node_junction', 100, 've_node_junction');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (8, 've_node_highpoint', 100, 've_node_highpoint');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (9, 've_node_circmanhole', 100, 've_node_circmanhole');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (10, 've_node_rectmanhole', 100, 've_node_rectmanhole');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (11, 've_node_netelement', 100, 've_node_netelement');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (12, 've_node_netgully', 100, 've_node_netgully');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (13, 've_node_sandbox', 100, 've_node_sandbox');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (14, 've_node_outfall', 100, 've_node_outfall');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (15, 've_node_overflowstorage', 100, 've_node_overflowstorage');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (16, 've_node_sewerstorage', 100, 've_node_sewerstorage');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (17, 've_node_valve', 100, 've_node_valve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (18, 've_node_jump', 100, 've_node_jump');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (19, 've_node_wwtp', 100, 've_node_wwtp');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (20, 've_arc_pumppipe', 100, 've_arc_pumppipe');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (21, 've_arc_conduit', 100, 've_arc_conduit');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (22, 've_arc_siphon', 100, 've_arc_siphon');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (23, 've_arc_varc', 100, 've_arc_varc');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (24, 've_arc_waccel', 100, 've_arc_waccel');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (25, 've_connec', 100, 've_connec');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (26, 've_gully', 100, 've_gully');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (27, 've_gully', 100, 've_gully');