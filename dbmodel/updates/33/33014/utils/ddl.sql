/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--13/11/2019
ALTER TABLE audit_cat_column ADD CONSTRAINT audit_cat_column_pkey PRIMARY KEY(column_id);

ALTER TABLE IF EXISTS raster_dem RENAME TO ext_raster_dem;
ALTER TABLE IF EXISTS cat_raster RENAME TO ext_cat_raster;


ALTER TABLE anl_graf RENAME TO _anl_graf_;


--14/11/2019
CREATE TABLE IF NOT EXISTS temp_anlgraf
(
  id serial NOT NULL,
  arc_id integer,
  node_1 integer,
  node_2 integer,
  water smallint,
  flag smallint,
  checkf smallint,
  CONSTRAINT temp_anlgraf_pkey PRIMARY KEY (id)
);