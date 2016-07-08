
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

  
CREATE SEQUENCE "SCHEMA_NAME".event_x_node_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
  
CREATE SEQUENCE "SCHEMA_NAME".event_x_arc_seq
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

  
CREATE SEQUENCE "SCHEMA_NAME".event_x_element_seq
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



CREATE TABLE "SCHEMA_NAME"."event_parameter" (
"id" varchar(50)   NOT NULL,
"event_type" varchar(30) ,
"feature" varchar(30) ,
"data_type" varchar(16) ,
"descript" varchar(50) ,
CONSTRAINT event_parameter_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."event_position" (
"id" varchar(50)   NOT NULL,
"feature" varchar(30) ,
"descript" varchar(50) ,
CONSTRAINT event_position_pkey PRIMARY KEY (id)
);



CREATE TABLE "SCHEMA_NAME"."event" (
"id" varchar(30) DEFAULT nextval('"SCHEMA_NAME".event_id_seq'::regclass) NOT NULL,
"event_type" varchar(30)  ,
"startdate" date,
"enddate" date,
"observ" varchar(512)  ,
"tag" varchar(16)  ,
"timestamp" timestamp(6) DEFAULT now(),
"user" varchar(16)  ,
CONSTRAINT event_pkey PRIMARY KEY (id)
);


-- ----------------------------
-- Table gis & elements features related
-- ----------------------------


CREATE TABLE "SCHEMA_NAME"."event_x_node" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_node_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"node_id" varchar(16)  ,  
"parameter_id" varchar(50)  ,
"value" text,
"position_id" varchar(50),
"text" text,
CONSTRAINT event_x_node_pkey PRIMARY KEY (id)
);



CREATE TABLE "SCHEMA_NAME"."event_x_arc" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_arc_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"arc_id" varchar(16)  ,  
"parameter_id" varchar(50)  ,
"value" text,
"position_id" varchar(50),
"text" text,
CONSTRAINT event_x_arc_pkey PRIMARY KEY (id)
);



CREATE TABLE "SCHEMA_NAME"."event_x_connec" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_connec_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"connec_id" varchar(16)  ,  
"parameter_id" varchar(50)  ,
"value" text,
"position_id" varchar(50),
"text" text,
CONSTRAINT event_x_connec_pkey PRIMARY KEY (id)
);



CREATE TABLE "SCHEMA_NAME"."event_x_element" (
"id" int8 DEFAULT nextval('"SCHEMA_NAME".event_x_element_seq'::regclass) NOT NULL,
"event_id" varchar(30)   NOT NULL,
"element_id" varchar(16)  ,  
"parameter_id" varchar(50)  ,
"value" text,
"position_id" varchar(50),
"text" text,
CONSTRAINT event_x_element_pkey PRIMARY KEY (id)
);

