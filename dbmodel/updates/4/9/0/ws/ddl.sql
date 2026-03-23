/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 19/03/2026
CREATE TABLE IF NOT EXISTS inp_dscenario_pattern (
	dscenario_id int4 NOT NULL,
	pattern_id varchar(16) NOT NULL,
	pattern_type varchar(30) NULL,
	observ text NULL,
	tscode text NULL,
	tsparameters json NULL,
	expl_id int4 NULL,
	log text NULL,
	active bool DEFAULT true NULL,
	CONSTRAINT inp_dscenario_pattern_pkey PRIMARY KEY (dscenario_id, pattern_id)
);

ALTER TABLE inp_dscenario_pattern ADD CONSTRAINT inp_dscenario_pattern_pattern_id_fkey 
FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) 
ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE IF NOT EXISTS inp_dscenario_pattern_value (
	id serial4 NOT NULL,
	dscenario_id int4 NOT NULL,
	pattern_id varchar(16) NOT NULL,
	factor_1 numeric(12, 4) DEFAULT 1 NULL,
	factor_2 numeric(12, 4) NULL,
	factor_3 numeric(12, 4) NULL,
	factor_4 numeric(12, 4) NULL,
	factor_5 numeric(12, 4) NULL,
	factor_6 numeric(12, 4) NULL,
	factor_7 numeric(12, 4) NULL,
	factor_8 numeric(12, 4) NULL,
	factor_9 numeric(12, 4) NULL,
	factor_10 numeric(12, 4) NULL,
	factor_11 numeric(12, 4) NULL,
	factor_12 numeric(12, 4) NULL,
	factor_13 numeric(12, 4) NULL,
	factor_14 numeric(12, 4) NULL,
	factor_15 numeric(12, 4) NULL,
	factor_16 numeric(12, 4) NULL,
	factor_17 numeric(12, 4) NULL,
	factor_18 numeric(12, 4) NULL,
	CONSTRAINT inp_dscenario_pattern_value_pkey PRIMARY KEY (id)
);

ALTER TABLE inp_dscenario_pattern_value ADD CONSTRAINT inp_dscenario_pattern_value_dscenario_id_pattern_id_fkey 
FOREIGN KEY (dscenario_id, pattern_id) REFERENCES inp_dscenario_pattern(dscenario_id, pattern_id) 
ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_pattern_value ADD CONSTRAINT inp_dscenario_pattern_value_unique UNIQUE (id,dscenario_id);


DROP VIEW IF EXISTS ve_inp_dscenario_demand;
ALTER TABLE inp_dscenario_demand DROP CONSTRAINT inp_dscenario_demand_pkey;
ALTER TABLE inp_dscenario_demand DROP COLUMN id;
ALTER TABLE inp_dscenario_demand ADD CONSTRAINT inp_dscenario_demand_pkey PRIMARY KEY (dscenario_id, feature_id);
