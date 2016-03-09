/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Records of cat_mat_arc
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."cat_mat_arc" VALUES ('N/I', null, null, null, null ,null);
INSERT INTO "SCHEMA_NAME"."cat_mat_arc" VALUES ('PVC', 'PVC', 0.011, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO "SCHEMA_NAME"."cat_mat_arc" VALUES ('IRON', 'IRON', 0.011, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');


-- ----------------------------
-- Records of cat_mat_node
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."cat_mat_node" VALUES ('N/I', null, null, null, null, null);
INSERT INTO "SCHEMA_NAME"."cat_mat_node" VALUES ('PVC', 'PVC', 0.011, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO "SCHEMA_NAME"."cat_mat_node" VALUES ('IRON', 'IRON', 0.011, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO "SCHEMA_NAME"."cat_mat_node" VALUES ('IRON-IRON-PVC', 'IRON-IRON-PVC', null, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');


-- ----------------------------
-- Records of cat_mat_element
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."cat_mat_element" VALUES ('N/I', null, null, null, null);
INSERT INTO "SCHEMA_NAME"."cat_mat_element" VALUES ('FD', 'FD', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');


-- ----------------------------
-- Records of cat_arc
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."cat_arc" VALUES ('PVC63-PN10','PIPE', 'PVC', '10 atm', '63 mm', 60, 63, 'PVC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc63_pn10.svg' );
INSERT INTO "SCHEMA_NAME"."cat_arc" VALUES ('PVC110-PN16','PIPE', 'PVC', '16 atm', '110 mm', 105, 110, 'PVC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc110_pn16.svg' );
INSERT INTO "SCHEMA_NAME"."cat_arc" VALUES ('PVC200-PN16','PIPE', 'PVC', '16 atm', '200 mm', 186, 200, 'PVC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc200_pn16.svg' );


-- ----------------------------
-- Records of cat_node
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('CURVE30DN110 PVCPN16','CURVE','PVC','16 atm', '100 mm', null, '110ext x 100int', 'PVC curve', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'curve30.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('CURVE45DN110 PVCPN16','CURVE','PVC','16 atm', '100 mm', null, '110ext x 100int', 'PVC curve', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'curve45.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('TDN110-63 PN16','T','PVC','16 atm', '110-110-63mm', null, 'PVC T', null, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 't_noequal.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('TDN110-110 PN16','T','IRON-IRON-PVC','16 atm', '110-110-110mm', null, '110 mm', 'PVC T', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 't_equal.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('TANK_01','TANK','IRON',null, null, null,'30x10x3m', 'Tank', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'tank.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('HYDRANT 1X110-2X63','HYDRANT','IRON', '16 atm', '110 mm', null, '110-63 mm', 'Green valve 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'hydrant_1x110_2x63.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('HYDRANT 1X110','HYDRANT','IRON', '16 atm', '110 mm',  null, '110ext x 100int', 'Green valve 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'hydrant_1x110.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('GREENVALVEDN63 PN16','GREEN VALVE','IRON','16 atm', '63 mm',  null, '63 mm', 'Green valve 63mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'greenvalve.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('GREENVALVEDN110 PN16','GREEN VALVE','IRON', '16 atm', '110 mm', null, '110 mm','Green valve 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'greenvalve.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('GREENVALVEDN50 PN16','GREEN VALVE','IRON', '16 atm', '50 mm', null, '50 mm', 'Green valve 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'greenvalve.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('PRESSUREMETERDN63 PN16','PRESSURE METER','IRON', '16 atm', '63 mm', null, '63 mm', 'Pressure meter 63mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pressuremeter.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('CHK-VALVE100-PN10','CHECK VALVE', 'IRON', '10 atm', '100 mm', 95, 'Check valve', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'chkvalve.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('CHK-VALVE200-PN10','CHECK VALVE', 'IRON', '10 atm', '200 mm', 186, 'Check valve', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'chkvalve.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('CHK-VALVE300-PN10','CHECK VALVE', 'IRON', '10 atm', '300 mm', 186,  'Check valve', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'chkvalve.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('PRV-VALVE100-PN6/16','PR-REDUC.VALVE', 'IRON', '6-16 atm', '100 mm', 86,  'Pressure reduction valve', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'prv.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('PRV-VALVE200-PN6/16','PR-REDUC.VALVE', 'IRON', '6-16 atm', '200 mm', 186,  'Pressure reduction valve', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'prv.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('PUMP-01','PUMP STATION', 'IRON', '16 atm', '110 mm', 186,  'Pump station', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pump.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('FILTER-01','FILTER', 'IRON', '16 atm', '110 mm', 186,  'Filter', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'filter.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('FLOWMETER-01','FLOW METER', 'IRON', '16 atm', '100 mm', 186, 'Flow meter', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'flowmeter.svg' );
INSERT INTO "SCHEMA_NAME"."cat_node" VALUES ('FLOWMETER-02','FLOW METER', 'IRON', '16 atm', '100 mm', 186, 'Flow meter', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'flowmeter.svg' );


-- ----------------------------
-- Records of cat_element
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."cat_element" VALUES ('COVER', 'COVER', 'FD', '60CM', 'Cover fd', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'Cover fd.svg' );


-- ----------------------------
-- Records of cat_connec
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."cat_connec" VALUES ('CONNEC NO DATA', null, null, null, null, null, null, null, null, null, null);


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

