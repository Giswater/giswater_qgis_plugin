/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/06/07
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_workspace", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);

ALTER TABLE cat_workspace ALTER COLUMN active SET DEFAULT True;

--2022/06/10
CREATE SEQUENCE IF NOT EXISTS ext_address_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 2147483647
  START 1
  CACHE 1;
  
CREATE SEQUENCE IF NOT EXISTS ext_streetaxis_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 2147483647
  START 1
  CACHE 1;
