/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Base map
-- ----------------------------


-- Municipality
CREATE TABLE "ext_municipality" (
muni_id integer PRIMARY KEY,
name text,
observ text,
the_geom geometry(MULTIPOLYGON, SRID_VALUE)
);



-- Streeter
CREATE TABLE "ext_type_street" (
"id" varchar(20) PRIMARY KEY NOT NULL,
"observ" varchar(50)
);



CREATE TABLE "ext_streetaxis" (
"id" varchar (16) PRIMARY KEY NOT NULL,
"code" varchar (16),
"type" varchar(18),
"name" varchar(100),
"text" text,
"the_geom" public.geometry (MULTILINESTRING, SRID_VALUE),
"expl_id" integer,
"muni_id" integer
);



-- Postnumber
CREATE TABLE "ext_address"(
id character varying(16) PRIMARY KEY NOT NULL,
muni_id integer,
postcode character varying(16),
streetaxis_id character varying(16),
postnumber character varying(16),
plot_id character varying(16),
the_geom geometry(Point,SRID_VALUE),
expl_id integer
  );

  

-- Urban_structure
CREATE TABLE "ext_plot"(
"id" character varying(16) PRIMARY KEY NOT NULL,
"plot_code" varchar(30),
"muni_id" integer,
"postcode"  varchar(16),
"streetaxis_id" varchar(16),
"postnumber" varchar(16),
"complement" varchar(16),
"placement" varchar(16),
"square" varchar(16),
"observ" text,
"text" text,
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE),
"expl_id" integer

);

