/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;



--FILL config_web_layer_tab TABLE
------------------------------


-- SIMPLIFIED GISWATER PROJECT

INSERT INTO config_web_layer_tab VALUES (104, 'v_edit_node', 'tabElement', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (105, 'v_edit_node', 'tabConnect', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (106, 'v_edit_node', 'tabVisit', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (107, 'v_edit_node', 'tabDoc', 'INFO_UD_NODE', 'F11');

INSERT INTO config_web_layer_tab VALUES (116, 'v_edit_man_valve', 'tabElement', 'INFO_WS_NODE', 'F12');
INSERT INTO config_web_layer_tab VALUES (117, 'v_edit_man_valve', 'tabConnect', 'INFO_WS_NODE', 'F12');
INSERT INTO config_web_layer_tab VALUES (118, 'v_edit_man_valve', 'tabVisit', 'INFO_WS_NODE', 'F12');
INSERT INTO config_web_layer_tab VALUES (119, 'v_edit_man_valve', 'tabDoc', 'INFO_WS_NODE', 'F12');

INSERT INTO config_web_layer_tab VALUES (100, 'v_edit_arc', 'tabElement', 'INFO_UTILS_ARC', 'F13');
INSERT INTO config_web_layer_tab VALUES (101, 'v_edit_arc', 'tabConnect', 'INFO_UTILS_ARC', 'F13');
INSERT INTO config_web_layer_tab VALUES (102, 'v_edit_arc', 'tabVisit', 'INFO_UTILS_ARC', 'F13');
INSERT INTO config_web_layer_tab VALUES (103, 'v_edit_arc', 'tabDoc', 'INFO_UTILS_ARC', 'F13');

INSERT INTO config_web_layer_tab VALUES (108, 'v_edit_connec', 'tabElement', 'INFO_UTILS_CONNEC', 'F14');
INSERT INTO config_web_layer_tab VALUES (109, 'v_edit_connec', 'tabHydro', 'INFO_UTILS_CONNEC', 'F14');
INSERT INTO config_web_layer_tab VALUES (110, 'v_edit_connec', 'tabMincut', 'INFO_UTILS_CONNEC', 'F14');
INSERT INTO config_web_layer_tab VALUES (111, 'v_edit_connec', 'tabVisit', 'INFO_UTILS_CONNEC', 'F14');
INSERT INTO config_web_layer_tab VALUES (112, 'v_edit_connec', 'tabDoc', 'INFO_UTILS_CONNEC', 'F14');

INSERT INTO config_web_layer_tab VALUES (113, 'v_edit_gully', 'tabElement', 'INFO_UD_GULLY', 'F15');
INSERT INTO config_web_layer_tab VALUES (114, 'v_edit_gully', 'tabVisit', 'INFO_UD_GULLY', 'F15');
INSERT INTO config_web_layer_tab VALUES (115, 'v_edit_gully', 'tabDoc', 'INFO_UD_GULLY', 'F15');




-- FULL GISWATER PROJECT

/*
INSERT INTO config_web_layer_tab VALUES (56, 'v_edit_man_varc', 'tabDoc', 'INFO_UTILS_ARC', 'F13');
INSERT INTO config_web_layer_tab VALUES (32, 'v_edit_man_netgully', 'tabDoc', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (36, 'v_edit_man_netinit', 'tabDoc', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (8, 'v_edit_man_chamber', 'tabDoc', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (57, 'v_edit_man_varc', 'tabElement', 'INFO_UTILS_ARC', 'F13');
INSERT INTO config_web_layer_tab VALUES (33, 'v_edit_man_netgully', 'tabElement', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (55, 'v_edit_man_varc', 'tabConnect', 'INFO_UTILS_ARC', 'F13');
INSERT INTO config_web_layer_tab VALUES (58, 'v_edit_man_varc', 'tabVisit', 'INFO_UTILS_ARC', 'F13');
INSERT INTO config_web_layer_tab VALUES (9, 'v_edit_man_chamber', 'tabElement', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (7, 'v_edit_man_chamber', 'tabConnect', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (10, 'v_edit_man_chamber', 'tabVisit', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (61, 'v_edit_man_waccel', 'tabElement', 'INFO_UTILS_ARC', 'F13');
INSERT INTO config_web_layer_tab VALUES (25, 'v_edit_man_junction', 'tabElement', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (69, 'v_edit_man_wwtp', 'tabElement', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (73, 'review_arc', 'tabElement', 'REVIEW_UD_ARC', 'F51');
INSERT INTO config_web_layer_tab VALUES (67, 'v_edit_man_wwtp', 'tabConnect', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (59, 'v_edit_man_waccel', 'tabConnect', 'INFO_UTILS_ARC', 'F13');
INSERT INTO config_web_layer_tab VALUES (62, 'v_edit_man_waccel', 'tabVisit', 'INFO_UTILS_ARC', 'F13');
INSERT INTO config_web_layer_tab VALUES (23, 'v_edit_man_junction', 'tabConnect', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (26, 'v_edit_man_junction', 'tabVisit', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (29, 'v_edit_man_manhole', 'tabElement', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (17, 'v_edit_man_connec', 'tabElement', 'INFO_UTILS_CONNEC', 'F14');
INSERT INTO config_web_layer_tab VALUES (70, 'v_edit_man_wwtp', 'tabVisit', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (31, 'v_edit_man_netgully', 'tabConnect', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (34, 'v_edit_man_netgully', 'tabVisit', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (71, 'review_arc', 'tabConnect', 'REVIEW_UD_ARC', 'F51');
INSERT INTO config_web_layer_tab VALUES (74, 'review_arc', 'tabVisit', 'REVIEW_UD_ARC', 'F51');
INSERT INTO config_web_layer_tab VALUES (37, 'v_edit_man_netinit', 'tabElement', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (77, 'review_node', 'tabElement', 'REVIEW_UD_NODE', 'F52');
INSERT INTO config_web_layer_tab VALUES (81, 'review_connec', 'tabElement', 'REVIEW_UD_CONNEC', 'F53');
INSERT INTO config_web_layer_tab VALUES (82, 'review_connec', 'tabVisit', 'REVIEW_UD_CONNEC', 'F53');
INSERT INTO config_web_layer_tab VALUES (84, 'review_gully', 'tabElement', 'REVIEW_UD_GULLY', 'F54');
INSERT INTO config_web_layer_tab VALUES (13, 'v_edit_man_conduit', 'tabElement', 'INFO_UTILS_ARC', 'F13');
INSERT INTO config_web_layer_tab VALUES (75, 'review_node', 'tabConnect', 'REVIEW_UD_NODE', 'F52');
INSERT INTO config_web_layer_tab VALUES (78, 'review_node', 'tabVisit', 'REVIEW_UD_NODE', 'F52');
INSERT INTO config_web_layer_tab VALUES (18, 'v_edit_man_connec', 'tabVisit', 'INFO_UTILS_CONNEC', 'F14');
INSERT INTO config_web_layer_tab VALUES (21, 'v_edit_man_gully', 'tabElement', 'INFO_UD_GULLY', 'F15');
INSERT INTO config_web_layer_tab VALUES (22, 'v_edit_man_gully', 'tabVisit', 'INFO_UD_GULLY', 'F15');
INSERT INTO config_web_layer_tab VALUES (11, 'v_edit_man_conduit', 'tabConnect', 'INFO_UTILS_ARC', 'F13');
INSERT INTO config_web_layer_tab VALUES (14, 'v_edit_man_conduit', 'tabVisit', 'INFO_UTILS_ARC', 'F13');
INSERT INTO config_web_layer_tab VALUES (35, 'v_edit_man_netinit', 'tabConnect', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (45, 'v_edit_man_siphon', 'tabElement', 'INFO_UTILS_ARC', 'F13');
INSERT INTO config_web_layer_tab VALUES (86, 'review_gully', 'tabVisit', 'REVIEW_UD_GULLY', 'F54');
INSERT INTO config_web_layer_tab VALUES (43, 'v_edit_man_siphon', 'tabConnect', 'INFO_UTILS_ARC', 'F13');
INSERT INTO config_web_layer_tab VALUES (46, 'v_edit_man_siphon', 'tabVisit', 'INFO_UTILS_ARC', 'F13');
INSERT INTO config_web_layer_tab VALUES (38, 'v_edit_man_netinit', 'tabVisit', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (27, 'v_edit_man_manhole', 'tabConnect', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (30, 'v_edit_man_manhole', 'tabVisit', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (41, 'v_edit_man_outfall', 'tabElement', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (39, 'v_edit_man_outfall', 'tabConnect', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (42, 'v_edit_man_outfall', 'tabVisit', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (49, 'v_edit_man_storage', 'tabElement', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (47, 'v_edit_man_storage', 'tabConnect', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (50, 'v_edit_man_storage', 'tabVisit', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (53, 'v_edit_man_valve', 'tabElement', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (51, 'v_edit_man_valve', 'tabConnect', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (54, 'v_edit_man_valve', 'tabVisit', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (65, 'v_edit_man_wjump', 'tabElement', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (63, 'v_edit_man_wjump', 'tabConnect', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (66, 'v_edit_man_wjump', 'tabVisit', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (60, 'v_edit_man_waccel', 'tabDoc', 'INFO_UTILS_ARC', 'F13');
INSERT INTO config_web_layer_tab VALUES (68, 'v_edit_man_wwtp', 'tabDoc', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (24, 'v_edit_man_junction', 'tabDoc', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (72, 'review_arc', 'tabDoc', 'REVIEW_UD_ARC', 'F51');
INSERT INTO config_web_layer_tab VALUES (16, 'v_edit_man_connec', 'tabDoc', 'INFO_UTILS_CONNEC', 'F14');
INSERT INTO config_web_layer_tab VALUES (28, 'v_edit_man_manhole', 'tabDoc', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (76, 'review_node', 'tabDoc', 'REVIEW_UD_NODE', 'F52');
INSERT INTO config_web_layer_tab VALUES (79, 'review_connec', 'tabDoc', 'REVIEW_UD_CONNEC', 'F53');
INSERT INTO config_web_layer_tab VALUES (12, 'v_edit_man_conduit', 'tabDoc', 'INFO_UTILS_ARC', 'F13');
INSERT INTO config_web_layer_tab VALUES (20, 'v_edit_man_gully', 'tabDoc', 'INFO_UD_GULLY', 'F15');
INSERT INTO config_web_layer_tab VALUES (83, 'review_gully', 'tabDoc', 'REVIEW_UD_GULLY', 'F54');
INSERT INTO config_web_layer_tab VALUES (44, 'v_edit_man_siphon', 'tabDoc', 'INFO_UTILS_ARC', 'F13');
INSERT INTO config_web_layer_tab VALUES (40, 'v_edit_man_outfall', 'tabDoc', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (48, 'v_edit_man_storage', 'tabDoc', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (52, 'v_edit_man_valve', 'tabDoc', 'INFO_UD_NODE', 'F11');
INSERT INTO config_web_layer_tab VALUES (64, 'v_edit_man_wjump', 'tabDoc', 'INFO_UD_NODE', 'F11');

*/

