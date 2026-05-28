/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET ROLE role_system;

CREATE SCHEMA utils AUTHORIZATION role_system;

SET search_path = utils, public;

GRANT ALL ON SCHEMA utils TO role_admin;
GRANT ALL ON SCHEMA utils TO role_basic;
ALTER DEFAULT PRIVILEGES IN SCHEMA utils GRANT SELECT ON TABLES TO role_basic;

CREATE TABLE config_param_system (
	"parameter" varchar(50) NOT NULL,
	value text NULL,
	descript text NULL,
	CONSTRAINT config_param_system_pkey PRIMARY KEY (parameter)
);

CREATE TABLE sys_table (
	id text NOT NULL,
	descript text NULL,
	sys_role varchar(30) NULL,
	project_template jsonb NULL,
	context varchar(500) NULL,
	orderby int2 NULL,
	alias text NULL,
	notify_action json NULL,
	isaudit bool NULL,
	keepauditdays int4 NULL,
	"source" text NULL,
	addparam json NULL,
	provider_config jsonb NULL,
	CONSTRAINT sys_table_pkey PRIMARY KEY (id)
);

CREATE TABLE type_street (
	id varchar(20) NOT NULL,
	observ varchar(50) NULL,
	CONSTRAINT type_street_pkey PRIMARY KEY (id)
);

CREATE TABLE region (
	region_id int4 NOT NULL,
	"name" text NOT NULL,
	descript text NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	active bool DEFAULT true NULL,
	code varchar(100) NULL,
	CONSTRAINT region_pkey PRIMARY KEY (region_id)
);

CREATE TABLE province (
	province_id int4 NOT NULL,
	"name" text NOT NULL,
	descript text NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	active bool DEFAULT true NULL,
	code varchar(100) NULL,
	CONSTRAINT province_pkey PRIMARY KEY (province_id)
);

CREATE TABLE region_x_province (
	region_id int4 NOT NULL,
	province_id int4 NOT NULL,
	CONSTRAINT region_x_province_pkey PRIMARY KEY (region_id, province_id)
    CONSTRAINT region_x_province_region_id_fkey FOREIGN KEY (region_id) REFERENCES region(region_id) ON DELETE RESTRICT ON UPDATE CASCADE
    CONSTRAINT region_x_province_province_id_fkey FOREIGN KEY (province_id) REFERENCES province(province_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE municipality (
	muni_id int4 NOT NULL,
	"name" text NOT NULL,
	observ text NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	active bool DEFAULT true NULL,
	region_id int4 NULL,
	province_id int4 NULL,
	code varchar(100) NULL,
	CONSTRAINT municipality_pkey PRIMARY KEY (muni_id),
    CONSTRAINT municipality_region_id_fkey FOREIGN KEY (region_id) REFERENCES region(region_id) ON DELETE RESTRICT ON UPDATE CASCADE
    CONSTRAINT municipality_province_id_fkey FOREIGN KEY (province_id) REFERENCES province(province_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX idx_municipality_name ON municipality USING btree (name);
CREATE INDEX idx_municipality_the_geom ON municipality USING gist (the_geom);

CREATE TABLE district (
	district_id int4 NOT NULL,
	"name" text NULL,
	muni_id int4 NOT NULL,
	observ text NULL,
	active bool NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	code varchar(100) NULL,
	CONSTRAINT district_pkey PRIMARY KEY (district_id),
    CONSTRAINT district_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE streetaxis (
	id varchar(16) DEFAULT nextval('streetaxis_id_seq'::regclass) NOT NULL,
	code varchar(100) NULL,
	"type" varchar(18) NULL,
	"name" varchar(100) NOT NULL,
	"text" text NULL,
	the_geom public.geometry(multilinestring, SRID_VALUE) NULL,
	muni_id int4 NOT NULL,
	"source" text NULL,
	CONSTRAINT streetaxis_pkey PRIMARY KEY (id),
	CONSTRAINT streetaxis_unique UNIQUE (muni_id, id),
    CONSTRAINT streetaxis_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE
    CONSTRAINT streetaxis_type_street_fkey FOREIGN KEY (type) REFERENCES type_street(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX idx_streetaxis_code ON streetaxis USING btree (code);
CREATE INDEX idx_streetaxis_muni_id ON streetaxis USING btree (muni_id);
CREATE INDEX idx_streetaxis_name ON streetaxis USING btree (name);
CREATE INDEX idx_streetaxis_the_geom ON streetaxis USING gist (the_geom);

CREATE TABLE plot (
	id varchar(16) DEFAULT nextval('plot_id_seq'::regclass) NOT NULL,
	code varchar(100) NULL,
	muni_id int4 NOT NULL,
	postcode varchar(16) NULL,
	streetaxis_id varchar(16) NOT NULL,
	postnumber varchar(16) NULL,
	complement varchar(16) NULL,
	placement varchar(16) NULL,
	square varchar(16) NULL,
	observ text NULL,
	"text" text NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	CONSTRAINT plot_pkey PRIMARY KEY (id),
    CONSTRAINT plot_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE
    CONSTRAINT plot_streetaxis_id_fkey FOREIGN KEY (streetaxis_id) REFERENCES streetaxis(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX idx_plot_muni_id ON plot USING btree (muni_id);
CREATE INDEX idx_plot_plot_code ON plot USING btree (code);
CREATE INDEX idx_plot_postcode ON plot USING btree (postcode);
CREATE INDEX idx_plot_streetaxis_id ON plot USING btree (streetaxis_id);
CREATE INDEX idx_plot_the_geom ON plot USING gist (the_geom);

CREATE TABLE address (
	id varchar(16) DEFAULT nextval('address_id_seq'::regclass) NOT NULL,
	muni_id int4 NOT NULL,
	postcode varchar(16) NULL,
	streetaxis_id varchar(16) NOT NULL,
	postnumber varchar(16) NOT NULL,
	plot_id varchar(16) NULL,
	the_geom public.geometry(point, SRID_VALUE) NULL,
	postcomplement text NULL,
	code varchar(100) NULL,
	"source" text NULL,
	CONSTRAINT address_pkey PRIMARY KEY (id),
    CONSTRAINT address_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE
    CONSTRAINT address_streetaxis_id_fkey FOREIGN KEY (streetaxis_id) REFERENCES streetaxis(id) ON DELETE RESTRICT ON UPDATE CASCADE
    CONSTRAINT address_plot_id_fkey FOREIGN KEY (plot_id) REFERENCES plot(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX idx_address_plot_id ON address USING btree (plot_id);
CREATE INDEX idx_address_postcode ON address USING btree (postcode);
CREATE INDEX idx_address_streetaxis_id ON address USING btree (streetaxis_id);
CREATE INDEX idx_address_the_geom ON address USING gist (the_geom);


CREATE TABLE cat_raster (
	id text NOT NULL,
	code text NULL,
	alias varchar(50) NULL,
	raster_type varchar(30) NULL,
	descript text NULL,
	"source" text NULL,
	provider varchar(30) NULL,
	"year" varchar(4) NULL,
	tstamp timestamp DEFAULT now() NULL,
	insert_user varchar(50) DEFAULT '"current_user"()' NULL,
	CONSTRAINT cat_raster_pkey PRIMARY KEY (id)
);

CREATE TABLE raster_dem (
	id int4 DEFAULT nextval('raster_dem_id_seq'::regclass) NOT NULL,
	rast public.raster NULL,
	rastercat_id text NULL,
	envelope public.geometry(polygon, SRID_VALUE) NULL,
	CONSTRAINT raster_dem_pkey PRIMARY KEY (id),
    CONSTRAINT raster_dem_rastercat_id_fkey FOREIGN KEY (rastercat_id) REFERENCES cat_raster(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('municipality', 'Table of town cities and villages', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('streetaxis', 'Table of streetaxis', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('address', 'Table of entrance numbers', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('plot', 'Table of urban properties', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('raster_dem', 'Table to store raster DEM', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('cat_raster', 'Catalog for raster layers', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('district', 'Table of districts', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('region_x_province', 'Table with the relations between regions and provinces', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('province', 'Table of provinces', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('region', 'Table of regions', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('type_street', 'Table with the values of different streetaxis types', 'role_edit', 'core');

CREATE TRIGGER gw_trg_manage_raster_dem_delete AFTER DELETE ON raster_dem 
FOR EACH ROW EXECUTE FUNCTION gw_trg_manage_raster_dem();

CREATE TRIGGER gw_trg_manage_raster_dem_insert BEFORE INSERT ON raster_dem
FOR EACH ROW EXECUTE FUNCTION gw_trg_manage_raster_dem();
