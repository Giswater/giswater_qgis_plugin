/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/01/30
SELECT gw_fct_admin_manage_fields($${"data":{"action":"inp_","table":"inp_pump_additional", "column":"to_arc", "dataType":"varchar(16)", "isUtils":"False"}}$$);


--2020/03/05
CREATE SEQUENCE IF NOT EXISTS man_hydrant_fire_code_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

