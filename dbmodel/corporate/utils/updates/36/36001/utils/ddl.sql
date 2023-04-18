/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "utils", public, pg_catalog;


CREATE TABLE region (
	region_id int4 NOT NULL,
	name text NOT NULL,
	descript text NULL,
	province_id int4 NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	active bool NULL DEFAULT true,
	CONSTRAINT ext_region_pkey PRIMARY KEY (region_id));

CREATE TABLE province (
	province_id int4 NOT NULL,
	name text NOT NULL,
	descript text NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	active bool NULL DEFAULT true,
	CONSTRAINT ext_province_pkey PRIMARY KEY (province_id));
    
ALTER TABLE municipality ADD COLUMN region_id integer;
ALTER TABLE municipality ADD COLUMN province_id integer;

