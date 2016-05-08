/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Records of cat_mat_arc
-- ----------------------------
INSERT INTO "SCHEMA_NAME".cat_mat_arc VALUES ('N/I', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "SCHEMA_NAME".cat_mat_arc VALUES ('PVC', 'PVC', 150.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO "SCHEMA_NAME".cat_mat_arc VALUES ('FD', 'Iron', 120.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO "SCHEMA_NAME".cat_mat_arc VALUES ('FC', 'Fiberconcret', 150.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO "SCHEMA_NAME".cat_mat_arc VALUES ('PE-HD', 'PE high density', 140.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO "SCHEMA_NAME".cat_mat_arc VALUES ('PE-LD', 'PE low density', 130.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');


-- ----------------------------
-- Records of cat_mat_element
-- ----------------------------
INSERT INTO "SCHEMA_NAME".cat_mat_element VALUES ('N/I', NULL, NULL, NULL, NULL);
INSERT INTO "SCHEMA_NAME".cat_mat_element VALUES ('FD', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', NULL);
INSERT INTO "SCHEMA_NAME".cat_mat_element VALUES ('CONCRET', NULL, NULL, NULL, NULL);
INSERT INTO "SCHEMA_NAME".cat_mat_element VALUES ('BRICK+IRON', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_mat_node
-- ----------------------------
INSERT INTO "SCHEMA_NAME".cat_mat_node VALUES ('N/I', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "SCHEMA_NAME".cat_mat_node VALUES ('PVC', 'PVC', 150.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO "SCHEMA_NAME".cat_mat_node VALUES ('FD', 'Iron', 120.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO "SCHEMA_NAME".cat_mat_node VALUES ('FD-FD-PVC', 'Iron-Iron-PVC', NULL, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO "SCHEMA_NAME".cat_mat_node VALUES ('CC', 'Concret', 100.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO "SCHEMA_NAME".cat_mat_node VALUES ('FC-FC-FC', 'Fiberconcret', 150.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO "SCHEMA_NAME".cat_mat_node VALUES ('FC', 'Fiberconcret', 150.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');


-- ----------------------------
-- Records of cat_arc
-- ---------------------------
INSERT INTO "SCHEMA_NAME".cat_arc VALUES ('PVC63-PN10', 'PIPE', 'PVC', '10 atm', '63 mm', 60.00000, 63.00000, 'PVC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc63_pn10.svg');
INSERT INTO "SCHEMA_NAME".cat_arc VALUES ('PVC110-PN16', 'PIPE', 'PVC', '16 atm', '110 mm', 105.00000, 110.00000, 'PVC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc110_pn16.svg');
INSERT INTO "SCHEMA_NAME".cat_arc VALUES ('PVC200-PN16', 'PIPE', 'PVC', '16 atm', '200 mm', 186.00000, 200.00000, 'PVC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc200_pn16.svg');
INSERT INTO "SCHEMA_NAME".cat_arc VALUES ('FD150', 'PIPE', 'FD', NULL, '150 mm', 150.00000, 170.00000, 'FD pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'fd150.svg');
INSERT INTO "SCHEMA_NAME".cat_arc VALUES ('FD200', 'PIPE', 'FD', NULL, '200 mm', 200.00000, 222.00000, 'FD pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'fd200.svg');
INSERT INTO "SCHEMA_NAME".cat_arc VALUES ('PEHD110-PN16', 'PIPE', 'PE-HD', '16 atm', '110 mm', 100.00000, 110.00000, 'PEHD pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pehd110_pn16.svg');
INSERT INTO "SCHEMA_NAME".cat_arc VALUES ('PELD110-PN10', 'PIPE', 'PE-LD', '10 atm', '110 mm', 100.00000, 110.00000, 'PELD pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'peld110_pn10.svg');
INSERT INTO "SCHEMA_NAME".cat_arc VALUES ('PVC160-PN16', 'PIPE', 'PVC', '16 atm', '160 mm', 150.00000, 160.00000, 'PVC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc160_pn16.svg');
INSERT INTO "SCHEMA_NAME".cat_arc VALUES ('FC63-PN10', 'PIPE', 'FC', '10 atm', '63 mm', 55.00000, 63.00000, 'FC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'fc63_pn10.svg');
INSERT INTO "SCHEMA_NAME".cat_arc VALUES ('FC110-PN10', 'PIPE', 'FC', '10 atm', '110 mm', 100.00000, 110.00000, 'FC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'fc110_pn10.svg');
INSERT INTO "SCHEMA_NAME".cat_arc VALUES ('FC160-PN10', 'PIPE', 'FC', '10 atm', '160 mm', 150.00000, 160.00000, 'FC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'fc160_pn10.svg');


-- ----------------------------
-- Records of cat_node
-- ----------------------------
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('SHUTOFFVALVEDN160 PN16', 'SHUTOFF VALVE', 'FD', '16 atm', '160 mm', 148.00000, '160 mm', 'Shutoff valve 160 mm', NULL, NULL, NULL, NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('SHUTOFFVALVEDN110 PN16', 'SHUTOFF VALVE', 'FD', '16 atm', '110 mm', 100.00000, '110 mm', 'Shutoff valve 110 mm', NULL, NULL, NULL, NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('SHUTOFFVALVEDN63 PN16', 'SHUTOFF VALVE', 'FD', '16 atm', '63 mm', 55.00000, '63 mm', 'Shutoff valve 63 mm', NULL, NULL, NULL, NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('JUNCTION DN63', 'JUNCTION', 'FD', '16 atm', NULL, NULL, '63 mm', 'Juntion 63mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('JUNCTION DN110', 'JUNCTION', 'FD', '16 atm', NULL, NULL, '110 mm', 'Juntion 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('JUNCTION DN160', 'JUNCTION', 'FD', '16 atm', NULL, NULL, '160 mm', 'Juntion 160mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('JUNCTION DN200', 'JUNCTION', 'FD', '16 atm', NULL, NULL, '200 mm', 'Juntion 200mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('OUTFALL VALVE-01', 'OUTFALL VALVE', 'FD', '16 atm', NULL, NULL, NULL, 'Outfall valve ', NULL, NULL, NULL, NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('PRESSUREMETERDN63 PN16', 'PRESSURE METER', 'FD', '16 atm', '63 mm', NULL, '63 mm', 'Pressure meter 63 mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pressuremeter.svg');
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('PRESSUREMETERDN110 PN16', 'PRESSURE METER', 'FD', '16 atm', '110 mm', NULL, '110 mm', 'Pressure meter 110 mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pressuremeter.svg');
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('CHK-VALVE100-PN10', 'CHECK VALVE', 'FD', '10 atm', '100 mm', 95.00000, 'Check valve', 'Check valve 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'chkvalve.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('HYDRANT 1X110-2X63', 'HYDRANT', 'FD', '16 atm', '110 mm', NULL, '110-63 mm', 'Green valve 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'hydrant_1x110_2x63.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('TDN160-110 PN16', 'T', 'FD', '16 atm', '110-160-160 mm', NULL, '110-160-160 mm', 'FD T', NULL, NULL, 't_noequal.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('GREENVALVEDN63 PN16', 'GREEN VALVE', 'FD', '16 atm', '63 mm', NULL, '63 mm', 'Green valve 63mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'greenvalve.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('GREENVALVEDN110 PN16', 'GREEN VALVE', 'FD', '16 atm', '110 mm', NULL, '110 mm', 'Green valve 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'greenvalve.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('GREENVALVEDN50 PN16', 'GREEN VALVE', 'FD', '16 atm', '50 mm', NULL, '50 mm', 'Green valve 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'greenvalve.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('PRV-VALVE200-PN6/16', 'PR-REDUC.VALVE', 'FD', '6-16 atm', '200 mm', 186.00000, '200 mm', 'Pressure reduction valve', 'c:\\users\users\catalog.jpg', 'http://url.info', 'prv.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('CHK-VALVE200-PN10', 'CHECK VALVE', 'FD', '10 atm', '200 mm', 186.00000, 'Check valve', 'Check valve 200mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'chkvalve.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('CHK-VALVE300-PN10', 'CHECK VALVE', 'FD', '10 atm', '300 mm', 186.00000, 'Check valve', 'Check valve 300mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'chkvalve.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('AIR VALVE DN50', 'AIR VALVE', 'FD', '16 atm', '50 mm', NULL, '50 mm', 'Air valve 50mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'airvalve.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('TDN63-63 PN16', 'T', 'PVC', '16 atm', '63-63-63 mm', NULL, '63-63-63 mm', 'PVC T', NULL, NULL, 't_equal.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('TDN110-110 PN16', 'T', 'FD', '16 atm', '110-110-110 mm', NULL, '110-110-110 mm', 'FD T', 'c:\\users\users\catalog.pdf', 'http://url.info', 't_equal.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('PUMP-01', 'PUMP STATION', 'FD', '16 atm', '110 mm', 100.00000, '110 mm', 'Pump station', 'c:\\users\users\catalog.jpg', 'http://url.info', 'pump.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('PRV-VALVE150-PN6/16', 'PR-REDUC.VALVE', 'FD', '6-16 atm', '150 mm', 148.00000, '150 mm', 'Pressure reduction valve', 'c:\\users\users\catalog.jpg', 'http://url.info', 'prv.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('FLOWMETER-02', 'FLOW METER', 'FD', '16 atm', '110 mm', 100.00000, 'FM 110 mm', 'Flow meter 110 mm', 'c:\\users\users\catalog.jpg', 'http://url.info', 'flowmeter.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('TDN160-160 PN16', 'T', 'FD', '16 atm', '160-160-160 mm', NULL, '160-160-160 mm', 'FD T', NULL, NULL, 't_equal.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('CURVE30DN110 PVCPN16', 'CURVE', 'PVC', '16 atm', '100 mm', NULL, '110ext x 100 int', 'PVC curve', 'c:\\users\users\catalog.pdf', 'http://url.info', 'curve30.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('TDN160-110-63 PN16', 'T', 'FD', '16 atm', '160-110-63 mm', NULL, '160-110-63 m', 'FD T', NULL, NULL, 't_noequal.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('CURVE45DN110 PVCPN16', 'CURVE', 'PVC', '16 atm', '100 mm', NULL, '110ext x 100 int', 'PVC curve', 'c:\\users\users\catalog.pdf', 'http://url.info', 'curve45.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('ENDLINE', 'ENDLINE', 'PVC', '16 atm', NULL, NULL, NULL, 'End line', NULL, NULL, 'endline.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('FILTER-01', 'FILTER', 'FD', '16 atm', '200 mm', 186.00000, 'F 200 mm', 'Filter 200 mm', 'c:\\users\users\catalog.jpg', 'http://url.info', 'filter.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('FLOWMETER-01', 'FLOW METER', 'FD', '16 atm', '200 mm', 186.00000, 'FM 200 mm', 'Flow meter 200 mm', 'c:\\users\users\catalog.jpg', 'http://url.info', 'flowmeter.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('CHK-VALVE63-PN10', 'CHECK VALVE', 'FD', '10 atm', '63 mm', 55.00000, 'Check valve', 'Check valve 63mm', 'c:\\users\users\catalog.jpg', 'http://url.info', 'chkvalve.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('PRV-VALVE100-PN6/16', 'PR-REDUC.VALVE', 'FD', '6-16 atm', '100 mm', 86.00000, '100 mm', 'Pressure reduction valve', 'c:\\users\users\catalog.jpg', 'http://url.info', 'prv.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('TANK_01', 'TANK', 'FD', NULL, NULL, NULL, '30x10x3 m', 'Tank', 'c:\\users\users\catalog.pdf', 'http://url.info', 'tank.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('HYDRANT 1X110', 'HYDRANT', 'FD', '16 atm', '110 mm', NULL, '110ext x 100 int', 'Green valve 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'hydrant_1x110.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('TDN110-63 PN16', 'T', 'PVC', '16 atm', '110-110-63 mm', NULL, '110-110-63 mm', 'PVC T', 'c:\\users\users\catalog.pdf', 'http://url.info', 't_noequal.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('TDN160-63 PN16', 'T', 'FD', '16 atm', '160-160-63 mm', NULL, '160-160-63 mm', 'FD T', NULL, NULL, 't_noequal.svg', NULL);
INSERT INTO "SCHEMA_NAME".cat_node VALUES ('TDN200-160 PN16', 'T', 'FD', '16 atm', '200-160-160 mm', NULL, '200-160-160 mm', 'FD T', NULL, NULL, 't_noequal.svg', NULL);


-- ----------------------------
-- Records of cat_connec
-- ----------------------------
INSERT INTO "SCHEMA_NAME".cat_connec VALUES ('PVC25-PN16-DOM', 'DOMESTIC', 'PVC', '16 atm', '25 mm', NULL, 'PVC connec', NULL, NULL, NULL, NULL);
INSERT INTO "SCHEMA_NAME".cat_connec VALUES ('PVC32-PN16-DOM', 'DOMESTIC', 'PVC', '16 atm', '32 mm', NULL, 'PVC connec', NULL, NULL, NULL, NULL);
INSERT INTO "SCHEMA_NAME".cat_connec VALUES ('PVC32-PN16-TRA', 'TRADE', 'PVC', '16 atm', '32 mm', NULL, 'PVC connec', NULL, NULL, NULL, NULL);
INSERT INTO "SCHEMA_NAME".cat_connec VALUES ('PVC50-PN16-IND', 'INDUSTRIAL', 'PVC', '16 atm', '50 mm', NULL, 'PVC connec', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_element
-- ----------------------------
INSERT INTO "SCHEMA_NAME".cat_element VALUES ('COVER', 'COVER', 'FD', '60 cm', 'Cover fd', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'Cover fd.svg');
INSERT INTO "SCHEMA_NAME".cat_element VALUES ('COVER40X40', 'COVER', 'FD', '40x40 cm', 'Cover fd', NULL, NULL, NULL, NULL);
INSERT INTO "SCHEMA_NAME".cat_element VALUES ('VREGISTER200X200', 'REGISTER', 'BRICK+IRON', '200x200 cm', 'Vertical register concret/Iron', NULL, NULL, NULL, NULL);
INSERT INTO "SCHEMA_NAME".cat_element VALUES ('REGISTER40X40', 'REGISTER', 'CONCRET', '40x40 cm', 'Register concret 40x40', NULL, NULL, NULL, NULL);
INSERT INTO "SCHEMA_NAME".cat_element VALUES ('REGISTER60X60', 'REGISTER', 'CONCRET', '60x60 cm', 'Register concret 60x60', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_builder
-- ----------------------------
INSERT INTO "SCHEMA_NAME".cat_builder VALUES ('BUILDER NO DATA', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_owner
-- ----------------------------
INSERT INTO "SCHEMA_NAME".cat_owner VALUES ('OWNER NO DATA', NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_soil
-- ----------------------------
INSERT INTO "SCHEMA_NAME".cat_soil VALUES ('SOIL NO DATA', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_work
-- ----------------------------
INSERT INTO "SCHEMA_NAME".cat_work VALUES ('WORK NO DATA', NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_event
-- ----------------------------
INSERT INTO "SCHEMA_NAME".cat_event VALUES ('EV03', 'INSPECTION', 'Inspecció 2016', NULL);
INSERT INTO "SCHEMA_NAME".cat_event VALUES ('EV01', 'INSPECTION', 'Inspecció 2015', NULL);
INSERT INTO "SCHEMA_NAME".cat_event VALUES ('EV02', 'REPAIR', 'Reparació 2015', NULL);


-- ----------------------------
-- Records of cat_tag
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."cat_tag" VALUES ('NO TAG', null);

