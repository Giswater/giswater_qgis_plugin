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
	dscenario_id int4 NOT NULL,
	pattern_id varchar(16) NOT NULL,
	factor_1 numeric(12, 4) NULL,
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
	factor_19 numeric(12, 4) NULL,
	factor_20 numeric(12, 4) NULL,
	factor_21 numeric(12, 4) NULL,
	factor_22 numeric(12, 4) NULL,
	factor_23 numeric(12, 4) NULL,
	factor_24 numeric(12, 4) NULL,
	CONSTRAINT inp_dscenario_pattern_value_pkey PRIMARY KEY (dscenario_id, pattern_id)
);

ALTER TABLE inp_dscenario_pattern_value ADD CONSTRAINT inp_dscenario_pattern_value_dscenario_id_pattern_id_fkey 
FOREIGN KEY (dscenario_id, pattern_id) REFERENCES inp_dscenario_pattern(dscenario_id, pattern_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- 13/04/2026
ALTER TABLE dwfzone DISABLE TRIGGER ALL;
ALTER TABLE drainzone DISABLE TRIGGER ALL;
ALTER TABLE omunit DISABLE TRIGGER ALL;
ALTER TABLE macroomunit DISABLE TRIGGER ALL;

UPDATE dwfzone SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
UPDATE dwfzone SET sector_id = ARRAY[0] WHERE sector_id IS NULL;
UPDATE dwfzone SET muni_id = ARRAY[0] WHERE muni_id IS NULL;
ALTER TABLE dwfzone ALTER COLUMN expl_id SET DEFAULT ARRAY[0];
ALTER TABLE dwfzone ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE dwfzone ALTER COLUMN sector_id SET DEFAULT ARRAY[0];
ALTER TABLE dwfzone ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE dwfzone ALTER COLUMN muni_id SET DEFAULT ARRAY[0];
ALTER TABLE dwfzone ALTER COLUMN muni_id SET NOT NULL;

UPDATE drainzone SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
UPDATE drainzone SET sector_id = ARRAY[0] WHERE sector_id IS NULL;
UPDATE drainzone SET muni_id = ARRAY[0] WHERE muni_id IS NULL;
ALTER TABLE drainzone ALTER COLUMN expl_id SET DEFAULT ARRAY[0];
ALTER TABLE drainzone ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE drainzone ALTER COLUMN sector_id SET DEFAULT ARRAY[0];
ALTER TABLE drainzone ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE drainzone ALTER COLUMN muni_id SET DEFAULT ARRAY[0];
ALTER TABLE drainzone ALTER COLUMN muni_id SET NOT NULL;

UPDATE omunit SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
UPDATE omunit SET sector_id = ARRAY[0] WHERE sector_id IS NULL;
UPDATE omunit SET muni_id = ARRAY[0] WHERE muni_id IS NULL;
ALTER TABLE omunit ALTER COLUMN expl_id SET DEFAULT ARRAY[0];
ALTER TABLE omunit ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE omunit ALTER COLUMN sector_id SET DEFAULT ARRAY[0];
ALTER TABLE omunit ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE omunit ALTER COLUMN muni_id SET DEFAULT ARRAY[0];
ALTER TABLE omunit ALTER COLUMN muni_id SET NOT NULL;

UPDATE macroomunit SET expl_id = ARRAY[0] WHERE expl_id IS NULL;
UPDATE macroomunit SET sector_id = ARRAY[0] WHERE sector_id IS NULL;
UPDATE macroomunit SET muni_id = ARRAY[0] WHERE muni_id IS NULL;
ALTER TABLE macroomunit ALTER COLUMN expl_id SET DEFAULT ARRAY[0];
ALTER TABLE macroomunit ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE macroomunit ALTER COLUMN sector_id SET DEFAULT ARRAY[0];
ALTER TABLE macroomunit ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE macroomunit ALTER COLUMN muni_id SET DEFAULT ARRAY[0];
ALTER TABLE macroomunit ALTER COLUMN muni_id SET NOT NULL;

ALTER TABLE omunit ALTER COLUMN the_geom TYPE public.geometry(multilinestring, SRID_VALUE) USING the_geom::public.geometry(multilinestring, SRID_VALUE);
ALTER TABLE macroomunit ALTER COLUMN the_geom TYPE public.geometry(multilinestring, SRID_VALUE) USING the_geom::public.geometry(multilinestring, SRID_VALUE);

ALTER TABLE dwfzone ENABLE TRIGGER ALL;
ALTER TABLE drainzone ENABLE TRIGGER ALL;
ALTER TABLE omunit ENABLE TRIGGER ALL;
ALTER TABLE macroomunit ENABLE TRIGGER ALL;

-- 21/04/2026
DROP RULE IF EXISTS omzone_expl ON omzone;
DROP RULE IF EXISTS dwfzone_expl ON dwfzone;
