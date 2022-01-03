/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE TABLE sys_table
(
  id text NOT NULL,
  descript text,
  sys_role character varying(30),
  sys_criticity smallint,
  qgis_toc character varying(30),
  qgis_criticity smallint,
  qgis_message text,
  sys_sequence text,
  sys_sequence_field text,
  notify_action json,
  isaudit boolean,
  keepauditdays integer,
  source text,
  CONSTRAINT sys_table_pkey PRIMARY KEY (id)
);
