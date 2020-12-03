/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Default values of patterns
-- ----------------------------

ALTER TABLE inp_pattern_value ALTER COLUMN factor_1 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_2 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_3 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_4 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_5 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_6 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_7 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_8 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_9 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_10 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_11 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_12 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_13 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_14 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_15 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_16 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_17 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_18 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_19 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_20 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_21 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_22 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_23 SET DEFAULT 1;
ALTER TABLE inp_pattern_value ALTER COLUMN factor_24 SET DEFAULT 1;


ALTER TABLE inp_cat_mat_roughness ALTER COLUMN period_id SET DEFAULT 'Default';
ALTER TABLE inp_cat_mat_roughness ALTER COLUMN init_age SET DEFAULT 0;
ALTER TABLE inp_cat_mat_roughness ALTER COLUMN end_age SET DEFAULT 999;








