/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Records of cat_mat_arc
-- ----------------------------
INSERT INTO cat_mat_arc VALUES ('Concret', 'Concret', 0.0140, NULL, NULL, NULL);
INSERT INTO cat_mat_arc VALUES ('PVC', 'PVC', 0.0110, NULL, NULL, NULL);
INSERT INTO cat_mat_arc VALUES ('PEAD', 'PEAD', 0.0110, NULL, NULL, NULL);
INSERT INTO cat_mat_arc VALUES ('Brick', 'Brick', 0.0140, NULL, NULL, NULL);
INSERT INTO cat_mat_arc VALUES ('Unknown', 'Unknown', 0.0130, NULL, NULL, NULL);

-- ----------------------------
-- Records of cat_mat_element
-- ----------------------------
INSERT INTO cat_mat_element VALUES ('N/I', 'No information', NULL, NULL, NULL);
INSERT INTO cat_mat_element VALUES ('Concret', 'Concret', NULL, NULL, NULL);
INSERT INTO cat_mat_element VALUES ('Iron', 'Iron', NULL, NULL, NULL);
INSERT INTO cat_mat_element VALUES ('FD', 'Iron', NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_mat_node
-- ----------------------------
INSERT INTO cat_mat_node VALUES ('Concret', 'Concret', NULL, NULL, NULL);
INSERT INTO cat_mat_node VALUES ('PEAD', 'PEAD', NULL, NULL, NULL);
INSERT INTO cat_mat_node VALUES ('Brick', 'Brick', NULL, NULL, NULL);
INSERT INTO cat_mat_node VALUES ('PVC', 'PVC', NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_arc
-- ---------------------------
INSERT INTO cat_arc VALUES ('CON-CC100', 'Concret', 'CIRCULAR', NULL, NULL, 1.0000, 0.0000, 0.0000, 0.0000, NULL, 'C100_CON', 'Concret conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.50, 0.1200, 1.40, 0.05, 'm', 'A_CON_DN100', 'S_REP', 'S_NULL', 0.0000, 0.0000, 0.0000, 0.0000);
INSERT INTO cat_arc VALUES ('CON-EG150', 'Concret', 'EGG', NULL, NULL, 1.5000, 1.0000, 0.0000, 0.0000, NULL, 'E150_CON', 'Concret conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.50, 0.1200, 1.40, 0.05, 'm', 'A_CON_O150', 'S_REP', 'S_NULL', 0.0000, 0.0000, 0.0000, 0.0000);
INSERT INTO cat_arc VALUES ('CON-RC150', 'Concret', 'RECT_CLOSED', NULL, NULL, 1.5000, 1.5000, 0.0000, 0.0000, NULL, 'R150_CON', 'Concret conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.50, 0.1200, 1.40, 0.05, 'm', 'A_CON_R150', 'S_REP', 'S_NULL', 0.0000, 0.0000, 0.0000, 0.0000);
INSERT INTO cat_arc VALUES ('CON-RC200', 'Concret', 'RECT_CLOSED', NULL, NULL, 2.0000, 2.0000, 0.0000, 0.0000, NULL, 'R200_CON', 'Concret conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.50, 0.1200, 1.40, 0.05, 'm', 'A_CON_R200', 'S_REP', 'S_NULL', 0.0000, 0.0000, 0.0000, 0.0000);
INSERT INTO cat_arc VALUES ('PVC-CC040', 'PVC', 'CIRCULAR', NULL, NULL, 0.4000, 0.0000, 0.0000, 0.0000, NULL, 'C40_PVC', 'PVC conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.50, 0.1200, 1.40, 0.05, 'm', 'A_PVC_DN40', 'S_REP', 'S_NULL', 0.0000, 0.0000, 0.0000, 0.0000);
INSERT INTO cat_arc VALUES ('PVC-CC060', 'PVC', 'CIRCULAR', NULL, NULL, 0.6000, 0.0000, 0.0000, 0.0000, NULL, 'C60_PVC', 'PVC conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.50, 0.1200, 1.40, 0.05, 'm', 'A_PVC_DN60', 'S_REP', 'S_NULL', 0.0000, 0.0000, 0.0000, 0.0000);
INSERT INTO cat_arc VALUES ('PVC-CC080', 'PVC', 'CIRCULAR', NULL, NULL, 0.8000, 0.0000, 0.0000, 0.0000, NULL, 'C80_PVC', 'PVC conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.50, 0.1200, 1.40, 0.05, 'm', 'A_PVC_DN80', 'S_REP', 'S_NULL', 0.0000, 0.0000, 0.0000, 0.0000);
INSERT INTO cat_arc VALUES ('PVC-CC020', 'PVC', 'CIRCULAR', NULL, NULL, 0.2000, 0.0000, 0.0000, 0.0000, NULL, 'C20_PVC', 'PVC conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.50, 0.1200, 1.40, 0.05, 'm', 'A_PVC_DN20', 'S_REP', 'S_NULL', 0.0000, 0.0000, 0.0000, 0.0000);
INSERT INTO cat_arc VALUES ('WEIR_60', 'Unknown', 'CIRCULAR', NULL, NULL, 0.6000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.10, 0.10, 0.50, 0.1200, 1.40, 0.05, 'm', 'A_WEIR_60', 'S_REP', 'S_NULL', 0.0000, 0.0000, 0.0000, 0.0000);
INSERT INTO cat_arc VALUES ('CON-CC040', 'Concret', 'CIRCULAR', NULL, NULL, 0.4000, 0.0000, 0.0000, 0.0000, NULL, 'C40_CON', 'Concret conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.50, 0.1200, 1.40, 0.05, 'm', 'A_CON_DN40', 'S_REP', 'S_NULL', 0.0000, 0.0000, 0.0000, 0.0000);
INSERT INTO cat_arc VALUES ('CON-CC060', 'Concret', 'CIRCULAR', NULL, NULL, 0.6000, 0.0000, 0.0000, 0.0000, NULL, 'C60_CON', 'Concret conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.50, 0.1200, 1.40, 0.05, 'm', 'A_CON_DN60', 'S_REP', 'S_NULL', 0.0000, 0.0000, 0.0000, 0.0000);
INSERT INTO cat_arc VALUES ('CON-CC080', 'Concret', 'CIRCULAR', NULL, NULL, 0.8000, 0.0000, 0.0000, 0.0000, NULL, 'C80_CON', 'Concret conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.50, 0.1200, 1.40, 0.05, 'm', 'A_CON_DN80', 'S_REP', 'S_NULL', 0.0000, 0.0000, 0.0000, 0.0000);
INSERT INTO cat_arc VALUES ('PE-PP020', 'PEAD', 'CIRCULAR', NULL, NULL, 0.2000, 0.0000, 0.0000, 0.0000, NULL, 'P20_PVC', 'PVC pump pipe', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.50, 0.1200, 1.40, 0.05, 'm', 'A_PRE_PE_DN20', 'S_REP', 'S_NULL', 0.0000, 0.0000, 0.0000, 0.0000);
INSERT INTO cat_arc VALUES ('PUMP_01', 'Unknown', 'CIRCULAR', NULL, NULL, NULL, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.10, 0.10, 0.50, 0.1200, 1.40, 0.05, 'm', 'A_PRE_PE_DN20', 'S_REP', 'S_NULL', 0.0000, 0.0000, 0.0000, 0.0000);

-- ----------------------------
-- Records of cat_node
-- ----------------------------
INSERT INTO cat_node VALUES ('OUTFALL-01', 'Concret', NULL, NULL, NULL, NULL, 'OUTFALL', 'Outfall', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('VIR_NODE-01', 'Concret', NULL, NULL, NULL, NULL, 'VIR_NODE_CON', 'Virtual node', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('C_MANHOLE-CON80', 'Concret', 0.80, NULL, NULL, NULL, 'C_MANHOLE_80_CON', 'Circular manhole ø80cm', NULL, NULL, NULL, NULL, NULL, NULL, 'N_PRD80-H160');
INSERT INTO cat_node VALUES ('C_MANHOLE-CON100', 'Concret', 1.00, NULL, NULL, NULL, 'C_MANHOLE_100_CON', 'Circular manhole ø100cm', NULL, NULL, NULL, NULL, NULL, NULL, 'N_PRD100-H160');
INSERT INTO cat_node VALUES ('R_MANHOLE-CON100', 'Concret', 1.00, 1.00, NULL, NULL, 'R_MANHOLE_100_CON', 'Rectangular manhole 100x100cm', NULL, NULL, NULL, NULL, NULL, NULL, 'N_PRQ100-H160');
INSERT INTO cat_node VALUES ('R_MANHOLE-CON150', 'Concret', 1.50, 1.50, NULL, NULL, 'R_MANHOLE_150_CON', 'Rectangular manhole 150x150cm', NULL, NULL, NULL, NULL, NULL, NULL, 'N_PRQ150-H250');
INSERT INTO cat_node VALUES ('R_MANHOLE-CON200', 'Concret', 2.00, 2.00, NULL, NULL, 'R_MANHOLE_200_CON', 'Rectangular manhole 200x200cm', NULL, NULL, NULL, NULL, NULL, NULL, 'N_PRQ200-H250');
INSERT INTO cat_node VALUES ('R_MANHOLE-BR100', 'Brick', 1.00, 1.00, NULL, NULL, 'R_MANHOLE_100_BR', 'Rectangular manhole 100x100cm', NULL, NULL, NULL, NULL, NULL, NULL, 'N_PRQ100-H160');
INSERT INTO cat_node VALUES ('C_MANHOLE-BR100', 'Brick', 1.00, 1.00, NULL, NULL, 'C_MANHOLE_100_BR', 'Circular manhole ø100cm', NULL, NULL, NULL, NULL, NULL, NULL, 'N_PRD100-H160');
INSERT INTO cat_node VALUES ('CHAMBER-01', NULL, 3.00, 2.50, 3.00, NULL, 'CHAMBER', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N_CH300x250-H300');
INSERT INTO cat_node VALUES ('NETGULLY-01', NULL, NULL, NULL, NULL, NULL, 'NETGULLY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N_PRD80-H160');
INSERT INTO cat_node VALUES ('HIGH POINT-01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N_PRD80-H160');
INSERT INTO cat_node VALUES ('SEW_STORAGE-01', 'Concret', 5.00, 3.50, 4.75, NULL, 'SEW_STORAGE', 'Sewer storage 5x3.5x4.5m', NULL, NULL, NULL, NULL, NULL, NULL, 'N_STR500x350x475');
INSERT INTO cat_node VALUES ('JUMP-01', NULL, 1.00, NULL, NULL, NULL, 'WJUMP', 'Circular jump manhole ø100cm', NULL, NULL, NULL, NULL, NULL, NULL, 'N_JUMP100');
INSERT INTO cat_node VALUES ('WEIR-01', 'Concret', 1.50, 2.00, NULL, NULL, 'WEIR_CON', 'Rectangular weir 150x200cm', NULL, NULL, NULL, NULL, NULL, NULL, 'A_WEIR_60');
INSERT INTO cat_node VALUES ('VALVE-01', NULL, NULL, NULL, NULL, NULL, 'VALVE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N_VAL_01');


-- ----------------------------
-- Records of cat_connec
-- ----------------------------
INSERT INTO cat_connec VALUES ('CON-CC020_D', 'DOMESTIC', 'Concret', 'CIRCULAR', NULL, NULL, 0.2000, 0.0000, 0.0000, 0.0000, NULL, 'DOM_C20_CON', 'Concret connec', NULL, NULL, NULL, NULL);
INSERT INTO cat_connec VALUES ('CON-CC030_D', 'DOMESTIC', 'Concret', 'CIRCULAR', NULL, NULL, 0.3000, 0.0000, 0.0000, 0.0000, NULL, 'DOM_C30_CON', 'Concret connec', NULL, NULL, NULL, NULL);
INSERT INTO cat_connec VALUES ('PVC-CC025_D', 'DOMESTIC', 'PVC', 'CIRCULAR', NULL, NULL, 0.2500, 0.0000, 0.0000, 0.0000, NULL, 'DOM_C25_PVC', 'PVC connec', NULL, NULL, NULL, NULL);
INSERT INTO cat_connec VALUES ('PVC-CC030_D', 'DOMESTIC', 'PVC', 'CIRCULAR', NULL, NULL, 0.3000, 0.0000, 0.0000, 0.0000, NULL, 'DOM_C30_PVC', 'PVC connec', NULL, NULL, NULL, NULL);
INSERT INTO cat_connec VALUES ('CON-CC040_I', 'INDUSTRIAL', 'Concret', 'CIRCULAR', NULL, NULL, 0.4000, 0.0000, 0.0000, 0.0000, NULL, 'IND_C40_CON', 'Concret connec', NULL, NULL, NULL, NULL);
INSERT INTO cat_connec VALUES ('PVC-CC025_T', 'TRADE', 'PVC', 'CIRCULAR', NULL, NULL, 0.2500, 0.0000, 0.0000, 0.0000, NULL, 'TRA_C25_PVC', 'PVC connec', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_element
-- ----------------------------
INSERT INTO cat_element VALUES ('COVER70', 'COVER', 'FD', '70 cm', 'Cover iron Ø70cm', NULL, NULL, NULL, NULL);
INSERT INTO cat_element VALUES ('COVER70X70', 'COVER', 'FD', '70x70cm', 'Cover iron 70x70cm', NULL, NULL, NULL, NULL);
INSERT INTO cat_element VALUES ('STEP200', 'STEP', 'Iron', '20x20X20cm', 'Step iron 20x20cm', NULL, NULL, NULL, NULL);
INSERT INTO cat_element VALUES ('PUMP_ABS', 'PUMP', 'Iron', NULL, 'Model ABS AFP 1001 M300/4-43', NULL, NULL, NULL, NULL);


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
-- Records of cat_grate
-- ----------------------------

INSERT INTO cat_grate VALUES ('S/I', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.4000, 0.8000, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_grate VALUES ('EMB1', 'R-121', NULL, 78.0000, 36.4000, 2839.0000, 1214.0000, 6.0000, 1.0000, NULL, 0.5676, 0.7416, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_grate VALUES ('EMB2', 'IMPU', NULL, 78.0000, 34.1000, 2659.0000, 873.0000, 1.0000, 21.0000, NULL, 0.6804, 0.7661, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_grate VALUES ('EMB3', 'E-25', NULL, 64.0000, 30.0000, 1920.0000, 693.0000, 1.0000, NULL, 12.0000, 0.4958, 0.7124, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_grate VALUES ('EMB4', 'Ebro', NULL, 77.6000, 34.5000, 2677.0000, 1050.0000, NULL, 15.0000, NULL, 0.4569, 0.7590, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_grate VALUES ('EMB5', 'Interceptora ', NULL, 97.5000, 47.5000, 4825.0000, 1400.0000, 3.0000, 7.0000, NULL, 0.8184, 0.7577, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_grate VALUES ('EMB6', 'Delta', NULL, 56.5000, 29.5000, 1667.0000, 725.0000, 1.0000, NULL, 9.0000, 0.4538, 0.6592, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_grate VALUES ('EMB7', NULL, NULL, 50.0000, 25.0000, 860.0000, 400.0000, 3.0000, 1.0000, NULL, 0.3485, 0.6580, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_grate VALUES ('REIXA1', NULL, NULL, 32.5000, 100.0000, 3020.0000, 1112.4000, 35.0000, 1.0000, NULL, 0.5949, 0.3465, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_grate VALUES ('REIXA2', NULL, NULL, 19.5000, 100.0000, 1950.0000, 751.9000, 36.0000, NULL, NULL, 0.4729, 0.2437, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_grate VALUES ('REIXA3', NULL, NULL, 10.0000, 100.0000, 1140.0000, 397.4000, 36.0000, NULL, NULL, 0.3877, 0.1429, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_grate VALUES ('REIXA4', NULL, NULL, 12.4000, 100.0000, 1240.0000, 582.4000, 3.0000, NULL, 59.0000, 0.4111, 0.1784, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_grate VALUES ('REIXA5', NULL, NULL, 47.5000, 100.0000, 4825.0000, 1400.0000, 7.0000, 3.0000, NULL, 0.7792, 0.3230, NULL, NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_tag
-- ----------------------------
INSERT INTO cat_tag VALUES ('NO TAG', null);

