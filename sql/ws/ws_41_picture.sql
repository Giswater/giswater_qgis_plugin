/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Structure for picture
-- ----------------------------

CREATE SEQUENCE "SCHEMA_NAME".picture_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE TABLE "SCHEMA_NAME"."picture" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".picture_seq'::regclass) NOT NULL,
"table_name" varchar(30)  ,
"pk_name" varchar(30)  ,
"pk_value" varchar(30)  ,
"comment" varchar(512)  ,
"event_id" varchar(16)  ,
"tagcat_id" varchar(16)  ,
"path" varchar(512)  ,
"date" timestamp(6) DEFAULT now(),
"user" varchar(16)  ,
"the_geom" public.geometry (POINT, SRID_VALUE),
CONSTRAINT picture_pkey PRIMARY KEY (id)
);


CREATE INDEX picture_index ON "SCHEMA_NAME"."picture" USING gist ("the_geom");

