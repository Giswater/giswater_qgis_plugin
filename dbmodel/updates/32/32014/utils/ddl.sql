/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector", "column":"status", "dataType":"integer"}}$$);


CREATE TABLE IF NOT EXISTS plan_typevalue(
  typevalue text NOT NULL,
  id integer NOT NULL,
  idval text,
  descript text,
  addparam json,
  CONSTRAINT plan_typevalue_pkey PRIMARY KEY (typevalue, id));

CREATE TABLE IF NOT EXISTS om_typevalue(
  typevalue text NOT NULL,
  id integer NOT NULL,
  idval text,
  descript text,
  addparam json,
  CONSTRAINT om_typevalue_pkey PRIMARY KEY (typevalue, id));
  
 
ALTER TABLE cat_arc ALTER COLUMN id DROP DEFAULT;
ALTER TABLE cat_node ALTER COLUMN id DROP DEFAULT;