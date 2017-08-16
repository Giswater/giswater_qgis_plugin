/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Default values of state selection
-- ----------------------------
INSERT INTO inp_selector_state VALUES ('EN_SERVEI');


-- ----------------------------
-- Records of plan_selector_state
-- ----------------------------
INSERT INTO plan_selector_state VALUES ('EN_SERVEI');
INSERT INTO plan_selector_state VALUES ('RECONSTRUIR');
INSERT INTO plan_selector_state VALUES ('SUBSTITUIR');
INSERT INTO plan_selector_state VALUES ('PLANIFICAT');


-- ----------------------------
-- Records of man_selector_state
-- ----------------------------
INSERT INTO "man_selector_state" VALUES ('EN_SERVEI');


-- ----------------------------
-- Records of anl_selector_state
-- ----------------------------
INSERT INTO "anl_selector_state" VALUES ('EN_SERVEI');



-- ----------------------------
-- Default values of valve selection
-- ----------------------------
INSERT INTO anl_mincut_selector_valve VALUES ('VALVULA');


