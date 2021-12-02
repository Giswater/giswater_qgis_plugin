/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/02
CREATE TABLE temp_data(
  id serial PRIMARY KEY,
  fid smallint,
  feature_type character varying(16),
  feature_id character varying(16),
  enabled boolean,
  log_message text,
  tstamp timestamp without time zone DEFAULT now(),
  cur_user text DEFAULT "current_user"(),
  addparam json);