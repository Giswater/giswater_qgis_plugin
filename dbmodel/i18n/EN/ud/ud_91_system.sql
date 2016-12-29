/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;



-- ----------------------------
-- Records of node type system table
-- ----------------------------
INSERT INTO node_type VALUES ('CHAMBER', 'CHAMBER', 'JUNCTION', 'man_chamber', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('CIRC_MANHOLE', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('HIGH POINT', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('REGISTER', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('SECTION CHANGE', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('VIRTUAL NODE', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('WEIR', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('JUMP', 'WJUMP', 'JUNCTION', 'man_wjump', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('RECT_MANHOLE', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('SANDBOX', 'NETINIT', 'JUNCTION', 'man_netinit', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('WWTP', 'WWTP', 'JUNCTION', 'man_wwtp', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('VALVE', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('SEWER STORAGE', 'STORAGE', 'STORAGE', 'man_storage', 'inp_storage', 'om_visit_x_node');
INSERT INTO node_type VALUES ('OWERFLOWS STORAGE', 'STORAGE', 'STORAGE', 'man_storage', 'inp_storage', 'om_visit_x_node');
INSERT INTO node_type VALUES ('OUTFALL', 'OUTFALL', 'OUTFALL', 'man_outfall', 'inp_outfall', 'om_visit_x_node');
INSERT INTO node_type VALUES ('NETGULLY', 'NETGULLY', 'JUNCTION', 'man_netgully', 'inp_junction', 'om_visit_x_node');



-- ----------------------------
-- Records of arc type system table
-- ----------------------------

INSERT INTO arc_type VALUES ('CONDUIT', 'CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit', 'om_visit_x_arc');
INSERT INTO arc_type VALUES ('PUMP PIPE', 'CONDUIT', 'FORCE_MAIN', 'man_conduit', 'inp_conduit', 'om_visit_x_arc');
INSERT INTO arc_type VALUES ('SIPHON', 'SIPHON', 'CONDUIT', 'man_siphon', 'inp_conduit', 'om_visit_x_arc');
INSERT INTO arc_type VALUES ('WACCEL', 'WACCEL', 'CONDUIT', 'man_waccel', 'inp_conduit', 'om_visit_x_arc');
INSERT INTO arc_type VALUES ('VARC', 'VARC', 'OUTLET', 'man_varc', 'inp_outlet', 'om_visit_x_arc');


-- ----------------------------
-- Records of connec_type
-- ----------------------------
INSERT INTO connec_type VALUES ('CONNEC', 'CONNEC', 'man_connec' ,'om_visit_x_connec');



-- ----------------------------
-- Records of element type system table
-- ----------------------------
INSERT INTO "element_type" VALUES ('COVER', 'COVER');
INSERT INTO "element_type" VALUES ('STEP', 'STEP');
INSERT INTO "element_type" VALUES ('PUMP', 'PUMP');
INSERT INTO "element_type" VALUES ('GATE', 'GATE');