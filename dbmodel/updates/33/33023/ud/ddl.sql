/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/01/10
CREATE TABLE rpt_control_actions_taken(
  id serial,
  result_id character varying(30) NOT NULL,
  text character varying(255),
  CONSTRAINT rpt_control_actions_taken_pkey PRIMARY KEY (id),
  CONSTRAINT rpt_control_actions_taken_result_id_fkey FOREIGN KEY (result_id)
      REFERENCES rpt_cat_result (result_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);