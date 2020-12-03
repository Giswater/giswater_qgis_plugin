/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;




CREATE TABLE inp_valve_importinp
(
  arc_id character varying(16) PRIMARY KEY NOT NULL,
  valv_type character varying(18),
  pressure numeric(12,4),
  diameter numeric(12,4),
  flow numeric(12,4),
  coef_loss numeric(12,4),
  curve_id character varying(16),
  minorloss numeric(12,4),
  status character varying(12),
  to_arc character varying(16)
  );

  
CREATE TABLE inp_pump_importinp
(
  arc_id character varying(16) PRIMARY KEY NOT NULL,
  power character varying,
  curve_id character varying,
  speed numeric(12,6),
  pattern character varying,
  status character varying(12)
);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_node", "column":"pattern_id", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc", "column":"flw_code", "dataType":"varchar(512)"}}$$);
