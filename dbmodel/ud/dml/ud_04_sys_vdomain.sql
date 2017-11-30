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
INSERT INTO sys_feature_cat VALUES ('CHAMBER', 'NODE', 1, 'v_edit_man_chamber', 'H', 'ch');
INSERT INTO sys_feature_cat VALUES ('CONDUIT', 'ARC', 4, 'v_edit_man_conduit', 'D', 'cd');
INSERT INTO sys_feature_cat VALUES ('CONNEC', 'CONNEC', 1, 'v_edit_man_connec', 'C', 'cn');
INSERT INTO sys_feature_cat VALUES ('GULLY', 'GULLY', 1, 'v_edit_man_gully', 'G', 'gu');
INSERT INTO sys_feature_cat VALUES ('JUNCTION', 'NODE', 2, 'v_edit_man_junction', 'J', 'jt');
INSERT INTO sys_feature_cat VALUES ('MANHOLE', 'NODE', 3, 'v_edit_man_manhole', 'M', 'mh');
INSERT INTO sys_feature_cat VALUES ('NETGULLY', 'NODE', 4, 'v_edit_man_netgully', 'Y', 'ng');
INSERT INTO sys_feature_cat VALUES ('NETINIT', 'NODE', 5, 'v_edit_man_netinit', 'I', 'ni');
INSERT INTO sys_feature_cat VALUES ('OUTFALL', 'NODE', 6, 'v_edit_man_outfall', 'O', 'of');
INSERT INTO sys_feature_cat VALUES ('SIPHON', 'ARC', 1, 'v_edit_man_siphon', 'S', 'sh');
INSERT INTO sys_feature_cat VALUES ('STORAGE', 'NODE', 7, 'v_edit_man_storage', 'T', 'st');
INSERT INTO sys_feature_cat VALUES ('VALVE', 'NODE', 8, 'v_edit_man_valve', 'V', 'vl');
INSERT INTO sys_feature_cat VALUES ('VARC', 'ARC', 2, 'v_edit_man_varc', 'A', 'va');
INSERT INTO sys_feature_cat VALUES ('WACCEL', 'ARC', 3, 'v_edit_man_waccel', 'W', 'wl');
INSERT INTO sys_feature_cat VALUES ('WJUMP', 'NODE', 9, 'v_edit_man_wjump', 'U', 'wj');
INSERT INTO sys_feature_cat VALUES ('WWTP', 'NODE', 10, 'v_edit_man_wwtp', 'P', 'wt');