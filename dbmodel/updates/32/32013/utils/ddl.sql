/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2019/05/24
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_csv2pg_cat", "column":"orderby", "dataType":"integer"}}$$);

-- 2019/05/27
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_cat_param_user", "column":"editability", "dataType":"json"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_cat_period", "column":"period_type", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_hydrometer_x_data", "column":"pattern_id", "dataType":"varchar(16)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_typevalue", "column":"addparam", "dataType":"json"}}$$);


CREATE TABLE ext_hydrometer_category_x_pattern(
  category_id character varying(16) PRIMARY KEY,
  period_type integer NOT NULL,
  pattern_id character varying(16) NOT NULL,
  observ text
);


CREATE TABLE ext_cat_period_type(
  id serial PRIMARY KEY,
  idval character varying(16) NOT NULL,
  descript text
);


ALTER TABLE polygon ALTER COLUMN pol_id SET DEFAULT nextval('SCHEMA_NAME.urn_id_seq'::regclass);

