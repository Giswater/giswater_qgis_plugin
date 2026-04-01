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
ALTER TABLE inp_dscenario_demand RENAME TO _inp_dscenario_demand_;
ALTER TABLE _inp_dscenario_demand_ DROP CONSTRAINT inp_dscenario_demand_pkey;
ALTER TABLE _inp_dscenario_demand_ DROP CONSTRAINT inp_demand_dscenario_id_fkey;
ALTER TABLE _inp_dscenario_demand_ DROP CONSTRAINT inp_dscenario_demand_feature_type_fkey;
ALTER TABLE _inp_dscenario_demand_ DROP CONSTRAINT inp_dscenario_demand_pattern_id_fkey;

DROP INDEX IF EXISTS idx_inp_dscenario_demand_dscenario_id;
DROP INDEX IF EXISTS idx_inp_dscenario_demand_source;

ALTER TABLE _inp_dscenario_demand_ ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS SCHEMA_NAME.inp_dscenario_demand_id_seq1;
ALTER SEQUENCE SCHEMA_NAME.inp_dscenario_demand_id_seq RENAME TO inp_dscenario_demand_id_seq1;

CREATE TABLE inp_dscenario_demand (
	id serial4 NOT NULL PRIMARY KEY,
	dscenario_id int4 NOT NULL,
	feature_id int4 NOT NULL,
	feature_type varchar(16) NULL,
	demand numeric(12, 6) NULL,
	pattern_id varchar(16) NULL,
	demand_type varchar(18) NULL,
	"source" text NULL,
	CONSTRAINT inp_demand_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT inp_demand_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT inp_dscenario_demand_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT inp_dscenario_demand_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX idx_inp_dscenario_demand_dscenario_id ON inp_dscenario_demand USING btree (dscenario_id);
CREATE INDEX idx_inp_dscenario_demand_source ON inp_dscenario_demand USING btree (source);

SELECT setval('SCHEMA_NAME.inp_dscenario_demand_id_seq', (SELECT last_value FROM inp_dscenario_demand_id_seq1));

-- 01/04/2026
DROP INDEX IF EXISTS arc_dma;
DROP INDEX IF EXISTS connec_dma;
DROP INDEX IF EXISTS node_dma;
DROP INDEX IF EXISTS anl_node_fid;
DROP INDEX IF EXISTS anl_node_fprocesscat_id_index;
CREATE INDEX IF NOT EXISTS anl_node_fid_idx ON anl_node USING btree (fid);
DROP INDEX IF EXISTS archived_psector_link_exit_id;
DROP INDEX IF EXISTS link_exit_id;
CREATE INDEX IF NOT EXISTS link_exit_id_idx ON link USING btree (exit_id);
DROP INDEX IF EXISTS idx_plan_psector_expl_id;
DROP INDEX IF EXISTS plan_psector_expl_id;
CREATE INDEX IF NOT EXISTS plan_psector_expl_id_idx ON plan_psector USING btree (expl_id);
ALTER TABLE selector_rpt_main_tstep DROP CONSTRAINT IF EXISTS time_cur_user_unique;
