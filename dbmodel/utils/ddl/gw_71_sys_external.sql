/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Base map
-- ----------------------------

-- Streeter

CREATE TABLE "ext_type_street" (
"id" varchar(20) PRIMARY KEY NOT NULL,
"observ" varchar(50)
);


CREATE TABLE "ext_streetaxis" (
"id" varchar (16) PRIMARY KEY NOT NULL,
"type" varchar(18),
"name" varchar(100),
"text" text,
"the_geom" public.geometry (LINESTRING, SRID_VALUE),
"expl_id" integer
);


-- Postnumber
CREATE TABLE "ext_address"(
id character varying(16) PRIMARY KEY NOT NULL,
postcode character varying(16),
streetaxis character varying(16),
"number" character varying(16),
urban_properties_id character varying(16),
the_geom geometry(Point,SRID_VALUE),
expl_id integer
  );


-- Urban_structure
CREATE TABLE "ext_plot"(
"id" integer PRIMARY KEY NOT NULL,
"plot_code" varchar(30),
"streetaxis" varchar(16),
"postcode" varchar(16),
"complement" varchar(16),
"placement" varchar(16),
"square" varchar(16),
"observ" text,
"text" text,
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE),
"expl_id" integer
);

