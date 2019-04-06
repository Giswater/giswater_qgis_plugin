/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = ud_sample, public, pg_catalog;


CREATE TABLE rpt_node (
id bigserial PRIMARY KEY,
result_id character varying(30) NOT NULL,
node_id varchar(16),
resultdate varchar(16),
resulttime varchar(12),
flooding float,
depth float,
head float,
CONSTRAINT rpt_node_result_fkey FOREIGN KEY (result_id)
      REFERENCES rpt_cat_result (result_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);



CREATE TABLE rpt_arc (
id bigserial PRIMARY KEY,
result_id character varying(30) NOT NULL,
arc_id varchar(16),
resultdate varchar(16),
resulttime varchar(12),
flow float,
velocity float,
fullpercent float,
CONSTRAINT rpt_arc_result_fkey FOREIGN KEY (result_id)
      REFERENCES rpt_cat_result (result_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE

);



CREATE TABLE rpt_subcatchment ( 
id bigserial PRIMARY KEY,
result_id character varying(30) NOT NULL,
subc_id varchar(16),
resultdate varchar(16),
resulttime varchar(12),
precip float,
losses float,
runoff float,
CONSTRAINT rpt_subcatchment_fkey FOREIGN KEY (result_id)
      REFERENCES rpt_cat_result (result_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE

);



CREATE TABLE rpt_selector_timestep(
  id serial PRIMARY KEY,
  resultdate varchar(16),
  resulttime varchar(12),
  cur_user text NOT NULL
);


CREATE TABLE rpt_selector_timestep_compare(
  id serial PRIMARY KEY,
  resulttime varchar(12),
  cur_user text NOT NULL
);


CREATE TABLE rpt_summary_raingage(
  id serial PRIMARY KEY,
  result_id character varying(30) NOT NULL,
  rg_id  character varying(16) NOT NULL,
  data_source character varying(16),
  data_type character varying(16),
  interval character varying(16)
);


CREATE TABLE rpt_summary_subcatchment(
  id serial PRIMARY KEY,
  result_id character varying(30) NOT NULL,
  subc_id  character varying(16) NOT NULL,
  area float,
  width float,
  imperv float,
  slope float,
  rg_id character varying(16) NOT NULL,
  outlet character varying(16) NOT NULL  
);

CREATE TABLE rpt_summary_node(
  id serial PRIMARY KEY,
  result_id character varying(30) NOT NULL,
  node_id  character varying(16) NOT NULL,
  epa_type character varying(16) NOT NULL,
  elevation float,
  maxdepth float, 
  pondedarea float, 
  externalinf character varying(16) NOT NULL
);


CREATE TABLE rpt_summary_arc (
  id serial PRIMARY KEY,
  result_id character varying(30) NOT NULL,
  arc_id  character varying(16) NOT NULL,
  node_1 character varying(16) NOT NULL,
  node_2 character varying(16) NOT NULL,
  epa_type character varying(16) NOT NULL,
  length float,
  slope float,
  roughness float
);


CREATE TABLE rpt_summary_crossection (
  id serial PRIMARY KEY,
  result_id character varying(30) NOT NULL,
  arc_id  character varying(16) NOT NULL,
  shape character varying(16) NOT NULL,
  fulldepth float,
  fullarea float,
  hydrad float,
  maxwidth float,
  barrels integer,
  fullflow float
);


