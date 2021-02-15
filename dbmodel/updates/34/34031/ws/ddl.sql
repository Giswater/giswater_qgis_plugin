/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/02/10
CREATE TABLE temp_demand(
  id serial PRIMARY KEY,
  feature_id character varying(16) NOT NULL,
  demand numeric(12,6),
  pattern_id character varying(16),
  demand_type character varying(18));
  
  
-- 2020/02/11
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"workcat_id_plan", "dataType":"character varying(255)", "isUtils":"True"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"workcat_id_plan", "dataType":"character varying(255)", "isUtils":"True"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"workcat_id_plan", "dataType":"character varying(255)", "isUtils":"True"}}$$);

ALTER TABLE inp_reservoir ADD COLUMN head double precision;

ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_curve_id_fkey FOREIGN KEY (curve_id) 
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

