/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Structure for picture
-- ----------------------------

CREATE SEQUENCE "sample_ud".picture_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE TABLE "sample_ud"."picture" (
"id" int8 DEFAULT nextval('"sample_ud".picture_seq'::regclass) NOT NULL,
"table_name" varchar(30) COLLATE "default",
"pk_name" varchar(30) COLLATE "default",
"pk_value" varchar(30) COLLATE "default",
"comment" varchar(512) COLLATE "default",
"event_id" varchar(16) COLLATE "default",
"tagcat_id" varchar(16) COLLATE "default",
"path" varchar(512) COLLATE "default",
"date" timestamp(6) DEFAULT now(),
"user" varchar(16) COLLATE "default",
"the_geom" public.geometry (POINT, 25831),
CONSTRAINT picture_pkey PRIMARY KEY (id)
);


ALTER TABLE "sample_ud"."picture" ADD FOREIGN KEY ("event_id") REFERENCES "sample_ud"."event" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."picture" ADD FOREIGN KEY ("tagcat_id") REFERENCES "sample_ud"."cat_tag" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

/*
CREATE trigger to control changes on the name of node_id, arc_id, connec_id, element_id...
*/
