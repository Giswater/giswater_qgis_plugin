/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



-- ----------------------------
-- Structure for event
-- ----------------------------

CREATE SEQUENCE "wsp".event_id_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "wsp".event_x_arc_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "wsp".event_x_node_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "wsp".event_x_connec_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "wsp".event_x_file_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;



CREATE TABLE "wsp"."cat_event" (
"id" varchar(16) COLLATE "default" NOT NULL,
"type" varchar(16) COLLATE "default",
"descript" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default",
CONSTRAINT cat_event_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE);



CREATE TABLE "wsp"."event" (
"id" int8 DEFAULT nextval('"wsp".event_id_seq'::regclass) NOT NULL,
"date" timestamp(6) DEFAULT now(),
"user" varchar(16) COLLATE "default",
"eventcat_id" varchar(16) COLLATE "default",
"comment" varchar(512) COLLATE "default",
CONSTRAINT event_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE);


CREATE TABLE "wsp"."event_x_node" (
"id" int8 DEFAULT nextval('"wsp".event_x_node'::regclass) NOT NULL,
"event_id" int8,
"node_id" varchar(16) COLLATE "default",
"text" varchar(512) COLLATE "default",
CONSTRAINT event_x_node_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE);


CREATE TABLE "wsp"."event_x_arc" (
"id" int8 DEFAULT nextval('"wsp".event_x_arc'::regclass) NOT NULL,
"event_id" int8,
"arc_id" varchar(16) COLLATE "default",
"text" varchar(512) COLLATE "default",
CONSTRAINT event_x_arc_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE);


CREATE TABLE "wsp"."event_x_connec" (
"id" int8 DEFAULT nextval('"wsp".event_x_node'::regclass) NOT NULL,
"event_id" int8,
"connec_id" varchar(16) COLLATE "default",
"text" varchar(512) COLLATE "default",
CONSTRAINT event_x_connec_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE);


CREATE TABLE "wsp"."event_x_file" (
"id" int8 DEFAULT nextval('"wsp".event_x_file_seq'::regclass) NOT NULL,
"event_id" int8,
"path" varchar(512) COLLATE "default",
CONSTRAINT event_x_file_pkey PRIMARY KEY (id)
) WITH (OIDS=FALSE) ;


ALTER TABLE "wsp"."event" ADD FOREIGN KEY ("user") REFERENCES "wsp"."adm_list_user" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "wsp"."event" ADD FOREIGN KEY ("eventcat_id") REFERENCES "wsp"."cat_event" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "wsp"."event_x_file" ADD FOREIGN KEY ("event_id") REFERENCES "wsp"."event" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "wsp"."event_x_node" ADD FOREIGN KEY ("event_id") REFERENCES "wsp"."event" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "wsp"."event_x_arc" ADD FOREIGN KEY ("event_id") REFERENCES "wsp"."event" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "wsp"."event_x_connec" ADD FOREIGN KEY ("event_id") REFERENCES "wsp"."event" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "wsp"."event_x_node" ADD FOREIGN KEY ("node_id") REFERENCES "wsp"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "wsp"."event_x_arc" ADD FOREIGN KEY ("arc_id") REFERENCES "wsp"."arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "wsp"."event_x_connec" ADD FOREIGN KEY ("connec_id") REFERENCES "wsp"."connec" ("connec_id") ON DELETE RESTRICT ON UPDATE CASCADE;




-- ----------------------------
-- Structure for picture
-- ----------------------------

CREATE SEQUENCE "wsp".event_arc_x_picture_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "wsp".event_node_x_picture_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "wsp".event_connec_x_picture_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE TABLE "wsp"."event_node_x_picture" (
"id" int8 DEFAULT nextval('"wsp".event_node_x_picture'::regclass) NOT NULL,
"node_id" varchar(16) COLLATE "default",
"path" varchar(512) COLLATE "default",
"date" timestamp(6) DEFAULT now(),
"user" varchar(16) COLLATE "default",
"comment" varchar(512) COLLATE "default",
CONSTRAINT event_node_x_picture_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE);


CREATE TABLE "wsp"."event_arc_x_picture" (
"id" int8 DEFAULT nextval('"wsp".event_arc_x_picture'::regclass) NOT NULL,
"arc_id" varchar(16) COLLATE "default",
"path" varchar(512) COLLATE "default",
"date" timestamp(6) DEFAULT now(),
"user" varchar(16) COLLATE "default",
"comment" varchar(512) COLLATE "default",
CONSTRAINT event_arc_x_picture_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE);



CREATE TABLE "wsp"."event_connec_x_picture" (
"id" int8 DEFAULT nextval('"wsp".event_connec_x_picture'::regclass) NOT NULL,
"connec_id" varchar(16) COLLATE "default",
"path" varchar(512) COLLATE "default",
"date" timestamp(6) DEFAULT now(),
"user" varchar(16) COLLATE "default",
"comment" varchar(512) COLLATE "default",
CONSTRAINT event_connec_x_picture_pkey PRIMARY KEY (id)
) WITH (OIDS=FALSE);



ALTER TABLE "wsp"."event_node_x_picture" ADD FOREIGN KEY ("node_id") REFERENCES "wsp"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "wsp"."event_arc_x_picture" ADD FOREIGN KEY ("arc_id") REFERENCES "wsp"."arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "wsp"."event_connec_x_picture" ADD FOREIGN KEY ("connec_id") REFERENCES "wsp"."connec" ("connec_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "wsp"."event_node_x_picture" ADD FOREIGN KEY ("user") REFERENCES "wsp"."adm_list_user" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "wsp"."event_arc_x_picture" ADD FOREIGN KEY ("user") REFERENCES "wsp"."adm_list_user" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "wsp"."event_connec_x_picture" ADD FOREIGN KEY ("user") REFERENCES "wsp"."adm_list_user" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


