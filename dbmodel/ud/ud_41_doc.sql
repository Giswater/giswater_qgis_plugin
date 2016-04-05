/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Structure for event
-- ----------------------------

CREATE SEQUENCE "sample_ud".doc_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "sample_ud".doc_x_node_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "sample_ud".doc_x_arc_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "sample_ud".doc_x_connec_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "sample_ud".doc_x_gully_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE TABLE "sample_ud"."doc_type" (
"id" varchar(30) COLLATE "default" NOT NULL,
"comment" varchar(512) COLLATE "default",
CONSTRAINT doc_type_pkey PRIMARY KEY (id)
);
  
  
CREATE TABLE "sample_ud"."cat_doc" (
"id" varchar(30) COLLATE "default" NOT NULL,
"type" varchar(30) COLLATE "default",
"descript" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default",
CONSTRAINT cat_doc_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."cat_tag" (
"id" varchar(16) COLLATE "default" NOT NULL,
"comment" varchar(512) COLLATE "default",
CONSTRAINT cat_tag_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."doc" (
"id" int8 DEFAULT nextval('"sample_ud".doc_seq'::regclass) NOT NULL,
"doccat_id" varchar(30) COLLATE "default",
"path" varchar(512) COLLATE "default",
"observ" varchar(512) COLLATE "default",
"tagcat_id" varchar(16) COLLATE "default",
"date" timestamp(6) DEFAULT now(),
"user" varchar(16) COLLATE "default",
CONSTRAINT doc_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."doc_x_node" (
"id" int8 DEFAULT nextval('"sample_ud".doc_x_node'::regclass) NOT NULL,
"doc_id" int8,
"node_id" varchar(16) COLLATE "default",
CONSTRAINT doc_x_node_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."doc_x_arc" (
"id" int8 DEFAULT nextval('"sample_ud".doc_x_arc'::regclass) NOT NULL,
"doc_id" int8,
"arc_id" varchar(16) COLLATE "default",
CONSTRAINT doc_x_arc_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."doc_x_connec" (
"id" int8 DEFAULT nextval('"sample_ud".doc_x_connec'::regclass) NOT NULL,
"doc_id" int8,
"connec_id" varchar(16) COLLATE "default",
CONSTRAINT doc_x_connec_pkey PRIMARY KEY (id)
);

CREATE TABLE "sample_ud"."doc_x_gully" (
"id" int8 DEFAULT nextval('"sample_ud".doc_x_gully'::regclass) NOT NULL,
"doc_id" int8,
"gully_id" varchar(16) COLLATE "default",
CONSTRAINT doc_x_gully_pkey PRIMARY KEY (id)
);


ALTER TABLE "sample_ud"."cat_doc" ADD FOREIGN KEY ("id") REFERENCES "sample_ud"."doc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."doc" ADD FOREIGN KEY ("doccat_id") REFERENCES "sample_ud"."cat_doc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."doc" ADD FOREIGN KEY ("tagcat_id") REFERENCES "sample_ud"."cat_tag" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."doc_x_node" ADD FOREIGN KEY ("doc_id") REFERENCES "sample_ud"."doc" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."doc_x_node" ADD FOREIGN KEY ("node_id") REFERENCES "sample_ud"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."doc_x_arc" ADD FOREIGN KEY ("doc_id") REFERENCES "sample_ud"."doc" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."doc_x_arc" ADD FOREIGN KEY ("arc_id") REFERENCES "sample_ud"."arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."doc_x_connec" ADD FOREIGN KEY ("doc_id") REFERENCES "sample_ud"."doc" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."doc_x_connec" ADD FOREIGN KEY ("connec_id") REFERENCES "sample_ud"."connec" ("connec_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."doc_x_gully" ADD FOREIGN KEY ("doc_id") REFERENCES "sample_ud"."doc" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."doc_x_gully" ADD FOREIGN KEY ("gully_id") REFERENCES "sample_ud"."gully" ("gully_id") ON DELETE RESTRICT ON UPDATE CASCADE;