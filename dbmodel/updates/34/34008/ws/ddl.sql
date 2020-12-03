/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE IF EXISTS anl_mincut_arc_x_node RENAME to _anl_mincut_arc_x_node_ ;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_pattern", "column":"pattern_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"ext_rtc_dma_period", "column":"m3_total_period"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"ext_rtc_dma_period", "column":"m3_total_period_hydro"}}$$);


drop table if exists temp_arc;
CREATE TABLE temp_arc
(
  id serial NOT NULL,
result_id character varying(30),
  arc_id character varying(16),
  node_1 character varying(16),
  node_2 character varying(16),
  arc_type character varying(30),
  arccat_id character varying(30),
  epa_type character varying(16),
  sector_id integer,
  state smallint,
  state_type smallint,
  annotation character varying(254),
  diameter numeric(12,3),
  roughness numeric(12,6),
  length numeric(12,3),
  status character varying(18),
  the_geom geometry(LineString,25831),
  expl_id integer,
  flw_code character varying(512),
  minorloss numeric(12,6),
  addparam text,
  arcparent character varying(16),
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

CREATE INDEX temp_arc_index
  ON temp_arc
  USING gist
  (the_geom);


CREATE INDEX temp_arc_node_1_type
  ON temp_arc
  USING btree
  (node_1 COLLATE pg_catalog."default");


CREATE INDEX temp_arc_node_2_type
  ON temp_arc
  USING btree
  (node_2 COLLATE pg_catalog."default");


drop table if exists temp_node;

CREATE TABLE temp_node
(
  id serial NOT NULL,
  result_id character varying(30),
  node_id character varying(16),
  elevation numeric(12,3),
  elev numeric(12,3),
  node_type character varying(30),
  nodecat_id character varying(30),
  epa_type character varying(16),
  sector_id integer,
  state smallint,
  state_type smallint,
  annotation character varying(254),
  demand double precision,
  the_geom geometry(Point,25831),
  expl_id integer,
  pattern_id character varying(16),
  addparam text,
  nodeparent character varying(16),
  arcposition smallint,
  CONSTRAINT temp_node_pkey PRIMARY KEY (id));

  
CREATE INDEX temp_node_epa_type
  ON temp_node
  USING btree
  (epa_type COLLATE pg_catalog."default");
  
CREATE INDEX temp_node_index
  ON temp_node
  USING gist
  (the_geom);

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

