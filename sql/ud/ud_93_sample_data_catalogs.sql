/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- ----------------------------
-- Records of cat_mat_arc
-- ----------------------------
INSERT INTO SCHEMA_NAME.cat_mat_arc VALUES ('Concret', 'Concret', 0.0140, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_mat_arc VALUES ('PVC', 'PVC', 0.0110, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_mat_arc VALUES ('PEAD', 'PEAD', 0.0110, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_mat_arc VALUES ('Brick', 'Brick', 0.0140, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_mat_element
-- ----------------------------
INSERT INTO SCHEMA_NAME.cat_mat_element VALUES ('N/I', 'No information', NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_mat_element VALUES ('Concret', 'Concret', NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_mat_element VALUES ('Iron', 'Iron', NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_mat_element VALUES ('FD', 'Iron', NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_mat_node
-- ----------------------------
INSERT INTO SCHEMA_NAME.cat_mat_node VALUES ('Concret', 'Concret', NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_mat_node VALUES ('PEAD', 'PEAD', NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_mat_node VALUES ('Brick', 'Brick', NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_mat_node VALUES ('PVC', 'PVC', NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_arc
-- ---------------------------
INSERT INTO SCHEMA_NAME.cat_arc VALUES ('CON-CC040', 'Concret', 'CIRCULAR', NULL, NULL, 0.4000, 0.0000, 0.0000, 0.0000, NULL, 'C40_CON', 'Concret conduit', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_arc VALUES ('CON-CC060', 'Concret', 'CIRCULAR', NULL, NULL, 0.6000, 0.0000, 0.0000, 0.0000, NULL, 'C60_CON', 'Concret conduit', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_arc VALUES ('CON-CC080', 'Concret', 'CIRCULAR', NULL, NULL, 0.8000, 0.0000, 0.0000, 0.0000, NULL, 'C80_CON', 'Concret conduit', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_arc VALUES ('CON-CC100', 'Concret', 'CIRCULAR', NULL, NULL, 1.0000, 0.0000, 0.0000, 0.0000, NULL, 'C100_CON', 'Concret conduit', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_arc VALUES ('CON-EG150', 'Concret', 'EGG', NULL, NULL, 1.5000, 1.0000, 0.0000, 0.0000, NULL, 'E150_CON', 'Concret conduit', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_arc VALUES ('CON-RC150', 'Concret', 'RECT_CLOSED', NULL, NULL, 1.5000, 1.5000, 0.0000, 0.0000, NULL, 'R150_CON', 'Concret conduit', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_arc VALUES ('CON-RC200', 'Concret', 'RECT_CLOSED', NULL, NULL, 2.0000, 2.0000, 0.0000, 0.0000, NULL, 'R200_CON', 'Concret conduit', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_arc VALUES ('PVC-CC040', 'PVC', 'CIRCULAR', NULL, NULL, 0.4000, 0.0000, 0.0000, 0.0000, NULL, 'C40_PVC', 'PVC conduit', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_arc VALUES ('PVC-CC060', 'PVC', 'CIRCULAR', NULL, NULL, 0.6000, 0.0000, 0.0000, 0.0000, NULL, 'C60_PVC', 'PVC conduit', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_arc VALUES ('PVC-CC080', 'PVC', 'CIRCULAR', NULL, NULL, 0.8000, 0.0000, 0.0000, 0.0000, NULL, 'C80_PVC', 'PVC conduit', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_arc VALUES ('PVC-CC020', 'PVC', 'CIRCULAR', NULL, NULL, 0.2000, 0.0000, 0.0000, 0.0000, NULL, 'C20_PVC', 'PVC conduit', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_arc VALUES ('PVC-PP020', 'PVC', 'CIRCULAR', NULL, NULL, 0.2000, 0.0000, 0.0000, 0.0000, NULL, 'P20_PVC', 'PVC pump pipe', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_node
-- ----------------------------
INSERT INTO SCHEMA_NAME.cat_node VALUES ('WEIR-01', 'Concret', 1.50, 2.00, NULL, NULL, 'WEIR_CON', 'Rectangular weir 150x200cm', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_node VALUES ('OUTFALL-01', 'Concret', NULL, NULL, NULL, NULL, 'OUTFALL', 'Outfall', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_node VALUES ('VIR_NODE-01', 'Concret', NULL, NULL, NULL, NULL, 'VIR_NODE_CON', 'Virtual node', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_node VALUES ('C_MANHOLE-CON80', 'Concret', 0.80, NULL, NULL, NULL, 'C_MANHOLE_80_CON', 'Circula manhole Ø80cm', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_node VALUES ('C_MANHOLE-CON100', 'Concret', 1.00, NULL, NULL, NULL, 'C_MANHOLE_100_CON', 'Circula manhole Ø100cm', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_node VALUES ('R_MANHOLE-CON100', 'Concret', 1.00, 1.00, NULL, NULL, 'R_MANHOLE_100_CON', 'Rectangular manhole 100x100cm', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_node VALUES ('R_MANHOLE-CON150', 'Concret', 1.50, 1.50, NULL, NULL, 'R_MANHOLE_150_CON', 'Rectangular manhole 150x150cm', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_node VALUES ('R_MANHOLE-CON200', 'Concret', 2.00, 2.00, NULL, NULL, 'R_MANHOLE_200_CON', 'Rectangular manhole 200x200cm', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_node VALUES ('R_MANHOLE-BR100', 'Brick', 1.00, 1.00, NULL, NULL, 'R_MANHOLE_100_CON', 'Rectangular manhole 100x100cm', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_node VALUES ('C_MANHOLE-BR100', 'Brick', 1.00, 1.00, NULL, NULL, 'C_MANHOLE_100_BR', 'Circula manhole Ø100cm', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_node VALUES ('SEW_STORAGE-01', 'Concret', 5.00, 3.50, 4.75, NULL, 'SEW_STORAGE', 'Sewer storage 5x3.5x4.5m', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_connec
-- ----------------------------
INSERT INTO SCHEMA_NAME.cat_connec VALUES ('CON-CC020_D', 'DOMESTIC', 'Concret', 'CIRCULAR', NULL, NULL, 0.2000, 0.0000, 0.0000, 0.0000, NULL, 'DOM_C20_CON', 'Concret connec', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_connec VALUES ('CON-CC030_D', 'DOMESTIC', 'Concret', 'CIRCULAR', NULL, NULL, 0.3000, 0.0000, 0.0000, 0.0000, NULL, 'DOM_C30_CON', 'Concret connec', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_connec VALUES ('PVC-CC025_D', 'DOMESTIC', 'PVC', 'CIRCULAR', NULL, NULL, 0.2500, 0.0000, 0.0000, 0.0000, NULL, 'DOM_C25_PVC', 'PVC connec', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_connec VALUES ('PVC-CC030_D', 'DOMESTIC', 'PVC', 'CIRCULAR', NULL, NULL, 0.3000, 0.0000, 0.0000, 0.0000, NULL, 'DOM_C30_PVC', 'PVC connec', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_connec VALUES ('CON-CC040_I', 'INDUSTRIAL', 'Concret', 'CIRCULAR', NULL, NULL, 0.4000, 0.0000, 0.0000, 0.0000, NULL, 'IND_C40_CON', 'Concret connec', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_connec VALUES ('PVC-CC025_T', 'TRADE', 'PVC', 'CIRCULAR', NULL, NULL, 0.2500, 0.0000, 0.0000, 0.0000, NULL, 'TRA_C25_PVC', 'PVC connec', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_element
-- ----------------------------
INSERT INTO SCHEMA_NAME.cat_element VALUES ('COVER70', 'COVER', 'FD', '70 cm', 'Cover iron Ø70cm', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_element VALUES ('COVER70X70', 'COVER', 'FD', '70x70cm', 'Cover iron 70x70cm', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_element VALUES ('STEP200', 'STEP', 'Iron', '20x20X20cm', 'Step iron 20x20cm', NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.cat_element VALUES ('PUMP_ABS', 'PUMP', 'Iron', NULL, 'Model ABS AFP 1001 M300/4-43', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_builder
-- ----------------------------
INSERT INTO SCHEMA_NAME.cat_builder VALUES ('BUILDER NO DATA', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_owner
-- ----------------------------
INSERT INTO SCHEMA_NAME.cat_owner VALUES ('OWNER NO DATA', NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_soil
-- ----------------------------
INSERT INTO SCHEMA_NAME.cat_soil VALUES ('SOIL NO DATA', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_work
-- ----------------------------
INSERT INTO SCHEMA_NAME.cat_work VALUES ('WORK NO DATA', NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_event
-- ----------------------------
INSERT INTO SCHEMA_NAME.cat_event VALUES ('EV01-INS', 'INSPECTION', 'Inspection 2015', NULL);
INSERT INTO SCHEMA_NAME.cat_event VALUES ('EV02-REP', 'REPAIR', 'Repair 2015', NULL);
INSERT INTO SCHEMA_NAME.cat_event VALUES ('EV03-INS', 'INSPECTION', 'Inspection 2016', NULL);
INSERT INTO SCHEMA_NAME.cat_event VALUES ('EV04-REC', 'RECONSTRUCT', 'Reconstruction 2015', NULL);


-- ----------------------------
-- Records of cat_tag
-- ----------------------------
INSERT INTO SCHEMA_NAME.cat_tag VALUES ('NO TAG', null);







