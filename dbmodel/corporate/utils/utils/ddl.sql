/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SET ROLE role_admin;

CREATE SCHEMA utils AUTHORIZATION role_admin;

GRANT ALL ON SCHEMA utils TO role_admin;
GRANT ALL ON SCHEMA utils TO role_basic;
ALTER DEFAULT PRIVILEGES IN SCHEMA utils GRANT SELECT ON TABLES TO role_basic;

CREATE TABLE utils.config_param_system (
	"parameter" varchar(50) NOT NULL,
	value text NULL,
	descript text NULL,
	CONSTRAINT config_param_system_pkey PRIMARY KEY (parameter)
);

CREATE TABLE utils.sys_table (
    LIKE sys_table INCLUDING ALL
);

CREATE TABLE utils.municipality (
    LIKE ext_municipality INCLUDING ALL
);

CREATE TABLE utils.streetaxis (
    LIKE ext_streetaxis INCLUDING ALL
);

CREATE TABLE utils.address (
    LIKE ext_address INCLUDING ALL
);

CREATE TABLE utils.plot (
    LIKE ext_plot INCLUDING ALL
);

CREATE TABLE utils.raster_dem (
    id serial NOT NULL,
	rast public.raster NULL,
	rastercat_id text NULL,
	envelope public.geometry(polygon, 25831) NULL,
	CONSTRAINT raster_dem_pkey PRIMARY KEY (id)
);

CREATE TABLE utils.cat_raster (
    LIKE ext_cat_raster INCLUDING ALL
);

CREATE TABLE utils.district (
    LIKE ext_district INCLUDING ALL
);

CREATE TABLE utils.region_x_province (
    LIKE ext_region_x_province INCLUDING ALL
);

CREATE TABLE utils.province (
    LIKE ext_province INCLUDING ALL
);

CREATE TABLE utils.region (
    LIKE ext_region INCLUDING ALL
);

CREATE TABLE utils.type_street (
    LIKE ext_type_street INCLUDING ALL
);