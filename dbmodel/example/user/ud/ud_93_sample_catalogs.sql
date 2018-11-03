/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO cat_mat_arc VALUES ('Brick', 'Brick', 0.0140);
INSERT INTO cat_mat_arc VALUES ('Concret', 'Concret', 0.0140);
INSERT INTO cat_mat_arc VALUES ('PEAD', 'PEAD', 0.0110);
INSERT INTO cat_mat_arc VALUES ('PEC', 'PEC', 0.0120);
INSERT INTO cat_mat_arc VALUES ('PVC', 'PVC', 0.0110);
INSERT INTO cat_mat_arc VALUES ('Unknown', 'Unknown', 0.0130);
INSERT INTO cat_mat_arc VALUES ('Virtual', 'Virtual', 0.0120);

INSERT INTO cat_mat_element VALUES ('Concret', 'Concret');
INSERT INTO cat_mat_element VALUES ('FD', 'FD');
INSERT INTO cat_mat_element VALUES ('Iron', 'Iron');
INSERT INTO cat_mat_element VALUES ('N/I', 'No information');



INSERT INTO cat_element VALUES ('COVER70', 'COVER', 'FD', '70 cm', 'Cover iron Ø70cm', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO cat_element VALUES ('COVER70X70', 'COVER', 'FD', '70x70cm', 'Cover iron 70x70cm', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO cat_element VALUES ('STEP200', 'STEP', 'Iron', '20x20X20cm', 'Step iron 20x20cm', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO cat_element VALUES ('PUMP_ABS', 'PUMP', 'Iron', NULL, 'Model ABS AFP 1001 M300/4-43', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO cat_element VALUES ('HYDROGEN SULFIDE SENSOR', 'IOT SENSOR', 'Iron', '10x10x10cm', 'Hydrogen sulfide sensor', NULL, NULL, NULL, NULL, NULL, true);
INSERT INTO cat_element VALUES ('WEEL PROTECTOR', 'PROTECTOR', 'Iron', '50x10x5cm', 'Weel protector', NULL, NULL, NULL, NULL, NULL, true);


INSERT INTO cat_mat_node VALUES ('Brick', 'Brick');
INSERT INTO cat_mat_node VALUES ('Concret', 'Concret');
INSERT INTO cat_mat_node VALUES ('PEAD', 'PEAD');
INSERT INTO cat_mat_node VALUES ('PVC', 'PVC');
INSERT INTO cat_mat_node VALUES ('N/I', 'N/I');
INSERT INTO cat_mat_node VALUES ('FD', 'FD');
INSERT INTO cat_mat_node VALUES ('Iron', 'Iron');


INSERT INTO cat_mat_gully VALUES ('N/I', 'N/I');
INSERT INTO cat_mat_gully VALUES ('FD', 'FD');
INSERT INTO cat_mat_gully VALUES ('Iron', 'Iron');
INSERT INTO cat_mat_gully VALUES ('Concret', 'Concret');


INSERT INTO cat_arc VALUES ('CON-CC100', 'Concret', 'CIRCULAR', 1.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Concret conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 1.30, 0.7854, 2.20, 0.15, 'm', 'A_CON_DN100', 'S_REP', 'S_NULL', true);
INSERT INTO cat_arc VALUES ('PVC-CC040', 'PVC', 'CIRCULAR', 0.4000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'PVC conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.52, 0.1257, 1.60, 0.06, 'm', 'A_PVC_DN40', 'S_REP', 'S_NULL', true);
INSERT INTO cat_arc VALUES ('PVC-CC060', 'PVC', 'CIRCULAR', 0.6000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'PVC conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.78, 0.2827, 1.80, 0.09, 'm', 'A_PVC_DN60', 'S_REP', 'S_NULL', true);
INSERT INTO cat_arc VALUES ('PVC-CC080', 'PVC', 'CIRCULAR', 0.8000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'PVC conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 1.04, 0.5027, 2.00, 0.12, 'm', 'A_PVC_DN80', 'S_REP', 'S_NULL', true);
INSERT INTO cat_arc VALUES ('PVC-CC020', 'PVC', 'CIRCULAR', 0.2000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'PVC conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.26, 0.0314, 1.40, 0.03, 'm', 'A_PVC_DN20', 'S_REP', 'S_NULL', true);
INSERT INTO cat_arc VALUES ('CON-CC040', 'Concret', 'CIRCULAR', 0.4000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Concret conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.52, 0.1257, 1.60, 0.06, 'm', 'A_CON_DN40', 'S_REP', 'S_NULL', true);
INSERT INTO cat_arc VALUES ('CON-CC060', 'Concret', 'CIRCULAR', 0.6000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Concret conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.78, 0.2827, 1.80, 0.09, 'm', 'A_CON_DN60', 'S_REP', 'S_NULL', true);
INSERT INTO cat_arc VALUES ('CON-CC080', 'Concret', 'CIRCULAR', 0.8000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Concret conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 1.04, 0.5027, 2.00, 0.12, 'm', 'A_CON_DN80', 'S_REP', 'S_NULL', true);
INSERT INTO cat_arc VALUES ('CON-EG150', 'Concret', 'EGG', 1.5000, 1.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Concret conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 1.15, 1.5000, 2.70, 0.22, 'm', 'A_CON_O150', 'S_REP', 'S_NULL', true);
INSERT INTO cat_arc VALUES ('CON-RC150', 'Concret', 'RECT_CLOSED', 1.5000, 1.5000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Concret conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 1.94, 2.2500, 2.70, 0.22, 'm', 'A_CON_R150', 'S_REP', 'S_NULL', true);
INSERT INTO cat_arc VALUES ('CON-RC200', 'Concret', 'RECT_CLOSED', 2.0000, 2.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Concret conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 2.60, 4.0000, 3.20, 0.30, 'm', 'A_CON_R200', 'S_REP', 'S_NULL', true);
INSERT INTO cat_arc VALUES ('PE-PP020', 'PEAD', 'FORCE_MAIN', 0.1800, 140.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'PEAD pump pipe', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.26, 0.0314, 1.40, 0.03, 'm', 'A_PRE_PE_DN20', 'S_REP', 'S_NULL', true);
INSERT INTO cat_arc VALUES ('PEC-CC040', 'PEC', 'CIRCULAR', 0.4000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'PEC conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.52, 0.1257, 1.60, 0.08, 'm', 'A_PEC_DN40', 'S_REP', 'S_NULL', true);
INSERT INTO cat_arc VALUES ('WEIR_60', 'Virtual', 'VIRTUAL', 0.6000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Weir', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.78, 0.2827, 1.80, 0.09, 'm', 'A_WEIR_60', 'S_REP', 'S_NULL', true);
INSERT INTO cat_arc VALUES ('PUMP_01', 'Virtual', 'VIRTUAL', 0.1800, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Pump', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.24, 0.0254, 1.38, 0.03, 'm', 'A_PRE_PE_DN20', 'S_REP', 'S_NULL', true);
INSERT INTO cat_arc VALUES ('PEC-CC315', 'PEC', 'CIRCULAR', 0.3150, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'PEC conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.42, 0.0920, 1.50, 0.06, 'm', 'A_PEC_DN315', 'S_REP', 'S_NULL', true);
INSERT INTO cat_arc VALUES ('VIRTUAL', 'Virtual', 'VIRTUAL', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Virtual', NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.0000, 0.00, 0.00, 'm', NULL, NULL, NULL, true);


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

INSERT INTO cat_connec VALUES ('PVC-CC025_D', 'PVC', 'CIRCULAR', 0.2500, 0.0000, 0.0000, 0.0000, NULL, 'PVC connec', NULL, NULL, NULL, NULL, 'N_CONNECTION', 'A_PVC_DN25', 'S_EXC', true);
INSERT INTO cat_connec VALUES ('CON-CC040_I', 'Concret', 'CIRCULAR', 0.4000, 0.0000, 0.0000, 0.0000, NULL, 'Concret connec', NULL, NULL, NULL, NULL, 'N_CONNECTION', 'A_CON_DN40', 'S_EXC', true);
INSERT INTO cat_connec VALUES ('PVC-CC025_T', 'PVC', 'CIRCULAR', 0.2500, 0.0000, 0.0000, 0.0000, NULL, 'PVC connec', NULL, NULL, NULL, NULL, 'N_CONNECTION', 'A_PVC_DN25', 'S_EXC', true);
INSERT INTO cat_connec VALUES ('PVC-CC030_D', 'PVC', 'CIRCULAR', 0.3000, 0.0000, 0.0000, 0.0000, NULL, 'PVC connec', NULL, NULL, NULL, NULL, 'N_CONNECTION', 'A_PVC_DN30', 'S_EXC', true);
INSERT INTO cat_connec VALUES ('CON-CC020_D', 'Concret', 'CIRCULAR', 0.2000, 0.0000, 0.0000, 0.0000, NULL, 'Concret connec', NULL, NULL, NULL, NULL, 'N_CONNECTION', 'A_CON_DN20', 'S_EXC', true);
INSERT INTO cat_connec VALUES ('CON-CC030_D', 'Concret', 'CIRCULAR', 0.3000, 0.0000, 0.0000, 0.0000, NULL, 'Concret connec', NULL, NULL, NULL, NULL, 'N_CONNECTION', 'A_CON_DN30', 'S_EXC', true);


INSERT INTO cat_node VALUES ('C_MANHOLE-BR100', 'Brick', NULL, 1.00, 1.00, NULL, NULL, 'Circular manhole ø100cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD100-H160', true);
INSERT INTO cat_node VALUES ('C_MANHOLE-CON100', 'Concret', NULL, 1.00, 1.00, NULL, NULL, 'Circular manhole ø100cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD100-H160', true);
INSERT INTO cat_node VALUES ('C_MANHOLE-CON80', 'Concret', NULL, 0.80, 1.00, NULL, NULL, 'Circular manhole ø80cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD80-H160', true);
INSERT INTO cat_node VALUES ('CHAMBER-01', 'Concret', NULL, 3.00, 2.50, 3.00, NULL, 'Chamber 3x2.5x3m', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_CH300x250-H300', true);
INSERT INTO cat_node VALUES ('HIGH POINT-01', 'Brick', NULL, 1.00, 1.00, NULL, NULL, 'High point', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD80-H160', true);
INSERT INTO cat_node VALUES ('JUMP-01', 'Concret', NULL, 1.00, 1.00, NULL, NULL, 'Circular jump manhole ø100cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_JUMP100', true);
INSERT INTO cat_node VALUES ('NETGULLY-01', 'Concret', NULL, 1.00, 1.00, NULL, NULL, 'Network gully', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD80-H160', true);
INSERT INTO cat_node VALUES ('R_MANHOLE-BR100', 'Brick', NULL, 1.00, 1.00, NULL, NULL, 'Rectangular manhole 100x100cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRQ100-H160', true);
INSERT INTO cat_node VALUES ('R_MANHOLE-CON100', 'Concret', NULL, 1.00, 1.00, NULL, NULL, 'Rectangular manhole 100x100cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRQ100-H160', true);
INSERT INTO cat_node VALUES ('R_MANHOLE-CON150', 'Concret', NULL, 1.50, 1.50, NULL, NULL, 'Rectangular manhole 150x150cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRQ150-H250', true);
INSERT INTO cat_node VALUES ('R_MANHOLE-CON200', 'Concret', NULL, 2.00, 2.00, NULL, NULL, 'Rectangular manhole 200x200cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRQ200-H250', true);
INSERT INTO cat_node VALUES ('SEW_STORAGE-01', 'Concret', NULL, 5.00, 3.50, 4.75, NULL, 'Sewer storage 5x3.5x4.5m', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_STR500x350x475', true);
INSERT INTO cat_node VALUES ('VALVE-01', 'Brick', NULL, 1.00, 1.00, NULL, NULL, 'Network valve', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_VAL_01', true);
INSERT INTO cat_node VALUES ('WEIR-01', 'Concret', NULL, 1.50, 2.00, NULL, NULL, 'Rectangular weir 150x200cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'A_WEIR_60', true);
INSERT INTO cat_node VALUES ('NETINIT-01', 'Brick', NULL, 1.00, 1.00, NULL, NULL, 'Network init', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD100-H160', true);
INSERT INTO cat_node VALUES ('NETELEMENT-01', 'Brick', NULL, 1.00, 1.00, NULL, NULL, 'Netelement rectangular', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD100-H160', true);
INSERT INTO cat_node VALUES ('JUNCTION-01', 'Brick', NULL, 1.00, 1.00, NULL, NULL, 'Juntion', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD100-H160', true);
INSERT INTO cat_node VALUES ('OUTFALL-01', 'Concret', NULL, 2.00, 1.00, NULL, NULL, 'Outfall', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD100-H160', true);
INSERT INTO cat_node VALUES ('NODE-01', 'Concret', NULL, 1.00, 1.00, NULL, NULL, 'Virtual node', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD80-H160', true);
INSERT INTO cat_node VALUES ('VIR_NODE-01', 'Brick', NULL, 1.00, 1.00, NULL, NULL, 'Virtual node', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD80-H160', true);
INSERT INTO cat_node VALUES ('WWTP-01', 'Concret', NULL, 1.00, 1.00, NULL, NULL, 'Wastewater treatment plant', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRQ150-H250', true);

INSERT INTO cat_owner VALUES ('owner1');
INSERT INTO cat_owner VALUES ('owner2');
INSERT INTO cat_owner VALUES ('owner3');

INSERT INTO cat_pavement VALUES ('Asphalt', NULL, NULL, 0.10, 'P_ASPHALT-10');
INSERT INTO cat_pavement VALUES ('pavement1', NULL, NULL, 0.10, 'P_ASPHALT-10');
INSERT INTO cat_pavement VALUES ('pavement2', NULL, NULL, 0.10, 'P_ASPHALT-10');

INSERT INTO cat_soil VALUES ('Standard Soil', 'Sòl estandard de plana dinundació', NULL, '5.00', '0.20', '0','S_EXC','S_REB','S_TRANS','S_TRENCH'); 

INSERT INTO cat_work VALUES ('work1');
INSERT INTO cat_work VALUES ('work2');
INSERT INTO cat_work VALUES ('work3');
INSERT INTO cat_work VALUES ('work4');

INSERT INTO cat_grate VALUES ('S/I', 'N/I', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.4000, 0.8000, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO cat_grate VALUES ('EMB1', 'FD', 78.0000, 36.4000, 2839.0000, 1214.0000, 6.0000, 1.0000, NULL, 0.5676, 0.7416, NULL, NULL, NULL, NULL, NULL, 'N_EMB1', true, NULL);
INSERT INTO cat_grate VALUES ('EMB2', 'FD', 78.0000, 34.1000, 2659.0000, 873.0000, 1.0000, 21.0000, NULL, 0.6804, 0.7661, NULL, NULL, NULL, NULL, NULL,'N_EMB2', true, NULL);
INSERT INTO cat_grate VALUES ('EMB3', 'FD', 64.0000, 30.0000, 1920.0000, 693.0000, 1.0000, NULL, 12.0000, 0.4958, 0.7124, NULL, NULL, NULL, NULL, NULL,'N_EMB3', true, NULL);
INSERT INTO cat_grate VALUES ('EMB4', 'FD', 77.6000, 34.5000, 2677.0000, 1050.0000, NULL, 15.0000, NULL, 0.4569, 0.7590, NULL, NULL, NULL, NULL, NULL,'N_EMB4', true, NULL);
INSERT INTO cat_grate VALUES ('EMB5', 'FD', 97.5000, 47.5000, 4825.0000, 1400.0000, 3.0000, 7.0000, NULL, 0.8184, 0.7577, NULL, NULL, NULL, NULL, NULL,'N_EMB5', true, NULL);
INSERT INTO cat_grate VALUES ('EMB6', 'FD', 56.5000, 29.5000, 1667.0000, 725.0000, 1.0000, NULL, 9.0000, 0.4538, 0.6592, NULL, NULL, NULL, NULL, NULL,'N_EMB6', true, NULL);
INSERT INTO cat_grate VALUES ('EMB7', 'FD', 50.0000, 25.0000, 860.0000, 400.0000, 3.0000, 1.0000, NULL, 0.3485, 0.6580, NULL, NULL, NULL, NULL, NULL,'N_EMB7', true, NULL);
INSERT INTO cat_grate VALUES ('REIXA1', 'Iron', 32.5000, 100.0000, 3020.0000, 1112.4000, 35.0000, 1.0000, NULL, 0.5949, 0.3465, NULL, NULL, NULL, NULL, NULL,'N_REIXA1', true, NULL);
INSERT INTO cat_grate VALUES ('REIXA2', 'FD', 19.5000, 100.0000, 1950.0000, 751.9000, 36.0000, NULL, NULL, 0.4729, 0.2437, NULL, NULL, NULL, NULL, NULL,'N_REIXA2', true, NULL);
INSERT INTO cat_grate VALUES ('REIXA3', 'FD', 10.0000, 100.0000, 1140.0000, 397.4000, 36.0000, NULL, NULL, 0.3877, 0.1429, NULL, NULL, NULL, NULL, NULL,'N_REIXA3', true, NULL);
INSERT INTO cat_grate VALUES ('REIXA4', 'FD', 12.4000, 100.0000, 1240.0000, 582.4000, 3.0000, NULL, 59.0000, 0.4111, 0.1784, NULL, NULL, NULL, NULL, NULL,'N_REIXA4', true, NULL);
INSERT INTO cat_grate VALUES ('REIXA5', 'FD', 47.5000, 100.0000, 4825.0000, 1400.0000, 7.0000, 3.0000, NULL, 0.7792, 0.3230, NULL, NULL, NULL, NULL, NULL,'N_REIXA5', true, NULL);



-----------------------------
-- Records of man_type_category
-- ----------------------------
INSERT INTO man_type_category VALUES (1, 'Standard Category', 'NODE');
INSERT INTO man_type_category VALUES (2, 'Standard Category', 'ARC');
INSERT INTO man_type_category VALUES (3, 'Standard Category', 'CONNEC');
INSERT INTO man_type_category VALUES (4, 'Standard Category', 'ELEMENT');
INSERT INTO man_type_category VALUES (5, 'Standard Category', 'GULLY');

-- ----------------------------
-- Records of man_type_fluid
-- ----------------------------
INSERT INTO man_type_fluid VALUES (1, 'Standard Fluid', 'NODE');
INSERT INTO man_type_fluid VALUES (2, 'Standard Fluid', 'ARC');
INSERT INTO man_type_fluid VALUES (3, 'Standard Fluid', 'CONNEC');
INSERT INTO man_type_fluid VALUES (4, 'Standard Fluid', 'ELEMENT');
INSERT INTO man_type_fluid VALUES (5, 'Standard Fluid', 'GULLY');

-- ----------------------------
-- Records of man_type_location
-- ----------------------------
INSERT INTO man_type_location VALUES (1, 'Standard Location', 'NODE');
INSERT INTO man_type_location VALUES (2, 'Standard Location', 'ARC');
INSERT INTO man_type_location VALUES (3, 'Standard Location', 'CONNEC');
INSERT INTO man_type_location VALUES (4, 'Standard Location', 'ELEMENT');
INSERT INTO man_type_location VALUES (5, 'Standard Location', 'GULLY');


-- ----------------------------
-- Records of man_type_function
-- ----------------------------
INSERT INTO man_type_function VALUES (1, 'Standard Function', 'NODE');
INSERT INTO man_type_function VALUES (2, 'Standard Function', 'ARC');
INSERT INTO man_type_function VALUES (3, 'Standard Function', 'CONNEC');
INSERT INTO man_type_function VALUES (4, 'Standard Function', 'ELEMENT');
INSERT INTO man_type_function VALUES (5, 'Standard Function', 'GULLY');

