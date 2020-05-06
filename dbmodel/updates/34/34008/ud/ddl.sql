/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node_type", "column":"isexitupperintro", "dataType":"int2"}}$$);
ALTER TABLE node_type ALTER COLUMN isexitupperintro SET DEFAULT 0;
COMMENT ON TABLE node_type IS 'FIELD isexitupperintro has three values 0-false (by default), 1-true, 2-maybe';

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc", "column":"q0", "dataType":"float"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc", "column":"qmax", "dataType":"float"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc", "column":"barrels", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc", "column":"slope", "dataType":"float"}}$$);


CREATE TABLE temp_arc(
  id serial NOT NULL,
  result_id character varying(30) NOT NULL,
  arc_id character varying(16) NOT NULL,
  flw_code character varying(50),
  node_1 character varying(16),
  node_2 character varying(16),
  elevmax1 numeric(12,3),
  elevmax2 numeric(12,3),
  arc_type character varying(30),
  arccat_id character varying(30),
  epa_type character varying(16),
  sector_id integer NOT NULL,
  state smallint NOT NULL,
  state_type smallint,
  annotation character varying(254),
  length numeric(12,3),
  n numeric(12,3),
  the_geom geometry(LineString,25831),
  expl_id integer,
  minorloss numeric(12,6),
  addparam text,
  arcparent character varying(16),
  q0 double precision,
  qmax double precision,
  barrels integer,
  slope double precision,
  CONSTRAINT temp_arc_pkey PRIMARY KEY (id));
  
  
CREATE INDEX temp_arc_arc_id
  ON temp_arc
  USING btree
  (arc_id COLLATE pg_catalog."default");

CREATE INDEX temp_arc_arc_type
  ON temp_arc
  USING btree
  (arc_type COLLATE pg_catalog."default");

CREATE INDEX temp_arc_epa_type
  ON temp_arc
  USING btree
  (epa_type COLLATE pg_catalog."default");

CREATE INDEX temp_arc_node_1_type
  ON temp_arc
  USING btree
  (node_1 COLLATE pg_catalog."default");

CREATE INDEX temp_arc_node_2_type
  ON temp_arc
  USING btree
  (node_2 COLLATE pg_catalog."default");

CREATE INDEX temp_arc_result_id
  ON temp_arc
  USING btree
  (result_id COLLATE pg_catalog."default");


CREATE TABLE temp_node (
  id serial NOT NULL,
  result_id character varying(30) NOT NULL,
  node_id character varying(16) NOT NULL,
  flw_code character varying(50),
  top_elev numeric(12,3),
  ymax numeric(12,3),
  elev numeric(12,3),
  node_type character varying(30),
  nodecat_id character varying(30),
  epa_type character varying(16),
  sector_id integer NOT NULL,
  state smallint NOT NULL,
  state_type smallint,
  annotation character varying(254),
  y0 numeric(12,4),
  ysur numeric(12,4),
  apond numeric(12,4),
  the_geom geometry(Point,25831),
  expl_id integer,
  addparam text,
  nodeparent character varying(16),
  arcposition smallint,
  CONSTRAINT temp_node_pkey PRIMARY KEY (id));
  

CREATE INDEX temp_node_epa_type
  ON temp_node
  USING btree
  (epa_type COLLATE pg_catalog."default");

CREATE INDEX temp_node_node_id
  ON temp_node
  USING btree
  (node_id COLLATE pg_catalog."default");

CREATE INDEX temp_node_node_type
  ON temp_node
  USING btree
  (node_type COLLATE pg_catalog."default");

CREATE INDEX temp_node_nodeparent
  ON temp_node
  USING btree
  (nodeparent COLLATE pg_catalog."default");

CREATE INDEX temp_node_result_id
  ON temp_node
  USING btree
  (result_id COLLATE pg_catalog."default");