/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Records of cat_feature
-- ----------------------------
INSERT INTO cat_feature VALUES ('WJOIN', 'WJOIN', 'CONNEC');
INSERT INTO cat_feature VALUES ('FOUNTAIN', 'FOUNTAIN', 'CONNEC');
INSERT INTO cat_feature VALUES ('TAP', 'TAP', 'CONNEC');
INSERT INTO cat_feature VALUES ('GREENTAP', 'GREENTAP', 'CONNEC');
INSERT INTO cat_feature VALUES ('WATERWELL', 'WATERWELL', 'NODE');
INSERT INTO cat_feature VALUES ('NETSAMPLEPOINT', 'NETSAMPLEPOINT', 'NODE');
INSERT INTO cat_feature VALUES ('NETELEMENT', 'NETELEMENT', 'NODE');
INSERT INTO cat_feature VALUES ('WTP', 'WTP', 'NODE');
INSERT INTO cat_feature VALUES ('PIPE', 'PIPE', 'ARC');
INSERT INTO cat_feature VALUES ('VARC', 'VARC', 'ARC');
INSERT INTO cat_feature VALUES ('CHECK_VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('PR_REDUC_VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('GREEN_VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('CURVE', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('FILTER', 'FILTER', 'NODE');
INSERT INTO cat_feature VALUES ('ENDLINE', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('FL_CONTR_VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('GEN_PURP_VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('HYDRANT', 'HYDRANT', 'NODE');
INSERT INTO cat_feature VALUES ('PR_BREAK_VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('OUTFALL_VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('JUNCTION', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('PR_SUSTA_VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('SHUTOFF_VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('REDUCTION', 'REDUCTION', 'NODE');
INSERT INTO cat_feature VALUES ('PUMP', 'PUMP', 'NODE');
INSERT INTO cat_feature VALUES ('TANK', 'TANK', 'NODE');
INSERT INTO cat_feature VALUES ('THROTTLE_VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('T', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('X', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('SOURCE', 'SOURCE', 'NODE');
INSERT INTO cat_feature VALUES ('MANHOLE', 'MANHOLE', 'NODE');
INSERT INTO cat_feature VALUES ('REGISTER', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('CONTROL_REGISTER', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('BYPASS_REGISTER', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('VALVE_REGISTER', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('WATER_CONNECTION', 'NETWJOIN', 'NODE');
INSERT INTO cat_feature VALUES ('FLEXUNION', 'FLEXUNION', 'NODE');
INSERT INTO cat_feature VALUES ('AIR_VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('FLOWMETER', 'METER', 'NODE');
INSERT INTO cat_feature VALUES ('EXPANTANK', 'EXPANSIONTANK', 'NODE');
INSERT INTO cat_feature VALUES ('PRESSURE_METER', 'METER', 'NODE');
INSERT INTO cat_feature VALUES ('ADAPTATION', 'JUNCTION', 'NODE');




-- Records of node type system table
-- ----------------------------

INSERT INTO node_type  VALUES ('FL_CONTR_VALVE', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', true, true, 2, true, 'Flow control valve', NULL);
INSERT INTO node_type  VALUES ('SHUTOFF_VALVE', 'VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', true, true, 2, true, 'Shutoff valve', NULL);
INSERT INTO node_type  VALUES ('TANK', 'TANK', 'TANK', 'man_tank', 'inp_tank', true, true, 2, true, 'Tank', NULL);
INSERT INTO node_type  VALUES ('GREEN_VALVE', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', true, true, 2, true, 'Green valve', NULL);
INSERT INTO node_type  VALUES ('OUTFALL_VALVE', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', true, true, 2, true, 'Outfall valve', NULL);
INSERT INTO node_type  VALUES ('GEN_PURP_VALVE', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', true, true, 2, true, 'General purpose valve', NULL);
INSERT INTO node_type  VALUES ('HYDRANT', 'HYDRANT', 'JUNCTION', 'man_hydrant', 'inp_junction', true, true, 2, true, 'Hydrant', NULL);
INSERT INTO node_type  VALUES ('JUNCTION', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', true, true, 2, true, 'Junction', NULL);
INSERT INTO node_type  VALUES ('REDUCTION', 'REDUCTION', 'JUNCTION', 'man_reduction', 'inp_junction', true, true, 2, true, 'Reduction', NULL);
INSERT INTO node_type  VALUES ('PUMP', 'PUMP', 'PUMP', 'man_pump', 'inp_pump', true, true, 2, true, 'Pump', NULL);
INSERT INTO node_type  VALUES ('PR_SUSTA_VALVE', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', true, true, 2, true, 'Pressure sustainer valve', NULL);
INSERT INTO node_type  VALUES ('PR_REDUC_VALVE', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', true, true, 2, true, 'Pressure reduction valve', NULL);
INSERT INTO node_type  VALUES ('PR_BREAK_VALVE', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', true, true, 2, true, 'Pressure break valve', NULL);
INSERT INTO node_type  VALUES ('T', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', true, true, 3, true, 'Junction where 3 pipes converge', NULL);
INSERT INTO node_type  VALUES ('X', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', true, true, 4, true, 'Junction where 4 pipes converge', NULL);
INSERT INTO node_type  VALUES ('MANHOLE', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction', true, true, 2, true, 'Inspection chamber', NULL);
INSERT INTO node_type  VALUES ('REGISTER', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction', true, true, 2, true, 'Register', NULL);
INSERT INTO node_type  VALUES ('VALVE_REGISTER', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction', true, true, 2, true, 'Valve register', NULL);
INSERT INTO node_type  VALUES ('WATER_CONNECTION', 'NETWJOIN', 'JUNCTION', 'man_netwjoin', 'inp_junction', true, true, 2, true, 'Water connection', NULL);
INSERT INTO node_type  VALUES ('FLEXUNION', 'FLEXUNION', 'JUNCTION', 'man_flexunion', 'inp_junction', true, true, 2, true, 'Flex union', NULL);
INSERT INTO node_type  VALUES ('PRESSURE_METER', 'METER', 'JUNCTION', 'man_meter', 'inp_junction', true, true, 2, true, 'Pressure meter', NULL);
INSERT INTO node_type  VALUES ('NETSAMPLEPOINT', 'NETSAMPLEPOINT', 'JUNCTION', 'man_netsamplepoint', 'inp_junction', true, true, 2, true, 'Netsamplepoint', NULL);
INSERT INTO node_type  VALUES ('NETELEMENT', 'NETELEMENT', 'JUNCTION', 'man_netelement', 'inp_junction', true, true, 2, true, 'Netelement', NULL);
INSERT INTO node_type  VALUES ('TAP', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', true, true, 2, true, 'Tap', NULL);
INSERT INTO node_type  VALUES ('ADAPTATION', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', true, true, 2, true, 'Adaptation junction', NULL);
INSERT INTO node_type  VALUES ('BYPASS_REGISTER', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction', true, true, 2, true, 'Bypass-register', NULL);
INSERT INTO node_type  VALUES ('CURVE', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', true, true, 2, true, 'Curve', NULL);
INSERT INTO node_type  VALUES ('CONTROL_REGISTER', 'REGISTER', 'VALVE', 'man_register', 'inp_valve', true, true, 2, true, 'Control register', NULL);
INSERT INTO node_type  VALUES ('ENDLINE', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', true, true, 1, true, 'End of the line', NULL);
INSERT INTO node_type  VALUES ('EXPANTANK', 'EXPANSIONTANK', 'JUNCTION', 'man_expansiontank', 'inp_junction', true, true, 2, true, 'Expansiontank', NULL);
INSERT INTO node_type  VALUES ('FILTER', 'FILTER', 'SHORTPIPE', 'man_filter', 'inp_shortpipe', true, true, 2, true, 'Filter', NULL);
INSERT INTO node_type  VALUES ('WATERWELL', 'WATERWELL', 'JUNCTION', 'man_waterwell', 'inp_junction', true, true, 2, true, 'Waterwell', NULL);
INSERT INTO node_type  VALUES ('SOURCE', 'SOURCE', 'JUNCTION', 'man_source', 'inp_junction', true, true, 2, true, 'Source', NULL);
INSERT INTO node_type  VALUES ('WTP', 'WTP', 'RESERVOIR', 'man_wtp', 'inp_junction', true, true, 2, true, 'Water treatment point', NULL);
INSERT INTO node_type  VALUES ('AIR_VALVE', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', true, true, 2, true, 'Air valve', NULL);
INSERT INTO node_type  VALUES ('CHECK_VALVE', 'VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', true, true, 2, true, 'Check valve', NULL);
INSERT INTO node_type  VALUES ('FLOWMETER', 'METER', 'JUNCTION', 'man_meter', 'inp_junction', true, true, 2, true, 'Flow meter', NULL);
INSERT INTO node_type  VALUES ('THROTTLE_VALVE', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', true, true, 2, true, 'Throttle-valve', NULL);



-- Records of arc type system table
-- ----------------------------
INSERT INTO arc_type VALUES ('PIPE', 'PIPE', 'PIPE', 'man_pipe', 'inp_pipe', TRUE, TRUE, 'Water distribution pipe' );
INSERT INTO arc_type VALUES ('VARC', 'VARC', 'PIPE', 'man_varc', 'inp_pipe', TRUE, TRUE, 'Virtual section of the pipe network. Used to connect arcs and nodes when polygons exists'  );

-- Records of connec_type system table
-- ----------------------------
INSERT INTO connec_type VALUES ('WJOIN', 'WJOIN', 'man_wjoin', TRUE, TRUE, 'Wjoin');
INSERT INTO connec_type VALUES ('FOUNTAIN', 'FOUNTAIN', 'man_fountain', TRUE, TRUE, 'Ornamental fountain' );
INSERT INTO connec_type VALUES ('TAP', 'TAP', 'man_tap', TRUE, TRUE, 'Water source');
INSERT INTO connec_type VALUES ('GREENTAP', 'GREENTAP', 'man_greentap', TRUE, TRUE, 'Greentap');


-- Records of element type system table
-- ----------------------------
INSERT INTO element_type VALUES ('REGISTER', true, true, 'REGISTER', NULL);
INSERT INTO element_type VALUES ('MANHOLE', true, true, 'MANHOLE', NULL);
INSERT INTO element_type VALUES ('COVER', true, true, 'COVER', NULL);
INSERT INTO element_type VALUES ('STEP', true, true, 'STEP', NULL);
INSERT INTO element_type VALUES ('PROTECT_BAND', true, true, 'PROTECT BAND', NULL);
INSERT INTO element_type VALUES ('HYDRANT_PLATE', true, true, 'HYDRANT_PLATE', NULL);

-- Records of mincut
-- ----------------------------
INSERT INTO anl_mincut_selector_valve VALUES ('SHUTOFF_VALVE');

INSERT INTO anl_mincut_cat_cause VALUES ('Accidental', NULL);
INSERT INTO anl_mincut_cat_cause VALUES ('Planified', NULL);

INSERT INTO anl_mincut_cat_class VALUES (1, 'Network mincut', NULL);
INSERT INTO anl_mincut_cat_class VALUES (2, 'Connec mincut', NULL);
INSERT INTO anl_mincut_cat_class VALUES (3, 'Hydrometer mincut', NULL);

INSERT INTO anl_mincut_cat_state VALUES (1, 'In Progress', NULL);
INSERT INTO anl_mincut_cat_state VALUES (2, 'Finished', NULL);
INSERT INTO anl_mincut_cat_state VALUES (0, 'Planified', NULL);


INSERT INTO anl_mincut_cat_type VALUES ('Test', true);
INSERT INTO anl_mincut_cat_type VALUES ('Demo', true);
INSERT INTO anl_mincut_cat_type VALUES ('Real', false);