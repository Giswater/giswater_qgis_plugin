/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association


VALUE DEFAULT FILE IS NOT VALID FOR ARC & NODE AND DERIVATES TABLES. 
THIS MEANS THAT YOU ARE NOT ALLOWED TO MODIFY DEFAULT VALUE OF THIS TABLES:

- ARC
- CONDUIT
- PUMP
- ORIFICE
- WEIR
- OUTLET
- NODE
- JUNCTION
- DIVIDER
- OUTFALL
- STORAGE
*/


-- ----------------------------
-- Default values of state selection
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."state_selection" VALUES ('ON_SERVICE');


-- ----------------------------
-- Default values of hydrologics
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."cat_hydrology" VALUES ('HC_DEFAULT', 'CURVE_NUMBER', 'Default value of infiltration');
ALTER TABLE "SCHEMA_NAME".subcatchment ALTER COLUMN hydrology_id SET DEFAULT 'HC_DEFAULT';
INSERT INTO "SCHEMA_NAME"."hydrology_selection" VALUES ('HC_DEFAULT');


-- ----------------------------
-- Default values of subcatchment
-- ----------------------------
ALTER TABLE "SCHEMA_NAME".subcatchment ALTER COLUMN imperv SET DEFAULT 90;
ALTER TABLE "SCHEMA_NAME".subcatchment ALTER COLUMN nimp SET DEFAULT 0.01;
ALTER TABLE "SCHEMA_NAME".subcatchment ALTER COLUMN nperv SET DEFAULT 0.1;
ALTER TABLE "SCHEMA_NAME".subcatchment ALTER COLUMN simp SET DEFAULT 0.05;
ALTER TABLE "SCHEMA_NAME".subcatchment ALTER COLUMN sperv SET DEFAULT 0.05;
ALTER TABLE "SCHEMA_NAME".subcatchment ALTER COLUMN zero SET DEFAULT 25;
ALTER TABLE "SCHEMA_NAME".subcatchment ALTER COLUMN rted SET DEFAULT 100;