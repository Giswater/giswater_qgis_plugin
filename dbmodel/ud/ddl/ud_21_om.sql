/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- System tables
-- ----------------------------
 

CREATE TABLE "om_visit_x_gully" (
"id" serial8 NOT NULL,
"visit_id" int8,
"gully_id" varchar (16),
"is_last" boolean  DEFAULT TRUE,
CONSTRAINT om_visit_x_gully_pkey PRIMARY KEY (id)
);



-- ----------------------------
-- Rehabilitation module
-- ----------------------------

CREATE TABLE om_reh_cat_works (
id varchar(30) PRIMARY KEY,
descript text,
observ text
);
 

CREATE TABLE om_reh_parameter_x_works (
id serial PRIMARY KEY,
parameter_id varchar(50),
init_condition integer,
end_condition integer,
arccat_id varchar(30),
loc_condition_id varchar(30),
catwork_id varchar(30)
);


CREATE TABLE om_reh_works_x_pcompost (
id serial PRIMARY KEY,
work_id varchar(30),
sql_condition text,
pcompost_id varchar(16)
);


CREATE TABLE om_reh_value_loc_condition (
id varchar(30) PRIMARY KEY,
descript text
);


