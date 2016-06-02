/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Sequences
-- --------------------------

CREATE SEQUENCE "SCHEMA_NAME".event_id_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME".event_x_junction_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME".event_x_storage_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME".event_x_outfall_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
 
CREATE SEQUENCE "SCHEMA_NAME".event_x_conduit_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME".event_x_gate_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME".event_x_pump_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME".event_x_cover_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME".event_x_step_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME".event_x_connec_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME".event_x_gully_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


-- ----------------------------
-- Table system table
-- ----------------------------
 
CREATE TABLE "SCHEMA_NAME"."event_type" (
"id" varchar(18)   NOT NULL,
"observ" varchar(255)   NOT NULL,
CONSTRAINT event_type_pkey PRIMARY KEY (id)
) ;


-- ----------------------------
-- Table structure for CATALOGS
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."cat_event" (
"id" varchar(30)   NOT NULL,
"eventtype_id" varchar(30)  ,
"descript" varchar(50)  ,
"comment" varchar(512)  ,
CONSTRAINT cat_event_pkey PRIMARY KEY (id)
);


-- ----------------------------
-- Table structure for GIS features
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."event" (
"id" varchar(30) DEFAULT nextval('"SCHEMA_NAME".event_id_seq'::regclass) NOT NULL,
"eventcat_id" varchar(30)  ,
"start_date" timestamp(6),
"end_date" timestamp(6),
"observ" varchar(512)  ,
"tag" varchar(16)  ,
"date" timestamp(6) DEFAULT now(),
"user" varchar(16)  ,
CONSTRAINT event_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."event_x_junction" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_junction_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"node_id" varchar(16)  ,
"value_struc" varchar(16)  ,
"value_sediment" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_junction_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."event_x_storage" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_storage_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"node_id" varchar(16)  ,
"value_struc" varchar(16)  ,
"value_sediment" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_storage_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."event_x_outfall" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_outfall_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"node_id" varchar(16)  ,
"value_struc" varchar(16)  ,
"value_sediment" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_outfall_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."event_x_conduit" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_conduit_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"arc_id" varchar(16)  ,
"value_struc" varchar(16)  ,
"value_sediment" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_conduit_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."event_x_gate" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_gate_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"element_id" varchar(16)  ,
"value" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_gate_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."event_x_pump" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_pump_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"element_id" varchar(16)  ,
"value" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_pump_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."event_x_cover" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_cover_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"element_id" varchar(16)  ,
"value_coverstate" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_cover_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."event_x_step" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_step_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"element_id" varchar(16)  ,
"value" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_step_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."event_x_connec" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_connec_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"connec_id" varchar(16)  ,
"value_struc" varchar(16)  ,
"value_sediment" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_connec_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."event_x_gully" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_gully_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"gully_id" varchar(16)  ,
"value_struc" varchar(16)  ,
"value_sediment" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_gully_pkey PRIMARY KEY (id)
);



-- ----------------------------
-- Table structure for event_value
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."event_value" (
"id" varchar(16)   NOT NULL,
"value" int2,
"descript" varchar(100)   NOT NULL,
CONSTRAINT event_value_pkey PRIMARY KEY (id)
);


-- ----------------------------
-- Table structure for event_value_struc
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."event_value_struc" (
"id" varchar(16)   NOT NULL,
"value" int2,
"descript" varchar(100)   NOT NULL,
CONSTRAINT event_value_struc_pkey PRIMARY KEY (id)
);

-- ----------------------------
-- Table structure for event_value_sediment
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."event_value_sediment" (
"id" varchar(16)   NOT NULL,
"value" int2,
"descript" varchar(100)   NOT NULL,
CONSTRAINT event_value_sediment_pkey PRIMARY KEY (id)
);


-- ----------------------------
-- Table structure for event_value_coverstate
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."event_value_coverstate" (
"id" varchar(16)   NOT NULL,
"value" int2,
"descript" varchar(100)   NOT NULL,
CONSTRAINT event_value_coverstate_pkey PRIMARY KEY (id)
);





ALTER TABLE "SCHEMA_NAME"."cat_event" ADD FOREIGN KEY ("eventtype_id") REFERENCES "SCHEMA_NAME"."event_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event" ADD FOREIGN KEY ("eventcat_id") REFERENCES "SCHEMA_NAME"."cat_event" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."event_x_junction" ADD FOREIGN KEY ("event_id") REFERENCES "SCHEMA_NAME"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_junction" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_junction" ADD FOREIGN KEY ("value_struc") REFERENCES "SCHEMA_NAME"."event_value_struc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_junction" ADD FOREIGN KEY ("value_sediment") REFERENCES "SCHEMA_NAME"."event_value_sediment" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."event_x_storage" ADD FOREIGN KEY ("event_id") REFERENCES "SCHEMA_NAME"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_storage" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_storage" ADD FOREIGN KEY ("value_struc") REFERENCES "SCHEMA_NAME"."event_value_struc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_storage" ADD FOREIGN KEY ("value_sediment") REFERENCES "SCHEMA_NAME"."event_value_sediment" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."event_x_outfall" ADD FOREIGN KEY ("event_id") REFERENCES "SCHEMA_NAME"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_outfall" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_outfall" ADD FOREIGN KEY ("value_struc") REFERENCES "SCHEMA_NAME"."event_value_struc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_outfall" ADD FOREIGN KEY ("value_sediment") REFERENCES "SCHEMA_NAME"."event_value_sediment" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."event_x_conduit" ADD FOREIGN KEY ("event_id") REFERENCES "SCHEMA_NAME"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_conduit" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_conduit" ADD FOREIGN KEY ("value_struc") REFERENCES "SCHEMA_NAME"."event_value_struc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_conduit" ADD FOREIGN KEY ("value_sediment") REFERENCES "SCHEMA_NAME"."event_value_sediment" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."event_x_gate" ADD FOREIGN KEY ("event_id") REFERENCES "SCHEMA_NAME"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_gate" ADD FOREIGN KEY ("element_id") REFERENCES "SCHEMA_NAME"."element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_gate" ADD FOREIGN KEY ("value") REFERENCES "SCHEMA_NAME"."event_value" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."event_x_pump" ADD FOREIGN KEY ("event_id") REFERENCES "SCHEMA_NAME"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_pump" ADD FOREIGN KEY ("element_id") REFERENCES "SCHEMA_NAME"."element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_pump" ADD FOREIGN KEY ("value") REFERENCES "SCHEMA_NAME"."event_value" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."event_x_cover" ADD FOREIGN KEY ("event_id") REFERENCES "SCHEMA_NAME"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_cover" ADD FOREIGN KEY ("element_id") REFERENCES "SCHEMA_NAME"."element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_cover" ADD FOREIGN KEY ("value_coverstate") REFERENCES "SCHEMA_NAME"."event_value_coverstate" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."event_x_step" ADD FOREIGN KEY ("event_id") REFERENCES "SCHEMA_NAME"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_step" ADD FOREIGN KEY ("element_id") REFERENCES "SCHEMA_NAME"."element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_step" ADD FOREIGN KEY ("value") REFERENCES "SCHEMA_NAME"."event_value" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."event_x_connec" ADD FOREIGN KEY ("event_id") REFERENCES "SCHEMA_NAME"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_connec" ADD FOREIGN KEY ("connec_id") REFERENCES "SCHEMA_NAME"."connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_connec" ADD FOREIGN KEY ("value_struc") REFERENCES "SCHEMA_NAME"."event_value_struc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_connec" ADD FOREIGN KEY ("value_sediment") REFERENCES "SCHEMA_NAME"."event_value_sediment" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."event_x_gully" ADD FOREIGN KEY ("event_id") REFERENCES "SCHEMA_NAME"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_gully" ADD FOREIGN KEY ("gully_id") REFERENCES "SCHEMA_NAME"."gully" ("gully_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_gully" ADD FOREIGN KEY ("value_struc") REFERENCES "SCHEMA_NAME"."event_value_struc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_gully" ADD FOREIGN KEY ("value_sediment") REFERENCES "SCHEMA_NAME"."event_value_sediment" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

