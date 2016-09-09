/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Base map
-- ----------------------------

-- Streeter

CREATE TABLE "ext_type_street" (
"id" varchar(20)   NOT NULL,
"observ" varchar(50)  ,
CONSTRAINT ext_type_street_pkey PRIMARY KEY (id)
);


CREATE TABLE "ext_streetaxis" (
"id" varchar (16) NOT NULL,
"type" varchar(18),
"name" varchar(100),
"text" text,
"the_geom" public.geometry (LINESTRING, SRID_VALUE),
CONSTRAINT ext_streetaxis_pkey PRIMARY KEY (id)
);


-- Postnumber layer is not needed because connec acts as postnumber


-- Urban_structure



CREATE TABLE "ext_urban_propierties" (
"id" varchar (16) NOT NULL,
"code" varchar(30),
"streetaxis" varchar(16),
"postnumber" varchar(16),
"complement" varchar(16),
"placement" varchar(16),
"square" varchar(16),
"observ" text,
"text" text,
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE),
CONSTRAINT ext_urban_propierties_pkey PRIMARY KEY (id)
);



