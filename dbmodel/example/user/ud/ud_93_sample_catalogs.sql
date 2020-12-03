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
INSERT INTO cat_mat_node VALUES ('Virtual', 'Virtual');


INSERT INTO cat_mat_grate VALUES ('Brick', 'Brick');
INSERT INTO cat_mat_grate VALUES ('Concret', 'Concret');
INSERT INTO cat_mat_grate VALUES ('PEAD', 'PEAD');
INSERT INTO cat_mat_grate VALUES ('PVC', 'PVC');
INSERT INTO cat_mat_grate VALUES ('N/I', 'N/I');
INSERT INTO cat_mat_grate VALUES ('FD', 'FD');
INSERT INTO cat_mat_grate VALUES ('Iron', 'Iron');


INSERT INTO cat_mat_gully VALUES ('N/I', 'N/I');
INSERT INTO cat_mat_gully VALUES ('FD', 'FD');
INSERT INTO cat_mat_gully VALUES ('Iron', 'Iron');
INSERT INTO cat_mat_gully VALUES ('Concret', 'Concret');
INSERT INTO cat_mat_gully VALUES ('Brick', 'Brick');


INSERT INTO cat_arc VALUES ('CON-CC100', NULL, 'CIRCULAR', 1.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 1.30, 0.7854, 2.20, 0.15, 'm', 'A_CON_DN100', 'S_REP', 'S_NULL', true, null, null, null, 'CONDUIT');
INSERT INTO cat_arc VALUES ('SIPHON-CC100', NULL, 'CIRCULAR', 1.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 1.30, 0.7854, 2.20, 0.15, 'm', 'A_CON_DN100', 'S_REP', 'S_NULL', true, null, null, null,  'SIPHON');
INSERT INTO cat_arc VALUES ('PVC-CC040', NULL, 'CIRCULAR', 0.4000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.52, 0.1257, 1.60, 0.06, 'm', 'A_PVC_DN40', 'S_REP', 'S_NULL', true, null, null, null,  'CONDUIT');
INSERT INTO cat_arc VALUES ('PVC-CC060', NULL, 'CIRCULAR', 0.6000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.78, 0.2827, 1.80, 0.09, 'm', 'A_PVC_DN60', 'S_REP', 'S_NULL', true, null, null, null,  'CONDUIT');
INSERT INTO cat_arc VALUES ('PVC-CC080', NULL, 'CIRCULAR', 0.8000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 1.04, 0.5027, 2.00, 0.12, 'm', 'A_PVC_DN80', 'S_REP', 'S_NULL', true, null, null, null,  'CONDUIT');
INSERT INTO cat_arc VALUES ('WACCEL-CC020', NULL, 'CIRCULAR', 0.2000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.26, 0.0314, 1.40, 0.03, 'm', 'A_PVC_DN20', 'S_REP', 'S_NULL', true, null, null, null,  'WACCEL');
INSERT INTO cat_arc VALUES ('PVC-CC020', NULL, 'CIRCULAR', 0.2000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.26, 0.0314, 1.40, 0.03, 'm', 'A_PVC_DN20', 'S_REP', 'S_NULL', true, null, null, null,  'CONDUIT');
INSERT INTO cat_arc VALUES ('CON-CC040', NULL, 'CIRCULAR', 0.4000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.52, 0.1257, 1.60, 0.06, 'm', 'A_CON_DN40', 'S_REP', 'S_NULL', true, null, null, null,  'CONDUIT');
INSERT INTO cat_arc VALUES ('CON-CC060', NULL, 'CIRCULAR', 0.6000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.78, 0.2827, 1.80, 0.09, 'm', 'A_CON_DN60', 'S_REP', 'S_NULL', true, null, null, null,  'CONDUIT');
INSERT INTO cat_arc VALUES ('CON-CC080', NULL, 'CIRCULAR', 0.8000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 1.04, 0.5027, 2.00, 0.12, 'm', 'A_CON_DN80', 'S_REP', 'S_NULL', true, null, null, null,  'CONDUIT');
INSERT INTO cat_arc VALUES ('CON-EG150', NULL, 'EGG', 1.5000, 1.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 1.15, 1.5000, 2.70, 0.22, 'm', 'A_CON_O150', 'S_REP', 'S_NULL', true, null, null, null,  'CONDUIT');
INSERT INTO cat_arc VALUES ('CON-RC150', NULL, 'RECT_CLOSED', 1.5000, 1.5000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 1.94, 2.2500, 2.70, 0.22, 'm', 'A_CON_R150', 'S_REP', 'S_NULL', true, null, null, null,  'CONDUIT');
INSERT INTO cat_arc VALUES ('CON-RC200', NULL, 'RECT_CLOSED', 2.0000, 2.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 2.60, 4.0000, 3.20, 0.30, 'm', 'A_CON_R200', 'S_REP', 'S_NULL', true, null, null, null,  'SIPHON');
INSERT INTO cat_arc VALUES ('PE-PP020', NULL, 'FORCE_MAIN', 0.1800, 140.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Pump pipe', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.26, 0.0314, 1.40, 0.03, 'm', 'A_PRE_PE_DN20', 'S_REP', 'S_NULL', true, null, null, null,  'PUMP_PIPE');
INSERT INTO cat_arc VALUES ('PEC-CC040', NULL, 'CIRCULAR', 0.4000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.52, 0.1257, 1.60, 0.08, 'm', 'A_PEC_DN40', 'S_REP', 'S_NULL', true, null, null, null,  'CONDUIT');
INSERT INTO cat_arc VALUES ('WEIR_60', NULL, 'VIRTUAL', 0.6000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Weir', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.78, 0.2827, 1.80, 0.09, 'm', 'A_WEIR_60', 'S_REP', 'S_NULL', true, null,  null, null, 'VARC');
INSERT INTO cat_arc VALUES ('PUMP_01', NULL, 'VIRTUAL', 0.1800, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Pump', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.24, 0.0254, 1.38, 0.03, 'm', 'A_PRE_PE_DN20', 'S_REP', 'S_NULL', true, null,  null, null, 'VARC');
INSERT INTO cat_arc VALUES ('PEC-CC315', NULL, 'CIRCULAR', 0.3150, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.42, 0.0920, 1.50, 0.06, 'm', 'A_PEC_DN315', 'S_REP', 'S_NULL', true, null,  null, null, 'CONDUIT');
INSERT INTO cat_arc VALUES ('VIRTUAL', NULL, 'VIRTUAL', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Virtual', NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.0000, 0.00, 0.00, 'm', NULL, NULL, NULL, true, null, null, null, 'VARC');

INSERT INTO cat_arc VALUES ('CC100', NULL, 'CIRCULAR', 1.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 1.30, 0.7854, 2.20, 0.15, 'm', 'A_CON_DN100', 'S_REP', 'S_NULL', true, null, null, null, 'CONDUIT');
INSERT INTO cat_arc VALUES ('CC040', NULL, 'CIRCULAR', 0.4000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.52, 0.1257, 1.60, 0.06, 'm', 'A_PVC_DN40', 'S_REP', 'S_NULL', true, null, null, null,  'CONDUIT');
INSERT INTO cat_arc VALUES ('CC060', NULL, 'CIRCULAR', 0.6000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.78, 0.2827, 1.80, 0.09, 'm', 'A_PVC_DN60', 'S_REP', 'S_NULL', true, null, null, null,  'CONDUIT');
INSERT INTO cat_arc VALUES ('CC080', NULL, 'CIRCULAR', 0.8000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 1.04, 0.5027, 2.00, 0.12, 'm', 'A_PVC_DN80', 'S_REP', 'S_NULL', true, null, null, null,  'CONDUIT');
INSERT INTO cat_arc VALUES ('CC020', NULL, 'CIRCULAR', 0.2000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.26, 0.0314, 1.40, 0.03, 'm', 'A_PVC_DN20', 'S_REP', 'S_NULL', true, null, null, null,  'CONDUIT');
INSERT INTO cat_arc VALUES ('CC315', NULL, 'CIRCULAR', 0.3150, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.42, 0.0920, 1.50, 0.06, 'm', 'A_PEC_DN315', 'S_REP', 'S_NULL', true, null,  null, null, 'CONDUIT');
INSERT INTO cat_arc VALUES ('EG150', NULL, 'EGG', 1.5000, 1.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 1.15, 1.5000, 2.70, 0.22, 'm', 'A_CON_O150', 'S_REP', 'S_NULL', true, null, null, null,  'CONDUIT');
INSERT INTO cat_arc VALUES ('RC150', NULL, 'RECT_CLOSED', 1.5000, 1.5000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 1.94, 2.2500, 2.70, 0.22, 'm', 'A_CON_R150', 'S_REP', 'S_NULL', true, null, null, null,  'CONDUIT');
INSERT INTO cat_arc VALUES ('RC200', NULL, 'RECT_CLOSED', 2.0000, 2.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Conduit', NULL, NULL, NULL, NULL, 0.10, 0.10, 2.60, 4.0000, 3.20, 0.30, 'm', 'A_CON_R200', 'S_REP', 'S_NULL', true, null, null, null,  'SIPHON');
INSERT INTO cat_arc VALUES ('PP020', NULL, 'FORCE_MAIN', 0.1800, 140.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, 'Pump pipe', NULL, NULL, NULL, NULL, 0.10, 0.10, 0.26, 0.0314, 1.40, 0.03, 'm', 'A_PRE_PE_DN20', 'S_REP', 'S_NULL', true, null, null, null,  'PUMP_PIPE');


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


INSERT INTO cat_connec VALUES ('PVC-CC025_D', NULL, 'CIRCULAR', 0.2500, 0.0000, 0.0000, 0.0000, NULL, 'PVC connec', NULL, NULL, NULL, NULL, 'N_CONNECTION', 'A_PVC_DN25', 'S_EXC', true, null, 'CONNEC');
INSERT INTO cat_connec VALUES ('CON-CC040_I', NULL, 'CIRCULAR', 0.4000, 0.0000, 0.0000, 0.0000, NULL, 'Concret connec', NULL, NULL, NULL, NULL, 'N_CONNECTION', 'A_CON_DN40', 'S_EXC', true, null, 'CONNEC');
INSERT INTO cat_connec VALUES ('PVC-CC025_T', NULL, 'CIRCULAR', 0.2500, 0.0000, 0.0000, 0.0000, NULL, 'PVC connec', NULL, NULL, NULL, NULL, 'N_CONNECTION', 'A_PVC_DN25', 'S_EXC', true, null, 'CONNEC');
INSERT INTO cat_connec VALUES ('PVC-CC030_D', NULL, 'CIRCULAR', 0.3000, 0.0000, 0.0000, 0.0000, NULL, 'PVC connec', NULL, NULL, NULL, NULL, 'N_CONNECTION', 'A_PVC_DN30', 'S_EXC', true, null, 'CONNEC');
INSERT INTO cat_connec VALUES ('CON-CC020_D', NULL, 'CIRCULAR', 0.2000, 0.0000, 0.0000, 0.0000, NULL, 'Concret connec', NULL, NULL, NULL, NULL, 'N_CONNECTION', 'A_CON_DN20', 'S_EXC', true, null, 'CONNEC');
INSERT INTO cat_connec VALUES ('CON-CC030_D', NULL, 'CIRCULAR', 0.3000, 0.0000, 0.0000, 0.0000, NULL, 'Concret connec', NULL, NULL, NULL, NULL, 'N_CONNECTION', 'A_CON_DN30', 'S_EXC', true, null, 'CONNEC');
INSERT INTO cat_connec VALUES ('VIRTUAL', NULL, 'VIRTUAL', 0.3000, 0.0000, 0.0000, 0.0000, NULL, 'Virtual connec', NULL, NULL, NULL, NULL, 'N_CONNECTION', 'A_CON_DN30', 'S_EXC', true, null, 'VCONNEC');

INSERT INTO cat_connec VALUES ('CC025_D', NULL, 'CIRCULAR', 0.2500, 0.0000, 0.0000, 0.0000, NULL, 'Connec', NULL, NULL, NULL, NULL, 'N_CONNECTION', 'A_PVC_DN25', 'S_EXC', true, null, 'CONNEC');
INSERT INTO cat_connec VALUES ('CC040_I', NULL, 'CIRCULAR', 0.4000, 0.0000, 0.0000, 0.0000, NULL, 'Connec', NULL, NULL, NULL, NULL, 'N_CONNECTION', 'A_CON_DN40', 'S_EXC', true, null, 'CONNEC');
INSERT INTO cat_connec VALUES ('CC025_T', NULL, 'CIRCULAR', 0.2500, 0.0000, 0.0000, 0.0000, NULL, 'Connec', NULL, NULL, NULL, NULL, 'N_CONNECTION', 'A_PVC_DN25', 'S_EXC', true, null, 'CONNEC');
INSERT INTO cat_connec VALUES ('CC030_D', NULL, 'CIRCULAR', 0.3000, 0.0000, 0.0000, 0.0000, NULL, 'Connec', NULL, NULL, NULL, NULL, 'N_CONNECTION', 'A_PVC_DN30', 'S_EXC', true, null, 'CONNEC');
INSERT INTO cat_connec VALUES ('CC020_D', NULL, 'CIRCULAR', 0.2000, 0.0000, 0.0000, 0.0000, NULL, 'Connec', NULL, NULL, NULL, NULL, 'N_CONNECTION', 'A_CON_DN20', 'S_EXC', true, null, 'CONNEC');


INSERT INTO cat_node VALUES ('C_MANHOLE-BR100', NULL, NULL, 1.00, 1.00, NULL, NULL, 'Circular manhole ø100cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD100-H160', true, null, 'CIRC_MANHOLE');
INSERT INTO cat_node VALUES ('C_MANHOLE-CON100', NULL, NULL, 1.00, 1.00, NULL, NULL, 'Circular manhole ø100cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD100-H160', true, null, 'CIRC_MANHOLE');
INSERT INTO cat_node VALUES ('C_MANHOLE-CON80', NULL, NULL, 0.80, 1.00, NULL, NULL, 'Circular manhole ø80cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD80-H160', true, null, 'CIRC_MANHOLE');
INSERT INTO cat_node VALUES ('CHAMBER-01', NULL, NULL, 3.00, 2.50, 3.00, NULL, 'Chamber 3x2.5x3m', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_CH300x250-H300', true, null, 'CHAMBER');
INSERT INTO cat_node VALUES ('HIGH POINT-01', NULL, NULL, 1.00, 1.00, NULL, NULL, 'High point', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD80-H160', true, null, 'HIGHPOINT');
INSERT INTO cat_node VALUES ('JUMP-01', NULL, NULL, 1.00, 1.00, NULL, NULL, 'Circular jump manhole ø100cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_JUMP100', true, null, 'JUMP');
INSERT INTO cat_node VALUES ('NETGULLY-01', NULL, NULL, 1.00, 1.00, NULL, NULL, 'Network gully', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD80-H160', true, null, 'NETGULLY');
INSERT INTO cat_node VALUES ('R_MANHOLE-BR100', NULL, NULL, 1.00, 1.00, NULL, NULL, 'Rectangular manhole 100x100cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRQ100-H160', true, null, 'RECT_MANHOLE');
INSERT INTO cat_node VALUES ('R_MANHOLE-CON100', NULL, NULL, 1.00, 1.00, NULL, NULL, 'Rectangular manhole 100x100cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRQ100-H160', true, null, 'RECT_MANHOLE');
INSERT INTO cat_node VALUES ('R_MANHOLE-CON150', NULL, NULL, 1.50, 1.50, NULL, NULL, 'Rectangular manhole 150x150cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRQ150-H250', true, null, 'RECT_MANHOLE');
INSERT INTO cat_node VALUES ('R_MANHOLE-CON200', NULL, NULL, 2.00, 2.00, NULL, NULL, 'Rectangular manhole 200x200cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRQ200-H250', true, null, 'RECT_MANHOLE');
INSERT INTO cat_node VALUES ('SEW_STORAGE-01', NULL, NULL, 5.00, 3.50, 4.75, NULL, 'Sewer storage 5x3.5x4.5m', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_STR500x350x475', true, null, 'SEWER_STORAGE');
INSERT INTO cat_node VALUES ('VALVE-01', NULL, NULL, 1.00, 1.00, NULL, NULL, 'Network valve', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_VAL_01', true, null, 'VALVE');
INSERT INTO cat_node VALUES ('WEIR-01', NULL, NULL, 1.50, 2.00, NULL, NULL, 'Rectangular weir 150x200cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'A_WEIR_60', true, null, 'WEIR');
INSERT INTO cat_node VALUES ('NETINIT-01', NULL, NULL, 1.00, 1.00, NULL, NULL, 'Network init', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD100-H160', true, null, 'NETINIT');
INSERT INTO cat_node VALUES ('NETELEMENT-01', NULL, NULL, 1.00, 1.00, NULL, NULL, 'Netelement rectangular', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD100-H160', true, null, 'NETELEMENT');
INSERT INTO cat_node VALUES ('JUNCTION-01', NULL, NULL, 1.00, 1.00, NULL, NULL, 'Juntion', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD100-H160', true, null, 'JUNCTION');
INSERT INTO cat_node VALUES ('OUTFALL-01', NULL, NULL, 2.00, 1.00, NULL, NULL, 'Outfall', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD100-H160', true, null, 'OUTFALL');
INSERT INTO cat_node VALUES ('NODE-01', NULL, NULL, 1.00, 1.00, NULL, NULL, 'Virtual node', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD80-H160', true, null, 'VIRTUAL_NODE');
INSERT INTO cat_node VALUES ('VIR_NODE-01', NULL, NULL, 1.00, 1.00, NULL, NULL, 'Virtual node', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD80-H160', true, null, 'VIRTUAL_NODE');
INSERT INTO cat_node VALUES ('WWTP-01', NULL, NULL, 1.00, 1.00, NULL, NULL, 'Wastewater treatment plant', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRQ150-H250', true, null, 'WWTP');

INSERT INTO cat_node VALUES ('C_MANHOLE_100', NULL, NULL, 1.00, 1.00, NULL, NULL, 'Circular manhole ø100cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD100-H160', true, null, 'CIRC_MANHOLE');
INSERT INTO cat_node VALUES ('C_MANHOLE_80', NULL, NULL, 0.80, 1.00, NULL, NULL, 'Circular manhole ø80cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD80-H160', true, null, 'CIRC_MANHOLE');
INSERT INTO cat_node VALUES ('R_MANHOLE_100', NULL, NULL, 1.00, 1.00, NULL, NULL, 'Rectangular manhole 100x100cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRQ100-H160', true, null, 'RECT_MANHOLE');
INSERT INTO cat_node VALUES ('R_MANHOLE_150', NULL, NULL, 1.50, 1.50, NULL, NULL, 'Rectangular manhole 150x150cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRQ150-H250', true, null, 'RECT_MANHOLE');
INSERT INTO cat_node VALUES ('R_MANHOLE_200', NULL, NULL, 2.00, 2.00, NULL, NULL, 'Rectangular manhole 200x200cm', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRQ200-H250', true, null, 'RECT_MANHOLE');


INSERT INTO cat_owner VALUES ('owner1');
INSERT INTO cat_owner VALUES ('owner2');
INSERT INTO cat_owner VALUES ('owner3');

INSERT INTO cat_pavement VALUES ('Asphalt', NULL, NULL, 0.10, 'P_ASPHALT-10');
INSERT INTO cat_pavement VALUES ('pavement1', NULL, NULL, 0.10, 'P_ASPHALT-10');
INSERT INTO cat_pavement VALUES ('pavement2', NULL, NULL, 0.10, 'P_ASPHALT-10');

INSERT INTO cat_soil VALUES ('soil1', 'soil 1', NULL, 7.00, 0.25, 0.60, 'S_EXC', 'S_REB', 'S_TRANS', 'S_TRENCH'); 
INSERT INTO cat_soil VALUES ('soil2', 'soil 2', NULL, 7.00, 0.20, 0.25, 'S_EXC', 'S_REB', 'S_TRANS', 'S_TRENCH');
INSERT INTO cat_soil VALUES ('soil3', 'soil 3', NULL, 5.00, 0.20, 0.00, 'S_EXC', 'S_REB', 'S_TRANS', 'S_TRENCH');

INSERT INTO cat_work VALUES ('work1');
INSERT INTO cat_work VALUES ('work2');
INSERT INTO cat_work VALUES ('work3');
INSERT INTO cat_work VALUES ('work4');

INSERT INTO cat_grate VALUES ('N/I', 'N/I', 0.0, 0.0, NULL, NULL, NULL, NULL, NULL, 0.4000, 0.8000, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO cat_grate VALUES ('SGRT1', 'FD', 78.0000, 36.4000, 2839.0000, 1214.0000, 6.0000, 1.0000, NULL, 0.5676, 0.7416, NULL, NULL, NULL, NULL, NULL, 'N_SGRT1', true, NULL);
INSERT INTO cat_grate VALUES ('SGRT2', 'FD', 78.0000, 34.1000, 2659.0000, 873.0000, 1.0000, 21.0000, NULL, 0.6804, 0.7661, NULL, NULL, NULL, NULL, NULL,'N_SGRT2', true, NULL);
INSERT INTO cat_grate VALUES ('SGRT3', 'FD', 64.0000, 30.0000, 1920.0000, 693.0000, 1.0000, NULL, 12.0000, 0.4958, 0.7124, NULL, NULL, NULL, NULL, NULL,'N_SGRT3', true, NULL);
INSERT INTO cat_grate VALUES ('SGRT4', 'FD', 77.6000, 34.5000, 2677.0000, 1050.0000, NULL, 15.0000, NULL, 0.4569, 0.7590, NULL, NULL, NULL, NULL, NULL,'N_SGRT4', true, NULL);
INSERT INTO cat_grate VALUES ('SGRT5', 'FD', 97.5000, 47.5000, 4825.0000, 1400.0000, 3.0000, 7.0000, NULL, 0.8184, 0.7577, NULL, NULL, NULL, NULL, NULL,'N_SGRT5', true, NULL);
INSERT INTO cat_grate VALUES ('SGRT6', 'FD', 56.5000, 29.5000, 1667.0000, 725.0000, 1.0000, NULL, 9.0000, 0.4538, 0.6592, NULL, NULL, NULL, NULL, NULL,'N_SGRT6', true, NULL);
INSERT INTO cat_grate VALUES ('SGRT7', 'FD', 50.0000, 25.0000, 860.0000, 400.0000, 3.0000, 1.0000, NULL, 0.3485, 0.6580, NULL, NULL, NULL, NULL, NULL,'N_SGRT7', true, NULL);
INSERT INTO cat_grate VALUES ('BGRT1', 'Iron', 32.5000, 100.0000, 3020.0000, 1112.4000, 35.0000, 1.0000, NULL, 0.5949, 0.3465, NULL, NULL, NULL, NULL, NULL,'N_BGRT1', true, NULL);
INSERT INTO cat_grate VALUES ('BGRT2', 'FD', 19.5000, 100.0000, 1950.0000, 751.9000, 36.0000, NULL, NULL, 0.4729, 0.2437, NULL, NULL, NULL, NULL, NULL,'N_BGRT2', true, NULL);
INSERT INTO cat_grate VALUES ('BGRT3', 'FD', 10.0000, 100.0000, 1140.0000, 397.4000, 36.0000, NULL, NULL, 0.3877, 0.1429, NULL, NULL, NULL, NULL, NULL,'N_BGRT3', true, NULL);
INSERT INTO cat_grate VALUES ('BGRT4', 'FD', 12.4000, 100.0000, 1240.0000, 582.4000, 3.0000, NULL, 59.0000, 0.4111, 0.1784, NULL, NULL, NULL, NULL, NULL,'N_BGRT4', true, NULL);
INSERT INTO cat_grate VALUES ('BGRT5', 'FD', 47.5000, 100.0000, 4825.0000, 1400.0000, 7.0000, 3.0000, NULL, 0.7792, 0.3230, NULL, NULL, NULL, NULL, NULL,'N_BGRT5', true, NULL);



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



-- ----------------------------
-- Update shortcuts
-- ----------------------------

UPDATE cat_feature SET shortcut_key=NULL;

UPDATE cat_feature SET shortcut_key='B' WHERE id = 'CHAMBER';
UPDATE cat_feature SET shortcut_key='E' WHERE id = 'CHANGE';
UPDATE cat_feature SET shortcut_key='M' WHERE id = 'CIRC_MANHOLE';
UPDATE cat_feature SET shortcut_key='Alt+X' WHERE id = 'CONDUIT';
UPDATE cat_feature SET shortcut_key='Alt+C' WHERE id = 'CONNEC';
UPDATE cat_feature SET shortcut_key='Alt+M' WHERE id = 'GULLY';
UPDATE cat_feature SET shortcut_key='H' WHERE id = 'HIGHPOINT';
UPDATE cat_feature SET shortcut_key='J' WHERE id = 'JUMP';
UPDATE cat_feature SET shortcut_key='N' WHERE id = 'JUNCTION';
UPDATE cat_feature SET shortcut_key='A' WHERE id = 'NETELEMENT';
UPDATE cat_feature SET shortcut_key='Y' WHERE id = 'NETGULLY';
UPDATE cat_feature SET shortcut_key='I' WHERE id = 'NETINIT';
UPDATE cat_feature SET shortcut_key='O' WHERE id = 'OUTFALL';
UPDATE cat_feature SET shortcut_key='G' WHERE id = 'OWERFLOW_STORAGE';
UPDATE cat_feature SET shortcut_key='Alt+K' WHERE id = 'PGULLY';
UPDATE cat_feature SET shortcut_key='Alt+U' WHERE id = 'PUMP_PIPE';
UPDATE cat_feature SET shortcut_key='P' WHERE id = 'PUMP_STATION';
UPDATE cat_feature SET shortcut_key='R' WHERE id = 'RECT_MANHOLE';
UPDATE cat_feature SET shortcut_key='U' WHERE id = 'REGISTER';
UPDATE cat_feature SET shortcut_key='X' WHERE id = 'SANDBOX';
UPDATE cat_feature SET shortcut_key='L' WHERE id = 'SEWER_STORAGE';
UPDATE cat_feature SET shortcut_key='Alt+B' WHERE id = 'SIPHON';
UPDATE cat_feature SET shortcut_key='V' WHERE id = 'VALVE';
UPDATE cat_feature SET shortcut_key='Alt+Q' WHERE id = 'VARC';
UPDATE cat_feature SET shortcut_key='Q' WHERE id = 'VIRTUAL_NODE';
UPDATE cat_feature SET shortcut_key='Alt+G' WHERE id = 'WACCEL';
UPDATE cat_feature SET shortcut_key='F' WHERE id = 'WEIR';
UPDATE cat_feature SET shortcut_key='W' WHERE id = 'WWTP';
UPDATE cat_feature SET shortcut_key='Alt+N' WHERE id = 'EMBORNAL_FICTICI';
UPDATE cat_feature SET shortcut_key='Alt+Z' WHERE id = 'ESCOMESA_FICTICIA';
UPDATE cat_feature SET shortcut_key='Alt+1' WHERE id = 'VGULLY';
UPDATE cat_feature SET shortcut_key='Alt+2' WHERE id = 'VCONNEC';
