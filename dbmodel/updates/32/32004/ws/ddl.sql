/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE SEQUENCE inp_energy_gl_id_seq
  INCREMENT 1
  NO MINVALUE 
  NO MAXVALUE
  START 1
   CACHE 1;

CREATE SEQUENCE inp_energy_el_id_seq
  INCREMENT 1
  NO MINVALUE 
  NO MAXVALUE
  START 1
   CACHE 1;

CREATE SEQUENCE inp_reactions_gl_id_seq
  INCREMENT 1
  NO MINVALUE 
  NO MAXVALUE
  START 1
   CACHE 1;

CREATE SEQUENCE inp_reactions_el_id_seq
  INCREMENT 1
  NO MINVALUE 
  NO MAXVALUE
  START 1
   CACHE 1;

ALTER TABLE inp_energy_gl ALTER COLUMN id SET DEFAULT nextval('SCHEMA_NAME.inp_energy_gl_id_seq'::regclass);
ALTER TABLE inp_energy_el ALTER COLUMN id SET DEFAULT nextval('SCHEMA_NAME.inp_energy_el_id_seq'::regclass);
ALTER TABLE inp_reactions_gl ALTER COLUMN id SET DEFAULT nextval('SCHEMA_NAME.inp_reactions_gl_id_seq'::regclass);
ALTER TABLE inp_reactions_el ALTER COLUMN id SET DEFAULT nextval('SCHEMA_NAME.inp_reactions_el_id_seq'::regclass);


ALTER TABLE inp_pattern_value ALTER COLUMN _factor_19 DROP DEFAULT;
ALTER TABLE inp_pattern_value ALTER COLUMN _factor_20 DROP DEFAULT;
ALTER TABLE inp_pattern_value ALTER COLUMN _factor_21 DROP DEFAULT;
ALTER TABLE inp_pattern_value ALTER COLUMN _factor_22 DROP DEFAULT;
ALTER TABLE inp_pattern_value ALTER COLUMN _factor_23 DROP DEFAULT;
ALTER TABLE inp_pattern_value ALTER COLUMN _factor_24 DROP DEFAULT;