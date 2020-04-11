/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE IF EXISTS anl_mincut_arc_x_node RENAME to _anl_mincut_arc_x_node_ ;

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
  
ALTER TABLE ext_rtc_dma_period ADD COLUMN pattern_volume double precision;

ALTER TABLE inp_pattern DROP COLUMN pattern_type;
