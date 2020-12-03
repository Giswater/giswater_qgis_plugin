/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pattern", "column":"pattern_type", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pattern", "column":"tscode", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pattern", "column":"tsparameters", "dataType":"json"}}$$);



CREATE TABLE rpt_inp_pattern_value
( id serial PRIMARY KEY,
  result_id character varying(16) NOT NULL,
  dma_id integer,
  pattern_id character varying(16) NOT NULL,
  idrow integer,
  factor_1 numeric(12,4),
  factor_2 numeric(12,4),
  factor_3 numeric(12,4),
  factor_4 numeric(12,4),
  factor_5 numeric(12,4),
  factor_6 numeric(12,4),
  factor_7 numeric(12,4),
  factor_8 numeric(12,4),
  factor_9 numeric(12,4),
  factor_10 numeric(12,4),
  factor_11 numeric(12,4),
  factor_12 numeric(12,4),
  factor_13 numeric(12,4),
  factor_14 numeric(12,4),
  factor_15 numeric(12,4),
  factor_16 numeric(12,4),
  factor_17 numeric(12,4),
  factor_18 numeric(12,4),
  user_name text DEFAULT current_user);