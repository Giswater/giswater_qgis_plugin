/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/




-- ----------------------------
-- Default values of patterns
-- ----------------------------

ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_1 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_2 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_3 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_4 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_5 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_6 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_7 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_8 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_9 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_10 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_11 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_12 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_13 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_14 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_15 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_16 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_17 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_18 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_19 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_20 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_21 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_22 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_23 SET DEFAULT 1;
ALTER TABLE "SCHEMA_NAME".inp_pattern ALTER COLUMN factor_24 SET DEFAULT 1;



-- ----------------------------
-- Records of inp_options
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_options" VALUES ('LPS', 'H-W', '', '1', '1', '40', '0.001', 'CONTINUE', '2', '10', '0', '', '1', '0.5', 'NONE', '1', '0.01', '', '40');
 

-- ----------------------------
-- Records of inp_report
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_report" VALUES ('0', '', 'YES', 'YES', 'YES', 'ALL', 'ALL', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES');
 

-- ----------------------------
-- Records of inp_times
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_times" VALUES ('24', '1:00', '0:06', '0:06', '1:00', '0:00', '1:00', '0:00', '12 am', 'NONE');


-- ----------------------------
-- Default values of state selection
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."inp_selector_state" VALUES ('ON_SERVICE');


