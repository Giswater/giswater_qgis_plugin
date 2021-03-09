/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/02/10
CREATE TABLE IF NOT EXISTS temp_demand(
  id serial PRIMARY KEY,
  feature_id character varying(16) NOT NULL,
  demand numeric(12,6),
  pattern_id character varying(16),
  demand_type character varying(18));
  
  
-- 2020/02/11
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"workcat_id_plan", "dataType":"character varying(255)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"workcat_id_plan", "dataType":"character varying(255)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"workcat_id_plan", "dataType":"character varying(255)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_reservoir", "column":"head", "dataType":"double precision", "isUtils":"False"}}$$);

ALTER SEQUENCE IF EXISTS inp_cat_mat_roughness_id_seq RENAME TO cat_mat_roughness_id_seq;