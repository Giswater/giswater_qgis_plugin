/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Sequences
-- --------------------------

CREATE SEQUENCE "sample_ud".event_id_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "sample_ud".event_x_junction_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "sample_ud".event_x_storage_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "sample_ud".event_x_outfall_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
 
CREATE SEQUENCE "sample_ud".event_x_conduit_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "sample_ud".event_x_gate_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "sample_ud".event_x_pump_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "sample_ud".event_x_cover_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "sample_ud".event_x_step_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "sample_ud".event_x_connec_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "sample_ud".event_x_gully_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


-- ----------------------------
-- Table system table
-- ----------------------------
 
CREATE TABLE "sample_ud"."event_type" (
"id" varchar(18) COLLATE "default" NOT NULL,
"observ" varchar(255) COLLATE "default" NOT NULL,
CONSTRAINT event_type_pkey PRIMARY KEY (id)
) ;


-- ----------------------------
-- Table structure for CATALOGS
-- ----------------------------

CREATE TABLE "sample_ud"."cat_event" (
"id" varchar(30) COLLATE "default" NOT NULL,
"eventtype_id" varchar(30) COLLATE "default",
"descript" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default",
CONSTRAINT cat_event_pkey PRIMARY KEY (id)
);


-- ----------------------------
-- Table structure for GIS features
-- ----------------------------

CREATE TABLE "sample_ud"."event" (
"id" varchar(30) DEFAULT nextval('"sample_ud".event_id_seq'::regclass) NOT NULL,
"eventcat_id" varchar(30) COLLATE "default",
"start_date" timestamp(6),
"end_date" timestamp(6),
"observ" varchar(512) COLLATE "default",
"tag" varchar(16) COLLATE "default",
"date" timestamp(6) DEFAULT now(),
"user" varchar(16) COLLATE "default",
CONSTRAINT event_pkey PRIMARY KEY (id)
);

CREATE TABLE "sample_ud"."event_x_junction" (
"id" int8 DEFAULT nextval('"sample_ud".event_x_junction_seq'::regclass) NOT NULL,
"event_id" varchar(30) COLLATE "default" NOT NULL,
"node_id" varchar(16) COLLATE "default",
"value_struc" varchar(16) COLLATE "default",
"value_sediment" varchar(16) COLLATE "default",
"observ" varchar (512) COLLATE "default",
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_junction_pkey PRIMARY KEY (id)
);

CREATE TABLE "sample_ud"."event_x_storage" (
"id" int8 DEFAULT nextval('"sample_ud".event_x_storage_seq'::regclass) NOT NULL,
"event_id" varchar(30) COLLATE "default" NOT NULL,
"node_id" varchar(16) COLLATE "default",
"value_struc" varchar(16) COLLATE "default",
"value_sediment" varchar(16) COLLATE "default",
"observ" varchar (512) COLLATE "default",
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_storage_pkey PRIMARY KEY (id)
);

CREATE TABLE "sample_ud"."event_x_outfall" (
"id" int8 DEFAULT nextval('"sample_ud".event_x_outfall_seq'::regclass) NOT NULL,
"event_id" varchar(30) COLLATE "default" NOT NULL,
"node_id" varchar(16) COLLATE "default",
"value_struc" varchar(16) COLLATE "default",
"value_sediment" varchar(16) COLLATE "default",
"observ" varchar (512) COLLATE "default",
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_outfall_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."event_x_conduit" (
"id" int8 DEFAULT nextval('"sample_ud".event_x_conduit_seq'::regclass) NOT NULL,
"event_id" varchar(30) COLLATE "default" NOT NULL,
"arc_id" varchar(16) COLLATE "default",
"value_struc" varchar(16) COLLATE "default",
"value_sediment" varchar(16) COLLATE "default",
"observ" varchar (512) COLLATE "default",
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_conduit_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."event_x_gate" (
"id" int8 DEFAULT nextval('"sample_ud".event_x_gate_seq'::regclass) NOT NULL,
"event_id" varchar(30) COLLATE "default" NOT NULL,
"element_id" varchar(16) COLLATE "default",
"value" varchar(16) COLLATE "default",
"observ" varchar (512) COLLATE "default",
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_gate_pkey PRIMARY KEY (id)
);

CREATE TABLE "sample_ud"."event_x_pump" (
"id" int8 DEFAULT nextval('"sample_ud".event_x_pump_seq'::regclass) NOT NULL,
"event_id" varchar(30) COLLATE "default" NOT NULL,
"element_id" varchar(16) COLLATE "default",
"value" varchar(16) COLLATE "default",
"observ" varchar (512) COLLATE "default",
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_pump_pkey PRIMARY KEY (id)
);

CREATE TABLE "sample_ud"."event_x_cover" (
"id" int8 DEFAULT nextval('"sample_ud".event_x_cover_seq'::regclass) NOT NULL,
"event_id" varchar(30) COLLATE "default" NOT NULL,
"element_id" varchar(16) COLLATE "default",
"value_coverstate" varchar(16) COLLATE "default",
"observ" varchar (512) COLLATE "default",
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_cover_pkey PRIMARY KEY (id)
);

CREATE TABLE "sample_ud"."event_x_step" (
"id" int8 DEFAULT nextval('"sample_ud".event_x_step_seq'::regclass) NOT NULL,
"event_id" varchar(30) COLLATE "default" NOT NULL,
"element_id" varchar(16) COLLATE "default",
"value" varchar(16) COLLATE "default",
"observ" varchar (512) COLLATE "default",
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_step_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."event_x_connec" (
"id" int8 DEFAULT nextval('"sample_ud".event_x_connec_seq'::regclass) NOT NULL,
"event_id" varchar(30) COLLATE "default" NOT NULL,
"connec_id" varchar(16) COLLATE "default",
"value_struc" varchar(16) COLLATE "default",
"value_sediment" varchar(16) COLLATE "default",
"observ" varchar (512) COLLATE "default",
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_connec_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."event_x_gully" (
"id" int8 DEFAULT nextval('"sample_ud".event_x_gully_seq'::regclass) NOT NULL,
"event_id" varchar(30) COLLATE "default" NOT NULL,
"gully_id" varchar(16) COLLATE "default",
"value_struc" varchar(16) COLLATE "default",
"value_sediment" varchar(16) COLLATE "default",
"observ" varchar (512) COLLATE "default",
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_gully_pkey PRIMARY KEY (id)
);



-- ----------------------------
-- Table structure for event_value
-- ----------------------------

CREATE TABLE "sample_ud"."event_value" (
"id" varchar(16) COLLATE "default" NOT NULL,
"value" int2,
"descript" varchar(100) COLLATE "default" NOT NULL,
CONSTRAINT event_value_pkey PRIMARY KEY (id)
);


-- ----------------------------
-- Table structure for event_value_struc
-- ----------------------------

CREATE TABLE "sample_ud"."event_value_struc" (
"id" varchar(16) COLLATE "default" NOT NULL,
"value" int2,
"descript" varchar(100) COLLATE "default" NOT NULL,
CONSTRAINT event_value_struc_pkey PRIMARY KEY (id)
);

-- ----------------------------
-- Table structure for event_value_sediment
-- ----------------------------

CREATE TABLE "sample_ud"."event_value_sediment" (
"id" varchar(16) COLLATE "default" NOT NULL,
"value" int2,
"descript" varchar(100) COLLATE "default" NOT NULL,
CONSTRAINT event_value_sediment_pkey PRIMARY KEY (id)
);


-- ----------------------------
-- Table structure for event_value_coverstate
-- ----------------------------

CREATE TABLE "sample_ud"."event_value_coverstate" (
"id" varchar(16) COLLATE "default" NOT NULL,
"value" int2,
"descript" varchar(100) COLLATE "default" NOT NULL,
CONSTRAINT event_value_coverstate_pkey PRIMARY KEY (id)
);







ALTER TABLE "sample_ud"."cat_event" ADD FOREIGN KEY ("eventtype_id") REFERENCES "sample_ud"."event_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event" ADD FOREIGN KEY ("eventcat_id") REFERENCES "sample_ud"."cat_event" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."event_x_junction" ADD FOREIGN KEY ("event_id") REFERENCES "sample_ud"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_junction" ADD FOREIGN KEY ("node_id") REFERENCES "sample_ud"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_junction" ADD FOREIGN KEY ("value_struc") REFERENCES "sample_ud"."event_value" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_junction" ADD FOREIGN KEY ("value_sediment") REFERENCES "sample_ud"."event_value_sediment" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."event_x_storage" ADD FOREIGN KEY ("event_id") REFERENCES "sample_ud"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_storage" ADD FOREIGN KEY ("node_id") REFERENCES "sample_ud"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_storage" ADD FOREIGN KEY ("value_struc") REFERENCES "sample_ud"."event_value" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_storage" ADD FOREIGN KEY ("value_sediment") REFERENCES "sample_ud"."event_value_sediment" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."event_x_outfall" ADD FOREIGN KEY ("event_id") REFERENCES "sample_ud"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_outfall" ADD FOREIGN KEY ("node_id") REFERENCES "sample_ud"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_outfall" ADD FOREIGN KEY ("value_struc") REFERENCES "sample_ud"."event_value" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_outfall" ADD FOREIGN KEY ("value_sediment") REFERENCES "sample_ud"."event_value_sediment" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."event_x_conduit" ADD FOREIGN KEY ("event_id") REFERENCES "sample_ud"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_conduit" ADD FOREIGN KEY ("arc_id") REFERENCES "sample_ud"."arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_conduit" ADD FOREIGN KEY ("value_struc") REFERENCES "sample_ud"."event_value" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_conduit" ADD FOREIGN KEY ("value_sediment") REFERENCES "sample_ud"."event_value_sediment" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."event_x_gate" ADD FOREIGN KEY ("event_id") REFERENCES "sample_ud"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_gate" ADD FOREIGN KEY ("element_id") REFERENCES "sample_ud"."element" ("element_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_gate" ADD FOREIGN KEY ("value") REFERENCES "sample_ud"."event_value" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."event_x_pump" ADD FOREIGN KEY ("event_id") REFERENCES "sample_ud"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_pump" ADD FOREIGN KEY ("element_id") REFERENCES "sample_ud"."element" ("element_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_pump" ADD FOREIGN KEY ("value") REFERENCES "sample_ud"."event_value" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."event_x_cover" ADD FOREIGN KEY ("event_id") REFERENCES "sample_ud"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_cover" ADD FOREIGN KEY ("element_id") REFERENCES "sample_ud"."element" ("element_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_cover" ADD FOREIGN KEY ("value_coverstate") REFERENCES "sample_ud"."event_value_coverstate" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."event_x_step" ADD FOREIGN KEY ("event_id") REFERENCES "sample_ud"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_step" ADD FOREIGN KEY ("element_id") REFERENCES "sample_ud"."element" ("element_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_step" ADD FOREIGN KEY ("value") REFERENCES "sample_ud"."event_value" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."event_x_connec" ADD FOREIGN KEY ("event_id") REFERENCES "sample_ud"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_connec" ADD FOREIGN KEY ("connec_id") REFERENCES "sample_ud"."connec" ("connec_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_connec" ADD FOREIGN KEY ("value_struc") REFERENCES "sample_ud"."event_value_struc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_connec" ADD FOREIGN KEY ("value_sediment") REFERENCES "sample_ud"."event_value_sediment" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."event_x_gully" ADD FOREIGN KEY ("event_id") REFERENCES "sample_ud"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_gully" ADD FOREIGN KEY ("gully_id") REFERENCES "sample_ud"."gully" ("gully_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_gully" ADD FOREIGN KEY ("value_struc") REFERENCES "sample_ud"."event_value" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."event_x_gully" ADD FOREIGN KEY ("value_sediment") REFERENCES "sample_ud"."event_value_sediment" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

