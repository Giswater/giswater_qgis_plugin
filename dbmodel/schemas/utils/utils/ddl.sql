/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

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
    LIKE "AUX_SCHEMA_NAME".sys_table INCLUDING ALL
);

CREATE TABLE utils.municipality (
    LIKE "AUX_SCHEMA_NAME".ext_municipality INCLUDING ALL
);

CREATE TABLE utils.streetaxis (
    LIKE "AUX_SCHEMA_NAME".ext_streetaxis INCLUDING ALL
);

CREATE TABLE utils.address (
    LIKE "AUX_SCHEMA_NAME".ext_address INCLUDING ALL
);

CREATE TABLE utils.plot (
    LIKE "AUX_SCHEMA_NAME".ext_plot INCLUDING ALL
);

CREATE TABLE utils.raster_dem (
    id serial NOT NULL,
	rast public.raster NULL,
	rastercat_id text NULL,
	envelope public.geometry(polygon, SRID_VALUE) NULL,
	CONSTRAINT raster_dem_pkey PRIMARY KEY (id)
);

CREATE TABLE utils.cat_raster (
    LIKE "AUX_SCHEMA_NAME".ext_cat_raster INCLUDING ALL
);

CREATE TABLE utils.district (
    LIKE "AUX_SCHEMA_NAME".ext_district INCLUDING ALL
);

CREATE TABLE utils.region_x_province (
    LIKE "AUX_SCHEMA_NAME".ext_region_x_province INCLUDING ALL
);

CREATE TABLE utils.province (
    LIKE "AUX_SCHEMA_NAME".ext_province INCLUDING ALL
);

CREATE TABLE utils.region (
    LIKE "AUX_SCHEMA_NAME".ext_region INCLUDING ALL
);

CREATE TABLE utils.type_street (
    LIKE "AUX_SCHEMA_NAME".ext_type_street INCLUDING ALL
);


CREATE SEQUENCE plot_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
	
CREATE SEQUENCE address_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
	
CREATE SEQUENCE streetaxis_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

ALTER TABLE plot ALTER COLUMN id SET DEFAULT nextval('plot_id_seq');
ALTER TABLE streetaxis ALTER COLUMN id SET DEFAULT nextval('streetaxis_id_seq');
ALTER TABLE address ALTER COLUMN id SET DEFAULT nextval('address_id_seq');