/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_presszone", "column":"the_geom", "dataType":"geometry(MULTIPOLYGON, SRID_VALUE)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"sector_type", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_reservoir", "column":"to_arc", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_rules_x_arc", "column":"active", "dataType":"boolean"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_rules_x_node", "column":"active", "dataType":"boolean"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_rules_x_sector", "column":"active", "dataType":"boolean"}}$$);


ALTER TABLE inp_controls_x_node RENAME TO _inp_controls_x_node_;

CREATE TABLE IF NOT EXISTS inp_inlet
(
  node_id varchar(16) PRIMARY KEY,
  initlevel numeric(12,4),
  minlevel numeric(12,4),
  maxlevel numeric(12,4),
  diameter numeric(12,4),
  minvol numeric(12,4),
  curve_id character varying(16),
  pattern_id varchar (16),
  to_arc varchar (16)
  );


  CREATE TABLE IF NOT EXISTS minsector(
  minsector_id SERIAL PRIMARY KEY,
  dma_id integer,
  dqa_id integer,
  presszonecat_id integer,
  sector_id integer,
  expl_id integer,
  the_geom geometry (POLYGON, SRID_VALUE)
   );
   
   
  CREATE TABLE IF NOT EXISTS minsector_graf(
  node_id varchar (16) PRIMARY KEY,
  nodecat_id varchar (30),
  minsector_1 integer,
  minsector_2 integer
    );
    
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_mincut_result_cat", "column":"notified", "dataType":"json"}}$$);

