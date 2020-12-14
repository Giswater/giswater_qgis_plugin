/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/12/03
ALTER TABLE cat_grate ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE cat_node_shape ALTER COLUMN active SET DEFAULT TRUE;

-- 2020/12/04
ALTER TABLE IF EXISTS inp_label RENAME to _inp_label_;

CREATE TABLE IF NOT EXISTS inp_label
(
  label text primary key,
  xcoord numeric(18,6),
  ycoord numeric(18,6),
  anchor character varying(16),
  font character varying(50),
  size integer,
  bold character varying(3),
  italic character varying(3)
);
