/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--SET LC_MESSAGES TO 'en_US.UTF-8';

SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- Records of value_state
-- ----------------------------
INSERT INTO value_state (id,name) VALUES (0,'OBSOLETE');
INSERT INTO value_state (id,name) VALUES (1,'ON SERVICE');
INSERT INTO value_state (id,name) VALUES (2,'PLANIFIED');

-- ----------------------------
-- Records of value_state_type
-- ----------------------------

INSERT INTO value_state_type VALUES (1, 0, 'OBSOLETE', false, false);
INSERT INTO value_state_type VALUES (2, 1, 'ON SERVICE', true, true);
INSERT INTO value_state_type VALUES (3, 2, 'PLANIFIED', true, true);
INSERT INTO value_state_type VALUES (4, 2, 'RECONSTRUCT', true, false);
INSERT INTO value_state_type VALUES (5, 1, 'PROVISIONAL', false, true);

-- ----------------------------
-- Records of value_verified
-- ----------------------------
INSERT INTO value_verified VALUES ('TO REVIEW');
INSERT INTO value_verified VALUES ('VERIFIED');


-- ----------------------------
-- Records of value_yesno
-- ----------------------------
INSERT INTO value_yesno VALUES ('NO');
INSERT INTO value_yesno VALUES ('YES');


-- ----------------------------
-- Records of man_type_category
-- ----------------------------
INSERT INTO man_type_category VALUES (1, 'Standard Category', 'NODE');
INSERT INTO man_type_category VALUES (2, 'Standard Category', 'ARC');
INSERT INTO man_type_category VALUES (3, 'Standard Category', 'CONNEC');
INSERT INTO man_type_category VALUES (4, 'Standard Category', 'ELEMENT');

-- ----------------------------
-- Records of man_type_fluid
-- ----------------------------
INSERT INTO man_type_fluid VALUES (1, 'Standard Fluid', 'NODE');
INSERT INTO man_type_fluid VALUES (2, 'Standard Fluid', 'ARC');
INSERT INTO man_type_fluid VALUES (3, 'Standard Fluid', 'CONNEC');
INSERT INTO man_type_fluid VALUES (4, 'Standard Fluid', 'ELEMENT');

-- ----------------------------
-- Records of man_type_location
-- ----------------------------
INSERT INTO man_type_location VALUES (1, 'Standard Location', 'NODE');
INSERT INTO man_type_location VALUES (2, 'Standard Location', 'ARC');
INSERT INTO man_type_location VALUES (3, 'Standard Location', 'CONNEC');
INSERT INTO man_type_location VALUES (4, 'Standard Location', 'ELEMENT');

-- ----------------------------
-- Records of man_type_function
-- ----------------------------
INSERT INTO man_type_function VALUES (1, 'Standard Function', 'NODE');
INSERT INTO man_type_function VALUES (2, 'Standard Function', 'ARC');
INSERT INTO man_type_function VALUES (3, 'Standard Function', 'CONNEC');
INSERT INTO man_type_function VALUES (4, 'Standard Function', 'ELEMENT');

/*
-- ----------------------------
-- Records of selector_valve
-- ----------------------------
INSERT INTO anl_mincut_selector_valve VALUES ('SHUTOFF-VALVE');
*/


