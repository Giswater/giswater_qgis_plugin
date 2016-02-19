/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Records of node type system table
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('CURVE','JUNCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('REDUCTION','JUNCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('LUVE','JUNCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('ADAPTATION','JUNCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('JUNCTION','JUNCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('ENDLINE','JUNCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('X','JUNCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('T','JUNCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('TAP','JUNCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
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
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('SHUTOFF VALVE','PIPE', 'man_arc_valve', 'PIPE', 'inp_pipe');
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('CHECK VALVE','PIPE', 'man_arc_valve', 'PIPE', 'inp_pipe');
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
INSERT INTO "SCHEMA_NAME"."cat_mat_node" VALUES ('N/I', null, null, null, null, null, null);
INSERT INTO "SCHEMA_NAME"."cat_mat_node" VALUES ('PVC', 'PVC', 0.011, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc.svg');
INSERT INTO "SCHEMA_NAME"."cat_mat_node" VALUES ('IRON', 'IRON', 0.011, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'iron.svg');


-- ----------------------------
-- Records of cat_mat
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."cat_mat_arc" VALUES ('N/I', null, null, null, null, null, null);
INSERT INTO "SCHEMA_NAME"."cat_mat_arc" VALUES ('PVC', 'PVC', 0.011, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc.svg');
INSERT INTO "SCHEMA_NAME"."cat_mat_arc" VALUES ('IRON', 'IRON', 0.011, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'iron.svg');


-- ----------------------------
-- Records of cat_arc
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."cat_arc" VALUES ('PVC63-PN10','PIPE', 'PVC', '10 atm', '63 mm', 60, 63, 'PVC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc63_pn10.svg' );
INSERT INTO "SCHEMA_NAME"."cat_arc" VALUES ('PVC110-PN16','PIPE', 'PVC', '16 atm', '110 mm', 105, 110, 'PVC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc110_pn16.svg' );
INSERT INTO "SCHEMA_NAME"."cat_arc" VALUES ('PVC200-PN16','PIPE', 'PVC', '16 atm', '200 mm', 186, 200, 'PVC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc200_pn16.svg' );
INSERT INTO "SCHEMA_NAME"."cat_arc" VALUES ('CHK-VALVE100-PN10','CHECK VALVE', 'IRON', '10 atm', '100 mm', 95, 100, 'Check valve', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'chkvalve.svg' );
INSERT INTO "SCHEMA_NAME"."cat_arc" VALUES ('CHK-VALVE200-PN10','CHECK VALVE', 'IRON', '10 atm', '200 mm', 186, 200, 'Check valve', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'chkvalve.svg' );
INSERT INTO "SCHEMA_NAME"."cat_arc" VALUES ('CHK-VALVE300-PN10','CHECK VALVE', 'IRON', '10 atm', '300 mm', 186, 200, 'Check valve', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'chkvalve.svg' );
INSERT INTO "SCHEMA_NAME"."cat_arc" VALUES ('PRV-VALVE100-PN6/16','PR-REDUC.VALVE', 'IRON', '6-16 atm', '100 mm', 86, 100, 'Pressure reduction valve', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'prv.svg' );
INSERT INTO "SCHEMA_NAME"."cat_arc" VALUES ('PRV-VALVE200-PN6/16','PR-REDUC.VALVE', 'IRON', '6-16 atm', '200 mm', 186, 200, 'Pressure reduction valve', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'prv.svg' );
INSERT INTO "SCHEMA_NAME"."cat_arc" VALUES ('PUMP-01','PUMP STATION', 'IRON', '16 atm', '110 mm', 186, 200, 'Pump station', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pump.svg' );
INSERT INTO "SCHEMA_NAME"."cat_arc" VALUES ('FILTER-01','FILTER', 'IRON', '16 atm', '110 mm', 186, 200, 'Filter', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'filter.svg' );
INSERT INTO "SCHEMA_NAME"."cat_arc" VALUES ('FLOWMETER-01','FLOW METER', 'IRON', '16 atm', '100 mm', 186, 200, 'Flow meter', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'flowmeter.svg' );
INSERT INTO "SCHEMA_NAME"."cat_arc" VALUES ('FLOWMETER-02','FLOW METER', 'IRON', '16 atm', '100 mm', 186, 200, 'Flow meter', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'flowmeter.svg' );


-- ----------------------------
-- Records of cat_node
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('CURVE30DN110 PVCPN16','CURVE','PVC',null, null, '16 atm', '100 mm', null, null, 30, null, null, null, 'PVC curve', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'curve30.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('CURVE45DN110 PVCPN16','CURVE','PVC',null, null, '16 atm', '100 mm', null, null, 45, null, null, null, 'PVC curve', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'curve45.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('TDN110-63 PN16','T','PVC',null, null, '16 atm', '110 mm', '63 mm', null, null, null, null, null, 'PVC T', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 't_noequal.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('TDN110-110 PN16','T','IRON','IRON', 'PVC', '16 atm', '110 mm', '110 mm', null, null, null, null, null, 'PVC T', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 't_equal.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('TANK_01','TANK','IRON',null, null, null, null, null, null, null, null, null, null, 'Tank', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'tank.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('HYDRANT 1X110-2X63','HYDRANT','IRON',null, null, '16 atm', '110 mm', '63 mm', null, null, null, null, null, 'Green valve 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'hydrant_1x110_2x63.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('HYDRANT 1X110','HYDRANT','IRON',null, null, '16 atm', '110 mm', null, null, null, null, null, null, 'Green valve 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'hydrant_1x110.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('GREENVALVEDN63 PN16','GREEN VALVE','IRON',null, null, '16 atm', '63 mm', null, null, null, null, null, null, 'Green valve 63mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'greenvalve.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('GREENVALVEDN110 PN16','GREEN VALVE','IRON',null, null, '16 atm', '110 mm', null, null, null, null, null, null, 'Green valve 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'greenvalve.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('GREENVALVEDN50 PN16','GREEN VALVE','IRON',null, null, '16 atm', '50 mm', null, null, null, null, null, null, 'Green valve 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'greenvalve.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('PRESSUREMETERDN63 PN16','PRESSURE METER','IRON',null, null, '16 atm', '63 mm', null, null, null, null, null, null, 'Pressure meter 63mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pressuremeter.svg' );


-- ----------------------------
-- Records of value_state
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."value_state" VALUES ('ON_SERVICE');
INSERT INTO "SCHEMA_NAME"."value_state" VALUES ('RECONSTRUCT');
INSERT INTO "SCHEMA_NAME"."value_state" VALUES ('REPLACE');
INSERT INTO "SCHEMA_NAME"."value_state" VALUES ('PLANIFIED');


-- ----------------------------
-- Records of value_verified
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."value_verified" VALUES ('TO REVIEW');
INSERT INTO "SCHEMA_NAME"."value_verified" VALUES ('VERIFIED');


-- ----------------------------
-- Default values of state selection
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."state_selection" VALUES ('ON_SERVICE');


-- ----------------------------
-- Records of cat_connec
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."cat_connec" VALUES ('CONNEC NO DATA', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);


-- ----------------------------
-- Records of cat_soil
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."cat_soil" VALUES ('SOIL NO DATA', null, null, null, null);


-- ----------------------------
-- Records of cat_builder
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."cat_builder" VALUES ('BUILDER NO DATA', null, null, null, null);


-- ----------------------------
-- Records of cat_work
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."cat_work" VALUES ('WORK NO DATA', null, null, null);


-- ----------------------------
-- Records of cat_owner
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."cat_owner" VALUES ('OWNER NO DATA', null, null, null);


-- ----------------------------
-- Records of man_type_category
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."man_type_category" VALUES ('NO CATEGORY DATA', null);


-- ----------------------------
-- Records of man_type_fluid
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."man_type_fluid" VALUES ('NO FLUID DATA', null);


-- ----------------------------
-- Records of man_type_location
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."man_type_location" VALUES ('NO LOCATION DATA', null);

