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

CREATE SEQUENCE "SCHEMA_NAME".event_x_tank_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME".event_x_hydrant_seq
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

CREATE SEQUENCE "SCHEMA_NAME".event_x_valve_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME".event_x_filter_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME".event_x_meter_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
  
CREATE SEQUENCE "SCHEMA_NAME".event_x_pipe_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;  

CREATE SEQUENCE "SCHEMA_NAME".event_x_register_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME".event_x_manhole_seq
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
"value" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_junction_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."event_x_tank" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_tank_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"node_id" varchar(16)  ,
"value" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_tank_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."event_x_hydrant" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_hydrant_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"node_id" varchar(16)  ,
"value" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_hydrant_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."event_x_pump" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_pump_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"node_id" varchar(16)  ,
"value" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_pump_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."event_x_valve" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_valve_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"node_id" varchar(16)  ,
"value" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_valve_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."event_x_filter" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_filter_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"node_id" varchar(16)  ,
"value" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_filter_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."event_x_meter" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_meter_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"node_id" varchar(16)  ,
"value" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_meter_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."event_x_pipe" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_pipe_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"arc_id" varchar(16)  ,
"value" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_pipe_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."event_x_register" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_register_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"element_id" varchar(16)  ,
"value" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_register_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."event_x_manhole" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_manhole_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"element_id" varchar(16)  ,
"value" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_manhole_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."event_x_cover" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_cover_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"element_id" varchar(16)  ,
"value" varchar(16)  ,
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
"value" varchar(16)  ,
"observ" varchar (512)  ,
"date" timestamp(6) DEFAULT now(),
CONSTRAINT event_x_connec_pkey PRIMARY KEY (id)
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

