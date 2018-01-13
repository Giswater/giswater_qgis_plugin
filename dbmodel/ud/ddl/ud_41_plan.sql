/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;



DROP TABLE IF EXISTS plan_result_reh_arc CASCADE;
CREATE TABLE plan_result_reh_arc (
id serial PRIMARY KEY,
result_id integer,
arc_id varchar (16),
parameter_id varchar(30) ,
work_id varchar(30) ,
init_condition float,
end_condition float,
loc_condition text,
pcompost_id varchar(16),
pcompost_price float,
ymax float,
length float,
measurement float,
cost float
);

DROP TABLE IF EXISTS plan_result_reh_node CASCADE;
CREATE TABLE plan_result_reh_node (
id serial PRIMARY KEY,
result_id integer,
node_id varchar (16),
parameter_id varchar(30) ,
work_id varchar(30) ,
pcompost_id varchar(16),
pcompost_price float,
ymax float,
measurement float,
cost float
);


CREATE TABLE plan_result_reh_cat (
result_id serial PRIMARY KEY,
name character varying(30),  
network_price_coeff float,
tstamp timestamp DEFAULT now(),
cur_user text,
descript text
);


CREATE TABLE plan_selector_result_reh (
  id SERIAL PRIMARY KEY,
  result_id integer NOT NULL,
  cur_user text NOT NULL
);