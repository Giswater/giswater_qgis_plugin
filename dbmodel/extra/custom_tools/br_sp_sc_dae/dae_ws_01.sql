/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- This file customize the customer request. 



CREATE TABLE "SCHEMA_NAME"."ppoint" (
"ppoint_id" varchar(30)   NOT NULL,
"presszonecat_id" varchar(30),
"number" int4,
"observ" character varying(512),
"text" text,
"the_geom" public.geometry (MULTIPOLYGON, SRID_VALUE),
CONSTRAINT prdistrict_pkey PRIMARY KEY (ppoint_id)
);


ALTER TABLE "SCHEMA_NAME"."ppoint" ADD FOREIGN KEY ("presszonecat_id") REFERENCES "SCHEMA_NAME"."cat_press_zone" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;