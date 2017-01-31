/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;
	


-- ----------------------------
-- Records of cat_mat_arc
-- ----------------------------
INSERT INTO cat_mat_arc VALUES ('N/I', NULL, NULL, NULL, NULL);
INSERT INTO cat_mat_arc VALUES ('PVC', 'PVC', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO cat_mat_arc VALUES ('FD', 'Iron', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO cat_mat_arc VALUES ('FC', 'Fiberconcret', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO cat_mat_arc VALUES ('PE-HD', 'PE high density', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO cat_mat_arc VALUES ('PE-LD', 'PE low density', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');



-- ----------------------------
-- Records of inp_cat_mat_roughness
-- ----------------------------
UPDATE inp_cat_mat_roughness SET period_id='ALL';
UPDATE inp_cat_mat_roughness SET init_age=0;
UPDATE inp_cat_mat_roughness SET end_age=150;
UPDATE inp_cat_mat_roughness SET roughness=100;



-- ----------------------------
-- Records of cat_press_zone
-- ----------------------------
INSERT INTO cat_press_zone VALUES ('HIGH');
INSERT INTO cat_press_zone VALUES ('MEDIUM');
INSERT INTO cat_press_zone VALUES ('LOW');




-- ----------------------------
-- Records of cat_mat_element
-- ----------------------------
INSERT INTO cat_mat_element VALUES ('N/I', NULL, NULL, NULL, NULL);
INSERT INTO cat_mat_element VALUES ('FD', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', NULL);
INSERT INTO cat_mat_element VALUES ('CONCRET', NULL, NULL, NULL, NULL);
INSERT INTO cat_mat_element VALUES ('BRICK+IRON', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_mat_node
-- ----------------------------
INSERT INTO cat_mat_node VALUES ('N/I', NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_mat_node VALUES ('PVC', 'PVC', 150.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO cat_mat_node VALUES ('FD', 'Iron', 120.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO cat_mat_node VALUES ('CC', 'Concret', 100.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO cat_mat_node VALUES ('FC-FC-FC', 'Fiberconcret', 150.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO cat_mat_node VALUES ('FC', 'Fiberconcret', 150.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO cat_mat_node VALUES ('FD-FD-PVC', 'Iron-Iron-PVC', 120.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');


-- ----------------------------
-- Records of cat_arc
-- ---------------------------
INSERT INTO cat_arc VALUES ('PVC63-PN10', 'PIPE', 'PVC', '10 atm', '63 mm', 56.70000, 63.00000, 'PVC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc63_pn10.svg', 0.10, 0.10, 0.06, 0.0031, 0.86, 3.15, 'm', 'A_PVC63_PN10', 'S_REP', 'S_NULL');
INSERT INTO cat_arc VALUES ('PVC110-PN16', 'PIPE', 'PVC', '16 atm', '110 mm', 99.00000, 110.00000, 'PVC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc110_pn16.svg', 0.10, 0.10, 0.11, 0.0095, 0.91, 5.50, 'm', 'A_PVC110_PN16', 'S_REP', 'S_NULL');
INSERT INTO cat_arc VALUES ('PVC200-PN16', 'PIPE', 'PVC', '16 atm', '200 mm', 180.00000, 200.00000, 'PVC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc200_pn16.svg', 0.10, 0.10, 0.20, 0.0314, 1.00, 10.00, 'm', 'A_PVC200_PN16', 'S_REP', 'S_NULL');
INSERT INTO cat_arc VALUES ('FD150', 'PIPE', 'FD', NULL, '150 mm', 153.00000, 170.00000, 'FD pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'fd150.svg', 0.10, 0.10, 0.17, 0.0227, 0.97, 8.50, 'm', 'A_FD150', 'S_REP', 'S_NULL');
INSERT INTO cat_arc VALUES ('FD200', 'PIPE', 'FD', NULL, '200 mm', 199.80000, 222.00000, 'FD pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'fd200.svg', 0.10, 0.10, 0.22, 0.0387, 1.02, 11.10, 'm', 'A_FD200', 'S_REP', 'S_NULL');
INSERT INTO cat_arc VALUES ('PEHD110-PN16', 'PIPE', 'PE-HD', '16 atm', '110 mm', 99.00000, 110.00000, 'PEHD pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pehd110_pn16.svg', 0.10, 0.10, 0.11, 0.0095, 0.91, 5.50, 'm', 'A_PEHD110_PN16', 'S_REP', 'S_NULL');
INSERT INTO cat_arc VALUES ('PELD110-PN10', 'PIPE', 'PE-LD', '10 atm', '110 mm', 99.00000, 110.00000, 'PELD pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'peld110_pn10.svg', 0.10, 0.10, 0.11, 0.0095, 0.91, 5.50, 'm', 'A_PELD110_PN10', 'S_REP', 'S_NULL');
INSERT INTO cat_arc VALUES ('PVC160-PN16', 'PIPE', 'PVC', '16 atm', '160 mm', 144.00000, 160.00000, 'PVC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc160_pn16.svg', 0.10, 0.10, 0.16, 0.0201, 0.96, 8.00, 'm', 'A_PVC160_PN16', 'S_REP', 'S_NULL');
INSERT INTO cat_arc VALUES ('FC63-PN10', 'PIPE', 'FC', '10 atm', '63 mm', 56.70000, 63.00000, 'FC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'fc63_pn10.svg', 0.10, 0.10, 0.06, 0.0031, 0.86, 3.15, 'm', 'A_FC63_PN10', 'S_REP', 'S_NULL');
INSERT INTO cat_arc VALUES ('FC110-PN10', 'PIPE', 'FC', '10 atm', '110 mm', 99.00000, 110.00000, 'FC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'fc110_pn10.svg', 0.10, 0.10, 0.11, 0.0095, 0.91, 5.50, 'm', 'A_FC110_PN10', 'S_REP', 'S_NULL');
INSERT INTO cat_arc VALUES ('FC160-PN10', 'PIPE', 'FC', '10 atm', '160 mm', 144.00000, 160.00000, 'FC pipe', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'fc160_pn10.svg', 0.10, 0.10, 0.16, 0.0201, 0.96, 8.00, 'm', 'A_FC160_PN10', 'S_REP', 'S_NULL');


-- ----------------------------
-- Records of cat_node
-- ----------------------------
INSERT INTO cat_node VALUES ('SHUTOFFVALVEDN160 PN16', 'SHUTOFF VALVE', 'FD', '16 atm', '160 mm', 148.00000, '160 mm', 'Shutoff valve 160 mm', 'c:\users\users\catalog.pdf', 'http://url.info', NULL, NULL, 1.00, NULL, 'N_SHTVAL160_PN16', 2);
INSERT INTO cat_node VALUES ('SHUTOFFVALVEDN110 PN16', 'SHUTOFF VALVE', 'FD', '16 atm', '110 mm', 100.00000, '110 mm', 'Shutoff valve 110 mm', 'c:\users\users\catalog.pdf', 'http://url.info', NULL, NULL, 1.00, NULL, 'N_SHTVAL110_PN16', 2);
INSERT INTO cat_node VALUES ('SHUTOFFVALVEDN63 PN16', 'SHUTOFF VALVE', 'FD', '16 atm', '63 mm', 55.00000, '63 mm', 'Shutoff valve 63 mm', 'c:\users\users\catalog.pdf', 'http://url.info', NULL, NULL, 1.00, NULL, 'N_SHTVAL63_PN16', 2);
INSERT INTO cat_node VALUES ('JUNCTION DN63', 'JUNCTION', 'FD', '16 atm', '63mm', NULL, '63 mm', 'Juntion 63mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', NULL, 1.00, NULL, 'N_JUN63', 2);
INSERT INTO cat_node VALUES ('JUNCTION DN110', 'JUNCTION', 'FD', '16 atm', '110mm', NULL, '110 mm', 'Juntion 110mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', NULL, 1.00, NULL, 'N_JUN110', 2);
INSERT INTO cat_node VALUES ('JUNCTION DN160', 'JUNCTION', 'FD', '16 atm', '160mm', NULL, '160 mm', 'Juntion 160mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', NULL, 1.00, NULL, 'N_JUN160', 2);
INSERT INTO cat_node VALUES ('OUTFALL VALVE-DN150', 'OUTFALL VALVE', 'FD', '16 atm', '150mm', NULL, '150mm', 'Outfall valve ', 'c:\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', NULL, 1.00, NULL, 'N_OUTVAL-01', 1);
INSERT INTO cat_node VALUES ('ENDLINE DN63', 'ENDLINE', 'PVC', '16 atm', '63mm', 63.00000, '63', 'End line', 'c:\users\users\catalog.pdf', 'http://url.info', 'endline.svg', NULL, 1.00, NULL, 'N_ENDLINE', 1);
INSERT INTO cat_node VALUES ('FILTER-01-DN200', 'FILTER', 'FD', '16 atm', '200 mm', 186.00000, 'F 200 mm', 'Filter 200 mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'filter.svg', NULL, 1.00, NULL, 'N_FILTER-01', 2);
INSERT INTO cat_node VALUES ('FLOWMETER-01-DN200', 'FLOW METER', 'FD', '16 atm', '200 mm', 186.00000, 'FM 200 mm', 'Flow meter 200 mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'flowmeter.svg', NULL, 1.00, NULL, 'N_FLOWMETER110', 2);
INSERT INTO cat_node VALUES ('CHK-VALVE63-PN10', 'CHECK VALVE', 'FD', '10 atm', '63 mm', 55.00000, 'Check valve', 'Check valve 63mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'chkvalve.svg', NULL, 1.00, NULL, 'N_CHKVAL63_PN10', 2);
INSERT INTO cat_node VALUES ('PRV-VALVE100-PN6/16', 'PR-REDUC.VALVE', 'FD', '6-16 atm', '100 mm', 86.00000, '100 mm', 'Pressure reduction valve', 'c:\users\users\catalog.pdf', 'http://url.info', 'prv.svg', NULL, 1.00, NULL, 'N_PRVAL100_6/16', 2);
INSERT INTO cat_node VALUES ('TANK_01', 'TANK', 'FD', NULL, NULL, NULL, '30x10x3 m', 'Tank', 'c:\users\users\catalog.pdf', 'http://url.info', 'tank.svg', NULL, 1.00, NULL, 'N_TANK_30x10x3', 1);
INSERT INTO cat_node VALUES ('HYDRANT 1X110', 'HYDRANT', 'FD', '16 atm', '110 mm', NULL, '110ext x 100 int', 'Green valve 110mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'hydrant_1x110.svg', NULL, 1.00, NULL, 'N_HYD_1x100', 2);
INSERT INTO cat_node VALUES ('TDN110-63 PN16', 'T', 'PVC', '16 atm', '110-110-63 mm', NULL, '110-110-63 mm', 'PVC T', 'c:\users\users\catalog.pdf', 'http://url.info', 't_noequal.svg', NULL, 1.00, NULL, 'N_T110-63_PN16', 3);
INSERT INTO cat_node VALUES ('TDN160-63 PN16', 'T', 'FD', '16 atm', '160-160-63 mm', NULL, '160-160-63 mm', 'FD T', 'c:\users\users\catalog.pdf', 'http://url.info', 't_noequal.svg', NULL, 1.00, NULL, 'N_T160-63_PN16', 3);
INSERT INTO cat_node VALUES ('TDN200-160 PN16', 'T', 'FD', '16 atm', '200-160-160 mm', NULL, '200-160-160 mm', 'FD T', 'c:\users\users\catalog.pdf', 'http://url.info', 't_noequal.svg', NULL, 1.00, NULL, 'N_T200-160_PN16', 3);
INSERT INTO cat_node VALUES ('PUMP-01', 'PUMP', 'FD', '16 atm', '110 mm', 100.00000, '110 mm', 'Pump station', 'c:\users\users\catalog.pdf', 'http://url.info', 'pump.svg', NULL, 1.00, NULL, 'N_PUMP-01', 2);
INSERT INTO cat_node VALUES ('CHK-VALVE150-PN10', 'CHECK VALVE', 'FD', '10 atm', '150 mm', 140.00000, 'Check valve', 'Check valve 150mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'chkvalve.svg', NULL, 1.00, NULL, 'N_CHKVAL150_PN10', 2);
INSERT INTO cat_node VALUES ('ENDLINE DN150', 'ENDLINE', 'FD', '16 atm', '150mm', 150.00000, '150', 'End line', 'c:\users\users\catalog.pdf', 'http://url.info', 'curve45.svg', NULL, 1.00, NULL, 'N_ENDLINE', 1);
INSERT INTO cat_node VALUES ('JUNCTION DN200', 'JUNCTION', 'FD', '16 atm', '200mm', NULL, '200 mm', 'Juntion 200mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', NULL, 1.00, NULL, 'N_JUN200', 2);
INSERT INTO cat_node VALUES ('PRESSUREMETERDN63 PN16', 'PRESSURE METER', 'FD', '16 atm', '63 mm', NULL, '63 mm', 'Pressure meter 63 mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pressuremeter.svg', 1.00, NULL, 'N_PRESME200_PN16', 2);
INSERT INTO cat_node VALUES ('PRESSUREMETERDN110 PN16', 'PRESSURE METER', 'FD', '16 atm', '110 mm', NULL, '110 mm', 'Pressure meter 110 mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pressuremeter.svg', 1.00, NULL, 'N_PRESME110_PN16', 2);
INSERT INTO cat_node VALUES ('CHK-VALVE100-PN10', 'CHECK VALVE', 'FD', '10 atm', '100 mm', 95.00000, 'Check valve', 'Check valve 110mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'chkvalve.svg', NULL, 1.00, NULL, 'N_CHKVAL100_PN10', 2);
INSERT INTO cat_node VALUES ('HYDRANT 1X110-2X63', 'HYDRANT', 'FD', '16 atm', '110 mm', NULL, '110-63 mm', 'Green valve 110mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'hydrant_1x110_2x63.svg', NULL, 1.00, NULL, 'N_HYD_1x110-2x63', 2);
INSERT INTO cat_node VALUES ('TDN160-110 PN16', 'T', 'FD', '16 atm', '110-160-160 mm', NULL, '110-160-160 mm', 'FD T', 'c:\users\users\catalog.pdf', 'http://url.info', 't_noequal.svg', NULL, 1.00, NULL, 'N_T160-110_PN16', 3);
INSERT INTO cat_node VALUES ('GREENVALVEDN63 PN16', 'GREEN VALVE', 'FD', '16 atm', '63 mm', NULL, '63 mm', 'Green valve 63mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'greenvalve.svg', NULL, 1.00, NULL, 'N_GREVAL63_PN16', 2);
INSERT INTO cat_node VALUES ('GREENVALVEDN110 PN16', 'GREEN VALVE', 'FD', '16 atm', '110 mm', NULL, '110 mm', 'Green valve 110mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'greenvalve.svg', NULL, 1.00, NULL, 'N_GREVAL110_PN16', 2);
INSERT INTO cat_node VALUES ('GREENVALVEDN50 PN16', 'GREEN VALVE', 'FD', '16 atm', '50 mm', NULL, '50 mm', 'Green valve 110mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'greenvalve.svg', NULL, 1.00, NULL, 'N_GREVAL50_PN16', 2);
INSERT INTO cat_node VALUES ('PRV-VALVE200-PN6/16', 'PR-REDUC.VALVE', 'FD', '6-16 atm', '200 mm', 186.00000, '200 mm', 'Pressure reduction valve', 'c:\users\users\catalog.pdf', 'http://url.info', 'prv.svg', NULL, 1.00, NULL, 'N_PRVAL200_6/16', 2);
INSERT INTO cat_node VALUES ('CHK-VALVE200-PN10', 'CHECK VALVE', 'FD', '10 atm', '200 mm', 186.00000, 'Check valve', 'Check valve 200mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'chkvalve.svg', NULL, 1.00, NULL, 'N_CHKVAL200_PN10', 2);
INSERT INTO cat_node VALUES ('CHK-VALVE300-PN10', 'CHECK VALVE', 'FD', '10 atm', '300 mm', 282.00000, 'Check valve', 'Check valve 300mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'chkvalve.svg', NULL, 1.00, NULL, 'N_CHKVAL300_PN10', 2);
INSERT INTO cat_node VALUES ('AIR VALVE DN50', 'AIR VALVE', 'FD', '16 atm', '50 mm', NULL, '50 mm', 'Air valve 50mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'airvalve.svg', NULL, 1.00, NULL, 'N_AIRVAL_DN50', 2);
INSERT INTO cat_node VALUES ('TDN63-63 PN16', 'T', 'PVC', '16 atm', '63-63-63 mm', NULL, '63-63-63 mm', 'PVC T', 'c:\users\users\catalog.pdf', 'http://url.info', 't_equal.svg', NULL, 1.00, NULL, 'N_T63-63_PN16', 3);
INSERT INTO cat_node VALUES ('TDN110-110 PN16', 'T', 'FD', '16 atm', '110-110-110 mm', NULL, '110-110-110 mm', 'FD T', 'c:\users\users\catalog.pdf', 'http://url.info', 't_equal.svg', NULL, 1.00, NULL, 'N_T110-110_PN16', 3);
INSERT INTO cat_node VALUES ('PRV-VALVE150-PN6/16', 'PR-REDUC.VALVE', 'FD', '6-16 atm', '150 mm', 148.00000, '150 mm', 'Pressure reduction valve', 'c:\users\users\catalog.pdf', 'http://url.info', 'prv.svg', NULL, 1.00, NULL, 'N_PRVAL150_6/16', 2);
INSERT INTO cat_node VALUES ('FLOWMETER-02-DN110', 'FLOW METER', 'FD', '16 atm', '110 mm', 100.00000, 'FM 110 mm', 'Flow meter 110 mm', 'c:\users\users\catalog.pdf', 'http://url.info', 'flowmeter.svg', NULL, 1.00, NULL, 'N_FLOWMETER200', 2);
INSERT INTO cat_node VALUES ('TDN160-160 PN16', 'T', 'FD', '16 atm', '160-160-160 mm', NULL, '160-160-160 mm', 'FD T', 'c:\users\users\catalog.pdf', 'http://url.info', 't_equal.svg', NULL, 1.00, NULL, 'N_T160-160_PN16', 3);
INSERT INTO cat_node VALUES ('CURVE30DN110 PVCPN16', 'CURVE', 'PVC', '16 atm', '100 mm', 100.00000, '110ext x 100 int', 'PVC curve', 'c:\users\users\catalog.pdf', 'http://url.info', 'curve30.svg', NULL, 1.00, NULL, 'N_CUR30_PVC110', 2);
INSERT INTO cat_node VALUES ('TDN160-110-63 PN16', 'T', 'FD', '16 atm', '160-110-63 mm', NULL, '160-110-63 m', 'FD T', 'c:\users\users\catalog.pdf', 'http://url.info', 't_noequal.svg', NULL, 1.00, NULL, 'N_T160-110-63', 3);
INSERT INTO cat_node VALUES ('CURVE45DN110 PVCPN16', 'CURVE', 'PVC', '16 atm', '100 mm', 100.00000, '110ext x 100 int', 'PVC curve', 'c:\users\users\catalog.pdf', 'http://url.info', 'curve45.svg', NULL, 1.00, NULL, 'N_CUR45_PVC110', 2);
INSERT INTO cat_node VALUES ('WATERWELL-01', 'WATERWELL', 'FD', NULL, NULL, NULL, NULL, 'Waterwell', 'c:\users\users\catalog.pdf', 'http://url.info', NULL, NULL, 1.00, NULL, 'N_WATERWELL-01', 1);
INSERT INTO cat_node VALUES ('TDN63-63-110 PN16', 'T', 'PVC', '16 atm', '63-63-110 mm', NULL, '63-63-110 mm', 'PVC T', 'c:\users\users\catalog.pdf', 'http://url.info', 't_noequal.svg', NULL, 1.00, NULL, 'N_T63-63-110', 3);
INSERT INTO cat_node VALUES ('SOURCE-01', 'SOURCE', NULL, NULL, NULL, NULL, NULL, 'Source', 'c:\users\users\catalog.pdf', 'http://url.info', NULL, NULL, 1.00, NULL, 'N_SOURCE-01', 1);
INSERT INTO cat_node VALUES ('PUMP-02', 'PUMP', 'FD', NULL, NULL, 100.00000, '110 mm', 'Pump tank', 'c:\users\users\catalog.pdf', 'http://url.info', 'pump.svg', NULL, 1.00, NULL, 'N_PUMP-01', 2);



-- ----------------------------
-- Records of cat_connec
-- ----------------------------
INSERT INTO cat_connec VALUES ('PVC25-PN16-DOM', 'WJOIN', 'PVC', '16 atm', '25 mm', NULL, 'PVC connec', NULL, NULL, NULL, NULL);
INSERT INTO cat_connec VALUES ('PVC32-PN16-DOM', 'WJOIN', 'PVC', '16 atm', '32 mm', NULL, 'PVC connec', NULL, NULL, NULL, NULL);
INSERT INTO cat_connec VALUES ('PVC32-PN16-TRA', 'WJOIN', 'PVC', '16 atm', '32 mm', NULL, 'PVC connec', NULL, NULL, NULL, NULL);
INSERT INTO cat_connec VALUES ('PVC50-PN16-IND', 'WJOIN', 'PVC', '16 atm', '50 mm', NULL, 'PVC connec', NULL, NULL, NULL, NULL);
INSERT INTO cat_connec VALUES ('PVC63-PN16-FOU', 'FOUNTAIN', 'PVC', '16 atm', '63 mm', NULL, 'PVC connec', NULL, NULL, NULL, NULL);
INSERT INTO cat_connec VALUES ('PVC25-PN16-TAP', 'TAP', 'PVC', '16 atm', '25 mm', NULL, 'PVC connec', NULL, NULL, NULL, NULL);
INSERT INTO cat_connec VALUES ('PVC50-PN16-GRE', 'GREEN_TAP', 'PVC', '16 atm', '50 mm', NULL, 'PVC connec ', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_element
-- ----------------------------
INSERT INTO cat_element VALUES ('COVER', 'COVER', 'FD', '60 cm', 'Cover fd', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'Cover_fd.svg');
INSERT INTO cat_element VALUES ('COVER40X40', 'COVER', 'FD', '40x40 cm', 'Cover fd', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'Cover_40x40.svg');
INSERT INTO cat_element VALUES ('VREGISTER200X200', 'REGISTER', 'BRICK+IRON', '200x200 cm', 'Vertical register concret/Iron', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'V_register.svg');
INSERT INTO cat_element VALUES ('REGISTER40X40', 'REGISTER', 'CONCRET', '40x40 cm', 'Register concret 40x40', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'Register_40x40.svg');
INSERT INTO cat_element VALUES ('REGISTER60X60', 'REGISTER', 'CONCRET', '60x60 cm', 'Register concret 60x60', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'Register_60x60.svg');


-- ----------------------------
-- Records of cat_builder
-- ----------------------------
INSERT INTO cat_builder VALUES ('BUILDER NO DATA', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_owner
-- ----------------------------
INSERT INTO cat_owner VALUES ('OWNER NO DATA', NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_soil
-- ----------------------------
INSERT INTO cat_soil VALUES ('SOIL NO DATA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_soil VALUES ('SOIL_01', 'Sòl estandard de plana d''inundació', NULL, NULL, NULL, 5.00, 0.20, 0.00, 'S_EXC', 'S_REB', 'S_TRANS', 'S_NULL');

-- ----------------------------
-- Records of cat_work
-- ----------------------------
INSERT INTO cat_work VALUES ('WORK NO DATA', NULL, NULL, NULL);

-- ----------------------------
-- Records of cat_pavement
-- ----------------------------
INSERT INTO cat_pavement VALUES ('PAVEMENT NO DATA', NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_pavement VALUES ('Asphalt', NULL, NULL, NULL, 0.10, 'P_ASPHALT-10');



-- ----------------------------
-- Records of cat_tag
-- ----------------------------
INSERT INTO cat_tag VALUES ('NO TAG', NULL);
INSERT INTO cat_tag VALUES ('PRIORITY NORMAL', NULL);
INSERT INTO cat_tag VALUES ('PRIORITY HIGH', NULL);

