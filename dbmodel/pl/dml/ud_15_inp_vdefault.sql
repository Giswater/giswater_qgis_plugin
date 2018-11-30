/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- Default values of hydrologics
-- ----------------------------
ALTER TABLE subcatchment ALTER COLUMN hydrology_id SET DEFAULT 1;


-- ----------------------------
-- Default values of subcatchment
-- ----------------------------
ALTER TABLE subcatchment ALTER COLUMN imperv SET DEFAULT 90;
ALTER TABLE subcatchment ALTER COLUMN nimp SET DEFAULT 0.01;
ALTER TABLE subcatchment ALTER COLUMN nperv SET DEFAULT 0.1;
ALTER TABLE subcatchment ALTER COLUMN simp SET DEFAULT 0.05;
ALTER TABLE subcatchment ALTER COLUMN sperv SET DEFAULT 0.05;
ALTER TABLE subcatchment ALTER COLUMN zero SET DEFAULT 25;
ALTER TABLE subcatchment ALTER COLUMN rted SET DEFAULT 100;

