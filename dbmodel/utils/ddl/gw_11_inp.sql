/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;



-- ----------------------------
-- Table structure for SELECTORS
-- ----------------------------

CREATE TABLE "rpt_selector_result" (
"id" serial NOT NULL PRIMARY KEY, 
"result_id" varchar(30) ,
"cur_user" text
);

CREATE TABLE "rpt_selector_compare" (
"id" serial NOT NULL PRIMARY KEY,
"result_id" varchar(30)  ,
"cur_user" text
);

CREATE TABLE "inp_selector_sector"(
"id" serial NOT NULL PRIMARY KEY,
"sector_id" integer,
"cur_user" text);

CREATE TABLE "inp_selector_result"(
"id" serial NOT NULL PRIMARY KEY,
"result_id" varchar(30),
"cur_user" text);


-- ----------------------------
-- Table structure
-- ----------------------------

CREATE TABLE "inp_arc_type" (
"id" varchar(16)   NOT NULL,
CONSTRAINT inp_arc_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "inp_node_type" (
"id" varchar(16)   NOT NULL,
CONSTRAINT inp_node_type_pkey PRIMARY KEY (id)
);



 
 


