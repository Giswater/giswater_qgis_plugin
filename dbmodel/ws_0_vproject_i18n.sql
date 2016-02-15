/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Records of node type system table
-- ----------------------------

INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('CURVE','JUCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('REDUCTION','JUCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('LUVE','JUCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('ADAPTATION','JUCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('JUNCTION','JUCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('ENDLINE','JUCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('X','JUCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('T','JUCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('TAP','JUCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('TANK','TANK', 'man_node_tank', 'TANK', 'inp_tank');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('HYDRANT','HYDRANT', 'man_node_hydrant', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('GREEN VALVE','VALVE', 'man_node_valve', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('AIR VALVE','VALVE', 'man_node_valve', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('OUTFALL VALVE','VALVE', 'man_node_valve', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('PRESSURE METER','MEASURE INSTRUMENT', 'man_node_meter', 'JUNCTION', 'inp_junction');


-- ----------------------------
-- Records of arc type system table
-- ----------------------------

INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('PIPE','PIPE', 'man_arc_pipe', 'PIPE', 'inp_pipe');
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('SHUTOFF VALVE','PIPE', 'man_arc_pipe', 'PIPE', 'inp_pipe');
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('CHECK VALVE','PIPE', 'man_arc_pipe', 'PIPE', 'inp_pipe');
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('PR-REDUC.VALVE','VALVE', 'man_arc_valve', 'VALVE', 'inp_valve');
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('PR-SUSTA.VALVE','VALVE', 'man_arc_valve', 'VALVE', 'inp_valve');
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('PR-BREAK.VALVE','VALVE', 'man_arc_valve', 'VALVE', 'inp_valve');
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('FL-CONTR.VALVE','VALVE', 'man_arc_valve', 'VALVE', 'inp_valve');
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('THROTTLE VALVE','VALVE', 'man_arc_valve', 'VALVE', 'inp_valve');
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('GEN-PURP.VALVE','VALVE', 'man_arc_valve', 'VALVE', 'inp_valve');
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('PUMP STATION','PUMP', 'man_arc_pump', 'PUMP', 'inp_pump');
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('FILTER','FILTER', 'man_arc_filter', 'PIPE', 'inp_pipe');
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('FLOW METER','MEASURE INSTRUMENT', 'man_arc_meter', 'PIPE', 'inp_pipe');



-- ----------------------------
-- Records of cat_mat
-- ----------------------------




-- ----------------------------
-- Records of cat_arc
-- ----------------------------




-- ----------------------------
-- Records of cat_node
-- ----------------------------




-- ----------------------------
-- Records of value_state
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."inp_value_state" VALUES ('ON_SERVICE');
INSERT INTO "SCHEMA_NAME"."inp_value_state" VALUES ('RECONSTRUCT');
INSERT INTO "SCHEMA_NAME"."inp_value_state" VALUES ('REPLACE');
INSERT INTO "SCHEMA_NAME"."inp_value_state" VALUES ('PLANIFIED');
