/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 13/02/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"connec", "column":"n_inhabitants", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"om_waterbalance", "column":"n_inhabitants", "dataType":"integer", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"om_waterbalance", "column":"avg_press", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_streetaxis", "column":"road_type", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_streetaxis", "column":"surface", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_streetaxis", "column":"maxspeed", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_streetaxis", "column":"lanes", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_streetaxis", "column":"oneway", "dataType":"boolean"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_streetaxis", "column":"pedestrian", "dataType":"boolean"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_streetaxis", "column":"access_info", "dataType":"varchar(100)"}}$$);


CREATE SEQUENCE IF NOT EXISTS om_streetaxis_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 2147483647
  START 1
  CACHE 1;


ALTER TABLE om_streetaxis ALTER COLUMN id SET DEFAULT nextval('om_streetaxis_id_seq');