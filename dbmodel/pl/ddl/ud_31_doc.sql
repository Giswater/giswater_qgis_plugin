/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;



CREATE SEQUENCE doc_x_gully_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
  
  

CREATE TABLE "doc_x_gully" (
"id" int8 DEFAULT nextval ('"SCHEMA_NAME".doc_x_gully_seq'::regclass) NOT NULL,
"doc_id" varchar(30),
"gully_id" varchar(16)  ,
CONSTRAINT doc_x_gully_pkey PRIMARY KEY (id)
);
