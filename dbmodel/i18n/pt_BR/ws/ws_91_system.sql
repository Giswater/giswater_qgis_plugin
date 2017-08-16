/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- Records of node type system table
-- ----------------------------
INSERT INTO node_type VALUES ('ADAPTATION', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('CHECK VALVE', 'VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', 'om_visit_x_node');
INSERT INTO node_type VALUES ('AIR VALVE', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('PR-REDUC.VALVE', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', 'om_visit_x_node');
INSERT INTO node_type VALUES ('LUVE', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('GREEN VALVE', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('FLOW METER', 'MEASURE INSTRUMENT', 'SHORTPIPE', 'man_meter', 'inp_shortpipe', 'om_visit_x_node');
INSERT INTO node_type VALUES ('CURVE', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('FILTER', 'FILTER', 'SHORTPIPE', 'man_filter', 'inp_shortpipe', 'om_visit_x_node');
INSERT INTO node_type VALUES ('ENDLINE', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('FL-CONTR.VALVE', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', 'om_visit_x_node');
INSERT INTO node_type VALUES ('GEN-PURP.VALVE', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', 'om_visit_x_node');
INSERT INTO node_type VALUES ('HYDRANT', 'HYDRANT', 'JUNCTION', 'man_hydrant', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('PR-BREAK.VALVE', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', 'om_visit_x_node');
INSERT INTO node_type VALUES ('OUTFALL VALVE', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('JUNCTION', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('PRESSURE METER', 'MEASURE INSTRUMENT', 'JUNCTION', 'man_meter', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('PR-SUSTA.VALVE', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', 'om_visit_x_node');
INSERT INTO node_type VALUES ('SHUTOFF VALVE', 'VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', 'om_visit_x_node');
INSERT INTO node_type VALUES ('REDUCTION', 'REDUCTION', 'JUNCTION', 'man_reduction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('PUMP STATION', 'PUMP', 'PUMP', 'man_pump', 'inp_pump', 'om_visit_x_node');
INSERT INTO node_type VALUES ('TANK', 'TANK', 'TANK', 'man_tank', 'inp_tank', 'om_visit_x_node');
INSERT INTO node_type VALUES ('THROTTLE VALVE', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', 'om_visit_x_node');
INSERT INTO node_type VALUES ('T', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('WATERWELL', 'JUNCTION', 'JUNCTION', 'man_waterwell', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('TAP', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction,', 'om_visit_x_node');
INSERT INTO node_type VALUES ('X', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('SOURCE', 'SOURCE', 'JUNCTION', 'man_source', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('MANHOLE', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction', 'om_visit_x_node');

-- ----------------------------
-- Records of arc type system table
-- ----------------------------
INSERT INTO arc_type VALUES ('PIPE', 'PIPE', 'PIPE', 'man_pipe', 'inp_pipe', 'om_visit_x_arc');


-- ----------------------------
-- Records of connec_type system table
-- ----------------------------
INSERT INTO connec_type VALUES ('GREEN_TAP', 'GREEN TAP', 'man_greentap', 'om_visit_x_connec');
INSERT INTO connec_type VALUES ('WJOIN', 'WJOIN', 'man_wjoin', 'om_visit_x_connec');
INSERT INTO connec_type VALUES ('FOUNTAIN', 'FOUNTAIN', 'man_fountain', 'om_visit_x_connec');
INSERT INTO connec_type VALUES ('TAP', 'TAP', 'man_tap', 'om_visit_x_connec');


-- ----------------------------
-- Records of element type system table
-- ----------------------------
INSERT INTO element_type VALUES ('REGISTER', 'REGISTER');
INSERT INTO element_type VALUES ('MANHOLE', 'MANHOLE');
INSERT INTO element_type VALUES ('COVER', 'COVER');
INSERT INTO element_type VALUES ('STEP', 'STEP');

