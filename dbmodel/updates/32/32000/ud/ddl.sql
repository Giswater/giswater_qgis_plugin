/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



ALTER TABLE IF EXISTS inp_evaporation RENAME TO _inp_evaporation_;
CREATE TABLE inp_evaporation(
  evap_type character varying(16) NOT NULL PRIMARY KEY,
  value text);


ALTER TABLE IF EXISTS inp_temperature RENAME TO _inp_temperature_;
  CREATE TABLE inp_temperature(
  id serial NOT NULL PRIMARY KEY,
  temp_type character varying(60),
  value text
);


ALTER TABLE IF EXISTS inp_pattern RENAME TO _inp_pattern_;
CREATE TABLE inp_pattern(
  pattern_id character varying(16) NOT NULL PRIMARY KEY,
  pattern_type character varying(30),
  observ text
);


ALTER TABLE IF EXISTS inp_pattern_value RENAME TO _inp_pattern_value_;
CREATE TABLE inp_pattern_value(
  id serial NOT NULL PRIMARY KEY,
  pattern_id character varying(16),
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
  factor_19 numeric(12,4),
  factor_20 numeric(12,4),
  factor_21 numeric(12,4),
  factor_22 numeric(12,4),
  factor_23 numeric(12,4),
  factor_24 numeric(12,4)
);


ALTER TABLE IF EXISTS inp_hydrograph RENAME TO _inp_hydrograph_;
CREATE TABLE inp_hydrograph(
  hydro_id integer PRIMARY KEY NOT NULL DEFAULT nextval('inp_hydrograph_seq'::regclass),
  text character varying(254));

  /*

ALTER TABLE IF EXISTS inp_lid_control RENAME TO _inp_lid_control;
CREATE TABLE inp_lid_control(
  id integer PRIMARY KEY NOT NULL DEFAULT nextval('SCHEMA_NAME.inp_lid_control_seq'::regclass),
  lidco_id character varying(16),
  lidco_type character varying(16), --changed length of the field
  value_2 numeric(12,4),
  value_3 numeric(12,4),
  value_4 numeric(12,4),
  value_5 numeric(12,4),
  value_6 numeric(12,4),
  value_7 numeric(12,4),
  value_8 numeric(12,4));

*/

ALTER TABLE inp_inflows  RENAME TO _inp_inflows_;

CREATE TABLE inp_inflows
(
  id integer NOT NULL DEFAULT nextval('SCHEMA_NAME.inp_inflows_seq'::regclass),
  node_id character varying(50),
  timser_id character varying(16),
  format_type text,
  mfactor numeric (12,4),
  sfactor numeric(12,4),
  base numeric(12,4),
  pattern_id character varying(16),
  CONSTRAINT inp_inflows_pkey2 PRIMARY KEY (id)
);


ALTER TABLE inp_snowpack RENAME TO _inp_snowpack_;

CREATE TABLE inp_snowpack
( id serial PRIMARY KEY,
  snow_id character varying(16) NOT NULL,
  snow_type character varying(16),
  value_1 numeric(12,3),
  value_2 numeric(12,3),
  value_3 numeric(12,3),
  value_4 numeric(12,3),
  value_5 numeric(12,3),
  value_6 numeric(12,3),
  value_7 numeric(12,3)
);

CREATE TABLE inp_snowpack_id(
  snow_id character varying(16) NOT NULL PRIMARY KEY,
  observ text
);