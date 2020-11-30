/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO cat_mat_arc VALUES ('N/I', 'Unknown', NULL);
INSERT INTO cat_mat_arc VALUES ('PVC', 'PVC', 'c:\\users\users\catalog.pdf');
INSERT INTO cat_mat_arc VALUES ('FD', 'Iron', 'c:\\users\users\catalog.pdf');
INSERT INTO cat_mat_arc VALUES ('FC', 'Fiberconcret', 'c:\\users\users\catalog.pdf');
INSERT INTO cat_mat_arc VALUES ('PE-HD', 'PE high density', 'c:\\users\users\catalog.pdf');
INSERT INTO cat_mat_arc VALUES ('PE-LD', 'PE low density', 'c:\\users\users\catalog.pdf');


INSERT INTO cat_mat_element VALUES ('N/I', 'Unknown', NULL);
INSERT INTO cat_mat_element VALUES ('FD', 'Iron', NULL);
INSERT INTO cat_mat_element VALUES ('CONCRET', 'Concret', NULL);
INSERT INTO cat_mat_element VALUES ('BRICK+IRON', 'Brick and iron', NULL);
INSERT INTO cat_mat_element VALUES ('PVC', 'PVC', NULL);


INSERT INTO cat_mat_node VALUES ('N/I', 'Unknown', NULL);
INSERT INTO cat_mat_node VALUES ('PVC', 'PVC', 'c:\\users\users\catalog.pdf');
INSERT INTO cat_mat_node VALUES ('FD', 'Iron', 'c:\\users\users\catalog.pdf');
INSERT INTO cat_mat_node VALUES ('CC', 'Concret', 'c:\\users\users\catalog.pdf');
INSERT INTO cat_mat_node VALUES ('FC-FC-FC', 'Fiberconcret', 'c:\\users\users\catalog.pdf');
INSERT INTO cat_mat_node VALUES ('FC', 'Fiberconcret', 'c:\\users\users\catalog.pdf');
INSERT INTO cat_mat_node VALUES ('FD-FD-PVC', 'Iron-Iron-PVC', 'c:\\users\users\catalog.pdf');


INSERT INTO cat_arc VALUES ('PVC63-PN10', 'PIPE', 'PVC', '10', '63', 56.70000, 63.00000, 'PVC pipe', 'c:\\users\users\catalog.pdf', NULL, NULL, 'pvc63_pn10.svg', 0.10, 0.10, 0.06, 0.0031, 0.86, 3.15, 'm', 'A_PVC63_PN10', 'S_REP', 'S_NULL', true, null, 'CIRCULAR');
INSERT INTO cat_arc VALUES ('PVC110-PN16', 'PIPE', 'PVC', '16', '110', 99.00000, 110.00000, 'PVC pipe', 'c:\\users\users\catalog.pdf', NULL, NULL, 'pvc110_pn16.svg', 0.10, 0.10, 0.11, 0.0095, 0.91, 5.50, 'm', 'A_PVC110_PN16', 'S_REP', 'S_NULL', true, null, 'CIRCULAR');
INSERT INTO cat_arc VALUES ('PVC200-PN16', 'PIPE', 'PVC', '16', '200', 180.00000, 200.00000, 'PVC pipe', 'c:\\users\users\catalog.pdf', NULL, NULL, 'pvc200_pn16.svg', 0.10, 0.10, 0.20, 0.0314, 1.00, 10.00, 'm', 'A_PVC200_PN16', 'S_REP', 'S_NULL', true, null, 'CIRCULAR');
INSERT INTO cat_arc VALUES ('FD150', 'PIPE', 'FD', '16', '150', 153.00000, 170.00000, 'FD pipe', 'c:\\users\users\catalog.pdf', NULL, NULL, 'fd150.svg', 0.10, 0.10, 0.17, 0.0227, 0.97, 8.50, 'm', 'A_FD150', 'S_REP', 'S_NULL', true, null, 'CIRCULAR');
INSERT INTO cat_arc VALUES ('FD200', 'PIPE', 'FD', '16', '200', 204.00000, 222.00000, 'FD pipe', 'c:\\users\users\catalog.pdf', NULL, NULL, 'fd200.svg', 0.10, 0.10, 0.22, 0.0387, 1.02, 11.10, 'm', 'A_FD200', 'S_REP', 'S_NULL', true, null, 'CIRCULAR');
INSERT INTO cat_arc VALUES ('PEHD110-PN16', 'PIPE', 'PE-HD', '16', '110', 99.00000, 110.00000, 'PEHD pipe', 'c:\\users\users\catalog.pdf', NULL, NULL, 'pehd110_pn16.svg', 0.10, 0.10, 0.11, 0.0095, 0.91, 5.50, 'm', 'A_PEHD110_PN16', 'S_REP', 'S_NULL', true, null, 'CIRCULAR');
INSERT INTO cat_arc VALUES ('PELD110-PN10', 'PIPE', 'PE-LD', '10', '110', 99.00000, 110.00000, 'PELD pipe', 'c:\\users\users\catalog.pdf', NULL, NULL, 'peld110_pn10.svg', 0.10, 0.10, 0.11, 0.0095, 0.91, 5.50, 'm', 'A_PELD110_PN10', 'S_REP', 'S_NULL', true, null, 'CIRCULAR');
INSERT INTO cat_arc VALUES ('PVC160-PN16', 'PIPE', 'PVC', '16', '160', 144.00000, 160.00000, 'PVC pipe', 'c:\\users\users\catalog.pdf', NULL, NULL, 'pvc160_pn16.svg', 0.10, 0.10, 0.16, 0.0201, 0.96, 8.00, 'm', 'A_PVC160_PN16', 'S_REP', 'S_NULL', true, null, 'CIRCULAR');
INSERT INTO cat_arc VALUES ('FC63-PN10', 'PIPE', 'FC', '10', '63', 56.70000, 63.00000, 'FC pipe', 'c:\\users\users\catalog.pdf', NULL, NULL, 'fc63_pn10.svg', 0.10, 0.10, 0.06, 0.0031, 0.86, 3.15, 'm', 'A_FC63_PN10', 'S_REP', 'S_NULL', false, null, 'CIRCULAR');
INSERT INTO cat_arc VALUES ('FC110-PN10', 'PIPE', 'FC', '10', '110', 99.00000, 110.00000, 'FC pipe', 'c:\\users\users\catalog.pdf', NULL, NULL, 'fc110_pn10.svg', 0.10, 0.10, 0.11, 0.0095, 0.91, 5.50, 'm', 'A_FC110_PN10', 'S_REP', 'S_NULL', false, null, 'CIRCULAR');
INSERT INTO cat_arc VALUES ('FC160-PN10', 'PIPE', 'FC', '10', '160', 144.00000, 160.00000, 'FC pipe', 'c:\\users\users\catalog.pdf', NULL, NULL, 'fc160_pn10.svg', 0.10, 0.10, 0.16, 0.0201, 0.96, 8.00, 'm', 'A_FC160_PN10', 'S_REP', 'S_NULL', false, null, 'CIRCULAR');
INSERT INTO cat_arc VALUES ('PVC90-PN16', 'PIPE', 'PVC', '16', '90', 82.00000, 90.00000, 'PVC pipe', 'c:\\users\users\catalog.pdf', NULL, NULL, 'pvc90_pn10.svg', 0.10, 0.10, 0.09, 0.0064, 0.95, 4.50, 'm', 'A_PVC90_PN16', 'S_REP', 'S_NULL', true, null, 'CIRCULAR');
INSERT INTO cat_arc VALUES ('VFD150-PN16', 'VARC', 'FD', '16', '150', 153.00000, 170.00000, 'FD pipe', 'c:\\users\users\catalog.pdf', NULL, NULL, 'fd150.svg', 0.10, 0.10, 0.17, 0.0227, 0.97, 8.50, 'm', 'A_FD150', 'S_REP', 'S_NULL', true, null, 'CIRCULAR');
INSERT INTO cat_arc VALUES ('VFC110-PN10', 'VARC', 'FC', '10', '110', 99.00000, 110.00000, 'FC pipe', 'c:\\users\users\catalog.pdf', NULL, NULL, 'fc110.svg', 0.10, 0.10, 0.09, 0.0095, 0.91, 4.00, 'm', 'A_FC110_PN10', 'S_REP', 'S_NULL', false, null, 'CIRCULAR');
INSERT INTO cat_arc VALUES ('VIRTUAL', 'VARC', 'PE-HD', NULL, NULL, 999, NULL, 'Virtual arc. Mandatory to fill some diameter and some material because EPANET needs some values to work with', 'c:\\users\users\catalog.pdf', NULL, NULL, 'fc110.svg', 0.10, 0.10, 0.09, 0.0095, 0.91, 4.00, 'm', 'A_FC110_PN10', 'S_REP', 'S_NULL', false, null, 'CIRCULAR');
INSERT INTO cat_arc VALUES ('FD300', 'PIPE', 'FD', '16', '300', 315.00000, 345.00000, 'FD pipe', 'c:\\users\users\catalog.pdf', NULL, NULL, 'fd300.svg', 0.10, 0.10, 0.22, 0.0387, 1.02, 11.10, 'm', 'A_FD200', 'S_REP', 'S_NULL', true, null, 'CIRCULAR');

INSERT INTO cat_brand VALUES ('brand1');
INSERT INTO cat_brand VALUES ('brand2');
INSERT INTO cat_brand VALUES ('brand3');


INSERT INTO cat_brand_model VALUES ('model1', 'brand1');
INSERT INTO cat_brand_model VALUES ('model2', 'brand1');
INSERT INTO cat_brand_model VALUES ('model3', 'brand2');
INSERT INTO cat_brand_model VALUES ('model4', 'brand2');
INSERT INTO cat_brand_model VALUES ('model5', 'brand3');
INSERT INTO cat_brand_model VALUES ('model6', 'brand3');


INSERT INTO cat_builder VALUES ('builder1');
INSERT INTO cat_builder VALUES ('builder2');
INSERT INTO cat_builder VALUES ('builder3');

UPDATE cat_feature SET active = false WHERE id = 'VCONNEC';

INSERT INTO cat_connec VALUES ('PVC25-PN16-DOM', 'WJOIN', 'PVC', '16', '25', NULL, NULL, 'PVC connec', NULL, NULL, NULL, NULL, 'N_WATER-CONNECT', 'A_PVC25_PN10', 'S_EXC', true);
INSERT INTO cat_connec VALUES ('PVC32-PN16-DOM', 'WJOIN', 'PVC', '16', '32', NULL, NULL, 'PVC connec', NULL, NULL, NULL, NULL, 'N_WATER-CONNECT', 'A_PVC32_PN10', 'S_EXC', true);
INSERT INTO cat_connec VALUES ('PVC32-PN16-TRA', 'WJOIN', 'PVC', '16', '32', NULL, NULL, 'PVC connec', NULL, NULL, NULL, NULL, 'N_WATER-CONNECT', 'A_PVC32_PN10', 'S_EXC', true);
INSERT INTO cat_connec VALUES ('PVC50-PN16-IND', 'WJOIN', 'PVC', '16', '50', NULL, NULL, 'PVC connec', NULL, NULL, NULL, NULL, 'N_WATER-CONNECT', 'A_PVC50_PN10', 'S_EXC', true);
INSERT INTO cat_connec VALUES ('PVC63-PN16-FOU', 'FOUNTAIN', 'PVC', '16', '63', NULL, NULL, 'PVC connec', NULL, NULL, NULL, NULL, 'N_WATER-CONNECT', 'A_PVC63_PN10', 'S_EXC', true);
INSERT INTO cat_connec VALUES ('PVC25-PN16-TAP', 'TAP', 'PVC', '16', '25', NULL, NULL, 'PVC connec', NULL, NULL, NULL, NULL, 'N_WATER-CONNECT', 'A_PVC25_PN10', 'S_EXC', true);
INSERT INTO cat_connec VALUES ('PVC50-PN16-GRE', 'GREENTAP', 'PVC', '16', '50', NULL, NULL, 'PVC connec ', NULL, NULL, NULL, NULL, 'N_WATER-CONNECT', 'A_PVC50_PN10', 'S_EXC', true);


INSERT INTO cat_dscenario VALUES (1, 'Hydrants_50%');


INSERT INTO cat_element VALUES ('PROTECT-BAND', 'PROTECT_BAND', 'PVC', '15cm', 'Protect band', 'c:\\users\users\catalog.pdf', NULL, NULL, NULL, 'protec_band.svg', true);
INSERT INTO cat_element VALUES ('COVER', 'COVER', 'FD', '60 cm', 'Cover fd', 'c:\\users\users\catalog.pdf', NULL, NULL, NULL, 'cover_fd.svg', true);
INSERT INTO cat_element VALUES ('COVER40X40', 'COVER', 'FD', '40x40 cm', 'Cover fd', 'c:\\users\users\catalog.pdf', NULL, NULL, NULL, 'cover_40x40.svg', true);
INSERT INTO cat_element VALUES ('REGISTER40X40', 'REGISTER', 'CONCRET', '40x40 cm', 'Register concret 40x40', 'c:\\users\users\catalog.pdf', NULL, NULL, NULL, 'register_40x40.svg', true);
INSERT INTO cat_element VALUES ('REGISTER60X60', 'REGISTER', 'CONCRET', '60x60 cm', 'Register concret 60x60', 'c:\\users\users\catalog.pdf', NULL, NULL, NULL, 'register_60x60.svg', true);
INSERT INTO cat_element VALUES ('VREGISTER200X200', 'REGISTER', 'BRICK+IRON', '200x200 cm', 'Vertical register concret/Iron', 'c:\\users\users\catalog.pdf', NULL, NULL, NULL, 'v_register.svg', true);
INSERT INTO cat_element VALUES ('HYDRANT_PLATE', 'HYDRANT_PLATE', 'N/I', '50x60 cm', 'Generic hidrant plate', NULL, NULL, NULL, NULL, NULL, true);

UPDATE cat_feature SET active = false WHERE id = 'CLORINATHOR' OR id = 'FL_CONTR_VALVE' OR id = 'GEN_PURP_VALVE' OR id = 'PR_SUSTA.VALVE' OR id = 'PR_BREAK.VALVE' 
OR id = 'VALVE_REGISTER' OR id = 'TAP' OR id = 'ADAPTATION' OR id = 'BYPASS_REGISTER' OR id = 'CONTROLREGISTER' OR id = 'THROTTLE_VALVE';


INSERT INTO cat_node VALUES ('REGISTER', 'REGISTER', 'N/I', NULL, NULL, NULL, NULL, NULL, 'Register', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_REGISTER', true);
INSERT INTO cat_node VALUES ('WATER-CONNECTION', 'WATER_CONNECTION', 'N/I', NULL, NULL, NULL, NULL, NULL, 'Netwjoin', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_WATER-CONNECT', true);
INSERT INTO cat_node VALUES ('XDN110 PN16', 'X', 'FD', '16', '110', NULL, NULL, NULL, 'X', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_XDN110_PN16', true);
INSERT INTO cat_node VALUES ('XDN110-90 PN16', 'X', 'FD', '16', '110', NULL, NULL, NULL, 'X', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_XDN110-90_PN16', true);
INSERT INTO cat_node VALUES ('FLEXUNION', 'FLEXUNION', 'N/I', NULL, NULL, NULL, NULL, NULL, 'Flexunion', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_FLEXUNION', true);
INSERT INTO cat_node VALUES ('FILTER-01-DN200', 'FILTER', 'FD', '16', '200', 186.00000, NULL, NULL, 'Filter 200', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_FILTER-01', true);
INSERT INTO cat_node VALUES ('PRV-VALVE100-PN6/16', 'PR_REDUC_VALVE', 'FD', '6', '100', 86.00000, NULL, NULL, 'Pressure reduction valve', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_PRVAL100_6/16', true);
INSERT INTO cat_node VALUES ('TANK_01', 'TANK', 'FD', NULL, NULL, NULL, NULL, NULL, 'Tank', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'm3', 'N_TANK_30x10x3', true);
INSERT INTO cat_node VALUES ('HYDRANT 1X110', 'HYDRANT', 'FD', '16', '110', NULL, NULL, NULL, 'Green valve 110mm', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_HYD_1x100', true);
INSERT INTO cat_node VALUES ('TDN110-63 PN16', 'T', 'PVC', '16', '110', NULL, NULL, NULL, 'PVC T', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_T110-63_PN16', true);
INSERT INTO cat_node VALUES ('TDN160-63 PN16', 'T', 'FD', '16', '160', NULL, NULL, NULL, 'FD T', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_T160-63_PN16', true);
INSERT INTO cat_node VALUES ('TDN200-160 PN16', 'T', 'FD', '16', '200', NULL, NULL, NULL, 'FD T', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_T200-160_PN16', true);
INSERT INTO cat_node VALUES ('PUMP-01', 'PUMP', 'FD', '16', '110', 98.00000, NULL, NULL, 'Pump station', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_PUMP-01', true);
INSERT INTO cat_node VALUES ('HYDRANT 1X110-2X63', 'HYDRANT', 'FD', '16', '110', NULL, NULL, NULL, 'Green valve 110mm', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_HYD_1x110-2x63', true);
INSERT INTO cat_node VALUES ('TDN160-110 PN16', 'T', 'FD', '16', '110', NULL, NULL, NULL, 'FD T', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_T160-110_PN16', true);
INSERT INTO cat_node VALUES ('PRV-VALVE200-PN6/16', 'PR_REDUC_VALVE', 'FD', '6', '200', 186.00000, NULL, NULL, 'Pressure reduction valve', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_PRVAL200_6/16', true);
INSERT INTO cat_node VALUES ('TDN63-63 PN16', 'T', 'PVC', '16', '63', NULL, NULL, NULL, 'PVC T', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_T63-63_PN16', true);
INSERT INTO cat_node VALUES ('TDN110-110 PN16', 'T', 'FD', '16', '110', NULL, NULL, NULL, 'FD T', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_T110-110_PN16', true);
INSERT INTO cat_node VALUES ('PRV-VALVE150-PN6/16', 'PR_REDUC_VALVE', 'FD', '6', '150', 145.00000, NULL, NULL, 'Pressure reduction valve', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_PRVAL150_6/16', true);
INSERT INTO cat_node VALUES ('TDN160-160 PN16', 'T', 'FD', '16', '160', NULL, NULL, NULL, 'FD T', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_T160-160_PN16', true);
INSERT INTO cat_node VALUES ('CURVE30DN110 PVCPN16', 'CURVE', 'PVC', '16', '110', 94.00000, NULL, NULL, 'PVC curve', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_CUR30_PVC110', true);
INSERT INTO cat_node VALUES ('TDN160-110-63 PN16', 'T', 'FD', '16', '160', NULL, NULL, NULL, 'FD T', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_T160-110-63', true);
INSERT INTO cat_node VALUES ('CURVE45DN110 PVCPN16', 'CURVE', 'PVC', '16', '110', 94.00000, NULL, NULL, 'PVC curve', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_CUR45_PVC110', true);
INSERT INTO cat_node VALUES ('WATERWELL-01', 'WATERWELL', 'FD', NULL, NULL, NULL, NULL, NULL, 'Waterwell', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_WATERWELL-01', true);
INSERT INTO cat_node VALUES ('OUTFALL VALVE-DN150', 'OUTFALL_VALVE', 'FD', '16', '150', 145.00000, NULL, NULL, 'Outfall valve ', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_OUTVAL-01', true);
INSERT INTO cat_node VALUES ('FLOWMETER-01-DN200', 'FLOWMETER', 'FD', '16', '200', 186.00000, NULL, NULL, 'Flow meter 200', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_FLOWMETER110', true);
INSERT INTO cat_node VALUES ('FLOWMETER-02-DN110', 'FLOWMETER', 'FD', '16', '110', 98.00000, NULL, NULL, 'Flow meter 110', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_FLOWMETER200', true);
INSERT INTO cat_node VALUES ('GREENVALVEDN63 PN16', 'GREEN_VALVE', 'FD', '16', '63', NULL, NULL, NULL, 'Green valve 63mm', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_GREVAL63_PN16', true);
INSERT INTO cat_node VALUES ('GREENVALVEDN110 PN16', 'GREEN_VALVE', 'FD', '16', '110', NULL, NULL, NULL, 'Green valve 110mm', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_GREVAL110_PN16', true);
INSERT INTO cat_node VALUES ('GREENVALVEDN50 PN16', 'GREEN_VALVE', 'FD', '16', '50', NULL, NULL, NULL, 'Green valve 110mm', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_GREVAL50_PN16', true);
INSERT INTO cat_node VALUES ('AIR VALVE DN50', 'AIR_VALVE', 'FD', '16', '50', NULL, NULL, NULL, 'Air valve 50mm', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_AIRVAL_DN50', true);
INSERT INTO cat_node VALUES ('TDN63-63-110 PN16', 'T', 'PVC', '16', '63', NULL, NULL, NULL, 'PVC T', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_T63-63-110', true);
INSERT INTO cat_node VALUES ('SOURCE-01', 'SOURCE', 'N/I', NULL, NULL, NULL, NULL, NULL, 'Source', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_SOURCE-01', true);
INSERT INTO cat_node VALUES ('PUMP-02', 'PUMP', 'FD', '16', '125', 110.00000, NULL, NULL, 'Pump tank', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_PUMP-01', true);
INSERT INTO cat_node VALUES ('TDN110-90 PN16', 'T', 'FD', '16', '110', NULL, NULL, NULL, 'FD T', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_T110-63_PN16', true);
INSERT INTO cat_node VALUES ('JUNCTION DN63', 'JUNCTION', 'FD', '16', '63', NULL, NULL, NULL, 'Juntion 63mm', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_JUN63', true);
INSERT INTO cat_node VALUES ('JUNCTION DN110', 'JUNCTION', 'FD', '16', '110', NULL, NULL, NULL, 'Juntion 110mm', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_JUN110', true);
INSERT INTO cat_node VALUES ('JUNCTION DN160', 'JUNCTION', 'FD', '16', '150', 154.00000, NULL, NULL, 'Juntion 160mm', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_JUN160', true);
INSERT INTO cat_node VALUES ('JUNCTION DN200', 'JUNCTION', 'FD', '16', '200', 205.00000, NULL, NULL, 'Juntion 200mm', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_JUN200', true);
INSERT INTO cat_node VALUES ('JUNCTION DN90', 'JUNCTION', 'FD', '16', '90', 93.00000, NULL, NULL, 'Juntion 90mm', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_JUN110', true);
INSERT INTO cat_node VALUES ('ENDLINE DN63', 'ENDLINE', 'PVC', '16', '63', 54.00000, NULL, NULL, 'End line', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_ENDLINE', true);
INSERT INTO cat_node VALUES ('ENDLINE DN150', 'ENDLINE', 'FD', '16', '150', 154.00000, NULL, NULL, 'End line', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_ENDLINE', true);
INSERT INTO cat_node VALUES ('ENDLINE DN90', 'ENDLINE', 'PVC', '16', '90', 77.00000, NULL, NULL, 'End line', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_ENDLINE', true);
INSERT INTO cat_node VALUES ('TDN110-90-63 PN16', 'T', 'FD', '16', '110', NULL, NULL, NULL, 'FD T', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_T110-63_PN16', true);
INSERT INTO cat_node VALUES ('CHK-VALVE63-PN16', 'CHECK_VALVE', 'FD', '16', '63', 65.00000, NULL, NULL, 'Check valve 63mm', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_CHKVAL63_PN10', true);
INSERT INTO cat_node VALUES ('CHK-VALVE150-PN16', 'CHECK_VALVE', 'FD', '16', '150', 154.00000, NULL, NULL, 'Check valve 150mm', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_CHKVAL150_PN10', true);
INSERT INTO cat_node VALUES ('CHK-VALVE100-PN16', 'CHECK_VALVE', 'FD', '16', '100', 102.00000, NULL, NULL, 'Check valve 110mm', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_CHKVAL100_PN10', true);
INSERT INTO cat_node VALUES ('CHK-VALVE200-PN16', 'CHECK_VALVE', 'FD', '16', '200', 205.00000, NULL, NULL, 'Check valve 200mm', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_CHKVAL200_PN10', true);
INSERT INTO cat_node VALUES ('CHK-VALVE300-PN16', 'CHECK_VALVE', 'FD', '16', '300', 306.00000, NULL, NULL, 'Check valve 300mm', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_CHKVAL300_PN10', true);
INSERT INTO cat_node VALUES ('PRESMETER-63-PN16', 'PRESSURE_METER', 'FD', '16', '63', 65.00000, NULL, NULL, 'Pressure meter 63', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_PRESME200_PN16', true);
INSERT INTO cat_node VALUES ('PRESMETER-110-PN16', 'PRESSURE_METER', 'FD', '16', '110', 115.00000, NULL, NULL, 'Pressure meter 110', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_PRESME110_PN16', true);
INSERT INTO cat_node VALUES ('EXPANTANK', 'EXPANTANK', 'N/I', NULL, NULL, NULL, NULL, NULL, 'Expansiontank', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_EXPANTANK', true);
INSERT INTO cat_node VALUES ('PRESMETER', 'PRESSURE_METER', 'FD', NULL, NULL, NULL, NULL, NULL, 'Pressure meter', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_PRESME200_PN16', true);
INSERT INTO cat_node VALUES ('FILTER-02-DN150', 'FILTER', 'FD', '16', '150', 145.00000, NULL, NULL, 'Filter 150', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_FILTER-01', true);
INSERT INTO cat_node VALUES ('CHK-VALVE90-PN16', 'CHECK_VALVE', 'FD', '16', '90', 82.00000, NULL, NULL, 'Check valve 90mm', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_CHKVAL100_PN10', true);
INSERT INTO cat_node VALUES ('SHTFF-VALVE160-PN16', 'SHUTOFF_VALVE', 'FD', '16', '160', 148.00000, NULL, NULL, 'Shutoff valve 160', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_SHTVAL160_PN16', true);
INSERT INTO cat_node VALUES ('SHTFF-VALVE110-PN16', 'SHUTOFF_VALVE', 'FD', '16', '110', 98.00000, NULL, NULL, 'Shutoff valve 110', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_SHTVAL110_PN16', true);
INSERT INTO cat_node VALUES ('SHTFF-VALVEN63 PN16', 'SHUTOFF_VALVE', 'FD', '16', '63', 55.00000, NULL, NULL, 'Shutoff valve 63', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_SHTVAL63_PN16', true);
INSERT INTO cat_node VALUES ('NETSAMPLEPOINT', 'NETSAMPLEPOINT', 'N/I', NULL, NULL, NULL, NULL, NULL, 'Netsamplepoint', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_NETSAMPLEP', true);
INSERT INTO cat_node VALUES ('NETELEMENT', 'NETELEMENT', 'N/I', NULL, NULL, NULL, NULL, NULL, 'Netelement', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_NETELEMENT', true);
INSERT INTO cat_node VALUES ('ETAP', 'WTP', 'N/I', NULL, NULL, NULL, NULL, NULL, 'Wtp', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_ETAP', true);
INSERT INTO cat_node VALUES ('MANHOLE', 'MANHOLE', 'N/I', NULL, NULL, NULL, NULL, NULL, 'Wtp', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_SOURCE-01', true);
INSERT INTO cat_node VALUES ('REDUC_110-90 PN16', 'REDUCTION', 'PVC', '16', '110', NULL, NULL, NULL, 'Reduction', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_REDUC_110-90', true, null, 1);
INSERT INTO cat_node VALUES ('REDUC_160-90 PN16', 'REDUCTION', 'PVC', '16', '160', NULL, NULL, NULL, 'Reduction', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_REDUC_160-90', true, null, 1);
INSERT INTO cat_node VALUES ('REDUC_110-63 PN16', 'REDUCTION', 'PVC', '16', '110', NULL, NULL, NULL, 'Reduction', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_REDUC_110-63', true, null, 1);
INSERT INTO cat_node VALUES ('REDUC_200-110 PN16', 'REDUCTION', 'PVC', '16', '110', NULL, NULL, NULL, 'Reduction', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_REDUC_200-110', true, null, 1);
INSERT INTO cat_node VALUES ('REDUC_160-110 PN16', 'REDUCTION', 'PVC', '16', '110', NULL, NULL, NULL, 'Reduction', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_REDUC_160-110', true, null, 1);
INSERT INTO cat_node VALUES ('JUNCTION CHNGMAT', 'JUNCTION', 'N/I', '16', '160', NULL, NULL, NULL, 'Change of arc material', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1.00, 'u', 'N_JUNCT_CHNGMAT', true, null, 1);

UPDATE cat_node SET ischange=2 where id LIKE '%HYDRANT%';
UPDATE cat_node SET ischange=1 where id ='TDN160-63 PN16';
UPDATE cat_node SET ischange=1 where id ='XDN110-90 PN16';
UPDATE cat_node SET ischange=2 where id ='TDN63-63 PN16';
UPDATE cat_node SET ischange=2 where id ='XDN110 PN16';
UPDATE cat_node SET ischange=2 where id ='TDN110-110 PN16';
UPDATE cat_node SET ischange=1 where id LIKE '%REDUC%';
UPDATE cat_node SET ischange=0 where ischange IS NULL;


INSERT INTO cat_owner VALUES ('owner1');
INSERT INTO cat_owner VALUES ('owner2');
INSERT INTO cat_owner VALUES ('owner3');


INSERT INTO cat_pavement VALUES ('Asphalt', NULL, NULL,'0.10','P_ASPHALT-10');
INSERT INTO cat_pavement VALUES ('pavement1', NULL, NULL,'0.12','P_ASPHALT-10');
INSERT INTO cat_pavement VALUES ('pavement2', NULL, NULL,'0.08','P_ASPHALT-10');


INSERT INTO cat_soil VALUES ('soil1', 'soil 1', NULL, 7.00, 0.25, 0.60, 'S_EXC', 'S_REB', 'S_TRANS', 'S_TRENCH');
INSERT INTO cat_soil VALUES ('soil2', 'soil 2', NULL, 7.00, 0.20, 0.25, 'S_EXC', 'S_REB', 'S_TRANS', 'S_TRENCH');
INSERT INTO cat_soil VALUES ('soil3', 'soil 3', NULL, 5.00, 0.20, 0.00, 'S_EXC', 'S_REB', 'S_TRANS', 'S_TRENCH');

INSERT INTO cat_work VALUES ('work1', 'Description work1', NULL, NULL, NULL, '2017-12-06');
INSERT INTO cat_work VALUES ('work2', 'Description work2', NULL, NULL, NULL, '2017-12-09');
INSERT INTO cat_work VALUES ('work3', 'Description work3', NULL, NULL, NULL, '2017-12-11');
INSERT INTO cat_work VALUES ('work4', 'Description work4', NULL, NULL, NULL, '2017-12-22');


-- ----------------------------
-- Records of man_type_category
-- ----------------------------
INSERT INTO man_type_category VALUES (1, 'St. Category', 'NODE');
INSERT INTO man_type_category VALUES (2, 'St. Category', 'ARC');
INSERT INTO man_type_category VALUES (3, 'St. Category', 'CONNEC');
INSERT INTO man_type_category VALUES (4, 'St. Category', 'ELEMENT');

-- ----------------------------
-- Records of man_type_fluid
-- ----------------------------
INSERT INTO man_type_fluid VALUES (1, 'St. Fluid', 'NODE');
INSERT INTO man_type_fluid VALUES (2, 'St. Fluid', 'ARC');
INSERT INTO man_type_fluid VALUES (3, 'St. Fluid', 'CONNEC');
INSERT INTO man_type_fluid VALUES (4, 'St. Fluid', 'ELEMENT');

-- ----------------------------
-- Records of man_type_location
-- ----------------------------
INSERT INTO man_type_location VALUES (1, 'St. Location', 'NODE');
INSERT INTO man_type_location VALUES (2, 'St. Location', 'ARC');
INSERT INTO man_type_location VALUES (3, 'St. Location', 'CONNEC');
INSERT INTO man_type_location VALUES (4, 'St. Location', 'ELEMENT');

-- ----------------------------
-- Records of man_type_function
-- ----------------------------
INSERT INTO man_type_function VALUES (1, 'St. Function', 'NODE');
INSERT INTO man_type_function VALUES (2, 'St. Function', 'ARC');
INSERT INTO man_type_function VALUES (3, 'St. Function', 'CONNEC');
INSERT INTO man_type_function VALUES (4, 'St. Function', 'ELEMENT');



-- ----------------------------
-- Update shortcuts
-- ----------------------------

UPDATE cat_feature SET shortcut_key=NULL;
UPDATE cat_feature SET shortcut_key='Alt+A' WHERE id = 'AIR_VALVE';
UPDATE cat_feature SET shortcut_key='C' WHERE id = 'CHECK_VALVE';
UPDATE cat_feature SET shortcut_key='V' WHERE id = 'CURVE';
UPDATE cat_feature SET shortcut_key='E' WHERE id = 'ENDLINE';
UPDATE cat_feature SET shortcut_key='K' WHERE id = 'EXPANTANK';
UPDATE cat_feature SET shortcut_key='F' WHERE id = 'FILTER';
UPDATE cat_feature SET shortcut_key='L' WHERE id = 'FLEXUNION';
UPDATE cat_feature SET shortcut_key='W' WHERE id = 'FLOWMETER';
UPDATE cat_feature SET shortcut_key='Alt+N' WHERE id = 'FOUNTAIN';
UPDATE cat_feature SET shortcut_key='G' WHERE id = 'GREEN_VALVE';
UPDATE cat_feature SET shortcut_key='Alt+G' WHERE id = 'GREENTAP';
UPDATE cat_feature SET shortcut_key='H' WHERE id = 'HYDRANT';
UPDATE cat_feature SET shortcut_key='J' WHERE id = 'JUNCTION';
UPDATE cat_feature SET shortcut_key='M' WHERE id = 'MANHOLE';
UPDATE cat_feature SET shortcut_key='N' WHERE id = 'NETELEMENT';
UPDATE cat_feature SET shortcut_key='S' WHERE id = 'NETSAMPLEPOINT';
UPDATE cat_feature SET shortcut_key='O' WHERE id = 'OUTFALL_VALVE';
UPDATE cat_feature SET shortcut_key='Alt+I' WHERE id = 'PIPE';
UPDATE cat_feature SET shortcut_key='Alt+Q' WHERE id = 'PR_REDUC_VALVE';
UPDATE cat_feature SET shortcut_key='B' WHERE id = 'PRESSURE_METER';
UPDATE cat_feature SET shortcut_key='U' WHERE id = 'PUMP';
UPDATE cat_feature SET shortcut_key='Z' WHERE id = 'REDUCTION';
UPDATE cat_feature SET shortcut_key='R' WHERE id = 'REGISTER';
UPDATE cat_feature SET shortcut_key='I' WHERE id = 'SHUTOFF_VALVE';
UPDATE cat_feature SET shortcut_key='D' WHERE id = 'SOURCE';
UPDATE cat_feature SET shortcut_key='T' WHERE id = 'T';
UPDATE cat_feature SET shortcut_key='Alt+K' WHERE id = 'TANK';
UPDATE cat_feature SET shortcut_key='Alt+C' WHERE id = 'TAP';
UPDATE cat_feature SET shortcut_key='Alt+T' WHERE id = 'VARC';
UPDATE cat_feature SET shortcut_key='Alt+U' WHERE id = 'VCONNEC';
UPDATE cat_feature SET shortcut_key='Y' WHERE id = 'WATER_CONNECTION';
UPDATE cat_feature SET shortcut_key='Alt+Y' WHERE id = 'WATERWELL';
UPDATE cat_feature SET shortcut_key='Alt+M' WHERE id = 'WJOIN';
UPDATE cat_feature SET shortcut_key='P' WHERE id = 'WTP';
UPDATE cat_feature SET shortcut_key='X' WHERE id = 'X';