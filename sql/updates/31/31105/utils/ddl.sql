/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2018/10/27
ALTER TABLE om_visit_parameter ADD COLUMN ismultifeature boolean;
UPDATE om_visit_parameter SET ismultifeature=true WHERE form_type='event_standard';

DROP RULE IF EXISTS insert_plan_arc_x_pavement ON arc;
CREATE OR REPLACE RULE insert_plan_arc_x_pavement AS ON INSERT TO arc DO  
INSERT INTO plan_arc_x_pavement (arc_id, pavcat_id, percent) 
VALUES (new.arc_id,  (SELECT value FROM config_param_user WHERE parameter='pavementcat_vdefault' and cur_user="current_user"()LIMIT 1), '1'::numeric);

-- 2018/10/29
ALTER TABLE node_type ADD COLUMN isarcdivide boolean DEFAULT TRUE;


-- 2018/11/11
CREATE TABLE dattrib(
  dattrib_type integer,
  feature_id character varying(30),
  feature_type varchar(30),
  idval text,
  CONSTRAINT dattrib_pkey PRIMARY KEY (dattrib_type, feature_id));

  
CREATE TABLE dattrib_type(
  id INTEGER PRIMARY KEY,
  idval varchar(30),
  project_type varchar(30),
  observ text);

ALTER TABLE dattrib ADD CONSTRAINT dattrib_dattrib_type_fkey FOREIGN KEY (dattrib_type)
REFERENCES dattrib_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
