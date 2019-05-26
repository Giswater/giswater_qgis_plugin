/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2019/05/24
ALTER TABLE sys_csv2pg_cat ADD COLUMN orderby integer;

-- 2019/05/27
ALTER TABLE audit_cat_param_user ADD COLUMN editability json;
ALTER TABLE config_api_form_fields ADD COLUMN editability json;



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

ALTER TABLE ext_cat_period ADD column period_type integer;
