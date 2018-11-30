/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

CREATE SEQUENCE doc_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE TABLE "doc_type" (
"id" varchar(30)   NOT NULL,
"comment" varchar(512)  ,
CONSTRAINT doc_type_pkey PRIMARY KEY (id)
);
  
  
CREATE TABLE "doc" (
"id" varchar(30) DEFAULT nextval ('"SCHEMA_NAME".doc_seq'::regclass) NOT NULL,
"doc_type" varchar(30),
"path" varchar(512),
"observ" varchar(512),
"date" timestamp(6) DEFAULT now(),
"user_name" varchar(50) DEFAULT user,
"tstamp" timestamp DEFAULT now(),
CONSTRAINT doc_pkey PRIMARY KEY (id)
);


CREATE TABLE "doc_x_node" (
"id" serial NOT NULL PRIMARY KEY,
"doc_id" varchar(30),
"node_id" varchar(16)
);


CREATE TABLE "doc_x_arc" (
"id" serial NOT NULL PRIMARY KEY,
"doc_id" varchar(30),
"arc_id" varchar(16)
);


CREATE TABLE "doc_x_connec" (
"id" serial NOT NULL PRIMARY KEY,
"doc_id" varchar(30),
"connec_id" varchar(16) 
);

CREATE TABLE "doc_x_visit"(
id serial NOT NULL PRIMARY KEY,
doc_id character varying(30),
visit_id integer 
);



