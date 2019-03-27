/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "utils", public, pg_catalog;


CREATE SEQUENCE streetaxis_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 20000
  CACHE 1;
GRANT ALL ON SEQUENCE streetaxis_id_seq TO role_edit;


CREATE SEQUENCE plot_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1000000
  CACHE 1;
GRANT ALL ON SEQUENCE plot_id_seq TO role_edit;


CREATE SEQUENCE address_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 50000
  CACHE 1;
GRANT ALL ON SEQUENCE address_id_seq TO role_edit;


ALTER TABLE streetaxis ALTER COLUMN id SET DEFAULT nextval('utils.streetaxis_id_seq'::regclass);
ALTER TABLE plot ALTER COLUMN id SET DEFAULT nextval('utils.plot_id_seq'::regclass);
ALTER TABLE address ALTER COLUMN id SET DEFAULT nextval('utils.address_id_seq'::regclass);