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
INSERT INTO sys_feature_type VALUES ('GULLY');
INSERT INTO sys_feature_type VALUES ('ELEMENT');


-- ----------------------------
-- Records of sys_feature_cat
-- ----------------------------
INSERT INTO sys_feature_cat VALUES ('ELEMENT', 'ELEMENT',null, 'v_edit_element',null);
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