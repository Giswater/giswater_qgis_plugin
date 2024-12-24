/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 29/05/2024
ALTER TABLE cat_manager RENAME COLUMN username TO rolename;
ALTER TABLE config_user_x_expl DROP CONSTRAINT config_user_x_expl_username_fkey;
ALTER TABLE config_user_x_sector DROP CONSTRAINT config_user_x_sector_username_fkey;

ALTER TABLE config_user_x_sector DROP CONSTRAINT config_user_x_sector_manager_id_fkey;
ALTER TABLE config_user_x_sector ADD CONSTRAINT config_user_x_sector_manager_id_fkey
FOREIGN KEY (manager_id) REFERENCES cat_manager(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE config_user_x_expl DROP CONSTRAINT config_user_x_expl_manager_id_fkey;
ALTER TABLE config_user_x_expl ADD CONSTRAINT config_user_x_expl_manager_id_fkey
FOREIGN KEY (manager_id) REFERENCES cat_manager(id) ON DELETE CASCADE ON UPDATE CASCADE;


DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN

		CREATE TABLE selector_municipality (
			muni_id integer NOT NULL,
			cur_user text NOT NULL DEFAULT CURRENT_USER,
			CONSTRAINT selector_municipality_pkey PRIMARY KEY (muni_id, cur_user),
			CONSTRAINT selector_municipality_fkey FOREIGN KEY (muni_id)
			REFERENCES utils.municipality (muni_id) MATCH SIMPLE
			ON UPDATE CASCADE ON DELETE CASCADE
		);

	ELSE

		CREATE TABLE selector_municipality
		(
			muni_id integer NOT NULL,
			cur_user text NOT NULL DEFAULT CURRENT_USER,
			CONSTRAINT selector_municipality_pkey PRIMARY KEY (muni_id, cur_user),
			CONSTRAINT selector_municipality_fkey FOREIGN KEY (muni_id)
			REFERENCES ext_municipality (muni_id) MATCH SIMPLE
			ON UPDATE CASCADE ON DELETE CASCADE
		);

	END IF;
END; $$;

-- 21/06/2024
ALTER TABLE plan_psector ALTER COLUMN status SET NOT NULL;
ALTER TABLE plan_psector ALTER COLUMN status SET DEFAULT 2;
ALTER TABLE plan_psector ALTER COLUMN psector_type SET DEFAULT 1;

ALTER TABLE cat_feature RENAME COLUMN config TO addparam;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"ext_municipality", "column":"ext_code", "dataType":"varchar(50)", "isUtils":"True"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"ext_region", "column":"ext_code", "dataType":"varchar(50)", "isUtils":"True"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"ext_province", "column":"ext_code", "dataType":"varchar(50)", "isUtils":"True"}}$$);

DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN

		-- create table utils.region_x_province
	 	CREATE TABLE IF NOT EXISTS utils.region_x_province (
			region_id int4 NOT NULL,
			province_id int4 NOT NULL,
			CONSTRAINT region_x_province_pkey PRIMARY KEY (region_id, province_id));

		-- insert values on table
		INSERT INTO utils.region_x_province SELECT region_id, province_id
		FROM utils.municipality WHERE region_id IS NOT NULL AND province_id IS NOT NULL
		ON CONFLICT (region_id, province_id) DO NOTHING;

		-- drop province_id from ext_region
		DROP VIEW IF EXISTS ud.ext_region;
		DROP VIEW IF EXISTS ws.ext_region;
		DROP VIEW IF EXISTS SCHEMA_NAME.ext_region;

		CREATE TABLE IF NOT EXISTS utils._region_ AS SELECT * FROM utils.region;
		ALTER TABLE utils.region DROP COLUMN IF EXISTS province_id;

		-- refresh views
		CREATE OR REPLACE VIEW ud.ext_region AS SELECT * FROM utils.region;
		CREATE OR REPLACE VIEW ws.ext_region AS SELECT * FROM utils.region;
		CREATE OR REPLACE VIEW SCHEMA_NAME.ext_region AS SELECT * FROM utils.region;
		CREATE OR REPLACE VIEW ud.ext_province AS SELECT * FROM utils.province;
		CREATE OR REPLACE VIEW ws.ext_province AS SELECT * FROM utils.province;
		CREATE OR REPLACE VIEW SCHEMA_NAME.ext_province AS SELECT * FROM utils.province;

		-- create fk
		ALTER TABLE utils.municipality DROP CONSTRAINT IF EXISTS municipality_province_region_fk;
		ALTER TABLE utils.municipality ADD CONSTRAINT municipality_province_region_fk FOREIGN KEY (province_id, region_id)
        REFERENCES utils.region_x_province (province_id, region_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
        
		-- add region and province to ext_municipality view
		CREATE OR REPLACE VIEW SCHEMA_NAME.ext_municipality
		AS SELECT municipality.muni_id,
			municipality.name,
			municipality.observ,
			municipality.the_geom,
			municipality.active,
			municipality.region_id,
			municipality.province_id
		   FROM utils.municipality;

    ELSE

	 	-- create table region_x_province
     	CREATE TABLE IF NOT EXISTS SCHEMA_NAME.ext_region_x_province (
			region_id int4 NOT NULL,
			province_id int4 NOT NULL,
			CONSTRAINT ext_region_x_province_pkey PRIMARY KEY (region_id, province_id));

		-- insert values on table
		INSERT INTO ext_region_x_province SELECT region_id, province_id
		FROM ext_municipality where region_id IS NOT NULL AND province_id IS NOT NULL
		ON CONFLICT (region_id, province_id) DO NOTHING;

		-- drop province_id from ext_region
		CREATE TABLE IF NOT EXISTS SCHEMA_NAME._ext_region_ AS SELECT * FROM SCHEMA_NAME.ext_region;
		ALTER TABLE SCHEMA_NAME.ext_region DROP COLUMN province_id;

		-- create fk
		ALTER TABLE SCHEMA_NAME.ext_municipality ADD CONSTRAINT ext_municipality_province_region_fk FOREIGN KEY (province_id, region_id)
        REFERENCES SCHEMA_NAME.ext_region_x_province (province_id, region_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

	 END IF;
END; $$;
