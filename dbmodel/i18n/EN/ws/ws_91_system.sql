/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;
-- ----------------------------
-- Records of sys_feature_type
-- ----------------------------
INSERT INTO sys_feature_type VALUES ('NODE');
INSERT INTO sys_feature_type VALUES ('ARC');
INSERT INTO sys_feature_type VALUES ('CONNEC');

-- ----------------------------
-- Records of sys_feature_cat
-- ----------------------------
INSERT INTO sys_feature_cat VALUES ('EXPANSIONTANK', 'NODE', 1, 'v_edit_man_expansiontank', 'X');
INSERT INTO sys_feature_cat VALUES ('FILTER', 'NODE', 2, 'v_edit_man_filter', 'F');
INSERT INTO sys_feature_cat VALUES ('FLEXUNION', 'NODE', 3, 'v_edit_man_flexunion', 'U');
INSERT INTO sys_feature_cat VALUES ('FOUNTAIN', 'CONNEC', 1, 'v_edit_man_fountain', 'N');
INSERT INTO sys_feature_cat VALUES ('GREENTAP', 'CONNEC', 2, 'v_edit_man_greentap', 'G');
INSERT INTO sys_feature_cat VALUES ('JUNCTION', 'NODE', 5, 'v_edit_man_junction', 'J');
INSERT INTO sys_feature_cat VALUES ('NETELEMENT', 'NODE', 16, 'v_edit_man_netelement', 'E');
INSERT INTO sys_feature_cat VALUES ('NETSAMPLEPOINT', 'NODE', 15, 'v_edit_man_netsamplepoint', 'S');
INSERT INTO sys_feature_cat VALUES ('PIPE', 'ARC', 1, 'v_edit_man_pipe', 'P');
INSERT INTO sys_feature_cat VALUES ('PUMP', 'NODE', 9, 'v_edit_man_pump', 'U');
INSERT INTO sys_feature_cat VALUES ('REDUCTION', 'NODE', 10, 'v_edit_man_reduction', 'R');
INSERT INTO sys_feature_cat VALUES ('SOURCE', 'NODE', 12, 'v_edit_man_source', 'S');
INSERT INTO sys_feature_cat VALUES ('REGISTER', 'NODE', 11, 'v_edit_man_register', 'I');
INSERT INTO sys_feature_cat VALUES ('TANK', 'NODE', 13, 'v_edit_man_tank', 'K');
INSERT INTO sys_feature_cat VALUES ('TAP', 'CONNEC', 3, 'v_edit_man_tap', 'T');
INSERT INTO sys_feature_cat VALUES ('MANHOLE', 'NODE', 6, 'v_edit_man_manhole', 'L');
INSERT INTO sys_feature_cat VALUES ('METER', 'NODE', 7, 'v_edit_man_meter', 'M');
INSERT INTO sys_feature_cat VALUES ('VALVE', 'NODE', 14, 'v_edit_man_valve', 'V');
INSERT INTO sys_feature_cat VALUES ('VARC', 'ARC', 2, 'v_edit_man_varc', 'A');
INSERT INTO sys_feature_cat VALUES ('WATERWELL', 'NODE', 17, 'v_edit_man_waterwell', 'W');
INSERT INTO sys_feature_cat VALUES ('NETWJOIN', 'NODE', 8, 'v_edit_man_netwjoin', 'O');
INSERT INTO sys_feature_cat VALUES ('WJOIN', 'CONNEC', 4, 'v_edit_man_wjoin', 'Z');
INSERT INTO sys_feature_cat VALUES ('WTP', 'NODE', 18, 'v_edit_man_wtp', 'X');
INSERT INTO sys_feature_cat VALUES ('HYDRANT', 'NODE', 4, 'v_edit_man_hydrant', 'H');

-- ----------------------------
-- Records of cat_feature
-- ----------------------------
INSERT INTO cat_feature VALUES ('WJOIN', 'WJOIN', 'CONNEC');
INSERT INTO cat_feature VALUES ('FOUNTAIN', 'FOUNTAIN', 'CONNEC');
INSERT INTO cat_feature VALUES ('TAP', 'TAP', 'CONNEC');
INSERT INTO cat_feature VALUES ('GREEN_TAP', 'GREENTAP', 'CONNEC');
INSERT INTO cat_feature VALUES ('WATERWELL', 'WATERWELL', 'NODE');
INSERT INTO cat_feature VALUES ('NETSAMPLEPOINT', 'NETSAMPLEPOINT', 'NODE');
INSERT INTO cat_feature VALUES ('NETELEMENT', 'NETELEMENT', 'NODE');
INSERT INTO cat_feature VALUES ('WTP', 'WTP', 'NODE');
INSERT INTO cat_feature VALUES ('PIPE', 'PIPE', 'ARC');
INSERT INTO cat_feature VALUES ('CHECK VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('PR-REDUC.VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('GREEN VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('CURVE', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('FILTER', 'FILTER', 'NODE');
INSERT INTO cat_feature VALUES ('ENDLINE', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('FL-CONTR.VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('GEN-PURP.VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('HYDRANT', 'HYDRANT', 'NODE');
INSERT INTO cat_feature VALUES ('PR-BREAK.VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('OUTFALL VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('JUNCTION', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('PR-SUSTA.VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('SHUTOFF VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('REDUCTION', 'REDUCTION', 'NODE');
INSERT INTO cat_feature VALUES ('PUMP', 'PUMP', 'NODE');
INSERT INTO cat_feature VALUES ('TANK', 'TANK', 'NODE');
INSERT INTO cat_feature VALUES ('THROTTLE VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('T', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('X', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('SOURCE', 'SOURCE', 'NODE');
INSERT INTO cat_feature VALUES ('MANHOLE', 'MANHOLE', 'NODE');
INSERT INTO cat_feature VALUES ('SIMPLE REGISTER', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('CONTROL REGISTER', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('BYPASS REGISTER', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('VALVE REGISTER', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('WATER CONNECTION', 'NETWJOIN', 'NODE');
INSERT INTO cat_feature VALUES ('FLEXUNION', 'FLEXUNION', 'NODE');
INSERT INTO cat_feature VALUES ('AIR VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('FLOW METER', 'METER', 'NODE');
INSERT INTO cat_feature VALUES ('EXPANSION TANK', 'EXPANSIONTANK', 'NODE');
INSERT INTO cat_feature VALUES ('PRESSURE METER', 'METER', 'NODE');
INSERT INTO cat_feature VALUES ('ADAPTATION', 'JUNCTION', 'NODE');

-- ----------------------------
-- Records of node type system table
-- ----------------------------
/*
INSERT INTO node_type VALUES ('ADAPTATION', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('CHECK VALVE', 'VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe');
INSERT INTO node_type VALUES ('AIR VALVE', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction');
INSERT INTO node_type VALUES ('PR-REDUC.VALVE', 'VALVE', 'VALVE', 'man_valve', 'inp_valve');
INSERT INTO node_type VALUES ('LUVE', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('GREEN VALVE', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction');
INSERT INTO node_type VALUES ('FLOW METER', 'MEASURE INSTRUMENT', 'SHORTPIPE', 'man_meter', 'inp_shortpipe');
INSERT INTO node_type VALUES ('CURVE', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('FILTER', 'FILTER', 'SHORTPIPE', 'man_filter', 'inp_shortpipe');
INSERT INTO node_type VALUES ('ENDLINE', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('FL-CONTR.VALVE', 'VALVE', 'VALVE', 'man_valve', 'inp_valve');
INSERT INTO node_type VALUES ('GEN-PURP.VALVE', 'VALVE', 'VALVE', 'man_valve', 'inp_valve');
INSERT INTO node_type VALUES ('HYDRANT', 'HYDRANT', 'JUNCTION', 'man_hydrant', 'inp_junction');
INSERT INTO node_type VALUES ('PR-BREAK.VALVE', 'VALVE', 'VALVE', 'man_valve', 'inp_valve');
INSERT INTO node_type VALUES ('OUTFALL VALVE', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction');
INSERT INTO node_type VALUES ('JUNCTION', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('PRESSURE METER', 'MEASURE INSTRUMENT', 'JUNCTION', 'man_meter', 'inp_junction');
INSERT INTO node_type VALUES ('PR-SUSTA.VALVE', 'VALVE', 'VALVE', 'man_valve', 'inp_valve');
INSERT INTO node_type VALUES ('SHUTOFF VALVE', 'VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe');
INSERT INTO node_type VALUES ('REDUCTION', 'REDUCTION', 'JUNCTION', 'man_reduction', 'inp_junction');
INSERT INTO node_type VALUES ('PUMP', 'PUMP', 'PUMP', 'man_pump', 'inp_pump');
INSERT INTO node_type VALUES ('TANK', 'TANK', 'TANK', 'man_tank', 'inp_tank');
INSERT INTO node_type VALUES ('THROTTLE VALVE', 'VALVE', 'VALVE', 'man_valve', 'inp_valve');
INSERT INTO node_type VALUES ('T', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('WATERWELL', 'JUNCTION', 'JUNCTION', 'man_waterwell', 'inp_junction');
INSERT INTO node_type VALUES ('TAP', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction,');
INSERT INTO node_type VALUES ('X', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('SOURCE', 'SOURCE', 'JUNCTION', 'man_source', 'inp_junction');
INSERT INTO node_type VALUES ('MANHOLE', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction');
INSERT INTO node_type VALUES ('SIMPLE REGISTER', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction');
INSERT INTO node_type VALUES ('CONTROL REGISTER', 'REGISTER', 'VALVE', 'man_register', 'inp_valve');
INSERT INTO node_type VALUES ('BYPASS REGISTER', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction');
INSERT INTO node_type VALUES ('VALVE REGISTER', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction');
INSERT INTO node_type VALUES ('WATER CONNECTION', 'NETWJOIN', 'JUNCTION', 'man_netwjoin', 'inp_junction');
INSERT INTO node_type VALUES ('EXPANSION TANK', 'EXPANSIONTANK', 'JUNCTION', 'man_expansiontank', 'inp_junction');
INSERT INTO node_type VALUES ('FLEXUNION', 'FLEXUNION', 'JUNCTION', 'man_flexunion', 'inp_junction');
*/
-- ----------------------------
-- Records of arc type system table
-- ----------------------------
INSERT INTO arc_type VALUES ('PIPE', 'PIPE', 'PIPE', 'man_pipe', 'inp_pipe');


-- ----------------------------
-- Records of connec_type system table
-- ----------------------------
/*
INSERT INTO connec_type VALUES ('GREEN_TAP', 'GREEN TAP', 'man_greentap');
INSERT INTO connec_type VALUES ('WJOIN', 'WJOIN', 'man_wjoin');
INSERT INTO connec_type VALUES ('FOUNTAIN', 'FOUNTAIN', 'man_fountain' );
INSERT INTO connec_type VALUES ('TAP', 'TAP', 'man_tap');
*/


-- ----------------------------
-- Records of element type system table
-- ----------------------------
/*
INSERT INTO element_type VALUES ('REGISTER', 'REGISTER');
INSERT INTO element_type VALUES ('MANHOLE', 'MANHOLE');
INSERT INTO element_type VALUES ('COVER', 'COVER');
INSERT INTO element_type VALUES ('STEP', 'STEP');
*/
