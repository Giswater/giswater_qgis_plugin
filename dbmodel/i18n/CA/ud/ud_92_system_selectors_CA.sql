/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- Default values of state selection
-- ----------------------------
INSERT INTO "inp_selector_state" VALUES ('EN_SERVEI');


-- ----------------------------
-- Default values of hydrology selection
-- ----------------------------

INSERT INTO "inp_selector_hydrology" VALUES ('CH_PER_DEFECTE');



-- ----------------------------
-- Records of plan_selector_economic
-- ----------------------------
INSERT INTO "plan_selector_economic" VALUES ('EN_SERVEI');
INSERT INTO "plan_selector_economic" VALUES ('RECONSTRUIR');
INSERT INTO "plan_selector_economic" VALUES ('SUBSTITUIR');
INSERT INTO "plan_selector_economic" VALUES ('PLANIFICAT');