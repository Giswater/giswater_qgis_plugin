/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP VIEW IF EXISTS  v_anl_graf;
DROP TABLE IF EXISTS temp_anlgraf;
CREATE TABLE temp_anlgraf(
  id serial NOT NULL,
  arc_id varchar(20),
  node_1 varchar(20),
  node_2 varchar(20),
  water smallint,
  flag smallint,
  checkf smallint,
  length numeric(12,4),
  cost numeric(12,4),
  value numeric(12,4),
  CONSTRAINT temp_anlgraf_pkey PRIMARY KEY (id),
  CONSTRAINT temp_anlgraf_unique UNIQUE (arc_id, node_1));

CREATE INDEX temp_anlgraf_arc_id
  ON temp_anlgraf  USING btree  (arc_id);

CREATE INDEX temp_anlgraf_node_1
  ON temp_anlgraf  USING btree  (node_1);

CREATE INDEX temp_anlgraf_node_2
  ON temp_anlgraf  USING btree  (node_2);
  
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_dma_period", "column":"pattern_volume", "dataType":"double precision"}}$$);

--29/04/2020
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_feature_cat", "column":"epa_default", "dataType":"varchar(16)"}}$$);

-- 30/04/2020
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"z1", "dataType":"float"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"z2", "dataType":"float"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"y1", "dataType":"float"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"y2", "dataType":"float"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"elev1", "dataType":"float"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"elev2", "dataType":"float"}}$$);