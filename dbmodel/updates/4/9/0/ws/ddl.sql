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

-- 02/04/2026
DROP VIEW IF EXISTS ve_plan_netscenario_dma;
DROP VIEW IF EXISTS ve_plan_netscenario_presszone;

ALTER TABLE plan_netscenario_presszone RENAME COLUMN presszone_name TO "name";
ALTER TABLE plan_netscenario_presszone ALTER COLUMN "name" TYPE varchar(100) USING "name"::varchar(100);
ALTER TABLE plan_netscenario_presszone ADD code varchar(100) NULL;
ALTER TABLE plan_netscenario_presszone ADD descript varchar(255) NULL;

ALTER TABLE plan_netscenario_dma RENAME COLUMN dma_name TO "name";
ALTER TABLE plan_netscenario_dma ALTER COLUMN "name" TYPE varchar(100) USING "name"::varchar(100);
ALTER TABLE plan_netscenario_dma ADD code varchar(100) NULL;
ALTER TABLE plan_netscenario_dma ADD descript varchar(255) NULL;

ALTER TABLE crmzone RENAME COLUMN id TO crmzone_id;
ALTER TABLE crmzone ADD code varchar(100) NULL;
ALTER TABLE crmzone ALTER COLUMN "name" TYPE varchar(100) USING "name"::varchar(100);
ALTER TABLE crmzone ALTER COLUMN "descript" TYPE varchar(255) USING "descript"::varchar(255);
ALTER TABLE crmzone ADD expl_id int4[] NULL;
ALTER TABLE crmzone ADD sector_id int4[] NULL;
ALTER TABLE crmzone ADD muni_id int4[] NULL;

-- 13/04/2026
ALTER TABLE macrodma DISABLE TRIGGER ALL;
ALTER TABLE dqa DISABLE TRIGGER ALL;
ALTER TABLE macrodqa DISABLE TRIGGER ALL;
ALTER TABLE presszone DISABLE TRIGGER ALL;
ALTER TABLE supplyzone DISABLE TRIGGER ALL;
ALTER TABLE crmzone DISABLE TRIGGER ALL;
ALTER TABLE plan_netscenario_dma DISABLE TRIGGER ALL;
ALTER TABLE plan_netscenario_presszone DISABLE TRIGGER ALL;

UPDATE macrodma SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
UPDATE macrodma SET sector_id = ARRAY[0] WHERE sector_id IS NULL;
UPDATE macrodma SET muni_id = ARRAY[0] WHERE muni_id IS NULL;
ALTER TABLE macrodma ALTER COLUMN expl_id SET DEFAULT ARRAY[0];
ALTER TABLE macrodma ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE macrodma ALTER COLUMN sector_id SET DEFAULT ARRAY[0];
ALTER TABLE macrodma ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE macrodma ALTER COLUMN muni_id SET DEFAULT ARRAY[0];
ALTER TABLE macrodma ALTER COLUMN muni_id SET NOT NULL;

UPDATE dqa SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
UPDATE dqa SET sector_id = ARRAY[0] WHERE sector_id IS NULL;
UPDATE dqa SET muni_id = ARRAY[0] WHERE muni_id IS NULL;
ALTER TABLE dqa ALTER COLUMN expl_id SET DEFAULT ARRAY[0];
ALTER TABLE dqa ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE dqa ALTER COLUMN sector_id SET DEFAULT ARRAY[0];
ALTER TABLE dqa ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE dqa ALTER COLUMN muni_id SET DEFAULT ARRAY[0];
ALTER TABLE dqa ALTER COLUMN muni_id SET NOT NULL;

UPDATE macrodqa SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
UPDATE macrodqa SET sector_id = ARRAY[0] WHERE sector_id IS NULL;
UPDATE macrodqa SET muni_id = ARRAY[0] WHERE muni_id IS NULL;
ALTER TABLE macrodqa ALTER COLUMN expl_id SET DEFAULT ARRAY[0];
ALTER TABLE macrodqa ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE macrodqa ALTER COLUMN sector_id SET DEFAULT ARRAY[0];
ALTER TABLE macrodqa ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE macrodqa ALTER COLUMN muni_id SET DEFAULT ARRAY[0];
ALTER TABLE macrodqa ALTER COLUMN muni_id SET NOT NULL;

UPDATE presszone SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
UPDATE presszone SET sector_id = ARRAY[0] WHERE sector_id IS NULL;
UPDATE presszone SET muni_id = ARRAY[0] WHERE muni_id IS NULL;
ALTER TABLE presszone ALTER COLUMN expl_id SET DEFAULT ARRAY[0];
ALTER TABLE presszone ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE presszone ALTER COLUMN sector_id SET DEFAULT ARRAY[0];
ALTER TABLE presszone ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE presszone ALTER COLUMN muni_id SET DEFAULT ARRAY[0];
ALTER TABLE presszone ALTER COLUMN muni_id SET NOT NULL;

UPDATE supplyzone SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
UPDATE supplyzone SET sector_id = ARRAY[0] WHERE sector_id IS NULL;
UPDATE supplyzone SET muni_id = ARRAY[0] WHERE muni_id IS NULL;
ALTER TABLE supplyzone ALTER COLUMN expl_id SET DEFAULT ARRAY[0];
ALTER TABLE supplyzone ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE supplyzone ALTER COLUMN sector_id SET DEFAULT ARRAY[0];
ALTER TABLE supplyzone ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE supplyzone ALTER COLUMN muni_id SET DEFAULT ARRAY[0];
ALTER TABLE supplyzone ALTER COLUMN muni_id SET NOT NULL;

UPDATE crmzone SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
UPDATE crmzone SET sector_id = ARRAY[0] WHERE sector_id IS NULL;
UPDATE crmzone SET muni_id = ARRAY[0] WHERE muni_id IS NULL;
ALTER TABLE crmzone ALTER COLUMN expl_id SET DEFAULT ARRAY[0];
ALTER TABLE crmzone ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE crmzone ALTER COLUMN sector_id SET DEFAULT ARRAY[0];
ALTER TABLE crmzone ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE crmzone ALTER COLUMN muni_id SET DEFAULT ARRAY[0];
ALTER TABLE crmzone ALTER COLUMN muni_id SET NOT NULL;

UPDATE plan_netscenario_dma SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
UPDATE plan_netscenario_dma SET sector_id = ARRAY[0] WHERE sector_id IS NULL;
UPDATE plan_netscenario_dma SET muni_id = ARRAY[0] WHERE muni_id IS NULL;
ALTER TABLE plan_netscenario_dma ALTER COLUMN expl_id SET DEFAULT ARRAY[0];
ALTER TABLE plan_netscenario_dma ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE plan_netscenario_dma ALTER COLUMN sector_id SET DEFAULT ARRAY[0];
ALTER TABLE plan_netscenario_dma ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE plan_netscenario_dma ALTER COLUMN muni_id SET DEFAULT ARRAY[0];
ALTER TABLE plan_netscenario_dma ALTER COLUMN muni_id SET NOT NULL;

UPDATE plan_netscenario_presszone SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
UPDATE plan_netscenario_presszone SET sector_id = ARRAY[0] WHERE sector_id IS NULL;
UPDATE plan_netscenario_presszone SET muni_id = ARRAY[0] WHERE muni_id IS NULL;
ALTER TABLE plan_netscenario_presszone ALTER COLUMN expl_id SET DEFAULT ARRAY[0];
ALTER TABLE plan_netscenario_presszone ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE plan_netscenario_presszone ALTER COLUMN sector_id SET DEFAULT ARRAY[0];
ALTER TABLE plan_netscenario_presszone ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE plan_netscenario_presszone ALTER COLUMN muni_id SET DEFAULT ARRAY[0];
ALTER TABLE plan_netscenario_presszone ALTER COLUMN muni_id SET NOT NULL;

ALTER TABLE macrodma ENABLE TRIGGER ALL;
ALTER TABLE dqa ENABLE TRIGGER ALL;
ALTER TABLE macrodqa ENABLE TRIGGER ALL;
ALTER TABLE presszone ENABLE TRIGGER ALL;
ALTER TABLE supplyzone ENABLE TRIGGER ALL;
ALTER TABLE crmzone ENABLE TRIGGER ALL;
ALTER TABLE plan_netscenario_dma ENABLE TRIGGER ALL;
ALTER TABLE plan_netscenario_presszone ENABLE TRIGGER ALL;

-- 21/04/2026
DROP RULE IF EXISTS presszone_expl ON presszone;
DROP RULE IF EXISTS dqa_expl ON dqa;