/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2019/04/20
CREATE TABLE cat_dwf_scenario (
  id serial PRIMARY KEY,
  idval character varying(30),
  startdate timestamp,
  enddate timestamp,
  observ text);

ALTER TABLE inp_dwf ADD COLUMN dwfscenario_id integer;

ALTER TABLE inp_dwf_pol_x_node ADD COLUMN dwfscenario_id integer;


CREATE TABLE inp_controls_importinp(
  id serial NOT NULL,
  text text);

