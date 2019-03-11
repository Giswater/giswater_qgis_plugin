/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2019/01/30
ALTER TABLE rpt_inp_arc ADD COLUMN flw_code text;


CREATE TABLE rpt_selector_hourly_compare
( id serial NOT NULL,
  "time" character varying(100) NOT NULL,
  cur_user text NOT NULL,
  CONSTRAINT rpt_selector_result_hourly_compare_pkey PRIMARY KEY (id)
);



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

