/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"sector_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_node", "column":"sector_id", "dataType":"integer", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_form_list", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_form_tableview", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_form_tableview", "column":"tablename", "newName":"objectname"}}$$);

-- 15/03/2023
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_report", "column":"device", "dataType":"int[]", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_toolbox", "column":"device", "dataType":"int[]", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"epa_type", "dataType":"character varying(16)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"is_operative", "dataType":"boolean", "isUtils":"False"}}$$);

DROP TABLE IF EXISTS selector_plan_psector;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_municipality", "column":"region_id", "dataType":"integer", "isUtils":"True"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_municipality", "column":"province_id", "dataType":"integer", "isUtils":"True"}}$$);

do $$ 
declare
    v_utils boolean; 
begin
     SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';
	 
	 if v_utils is true then

		CREATE TABLE IF NOT EXISTS utils.region (
			region_id int4 NOT NULL,
			name text NOT NULL,
			descript text NULL,
			province_id int4 NULL,
			the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
			active bool NULL DEFAULT true,
			CONSTRAINT region_pkey PRIMARY KEY (region_id));

		CREATE TABLE IF NOT EXISTS utils.province (
			province_id int4 NOT NULL,
			name text NOT NULL,
			descript text NULL,
			the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
			active bool NULL DEFAULT true,
			CONSTRAINT province_pkey PRIMARY KEY (province_id));
			
		CREATE VIEW SCHEMA_NAME.ext_region AS SELECT * FROM utils.region;
		CREATE VIEW SCHEMA_NAME.ext_province AS SELECT * FROM utils.province;
		CREATE OR REPLACE VIEW SCHEMA_NAME.ext_municipality AS SELECT * FROM utils.municipality;
			
     else
     	CREATE TABLE IF NOT EXISTS SCHEMA_NAME.ext_region (
			region_id int4 NOT NULL,
			name text NOT NULL,
			descript text NULL,
			province_id int4 NULL,
			the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
			active bool NULL DEFAULT true,
			CONSTRAINT ext_region_pkey PRIMARY KEY (region_id));

		CREATE TABLE IF NOT EXISTS SCHEMA_NAME.ext_province (
			province_id int4 NOT NULL,
			name text NOT NULL,
			descript text NULL,
			the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
			active bool NULL DEFAULT true,
			CONSTRAINT ext_province_pkey PRIMARY KEY (province_id));
	
	 end if;
end; $$;


-- restoring path
SET search_path = SCHEMA_NAME, public, pg_catalog;



--04/05/2023
--add fields tstamp, insert_user, lastupdate and lastupdate_user to some tables and set default values:
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dimensions", "column":"tstamp", "dataType":"timestamp", "isUtils":"False"}}$$);;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dimensions", "column":"insert_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dimensions", "column":"lastupdate", "dataType":"timestamp", "isUtils":"False"}}$$);;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dimensions", "column":"lastupdate_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"tstamp", "dataType":"timestamp", "isUtils":"False"}}$$);;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"insert_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"lastupdate", "dataType":"timestamp", "isUtils":"False"}}$$);;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"lastupdate_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"exploitation", "column":"tstamp", "dataType":"timestamp", "isUtils":"False"}}$$);;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"exploitation", "column":"insert_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"exploitation", "column":"lastupdate", "dataType":"timestamp", "isUtils":"False"}}$$);;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"exploitation", "column":"lastupdate_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector", "column":"tstamp", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector", "column":"insert_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector", "column":"lastupdate", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector", "column":"lastupdate_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);


ALTER TABLE dimensions ALTER COLUMN tstamp SET DEFAULT now();
ALTER TABLE dimensions ALTER COLUMN insert_user SET DEFAULT current_user;

ALTER TABLE link ALTER COLUMN tstamp SET DEFAULT now();
ALTER TABLE link ALTER COLUMN insert_user SET DEFAULT current_user;

ALTER TABLE exploitation ALTER COLUMN tstamp SET DEFAULT now();
ALTER TABLE exploitation ALTER COLUMN insert_user SET DEFAULT current_user;

ALTER TABLE plan_psector ALTER COLUMN tstamp SET DEFAULT now();
ALTER TABLE plan_psector ALTER COLUMN insert_user SET DEFAULT current_user;
