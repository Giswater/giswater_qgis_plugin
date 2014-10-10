/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- Only numeric default values are allowed


-- ----------------------------
-- Default values of node
-- ----------------------------

ALTER TABLE "SCHEMA_NAME".node
ALTER COLUMN top_elev SET DEFAULT 0.00;

ALTER TABLE "SCHEMA_NAME".node
ALTER COLUMN ymax SET DEFAULT 0.00;


ALTER TABLE "SCHEMA_NAME".arc
ALTER COLUMN z1 SET DEFAULT 0.00;

ALTER TABLE "SCHEMA_NAME"."arc"
ALTER COLUMN z2 SET DEFAULT 0.00;


-- ----------------------------
-- Default values of subcatchment
-- ----------------------------

ALTER TABLE "SCHEMA_NAME".subcatchment
ALTER COLUMN imperv SET DEFAULT 90;

ALTER TABLE "SCHEMA_NAME".subcatchment
ALTER COLUMN nimp SET DEFAULT 0.01;

ALTER TABLE "SCHEMA_NAME".subcatchment
ALTER COLUMN nperv SET DEFAULT 0.1;

ALTER TABLE "SCHEMA_NAME".subcatchment
ALTER COLUMN simp SET DEFAULT 0.05;

ALTER TABLE "SCHEMA_NAME".subcatchment
ALTER COLUMN sperv SET DEFAULT 0.05;

ALTER TABLE "SCHEMA_NAME".subcatchment
ALTER COLUMN zero SET DEFAULT 25;

ALTER TABLE "SCHEMA_NAME".subcatchment
ALTER COLUMN rted SET DEFAULT 100;